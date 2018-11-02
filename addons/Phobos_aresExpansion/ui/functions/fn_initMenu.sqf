//Initialized by overridden Main Menu.
private ["_currentVersion", "_lastVersionClientUsed"];
_mainDisplay = _this select 0;

//Check if a function source is provided. If not, shutdown the game.
if ((!isClass (configfile >> "CfgPatches" >> "Ares")) && (!isClass (configfile >> "CfgPatches" >> "achilles_functions_f_ares"))) exitWith {_mainDisplay createDisplay "shutdownWarning";};

//Check past version of mod. Display welcomeScreen, Changelog depending on last version user used.
if (!(profileNamespace getVariable ["Phobos_version","0.0.0"] isEqualTo "0.0.0")) then {
	_currentVersion = getText (configFile >> "cfgPatches" >> "Phobos" >> "versionStr");
	_lastVersionClientUsed = profileNamespace getVariable "Phobos_version";
	diag_log format ["Phobos: Current version: %1, Last Version user used: %2", _currentVersion, _lastVersionClientUsed];
	
	if (_lastVersionClientUsed isEqualTo _currentVersion) then {
		diag_log "Phobos: Skipping Welcoming Phase.";
	} else {
		_mainDisplay createDisplay "changelogDialog";
		diag_log "Phobos: Displaying changelog.";
	}
} else {
	_mainDisplay createDisplay "WelcomeScreen";
	diag_log "Phobos: Displaying welcome screen.";
};

["onLoad",_this,"RscDisplayMain","GUI"] call compile preprocessFileLineNumbers "A3\ui_f\scripts\initDisplay.sqf";
