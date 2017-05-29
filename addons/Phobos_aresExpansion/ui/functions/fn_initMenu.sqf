//Initialized by overridden Main Menu.
private ["_currentVersion", "_lastVersionClientUsed"];
_mainDisplay = _this select 0;

if((!isClass (configfile >> "CfgPatches" >> "Ares")) && (!isClass (configfile >> "CfgPatches" >> "achilles_functions_f_ares"))) exitWith {_mainDisplay createDisplay "shutdownWarning";};

if(!(profileNamespace getVariable ["Phobos_version","0.0.0"] isEqualTo "0.0.0")) then {
	_currentVersion = getText(configFile >> "cfgPatches" >> "Phobos" >> "versionStr");
	_lastVersionClientUsed = profileNamespace getVariable "Phobos_version";
	["Phobos current version: " + _currentVersion + ", Last Version user used: " + _lastVersionClientUsed]  call Phobos_fnc_logMessage;
	
	if(_lastVersionClientUsed isEqualTo _currentVersion) then {
		diag_log "Phobos: Skipping Welcoming Phase.";
	} else {
		//[] call Phobos_fnc_whatIsNew; First Version...
		diag_log "Phobos: Displaying changelog."; 
		profileNamespace setVariable ["Phobos_version",_currentVersion]; //TODO bind it to OK button when fnc is filled.
	}
} else {
	_mainDisplay createDisplay "WelcomeScreen";
	diag_log "Phobos: Displaying welcome screen.";
};

["onLoad",_this,"RscDisplayMain","GUI"] call compile preprocessFileLineNumbers "A3\ui_f\scripts\initDisplay.sqf";