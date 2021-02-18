#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

static const char DATABASE_CONF_NAME[] = "supercoop";
static const char TABLE_BASIC_INFO[] = "players_basic";
static const char DATABASE_CHARSET[]="utf8";


public Plugin myinfo =
{
	name = "Super Coop Server DataBase Query for all Clients",
	author = "SamaelXXX",
	description = "Manage basic info of all connected players",
	version = "1",
	url = ""
};

enum SQLSessionType
{
	MyRecord=1,
	TotalTimeRanks=2,
	MaxOnlineTimeRanks=3
}

public void OnPluginStart()
{
	RegConsoleCmd("sm_myrecord", CmdMyRecord);
	RegConsoleCmd("sm_total_time_ranks",CmdTotalTimeRanks);
	RegConsoleCmd("sm_max_online_time_ranks",CmdMaxOnlineTimeRanks);
}

Action CmdMyRecord(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[600];
	Format(query, 
		sizeof(query), 
		"SELECT max_online_time,total_play_time FROM %s WHERE steam_id='%s'",
		TABLE_BASIC_INFO,
		steamid);
	
	StartSQLSession(client,MyRecord,query);
	return Plugin_Handled;
}

Action CmdTotalTimeRanks(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[600];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,total_play_time FROM %s ORDER BY total_play_time DESC LIMIT 10",
		TABLE_BASIC_INFO,
		steamid);
	
	StartSQLSession(client,TotalTimeRanks,query);
	return Plugin_Handled;
}

Action CmdMaxOnlineTimeRanks(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[600];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,max_online_time FROM %s ORDER BY max_online_time DESC LIMIT 10",
		TABLE_BASIC_INFO,
		steamid);
	
	StartSQLSession(client,MaxOnlineTimeRanks,query);
	return Plugin_Handled;
}


void StartSQLSession(int client,int session_type,const char[] query)
{
	DataPack dp=new DataPack();
	dp.WriteCell(client);
	dp.WriteCell(session_type);
	dp.WriteString(query);

	PrintToChat(client,"查询中，请稍候...");
	Database.Connect(OnSQLServerConnected, DATABASE_CONF_NAME, dp);
}

void OnSQLServerConnected(Database db, const char[] error,any data)
{
	DataPack dp=view_as<DataPack>(data);
	dp.Reset();

	int client=dp.ReadCell();
	dp.ReadCell();
	char query[400];
	dp.ReadString(query,400);

	if(db==null)
	{
		PrintToChat(client,"数据查询失败:%s",error);
	}
	else
	{
		//PrintToChat(client,"Database connect succeed!");
		db.SetCharset(DATABASE_CHARSET);
		db.Query(OnReceiveResult, query, dp);
	}
}

void OnReceiveResult(Database db, DBResultSet results, const char[] error, DataPack dp)
{
	dp.Reset();

	int client=dp.ReadCell();
	int session_type=dp.ReadCell();

	delete dp;

	if (db == null || results == null || error[0] != '\0')
    {
        PrintToChat(client,"数据查询失败:%s", error);
    }
	else
	{
		switch(session_type)
		{
			case MyRecord:
			{
				PrintMyRecordResult(client,results);
			}
				
			case TotalTimeRanks:
			{	
				PrintTotalTimeRanksResult(client,results);
			}

			case MaxOnlineTimeRanks:
			{
				PrintMaxOnlineRanksResult(client,results);
			}
		}
	}
	delete results;
	delete db;
}

void PrintMyRecordResult(int client,DBResultSet results)
{
	while(results.FetchRow())
	{
		int max_online_time=results.FetchInt(0);
		int total_time=results.FetchInt(1);
		char max_time_str[30];
		char total_time_str[30];
		FormatDuration(max_time_str,sizeof(max_time_str),max_online_time);
		FormatDuration(total_time_str,sizeof(total_time_str),total_time);
		PrintToChat(client,"\x01最长在线时间：\x03%s",max_time_str);
		PrintToChat(client,"\x01总游玩时间：\x03%s",total_time_str);
	}

	delete results;
}

void PrintTotalTimeRanksResult(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===总游戏时长排行榜===");
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);
		int total_time=results.FetchInt(1);
		char total_time_str[30];
		FormatDuration(total_time_str,sizeof(total_time_str),total_time);

		PrintToChat(client,"\x01%d：\x03%s-%s",rank,username,total_time_str);
		rank++;
	}
	PrintToChat(client,"======================");
	delete results;
}

void PrintMaxOnlineRanksResult(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===单次游戏时长排行榜===");
	
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);

		int total_time=results.FetchInt(1);
		char total_time_str[30];

		FormatDuration(total_time_str,sizeof(total_time_str),total_time);

		PrintToChat(client,"\x01%d：\x03%s-%s",rank,username,total_time_str);
		rank++;
	}

	PrintToChat(client,"======================");
	delete results;
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

