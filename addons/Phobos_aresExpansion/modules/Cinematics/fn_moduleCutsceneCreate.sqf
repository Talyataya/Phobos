//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Create a new cutscene in cutscene list.
// Changelog: None
// Notes: Although fn_camWaypoint has capability to create cutscene, player has no option to create due GUI limitation.(Which is for safety)
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

["User initialized the cutscene creation module."] call Phobos_fnc_logMessage;
_chatResult = 
[
	"Cutscene Creation",
	[
		["Cutscene Name: ", ""]
	]
] call Phobos_fnc_showChooseDialog;

if (count _chatResult == 0) exitWith {["User aborted the cutscene creation module."] call Phobos_fnc_logMessage;};

private _cutsceneName = _chatResult select 0;
private _creationResult = [_cutsceneName] call Phobos_fnc_cutsceneAddNew;

private _notificationData = ["CutsceneCreationSucceeded", [_cutsceneName]];
switch (_creationResult) do {
	case 1: {_notificationData = ["CutsceneCreationFailed", [_cutsceneName, "Cutscene already exists."]];};
	case 2: {_notificationData = ["CutsceneCreationFailed", [_cutsceneName, "Inappropriate cutscene name was used."]];};
};
_notificationData call BIS_fnc_showNotification;

#include "\Phobos_aresExpansion\module_footer.hpp"