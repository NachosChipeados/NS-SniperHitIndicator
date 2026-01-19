untyped

global function SniperVGUI_Init

global function CreateSniperVGUI
global function DestroySniperVGUI

global const SniperVGUI_AllowScan = {
	[ "npc_drone" ]				= true,
	[ "npc_frag_drone" ]		= true,
	[ "npc_marvin" ]			= true,
	[ "npc_pilot_elite" ]		= true,
	[ "npc_prowler" ]			= true,
	[ "npc_soldier" ]			= true,
	[ "npc_soldier_heavy" ]		= true,
	[ "npc_soldier_shield" ]	= true,
	[ "npc_spectre" ]			= true,
	[ "npc_stalker" ]			= true,
//	[ "npc_super_spectre" ]		= true,
//	[ "npc_turret_sentry" ]		= true,
	[ "player" ]				= true,
	[ "player_decoy" ]			= true,
}

global const SniperVGUI_AllowedWeapons = {
	[ "mp_weapon_dmr" ]			= true,
	[ "mp_weapon_doubletake" ]	= true,
	[ "mp_weapon_lmg" ]			= true, // Funny
	[ "mp_weapon_sniper" ]		= true,
	[ "mp_weapon_sr_valkyrie" ]	= true,
	[ "mp_weapon_valkyrie" ]	= true,
}

struct
{
	entity selectedWeapon
} file

void function SniperVGUI_Init()
{
	if ( !IsLobby() )
	{
		PrecacheHUDMaterial( $"vgui/hud/hit_confirm_bg" )
		PrecacheHUDMaterial( $"vgui/hud/hit_confirm_head" )
		PrecacheHUDMaterial( $"vgui/hud/hit_confirm_torso" )
		PrecacheHUDMaterial( $"vgui/hud/hit_confirm_arm_left" )
		PrecacheHUDMaterial( $"vgui/hud/hit_confirm_arm_right" )
		PrecacheHUDMaterial( $"vgui/hud/hit_confirm_leg_left" )
		PrecacheHUDMaterial( $"vgui/hud/hit_confirm_leg_right" )

		PrecacheRes( "vgui_sniper" )
	}

	RegisterSignal( "UpdateSniperVGUI" )
	RegisterSignal( "UpdateSniperVGUI_KillShot" )
	RegisterSignal( "SniperVGUI_TargetChanged" )

	AddCallback_OnSelectedWeaponChanged( SniperVGUI_Setup )
	AddCallback_OnLocalPlayerDidDamage( SniperVGUI_DidDamage )
	AddCallback_OnCrosshairCurrentTargetChanged( SniperVGUI_CrosshairTargetChanged )
}

void function SniperVGUI_Setup( entity weapon )
{
	DestroySniperVGUI( file.selectedWeapon )

    if ( !IsValid( weapon ) || weapon.IsWeaponOffhand() )
        return

    file.selectedWeapon = weapon

	thread SniperVGUI_Setup_Threaded( weapon )
}

void function SniperVGUI_Setup_Threaded( entity selectedWeapon )
{
	WaitFrame()

	string weaponClass = selectedWeapon.GetWeaponClassName()

	bool isValidWeapon = ( weaponClass in SniperVGUI_AllowedWeapons )
	if ( !isValidWeapon )
		return

	entity player = GetLocalViewPlayer()

	bool hasAog = ( selectedWeapon.HasMod( "aog" ) || selectedWeapon.HasMod( "aog_r1" ) )
	bool hasSights = ( selectedWeapon.HasMod( "scope_4x" ) || selectedWeapon.HasMod( "threat_scope" ) || selectedWeapon.HasMod( "stabilizer" ) || selectedWeapon.HasMod( "scope_dcom" ) )

	if ( weaponClass == "mp_weapon_lmg" && !hasAog )
		return

	if ( weaponClass == "mp_weapon_doubletake" && !hasSights )
		return

	CreateSniperVGUI( player, selectedWeapon )
}

void function SniperVGUI_DidDamage( PlayerDidDamageParams params )
{
	if ( !GetConVarBool( "SniperUI.HitLabelEnabled" ) )
		return

	entity attacker = GetLocalViewPlayer()
	if ( !IsValid( attacker ) || attacker.IsTitan() )
		return

	entity victim = params.victim
	if ( !IsValid( victim ) )
		return

	if ( !IsValid( file.selectedWeapon ) )
		return

	string weaponClass = file.selectedWeapon.GetWeaponClassName()

	bool isValidWeapon = ( weaponClass in SniperVGUI_AllowedWeapons )
	if ( !isValidWeapon )
		return

	string entClass = expect string( victim.GetSignifierName() )

	int damageType = params.damageType
	int hitGroup = params.hitGroup

	bool isCritShot = (damageType & DF_CRITICAL) ? true : false
	bool isKillShot = (damageType & DF_KILLSHOT) ? true : false
	bool isBullet = (damageType & DF_BULLET) ? true : false

	if ( isValidWeapon && attacker.GetAdsFraction() > 0.7 && isBullet )
	{
		if ( entClass in SniperVGUI_AllowScan && hitGroup != HITGROUP_GENERIC )
		{
			if ( !isKillShot )
				attacker.Signal( "UpdateSniperVGUI", { hitGroup = hitGroup } )
			else
				attacker.Signal( "UpdateSniperVGUI_KillShot", { hitGroup = hitGroup } )
		}
		else if ( victim.IsTitan() && hitGroup == HITGROUP_GENERIC || isCritShot )
		{
			if ( !isKillShot )
				attacker.Signal( "UpdateSniperVGUI", { hitGroup = hitGroup } )
			else
				attacker.Signal( "UpdateSniperVGUI_KillShot", { hitGroup = hitGroup } )
		}
	}
}


void function SniperVGUI_CrosshairTargetChanged ( entity player, entity newTarget )
{
	if ( !GetConVarBool( "SniperUI.InfoLabelEnabled" ) )
		return

	if ( !IsValid( player ) )
		return

	if ( !IsValid( newTarget ) )
		return

	if ( !IsValid( file.selectedWeapon ) )
		return

	string weaponClass = file.selectedWeapon.GetWeaponClassName()

	bool isValidWeapon = ( weaponClass in SniperVGUI_AllowedWeapons )
	if ( !isValidWeapon )
		return

	if ( !IsCloaked( newTarget ) && player.GetAdsFraction() > 0.7 )
	{
		player.Signal( "SniperVGUI_TargetChanged", { newTarget = newTarget } )
	}
}

void function CreateSniperVGUI( entity player, entity weapon )
{
	Assert( IsClient() )

	if ( weapon.GetWeaponOwner() != player )
		return

	if ( "sniperVGUI" in weapon.s )
		return

	string vguiName = "vgui_sniper"
	entity modelEnt	= player.GetViewModelEntity()
	if ( !IsValid( modelEnt ) )
		return

	local fixedSize

	bool isValkyrie = ( weapon.GetWeaponClassName() == "mp_weapon_valkyrie" || weapon.GetWeaponClassName() == "mp_weapon_sr_valkyrie" )

	if ( isValkyrie )
	{
		fixedSize =	[ 1.5, 1.5 ]
	}
	else
	{
		fixedSize =	[ 3.0, 3.0 ]
	}

	if ( weapon.HasMod( "stabilizer" ) && !isValkyrie )
	{
		fixedSize =	[ 2.0, 2.0 ]

	}
	else if ( weapon.HasMod( "aog" ) || weapon.HasMod( "aog_r1" ) )
	{
		if ( isValkyrie )
		{
			fixedSize =	[ 2.0, 2.0 ]
		}
		else
		{
			fixedSize =	[ 1.5, 1.5 ]
		}
	}
	else if ( weapon.HasMod( "scope_8x" ) )
	{
		fixedSize =	[ 1.6, 1.6 ]
	}

	float fovScale = GetConVarFloat( "cl_fovScale" )
	float applyScale = GraphCapped( fovScale, 1.0, 1.3, 1.0, 1.45 )

	entity vgui = CreateClientsideVGuiScreen( vguiName, VGUI_SCREEN_PASS_VIEWMODEL, Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), fixedSize[0] * applyScale, fixedSize[1] * applyScale )
	var panel   = vgui.GetPanel()
	vgui.s.panel <- panel

	vgui.s.hitConfirmBG <- HudElement( "HitConfirmBG", panel )
	vgui.s.hitConfirmPoints <- {}
	vgui.s.hitConfirmPoints[HITGROUP_CHEST] <- HudElement( "HitConfirmTorso", panel )
	vgui.s.hitConfirmPoints[HITGROUP_GENERIC] <- vgui.s.hitConfirmPoints[HITGROUP_CHEST]
	vgui.s.hitConfirmPoints[HITGROUP_STOMACH] <- vgui.s.hitConfirmPoints[HITGROUP_CHEST]
	vgui.s.hitConfirmPoints[HITGROUP_GEAR] <- vgui.s.hitConfirmPoints[HITGROUP_CHEST]
	vgui.s.hitConfirmPoints[HITGROUP_HEAD] <- HudElement( "HitConfirmHead", panel )
	vgui.s.hitConfirmPoints[HITGROUP_LEFTARM] <- HudElement( "HitConfirmArmLeft", panel )
	vgui.s.hitConfirmPoints[HITGROUP_RIGHTARM] <- HudElement( "HitConfirmArmRight", panel )
	vgui.s.hitConfirmPoints[HITGROUP_LEFTLEG] <- HudElement( "HitConfirmLegLeft", panel )
	vgui.s.hitConfirmPoints[HITGROUP_RIGHTLEG] <- HudElement( "HitConfirmLegRight", panel )

	vgui.s.confidenceLabel <- HudElement( "ConfidenceLabel", panel )

	weapon.s.sniperVGUI <- vgui
	weapon.s.sniperVGUI.s.nextUpdateTime <- 0

	float fireRate = weapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
	float rechamberTime = weapon.GetWeaponSettingFloat( eWeaponVar.rechamber_time )

	if ( fireRate > 3.0 )
		fireRate = 2.5

	if ( rechamberTime > 0 )
		weapon.s.sniperVGUI.s.confirmationTime <- ( rechamberTime )
	else
		weapon.s.sniperVGUI.s.confirmationTime <- ( fireRate )

	if ( GetConVarBool( "SniperUI.InfoLabelEnabled" ) )
		thread SniperVGUI_PotentialHitThink( player, weapon )

	thread SniperVGUI_Think( player, weapon )
	thread SniperVGUI_Think_KillShot( player, weapon )

	thread SniperVGUI_UpdateSettings( player, weapon )

//	printt( "//////////////////////////////////////////////" )
//	printt( "Created sniper VGUI for: " + weapon )
//	printt( "//////////////////////////////////////////////" )
}

void function SniperVGUI_UpdateSettings( entity player, entity weapon )
{
	weapon.s.sniperVGUI.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnDestroy" )

	string bottomLeftAttachment
	string topRightAttachment

	array<float> fixedOffsets

	var t = weapon.s.sniperVGUI

	while( true )
	{
		entity modelEnt	= player.GetViewModelEntity()
		if ( !IsValid( modelEnt ) )
			return

		bool isValkyrie = ( weapon.GetWeaponClassName() == "mp_weapon_valkyrie" || weapon.GetWeaponClassName() == "mp_weapon_sr_valkyrie" )

		// TODO: per-weapon overrides
		float default_x = 		GetConVarFloat( "SniperUI.DefaultX" )
		float default_y = 		GetConVarFloat( "SniperUI.DefaultY" )
	/*
		float threat_x = 		GetConVarFloat( "SniperUI.ThreatX" )
		float threat_y = 		GetConVarFloat( "SniperUI.ThreatY" )
		float threat_z_TEST =	GetConVarFloat( "SniperUI.ThreatZ_TEST" )
	*/
		float stabilizer_x = 	GetConVarFloat( "SniperUI.StabilizerX" )
		float stabilizer_y = 	GetConVarFloat( "SniperUI.StabilizerY" )
		float aog_x =			GetConVarFloat( "SniperUI.AogX" )
		float aog_y =			GetConVarFloat( "SniperUI.AogY" )

		if ( player.GetAdsFraction() < 0.7 )
		{
			if ( isValkyrie )
			{
				bottomLeftAttachment = "L_HAND"
				topRightAttachment = "R_HAND"
			}
			else
			{
				bottomLeftAttachment = "l_hand_ik"
				topRightAttachment = "r_hand_ik"
			}

			fixedOffsets =		[ 0.0, 0.0, 0.0 ]
		}
		else
		{

			if ( isValkyrie )
			{
				bottomLeftAttachment = 	"SCR_BL_SCOPE12X"
				topRightAttachment = 	"SCR_TR_SCOPE12X"
				fixedOffsets =			[ 0.1, 0.0, 0.0 ]
			}
			else
			{
				bottomLeftAttachment = 	"SCR_BL_SCOPEADS"
				topRightAttachment = 	"SCR_TR_SCOPEADS"
				fixedOffsets =			[ default_x, default_y, 0.0 ]
			}
		/*
			if ( weapon.HasMod( "scope_4x" ) ) // Not needed
			{
				bottomLeftAttachment = 	"SCR_BL_SCOPE_TALON"
				topRightAttachment = 	"SCR_TR_SCOPE_TALON"
			}
		*/

		/*
			if ( weapon.HasMod( "threat_scope" ) ) // Doesn't work and i don't know why
			{
				bottomLeftAttachment = 	"SCR_BL_SCOPE_WONYEON"
				topRightAttachment = 	"SCR_TR_SCOPE_WONYEON"
				fixedOffsets =			[ threat_x, threat_y, threat_z_TEST ]
			}
		*/
			if ( weapon.HasMod( "stabilizer" ) && !isValkyrie )
			{
				bottomLeftAttachment = 	"SCR_BL_ORACLE"
				topRightAttachment = 	"SCR_TR_ORACLE"
				fixedOffsets =			[ stabilizer_x, stabilizer_y, 0.0 ]
		
			}
			else if ( weapon.HasMod( "aog" ) || weapon.HasMod( "aog_r1" ) )
			{
				bottomLeftAttachment = 	"SCR_BL_AOG"
				topRightAttachment = 	"SCR_TR_AOG"

				if ( isValkyrie )
				{
					fixedOffsets =		[ 0.0, 0.1, 0.0 ]
				}
				else
				{
					fixedOffsets =		[ aog_x, aog_y, -2.0 ]
				}
			}
			else if ( weapon.HasMod( "scope_8x" ) )
			{
				bottomLeftAttachment = 	"SCR_BL_SCOPE8X"
				topRightAttachment = 	"SCR_TR_SCOPE8X"
				fixedOffsets =			[ 0.1, 0.0, 0.0 ]
			}

			if ( player.IsInputCommandHeld( IN_VARIABLE_SCOPE_TOGGLE ) || player.IsInputCommandHeld( IN_SPEED ) )
			{
				fixedOffsets[2] += -10
			}
		}

		int bottomLeftID 	= modelEnt.LookupAttachment( bottomLeftAttachment )
		int topRightID 		= modelEnt.LookupAttachment( topRightAttachment )

		// JFS: defensive fix for kill replay issues
		if ( bottomLeftID == 0 || topRightID == 0 )
			return

		t.SetParent( modelEnt, bottomLeftAttachment )
		t.SetAttachOffsetOrigin( Vector( fixedOffsets[0], fixedOffsets[1], fixedOffsets[2] ) )
		t.SetAttachOffsetAngles( Vector( 0, 0, 0 ) )

		WaitFrame()
	}
}

void function DestroySniperVGUI( entity weapon )
{
	if ( IsValid( weapon ) && "sniperVGUI" in weapon.s )
	{
		weapon.s.sniperVGUI.Destroy()
		delete weapon.s.sniperVGUI

//		printt( "// -------------------------------------------------" )
//		printt( "Deleted " + weapon + "'s sniper VGUI" )
//		printt( "// -------------------------------------------------" )
	}
}

void function SniperVGUI_Think( entity player, entity weapon )
{
	weapon.s.sniperVGUI.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnDestroy" )

	while ( true )
	{
		var results = player.WaitSignal( "UpdateSniperVGUI" )

		if ( GetConVarBool( "SniperUI.HitLabelEnabled" ) )
			thread SniperVGUI_ShowHit( player, weapon, results.hitGroup )
	}
}

void function SniperVGUI_Think_KillShot( entity player, entity weapon )
{
	weapon.s.sniperVGUI.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnDestroy" )

	while ( true )
	{
		var results = player.WaitSignal( "UpdateSniperVGUI_KillShot" )
		
		if ( GetConVarBool( "SniperUI.HitLabelEnabled" ) )
			thread SniperVGUI_ShowHit( player, weapon, results.hitGroup, true )
	}
}

void function SniperVGUI_ShowHit( entity player, entity weapon, var hitGroup, bool isKillShot = false )
{
	weapon.s.sniperVGUI.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	var t = weapon.s.sniperVGUI.s

	while ( true )
	{
		t.nextUpdateTime = Time() + t.confirmationTime / 1.5
		t.hitConfirmBG.Show()

		float red =			GetConVarFloat( "SniperUI.HitColorRed" )
		float green =		GetConVarFloat( "SniperUI.HitColorGreen" )
		float blue =		GetConVarFloat( "SniperUI.HitColorBlue" )
		float alpha =		GetConVarFloat( "SniperUI.HitColorAlpha" )
	
		float red_label =	GetConVarFloat( "SniperUI.HitLabelRed" )
		float green_label =	GetConVarFloat( "SniperUI.HitLabelGreen" )
		float blue_label =	GetConVarFloat( "SniperUI.HitLabelBlue" )
		float alpha_label =	GetConVarFloat( "SniperUI.HitLabelAlpha" )

		if ( isKillShot )
		{
			red_label =		GetConVarFloat( "SniperUI.KillLabelRed" )
			green_label =	GetConVarFloat( "SniperUI.KillLabelGreen" )
			blue_label =	GetConVarFloat( "SniperUI.KillLabelBlue" )
			alpha_label =	GetConVarFloat( "SniperUI.KillLabelAlpha" )
		}

		if ( player.GetAdsFraction() > 0.7 )
		{
			t.hitConfirmPoints[hitGroup].Show()
			t.hitConfirmPoints[hitGroup].SetColor( red, green, blue, alpha )
			t.hitConfirmPoints[hitGroup].FadeOverTimeDelayed( 0, t.confirmationTime / 2, t.confirmationTime / 2 + GetConVarFloat( "SniperUI.HitTime" ) )
	
			//t.confidenceLabel.SetAlpha( alpha_label )
			t.confidenceLabel.Show()
			t.confidenceLabel.SetColor( red_label, green_label, blue_label, alpha_label )
			
			if ( !isKillShot )
				t.confidenceLabel.SetText( "#WPN_DMR_HIT_CONFIRMED" )
			else
				t.confidenceLabel.SetText( "#WPN_DMR_KILL_CONFIRMED" )

			t.confidenceLabel.FadeOverTimeDelayed( 0, t.confirmationTime / 2, t.confirmationTime / 2 + GetConVarFloat( "SniperUI.HitTime" ) )
		}
		wait 0
	}
}

void function SniperVGUI_PotentialHitThink( entity player, entity weapon )
{
	weapon.s.sniperVGUI.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnDestroy" )

	var t = weapon.s.sniperVGUI.s

	while ( true )
	{
		var results = player.WaitSignal( "SniperVGUI_TargetChanged" )

		var newTarget = results.newTarget

		if ( !IsValid( newTarget ) )
			continue

		if ( newTarget.GetTeam() == player.GetTeam() )
			continue

		var entClass = newTarget.GetSignifierName()

		if ( !( entClass in SniperVGUI_AllowScan ) )
			continue

		thread SniperVGUI_UpdateTargetData( player, newTarget, weapon )
	}
}

void function SniperVGUI_UpdateTargetData( entity player, var crosshairTarget, entity weapon )
{
	weapon.s.sniperVGUI.EndSignal( "OnDestroy" )
	player.EndSignal( "SniperVGUI_TargetChanged" )
	player.EndSignal( "OnDestroy" )

	var t = weapon.s.sniperVGUI.s
	float farDist = weapon.GetWeaponSettingFloat( eWeaponVar.damage_far_distance )

	while ( true )
	{
		if ( player.GetAdsFraction() > 0.7 && Time() >= t.nextUpdateTime )
		{
			TraceResults traceResult = TraceLineHighDetail( player.EyePosition(), player.EyePosition() + ( player.CameraAngles().AnglesToForward() * farDist * 2 ), player, (TRACE_MASK_SHOT | CONTENTS_BLOCKLOS), TRACE_COLLISION_GROUP_NONE )

			entity target = traceResult.hitEnt

			if ( !IsValid( target ) || target != crosshairTarget )
			{
				wait 0
				continue
			}

			string entClass = expect string( target.GetSignifierName() )

			int hitGroup = traceResult.hitGroup

			table hitData = GetHitProbabilityData( player, target, hitGroup, weapon )

			float unit_div
			if ( !GetConVarBool( "SniperUI.Measure_HU" ) )
				unit_div = 39.3701
			else
				unit_div = 1

			float red =			GetConVarFloat( "SniperUI.HitInfoRed" )
			float green =		GetConVarFloat( "SniperUI.HitInfoGreen" )
			float blue =		GetConVarFloat( "SniperUI.HitInfoBlue" )
			float alpha =		GetConVarFloat( "SniperUI.HitInfoAlpha" )
				
			float red_label =	GetConVarFloat( "SniperUI.InfoLabelRed" )
			float green_label =	GetConVarFloat( "SniperUI.InfoLabelGreen" )
			float blue_label =	GetConVarFloat( "SniperUI.InfoLabelBlue" )
			float alpha_label =	GetConVarFloat( "SniperUI.InfoLabelAlpha" )

			//t.confidenceLabel.SetAlpha( alpha_label )
			t.confidenceLabel.SetColor( red_label, green_label, blue_label, alpha_label )

			string hit
			string dist
			string speed

			if ( hitData.distance <= farDist )
			{
				hit = format( "%.1f", hitData.confidence * 100 )
				dist = format( "%.2f", hitData.distance / unit_div )
				speed = format( "%.2f", hitData.speed / unit_div )
			}
			else
			{
				hit = "---"
				dist = "---"
				speed = "---"
			}

			// Stupid hack because GetVelocity() doesn't work on NPCs
			// Still letting decoys use it anyway, even if it looks bad
			if( IsPilot( target ) || IsPilotDecoy( target ) )
				t.confidenceLabel.SetText( "#WPN_DMR_DATA_R1", hit + "%", dist, speed )
			else
				t.confidenceLabel.SetText( "#WPN_DMR_DATA_NPC", hit + "%", dist )

			t.confidenceLabel.FadeOverTime( 0, 0.3 )

			t.hitConfirmPoints[hitGroup].Show()
			t.hitConfirmPoints[hitGroup].SetColor( red, green, blue, alpha )
			t.hitConfirmPoints[hitGroup].FadeOverTime( 0, 0.032 )
		}

		wait 0
	}
}

table function GetHitProbabilityData( entity player, entity target, int hitGroup, entity weapon )
{
	var t = weapon.s.sniperVGUI.s

	t.hitGroupProbabilityModifier <- {}
	t.hitGroupProbabilityModifier[HITGROUP_CHEST] <- 1.0
	t.hitGroupProbabilityModifier[HITGROUP_GENERIC] <- 1.0
	t.hitGroupProbabilityModifier[HITGROUP_STOMACH] <- 0.98
	t.hitGroupProbabilityModifier[HITGROUP_GEAR] <- 1.0
	t.hitGroupProbabilityModifier[HITGROUP_HEAD] <- 0.97
	t.hitGroupProbabilityModifier[HITGROUP_LEFTARM] <- 0.96
	t.hitGroupProbabilityModifier[HITGROUP_RIGHTARM] <- 0.96
	t.hitGroupProbabilityModifier[HITGROUP_LEFTLEG] <- 0.94
	t.hitGroupProbabilityModifier[HITGROUP_RIGHTLEG] <- 0.94

	float targetSpeed = Length( target.GetVelocity() )
	float targetDist = Distance( target.GetOrigin(), player.GetOrigin() )

	var confidence = 1.0
	confidence *= GraphCapped( targetDist, 2000, 4000, 0.99, 0.60 )
	confidence *= GraphCapped( targetSpeed, 10, 250, 0.99, 0.60 )
	confidence *= t.hitGroupProbabilityModifier[hitGroup]

	return { confidence = confidence, distance = targetDist, speed = targetSpeed }
}
