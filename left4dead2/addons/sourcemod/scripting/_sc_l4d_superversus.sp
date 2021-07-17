#include <sourcemod>
#include <sdktools>

#pragma semicolon 1; // Force strict semicolon mode.
#pragma newdecls required; 

// l4dt forward (to add more SI bots)
forward Action L4D_OnGetScriptValueInt(const char[] key, int &retVal);

// *********************************************************************************
// CONSTANTS
// *********************************************************************************
#define PLUGIN_VERSION		       "2.5"
#define CVAR_FLAGS			FCVAR_NOTIFY
#define TEAM_SPECTATOR	               1
#define TEAM_SURVIVOR	               2
#define TEAM_INFECTED	               3
#define DELAY_KICK_NONEEDBOT         0.7
#define DELAY_KICK_FAKECLIENT        0.1
#define ZC_ZOMBIE                      0
#define ZC_SMOKER                      1
#define ZC_BOOMER                      2
#define ZC_HUNTER                      3
#define ZC_SPITTER                     4
#define ZC_JOCKEY                      5
#define ZC_CHARGER                     6
#define ZC_WITCH                       7
#define ZC_TANK                        8

char gameMode[16];
char gameName[16];

ConVar SurvivorLimit;

ConVar L4DSurvivorLimit;
ConVar AfkTimeout;
ConVar GameType;
ConVar SurvMaxIncap;
ConVar PainPillsDR;

ConVar RespawnJoin;
ConVar AfkMode;
ConVar AutoJoin;
ConVar Management;
ConVar cvar_minsurvivor;

Handle SubDirector					= null;
Handle BotsUpdateTimer				= null;
Handle TeamPanelTimer[MAXPLAYERS+1];
Handle AfkTimer[MAXPLAYERS+1];

bool RoundStarted = false;

bool  CheckIdle[MAXPLAYERS+1];
int   iButtons[MAXPLAYERS+1];
float fEyeAngles[MAXPLAYERS+1][3];

StringMap SteamIDs;

public Plugin myinfo =
{
	name        = "Super Versus Reloaded",
	author      = "DDRKhat, Marcus101RR, Merudo, Foxhound27, Senip, RainyDagger, Shao",
	description = "Allows up to 32 players on Left 4 Dead.",
	version     = PLUGIN_VERSION,
	url         = "https://forums.alliedmods.net/showthread.php?p=2704058#post2704058"
}

// *********************************************************************************
// METHODS FOR GAME START & END
// *********************************************************************************
public void OnPluginStart()
{
	GetGameFolderName(gameName, sizeof(gameName));

	CreateConVar("sm_superversus_version", PLUGIN_VERSION, "L4D Super Versus", CVAR_FLAGS|FCVAR_DONTRECORD);

	L4DSurvivorLimit = FindConVar("survivor_limit");
	SurvivorLimit = CreateConVar("l4d_survivor_limit", "8", "Maximum amount of survivors", CVAR_FLAGS,true, 1.00, true, 24.00);
	cvar_minsurvivor = CreateConVar("l4d_static_minimum_survivor", "8", "Static minimum amount of team survivor", CVAR_FLAGS, true, 4.00, true, 24.00);

	// Remove limits for survivor/infected
	SetConVarBounds(L4DSurvivorLimit, ConVarBound_Upper, true, 24.0);
	HookConVarChange(SurvivorLimit, OnSurvivorChanged);	HookConVarChange(L4DSurvivorLimit, OnSurvivorChanged);

	RespawnJoin = CreateConVar("l4d_respawn_on_join", "0" , "Respawn alive when joining as an extra survivor? 0: No, 1: Yes (first time only)", CVAR_FLAGS, true, 0.0, true, 1.0);
	AfkMode =  CreateConVar("l4d_versus_afk", "1" , "If player is afk on versus, 0: Do nothing, 1: Become idle, 2: Become spectator, 3: Kicked", CVAR_FLAGS, true, 0.0, true, 3.0);
	AutoJoin = CreateConVar("l4d_autojoin", "2" , "Once a player connects, 3: Put them in Spectate. 2: In Co-op will put them on Survivor team, In Versus, will put them on a random team. 1: Show teammenu, 0: Do nothing", CVAR_FLAGS, true, 0.0, true, 3.0);
	Management = CreateConVar("l4d_management", "3", "3: Enable teammenu & commands, 2: commands only, 1: !infected,!survivor,!join only, 0: Nothing", CVAR_FLAGS, true, 0.0, true, 4.0);

	//Cache CVArs
	AfkTimeout = FindConVar("director_afk_timeout");
	GameType = FindConVar("mp_gamemode");
	SurvMaxIncap = FindConVar("survivor_max_incapacitated_count");
	PainPillsDR = FindConVar("pain_pills_decay_rate");

	RegConsoleCmd("sm_join", Join_Game, "Join Survivor or Infected team");
	RegConsoleCmd("sm_survivor", Join_Survivor, "Join Survivor Team");
	RegConsoleCmd("sm_spectate", Join_Spectator, "Join Spectator Team");
	RegConsoleCmd("sm_afk", GO_AFK, "Go Idle (Survivor) or Join Spectator Team (Infected)");
	RegConsoleCmd("sm_teams", TeamMenu, "Opens Team Panel with Selection");
	RegConsoleCmd("sm_changeteam", TeamMenu, "Opens Team Panel with Selection");
	RegAdminCmd("sm_createplayer", Create_Player, ADMFLAG_CONVARS, "Create Survivor Bot");

	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("player_bot_replace", Event_BotReplacedPlayer);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("player_afk", Event_PlayerWentAFK, EventHookMode_Pre);
	HookEvent("round_start", Event_RoundStart, EventHookMode_Post);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	HookEvent("finale_vehicle_leaving", Event_FinaleVehicleLeaving);

	AddCommandListener(Cmd_spec_next, "spec_next");
	
	SteamIDs = new StringMap();

	AutoExecConfig(true, "l4d_superversus");
}

public void OnSurvivorChanged (Handle c, const char[] o, const char[] n)  {L4DSurvivorLimit.IntValue = SurvivorLimit.IntValue;}

public void OnMapStart() 
{
	GameType.GetString(gameMode, sizeof(gameMode));
}

// ------------------------------------------------------------------------
// OnMapEnd()
// ------------------------------------------------------------------------
public void OnMapEnd()
{
	GameEnd();
}

public void Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	GameEnd();
}

// ------------------------------------------------------------------------
//  Clean up the timers at the game end
// ------------------------------------------------------------------------
void GameEnd()
{
	delete SubDirector;
	delete BotsUpdateTimer;
	
	for(int i = 1; i <= MaxClients; i++)
	{
		delete TeamPanelTimer[i];
		delete AfkTimer[i];
		TakeOver(i);
	}

	// Reset SteamIDs, so previous players who join next round can respawn alive
	SteamIDs.Clear();
	
	RoundStarted = false;
}

// ------------------------------------------------------------------------
// Event_RoundStart
// ------------------------------------------------------------------------
public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	RoundStarted = true;
}

// ------------------------------------------------------------------------
// FinaleEnd() Thanks to Damizean for smarter method of detecting safe survivors.
// ------------------------------------------------------------------------
public void Event_FinaleVehicleLeaving(Event event, const char[] name, bool dontBroadcast)
{
	int edict_index = FindEntityByClassname(-1, "info_survivor_position");
	if (edict_index != -1)
	{
		float pos[3];
		GetEntPropVector(edict_index, Prop_Send, "m_vecOrigin", pos);
		for(int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientConnected(i)) continue;
			if (!IsClientInGame(i)) continue;
			if (GetClientTeam(i) != TEAM_SURVIVOR) continue;
			if (!IsPlayerAlive(i)) continue;
			if (GetEntProp(i, Prop_Send, "m_isIncapacitated", 1) == 1) continue;
			TeleportEntity(i, pos, NULL_VECTOR, NULL_VECTOR);
		}
	}
}

// *********************************************************************************
// METHODS RELATED TO PLAYER/BOT SPAWN AND KICK
// *********************************************************************************

// ------------------------------------------------------------------------
//  Each time a survivor spawns, setup timer to kick / spawn bots a bit later
// ------------------------------------------------------------------------
public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	// Each time a new survivor spawns, check difficulty & record steam id (to prevent free respawning)
	if (GetClientTeam(client) == TEAM_SURVIVOR)
	{
		// Reset the bot check timer, if one exists	
		delete BotsUpdateTimer;
		BotsUpdateTimer = CreateTimer(2.0, Timer_BotsUpdate);
		
		if (!IsFakeClient(client) && IsFirstTime(client))
			RecordSteamID(client); // Record SteamID of player.
	}
}

public int GetClientZC(int client)
{

	if (!IsValidEntity(client) || !IsValidEdict(client))
	{
		return 0;
	}
	return GetEntProp(client, Prop_Send, "m_zombieClass");
}

////////////////////////////////////////////////////////////////////


// ------------------------------------------------------------------------
// If player disconnect, set timer to spawn/kick bots as needed. Manages difficulty on survivor bot disconnect.
// ------------------------------------------------------------------------
public void OnClientDisconnect(int client)
{
	delete AfkTimer[client];				//	Clean up Afk timer
	delete TeamPanelTimer[client];			//	Clean up Panel timer
	CheckIdle[client] = false;				//  Turn off idle check

	if(RoundStarted)			// if not bot or during transition
	{
		// Reset the timer, if one exists
		delete BotsUpdateTimer;
		BotsUpdateTimer = CreateTimer(1.0, Timer_BotsUpdate);	// re-update the bots
	}
}

// ------------------------------------------------------------------------
// Bots are kicked/spawned after every survivor spawned and every player joined
// ------------------------------------------------------------------------
public Action Timer_BotsUpdate(Handle hTimer)
{
	BotsUpdateTimer = null;

	if (AreAllInGame() == true)
	{

		SpawnCheck();
	}
	else
	{
		BotsUpdateTimer = CreateTimer(1.0, Timer_BotsUpdate); // if not everyone joined, delay update
	}
}

// ------------------------------------------------------------------------
// Check the # of survivors, and kick/spawn bots as needed
// ------------------------------------------------------------------------
void SpawnCheck()
{
	if(RoundStarted != true)  return;      // if during transition, don't do anything
	
	int iSurvivor       = GetSurvivorTeam();
	//int iHumanSurvivor  = InfectedAllowed ? GetTeamPlayers(TEAM_SURVIVOR, false) : GetHumanCount();  // survivors excluding bots but including idles. If coop, counts spectators too (may be idles)
	//int iSurvivorLim    = SurvivorLimit.IntValue;
	//int iSurvivorMax    = iHumanSurvivor  >  iSurvivorLim ? iHumanSurvivor  : iSurvivorLim ;
	
	// iSurvivorMax is the maximum # of survivor we allow - we never kick human survivors

	if (iSurvivor >= cvar_minsurvivor.IntValue)  return;
	for(; iSurvivor < cvar_minsurvivor.IntValue; iSurvivor++) SpawnFakeSurvivorClient();
}

// ------------------------------------------------------------------------
// Kick an unused survivor bot
// ------------------------------------------------------------------------
stock bool IsValidSurvivorBot(int client)
{
	if (!client) return false;
	if (!IsClientInGame(client)) return false;
	if (!IsFakeClient(client)) return false;
	if (GetClientTeam(client) != TEAM_SURVIVOR) return false;
	return true;
}

// ------------------------------------------------------------------------
// Spawn a survivor bot
// ------------------------------------------------------------------------
bool SpawnFakeSurvivorClient()
{
	int ClientsCount = GetSurvivorTeam();
	
	bool fakeclientKicked = false;
	
	// create fakeclient
	int fakeclient = 0;

	if (ClientsCount < SurvivorLimit.IntValue)
	{
		fakeclient = CreateFakeClient("SurvivorBot");
	}
	
	// if entity is valid
	if (fakeclient != 0)
	{
		// move into survivor team
		ChangeClientTeam(fakeclient, TEAM_SURVIVOR);
		
		// check if entity classname is survivorbot
		if (DispatchKeyValue(fakeclient, "classname", "survivorbot") == true)
		{
			// spawn the client
			if (DispatchSpawn(fakeclient) == true)
			{	
				// kick the fake client to make the bot take over
				CreateTimer(DELAY_KICK_FAKECLIENT, Timer_KickFakeBot, fakeclient, TIMER_REPEAT);
				fakeclientKicked = true;
			}
		}			
		// if something went wrong, kick the created FakeClient
		if (fakeclientKicked == false) KickClient(fakeclient, "Kicking FakeClient");
	}
	return fakeclientKicked;
}

// ------------------------------------------------------------------------
// Autojoin survivors if coop & spectator
// ------------------------------------------------------------------------
public void OnClientPostAdminCheck(int client)
{
	if (IsFakeClient(client)) return;
	
	if (GetClientTeam(client) <= TEAM_SPECTATOR) // Sets on a random team in versus if lobby is 8+ player. l4d_autojoin 2 required.
	{
		CreateTimer(5.0, Timer_AutoJoinTeam, GetClientUserId(client));
	}
	if (GetClientTeam(client) == TEAM_SURVIVOR ) // Sets on survivor team in coop regardless of the character without creating an extra survivor that could be dead on connection. l4d_autojoin 2 required.
	{
		CreateTimer(0.5, Timer_AutoJoinTeam, GetClientUserId(client));
	}
	delete AfkTimer[client];
}

// ------------------------------------------------------------------------
// If connect as spectator, either auto-join survivor or show team menu
// ------------------------------------------------------------------------
public Action Timer_AutoJoinTeam(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);

	// If joined the game already or not valid, don't do anything
	if (!client || !IsClientInGame(client) || IsFakeClient(client) || GetBotOfIdle(client)) return;
	
	if (BotsUpdateTimer != null || !RoundStarted || !AreAllInGame() || GetClientTeam(client) == 0)
	{
		CreateTimer(1.0, Timer_AutoJoinTeam, GetClientUserId(client)); // if during transition, delay autojoin
	}
	else
	{
		if(AutoJoin.IntValue > 0)
		{
			if(AutoJoin.IntValue == 3) FakeClientCommand(client, "sm_spectate");  // Autojoin Spectate
			else if(AutoJoin.IntValue == 2) FakeClientCommand(client, "sm_survivor"); // Autojoin Survivor
			else if(AutoJoin.IntValue == 2) FakeClientCommand(client, "sm_join"); // Autojoin random team
			else if(AutoJoin.IntValue == 1) FakeClientCommand(client, "sm_teams"); // Show team selection menu
		}
	}
}

// *********************************************************************************
// IDLE FIX
// *********************************************************************************

// ------------------------------------------------------------------------
// If player goes AFK, activate idle bug check
// ------------------------------------------------------------------------
public Action Event_PlayerWentAFK(Event event, const char[] name, bool dontBroadcast)
{
	// Event is triggered when a player goes AFK
	int client = GetClientOfUserId(event.GetInt("player"));
	CheckIdle[client] = true;
}

// ------------------------------------------------------------------------
// When survivor bot replace player AND player went afk, trigger fix
// ------------------------------------------------------------------------
public Action Event_BotReplacedPlayer(Event event, const char[] name, bool dontBroadcast)
{
	// Event is triggered when a bot takes over a player
	int player	= GetClientOfUserId(event.GetInt("player"));
	int bot		= GetClientOfUserId(event.GetInt("bot"));

	if (GetClientTeam(bot) == TEAM_SURVIVOR) CreateTimer(DELAY_KICK_NONEEDBOT, Timer_KickNoNeededBot, bot);
	
	if (IsFakeClient(player)) return; 		// if "player" is a bot, don't do anything (side effect of creating new bots)

	// Create a datapack as we are moving 2+ pieces of data through a timer
	if(player > 0 && IsClientInGame(player) && GetClientTeam(bot)==TEAM_SURVIVOR) 
	{
		Handle datapack = CreateDataPack();
		WritePackCell(datapack, player);
		WritePackCell(datapack, bot);
		CreateTimer(0.2, Timer_ActivateFix, datapack, TIMER_FLAG_NO_MAPCHANGE);
	}
}

// ------------------------------------------------------------------------
// Fix the idle bug by setting pseudo idle mode
// ------------------------------------------------------------------------
public Action Timer_ActivateFix(Handle Timer, any datapack)
{
	// Reset the data pack
	ResetPack(datapack);

	// Retrieve values from datapack
	int player = ReadPackCell(datapack);
	int bot = ReadPackCell(datapack);

	// If  player left game, is not spectator, or is correctly idle, skip the fix
	// If  bot is occupied (should not happen unless something happened in .2 sec) , try to get another
	
	if (!IsClientInGame(player) || GetClientTeam(player) != TEAM_SPECTATOR || GetBotOfIdle(player) ||  IsFakeClient(player)) CheckIdle[player] = false;	
	if (!IsBotValid(bot) || GetClientTeam(bot) != TEAM_SURVIVOR) bot = GetAnyValidSurvivorBot(); if (bot < 1) CheckIdle[player] = false; 

	// If the player went AFK and failed, continue on
	if(CheckIdle[player])
	{
		CheckIdle[player] = false;
		SetHumanIdle(bot, player);
	}
}

// ------------------------------------------------------------------------
// When player dies, forces takeover of the bot
// ------------------------------------------------------------------------
public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	// Event is triggered when a player dies
	int client = GetClientOfUserId(event.GetInt("userid"));
	TakeOver(client);
}

void TakeOver(int bot)
{
	if(bot > 0 && IsClientInGame(bot) &&  IsFakeClient(bot) && GetClientTeam(bot) == TEAM_SURVIVOR && GetIdlePlayer(bot))
	{
		int idleplayer = GetIdlePlayer(bot);
		SetHumanIdle(bot, idleplayer);
		TakeOverBot(idleplayer);		
	}
}

// ------------------------------------------------------------------------
// Store vision angle & button, if changed reset afk timer
// ------------------------------------------------------------------------
public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (IsFakeClient(client)) return;

	if (AfkMode.BoolValue && GetClientTeam(client) > TEAM_SPECTATOR && IsPlayerAlive(client) && RoundStarted)
	{	
		if ( (iButtons[client] != buttons) ||  (FloatAbs(angles[0] - fEyeAngles[client][0]) > 2.0) || (FloatAbs(angles[1] - fEyeAngles[client][1]) > 2.0) || (FloatAbs(angles[2] - fEyeAngles[client][2]) > 2.0) ) 
		{
			delete AfkTimer[client];  // Reset timer
		}
		if (AfkTimer[client] == null) AfkTimer[client] = CreateTimer(AfkTimeout.FloatValue, Timer_AFK, client); 
		
		iButtons[client]   = buttons;
		fEyeAngles[client] = angles; 
	} else delete AfkTimer[client];
}

// ------------------------------------------------------------------------
// Reset timer if client say something in chat
// ------------------------------------------------------------------------
public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs) // Player Chat
{
	if (!client || IsFakeClient(client)) return;
	
	delete AfkTimer[client];	
	
	if (AfkMode.BoolValue && GetClientTeam(client) > TEAM_SPECTATOR && IsPlayerAlive(client) && RoundStarted)
	{
		AfkTimer[client] = CreateTimer(AfkTimeout.FloatValue, Timer_AFK, client);
	}
}

// ------------------------------------------------------------------------
// If afk timer ran out, deal with afk client
// ------------------------------------------------------------------------
public Action Timer_AFK(Handle Timer, int client)
{
	AfkTimer[client] = null;

	if (IsClientInGame(client) && AfkMode.BoolValue && GetClientTeam(client) > TEAM_SPECTATOR && IsPlayerAlive(client) && RoundStarted)
	{
		if ( GetTeamPlayers(GetClientTeam(client), false) > 0) // if more than 1 human player on the team
		{
			if (AfkMode.IntValue == 1) FakeClientCommand(client, "sm_afk");
			if (AfkMode.IntValue == 2) FakeClientCommand(client, "sm_spectate");
			if (AfkMode.IntValue == 3) KickClient(client, "Afk");
		}
	}
}

// *********************************************************************************
// COMMANDS FOR JOINING TEAMS
// *********************************************************************************

// ------------------------------------------------------------------------
// If press left mouse button as spectator, show menu to join game. Useful in case of idle bug
// ------------------------------------------------------------------------
public Action Cmd_spec_next(int client, char[] command, int argc)
{
	if (client > 0 && IsClientInGame(client) && GetClientTeam(client) == TEAM_SPECTATOR && !GetBotOfIdle(client))
	{
		FakeClientCommand(client, "sm_teams");
	}
	return Plugin_Continue;	
}

// ------------------------------------------------------------------------
// Join survivor or infected
// ------------------------------------------------------------------------
public Action Join_Game(int client, int args)
{
	if (!Management.BoolValue) return Plugin_Continue;

	if (GetBotOfIdle(client) || GetClientTeam(client) == TEAM_SURVIVOR) FakeClientCommand(client,"sm_survivor"); 
	else
	{
		PrintToChat(client, "Both teams are full.");
	}
	return Plugin_Handled;
}

public Action Join_Spectator(int client, int args)
{
	if (Management.IntValue < 2) return Plugin_Continue;

	ChangeClientTeam(client,TEAM_SPECTATOR);
	return Plugin_Handled;
}

public Action Join_Survivor(int client, int args) {

	if (CountAvailableBots(TEAM_SURVIVOR) == 0) {
		Create_Player(client, 0);
		Join_Survivor2(client, 0);
	} else if (CountAvailableBots(TEAM_SURVIVOR) > 0) {

		Join_Survivor2(client, 0);

	}

}

public Action Join_Survivor2(int client, int args)
{
	if (!Management.BoolValue) return Plugin_Continue;

	if(!IsClientInGame(client)) return Plugin_Handled;
	
	if(GetClientTeam(client) != TEAM_SURVIVOR && !GetBotOfIdle(client))
	{
		if(CountAvailableBots(TEAM_SURVIVOR) == 0)
		{
			bool canRespawn = (RespawnJoin.BoolValue && IsFirstTime(client)) ;
			
			ChangeClientTeam(client, TEAM_SURVIVOR);  // Add extra survivor. Triggers player_spawn, which makes IsFirstTime false
			
			if (!IsPlayerAlive(client) && !GetBotOfIdle(client) && canRespawn)
			{
				Respawn(client);
				TeleportToSurvivor(client);
				SetGodMode(client, 1.0); // 1 sec of god mode after spawning
				
				GiveAverageWeapon(client);				
			} else if (!IsPlayerAlive(client) && !GetBotOfIdle(client) && RespawnJoin.BoolValue)
			{
				PrintToChat(client, "\x03[SV] \x01You already played on the \x04Survivor Team\x01 this round. You will spawn dead.");
			}
		}
		else
		{
			FakeClientCommand(client,"jointeam 2");
		}
	}
	
	if(GetBotOfIdle(client))  TakeOver(GetBotOfIdle(client));
	
	if(GetClientTeam(client) == TEAM_SURVIVOR)
	{		
		if(IsPlayerAlive(client) == true)
		{
			PrintToChat(client, "\x03[SV] \x01You are on the \x04Survivor Team\x01.");
		}
		else if(IsPlayerAlive(client) == false && CountAvailableBots(TEAM_SURVIVOR) != 0)  // Takeover a bot
		{
			ChangeClientTeam(client, TEAM_SPECTATOR);
			FakeClientCommand(client,"jointeam 2");
		}
		else if(IsPlayerAlive(client) == false && CountAvailableBots(TEAM_SURVIVOR) == 0)
		{
			PrintToChat(client, "\x03[SV] \x01You are \x04Dead\x01. No \x05Bot(s) \x01Available.");
		}
	}
	return Plugin_Handled;
}

public Action GO_AFK(int client, int args) {
	if (Management.IntValue < 2) return Plugin_Continue;

	if (GetClientTeam(client) == TEAM_SURVIVOR) // Infected can't go idle, they spectate instead
	{
		CheckIdle[client] = true; // Check for fix
		FakeClientCommand(client, "go_away_from_keyboard");
	}
	if (GetClientTeam(client) != TEAM_SPECTATOR) FakeClientCommand(client, "sm_spectate");
	return Plugin_Handled;
}

// ------------------------------------------------------------------------
// Create a bot. Useful if less bots than SurvivorLimit because the later got increased
// ------------------------------------------------------------------------
public Action Create_Player(int client, int args) {

	bool fakeclientKicked = false;

	int ClientsCount = GetSurvivorTeam();

	if (Management.IntValue < 2) return Plugin_Continue;

	char arg[MAX_NAME_LENGTH];
	if (args > 0) {
		GetCmdArg(1, arg, sizeof(arg));
		PrintToChatAll("\x03[SV] \x01Player %s has joined the game", arg);
		CreateFakeClient(arg);
	}
	else {
		// create fakeclient
		int Bot = 0;

		if (ClientsCount < SurvivorLimit.IntValue) {
			Bot = CreateFakeClient("SurvivorBot");
		}

		if (Bot == 0) return Plugin_Handled;

		ChangeClientTeam(Bot, TEAM_SURVIVOR);
		if (!DispatchKeyValue(Bot, "classname", "survivorbot")) return Plugin_Handled;

		if (!DispatchSpawn(Bot)) return Plugin_Handled; // if dispatch failed		

		if (!IsPlayerAlive(Bot)) Respawn(Bot);

		// check if entity classname is survivorbot
		if (DispatchKeyValue(Bot, "classname", "survivorbot") == true) {
			// spawn the client
			if (DispatchSpawn(Bot) == true) {
				// teleport client to the position of any active alive player
				TeleportToSurvivor(Bot);
				GiveAverageWeapon(Bot);
				// kick the fake client to make the bot take over
				CreateTimer(DELAY_KICK_FAKECLIENT, Timer_KickFakeBot, Bot, TIMER_REPEAT);
				fakeclientKicked = true;
			}
		}
		// if something went wrong, kick the created FakeClient
		if (fakeclientKicked == false) KickClient(Bot, "Kicking FakeClient");

	}
	return Plugin_Handled;
}

public Action Timer_KickFakeBot(Handle timer, any Bot)
{
	if (IsClientConnected(Bot))
	{
		KickClient(Bot, "Kicking FakeClient");		
		return Plugin_Stop;
	}	
	return Plugin_Continue;
}

public Action TeamMenu(int client, int args)
{
	if (Management.IntValue < 3) return Plugin_Continue;

	if(TeamPanelTimer[client] == null)
	{
		DisplayTeamMenu(client);
	}
	return Plugin_Handled;
}

// ------------------------------------------------------------------------
// Returns true if all connected players are in the game
// ------------------------------------------------------------------------
bool AreAllInGame()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientConnected(i) && !IsFakeClient(i))
		{
			if (!IsClientInGame(i)) return false;
		}
	}
	return true;
}

// ------------------------------------------------------------------------
// Returns true if client never spawned as survivor this game. Used to allow 1 free spawn
// ------------------------------------------------------------------------
bool IsFirstTime(int client)
{
	if(!IsClientInGame(client) || IsFakeClient(client)) return false;
	
	char SteamID[64];
	bool valid = GetClientAuthId(client, AuthId_Steam2, SteamID, sizeof(SteamID));		
	
	if (valid == false) return false;

	bool Allowed;
	if (!SteamIDs.GetValue(SteamID, Allowed))  // If can't find the entry in map
	{
		SteamIDs.SetValue(SteamID, true, true);
		Allowed = true;
	}
	return Allowed;
}

// ------------------------------------------------------------------------
// Stores the Steam ID, so if reconnect we don't allow free respawn
// ------------------------------------------------------------------------
void RecordSteamID(int client)
{
	// Stores the Steam ID, so if reconnect we don't allow free respawn
	char SteamID[64];
	bool valid = GetClientAuthId(client, AuthId_Steam2, SteamID, sizeof(SteamID));
	if (valid) SteamIDs.SetValue(SteamID, false, true);
}

// ------------------------------------------------------------------------
// Returns the idle player of the bot, returns 0 if none
// ------------------------------------------------------------------------
int GetIdlePlayer(int bot)
{
	if(IsClientInGame(bot) && GetClientTeam(bot) == TEAM_SURVIVOR && IsPlayerAlive(bot) && IsFakeClient(bot))
	{
		char sNetClass[12];
		GetEntityNetClass(bot, sNetClass, sizeof(sNetClass));

		if(strcmp(sNetClass, "SurvivorBot") == 0)
		{
			int client = GetClientOfUserId(GetEntProp(bot, Prop_Send, "m_humanSpectatorUserID"));			
			if(client > 0 && IsClientInGame(client) && GetClientTeam(client) == TEAM_SPECTATOR)
			{
				return client;
			}
		}
	}
	return 0;
}

// ------------------------------------------------------------------------
// Returns the bot of the idle client, returns 0 if none 
// ------------------------------------------------------------------------
int GetBotOfIdle(int client)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if (GetIdlePlayer(i) == client) return i;
	}
	return 0;
}

// ------------------------------------------------------------------------
// Get the number of players on the team (includes idles)
// includeBots == true : counts bots
// ------------------------------------------------------------------------
int GetTeamPlayers(int team, bool includeBots)
{
	int players = 0;
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && GetClientTeam(i) == team)
		{
			if(IsFakeClient(i) && !includeBots && !GetIdlePlayer(i))
				continue;
			players++;
		}
	}
	return players;
}

// ------------------------------------------------------------------------
// Get the number of survivors on the team, including bots
// ------------------------------------------------------------------------
int GetSurvivorTeam()
{
	return GetTeamPlayers(TEAM_SURVIVOR, true);
}

// ------------------------------------------------------------------------
// Is the bot valid? (either survivor or infected)
// ------------------------------------------------------------------------
bool IsBotValid(int client)
{
	if(client > 0 && IsClientInGame(client) && IsFakeClient(client) && !GetIdlePlayer(client) && !IsClientInKickQueue(client))
		return true;
	return false;
}

// ------------------------------------------------------------------------
// Get any valid survivor bot (may be dead). Last bot created is found first
// ------------------------------------------------------------------------
int GetAnyValidSurvivorBot()
{
	for(int i = MaxClients ; i >= 1; i--)  // kick bots in reverse order they have been spawned
	{
		if (IsBotValid(i) && GetClientTeam(i) == TEAM_SURVIVOR)
			return i;
	}
	return -1;
}

// ------------------------------------------------------------------------
// Check if how many alive bots without an idle are available in a team
// ------------------------------------------------------------------------
int CountAvailableBots(int team)
{
	int num = 0;
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsBotValid(i) && GetClientTeam(i) == team && IsPlayerAlive(i))
					num++;
	}
	return num;
}

// ------------------------------------------------------------------------
// Check if how many bots are in a team without idle. Can be dead
// ------------------------------------------------------------------------
stock int CountBots(int team)
{
	int num = 0;
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsBotValid(i) && GetClientTeam(i) == team)
					num++;
	}
	return num;
}

// *********************************************************************************
// TEAM MENU
// *********************************************************************************
void DisplayTeamMenu(int client)
{
	Handle TeamPanel = CreatePanel();

	SetPanelTitle(TeamPanel, "SuperVersus Team Panel");

	char title_spectator[32];
	Format(title_spectator, sizeof(title_spectator), "Spectator (%d)", GetTeamPlayers(TEAM_SPECTATOR, false));
	DrawPanelItem(TeamPanel, title_spectator);
		
	// Draw Spectator Group
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && GetClientTeam(i) == TEAM_SPECTATOR)
		{
			char text_client[32];
			char ClientUserName[MAX_TARGET_LENGTH];
			GetClientName(i, ClientUserName, sizeof(ClientUserName));
			ReplaceString(ClientUserName, sizeof(ClientUserName), "[", "");

			Format(text_client, sizeof(text_client), "%s", ClientUserName);
			DrawPanelText(TeamPanel, text_client);
		}
	}

	char title_survivor[32];
	Format(title_survivor, sizeof(title_survivor), "Survivors (%d/%d) - %d Bot(s)", GetTeamPlayers(TEAM_SURVIVOR, false), SurvivorLimit.IntValue, CountAvailableBots(TEAM_SURVIVOR));
	DrawPanelItem(TeamPanel, title_survivor);
	
	// Draw Survivor Group
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && GetClientTeam(i) == TEAM_SURVIVOR)
		{
			char text_client[32];
			char ClientUserName[MAX_TARGET_LENGTH];

			GetClientName(i, ClientUserName, sizeof(ClientUserName));
			ReplaceString(ClientUserName, sizeof(ClientUserName), "[", "");

			char m_iHealth[MAX_TARGET_LENGTH];
			if(IsPlayerAlive(i))
			{
				if(GetEntProp(i, Prop_Send, "m_isIncapacitated"))
				{
					Format(m_iHealth, sizeof(m_iHealth), "DOWN - %d HP - ", GetEntData(i, FindDataMapInfo(i, "m_iHealth"), 4));
				}
				else if(GetEntProp(i, Prop_Send, "m_currentReviveCount") == SurvMaxIncap.IntValue)
				{
					Format(m_iHealth, sizeof(m_iHealth), "BLWH - ");
				}
				else
				{
					Format(m_iHealth, sizeof(m_iHealth), "%d HP - ", GetClientRealHealth(i));
				}
	
			}
			else
			{
				Format(m_iHealth, sizeof(m_iHealth), "DEAD - ");
			}

			Format(text_client, sizeof(text_client), "%s%s", m_iHealth, ClientUserName);
			DrawPanelText(TeamPanel, text_client);
		}
	}

	DrawPanelItem(TeamPanel, "Close");
		
	SendPanelToClient(TeamPanel, client, TeamMenuHandler, 30);
	CloseHandle(TeamPanel);
	TeamPanelTimer[client] = CreateTimer(1.0, Timer_TeamMenuHandler, client);
}

public int TeamMenuHandler(Handle UpgradePanel, MenuAction action, int client, int param2) {
	if (action == MenuAction_Select) {
		if (param2 == 1) {
			FakeClientCommand(client, "sm_spectate");
		}
		else if (param2 == 2) {


				FakeClientCommand(client, "sm_survivor");

		}
		else if (param2 == 3) {
			FakeClientCommand(client, "sm_infected");
		}
		else if (param2 == 4) {
			delete TeamPanelTimer[client];
		}
	}
	else if (action == MenuAction_Cancel) {
		// Nothing
	}
}

public Action Timer_TeamMenuHandler(Handle hTimer, int client)
{
	DisplayTeamMenu(client);
}

int GetClientRealHealth(int client)
{
	if(!client || !IsValidEntity(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || IsClientObserver(client))
	{
		return -1;
	}
	if(GetClientTeam(client) != TEAM_SURVIVOR)
	{
		return GetClientHealth(client);
	}
  
	float buffer = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
	float TempHealth;
	int PermHealth = GetClientHealth(client);
	if(buffer <= 0.0)
	{
		TempHealth = 0.0;
	}
	else
	{
		float difference = GetGameTime() - GetEntPropFloat(client, Prop_Send, "m_healthBufferTime");
		float decay = PainPillsDR.FloatValue;
		float constant = 1.0/decay;	TempHealth = buffer - (difference / constant);
	}
	
	if(TempHealth < 0.0)
	{
		TempHealth = 0.0;
	}
	return RoundToFloor(PermHealth + TempHealth);
}

// *********************************************************************************
// SIGNATURE METHODS
// *********************************************************************************
void Respawn(int client)
{
	static Handle hRoundRespawn;
	if (hRoundRespawn == null)
	{
		Handle hGameConf = LoadGameConfigFile("l4d_superversus");
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConf, SDKConf_Signature, "RoundRespawn");
		hRoundRespawn = EndPrepSDKCall();

  	}
	SDKCall(hRoundRespawn, client);
}

void SetHumanIdle(int bot, int client)
{
	static Handle hSpec;
	if (hSpec == null)
	{
		Handle hGameConf = LoadGameConfigFile("l4d_superversus");
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConf, SDKConf_Signature, "SetHumanSpec");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		hSpec = EndPrepSDKCall();


	}

	SDKCall(hSpec, bot, client);
	SetEntProp(client, Prop_Send, "m_iObserverMode", 5);
}

void TakeOverBot(int client)
{
	static Handle hSwitch;
	if (hSwitch == null)
	{
		Handle hGameConf = LoadGameConfigFile("l4d_superversus");
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(hGameConf, SDKConf_Signature, "TakeOverBot");
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		hSwitch = EndPrepSDKCall();

	}
	SDKCall(hSwitch, client, true);
}

// *********************************************************************************
// CHEAT METHODS
// *********************************************************************************
void CheatCommand(int client, const char[] command, const char[] argument1, const char[] argument2)
{
	int userFlags = GetUserFlagBits(client);
	SetUserFlagBits(client, ADMFLAG_ROOT);
	int flags = GetCommandFlags(command);
	SetCommandFlags(command, flags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "%s %s %s", command, argument1, argument2);
	SetCommandFlags(command, flags);
	SetUserFlagBits(client, userFlags);
}

stock void PrintConsoleToAll(const char[] format, any ...) 
{ 
	char text[192];
	VFormat(text, sizeof(text), format, 2);
	
	for (int i = 1; i <= MaxClients; i++)
	{ 
		if (IsClientInGame(i))
		{
			SetGlobalTransTarget(i);
			PrintToConsole(i, "%s", text);
		}
	}
}

// ------------------------------------------------------------------------
// Teleport client to survivor
// ------------------------------------------------------------------------
void TeleportToSurvivor(int Bot) 
{
				for (int i = 1; i <= MaxClients; i++)
				{
					if (IsClientInGame(i) && (GetClientTeam(i) == TEAM_SURVIVOR) && !IsFakeClient(i) && IsAlive(i) && i != Bot)
					{						
						// get the position coordinates of any active alive player
						float teleportOrigin[3];
						GetClientAbsOrigin(i, teleportOrigin);			
						TeleportEntity(Bot, teleportOrigin, NULL_VECTOR, NULL_VECTOR);					
						break;
					}
				}
}

// ------------------------------------------------------------------------
// Get the average weapon tier of survivors, and give a weapon of that tier to client
// ------------------------------------------------------------------------
char tier1_weapons[5][] =
{
	"weapon_smg",
	"weapon_pumpshotgun",
	"weapon_smg_silenced",		// L4D2 only
	"weapon_shotgun_chrome",	// L4D2 only
	"weapon_smg_mp5"			// International only
};

bool IsWeaponTier1(int iWeapon)
{
	char sWeapon[128];
	GetEdictClassname(iWeapon, sWeapon, sizeof(sWeapon));
	for (int i = 0; i < sizeof(tier1_weapons); i++)
	{
		if (StrEqual(sWeapon, tier1_weapons[i], false)) return true;
	}
	return false;
}

void GiveAverageWeapon(int client)
{
	if (!IsClientInGame(client) || GetClientTeam(client) != TEAM_SURVIVOR || !IsPlayerAlive(client)) return;

	int iWeapon;
	int wtotal=0; int total=0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == TEAM_SURVIVOR && IsPlayerAlive(i) && client != i)
		{
			total = total+1;	
			iWeapon = GetPlayerWeaponSlot(i, 0);
			if (iWeapon < 0 || !IsValidEntity(iWeapon) || !IsValidEdict(iWeapon)) continue; // no primary weapon

			if (IsWeaponTier1(iWeapon)) wtotal = wtotal + 1;  // tier 1
			else wtotal = wtotal + 2; // tier 2 or more
		}
	}
	int average = total > 0 ? RoundToNearest(1.0 * wtotal/total) : 0;
	switch(average)
	{
		case 0: CheatCommand(client, "give", "pistol", "");	
		case 1: CheatCommand(client, "give", "smg", "");
		case 2: CheatCommand(client, "give", "weapon_rifle", "");
	}
}

void SetGodMode(int client, float duration)
{
	if (!IsClientInGame(client)) return;
	
	SetEntProp(client, Prop_Data, "m_takedamage", 0, 1); // god mode
	
	if (duration > 0.0) CreateTimer(duration, Timer_mortal, GetClientUserId(client));
}

public Action Timer_mortal(Handle hTimer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (!client || !IsClientInGame(client)) return;
	SetEntProp(client, Prop_Data, "m_takedamage", 2, 1); // mortal
}

stock int TotalSurvivors() // total bots, including players
{
	int l = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientConnected(i))
		{
			if (IsClientInGame(i) && (GetClientTeam(i) == TEAM_SURVIVOR)) l++;
		}
	}
	return l;
}

public Action Timer_KickNoNeededBot(Handle timer, any bot)
{
	if ((TotalSurvivors() <= cvar_minsurvivor.IntValue)) return Plugin_Handled;
	if (IsClientConnected(bot) && IsClientInGame(bot))
	{
		char BotName[100];
		GetClientName(bot, BotName, sizeof(BotName));				
		if (StrEqual(BotName, "SurvivorBot", true)) return Plugin_Handled;
		if (!HasIdlePlayer(bot))
		{
			StripWeapons(bot);
			KickClient(bot, "Kicking No Needed Bot");
		}
	}
	
	//ServerCommand("sm_kickextrabots");
	
	return Plugin_Handled;
}

stock int StripWeapons(int client) // strip all items from client
{
	int itemIdx;
	for (int x = 0; x <= 3; x++)
	{
		if ((itemIdx = GetPlayerWeaponSlot(client, x)) != -1)
		{  
			RemovePlayerItem(client, itemIdx);
			RemoveEdict(itemIdx);
		}
	}
}

stock bool HasIdlePlayer(int bot)
{
	if (IsValidEntity(bot))
	{
		char sNetClass[12];
		GetEntityNetClass(bot, sNetClass, sizeof(sNetClass));

		if (strcmp(sNetClass, "SurvivorBot") == 0)
		{
			if (!GetEntProp(bot, Prop_Send, "m_humanSpectatorUserID"))
				return false;

			int client = GetClientOfUserId(GetEntProp(bot, Prop_Send, "m_humanSpectatorUserID"));
			if (client)
			{
				// Do not count bots
				// Do not count 3rd person view players
				if (IsClientInGame(client) && !IsFakeClient(client) && (GetClientTeam(client) != TEAM_SURVIVOR)) return true;
			}
			else return false;
		}
	}
	return false;
}

bool IsAlive(int client)
{
	if (!GetEntProp(client, Prop_Send, "m_lifeState")) return true;
	return false;
}