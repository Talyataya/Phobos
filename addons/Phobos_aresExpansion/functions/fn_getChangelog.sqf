_colorHighlightRGB = ["GUI","BCG_RGB"] call compile preprocessFileLineNumbers "A3\functions_f\gui\fn_displayColorGet.sqf";
_colorHighlightHTML = _colorHighlightRGB call compile preprocessFileLineNumbers "A3\functions_f\misc\fn_colorRGBtoHTML.sqf";

_changelog = "<br />";
_bullet = "<t size='0.5' color='" + _colorHighlightHTML + "'><img image='A3\Ui_f\data\IGUI\RscIngameUI\RscHint\indent_gr' /></t>";



_changelog = _changelog + "<t color='" +_colorHighlightHTML+ "'>v0.5.2:</t><br />";
_changelog = _changelog + _bullet + " <t color='" +_colorHighlightHTML+ "'>Added:</t> Changelog, which will be displayed first time a new version is launched.(Such as now!)<br />";
_changelog = _changelog + _bullet +	" <t color='" +_colorHighlightHTML+ "'>Added Module:</t> 'Generate Mission SQF(Basic)', written from scratch to fix bugs/absents of Ares one. (Basic) is meant relative to future features and supports every feature of Ares version.<br />";
_changelog = _changelog + "    - Fixes corrupted SQF generation.<br />";
_changelog = _changelog + "    - Fixes multiple vehicle generations(and due that, explosions) caused by squad-bounded vehicle generation.<br />";
_changelog = _changelog + "    - Saves units inside vehicles instead of generating squads from config.<br />";
_changelog = _changelog + _bullet + " <t color='" +_colorHighlightHTML+ "'>Added Module:</t> 'Display/Modify Object Variables', displays and modifies(not yet) an object's variables.<br />";
_changelog = _changelog + _bullet + " <t color='" +_colorHighlightHTML+ "'>Added function:</t> 'showChooseDialog.sqf' from Ares in expanded form.<br />";
_changelog = _changelog + "    - Now supports scrolling, allowing many more choices to be given.<br />";
_changelog = _changelog + "    - Now options that are required as text input can appear with a default value instead of being empty.<br />";
_changelog = _changelog + _bullet + "  <t color='" +_colorHighlightHTML+ "'>Fixed Module:</t> 'AI Difficulty Prefix' now checks correct variable to remove previous related event handler.<br />";

_changelog = _changelog + "<br /><br />";

_changelog = _changelog + "<t color='" +_colorHighlightHTML+ "'>v0.5.0:</t><br />";
_changelog = _changelog + _bullet + "<t color='" +_colorHighlightHTML+ "'>Content Release.</t><br />";
_changelog;