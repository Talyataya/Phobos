class Phobos_Module_Cutscene_CamAddObject : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
	displayName = "Add Camera Object";
	function = "Phobos_fnc_moduleCamAddObject";
}

class Phobos_Module_Cutscene_CamCreate : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
	displayName = "Create Camera";
	function = "Phobos_fnc_moduleCamWaypoint";
};

class Phobos_Module_Cutscene_CamProperties : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
	displayName = "Modify Camera";
	function = "Phobos_fnc_moduleCamProperties";
};

/*
class Phobos_Module_Cutscene_CamSwap : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
    displayName = "Swap cameras";
	
};
*/

class Phobos_Module_Cutscene_CutsceneCreate : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
	displayName = "Create Cutscene";
	function = "Phobos_fnc_moduleCutsceneCreate";
};

class Phobos_Module_Cutscene_CutsceneExtract : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
	displayName = "Extract Cutscene";
	function = "Phobos_fnc_moduleCutsceneExtract";
};

class Phobos_Module_Cutscene_CutscenePreview : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
	displayName = "Preview Cutscene";
	function = "Phobos_fnc_moduleCutscenePreview";
};

class Phobos_Module_Cutscene_CutscenePlay : Phobos_Cutscene_Module_Base
{
	scopeCurator = 2;
	displayName = "Play Cutscene";
	function = "Phobos_fnc_moduleCutscenePlay";
};