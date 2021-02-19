#include <sourcemod>
#include <sdktools>

Database gDatabase=INVALID_HANDLE;

enum struct LoginInfo{
	int loginTime;
	char loginSteamId[64];
}

LoginInfo loginInfos[MAXPLAYERS + 1];


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
	ResetAllLoginInfos();
	HookEvent("player_connect",Event_PlayerConnect);
	HookEvent("player_disconnect",Event_PlayerDisconnect);
}

public void OnMapStart()
{
	delete gDatabase;
	ConnectDB();//每次开启新地图尝试重新连接一次服务器
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

public void ResetAllLoginInfos()
{
	for(int i=0;i<MAXPLAYERS + 1;i++)
	{
		loginInfos[i].loginTime=-1;
		strcopy(loginInfos[i].loginSteamId,
				64,
				"");
	}
}

public int SteamIdIndex(char [] steamid)
{
	for(int i=0;i<MAXPLAYERS + 1;i++)
	{
		if(loginInfos[i].loginTime==-1)
			continue;
		
		if(StrEqual(loginInfos[i].loginSteamId, steamid, false))
		{
			return i;
		}
		
	}
	return -1;
}

public void PutLoginInfo(char [] steamid)
{
	int index=SteamIdIndex(steamid);
	if(index!=-1)
	{
		loginInfos[index].loginTime=GetTime();
		strcopy(loginInfos[index].loginSteamId,64,steamid);
		return;
	}
		
	for(int i=0;i<MAXPLAYERS + 1;i++)
	{
		if(loginInfos[i].loginTime!=-1)
			continue;
		
		loginInfos[i].loginTime=GetTime();
		strcopy(loginInfos[i].loginSteamId,64,steamid);
		return;
	}
}

public void RemoveLoginInfo(char [] steamid)
{
	for(int i=0;i<MAXPLAYERS + 1;i++)
	{
		if(loginInfos[i].loginTime==-1)
			continue;
		
		if(StrEqual(loginInfos[i].loginSteamId, steamid, false))
		{
			loginInfos[i].loginTime=-1;
			strcopy(loginInfos[i].loginSteamId,64,"");
			return;
		}
	}
}

public int GetLoginTime(char [] steamid)
{
	for(int i=0;i<MAXPLAYERS + 1;i++)
	{
		if(loginInfos[i].loginTime==-1)
			continue;
		
		if(StrEqual(loginInfos[i].loginSteamId, steamid, false))
		{
			return loginInfos[i].loginTime;
		}
		
	}
	return -1;
}

public Action Event_PlayerConnect(Handle hEvent, const char[] strName, bool bDontBroadcast) {
	char id[32];
	char name[64];
	GetEventString(hEvent,"networkid",id,32);
	GetEventString(hEvent,"name",name,64);

	if(StrEqual(id,"BOT",false))
		return Plugin_Handled;

	PrintToServer(">>>[Database] Player Connect : %s--%s!######################################",id,name);
	PutLoginInfo(id);//将当前id加入字典

	//登录用户的名称等基本信息
	char query[1024];
	Format(query, 
		sizeof(query), 
		"INSERT INTO players_basic (steam_id,user_name) VALUES ('%s','%s') ON DUPLICATE KEY UPDATE user_name=VALUES(user_name)",
		id,
		name);
	
	SendSQLUpdate(query);
	
	return Plugin_Continue;
}


public Action Event_PlayerDisconnect(Handle hEvent, const char[] strName, bool bDontBroadcast) {
	char id[32];
	char name[64];
	
	GetEventString(hEvent,"networkid",id,32);
	GetEventString(hEvent,"name",name,64);

	if(StrEqual(id,"BOT",false))
		return Plugin_Handled;

	int loginTime=GetLoginTime(id);
	if(loginTime==-1)
		return Plugin_Handled;
	
	int online_duration=GetTime()-loginTime;

	char query[1024];
	// 更新用户总游戏时间
	Format(query, 
		sizeof(query), 
		"INSERT INTO players_basic (steam_id,total_play_time) VALUES ('%s',%d) ON DUPLICATE KEY UPDATE total_play_time=total_play_time+%d",
		id,
		online_duration,
		online_duration);
	SendSQLUpdate(query);

	//更新用户的最长在线时间
	Format(query,
			sizeof(query),
			"UPDATE players_basic SET max_online_time=%d WHERE steam_id='%s' AND max_online_time<%d",
			online_duration,
			id,
			online_duration);
	SendSQLUpdate(query);

	RemoveLoginInfo(id);//将当前id移出字典
	PrintToServer(">>>[Database] Player DisConnect :%s--%s--%d!######################################",id,name,online_duration);
	
	return Plugin_Continue;
}
