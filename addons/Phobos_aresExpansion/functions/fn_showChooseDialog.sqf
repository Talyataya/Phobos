//////////////////////////////////////////////////////////////////////////
//
// Author: Anton Struyk
// Modified by: Talya
// Taken from: Ares Mod(v1.8.1) - fn_showChooseDialog.sqf
// 
// Version: 1.6
// Description: Written below. (Outdated, check notes for new syntax.)
// Changelog:
//
// v1.6: 
//		*Added: 2 new advanced controls that provides selection of faction/group/unit similar to BI controls: "RscPropertyOwners_Units" (all units listed), "RscPropertyOwners_Players" (players listed only)
//		*Enhanced: Slidebars were not supporting value gap that contained -1 due default value was equal to that and wouldn't be saved due that. Default value is now -1e39 which represents "-1.#INF", typeName == "NaN"
//		*Changed: ControlsGroup calculation changed, as ScriptBox and RscPropertyOwners are bigger than previous controls and required a new measurement type.
//		*Fixed: RscEdit(scriptless) wasn't registering saved value as player entry even though showed so.
//
// v1.5: 
//		*Added: An rscEdit with scripting preset(Autocompletion for scripting is supported).
//		*Added: An argument to save or not to save value for later uses.(ex: It is annoying to delete previous roleplay sentence each time it is used.)
//		*Enhanced: All new components now by default saves values for later use.
//		*Fixed: Previously saved inputs were not loading correctly.
//
// v1.4: 
//		*Added: A variable that returns true if dialog is in use. (Phobos_fnc_chooseDialog_isActive)
//		*Added: Script execution onLoad, dialog = _this select 0
//		*Added: Script execution onUnload, dialogResult(bool) = _this select 0 (if OK or Cancel was pressed)
//		*Added: Tooltip for both elements in a choice. (Choice Description and ANY type of Choice)
//		*Added: Every option now has their own script execution with id and controls of that line passing as arguments.
//		*Fixed: Non-modified choices were returning wrong values.
//		*Enhanced: Slider numeric value now can be rounded up with an additional parameter. Usage: Usage:[int min, int default, int max,(optional) int decimalCount]
//		*Changed: Kronzky's(KRON tagged) functions are carried into separate files.
//		*Changed: RscCombo default value declaration changed. Nothing has changed for comboboxes that has no default value declared.
//				 Ex: ["Choice Description", ["Choice1" , "Choice2"], 1] became ["Choice Description", [["Choice1" , "Choice2"], 1]].
//
// v1.3:
//		*Enhanced: Slider now shows the selected numeric value.
//
// v1.2: 
//		*Added: Support for slidebar for options with numeric values. Usage:[int min, int default, int max]. Returns int in string form.(Check v1.4 for full version)
//
// v1.1: 
// 		*Added: Support for infinite amount of options. (Scroll Bar Added) 
// 		*Changed: Options with textboxes now come with a default string input instead of empty string.
// 
// Notes:
//		*Default choice for rscCombo has changed. Options with default values declared must be surrounded by [] to work properly. See v1.4 Changelog for more details.
//		*Commands that take too long time to execute(ie. setDate) should be used in onLoad , instead of choice script. Failure to do so causes dialog to appear part by part, which is visually annoying.
//		*RscPropertyOwners ctrl do NOT support saving selection and more than 1 control(due using Global variables). 
//
//////////////////////////////////////////////////////////////////////////


/*
	Displays a dialog that prompts the user to choose an option from a set of combo boxes. 
	If the dialog has a title then the default values provided will be used the FIRST time a dialog is displayed, and the selected values remembered for the next time it is displayed.
	
	Params:
		0 - String - The title to display for the combo box. Do not use non-standard characters (e.g. %&$*()!@#*%^&) that cannot appear in variable names
		1 - Array of Arrays - The set of choices to display to the user. Each element in the array should be an array in the following format: ["Choice Description", ["Choice1", "Choice2", etc...]] optionally the last element can be a number that indicates which element to select. For example: ["Choose A Pie", [["Apple", "Pumpkin"], 1]] will have "Pumpkin" selected by default. If you replace the choices with a string then a textbox (with the provided entry as default) will be displayed instead.
		1 - Array of Arrays - A line of choice based on provided component*. 
			Usage: [str _title, Component* (see below), (Optional) [str _tooltipTitle, (Optional) str _tooltipComponent], (Optional) code/str _code, (Optional) bool _isSaved]
				_title: Title of Option.
				Component*: See Components*.
				_tooltipTitle: Tooltip to display when mouse is hovered over _title.
				_tooltipComponent: Tooltip to display when mouse is hovered over Component*.
				_code: Code that is executed right after Component is created. Params: [int _lineIndex, Control _titleCtrl, Control _componentCtrl, (Exclusive to slider, returns ctrlText that displays value on slider) Control _componentCtrl]
				(Warning: Time consuming _code cause UI to construct in a noticeable amount of time. Use OnLoad code if its the case.)
				_isSaved: Boolean to save value for next time same dialog is opened.
			Basic Example: ["Choose A Pie", [["Apple", "Pumpkin"], 1]] will provide a list of options with default selected as Pumpkin.
			More Basic Examples can be found in Modules folder. 
			Complex Examples can be found with most modules associated with Phobos_Cutscene_Editor.(Files named with fn_cam.. and fn_cutscene...) 
		2 - (Optional) Code OR String - OnLoad code that is executed after the dialog creation is completed. Passed parameters are: [Dialog]
		3 - (Optional) Code OR String - OnUnload code that is executed after the dialog is closed. Passed parametes are: [Bool - True if OK pressed/False otherwise]

	Alternate Params:
		0 - String - The title to display for the combo box.
		1 - Array of Arrays - A single entry in the format of the first version of the function. That is: ["Choice Description", ["Choice1", "Choice2", etc...]]. If you replace the choices with a string then a textbox (with the provided entry as default) will be displayed instead.
	
	Components*:
		This function currently features 6 types of component to retrieve data from user.
		1 - Text Box[Non-Code]
			Description: Creates a ctrlEdit which user can enter their string input.
			Usage: str _defaultValue
			Returns: (String) User's string entry.
			
		2 - Slider
			Description: Creates a slider which user can enter their numerical input.
			Usage: [int _minValue, int _defaultValue, int _maxValue, (Optional) int _decimalCount]
			Returns: (Integer) User's integer selection on slider.
			
		3 - Text Box[Code]
			Description: Creates a ctrlEdit with scripting auto-completion feature.
			Usage: ["ScriptBox", (Optional) str _defaultValue, (Optional) int _lineCount]
				"ScriptBox": Is hardcoded and separates component from other components.
				_lineCount: Expands the ctrlEdit vertically for user confidence.
			Returns: (String) User's string entry.
			
		4 - Choice List :
			Description: Creates a list of entries to choose from.
			Usage: [str _choice0, str _choice1, ..., str _choiceN-1] OR [[str _choice0, str _choice1, ..., str _choiceN-1], int _defaultIndex]
				Creates N-different options to choose from.
				_defaultIndex: Sets default choice to targeted index.
			Returns: (Integer) Chosen option's index.
			
			Note: [See Usage #2] Usage with default value declared requires component to be wrapped with another array.(Ares Backward-Compatibility is only broken in this case for the sake of additional parameters.)
			
		5 - Unit Selection : 
			Description: Creates a ctrl that either takes faction/group/unit as an input.
			Usage: ["RscPropertyOwners_Players"]			
				"RscPropertyOwners_Units": Is hardcoded and separates component from other components.
			Returns: (Array of Objects) Chosen units.
			
		6 - Player Selection : 
			Description: Same as Unit Selection but input only considers players.
			Usage: ["RscPropertyOwners_Players"]
				"RscPropertyOwners_Players": Is hardcoded and separates component from other components.
			Returns: (Array of Objects) Chosen players.
			
	Returns:
		An array containing the indices of each of the values chosen, or a null object if nothing was selected.
*/
#define IDD_DYNAMIC_DIALOG 340200 
#define INT_NEGATIVE_INFINITY -1e39
#define TITLE_COUNT_WITHOUT_VSCROLL_MAX 9 //TITLE_WIDTH is taken into base for height calculation. All components have multiples of TITLE_WIDTH. 

disableSerialization;

_titleText = [_this, 0] call BIS_fnc_param;
_choicesArray = _this select 1;
_onLoadScript = param [2, ""];
_onUnloadScript = param [3, ""];

if (missionNamespace getVariable ["Phobos_fnc_chooseDialog_isActive",false]) exitWith {
	["Unable to create dialog, another instance is already active."] call Ares_fnc_showZeusMessage;
	["fn_showChooseDialog: Player attempted to activate the already active dialog."] call Phobos_fnc_logMessage;
};

if ((count _this) == 2 && typeName (_choicesArray select 0) == typeName "") then
{
	// Person is using the 'short' alternate syntax. Automatically wrap in another array.
	_choicesArray = [_this select 1];
};

// Define some constants for us to use when laying things out.
#define GUI_GRID_X		(0)
#define GUI_GRID_Y		(0)
#define GUI_GRID_W		(0.025)
#define GUI_GRID_H		(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

#define BG_X						(1 * GUI_GRID_W + GUI_GRID_X)
#define BG_Y						(1 * GUI_GRID_H + GUI_GRID_Y)
#define BG_WIDTH					(39 * GUI_GRID_W)
#define CONTROLSGROUP_X				(1 * GUI_GRID_W + GUI_GRID_X)
#define CONTROLSGROUP_Y				(3 * GUI_GRID_H + GUI_GRID_Y)
#define CONTROLSGROUP_WIDTH			(39 * GUI_GRID_W)
#define CONTROLSGROUP_HEIGHT_MAX	(TITLE_COUNT_WITHOUT_VSCROLL_MAX * TOTAL_ROW_HEIGHT)
#define EDIT_BOX_EDGE_DIFFERENCE	(0.025 * GUI_GRID_H) //Used for fixing annoying visual of top edge of first element.
#define TITLE_X						(2 * GUI_GRID_W + GUI_GRID_X)
#define TITLE_Y						(BG_Y + (0.5 * GUI_GRID_H))
#define TITLE_WIDTH					(14 * GUI_GRID_W)
#define TITLE_HEIGHT				(1.5 * GUI_GRID_H)
#define LABEL_COLUMN_X				((2 * GUI_GRID_W + GUI_GRID_X) - CONTROLSGROUP_X)
#define LABEL_WIDTH					(14 * GUI_GRID_W)
#define LABEL_HEIGHT				(1.5 * GUI_GRID_H)
#define COMBO_COLUMN_X				((17.5 * GUI_GRID_W + GUI_GRID_X) - CONTROLSGROUP_X)
#define COMBO_WIDTH					(21 * GUI_GRID_W)
#define COMBO_HEIGHT				(1.5 * GUI_GRID_H)
#define OK_BUTTON_X					(29.5 * GUI_GRID_W + GUI_GRID_X)
#define OK_BUTTON_WIDTH				(4 * GUI_GRID_W)
#define OK_BUTTON_HEIGHT			(1.5 * GUI_GRID_H)
#define CANCEL_BUTTON_X				(34 * GUI_GRID_W + GUI_GRID_X)
#define CANCEL_BUTTON_WIDTH			(4.5 * GUI_GRID_W)
#define CANCEL_BUTTON_HEIGHT		(1.5 * GUI_GRID_H)
#define TOTAL_ROW_HEIGHT			(2 * GUI_GRID_H)
#define OK_BUTTON_IDC				(8997)
#define CANCEL_BUTTON_IDC			(8998)
#define CONTROLSGROUP_IDC			(8999)
#define BASE_IDC					(9000)

// Announce whole world that this dialog is activated. 
missionNamespace setVariable ["Phobos_fnc_chooseDialog_isActive",true];

// Bring up the dialog frame we are going to add things to.
_createdDialogOk = createDialog "Phobos_Dynamic_Dialog";
_dialog = findDisplay IDD_DYNAMIC_DIALOG;

// Create the BG and Frame
_background = _dialog ctrlCreate ["IGUIBack", BASE_IDC];
_background ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, 10 * GUI_GRID_H];
_background ctrlCommit 0;

// Start placing controls 1 units down in the window.
//_yCoord = BG_Y + (0.5 * GUI_GRID_H);
_controlCount = 2;

_titleRowHeight = 0;
if (_titleText != "") then
{
	// Create the label
	_labelControl = _dialog ctrlCreate ["RscText", BASE_IDC + _controlCount];
	_labelControl ctrlSetPosition [TITLE_X, TITLE_Y, TITLE_WIDTH, TITLE_HEIGHT];
	_labelControl ctrlCommit 0;
	_labelControl ctrlSetText _titleText;
	//_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
	_controlCount = _controlCount + 1;
	_titleRowHeight = TITLE_HEIGHT;
};

// Create ControlsGroup 
_controlsGroup = _dialog ctrlCreate ["RscControlsGroupNoHScrollbars", CONTROLSGROUP_IDC];
_controlsGroup ctrlSetPosition [CONTROLSGROUP_X, CONTROLSGROUP_Y, CONTROLSGROUP_WIDTH, CONTROLSGROUP_HEIGHT_MAX];
_controlsGroup ctrlCommit 0;

// Get the ID for use when looking up previously selected values.
_titleVariableIdentifier = format ["Phobos_ChooseDialog_DefaultValues_%1", [_titleText, " ", "_"] call Phobos_fnc_strReplace];

_yCoord = EDIT_BOX_EDGE_DIFFERENCE; 
{
	_choiceName = _x select 0; //Name of the row.
	_choices = _x select 1; //Data for choice component.
	_choicesTooltip = _x param [2, ["",""], [["",""]], [1,2]]; // Explanations or such when hovered on row components.
	_choicesScript = _x param [3, ""]; //Script to execute for that row.
	_choicesSaved = _x param [4, true]; //To save and use the same value next times. (True by default for backward compatibility (Ares))
	_choicesArrayIndex = _forEachIndex;
	_defaultValue = INT_NEGATIVE_INFINITY; //TODO: Make sure typeName == "NaN" and typeName != "SCALAR", wiki says its better to check with finite command but it doesnt look like its needed.
	
	//Get previously saved value if any.
	_defaultVariableId = format["%1_%2", _titleVariableIdentifier, _choicesArrayIndex];
	_tempDefault = missionNamespace getVariable [_defaultVariableId, INT_NEGATIVE_INFINITY];

	/*
	if (count _x > 2) then
	{
		_defaultChoice = _x select 2;
	};
	
	// If this dialog is named, attempt to get the default value from a previously displayed version
	if (_titleText != "") then
	{
		_defaultVariableId = format["%1_%2", _titleVariableIdentifier, _choicesArrayIndex];
		_tempDefault = missionNamespace getVariable [_defaultVariableId, -1];
		_isSelect = typeName _tempDefault == typeName 0;
		_isText = typeName _tempDefault == typeName "";
		
		// This really sucks but SQF does not seem to like complex ifs...
		if (_isSelect) then
		{
			if (_tempDefault != -1) then {
			_defaultChoice = _tempDefault;
			};
		};
		if (_isText) then {
			if (_tempDefault != "") then {
				_defaultChoice = _tempDefault;
			};
		};
	};
	*/
	// Create the label for this entry
	_choiceLabel = _dialog ctrlCreate ["RscText", BASE_IDC + _controlCount, _controlsGroup];
	_choiceLabel ctrlSetPosition [LABEL_COLUMN_X, _yCoord, LABEL_WIDTH, LABEL_HEIGHT];
	_choiceLabel ctrlSetText _choiceName;
	_choiceLabel ctrlSetTooltip (_choicesTooltip select 0);
	_choiceLabel ctrlCommit 0;
	_controlCount = _controlCount + 1;
	
	_comboBoxIdc = BASE_IDC + _controlCount;
	
	if (typeName _choices == "STRING") then 
	{
		//String Detected.
		
		//Get previously saved value if any.
		if (_choicesSaved && _titleText != "" && typeName _tempDefault == "STRING") then {
			_defaultValue = _tempDefault;
		} else {
			_defaultValue = _choices;
		};
		
		_choiceEdit = _dialog ctrlCreate ["RscEdit", _comboBoxIdc, _controlsGroup];
		_choiceEdit ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
		_choiceEdit ctrlSetBackgroundColor [0, 0, 0, 1];
		_choiceEdit ctrlSetText _defaultValue;
		_choiceEdit ctrlSetTooltip (_choicesTooltip select 1);
		_choiceEdit ctrlSetEventHandler ["KeyUp", "missionNamespace setVariable [format['Phobos_ChooseDialog_ReturnValue_%1'," + str (_choicesArrayIndex) + "], ctrlText (_this select 0)];"];
		_choiceEdit ctrlCommit 0;
		
		missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choicesArrayIndex], _defaultValue];
		
		if ((typeName _choicesScript) isEqualTo "CODE") then {
			[_choicesArrayIndex, _choiceLabel, _choiceEdit] call _choicesScript;
		} else {
			[_choicesArrayIndex, _choiceLabel, _choiceEdit] call (compile _choicesScript);
		};
		
		_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
	} else {
		//Array Detected. 
		if (count _choices >= 3 && (_choices isEqualTypeArray [0,0,0] || _choices isEqualTypeArray [0,0,0,0])) then {
			// Vertical Bar requested. 
			// Slider params: [min,default,max,(optional) decimalCount].
			
			//Get previously saved value if any.
			if (_choicesSaved && _titleText != "" && typeName _tempDefault == "SCALAR") then {
				_defaultValue = _tempDefault;
			} else {
				_defaultValue = _choices select 1;
			};
			_minValue = _choices select 0;
			_maxValue = _choices select 2;
			_decimalCount = _choices param [3, -1 , [0]];
			_defaultRoundedValue = [_defaultValue, _decimalCount] call Phobos_fnc_roundNumber;
			
			_slider = _dialog ctrlCreate ["RscDynamicDialogSliderH", _comboBoxIdc, _controlsGroup];
			_slider ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
			_slider sliderSetRange [_minValue, _maxValue];
			_slider sliderSetPosition _defaultRoundedValue;
			//_slider ctrlSetBackgroundColor [0,0,0,1];
			_slider ctrlSetTooltip (_choicesTooltip select 1);
			_slider ctrlCommit 0;
			
			_controlCount = _controlCount + 1;
			_comboBoxIdc = BASE_IDC + _controlCount;
			
			_sliderText = _dialog ctrlCreate ["RscDynamicDialogSliderText", _comboBoxIdc, _controlsGroup];
			_sliderText ctrlSetText (str _defaultRoundedValue);
			_sliderText ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
			//_sliderText ctrlSetBackgroundColor [0,0,0,1];
			_sliderText ctrlSetTooltip (_choicesTooltip select 1); 
			_sliderText ctrlCommit 0;
			
			_slider ctrlAddEventHandler ["SliderPosChanged", format ["
				_slider = _this select 0;
				_sliderValue = _this select 1;
				_display = ctrlParent _slider;
				_sliderText = _display displayCtrl %1;
				_sliderRoundedValue = [_sliderValue,%2] call Phobos_fnc_roundNumber;
				_sliderText ctrlSetText (str _sliderRoundedValue);
				['Slider Value:' + (str _sliderRoundedValue), Phobos_enableUIAdvancedOutput] call Phobos_fnc_logMessage;
				missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%3', _sliderRoundedValue];", 
				_comboBoxIdc, _decimalCount, str _choicesArrayIndex]
			];
			
			missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choicesArrayIndex], _defaultRoundedValue];
			
			if ((typeName _choicesScript) isEqualTo "CODE") then {
				[_choicesArrayIndex, _choiceLabel, _slider, _sliderText] call _choicesScript;
			} else {
				[_choicesArrayIndex, _choiceLabel, _slider, _sliderText] call (compile _choicesScript);
			};
			
			_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
		} else {
			switch (_choices select 0) do {
				case "ScriptBox": {
					//TODO: Check if permission granted by server management, when admin-rights update is released.
					_ctrlText = _choices param [1, "", [""]];
					_ctrlHeight = _choices param [2, 1, [0]];
					
					//Get previously saved value if any.
					if (_choicesSaved && _titleText != "" &&  typeName _tempDefault == "STRING") then {
						_defaultValue = _tempDefault;
					} else {
						_defaultValue = _ctrlText;
					};
					
					_ctrlScriptEdit = _dialog ctrlCreate ["RscDynamicDialogScriptBox", _comboBoxIdc, _controlsGroup];
					_ctrlScriptEdit ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT * _ctrlHeight];
					_ctrlScriptEdit ctrlSetBackgroundColor [0, 0, 0, 1];
					_ctrlScriptEdit ctrlSetTooltip (_choicesTooltip select 1);
					_ctrlScriptEdit ctrlCommit 0;
					_ctrlScriptEdit ctrlSetText _defaultValue;
					
					_ctrlScriptEdit ctrlAddEventHandler ["KeyUp", format ["missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%1', ctrlText (_this select 0)];",str _choicesArrayIndex]];
					
					missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choicesArrayIndex], _defaultValue];
				
					if ((typeName _choicesScript) isEqualTo "CODE") then {
						[_choicesArrayIndex, _choiceLabel, _ctrlScriptEdit] call _choicesScript;
					} else {
						[_choicesArrayIndex, _choiceLabel, _ctrlScriptEdit] call (compile _choicesScript);
					};
					
					_yCoord = _yCoord + TOTAL_ROW_HEIGHT + ((_ctrlHeight - 1) * COMBO_HEIGHT);
				};
				case "RscPropertyOwners_Units": {
					//TODO: Implement a save/load system.	
					_ctrlOwners = _dialog ctrlCreate ["RscPropertyOwners_Units", _comboBoxIdc, _controlsGroup];
					_ctrlOwners ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, TOTAL_ROW_HEIGHT * 2];
					_ctrlOwners ctrlSetTooltip (_choicesTooltip select 1);
					_ctrlOwners ctrlCommit 0;
					
					
					//TODO: Possible to save with the existing system? Not in a way what player chose for guaranteed but there is... but is it worth it?
					
					//TODO: Change handler type, current one is used due pressing ENTER toggles faction button status.(As if not that issue pushed us to use this one among all...)
					_dialog displayAddEventHandler ["MouseMoving", format ["missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%1', ['onUpdate',findDisplay %2, false] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf']", str _choicesArrayIndex, IDD_DYNAMIC_DIALOG]];
					
					_yCoord = _yCoord + (TOTAL_ROW_HEIGHT * 2) + (TOTAL_ROW_HEIGHT - COMBO_HEIGHT);
				};
				
				case "RscPropertyOwners_Players": {
					//TODO: Implement a save/load system.	
					_ctrlOwners = _dialog ctrlCreate ["RscPropertyOwners_Players", _comboBoxIdc, _controlsGroup];
					_ctrlOwners ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, TOTAL_ROW_HEIGHT * 2];
					_ctrlOwners ctrlSetTooltip (_choicesTooltip select 1);
					_ctrlOwners ctrlCommit 0;
					
					
					//TODO: Possible to save with the existing system? Not in a way what player chose for guaranteed but there is... but is it worth it?
					
					//TODO: Change handler type, current one is used due pressing ENTER toggles faction button status.(As if not that issue pushed us to use this one among all...)
					_dialog displayAddEventHandler ["MouseMoving", format ["missionNamespace setVariable ['Phobos_ChooseDialog_ReturnValue_%1', ['onUpdate',findDisplay %2, true] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf']", str _choicesArrayIndex, IDD_DYNAMIC_DIALOG]];
					
					_yCoord = _yCoord + (TOTAL_ROW_HEIGHT * 2) + (TOTAL_ROW_HEIGHT - COMBO_HEIGHT);
				};
				
				default {
					// Create the combo box for this entry and populate it.
					_choiceCombo = _dialog ctrlCreate ["RscCombo", _comboBoxIdc, _controlsGroup];
					_choiceCombo ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
					_choiceCombo ctrlSetTooltip (_choicesTooltip select 1);
					_choiceCombo ctrlCommit 0;
					
					private ["_options","_defaultOption"];
					if (_choices isEqualTypeArray [[], 0] || _choices isEqualTypeArray [[]]) then {
						_options = _choices select 0;
						_defaultValue = _choices param [1, 0, [0]];
					} else {
						//_choices isEqualTypeArray [] --> Old style without default value.
						_options = _choices;
						_defaultValue = 0;
					};
					
					//Get previously saved value and overwrite if any.
					if (_choicesSaved && _titleText != "" && typeName _tempDefault == "SCALAR") then {
						_defaultValue = _tempDefault;
					};
					
					//Add all options to combobox.
					{
						_choiceCombo lbAdd _x;
					} forEach _options;
					missionNamespace setVariable [format ['Phobos_ChooseDialog_ReturnValue_%1', _choicesArrayIndex], _defaultValue];
						
					// Set the current choice, record it in the global variable, and setup the event handler to update it.
					_choiceCombo lbSetCurSel _defaultValue;
					_choiceCombo ctrlSetEventHandler ["LBSelChanged", "missionNamespace setVariable [format['Phobos_ChooseDialog_ReturnValue_%1'," + str (_choicesArrayIndex) + "], _this select 1];"];
					
					
					
					if ((typeName _choicesScript) isEqualTo "CODE") then {
						[_choicesArrayIndex, _choiceLabel, _choiceCombo] call _choicesScript;
					} else {
						[_choicesArrayIndex, _choiceLabel, _choiceCombo] call (compile _choicesScript);
					};
					
					_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
				};
			};
		};
	};
	
	_controlCount = _controlCount + 1;

	// Move onto the next row
} forEach _choicesArray;

missionNamespace setVariable ["Phobos_ChooseDialog_Result", -1];

//Resize the controlsGroup based on size of _yCoord.
_controlsGroupHeight = 0;
if (_yCoord > TITLE_COUNT_WITHOUT_VSCROLL_MAX * TOTAL_ROW_HEIGHT) then {
	_controlsGroupHeight = CONTROLSGROUP_HEIGHT_MAX;
} else {
	_controlsGroupHeight = _yCoord;
};
_controlsGroup ctrlSetPosition [CONTROLSGROUP_X, CONTROLSGROUP_Y, CONTROLSGROUP_WIDTH, _controlsGroupHeight];
_controlsGroup ctrlCommit 0;

// Create the Ok and Cancel buttons
_okButton = _dialog ctrlCreate ["RscButtonMenuOK", OK_BUTTON_IDC];
_okButton ctrlSetPosition [OK_BUTTON_X, _controlsGroupHeight + TOTAL_ROW_HEIGHT + TITLE_HEIGHT, OK_BUTTON_WIDTH, OK_BUTTON_HEIGHT];
_okButton ctrlCommit 0;
_okButton ctrlSetEventHandler ["ButtonClick", "missionNamespace setVariable ['Phobos_ChooseDialog_Result', 1]; closeDialog 1;"];

_cancelButton = _dialog ctrlCreate ["RscButtonMenuCancel", CANCEL_BUTTON_IDC];
_cancelButton ctrlSetPosition [CANCEL_BUTTON_X, _controlsGroupHeight + TOTAL_ROW_HEIGHT + TITLE_HEIGHT, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT];
_cancelButton ctrlSetEventHandler ["ButtonClick", "missionNamespace setVariable ['Phobos_ChooseDialog_Result', -1]; closeDialog 2;"];
_cancelButton ctrlCommit 0;


// Resize the background to fit all the controls we've created.
// controlsGroup, and 2 for the OK/Cancel buttons. +2 for padding on top and bottom.
_backgroundHeight = _controlsGroupHeight
					+ _titleRowHeight
					+ OK_BUTTON_HEIGHT
					+ (1.5 * GUI_GRID_H); // We want some padding on the top and bottom
_background ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, _backgroundHeight];
_background ctrlCommit 0;


if ((typeName _onLoadScript) isEqualTo "CODE") then {[_dialog] call _onLoadScript} else {[_dialog] call (compile _onLoadScript)};

waitUntil { !dialog };

// Announce whole world that this dialog is no more existing.
missionNamespace setVariable ["Phobos_fnc_chooseDialog_isActive", false];

private "_dialogResult";
if (missionNamespace getVariable "Phobos_ChooseDialog_Result" == 1) then {_dialogResult = true} else {_dialogResult = false};
if ((typeName _onUnloadScript) isEqualTo "CODE") then {[_dialogResult] call _onUnloadScript} else {[_dialogResult] call (compile _onUnloadScript)};


// Check whether the user confirmed the selection or not, and return the appropriate values.
if (missionNamespace getVariable "Phobos_ChooseDialog_Result" == 1) then
{
	_returnValue = [];
	{
		_returnValue set [_forEachIndex, missionNamespace getVariable (format["Phobos_ChooseDialog_ReturnValue_%1",_forEachIndex])];
	}forEach _choicesArray;
	
	// Save the selections as defaults for next time
	if (_titleText != "") then
	{
		{
			_defaultVariableId = format["%1_%2", _titleVariableIdentifier, _forEachIndex];
			missionNamespace setVariable [_defaultVariableId, _x];
		} forEach _returnValue;
	};
	
	_returnValue;
}
else
{
	[];
};