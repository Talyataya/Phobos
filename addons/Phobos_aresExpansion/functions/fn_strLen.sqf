//////////////////////////////////////////////////////////////////////////
//
// Author: Kronzky
// Modified by: Talya (Function names are modified)
// Taken from: http://kronzky.info/snippets/strings/index.htm
// 
// Version: 1.0
// Description: Returns string length.
//
//////////////////////////////////////////////////////////////////////////

private["_in","_arr","_len"];
_in=_this select 0;
_arr=[_in] call Phobos_fnc_strToArray;
_len=count (_arr);
_len