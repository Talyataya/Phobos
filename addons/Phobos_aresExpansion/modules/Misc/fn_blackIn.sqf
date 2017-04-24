//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.2
// Description: Turns players' screens smoothly back to normal.
// Changelog:
// v1.2:
// *Fixed: No more creates a 2nd empty line.
// v1.1:
// +Added: Now notifies about the black screen starts to disappear.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

Phobos_isBlackScreenOn=false;

_presentCurators = [];
{
	_curator = getAssignedCuratorUnit _x;
	_presentCurators pushBack _curator;
} forEach allCurators;
_groundUnits = allPlayers - _presentCurators;
[[["Zeus Has Enlightened Players' Screens","<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>"]]] remoteExec  ["BIS_fnc_typeText",_groundUnits,true];
[[["You Have Enlightened Players' Screens","<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>"]]] remoteExec  ["BIS_fnc_typeText",_presentCurators,true];
"ScreenSetup" remoteExec ["BIS_fnc_BlackIn", _groundUnits];

#include "\Phobos_aresExpansion\module_footer.hpp"

