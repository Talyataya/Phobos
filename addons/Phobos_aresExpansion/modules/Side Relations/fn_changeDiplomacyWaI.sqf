//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Changes the relationship between West and Independence.
// Changelog: None.
// Notes: Reverted from v1.1
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_friendshipWaI = WEST getFriend INDEPENDENT;
[WEST, [INDEPENDENT,(_friendshipWaI+1) mod 2]] remoteExecCall ["setFriend", 2];
[INDEPENDENT, [WEST,(_friendshipWaI+1) mod 2]] remoteExecCall ["setFriend", 2];



if (WEST getFriend INDEPENDENT == 1) then {
	//The delay in diplomacy change returns wrong information that's why we are actually checking the previous situation.. Therefore giving feedback that they're now enemies by checking if they 'were' friendly.
	["West and Independent are now enemies to each other."] call Ares_fnc_ShowZeusMessage;
}
else 
{
	//The delay in diplomacy change returns wrong information that's why we are actually checking the previous situation.. Therefore giving feedback that they're now friendly by checking if they 'were' enemies.
	["West and Independent are now friendly to each other."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"