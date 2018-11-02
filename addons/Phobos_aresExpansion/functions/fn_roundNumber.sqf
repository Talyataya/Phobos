//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Function to round up an integer with requested decimal count.
// Changelog: None.
//
//////////////////////////////////////////////////////////////

private ["_number","_decimalCount", "_roundedNumber"];
_number = _this select 0;
_decimalCount = param [1, 0, [0]];

if (_decimalCount >= 0) then {
	_roundedNumber = round ((10 ^ _decimalCount) * _number) / (10 ^ _decimalCount);
} else {
	_roundedNumber = _number;
};
_roundedNumber;