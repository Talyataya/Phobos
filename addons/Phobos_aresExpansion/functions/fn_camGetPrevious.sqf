//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Gets previous camera.
// Changelog: None.
// Notes: 
//
//////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\includes\cinematics.inc"

private _cutsceneName = _this select 0;
private _camID = _this select 1;

private _previousCam = [_cutsceneName, -1];
for [{_i = _camID - 1}, {_i >= MIN_CAMERA_WAYPOINT}, {_i = _i - 1}] do {
	_previousCamIndexExists = [_cutsceneName, _i] call Phobos_fnc_camExists;
	if (_previousCamIndexExists) exitWith {
		_previousCam = [_cutsceneName, _i];						
		[format ["Previous cam: %1", str _previousCam]] call Phobos_fnc_logMessage;
	};
};
_previousCam;