//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Records curator camera position and target(pos or obj) as player bound variables. Usage: [str _cutsceneName, int camId] 
// Changelog: 
//		v1.1: 
//			*Changed: Event Handler related objectives are carried to fn_camSetProperties.
// Notes: 
//		*A cutscene starts from id 1 instead of 0, this is due avoiding confusion with F1-F12 buttons.
//		*Should be spawned unless 3rd parameter is false.(Failure of this condition would cause case:'Object Target' would end up as script error due suspension.)
//		*Deletion of a target after cinematic beginning has not been handled yet.(Needed for future update of this script as player will be able to modify a cutscene during it is playing.)
//		*No camera name with spaces can be handled.(Due creating a variable with spaces is not possible.)
//////////////////////////////////////////////////////////////
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\Phobos_aresExpansion\includes\cinematics.inc"


private ["_position", "_target"];
private _cutsceneName = _this select 0;
private _camID = _this select 1;
private _checkCuratorTargetObject = _this param [2, true]; //If false, can be called instead of spawned. (False to prevent target detection.)
private _doNotifyPlayer = _this param [3, true]; //If false, don't notify.
private _camFullName = format ["%1_%2", _cutsceneName, _camID]; 


if (_camID < MIN_CAMERA_WAYPOINT || _camID > MAX_CAMERA_WAYPOINT) exitWith {
	[format ["Camera creation failed, camera ID must be between %1-%2.", MIN_CAMERA_WAYPOINT, MAX_CAMERA_WAYPOINT]] call Phobos_fnc_logMessage;
	if (_doNotifyPlayer) then {
		["CamCreationFailed", [_camFullName, format ["CamID must be between %1 - %2.", MIN_CAMERA_WAYPOINT, MAX_CAMERA_WAYPOINT]]] call BIS_fnc_showNotification;
	};
};
[format ["Initializing process of creating a camera named: %1", _camFullName]] call Phobos_fnc_logMessage;

//Create a cutscene.(A cutscene is formed up by the cameras made in the name of cutscene.)
_cutsceneCreationResult = [_cutsceneName] call Phobos_fnc_cutsceneAddNew;
if (_cutsceneCreationResult == 2) exitWith {["Invalid cutscene name, aborting camera creation."] call Phobos_fnc_logMessage};

/*
//Check if another camera exists in the same cutscene with same id.
_camExists = [_cutsceneName, _camID] call Phobos_fnc_camExists;
if (_camExists) then {
	["Another camera exists, starting EH Removal process."] call Phobos_fnc_logMessage;
	_oldCamProperties = [_cutsceneName, _camID] call Phobos_fnc_camGetProperties;
	_oldCamPosition = _oldCamProperties select 0;
	_oldCamTarget = _oldCamProperties select 1;
	
	//Delete event handler if position is relative to an object.
	if (_oldCamPosition isEqualTypeArray [objNull, [],0]) then { 
		// [object, [x,y,z], eventHandlerID]
		_relativeObject = _oldCamPosition select 0;
		_eventHandlerID = _oldCamPosition select 2;
		
		_relativeObject removeEventHandler ["Deleted", _eventHandlerID];
		[format ["Object: %1 detected as relative , EH removal done for id: %2", _relativeObject, _eventHandlerID]] call Phobos_fnc_logMessage;
	} else {
		["No relative position detected, passing EH removal process."] call Phobos_fnc_logMessage;
	};
	
	//Delete event handler if target is an object.
	if (_oldCamTarget isEqualTypeArray [objNull, 0]) then {
		// [object, eventHandlerID]
		_target = _oldCamTarget select 0;
		_eventHandlerID = _oldCamTarget select 1;
		
		_target removeEventHandler ["Deleted", _eventHandlerID];
		[format ["Object: %1 detected as target, EH removal done for id: %2", _target, _eventHandlerID]] call Phobos_fnc_logMessage;
	} else {
		["No object bound target was detected, no EH Removal needed."] call Phobos_fnc_logMessage;
	};
} else {
	["Another camera does not exist, passing EH Removal Process."] call Phobos_fnc_logMessage;
};
*/
_position = getPos curatorCamera;
private "_target";
if (_checkCuratorTargetObject) then {
	private _objectsIntersectingCuratorCam = lineIntersectsWith [ATLtoASL (screenToWorld [0.5,0.5]),getPosASL curatorCamera,objNull,objNull,true];
	private _isObjectConditionSatisfied = false;
	if (count _objectsIntersectingCuratorCam > 0) then {
		{
			_curatorObjects = curatorEditableObjects (getAssignedCuratorLogic player);
			_objectIndex = _objectsIntersectingCuratorCam select _forEachIndex;
			_isObjectConditionSatisfied = false;
			if (!_isObjectConditionSatisfied && {_objectIndex in _curatorObjects}) then {
				["An object eligible to become target was detected.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
				//Saving it here to prevent losing while player is deep in mind thinking about his answer by the following gui...
				_target = _objectIndex; //Choose the curator-editable object at the front.
				_isObjectConditionSatisfied = true;
			} else {
				["Non zeus object detected at target location. Passing.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			};
		} forEach _objectsIntersectingCuratorCam;
		if (_isObjectConditionSatisfied) then {
			_result = [format ["Object:'%1' detected at targeted location, lock camera target to object?", _target],_camFullName,true,true, findDisplay IDD_RSCDISPLAYCURATOR] call BIS_fnc_guiMessage;
			if (_result) then {
				//We had already saved vehicle as _target.
				_target = [_target] call BIS_fnc_objectVar;
				//And exchange object with its variable for later use.
				["Detected object was chosen to become target.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			} else {
				_target = screenToWorld [0.5,0.5];
				["Position is chosen as target.(Zeus denied object to become target.)", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			};
		} else {
			_target = screenToWorld [0.5,0.5];
			["Position is chosen as target.(None of the objects were detected as zeus-editable.)", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		};
	} else {
		_target = screenToWorld [0.5,0.5];
		["Position is chosen as target.(No object eligible to become target was detected.)", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	}; 
} else {
	_target = screenToWorld [0.5,0.5];
	["Position is chosen as target.(Object detection was ignored.)", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
};

missionNamespace setVariable [_camFullName, true]; //To check if it exists and ready to go.(ie. Will not be ready if _target is deleted.)

/*
for [{_i = _camID}, {_i > 1}, {_i = _i - 1}] do {
	_previousCamIndexExists = missionNamespace getVariable [format ["%1_%2", _cutsceneName, _i],false];
	if (_previousCamIndexExists) exitWith {
		_previousCamProperties = [_cutsceneName, _i] call Phobos_fnc_camGetProperties;
		[_cutsceneName, _camID, _previousCamProperties] call Phobos_fnc_camSetProperties;
	};
};
*/

//Copy attributes of previous cam, if exists(excluding position, target and dayTime(which will be 'No Change'))
_previousCam = [_cutsceneName, _camID] call Phobos_fnc_camGetPrevious;
if (_previousCam select 1 != -1) then {
	_previousCamProperties = _previousCam call Phobos_fnc_camGetProperties;
	_modifiedCamProperties = [_position,_target];
	_modifiedCamProperties append (_previousCamProperties select [2,15]);
	_modifiedCamProperties set [11, 0]; //Daytime to 'No Change'
	_modifiedCamProperties set [12, -0.01]; //Overcast to 'No Change'
	_modifiedCamProperties set [13, -0.01]; //Rain to 'No Change'
	_modifiedCamProperties set [14, -0.01]; //Fog to 'No Change'
	_modifiedCamProperties set [16, ""]; //Code to nothing.
	[_cutsceneName, _camID, _modifiedCamProperties] call Phobos_fnc_camSetProperties;
} else {
	_defaultProperties = [
		_position,
		_target,
		PROPERTIES_DEFAULT_IS_ATTACHED,
		PROPERTIES_DEFAULT_COMMIT_TIME,
		PROPERTIES_DEFAULT_WAIT_BEFORE_COMMIT,
		PROPERTIES_DEFAULT_FOV,
		PROPERTIES_DEFAULT_FOCUS,
		PROPERTIES_DEFAULT_APERTURE,
		PROPERTIES_DEFAULT_BRIGHTNESS,
		PROPERTIES_DEFAULT_CONTRAST,
		PROPERTIES_DEFAULT_SATURATION,
		PROPERTIES_DEFAULT_DAYTIME,
		PROPERTIES_DEFAULT_OVERCAST,
		PROPERTIES_DEFAULT_RAIN,
		PROPERTIES_DEFAULT_FOG,
		PROPERTIES_DEFAULT_VISION_MODE,
		PROPERTIES_DEFAULT_CODE
	];

	[_cutsceneName, _camID, _defaultProperties] call Phobos_fnc_camSetProperties;
};

_camProperties = [_cutsceneName, _camID] call Phobos_fnc_camGetProperties;
[format ["Camera: %1 created, properties: %2",_camFullName, str _camProperties]] call Phobos_fnc_logMessage;
if (_doNotifyPlayer) then {
	["CamCreationSucceeded",[_camFullName]] call BIS_fnc_showNotification;
};

