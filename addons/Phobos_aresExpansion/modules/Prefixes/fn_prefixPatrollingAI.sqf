//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Changes units' behavior and movement speed to fitting for a patrolling AI type. (Affects units placed after activated unless retoggled.)
// Changelog: None.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_zeusLogic = getAssignedCuratorLogic player;

if (isNil "Phobos_isPrefixActivated") then {
Phobos_isPrefixActivated=true;
};

if (Phobos_isPrefixActivated) then {
	Phobos_patrolAIGroupEHIndex = _zeusLogic addEventHandler ["CuratorGroupPlaced",{
		_targetGroup=(_this select 1);
		_targetGroup setBehaviour "SAFE";
		_targetGroup setSpeedMode "LIMITED";
		}];
	Phobos_patrolAIObjectEHIndex = _zeusLogic addEventHandler ["CuratorObjectPlaced",{
		_targetUnit=(_this select 1);
		_targetUnit setBehaviour "SAFE";
		_targetUnit setSpeedMode "LIMITED";
		}];
	Phobos_isPrefixActivated=false;
["AI Patrol Prefix has been activated."] call Ares_fnc_ShowZeusMessage;
} else {
	_zeusLogic removeEventHandler ["CuratorGroupPlaced",Phobos_patrolAIGroupEHIndex];
			_zeusLogic removeEventHandler ["CuratorObjectPlaced",Phobos_patrolAIObjectEHIndex];
	Phobos_isPrefixActivated=true;
	["AI Patrol Prefix has been deactivated."] call Ares_fnc_ShowZeusMessage;
}

#include "\Phobos_aresExpansion\module_footer.hpp"
