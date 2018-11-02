//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Deletes an existing camera.
// Changelog: None.
// Notes:
//		*TODO: Some logging.
//////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\includes\cinematics.inc"

private _cutsceneName = _this select 0;
private _camID = _this select 1;
private _camFullName = format ["%1_%2", _cutsceneName, _camID];

_camExists = [_cutsceneName, _camID] call Phobos_fnc_camExists;
if (!_camExists) exitWith {[format ["Camera deletion failed, %1 does not exist.", _camFullName]] call Phobos_fnc_logMessage};

[format ["Initializing process of deleting the camera named: %1", _camFullName]] call Phobos_fnc_logMessage;

//Denounce existence of cam.
missionNamespace setVariable [_camFullName, false];


//Remove EHs from associated assets.
_positionObject = missionNamespace getVariable [format ['%1_Position' , _camFullName], objNull];
_positionHandler = missionNamespace getVariable [format ['%1_Position_Handler', _camFullName], -1];

if (!isNull _positionObject && _positionHandler > -1) then {
	_positionObject removeEventHandler ["Deleted", _positionHandler];
};


_targetObject = missionNamespace getVariable [format ['%1_Target', _camFullName], objNull];
_targetHandler = missionNamespace getVariable [format ['%1_Target_Handler', _camFullName], -1];

if (!isNull _positionObject && _targetHandler > -1) then {
	_targetObject removeEventHandler ["Deleted", _targetHandler];
};


//Delete all data of camera.
missionNamespace setVariable [format ["%1_properties", _camFullName], nil];

missionNamespace setVariable [format ['%1_Position' , _camFullName], nil];
missionNamespace setVariable [format ['%1_Position_Handler', _camFullName], nil];

missionNamespace setVariable [format ['%1_Target', _camFullName], nil];
missionNamespace setVariable [format ['%1_Target_Handler', _camFullName], nil];

[format ["Camera: %1, has been successfully deleted.", _camFullName]] call Phobos_fnc_logMessage;
