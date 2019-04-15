//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Grabs properties of created cameras and generates the code of cutscene in requested format.(Module)
// Changelog: None.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

["User initialized the cutscene extraction module."] call Phobos_fnc_logMessage;

private _allCutscenes = [] call Phobos_fnc_cutsceneGetAll;
if (count _allCutscenes <= 0) exitWith {
	["No cutscene in cutscene list was found. Create a cutscene first."] call Ares_fnc_showZeusMessage;
	["No cutscene in cutscene list was found. Aborting module process."] call Phobos_fnc_logMessage;
};

_hint11 = "Format of code that will be generated.";
_hint12 = 
"*Phobos Cutscene Editor: Creates code for Phobos and allows you to modify just like a fresh cutscene created, usable only if Curator uses Phobos." + endl +
"*Vanilla A3: Creates code that can be used anywhere, use only if you won't have access to Phobos as you cannot modify the cutscene without Phobos." + endl + "Also may require some parameters to be entered manually based on player desire.";


_chatResult = 
[
	"Extract Cutscene",
	[
		["Cutscene Name :" , _allCutscenes],
		["Code Type :" , ["Phobos Cutscene Editor", "Vanilla A3"], [_hint11, _hint12]]
	]
] call Phobos_fnc_showChooseDialog;

if (count _chatResult == 0) exitWith {["User aborted the cutscene extraction module."] call Phobos_fnc_logMessage;};

private _cutsceneName = _allCutscenes select (_chatResult select 0);
private _extractMethod = _chatResult select 1;
private _cutsceneCode = "";
if (_extractMethod == 0) then {
	_cutsceneCode =	[_cutsceneName] call Phobos_fnc_cutsceneExtract;
} else {
	_cutsceneCode = [_cutsceneName, true] call Phobos_fnc_cutscenePrepare;
};

if (_cutsceneCode isEqualTo -1) exitWith { //It may come number or string.
	["No camera available to create a cutscene. Aborting cutscene preview."] call Ares_fnc_showZeusMessage;
};

missionNamespace setVariable ['Phobos_CopyPaste_Dialog_Text', _cutsceneCode];
createDialog "Phobos_CopyPaste_Dialog";

#include "\Phobos_aresExpansion\module_footer.hpp"


