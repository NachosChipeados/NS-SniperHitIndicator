untyped

global function NewOnWeaponActivate_weapon_dmr
global function NewOnWeaponDeactivate_weapon_dmr

global function OnWeaponActivate_weapon_doubletake
global function OnWeaponDeactivate_weapon_doubletake

global function NewOnWeaponActivate_weapon_sniper
global function OnWeaponDeactivate_weapon_sniper

// Just in case it gets ported one day
global function OnWeaponActivate_weapon_valkyrie
global function OnWeaponDeactivate_weapon_valkyrie

// Funny
global function NewOnWeaponActivate_weapon_lmg
global function OnWeaponDeactivate_weapon_lmg

//--------------------------------------------
//
//--------------------------------------------

void function NewOnWeaponActivate_weapon_dmr( entity weapon )
{
	#if CLIENT
		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	#endif

	OnWeaponActivate_weapon_dmr( weapon )
}

void function NewOnWeaponDeactivate_weapon_dmr( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
	
	OnWeaponDeactivate_weapon_dmr( weapon )
}

//--------------------------------------------
//
//--------------------------------------------

void function OnWeaponActivate_weapon_doubletake( entity weapon )
{
	#if CLIENT
	if ( weapon.HasMod( "scope_4x" ) || weapon.HasMod( "threat_scope" ) || weapon.HasMod( "stabilizer" ) || weapon.HasMod( "scope_dcom" ) )
	{
		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	}
	#endif
}

void function OnWeaponDeactivate_weapon_doubletake( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

//--------------------------------------------
//
//--------------------------------------------

void function NewOnWeaponActivate_weapon_sniper( entity weapon )
{
	#if CLIENT
		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	#endif

	OnWeaponActivate_weapon_sniper( weapon )
}

void function OnWeaponDeactivate_weapon_sniper( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

//--------------------------------------------
//
//--------------------------------------------

void function OnWeaponActivate_weapon_valkyrie( entity weapon )
{
	#if CLIENT
		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	#endif
}

void function OnWeaponDeactivate_weapon_valkyrie( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

//--------------------------------------------
//
//--------------------------------------------

void function NewOnWeaponActivate_weapon_lmg( entity weapon )
{
	#if CLIENT
		if ( weapon.HasMod( "aog" ) )
		{
			CreateSniperVGUI( GetLocalViewPlayer(), weapon )
		}
	#endif

	OnWeaponActivate_lmg( weapon )
}

void function OnWeaponDeactivate_weapon_lmg( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

void function OnWeaponStartZoomIn_weapon_lmg( entity weapon )
{
	#if CLIENT
		if ( weapon.HasMod( "aog" ) )
		{
			CreateSniperVGUI( GetLocalViewPlayer(), weapon )
		}
	#endif
}

