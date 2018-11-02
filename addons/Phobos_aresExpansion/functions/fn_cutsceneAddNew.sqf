//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Adds a new cutscene to the cutscenes array. Returns a number based on success of creation(#Defines).
// Changelog: None.
// Notes: 
//
/////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\includes\cinematics.inc"

_cutsceneName = _this select 0;

private "_creationResult";
private _cutsceneName = [_cutsceneName, " ", "_"] call Phobos_fnc_strReplace;
private _isNameEligible = [_cutsceneName] call Phobos_fnc_isVariableEligible;

if (!_isNameEligible) exitWith {[format ["Inappropriate name detected, aborting cutscene creation: %1", _cutsceneName]] call Phobos_fnc_logMessage; ID_CREATION_FAILED_INAPPROPRIATE_NAME;};

private _cutscenes = missionNamespace getVariable ["Phobos_Cutscenes",[]];
private _comparedCutscenes = []; //Another array to prevent names from being lowered.
{
	_comparedCutscenes set [_forEachIndex, toLower _x]; 
} forEach _cutscenes;

if (!((toLower _cutsceneName) in _comparedCutscenes)) then {
	_cutscenes pushBack _cutsceneName;
	missionNamespace setVariable ["Phobos_Cutscenes", _cutscenes];
	[format ["A new cutscene has been created: %1", _cutsceneName]] call Phobos_fnc_logMessage;
	_creationResult = ID_CREATION_SUCCESFUL;
} else {
	[format ["Existing cutscene detected, aborting cutscene creation: %1", _cutsceneName]] call Phobos_fnc_logMessage;
	_creationResult = ID_CREATION_FAILED_ALREADY_EXISTS;
};
_creationResult;

