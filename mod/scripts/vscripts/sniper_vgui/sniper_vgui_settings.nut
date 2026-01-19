global function SniperVGUISettings_Init

void function SniperVGUISettings_Init()
{
	string red = "^ff010000Red^e0e0e000 "
	string green = "^00ff0000Green^e0e0e000 " 
	string blue = "^0000ff00Blue^e0e0e000 "

	ModSettings_AddModTitle( "Sniper Hit Indicator" )
	ModSettings_AddModCategory( "General" )
	ModSettings_AddEnumSetting( "SniperUI.HitLabelEnabled", "Enable \"Hit/Kill Confirmed\" Labels", [ "#SETTING_OFF", "#SETTING_ON" ] )
	ModSettings_AddSetting( "SniperUI.HitTime", "Hit Confirm FadeOut Delay", "float" )
	ModSettings_AddEnumSetting( "SniperUI.Measure_HU", "Use Hammer Units For Measurements", [ "#SETTING_OFF", "#SETTING_ON" ] )

	ModSettings_AddModCategory( "Hit Indicator Position" )
	ModSettings_AddSetting(	"SniperUI.DefaultX", "Default/Variable Scope Position [X]", "float" )
	ModSettings_AddSetting(	"SniperUI.DefaultY", "Default/Variable Scope Position [Y]", "float" )
	//ModSettings_AddSetting( "SniperUI.ThreatX", "Threat Scope Position [X]", "float" )
	//ModSettings_AddSetting( "SniperUI.ThreatY", "Threat Scope Position [Y]", "float" )
	ModSettings_AddSetting(	"SniperUI.StabilizerX", "Stabilizer Scope Position [X]", "float" )
	ModSettings_AddSetting(	"SniperUI.StabilizerY", "Stabilizer Scope Position [Y]", "float" )
	ModSettings_AddSetting(	"SniperUI.AogX", "AOG Position [X]", "float" )
	ModSettings_AddSetting(	"SniperUI.AogY", "AOG Position [Y]", "float" )

	ModSettings_AddModCategory( "Target Hit Hightlight" )
	ModSettings_AddSliderSetting( "SniperUI.HitColorRed", red + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitColorGreen", green + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitColorBlue", blue + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitColorAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Target Info Hightlight" )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoRed", red + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoGreen", green + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoBlue", blue + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Hit Confirmed Label" )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelRed", red + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelGreen", green + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelBlue", blue + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Kill Confirmed Label" )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelRed", red + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelGreen", green + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelBlue", blue + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Target Info Label" )
	ModSettings_AddEnumSetting( "SniperUI.InfoLabelEnabled", "Enable Target Info Label", [ "#SETTING_OFF", "#SETTING_ON" ] )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelRed", red + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelGreen", green + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelBlue", blue + "Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelAlpha", "Alpha Value", 0, 255, 0.1, true )
}