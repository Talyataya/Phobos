class ChangelogDialog
{
	idd = 340101;
	onLoad = "_this call compile preprocessfilelinenumbers '\Phobos_aresExpansion\ui\functions\fn_displayChangelog.sqf'";
	movingEnable = false;
	class controls 
	{
		class RscButtonMenuOK_2600: RscButtonMenuOK
		{
			idc = 2600;
			onMouseButtonClick = "[] call compile preprocessFileLineNumbers '\Phobos_aresExpansion\ui\functions\fn_displayChangelogFnc.sqf'";
			soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.1,1};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.1,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.1,1};
			soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.1,1};
			x = 0.64 * safezoneW + safezoneX;
			y = 0.644375 * safezoneH + safezoneY;
			w = 0.07 * safezoneW;
			h = 0.039375 * safezoneH;
		};
		
		class TextTitle : RscStructuredText
		{
			idc = 1101;
			colorBackground[] = {0,0,0,1};
			x = 0.2025 * safezoneW + safezoneX;
			y = 0.250625 * safezoneH + safezoneY;
			w = 0.56 * safezoneW;
			h = 0.02625 * safezoneH;
		};
		
		class StructuredTextControlGroup : RscControlsGroupNoHScrollbars
		{	
			idc = -1;
			x = 0.2025 * safezoneW + safezoneX;
	        y = 0.276875 * safezoneH + safezoneY;
	        w = 0.56 * safezoneW;
          	h = 0.3675 * safezoneH;
			class controls 
			{
				class RscStructuredText_1100: RscStructuredText
				{
					idc = 1100;
					colorBackground[] = { 0, 0, 0, 0 };
					size = ((((GUI_GRID_W / GUI_GRID_H ) min 1.2) / 1.2) / 25) / (getResolution select 5);
					lineSpacing = 1;
					x = 0;
					y = 0;
					w = 0.56 * safezoneW;
					h = 0.3675 * safezoneH;
				};
			};
		};
	};
	class controlsBackground
	{
        class MainBackground: IGUIBack
        {
        	idc = -1;
            x = safezoneXAbs;
            y = safezoneY;
            w = safezoneWAbs;
            h = safezoneH;
        };
		
		class TextContentBackground : RscText
		{
			idc = -1;
			colorBackground[] = { 0, 0, 0, 0.7 };
			x = 0.2025 * safezoneW + safezoneX;
			y = 0.276875 * safezoneH + safezoneY;
			w = 0.56 * safezoneW;
			h = 0.42 * safezoneH;
		};
    };
};
