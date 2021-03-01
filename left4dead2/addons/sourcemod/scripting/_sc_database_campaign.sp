#include <sourcemod>
#include <sdktools>

Database gDatabase=INVALID_HANDLE;


public Plugin myinfo =
{
	name = "Super Coop Server DataBase Management for Campaign Info",
	author = "SamaelXXX",
	description = "Manage campaign info of all connected players",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("finale_win",Event_FinaleWin);
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

void GetCampaignBriefStr(char[] buffer,int maxLength)
{
	int i=0;
	while(i<maxLength)
	{
		if(buffer[i]=='m')
		{
			buffer[i]='\0';
			break;
		}
	}
}

public Action Event_FinaleWin(Handle hEvent, const char[] strName, bool bDontBroadcast) {
	char mapname[32];
	GetEventString(hEvent,"map_name",mapname,32);
	GetCampaignBriefStr(mapname,32)

	for(int i=1;i<=32;i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))	
		{
			char id[32];
			char name[64];
			GetClientAuthId(i, AuthId_Steam2, id, sizeof(id),false)
			GetClientName(i,name,sizeof(name));

			if(StrEqual(id,"BOT",false))
				continue;

			//登录用户的名称等基本信息
			char query[1024];
			Format(query, 
				sizeof(query), 
				"INSERT INTO players_campaign (steam_id,user_name,%s) VALUES ('%s','%s',1) ON DUPLICATE KEY UPDATE user_name=VALUES(user_name),%s=%s+1",
				mapname,
				id,
				name,
				mapname,
				mapname);
			
			SendSQLUpdate(query);
		}
	}
	
	return Plugin_Continue;
}
