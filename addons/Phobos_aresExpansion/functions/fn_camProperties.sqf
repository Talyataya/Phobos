//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Displays additional properties for cams created by Phobos_fnc_camWaypoint.
// Changelog: 
//		v1.1: 
//			*Changed: Event Handler related objectives are carried to fn_camSetProperties.
// Notes:
//		*Skiptime after setdate (which is required to set seconds) is not working as skipTime works before setDate is completed, which results in overwriting date.
//		*TODO (Removed Feature): Fix seconds by solving the top issue, will need to switch entire system to skipTime if there is no way to calculate setDate exec time.
//		*TODO: Some cleaning required, code's logic changed like 10 times.
// 		*bank and dive angles are not supported yet.(They don't work for an unknown reason)
// 		*UPDATE: camSetBank and camSetPitch are not usable, yet fn_setPitchBank is only making a change for a second then goes back to previous view, potentially being blocked by camSetTarget.
//		*UPDATE2: Angle features are on halt since new cutscene creation came out after development of this cutscene system(Thanks BI -.-).
//		*TODO (Removed Feature): (Server) Check if a cutscene is being played by some players that has modified daytime, and block the time change for them.
//		*TODO: Phobos_fnc_camProperties_cam and Phobos_fnc_camProperties_position are causing attached camera to return error. Does not affect anything, just logs error due while lasts longer than variable cleaning. [Bug: Low Priority]
//
//////////////////////////////////////////////////////////////

// Define some constants for us to use for additional button.
#define GUI_GRID_X		(0)
#define GUI_GRID_W		(0.025)
#define DELAY_DAYTIME_EXECUTION 1.0 //Time(in seconds) to delay daytime execution to prevent player noticing GUI shutter. In return, daytime is being executed way later.

private _cutsceneName = _this select 0;
private _camID = _this select 1;
private _camFullName = format ["%1_%2", _cutsceneName, _camID];

//Check if same dialog is opened already.
//if (missionNamespace getVariable ["Phobos_fnc_chooseDialog_isActive", false]) exitWith {["Unable to open properties, dialog is already active."] call Phobos_fnc_logMessage;};

//Check if camera of the requested properties is available.(Created and related objects are not deleted, rendering it unusable.)
if (!(missionNamespace getVariable [_camFullName,false])) exitWith {[format ["Camera: %1 not created, unable to access properties.", _camFullName]] call Phobos_fnc_logMessage;};
	
_camProperties = [_cutsceneName, _camID] call Phobos_fnc_camGetProperties;

_camPosition = _camProperties select 0;
_camTarget = _camProperties select 1;
_camIsAttached = _camProperties select 2;
_camCommitTime = _camProperties select 3;
_camWaitBeforeCommit = _camProperties select 4;
_camFov = _camProperties select 5;
_camFocus = _camProperties select 6;
_camAperture = _camProperties select 7;
_camBrightness = _camProperties select 8;
_camContrast = _camProperties select 9;
_camSaturation = _camProperties select 10;
_camDayTime = _camProperties select 11;
_camOvercast = _camProperties select 12;
_camRain = _camProperties select 13;
_camFog = _camProperties select 14;
_camVisionMode = _camProperties select 15;
_camCode = _camProperties select 16;

////////////////////////////////////////
//Tooltips

//Position
_tooltip01 = 
"Position of Camera." + endl + 
"-Position: [x,y,z] or" + endl + 
"-Position relative to object: [object, [x,y,z]]" + endl +
"-Position convertion to relative position: object" + endl +
"-Empty: No change in position.";

_tooltip02 = 
"For automatic conversion from position to relative position," + endl + 
"only write object name and relative position will be calculated" + endl +
"based on current position." + endl +
"*Relative Position will turn attach option to true.";

//Target
_tooltip11 = 
"Target of camera." + endl +
"-Position: [x,y,z] or" + endl +
"-Object: object";

//Attach?
_tooltip21 = 
"Should camera follow relative object declared in Position?" + endl +
"*Requires a relative object to work.";

//Commit
_tooltip31 = 
"Time spent till next camera position." + endl +
"-Time: number(in seconds)";

//Sleep before commit
_tooltip41 =
"Time spent stationary before starting to move." + endl +
"-Time: number(in seconds)";

//FoV
_tooltip51 = 
"Field of View." + endl +
"*Default FoV of a curator is 0.7." + endl +
"*Lower it to zoom in," + endl +
"*Rise it to zoom out.";

//Focus
_tooltip61 = 
"Blur setting, does not apply for players with blur disabled.";

//Aperture
_tooltip71 = 
"Light gained by camera." + endl +
"The lesser, the brighter" + endl +
"The higher, the darker" + endl + 
"*Warning: Causes instant change, regardless of commit time.";

_tooltip72 = 
"Aperture has a sudden change, regardless what commit times are," + endl + 
"therefore its suggested to use only at where light change would occur.";

//Brightness
_tooltip81 = "Light reflection.";

//Contrast
_tooltip91 = "";

//Saturation 
_tooltipA1 = "Color density.";

//Daytime
_tooltipB1 = 
"During 'No Change', simulated time will be the same as" + endl +
"last camera that changes time.";

//Overcast
_tooltipC1= "";

//Vision Mode
_tooltipF1= "Vision Mode such as Night or Thermal Vision etc.";

//Code
_tooltipG1= "Code to execute upon camera initialized.";

////////////////////////////////////////
//Codes

_codeOnLoad = {
	//Declare that a new camera instance has been created.(Used for camera transitions on unload.)
	Phobos_fnc_camProperties_newInstanceCreated = true;

	//Save all data related to curator camera.
	Phobos_fnc_camProperties_curatorCam = curatorCamera;
	Phobos_fnc_camProperties_curatorCamPosition = position curatorCamera;
	Phobos_fnc_camProperties_curatorCamTarget = screenToWorld [0.5,0.5];

	_cam = "camera" camCreate (position curatorCamera);
	Phobos_fnc_camProperties_cam = _cam;
	Phobos_fnc_camProperties_position = _camPosition;
	//Phobos_fnc_camProperties_target = _camTarget;
	//Phobos_fnc_camProperties_fov = _camFov;
	//Phobos_fnc_camProperties_focus = _camFocus;
	//Phobos_fnc_camProperties_aperture = _camAperture;
	Phobos_fnc_camProperties_brightness = _camBrightness;
	Phobos_fnc_camProperties_contrast = _camContrast;
	Phobos_fnc_camProperties_saturation = _camSaturation;
	Phobos_fnc_camProperties_dayTime = _camDayTime;
	//Phobos_fnc_camProperties_overcast = _camOvercast;
	//Phobos_fnc_camProperties_visionMode = _camVisionMode;
	
	//Setup our new camera to travel from curatorCamera to cutscene camera.
	if (count _camPosition == 2) then { //Object syntax
		
		if (/*_camIsAttached*/ true) then { //Technically, it should act like it is attached as that position will be the actual one no matter what, considering it is a preview.
			//Here comes our shakeless camera + smooth transition solution.
			[_camPosition] spawn {
				_positionValue = _this select 0;
				_relObject = missionNamespace getVariable [_positionValue select 0, objNull];
				_relPosition = _positionValue select 1;
				_timeStart = diag_tickTime;

				//Till another value is entered by player or dialog is closed...
				while {(missionNamespace getVariable ['Phobos_fnc_chooseDialog_isActive', false]) && {_positionValue isEqualTo Phobos_fnc_camProperties_position}} do {
					_posX = ((position _relObject) select 0) + (_relPosition select 0);
					_posY = ((position _relObject) select 1) + (_relPosition select 1);
					_posZ = ((position _relObject) select 2) + (_relPosition select 2);
					_finalPos = [_posX, _posY, _posZ];
					//...update the camera position in desired intervals(no interval currently as performance looks fine?)
					_timeStop = diag_tickTime;
					_timeDifference = _timeStop - _timeStart;
					_dynamicCommitTime = (1 - _timeDifference);
					//Set the final position calculated from object's current position + relative position.
					if (isNil "Phobos_fnc_camProperties_cam") exitWith {}; //Camera destroyed, halt the simulation.
					Phobos_fnc_camProperties_cam camSetPos _finalPos;
					if (_dynamicCommitTime > 0.1) then {
						Phobos_fnc_camProperties_cam camCommit _dynamicCommitTime;
					} else {
						Phobos_fnc_camProperties_cam camCommit 0.1;
					};
				};
			};
		} else {
			/*
			_posX = ((position _relObject) select 0) + (_relPosition select 0);
			_posY = ((position _relObject) select 1) + (_relPosition select 1);
			_posZ = ((position _relObject) select 2) + (_relPosition select 2);
			_cam camSetPos [_posX, _posY, _posZ];
			*/
		};
	} else {
		_cam camSetPos _camPosition;
	};
	
	//Simulate initial targeting.
	if (_camTarget isEqualType []) then {
		_cam camSetTarget _camTarget;
	} else {
		_targetObject = missionNamespace getVariable [_camTarget, objNull];
		_cam camSetTarget _targetObject;
	};
	
	//Simulate initial Field of View.
	_cam camSetFov _camFov;
	
	//Simulate initial Focus.
	if (_camFocus == 0) then {
		_cam camSetFocus [-1,1];
	} else {
		_cam camSetFocus [_camFocus,1];
	};
	
	//Simulate initial Post-Process Effects.
	Phobos_fnc_camProperties_ppColor = ppEffectCreate ["colorCorrections", 2999];
	Phobos_fnc_camProperties_ppColor ppEffectEnable true;
	Phobos_fnc_camProperties_ppColor ppEffectAdjust [1,_camBrightness,_camContrast,[1,1,1,0],[1,1,1,_camSaturation],[0.75,0.25,0,1]];
	
	_cam cameraEffect ["Internal", "Back"];
	_cam camCommit 1;
	Phobos_fnc_camProperties_ppColor ppEffectCommit 1;
	if (_camAperture == 0) then {
		setAperture -1;
	} else {
		setAperture _camAperture;
	};
	
	//Simulate visionMode AFTER daytime change.(Commented areas are for feature removed.)
	[_camVisionMode] call /*spawn*/ {
		_camVisionMode = _this select 0;
		//waitUntil {missionNamespace getVariable ['Phobos_fnc_camProperties_initVisionModeChange', false]};
		//missionNamespace setVariable ['Phobos_fnc_camProperties_initVisionModeChange', false];
		["Initializing vision mode simulation.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		switch (_camVisionMode) do {
			case 0: {camUseNVG false; false setCamUseTI 0;};
			case 1: {camUseNVG true; false setCamUseTI 0;};
			case 2; case 3; case 4; case 5; case 6; case 7; case 8;
			case 9: {camUseNVG false; true setCamUseTI (_camVisionMode - 2);};
		};
	};
	
	//Create an extra button for camera deletion.
	disableSerialization;
	_display = _this select 0;
	_deleteButton = _display ctrlCreate ["RscButtonMenuCancel", 8996];
	//Retrieve CANCEL Button's properties to use for DELETE button.
	_cancelButton = _display displayCtrl 8998;
	_cancelButtonPosition = ctrlPosition _cancelButton;
	_deleteButton ctrlSetPosition [2 * GUI_GRID_W + GUI_GRID_X, _cancelButtonPosition select 1, _cancelButtonPosition select 2, _cancelButtonPosition select 3];
	_deleteButton ctrlSetText "DELETE";
	_deleteButton ctrlCommit 0;
	//TODO: Add confirmation for deleting OR would it be annoying?
	_deleteButton ctrlSetEventHandler ["ButtonClick", format ["
		['CamDeleted', [%3]] call BIS_fnc_showNotification;
		[%1,%2] call Phobos_fnc_camDelete;
		closeDialog 2;
	", str _cutsceneName, _camID, str _camFullName]];
	
	//Activate time consuming simulation changes in choice script.(Removed Feature.)
	/*
	[_deleteButton, _cancelButtonPosition] spawn {
		private _deleteButton = _this select 0;
		private _cancelButtonPosition = _this select 1;
		//When a code related to GUI is executed, it doesn't mean that the GUI is updated at the very moment(including commit). So despite ctrlCommit is done, it still takes some time for our gui to be built as there are a lot of stuff in queue. So we are waiting till it is done and meanwhile we're checking the position of our delete button. Once we got confirmation of our last button passes to its position, we go for our heavy code. 
		waitUntil {(ctrlPosition _deleteButton) isEqualTo [2 * GUI_GRID_W + GUI_GRID_X, _cancelButtonPosition select 1, _cancelButtonPosition select 2, _cancelButtonPosition select 3]};
		missionNamespace setVariable ["Phobos_fnc_camProperties_initDayTimeChange", true];
		
	};
	*/
};

_codeOnUnload = {
	Phobos_fnc_camProperties_newInstanceCreated = false;


	//Travel smoothly back to curatorCamera.
	Phobos_fnc_camProperties_cam camSetPos Phobos_fnc_camProperties_curatorCamPosition;
	Phobos_fnc_camProperties_cam camSetTarget Phobos_fnc_camProperties_curatorCamTarget;
	Phobos_fnc_camProperties_cam camSetFov 0.7;
	Phobos_fnc_camProperties_cam camSetFocus [-1,1];
	//TODO: Retrieve actual ppEffect used.(Maybe mediterranean effect is used or such) (Update1: No way to retrieve active ppEffect.)
	Phobos_fnc_camProperties_ppColor ppEffectAdjust [1,1,0,[1,1,1,0],[1,1,1,1],[0.75,0.25,0,1]]; //Default pp.
	setAperture -1;
	
	//Leave no evidence.
	Phobos_fnc_camProperties_position = nil;
	//Phobos_fnc_camProperties_target = nil;
	//Phobos_fnc_camProperties_fov = nil;
	//Phobos_fnc_camProperties_focus = nil;
	//Phobos_fnc_camProperties_aperture = nil;
	Phobos_fnc_camProperties_brightness = nil;
	Phobos_fnc_camProperties_contrast = nil;
	Phobos_fnc_camProperties_saturation = nil;
	//Phobos_fnc_camProperties_overcast = nil;
	
	Phobos_fnc_camProperties_cam camCommit 1;
	Phobos_fnc_camProperties_ppColor ppEffectCommit 1;
	
	//If server, set daytime to actual daytime. (Removed Feature.)
	/*
	if (isServer && {missionnamespace getVariable ["Phobos_fnc_camProperties_isTimeSimulatedByHost",false]}) then {
		_elapsedMin = floor (Phobos_fnc_camProperties_elapsedTimeSinceSimStarted / 60);
		_elapsedSec = floor (Phobos_fnc_camProperties_elapsedTimeSinceSimStarted mod 60);
		setDate ((Phobos_fnc_camProperties_actualDate select [0,4]) + [(Phobos_fnc_camProperties_actualDate select 4) + (_elapsedMin * Phobos_fnc_camProperties_timeMultiplier)]);
		skipTime ((Phobos_fnc_camProperties_dayTime_actualSecond + (_elapsedSec * Phobos_fnc_camProperties_timeMultiplier)) / 3600); //TODO: Fix ineffective line, gets overwritten by setDate. Affects seconds.
		
		setTimeMultiplier Phobos_fnc_camProperties_timeMultiplier;
		
		Phobos_fnc_camProperties_actualDayTime = nil;
		Phobos_fnc_camProperties_timeMultiplier = nil;
		Phobos_fnc_camProperties_dayTime_actualSecond = nil;
		Phobos_fnc_camProperties_isTimeSimulatedByHost = false;
		//publicVariable "Phobos_fnc_camProperties_isTimeSimulatedByHost";
		//The variable below insists on not becoming false on remote clients, but for some reason, in while it succeeds in one attempt...
		[[], {_i = 0; while {Phobos_fnc_camProperties_isTimeSimulatedByHost} do {systemChat format ["Attempting to disable variable Phobos_fnc_camProperties_isTimeSimulatedByHost (%1)", _i]; _i = _i + 1; Phobos_fnc_camProperties_isTimeSimulatedByHost = false;}}] remoteExecCall ["spawn", -2];
		//Phobos_fnc_camProperties_elapsedTimeSinceSimStarted = nil; Returns log error(functionally correct) when deleted for some reason. Most likely due while loop cannot be terminated in time.
		
	};
	*/
	//Switch to original vision mode.

	private _curator = (getAssignedCuratorLogic player);
	private _visionModes = _curator call bis_fnc_curatorVisionModes;
	private _visionModeindex = _curator getvariable ["bis_fnc_curatorVisionModes_current",0];
	private _actualVisionMode = _visionModes select _visionModeIndex;
	
	switch (_actualVisionMode) do {
		case -1: {camUseNVG false; false setCamUseTI 0;};
		case -2: {camUseNVG true; false setCamUseTI 0;};
		case 0; case 1; case 2; case 3; case 4; case 5; case 6;
		case 7: {camUseNVG false; true setCamUseTI (_actualVisionMode);};
	};
	
	//Passing global vars to local vars, so in case a new camera property is accessed while another hasn't ended, we will not overwrite which would be overwritten in case of after sleep.
	private _cam = Phobos_fnc_camProperties_cam;
	private _curatorCam = Phobos_fnc_camProperties_curatorCam;
	private _ppColor = Phobos_fnc_camProperties_ppColor;
	
	Phobos_fnc_camProperties_cam = nil;
	Phobos_fnc_camProperties_curatorCam = nil;
	Phobos_fnc_camProperties_curatorCamPosition = nil;
	Phobos_fnc_camProperties_curatorCamTarget = nil;
	Phobos_fnc_camProperties_ppColor = nil;
	
	//Change camera without player notice.
	uiSleep 1;
	//The below condition is to prevent if a new instance was opened despite the previous instance's travel to curatorCam point had not ended. Would cause player to end up in curatorCam instead of new instance's cam.
	//Despite above the variable below is turned to false, it can still be true if a new instance is created as there is 1 second sleep, in such case it will return true by onLoad code.
	if (!Phobos_fnc_camProperties_newInstanceCreated) then {
		_curatorCam cameraEffect ["Internal","Back"];
	};
	
	camDestroy _cam;
	ppEffectDestroy _ppColor;
};

_code01 = {
	_choiceIndex = _this select 0;
	_ctrlText = _this select 1;
	_ctrlEdit = _this select 2;
	_ctrlInput = ctrlText _ctrlEdit;
	_strStart = _ctrlInput select [0,1];
	_strEnd = _ctrlInput select [((count _ctrlInput) - 1),1];
	if ((_strStart isEqualto '[') && (_strEnd isEqualTo ']')) then { //Just in case.
		_ctrlModifiedInput = [_ctrlInput, toString [32], toString [0]] call Phobos_fnc_strReplace; //Unlikely, but just in case.
		_parsedArray = parseSimpleArray _ctrlModifiedInput;
		if (count _parsedArray == 2) then {
			//Relative Position: [object,[x,y,z]]
			_strObjectEnd = _ctrlModifiedInput find ',';
			_strObjectVar = _ctrlModifiedInput select [1, _strObjectEnd - 1];
			//_relativeObject = missionNamespace getVariable [_strObjectVar, objNull];
			_parsedArray set [0, _strObjectVar];
			missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', str _choiceIndex], _parsedArray];
		} else { 
			//Position: [x,y,z]
			missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', str _choiceIndex], _parsedArray];
		};
	};
	//_ctrlText auto-name change based on value provided.
	//Position: [x,y,z] || Relative Position: [object, [x,y,z]] || Current Position -> Relative Position: object
	_ctrlEdit ctrlRemoveAllEventHandlers "KeyUp";
	_ctrlEdit ctrlAddEventHandler ["KeyUp", format ["
		disableSerialization;
		_ctrlEdit = _this select 0;
		_display = ctrlParent _ctrlEdit;
		_ctrlText = _display displayCtrl %1;
		_ctrlInput = ctrlText _ctrlEdit;
		_strStart = _ctrlInput select [0,1];
		_strEnd = _ctrlInput select [((count _ctrlInput) - 1),1];
		
		if (_ctrlInput isEqualTo (toString [0])) exitWith {
			_previousCam = [%3,%4] call Phobos_fnc_camGetPrevious;
			if (_previousCam select 1 != -1) then {
				_array = (_previousCam call Phobos_fnc_camGetProperties) select 0;
				_ctrlText ctrlSetText ""Position (Previous cam's position) :"";
				_ctrlEdit ctrlSetBackgroundColor [0,0.33,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _array];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', true];
			} else {
				_ctrlEdit ctrlSetBackgroundColor [0.33,0,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', false];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', ([%3, %4] call Phobos_fnc_camGetProperties) select 0];
			};
		};

		
		if ((_strStart isEqualto '[') && (_strEnd isEqualTo ']')) then {
			_ctrlModifiedInput = [_ctrlInput, toString [32], toString [0]] call Phobos_fnc_strReplace;
			_array = parseSimpleArray _ctrlModifiedInput;
			if (_array isEqualTypeArray [0,0,0]) exitWith {
				_ctrlText ctrlSetText 'Position :';
				_ctrlEdit ctrlSetBackgroundColor [0,0.33,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _array];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', true];
				
			}; 
			
			_strObjectEnd = _ctrlModifiedInput find ',';
			_strObjectVar = _ctrlModifiedInput select [1, _strObjectEnd - 1];
			_relativeObject = missionNamespace getVariable [_strObjectVar, objNull];
			_array set [0, _relativeObject];
			if (_array isEqualTypeArray [objNull, [0,0,0]] && {!isNull _relativeObject}) exitWith {
				_ctrlText ctrlSetText ""Position (Relative to "" + str _relativeObject + "") :"";
				_ctrlEdit ctrlSetBackgroundColor [0,0.33,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', [_strObjectVar, _array select 1]];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', true];
			};
			
			_ctrlEdit ctrlSetBackgroundColor [0.33,0,0,1];
			missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', false];
			missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', ([%3, %4] call Phobos_fnc_camGetProperties) select 0];
		} else {
			_relativeObject = missionNamespace getVariable [_ctrlInput, objNull];
			if (!isNull _relativeObject) then {
				_ctrlText ctrlSetText ""Position (Relative to "" + str _relativeObject + "") :"";
				_relativePositionX = ((([%3,%4] call Phobos_fnc_camGetProperties) select 0) select 0) - ((position _relativeObject) select 0);
				_relativePositionY = ((([%3,%4] call Phobos_fnc_camGetProperties) select 0) select 1) - ((position _relativeObject) select 1);
				_relativePositionZ = ((([%3,%4] call Phobos_fnc_camGetProperties) select 0) select 2) - ((position _relativeObject) select 2);
				_ctrlEdit ctrlSetBackgroundColor [0,0.33,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', [_ctrlInput, [_relativePositionX, _relativePositionY, _relativePositionZ]]];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', true];
			} else {
				_ctrlEdit ctrlSetBackgroundColor [0.33,0,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', false];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', ([%3, %4] call Phobos_fnc_camGetProperties) select 0];
			};
		};",
		ctrlIDC _ctrlText, str _choiceIndex, str _cutsceneName, _camID]
	];
		
	//Although 'KeyUp' action handles the calculation, we have to tell player that his desire is acknowledged and give it in its final form, displaying it in related syntax.(KeyUp would be annoying for this case as if a player had car and car1 vars, he would only be able to enter car and syntax would be automatically changing, making this feature a hell.)
	_ctrlEdit ctrlAddEventHandler ["KillFocus", format ["
		_ctrlEdit = _this select 0;
		_ctrlInput = ctrlText _ctrlEdit;
		_relativeObject = missionNamespace getVariable [_ctrlInput,objNull];
		
		if (_ctrlInput isEqualTo (toString [0]) || (!isNull _relativeObject)) then {
			_positionData = missionNamespace getVariable ['Phobos_ChooseDialog_ReturnValue_%1', []];
			_ctrlEdit ctrlSetText ([str _positionData, toString [34], toString [0]] call Phobos_fnc_strReplace);
		};",
		str _choiceIndex]
	];
	
	//Update Visually.
	_ctrlEdit ctrlAddEventHandler ["KillFocus", format ["
		_camPosition = missionNamespace getVariable ['Phobos_ChooseDialog_ReturnValue_%1', []];
		Phobos_fnc_camProperties_position = nil;
		Phobos_fnc_camProperties_position = _camPosition;
		if (count _camPosition == 2) then {
			[_camPosition] spawn {
				_positionValue = _this select 0;
				_relObject = missionNamespace getVariable [_positionValue select 0, objNull];
				_relPosition = _positionValue select 1;
				_timeStart = diag_tickTime;
				
				while {(missionNamespace getVariable ['Phobos_fnc_chooseDialog_isActive', false]) && {_positionValue isEqualTo Phobos_fnc_camProperties_position}} do {
					_posX = ((position _relObject) select 0) + (_relPosition select 0);
					_posY = ((position _relObject) select 1) + (_relPosition select 1);
					_posZ = ((position _relObject) select 2) + (_relPosition select 2);
					_finalPos = [_posX, _posY, _posZ];

					_timeStop = diag_tickTime;
					_timeDifference = _timeStop - _timeStart;
					_dynamicCommitTime = (1 - _timeDifference);
					
					
					if (isNil 'Phobos_fnc_camProperties_cam') exitWith {};
					Phobos_fnc_camProperties_cam camSetPos _finalPos;
					
					if (_dynamicCommitTime > 0.1) then {
						Phobos_fnc_camProperties_cam camCommit _dynamicCommitTime;
					} else {
						Phobos_fnc_camProperties_cam camCommit 0.1;
					};
				};
			};
		} else {
			if (count _camPosition == 3) then {
				Phobos_fnc_camProperties_cam camSetPos _camPosition;
			};
		};",
		str _choiceIndex]
	];
};

_code11 = {
	_choiceIndex = _this select 0;
	_ctrlText = _this select 1;
	_ctrlEdit = _this select 2;
	_ctrlInput = ctrlText _ctrlEdit;
	
	_strStart = _ctrlInput select [0,1];
	_strEnd = _ctrlInput select [((count _ctrlInput) - 1),1];
	if ((_strStart isEqualto '[') && (_strEnd isEqualTo ']')) then {
		_ctrlModifiedInput = [_ctrlInput, toString [32], toString [0]] call Phobos_fnc_strReplace;
		_array = parseSimpleArray _ctrlModifiedInput;
		if (_array isEqualTypeArray [0,0,0]) then {
			_ctrlText ctrlSetText 'Target :';
			missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choiceIndex], _array];
		};
	} else {
		_object = missionNamespace getVariable [_ctrlInput, objNull];
		if (!isNull _object) then { //If not true, huge problem but just in case.
			_ctrlText ctrlSetText format ['Target(%1) :', _object];
			missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choiceIndex], _ctrlInput];
		};
	};
	
	// _target = [x,y,z] or object
	_ctrlEdit ctrlRemoveAllEventHandlers "KeyUp";
	_ctrlEdit ctrlAddEventHandler ["KeyUp", format ["
		disableSerialization;
		_ctrlEdit = _this select 0;
		_display = ctrlParent _ctrlEdit;
		_ctrlText = _display displayCtrl %1;
		_ctrlInput = ctrlText _ctrlEdit;
		
		if (_ctrlInput isEqualTo (toString [0])) exitWith {
			_previousCam = [%3,%4] call Phobos_fnc_camGetPrevious;
			if (_previousCam select 1 != -1) then {
				_targetData = (_previousCam call Phobos_fnc_camGetProperties) select 1;
				_ctrlText ctrlSetText ""Target (Previous cam's target) :"";
				_ctrlEdit ctrlSetBackgroundColor [0,0.33,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _targetData];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidTarget', true];
			} else {
				_ctrlEdit ctrlSetBackgroundColor [0.33,0,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidTarget', false];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', ([%3, %4] call Phobos_fnc_camGetProperties) select 1];
			};
		};
		
		_strStart = _ctrlInput select [0,1];
		_strEnd = _ctrlInput select [((count _ctrlInput) - 1),1];
		if ((_strStart isEqualto '[') && (_strEnd isEqualTo ']')) then {
			_ctrlModifiedInput = [_ctrlInput, toString [32], toString [0]] call Phobos_fnc_strReplace;
			_array = parseSimpleArray _ctrlModifiedInput;
			if (_array isEqualTypeArray [0,0,0]) then {
				_ctrlText ctrlSetText 'Target :';
				_ctrlEdit ctrlSetBackgroundColor [0,0.33,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _array];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidTarget', true];
			} else {
				_ctrlEdit ctrlSetBackgroundColor [0.33,0,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', ([%3, %4] call Phobos_fnc_camGetProperties) select 1];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidTarget', false];
			};
		} else {
			_object = missionNamespace getVariable [_ctrlInput, objNull];
			if (!isNull _object) then {
				_ctrlText ctrlSetText ""Target (""  + str _object + "") :"";
				_ctrlEdit ctrlSetBackgroundColor [0,0.33,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _ctrlInput];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidTarget', true];
			} else {
				_ctrlEdit ctrlSetBackgroundColor [0.33,0,0,1];
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', ([%3, %4] call Phobos_fnc_camGetProperties) select 1];
				missionNamespace setVariable ['Phobos_ChooseDialog_isValidTarget', false];
			};
		};",
		ctrlIDC _ctrlText, str _choiceIndex, str _cutsceneName, _camID]
	];
	
	//Update if its previous cam's target is requested.
	_ctrlEdit ctrlAddEventHandler ["KillFocus", format ["
		_ctrlEdit = _this select 0;
		_ctrlInput = ctrlText _ctrlEdit;
		
		if (_ctrlInput isEqualTo (toString [0])) then {
			_targetData = missionNamespace getVariable ['Phobos_ChooseDialog_ReturnValue_%1', []];
			_ctrlEdit ctrlSetText ([str _targetData, toString [34], toString [0]] call Phobos_fnc_strReplace);
		};",
		str _choiceIndex]	
	];
	
	//Update visually.
	_ctrlEdit ctrlAddEventHandler ["KillFocus", format ["
		_enteredValue = missionNamespace getVariable ['Phobos_ChooseDialog_ReturnValue_%1', []];
		private '_target';
		if (_enteredValue isEqualType toString [0]) then {
			_target = missionNamespace getVariable [_enteredValue, objNull];
		} else {
			_target = _enteredValue;
		};
		Phobos_fnc_camProperties_cam camSetTarget _target;
		Phobos_fnc_camProperties_cam camCommit 1;
		",
		str _choiceIndex]
	];
};

_code51 = {
	_slider = _this select 2;
	
	_slider ctrlAddEventHandler ["SliderPosChanged", {
		_fov = _this select 1;
		Phobos_fnc_camProperties_cam camSetFov _fov;
		Phobos_fnc_camProperties_cam camCommit 1;
	}];
};

_code61 = { 
	_choiceIndex = _this select 0;
	_slider = _this select 2;
	_sliderText = _this select 3;
	switch (sliderPosition _slider) do {
		case 0: {_sliderText ctrlSetText 'AUTO'};
		case 100: {_sliderText ctrlSetText 'DISABLED'};
	};
	
	_slider ctrlRemoveAllEventHandlers "SliderPosChanged";
	_slider ctrlAddEventHandler ["SliderPosChanged", format ["
		disableSerialization;
		_slider = _this select 0;
		_sliderValue = _this select 1;
		_display = ctrlParent _slider;
		_sliderText = _display displayCtrl %1;
		_sliderRoundedValue = [_sliderValue, 3] call Phobos_fnc_roundNumber;
		switch (_sliderRoundedValue) do {
			case 0: {_sliderText ctrlSetText 'AUTO'};
			case 100: {_sliderText ctrlSetText 'DISABLED'};
			default {_sliderText ctrlSetText (str _sliderRoundedValue)};
		};
		missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _sliderRoundedValue];",
		ctrlIDC _sliderText, str _choiceIndex]
	];
	
	_slider ctrlAddEventHandler ["SliderPosChanged", {
		_focus = _this select 1; 
		if (_focus == 0) then {
			Phobos_fnc_camProperties_cam camSetFocus [-1, 1];
		} else {
			Phobos_fnc_camProperties_cam camSetFocus [_focus , 1];
		};
		Phobos_fnc_camProperties_cam camCommit 1;
	}];
};

_code71 = { 
	_choiceIndex = _this select 0;
	_slider = _this select 2;
	_sliderText = _this select 3;
	
	if(sliderPosition _slider == 0) then {
		_sliderText ctrlSetText 'AUTO';
	};
	
	_slider ctrlRemoveAllEventHandlers "SliderPosChanged";
	_slider ctrlAddEventHandler ["SliderPosChanged", format ["
		disableSerialization;
		_slider = _this select 0;
		_sliderValue = _this select 1;
		_display = ctrlParent _slider;
		_sliderText = _display displayCtrl %1;
		_sliderRoundedValue = [_sliderValue, 2] call Phobos_fnc_roundNumber;
		switch (_sliderRoundedValue) do {
			case 0: {_sliderText ctrlSetText 'AUTO'};
			default {_sliderText ctrlSetText (str _sliderRoundedValue)};
		};
		missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _sliderRoundedValue];",
		ctrlIDC _sliderText, str _choiceIndex]
	];
	
	_slider ctrlAddEventHandler ["SliderPosChanged", {
		_aperture = _this select 1; 
		if (_aperture == 0) then {
			setAperture -1;
		} else {
			setAperture _aperture;
		};
	}];
};

_code81 = {
	_slider = _this select 2;
	
	//Update visually.
	_slider ctrlAddEventHandler ["sliderPosChanged", {
		_brightness = _this select 1;
		Phobos_fnc_camProperties_brightness = _brightness;
		Phobos_fnc_camProperties_ppColor ppEffectAdjust [1,Phobos_fnc_camProperties_brightness,Phobos_fnc_camProperties_contrast,[1,1,1,0],[1,1,1,Phobos_fnc_camProperties_saturation],[0.75,0.25,0,1]];
		Phobos_fnc_camProperties_ppColor ppEffectCommit 1;
	}];
};

_code91 = {
	_slider = _this select 2;
	
	//Update visually.
	_slider ctrlAddEventHandler ["sliderPosChanged", {
		_contrast = _this select 1;
		Phobos_fnc_camProperties_contrast = _contrast;
		Phobos_fnc_camProperties_ppColor ppEffectAdjust [1,Phobos_fnc_camProperties_brightness,Phobos_fnc_camProperties_contrast,[1,1,1,0],[1,1,1,Phobos_fnc_camProperties_saturation],[0.75,0.25,0,1]];
		Phobos_fnc_camProperties_ppColor ppEffectCommit 1;
	}];
};

_codeA1 = {
	_slider = _this select 2;
	
	//Update visually.
	_slider ctrlAddEventHandler ["sliderPosChanged", {
		_saturation	= _this select 1;
		Phobos_fnc_camProperties_saturation = _saturation;
		Phobos_fnc_camProperties_ppColor ppEffectAdjust [1,Phobos_fnc_camProperties_brightness,Phobos_fnc_camProperties_contrast,[1,1,1,0],[1,1,1,Phobos_fnc_camProperties_saturation],[0.75,0.25,0,1]];
		Phobos_fnc_camProperties_ppColor ppEffectCommit 1;
	}];
};

//Works, unused due feature removed. (Unable to adapt the feature for too many possibilities during a cutscene is being played: More info at fn_cutscenePrepare.sqf)
_codeB1 = {
	//Displays user the selected time; if its host, all clients get a 'simulated timeline' independent from actualTime. If it is a client, only client gets 'simulated timeline'.
	_choicesArrayIndex = _this select 0;
	_slider = _this select 2;
	_sliderText = _this select 3;
	_sliderValue = sliderPosition _slider;

	Phobos_fnc_camProperties_dayTime = _sliderValue;
		
	private _text = '';
	private ['_hour','_min'];
	
	//Convert sliderText value to HH:MM format.
	switch (_sliderValue) do {
		case 0: {_text = 'No Change'; _hour = 0; _min = 0;}; //_hour and _min are dummy variables, they will be overwritten anyway in this case.
		case 1440: {_hour = 0; _min = 0;};
		default {_hour = floor (_sliderValue / 60); _min = floor (_sliderValue mod 60);};
	};
	
	if (_sliderValue != 0) then {
		private _strHour = str _hour;
		private _strMin = str _min;
		
		if (count _strHour == 1) then {
			_strHour = '0' + _strHour;
		};
		if (count _strMin == 1) then {
			_strMin = '0' + _strMin;
		};
		
		_text = _strHour + ':' + _strMin;
	};
	_sliderText ctrlSetText _text;
	['Slider Value(int):' + (str _sliderValue), Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	['Slider Value(time):' + _text, Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	
	//Change our value the moment it is chosen, since checking simulation is something optional. Player should expect their value made it to results before simulation done.
	missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choicesArrayIndex], _sliderValue];
	
	[_hour, _min, _sliderValue, _cutsceneName, _camID, _choicesArrayIndex] spawn {
		//Wait till onLoad is called, this is to reduce load caused by setDate, which caused delay on dynamic dialog's generation. For more information, read notes on fn_showChooseDialog.sqf.
		["Initializing wait process for daytime simulation.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		private _k = 0;
		waitUntil {
			//Takes mostly 1 cycle, but may not be true for a busy client/host. Either way, it fixes the gui shutter caused by setDate.
			[format ["Waiting for dialog to be built(%1).", _k], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			_k = _k + 1;
			private _activateDayTimeChange = (missionNamespace getVariable ["Phobos_fnc_camProperties_initDayTimeChange", false]);
			_activateDayTimeChange;
		};
		missionNamespace setVariable ["Phobos_fnc_camProperties_initDayTimeChange", false];
		uiSleep DELAY_DAYTIME_EXECUTION; //Secure safe camera travel.
		["Initializing daytime simulation.", Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		private _hour = _this select 0;
		private _min = _this select 1;
		private _sliderValue = _this select 2;
		private _cutsceneName = _this select 3;
		private _camID = _this select 4;
		private _choicesArrayIndex = _this select 5;
		
		//If sliderValue is already changed, or dialog closed, terminate execution.
		if (Phobos_fnc_camProperties_dayTime != _sliderValue || !Phobos_fnc_chooseDialog_isActive) exitWith {
		missionNamespace setVariable ['Phobos_fnc_camProperties_initVisionModeChange', true];
		['[Daytime] Dialog closed or global sliderValue != local sliderValue. Progress halted.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		};
		
		private _stopSimulationInit = false;
		//If sliderValue is 0, try to find last previous cam that changes time, so that we can show how it will look on cutscene on this particular camera, if found nothing just simulate current time as we cannot guess under what conditions(ie. when on daytime) cutscene will be executed.
		if (_sliderValue == 0) then {
			if (_camID != 1) then {
				for [{_i = 1}, {_i < _camID}, {_i = _i + 1}] do {
					if ([_cutsceneName, _camID - _i] call Phobos_fnc_camExists) then {
						_prevCamProperty = [_cutsceneName, _camID - _i] call Phobos_fnc_camGetProperties;
						_prevChangedDayTime = _prevCamProperty select _choicesArrayIndex;
						if (_prevChangedDayTime != 0) then {
							_hour = floor (_prevChangedDayTime / 60);
							_min = floor (_prevChangedDayTime mod 60);
							_i = _camID;
						};
						if (_prevChangedDayTime == 0 && {_i == _camID - 1}) then {
							//If we're at last camera and no time change is present, then just stop simulation. 
							_stopSimulationInit = true;
						};
					};
				};
			} else {
				//Stop simulation since current cam is 1st cam, and it is slider value is 0, which means just show this moment.
				_stopSimulationInit = true;
			}
		};
		
		//(For Server) If simulation was on and current slider value is 0, and no previous camera has different daytime, then stop the simulation.
		/*
		if (isServer && {missionNamespace getVariable ['Phobos_fnc_camProperties_isTimeSimulatedByHost', false]} && {_stopSimulationInit} && {_sliderValue == 0}) then {
			_elapsedMin = floor (Phobos_fnc_camProperties_elapsedTimeSinceSimStarted / 60);
			_elapsedSec = floor (Phobos_fnc_camProperties_elapsedTimeSinceSimStarted mod 60);
			setDate ((Phobos_fnc_camProperties_actualDate select [0,4]) + [(Phobos_fnc_camProperties_actualDate select 4) + (_elapsedMin * Phobos_fnc_camProperties_timeMultiplier)]);
			skipTime ((Phobos_fnc_camProperties_dayTime_actualSecond + (_elapsedSec * Phobos_fnc_camProperties_timeMultiplier)) / 3600); //TODO: Fix ineffective line, gets overwritten by setDate. Affects seconds.
			
			setTimeMultiplier Phobos_fnc_camProperties_timeMultiplier;
			
			Phobos_fnc_camProperties_isTimeSimulatedByHost = false;
			//publicVariable "Phobos_fnc_camProperties_isTimeSimulatedByHost";
			//The variable below insists on not becoming false on remote clients, but for some reason, in while it succeeds in one attempt...
			[[], {_i = 0; while {Phobos_fnc_camProperties_isTimeSimulatedByHost} do {systemChat format ["Attempting to disable variable Phobos_fnc_camProperties_isTimeSimulatedByHost (%1)", _i]; _i = _i + 1; Phobos_fnc_camProperties_isTimeSimulatedByHost = false;}}] remoteExecCall ["spawn", -2];
			//Phobos_fnc_camProperties_elapsedTimeSinceSimStarted = nil; Returns log error(functionally correct) when deleted for some reason. Most likely due while loop cannot be terminated in time.+ 1; Phobos_fnc_camProperties_isTimeSimulatedByHost = false;}}] remoteExecCall ["spawn", -2];
		};
		*/
		//If sliderValue == 0 && no previous cam changes time aswell, then stop time simulation init.
		if (_stopSimulationInit) exitWith {
			missionNamespace setVariable ['Phobos_fnc_camProperties_initVisionModeChange', true];
			['Simulation process halted, no daytime to simulate was found in cutscene.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage
		};
		
		if (isServer) then {
			['Daytime simulation process configured for host. Initializing visual change.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;

			if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isTimeSimulatedByHost', false])) then {
				Phobos_fnc_camProperties_actualDayTime = daytime;
				Phobos_fnc_camProperties_actualDate = date;
				Phobos_fnc_camProperties_timeMultiplier = timeMultiplier;
			};
			private _actualDayTime = Phobos_fnc_camProperties_actualDayTime;
			private _actualDate = Phobos_fnc_camProperties_actualDate;
			private _actualTimeMultiplier = Phobos_fnc_camProperties_timeMultiplier;
			private _actualHour = floor _actualDayTime;
			private _actualMinute = floor ((_actualDayTime - _actualHour) * 60);
			private _actualSecond = floor (((((_actualDayTime) - (_actualHour)) * 60) - _actualMinute) * 60); 
			Phobos_fnc_camProperties_dayTime_actualSecond = _actualSecond;
			
			//Make clients loop actual time till host is not simulating.
			//TODO: Check if this part should be conditional based on Phobos_fnc_camProperties_isTimeSimulatedByHost aswell...
			private _remoteCode = {
				private _date = _this select 0;
				private _timeMultiplier = _this select 1;
				
				Phobos_fnc_camProperties_isTimeSimulatedByHost = true;
				//Fix second calculation, however even with that, skipTime works before setDate, ending up useless.
				while {Phobos_fnc_camProperties_isTimeSimulatedByHost} do {setDate _date; skipTime (0.01 * _timeMultiplier / 3600)};
			};
			
			//Start simulation.
			[[Phobos_fnc_camProperties_actualDate, _actualTimeMultiplier], _remoteCode] remoteExecCall ['spawn', -2];
			setTimeMultiplier 0;
			
			//If time was not simulated by host, initialize simulation and start to record elapsed time of simulation.
			if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isTimeSimulatedByHost',false])) then {
				Phobos_fnc_camProperties_isTimeSimulatedByHost = true;
				[] spawn {
					Phobos_fnc_camProperties_elapsedTimeSinceSimStarted = 0;
					while {Phobos_fnc_camProperties_isTimeSimulatedByHost} do {
						uiSleep 0.01;
						Phobos_fnc_camProperties_elapsedTimeSinceSimStarted = Phobos_fnc_camProperties_elapsedTimeSinceSimStarted + 0.01;
					};
				};
			};
			//Switch host's date, without worrying about clients on other dimension looping their actualTime independently.
			setDate ((_actualDate select [0,3]) + [_hour, _min]);
			['Time changed to: ' + str date, Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			missionNamespace setVariable ['Phobos_fnc_camProperties_initVisionModeChange', true];
		} else {
			//If curator is client, life is easy for us. Just keep looping the desired time for client.
			['Daytime simulation process configured for client. Initializing visual change.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			private _date = date select [0,3];
			_date = _date + [_hour, _min];
			[_sliderValue, _date] spawn {
				private _sliderValue = _this select 0;
				private _date = _this select 1;
				while {Phobos_fnc_chooseDialog_isActive && {Phobos_fnc_camProperties_dayTime == _sliderValue}} do {setDate _date;};
			};
			missionNamespace setVariable ['Phobos_fnc_camProperties_initVisionModeChange', true];
		};
	};
	
	//Number to Clock conversion for user.(Visually shows HH:MM, returns integer in minute format.)
	//Displays user the selected time; if its host, all clients get a 'simulated timeline' independent from actualTime. If it is a client, only client gets 'simulated timeline'.
	//Pretty much the same as initial code.
	_slider ctrlRemoveAllEventHandlers "sliderPosChanged";
	_slider ctrlAddEventHandler ["sliderPosChanged", format ["
		_slider = _this select 0;
		_sliderValue = _this select 1;
		_display = ctrlParent _slider;
		_sliderText = _display displayCtrl %1;
		
		Phobos_fnc_camProperties_dayTime = _sliderValue;
		
		private _text = '';
		private ['_hour','_min'];
		switch (_sliderValue) do {
			case 0: {_text = 'No Change'; _hour = 0; _min = 0;};
			case 1440: {_hour = 0; _min = 0;};
			default {_hour = floor (_sliderValue / 60); _min = floor (_sliderValue mod 60);};
		};
		
		if (_sliderValue != 0) then {
			private _strHour = str _hour;
			private _strMin = str _min;
			

			if (count _strHour == 1) then {
				_strHour = '0' + _strHour;
			};
			if (count _strMin == 1) then {
				_strMin = '0' + _strMin;
			};
			
			_text = _strHour + ':' + _strMin;
		};
		_sliderText ctrlSetText _text;
		['Slider Value(int):' + (str _sliderValue), Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		['Slider Value(time):' + _text, Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _sliderValue];
		
		[_hour, _min, _sliderValue] spawn {
			private _hour = _this select 0;
			private _min = _this select 1;
			private _sliderValue = _this select 2;
		
		
			private _timeStart = diag_tickTime;
			waitUntil {
				private _timeStop = diag_tickTime;
				(_timeStop - _timeStart) >= 1;
			};
			if (Phobos_fnc_camProperties_dayTime != _sliderValue || !Phobos_fnc_chooseDialog_isActive) exitWith {};
			private _stopSimulationInit = false;
			if (_sliderValue == 0) then {
				if (%4 != 1) then {
					for [{_i = 1}, {_i < %4}, {_i = _i + 1}] do {
						if ([%3, %4 - _i] call Phobos_fnc_camExists) then {
							private _prevCamProperty = [%3, %4 - _i] call Phobos_fnc_camGetProperties;
							private _prevChangedDayTime = _prevCamProperty select 11;
							if (_prevChangedDayTime != 0) then {
								_hour = floor (_prevChangedDayTime / 60);
								_min = floor (_prevChangedDayTime mod 60);
								_i = %4;
							};
							if (_prevChangedDayTime == 0 && {_i == %4 - 1}) then {
								_stopSimulationInit = true;
							};
						};
					};
				} else {
					_stopSimulationInit = true;
				};
			};
			
			
			if (isServer && {missionNamespace getVariable ['Phobos_fnc_camProperties_isTimeSimulatedByHost', false]} && {_stopSimulationInit} && {_sliderValue == 0}) then {
				_elapsedMin = floor (Phobos_fnc_camProperties_elapsedTimeSinceSimStarted / 60);
				_elapsedSec = floor (Phobos_fnc_camProperties_elapsedTimeSinceSimStarted mod 60);
				setDate ((Phobos_fnc_camProperties_actualDate select [0,4]) + [(Phobos_fnc_camProperties_actualDate select 4) + (_elapsedMin * Phobos_fnc_camProperties_timeMultiplier)]);
				skipTime ((Phobos_fnc_camProperties_dayTime_actualSecond + (_elapsedSec * Phobos_fnc_camProperties_timeMultiplier)) / 3600);
				
				setTimeMultiplier Phobos_fnc_camProperties_timeMultiplier;
				
				Phobos_fnc_camProperties_isTimeSimulatedByHost = false;
				
				[[], {_i = 0; while {Phobos_fnc_camProperties_isTimeSimulatedByHost} do {systemChat (""Attempting to disable variable Phobos_fnc_camProperties_isTimeSimulatedByHost ("" + str _i + "")""); _i = _i + 1; Phobos_fnc_camProperties_isTimeSimulatedByHost = false;}}] remoteExecCall ['spawn', -2];
			};
			
			if (_stopSimulationInit) exitWith {['Simulation process halted, no daytime to simulate was found in cutscene.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage};
			if (isServer) then {
				['Daytime simulation initialized for host.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
				if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isTimeSimulatedByHost', false])) then {
					Phobos_fnc_camProperties_actualDayTime = daytime;
					Phobos_fnc_camProperties_actualDate = date;
					Phobos_fnc_camProperties_timeMultiplier = timeMultiplier;
				};
				private _actualDayTime = Phobos_fnc_camProperties_actualDayTime;
				private _actualDate = Phobos_fnc_camProperties_actualDate;
				private _actualTimeMultiplier = Phobos_fnc_camProperties_timeMultiplier;
				private _actualHour = floor _actualDayTime;
				private _actualMinute = floor ((_actualDayTime - _actualHour) * 60);
				private _actualSecond = floor (((((_actualDayTime) - (_actualHour))*60) - _actualMinute)*60); 
				Phobos_fnc_camProperties_dayTime_actualSecond = _actualSecond;
				
				private _remoteCode = {
					private _date = _this select 0;
					private _timeMultiplier = _this select 1;
					
					Phobos_fnc_camProperties_isTimeSimulatedByHost = true;
					comment 'Fix second calculation, however even with that , skipTime works before setDate, ending up useless.';
					while {Phobos_fnc_camProperties_isTimeSimulatedByHost} do {setDate _date; skipTime (0.01 * _timeMultiplier / 3600)};
				};
				
				
				[[_actualDate, _actualTimeMultiplier], _remoteCode] remoteExecCall ['spawn', -2];
				setTimeMultiplier 0;
				
				if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isTimeSimulatedByHost',false])) then {
					Phobos_fnc_camProperties_isTimeSimulatedByHost = true;
					[] spawn {
						Phobos_fnc_camProperties_elapsedTimeSinceSimStarted = 0;
						while {Phobos_fnc_camProperties_isTimeSimulatedByHost} do {
							uiSleep 0.01;
							Phobos_fnc_camProperties_elapsedTimeSinceSimStarted = Phobos_fnc_camProperties_elapsedTimeSinceSimStarted + 0.01;
						};
					};
				};
				setDate ((_actualDate select [0,3]) + [_hour, _min]);
				['Time changed to: ' + str date, Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			} else {
				['Daytime simulation initialized for client.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
				private _date = date select [0,3];
				_date = _date + [_hour, _min];
				[_sliderValue, _date] spawn {
					private _sliderValue = _this select 0;
					private _date = _this select 1;
					while {Phobos_fnc_chooseDialog_isActive && {Phobos_fnc_camProperties_dayTime == _sliderValue}} do {setDate _date;};
				};
			};
		}", 
		ctrlIDC _sliderText, _choicesArrayIndex, _cutsceneName, _camID] 
	];
};

//Overcast
/*
_codeC1 = {
	_choicesArrayIndex = _this select 0;
	_slider = _this select 2;
	_sliderText = _this select 3;
	_sliderValue = sliderPosition _slider;
	
	_sliderValue = [_sliderValue, 2] call Phobos_fnc_roundNumber;
	Phobos_fnc_camProperties_overcast = _sliderValue;
	
	private _text = '';
	private '_sliderValue';
	if (_sliderValue < 0.00) then {
		_text = 'No Change';
	} else {
		_text = str _sliderValue;
	};
	_sliderText ctrlSetText _text;
	['Slider Value(int):' + (str _sliderValue), Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	
	missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1',_choicesArrayIndex], _sliderValue];
	
	[_sliderValue, _cutsceneName, _camID] spawn {
		private _sliderValue = _this select 0;
		private _cutsceneName = _this select 1;
		private _camID = _this select 2;
		
		//If sliderValue is already changed, or dialog closed, terminate execution.
		if (Phobos_fnc_camProperties_dayTime != _sliderValue || !Phobos_fnc_chooseDialog_isActive) exitWith {['[Overcast] Dialog closed or global sliderValue != local sliderValue. Progress halted.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;};
		
		private _stopSimulationInit = false;
		//If sliderValue is 0, try to find last previous cam that changes overcast, so that we can show how it will look on cutscene on this particular camera, if found nothing just simulate current overcast as we cannot guess under what conditions(ie. on what overcast) cutscene will be executed.
		if (_sliderValue == -0.01) then {
			if (_camID != 1) then {
				for [{_i = 1}, {_i < _camID}, {_i = _i + 1}] do {
					if ([_cutsceneName, _camID - _i] call Phobos_fnc_camExists) then {
						private _prevCamProperty = [_cutsceneName, _camID - _i] call Phobos_fnc_camGetProperties;
						private _prevChangedOvercast = _prevCamProperty select 12;
						if (_prevChangedOvercast != -0.01) then {
							_sliderValue = _prevChangedOvercast;
							_i = _camID;
						};
						if (_prevChangedOvercast == -0.01 && {_i == _camID - 1}) then {
							//If we're at last camera and no overcast change is present, then just stop simulation. 
							_stopSimulationInit = true;
						};
					};
				};
			} else {
				//Stop simulation since current cam is 1st cam, and it is slider value is 0, which means just show this moment's overcast.
				_stopSimulationInit = true;
			};
		};
		
		//(For Server) If simulation was on and current slider value is 0, and no previous camera has different overcast, then stop the simulation.
		<Comment Out Below When It Works>
		if (isServer && {missionNamespace getVariable ['Phobos_fnc_camProperties_isOvercastSimulatedByHost', false]} && {_stopSimulationInit} && {_sliderValue == -0.01}) then {
			86400 setOvercast Phobos_fnc_camProperties_actualOvercast;
			skiptime 24;
			skiptime -24;
			simulWeatherSync;
			
			Phobos_fnc_camProperties_isOvercastSimulatedByHost = false;
			
			[[], {_i = 0; while {Phobos_fnc_camProperties_isOvercastSimulatedByHost} do {systemChat ("Attempting to disable variable Phobos_fnc_camProperties_isOvercastSimulatedByHost (" + str _i + ")"); _i = _i + 1; Phobos_fnc_camProperties_isOvercastSimulatedByHost = false;}}] remoteExecCall ['spawn', -2];
		};
		<Comment out Above When It works>
		
		if (_stopSimulationInit) exitWith {['Simulation process halted, no overcast to simulate was found in cutscene.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage};
		if (isServer) then {
			['Overcast simulation initialized for host.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isOvercastSimulatedByHost', false])) then {
				Phobos_fnc_camProperties_actualOvercast = overcast;
			};
			private _actualOvercast = Phobos_fnc_camProperties_actualOvercast;
			
			private _remoteCode = {
				private _overcast = _this;
				
				Phobos_fnc_camProperties_isOvercastSimulatedByHost = true;
				while {Phobos_fnc_camProperties_isOvercastSimulatedByHost} do {86400 setOvercast _overcast};
			};
			
			[_actualOvercast, _remoteCode] remoteExecCall ['spawn', -2];
			
			if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isOvercastSimulatedByHost',false])) then {
				Phobos_fnc_camProperties_isOvercastSimulatedByHost = true;
			};
			86400 setOvercast _sliderValue;
			skiptime 24;
			skiptime -24;
			simulWeatherSync;
		} else {
			['Overcast simulation initialized for client.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			86400 setOvercast _sliderValue;
			skipTime 24;
			skipTime -24;
			simulWeatherSync;
			while {Phobos_fnc_chooseDialog_isActive && {Phobos_fnc_camProperties_overcast == _sliderValue}} do {86400 setOvercast _sliderValue; skipTime 24; skipTime -24;};
		}
	};
	
	_slider ctrlRemoveAllEventHandlers "sliderPosChanged";
	_slider ctrlAddEventHandler ["sliderPosChanged", format ["
		_slider = _this select 0;
		_sliderValue = _this select 1;
		_display = ctrlParent _slider;
		_sliderText = _display displayCtrl %1;
		
		_sliderValue = [_sliderValue, 2] call Phobos_fnc_roundNumber;
		Phobos_fnc_camProperties_overcast = _sliderValue;
		
		private _text = '';
		private '_sliderValue';
		if (_sliderValue < 0) then {
			_text = 'No Change';
		} else {
			_text = str _sliderValue;
		};
		_sliderText ctrlSetText _text;
		['Slider Value(int):' + (str _sliderValue), Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		
		missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%2', _sliderValue];
		
		[_sliderValue] spawn {
			_sliderValue = _this select 0;
			
			private _timeStart = diag_tickTime;
			waitUntil {
				private _timeStop = diag_tickTime;
				(_timeStop - _timeStart) >= 1;
			};
			
			if (Phobos_fnc_camProperties_overcast != _sliderValue || !Phobos_fnc_chooseDialog_isActive) exitWith {};

			private _stopSimulationInit = false;
			if (_sliderValue == -0.01) then {
				if (%4 != 1) then {
					for [{_i = 1}, {_i < %4}, {_i = _i + 1}] do {
						if ([%3, %4 - _i] call Phobos_fnc_camExists) then {
							private _prevCamProperty = [%3, %4 - _i] call Phobos_fnc_camGetProperties;
							private _prevChangedOvercast = _prevCamProperty select %2;
							if (_prevChangedOvercast != -0.01) then {
								_sliderValue = _prevChangedOvercast;
								_i = %4;
							};
							if (_prevChangedOvercast == -0.01 && {_i == %4 - 1}) then {
								_stopSimulationInit = true;
							};
						};
					};
				} else {
					_stopSimulationInit = true;
				};
			};
			
			if (isServer && {missionNamespace getVariable ['Phobos_fnc_camProperties_isOvercastSimulatedByHost', false]} && {_stopSimulationInit} && {_sliderValue == -0.01}) then {
				86400 setOvercast Phobos_fnc_camProperties_actualOvercast;
				skiptime 24;
				skiptime -24;
				simulWeatherSync;
				
				Phobos_fnc_camProperties_isOvercastSimulatedByHost = false;
				
				[[], {_i = 0; while {Phobos_fnc_camProperties_isOvercastSimulatedByHost} do {systemChat (""Attempting to disable variable Phobos_fnc_camProperties_isOvercastSimulatedByHost ("" + str _i + "")""); _i = _i + 1; Phobos_fnc_camProperties_isOvercastSimulatedByHost = false;}}] remoteExecCall ['spawn', -2];
			};
			
			if (_stopSimulationInit) exitWith {['Simulation process halted, no overcast to simulate was found in cutscene.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage};
			if (isServer) then {
				['Overcast simulation initialized for host.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
				if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isOvercastSimulatedByHost', false])) then {
					Phobos_fnc_camProperties_actualOvercast = overcast;
				};
				private _actualOvercast = Phobos_fnc_camProperties_actualOvercast;
				
				private _remoteCode = {
					private _overcast = _this;
					
					Phobos_fnc_camProperties_isOvercastSimulatedByHost = true;
					
					while {Phobos_fnc_camProperties_isOvercastSimulatedByHost} do {86400 setOvercast _overcast};
				};
				
				[_actualOvercast, _remoteCode] remoteExecCall ['spawn', -2];
				
				if (!(missionNamespace getVariable ['Phobos_fnc_camProperties_isOvercastSimulatedByHost',false])) then {
					Phobos_fnc_camProperties_isOvercastSimulatedByHost = true;
				};
				86400 setOvercast _sliderValue;
				skiptime 24;
				skiptime -24;
				simulWeatherSync;
			} else {
				['Overcast simulation initialized for client.', Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
				86400 setOvercast _sliderValue;
				skipTime 24;
				skipTime -24;
				simulWeatherSync;
				while {Phobos_fnc_chooseDialog_isActive && {Phobos_fnc_camProperties_overcast == _sliderValue}} do {86400 setOvercast _sliderValue;};
			}
		}",
		ctrlIDC _sliderText, _choicesArrayIndex, _cutsceneName, _camID]
	];
};
*/
//Rain

//Fog

//Vision Mode
_codeF1 = {
	//Visually Simulate, rest is handled by default handler.
	_combobox = _this select 2;
	
	_combobox ctrlAddEventHandler ["LBSelChanged", "
		_choiceSelected = _this select 1;
		switch (_choiceSelected) do {
			case 0: {camUseNVG false; false setCamUseTI 0;};
			case 1: {camUseNVG true; false setCamUseTI 0;};
			case 2; case 3; case 4; case 5; case 6; case 7; case 8;
			case 9: {camUseNVG false; true setCamUseTI (_choiceSelected - 2);};
		};"
	];
};

//Convert _camIsAttached to integer to be compatible with showChooseDialog.
private "_intCamIsAttached";
if (_camIsAttached) then {
	_intCamIsAttached = 0;
} else {
	_intCamIsAttached = 1;
};




_chatResult = 
	[format ["Cam Editor: %1",_camFullName], 
		[ 
			["Position :" , [str _camPosition, toString [34], toString [0]] call Phobos_fnc_strReplace, [_tooltip01, _tooltip02], _code01, false],
			["Target :", [str _camTarget, toString [34], toString [0]] call Phobos_fnc_strReplace, [_tooltip11, ""], _code11, false],
			["Attach cam to relative object?", [["Yes","No"], _intCamIsAttached], [_tooltip21, ""], nil, false],
			["Commit Time :", str _camCommitTime, [_tooltip31, ""], nil, false], 
			["Wait Before Commit :", str _camWaitBeforeCommit, [_tooltip41, ""], nil, false],
			["Field Of View :", [0, _camFov, 5, 1], [_tooltip51, ""], _code51, false],
			["Focus :", [0, _camFocus, 100], [_tooltip61, ""], _code61, false],
			["Aperture :", [0, _camAperture, 150], [_tooltip71, _tooltip72], _code71, false],
			["Brightness :", [0.5, _camBrightness, 1.5, 2], [_tooltip81, ""], _code81, false],
			["Contrast :", [-0.5, _camContrast, 0.5, 2], [_tooltip91, ""], _code91, false],
			["Saturation :", [0, _camSaturation, 2, 2], [_tooltipA1, ""], _codeA1, false],
			//["Daytime :", [0, _camDayTime, 1440], [_tooltipB1, ""], _codeB1, false],
			//["Overcast :", [-0.01, _camOvercast, 1, 2], [_tooltipC1, ""], _codeC1, false],
			//["Rain Density :", [-0.01, _camRain, 1, 2], [_tooltipD1, ""], _codeD1, false],
			//["Fog Density :", [-0.01, _camFog, 1, 2], [_tooltipE1, ""], _codeE1, false],
			["Vision Type :", [["Normal Vision", "Night Vision", "Thermal(White Hot)", "Thermal(Black Hot)", "Thermal(Light Green Hot / Darker Green Cold)", "Thermal(Black Hot / Darker Green Cold)", "Thermal(Light Red Hot / Darker Red Cold)", "Thermal(Black Hot / Darker Red Cold)", "Thermal(White Hot / Darker Red Cold)", "Thermal(Predator Vision)"], _camVisionMode], [_tooltipF1, ""], _codeF1, false],
			["Code :", ["ScriptBox", _camCode, 3], [_tooltipG1, ""], nil, false]
		], _codeOnLoad, _codeOnUnload
	] call Phobos_fnc_showChooseDialog;
		
if (count _chatResult == 0) exitWith {[format ["User aborted modification process of Cam properties: %1", _camFullName]] call Phobos_fnc_logMessage;};


_camNewPosition = _chatResult select 0;
_camNewTarget = _chatResult select 1;
_camNewIsAttached = if (_chatResult select 2 == 0) then {true} else {false};
_camNewCommitTime = parseNumber (_chatResult select 3); //Comes as string from rscEdit
_camNewWaitBeforeCommit = parseNumber (_chatResult select 4); //Comes as string from rscEdit
_camNewFov = _chatResult select 5;
_camNewFocus = _chatResult select 6;
_camNewAperture = _chatResult select 7;
_camNewBrightness = _chatResult select 8;
_camNewContrast = _chatResult select 9;
_camNewSaturation = _chatResult select 10;
_camNewDayTime = /*_chatResult select 11*/ -0.01;
_camNewOvercast = /*_chatResult select 12*/ -0.01;
_camNewRain = /*_chatResult select 13*/ -0.01;
_camNewFog = /*_chatResult select 14*/ -0.01;
_camNewVisionMode = _chatResult select 11;
_camNewCode = _chatResult select 12;

_camNewProperties = [
	_camNewPosition,
	_camNewTarget,
	_camNewIsAttached,
	_camNewCommitTime,
	_camNewWaitBeforeCommit,
	_camNewFov,
	_camNewFocus,
	_camNewAperture,
	_camNewBrightness,
	_camNewContrast,
	_camNewSaturation,
	_camNewDayTime,
	_camNewOvercast,
	_camNewRain,
	_camNewFog,
	_camNewVisionMode,
	_camNewCode
];


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Return feedback to player regarding parameters' validity.(Position and Target)

//If below are undefined, it means that player didn't touch regarding option, so it is valid.
_isValidPosition = missionNamespace getVariable ['Phobos_ChooseDialog_isValidPosition', true];
_isValidTarget = missionNamespace getVariable ['Phobos_ChooseDialog_isValidTarget', true];
_feedbackValue = 0;
//TODO: Fix this ugliness below, turn it to bitwise sum checking.
if (!_isValidPosition && _isValidTarget) then {_feedbackValue = 1};
if (_isValidPosition && !_isValidTarget) then {_feedbackValue = 2};
if (!_isValidPosition && !_isValidTarget) then {_feedbackValue = 3};

switch (_feedbackValue) do {
	case 1: {
		["Illegal Position format, old position is kept active."] call Ares_fnc_showZeusMessage;
		["Illegal Position format detected, old position is kept active for cam: %1", _camFullName] call Phobos_fnc_logMessage;
	};
	
	case 2: {
		["Illegal Target format, old target is kept active."] call Ares_fnc_showZeusMessage;
		["Illegal Target format detected, old target is kept active for cam: %1", _camFullName] call Phobos_fnc_logMessage;
	};
	
	case 3: {
		["Illegal Position and Target format, old values are kept active."] call Ares_fnc_showZeusMessage;
		["Illegal Position and Target format, old values are kept active for cam: %1", _camFullName] call Phobos_fnc_logMessage;
	};
};

//Neutralize these values for next use.
missionNamespace setVariable ['Phobos_ChooseDialog_isValidPosition', nil];
missionNamespace setVariable ['Phobos_ChooseDialog_isValidTarget', nil];
	
[_cutsceneName, _camID, _camNewProperties] call Phobos_fnc_camSetProperties;
["CamModificationSucceeded", [_camFullName]] call BIS_fnc_showNotification;
