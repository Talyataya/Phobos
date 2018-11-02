//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Sets camera properties of chosen camera.
// Changelog: 
//		v1.1: 
//			 *Enhanced: Now handles all Event Handler related objectives.
// Notes: 
//		Important: Object related parameters come as objects and being assigned a variable, after that the assigned variables are stored in string form for code generator compatibility.
//		*TODO: Some cleaning required, code's logic changed like 10 times.
//		*Bug: Camera target Event Handler setup does not work all the time.(Event handler id returns -1 meaning it is not being created.)
//		*BugUpdate: It only occurs for objects that are targeted by camWaypoint, not by camProperties.
//////////////////////////////////////////////////////////////

private _cutsceneName = _this select 0;
private _camID = _this select 1;
private _camProperties = _this select 2;
_camFullName = format ["%1_%2", _cutsceneName, _camID];

_camExists = missionNamespace getVariable [_camFullName,false];

if (_camExists) then {
	_oldProperties = [_cutsceneName, _camID] call Phobos_fnc_camGetProperties;
	[format ["fn_camSetProperties: _oldProperties: %1", _oldProperties], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	[format ["fn_camSetProperties: _newProperties: %1", _camProperties], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	private ["_oldCamPosition","_oldCamTarget"];
	if (count _oldProperties > 0) then {
		_oldCamPosition = _oldProperties select 0;
		_oldCamTarget = _oldProperties select 1;
	};
	_oldObjectPosition =  missionNamespace getVariable [format ["%1_Position", _camFullName], objNull];
	_oldObjectTarget = missionNamespace getVariable [format ["%1_Target", _camFullName], objNull];
	_oldObjectPositionHandler = missionNamespace getVariable [format ["%1_Position_Handler", _camFullName], -1];
	_oldObjectTargetHandler = missionNamespace getVariable [format ["%1_Target_Handler", _camFullName], -1];
	_camNewPosition = _camProperties select 0; 
	_camNewTarget = _camProperties select 1; 
	
	
	[format ["Modifying properties of %1.", _camFullName]] call Phobos_fnc_logMessage;
	
	//Check if EH modification is required.
	_isSamePositionObject = if ((count _camNewPosition == 2) && {_oldObjectPosition == missionNamespace getVariable [_camNewPosition select 0,objNull]}) then {true} else {false};
	_isSameTargetObject = if ((_camNewTarget isEqualType "") && {_oldObjectTarget == missionNamespace getVariable [_camNewTarget,objNull]}) then {true} else {false};
	
	//QuickFix for same object having player defined variable instead of script assigned variable if variable's object was not changed.
	if (_isSamePositionObject) then {
		//Exclude EH related stuff, just pass the variable.
		_camNewRelPos = _camNewPosition select 1;
		_camProperties set [0, [format ["%1_Position", _camFullName], _camNewRelPos]];
		["Same object for position detected; EH-Process halted, relative position updated.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	};
	if (_isSameTargetObject) then {
		//Exclude EH related stuff, just pass the variable.
		_camProperties set [1, format ["%1_Target", _camFullName]]; 
		["Same object for position detected; EH-Process halted.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	};
	
	//Remove any previously assigned EHs.
	if ((!_isSamePositionObject) && {_oldObjectPositionHandler != -1}) then {
		_oldCamRelObject = _oldObjectPosition;
		_oldCamRelObject removeEventHandler ["Deleted", _oldObjectPositionHandler];
		missionNamespace setVariable [format ["%1_Position", _camFullName], objNull];
		missionNamespace setVariable [format ["%1_Position_Handler", _camFullName], -1];
		[format ["Object: %1 detected as relative , EH removal done for id: %2", _oldCamRelObject, _oldObjectPositionHandler], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	};
	
	if ((!_isSameTargetObject) && {_oldObjectTargetHandler != -1}) then {
		_oldCamTarget = _oldObjectTarget;
		_oldCamTarget removeEventHandler ["Deleted", _oldObjectTargetHandler];
		missionNamespace setVariable [format ["%1_Target", _camFullName], objNull];
		missionNamespace setVariable [format ["%1_Target_Handler", _camFullName], -1];
		[format ["Object: %1 detected as target, EH removal done for id: %2", _oldCamTarget, _oldObjectTargetHandler], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	};
	
	//Place new EHs.
	[format ["Position debug: %1", _camNewPosition]] call Phobos_fnc_logMessage;
	if ((!_isSamePositionObject) && {_camNewPosition isEqualTypeArray ["", [0,0,0]]}) then {
		_camNewPosRelObject = missionNamespace getVariable [(_camNewPosition select 0),objNull];
		_camNewRelPos =  _camNewPosition select 1;
		_positionRelObjEventID = _camNewPosRelObject addEventHandler ["Deleted", format ["
			_target = _this select 0;
			missionNamespace setVariable ['%1',false];
			_positionHandler = missionNamespace getVariable ['%1_Position_Handler', -1];
			_target removeEventHandler ['Deleted', _positionHandler];
			missionNamespace setVariable ['%1_Position', objNull];
			missionNamespace setVariable ['%1_Position_Handler', -1];
			['CamDestroyed', ['%1', 'Pos-relative object has been deleted.']] call BIS_fnc_showNotification; 
			[""%1's position-relative object has been deleted, camera reseted."", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		", _camFullName]];
		missionNamespace setVariable [format ["%1_Position", _camFullName], _camNewPosRelObject]; //For code generator, we need a variable that can't be changed accidentally by player(otherwise EHs would fail), therefore a new variable special to the camera is passed into properties.
		[format ["Before pos modification: %1", _camProperties], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		_camProperties set [0, [format ["%1_Position", _camFullName], _camNewRelPos]]; //Replacing object with its variable name(without forgetting position).
		[format ["After pos modification: %1", _camProperties], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		missionNamespace setVariable [format ["%1_Position_Handler", _camFullName],_positionRelObjEventID];
		[format ["New EH for cam: %1's position-relative object: %2 has been added with id: %3.", _camFullName, _camNewPosRelObject, _positionRelObjEventID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	};

	[format ["Target debug: %1", _camNewTarget], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	if ((!_isSameTargetObject) && {_camNewTarget isEqualType ""}) then {
		_camNewTargetObject = missionNamespace getVariable [_camNewTarget, objNull];
		_targetEventID = _camNewTargetObject addEventHandler ["Deleted", format ["
			_target = _this select 0;
			missionNamespace setVariable ['%1',false];
			_targetHandler = missionNamespace getVariable ['%1_Target_Handler', -1];
			_target removeEventHandler ['Deleted',_targetHandler];
			missionNamespace setVariable ['%1_Target', objNull];
			missionNamespace setVariable ['%1_Target_Handler', -1];
			['CamDestroyed', ['%1', 'Target object has been deleted.']] call BIS_fnc_showNotification;
			[""%1's target object has been deleted, camera reseted."", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		", _camFullName]];
		missionNamespace setVariable [format ["%1_Target", _camFullName], _camNewTargetObject]; //For code generator, we need a variable that can't be changed accidentally by player, therefore a new variable special to the camera is passed into properties.
		_camProperties set [1, format ["%1_Target", _camFullName]];//Replacing object with its variable name.
		missionNamespace setVariable [format ["%1_Target_Handler", _camFullName], _targetEventID];
		[format ["New EH for cam: %1's target object: %2 has been added with id: %3.", _camFullName, _camNewTargetObject, _targetEventID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	};
	
	missionNamespace setVariable [format ["%1_properties", _camFullName], _camProperties];
	[format ["fn_camSetProperties: _finalProperties: %1", _camProperties]] call Phobos_fnc_logMessage;
} else {
	[format ["%1 does not exist. Unable to setProperties for this cam.", _camFullName]] call Phobos_fnc_logMessage;
};