#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <geoip>

#define PLUGIN_VERSION "1.8"

#define CVAR_FLAGS		FCVAR_NOTIFY
#define PRIVATE_STUFF	1

public Plugin myinfo = 
{
	name = "[L4D] Votemute (no black screen)",
	author = "Dragokas",
	description = "Vote for player mute (microphone) with translucent menu",
	version = PLUGIN_VERSION,
	url = "https://github.com/dragokas"
};

/*
	This plugin is based on "[L4D] Votekick (no black screen)" by Dragokas.
	
	Some forwards and commands used from BaseComm:

	// SetListenOverride(i, client, Listen_No);
	// sm_mute
	// sm_gag
	// sm_silence
	
	// SetClientListeningFlags(client, VOICE_MUTED);
	// SetClientListeningFlags(client, VOICE_NORMAL);
	
	// BaseComm_IsClientGagged()
	// BaseComm_IsClientMuted()
	// BaseComm_SetClientGag()
	// BaseComm_SetClientMute()
	
	====================================================================================
	
	Description:
	 - This plugin adds ability to vote for voice mute.
	
	Features:
	 - translucent vote menu.
	 - mute for 1 hour (adjustable) even if player used trick to quit the game before vote ends.
	 - vote announcement
	 - flexible configuration of access rights
	 - all actions are logged (who mute, whom mute, who tried to mute ...)
	
	Logfile location:
	 - logs/vote_mute.log

	Permissions:
	 - by default, vote can be started by everybody (adjustable) if immunity and player count checks passed.
	 - ability to set minimum time to allow repeat the vote.
	 - ability to set minimum players count to allow starting the vote.
	 - admins cannot target root admin.
	 - set #PRIVATE_STUFF to 1 to unlock some additional options - forbid vote by name or SteamID
	
	Settings (ConVars):
	 - sm_votemute_delay - def.: 60 - Minimum delay (in sec.) allowed between votes
	 - sm_votemute_timeout - def.: 10 - How long (in sec.) does the vote last
	 - sm_votemute_announcedelay - def.: 2.0 - Delay (in sec.) between announce and vote menu appearing
	 - sm_votemute_mutetime - def.: 3600 - How long player will be muteed (in sec.)
	 - sm_votemute_minplayers - def.: 1 - Minimum players present in game to allow starting vote for mute
	 - sm_votemute_accessflag - def.: "" - Admin flag required to start the vote (leave empty to allow for everybody)
	 - sm_votemute_handleadminmenu - def.: 1 - Should this plugin handle mute/gag made via admin menu? (1 - Yes / 0 - No)
	 - sm_votemute_log - def.: 1 - Use logging? (1 - Yes / 0 - No)
	
	Commands:
	
	- sm_vm (or sm_votemute) - Try to start vote for mute
	- sm_veto - Allow admin to veto current vote (ADMFLAG_BAN is required)
	- sm_votepass - Allow admin to bypass current vote (ADMFLAG_BAN is required)
	
	Requirements:
	 - GeoIP extension (included in SourceMod).
	 - SourceMod Communication Plugin - Basecomm.smx (included in SourceMod).
	
	Languages:
	 - Russian
	 - English
	
	Installation:
	 - copy smx file to addons/sourcemod/plugins/
	 - copy phrases.txt file to addons/sourcemod/translations/
	
	TODO:
	 - unmute
	 - permanent mute on join automatically by list

*/

StringMap hMapSteam;

char g_sIP[32];
char g_sCountry[4];
char g_sName[MAX_NAME_LENGTH];

char g_sLog[PLATFORM_MAX_PATH];

int g_iMuteUserId;
int g_iSteamId;
char g_sSteamId[64];
int iLastTime[MAXPLAYERS+1];

bool g_bVeto;
bool g_bVotepass;
bool g_bVoteInProgress;
bool g_bVoteDisplayed;
bool g_bBaseCommAvail;

ConVar g_hCvarDelay;
ConVar g_hCvarMuteTime;
ConVar g_hCvarHandleAdminMenu;
ConVar g_hCvarAnnounceDelay;
ConVar g_hCvarTimeout;
ConVar g_hCvarLog;
ConVar g_hMinPlayers;
ConVar g_hCvarAccessFlag;

native bool BaseComm_SetClientMute(int client, bool bState);

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	MarkNativeAsOptional("BaseComm_SetClientMute");
	return APLRes_Success;
}

public void OnPluginStart()
{
	LoadTranslations("l4d_votemute.phrases");
	CreateConVar("l4d_votemute_version", PLUGIN_VERSION, "Version of L4D Votemute on this server", FCVAR_DONTRECORD);
	
	g_hCvarDelay = CreateConVar(			"sm_votemute_delay",			"60",				"Minimum delay (in sec.) allowed between votes", CVAR_FLAGS );
	g_hCvarTimeout = CreateConVar(			"sm_votemute_timeout",			"10",				"How long (in sec.) does the vote last", CVAR_FLAGS );
	g_hCvarAnnounceDelay = CreateConVar(	"sm_votemute_announcedelay",	"2.0",				"Delay (in sec.) between announce and vote menu appearing", CVAR_FLAGS );
	g_hCvarMuteTime = CreateConVar(			"sm_votemute_mutetime",			"3600",				"How long player will be muteed (in sec.)", CVAR_FLAGS );
	g_hMinPlayers = CreateConVar(			"sm_votemute_minplayers",		"1",				"Minimum players present in game to allow starting vote for mute", CVAR_FLAGS );
	g_hCvarAccessFlag = CreateConVar(		"sm_votemute_accessflag",		"",					"Admin flag required to start the vote (leave empty to allow for everybody)", CVAR_FLAGS );
	g_hCvarHandleAdminMenu = CreateConVar(	"sm_votemute_handleadminmenu",	"1",				"Should this plugin handle mute/gag made via admin menu? (1 - Yes / 0 - No)", CVAR_FLAGS );
	g_hCvarLog = CreateConVar(				"sm_votemute_log",				"1",				"Use logging? (1 - Yes / 0 - No)", CVAR_FLAGS );
	
	AutoExecConfig(true,				"sm_votemute");
	
	RegConsoleCmd("sm_votemute", Command_Votemute);
	RegConsoleCmd("sm_vm", Command_Votemute);
	
	RegAdminCmd("sm_veto", 			Command_Veto, 		ADMFLAG_VOTE, 	"Allow admin to veto current vote.");
	RegAdminCmd("sm_votepass", 		Command_Votepass, 	ADMFLAG_BAN, 	"Allow admin to bypass current vote.");
	
	if (hMapSteam == null) {
		hMapSteam = new StringMap();
	}
	
	BuildPath(Path_SM, g_sLog, sizeof(g_sLog), "logs/vote_mute.log");
}

bool IsInMuteBase(int client, int iSteamId = 0)
{
	// check is available both by client or SteamId (because client could disconnect before vote finished)
	static char auth[32], sTime[32];
	static int iTime;
	
	if (client != 0 && IsClientInGame(client))
		iSteamId = GetSteamAccountID(client, true);
	
	IntToString(iSteamId, auth, sizeof(auth));
	
	if (hMapSteam.GetString(auth, sTime, sizeof(sTime))) { // mute not more than 1 hour
		iTime = StringToInt(sTime);
		if (GetTime() - iTime < g_hCvarMuteTime.IntValue) {
			return true;
		}
		else {
			hMapSteam.Remove(auth);
		}
	}
	return false;
}

stock void MuteClient(int client, int iSteamId = 0)
{
	static char sTime[32], sSteam[32];
	
	if (g_bBaseCommAvail)
		BaseComm_SetClientMute(client, true);
	
	if (!IsInMuteBase(client, iSteamId)) {
		if (client != 0 && IsClientInGame(client))
			iSteamId = GetSteamAccountID(client, true);
		
		IntToString(GetTime(), sTime, sizeof(sTime));
		IntToString(iSteamId, sSteam, sizeof(sSteam));
		hMapSteam.SetString(sSteam, sTime, true);
	}
}

stock void UnmuteClient(int client, int iSteamId = 0)
{
	static char sSteam[32];

	if (g_bBaseCommAvail)
		BaseComm_SetClientMute(client, false);
		
	if (IsInMuteBase(client, iSteamId)) {
		if (client != 0 && IsClientInGame(client))
			iSteamId = GetSteamAccountID(client, true);
		
		IntToString(iSteamId, sSteam, sizeof(sSteam));
		hMapSteam.Remove(sSteam);
	}
}

public void BaseComm_OnClientMute(int client, bool muteState)
{
	if (g_hCvarHandleAdminMenu.BoolValue) {
		if (muteState) {
			MuteClient(client);
		}
		else {
			UnmuteClient(client);
		}
	}
}

public void BaseComm_OnClientGag(int client, bool gagState)
{
}

public Action Command_Veto(int client, int args)
{
	if (g_bVoteInProgress) { // IsVoteInProgress() is not working here, sm bug?
		g_bVeto = true;
		CPrintToChatAll("%t", "veto", client);
		if (g_bVoteDisplayed) CancelVote();
		LogVoteAction(client, "[VETO]");
	}
	return Plugin_Handled;
}

public Action Command_Votepass(int client, int args)
{
	if (g_bVoteInProgress) {
		g_bVotepass = true;
		CPrintToChatAll("%t", "votepass", client);
		if (g_bVoteDisplayed) CancelVote();
		LogVoteAction(client, "[PASS]");
	}
	return Plugin_Handled;
}

public void OnAllPluginsLoaded()
{
	g_bBaseCommAvail = LibraryExists("basecomm");
	if (!g_bBaseCommAvail) {
		SetFailState("Required plugin basecomm.smx is not loaded.");
	}
}

public void OnLibraryAdded(const char[] sName)
{
	if(StrEqual(sName, "basecomm")) {
		g_bBaseCommAvail = true;
	}
}

public void OnLibraryRemoved(const char[] sName)
{
	if(StrEqual(sName, "basecomm")) {
		g_bBaseCommAvail = false;
	}
}

public Action Command_Votemute(int client, int args)
{
	if(client != 0) CreateVotemuteMenu(client);
	return Plugin_Handled;
}

void CreateVotemuteMenu(int client)
{
	Menu menu = new Menu(Menu_Votemute, MENU_ACTIONS_DEFAULT);
	static char name[MAX_NAME_LENGTH];
	static char uid[12];
	static char menuItem[64];
	static char ip[32];
	static char code[4];
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i)) //&& i != client)
		{
			Format(uid, sizeof(uid), "%i", GetClientUserId(i));
			if(GetClientName(i, name, sizeof(name)))
			{
				if(GetClientIP(i, ip, sizeof(ip)))
				{
					if(!GeoipCode3(ip, code))
						strcopy(code, sizeof(code), "LAN");

					Format(menuItem, sizeof(menuItem), "%s (%s)", name, code);
					AddMenuItem(menu, uid, menuItem);
				}
				else
					menu.AddItem(uid, name);
			}
		}
	}
	menu.SetTitle("Player To Mute", client);
	menu.Display(client, MENU_TIME_FOREVER);
}

public int Menu_Votemute(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
		
		case MenuAction_Cancel:
			if (param2 == MenuCancel_ExitBack)
				CreateVotemuteMenu(param1);
		
		case MenuAction_Select:
		{
			char info[16];
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int target = GetClientOfUserId(StringToInt(info));
				StartVoteAccessCheck(param1, target);
			}
		}
	}
}

void StartVoteAccessCheck(int client, int target)
{
	if (IsVoteInProgress() || g_bVoteInProgress) {
		CPrintToChat(client, "%t", "other_vote");
		LogVoteAction(client, "[DENY] Reason: another vote is in progress.");
		return;
	}
	
	if (target == 0 || !IsClientInGame(target))
	{
		CPrintToChat(client, "%t", "not_in_game"); // "Client is already disconnected."
		return;
	}
	
	SetListenOverride(client, target, Listen_No); // in case initiator don't want to hear this client (but vote failed)
	
	if (!IsVoteAllowed(client, target))
	{
		CPrintToChatAll("%t", "no_access", client, target); // "%s tried to use votemute against %s, but has no access."
		LogVoteAction(client, "[NO ACCESS]");
		LogVoteAction(target, "[TRIED] to mute against:");
		return;
	}
	
	StartVoteMute(client, target);
}

int GetRealClientCount() {
	int cnt;
	for (int i = 1; i <= MaxClients; i++)
		if (IsClientInGame(i) && !IsFakeClient(i)) cnt++;
	return cnt;
}

bool IsVoteAllowed(int client, int target)
{
	if (target == 0 || !IsClientInGame(target))
		return false;
	
	if (IsClientRootAdmin(target))
		return false;
	
	if (IsClientRootAdmin(client))
		return true;
	
	if (iLastTime[client] != 0)
	{
		if (iLastTime[client] + g_hCvarDelay.IntValue > GetTime()) {
			CPrintToChat(client, "%t", "too_often"); // "You can't vote too often!"
			LogVoteAction(client, "[DENY] Reason: too often.");
			return false;
		}
	}
	iLastTime[client] = GetTime();
	
	int iClients = GetRealClientCount();
	
	if (iClients < g_hMinPlayers.IntValue) {
		CPrintToChat(client, "%t", "not_enough_players", g_hMinPlayers.IntValue); // "Not enough players to start the vote. Required minimum: %i"
		LogVoteAction(client, "[DENY] Reason: Not enough players. Now: %i, required: %i.", iClients, g_hMinPlayers.IntValue);
		return false;
	}
	
	if (HasVoteAccess(target) && !HasVoteAccess(client) && !IsClientRootAdmin(client))
		return false;
	
	#if PRIVATE_STUFF
		static char sName[MAX_NAME_LENGTH];
		static char sSteam[64];
		GetClientAuthId(client, AuthId_Steam2, sSteam, sizeof(sSteam));
		
		if (StrEqual(sSteam, "STEAM_1:0:218709151")) { // by SteamID - Den4ik
			LogVoteAction(client, "[DENY] Reason: it's a XXX :).");
			CPrintToChat(client, "%t", "no_access");
			return false;
		}
		
		GetClientName(client, sName, sizeof(sName));
		
		if ( (StrContains(sName, "Ведьмак") != -1) || (StrContains(sName, "Beдьмaк") != -1) ) {
			LogVoteAction(client, "[DENY] Reason: he is a noob:");
			return false;
		}
	#endif
	
	if (!HasVoteAccess(client)) return false;
	
	return true;
}

void StartVoteMute(int client, int target)
{
	Menu menu = new Menu(Handle_Votemute, MenuAction_DisplayItem | MenuAction_Display);
	g_iMuteUserId = GetClientUserId(target);
	menu.AddItem("", "Yes");
	menu.AddItem("", "No");
	menu.ExitButton = false;
	
	LogVoteAction(client, "[STARTED] by");
	LogVoteAction(target, "[AGAINST] ");
	
	CPrintToChatAll("%t", "vote_started", client, target); // %N is started vote for mute: %N
	PrintToServer("Vote for mute is started by: %N", client);
	PrintToConsoleAll("Vote for mute is started by: %N", client);
	
	GetClientAuthId(target, AuthId_Steam2, g_sSteamId, sizeof(g_sSteamId));
	g_iSteamId = GetSteamAccountID(target, true);
	GetClientName(target, g_sName, sizeof(g_sName));
	GetClientIP(target, g_sIP, sizeof(g_sIP));
	GeoipCode3(g_sIP, g_sCountry);
	
	g_bVotepass = false;
	g_bVeto = false;
	g_bVoteDisplayed = false;
	
	CreateTimer(g_hCvarAnnounceDelay.FloatValue, Timer_VoteDelayed, menu);
	CPrintHintTextToAll("%t", "vote_started_announce", g_sName);
}

Action Timer_VoteDelayed(Handle timer, Menu menu)
{
	if (g_bVotepass || g_bVeto) {
		Handler_PostVoteAction(g_bVotepass);
		delete menu;
	}
	else {
		if (!IsVoteInProgress()) {
			g_bVoteInProgress = true;
			menu.DisplayVoteToAll(g_hCvarTimeout.IntValue);
			g_bVoteDisplayed = true;
		}
		else {
			delete menu;
		}
	}
}

public int Handle_Votemute(Menu menu, MenuAction action, int param1, int param2)
{
	static char display[64], buffer[255];

	switch (action)
	{
		case MenuAction_End: {
			if (g_bVoteInProgress && g_bVotepass) { // in case vote is passed with CancelVote(), so MenuAction_VoteEnd is not called.
				Handler_PostVoteAction(true);
			}
			g_bVoteInProgress = false;
			delete menu;
		}
		
		case MenuAction_VoteEnd: // 0=yes, 1=no
		{
			if ((param1 == 0 || g_bVotepass) && !g_bVeto) {
				Handler_PostVoteAction(true);
			}
			else {
				Handler_PostVoteAction(false);
			}
			g_bVoteInProgress = false;
		}
		case MenuAction_DisplayItem:
		{
			menu.GetItem(param2, "", 0, _, display, sizeof(display));
			Format(buffer, sizeof(buffer), "%T", display, param1);
			return RedrawMenuItem(buffer);
		}
		case MenuAction_Display:
		{
			Format(buffer, sizeof(buffer), "%T", "vote_started_announce", param1, g_sName); // "Do you want to mute: %s ?"
			menu.SetTitle(buffer);
		}
	}
	return 0;
}

void Handler_PostVoteAction(bool bVoteSuccess)
{
	if (bVoteSuccess) {
		int iTarget = GetClientOfUserId(g_iMuteUserId);
		if (iTarget != 0 && IsClientInGame(iTarget)) {
			MuteClient(iTarget, g_iSteamId);
		}
		else {
			MuteClient(0, g_iSteamId);
		}
		LogVoteAction(0, "[MUTED]");
		CPrintToChatAll("%t", "vote_success", g_sName);
	}
	else {
		LogVoteAction(0, "[NOT ACCEPTED]");
		CPrintToChatAll("%t", "vote_failed");
	}
	g_bVoteInProgress = false;
}

public void OnClientPostAdminCheck(int client)
{
	if (!IsFakeClient(client)) {
		if (IsInMuteBase(client))
			MuteClient(client);
		
		// check permanent mute list
		
		
	}
}

stock bool IsClientRootAdmin(int client)
{
	return ((GetUserFlagBits(client) & ADMFLAG_ROOT) != 0);
}

bool HasVoteAccess(int client)
{
	int iUserFlag = GetUserFlagBits(client);
	if (iUserFlag & ADMFLAG_ROOT != 0) return true;
	
	char sReq[32];
	g_hCvarAccessFlag.GetString(sReq, sizeof(sReq));
	if (strlen(sReq) == 0) return true;
	
	int iReqFlags = ReadFlagString(sReq);
	return (iUserFlag & iReqFlags != 0);
}

void LogVoteAction(int client, const char[] format, any ...)
{
	if (!g_hCvarLog.BoolValue)
		return;
	
	static char sSteam[64];
	static char sIP[32];
	static char sCountry[4];
	static char sName[MAX_NAME_LENGTH];
	static char buffer[256];
	
	VFormat(buffer, sizeof(buffer), format, 3);
	
	if (client != 0 && IsClientInGame(client)) {
		GetClientAuthId(client, AuthId_Steam2, sSteam, sizeof(sSteam));
		GetClientName(client, sName, sizeof(sName));
		GetClientIP(client, sIP, sizeof(sIP));
		GeoipCode3(sIP, sCountry);
		LogToFile(g_sLog, "%s %s (%s | [%s] %s)", buffer, sName, sSteam, sCountry, sIP);
	}
	else {
		LogToFile(g_sLog, "%s %s (%s | [%s] %s)", buffer, g_sName, g_sSteamId, g_sCountry, g_sIP);
	}
}

stock char[] Translate(int client, const char[] format, any ...)
{
	char buffer[192];
	SetGlobalTransTarget(client);
	VFormat(buffer, sizeof(buffer), format, 3);
	return buffer;
}

stock void ReplaceColor(char[] message, int maxLen)
{
    ReplaceString(message, maxLen, "{white}", "\x01", false);
    ReplaceString(message, maxLen, "{cyan}", "\x03", false);
    ReplaceString(message, maxLen, "{orange}", "\x04", false);
    ReplaceString(message, maxLen, "{green}", "\x05", false);
}

stock void CPrintToChat(int iClient, const char[] format, any ...)
{
    char buffer[192];
    SetGlobalTransTarget(iClient);
    VFormat(buffer, sizeof(buffer), format, 3);
    ReplaceColor(buffer, sizeof(buffer));
    PrintToChat(iClient, "\x01%s", buffer);
}

stock void CPrintToChatAll(const char[] format, any ...)
{
    char buffer[192];
    for( int i = 1; i <= MaxClients; i++ )
    {
        if( IsClientInGame(i) && !IsFakeClient(i) )
        {
            SetGlobalTransTarget(i);
            VFormat(buffer, sizeof(buffer), format, 2);
            ReplaceColor(buffer, sizeof(buffer));
            PrintToChat(i, "\x01%s", buffer);
        }
    }
}

stock void CPrintHintTextToAll(const char[] format, any ...)
{
    char buffer[192];
    for( int i = 1; i <= MaxClients; i++ )
    {
        if( IsClientInGame(i) && !IsFakeClient(i) )
        {
            SetGlobalTransTarget(i);
            VFormat(buffer, sizeof(buffer), format, 2);
            PrintHintText(i, buffer);
        }
    }
}