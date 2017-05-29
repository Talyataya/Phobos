private["_message"];
_message = _this select 0;
_condition = param [1,true,[],[]];

if(_condition) then {
	if (count _this > 1) then
	{
		_message = format _this;
	};

	//for rpt file. Default: true
	if (Phobos_enableRptOutput) then //TODO: Will be connected to config file.
	{
		diag_log format["Phobos: %1", _message];
	};

	//for ingame chat. Default: false
	if (Phobos_enableIngameOutput) then //TODO: Will be connected to config file.
	{
		systemChat format["Phobos: %1", _message];
	};
};
