#include "BIS_AddonInfo.hpp"
class CfgPatches 
{
                 class Phobos
                 {
                       name="Phobos";
                       author[]={"Talya"};
                       url ="";
                       version = 0.5.2;
                       versionStr = "0.5.2";
                       versionAr[] ={0,5,2};
                       requiredVersion = 0.1;
                       #include "units.hpp"
                       requiredAddons[] =
                       {
                                        "A3_UI_F",
                                        "A3_UI_F_Curator",
                                        "A3_Functions_F",
                                        "A3_Functions_F_Curator",
                                        "A3_Modules_F",
                                        "A3_Modules_F_Curator"
                       };
                 };
};

class CfgVehicles
{
      class Logic ;
      class Module_F : Logic {};
      class Ares_Module_Base : Module_F {};
      
      class Phobos_Module_Base : Ares_Module_Base
      {
            author="Talya";
            displayName= "Phobos Module Base";
            category = "Phobos";
      };
      
      class Phobos_AIBehaviour_Module_Base : Phobos_Module_Base
      {
            subCategory = "Set AI Behaviour";
      };
      
      class Phobos_AIEngagementRules_Module_Base : Phobos_Module_Base
      {
            subCategory = "Set AI Engagement Rules";
      };
      
      class Phobos_AIMics_Module_Base : Phobos_Module_Base
      {
            subCategory = "Set AI Misc";
      };
      
      class Phobos_AISpeedMode_Module_Base : Phobos_Module_Base
      {
            subCategory = "Set AI Speed";
      };
      
      class Phobos_CombatAnimations_Module_Base : Phobos_Module_Base
      {
            subCategory = "Animations: Combat";
      };
            
      class Phobos_DeveloperTools_Module_Base : Phobos_Module_Base
      {
            subCategory = "Developer Tools";
      };
      
      class Phobos_Misc_Module_Base : Phobos_Module_Base
      {
            subCategory = "Misc";
      };
      
      class Phobos_ObjectCustomization_Module_Base : Phobos_Module_Base
      {
            subCategory = "Object Customization";
      };
      
      class Phobos_ObjectPositioning_Module_Base : Phobos_Module_Base
      {
            subCategory = "Object Position (±0.05)";
      };
      
      class Phobos_Prefixes_Module_Base : Phobos_Module_Base
      {
            subCategory = "Prefixes";
      };
      
      class Phobos_Roleplay_Module_Base : Phobos_Module_Base
      {
            subCategory = "Roleplay";
      };
      
      class Phobos_SaveMission_Module_Base : Phobos_Module_Base
      {
            subCategory = "Phobos Save/Load";
      };
            
      class Phobos_SideRelations_Module_Base : Phobos_Module_Base
      {
            subCategory = "Diplomacy";
      };
      
      #include "cfgVehiclesAIBehaviour.hpp"
      #include "cfgVehiclesAIEngagementRules.hpp"
      #include "cfgVehiclesAIMisc.hpp"
      #include "cfgVehiclesAISpeedMode.hpp"
      #include "cfgVehiclesCombatAnimations.hpp"
      #include "cfgVehiclesDeveloperTools.hpp"
      #include "cfgVehiclesMisc.hpp"
      #include "cfgVehiclesObjectCustomization.hpp"
      #include "cfgVehiclesObjectPositioning.hpp"
      #include "cfgVehiclesPrefixes.hpp"
      #include "cfgVehiclesRoleplay.hpp"
      #include "cfgVehiclesSaveMission.hpp"
      #include "cfgVehiclesSideRelations.hpp"
};        

class cfgHints
{
      #include "cfgHints.hpp"
};
class cfgFunctions 
{
      #include "cfgFunctions.hpp"
};

#include "ui\baseDialogs.hpp"
#include "ui\welcomeDialog.hpp"
#include "ui\shutdownDialog.hpp"
#include "ui\dynamicDialog.hpp"
#include "ui\changelogDialog.hpp"

class RscStandardDisplay;
class RscDisplayMain : RscStandardDisplay
{
      onLoad = "_this call compile preprocessfilelinenumbers '\Phobos_aresExpansion\ui\functions\fn_initMenu.sqf'";
};
