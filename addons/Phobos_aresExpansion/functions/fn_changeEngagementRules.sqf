//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Editing selected groups' Engagement Rules.
// Changelog:
//	v1.1:
//		*Changed: All engagement rules' modifications are now being done by single function.
// 
//////////////////////////////////////////////////////////////

_engagementRule = _this select 0;
if(count Phobos_selectedObjects > 0) then
{
	{_x setCombatMode _engagementRule;} forEach Phobos_selectedObjects;
	[format ["Selected groups' combat mode is set to %1", _engagementRule]] call Ares_fnc_ShowZeusMessage;
}
else
{
	["No units were selected."] call Ares_fnc_ShowZeusMessage;
};