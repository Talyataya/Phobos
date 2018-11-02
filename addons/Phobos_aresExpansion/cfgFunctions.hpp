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
		class handleCuratorKeyPressed;
		//class handleCuratorKeyReleased;
	};

	class utility
	{
		file = "\Phobos_aresExpansion\functions";
		class camDelete;
		class camExists;
		class camGetPrevious;
		class camGetProperties;
		class camProperties;
		class camSetProperties;
		class camWaypoint;
		class changeBehaviour;
		class changeEngagementRules;
		class changeSpeedMode;
		class changeStance;
		class cutsceneAddNew;
		class cutsceneDelete;
		class cutsceneGetAll;
		class cutscenePrepare;
		class cutsceneExtract;
		class getChangelog;
		class getParentMod;
		class initGlobalVariables;
		class isVariableEligible;
		class logMessage;
		class monitorCuratorDisplay;
		class roundNumber;
		class showChooseDialog;
		class strToArray;
		class strLen;
		class strReplace;
	};

	class ui
	{
		file = "\Phobos_aresExpansion\ui\functions";
		class displayChangelog {};
		class displayChangelogFnc {};
		class initMenu {};
		class welcomeScreen {};
		class welcomeScreenFnc {};
	};
	
	#include "cfgFunctionsAIBehaviour.hpp"
	#include "cfgFunctionsAIEngagementRules.hpp"
	#include "cfgFunctionsAIMisc.hpp"
	#include "cfgFunctionsAISpeedMode.hpp"
	#include "cfgFunctionsAIStance.hpp"
	#include "cfgFunctionsCombatAnimations.hpp"
	#include "cfgFunctionsCutscene.hpp"
	#include "cfgFunctionsDeveloperTools.hpp"
	#include "cfgFunctionsMisc.hpp"
	#include "cfgFunctionsObjectCustomization.hpp"
	#include "cfgFunctionsObjectPositioning.hpp"
	#include "cfgFunctionsPrefixes.hpp"
	#include "cfgFunctionsRoleplay.hpp"
	#include "cfgFunctionsSaveMission.hpp"
	#include "cfgFunctionsSideRelations.hpp"
};
