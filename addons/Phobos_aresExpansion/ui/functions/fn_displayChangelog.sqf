private ["_display","_colorHighlightRGB","_textField","_title","_changelog"];
disableSerialization;

_display = _this select 0;
_textField = _display displayCtrl 1100;
_title = _display displayCtrl 1101;

_colorHighlightRGB = ["GUI","BCG_RGB"] call compile preprocessFileLineNumbers "A3\functions_f\gui\fn_displayColorGet.sqf";
_changelog = [] call compile preprocessFileLineNumbers "\Phobos_aresExpansion\functions\fn_getChangelog.sqf";

_textField ctrlSetStructuredText (parseText _changelog);
[_textField] call compile preprocessFileLineNumbers "A3\functions_f\gui\fn_ctrlFitToTextHeight.sqf";
_title ctrlSetStructuredText (parseText "Phobos");
_title ctrlSetBackgroundColor _colorHighlightRGB;
_textField ctrlCommit 0; 
_title ctrlCommit 0;