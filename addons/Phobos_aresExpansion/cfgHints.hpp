class Phobos
{
	displayName = "Phobos";
	logicalOrder = 24; //Element 23 is Zeus.
    class introduction
	{
		displayName = "Phobos";
		description = "%3Phobos%4 is a mod, dedicated to expand Zeus' abilities in order to provide an environment for Zeus to have more control over the scenario. It is focusing on providing %3more features%4 while providing %3faster development%4 for experienced Zeuses.";
		tip = "%3Phobos%4 requires Ares or an Ares included mod(ie. Achilles) in order to work, however it is not guaranteed to work as intended on non-pure Ares mods.";
		image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
		logicalOrder = 1;
	};
	
	class objectSelection
	{
          displayName = "Selecting Object(s)";
          description = "%3Phobos%4 is using basic object selection as a core ability, allowing players to select multiple units/objects and applying module's feature to all of them, in order to provide ability to faster development for experienced Zeuses.%1Pre-Selecting units is done through %3highlighting%4 units and/or objects. %1To highlight a unit: %1Either %3Left click%4 a unit and select more units by holding %3CTRL%4 %1Or Drag a box by holding %3Left Mouse Button%4.%1After selecting units, choose a module that uses this selection of units/objects and let module do its job."; 
          tip = "If you wish to use this feature as a part of your scripts inside Zeus, you can access this Global Variable by calling 'Phobos_SelectedObjects'. (Returns array of selected objects.)";
          image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
		  logicalOrder = 2;
    };
    
	class moduleTypes
	{
		displayName = "Module Types";
		subDisplayName = "Know Your Tools.";
		description = "In %3Phobos%4 there are multiple types of modules which are supposed to be used in different subjects. %1%2 These modules will guide you on how to use that module and do not require any extra knowledge.%1%2 These modules require you to %3pre-select units or objects%4 that will be affected when placing the module.";
		tip = "When you use a module, %3Phobos%4 will always give feedback to you regarding what type of objects(ie. units, groups or static objects) it affects. In future updates, more support will be provided in this case.";
	    image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
		logicalOrder = 3;
    };
	
	class prefixes 
	{
		displayName = "Prefix Modules";
		description = "%3Phobos%4 provides %3automatic modifiers%4 for basic needs. These prefixes edit attributes based on their feature and only is activated on %3Curator Request%4. Prefixes work with %3toggle logic%4, meaning both activating and deactivating is done through choosing the same module again.";
		tip =  "%3Phobos%4 currently contains 2 prefixes:%1%2%3AI Difficulty Prefix:%4 After used, changes difficulty of AIs created afterwards.%1%2%3AI Patrol Prefix:%4 When toggled, automatically sets ais in RELAX Behavior and Speed set on limited";
	    image = "A3\Ui_f\data\gui\cfg\hints\zeus_ca.paa";
		logicalOrder = 4;
    };
	/*
	class cinematics
	{
		displayName = "Cutscenes - BETA";
		description = "%3Phobos%4 allows curators to create their own cutscenes with its advanced cutscene creation system.%1 With %3Phobos%4, you can create, preview and play your cutscene in matters of seconds or minutes, based on your creativity.%1 And if you just want to use the cutscene not inside your ongoing mission, you can save it for later and play it %3anywhere%4.%1 %3Phobos Cutscene Editor%4 allows you to create cutscenes indifferent from a professional cutscene scripter with this simple tool.";
		tip = "Buttons apart from provided Cutscene modules:%1%2To %3create camera%4 for a cutscene: %3[CTRL]%4 + %3[F1/F12]%4.%1%2To %3modify camera%4 for a cutscene: %3[SHIFT]%4 + %3[F1/F12]%4.%1%1%3Phobos Cutscene Editor%4 requires no dependency, allowing you to extract code, and use it in any zeus server or editor mission, without requiring %3Phobos%4 itself!";
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 5;
	};
	*/
};

class PhobosCutsceneEditor
{
	displayName = "Phobos Cutscene Editor - BETA";
	logicalOrder = 25;
	class introduction
	{
		displayName = "Phobos Cutscene Editor";
		description = "%3Phobos Cutscene Editor(PCE)%4 is a system built to allow any curator (regardless of knowing scripting or not) to easily create cutscenes indifferent from a professional scripter. With %3Phobos%4, you can create, preview and play your cutscene in a matter of seconds or minutes, based on your creativity. Due the %3nature of Phobos%4 being a tool to %3expand Curator Mode(Zeus Mode)%4, which is an environment where every second matters, %3PCE is automated and simplified without lacking any features or options%4 that could be open to players. While this integrated system is built for Curator Mode, due no tools' existance to create what %3Phobos Cutscene Editor%4 provides, it also provides support and makes sure that anything created by this tool %3can be used anywhere, any time, even without the necessity of Phobos being active%4.";
		tip = "You can create a cutscene and use it anywhere without needing Phobos at all! After you create a cutscene, you can use it on(Considering you have a debug console):%1%2Current Zeus Server with Phobos,%1%2Another Zeus Server with Phobos,%1%2Another Zeus Server without Phobos,%1%2Any Public Zeus Server,%1%2Any Editor Mission,%1%2Basically anywhere..."; 
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 1;
	};
	
	class basics 
	{
		displayName = "Logical Structure";
		description = "%3Phobos Cutscene Editor%4 has its own basic logic to ensure it is as %3simple%4 as every player can understand the system they are using. This system focuses on 2 basic items:%1%2%3Cutscene:%4 A cutscene is being built by multiple cameras.%1%2%3Camera%4: Simple component of a cutscene created by 16 components.";
		tip = "Note that despite the name, it is actually only a single camera that handles a cutscene, so thinking of cameras as camera waypoints may be more logical.";
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 2;
	};
	
	class requirements 
	{
		displayName = "Requirements";
		description = "In %3PCE%4, both cameras and cutscenes have %3requirements%4. Without these requirements fulfilled, curator is unable to benefit from the system.%1%2%3Cutscene:%4 A cutscene requires at least 1 camera to be functional.%1%2%3Camera:%4 A camera requires at least one position and target set.";
		tip = "Phobos modules and buttons handle everything to make sure curator's cutscene is safe. However there is a chance of camera getting destroyed; if that camera is bound to an object either by relative position or target, deleting the object by any means will cause the destruction of the camera, and will be removed from the cutscene. In such case the curator will be notified with a notification regarding the issue and has to recreate the camera if needed.";
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 3;
	};
	/*
	class easeOfUse
	{
		displayName = "Smart System"; //Find a proper display name.
		description = "Each camera created, %3copies the attributes of the previous camera%4 for curator to not change every single value for each camera created for that cutscene. Complex camera properties continuously %3guiding and controlling your entries%4 to ensure you're using them correctly, if entered any incorrect data, previously saved data overwrites wrong values. It also %3watches over your cameras and notifies you%4 in case they get broken somehow(such as a target vehicle of a camera is being deleted, you'll be notified before displaying a ruined cutscene.)";
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 4;
	};
	*/
	class keybinds 
	{
		displayName = "Keybinds";
		description = "Additional to provided modules, %3PCE%4 provides keybinds to ease up the usage of the system for short cutscenes.%1%2To %3create camera%4 for a cutscene: %3[CTRL]%4 + %3[F1/F12]%4.%1%2To %3modify camera%4 for a cutscene: %3[SHIFT]%4 + %3[F1/F12]%4.";
		tip = "All cameras created by the keybinds are part of the cutscene 'Phobos_Cutscene'";
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 5;
	};
	
	class cutscenePlayNotes
	{
		displayName = "Multiple Cutscenes At Once";
		description = "%3Phobos Cutscene Editor%4 has been %3designed to support infinite amount of cutscenes run at the same time%4. Example: You may have a mission where multiple sides are present, and you may want to show one side their own side of cutscene while the other side, their own side with another cutscene. In such case, you are able to %3create multiple cutscenes%4 for multiple players you choose.";
		tip = "%3Attention:%4 In case a player and/or a curator is chosen to watch a cutscene while they're still watching another cutscene, they will not be able to watch the new cutscene and will simply skip it."
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 6;
	}
	
	class extractMethods
	{
		displayName = "Extraction Methods";
		description = "In %3Phobos%4, when you create a cutscene, you may not be needing that cutscene for that particular game session or simply you may have wanted to use it for another purpose from the start. For the sake of being usable anywhere, and any time; %3Phobos%4 provides%3 2 methods of extraction%4, with each of them having their own benefits.%1%2%3PCE Code:%4 Creates a code that sets up the cutscene into %3Phobos Cutscene Editor%4. Since it can be loaded back just like a fresh cutscene, provides benefits like modifying and when played, handles potential multiplayer environment issues(in case of other cutscenes by other curators can be created).%1%2%3Vanilla A3 Code:%4 Creates the code independent from Phobos; %3usable anywhere, any way, any time%4 but %3not modifiable%4 apart from general cutscene values that are granted.";
		tip = "It is always suggested to %3use PCE Code if Phobos is enabled%4, as it %3handles any issue that can occur by other curators%4. If you're going to use a cutscene code for a %3non-Phobos environment%4, it is always %3suggested to get a PCE Code as a backup%4 since you can edit and convert it to Vanilla A3 Code any time.%1%1%3Warning:%4 Do not forget to designate every object in the mission before you extract a cutscene.(ie. If you have your *cutsceneName*'s *cameraID* targeting a MRAP, you need to assign variable name *cutsceneName*_*cameraID*_Target to that object. For position it would be *cutsceneName*_*cameraID*_Position instead. Basically the names that are displayed on properties.)%1This should be done before PCE Code is used for the session otherwise cameras will report that they are not functional. A camera is not functional if it is not able to display properties.";
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 7;
	};
	
	class extractedCodeParams
	{
		displayName = "Modifying Cutscene Parameters";
		description = "In %3case of PCE%4 used, %3modifying%4 cutscene parameters(ex. such as playing a custom music track on cutscene start, or showing cutscene only to BLUFOR units) are asked when curator decides to play the cutscene. However in %3case of Vanilla A3 Code%4, as there is no way to know the environment the cutscene will be played by %3PCE%4, players are expected to fill in the first square brackets(ie. []) of code to change default parametes granted. These parameters are:%1%2%3Spectators:%4 Players who will be watching the cutscene. (Array of objects) [Default: All players excluding Headless Clients]%1%2%3Length Multiplier:%4 Entire cutscene length multiplied by this value. (Number) [Default: 1]%1%2%3Music:%4 Music that will be played. (String, class name of music in cfgMusics) [Default: '', will not interrupt any ongoing music]%1%2%3Music Volume:%4 Volume percentage of music. (Float Number) [Default: 0.5 in editor, dependent on Add Music module in curator mode]%1%2%3Execute Scripts:%4 If scripts provided to cutscene cameras to be executed. (Boolean) [Default: True]";
		tip = "Assume you extracted a cutscene and want to use it in your editor mission. You have a co-op mission with 4 players and you would like to show the cutscene to the players with variable names: %3player1, player2%4 and keep rest of values as default. In such case your square bracket would look like %3[[player1,player2]]%4 or for %3player1 only%4, it would look like %3[[player1]]%4. Pay %3attention that it is not%4 [player1,player2] or [player1], as you would then mean that your spectators are player1(an issue because it is not an array of object, it is just an object and length multiplier would be player2, again an error because you passed an object to somewhere that requires integer.%1%1Let`s assume you want to keep everything default but modify music class name instead. You want to play music named: 'This is War' with %3 85%11 %4 volume. In such case, you can %3go to editor%4, press %3[ALT]+[G]%4 to access config viewer. %3Find CfgMusics%4 from the %3list on left%4, %3double click%4 to open the list of it. %3Check every music%4 until you find the entry: %3name = 'This is War'%4 on the right window, and copy the name on the left list you had found which in this case, would be %3'LeadTrack01_F'%4. Then plug it as %3[nil, nil, 'LeadTrack01_F', 0.85]%4. %3nil%4 means you want to keep that particular value as default.%1%1Do not fear from failing as next 5 lines of code, states default values in case of any wrong parameter types were given. If you do not notice any change after your attempt to modify, it most likely means you did something wrong and saved by default values.%1%1%3Do not attempt to modify anything inside {} brackets%4 unless you know what you are doing. This information is only meant for [] bracket at the very start.%1%1If you have understood what is going on in here, and has been successful, congratulations; you have also understood some essentials of scripting aswell! You`re awesome!";
		arguments[] = {{"%"}};
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 8;
	};
	
	class coding
	{
		displayName = "Coding";
		description = "Based on your scripting knowledge, you may want to %3enrich your cutscene even more%4. In %3PCE%4, every camera has a parameter called 'Code', and these %3custom codes are activated when this camera is reached%4 while the cutscene is being played.%1%1Coding in %3PCE%4 is %3just like coding in 3Den Editor%4, a code written in there is executed by all players in the mission. A %3cutscene is being played by all players%4 even if it's not being watched by all players, this is to ensure that these custom codes can %3support 'isServer' and 'local' commands%4. Since these codes are already executed on all players, %3no multiplayer scripting is needed%4. Instead if required to be executed only once, the scripter can just use these commands based on what their code requires.";
		
		tip = "Codes support suspending(ie. You can use sleep, waitUntil commands). Codes have additional parameters that can be used. Those can be accessed by:%1%2_this select 0: Camera Object.%1%2_this select 1: ppEffectHandle.%1%2_this select 2: An array of all properties of the related camera.%1%2_this select 3: An array of all properties of cutscene.";
		image = "A3\Ui_f\data\gui\cfg\hints\thirdperson_ca.paa";
		logicalOrder = 9;
	};
};
