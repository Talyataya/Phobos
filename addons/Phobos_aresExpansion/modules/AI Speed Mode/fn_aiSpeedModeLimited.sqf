//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Editing selected groups' movement speed.
// Changelog: None
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

if(count Phobos_selectedObjects > 0) then
{
	{_x setSpeedMode "LIMITED";} forEach Phobos_selectedObjects;
	["Selected groups' speed is set to Limited Speed."] call Ares_fnc_ShowZeusMessage;
}
else
{
	["No units were selected."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"