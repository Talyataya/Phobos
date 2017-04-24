#define POSITION_MODIFIER_X 10.6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)
#define POSITION_MODIFIER_Y 7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH -(((safezoneW / safezoneH) min 1.2) / 1.2))/2)

class ShutdownWarning
{
	onUnload = "[] call compile preprocessfilelinenumbers 'A3\functions_f\debug\fn_shutdown.sqf'";
	idd=-1;
	movingEnable = false;
	class Controls
	{
		class BcgCommonTop: RscStructuredText
		{
			idc=-1;
			text = "Phobos";
			x=POSITION_MODIFIER_X;
			y=POSITION_MODIFIER_Y;
			w=18.8 * (((safezoneW / safezoneH) min 1.2) / 40);
			h=1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			colorBackground[] =
			{
				"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",
				1
			};
		};
		class BcgCommon: RscBackgroundGUI
		{
			idc=-1;
			x=POSITION_MODIFIER_X;
			y=POSITION_MODIFIER_Y + 1.1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			w=18.8 * (((safezoneW / safezoneH) min 1.2) / 40);
			h=5.4 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			colorBackground[] = {0,0,0,1};
		};
		class Text: RscStructuredText
		{
			idc=-1;
			text = "Could not detect Ares resources. Phobos requires Ares or an Ares based mod to work properly. Please retry after loading Ares or Ares based mod(ie. Achilles). Shutting down.";
			x=POSITION_MODIFIER_X + 0.7 * (((safezoneW / safezoneH) min 1.2) / 40);
			y=POSITION_MODIFIER_Y + 1.8 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			w=17 * (((safezoneW / safezoneH) min 1.2) / 40);
			h=4.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			colorBackground[] = {0,0,0,1};
		};
		class ButtonOK: RscButtonMenuOK
		{
			idc=-1;
			onMouseButtonClick = "(ctrlParent (_this select 0)) closeDisplay 0";
			soundClick[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundClick",0.1,1};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEnter",0.1,1};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundEscape",0.1,1};
			soundPush[] = {"\A3\ui_f\data\sound\RscButtonMenu\soundPush",0.1,1};
			x=POSITION_MODIFIER_X + 6.3 * (((safezoneW / safezoneH) min 1.2) / 40);
			y=1.53 * POSITION_MODIFIER_Y + 2.9 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			w=6.2 * (((safezoneW / safezoneH) min 1.2) / 40);
			h=1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			colorBackground[] = {0,0,0,1};
		};
		class ButtonOKLeftHand : RscText
		{
			idc=-1;
			x=POSITION_MODIFIER_X;
			y=1.53 * POSITION_MODIFIER_Y + 2.9 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			w=6.2 * (((safezoneW / safezoneH) min 1.2) / 40);
			h=1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			colorBackground[] = {0,0,0,1};
		};
		class ButtonOKRightHand: RscText
		{
			idc=-1;
			x=POSITION_MODIFIER_X + 12.6 * (((safezoneW / safezoneH) min 1.2) / 40);
			y=1.53 * POSITION_MODIFIER_Y + 2.9 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			w=6.2 * (((safezoneW / safezoneH) min 1.2) / 40);
			h=1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
			colorBackground[] = {0,0,0,1};
		};
	};
};
