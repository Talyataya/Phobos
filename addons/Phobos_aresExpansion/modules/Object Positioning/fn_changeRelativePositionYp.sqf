//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Changes Relative Object Position(Helpful for details that is hard to change with mouse or going sub zero altitude).
// Changelog: 
// v1.1:
// *Changed: Now changes position relative to old position(in its own X, Y, Z axises instead of map X/Y/Z Axises.)
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

if (not (isNull _unitUnderCursor)) then
{
	_currentLocation = _unitUnderCursor worldToModel (getPosWorld _unitUnderCursor);
	_unitUnderCursor setPosWorld (_unitUnderCursor modelToWorld [_currentLocation select 0, (_currentLocation select 1)+0.05 , _currentLocation select 2]);
}
else
{
	["Module needs to be dropped on a unit."] call Ares_fnc_ShowZeusMessage;
};
#include "\Phobos_aresExpansion\module_footer.hpp"

