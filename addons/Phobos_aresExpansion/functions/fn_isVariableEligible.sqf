//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Checks if identifier is eligible to become a variable name.
// Changelog: None.
// Notes: 
//
//////////////////////////////////////////////////////////////

private _identifier = _this select 0;

private _strArray = toArray _identifier;
private _result = true;
//Check first character is a number?
if (((_strArray select 0) >= 48) && (_strArray select 0) <= 57) exitWith {false;};

//Check if each value is a number, uppercase or lowercase letter or underscore.
{
	if ((_x < 48 || _x > 57) && (_x < 65 || _x > 90) && (_x < 97 || _x > 122) && (_x != 95)) exitWith {_result = false;};
} forEach _strArray;

_result;


