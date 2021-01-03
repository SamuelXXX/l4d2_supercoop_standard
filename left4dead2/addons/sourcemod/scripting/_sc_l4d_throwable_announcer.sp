/**
// ====================================================================================================
Change Log:

1.0.3 (30-September-2020)
    - Moved molotov check to "molotov_thrown" event. (L4D2 only)
    - Updated translation file to be more color friendly and highlighted the throwables.
    - Removed EventHookMode_PostNoCopy from hook events.

1.0.2 (29-September-2020)
    - Changed the validation from weapon name to weapon id.
    - Code optimization. (thanks to "Silvers")
    - Added colors.inc replacer. (thanks to "Silvers")

1.0.1 (29-September-2020)
    - Added Hungarian (hu) translation. (thanks to "KasperH")

1.0.0 (29-September-2020)
    - Initial release.

// ====================================================================================================
*/

// ====================================================================================================
// Plugin Info - define
// ====================================================================================================
#define PLUGIN_NAME                   "[L4D1 & L4D2] Throwable Announcer"
#define PLUGIN_AUTHOR                 "Mart"
#define PLUGIN_DESCRIPTION            "Output to the chat who threw a throwable"
#define PLUGIN_VERSION                "1.0.3"
#define PLUGIN_URL                    "https://forums.alliedmods.net/showthread.php?t=327613"

// ====================================================================================================
// Plugin Info
// ====================================================================================================
public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = PLUGIN_AUTHOR,
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_VERSION,
    url         = PLUGIN_URL
}

// ====================================================================================================
// Includes
// ====================================================================================================
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <colors>

// ====================================================================================================
// Pragmas
// ====================================================================================================
#pragma semicolon 1
#pragma newdecls required

// ====================================================================================================
// Cvar Flags
// ====================================================================================================
#define CVAR_FLAGS                    FCVAR_NOTIFY
#define CVAR_FLAGS_PLUGIN_VERSION     FCVAR_NOTIFY|FCVAR_DONTRECORD|FCVAR_SPONLY

// ====================================================================================================
// Filenames
// ====================================================================================================
#define CONFIG_FILENAME               "l4d_throwable_announcer"

// ====================================================================================================
// Defines
// ====================================================================================================
#define TEAM_SPECTATOR               1
#define TEAM_SURVIVOR                2
#define TEAM_INFECTED                3

#define FLAG_TEAM_NONE               (0 << 0) // 0   | 000
#define FLAG_TEAM_SURVIVOR           (1 << 0) // 1   | 001
#define FLAG_TEAM_INFECTED           (1 << 1) // 2   | 010
#define FLAG_TEAM_SPECTATOR          (1 << 2) // 4   | 100

#define L4D1_WEPID_MOLOTOV           9
#define L4D1_WEPID_PIPE_BOMB         10

#define L4D2_WEPID_MOLOTOV           13
#define L4D2_WEPID_PIPE_BOMB         14
#define L4D2_WEPID_VOMITJAR          25

// ====================================================================================================
// Plugin Cvars
// ====================================================================================================
static ConVar g_hCvar_Enabled;
static ConVar g_hCvar_Molotov;
static ConVar g_hCvar_Pipebomb;
static ConVar g_hCvar_Vomitjar;
static ConVar g_hCvar_Team;

// ====================================================================================================
// bool - Plugin Variables
// ====================================================================================================
static bool   g_bL4D2Version;
static bool   g_bEventsHooked;
static bool   g_bCvar_Enabled;
static bool   g_bCvar_Molotov;
static bool   g_bCvar_Pipebomb;
static bool   g_bCvar_Vomitjar;

// ====================================================================================================
// int - Plugin Variables
// ====================================================================================================

// ====================================================================================================
// Plugin Start
// ====================================================================================================
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    EngineVersion engine = GetEngineVersion();

    if (engine != Engine_Left4Dead && engine != Engine_Left4Dead2)
    {
        strcopy(error, err_max, "This plugin only runs in the \"Left 4 Dead\" and \"Left 4 Dead 2\" game.");
        return APLRes_SilentFailure;
    }

    g_bL4D2Version = (engine == Engine_Left4Dead2);

    return APLRes_Success;
}

/****************************************************************************************************/

public void OnPluginStart()
{

    CreateConVar("l4d_throwable_announcer_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, CVAR_FLAGS_PLUGIN_VERSION);
    g_hCvar_Enabled  = CreateConVar("l4d_throwable_announcer_enable", "1", "Enables/Disables the plugin.\n0 = Enable, 1 = Disable.", CVAR_FLAGS, true, 0.0, true, 1.0);
    g_hCvar_Molotov  = CreateConVar("l4d_throwable_announcer_molotov", "1", "Output to the chat every time someone throws a molotov.\n0 = OFF, 1 = ON.", CVAR_FLAGS, true, 0.0, true, 1.0);
    g_hCvar_Pipebomb = CreateConVar("l4d_throwable_announcer_pipebomb", "1", "Output to the chat every time someone throws a pipe bomb.\n0 = OFF, 1 = ON.", CVAR_FLAGS, true, 0.0, true, 1.0);
    g_hCvar_Vomitjar = CreateConVar("l4d_throwable_announcer_vomitjar", "1", "Output to the chat every time someone throws a vomit jar.\nL4D2 only.\n0 = OFF, 1 = ON.", CVAR_FLAGS, true, 0.0, true, 1.0);
    g_hCvar_Team     = CreateConVar("l4d_throwable_announcer_team", "1", "Which teams should the message be transmitted to.\nKnown values: 0 = NONE, 1 = SURVIVOR, 2 = INFECTED, 4 = SPECTATOR.\nAdd numbers greater than 0 for multiple options.", CVAR_FLAGS, true, 0.0, true, 7.0);

    // Hook plugin ConVars change
    g_hCvar_Enabled.AddChangeHook(Event_ConVarChanged);
    g_hCvar_Molotov.AddChangeHook(Event_ConVarChanged);
    g_hCvar_Pipebomb.AddChangeHook(Event_ConVarChanged);
    g_hCvar_Vomitjar.AddChangeHook(Event_ConVarChanged);
    g_hCvar_Team.AddChangeHook(Event_ConVarChanged);

    // Load plugin configs from .cfg
    AutoExecConfig(true, CONFIG_FILENAME);

}


/****************************************************************************************************/

public void OnConfigsExecuted()
{
    GetCvars();
}

/****************************************************************************************************/

void Event_ConVarChanged(Handle convar, const char[] sOldValue, const char[] sNewValue)
{
    GetCvars();
}

/****************************************************************************************************/

void GetCvars()
{
    g_bCvar_Enabled = g_hCvar_Enabled.BoolValue;
    g_bCvar_Molotov = g_hCvar_Molotov.BoolValue;
    g_bCvar_Pipebomb = g_hCvar_Pipebomb.BoolValue;
    g_bCvar_Vomitjar = g_hCvar_Vomitjar.BoolValue;

    // Hook plugin events
    HookEvents(g_bCvar_Enabled);
}

// ====================================================================================================
// Events
// ====================================================================================================
void HookEvents(bool hook)
{
    if (hook && !g_bEventsHooked)
    {
        g_bEventsHooked = true;

        if (g_bL4D2Version)
        {
            HookEvent("molotov_thrown", Event_L4D2_MolotovThrown);
            HookEvent("weapon_fire", Event_L4D2_WeaponFire);
        }
        else
        {
            //L4D1 doesn't have "molotov_thrown" event
            HookEvent("weapon_fire", Event_L4D1_WeaponFire);
        }

        return;
    }

    if (!hook && g_bEventsHooked)
    {
        g_bEventsHooked = false;

        if (g_bL4D2Version)
        {
            UnhookEvent("molotov_thrown", Event_L4D2_MolotovThrown);
            UnhookEvent("weapon_fire", Event_L4D2_WeaponFire);
        }
        else
        {
            UnhookEvent("weapon_fire", Event_L4D1_WeaponFire);
        }

        return;
    }
}

/****************************************************************************************************/

public Action Event_L4D2_MolotovThrown(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_bCvar_Molotov)
        return Plugin_Handled;

    int client = GetClientOfUserId(event.GetInt("userid"));

    if (!IsValidClient(client))
        return Plugin_Handled;

    char clientName[MAX_TARGET_LENGTH];
    GetClientName(client, clientName, sizeof(clientName));
    CPrintToChatAll("{green}[提示] {olive}%s {default}扔出燃烧瓶", clientName);

    return Plugin_Handled;
}

/****************************************************************************************************/

public Action Event_L4D2_WeaponFire(Event event, const char[] name, bool dontBroadcast)
{
    int weaponid = GetEventInt(event,"weaponid");

    switch (weaponid)
    {
        case L4D2_WEPID_PIPE_BOMB, L4D2_WEPID_VOMITJAR:
        {
            int client = GetClientOfUserId(event.GetInt("userid"));

            if (!IsValidClient(client))
                return Plugin_Handled;

            if (weaponid == L4D2_WEPID_PIPE_BOMB)
            {
                if (!g_bCvar_Pipebomb)
                    return Plugin_Handled;

                char clientName[MAX_TARGET_LENGTH];
                GetClientName(client, clientName, sizeof(clientName));
                CPrintToChatAll("{green}[提示] {olive}%s {default}扔出土质炸弹", clientName);

                return Plugin_Handled;
            }

            if (weaponid == L4D2_WEPID_VOMITJAR)
            {
                if (!g_bCvar_Vomitjar)
                    return Plugin_Handled;

                char clientName[MAX_TARGET_LENGTH];
                GetClientName(client, clientName, sizeof(clientName));
                CPrintToChatAll("{green}[提示] {olive}%s {default}扔出胆汁罐", clientName);

                return Plugin_Handled;
            }
        }
    }

    return Plugin_Handled;
}

/****************************************************************************************************/

public Action Event_L4D1_WeaponFire(Event event, const char[] name, bool dontBroadcast)
{
    int weaponid = GetEventInt(event,"weaponid");

    switch (weaponid)
    {
        case L4D1_WEPID_MOLOTOV, L4D1_WEPID_PIPE_BOMB:
        {
            int client = GetClientOfUserId(event.GetInt("userid"));

            if (!IsValidClient(client))
                return Plugin_Handled;

            if (weaponid == L4D1_WEPID_MOLOTOV)
            {
                if (!g_bCvar_Molotov)
                    return Plugin_Handled;

                char clientName[MAX_TARGET_LENGTH];
                GetClientName(client, clientName, sizeof(clientName));
                CPrintToChatAll("{green}[提示] {olive}%s {default}扔出燃烧瓶", clientName);

                return Plugin_Handled;
            }

            if (weaponid == L4D1_WEPID_PIPE_BOMB)
            {
                if (!g_bCvar_Pipebomb)
                    return Plugin_Handled;


                char clientName[MAX_TARGET_LENGTH];
                GetClientName(client, clientName, sizeof(clientName));
                CPrintToChatAll("{green}[提示] {olive}%s {default}扔出土制炸弹", clientName);

                return Plugin_Handled;
            }
        }
    }

    return Plugin_Handled;
}


// ====================================================================================================
// Helpers
// ====================================================================================================
/**
 * Validates if is a valid client index.
 *
 * @param client        Client index.
 * @return              True if client index is valid, false otherwise.
 */
bool IsValidClientIndex(int client)
{
    return (1 <= client <= MaxClients);
}

/****************************************************************************************************/

/**
 * Validates if is a valid client.
 *
 * @param client        Client index.
 * @return              True if client index is valid and client is in game, false otherwise.
 */
bool IsValidClient(int client)
{
    return (IsValidClientIndex(client) && IsClientInGame(client));
}
