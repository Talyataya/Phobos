//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Performs animation on the unit under cursor.(Will break out when in 'COMBAT'.)
// Changelog:
// v1.1: 
// * Changed: BIS_fnc_MP is replaced with remoteExecCall.
// * Changed: Now successfully terminates previous animation to perform next one.
//////////////////////////////////////////////////////////////


#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

if (not (isNull _unitUnderCursor)) then
{
	[_unitUnderCursor, "LEAN", "ASIS"] remoteExecCall ["BIS_fnc_AmbientAnimCombat",0,true];
	["This unit is now performing the animation."] call Ares_fnc_ShowZeusMessage;
}
else
{
		["Module needs to be dropped on a unit."] call Ares_fnc_ShowZeusMessage;
};



#include "\Phobos_aresExpansion\module_footer.hpp"