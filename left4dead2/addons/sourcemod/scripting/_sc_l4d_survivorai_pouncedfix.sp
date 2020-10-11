#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.0.5"
#define PLUGIN_NAME "L4D Survivor AI Pounced Fix"


public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = " AtomicStryker ",
	description = " Fixes Survivor Bots neglecting Teammates in need ",
	version = PLUGIN_VERSION,
	url = ""
};

#define MAX_CLIENT 32

static bool IsL4D2 = false;

int botInSavingTask[MAX_CLIENT+1];
bool botInAggrTask[MAX_CLIENT+1];
Handle AggressiveAITickHandler;
ConVar CVar_MaxSaviour;

public void OnPluginStart()
{
	HookEvent("tongue_grab", Event_TongueGrab);
	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("round_start",Event_RoundStart,EventHookMode_Post);	
	HookEvent("player_bot_replace", Event_PlayerToBot, EventHookMode_Post);

	CreateConVar("l4d_survivoraipouncedfix_version", PLUGIN_VERSION, " Version of L4D Survivor AI Pounced Fix on this server ", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	CVar_MaxSaviour=CreateConVar("l4d_max_saviour", "3", " How many savivor will help you ", FCVAR_NOTIFY);
	
	CheckGame();
}

public void Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	PrintToServer(">>>[SaviourAI] Round Start!!!");
	ResetBotState();
	delete AggressiveAITickHandler;
	AggressiveAITickHandler=CreateTimer(1,AggressiveAITick,_,TIMER_REPEAT);
}

public Action AggressiveAITick(Handle timer)
{
	for(int i=1;i<MAX_CLIENT+1;i++)
	{
		if(!IsFreeSurvivorBot(i))//不是有自由行动能力的电脑
			continue;
		
		if(botInSavingTask[i]!=-1)//正在进行救援队友的任务，不可打断
			continue;
		
		if(botInAggrTask[i])
			continue;
		
		StartAggressiveTask(i);
	}
	return Plugin_Continue;
}

stock void StartAggressiveTask(int bot)
{
	botInAggrTask[bot]=true;
	CreateTimer(1,AggressiveTaskRoutine,bot,TIMER_REPEAT);
}

stock Action AggressiveTaskRoutine(Handle timer,int bot)
{
	if(!IsFreeSurvivorBot(bot))//不是有自由行动能力的电脑
	{
		botInAggrTask[bot]=false;
		return Plugin_Stop;
	}
		
	if(botInSavingTask[bot]!=-1)//正在进行救援队友的任务，不可打断
	{
		botInAggrTask[bot]=false;
		return Plugin_Stop;
	}
	
	int threat=FindNearThreat(bot);
	if(threat!=-1)
	{
		char botName[32];
		char threatName[32];

		GetClientName(bot,botName,32);
		GetClientName(threat,threatName,32);

		//PrintToServer(">>>[AggressiveAI] %s shooting %s!!!",botName,threatName);

		ScriptCommand(bot, "script", 
		"CommandABot({cmd=0,bot=GetPlayerFromUserID(%i),target=GetPlayerFromUserID(%i)})", 
		GetClientUserId(bot), 
		GetClientUserId(threat));
	}

	return Plugin_Continue;
}

int FindNearThreat(int bot)
{
	//寻找最近的特感
	//Get all bots
	int allThreats[32];
	int threatsCount=0;
	for(int i = 1; i <= MAX_CLIENT; i++)
	{
		if(IsClientInGame(i)&&GetClientTeam(i)!=2&&IsPlayerAlive(i))
			allThreats[threatsCount++]=i;
	}

	float position[3];
	GetClientAbsOrigin(bot, position);
	float closeDistance=99999.0;
	int closeIndex=-1;
	for(int j=0;j<threatsCount;j++)
	{
		int threat=allThreats[j];
		if(threat<=0)			
			continue;

		float threatPos[3];
		GetClientAbsOrigin(threat, threatPos);

		float dis=GetVectorDistance(threatPos, position);
		if(dis < closeDistance)
		{
			closeDistance=dis;
			closeIndex=j;
		}
	}
	
	if(closeIndex != -1)
	{
		return allThreats[closeIndex];	
	}

	return -1;

}



public void Event_PlayerToBot(Handle hEvent, const char[] sName, bool bDontBroadcast)// CreateFakeClient this is called after SpawnPost hook
{
	int iBot = GetClientOfUserId(GetEventInt(hEvent, "bot"));
	botInSavingTask[iBot]=-1;
	botInAggrTask[iBot]=false;
}

public Action Event_TongueGrab(Handle event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(GetEventInt(event, "victim"));
	ProtectVictim(victim);
}

public Action Event_PlayerHurt(Handle event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(GetEventInt(event, "userid"));
	ProtectVictim(victim);
}

stock void ProtectVictim(int victim)
{
	int dominator=GetDominator(victim);

	if (dominator!=-1)
	{
		for(int i=0;i<MAX_CLIENT+1;i++)
		{
			if(botInSavingTask[i]==victim)//已经派遣了电脑进行救援了
			{
				return;
			}
		}
		float dominator_position[3];
		GetClientAbsOrigin(dominator, dominator_position);

		int saviourCount=CVar_MaxSaviour.IntValue;
		int[] saviours=new int[saviourCount];
		FindClosestAvailableBots(dominator_position , saviourCount, saviours);

		for(int i=0;i<saviourCount;i++)
		{
			int saviour=saviours[i];
			if(saviour==-1)
				continue;
			
			StartBotSaveTask(saviour,victim);//派遣一名电脑去营救被控者
		}
	}
}

stock void FindClosestAvailableBots(float position[3],int amount,int[] botsID)
{
	//寻找最近的几个空闲的电脑
	//Get all bots
	int allBots[32];
	int botsCount=0;
	for(int i = 1; i <= MAX_CLIENT; i++)
	{
		if(IsFreeSurvivorBot(i) && botInSavingTask[i]==-1)
			allBots[botsCount++]=i;
	}

	if(botsCount<=amount)
	{
		//Direct Copy and Return
		for(int i=0;i<amount;i++)
		{
			if(i<botsCount)
			{
				botsID[i]=allBots[i];
			}
			else
			{
				botsID[i]=-1;
			}
		}
		return;
	}

	for(int i=0;i<amount;i++)
	{
		botsID[i]=-1;
		float closeDistance=99999.0;
		int closeIndex=-1;
		for(int j=0;j<botsCount;j++)
		{
			int bot=allBots[j];
			if(bot==-1)			
				continue;

			float botPos[3];
			GetClientAbsOrigin(bot, botPos);

			float dis=GetVectorDistance(botPos, position);
			if(dis < closeDistance)
			{
				closeDistance=dis;
				closeIndex=j;
			}
		}
		
		if(closeIndex != -1)
		{
			botsID[i]=allBots[closeIndex];
			allBots[closeIndex]=-1;		
		}
	}
}

stock void ResetBotState()
{
	for(int i=0;i<MAX_CLIENT+1;i++)
	{
		botInSavingTask[i]=-1;
		botInAggrTask[i]=false;
	}
}

stock void StartBotSaveTask(int bot, int saveTarget)
{
	if(!IsFreeSurvivorBot(bot))//不是一个行动自由的电脑
		return;
	
	if(DoSaveTeamMate(bot,saveTarget))
	{
		botInSavingTask[bot]=saveTarget;

		int attacker=GetDominator(saveTarget);
		if(attacker==-1)
			return;
		
		char botName[32];
		char saveTargetName[32];
		char attackName[32];

		GetClientName(bot,botName,32);
		GetClientName(saveTarget,saveTargetName,32);
		GetClientName(attacker,attackName,32);

		//PrintToServer(">>>[SaviourAI] %s start saving %s from %s!!!",botName,saveTargetName,attackName);

		DataPack pack;
		CreateDataTimer(1,ContinousSaveRoutine,pack,TIMER_REPEAT);
		pack.WriteCell(bot);
		pack.WriteCell(saveTarget);	
	}
	else
	{
		botInSavingTask[bot]=-1;
	}
}

stock Action ContinousSaveRoutine(Handle timer,DataPack pack)
{
	pack.Reset();

	int bot=pack.ReadCell();
	int saveTarget=pack.ReadCell();

	if(!IsFreeSurvivorBot(bot))//不在是行动自由的电脑，或者被玩家控制
	{
		// char botName[32];
		// char saveTargetName[32];

		// GetClientName(bot,botName,32);
		// GetClientName(saveTarget,saveTargetName,32);
		//PrintToServer(">>>[SaviourAI] %s stop saving %s because it is no longer a free survivor bot!!!",botName,saveTargetName);
		botInSavingTask[bot]=-1;
		return Plugin_Stop;
	}
		
	if(!DoSaveTeamMate(bot,saveTarget))//目标队友已经解控
	{
		// char botName[32];
		// char saveTargetName[32];

		// GetClientName(bot,botName,32);
		// GetClientName(saveTarget,saveTargetName,32);
		//PrintToServer(">>>[SaviourAI] %s stop saving %s because target is successfully saved!!!",botName,saveTargetName);
		botInSavingTask[bot]=-1;
		return Plugin_Stop;
	} 
	return Plugin_Continue;
}

stock bool DoSaveTeamMate(int bot, int saveTarget)
{
	//执行救援队友任务，如果队友需要救援就返回true，反之返回false
	int attacker=GetDominator(saveTarget);
	if(attacker==-1)
		return false;
	
	ScriptCommand(bot, "script", 
	"CommandABot({cmd=0,bot=GetPlayerFromUserID(%i),target=GetPlayerFromUserID(%i)})", 
	GetClientUserId(bot), 
	GetClientUserId(attacker));
	return true;
}

stock int GetDominator(int client)
{
	if(HasValidEnt(client, "m_tongueOwner"))
	{
		return GetEntPropEnt(client, Prop_Send, "m_tongueOwner")
	}

	if(HasValidEnt(client, "m_pounceAttacker"))
	{
		return GetEntPropEnt(client, Prop_Send, "m_pounceAttacker")
	}

	if(HasValidEnt(client, "m_jockeyAttacker"))
	{
		return GetEntPropEnt(client, Prop_Send, "m_jockeyAttacker")
	}

	if(HasValidEnt(client, "m_pummelAttacker"))
	{
		return GetEntPropEnt(client, Prop_Send, "m_pummelAttacker")
	}

	return -1;
}

bool IsFreeSurvivorBot(int client)
{
	return IsClientInGame(client) && 
		GetClientTeam(client)==2 && 
		IsPlayerAlive(client) &&
		IsFakeClient(client) && 
		GetDominator(client)==-1 &&
		!IsIncapacitated(client);
}

stock bool IsIncapacitated(int client)
{
	if( GetEntProp(client, Prop_Send, "m_isIncapacitated", 1) > 0 )
		return true;
	return false;
}

stock bool HasValidEnt(client, const char[] entprop)
{
	int ent = GetEntPropEnt(client, Prop_Send, entprop);
	
	return (ent > 0
		&& IsClientInGame(ent));
}

stock void ScriptCommand(client, const char[] command, const char[] arguments, any ...)
{
    char vscript[PLATFORM_MAX_PATH];
    VFormat(vscript, sizeof(vscript), arguments, 4);
    
    int flags = GetCommandFlags(command);
    SetCommandFlags(command, flags^FCVAR_CHEAT);
    FakeClientCommand(client, "%s %s", command, vscript);
    SetCommandFlags(command, flags | FCVAR_CHEAT);
}

static void CheckGame()
{
	char game[32];
	GetGameFolderName(game, sizeof(game));
	
	if (StrEqual(game, "left4dead", false))
		IsL4D2 = false;
		
	else if (StrEqual(game, "left4dead2", false))
		IsL4D2 = true;
		
	else
		SetFailState("Plugin is for Left For Dead 1/2 only");
}