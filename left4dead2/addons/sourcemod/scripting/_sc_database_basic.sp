#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

static const char DATABASE_CONF_NAME[] = "supercoop";
static const char TABLE_BASIC_INFO[] = "players_basic";
static const char DATABASE_CHARSET[]="utf8";


public Plugin myinfo =
{
	name = "Super Coop Server DataBase Management for Basic Info",
	author = "SamaelXXX",
	description = "Manage basic info of all connected players",
	version = "1",
	url = ""
};

public void OnClientPutInServer(int client)
{
	if(IsFakeClient(client)) return;

	PrintToServer("Start Connecting SQL Server...");
	Database.Connect(OnSQLConnected, DATABASE_CONF_NAME, client);
}

void OnSQLConnected(Database db, const char[] error,any data)
{
	if(db==null)
	{
		PrintToServer("Database connect failure:%s",error);
	}
	else
	{
		PrintToServer("Database connect succeed!");
		InsertRecordToDB(db, data);
	}
}

void InsertRecordToDB(Database db, int client)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	if(strcmp(steamid,"BOT")==0) return;
	
	PrintToServer("Add database record:%s %s",steamid,username);
	
	char query[200];
	Format(query, sizeof(query), "REPLACE INTO %s (steam_id,user_name) VALUES ('%s','%s')",TABLE_BASIC_INFO,steamid,username);

	db.SetCharset(DATABASE_CHARSET);
	db.Query(OnPostQuery, query, client);
}

void OnPostQuery(Database db, DBResultSet results, const char[] error, int client)
{
	if (db == null || results == null || error[0] != '\0')
    {
        PrintToServer("Query failed! %s", error);
    }

	delete db;
}
