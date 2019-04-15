//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Initializes entire mod on mission initialization. (preInit = 1)
// Changelog: None.
// Notes:
//
//////////////////////////////////////////////////////////////

//Check if dedicated server
if(!hasInterface) exitWith {["Dedicated Server detected, aborting Phobos initialization."] call Phobos_fnc_LogMessage;};
[] call Phobos_fnc_initGlobalVariables; //Temporary function, serves as a list for a future feature.

Phobos_EditableObjectBlacklist =
	[
		"Ares_Module_Util_Create_Composition",
		"ModuleCurator_F",
		"GroundWeaponHolder",
		"Salema_F",
		"Ornate_random_F",
		"Mackerel_F",
		"Tuna_F",
		"Mullet_F", 
		"CatShark_F",
		"Rabbit_F",
		"Snake_random_F",
		"Turtle_F",
		"Hen_random_F",
		"Cock_random_F",
		"Cock_white_F",
		"Sheep_random_F"
	];

//Wait till player is zeus.
[] spawn {
	[] call Ares_fnc_waitForZeus;
	while { not ([player] call Ares_fnc_isZeus) } do
	{
		sleep 1;
	};
	
	["Initializing Phobos UI."] call Phobos_fnc_logMessage;
	["Phobos"] spawn Phobos_fnc_MonitorCuratorDisplay;
	["UI Initialized."] call Phobos_fnc_logMessage;
	
	Phobos_selectedObjects=[];
	_curatorLogic = getAssignedCuratorLogic player;
	_curatorLogic addEventHandler ["CuratorObjectSelectionChanged", "if (not (curatorSelected select 0 isEqualTo [] || side (_this select 1) == sideLogic)) then { Phobos_selectedObjects=curatorSelected select 0;}"];
};

