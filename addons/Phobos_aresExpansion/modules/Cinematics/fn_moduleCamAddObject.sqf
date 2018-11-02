//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Module to add a position or target object to a camera.(Module)
// Changelog: None
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"
#include "\Phobos_aresExpansion\includes\cinematics.inc"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

if (isNull _unitUnderCursor) exitWith {["Module needs to be dropped on an object."] call Ares_fnc_ShowZeusMessage;};


["User initialized the camera object addition module."] call Phobos_fnc_logMessage;
private _allCutscenes = [] call Phobos_fnc_cutsceneGetAll;
if (count _allCutscenes <= 0) exitWith {
	["No cutscene in cutscene list was found. Create a cutscene first."] call Ares_fnc_showZeusMessage;
	["No cutscene in cutscene list was found. Aborting module process."] call Phobos_fnc_logMessage;
};

_chatResult =
[
	"Add Camera-Related Object",
	[
		["Cutscene Name: ", _allCutscenes],
		["Camera ID: ", ""],
		["Object type: ", ["Position", "Target"]]
	]
] call Phobos_fnc_showChooseDialog;

if (count _chatResult == 0) exitWith {["User aborted the camera creation module."] call Phobos_fnc_logMessage;};

private _cutsceneName = _allCutscenes select (_chatResult select 0);
private _camID =  parseNumber (_chatResult select 1);
private _camFullName = format ["%1_%2", _cutsceneName, _camID];
private _isPosition = if (_chatResult select 2 == 0) then {true} else {false};

private "_relativePosition";
if (_isPosition) then {
	_subChatResult = 
	[
		"Add Position-Related Object",
		[
			["Relative Position: ", "[0,0,0]"]
		]
	] call Phobos_fnc_showChooseDialog;
	
	if (count _subChatResult == 0) exitWith {["User aborted the camera object addition module."] call Phobos_fnc_logMessage;};
	
	_input = _subChatResult select 0;
	if ((_input select [0,1]) == "[" && (_input select [((count _input) - 1),1]) == "]") then {
		_input = parseSimpleArray _input;
		if (count _input == 3) then {
			_relativePosition = _input;
		} else {
			_relativePosition = [0,0,0];
			["User entered wrong size of array value for Relative Position. Value has been set to default."] call Phobos_fnc_logMessage;
		}
	} else {
		_relativePosition = [0,0,0];
		["User entered empty or illegal format of value for Relative Position. Value has been set to default."] call Phobos_fnc_logMessage;
	};
} else {
	/*
	This part is for next update.
	_subChatResult = [
		"Add Target-Related Object",
		[
			["Relative Position: ", "[0,0,0]"]
		]
	] call Phobos_fnc_showChooseDialog;
	*/
};

//if (count _subChatResult == 0) exitWith {["User aborted the camera object addition module."] call Phobos_fnc_logMessage;};

private _camProperties = [_cutsceneName, _camID] call Phobos_fnc_camGetProperties;
private _unitStr = [_unitUnderCursor] call BIS_fnc_objectVar; //We need to give a string to the fn_camSetProperties.
if (_isPosition) then {
	_camProperties set [0, [_unitStr, _relativePosition]];
} else {
	_camProperties set [1, _unitStr];
};

[_cutsceneName, _camID, _camProperties] call Phobos_fnc_camSetProperties;
["CamModificationSucceeded", [_camFullName]] call BIS_fnc_showNotification;

#include "\Phobos_aresExpansion\module_footer.hpp"


