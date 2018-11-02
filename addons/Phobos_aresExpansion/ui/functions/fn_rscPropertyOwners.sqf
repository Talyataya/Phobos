//////////////////////////////////////////////////////////////
//
// Author: Talya
// Version: 1.0
// Description: Functionality for rscPropertyOwners component.
// Changelog: None.
// Notes: 
//		*Designed to work with chooseDialog.sqf.
//		*Cannot handle multiple instances due global variables.	
//
//////////////////////////////////////////////////////////////


#include "defines.inc"

_mode = _this select 0;
_display = _this select 1;
_isPlayersOnly = _this select 2;

_tabSide = _display displayCtrl IDC_RSCPROPERTYOWNERS_TABSIDE;
_tabGroup = _display displayCtrl IDC_RSCPROPERTYOWNERS_TABGROUP;
_tabUnit = _display displayCtrl IDC_RSCPROPERTYOWNERS_TABUNIT;
//_tabSelectedUnits = _display displayCtrl ...
_iconBlufor = _display displayCtrl IDC_RSCPROPERTYOWNERS_BLUFOR;
_iconOpfor = _display displayCtrl IDC_RSCPROPERTYOWNERS_OPFOR;
_iconIndependent = _display displayCtrl IDC_RSCPROPERTYOWNERS_INDEPENDENT;
_iconCivilian = _display displayCtrl IDC_RSCPROPERTYOWNERS_CIVILIAN;
_listGroup = _display displayCtrl IDC_RSCPROPERTYOWNERS_GROUPLIST;
_listUnit =  _display displayCtrl IDC_RSCPROPERTYOWNERS_UNITLIST;

_ctrlTabs = [_tabSide, _tabGroup, _tabUnit];
_ctrlIcons = [_iconOpfor, _iconBlufor, _iconIndependent, _iconCivilian];

switch _mode do {
	case "onLoad": {

		//Only side buttons should show at start.(For now at least.)
		{
			_x ctrlShow false;
		} forEach (/*_listIcons*/ + [_listGroup, _listUnit]);
		//Disabling this for start.(For now at least.)
		_tabSide ctrlEnable false;
		
		{
			//Set initial properties of side buttons.
			_sideID = _ctrlIcons find _x;
			_side = _sideID call BIS_fnc_sideType;
			_color = _sideID call BIS_fnc_sidecolor;
			_scale = 1;
			_alpha = 0.5;
			_x ctrlSetActiveColor _color;
			_color set [3, _alpha];
			_x ctrlSetTextColor _color;
			
			
			//Set EH for selection.
			Phobos_rscPropertyOwners_Sides = [];
			_x ctrlSetEventHandler ["ButtonClick", format ["
				_sideButton = _this select 0;
				_sideIdcs = [%1,%2,%3,%4];
				_sideId = _sideIdcs find (ctrlIdc _sideButton);
				_side = _sideId call BIS_fnc_sideType;
				_color = _sideId call BIS_fnc_sideColor;
				_scale = 1;
				_alpha = 0.5;
				if (_side in Phobos_rscPropertyOwners_Sides) then {
					Phobos_rscPropertyOwners_Sides = Phobos_rscPropertyOwners_Sides - [_side];
				} else {
					Phobos_rscPropertyOwners_Sides = Phobos_rscPropertyOwners_Sides + [_side];
					_scale = 1.2;
					_alpha = 1;
				};
				_color set [3,_alpha];
				_sideButton ctrlSetTextColor _color;
				_delay = 0.2;
				[_sideButton, _scale, _delay] call BIS_fnc_ctrlSetScale;
			", ctrlIDC _iconOpfor, ctrlIDC _iconBlufor, ctrlIDC _iconIndependent, ctrlIDC _iconCivilian]];
		} forEach _ctrlIcons;

		//Set EH of tabs.
		{
				_x ctrlSetEventHandler ["ButtonClick", format ["
				_ctrlTab = _this select 0;
				_display = ctrlParent _ctrlTab;
				_hiddenIdcs = [%4,%5,%6,%7,%8,%9];
				_shownIdcs = [];
				_activeTabIdcs = [];
				_inactiveTabIdcs = [%1,%2,%3];
				
				switch (ctrlIdc _ctrlTab) do {
					case %1: {
						_shownIdcs = [%4,%5,%6,%7];
						_activeTabIdcs pushBack %1;
					};
					
					case %2: {
						_shownIdcs = [%8];
						_activeTabIdcs pushBack %2;
					};
					
					case %3: {
						_shownIdcs = [%9];
						_activeTabIdcs pushBack %3;
					};
				};
				_hiddenIdcs = _hiddenIdcs - _shownIdcs;
				_inactiveTabIdcs = _inactiveTabIdcs - _activeTabIdcs; 
				
				{(_display displayCtrl _x) ctrlShow false;} forEach _hiddenIdcs;
				{(_display displayCtrl _x) ctrlShow true;} forEach _shownIdcs;
				{(_display displayCtrl _x) ctrlEnable false;} forEach _activeTabIdcs;
				{(_display displayCtrl _x) ctrlEnable true;} forEach _inactiveTabIdcs;
			", ctrlIDC _tabSide, ctrlIDC _tabGroup, ctrlIDC _tabUnit, ctrlIDC _iconBlufor, ctrlIDC _iconOpfor, ctrlIDC _iconIndependent, ctrlIDC _iconCivilian, ctrlIDC _listGroup, ctrlIDC _listUnit]];
		} forEach _ctrlTabs;


		_allUnits = [];
		_allGroups = [];
		if (_isPlayersOnly) then {
			_allUnits = playableUnits + switchableUnits;
			{
				_allGroups pushBack (group _x);
			} forEach _allUnits;
		} else {
			_allGroups = allGroups;
			_allUnits = allUnits;
		};
		
		
		_sides = [east, west, independent, civilian];
		_sideIcons = [
			gettext (configfile >> "CfgDiary" >> "Icons" >> "playerEast"),
			gettext (configfile >> "CfgDiary" >> "Icons" >> "playerWest"),
			gettext (configfile >> "CfgDiary" >> "Icons" >> "playerGuer"),
			gettext (configfile >> "CfgDiary" >> "Icons" >> "playerCiv")
		];
		
		Phobos_RscPropertyOwners_Groups = [];

		//Populate groups list.
		{
			_group = _x;
			_groupIndex = _forEachIndex;
			if (_isPlayersOnly) then {
				{
					if (isPlayer _x && {(side _x) in _sides} && !((group _x) in Phobos_RscPropertyOwners_Groups)) then {
						_groupSide = side (leader _group);
						_sideID = _sides find _groupSide;
						_sideIcon = _sideIcons select _sideID;
						_index = _listGroup lbAdd (groupID _group);
						_listGroup lbSetValue [_index, _groupIndex];
						_listGroup lbSetPicture [_index, _sideIcon];
						_sideColor = _sideID call BIS_fnc_sideColor;
						_listGroup lbSetPictureColor [_index, _sideColor];
						_listGroup lbSetTooltip [_index, str _groupIndex];
						Phobos_RscPropertyOwners_Groups pushBack (group _x);
					};
				} forEach (units _group);
			} else {
				{
					if ((side _x) in _sides && !((group _x) in Phobos_RscPropertyOwners_Groups)) then {
						_groupSide = side (leader _group);
						_sideID = _sides find _groupSide;
						_sideIcon = _sideIcons select _sideID;
						_index = _listGroup lbAdd (groupID _group);
						_listGroup lbSetValue [_index, _groupIndex];
						_listGroup lbSetPicture [_index, _sideIcon];
						_sideColor = _sideID call BIS_fnc_sideColor;
						_listGroup lbSetPictureColor [_index, _sideColor];
						_listGroup lbSetTooltip [_index, str _groupIndex];
						Phobos_RscPropertyOwners_Groups pushBack (group _x);
					};
				} forEach (units _group);
			};
		} forEach _allGroups;
		
		
		Phobos_RscPropertyOwners_Units = _allUnits;
		
		//Populate units list.
		{
			if ((side _x) in _sides) then {
				if (_isPlayersOnly) then {
					if (isPlayer _x) then {
						_index = _listUnit lbAdd (name _x);
						_listUnit lbSetValue [_index, _forEachIndex];
						_sideID = _sides find (side _x);
						_sideIcon = _sideIcons select _sideID;
						_listUnit lbSetPicture [_index, _sideIcon];
						_sideColor = _sideID call BIS_fnc_sideColor;
						_listUnit lbSetPictureColor [_index, _sideColor];
						_listUnit lbSetTooltip [_index, str _forEachIndex];
					};
				} else {
					private "_index";
					if (isPlayer _x) then {
						_index = _listUnit lbAdd (name _x);
						//_index lbSetPictureRight <Standing Soldier Pic>;
					} else {
						_index = _listUnit lbAdd (str _x);
					};
					_listUnit lbSetValue [_index, _forEachIndex];
					_listUnit lbSetTooltip [_index, str _forEachIndex];
					_sideID = _sides find (side _x);
					_sideIcon = (_sideIcons select _sideID);
					_listUnit lbSetPicture [_index, _sideIcon];
					_sideColor = _sideID call BIS_fnc_sideColor;
					_listUnit lbSetPictureColor [_index, _sideColor];
					_listUnit lbSetTooltip [_index, str _forEachIndex];
				};
			};
		} forEach _allUnits;
		lbSort _listGroup;
		lbSort _listUnit;
	};

	case "onUpdate": {
		//In here we do NOT care whether or not it is confirmed. Even if it is cancelled, it should be handled by the gui used. (Which is showChooseDialog.sqf in this case.)
		private _selectedUnits = [];
		
		//Return chosen elements in units form. (Only one of them should satisfy the condition.)
		//The disabled button gives a hint about, on which page(ie. Side, Group or Unit) the user has made his choice.
		if (!ctrlEnabled _tabSide) then {
			{
				if (_isPlayersOnly) then {
					if (isPlayer _x && {(side _x) in Phobos_rscPropertyOwners_Sides}) then {
						_selectedUnits pushBack _x;
					};
				} else {
					if ((side _x) in Phobos_rscPropertyOwners_Sides) then {
						_selectedUnits pushBack _x;
					};
				};
			} forEach allUnits;
		};
		
		if (!ctrlEnabled _tabGroup) then {
			[format ["_tabGroup groups: %1, choiceId: %2", _listGroup, (_listGroup lbValue lbCurSel _listGroup)], Phobos_enableUIAdvancedOutput] call Phobos_fnc_logMessage;
			_selectedUnits = units (Phobos_rscPropertyOwners_Groups select (_listGroup lbValue lbCurSel _listGroup));
		};
		
		if (!ctrlEnabled _tabUnit) then {
			//Preserving array form to fit to other results.
			_selectedUnits = [Phobos_rscPropertyOwners_Units select (_listUnit lbValue lbCurSel _listUnit)];
		};
		[format ["Selected units: %1", _selectedUnits], Phobos_enableUIAdvancedOutput] call Phobos_fnc_logMessage;
		_selectedUnits
	};
	
	case "onUnload": {
		Phobos_rscPropertyOwners_Sides = nil;
		Phobos_RscPropertyOwners_Groups = nil;
		Phobos_rscPropertyOwners_Units = nil;
		//Rest will be deleted by parent already.
	}
};

