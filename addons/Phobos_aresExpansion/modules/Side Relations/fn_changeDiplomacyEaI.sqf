//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Changes the relationship between East and Independence.
// Changelog: None.
// Notes: Reverted from v1.1
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_friendshipEaI = EAST getFriend INDEPENDENT;
[EAST, [INDEPENDENT,(_friendshipEaI+1) mod 2]] remoteExecCall ["setFriend",2];
[INDEPENDENT, [EAST,(_friendshipEaI+1) mod 2]] remoteExecCall ["setFriend",2];



if (EAST getFriend INDEPENDENT == 1) then {
	//The delay in diplomacy change returns wrong information that's why we are actually checking the previous situation.. Therefore giving feedback that they're now enemies by checking if they 'were' friendly.
	["East and Independent are now enemies to each other."] call Ares_fnc_ShowZeusMessage;
}
else 
{
	//The delay in diplomacy change returns wrong information that's why we are actually checking the previous situation.. Therefore giving feedback that they're now friendly by checking if they 'were' enemies.
	["East and Independent are now friendly to each other."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"