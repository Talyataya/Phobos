//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Waypoint Editor: Allows player to change last waypoint type.
// Changelog: None
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

if (not (isNull _unitUnderCursor)) then {
	_groupOfSelectedUnit= group _unitUnderCursor; 
	_waypoints = waypoints _groupOfSelectedUnit; 
	_waypointCount = count _waypoints; 
	_lastWaypoint = (_waypoints select (_waypointCount - 1)) select 1;
	if (_waypointCount > 1 ) then {
		_chatResult =
		["Waypoint Editor",
			[
				["Choose Waypoint Type: ", ["MOVE", "DESTROY", "SAD", "GETIN NEAREST", "JOIN", "LEADER", "GETOUT", "CYCLE","LOAD","UNLOAD", "TR UNLOAD", "HOLD", "SENTRY", "GUARD", "TALK", "SCRIPTED", "SUPPORT", "DISMISS", "LOITER"]]
			]
		] call ares_fnc_showChooseDialog;
		
		if (count _chatResult > 0) then {
			_selectedWPType =_chatResult select 0;
			switch (_selectedWPType) do {
			case 0: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "MOVE";};
			case 1: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "DESTROY";};
			case 2: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "SAD";};
			case 3: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "GETIN NEAREST";};
			case 4: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "JOIN";};
			case 5: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "LEADER";};
			case 6: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "GETOUT";};
			case 7: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "CYCLE";};
			case 8: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "LOAD";};
			case 9: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "UNLOAD";};
			case 10: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "TR UNLOAD";};
			case 11: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "HOLD";};
			case 12: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "SENTRY";};
			case 13: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "GUARD";};
			case 14: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "TALK";};
			case 15: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "SCRIPTED";};
			case 16: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "SUPPORT";};
			case 17: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "DISMISS";};
			case 18: {[_groupOfSelectedUnit,_lastWaypoint] setWaypointType "LOITER";};
			};
		}
	}
}
	else
{
	["Module needs to be dropped on an object."] call Ares_fnc_ShowZeusMessage;
}

#include "\Phobos_aresExpansion\module_footer.hpp"