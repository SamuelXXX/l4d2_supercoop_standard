#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

static const char DATABASE_CONF_NAME[] = "supercoop";
static const char TABLE_BASIC_INFO[] = "players_basic";
static const char DATABASE_CHARSET[]="utf8";
static int lastLoginTime[MAXPLAYERS + 1];
static char loginSteamID[MAXPLAYERS + 1][64];


public Plugin myinfo =
{
	name = "Super Coop Server DataBase Management for Basic Info",
	author = "SamaelXXX",
	description = "Manage basic info of all connected players",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	ResetAllClients();
	HookEvent("player_connect",Event_PlayerConnect);
	HookEvent("player_disconnect",Event_PlayerDisconnect);
}

void WriteSteamID(int client, const char[] steamid)
{
	strcopy(loginSteamID[client],64,steamid);
}

void ResetAllClients()
{
	for(int i=0;i<MAXPLAYERS + 1;i++)
	{
		lastLoginTime[i]=-1;
		WriteSteamID(i,"");
	}
}

//Event fired when a player disconnects from the server
public Action Event_PlayerConnect(Handle hEvent, const char[] strName, bool bDontBroadcast) {
	int client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(client < 1)
		return Plugin_Continue;
		
	if(IsFakeClient(client)) return Plugin_Continue;
	lastLoginTime[client]=-1;
	AsyncPostPlayerLoginRecord(client);
	
	return Plugin_Continue;
}

void AsyncPostPlayerLoginRecord(int client)
{
	PrintToServer("Start Connecting SQL Server...");
	Database.Connect(OnSQLConnected_Login, DATABASE_CONF_NAME, client);
}

void OnSQLConnected_Login(Database db, const char[] error,any data)
{
	if(db==null)
	{
		PrintToServer("Database connect failure:%s",error);
	}
	else
	{
		PrintToServer("Database connect succeed!");
		InsertRecordToDB_Login(db, data);
	}
}

void InsertRecordToDB_Login(Database db, int client)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	if(strcmp(steamid,"BOT")==0) return;

	WriteSteamID(client,steamid);
	
	PrintToServer("Add login database record:%s %s",steamid,username);
	
	char query1[600];
	char query2[200];
	Format(query1, 
		sizeof(query1), 
		"INSERT INTO %s (steam_id,user_name,last_login_time) VALUES ('%s','%s',unix_timestamp()) ON DUPLICATE KEY UPDATE user_name=VALUES(user_name),last_login_time=VALUES(last_login_time)",
		TABLE_BASIC_INFO,
		steamid,
		username);
	
	Format(query2, 
		sizeof(query2), 
		"SELECT last_login_time FROM %s WHERE steam_id='%s'",
		TABLE_BASIC_INFO,
		steamid);

	db.SetCharset(DATABASE_CHARSET);
	db.Query(OnPostQuery_Login, query1, client);
	db.Query(OnFetchQuery_Login, query2, client);
}

void OnPostQuery_Login(Database db, DBResultSet results, const char[] error, int client)
{
	if (db == null || results == null || error[0] != '\0')
    {
        PrintToServer("Query failed! %s", error);
    }
}

void OnFetchQuery_Login(Database db, DBResultSet results, const char[] error, int client)
{
	if (db == null || results == null || error[0] != '\0')
    {
        PrintToServer("Query failed! %s", error);
    }
	else
	{
		while (results!=null&&results.FetchRow())
		{
			int time_stamp=results.FetchInt(0);
			lastLoginTime[client]=time_stamp;
			
			// char format_time[200];
			// FormatTime(format_time,200,"%Y/%m/%d-%H:%M:%S",time_stamp);
			// PrintToChatAll("Login Time:%s",format_time);
		}
	}
	delete db;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
public Action Event_PlayerDisconnect(Handle hEvent, const char[] strName, bool bDontBroadcast) {
	int client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	
	if(client < 1)
		return Plugin_Continue;
		
	if(IsFakeClient(client)) return Plugin_Continue;
	if(lastLoginTime[client]==-1) return Plugin_Continue;
	AsyncPostPlayerLogoutRecord(client);
	
	return Plugin_Continue;
}

void AsyncPostPlayerLogoutRecord(int client)
{
	PrintToServer("Start Connecting SQL Server...");
	Database.Connect(OnSQLConnected_Logout, DATABASE_CONF_NAME, client);
}

void OnSQLConnected_Logout(Database db, const char[] error,any data)
{
	if(db==null)
	{
		PrintToServer("Database connect failure:%s",error);
	}
	else
	{
		PrintToServer("Database connect succeed!");
		InsertRecordToDB_Logout(db, data);
	}
}

void InsertRecordToDB_Logout(Database db, int client)
{
	if(strcmp(loginSteamID[client],"BOT")==0) return;
	
	PrintToServer("Add logout database record:%s",loginSteamID[client]);
	
	char query1[400];
	char query2[200];
	Format(query1, 
		sizeof(query1), 
		"INSERT INTO %s (steam_id,last_logout_time) VALUES ('%s',unix_timestamp()) ON DUPLICATE KEY UPDATE last_logout_time=VALUES(last_logout_time)",
		TABLE_BASIC_INFO,
		loginSteamID[client]);
	
	Format(query2, 
		sizeof(query2), 
		"SELECT last_logout_time,max_online_time FROM %s WHERE steam_id='%s'",
		TABLE_BASIC_INFO,
		loginSteamID[client]);

	db.SetCharset(DATABASE_CHARSET);

	DataPack pack=new DataPack();
	pack.WriteCell(client);
	pack.WriteString(loginSteamID[client]);
	WriteSteamID(client,"");
 	db.Query(OnPostQuery_Logout, query1, pack);
	db.Query(OnFetchQuery_Logout, query2, pack);
}

void OnPostQuery_Logout(Database db, DBResultSet results, const char[] error, any data)
{
	if (db == null || results == null || error[0] != '\0')
    {
        PrintToServer("Query failed! %s", error);
    }
}

void OnFetchQuery_Logout(Database db, DBResultSet results, const char[] error, any data)
{
	DataPack pack=view_as<DataPack>(data);
	pack.Reset();

	int client=pack.ReadCell();
	char steamid[200];
	pack.ReadString(steamid,sizeof(steamid));
	delete pack;

	if (db == null || results == null || error[0] != '\0')
    {
        PrintToServer("Query failed! %s", error);
    }
	else if(lastLoginTime[client]!=-1)
	{
		int play_time=-1;
		int max_time=-1;
		int last_login_time=lastLoginTime[client];
		lastLoginTime[client]=-1;

		while (results!=null&&results.FetchRow())
		{
			int time_stamp=results.FetchInt(0);
			max_time=results.FetchInt(1);
			play_time=time_stamp-last_login_time;
			if(max_time<play_time)
			{
				max_time=play_time;
			}		
			//PrintToServer("Play Time:%d",play_time);
		}

		if(play_time>0)
		{
			char query[200];
			Format(query, 
				sizeof(query), 
				"UPDATE %s SET total_play_time=total_play_time+%d,max_online_time=%d WHERE steam_id='%s'",
				TABLE_BASIC_INFO,
				play_time,
				max_time,
				steamid);
			db.Query(OnPostQuery_TotalTime, query);
		}
	}
	delete db;
}

void OnPostQuery_TotalTime(Database db, DBResultSet results, const char[] error, any data)
{
	if (db == null || results == null || error[0] != '\0')
    {
        PrintToServer("Query failed! %s", error);
    }
	delete db;
}
