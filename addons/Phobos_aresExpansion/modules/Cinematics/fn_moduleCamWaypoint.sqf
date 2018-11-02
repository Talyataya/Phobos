//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Records curator camera position and target(pos or obj) as player bound variables.(Module Type)
// Changelog: None
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"
#include "\Phobos_aresExpansion\includes\cinematics.inc"

["User initialized the camera creation module."] call Phobos_fnc_logMessage;
private _allCutscenes = [] call Phobos_fnc_cutsceneGetAll;
if (count _allCutscenes <= 0) exitWith {
	["No cutscene in cutscene list was found. Create a cutscene first."] call Ares_fnc_showZeusMessage;
	["No cutscene in cutscene list was found. Aborting module process."] call Phobos_fnc_logMessage;
};

_chatResult =
[
	"Camera Properties",
	[
		["Cutscene Name: ", _allCutscenes],
		["Camera ID: ", ""]
	]
] call Phobos_fnc_showChooseDialog;

if (count _chatResult == 0) exitWith {["User aborted the camera creation module."] call Phobos_fnc_logMessage;};

private _cutsceneName = _allCutscenes select (_chatResult select 0);
private _camID =  parseNumber (_chatResult select 1);

[_cutsceneName, _camID] call Phobos_fnc_camWaypoint;

#include "\Phobos_aresExpansion\module_footer.hpp"