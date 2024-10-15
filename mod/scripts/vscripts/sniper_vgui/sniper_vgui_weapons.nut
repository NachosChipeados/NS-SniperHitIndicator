untyped

global function NewOnWeaponDeactivate_weapon_dmr
global function OnWeaponStartZoomIn_weapon_dmr
global function OnWeaponStartZoomOut_weapon_dmr

global function OnWeaponDeactivate_weapon_doubletake
global function OnWeaponStartZoomIn_weapon_doubletake
global function OnWeaponStartZoomOut_weapon_doubletake

global function OnWeaponDeactivate_weapon_sniper
global function OnWeaponStartZoomIn_weapon_sniper
global function OnWeaponStartZoomOut_weapon_sniper

// Just in case it gets ported one day
global function OnWeaponDeactivate_weapon_valkyrie
global function OnWeaponStartZoomIn_weapon_valkyrie
global function OnWeaponStartZoomOut_weapon_valkyrie

// Funny
global function OnWeaponDeactivate_weapon_lmg
global function OnWeaponStartZoomIn_weapon_lmg
global function OnWeaponStartZoomOut_weapon_lmg

//--------------------------------------------
//
//--------------------------------------------

void function NewOnWeaponDeactivate_weapon_dmr( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
	
	OnWeaponDeactivate_weapon_dmr( weapon )
}

void function OnWeaponStartZoomIn_weapon_dmr( entity weapon )
{
	#if CLIENT
		// Destoy and create it at the same time to prevent issues with variable zoom
		DestroySniperVGUI( weapon )

		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	#endif
}

void function OnWeaponStartZoomOut_weapon_dmr( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

//--------------------------------------------
//
//--------------------------------------------

void function OnWeaponDeactivate_weapon_doubletake( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

void function OnWeaponStartZoomIn_weapon_doubletake( entity weapon )
{
	#if CLIENT
	if ( weapon.HasMod( "scope_4x" ) || weapon.HasMod( "threat_scope" ) || weapon.HasMod( "stabilizer" ) || weapon.HasMod( "scope_dcom" ) )
	{
		// Destoy and create it at the same time to prevent issues with variable zoom
		DestroySniperVGUI( weapon )
	
		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	}
	#endif
}

void function OnWeaponStartZoomOut_weapon_doubletake( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

//--------------------------------------------
//
//--------------------------------------------

void function OnWeaponDeactivate_weapon_sniper( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

void function OnWeaponStartZoomIn_weapon_sniper( entity weapon )
{
	#if CLIENT
		// Destoy and create it at the same time to prevent issues with variable zoom
		DestroySniperVGUI( weapon )

		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	#endif
}

void function OnWeaponStartZoomOut_weapon_sniper( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

//--------------------------------------------
//
//--------------------------------------------

void function OnWeaponDeactivate_weapon_valkyrie( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

void function OnWeaponStartZoomIn_weapon_valkyrie( entity weapon )
{
	#if CLIENT
		// Destoy and create it at the same time to prevent issues with variable zoom
		DestroySniperVGUI( weapon )

		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	#endif
}

void function OnWeaponStartZoomOut_weapon_valkyrie( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}

//--------------------------------------------
//
//--------------------------------------------

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
		// Destoy and create it at the same time to prevent issues with variable zoom
		DestroySniperVGUI( weapon )
	
		CreateSniperVGUI( GetLocalViewPlayer(), weapon )
	}
	#endif
}

void function OnWeaponStartZoomOut_weapon_lmg( entity weapon )
{
	#if CLIENT
		DestroySniperVGUI( weapon )
	#endif
}