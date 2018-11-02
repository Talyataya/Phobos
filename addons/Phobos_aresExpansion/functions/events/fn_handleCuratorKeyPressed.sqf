//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Sets up events for 'onKeyDown' event handler. 
// Changelog: None.
// Notes:
//
//////////////////////////////////////////////////////////////

_key = _this select 1;
_isShiftPressed = _this select 2;
_isCtrlPressed = _this select 3;
//_isAltPressed = _this select 4;
_handled = false;

//Debug for keys clicked. Default: false.
[format ["Key pressed: %1",_key], Phobos_enableButtonOutput] call Phobos_fnc_logMessage;

switch (_key) do {
	//F1
	case 59 : 
	{
		if (_isCtrlPressed) then {
			["CTRL + F1 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",1] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F1 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",1] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F2
	case 60 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F2 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",2] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F2 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",2] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F3
	case 61 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F3 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",3] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F3 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",3] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F4
	case 62 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F4 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",4] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F4 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",4] spawn Phobos_fnc_camProperties;
			_handled = true;
		};	
	};
	//F5
	case 63 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F5 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",5] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F5 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",5] spawn Phobos_fnc_camProperties;
			_handled = true;
		};	
	};
	//F6
	case 64 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F6 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",6] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F6 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",6] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F7
	case 65 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F7 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",7] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F7 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",7] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F8
	case 66 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F8 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",8] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F8 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",8] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F9
	case 67 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F9 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",9] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F9 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",9] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F10
	case 68 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F10 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",10] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F10 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",10] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F11
	case 87 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F11 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",11] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F11 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",11] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
	//F12
	case 88 :
	{
		if (_isCtrlPressed) then {
			["CTRL + F12 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",12] spawn Phobos_fnc_camWaypoint;
		};
		
		if (_isShiftPressed) then {
			["SHIFT + F12 was pressed."] call Phobos_fnc_logMessage;
			["Phobos_Cutscene",12] spawn Phobos_fnc_camProperties;
			_handled = true;
		};
	};
};

_handled;


