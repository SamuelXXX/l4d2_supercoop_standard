#include <sourcemod>
#include <sdktools>

Database gDatabase=INVALID_HANDLE;

public Plugin myinfo =
{
	name = "Login info Printer",
	author = "SamaelXXX",
	description = "Print basic info of login players",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("player_connect",Event_PlayerConnect);
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

public void SendSQLQuery(const char[] query)
{
	if (gDatabase == INVALID_HANDLE)
        return;

	gDatabase.Query(SQLQueryCheckCallback, query);
}

public void SQLQueryCheckCallback(Database db, DBResultSet results, const char[] error,any data)
{
	if (db == INVALID_HANDLE)
        return;

    if(!StrEqual("", error))
        PrintToServer("SQL Error: %s", error);
	else
	{
		int total_time=0;
		while(results.FetchRow())
		{
			total_time=results.FetchInt(0);
		}

		if(total_time==0)
		{
			PrintToChatAll("该玩家尚未玩过群服，请诸位大佬耐心引导哦！");
		}
		else
		{
			char time_str[32];
			FormatDuration(time_str,32,total_time);
			PrintToChatAll("该玩家群服游戏时长：\x06%s",time_str);
		}
	}
}

void FormatDuration(char[] buffer,int maxLength,int duration)
{
	if(duration<60)
	{
		Format(buffer,maxLength,"%d 秒",duration);
	}
	else if(duration<3600)
	{
		Format(buffer,maxLength,"%d 分钟",duration/60);
	}
	else
	{
		float f_duration=float(duration);
		f_duration=f_duration/3600.0;
		Format(buffer,maxLength,"%.1f 小时",f_duration);
	}
}


public Action Event_PlayerConnect(Handle hEvent, const char[] strName, bool bDontBroadcast) {
	char id[32];
	char name[64];
	GetEventString(hEvent,"networkid",id,32);
	GetEventString(hEvent,"name",name,64);

	if(StrEqual(id,"BOT",false))
		return Plugin_Handled;

	//登录用户的名称等基本信息
	char query[1024];
	Format(query, 
		sizeof(query), 
		"SELECT total_play_time FROM players_basic WHERE steam_id='%s'",
		id);
	
	SendSQLQuery(query);
	
	return Plugin_Continue;
}
