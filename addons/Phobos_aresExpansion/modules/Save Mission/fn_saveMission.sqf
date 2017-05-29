//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.2
// Description: Module to save mission.(Basic Save)
// Changelog: 
// v1.2: 
//		*Removed upcoming features' options. (Reason: Will be readded after features are implemented.)
//		*Removed option to save non-zeus objects. (Reason: No efficient way to exclude map objects(?))
// v1.1: 
// 		*Changed: Does not copy 'MODULEHQ_F' anymore.
// Notes: Module written from scratch to cover up absents and bugs of Ares save/load module.
//		*Saves units inside vehicles instead of generating squads from config.
//		*Fixes multiple vehicle generations(and due that, explosions) caused by squad-bounded vehicle generation.
//		*Fixes corrupted SQF generation.(Caused by improper logic side handling.)
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

["User initialized the save(basic) module."] call Phobos_fnc_logMessage;

_chatResult =
["Create Mission SQF(Basic)",
	[
		["Radius:", ["50m","100m","250m","500m","1km","2km","5km","Entire Map"], 7],
		["Include Units?", ["Yes","No"]],
		["Include Objects?", ["Yes","No"]],
		["Include Empty Vehicles?", ["Yes","No"]],
		["Include Markers?", ["Yes", "No"], 1]
	]
] call Phobos_fnc_showChooseDialog;

if(count _chatResult == 0) exitWith {["User aborted save(basic) process."] call Phobos_fnc_logMessage;};
_diagTimeStart = diag_tickTime; 
_radius = -1;
switch (_chatResult select 0) do {
	case 0: {_radius = 50;};
	case 1: {_radius = 100;};
	case 2: {_radius = 250;};
	case 3: {_radius = 500;};
	case 4: {_radius = 1000;};
	case 5: {_radius = 2000;};
	case 6: {_radius = 5000;};
	case 7: {_radius = -1;};
};
_includeUnits = if (_chatResult select 1 == 0) then {true} else {false};
_includeObjects = if (_chatResult select 2 == 0) then {true} else {false};
_includeEmptyVehicles = if (_chatResult select 3 == 0) then {true} else {false};
_includeMarkers = if (_chatResult select 4 == 0) then {true} else {false};

[format ["Save module decisions are as follows: Radius: %1,Included units: %2 , Included objects: %3, Included empty vehicles: %4, Included markers: %5", _radius, _includeUnits, _includeObjects, _includeEmptyVehicles, _includeMarkers]] call Phobos_fnc_logMessage;

_objectsToSave = [];
_allZeusObjects = curatorEditableObjects (allCurators select 0);
_blacklist = Ares_EditableObjectBlackList;
//Verify the logic below is properly written.

if(_radius != -1) then {
	{
		if (((_logic distance _x) < _radius) && {!((typeOf _x) in _blacklist)}) then {
			_objectsToSave append [_x];
		};
	} forEach _allZeusObjects;
	[format ["Objects inside %2m, were chosen to be saved: %1",_objectsToSave,_radius]] call Phobos_fnc_logMessage;
} else {
	_objectsToSave = _allZeusObjects;
	[format ["All Objects were chosen to be saved: %1",_objectsToSave]] call Phobos_fnc_logMessage;
};

_totalGroups = 0;
_totalUnits = 0;
_totalOccupiedVehicles = 0;
_totalEmptyVehicles = 0;
_totalEmptyObjects = 0;

_output = [];
if (_includeUnits) then {
	//Vehicles
	_usedVehicles = [];
	{
		if((!(vehicle _x == _x)) && (!((vehicle _x) in _usedVehicles))) then {
			_usedVehicles pushback (vehicle _x);
			
			_class = typeOf (vehicle _x);
			_position = position (vehicle _x);
			_posASL = getPosASL (vehicle _x);
			_dir = direction (vehicle _x);
			
			_output pushBack format ["_newVehicle = createVehicle ['%1',%2,[],0,'CAN_COLLIDE']; _newVehicle setPosASL %3; _newVehicle setDir %4;", _class, _position, _posASL, _dir];
			
			_totalOccupiedVehicles = _totalOccupiedVehicles + 1;
		};
	} forEach (_objectsToSave arrayIntersect allUnits);
	[format ["All vehicles in use are as follows: %1",_usedVehicles]] call Phobos_fnc_logMessage;
	
	//Groups
	_allGroups = [];
	{
		if (!((group _x) in _allGroups)) then {
			_allGroups pushBack (group _x);
		};
	} forEach (_objectsToSave arrayIntersect allUnits);
	[format ["All present groups are as follows: %1",_allGroups]] call Phobos_fnc_logMessage;	
		
	{	
		_sideStr = "";
		if(side _x == sideLogic) exitWith {}; //Ares bug that was corrupting generated mission SQF.
		switch (side _x) do
		{
			case west: { _sideStr = "west"; };
			case east: { _sideStr = "east"; };
			case resistance: { _sideStr = "resistance"; };
			case civilian: { _sideStr = "civilian"; };
			default { _sideStr = "?"; };
		};
		
		_groupSide = _sideStr;
		_formation = formation _x;
		_behaviour = behaviour (leader _x);
		_combatMode = combatMode _x;
		_speedMode = speedMode _x;
		
		_output pushback format ["_newGroup = createGroup %1; _newGroup setFormation '%2'; _newGroup setBehaviour '%3';_newGroup setCombatMode '%4'; _newGroup setSpeedMode '%5';", _groupSide, _formation, _behaviour, _combatMode, _speedMode];
		
		_units = [];
		{
			if (alive _x && !isPlayer _x) then {
				_units pushBack _x;
			};
		} forEach (units _x);
		
		//Units
		{
			_class = typeOf _x;
			if ((toLower _class) isEqualTo (toLower "MODULEHQ_F")) exitWith {
				["'MODULEHQ_F' Detected, ignoring."] call Phobos_fnc_logMessage;
			};
			_skill = skill _x;
			_rank = rank _x;
			
			if(!(vehicle _x == _x)) then {
				private ["_moveInCommand","_unitVehicleData","_unitVehicleRole","_unitVehicleIndex","_indexExists"];
				_unitVehicleData = assignedVehicleRole _x;
				_unitVehicleRole = _unitVehicleData select 0;
				
				_indexExists = false;
				if(count _unitVehicleData > 1) then {
					_indexExists = true;
					_unitVehicleIndex = _unitVehicleData select 1;
				};
				
				_unitVehicleRole = toLower _unitVehicleRole;
				switch (_unitVehicleRole) do {
				case "driver": {
						_moveInCommand = "moveInDriver " + format ["nearestObject [%1, 'AllVehicles']", position (vehicle _x)];
					};
					case "turret": {
						_moveInCommand = "moveInTurret " + format ["[nearestObject [%1, 'AllVehicles'], %2]",position (vehicle _x), _unitVehicleIndex]; 
					};
					case "cargo": {
						if(_indexExists) then {
							_moveInCommand = "moveInCargo " + format ["[nearestObject [%1, 'AllVehicles'], %2]",position (vehicle _x), _unitVehicleIndex select 0]; //TODO: Make sure _unitVehicleSlotIndex always return an array with single number.
						} else {
							_moveInCommand = "moveInCargo " + format ["nearestObject [%1, 'AllVehicles']",position (vehicle _x)];
						};
					};
				};
					
				_output pushBack format ["_newUnit = _newGroup createUnit ['%1',[0,0,10],[],0,'CAN_COLLIDE']; _newUnit setSkill %2, _newUnit setRank '%3'; _newUnit %4; [_newUnit] orderGetIn true;", _class, _skill, _rank, _moveInCommand];
			} else {
				_position = position _x;
				_posASL = getPosASL _x;
				_dir = direction _x;
				_formDir = formationDirection _x;
				
				_output pushBack format ["_newUnit = _newGroup createUnit ['%1',%2,[],0,'CAN_COLLIDE']; _newUnit setPosASL %3; _newUnit setSkill %4;_newUnit setRank '%5';_newUnit setDir %6; _newUnit setFormDir %7; [_newUnit] orderGetIn false;", _class, _position, _posASL, _skill, _rank, _dir, _formDir];
			};
			_totalUnits = _totalUnits + 1;
		} forEach _units;
		
		{
			if (_forEachIndex > 0) then {
				_output pushBack format [
					"_newWaypoint = _newGroup addWaypoint [%1, %2]; _newWaypoint setWaypointType '%3';%4 %5 %6",
					(waypointPosition _x),
					0,
					(waypointType _x),
					if ((waypointSpeed _x) != 'UNCHANGED') then { "_newWaypoint setWaypointSpeed '" + (waypointSpeed _x) + "'; " } else { "" },
					if ((waypointFormation _x) != 'NO CHANGE') then { "_newWaypoint setWaypointFormation '" + waypointFormation _x + "'; " } else { "" },
					if ((waypointCombatMode _x) != 'NO CHANGE') then { "_newWaypoint setWaypointCombatMode '" + (waypointCombatMode _x) + "'; " } else { "" }
				];
			};
		} forEach (waypoints _x);
		_totalGroups = _totalGroups + 1;
	} forEach _allGroups;
};
//Objects
if (_includeObjects) then {
	{
		if (!((_x isKindOf "CAManBase") || (_x isKindOf "car") || (_x isKindOf "tank") || (_x isKindOf "air") || (_x isKindOf "StaticWeapon") || (_x isKindOf "ship" || _x isKindOf "logic"))) then {
			_class = typeOf _x;
			_position = position _x;
			_posASL = getPosASL _x;
			_dir = direction _x;
			_vectorDir = vectorDir _x;
			_vectorUp = vectorUp _x;

			_output pushBack format ["_newObject = createVehicle ['%1',%2,[],0,'CAN_COLLIDE']; _newObject setPosASL %3; _newObject setDir %4; _newObject setVectorDirAndUp [%5,%6];",_class,_position,_posASL,_dir, _vectorDir, _vectorUp];
			
			_totalEmptyObjects = _totalEmptyObjects + 1;
		};
	} forEach _objectsToSave;
};
//Empty Vehicles
if (_includeEmptyVehicles) then {
	{
		if ( ( (_x isKindOf "car") || (_x isKindOf "tank") || (_x isKindOf "air") || (_x isKindOf "StaticWeapon") || (_x isKindOf "ship")) && (alive _x) && {alive _x} count (crew _x) == 0 ) then {
			_class = typeOf _x;
			_position = position _x;
			_posASL = getPosASL _x;
			_dir = direction _x;
			_vectorDir = vectorDir _x;
			_vectorUp = vectorUp _x;
		
			_output pushBack format ["_newEmptyVehicle = createVehicle ['%1',%2,[],0,'CAN_COLLIDE']; _newEmptyVehicle setPosASL %3; _newEmptyVehicle setDir %4; _newEmptyVehicle setVectorDirAndUp [%5,%6];", _class, _position, _posASL, _dir, _vectorDir, _vectorUp];
			
			_totalEmptyVehicles = _totalEmptyVehicles + 1;
		};
	} forEach _objectsToSave;
};
//Markers
if (_includeMarkers) then {
	{
		_markerName = "Phobos_Imported_Marker_" + str(_forEachIndex);
		_output pushBack format [
			"_newMarker = createMarker ['%1', %2]; _newMarker setMarkerShape '%3'; _newMarker setMarkerType '%4'; _newMarker setMarkerDir %5; _newMarker setMarkerColor '%6'; _newMarker setMarkerAlpha %7; %8 %9",
			_markerName,
			(getMarkerPos _x),
			(markerShape _x),
			(markerType _x),
			(markerDir _x),
			(getMarkerColor _x),
			(markerAlpha _x),
			if ((markerShape _x) == "RECTANGLE" ||(markerShape _x) == "ELLIPSE") then { "_newMarker setMarkerSize " + str(markerSize _x) + ";"; } else { ""; },
			if ((markerShape _x) == "RECTANGLE" || (markerShape _x) == "ELLIPSE") then { "_newMarker setMarkerBrush " + str(markerBrush _x) + ";"; } else { ""; }
			];
	} forEach allMapMarkers;
};

_text = "";
{
	_text = _text + _x;
	[_x, nil, nil, false] call Phobos_fnc_LogMessage;
} forEach _output;

missionNamespace setVariable ['Ares_CopyPaste_Dialog_Text', _text];
_dialog = createDialog "Ares_CopyPaste_Dialog";

_diagTimeStop = diag_tickTime;
_processInfo = format ["Generated SQF from (%1 groups, %2 units, %3 occupied vehicles, %4 empty vehicles, %5 objects) in %6s", _totalGroups, _totalUnits, _totalOccupiedVehicles, _totalEmptyVehicles, _totalEmptyObjects, _diagTimeStop - _diagTimeStart];
[_processInfo] call Ares_fnc_showZeusMessage;
[_processInfo] call Phobos_fnc_logMessage;

#include "\Phobos_aresExpansion\module_footer.hpp"


