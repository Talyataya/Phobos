//Camera Count Limitations
#define MIN_CAMERA_WAYPOINT 1 //What do you mean arrays start from 0?!(Starts from 1 to correspond camera(Fn) buttons)
#define MAX_CAMERA_WAYPOINT 200

//Camera Default Properties
#define PROPERTIES_DEFAULT_IS_ATTACHED			false
#define PROPERTIES_DEFAULT_COMMIT_TIME			5 //TEMPORARY, TODO: change adaptive to position change.... Maybe one day..
#define PROPERTIES_DEFAULT_WAIT_BEFORE_COMMIT 	0
#define PROPERTIES_DEFAULT_FOV 					0.7
#define PROPERTIES_DEFAULT_FOCUS				0 //AUTO (Actual auto is -1)
#define PROPERTIES_DEFAULT_APERTURE				0 //AUTO (Actual auto is -1, although 0 has the same effect?)
#define PROPERTIES_DEFAULT_BRIGHTNESS			1
#define PROPERTIES_DEFAULT_CONTRAST 			0
#define PROPERTIES_DEFAULT_SATURATION 			1
#define PROPERTIES_DEFAULT_DAYTIME 				0 //0 for no change, 1440 for 00.00
#define PROPERTIES_DEFAULT_OVERCAST				(-0.01)
#define PROPERTIES_DEFAULT_RAIN					(-0.01)
#define PROPERTIES_DEFAULT_FOG					(-0.01)
#define PROPERTIES_DEFAULT_VISION_MODE			0
#define PROPERTIES_DEFAULT_CODE					""

//Camera Properties Index (DO NOT USE FOR RETRIEVING FROM fn_showChooseDialog, as some of them are not being used.)
#define ID_PROPERTIES_POSITION 0
#define ID_PROPERTIES_TARGET 1
#define ID_PROPERTIES_IS_ATTACHED 2
#define ID_PROPERTIES_COMMIT_TIME 3
#define ID_PROPERTIES_WAIT_BEFORE_COMMIT 4
#define ID_PROPERTIES_FOV 5
#define ID_PROPERTIES_FOCUS 6
#define ID_PROPERTIES_APERTURE 7
#define ID_PROPERTIES_BRIGHTNESS 8
#define ID_PROPERTIES_CONTRAST 9
#define ID_PROPERTIES_SATURATION 10
#define ID_PROPERTIES_DAYTIME 11
#define ID_PROPERTIES_OVERCAST 12
#define ID_PROPERTIES_RAIN 13
#define ID_PROPERTIES_FOG 14
#define ID_PROPERTIES_VISION_MODE 15
#define ID_PROPERTIES_CODE 16

//Cutscene Creation Error Codes
#define ID_CREATION_SUCCESFUL 0
#define ID_CREATION_FAILED_ALREADY_EXISTS 1
#define ID_CREATION_FAILED_INAPPROPRIATE_NAME 2

//Cutscene Fixed Properties
#define INT_CAMERA_INTRO_LENGTH 2 //Length of BlackIn(Length during cutscene)
#define INT_CAMERA_OUTRO_LENGTH 2 //Length of BlackOut(Length during cutscene)