class Phobos
{
      class init
      {
            file = "\Phobos_aresExpansion\functions\init";
            class initPhobos { preInit = 1; }; 
      };
      class events
      {
            file = "\Phobos_aresExpansion\functions\events";
            class onModuleTreeLoad;
      };
      
      class utility
      {
            file = "\Phobos_aresExpansion\functions";
            class monitorCuratorDisplay;
            class logMessage;
            class initGlobalVariables;
			class getParentMod;
      };
      
      class ui
      {
            file = "\Phobos_aresExpansion\ui\functions";
            class welcomeScreen {};
            class whatIsNew {};
            class initMenu {};
			class welcomeScreenFnc {};
      };
               
      #include "cfgFunctionsAIBehaviour.hpp"
      #include "cfgFunctionsAIEngagementRules.hpp"
      #include "cfgFunctionsAIMisc.hpp"
      #include "cfgFunctionsAISpeedMode.hpp"
      #include "cfgFunctionsCombatAnimations.hpp"
      #include "cfgFunctionsDeveloperTools.hpp"
      #include "cfgFunctionsMisc.hpp"
      #include "cfgFunctionsObjectCustomization.hpp"
      #include "cfgFunctionsObjectPositioning.hpp"
      #include "cfgFunctionsPrefixes.hpp"
      #include "cfgFunctionsRoleplay.hpp"
      #include "cfgFunctionsSideRelations.hpp"
};
