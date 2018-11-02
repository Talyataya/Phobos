//Taken and modified from BI's RscAttributeOwners.

//Usage tweaked to work together with showChooseDialog.sqf
class RscPropertyOwners : RscControlsGroupNoScrollbars {
	idc = 18708;
	//onLoad = "['onLoad',ctrlParent (_this select 0)] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf'";
	//onUnload = "['onUnload',ctrlParent (_this select 0)] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf'";
	x = 16.5 * GUI_GRID_W + GUI_GRID_X; //COMBO_COLUMN_X - CONTROLSGROUP_X
	y = 0;
	w = 21 * GUI_GRID_W;
	h = 4 * GUI_GRID_H; //Get a proper height
	class controls
	{
		/*
		class Title : RscText
		{
			idc = 17410;
			text = "$STR_A3_RscAttributeOwners_Title";
			x = "0 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			y = "0 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			w = "26 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorBackground[] = { 0,0,0,0.5 };
		};
		*/
		class Background : RscText
		{
			idc = 17408;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 1 * GUI_GRID_H + GUI_GRID_Y; 
			w = 21 * GUI_GRID_W;
			h = 3 * GUI_GRID_H;
			colorBackground[] = { 1,1,1,0.1 };
		};
		class TabSide : RscButton
		{
			colorDisabled[] = { 1,1,1,1 };
			colorFocused[] = { 1,1,1,0.1 };
			colorBackground[] = { 1,1,1,0 };
			colorBackgroundActive[] = { 1,1,1,0.30000001 };
			colorBackgroundDisabled[] = { 1,1,1,0.1 };
			period = 0;
			periodFocus = 0;
			periodOver = 0;
			shadow = 0;
			font = "RobotoCondensedLight";
			idc = 18010;
			text = "SIDES";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class TabGroup : TabSide
		{
			idc = 18011;
			text = "GROUP";
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class TabUnit : TabSide
		{
			idc = 18012;
			text = "PLAYER";
			x = 14 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class BLUFOR : RscActivePicture
		{
			idc = 17608;
			text = "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_west_ca.paa";
			x = 3.5 * GUI_GRID_W + GUI_GRID_X;
			y = 1.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.4 * GUI_GRID_W;
			h = 2.16 * GUI_GRID_H;
			tooltip = "BLUFOR"; //"$STR_WEST"
		};
		class OPFOR : BLUFOR
		{
			idc = 17609;
			text = "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_east_ca.paa";
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 1.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.4 * GUI_GRID_W;
			h = 2.16 * GUI_GRID_H;
			tooltip = "OPFOR"; //"$STR_EAST"
		};
		class Independent : BLUFOR
		{
			idc = 17610;
			text = "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_guer_ca.paa";
			x = 11.5 * GUI_GRID_W + GUI_GRID_X;
			y = 1.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.4 * GUI_GRID_W;
			h = 2.16 * GUI_GRID_H;
			tooltip = "Independent"; //"$STR_guerilla"
		};
		class Civilian : BLUFOR
		{
			idc = 17611;
			text = "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_civ_ca.paa";
			x = 15.5 * GUI_GRID_W + GUI_GRID_X;
			y = 1.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.4 * GUI_GRID_W;
			h = 2.16 * GUI_GRID_H;
			tooltip = "Civilian"; //"$STR_Civilian"
		};
		class GroupList : RscCombo
		{
			idc = 18508;
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = 1.8 * GUI_GRID_H + GUI_GRID_Y);
			w = 19 * GUI_GRID_W;
			h = 1.35 * GUI_GRID_H;
		};
		class UnitList : RscCombo
		{
			idc = 18509;
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = 1.8 * GUI_GRID_H + GUI_GRID_Y;
			w = 19 * GUI_GRID_W;
			h = 1.35 * GUI_GRID_H;
		};
	};
};

//All controls listing all units(including players).
class RscPropertyOwners_Units : RscPropertyOwners {
	onLoad = "['onLoad',ctrlParent (_this select 0), false] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf'";
	onUnload = "['onUnload',ctrlParent (_this select 0), false] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf'";
};

//All controls listing players (and playable units) only.
class RscPropertyOwners_Players : RscPropertyOwners {
	onLoad = "['onLoad',ctrlParent (_this select 0), true] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf'";
	onUnload = "['onUnload',ctrlParent (_this select 0), true] call compile preProcessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_rscPropertyOwners.sqf'";
};