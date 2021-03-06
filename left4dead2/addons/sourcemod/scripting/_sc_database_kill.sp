#include <sourcemod>
#include <sdktools>
#include <smac>

#define MAX_LINE_WIDTH 64

Database gDatabase=INVALID_HANDLE;

int specialInfectedKilled[MAXPLAYERS + 1];


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
	HookEvent("round_start",Event_RoundStart);
	HookEvent("player_death",Event_PlayerDeath);
	HookEvent("map_transition", Event_RoundEnd);
}

public void OnMapStart()
{
	ResetSpecialInfectedKilled();
	delete gDatabase;
	ConnectDB();
}

public void OnClientDisconnect(int client)
{
	specialInfectedKilled[client]=0;
}

public void ConnectDB()
{
	if(SQL_CheckConfig("supercoop"))
	{
		char error[256];
		gDatabase=SQL_Connect("supercoop",true,error,sizeof(error));
		
		if(gDatabase==INVALID_HANDLE)
		{
			PrintToServer("Failed to connect to database:%s",error);
		}
		else
		{
			gDatabase.SetCharset("utf8");
		}
	}
}

public void SendSQLUpdate(const char[] query)
{
	if (gDatabase == INVALID_HANDLE)
        return;

	gDatabase.Query(SQLErrorCheckCallback, query);
}

public void SQLErrorCheckCallback(Database db, DBResultSet results, const char[] error,any data)
{
	if (db == INVALID_HANDLE)
        return;

    if(!StrEqual("", error))
        PrintToServer("SQL Error: %s", error);
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

	//PrintToServer(">>>[Database] Player Death:%s#########################################",victimName);

	char infectedKey[MAX_LINE_WIDTH];
	StringToLower(victimName);
	if(StrEqual(victimName,"hunter")||
		StrEqual(victimName,"smoker")||
		StrEqual(victimName,"spitter")||
		StrEqual(victimName,"boomer")||
		StrEqual(victimName,"jockey")||
		StrEqual(victimName,"charger"))
	{
		specialInfectedKilled[attacker]++;
		// for(int i=0;i<MAXPLAYERS + 1;i++)
		// 	PrintToServer("%d:%d",i,specialInfectedKilled[i]);
		Format(infectedKey,sizeof(infectedKey),"total_%s_killed",victimName);
	}
	else if(StrEqual(victimName,"witch")||
		StrEqual(victimName,"infected"))
	{
		Format(infectedKey,sizeof(infectedKey),"total_%s_killed",victimName);
	}
		
	else
		return Plugin_Continue;


	char query[1024];
	Format(query,
	sizeof(query),
	"INSERT INTO players_kill (steam_id,user_name,%s) VALUES ('%s','%s',1) ON DUPLICATE KEY UPDATE %s=%s+1,user_name=VALUES(user_name)",
	infectedKey,
	attackerId,
	attackerName,
	infectedKey,
	infectedKey
	);
	SendSQLUpdate(query);

	char update[1024];
	Format(update,
	sizeof(update),
	"UPDATE players_kill SET total_specials_killed=total_spitter_killed+total_boomer_killed+total_smoker_killed+total_jockey_killed+total_charger_killed+total_hunter_killed+total_witch_killed WHERE steam_id='%s'",
	attackerId);
	SendSQLUpdate(update);
	return Plugin_Continue;
}

public Action Event_RoundEnd(Handle event, const char[] name,bool dontBroadcast)
{
	PrintToServer(">>>[Database] Round End#########################################");
	for(int i=1;i<=32;i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i))	
		{
			int infectedKilled = GetEntProp(i, Prop_Send, "m_checkpointZombieKills");
			int specialKilled = specialInfectedKilled[i];
			if(infectedKilled<=0&&specialKilled<=0)
				continue;
			
			char id[32];
			char name[64];
			GetClientAuthId(i, AuthId_Steam2, id, sizeof(id),false)
			GetClientName(i,name,sizeof(name));

			if(StrEqual(id,"BOT",false))
				continue;

			char query[1024];
			Format(query,
			sizeof(query),
			"UPDATE players_kill SET max_infected_killed=%d WHERE steam_id='%s' AND max_infected_killed<%d",
			infectedKilled,
			id,
			infectedKilled
			);
			SendSQLUpdate(query);

			Format(query,
			sizeof(query),
			"UPDATE players_kill SET max_specials_killed=%d WHERE steam_id='%s' AND max_specials_killed<%d",
			specialKilled,
			id,
			specialKilled
			);
			SendSQLUpdate(query);
		}
	}

	PrintToChatAll("\x01=====\x04特感击杀榜\x01=====");
	int cursor=1;
	for(int i=0;i<8;i++)
	{
		int max=0;
		int maxClient=-1;
		for(int j=0;j<MAXPLAYERS + 1;j++)
		{
			if(max<specialInfectedKilled[j])
			{
				max=specialInfectedKilled[j];
				maxClient=j;
			}
		}
		if(maxClient!=-1)
		{
			specialInfectedKilled[maxClient]=0;
			if(IsClientInGame(maxClient))
			{
				char name[64];
				GetClientName(maxClient,name,sizeof(name));
				PrintToChatAll("\x01%d.\x04%d----\x05%s",cursor,max,name);
				cursor++;
			}
		}	
	}

	ResetSpecialInfectedKilled();
	return Plugin_Continue;
}

public Action Event_RoundStart(Handle event, const char[] name,bool dontBroadcast)
{
	ResetSpecialInfectedKilled();
	return Plugin_Continue;
}

public void ResetSpecialInfectedKilled()
{
	for(int i=0;i<MAXPLAYERS + 1;i++)
		specialInfectedKilled[i]=0;
}

