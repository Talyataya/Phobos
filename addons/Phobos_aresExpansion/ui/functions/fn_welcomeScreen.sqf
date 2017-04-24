private ["_display","_colorHighlightRGB","_colorHighlightHTML","_bullet","_textField","_title","_message"];
disableSerialization;

_display = _this select 0; 

_textField = _display displayCtrl 1100;
_title = _display displayCtrl 1101;

_colorHighlightRGB = ["GUI","BCG_RGB"] call compile preprocessFileLineNumbers "A3\functions_f\gui\fn_displayColorGet.sqf";
_colorHighlightHTML = _colorHighlightRGB call compile preprocessFileLineNumbers "A3\functions_f\misc\fn_colorRGBtoHTML.sqf";

_message = "<br />";
_bullet = "<t size='0.5' color='" + _colorHighlightHTML + "'><img image='A3\Ui_f\data\IGUI\RscIngameUI\RscHint\indent_gr' /></t>";


_message = _message + "Welcome and Thanks for downloading and taking part in <t color='" +_colorHighlightHTML+ "'>Beta Version</t> of <t color='" +_colorHighlightHTML+ "'>Phobos</t>.<br />";
_message = _message + "In this mod, you'll have new features with different functionalities as a variation of extra modules.<br /><br />";
_message = _message + "<t color='" +_colorHighlightHTML+ "'>Key Features</t><br />";
_message = _message + _bullet + "<t color='" + _colorHighlightHTML + "'>Easy Selection</t> of objects and performing tasks which otherwise would take long time.<br />";
_message = _message + _bullet + "<t color ='" + _colorHighlightHTML + "'>Easy to use modules</t> that are developed in order to perform tasks <t color ='" + _colorHighlightHTML + "'>much faster</t>.<br />";
_message = _message + _bullet + "<t color= '" + _colorHighlightHTML + "'>Prefixed Modules</t> that allows player to no more bother with repeating same stuff.(ie: Editing AI Difficulty)<br />";
_message = _message + _bullet + "Detailed way to edit AI attributes and waypoints to have <t color= '" + _colorHighlightHTML + "'>more control</t> over missions.<br />";
_message = _message + _bullet + "Ability to <t color ='" + _colorHighlightHTML + "'>change faction relations</t> during mid-game.<br />";
_message = _message + _bullet + "More features regarding objects such as positioning and customization.<br />";
_message = _message + _bullet + "Extra features for roleplay missions.<br />";
_message = _message + _bullet + "Ambience related features to <t color ='" + _colorHighlightHTML + "'>prevent</t> your worshippers from <t color ='" + _colorHighlightHTML + "'>feeling lonely</t>.<br />";
_message = _message + _bullet + "Animations.<br />";
_message = _message + _bullet + "And many more that awaits for your <t color ='" + _colorHighlightHTML + "'>exploration</t>.<br /><br />";
_message = _message + "If you like what is going on with this mod, feel free to contribute to it by proposing your ideas or report any issues you have on: <br /><t href='https://github.com/Talyataya/Phobos/issues'>GitHub Link</t>";

_textField ctrlSetStructuredText (parseText _message);
_title ctrlSetStructuredText (parseText "Phobos");
_title ctrlSetBackgroundColor _colorHighlightRGB;
_textField ctrlCommit 0; 
_title ctrlCommit 0;

//["onLoad",_this,"RscDisplayMain","GUI"] call compile preprocessFileLineNumbers "A3\ui_f\scripts\initDisplay.sqf";
/*
Welcome and thanks for downloading and taking part in Beta Version of Phobos. In this mod, you'll have new features varied from new module types to different functionalities.

Key Features

Easy selection of objects and performing tasks which otherwise would take long time.
Easy to use modules that are developed in order to perform tasks much faster.
Prefixed Modules that allows player to no more bother with repeating same stuff.(ie: Editing AI Difficulty)
Detailed way to edit AI attributes and waypoints to have more control over missions.
Ability to change faction relations during mid-game.
More features regarding objects such as positioning and customization.
Extra features for roleplay missions.
Ambience related features to prevent your worshippers feel lonely.
Animations.
And many more that awaits for your exploration..

If you like what is going with this mod, feel free to contribute to it by proposing your ideas or report any issues you have on:
<Github link here>

*/


