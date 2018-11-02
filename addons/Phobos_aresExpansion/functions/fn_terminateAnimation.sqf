//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Checks previous animation on desired unit and terminates previous one(if there is) to start new one.
// Changelog: None.
// Notes: 
//		*Progress on halt, further research required.(Not used in anywhere.)
//		*Most likely an entire new structure will be created.
//		
//
//////////////////////////////////////////////////////////////

_unit = _this select 0;

if (!isNil (_unit getVariable "bis_fnc_ambientAnim__animSet")) then {
	if(!((_unit getVariable "bis_fnc_ambientAnim__animSet") isEqualTo "STAND_IA")) then {
		[_unit] remoteExecCall ["BIS_fnc_ambientAnim__terminate",0,true];
	};
};
