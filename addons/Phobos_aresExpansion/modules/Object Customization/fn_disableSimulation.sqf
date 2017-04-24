//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Disables Simulation for selected objects.
// Changelog: None.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

if(count Phobos_selectedObjects > 0) then {
	{
		_x enableSimulationGlobal false;
	} forEach Phobos_selectedObjects;
	["Selected objects are now not Collidable and Floating."] call Ares_fnc_ShowZeusMessage;
} 
else 
{
	["No objects were selected."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"