#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

ConVar MinTimeCVAR,MaxTimeCVAR,ShowMsgCVAR;

Handle mapTickHandler,delayStopTickHandler,delayStart;

public Plugin myinfo =
{
	name = "Tank Spawner",
	author = "SamaelXXX",
	description = "Spawn tank along the way",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	char sGame[32];
	GetGameFolderName(sGame, sizeof(sGame));

	if (!StrEqual(sGame, "left4dead2", false))
		SetFailState("Plugin supports Left 4 Dead 2 only.");


	MinTimeCVAR=CreateConVar("min_time_spawn_tank","300","Min time trigger tank spawn",FCVAR_NOTIFY);
	MaxTimeCVAR=CreateConVar("max_time_spawn_tank","500","Max time trigger tank spawn",FCVAR_NOTIFY);
	ShowMsgCVAR=CreateConVar("tank_spawner_show_msg","0","Should Log out Message",FCVAR_NOTIFY);
}



public void OnMapStart()
{
	//PrintDebugMessage("Map Start");
	delayStart=CreateTimer(20.0,DelayStart);
}

public Action DelayStart(Handle timer)
{
	//PrintDebugMessage("Start Map Tick Routine");
	delete mapTickHandler;//保证一次只有一个tick timer
	float random_time=GenerateRandomTime();
	PrintToServer(">>>[TankSpawner] Spawn Time:%f",random_time);
	mapTickHandler = CreateTimer(random_time,MapTickHandleRoutine,_,TIMER_REPEAT);
}

public void OnMapEnd()
{
	//PrintDebugMessage("Map End");
	delete mapTickHandler;
	delete delayStopTickHandler;
}

stock float GenerateRandomTime()
{
	float minTime=MinTimeCVAR.FloatValue;
	float maxTime=MaxTimeCVAR.FloatValue;
	PrintToServer(">>>[TankSpawner] Min Time:%f",minTime);
	PrintToServer(">>>[TankSpawner] Max Time:%f",maxTime);

	float r=GetURandomFloat();
	return minTime+(maxTime-minTime)*r;
}

stock void ReleaseTankWave()
{
	PrintDebugMessage("允许Tank生成");
	ServerCommand("sm_cvar director_force_tank 1");
}

stock void CloseTankWave()
{
	PrintDebugMessage("禁止Tank生成");
	ServerCommand("sm_cvar director_force_tank 0");
}

Action DelayStopTankWave(Handle timer)
{
	if(IsAliveTankInPlay())
	{
		CloseTankWave();
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

stock bool IsAliveTankInPlay()
{
	char name[32];
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsSurvivor(i))
			continue;

		if(!IsClientInGame(i))
			continue;
			
		if(!IsPlayerAlive(i))
			continue;
		
		if(GetClientName(i, name, sizeof(name)))
		{	
			if(StrContains(name,"Tank",false)!=-1)
			{
				return true;
			}
		}	
			
	}

	return false;
}


public Action MapTickHandleRoutine(Handle timer)
{
	//PrintDebugMessage("Map Ticking");
	if(!IsAliveTankInPlay())
	{
		PrintDebugMessage("当前无tank，即将解禁tank的生成！");
		ReleaseTankWave();
		delayStopTickHandler = CreateTimer(5.0,DelayStopTankWave,_,TIMER_REPEAT);
	}

	return Plugin_Continue;
}

stock bool IsSurvivor(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2 && IsClientConnected(client));
}

stock bool PrintDebugMessage(const char[] msg)
{
	int showMsg=GetConVarInt(ShowMsgCVAR);
	if(showMsg==1)
		PrintToChatAll(msg);
}
