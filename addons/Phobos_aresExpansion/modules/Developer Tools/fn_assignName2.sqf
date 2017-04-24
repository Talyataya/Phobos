//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Assigns name on placed object: 'object2'. (Useful when not having Developer Console.)
// Changelog: None
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

if (not (isNull _unitUnderCursor)) then
{
	object2 = _unitUnderCursor;
	["This object is now named as 'object2'."] call Ares_fnc_ShowZeusMessage;
}
else
{
	["Module needs to be dropped on an object."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"