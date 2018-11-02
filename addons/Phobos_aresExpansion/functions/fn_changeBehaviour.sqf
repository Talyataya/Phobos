//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Editing selected groups' behaviour.
// Changelog:
//	v1.1: 
//		*Enhanced: Now supports multiple units (and their groups) to change.
//		*Changed: All behaviour modifications are now being done by single function.
//
//////////////////////////////////////////////////////////////

_behaviour = _this select 0;
if (count Phobos_selectedObjects > 0) then
{
	{_x setBehaviour _behaviour;} forEach Phobos_selectedObjects;
	[format ["Selected units' group will act as in %1 mode.", _behaviour]] call Ares_fnc_ShowZeusMessage;
}
else 
{
	["No units were selected."] call Ares_fnc_ShowZeusMessage;
};
