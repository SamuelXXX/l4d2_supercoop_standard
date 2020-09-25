#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

static Handle client_handle_timers[MAXPLAYERS+1];// 单独处理每个玩家的电锯timer
static int chainsaw_fire_count[MAXPLAYERS+1];// 单独处理每个玩家的电锯timer
static int chainsawFireCont=30; // 每一发电锯子弹可以维持30个Fire事件
ConVar RefuelAmountCVAR, RefuelTimerCVAR, ExtraFuelConsumePerFireCVAR;

public Plugin myinfo =
{
	name = "Regenerating Chainsaw",
	author = "SamaelXXX",
	description = "Make chainsaw fuel regenerate when not equip it and prevent it from drop",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	char sGame[32];
	GetGameFolderName(sGame, sizeof(sGame));

	if (!StrEqual(sGame, "left4dead2", false))
		SetFailState("Plugin supports Left 4 Dead 2 only.");

	RefuelAmountCVAR=CreateConVar("refuel_rate","1","Refueling amount each timer",FCVAR_NOTIFY);
	RefuelTimerCVAR=CreateConVar("refuel_timer","1","Refueling timer",FCVAR_NOTIFY);
	ExtraFuelConsumePerFireCVAR=CreateConVar("extra_fuel_consume_per_fire","0","Extra fuel consumes per fire",FCVAR_NOTIFY);


	HookEvent("weapon_fire", eWeaponFire);

	AutoExecConfig(true, "regenerating_chainsaw");
}

public void OnMapStart()
{
	if (!IsModelPrecached("models/models/weapons/melee/w_chainsaw.mdl"))
		PrecacheModel("models/models/weapons/melee/w_chainsaw.mdl");

	if (!IsModelPrecached("models/models/weapons/melee/v_chainsaw.mdl"))
		PrecacheModel("models/models/weapons/melee/v_chainsaw.mdl");
}

public void OnClientPutInServer(int client)
{
	client_handle_timers[client]=CreateTimer(GetConVarFloat(RefuelTimerCVAR),ClientHandleRoutine,client, TIMER_REPEAT);
}

public void OnClientDisconnect(int client)
{
	delete client_handle_timers[client];
}

public Action ClientHandleRoutine(Handle timer,int client)
{
	if (!IsSurvivor(client) || !IsPlayerAlive(client))
		return Plugin_Continue;

	
	int viceWeapon = GetPlayerWeaponSlot(client, 1);// 当前的副手武器

	if(viceWeapon==-1)
	{
		return Plugin_Continue;
	}
		
	
	char viceWeaponName[32];
	GetEntityClassname(viceWeapon, viceWeaponName, sizeof(viceWeaponName));

	if (!StrEqual(viceWeaponName, "weapon_chainsaw"))//如果副手武器不是电锯，就不用处理了
	{
		return Plugin_Continue;
	}


	// 处理副手武器是电锯的情况
	int activeWeapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");// 当前使用的武器
	int mainWeapon = GetPlayerWeaponSlot(client, 0);// 当前的主手武器

	if(mainWeapon == -1)
	{
		FuelChainsaw(viceWeapon, 4 * GetConVarInt(RefuelAmountCVAR));//没有主手武器，四倍恢复
	}
	else if(activeWeapon == viceWeapon)
	{
		FuelChainsaw(viceWeapon, GetConVarInt(RefuelAmountCVAR));//正使用电锯，一倍恢复
	}
	else
	{
		FuelChainsaw(viceWeapon, 2 * GetConVarInt(RefuelAmountCVAR));//没有使用电锯，两倍恢复
	}

	return Plugin_Continue;
}

stock void FuelChainsaw(int weapon, int amount)
{
	int clip = GetEntProp(weapon, Prop_Data, "m_iClip1"); 
	int maxClip=GetConVarInt(FindConVar("ammo_chainsaw_max"));

	clip=clip+amount;
	if(clip>maxClip)
	{
		clip=maxClip;
	}
	if(clip<1)
	{
		clip=1;
	}

	SetEntProp(weapon, Prop_Send, "m_iClip1", clip);
}
	
public void eWeaponFire(Event event, const char[] name, bool dontBroadcast)
{
	// 防止电锯因为油量见底而被删除
	int client = GetClientOfUserId(event.GetInt("userid"));

	if (!IsSurvivor(client) || !IsPlayerAlive(client))
		return;

	int Weapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");

	if (Weapon == -1)
		return;

	char sWeapon[17];
	GetEntityClassname(Weapon, sWeapon, sizeof(sWeapon));

	if (!StrEqual(sWeapon, "weapon_chainsaw"))
	{
		return;
	}
	//PrintToServer("Chainsaw Fire:%d",GetEntProp(Weapon, Prop_Data, "m_iClip1"));
	chainsaw_fire_count[client]+=1;
	if(chainsaw_fire_count[client]>=chainsawFireCont)
	{
		chainsaw_fire_count[client]=0;
		FuelChainsaw(Weapon,-GetConVarInt(ExtraFuelConsumePerFireCVAR));
	}
	//FuelChainsaw(Weapon,-GetConVarInt(ExtraFuelConsumePerFireCVAR));

	ProcessFireChainsaw(client,Weapon);
}

stock void ProcessFireChainsaw(int client, int weapon)
{
	//Process when chainsaw fired

	int Clip = GetEntProp(weapon, Prop_Data, "m_iClip1");

	if (Clip <= 1)//Prevent chainsaw from being destroyed
	{
		AcceptEntityInput(weapon, "kill");

		int chainsaw = CreateEntityByName("weapon_chainsaw");
		DispatchSpawn(chainsaw);
		EquipPlayerWeapon(client, chainsaw);

		SetEntProp(chainsaw, Prop_Send, "m_iClip1", 1);
	}
}

stock bool IsSurvivor(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}