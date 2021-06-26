#include <sourcemod>
#include <sdktools>
#include <builtinvotes>
#include <l4d2_weapon_stocks>
#include <colors>
#include <left4dhooks>
#undef REQUIRE_PLUGIN
#include <readyup>
#define REQUIRE_PLUGIN

#pragma semicolon 1
#pragma newdecls required

#define DEBUG 0
#define PLUGIN_VERSION	"3.5.0a"

public Plugin myinfo = 
{
	name = "Hyper-V HUD Manager",
	author = "Visor, Forgetest",
	description = "Provides different HUDs for spectators",
	version = PLUGIN_VERSION,
	url = "https://github.com/Target5150/MoYu_Server_Stupid_Plugins"
};

// ======================================================================
//  Macros
// ======================================================================
#define SPECHUD_DRAW_INTERVAL   0.5


#define CLAMP(%0,%1,%2) (((%0) > (%2)) ? (%2) : (((%0) < (%1)) ? (%1) : (%0)))
#define MAX(%0,%1) (((%0) > (%1)) ? (%0) : (%1))
#define MIN(%0,%1) (((%0) < (%1)) ? (%0) : (%1))

// ToPercent(int score, int maxbonus) : float
#define ToPercent(%0,%1) ((%0) < 1 ? 0.0 : (100.0 * (%0) / (%1)))

#define TEAM_NONE       0
#define TEAM_SPECTATOR  1
#define TEAM_SURVIVOR   2
#define TEAM_INFECTED   3

// ======================================================================
//  Plugin Vars
// ======================================================================
enum L4D2Gamemode
{
	L4D2Gamemode_None,
	L4D2Gamemode_Coop,
	L4D2Gamemode_Versus,
	L4D2Gamemode_Scavenge
};
L4D2Gamemode g_Gamemode;

enum L4D2SI 
{
	ZC_None,
	ZC_Smoker,
	ZC_Boomer,
	ZC_Hunter,
	ZC_Spitter,
	ZC_Jockey,
	ZC_Charger,
	ZC_Witch,
	ZC_Tank
};
//L4D2SI storedClass[MAXPLAYERS+1];

enum SurvivorCharacter
{
	SC_NONE=-1,
	SC_NICK=0,
	SC_ROCHELLE,
	SC_COACH,
	SC_ELLIS,
	SC_BILL,
	SC_ZOEY,
	SC_LOUIS,
	SC_FRANCIS
};

// Game Var
ConVar survivor_limit, mp_gamemode, sv_maxplayers, pain_pills_decay_rate;
int iSurvivorLimit, iMaxPlayers;
float fPainPillsDecayRate;

// Network Var
ConVar cVarMinUpdateRate, cVarMaxUpdateRate, cVarMinInterpRatio, cVarMaxInterpRatio;
float fMinUpdateRate, fMaxUpdateRate, fMinInterpRatio, fMaxInterpRatio;

// Plugin Cvar
ConVar g_iCoopRoundLiveCount, hServerNamer, l4d_ready_cfg_name;
float g_fTime;

// Plugin Var
char sReadyCfgName[64], sHostname[64];
bool bPendingArrayRefresh = true;
int iSurvivorArray[MAXPLAYERS/2+1];

// Plugin Handle
//ArrayList hSurvivorArray;

// Hud Toggle & Hint Message
bool bSpecHudActive[MAXPLAYERS+1];
bool bSpecHudHintShown[MAXPLAYERS+1];

#if DEBUG
bool bDebugActive[MAXPLAYERS+1];
#endif

/**********************************************************************************************/

// ======================================================================
//  Plugin Start
// ======================================================================
public void OnPluginStart()
{
	(	survivor_limit			= FindConVar("survivor_limit")			).AddChangeHook(OnGameConVarChanged);
	(	mp_gamemode				= FindConVar("mp_gamemode")				).AddChangeHook(OnGameConVarChanged);
	(	sv_maxplayers			= FindConVar("sv_maxplayers")			).AddChangeHook(OnGameConVarChanged);
	(	pain_pills_decay_rate	= FindConVar("pain_pills_decay_rate")	).AddChangeHook(OnGameConVarChanged);

	(	cVarMinUpdateRate		= FindConVar("sv_minupdaterate")			).AddChangeHook(OnNetworkConVarChanged);
	(	cVarMaxUpdateRate		= FindConVar("sv_maxupdaterate")			).AddChangeHook(OnNetworkConVarChanged);
	(	cVarMinInterpRatio		= FindConVar("sv_client_min_interp_ratio")	).AddChangeHook(OnNetworkConVarChanged);
	(	cVarMaxInterpRatio		= FindConVar("sv_client_max_interp_ratio")	).AddChangeHook(OnNetworkConVarChanged);
	
	g_iCoopRoundLiveCount	= CreateConVar("l4d_round_live_count", "1", "Number of rounds the Survivors are live in", FCVAR_NOTIFY|FCVAR_PRINTABLEONLY);

	FillServerNamer();
	FillReadyConfig();
	
	RegConsoleCmd("sm_spechud", ToggleSpecHudCmd);
	
	#if DEBUG
	RegAdminCmd("sm_debugspechud", DebugSpecHudCmd, ADMFLAG_CHEATS);
	#endif
	
	HookEvent("round_end",		view_as<EventHook>(Event_RoundEnd), EventHookMode_PostNoCopy);
	HookEvent("player_death",	Event_PlayerDeath);
	HookEvent("player_team",	Event_PlayerTeam);
	
	GetGameCvars();
	GetNetworkCvars();
	
	for (int i = 1; i <= MaxClients; ++i)
	{
		bSpecHudActive[i] = false;
		bSpecHudHintShown[i] = false;
	}
	
	CreateTimer(SPECHUD_DRAW_INTERVAL, HudDrawTimer, _, TIMER_REPEAT);
}

/**********************************************************************************************/

// ======================================================================
//  ConVar Maintenance
// ======================================================================
void GetGameCvars()
{
	iSurvivorLimit		= survivor_limit.IntValue;
	GetCurrentGameMode();
	iMaxPlayers			= sv_maxplayers.IntValue;
	fPainPillsDecayRate	= pain_pills_decay_rate.FloatValue;
}

void GetNetworkCvars()
{
	fMinUpdateRate	= cVarMinUpdateRate.FloatValue;
	fMaxUpdateRate	= cVarMaxUpdateRate.FloatValue;
	fMinInterpRatio	= cVarMinInterpRatio.FloatValue;
	fMaxInterpRatio	= cVarMaxInterpRatio.FloatValue;
}

void GetCurrentGameMode()
{
	char sGameMode[32];
	GetConVarString(mp_gamemode, sGameMode, sizeof(sGameMode));

	if (strcmp(sGameMode, "coop") == 0)
	{
		g_Gamemode = L4D2Gamemode_Coop;
	}
	else if (strcmp(sGameMode, "scavenge") == 0)
	{
		g_Gamemode = L4D2Gamemode_Scavenge;
	}
	else if (strcmp(sGameMode, "versus") == 0
		|| strcmp(sGameMode, "mutation12") == 0) // realism versus
	{
		g_Gamemode = L4D2Gamemode_Versus;
	}
	else
	{
		g_Gamemode = L4D2Gamemode_None; // Unsupported
	}
}

// ======================================================================
//  Dependency Maintenance
// ======================================================================

void FillServerNamer()
{
	ConVar convar = null;
	if ((convar = FindConVar("sn_main_name")) == null)
		convar = FindConVar("hostname");
	
	if (hServerNamer == null)
	{
		hServerNamer = convar;
	}
	else if (hServerNamer != convar)
	{
		hServerNamer.RemoveChangeHook(OnHostnameChanged);
		delete hServerNamer;
		hServerNamer = view_as<ConVar>(CloneHandle(convar));
	}
	
	hServerNamer.AddChangeHook(OnHostnameChanged);
	hServerNamer.GetString(sHostname, sizeof(sHostname));
	
	delete convar;
}

void FillReadyConfig()
{
	if (l4d_ready_cfg_name != null || (l4d_ready_cfg_name = FindConVar("l4d_ready_cfg_name")) != null)
		l4d_ready_cfg_name.GetString(sReadyCfgName, sizeof(sReadyCfgName));
}

// ======================================================================
//  Dependency Monitor
// ======================================================================
public void OnGameConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetGameCvars();
}

public void OnNetworkConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetNetworkCvars();
}

public void OnHostnameChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	FillServerNamer();
}

public void OnAllPluginsLoaded()
{
	FillServerNamer();
	FillReadyConfig();
}

/**********************************************************************************************/

// ======================================================================
//  Forwards
// ======================================================================
public void OnClientDisconnect(int client)
{
	bSpecHudHintShown[client] = false;
	
	#if DEBUG
	if (bDebugActive[client])
	{
		bDebugActive[client] = false;
	}
	#endif
}

public void OnMapStart()
{
	g_iCoopRoundLiveCount = 1;		//Reset the round live counter on every map start
	SetConVarInt(FindConVar("l4d_round_live_count"), g_iCoopRoundLiveCount);
}

public void OnRoundIsLive()
{
	FillReadyConfig();
	
	bPendingArrayRefresh = true;
	
	GetCurrentGameMode();

	if(FindConVar("l4d_round_live_count") == -1){
		g_iCoopRoundLiveCount = 1;
		SetConVarInt(FindConVar("l4d_round_live_count"), g_iCoopRoundLiveCount);
	}
}

//public void L4D2_OnEndVersusModeRound_Post() { if (!InSecondHalfOfRound()) iFirstHalfScore = L4D_GetTeamScore(GetRealTeam(0) + 1); }

// ======================================================================
//  Events
// ======================================================================
public void Event_RoundEnd(){
	g_iCoopRoundLiveCount++;
	SetConVarInt(FindConVar("l4d_round_live_count"), g_iCoopRoundLiveCount);
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
}

public void Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!client) return;
	
	int team = event.GetInt("team");
	int oldteam = event.GetInt("oldteam");
	
	if (team == TEAM_NONE) // Player disconnecting
	{
		bSpecHudActive[client] = false;
		
		if (oldteam == TEAM_SPECTATOR) return;
	}
	
	bPendingArrayRefresh = true;
	
	//if (team == 3) storedClass[client] = ZC_None;
}

/**********************************************************************************************/

// ======================================================================
//  HUD Command Callbacks
// ======================================================================
public Action ToggleSpecHudCmd(int client, int args) 
{
	bSpecHudActive[client] = !bSpecHudActive[client];
	CPrintToChat(client, "<{olive}HUD{default}> 旁观HUD%s.", (bSpecHudActive[client] ? "{blue}开启{default}" : "{red}关闭{default}"));
}

#if DEBUG
public Action DebugSpecHudCmd(int client, int args)
{
	bDebugActive[client] = !bDebugActive[client];
	CPrintToChat(client, "<{olive}HUD{default}> Spectator HUD debugging is now %s.", (bDebugActive[client] ? "{blue}on{default}" : "{red}off{default}"));
}
#endif

/**********************************************************************************************/

// ======================================================================
//  HUD Handle
// ======================================================================
public Action HudDrawTimer(Handle hTimer)
{
	if (IsInReady())
		return Plugin_Continue;

	bool bSpecsOnServer = false;
	
	for (int i = 1; i <= MaxClients; ++i)
	{
		// 1. Human spectator with spechud active. 
		// 2. SourceTV active.
		if( IsClientInGame(i) && GetClientTeam(i) == TEAM_SPECTATOR && bSpecHudActive[i] )
		{
			bSpecsOnServer = true;
			break;
		}
	}

	if (bSpecsOnServer) // Only bother if someone's watching us
	{
		Panel specHud = new Panel();
		
		if (bPendingArrayRefresh)
		{
			bPendingArrayRefresh = false;
			BuildPlayerArrays();
		}

		FillHeaderInfo(specHud);
		FillTimeInfo(specHud);
		FillSurvivorInfo(specHud);
		//FillGameInfo(specHud);

		#if DEBUG
		for (int i = 1; i <= MaxClients; ++i)
		{
			if (IsClientInGame(i) && bDebugActive[i])
			{
				SendPanelToClient(specHud, i, DummySpecHudHandler, 3);
			}
		}
		#endif
		
		for (int i = 1; i <= MaxClients; ++i)
		{
			// - Client is in game.
			//    1. Client is non-bot and spectator with spechud active.
			//    2. Client is bot as SourceTV.
			if (!IsClientInGame(i) || GetClientTeam(i) != TEAM_SPECTATOR || !bSpecHudActive[i] || (IsFakeClient(i) && !IsClientSourceTV(i)))
				continue;

			if (BuiltinVote_IsVoteInProgress() && IsClientInBuiltinVotePool(i))
				continue;

			SendPanelToClient(specHud, i, DummySpecHudHandler, 3);
			if (!bSpecHudHintShown[i])
			{
				bSpecHudHintShown[i] = true;
				CPrintToChat(i, "<{olive}HUD{default}> 输入{green}!spechud{default}开关{blue}旁观HUD{default}.");
			}
		}
		delete specHud;
	}
	
	
	return Plugin_Continue;
}

public int DummySpecHudHandler(Menu hMenu, MenuAction action, int param1, int param2) {}

/**********************************************************************************************/

// ======================================================================
//  HUD Content
// ======================================================================
void FillHeaderInfo(Panel &hSpecHud)
{
	static int iTickrate = 0;
	if (iTickrate == 0 && IsServerProcessing()) {
		iTickrate = RoundToNearest(1.0 / GetTickInterval());
	}
	
	static char buf[64];
	Format(buf, sizeof(buf), "Server: %s [Slots %i/%i | %iT]", sHostname, GetRealClientCount(), iMaxPlayers, iTickrate);
	DrawPanelText(hSpecHud, buf);
}

void FillTimeInfo(Panel &hSpecHud)
{
	static char buf[64];
	float fTime = GetEngineTime();
	int iPassTime = RoundToFloor(fTime - g_fTime);

	FormatTime(buf, sizeof(buf), "时间: %m/%d/%Y - %I:%M%p");
	Format(buf, sizeof(buf), "%s (%s%d:%s%d)", buf, (iPassTime / 60 < 10) ? "0" : "", iPassTime / 60, (iPassTime % 60 < 10) ? "0" : "", iPassTime % 60);
	DrawPanelText(hSpecHud, buf);
}

void GetMeleePrefix(int client, char[] prefix, int length)
{
	int secondary = GetPlayerWeaponSlot(client, view_as<int>(L4D2WeaponSlot_Secondary));
	WeaponId secondaryWep = IdentifyWeapon(secondary);

	static char buf[4];
	switch (secondaryWep)
	{
		case WEPID_NONE: buf = "N";
		case WEPID_PISTOL: buf = (GetEntProp(secondary, Prop_Send, "m_isDualWielding") ? "DP" : "P");
		case WEPID_PISTOL_MAGNUM: buf = "DE";
		case WEPID_MELEE: buf = "M";
		default: buf = "?";
	}

	strcopy(prefix, length, buf);
}

void GetWeaponInfo(int client, char[] info, int length)
{
	static char buffer[32];
	
	int activeWep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	int primaryWep = GetPlayerWeaponSlot(client, view_as<int>(L4D2WeaponSlot_Primary));
	WeaponId activeWepId = IdentifyWeapon(activeWep);
	WeaponId primaryWepId = IdentifyWeapon(primaryWep);
	
	// Let's begin with what player is holding,
	// but cares only pistols if holding secondary.
	switch (activeWepId)
	{
		case WEPID_PISTOL, WEPID_PISTOL_MAGNUM:
		{
			if (activeWepId == WEPID_PISTOL && !!GetEntProp(activeWep, Prop_Send, "m_isDualWielding"))
			{
				// Dual Pistols Scenario
				// Straight use the prefix since full name is a bit long.
				Format(buffer, sizeof(buffer), "DP");
			}
			else GetLongWeaponName(activeWepId, buffer, sizeof(buffer));
			
			FormatEx(info, length, "%s %i", buffer, GetWeaponClipAmmo(activeWep));
		}
		default:
		{
			GetLongWeaponName(primaryWepId, buffer, sizeof(buffer));
			FormatEx(info, length, "%s %i/%i", buffer, GetWeaponClipAmmo(primaryWep), GetWeaponExtraAmmo(client, primaryWepId));
		}
	}
	
	// Format our result info
	if (primaryWep == -1)
	{
		// In case with no primary,
		// show the melee full name.
		if (activeWepId == WEPID_MELEE || activeWepId == WEPID_CHAINSAW)
		{
			MeleeWeaponId meleeWepId = IdentifyMeleeWeapon(activeWep);
			GetLongMeleeWeaponName(meleeWepId, info, length);
		}
	}
	else
	{
		// Default display -> [Primary <In Detail> | Secondary <Prefix>]
		// Holding melee included in this way
		// i.e. [Chrome 8/56 | M]
		if (GetSlotFromWeaponId(activeWepId) != 1 || activeWepId == WEPID_MELEE || activeWepId == WEPID_CHAINSAW)
		{
			GetMeleePrefix(client, buffer, sizeof(buffer));
			Format(info, length, "%s | %s", info, buffer);
		}

		// Secondary active -> [Secondary <In Detail> | Primary <Ammo Sum>]
		// i.e. [Deagle 8 | Mac 700]
		else
		{
			GetLongWeaponName(primaryWepId, buffer, sizeof(buffer));
			Format(info, length, "%s | %s %i", info, buffer, GetWeaponClipAmmo(primaryWep) + GetWeaponExtraAmmo(client, primaryWepId));
		}
	}
}

void FillSurvivorInfo(Panel &hSpecHud)
{
	static char info[100];
	static char name[MAX_NAME_LENGTH];

	switch (g_Gamemode)
	{
		case L4D2Gamemode_Coop:
		{
			FormatEx(info, sizeof(info), "生还者 [回合 %d]", g_iCoopRoundLiveCount);
		}

		case L4D2Gamemode_Versus:
		{
			FormatEx(info, sizeof(info), "生还者 [回合 %d]", g_iCoopRoundLiveCount);
		}
	}
	
	DrawPanelText(hSpecHud, " ");
	DrawPanelText(hSpecHud, info);
	
	for (int i = 0; i < iSurvivorLimit; ++i)
	{
		int client = iSurvivorArray[i];
		if (!client) continue;
		
		GetClientFixedName(client, name, sizeof(name));
		if (!IsPlayerAlive(client))
		{
			FormatEx(info, sizeof(info), "%s: Dead", name);
		}
		else
		{
			if (IsSurvivorHanging(client))
			{
				// Nick: <300HP@Hanging>
				FormatEx(info, sizeof(info), "%s: <%iHP@Hanging>", name, GetClientHealth(client));
			}
			else if (IsIncapacitated(client))
			{
				int activeWep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
				GetLongWeaponName(IdentifyWeapon(activeWep), info, sizeof(info));
				// Nick: <300HP@1st> [Deagle 8]
				Format(info, sizeof(info), "%s: <%iHP@%s> [%s %i]", name, GetClientHealth(client), (GetSurvivorIncapCount(client) == 1 ? "2nd" :(GetSurvivorIncapCount(client) == 2 ? "B&W" : "1st")), info, GetWeaponClipAmmo(activeWep));
			}
			else
			{
				GetWeaponInfo(client, info, sizeof(info));
				
				int tempHealth = GetSurvivorTemporaryHealth(client);
				int health = GetClientHealth(client) + tempHealth;
				int incapCount = GetSurvivorIncapCount(client);
				if (incapCount == 0)
				{
					// "#" indicates that player is bleeding.
					// Nick: 99HP# [Chrome 8/72]
					Format(info, sizeof(info), "%s: %iHP%s [%s]", name, health, (tempHealth > 0 ? "#" : ""), info);
				}
				else
				{
					// Player ever incapped should always be bleeding.
					// Nick: 99HP (#1st) [Chrome 8/72]
					Format(info, sizeof(info), "%s: %iHP (#%s) [%s]", name, health, (incapCount == 2 ? "2nd" :(incapCount == 3 ? "B&W" : "1st")), info);
				}
			}
		}
		
		DrawPanelText(hSpecHud, info);
	}
}

void FillGameInfo(Panel &hSpecHud)
{
	// Turns out too much info actually CAN be bad, funny ikr
	static char info[64];

	switch (g_Gamemode)
	{
		case L4D2Gamemode_Coop:
		{
			FormatEx(info, sizeof(info), "->2. Config: %s [Round %d]", sReadyCfgName, g_iCoopRoundLiveCount);

			DrawPanelText(hSpecHud, " ");
			DrawPanelText(hSpecHud, info);
		}

		case L4D2Gamemode_Versus:
		{
			FormatEx(info, sizeof(info), "->2. Config: %s [Round: %d]", sReadyCfgName, g_iCoopRoundLiveCount);

			DrawPanelText(hSpecHud, " ");
			DrawPanelText(hSpecHud, info);
		}
	}
}

/**
 *	Stocks
**/

/**
 *	Datamap m_iAmmo
 *	offset to add - gun(s) - control cvar
 *	
 *	+12: M4A1, AK74, Desert Rifle, also SG552 - ammo_assaultrifle_max
 *	+20: both SMGs, also the MP5 - ammo_smg_max
 *	+28: both Pump Shotguns - ammo_shotgun_max
 *	+32: both autoshotguns - ammo_autoshotgun_max
 *	+36: Hunting Rifle - ammo_huntingrifle_max
 *	+40: Military Sniper, AWP, Scout - ammo_sniperrifle_max
 *	+68: Grenade Launcher - ammo_grenadelauncher_max
 */

#define	ASSAULT_RIFLE_OFFSET_IAMMO		12;
#define	SMG_OFFSET_IAMMO				20;
#define	PUMPSHOTGUN_OFFSET_IAMMO		28;
#define	AUTO_SHOTGUN_OFFSET_IAMMO		32;
#define	HUNTING_RIFLE_OFFSET_IAMMO		36;
#define	MILITARY_SNIPER_OFFSET_IAMMO	40;
#define	GRENADE_LAUNCHER_OFFSET_IAMMO	68;

stock int GetWeaponExtraAmmo(int client, WeaponId wepid)
{
	static int ammoOffset;
	if (!ammoOffset) ammoOffset = FindSendPropInfo("CCSPlayer", "m_iAmmo");
	
	int offset;
	switch (wepid)
	{
		case WEPID_RIFLE, WEPID_RIFLE_AK47, WEPID_RIFLE_DESERT, WEPID_RIFLE_SG552:
			offset = ASSAULT_RIFLE_OFFSET_IAMMO
		case WEPID_SMG, WEPID_SMG_SILENCED:
			offset = SMG_OFFSET_IAMMO
		case WEPID_PUMPSHOTGUN, WEPID_SHOTGUN_CHROME:
			offset = PUMPSHOTGUN_OFFSET_IAMMO
		case WEPID_AUTOSHOTGUN, WEPID_SHOTGUN_SPAS:
			offset = AUTO_SHOTGUN_OFFSET_IAMMO
		case WEPID_HUNTING_RIFLE:
			offset = HUNTING_RIFLE_OFFSET_IAMMO
		case WEPID_SNIPER_MILITARY, WEPID_SNIPER_AWP, WEPID_SNIPER_SCOUT:
			offset = MILITARY_SNIPER_OFFSET_IAMMO
		case WEPID_GRENADE_LAUNCHER:
			offset = GRENADE_LAUNCHER_OFFSET_IAMMO
		default:
			return -1;
	}
	return GetEntData(client, ammoOffset + offset);
} 

stock int GetWeaponClipAmmo(int weapon)
{
	return (weapon > 0 ? GetEntProp(weapon, Prop_Send, "m_iClip1") : -1);
}

stock void BuildPlayerArrays()
{
	int survivorCount = 0;
	for (int client = 1; client <= MaxClients; ++client) 
	{
		if (!IsClientInGame(client)) continue;
		
		if (GetClientTeam(client) == TEAM_SURVIVOR)
				if (survivorCount < iSurvivorLimit)
					iSurvivorArray[survivorCount++] = client;
	}
	
	iSurvivorArray[survivorCount] = 0;
	
	SortCustom1D(iSurvivorArray, survivorCount, SortSurvArray);
}

public int SortSurvArray(int elem1, int elem2, const int[] array, Handle hndl)
{
	SurvivorCharacter sc1 = GetFixedSurvivorCharacter(elem1);
	SurvivorCharacter sc2 = GetFixedSurvivorCharacter(elem2);
	
	if (sc1 > sc2) { return 1; }
	else if (sc1 < sc2) { return -1; }
	else { return 0; }
}

stock SurvivorCharacter GetFixedSurvivorCharacter(int client)
{
	int sc = GetEntProp(client, Prop_Send, "m_survivorCharacter");
	
	switch (sc)
	{
		case 6:						// Francis' netprop is 6
			return SC_FRANCIS;		// but here to match the official serial
			
		case 7:						// Louis' netprop is 7
			return SC_LOUIS;		// but here to match the official serial
			
		case 9, 11:					// Bill's alternative netprop
			return SC_BILL;			// match it correctly
	}
	return view_as<SurvivorCharacter>(sc);
}

stock float GetLerpTime(int client)
{
	static char value[16];
	
	if (!GetClientInfo(client, "cl_updaterate", value, sizeof(value))) value = "";
	int updateRate = StringToInt(value);
	updateRate = RoundFloat(CLAMP(float(updateRate), fMinUpdateRate, fMaxUpdateRate));
	
	if (!GetClientInfo(client, "cl_interp_ratio", value, sizeof(value))) value = "";
	float flLerpRatio = StringToFloat(value);
	
	if (!GetClientInfo(client, "cl_interp", value, sizeof(value))) value = "";
	float flLerpAmount = StringToFloat(value);
	
	if (cVarMinInterpRatio != null && cVarMaxInterpRatio != null && fMinInterpRatio != -1.0 ) {
		flLerpRatio = CLAMP(flLerpRatio, fMinInterpRatio, fMaxInterpRatio );
	}
	
	return MAX(flLerpAmount, flLerpRatio / updateRate);
}

stock void GetClientFixedName(int client, char[] name, int length)
{
	GetClientName(client, name, length);

	if (name[0] == '[')
	{
		char temp[MAX_NAME_LENGTH];
		strcopy(temp, sizeof(temp), name);
		temp[sizeof(temp)-2] = 0;
		strcopy(name[1], length-1, temp);
		name[0] = ' ';
	}

	if (strlen(name) > 18)
	{
		name[15] = name[16] = name[17] = '.';
		name[18] = 0;
	}
}

//stock int GetRealTeam(int team)
//{
//	return team ^ view_as<int>(!!InSecondHalfOfRound() != L4D2_AreTeamsFlipped());
//}

stock int GetRealClientCount() 
{
	int clients = 0;
	for (int i = 1; i <= MaxClients; ++i) 
	{
		if (IsClientConnected(i) && !IsFakeClient(i)) clients++;
	}
	return clients;
}

stock int GetFurthestSurvivorFlow()
{
	int flow = RoundToNearest(100.0 * (L4D2_GetFurthestSurvivorFlow() + fVersusBossBuffer) / L4D2Direct_GetMapMaxFlowDistance());
	return MIN(flow, 100);
}

//stock float GetClientFlow(int client)
//{
//	return (L4D2Direct_GetFlowDistance(client) / L4D2Direct_GetMapMaxFlowDistance());
//}

stock int GetHighestSurvivorFlow()
{
	int flow = -1;
	
	int client = L4D_GetHighestFlowSurvivor();
	if (client > 0) {
		flow = RoundToNearest(100.0 * (L4D2Direct_GetFlowDistance(client) + fVersusBossBuffer) / L4D2Direct_GetMapMaxFlowDistance());
	}
	
	return MIN(flow, 100);
}

//bool IsSpectator(int client)
//{
//	return IsClientInGame(client) && GetClientTeam(client) == TEAM_SPECTATOR;
//}

stock bool IsSurvivor(int client)
{
	return IsClientInGame(client) && GetClientTeam(client) == TEAM_SURVIVOR;
}

stock bool IsIncapacitated(int client)
{
	return !!GetEntProp(client, Prop_Send, "m_isIncapacitated");
}

stock bool IsSurvivorHanging(int client)
{
	return !!(GetEntProp(client, Prop_Send, "m_isHangingFromLedge") | GetEntProp(client, Prop_Send, "m_isFallingFromLedge"));
}

stock int GetSurvivorIncapCount(int client)
{
	return GetEntProp(client, Prop_Send, "m_currentReviveCount");
}

stock int GetSurvivorTemporaryHealth(int client)
{
	int temphp = RoundToCeil(GetEntPropFloat(client, Prop_Send, "m_healthBuffer") - ((GetGameTime() - GetEntPropFloat(client, Prop_Send, "m_healthBufferTime")) * fPainPillsDecayRate)) - 1;
	return (temphp > 0 ? temphp : 0);
}