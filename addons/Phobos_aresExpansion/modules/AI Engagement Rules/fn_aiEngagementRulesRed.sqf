//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Editing selected groups' Engagement Rules.
// Changelog: None
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

if(count Phobos_selectedObjects > 0) then
{
	{_x setCombatMode "RED";} forEach Phobos_selectedObjects;
	["Selected groups' combat mode is set to RED"] call Ares_fnc_ShowZeusMessage;
}
else
{
	["No units were selected."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"