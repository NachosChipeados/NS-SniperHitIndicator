global function SniperVGUISettings_Init

void function SniperVGUISettings_Init()
{
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
	ModSettings_AddSliderSetting( "SniperUI.HitColorRed", "Red Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitColorGreen", "Green Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitColorBlue", "Blue Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitColorAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Target Info Hightlight" )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoRed", "Red Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoGreen", "Green Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoBlue", "Blue Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitInfoAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Hit Confirmed Label" )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelRed", "Red Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelGreen", "Green Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelBlue", "Blue Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.HitLabelAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Kill Confirmed Label" )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelRed", "Red Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelGreen", "Green Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelBlue", "Blue Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.KillLabelAlpha", "Alpha Value", 0, 255, 0.1, true )

	ModSettings_AddModCategory( "Target Info Label" )
	ModSettings_AddEnumSetting( "SniperUI.InfoLabelEnabled", "Enable Target Info Label", [ "#SETTING_OFF", "#SETTING_ON" ] )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelRed", "Red Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelGreen", "Green Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelBlue", "Blue Value", 0, 255, 0.1, true )
	ModSettings_AddSliderSetting( "SniperUI.InfoLabelAlpha", "Alpha Value", 0, 255, 0.1, true )
}