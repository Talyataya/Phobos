//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Checks if cam exists.(Includes cameras that are created and not broken.)
// Changelog: None.
// Notes: 
//
//////////////////////////////////////////////////////////////

private _cutsceneName = _this select 0;
private _camID = _this select 1;
private _camFullName = format ["%1_%2", _cutsceneName, _camID]; 

private _camExists = missionNamespace getVariable [_camFullName, false];
_camExists;