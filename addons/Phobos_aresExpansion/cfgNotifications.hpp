
/*
//For reference, not used.
class Default
{
	title = ""; // Title displayed as text on black background. Filled by arguments.
	iconPicture = ""; // Small icon displayed in left part. Colored by "color", filled by arguments.
	iconText = ""; // Short text displayed over the icon. Colored by "color", filled by arguments.
	description = ""; // Brief description displayed as structured text. Colored by "color", filled by arguments.
	color[] = { 1,1,1,1 }; // Icon and text color
	colorIconPicture[] = {1,1,1,1}; // Icon color only
	duration = 5; // How many seconds will the notification be displayed
	priority = 0; // Priority; higher number = more important; tasks in queue are selected by priority
	difficulty[] = {}; // Required difficulty settings. All listed difficulties has to be enabled
};
*/
class CamCreationSucceeded
{
	title = "CAMERA CREATED";
	iconPicture = "\A3\ui_f\data\gui\rsc\rscdisplayegspectator\cameratexture_ca.paa";
	description = "Camera: %1, has been created.";
	color[] = { 0.7,1,0.3,1 };
	duration = 5;
	priority = 3;
};

class CamCreationFailed: CamCreationSucceeded
{
	title = "CAMERA CREATION FAILED";
	description = "Camera: %1, could not be created. %2";
	color[] = { 1,0.3,0.2,1 };
};

class CamModificationSucceeded: CamCreationSucceeded
{
	title = "CAMERA MODIFIED: %1";
	description = "Camera: %1 has been modified.";
	color[] = { 0.5,1,1,1 };
};
//Unused, cant fit any data inside this.
class CamModificationSuccessWarning : CamCreationSucceeded
{
	title = "CAMERA MODIFIED (WARNING)";
	description = "Camera: %1, has been modified. %2";
	color[] = {};
	priority = 4;
};

//Unused.
class CamModificationFailed:  CamCreationSucceeded
{
	title = "CAMERA MODIFICATION FAILED";
	description = "Camera: %1, could not be modified. %2";
	color[] = { 0.8, 0.5, 0, 0.8 };
};

class CamDestroyed: CamCreationSucceeded
{
	title = "CAMERA DESTROYED";
	description = "Camera: %1, has been destroyed. %2";
	color[] = { 0.66, 0, 0, 1 };
	priority = 5;
};

class CamDeleted: CamDestroyed 
{
	title = "CAMERA DELETED";
	description = "Camera: %1, has been deleted by user request.";
};

class CutsceneCreationSucceeded : CamCreationSucceeded {
	title = "CUTSCENE CREATED";
	description = "Cutscene: %1, has been created.";
};

class CutsceneCreationFailed : CamCreationFailed {
	title = "CUTSCENE CREATION FAILED";
	description = "Cutscene: %1, could not be created. %2";
};

