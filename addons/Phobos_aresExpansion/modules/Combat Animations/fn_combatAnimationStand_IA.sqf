//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Performs animation on the unit under cursor.(Default animation of a created unit.)
// Changelog:
// v1.1: 
// * Changed: BIS_fnc_MP is replaced with remoteExecCall.
//
//////////////////////////////////////////////////////////////


#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

if (not (isNull _unitUnderCursor)) then
{
	[_unitUnderCursor, "STAND_IA", "ASIS"] remoteExecCall ["BIS_fnc_AmbientAnimCombat",0,true];
	[_unitUnderCursor] remoteExecCall ["BIS_fnc_ambientAnim__terminate",0,true];
	["This unit is now performing the animation."] call Ares_fnc_ShowZeusMessage;
}
else
{
		["Module needs to be dropped on a unit."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"