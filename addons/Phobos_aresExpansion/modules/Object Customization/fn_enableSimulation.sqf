//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Enables simulation for selected objects.
// Changelog: None.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

if(count Phobos_selectedObjects > 0) then {
	{
	_x enableSimulationGlobal true;
	} forEach Phobos_selectedObjects;
	["Selected objects are now Collidable and not Floating."] call Ares_fnc_ShowZeusMessage;
}
else 
{
	["No objects were selected."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"