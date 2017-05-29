//////////////////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Function for debug purposes.
// Changelog: None. 
//
//////////////////////////////////////////////////////////////////////////

private["_message", "_condition", "_overrideRptOutput", "_overrideIngameOutput"];
_message = _this select 0;
_condition = param [1,true,[],[]]; //For config file. To suspend all debug stuff...
_overrideRptOutput = param [2,true,[],[]];
_overrideIngameOutput = param [3,true,[],[]]; //Long debug outputs in game would not be helpful... false to forcefully disable.

if(_condition) then {
	//for rpt file. Default: true
	if (Phobos_enableRptOutput && _overrideRptOutput) then //TODO: Will be connected to config file.
	{
		diag_log format["Phobos: %1", _message];
	};

	//for ingame chat. Default: false
	if (Phobos_enableIngameOutput && _overrideIngameOutput) then //TODO: Will be connected to config file.
	{
		systemChat format["Phobos: %1", _message];
	};
};
