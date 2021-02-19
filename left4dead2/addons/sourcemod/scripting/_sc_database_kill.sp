#include <sourcemod>
#include <sdktools>
#include <smac>

#pragma semicolon 1
#pragma newdecls required

#define MAX_LINE_WIDTH 64

static const char DATABASE_CONF_NAME[] = "supercoop";
static const char TABLE_KILL_INFO[] = "players_kill";
static const char DATABASE_CHARSET[]="utf8";
Database db=INVALID_HANDLE;


public Plugin myinfo =
{
	name = "Super Coop Server DataBase Management for Kill Info",
	author = "SamaelXXX",
	description = "Manage basic info of all connected players kill info",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("player_death",Event_PlayerDeath);
}

public void OnMapStart()
{
	delete db;
	ConnectDB();
}

public Action Event_PlayerDeath(Handle event, const char[] name,bool dontBroadcast)
{
	int attacker=GetClientOfUserId(GetEventInt(event,"attacker"));

	if(GetEventBool(event,"attackerisbot")||!GetEventBool(event,"victimisbot"))
		return Plugin_Continue;

	char attackerId[MAX_LINE_WIDTH];
	GetClientAuthString(attacker,attackerId,sizeof(attackerId));
	char attackerName[MAX_LINE_WIDTH];
	GetClientName(attacker,attackerName,sizeof(attackerName));

	char victimName[MAX_LINE_WIDTH];
	GetEventString(event,"victimname",victimName,sizeof(victimName));

	char infectedKey[MAX_LINE_WIDTH];
	StringToLower(victimName);
	if(StrEqual(victimName,"hunter")||
		StrEqual(victimName,"smoker")||
		StrEqual(victimName,"spitter")||
		StrEqual(victimName,"boomer")||
		StrEqual(victimName,"jockey")||
		StrEqual(victimName,"charger")||
		StrEqual(victimName,"witch"))
		Format(infectedKey,sizeof(infectedKey),"total_%s_killed",victimName);
	else
		return Plugin_Continue;


	char query[1024];
	Format(query,
	sizeof(query),
	"INSERT INTO %s (steam_id,user_name,%s) VALUES ('%s','%s',1) ON DUPLICATE KEY UPDATE %s=%s+1,user_name=VALUES(user_name)",
	TABLE_KILL_INFO,
	infectedKey,
	attackerId,
	attackerName,
	infectedKey,
	infectedKey
	);
	SendSQLUpdate(query);
	return Plugin_Continue;
}

public void ConnectDB()
{
	if(SQL_CheckConfig(DATABASE_CONF_NAME))
	{
		char error[256];
		Database db=SQL_Connect(DATABASE_CONF_NAME,true,error,sizeof(error));
		
		if(db==INVALID_HANDLE)
		{
			PrintToServer("Failed to connect to database:%s",error);
		}
		else
		{
			db.SetCharset(DATABASE_CHARSET);
		}
			//SendSQLUpdate("SET NAMES 'utf8'");
	}
}

public void SendSQLUpdate(const char[] query)
{
	if (db == INVALID_HANDLE)
        return;

	db.Query(SQLErrorCheckCallback, query);
}

public void SQLErrorCheckCallback(Database db, DBResultSet results, const char[] error,any data)
{
	if (db == INVALID_HANDLE)
        return;

    if(!StrEqual("", error))
        PrintToServer("SQL Error: %s", error);
}

