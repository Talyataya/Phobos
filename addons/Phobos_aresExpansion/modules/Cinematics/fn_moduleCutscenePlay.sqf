//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Prepares the cutscene according to desired parameters and plays the cutscene to curator(s) and player(s).(Module)
// Changelog: None.
// Notes: Mostly the same(copied) from fn_modulesCutscenePreview.sqf
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"
#include "\Phobos_aresExpansion\includes\cinematics.inc"

#define ID_CUTSCENE_INDEX 0 //Points cutsceneName choiceIndex.

["User initialized the cutscene preview module."] call Phobos_fnc_logMessage;
private _allCutscenes = [] call Phobos_fnc_cutsceneGetAll;
if (count _allCutscenes <= 0) exitWith {
	["No cutscene in cutscene list was found. Create a cutscene first."] call Ares_fnc_showZeusMessage;
	["No cutscene in cutscene list was found. Aborting module process."] call Phobos_fnc_logMessage;
};


//Retrieve Sitrep from curators, curators will actively be reporting their situation.(ie. if available or remote controlling a unit.)
 _curatorLogics = allCurators;
 _curatorUnits = []; //All curators (AI or Player), Reason: A player might use selectPlayer(future feature) instead of remote control.
//Arrays below are parallel.
 _curatorPlayers = []; //All curators that are present on curator units.
 _curatorSitrepVars = []; //Variables assigned to remote curators.

 _viewers = []; //Info that will appear on rscCombo.

{
	_curatorUnits pushBack (getAssignedCuratorUnit _x);
} forEach _curatorLogics;

{
	if (_x in (allPlayers - (entities "HeadlessClient_F"))) then {
		_curatorPlayers pushBack _x;
	};
} foreach _curatorUnits;

//Take sitrep of curators continuously and update user. (Broadcaster)
_curatorSitrep = {
	_curatorID = _this select 0; //Id assigned to the remote curator.
	_requestID = _this select 1; //Id assigned to the request.
	missionNamespace setVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], true];
	private _rcVar = format ["Phobos_fnc_cutscenePlay_isRemoteControlling_id%2%1", _curatorID, _requestID];
	//Broadcast first answer.
	if (isNull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])) then {
		[[_rcVar], {_rcVar = _this select 0; missionNamespace setVariable [_rcVar, false];}] remoteExec ["call", remoteExecutedOwner];
	} else {
		[[_rcVar], {_rcVar = _this select 0; missionNamespace setVariable [_rcVar, true];}] remoteExec ["call", remoteExecutedOwner];
	};
	//Broadcast rest of answers.
	while {missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], false]} do {
		if (isNull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])) then {
			waitUntil {(!isNull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])) || (!(missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], false]))};
			if (!(missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], false])) exitWith {}; //Terminate broadcaster.
			[[_rcVar], {_rcVar = _this select 0; missionNamespace setVariable [_rcVar, true];}] remoteExec ["call", remoteExecutedOwner];
		} else {
			waitUntil {(isNull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])) || (!(missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], false]))};
			if (!(missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], false])) exitWith {}; //Terminate broadcaster.
			[[_rcVar], {_rcVar = _this select 0; missionNamespace setVariable [_rcVar, false];}] remoteExec ["call", remoteExecutedOwner];
		};
	};
};

//Create the curators' list.
_requestID = -1;
if (count _curatorPlayers > 1) then {
	_viewers pushBack "All Curators";
	_viewers pushBack "No Curators";
	{
		_viewers pushBack (name _x);
		_curatorID = _forEachIndex;
		//Make a public variable that holds the count of requestIDs. (Prevents multiple people from confusing the variables.)
		_requestID = missionNamespace getVariable ["Phobos_fnc_cutscenePlay_RCRequestIDRegister", 0];
		_curatorSitrepVars pushBack (format ["Phobos_fnc_cutscenePlay_isRemoteControlling_id%2%1", _curatorID, _requestID]);
		[format ["Populating: _curatorSitrepVars: %1", _curatorSitrepVars], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		[[_curatorID, _requestID], _curatorSitrep] remoteExec ["spawn", _x];
		[format ["Local Code Report: _curatorID: %1 _requestID: %2", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
	} forEach _curatorPlayers;
	missionNamespace setVariable ["Phobos_fnc_cutscenePlay_RCRequestIDRegister", _requestID + 1];
	publicVariable "Phobos_fnc_cutscenePlay_RCRequestIDRegister";
} else {
	_viewers pushBack "No Curators";
	_viewers pushBack (name player);
};
[format ["Viewers: %1", _viewers]] call Phobos_fnc_logMessage;

_code11 = {
	_choiceIndex = _this select 0;
	_listbox = _this select 2;
	
	//If player is alone, change default value to player.
	if (count _curatorPlayers == 1) exitWith { 
		_playerIndex = 1; 
		_listBox lbSetCurSel _playerIndex;
		missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choiceIndex], _playerIndex];
	};
	
	//If multiple curators... read broadcasters and update ctrls and values.
	{
		//Take sitrep of curators continuously and update user. (Listener)
		_curatorID = _forEachIndex;
		[_curatorID, _requestID, _curatorPlayers, _listBox] spawn {
			private _curatorID = _this select 0;
			private _requestID = _this select 1;
			private _curatorPlayers = _this select 2;
			private _listBox = _this select 3;
			[format ["Deploying local variable listener for id%2%1.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
			while {missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], false]} do {
				if (missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_isRemoteControlling_id%2%1", _curatorID, _requestID], false]) then {
					[format ["Listener[%2%1]: Remotecontrolling, waiting for leaving remotecontrolling.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
					waitUntil {!(missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_isRemoteControlling_id%2%1", _curatorID, _requestID], false])};
					_listbox lbSetText [_curatorID + 2, format ["%1 (Available)", name (_curatorPlayers select _curatorID)]]; //+2 for All Curators + No Curators options.
					[format ["Listener[%2%1]: RemoteControl Deactivation Detected. ListBox updated curator as Available.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
				} else {
					[format ["Listener[%2%1]: No remotecontrolling, waiting for remotecontrolling.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
					waitUntil {missionNamespace getVariable [format ["Phobos_fnc_cutscenePlay_isRemoteControlling_id%2%1", _curatorID, _requestID], false]};
					_listbox lbSetText [_curatorID + 2, format ["%1 (Remote Controlling)", name (_curatorPlayers select _curatorID)]]; //+2 for All Curators + No Curators options.
					[format ["Listener[%2%1]: RemoteControl Activation Detected. ListBox updated curator as Remote Controlling.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
				};
			};
		};
		[format ["Local variable listener deployed for id%2%1.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		//Take sitrep for the first time(and in case sitrep returned back before EH deployed).
		waitUntil {typeName (missionNamespace getVariable [_x, -1]) isEqualTo "BOOL"};
		if (missionNamespace getVariable _x) then {
			_listbox lbSetText [_curatorID + 2, format ["%1 (Remote Controlling)", name (_curatorPlayers select _curatorID)]]; //+2 for All Curators + No Curators options.
			[format ["First Detection[%2%1]: Curator is Remote Controlling. Listbox updated.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		} else {
			_listbox lbSetText [_curatorID + 2, format ["%1 (Available)", name (_curatorPlayers select _curatorID)]]; //+2 for All Curators + No Curators options.
			[format ["First Detection[%2%1]: Curator is Available. Listbox Updated.", _curatorID, _requestID], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
		};
	} forEach _curatorSitrepVars;
};

_code31 = {
	_choiceIndex = _this select 0;
	_titleBox = _this select 1;
	_textBox = _this select 2;
	_choiceIndexCutscene = ID_CUTSCENE_INDEX;
	
	
	[_choiceIndex, _titleBox, _textBox, _choiceIndexCutscene, _allCutscenes] spawn {
		_choiceIndex = _this select 0;
		_titleBox = _this select 1;
		_textBox = _this select 2;
		_choiceIndexCutscene = _this select 3;
		_allCutscenes = _this select 4;
		_currentRetrievedCutsceneID = -1; //-1 to run below once since we'll have a value > -1 due cutscene will be set till this code runs.
		missionNamespace setVariable ["Phobos_fnc_cutscenePlay_doListenCutsceneName", true];
		while {missionNamespace getVariable ["Phobos_fnc_cutscenePlay_doListenCutsceneName", false]} do {
			//isEqualTo used below to suppress unnecessary error
			waitUntil {(!(_currentRetrievedCutsceneID isEqualTo (missionNamespace getVariable [format ["Phobos_ChooseDialog_ReturnValue_%1", _choiceIndexCutscene], -1]))) || (!(missionNamespace getVariable ["Phobos_fnc_chooseDialog_isActive",false]))}; //Wait until user changes cutscene selection. (Or if dialog is closed, free the thread.)
			if (!(missionNamespace getVariable ["Phobos_fnc_chooseDialog_isActive",false])) exitWith {}; //To prevent returning error of cutscene array not existing (since GUI doesnt exist anymore.)
			_currentRetrievedCutsceneID = (missionNamespace getVariable [format ["Phobos_ChooseDialog_ReturnValue_%1", _choiceIndexCutscene], -1]);
			//Retrieve Chosen Cutscene.
			_cutsceneName = _allCutscenes select (_currentRetrievedCutsceneID);
			
			//Retrieve all functional cameras.
			_cutsceneCams = [];
			for [{_i = MIN_CAMERA_WAYPOINT}, {_i < MAX_CAMERA_WAYPOINT}, {_i = _i + 1}] do {
				_camIndexExists = [_cutsceneName, _i] call Phobos_fnc_camExists;
				if (_camIndexExists) then {
					_cutsceneCams pushBack [_cutsceneName, _i];
				};
			};
			
			//Calculate Length of the entire cutscene.
			_cutsceneLength = 0;
			{
				_camProperties = _x call Phobos_fnc_camGetProperties; 
				_camCommitTime = _camProperties select ID_PROPERTIES_COMMIT_TIME;
				_camSleepTime = _camProperties select ID_PROPERTIES_WAIT_BEFORE_COMMIT;
				
				if (_forEachIndex != 0) then {
					_cutsceneLength = _cutsceneLength + (_camCommitTime + _camSleepTime);
				} else {
					_cutsceneLength = _cutsceneLength + INT_CAMERA_INTRO_LENGTH;
				};
			} forEach _cutsceneCams;
			
			_textBox ctrlSetText (str _cutsceneLength);
			_cutsceneLengthStr = [_cutsceneLength / 60,"HH:MM"] call BIS_fnc_timeToString;
			_titleBox ctrlSetText (format ["Cutscene Length: (%1)", _cutsceneLengthStr]);
			
			missionNamespace setVariable [format ["Phobos_ChooseDialog_ReturnValue_%1", _choiceIndex], _cutsceneLength];
			missionNamespace setVariable ["Phobos_fnc_cutscenePlay_actualLength", _cutsceneLength];
		};
	};
	_textBox ctrlRemoveAllEventHandlers "KeyUp";
	//We removed default EH to make this a bit more dummyproof. Now checks if it is a number, and if not, then the default number is set.
	_textBox ctrlAddEventHandler ["KeyUp", format ["
		_ctrlTextBox = _this select 0;
		_input = ctrlText _ctrlTextBox;
		_display = ctrlParent _ctrlTextBox;
		_ctrlTitle = _display displayCtrl %2;
		
		_parsedInput = [_input] call BIS_fnc_parseNumber;
		if (_parsedInput != -1) then {
			missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%1', _parsedInput];
			_parsedInputStr = [_parsedInput / 60, 'HH:MM'] call BIS_fnc_timeToString;
			_ctrlTitle ctrlSetText ('Cutscene Length: (' +  _parsedInputStr + ')');
		} else {
			_actualLength = missionNamespace getVariable ['Phobos_fnc_cutscenePlay_actualLength', 0];
			missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%1', _actualLength];
			_actualLengthStr = [_actualLength / 60, 'HH:MM'] call BIS_fnc_timeToString;
			_ctrlTitle ctrlSetText ('Cutscene Length: (' +  _actualLengthStr + ')');
		};",str _choiceIndex ,ctrlIDC _titleBox]
	];
};

_code41 = {
	//Create Music List.
	_choiceIndex = _this select 0;
	_listBox = _this select 2;

	//Retrieve all music classes and put them into listBox. (TreeView style, except titles are options aswell.)
	
	_selectedIndex = lbCurSel _listBox;
	_listBox lbSetData [_selectedIndex, ""];
	_listBox lbSetValue [_selectedIndex, -1];
	
	_musicClasses = []; 
	{
		_musicClasses pushBack (toLower (configName _x));
		_index = _listBox lbAdd (getText (_x >> "displayName"));
		_listBox lbSetData [_index, ""];
		//A little sorting trick.(actualLength + 60mins * _musicClasses index) --> Doubt there are musics longer than 1 hour.
		_listBox lbSetValue [_index, (3600 * _forEachIndex)];
	} forEach ((configFile >> "cfgMusicClasses") call BIS_fnc_returnChildren);
	
	_lastIndex = _listBox lbAdd "Unlisted";
	_listBox lbSetData [_lastIndex, ""];
	_listBox lbSetValue [_lastIndex, 3600 * (count _musicClasses)];
	
	
	//Retrieve all musics and put them into listBox.
	{
		_name = getText (_x >> "name");
		if (_name == "") then { //No music shall stay hidden!
			_name = (configName _x);
		};
		_musicClass = (count _musicClasses); //Equal to Unlisted.
		if ((tolower (getText (_x >> "musicClass"))) in _musicClasses) then {
			_musicClass = _musicClasses find (toLower (getText (_x >> "musicClass")));
		};
		_duration = getNumber (_x >> "duration");
		_durationText = [_duration / 60,"HH:MM"] call bis_fnc_timetostring;
		_index = _listBox lbAdd (format ["(%2) %1", _name, _durationText]);
		_listBox lbSetData [_index, configName _x];
		//A little sorting trick.(actualLength + 60mins * _musicClasses index) --> Doubt there are musics longer than 1 hour.
		_listBox lbSetValue [_index, _duration + (3600 * _musicClass)];
	} forEach ((configFile >> "cfgMusic") call BIS_fnc_returnChildren);
	lbSortByValue _listBox;
	_listBox lbSetCurSel _selectedIndex; //Just making sure.
	//Set default data manually.
	missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choiceIndex], ""];
	//Return data instead of index.(Which contains music class)
	_listBox ctrlRemoveAllEventHandlers "LBSelChanged";
	_listBox ctrlAddEventHandler ["LBSelChanged", format [
	"missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%1', (_this select 0) lbData (_this select 1)];
	playMusic ((_this select 0) lbData (_this select 1));
	missionNamespace setVariable ['Phobos_fnc_cutscenePlay_isMusicEHActivated', true];
	", _choiceIndex]];
};

_code51 = {
	_slider = _this select 2;
	_slider ctrlAddEventHandler ["SliderPosChanged", "0 fadeMusic ((_this select 1) / 100)"];
};

_onUnload = {
	missionNamespace setVariable ["Phobos_fnc_cutscenePlay_doListenCutsceneName", false];
	missionNamespace setVariable [format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID], false];
	publicVariable (format ["Phobos_fnc_cutscenePlay_curatorSitrepRequest_id%1", _requestID]);
	if (missionNamespace getVariable ['Phobos_fnc_cutscenePlay_isMusicEHActivated', false]) then {
		playMusic "";
		missionNamespace setVariable ['Phobos_fnc_cutscenePlay_isMusicEHActivated', false];
	};
	//Retrieve last musicVolume set by addMusic module.(Since it's the only thing that changes volume of a player.)
	0 fademusic (uinamespace getvariable ["RscAttributeMusicVolume_volume",musicvolume]); 
};

_chatResult = 
[
	"Preview Cutscene",
	[
		["Cutscene Name: ", _allCutscenes],
		["Viewers (Curators): ", _viewers, ["", ""], _code11, false],
		["Viewers (Players): ", ["RscPropertyOwners_Players"], nil, nil, false],
		["Cutscene Length: ", "", ["", ""], _code31, false], 
		["Music: ", ["No Music"], ["", ""], _code41, false], //Array is filled by _code41.
		["Music Volume: ", [0, musicVolume * 100, 100, 0], ["",""], _code51, false],
		["Execute Scripts?: ", ["Yes", "No"]]
	], nil , _onUnload
] call Phobos_fnc_showChooseDialog;

if (count _chatResult == 0) exitWith {
	["User aborted the Cutscene Preview module."] call Phobos_fnc_logMessage;
};

private _cutsceneName = _allCutscenes select (_chatResult select 0);
private _spectators = [];
//Add all spectator curators to array.
if (count _curatorPlayers > 1) then {
	switch (_chatResult select 1) do {
		case 0: {
			{
				if (!(missionNamespace getVariable [_curatorSitrepVars select _forEachIndex, false])) then {
					_spectators pushBack _x;
				};
			} forEach _curatorPlayers;
		};
		case 1: {}; //Do nothing, no curator will watch.
		default {
			if (!(missionNamespace getVariable [_curatorSitrepVars select (_chatResult select 1) - 2, false])) then { //-2 due All Curators option.
				_spectators pushBack (_curatorPlayers select ((_chatResult select 1) - 2));
			};
		};
	};
} else {
	if (_chatResult select 1 == 1) then {
		_spectators pushBack (_curatorPlayers select 0);
	}; //Else do nothing, none selected.
};
//Add all spectator non-curator players to array.
_spectators = _spectators + (_chatResult select 2);
[format ["Spectators array: %1", _spectators], Phobos_enableAdvancedCutsceneOutput] call Phobos_fnc_logMessage;
private _actualCutsceneLength = missionNamespace getVariable ["Phobos_fnc_cutscenePlay_actualLength", -1];
if (_actualCutsceneLength < 0) then {
	["ERROR: Cutscene length could not be retrieved."] call Phobos_fnc_logMessage;
};
private _desiredCutsceneLength = _chatResult select 3; //Parsed by code already.
private _cutsceneLengthMultiplier = 1;
if (_desiredCutsceneLength > 0) then {
	_cutsceneLengthMultiplier = (_desiredCutsceneLength / _actualCutsceneLength);
};
private _musicClass = _chatResult select 4;
private _musicVolume = ((_chatResult select 5) / 100);
private _execScripts = if (_chatResult select 6 == 0) then {true} else {false};

private _cutsceneCode = [_cutsceneName, false] call Phobos_fnc_cutscenePrepare;
if (_cutsceneCode isEqualTo -1) then { //May come number or string.
	["No camera available to create a cutscene. Aborting cutscene play."] call Ares_fnc_showZeusMessage;
};
[_spectators, _cutsceneLengthMultiplier, _musicClass, _musicVolume, _execScripts] call (compile _cutsceneCode);

#include "\Phobos_aresExpansion\module_footer.hpp"