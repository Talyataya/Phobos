//TODO: Complete scripts, idc numbers, define them in .inc file and move .inc file to a separate file.
class Phobos_CopyPaste_Dialog
{
	idd = 340201;
	onLoad = "((_this select 0) displayCtrl 1400) ctrlSetText (missionNamespace getVariable ['Phobos_CopyPaste_Dialog_Text', '']);";
	movingEnable = false;
	class controls
	{
		class Code: RscEdit
		{
			idc = 1400;
			//text = "";
			style = 16;
			linespacing = 1;
			autocomplete = "scripting";
			x = 3 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 34 * GUI_GRID_W;
			h = 16 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.7};
		};
		class ButtonCancel: RscButtonMenuCancel
		{
			x = 32.24 * GUI_GRID_W + GUI_GRID_X;
			y = 20.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class ButtonOK: RscButtonMenuOK
		{
			x = 28.15 * GUI_GRID_W + GUI_GRID_X;
			y = 20.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class InfoText: RscText
		{
			idc = 1000;
			text = "Copy/Paste clipboard contents using CTRL+C and CTRL+V";
			style = 16 + 512;
			linespacing = 1;
			x = 3 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 34 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			//colorBackground[] = {0,0,0,0};
		};
		class Title: RscText
		{
			idc = 1001;
			text = "Phobos";
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 36 * GUI_GRID_W;
			h = 1.16836 * GUI_GRID_H;
			colorBackground[] = {
				"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
			};
		};
	};
	
	class controlsBackground
	{
        class MainBackground: RscText
        {
        	idc = -1;
            x = safezoneXAbs;
            y = safezoneY;
            w = safezoneWAbs;
            h = safezoneH;
        };
		class Bcg_00: RscText
		{
			idc = -1;
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 16 * GUI_GRID_H;
			colorBackground[] = {0.05,0.05,0.05,0.85};
		};
		class Bcg_01: Bcg_00
		{
			x = 36.95 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.0505 * GUI_GRID_W;
			h = 16 * GUI_GRID_H;
		};
		class Bcg_02: Bcg_00
		{
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 36 * GUI_GRID_W;
			h = 4.00505 * GUI_GRID_H;
		};
		class Bcg_03: Bcg_00
		{
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 20.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 26 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class Bcg_04: Bcg_00
		{
			x = 36.3 * GUI_GRID_W + GUI_GRID_X;
			y = 20.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.70202 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
	};
};