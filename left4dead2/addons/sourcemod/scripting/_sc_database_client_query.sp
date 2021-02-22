#include <sourcemod>
#include <sdktools>


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
	MyTimeRecord,
	MyKillRecord,
	TotalTimeRanks,
	MaxOnlineTimeRanks,
	MaxSpecialKilledRanks,
	TotalSpecialKilledRanks,
	TeamTotalTimeRanks,
	TeamMaxTimeRanks,
	TeamMaxSpecialKillRanks

}

public void OnPluginStart()
{
	RegConsoleCmd("sm_mytimerecord", CmdMyTimeRecord);
	RegConsoleCmd("sm_mykillrecord",CmdMyKillRecord);

	RegConsoleCmd("sm_total_time_ranks",CmdTotalTimeRanks);
	RegConsoleCmd("sm_max_online_time_ranks",CmdMaxOnlineTimeRanks);
	RegConsoleCmd("sm_max_special_killed_ranks",CmdMaxSpecialKilledRanks);
	RegConsoleCmd("sm_total_special_killed_ranks",CmdTotalSpecialKilledRanks);

	RegConsoleCmd("sm_team_total_time", CmdTeamTotalTime);
	RegConsoleCmd("sm_team_max_time",CmdTeamMaxTime);
	RegConsoleCmd("sm_team_max_special_kills",CmdTeamMaxSpecialKills);
}

Action CmdMyTimeRecord(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[600];
	Format(query, 
		sizeof(query), 
		"SELECT max_online_time,total_play_time FROM players_basic WHERE steam_id='%s'",
		steamid);
	
	StartSQLSession(client,MyTimeRecord,query);
	return Plugin_Handled;
}

Action CmdMyKillRecord(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[1024];
	Format(query, 
		sizeof(query), 
		"SELECT * FROM players_kill WHERE steam_id='%s'",
		steamid);
	
	StartSQLSession(client,MyKillRecord,query);
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
		"SELECT user_name,total_play_time FROM players_basic ORDER BY total_play_time DESC LIMIT 20",
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
		"SELECT user_name,max_online_time FROM players_basic ORDER BY max_online_time DESC LIMIT 20",
		steamid);
	
	StartSQLSession(client,MaxOnlineTimeRanks,query);
	return Plugin_Handled;
}

Action CmdMaxSpecialKilledRanks(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[600];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,max_specials_killed FROM players_kill ORDER BY max_specials_killed DESC LIMIT 20");
	
	StartSQLSession(client,MaxSpecialKilledRanks,query);
	return Plugin_Handled;
}

Action CmdTotalSpecialKilledRanks(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[1024];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,total_spitter_killed + total_boomer_killed + total_smoker_killed + total_jockey_killed + total_charger_killed + total_hunter_killed + total_witch_killed FROM players_kill ORDER BY total_spitter_killed + total_boomer_killed + total_smoker_killed + total_jockey_killed + total_charger_killed + total_hunter_killed + total_witch_killed DESC LIMIT 20");
	
	StartSQLSession(client,TotalSpecialKilledRanks,query);
	return Plugin_Handled;
}

void FormTeamPlayersList(char[] buffer,int maxLength)
{
	bool firstInside=false;
	buffer[0]='\0';
	int len=0;
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

			if(!firstInside)
			{
				len+=Format(buffer[len], maxLength-len, "'%s'", id);
				firstInside=true;
			}
			else
			{
				len+=Format(buffer[len], maxLength-len, ",'%s'", id);
			}
		}
	}
}

Action CmdTeamMaxSpecialKills(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char team_steamid[1024];
	FormTeamPlayersList(team_steamid,sizeof(team_steamid));

	//PrintToServer(">>>Team Steam ID: %s",team_steamid);

	char query[3000];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,max_specials_killed FROM players_kill  WHERE steam_id IN (%s) ORDER BY max_specials_killed DESC",
		team_steamid);
	
	StartSQLSession(client,TeamMaxSpecialKillRanks,query);
	return Plugin_Handled;
}

Action CmdTeamTotalTime(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char team_steamid[1024];
	FormTeamPlayersList(team_steamid,sizeof(team_steamid));

	//PrintToServer(">>>Team Steam ID: %s",team_steamid);

	char query[2048];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,total_play_time FROM players_basic  WHERE steam_id IN (%s) ORDER BY total_play_time DESC",
		team_steamid);
	
	StartSQLSession(client,TeamTotalTimeRanks,query);
	return Plugin_Handled;
}

Action CmdTeamMaxTime(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char team_steamid[1024];
	FormTeamPlayersList(team_steamid,sizeof(team_steamid));

	//PrintToServer(">>>Team Steam ID: %s",team_steamid);

	char query[2048];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,max_online_time FROM players_basic  WHERE steam_id IN (%s) ORDER BY max_online_time DESC",
		team_steamid);
	
	StartSQLSession(client,TeamMaxTimeRanks,query);
	return Plugin_Handled;
}


void StartSQLSession(int client,int session_type,const char[] query)
{
	DataPack dp=new DataPack();
	dp.WriteCell(client);
	dp.WriteCell(session_type);
	dp.WriteString(query);

	PrintToChat(client,"查询中，请稍候...");
	Database.Connect(OnSQLServerConnected, "supercoop", dp);
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
		db.SetCharset("utf8");
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
			case MyTimeRecord:
			{
				PrintMyTimeRecordResult(client,results);
			}

			case MyKillRecord:
			{
				PrintMyKillRecordResult(client,results);
			}
				
			case TotalTimeRanks:
			{	
				PrintTotalTimeRanksResult(client,results);
			}

			case MaxOnlineTimeRanks:
			{
				PrintMaxOnlineRanksResult(client,results);
			}

			case MaxSpecialKilledRanks:
			{
				PrintMaxSpecialsKilledResult(client,results);
			}

			case TotalSpecialKilledRanks:
			{
				PrintTotalSpecialsKilledResult(client,results);
			}

			case TeamTotalTimeRanks:
			{
				PrintTeamTotalTimeResult(client,results);
			}

			case TeamMaxTimeRanks:
			{
				PrintTeamMaxTimeResult(client,results);
			}

			case TeamMaxSpecialKillRanks:
			{
				PrintTeamSpecialsKilledResult(client,results);
			}
		}
	}
	delete results;
	delete db;
}

void PrintMyTimeRecordResult(int client,DBResultSet results)
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

void PrintMyKillRecordResult(int client,DBResultSet results)
{
	int total_spitter_killed=0;
	int total_boomer_killed=0;
	int total_smoker_killed=0;
	int total_jockey_killed=0;

	int total_charger_killed=0;
	int total_hunter_killed=0;
	int total_witch_killed=0;

	int max_specials_killed=0;
	int total_infected_killed=0;
	int max_infected_killed=0;

	while(results.FetchRow())
	{
		total_spitter_killed=results.FetchInt(2); 	PrintToChat(client,"\x04Spitter\x01击杀总数：\x03%d",total_spitter_killed);
		total_boomer_killed=results.FetchInt(3); 	PrintToChat(client,"\x04Boomer\x01击杀总数：\x03%d",total_boomer_killed);
		total_smoker_killed=results.FetchInt(4); 	PrintToChat(client,"\x04Smoker\x01击杀总数：\x03%d",total_smoker_killed);
		total_jockey_killed=results.FetchInt(5);	PrintToChat(client,"\x04Jockey\x01击杀总数：\x03%d",total_jockey_killed);

		total_charger_killed=results.FetchInt(6);	PrintToChat(client,"\x04Charger\x01击杀总数：\x03%d",total_charger_killed);
		total_hunter_killed=results.FetchInt(7);	PrintToChat(client,"\x04Hunter\x01击杀总数：\x03%d",total_hunter_killed);
		total_witch_killed=results.FetchInt(8);		PrintToChat(client,"\x04Witch\x01击杀总数：\x03%d",total_witch_killed);
		PrintToChat(client,"\x01历史特感击杀总数合计：\x03%d",
					total_spitter_killed+
					total_boomer_killed+
					total_smoker_killed+
					total_jockey_killed+
					total_charger_killed+
					total_hunter_killed+
					total_witch_killed);

		max_specials_killed=results.FetchInt(9);	PrintToChat(client,"\x01单局最高特感击杀数：\x03%d",max_specials_killed);
		total_infected_killed=results.FetchInt(10);	PrintToChat(client,"\x01历史普通感染者击杀总数：\x03%d",total_infected_killed);
		max_infected_killed=results.FetchInt(11);	PrintToChat(client,"\x01单局最高普通感染者击杀总数：\x03%d",max_infected_killed);
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

		PrintToChat(client,"\x01%d：\x03%s-\x04%s",rank,username,total_time_str);
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

		PrintToChat(client,"\x01%d：\x03%s-\x04%s",rank,username,total_time_str);
		rank++;
	}

	PrintToChat(client,"======================");
	delete results;
}

void PrintMaxSpecialsKilledResult(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===单局特感击杀数排行榜===");
	
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);

		int max=results.FetchInt(1);

		PrintToChat(client,"\x01%d：\x03%s-\x04%d",rank,username,max);
		rank++;
	}

	PrintToChat(client,"======================");
	delete results;
}

void PrintTotalSpecialsKilledResult(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===历史特感击杀总数排行榜===");
	
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);

		int max=results.FetchInt(1);

		PrintToChat(client,"\x01%d：\x03%s-\x04%d",rank,username,max);
		rank++;
	}

	PrintToChat(client,"======================");
	delete results;
}

void PrintTeamTotalTimeResult(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===团队总游戏时长排行榜===");
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);
		int total_time=results.FetchInt(1);
		char total_time_str[30];
		FormatDuration(total_time_str,sizeof(total_time_str),total_time);

		PrintToChat(client,"\x01%d：\x03%s-\x04%s",rank,username,total_time_str);
		rank++;
	}
	PrintToChat(client,"======================");
	delete results;
}

void PrintTeamMaxTimeResult(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===团队最大在线时长排行榜===");
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);
		int total_time=results.FetchInt(1);
		char total_time_str[30];
		FormatDuration(total_time_str,sizeof(total_time_str),total_time);

		PrintToChat(client,"\x01%d：\x03%s-\x04%s",rank,username,total_time_str);
		rank++;
	}
	PrintToChat(client,"======================");
	delete results;
}

void PrintTeamSpecialsKilledResult(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===团队单局特感击杀排行榜===");
	
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);

		int max=results.FetchInt(1);

		PrintToChat(client,"\x01%d：\x03%s-\x04%d",rank,username,max);
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

