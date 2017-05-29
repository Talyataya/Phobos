//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Module to reveal and edit(Not yet) all variables of unit under cursor.
// Changelog: None.
// Notes: Edit part is not included yet.
//		  Null and nil vars are not handled properly to be distinguished.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

_array = [];
{
	private ["_varName", "_varValue"];
	_varName = _x;
	_varValue = (_unitUnderCursor getVariable (_x));
	if(isNil "_varValue") then { //null returns true aswell, no difference for null and nil for setVariable?
		_varValue = "nil";
	};
	_subArray = [_varName + ":",str _varValue];
	_array pushBack _subArray;
} forEach (allVariables _unitUnderCursor);


_chatResult = ["Entity Variables",_array] call Phobos_fnc_showChooseDialog;

if (_chatResult != -1) exitWith {
	["Unable to change variables, feature not implemented yet."] call Ares_fnc_showZeusMessage;
};

//TODO: Add feature to modify when pressed OK.

#include "\Phobos_aresExpansion\module_footer.hpp"
