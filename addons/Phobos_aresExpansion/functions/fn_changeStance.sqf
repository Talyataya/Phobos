//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Modifies selected units' stances.
// Changelog: None.
// 
//////////////////////////////////////////////////////////////

_stance = _this select 0;
if(count Phobos_selectedObjects > 0) then
{
	{_x setUnitPos _stance;} forEach Phobos_selectedObjects;
	[format ["Selected units' stance is set to %1", _stance]] call Ares_fnc_ShowZeusMessage;
}
else
{
	["No units were selected."] call Ares_fnc_ShowZeusMessage;
};