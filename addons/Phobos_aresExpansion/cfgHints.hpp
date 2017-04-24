class Phobos
{
	displayName = "Phobos";
    class introduction
	{
		displayName = "Phobos";
		description = "%3Phobos%4 is a mod, dedicated to expand Zeus' abilities in order to provide an environment for Zeus to have more control over the scenario. It is focusing on providing %3more features%4 while providing %3faster development%4 for experienced Zeuses.";
		tip = "%3Phobos%4 requires Ares or an Ares included mod(ie. Achilles) in order to work, however it is not guaranteed to work as intended on non-pure Ares mods.";
		image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
	};
	
	class objectSelection
	{
          displayName = "Selecting Object(s)";
          description = "%3Phobos%4 is using basic object selection as a core ability, allowing players to select multiple units/objects and applying module's feature to all of them, in order to provide ability to faster development for experienced Zeuses.%1Pre-Selecting units is done through %3highlighting%4 units and/or objects. %1To highlight a unit: %1Either %3Left click%4 a unit and select more units by holding %3CTRL%4 %1Or Drag a box by holding %3Left Mouse Button%4."; 
          tip = "If you wish to use this feature as a part of your scripts inside Zeus, you can access this Global Variable by calling 'Phobos_SelectedObjects'. (Returns array of selected objects.)";
          image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
    };
    
	class moduleTypes
	{
		displayName = "Module Types";
		subDisplayName = "Know Your Tools.";
		description = "In %3Phobos%4 there are multiple types of modules which are supposed to be used in different subjects. %1%2 These modules will guide you on how to use that module and do not require any extra knowledge.%1%2 These modules require you to %3pre-select units or objects%4 that will be affected when placing the module.";
		tip = "When you use a module, %3Phobos%4 will always give feedback to you regarding what type of objects(ie. units, groups or static objects) it affects. In future updates, more support will be provided in this case.";
	    image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
    };
	
	class prefixes 
	{
		displayName = "Prefix Modules";
		description = "%3Phobos%4 provides %3automatic modifiers%4 for basic needs. These prefixes edit attributes based on their feature and only is activated on %3Curator Request%4. Prefixes work with %3toggle logic%4, meaning both activating and deactivating is done through choosing the same module again.";
		tip =  "%3Phobos%4 currently contains 2 prefixes:%1%2%3AI Difficulty Prefix:%4 After used, changes difficulty of AIs created afterwards.%1%2%3AI Patrol Prefix:%4 When toggled, automatically sets ais in RELAX Behavior and Speed set on limited";
	    image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
    };
};
