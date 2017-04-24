//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Blackens players' screens and deafen the players.
// Changelog: None.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

Phobos_isBlackScreenOn=true;
_presentCurators = [];
{
		_curator = getAssignedCuratorUnit _x;
		_presentCurators pushBack _curator;
} forEach allCurators;
_groundUnits = allPlayers - _presentCurators;
"ScreenSetup" remoteExec ["BIS_fnc_BlackOut", _groundUnits, true];


deleteVehicle (_this select 0); //Unable to reach to module footer due while returns true therefore module should be deleted manually.

//TODO: Separate this part.
while {Phobos_isBlackScreenOn}
do 
{
	[[["Zeus Has Blackened Players' Screens","<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>"],    ["Please Wait...","<t align = 'center' shadow = '1' size = '1.0'>%1</t>"]]] remoteExec  ["BIS_fnc_typeText",_groundUnits,true];
	[[["ATTENTION: You Have Blackened Players' Screens ","<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>"]]] remoteExec ["BIS_fnc_typeText",_presentCurators, true];
	[[],uiSleep 60] remoteExec ["spawn",_presentCurators, true];
	[[],uiSleep 15] remoteExec ["spawn",_groundUnits, true];
};

#include "\Phobos_aresExpansion\module_footer.hpp"