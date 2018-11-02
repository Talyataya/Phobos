//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Deletes a cutscene, with its cameras.
// Changelog: None.
//
//////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\includes\cinematics.inc"

private _cutsceneName = _this select 0;

private _cutscenes = missionNamespace getVariable ["Phobos_Cutscenes",[]];
private _cutsceneID = _cutscenes find _cutsceneName;
if (_cutsceneID == -1) exitWith {
	["Cutscene: %1 does not exist. Aborting cutscene deletion process.", _cutsceneName] call Phobos_fnc_logMessage;
};

_cutsceneCams = [];
for [{_i = MIN_CAMERA_WAYPOINT}, {_i < MAX_CAMERA_WAYPOINT}, {_i = _i + 1}] do {
	_camIndexExists = [_cutsceneName, _i] call Phobos_fnc_camExists;
	if (_camIndexExists) then {
		_cutsceneCams pushBack [_cutsceneName, _i];
	};
};

//Delete every single camera.
{
	_x call Phobos_fnc_camDelete;
} forEach _cutsceneCams;

//Update cutscenes list.
_cutscenes deleteAt _cutsceneID;
missionNamespace setVariable ["Phobos_Cutscenes",_cutscenes];


