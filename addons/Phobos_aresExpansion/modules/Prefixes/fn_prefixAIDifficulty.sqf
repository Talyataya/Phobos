//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.2
// Description: Changes placed units' difficulty.(Only for units placed after this module is used.)
// Changelog: 
// v1.2: 
//		* Changed: Ares_fnc_showChooseDialog --> Phobos_fnc_showChooseDialog
// 		* Enhanced: Now uses slider instead of editbox.
// v1.1: 
//		* Fixed: Wrong variable was being checked to delete previous removeEventHandler, if existed.
//
//////////////////////////////////////////////////////////////
#include "\Phobos_aresExpansion\module_header.hpp"
#define DEFAULT_AI_DIFFICULTY 0.5

_zeusLogic = getAssignedCuratorLogic player;
_defaultValue = DEFAULT_AI_DIFFICULTY;
if (not (isNil "Phobos_fnc_prefixAIDifficulty_EH_Index")) then 
{	
	_zeusLogic removeEventHandler ["CuratorObjectPlaced",Phobos_fnc_prefixAIDifficulty_EH_Index];
	_defaultValue = Phobos_fnc_prefixAIDifficulty_selectedAISkillValue;
};
_chatResult =
	["Custom AI Difficulty",
		[
			["Select General AI Skill:" , [0,_defaultValue,1,2]]
		]
	] call Phobos_fnc_showChooseDialog;
		
if (count _chatResult > 0) then 
{
	Phobos_fnc_prefixAIDifficulty_selectedAISkillValue = _chatResult select 0;
	Phobos_fnc_prefixAIDifficulty_EH_Index = _zeusLogic addEventHandler ["CuratorObjectPlaced",{(_this select 1) setSkill Phobos_fnc_prefixAIDifficulty_selectedAISkillValue;}];
};

#include "\Phobos_aresExpansion\module_footer.hpp"