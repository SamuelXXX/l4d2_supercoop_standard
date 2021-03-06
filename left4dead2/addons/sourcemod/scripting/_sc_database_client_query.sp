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
	My_Time,
	My_Kill,
	My_Campaign,

	Team_Total_Time,
	Team_Max_Time,
	Team_Max_Kills,
	Team_Campaign,


	Rank_Total_Time,
	Rank_Max_Time,
	Rank_Max_Kills,
	Rank_Total_Kills,
	Rank_Campaign,
	Rank_Efficiency
}

public void OnPluginStart()
{
	RegConsoleCmd("sm_my_time", CMD_MyTime);
	RegConsoleCmd("sm_my_kills",CMD_MyKill);
	RegConsoleCmd("sm_my_campaign",CMD_MyCampaign);

	RegConsoleCmd("sm_team_total_time", CMD_TeamTotalTime);
	RegConsoleCmd("sm_team_max_time",CMD_TeamMaxTime);
	RegConsoleCmd("sm_team_max_kills",CMD_TeamMaxKills);

	RegConsoleCmd("sm_rank_total_time",CMD_RankTotalTime);
	RegConsoleCmd("sm_rank_max_time",CMD_RankMaxTime);
	RegConsoleCmd("sm_rank_max_kills",CMD_RankMaxKills);
	RegConsoleCmd("sm_rank_total_kills",CMD_RankTotalKills);
	RegConsoleCmd("sm_rank_campaign",CMD_RankCampaign);
	RegConsoleCmd("sm_rank_efficiency",CMD_RankEfficiency);
}

Action CMD_MyTime(int client,int args)
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
	
	StartSQLSession(client,My_Time,query);
	return Plugin_Handled;
}

Action CMD_MyKill(int client,int args)
{
	char steamid[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[1024];
	Format(query, 
		sizeof(query), 
		"SELECT players_kill.*,players_basic.total_play_time FROM players_kill,players_basic WHERE players_kill.steam_id='%s' AND players_basic.steam_id='%s'",
		steamid,steamid);
	
	StartSQLSession(client,My_Kill,query);
	return Plugin_Handled;
}

Action CMD_MyCampaign(int client,int args)
{
	char steamid[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[1024];
	Format(query, 
		sizeof(query), 
		"SELECT c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14 FROM players_campaign WHERE steam_id='%s'",
		steamid);
	
	StartSQLSession(client,My_Campaign,query);
	return Plugin_Handled;
}




Action CMD_TeamMaxKills(int client,int args)
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
	
	StartSQLSession(client,Team_Max_Kills,query);
	return Plugin_Handled;
}

Action CMD_TeamTotalTime(int client,int args)
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
	
	StartSQLSession(client,Team_Total_Time,query);
	return Plugin_Handled;
}

Action CMD_TeamMaxTime(int client,int args)
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
	
	StartSQLSession(client,Team_Max_Time,query);
	return Plugin_Handled;
}


Action CMD_RankTotalTime(int client,int args)
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
	
	StartSQLSession(client,Rank_Total_Time,query);
	return Plugin_Handled;
}

Action CMD_RankMaxTime(int client,int args)
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
	
	StartSQLSession(client,Rank_Max_Time,query);
	return Plugin_Handled;
}

Action CMD_RankMaxKills(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[600];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,max_specials_killed FROM players_kill ORDER BY max_specials_killed DESC LIMIT 20");
	
	StartSQLSession(client,Rank_Max_Kills,query);
	return Plugin_Handled;
}

Action CMD_RankTotalKills(int client,int args)
{
	char steamid[32];
	char username[50];

	GetClientName(client,username,50);
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid),false);

	char query[1024];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,total_spitter_killed + total_boomer_killed + total_smoker_killed + total_jockey_killed + total_charger_killed + total_hunter_killed + total_witch_killed AS total FROM players_kill ORDER BY total DESC LIMIT 20");
	
	StartSQLSession(client,Rank_Total_Kills,query);
	return Plugin_Handled;
}

Action CMD_RankCampaign(int client,int args)
{
	char query[1024];
	Format(query, 
		sizeof(query), 
		"SELECT user_name,c1+c2+c3+c4+c5+c6+c7+c8+c9+c10+c11+c12+c13+c14 AS total FROM players_campaign ORDER BY total DESC LIMIT 20");
	
	StartSQLSession(client,Rank_Campaign,query);
	return Plugin_Handled;
}

Action CMD_RankEfficiency(int client,int args)
{
	char query[]="SELECT players_kill.user_name,players_kill.total_specials_killed*3600/players_basic.total_play_time AS data FROM players_kill,players_basic WHERE players_basic.steam_id=players_kill.steam_id AND players_basic.total_play_time >3600 ORDER BY data DESC LIMIT 20";
	
	StartSQLSession(client,Rank_Efficiency,query);
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
			case My_Time:
			{
				PRINT_MyTime(client,results);
			}

			case My_Kill:
			{
				PRINT_MyKill(client,results);
			}

			case My_Campaign:
			{
				PRINT_MyCampaign(client,results);
			}



			case Team_Total_Time:
			{
				PRINT_TeamTotalTime(client,results);
			}

			case Team_Max_Time:
			{
				PRINT_TeamMaxTime(client,results);
			}

			case Team_Max_Kills:
			{
				PRINT_TeamMaxKills(client,results);
			}


				
			case Rank_Total_Time:
			{	
				PRINT_RankTotalTime(client,results);
			}

			case Rank_Max_Time:
			{
				PRINT_RankMaxTime(client,results);
			}

			case Rank_Max_Kills:
			{
				PRINT_RankMaxKills(client,results);
			}

			case Rank_Total_Kills:
			{
				PRINT_RankTotalKills(client,results);
			}

			case Rank_Campaign:
			{
				PRINT_RankCampaign(client,results);
			}

			case Rank_Efficiency:
			{
				PRINT_RankEfficiency(client,results);
			}

			
		}
	}
	delete results;
	delete db;
}

void PRINT_MyTime(int client,DBResultSet results)
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

void PRINT_MyKill(int client,DBResultSet results)
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

		int total_killed=total_spitter_killed+
					total_boomer_killed+
					total_smoker_killed+
					total_jockey_killed+
					total_charger_killed+
					total_hunter_killed+
					total_witch_killed;
		PrintToChat(client,"\x01历史特感击杀总数合计：\x03%d",total_killed);
		PrintToChat(client,"\x01特感击杀效率：\x03%d 只/小时",total_killed*3600/results.FetchInt(13));

		max_specials_killed=results.FetchInt(9);	PrintToChat(client,"\x01单局最高特感击杀数：\x03%d",max_specials_killed);
		total_infected_killed=results.FetchInt(10);	PrintToChat(client,"\x01历史普通感染者击杀总数：\x03%d",total_infected_killed);
		max_infected_killed=results.FetchInt(11);	PrintToChat(client,"\x01单局最高普通感染者击杀总数：\x03%d",max_infected_killed);
	}

	delete results;
}


void PRINT_MyCampaign(int client,DBResultSet results)
{
	char formatLog[]="\x04%s\x01通关总数：\x03%d"
	bool hasValue=false;

	while(results.FetchRow())
	{
		int i=0;
		int sum=0;
		PrintToChat(client,formatLog,"死亡中心",	i=results.FetchInt(0)); sum+=i;
		PrintToChat(client,formatLog,"黑色狂欢节",	i=results.FetchInt(1)); sum+=i;
		PrintToChat(client,formatLog,"沼泽激战",	i=results.FetchInt(2)); sum+=i;
		PrintToChat(client,formatLog,"暴风骤雨",	i=results.FetchInt(3)); sum+=i;
		PrintToChat(client,formatLog,"教区",		i=results.FetchInt(4)); sum+=i;
		PrintToChat(client,formatLog,"短暂时刻",	i=results.FetchInt(5)); sum+=i;
		PrintToChat(client,formatLog,"牺牲",		i=results.FetchInt(6)); sum+=i;
		PrintToChat(client,formatLog,"毫不留情",	i=results.FetchInt(7)); sum+=i;
		PrintToChat(client,formatLog,"坠机险途",	i=results.FetchInt(8)); sum+=i;
		PrintToChat(client,formatLog,"死亡丧钟",	i=results.FetchInt(9)); sum+=i;
		PrintToChat(client,formatLog,"静寂时分",	i=results.FetchInt(10)); sum+=i;
		PrintToChat(client,formatLog,"血腥收获",	i=results.FetchInt(11)); sum+=i;
		PrintToChat(client,formatLog,"刺骨寒溪",	i=results.FetchInt(12)); sum+=i;
		PrintToChat(client,formatLog,"临死一搏",	i=results.FetchInt(13)); sum+=i;
		

		PrintToChat(client,"\x01全部战役通关总数合计：\x03%d",sum);
		hasValue=true;
	}

	if(!hasValue)
	{
		PrintToChat(client,"未查询到任何通关记录");
	}

	delete results;
}

void PRINT_RankTotalTime(int client,DBResultSet results)
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

void PRINT_RankMaxTime(int client,DBResultSet results)
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

void PRINT_RankMaxKills(int client,DBResultSet results)
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

void PRINT_RankTotalKills(int client,DBResultSet results)
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

void PRINT_RankCampaign(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===终局通关总数排行榜===");
	
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

void PRINT_RankEfficiency(int client,DBResultSet results)
{
	int rank=1;
	PrintToChat(client,"===特感击杀效率排行榜===");
	
	while(results.FetchRow())
	{
		char username[100];
		results.FetchString(0,username,100);

		int max=results.FetchInt(1);

		PrintToChat(client,"\x01%d：\x03%s-\x04%d\x01只/小时",rank,username,max);
		rank++;
	}

	PrintToChat(client,"======================");
	delete results;
}

void PRINT_TeamTotalTime(int client,DBResultSet results)
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

void PRINT_TeamMaxTime(int client,DBResultSet results)
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

void PRINT_TeamMaxKills(int client,DBResultSet results)
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

