#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;
if (not (isNull _unitUnderCursor)) then
{
	_unitUnderCursor setBehaviour "AWARE";
	["This unit's group will act as Aware."] call Ares_fnc_ShowZeusMessage;
}
else 
{
	["Module needs to be dropped on a unit."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"
