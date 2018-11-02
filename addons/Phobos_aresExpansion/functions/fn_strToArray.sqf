//////////////////////////////////////////////////////////////////////////
//
// Author: Kronzky
// Taken from: http://kronzky.info/snippets/strings/index.htm
// 
// Version: 1.0
// Description: Converts string to array.
//
//////////////////////////////////////////////////////////////////////////

private["_in","_i","_arr","_out"];
_in=_this select 0;
_arr = toArray(_in);
_out=[];
for "_i" from 0 to (count _arr)-1 do {
	_out set [count _out, toString([_arr select _i])];
};
_out
