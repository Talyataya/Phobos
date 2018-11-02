//////////////////////////////////////////////////////////////////////////
//
// Author: Anton Struyk
// Modified by: Talya
// Version: 1.2
// Description: 
// Taken from: Ares Mod(v1.8.1) - fn_MonitorCuratorDisplay.sqf
// Description: Detecting if player is a curator and starts to modify curator interface by module list and event aspects.
// Changelog: 
// v1.2: 
//		*Moved Phobos_selectedObjects: fn_initPhobos.sqf -> fn_monitorCuratorDisplay.sqf
//		*Removed fn_handleCuratorKeyReleased as we read CTRL and SHIFT inputs directly from fn_handleCuratorKeyPressed parameters now.
// v1.1:
//		*Added new display handlers.
// Notes: 
//		*TODO: Fix fails to initialize when a unit is remote controlled and leave so fast. Requires curator interface to be redetected.(Tempfix: restart curator interface by vanilla module: Remote Control)
//////////////////////////////////////////////////////////////////////////


#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

_category = _this select 0;

disableSerialization;

while {true} do {
	//["Monitor curator display..."] call Ares_fnc_LogMessage;
	
	// Wait for the player to become zeus again (if they're not - eg. if on dedicated server and logged out)
	while { !([player] call Ares_fnc_IsZeus) } do
	{
		//["Unit not zeus..."] call Ares_fnc_LogMessage;
		sleep 1;
	};
	//["Zeus has arrived!"] call Ares_fnc_LogMessage;

	//Wait for the curator screen to be displayed
	while {isNull (findDisplay IDD_RSCDISPLAYCURATOR)} do
	{
		//["Display not open."] call Ares_fnc_LogMessage;
		sleep 1;
	};
	//["Display opened!"] call Ares_fnc_LogMessage;
	
	_display = findDisplay IDD_RSCDISPLAYCURATOR;
	_ctrl = _display displayCtrl IDC_RSCDISPLAYCURATOR_MODEMODULES;
	
	//Declare our UI event handlers.
	_ctrl ctrlAddEventHandler ["Buttonclick", format ["['%1'] spawn Phobos_fnc_OnModuleTreeLoad;", _category]];
	_display displayAddEventHandler ["KeyDown", {_this call Phobos_fnc_handleCuratorKeyPressed;}];
	//_display displayAddEventHandler ["KeyUp", {_this call Phobos_fnc_handleCuratorKeyReleased;}];
	
	//Declare our event handlers.
	//Variable to store all selected objects actively.
	Phobos_selectedObjects=[];
	_curatorLogic = getAssignedCuratorLogic player;
	_curatorLogic addEventHandler ["CuratorObjectSelectionChanged", "if (not (curatorSelected select 0 isEqualTo [] || side (_this select 1) == sideLogic)) then { Phobos_selectedObjects=curatorSelected select 0;}"];
	
	[_category] call Phobos_fnc_OnModuleTreeLoad;

	//Wait for the curator screen to be removed
	while {!isNull (findDisplay IDD_RSCDISPLAYCURATOR)} do
	{
		//["Display not closed."] call Ares_fnc_LogMessage;
		sleep 1;
	};
	//["Display closed!"] call Ares_fnc_LogMessage;
};