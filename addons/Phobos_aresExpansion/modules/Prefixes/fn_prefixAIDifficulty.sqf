//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Changes placed units' difficulty.(Only for units placed after this module is used.)
// Changelog: 
// v1.1: 
//		* Fixed: Wrong variable was being checked to delete previous removeEventHandler, if existed.
//
//////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\module_header.hpp"

_zeusLogic = getAssignedCuratorLogic player;
if (not (isNil "Phobos_customAIDifficultyEHIndex")) then 
{	
	_zeusLogic removeEventHandler ["CuratorObjectPlaced",Phobos_customAIDifficultyEHIndex];
};
_chatResult =
	["Custom AI Difficulty",
		[
			["Select General AI Skill:" , ""]
		]
	] call Ares_fnc_showChooseDialog;
		
if (count _chatResult > 0) then 
{
	if (parseNumber (_chatResult select 0)>=0 && (parseNumber (_chatResult select 0))<=1) then 
	{
		Phobos_selectedAISkillValue = parseNumber (_chatResult select 0);
		Phobos_customAIDifficultyEHIndex = _zeusLogic addEventHandler ["CuratorObjectPlaced",{(_this select 1) setSkill Phobos_selectedAISkillValue;}];
	}
else 
	{
		["A number between 0 and 1 must be chosen."] call Ares_fnc_ShowZeusMessage; 
	}
};

#include "\Phobos_aresExpansion\module_footer.hpp"