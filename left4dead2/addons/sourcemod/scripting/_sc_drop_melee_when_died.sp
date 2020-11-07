#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <l4d_info_editor>

#define TEAM_SPECTATOR	1
#define TEAM_SURVIVOR	2

static int sViceWeaponEntityTracking[MAXPLAYERS+1];
static bool printedSinceRoundStart=false;

static char MeleesInCurrentMap[16][16];
static int MeleeClassCountInCurrentMap;


public Plugin myinfo =
{
	name = "Drop Melee Weapon When Player Dead",
	author = "SamaelXXX",
	description = "Make Player Drop Melee Weapon When died",
	version = "1",
	url = ""
};

public void OnAllPluginsLoaded()
{
	if( LibraryExists("info_editor") == false )
	{
		SetFailState("Drop Melee When Dead cannot start 'l4d_info_editor.smx' plugin not loaded.");
	}
}

public void OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("defibrillator_used", Event_PlayerRevived, EventHookMode_Post);	
	HookEvent("round_start",Event_RoundStart,EventHookMode_Post);	
	HookEvent("round_end",Event_RoundEnd,EventHookMode_Post);
}

Handle roundTickHandler;

public Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	PrintToServer(">>>>[DropMeleeWhenDied] Round Start");
	delete roundTickHandler;
	roundTickHandler=CreateTimer(1,RoundTickHandleRoutine,_,TIMER_REPEAT);
	printedSinceRoundStart=false;
}

public Action Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	PrintToServer(">>>>[DropMeleeWhenDied] Round End");
	delete roundTickHandler;
}

public Action RoundTickHandleRoutine(Handle timer)
{
	//每隔一秒Tick一次存储角色的副手武器信息
	//在角色死亡时无法获取装备信息，只能提前获取了
	for(int i=0;i<MaxClients+1;i++)
	{
		if (!IsSurvivor(i))
		{
			sViceWeaponEntityTracking[i]=-1;
		} 
		else if(GetEntProp(i, Prop_Send, "m_isIncapacitated", 1) <= 0) //未倒地状态才会记录武器
		{
			sViceWeaponEntityTracking[i] = GetPlayerWeaponSlot(i, 1);// 当前的副手武器
		}
	}

	return Plugin_Continue;
}

stock bool IsSurvivor(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsSurvivor(client))
	{
		return;
	} 

	DropViceWeapon(client);
}

public Action Event_PlayerRevived(Handle event, const char[] name, bool dontBroadcast)
{
	//玩家被电击复活后，需要移除掉它的副手武器，并替换为一把小手枪
	int client = GetClientOfUserId(GetEventInt(event, "subject"));

	if (!IsSurvivor(client))
	{
		return;
	} 

	ReplaceWithPistol(client);
}

stock void DropViceWeapon(int client)
{
	int weapon=sViceWeaponEntityTracking[client];
	if(weapon==-1)
	{
		PrintToServer(">>>>[DropMeleeWhenDied] Invalid Drop Weapon");
		return;
	}
	if(!IsValidEntity(weapon))
	{
		PrintToServer(">>>>[DropMeleeWhenDied] Invalid Drop Weapon Entity");
		return;
	}

	char wName[32];
	GetEdictClassname(weapon, wName, 32);
	PrintToServer(">>>>[DropMeleeWhenDied] Drop Weapon Entity Class Name:%s",wName);

	int newWeapon = -1;
	newWeapon = CreateEntityByName(wName);
	if( newWeapon == -1 )
		return;

	if(StrEqual(wName,"weapon_melee"))//Drop a melee weapon
	{
		int meleeWeaponId=GetEntProp(weapon, Prop_Send, "m_hMeleeWeaponInfo");
		if(meleeWeaponId>=0&&meleeWeaponId<MeleeClassCountInCurrentMap)
		{
			PrintToServer(">>>>[DropMeleeWhenDied] Drop Melee Weapon: %s",MeleesInCurrentMap[meleeWeaponId]);
			DispatchKeyValue(newWeapon, "solid", "6");
			DispatchKeyValue(newWeapon, "melee_script_name", MeleesInCurrentMap[meleeWeaponId]);
		}
		else
		{
			PrintToServer(">>>>[DropMeleeWhenDied] Drop Unknown Melee Weapon ID: %d",meleeWeaponId);
		}
		
	}
	else//Drop pistol, magnum or chainsaw, No special processing needed
	{

	}

	if(DispatchSpawn(newWeapon))
	{
		float position[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);	
		position[2]+=200;
		TeleportEntity(newWeapon,position, NULL_VECTOR, NULL_VECTOR);
		ActivateEntity(newWeapon);
	}
}

stock void ReplaceWithPistol(client)
{
	int newWeapon = -1;
	newWeapon = CreateEntityByName("weapon_pistol");
	if( newWeapon == -1 )
		ThrowError("Failed to create entity 'weapon_pistol'.");
	
	int viceWeapon=GetPlayerWeaponSlot(client,1);
	if(viceWeapon!=-1)
		RemovePlayerItem(client,viceWeapon);

	if(DispatchSpawn(newWeapon))
	{
		ActivateEntity(newWeapon);
		EquipPlayerWeapon(client,newWeapon);
	}
}

public void OnGetMissionInfo(int pThis)
{
	//由info_editor提供的一个回调函数，用来获取当前战役的一些设置信息
	//在本插件中则是为了获取地图设定的近战列表
	RequestFrame(onMissionSettingParsed, pThis);
}

public void onMissionSettingParsed(int pThis)
{
	//提取本轮战役的近战字符串列表
	char temp[256];
	InfoEditor_GetString(pThis, "meleeweapons", temp, sizeof(temp));
	MeleeClassCountInCurrentMap=ExplodeString(temp,";",MeleesInCurrentMap,16,16,true);

	if(!printedSinceRoundStart)
	{	
		PrintToServer(">>>>[DropMeleeWhenDied] Melee Weapon List In This Campaign: %s",temp);
		for(int i=0;i<MeleeClassCountInCurrentMap;i++)
		{
			PrintToServer(">>>>[DropMeleeWhenDied] Melee Weapon %d : %s",i,MeleesInCurrentMap[i]);
		}
		printedSinceRoundStart=true;
	}
	
}