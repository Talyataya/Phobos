//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Creates a code to import a cutscene into Phobos.(For Vanilla A3 code, fn_cutscenePrepare is used.)
// Changelog: None.
// Notes: 
//
//////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\includes\cinematics.inc"
#define ID_ERROR_NO_CAMERA_FOUND -1

private _cutsceneName = _this select 0;
private _output = [];

_cutsceneCams = [];
for [{_i = MIN_CAMERA_WAYPOINT}, {_i < MAX_CAMERA_WAYPOINT}, {_i = _i + 1}] do {
	_camIndexExists = [_cutsceneName, _i] call Phobos_fnc_camExists;
	if (_camIndexExists) then {
		_cutsceneCams pushBack [_cutsceneName, _i];
	};
};

//Just in case some cams were created but got broken due conditions unmet.
if (count _cutsceneCams == 0) exitWith {["No camera available to create a cutscene."] call Phobos_fnc_logMessage; ID_ERROR_NO_CAMERA_FOUND};

//Delete if any cutscene exists.
_output pushback format ["_cutsceneName = %2;%1%1[_cutsceneName] call Phobos_fnc_cutsceneDelete;%1", endl, str _cutsceneName];

{
	private _camID = _x select 1;
	private _camProperties = _x call Phobos_fnc_camGetProperties;
	
	_output pushBack (format ["[_cutsceneName, %2, false, false] call Phobos_fnc_camWaypoint;%1[_cutsceneName, %2, %3] call Phobos_fnc_camSetProperties;%1", endl, _camID, _camProperties]);
} forEach _cutsceneCams;

_output pushback format ["%1[""CutsceneImportSucceeded"", [_cutsceneName]] call BIS_fnc_showNotification;", endl];

private _code = "";
{
	_code = _code + _x;
	[_x, nil, nil, false] call Phobos_fnc_logMessage;
} forEach _output;

_code;