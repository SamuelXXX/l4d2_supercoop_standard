#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

ConVar GrenadeResupplyCVAR;

public Plugin myinfo =
{
	name = "Reloadable Grenade",
	author = "SamaelXXX",
	description = "Allow ammo pile reloading for grenade launcher",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	char sGame[32];
	GetGameFolderName(sGame, sizeof(sGame));

	if (!StrEqual(sGame, "left4dead2", false))
		SetFailState("Plugin supports Left 4 Dead 2 only.");

	GrenadeResupplyCVAR = CreateConVar("grenade_resupply", "1", " Do you allow players to resupply the Grenade off ammospots ", FCVAR_NOTIFY);

	HookEvent("player_use", eAmmoPickup);
	AutoExecConfig(true, "reloadable_grenade_launcher");
}

public void OnMapStart()
{
	if (!IsModelPrecached("models/w_models/weapons/w_grenade_launcher.mdl"))
		PrecacheModel("models/w_models/weapons/w_grenade_launcher.mdl");

	if (!IsModelPrecached("models/v_models/v_grenade_launcher.mdl"))
		PrecacheModel("models/v_models/v_grenade_launcher.mdl");
}

public void eAmmoPickup(Event event, const char[] name, bool dontBroadcast)
{
	if (GetConVarInt(GrenadeResupplyCVAR) != 1)
		return;

	int client = GetClientOfUserId(event.GetInt("userid"));
	int EntId = event.GetInt("targetid");

	char sClsName[32];
	GetEntityClassname(EntId, sClsName, sizeof(sClsName));

	if (StrEqual(sClsName, "weapon_ammo_spawn"))
	{
		int iWeapon = GetPlayerWeaponSlot(client, 0);

		if (IsValidEntity(iWeapon))
		{
			GetEntityClassname(iWeapon, sClsName, sizeof(sClsName));

			if (StrEqual(sClsName, "weapon_grenade_launcher"))
			{
				int AmmoType = GetEntProp(iWeapon, Prop_Data, "m_iPrimaryAmmoType");

				if (AmmoType == -1)
					return;

				int Clip = GetEntProp(iWeapon, Prop_Send, "m_iClip1");

				SetEntProp(client, Prop_Send, "m_iAmmo", GetConVarInt(FindConVar("ammo_grenadelauncher_max")) + 1 - Clip, _, AmmoType);
				ClientCommand(client, "play items/itempickup.wav");
			}
		}
	}
}