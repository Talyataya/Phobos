//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Tests for entire PCE(Phobos Cutscene Editor) functions.
// Changelog: None.
// Notes: 
//			*For some reason, __LINE__ returns -1.
//		  	*Expand for event handlers.
//////////////////////////////////////////////////////////////

//assert provided by engine comes to an halt. So we create our own.
#define ASSERT_TRUE(ARG1) if (!(ARG1)) then {diag_log format ["Line %1: Assertation Failed. Found 'False', Expected 'True'.", __LINE__ + 1]};
#define ASSERT_FALSE(ARG1) if (ARG1) then {diag_log format ["Line %1: Assertation Failed. Found 'True', Expected 'False'.", __LINE__ + 1]};
#define ASSERT_EQUAL(ARG1, ARG2) if ((ARG1) != (ARG2)) then {diag_log format ["Line %1: Assertation Failed. %2 != %3", __LINE__ + 1, ARG1, ARG2]};
#define ASSERT_EQUAL_STRING(ARG1, ARG2) if (!((ARG1) isEqualTo (ARG2))) then {diag_log format ["Line %1: Assertation Failed. Strings %2 !== %3.", __LINE__ + 1, ARG1, ARG2]};
#define ASSERT_EQUAL_ARRAY(ARG1, ARG2) if (!((ARG1) isEqualTo (ARG2))) then {diag_log format ["Line %1: Assertation Failed. Arrays %2 !== %3.", __LINE__ + 1, ARG1, ARG2]};

["Initializing Testing of PCE Functions."] call Phobos_fnc_logMessage;

//============================================================
//Test for Cutscene creation.
private _testCutsceneAddNewBadName01 = ["9myCutscene"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddNewBadName02 = ["awe$omeCutscene"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddNewBadName03 = ["ExCutscene#1"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddNewBadName04 = ["GudCutscene?"] call Phobos_fnc_cutsceneAddNew;

ASSERT_EQUAL(_testCutsceneAddNewBadName01, 2);
ASSERT_EQUAL(_testCutsceneAddNewBadName02, 2);
ASSERT_EQUAL(_testCutsceneAddNewBadName03, 2);
ASSERT_EQUAL(_testCutsceneAddNewBadName04, 2);

private _allCutscenes = missionNamespace getVariable ["Phobos_Cutscenes", []];
ASSERT_EQUAL(count _allCutscenes, 0);

private _testCutsceneAddNewGoodName01 = ["My_Super_Duper_Film"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddNewGoodName02 = ["MyCutscene"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddNewGoodName03 = ["Phobos Test Cutscene"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddCopiedName01 = ["My_Super_Duper_Film"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddCopiedName02 = ["Phobos Test Cutscene"] call Phobos_fnc_cutsceneAddNew;
private _testCutsceneAddCopiedName03 = ["My_sUPeR_DuPER_FiLM"] call Phobos_fnc_cutsceneAddNew;

ASSERT_EQUAL(_testCutsceneAddNewGoodName01, 0);
ASSERT_EQUAL(_testCutsceneAddNewGoodName02, 0);
ASSERT_EQUAL(_testCutsceneAddNewGoodName03, 0);
ASSERT_EQUAL(_testCutsceneAddCopiedName01, 1);
ASSERT_EQUAL(_testCutsceneAddCopiedName02, 1);
ASSERT_EQUAL(_testCutsceneAddCopiedName03, 1);

private _allCutscenes = missionNamespace getVariable ["Phobos_Cutscenes", []];
ASSERT_EQUAL(count _allCutscenes, 3);
private _correctResult = ["My_Super_Duper_Film", "MyCutscene", "Phobos_Test_Cutscene"];
private _fncResult = [] call Phobos_fnc_cutsceneGetAll;
ASSERT_EQUAL_ARRAY(_allCutscenes, _correctResult);
ASSERT_EQUAL_ARRAY(_allCutscenes, _fncResult);

//=============================================================
//Test for CamCreation.
//Assumed 1-200 Cap.

["My_Super_Duper_Film", -2993, false, false] call Phobos_fnc_camWaypoint;
["My_Super_Duper_Film", 349, false, false] call Phobos_fnc_camWaypoint;
["My_Super_Duper_Film", 45, false, false] call Phobos_fnc_camWaypoint;
["My_Super_Duper_Film", 57, false, false] call Phobos_fnc_camWaypoint;
["MyCutscene", 23, false, false] call Phobos_fnc_camWaypoint;

private _result1 = missionNamespace getVariable [format ["My_Super_Duper_Film_%1", -2993], false];
private _result2 = missionNamespace getVariable [format ["My_Super_Duper_Film_%1", 349], false];
private _result3 = missionNamespace getVariable [format ["My_Super_Duper_Film_%1", 441], false];
private _result4 = missionNamespace getVariable [format ["My_Super_Duper_Film_%1", 98], false];
private _result5 = missionNamespace getVariable [format ["My_Super_Duper_Film_%1", 45], false];
private _result6 = missionNamespace getVariable [format ["My_Super_Duper_Film_%1", 57], false];
private _result7 = missionNamespace getVariable [format ["MyCutscene_%1", 23], false];

ASSERT_FALSE(_result1);
ASSERT_FALSE(_result2);
ASSERT_FALSE(_result3);
ASSERT_FALSE(_result4);
ASSERT_TRUE(_result5);
ASSERT_TRUE(_result6);
ASSERT_TRUE(_result7);

//==============================================================
//Test for CamExist.
//Assumed 1-200 Cap.

private _result1 = ["My_Super_Duper_Film", -2993] call Phobos_fnc_camExists;
private _result2 = ["My_Super_Duper_Film", 349] call Phobos_fnc_camExists;
private _result3 = ["My_Super_Duper_Film", 441] call Phobos_fnc_camExists;
private _result4 = ["My_Super_Duper_Film", 98] call Phobos_fnc_camExists;
private _result5 = ["My_Super_Duper_Film", 45] call Phobos_fnc_camExists;
private _result6 = ["My_Super_Duper_Film", 57] call Phobos_fnc_camExists;
private _result7 = ["MyCutscene", 23] call Phobos_fnc_camExists;


ASSERT_FALSE(_result1);
ASSERT_FALSE(_result2);
ASSERT_FALSE(_result3);
ASSERT_FALSE(_result4);
ASSERT_TRUE(_result5);
ASSERT_TRUE(_result6);
ASSERT_TRUE(_result7);

//=============================================================
//Test for CamDeletion.

["MyCutscene", 23] call Phobos_fnc_camDelete;
private _result = ["MyCutscene", 23] call Phobos_fnc_camExists;
ASSERT_FALSE(_result);


//=============================================================
//Test for CutsceneDeletion.

["My_Super_Duper_Film"] call Phobos_fnc_cutsceneDelete;
private _correctResult = ["MyCutscene", "Phobos_Test_Cutscene"];
private _allCutscenes = missionNamespace getVariable ["Phobos_Cutscenes", []];
ASSERT_EQUAL_ARRAY(_correctResult, _allCutscenes);
private _result1 = ["My_Super_Duper_Film", 45] call Phobos_fnc_camExists;
private _result2 = ["My_Super_Duper_Film", 57] call Phobos_fnc_camExists;
ASSERT_FALSE(_result1);
ASSERT_FALSE(_result2);

//=============================================================
//Test for camGetPrevious

["MyCutscene", 41, false, false] call Phobos_fnc_camWaypoint;
["MyCutscene", 96, false, false] call Phobos_fnc_camWaypoint;
["MyCutscene", 84, false, false] call Phobos_fnc_camWaypoint;

private _result = ["MyCutscene", 84] call Phobos_fnc_camGetPrevious;
private _correctResult = ["MyCutscene", 41];
ASSERT_EQUAL_ARRAY(_result, _correctResult);
private _result = ["MyCutscene", 96] call Phobos_fnc_camGetPrevious;
private _correctResult = ["MyCutscene", 84];
ASSERT_EQUAL_ARRAY(_result, _correctResult);

//=============================================================
//Test for camGetProperties

private _result = ["MyCutscene", 41] call Phobos_fnc_camGetProperties;
private _correctResult = [position curatorCamera, screenToWorld [0.5,0.5],false,5,0,0.7,0,0,1,0,1,0,-0.01,-0.01,-0.01,0,""]; 
ASSERT_EQUAL_ARRAY(_result, _correctResult);

//=============================================================
//Test for camSetProperties

private _customSettings1 = [[10,10,10], [20,20,0], false, 3, 1, 0.5, 0, 0, 0.7, 0, 0.75, 0, -0.01, -0.01,-0.01, 2, "hint 'helloworld'"];
["MyCutscene", 84,_customSettings1] call Phobos_fnc_camSetProperties;
private _result = ["MyCutscene", 84] call Phobos_fnc_camGetProperties;
ASSERT_EQUAL_ARRAY(_result, _customSettings1);

//=============================================================
//Test for new camera taking previous camera's data.(And excluding code)

["MyCutscene", 87, false, false] call Phobos_fnc_camWaypoint;
private _result = (["MyCutscene", 87] call Phobos_fnc_camGetProperties) select [2, 15];
private _correctResult = [false, 3, 1, 0.5, 0, 0, 0.7, 0, 0.75, 0, -0.01, -0.01,-0.01, 2, ""];
ASSERT_EQUAL_ARRAY(_result, _correctResult);

["Terminating testing of PCE Functions."] call Phobos_fnc_logMessage;
