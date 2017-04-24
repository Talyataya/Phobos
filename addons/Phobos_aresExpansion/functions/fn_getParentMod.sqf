//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Returns which Ares(pure or Achilles combined) version is loaded.
// Changelog: None.
// Notes: 
//
//////////////////////////////////////////////////////////////
private "_parentMod";

if (isClass (configfile >> "CfgPatches" >> "Ares")) then {
	_parentMod = "Ares";
};

if (isClass (configfile >> "CfgPatches" >> "achilles_functions_f_ares")) then {
	_parentMod = "Achilles";
};

_parentMod;