#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define ZOEY 0
#define LOUIS 1
#define FRANCIS 2
#define BILL 3
#define ROCHELLE 4
#define COACH 5
#define ELLIS 6
#define NICK 7

public Plugin myinfo =
{
	name = "Important Event Display",
	author = "SamaelXXX",
	description = "As titled",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("rescue_door_open",Event_OpenRescueDoor,EventHookMode_Post);	
	HookEvent("heal_success",Event_Healing,EventHookMode_Post);
	HookEvent("revive_success", Event_ReviveSuccess,EventHookMode_Post);
	HookEvent("player_death", Event_PlayerDeath,EventHookMode_Post);
	HookEvent("round_start", Event_RoundStart,EventHookMode_Post);

	//HookEvent("tank_spawn", Event_TankSpawn,EventHookMode_Post);
	//HookEvent("tank_killed", Event_TankKilled,EventHookMode_Post);

	HookEvent("player_use",Event_PlayerUse,EventHookMode_Post);	
	HookEvent("finale_start",Event_FinaleStart,EventHookMode_Post);	
	HookEvent("gauntlet_finale_start",Event_GauntletFinaleStart,EventHookMode_Post);	
	// HookEvent("finale_escape_start",Event_FinaleStart,EventHookMode_Post);	
	HookEvent("triggered_car_alarm",Event_TriggerCarAlarm,EventHookMode_Post);

	ClearAllReviveCount();
}

public void OnMapStart()
{
	ClearAllReviveCount();
}

public void Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	ClearAllReviveCount();
}

public void Event_OpenRescueDoor(Handle event, const char[] name, bool dontBroadcast)
{
	char user_name[32];
	get_user_name(event,user_name,32);
	display_event(user_name,"打开了复活门！");
}

public void Event_Healing(Handle event, const char[] name, bool dontBroadcast)
{
	int user_id=GetEventInt(event,"userid");
	int subject_id=GetEventInt(event,"subject");
	int health_restored=GetEventInt(event,"health_restored");

	int client=GetClientOfUserId(user_id);
	int revive_count=GetReviveCount(client);
	//PrintToServer("revive count %d",revive_count);
	bool in_black_white= (revive_count == FindConVar("survivor_max_incapacitated_count").IntValue);


	if(user_id==subject_id)
	{
		char user_name[32];
		get_user_name(event,user_name,32);
		if(health_restored<=60)
		{
			PrintToChatAll("\x03[虾皮行为检测器] \x04%s\x01绿血恰包-回复血量：\x05%d，\x01您是魔鬼吗！！！",user_name,health_restored);
		}
		else if(health_restored<99)
		{
			PrintToChatAll("\x03[虾皮行为检测器] \x04%s\x01尚未倒地就打包-回复血量：\x05%d，\x01医疗包很珍贵，且打且珍惜！",user_name,health_restored);
		}	
		// else if(!in_black_white)
		// {
		// 	PrintToChatAll("\x03[虾皮行为检测器] \x04%s\x01尚未黑白就打包-倒地次数累计：\x05%d，\x01医疗包的正确用法是黑白再使用哦！",user_name,revive_count);
		// }	
	}
	ClearReviveCount(client);
}

public void Event_ReviveSuccess(Handle event, const char[] name, bool dontBroadcast)
{
	if(GetEventInt(event,"ledge_hang") != 0)
		return;

	int user_id=GetEventInt(event,"subject");
	int client=GetClientOfUserId(user_id);
	AddReviveCount(client);
}

public void Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int user_id=GetEventInt(event,"userid");
	int client=GetClientOfUserId(user_id);
	ClearReviveCount(client);
}

public void Event_PlayerUse(Handle event, const char[] name, bool dontBroadcast)
{
	char user_name[32];
	get_user_name(event,user_name,32);
	int target_id=GetEventInt(event,"targetid");
	char target_class[32];
	GetEntityClassname(target_id,target_class,32);

	if(StrEqual(target_class,"func_button",true))
	{
		display_event(user_name,"触发了机关！")
	}

	if(StrEqual(target_class,"trigger_finale",true))
	{
		display_event(user_name,"触发了终局开关！")
	}
}

public void Event_TankSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int tank_count=TankCount();
	PrintToChatAll("\x03[系统提示] \x01新Tank出现，当前在场Tank数量：\x05%d！",tank_count);
}

stock bool IsAliveTank(int client)
{
	if(IsClientInGame(client) && IsPlayerAlive(client) && (GetClientTeam(client) == 3))
	{
		char client_name[32];
		GetClientName(client,client_name,32);
		if(StrContains(client_name, "Tank", false) > 0) 
		{
			return true;
		}
	}
	return false;
}

stock int TankCount()
{
	int tank_count=0;
	for(int i=1;i<=MaxClients;i++)
	{
		if(IsAliveTank(i))
			tank_count++;
	}
	return tank_count;
}	

public void Event_TankKilled(Handle event, const char[] name, bool dontBroadcast)
{
	int tank_count=TankCount();
	PrintToChatAll("\x03[系统提示] \x01Tank死亡，当前在场Tank数量：\x05%d！",tank_count);
}

int revive_count[8];

stock int ClientToReviveIndex(int client)
{
	if(!IsAliveSurvivor(client))
		return -1;
	
	char model[128]; 
	GetClientModel(client, model, sizeof(model));
	
	//fill string with character names
	if(StrContains(model, "teenangst", false) > 0) 
	{
		return ZOEY;
	}
	else if(StrContains(model, "biker", false) > 0)
	{
		return FRANCIS;
	}
	else if(StrContains(model, "manager", false) > 0)
	{
		return LOUIS;
	}
	else if(StrContains(model, "namvet", false) > 0)
	{
		return BILL;
	}
	else if(StrContains(model, "producer", false) > 0) 
	{
		return ROCHELLE;
	}
	else if(StrContains(model, "mechanic", false) > 0)
	{
		return ELLIS;
	}
	else if(StrContains(model, "coach", false) > 0)
	{
		return COACH;
	}
	else if(StrContains(model, "gambler", false) > 0)
	{
		return NICK;
	}

	return -1;
}

stock bool IsAliveSurvivor(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client));
}

stock void ClearAllReviveCount()
{
	for(int i=1;i<=MaxClients;i++)
	{
		int index=ClientToReviveIndex(i);
		if(index==-1)
		{
			continue;
		}
		int health=GetClientHealth(i);
		if(health>1)
		{
			//PrintToServer("Clear Revive Count");
			revive_count[index]=0;
		}	
	}
}

stock int GetReviveCount(int client)
{
	if(!IsAliveSurvivor(client))
		return 0;
	
	int index = ClientToReviveIndex(client);
	if(index==-1)
		return 0;
	return revive_count[index];
}

stock void AddReviveCount(int client)
{
	if(!IsAliveSurvivor(client))
		return;
	
	int index = ClientToReviveIndex(client);
	if(index==-1)
		return;

	revive_count[index]=revive_count[index]+1;
}

stock void ClearReviveCount(int client)
{
	if(!IsAliveSurvivor(client))
		return;
	
	int index = ClientToReviveIndex(client);
	if(index==-1)
		return;
		
	revive_count[index]=0;
}

public void Event_FinaleStart(Handle event, const char[] name, bool dontBroadcast)
{
	PrintToChatAll("\x03[终局提示] \x01防守终局已经启动，准备开始防守！");
}

public void Event_GauntletFinaleStart(Handle event, const char[] name, bool dontBroadcast)
{
	PrintToChatAll("\x03[终局提示] \x01跑图终局已经启动，准备开始跑图！");
}

public void Event_TriggerCarAlarm(Handle event, const char[] name, bool dontBroadcast)
{
	char user_name[32];
	get_user_name(event,user_name,32);
	display_event(user_name,"打响了警报车！")
	
}

stock void display_event(const char[] name,const char[] behaviour)
{
	PrintToChatAll("\x03[虾皮行为检测器] \x04%s\x01%s",name,behaviour)
}

stock int get_user_name(Handle event,char[] name,int len)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	GetClientName(client,name,len);
}