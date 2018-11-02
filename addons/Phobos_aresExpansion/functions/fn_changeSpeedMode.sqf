//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Editing selected groups' Speed Mode.
// Changelog:
//	v1.1:
//		*Changed: All speed mode modifications are now being done by single function.
// 
//////////////////////////////////////////////////////////////

_speedMode = _this select 0;
if(count Phobos_selectedObjects > 0) then
{
	{_x setSpeedMode _speedMode;} forEach Phobos_selectedObjects;
	[format ["Selected groups' speed is set to %1 Speed.", _speedMode]] call Ares_fnc_ShowZeusMessage;
}
else
{
	["No units were selected."] call Ares_fnc_ShowZeusMessage;
};