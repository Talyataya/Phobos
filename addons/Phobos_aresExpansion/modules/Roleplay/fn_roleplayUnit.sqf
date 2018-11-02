//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.1
// Description: Allows zeus to chat in the name of the selected unit in chosen channel.
// Changelog: 
//	v1.1
//	* Changed: When placed on player, is not displaying their name anymore.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_unitUnderCursor = [_logic,false] call Ares_fnc_GetUnitUnderCursor;

if (not (isNull _unitUnderCursor)) then
	{
		_nameOfSelectedUnit = name _unitUnderCursor;
		_chatResult =
			["Chat",
				[
					[_nameOfSelectedUnit + " says:" , ""],
					["Chat Type:", ["Global Chat", "Side Chat", "Command Chat", "Group Chat", "Vehicle Chat", "System Chat"]]
				]
			] call Phobos_fnc_showChooseDialog;
			
		if (count _chatResult > 0) then {
			_saidContent= _chatResult select 0; 
			_chatType= _chatResult select 1;
			if (isPlayer _unitUnderCursor) then {
				switch (_chatType) do {
				case 0: {[_unitUnderCursor, format ["%1",_saidContent]] remoteExec ["globalChat"]};
				case 1: {[_unitUnderCursor, format ["%1",_saidContent]] remoteExec ["sideChat"]};
				case 2: {[_unitUnderCursor, format ["%1",_saidContent]] remoteExec ["commandChat"]};
				case 3: {[_unitUnderCursor, format ["%1",_saidContent]] remoteExec ["groupChat"]};
				case 4: {[_unitUnderCursor, format ["%1",_saidContent]] remoteExec ["vehicleChat"]};
				case 5: {[format ["%1",_saidContent]] remoteExec ["systemChat"]};
				}
		} else {
			switch (_chatType) do {
			case 0: {[_unitUnderCursor, format ["%2: %1",_saidContent, _nameOfSelectedUnit]] remoteExec ["globalChat"]};
			case 1: {[_unitUnderCursor, format ["%2: %1",_saidContent, _nameOfSelectedUnit]] remoteExec ["sideChat"]};
			case 2: {[_unitUnderCursor, format ["%2: %1",_saidContent, _nameOfSelectedUnit]] remoteExec ["commandChat"]};
			case 3: {[_unitUnderCursor, format ["%2: %1",_saidContent, _nameOfSelectedUnit]] remoteExec ["groupChat"]};
			case 4: {[_unitUnderCursor, format ["%2: %1",_saidContent, _nameOfSelectedUnit]] remoteExec ["vehicleChat"]};
			case 5: {[format ["%2: %1",_saidContent, _nameOfSelectedUnit]] remoteExec ["systemChat"]};
			};
		}
	}
}
else
{
	["Module needs to be dropped on an object."] call Ares_fnc_ShowZeusMessage;
};

#include "\Phobos_aresExpansion\module_footer.hpp"