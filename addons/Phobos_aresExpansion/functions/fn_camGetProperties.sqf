//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Gets camera properties of chosen camera.
// Changelog: None.
// Notes: 
//
//////////////////////////////////////////////////////////////


private _cutsceneName = _this select 0;
private _camID = _this select 1;

private _camFullName = format ["%1_%2", _cutsceneName, _camID];

private _properties = missionNamespace getVariable [format ["%1_properties", _camFullName], []];
_properties;