//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Copies and creates units, based on; their side, class(ie medic,engineer) and loadouts.
// Changelog: None.
//
//////////////////////////////////////////////////////////////

#include "\Phobos_aresExpansion\module_header.hpp"

_position = position _logic;
{
	_curators = objectCurators _x;
	_characterClass = typeOf _x;
	_side = side _x;

	_primaryWeapon= primaryWeapon _x;
	_secondaryWeapon= secondaryWeapon _x;
	_handgunWeapon = handgunWeapon _x;
	_primaryWeaponMagazine = primaryWeaponMagazine _x;
	_secondaryWeaponMagazine = secondaryWeaponMagazine _x;
	_handgunMagazine = handgunMagazine _x;
	_primaryWeaponItems = primaryWeaponItems _x;
	_secondaryWeaponItems = secondaryWeaponItems _x;
	_handgunItems = handgunItems _x;
	_assignedItems = assignedItems _x;
	_uniform = uniform _x;
	_vest = vest _x;
	_backpack = backpack _x;
	_headgear = headgear _x;
	_goggles = goggles _x;
	_uniformItems = uniformItems _x;
	_vestItems = vestItems _x;
	_backpackItems = backpackItems _x;
	_face = face _x;
	_speaker = speaker _x;
			
	_newGroup = createGroup _side;
	_newUnit =_newGroup createUnit [_characterClass, _position , [],3, "CAN_COLLIDE"];
			
	removeAllWeapons _newUnit;
	removeAllItems _newUnit;
	removeAllAssignedItems _newUnit;
	removeUniform _newUnit;
	removeVest _newUnit;
	removeBackpack _newUnit;
	removeHeadgear _newUnit;
	removeGoggles _newUnit;
			
	_newUnit addWeapon _primaryWeapon;
	{_newUnit addPrimaryWeaponItem _x;} forEach (_primaryWeaponItems+_primaryWeaponMagazine);
	_newUnit addWeapon _secondaryWeapon;
	{_newUnit addSecondaryWeaponItem _x;} forEach (_secondaryWeaponItems+_secondaryWeaponMagazine);
	_newUnit addWeapon _handgunWeapon;
	{_newUnit addHandgunItem _x;} forEach (_handgunItems+_handgunMagazine);
	_newUnit forceAddUniform _uniform;
	{_newUnit addItemToUniform _x;} forEach _uniformItems;
	_newUnit addVest _vest;
	{_newUnit addItemToVest _x;} forEach _vestItems;
	_newUnit addBackpack _backpack;
	{_newUnit addItemToBackpack _x;} forEach _backpackItems;
	_newUnit addHeadgear _headgear;
	_newUnit addGoggles _goggles;
	{_newUnit linkItem _x} forEach _assignedItems;
	_newUnit setFace _face;
	_newUnit setSpeaker _speaker;
			
	{[_x,[[_newUnit],true]] remoteExec ["addCuratorEditableObjects",2];} forEach _curators;
} forEach Phobos_selectedObjects;



#include "\Phobos_aresExpansion\module_footer.hpp"