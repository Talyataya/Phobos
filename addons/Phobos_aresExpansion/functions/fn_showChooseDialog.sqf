//////////////////////////////////////////////////////////////////////////
//
// Author: Anton Struyk
// Modified by: Talya
// Taken from: Ares Mod(v1.8.1) - fn_showChooseDialog.sqf
// 
// Version: 1.1
// Description: Written below.
// Changelog: 
// v1.1: 
// * Added: Support for infinite amount of options. (Scroll Bar Added) 
// * Changed: Options with textboxes now come with string input instead of empty string.
//
//////////////////////////////////////////////////////////////////////////


/*
	Displays a dialog that prompts the user to choose an option from a set of combo boxes. 
	If the dialog has a title then the default values provided will be used the FIRST time a dialog is displayed, and the selected values remembered for the next time it is displayed.
	
	Params:
		0 - String - The title to display for the combo box. Do not use non-standard characters (e.g. %&$*()!@#*%^&) that cannot appear in variable names
		1 - Array of Arrays - The set of choices to display to the user. Each element in the array should be an array in the following format: ["Choice Description", ["Choice1", "Choice2", etc...]] optionally the last element can be a number that indicates which element to select. For example: ["Choose A Pie", ["Apple", "Pumpkin"], 1] will have "Pumpkin" selected by default. If you replace the choices with a string then a textbox (with the provided entry as default) will be displayed instead.

	Alternate Params:
		0 - String - The title to display for the combo box.
		1 - Array of Arrays - A single entry in the format of the first version of the function. That is: ["Choice Description", ["Choice1", "Choice2", etc...]]. If you replace the choices with a string then a textbox (with the provided entry as default) will be displayed instead.
	Returns:
		An array containing the indices of each of the values chosen, or a null object if nothing was selected.
*/
#define IDD_DYNAMIC_DIALOG 340200 
#define TITLE_COUNT_WITHOUT_VSCROLL_MAX 9

disableSerialization;

_titleText = [_this, 0] call BIS_fnc_param;
_choicesArray = _this select 1; 
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
#define EDIT_BOX_EDGE_DIFFERENCE	(0.025 * GUI_GRID_H) //Not used for now.
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
#define CONTROLSGROUP_IDC			(8999)
#define BASE_IDC					(9000)

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
_controlsGroupHeight = 0;
if (count _choicesArray > TITLE_COUNT_WITHOUT_VSCROLL_MAX) then {
	_controlsGroupHeight = CONTROLSGROUP_HEIGHT_MAX;
} else {
	_controlsGroupHeight = TOTAL_ROW_HEIGHT * (count _choicesArray);
};
_controlsGroup ctrlSetPosition [CONTROLSGROUP_X, CONTROLSGROUP_Y, CONTROLSGROUP_WIDTH, _controlsGroupHeight];
_controlsGroup ctrlCommit 0;

// TODO move these to seperate functions...
KRON_StrToArray = {
	private["_in","_i","_arr","_out"];
	_in=_this select 0;
	_arr = toArray(_in);
	_out=[];
	for "_i" from 0 to (count _arr)-1 do {
		_out set [count _out, toString([_arr select _i])];
	};
	_out
};

KRON_StrLen = {
	private["_in","_arr","_len"];
	_in=_this select 0;
	_arr=[_in] call KRON_StrToArray;
	_len=count (_arr);
	_len
};

KRON_Replace = {
	private["_str","_old","_new","_out","_tmp","_jm","_la","_lo","_ln","_i"];
	_str=_this select 0;
	_arr=toArray(_str);
	_la=count _arr;
	_old=_this select 1;
	_new=_this select 2;
	_na=[_new] call KRON_StrToArray;
	_lo=[_old] call KRON_StrLen;
	_ln=[_new] call KRON_StrLen;
	_out="";
	for "_i" from 0 to (count _arr)-1 do {
		_tmp="";
		if (_i <= _la-_lo) then {
			for "_j" from _i to (_i+_lo-1) do {
				_tmp=_tmp + toString([_arr select _j]);
			};
		};
		if (_tmp==_old) then {
			_out=_out+_new;
			_i=_i+_lo-1;
		} else {
			_out=_out+toString([_arr select _i]);
		};
	};
	_out
};

// Get the ID for use when looking up previously selected values.
_titleVariableIdentifier = format ["Phobos_ChooseDialog_DefaultValues_%1", [_titleText, " ", "_"] call KRON_Replace];
{
	_choiceName = _x select 0;
	_choices = _x select 1;
	_choicesArrayIndex = _forEachIndex;
	_defaultChoice = 0;
	if (count _x > 2) then
	{
		_defaultChoice = _x select 2;
	};
	
	// If this dialog is named, attmept to get the default value from a previously displayed version
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
			}
		};
		if (_isText) then {
			if (_tempDefault != "") then {
				_defaultChoice = _tempDefault;
			};
		};
	};

	// Create the label for this entry
	_choiceLabel = _dialog ctrlCreate ["RscText", BASE_IDC + _controlCount, _controlsGroup];
	_choiceLabel ctrlSetPosition [LABEL_COLUMN_X, TOTAL_ROW_HEIGHT * _choicesArrayIndex , LABEL_WIDTH, LABEL_HEIGHT];
	_choiceLabel ctrlSetText _choiceName;
	_choiceLabel ctrlCommit 0;
	_controlCount = _controlCount + 1;
	
	_comboBoxIdc = BASE_IDC + _controlCount;
	
	if (typeName _choices == "STRING") then 
	{
		//String Detected.
		if(count _choices == 0) then {
			_defaultChoice = -1;
		} else {
			_defaultChoice = _choices;
		};
		
		_choiceEdit = _dialog ctrlCreate ["RscEdit", _comboBoxIdc, _controlsGroup];
		_choiceEdit ctrlSetPosition [COMBO_COLUMN_X, (TOTAL_ROW_HEIGHT * _choicesArrayIndex), COMBO_WIDTH, COMBO_HEIGHT];
		_choiceEdit ctrlSetBackgroundColor [0, 0, 0, 1];
		_choiceEdit ctrlSetText _choices;
		_choiceEdit ctrlCommit 0;
		_choiceEdit ctrlSetEventHandler ["KeyUp", "missionNamespace setVariable [format['Phobos_ChooseDialog_ReturnValue_%1'," + str (_choicesArrayIndex) + "], ctrlText (_this select 0)];"];
		_choiceEdit ctrlCommit 0;
	} else {
	/*
		//Array Detected. 
		if(count _choices == 3 && _choices isEqualTypeArray [0,0,0]) then {
		// Vertical Bar requested. 
		// Slider params: [min,default,max].
		_slider = _dialog ctrlCreate ["RscDynamicDialogSlider", -1, _controlsGroup];
		_slider ctrlSetPosition [COMBO_COLUMN_X, TOTAL_ROW_HEIGHT * _choicesArrayIndex, COMBO_WIDTH, COMBO_HEIGHT];
		_slider sliderSetPosition (_choices select 1);
		_slider sliderSetRange [_choices select 0, _choices select 2];
		_slider ctrlCommit 0;
		/* 
		_sliderEdit = _dialog ctrlCreate ["RscEdit", -1, _controlsGroup];
		_sliderEdit ctrlSetText (str (_choices select 1));
		_sliderEdit ctrlSetPosition [COMBO_COLUMN_X-0.1, TOTAL_ROW_HEIGHT * _choicesArrayIndex, COMBO_WIDTH/6, COMBO_HEIGHT];
		_sliderEdit ctrlSetBackgroundColor [0,0,0,1];
		_sliderEdit ctrlCommit 0;
		
		_slider ctrlAddEventHandler ["SliderPosChanged", {
			//_sliderEdit ctrlSetText (str (_this select 1));
			//_sliderEdit ctrlCommit 0;
			hint str (_this select 1);
		}];
		
		_sliderEdit ctrlAddEventHandler ["KeyUp", {
			_slider sliderSetPosition (parseNumber (ctrlText _sliderEdit));
			_slider ctrlCommit 0;
			hint (ctrlText _sliderEdit);
		}];
		
		} else {*/
		// Create the combo box for this entry and populate it.		
		_choiceCombo = _dialog ctrlCreate ["RscCombo", _comboBoxIdc, _controlsGroup];
		_choiceCombo ctrlSetPosition [COMBO_COLUMN_X, TOTAL_ROW_HEIGHT * _choicesArrayIndex, COMBO_WIDTH, COMBO_HEIGHT];
		_choiceCombo ctrlCommit 0;
		{
			_choiceCombo lbAdd _x;
		} forEach _choices;
		
		// Set the current choice, record it in the global variable, and setup the event handler to update it.
		_choiceCombo lbSetCurSel _defaultChoice;
		_choiceCombo ctrlSetEventHandler ["LBSelChanged", "missionNamespace setVariable [format['Phobos_ChooseDialog_ReturnValue_%1'," + str (_choicesArrayIndex) + "], _this select 1];"];
		//};
	};
	missionNamespace setVariable [format["Phobos_ChooseDialog_ReturnValue_%1",_choicesArrayIndex], _defaultChoice];
	
	_controlCount = _controlCount + 1;

	// Move onto the next row
} forEach _choicesArray;

missionNamespace setVariable ["Phobos_ChooseDialog_Result", -1];

// Create the Ok and Cancel buttons
_okButton = _dialog ctrlCreate ["RscButtonMenuOK", BASE_IDC + _controlCount];
_okButton ctrlSetPosition [OK_BUTTON_X, _controlsGroupHeight + TOTAL_ROW_HEIGHT + TITLE_HEIGHT, OK_BUTTON_WIDTH, OK_BUTTON_HEIGHT];
_okButton ctrlCommit 0;
_okButton ctrlSetEventHandler ["ButtonClick", "missionNamespace setVariable ['Phobos_ChooseDialog_Result', 1]; closeDialog 1;"];
_controlCount = _controlCount + 1;

_cancelButton = _dialog ctrlCreate ["RscButtonMenuCancel", BASE_IDC + _controlCount];
_cancelButton ctrlSetPosition [CANCEL_BUTTON_X, _controlsGroupHeight + TOTAL_ROW_HEIGHT + TITLE_HEIGHT, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT];
_cancelButton ctrlSetEventHandler ["ButtonClick", "missionNamespace setVariable ['Phobos_ChooseDialog_Result', -1]; closeDialog 2;"];
_cancelButton ctrlCommit 0;
_controlCount = _controlCount + 1;

// Resize the background to fit all the controls we've created.
// controlsGroup, and 2 for the OK/Cancel buttons. +2 for padding on top and bottom.
_backgroundHeight = _controlsGroupHeight
					+ _titleRowHeight
					+ OK_BUTTON_HEIGHT
					+ (1.5 * GUI_GRID_H); // We want some padding on the top and bottom
_background ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, _backgroundHeight];
_background ctrlCommit 0;

waitUntil { !dialog };

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