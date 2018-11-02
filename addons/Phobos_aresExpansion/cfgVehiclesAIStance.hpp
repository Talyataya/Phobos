class Phobos_Module_AIStance_Auto : Phobos_AIStance_Module_Base
{
	scopeCurator = 2;
	displayName = "Auto";
	function = "Phobos_fnc_aiStanceAuto";
};

class Phobos_Module_AIStance_Down : Phobos_AIStance_Module_Base
{
	scopeCurator = 2;
	displayName = "Prone";
	function = "Phobos_fnc_aiStanceDown";
};

class Phobos_Module_AIStance_Middle : Phobos_AIStance_Module_Base
{
	scopeCurator = 2;
	displayName = "Crouch";
	function = "Phobos_fnc_aiStanceMiddle";
};

class Phobos_Module_AIStance_Up : Phobos_AIStance_Module_Base
{
	scopeCurator = 2;
	displayName = "Stand";
	function = "Phobos_fnc_aiStanceUp";
};