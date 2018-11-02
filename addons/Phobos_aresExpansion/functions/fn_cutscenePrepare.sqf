//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Grabs properties of created cameras and generates the SQF and import code of cutscene.(It doesn't start cutscene!)
// Changelog: None.
// Notes: Bug: [Extract Mode]Relative objects create new variables, is not compatible with another session. (Fixed, Untested)
// Pending tests: Bug fix above(Update: Pending) and non-attached object based position calculation fix(Update: Fixed).
//////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\includes\cinematics.inc"
#define ID_ERROR_NO_CAMERA_FOUND -1

#define STR_1TAB	"    "
#define STR_2TAB	(STR_1TAB + STR_1TAB)
#define STR_3TAB	(STR_1TAB + STR_1TAB + STR_1TAB)

private _cutsceneName = _this select 0;
private _extractMode = _this param [1, false, [false]];

private _cutsceneCams = [];
for [{_i = MIN_CAMERA_WAYPOINT}, {_i < MAX_CAMERA_WAYPOINT}, {_i = _i + 1}] do {
	_camIndexExists = [_cutsceneName, _i] call Phobos_fnc_camExists;
	if (_camIndexExists) then {
		_cutsceneCams pushBack [_cutsceneName, _i];
	};
};

//Just in case some cams were created but got broken due conditions unmet.
if (count _cutsceneCams == 0) exitWith {["No camera available to create a cutscene."] call Phobos_fnc_logMessage; ID_ERROR_NO_CAMERA_FOUND;};

/*
//Removed Feature. 
private _daytimeChangeExist = false;
{
	_camProperties = _x call Phobos_fnc_camGetProperties;
	if (_camProperties select 11 > 0) then {
		_daytimeChangeExist = true;
	};
} forEach _cutsceneCams;
*/

private _output = [];
private _objects = [];//Objects that are required to be broadcasted to players if its extracted.(Related to cam pos/targets dependency on objects.) 

private _cam = format ["%1", _cutsceneName]; //Camera's name.
if (!_extractMode) then {
	_curatorID = allCurators find (getAssignedCuratorLogic player); //To prevent multiple cutscenes with same names to ruin things in case they're used at the same time.
	_cam = format ["%1_%2", _cutsceneName, _curatorID]; 
};
private _ppColorCorrectionHandle = format ["%1_PPColorCorrectionHandle", _cam]; //ppEffect's name.

//Declare some variables that we will use for position related codes.
_isCamAttachCodePlaced = false; //var to check if camAttach code is printed. (Pastes function once then reuses that for shorter code generation.)
_isCamRelPosCodePlaced = false; //same thing for relative position version.
_handleSleepNextCamera = false; //handler for next sleep.

//Retrieve data and do the show magic.
{
	//Retrieve camera attributes.
	_camProperties = _x call Phobos_fnc_camGetProperties;
	
	_camPosition = _camProperties select 0;
	_camTarget = _camProperties select 1;
	_camIsAttached = _camProperties select 2;
	_camCommitTime = _camProperties select 3;
	_camWaitBeforeCommit = _camProperties select 4;
	_camFov = _camProperties select 5;
	_camFocus = _camProperties select 6;
	_camAperture =_camProperties select 7;
	_camBrightness = _camProperties select 8;
	_camContrast = _camProperties select 9;
	_camSaturation = _camProperties select 10;
	_camDayTime = _camProperties select 11;
	_camOvercast = _camProperties select 12;
	_camRain = _camProperties select 13;
	_camFog = _camProperties select 14;
	_camVisionType = _camProperties select 15;
	_camCode = _camProperties select 16;
	
	[format ["_cam: %1", _x]] call Phobos_fnc_logMessage;
	[format ["_camProperties: %1", _camProperties]] call Phobos_fnc_logMessage;
	
	//Retrieve previous camera attributes if exists.(To compare attributes and prevention of executing the already same ones.)
	private ["_camPrevious", "_camPreviousProperties", "_camPreviousPosition", "_camPreviousTarget", "_camPreviousIsAttached", "_camPreviousCommitTime", "_camPreviousWaitBeforeCommit", "_camPreviousFov", "_camPreviousFocus", "_camPreviousAperture", "_camPreviousBrightness", "_camPreviousContrast", "_camPreviousSaturation", "_camPreviousDayTime", "_camPreviousOvercast", "_camPreviousRain", "_camPreviousFog", "_camPreviousVisionType", "_camPreviousCode"];
	if (_forEachIndex != 0) then {
		_camPreviousProperties = (_cutsceneCams select (_forEachIndex - 1)) call Phobos_fnc_camGetProperties;
		
		_camPreviousPosition = _camPreviousProperties select 0;
		_camPreviousTarget = _camPreviousProperties select 1;
		_camPreviousIsAttached = _camPreviousProperties select 2;
		_camPreviousCommitTime = _camPreviousProperties select 3;
		_camPreviousWaitBeforeCommit = _camPreviousProperties select 4;
		_camPreviousFov = _camPreviousProperties select 5;
		_camPreviousFocus = _camPreviousProperties select 6;
		_camPreviousAperture =_camPreviousProperties select 7;
		_camPreviousBrightness = _camPreviousProperties select 8;
		_camPreviousContrast = _camPreviousProperties select 9;
		_camPreviousSaturation = _camPreviousProperties select 10;
		_camPreviousDayTime = _camPreviousProperties select 11;
		_camPreviousOvercast = _camPreviousProperties select 12;
		_camPreviousRain = _camPreviousProperties select 13;
		_camPreviousFog = _camPreviousProperties select 14;
		_camPreviousVisionType = _camPreviousProperties select 15;
		_camPreviousCode = _camPreviousProperties select 16;
	};
	
	//Retrieve next camera sleep time. (May be required if camera is attached so while loop has to be longer if next camera has sleep.)
	_camNextWaitBeforeCommit = 0;
	if (_forEachIndex != ((count _cutsceneCams) - 1)) then {
		_camNextProperties = (_cutsceneCams select (_forEachIndex + 1)) call Phobos_fnc_camGetProperties;
		_camNextWaitBeforeCommit = _camNextProperties select 4;
	};
	
	
	//Create beginning of code.
	if (_forEachIndex == 0) then {
		//If being extracted, create parameters that player will be able to choose, and the beginning of code.(Otherwise we'll call parameters and remote execution from modules.)
		if (_extractMode) then {
			_output pushBack format ["[] call {%1", endl];
		};
		//Define values for remoteExec and for _cutsceneCode.
		_output pushback format ["%1private _viewers = _this param [0, allPlayers - (entities 'HeadlessClient_F'), [[]]];%2%1private _lengthMultiplier = _this param [1, 1, [0]];%2%1private _music = _this param [2, '', ['']];%2%1private _musicVolume = _this param [3, musicVolume, [0]];%2%1private _execScripts = _this param [4, true, [true]];%2", STR_1TAB, endl];
		//Put a placeholder here, it will later be used to stream all objects.
		if (_extractMode) then {
			_output pushback "<PLACEHOLDER>";
		};
		//Define values inside _cutsceneCode.
		_output pushBack format ["%3%1private _cutsceneCode = {%3%2private _viewers = _this select 0;%3%2private _lengthMultiplier = _this select 1;%3%2private _music = _this select 2;%3%2private _musicVolume = _this select 3;%3%2private _execScripts = _this select 4;%3", STR_1TAB, STR_2TAB, endl];
		//Create new camera and ppEffect if first camera waypoint.
		_output pushBack format ["%2%1 = 'camera' camCreate [0,0,0];%3", _cam, STR_2TAB, endl];
		//Create ppEffect.
		_output pushBack format ["%2_i = 0;%4%2%1 = -1;%4%2while {%1 < 0} do {%4%3%1 = ppEffectCreate ['colorCorrections', 3000 + _i];%4%3_i = _i + 1;%4%2};%4%2%1 ppEffectEnable true;%4", _ppColorCorrectionHandle, STR_2TAB, STR_3TAB, endl];
	};
	
	//Target
	//TODO: Provide relative position targeting.
	//Check if it is a variable or array.
	if (_camTarget isEqualType "") then {
		// Target: object
		//Create a public unique variable.(Since it is a code that is being streamed, we need public variables.)
		private '_objectPublicVar';
		if (_extractMode) then {
			_objectPublicVar = _camTarget; //Extract mode cannot support Public Variable, pass it as it is and broadcast it.(We do not support multiple cutscenes with same name on non-Phobos environments.)
			_objects pushBack _objectPublicVar;
		} else {
			_object = missionNamespace getvariable [_camTarget, objNull];
			_objectPublicVar = [_object] call BIS_fnc_objectVar;
		};
		_output pushBack format ["%3%1 camSetTarget %2;%4", _cam, _objectPublicVar, STR_2TAB, endl];
	} else {
		//Target: Position
		_output pushBack format ["%3%1 camSetTarget %2;%4", _cam, _camTarget, STR_2TAB, endl];
	};
	
	//CamFov 
	if (_forEachIndex == 0 || {_camPreviousFov != _camFov}) then {
		_output pushBack format ["%3%1 camSetFov %2;%4", _cam, _camFov, STR_2TAB, endl];
	};
	
	//CamFocus
	if (_forEachIndex == 0 || {_camPreviousFocus != _camFocus}) then {
		if (_camFocus == 0) then {
			_output pushBack format ["%2%1 camSetFocus [-1,1];%3", _cam, STR_2TAB, endl];
		} else {
			_output pushBack format ["%3%1 camSetFocus [%2,1];%4", _cam, _camFocus, STR_2TAB, endl];
		};
	};
	
	//Transfer player to camera if its first cam with a little mystery(fade screen).
	//We are playing the entire cutscene for all players in the background so cutscenes with scripts can use isServer and local commands without any dependency on who is watching.(3Den style scripting.)
	//It may change if performance is actually taking a hit although most likely not.(Note to myself: Use parser on script for such commands if decide to change and play the cutscene for associated machines.)
	if (_forEachIndex == 0) then {
		_musicFadeTime = 0;
		_output pushBack format ["%3if (player in _viewers && {!(missionNamespace getVariable ['Phobos_Cutscene_isPlayerWatchingAnyCutscene', false])}) then {%5%4missionNamespace setVariable ['Phobos_Cutscene_isPlayerWatchingAnyCutscene', true];%5%4'%1_transaction' call BIS_fnc_blackOut;%5%4uiSleep 2;%5%4%1 cameraEffect ['Internal','Back'];%5%4if (!(_music isEqualTo '')) then {playMusic _music;};%5%4%2 fadeMusic _musicVolume;%5%4'%1_transaction' call BIS_fnc_blackIn;%5%3};%5", _cam, _musicFadeTime, STR_2TAB, STR_3TAB, endl]; 
	};
	
	//Code
	if (_camCode != "") then {
		_output pushBack format ["%5if (_execScripts) then {%7%6[%1, %2, %3, [_viewers, _lengthMultiplier, _music, _musicVolume]] spawn %4;%7%5};%7", _cam, _ppColorCorrectionHandle, _camProperties, compile _camCode, STR_2TAB, STR_3TAB, endl];
	};
	
	//PP(brightness, contrast, saturation)
	if (_forEachIndex == 0 || {_camPreviousBrightness != _camBrightness} || {_camPreviousContrast != _camContrast} || {_camPreviousSaturation != _camSaturation}) then {
		_output pushBack format ["%5%1 ppEffectAdjust [1,%2,%3,[1,1,1,0],[1,1,1,%4],[0.75,0.25,0,1]];%6", _ppColorCorrectionHandle, _camBrightness, _camContrast, _camSaturation, STR_2TAB, endl];
	};
	
	//Wait before commit.
	if (!isNil "_handleSleepNextCamera" && {_handleSleepNextCamera}) then {
		//Turn sleep handler off and do nothing.(Attached camera wont enter this scope due outer scope already checks if its handled by attached so it is only next camera that will enter this scope.)
		_handleSleepNextCamera = false;
	} else {
		if (_forEachIndex != 0) then {
			_output pushBack format ["%2uiSleep (%1 * _lengthMultiplier);%3", _camWaitBeforeCommit, STR_2TAB, endl];
		};
	};
	
	_isCamCommitHandledByAttached = false; //var to check if camCommit and camSleep are handled by an attached object.
	_isCamCommitHandledByRelPos = false; //same thing for relative position version.
	if (_camPosition isEqualTypeArray [toString [0], [0,0,0]]) then {
		// Relative Position = [relObject, [x,y,z]]
		//Create a public unique variable.(Since it is a code that is being streamed, we need public variables.)
		private '_relativeObjectPublicVariable';
		if (_extractMode) then {
			_relativeObjectPublicVariable = _camPosition select 0; //Extract mode cannot support Public Variable, pass it as it is.
			_objects pushBack _relativeObjectPublicVariable;
		} else {
			_relativeObject = missionNamespace getVariable [_camPosition select 0, objNull];
			_relativeObjectPublicVariable = [_relativeObject] call BIS_fnc_objectVar;
		};
		_position = _camPosition select 1;
		
		//_objects pushBack _relativeObject;
		if (_camIsAttached) then {
			if (!_isCamAttachCodePlaced) then {
				_isCamCommitHandledByAttached = true;
				_isCamAttachCodePlaced = true;
				_handleSleepNextCamera = true; //We handle next sleep aswell by expanding our while loop into next sleep time. So on next camera, we should suspend the sleep otherwise we would cause a 2x _camWaitBeforeCommit sleep.
				_output pushBack format ["%2_camAttachCode = {%4%3_camera = _this select 0;%4%3_relObject = _this select 1;%4%3_relPosition = _this select 2;%4%3_lengthMultiplier = _this select 3;%4%3_commitTime = (_this select 4) * _lengthMultiplier;%4%3_sleepTime = (_this select 5) * _lengthMultiplier;%4%3_isFirstCamera = _this select 6;%4%4%3_timeStart = diag_tickTime;%4%3private '_timeStop';%4%3while {%4%3%1_timeStop = diag_tickTime;%4%3%1(_timeStop - _timeStart) < (_commitTime + _sleepTime);%4%3} do {%4%3%1_posX = ((position _relObject) select 0) + (_relPosition select 0);%4%3%1_posY = ((position _relObject) select 1) + (_relPosition select 1);%4%3%1_posZ = ((position _relObject) select 2) + (_relPosition select 2);%4%3%1_finalPos = [_posX, _posY, _posZ];%4%3%1_timeDifference = _timeStop - _timeStart;%4%3%1_dynamicCommitTime = (_commitTime - _timeDifference);%4%3%1_camera camSetPos _finalPos;%4%3%1if (_isFirstCamera) then {%4%3%2_camera camCommit 0;%4%3%1};%4%3%1if (_dynamicCommitTime > 0.1) then {%4%3%2_camera camCommit _dynamicCommitTime;%4%3%1} else {%4%3%2_camera camCommit 0.1;%4%3%1};%4%3};%4%2};%4", STR_1TAB, STR_2TAB, STR_3TAB, endl];
				//Attaching camera to a moving object shakes camera a lot, this is a little nasty but satisfying work around. It also is more helpful as its easier to make a smooth transition.
			};
			//Use the function above that was printed at some point.
			if (_forEachIndex == 0 || {_camPreviousBrightness != _camBrightness} || {_camPreviousContrast != _camContrast} || {_camPreviousSaturation != _camSaturation}) then {
				_output pushBack format ["%3%1 ppEffectCommit %2;%4", _ppColorCorrectionHandle, _camCommitTime,STR_2TAB, endl];
			};
			_output pushBack format ["%8[%1, %2, %3, _lengthMultiplier, %4, %7, %6] call _camAttachCode;%9", _cam, _relativeObjectPublicVariable, _position, _camCommitTime, _camWaitBeforeCommit, _forEachIndex == 0, _camNextWaitBeforeCommit, STR_2TAB, endl];
		} else {
			if (!_isCamRelPosCodePlaced) then {
				_isCamRelPosCodePlaced = true;
				//To retrieve the object's that moment's position, this code has to be inside generated code. Otherwise we would just be grabbing initial point of it which pretty much destroys the purpose.
				_output pushBack format ["%1_camRelPosCode = {%3%2_cam = _this select 0;%3%2_relObject = _this select 1;%3%2_relPosition = _this select 2;%3%3%2_finalPosX = ((position _relObject) select 0) + (_relPosition select 0);%3%2_finalPosY = ((position _relObject) select 1) + (_relPosition select 1);%3%2_finalPosZ = ((position _relObject) select 2) + (_relPosition select 2);%3%3%2_finalPos = [_finalPosX, _finalPosY, _finalPosZ];%3%2_cam camSetPos _finalPos;%3%1};%3", STR_2TAB, STR_3TAB, endl];
			};
			_output pushBack format ["%4[%1, %2, %3] call _camRelPosCode;%5", _cam, _relativeObjectPublicVariable, _position, STR_2TAB, endl];
		};
	} else {
		// Position == [x,y,z]
		_position = _camPosition;
		_output pushBack format ["%3%1 camSetPos %2;%4",_cam, _position, STR_2TAB, endl];
	};
	
	//CommitTime
	if (_forEachIndex == 0 && !_isCamCommitHandledByAttached) then {
		_output pushBack format ["%2%1 camCommit 0;%3",_cam, STR_2TAB, endl];
	} else {
		_output pushBack format ["%3%1 camCommit (%2 * _lengthMultiplier);%4",_cam ,_camCommitTime, STR_2TAB, endl];
	};
	
	//ppEffectCommit
	if (!_isCamCommitHandledByAttached && (_forEachIndex == 0 || {_camPreviousBrightness != _camBrightness} || {_camPreviousContrast != _camContrast} || {_camPreviousSaturation != _camSaturation})) then {
		_ppEffectCommitTime = _camCommitTime;
		if (_forEachIndex == 0) then {
			_output pushBack format ["%2%1 ppEffectCommit 0;%3", _ppColorCorrectionHandle, STR_2TAB, endl];
		} else {
			_output pushBack format ["%3%1 ppEffectCommit (%2 * _lengthMultiplier);%4", _ppColorCorrectionHandle, _ppEffectCommitTime, STR_2TAB, endl];
		};
	};
	
	//Aperture 
	if (_forEachIndex == 0 || {_camPreviousAperture != _camAperture}) then {
		_output pushBack format ["%2setAperture %1;%3", _camAperture, STR_2TAB, endl]; //0 and -1 looks like having same effect unlike setFocus.
	};
	
	//Daytime
	//Removed Feature.
	/*
	if (_foreachIndex == 0 || {_camPreviousDayTime != _camDayTime}) then {
		if (_camDayTime == 0) then {
			//Nothing to do here right? 0 is default value, change nothing.
		} else {
			private _simHour = _camDayTime / 60;
			private _simMin = _camDayTime mod 60;
			<Comment Start>
			To change daytime, we need to know if host is going to be part of this daytime change. If yes, we need to change 
			host's time and simulate non-cutscene affected players.
			
			We want code to stay independent from players. As user may decide to generate code and use later in different conditions, so logic should be inside output.
			Therefore:
			The following code is generated instead of being part of the function to support player to use the code anytime, anywhere instead of limiting parameters to that moment's conditions.
			Note: The variable; Phobos_fnc_cutscenePrepare_players is an abstract variable, is not defined until execution phase of cutscene.
			
			--------------------------------------------------------------------------------------------------------------------------------------
			Note on _serverCode: Just checks if host is part of this cutscene.
			
			--------------------------------------------------------------------------------------------------------------------------------------
			Note on _clientNonParticipantCode: This is for a client that doesn't see this cutscene. It should be taken into consideration that a player who is not part of this cutscene may or may not be part of another cutscene, and for that, daytime should be taken care of cautiously. 
			
			*This code should only be executed if host is part of the cutscene. (Host can only be part of one cutscene obviously, forcing this player to take care of their own daytime.)
			*Daytime change for this client should ONLY occur if there is no other cutscene, otherwise 2 codes for 2 different daytimes will be forced to show to client. 
			
			Code's Logic is as follows, and may be FLAWED.
			
			(X means Question doesnt matter.)
			QUESTION: Is Host part of THIS cutscene?
			CASE: TRUE
				QUESTION: Is another cutscene going on?
				CASE: TRUE
					QUESTION: Is player part of ANOTHER cutscene? 
					CASE: TRUE
						*Do NOT change time UNTIL cutscene is over.(MODIFY ENDING TIME, Host may still be inside a cutscene, unable to sync this player into actual time.)
						QUESTION: Is Host part of ANOTHER cutscene? X
						CASE: TRUE
							IMPOSSIBLE CASE, HOST CANNOT BE PART OF 2 CUTSCENES.
						CASE: FALSE
							*Do nothing, player is already handled by host(Host sets player time in previous cutscene).
					CASE: FALSE
						*Loop host's current time on player.
						QUESTION: Is host part of ANOTHER cutscene? X (Impossible question: host cannot be in 2 cutscenes.)
				CASE: FALSE
					*Daytime change for this client should ONLY occur if there is no other cutscene, otherwise 2 codes for 2 different daytimes will be forced to show to client.
					QUESTION: Is player part of ANOTHER cutscene? X (Impossible question: another cutscene doesn't exist.)
					QUESTION: Is host part of ANOTHER cutscene? X (Impossible question: another cutscene doesn't exist.)
			CASE: FALSE
				QUESTION: Is another cutscene going on?
				CASE: TRUE
					QUESTION: Is player part of ANOTHER cutscene?
					CASE: TRUE
						*Do NOT change time UNTIL cutscene is over.(MODIFY ENDING TIME, Host may still be inside a cutscene, unable to sync this player into actual time.)
						QUESTION: Is Host part of ANOTHER cutscene? X (Doesn't matter as long as we cannot be sure if player and host are in another same cutscene.)
					CASE: FALSE
						QUESTION: Is Host part of ANOTHER cutscene? X )
						CASE: TRUE
							*Extend looping ACTUAL TIME till every cutscenes finish.
						CASE: FALSE
							*Do nothing, host and this player will be handled by ACTUAL TIME.
				CASE: FALSE
					
			
			
			
			Required functions: 
			Check all active cutscenes. From every single Zeus.
			Calculate cutscene length, to learn which one finishes first.
			Request actualTime from Host, handle host may be in a cutscene or not, so save those datas in var or request actual if he is not in a cutscene.
			--------------------------------------------------------------------------------------------------------------------------------------
			Note on _clientParticipantCode: This is for a client that sees this cutscene. It should be taken into consideration that a player who is part of this cutscene cannot be a part of another cutscene, therefore only what happens in here, affects this player. However if another cutscene goes on and host is part of that cutscene, the player should deactivate the _clientNonParticipantCode that comes from previous cutscene.
			
			*Daytime change for this client should ALWAYS(considering daytime change exists) occur.
			*This code should deactivate any _clientNonParticipantCode daytime change to loop out and change its own daytime IF daytime changes in this cutscene.
			*This code should only be executed IF host is not part of the cutscene. (Host may not be part of multiple cutscenes.)
			
			QUESTION: Is Host part of THIS cutscene?
			CASE: TRUE
				Do nothing, player is in sync with host. Host will change time and player will have that change aswell.
			CASE: FALSE
				Loop the camera time.
			
			ATTENTION: CODE BELOW DO NOT RERPESENT THE LOGIC ABOVE.(Incomplete Code)
			<Comment End>
			_output pushback format ["
				private _actualHour = date select 3;
				private _actualMin = date select 4;
				
				//IF HOST PART OF CUTSCENE
				_clientNonParticipantCode = {
					private _hour = _this select 0;
					private _min = _this select 1;
					//IF HOST PART OF CUTSCENE
					comment 'There is an issue here, if more than 1 cutscene starts, this gonna be handled but the moment one of them finish, it will switch time for non participants and loop it(Problem is it will be noticed.)'; 
					waitUntil {Phobos_fnc_cutscenePrepare_activeCutsceneCount == 1};
					while {Phobos_fnc_cutscenePrepare_activeCutsceneCount == 1} do { 
						setDate ((Phobos_fnc_cutscenePrepare_actualDayTime select [0,3] + [_hour, _min]));
					};
				};
				
				_clientParticipantCode = {
					private _hour = _this select 0;
					private _min = _this select 1;
					waitUntil {Phobos_fnc_cutscenePrepare_changeDaytime};
					while {Phobos_fnc_cutscenePrepare_changeDaytime} do {
						
					};
				};
				
				Phobos_fnc_cutscenePrepare_isHostPartOfCutscene = false;
				_serverCode = {
					_cutscenePlayers = _this select 0;	
					{
						if ((owner _x) == 2) then {
							[[],{Phobos_fnc_cutscenePrepare_isHostPartOfCutscene = true;}] remoteExec ['call', remoteExecutedOwner];
						};
					} forEach _cutscenePlayers;
				};
				
				[[Phobos_fnc_cutscenePrepare_players], _serverCode] remoteExecCall ['call' , 2];
				
				if (Phobos_fnc_cutscenePrepare_isHostPartOfCutscene) then {
					[[%1, %2], {setDate ((Phobos_fnc_cutscenePrepare_actualDayTime select [0,3]) + [_this select 0, _this select 1])}] remoteExecCall ['call', 2];
					private _nonCutscenePlayers = allPlayers - Phobos_fnc_cutscenePrepare_players;
					[[_actualHour, _actualMin], _clientCode] remoteExec ['call', _nonCutscenePlayers];
				} else {
					[[%1, %2], _clientCode] remoteExec ['call', Phobos_fnc_cutscenePrepare_players];
				};",
				_simHour, _simMin]
		};
	};
	*/
	//Overcast
	
	//Vision Type
	if (_forEachIndex == 0 || {_camPreviousVisionType != _camVisionType}) then {
		private _outputString = "";
		switch (_camVisionType) do {
			case 0: {_outputString = format ["%1camUseNVG false;%2%1false setCamUseTI 0;%2", STR_2TAB, endl]};
			case 1: {_outputString = format ["%1camUseNVG true;%2%1false setCamUseTI 0;%2", STR_2TAB, endl]};
			default {_outputString = format ["%2camUseNVG false;%3%2true setCamUseTI %1;%3", _camVisionType - 2, STR_2TAB, endl]};
		};
		_output pushBack _outputString;
	};
	
	//Wait while camCommit is active.
	if (_forEachIndex != 0 && _forEachIndex != ((count _cutsceneCams) - 1) && !_isCamCommitHandledByAttached) then { //Commit time is 0 for 1st cam. Last cam handled by termination code.
		_output pushBack format ["%2uiSleep (%1 * _lengthMultiplier);%3", _camCommitTime, STR_2TAB, endl];
	};
	
	//End the cutscene.
	if (_forEachIndex == ((count _cutsceneCams) - 1)) then {
		_blackOutTime = INT_CAMERA_OUTRO_LENGTH;
		_output pushBack format ["%7uiSleep ((%2 * _lengthMultiplier) - %4);%9%7if (player in _viewers) then {%9%8'%1_transaction' call BIS_fnc_blackOut;%9%8uiSleep %4;%9%8if (!isNull curatorCamera) then {%9%8%6curatorCamera cameraEffect ['Internal','Back'];%9%8} else {%9%8%6%1 cameraEffect ['Terminate','Back'];%9%8};%9%8'%1_transaction' call BIS_fnc_blackIn;%9%8camDestroy %1;%9%8ppEffectDestroy %5;%9%8setAperture -1;%9%8missionNamespace setVariable ['Phobos_Cutscene_isPlayerWatchingAnyCutscene', false];%9%7};%9%6};%9%6[[_viewers, _lengthMultiplier, _music, _musicVolume, _execScripts], _cutsceneCode] remoteExec ['spawn'];%9",_cam, _camCommitTime, _camWaitBeforeCommit, _blackOutTime, _ppColorCorrectionHandle, STR_1TAB, STR_2TAB, STR_3TAB, endl];
		//Fill in the ending of the extracted code.
		if (_extractMode) then {
			_output pushback format ["};%1", endl];
		};
	};
} forEach _cutsceneCams; 

//Remove placeholder, stream objects.
if (_extractMode) then {
	_string = "";
	if (count _objects > 0) then {
		_string = format ['%2{publicVariable _x;} forEach %1;%3', _objects, STR_1TAB, endl];
	};
	_output set [2, _string];
};

private _code = "";
{
	_code = _code + _x;
	[_x, nil, nil, false] call Phobos_fnc_logMessage;
} forEach _output;

_code;




