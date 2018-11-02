class Phobos_Module_AIEngagementRule_Blue : Phobos_AIEngagementRules_Module_Base 
{
	scopeCurator = 2;
	displayName = "BLUE (Never Fire)";
	function = "Phobos_fnc_aiEngagementRulesBlue";
};

class Phobos_Module_AIEngagementRule_Green : Phobos_AIEngagementRules_Module_Base 
{
	scopeCurator = 2;
	displayName = "GREEN (Hold Fire - Defend Only)";
	function = "Phobos_fnc_aiEngagementRulesGreen";
};

class Phobos_Module_AIEngagementRule_Red : Phobos_AIEngagementRules_Module_Base 
{
	scopeCurator = 2;
	displayName = "RED (Fire at will, Engage at will)";
	function = "Phobos_fnc_aiEngagementRulesRed";
};

class Phobos_Module_AIEngagementRule_White : Phobos_AIEngagementRules_Module_Base 
{
	scopeCurator = 2;
	displayName = "WHITE (Hold Fire, Engage at will)";
	function = "Phobos_fnc_aiEngagementRulesWhite";
};

class Phobos_Module_AIEngagementRule_Yellow : Phobos_AIEngagementRules_Module_Base 
{
	scopeCurator = 2;
	displayName = "YELLOW (Fire at will)";
	function = "Phobos_fnc_aiEngagementRulesYellow";
};
