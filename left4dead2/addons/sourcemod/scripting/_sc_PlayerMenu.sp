#include <sourcemod>
#include <sdktools>
#include <geoip>


public Plugin myinfo =
{
	name = "Player Menu",
	author = "SamaelXXX",
	description = "As Title",
	version = "1.0",
	url = "http://www.sourcemod.net/"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_menu",Command_ShowPlayerMenu);
}

public Action Command_ShowPlayerMenu(int client,int args)
{
	if(client != 0) CreateMainMenu(client);
	return Plugin_Handled;
}

enum MainMenuItem
{
	PMVoteKick=1,
	PMVoteKill=2,
	PMVoteMap=3,
	PMVoiceMute=4,
	PMTakeOverBot=5,
	PMKick=6,
	PMSpawnWeapon=7
}

bool menuOn=false;
void CreateMainMenu(int client)
{	
	Menu menu=CreateMenu(MainMenuHandler,MENU_ACTIONS_DEFAULT);
	SetMenuTitle(menu,"主菜单");
	AddMenuItem(menu,"1","踢人投票");
	AddMenuItem(menu,"2","处死投票");
	AddMenuItem(menu,"3","换图投票(限首关)");
	AddMenuItem(menu,"4","静音玩家");
	AddMenuItem(menu,"5","接管电脑");
	if(CheckCommandAccess(client,"sm_kick",ADMFLAG_KICK,false))
		AddMenuItem(menu,"6","踢出玩家（管理员）");
	if(CheckCommandAccess(client,"sm_sw",ADMFLAG_SLAY,false))
		AddMenuItem(menu,"7","刷枪（最高权限）");
		
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	menuOn=true;
}

public int MainMenuHandler(Menu menu,MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
			
		case MenuAction_Cancel:
		if (param2 == MenuCancel_ExitBack)
				CreateMainMenu(param1);
					
		case MenuAction_Select:
		{
			char info[16];
			
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				MainMenuItem cmd = StringToInt(info);
				
				switch(cmd)
				{
					case PMVoteKick:
					{
						CreatePlayerListMenu(param1,"选择踢出目标",8,HandlerVoteKick,true);
					}
					case PMVoteKill:
					{
						CreatePlayerListMenu(param1,"选择处死目标",8,HandlerVoteKill,true);
					}
					case PMVoteMap:
					{
						FakeClientCommand(param1,"sm_chmap");
					}
					case PMVoiceMute:
					{
						CreatePlayerListMuteMenu(param1,"切换静音状态",8,HandlerVoiceMute,false);
					}
					case PMTakeOverBot:
					{
						FakeClientCommand(param1,"sm_pickbot");
					}
					
					case PMKick:
					{
						CreatePlayerListMenu(param1,"选择踢出目标",8,HandlerKick,false);
					}

					case PMSpawnWeapon:
					{
						CreateWeaponMainMenu(param1,"选择武器类型");
					}
				}
			}
			
		}
	}	
}

void CreatePlayerListMenu(int client , const char[] title , int lifespan , MenuHandler handler , bool includeSelf)
{
	int count=0;
	Menu menu=CreateMenu(handler);
	SetMenuTitle(menu,title);
	
	static char name[MAX_NAME_LENGTH];
	static char uid[12];

	for(int i = 1; i <= MaxClients; i++)
	{
		if(!includeSelf && i == client)
			continue;
		
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			Format(uid, sizeof(uid), "%i", GetClientUserId(i));

			if(GetClientName(i, name, sizeof(name)))
			{
				AddMenuItem(menu,uid,name);
				count++;
			}
		}
	}
	if(count==0)
	{
		PrintToChat(client,"没有可供操作的玩家");
	}
	else
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

void CreatePlayerListMuteMenu(int client , const char[] title , int lifespan , MenuHandler handler , bool includeSelf)
{
	int count=0;
	
	Menu menu=CreateMenu(handler);
	SetMenuTitle(menu,title);
	
	static char name[MAX_NAME_LENGTH];
	static char uid[12];
	static char menuItem[32];

	for(int i = 1; i <= MaxClients; i++)
	{
		if(!includeSelf && i == client)
			continue;
		
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			Format(uid, sizeof(uid), "%i", GetClientUserId(i));

			if(GetClientName(i, name, sizeof(name)))
			{
				if(GetListenOverride(client,i) == Listen_No)
				{
					Format(menuItem, sizeof(menuItem), "%s (%s)", name, "已静音");
					AddMenuItem(menu, uid, menuItem);
				}
				else
					AddMenuItem(menu, uid, name);
				
				count++;
			}
		}
	}
	if(count==0)
	{
		PrintToChat(client,"没有可以静音的玩家");
	}
	else
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public int HandlerVoteKick(Menu menu,MenuAction action,int client,int param2)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
			
		case MenuAction_Cancel:
			if (param2 == MenuCancel_ExitBack)
				CreateMainMenu(client);
					
		case MenuAction_Select:
		{
			char info[16];
			char name[MAX_NAME_LENGTH];
			
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int target = GetClientOfUserId(StringToInt(info));
				GetClientName(target, name, sizeof(name));
				FakeClientCommand(client,"sm_votekick %s",name);
			}
		}
	}
}

public int HandlerKick(Menu menu,MenuAction action,int client,int param2)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
			
		case MenuAction_Cancel:
			if (param2 == MenuCancel_ExitBack)
				CreateMainMenu(client);
					
		case MenuAction_Select:
		{
			char info[16];
			char name[MAX_NAME_LENGTH];
			
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int target = GetClientOfUserId(StringToInt(info));
				GetClientName(target, name, sizeof(name));
				FakeClientCommand(client,"sm_kick %s",name);
			}
		}
	}
}

public int HandlerVoteKill(Menu menu,MenuAction action,int client,int param2)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
			
		case MenuAction_Cancel:
			if (param2 == MenuCancel_ExitBack)
			CreateMainMenu(client);
					
		case MenuAction_Select:
		{
			char info[16];
			char name[MAX_NAME_LENGTH];
			
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int target = GetClientOfUserId(StringToInt(info));
				GetClientName(target, name, sizeof(name));
				FakeClientCommand(client,"sm_voteslay %s",name);
			}
		}
	}
}

public int HandlerVoiceMute(Menu menu,MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
			
		case MenuAction_Cancel:
			if (param2 == MenuCancel_ExitBack)
				CreateMainMenu(param1);
					
		case MenuAction_Select:
		{
			char info[16];
			char name[32];
			
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int target = GetClientOfUserId(StringToInt(info));
				GetClientName(target, name, sizeof(name));
				if(GetListenOverride(param1,target) != Listen_No)
				{
					SetListenOverride(param1,target,Listen_No);
					PrintToChat(param1,"\x01已将\x04%s\x01静音",name);
				}
				else
				{
					SetListenOverride(param1,target,Listen_Default);
					PrintToChat(param1,"\x01已恢复\x04%s\x01的语音，如果听不到对方语音，请检查音频设置。",name);
				}
			}
		}
	}
}

void CreateWeaponMenu(int client , const char[] title, MenuHandler handler,const char[][] description,int length)
{
	int count=0;
	
	Menu menu=CreateMenu(handler);
	SetMenuTitle(menu,title);
	
	static char uid[12];
	static char display_name[32]

	for(int i = 0; i < length; i++)
	{
		Format(uid, sizeof(uid), "%i", i);
		AddMenuItem(menu, uid, description[i]);
	}
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public int HandlerSpawnWeapon(Menu menu,MenuAction action,int client,int param2,const char[][] weapon)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
			
		case MenuAction_Cancel:
			if (param2 == MenuCancel_ExitBack)
				CreateMainMenu(client);
					
		case MenuAction_Select:
		{
			char info[16];
			char name[MAX_NAME_LENGTH];
			
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int target = StringToInt(info);
				FakeClientCommand(client,"sm_sw %s",weapon[target]);
			}
		}
	}
}

static const char weapon_hyper[4][]=
{
	"sniper_awp",
	"sniper_scout",
	"grenade_launcher",
	"rifle_m60",
}
static const char weapon_hyper_description[4][]=
{
	"大狙",
	"鸟狙",
	"榴弹发射器",
	"大菠萝",
}
void CreateHyperWeaponMenu(int client)
{
	CreateWeaponMenu(client,"顶级主武器",HandlerSpawnWeaponHyper,weapon_hyper_description,4)
}
public int HandlerSpawnWeaponHyper(Menu menu,MenuAction action,int client,int param2)
{
	HandlerSpawnWeapon(menu,action,client,param2,weapon_hyper)
}


static const char weapon_super[4][]=
{
	"autoshotgun",
	"shotgun_spas",
	"hunting_rifle",
	"sniper_military",
}
static const char weapon_super_description[4][]=
{
	"一代连喷",
	"二代连喷",
	"猎枪",
	"军狙",
}
void CreateSuperWeaponMenu(int client)
{
	CreateWeaponMenu(client,"高级主武器",HandlerSpawnWeaponSuper,weapon_super_description,4)
}
public int HandlerSpawnWeaponSuper(Menu menu,MenuAction action,int client,int param2)
{
	HandlerSpawnWeapon(menu,action,client,param2,weapon_super)
}

static const char weapon_normal[2][]=
{
	"pumpshotgun",
	"shotgun_chrome",
}
static const char weapon_normal_description[2][]=
{
	"一代单喷",
	"二代单喷",
}
void CreateNormalWeaponMenu(int client)
{
	CreateWeaponMenu(client,"中级主武器",HandlerSpawnWeaponNormal,weapon_normal_description,2)
}
public int HandlerSpawnWeaponNormal(Menu menu,MenuAction action,int client,int param2)
{
	HandlerSpawnWeapon(menu,action,client,param2,weapon_normal)
}

static const char weapon_vice[2][]=
{
	"pistol_magnum",
	"chainsaw",
}
static const char weapon_vice_description[2][]=
{
	"马格南",
	"电锯",
}
void CreateViceWeaponMenu(int client)
{
	CreateWeaponMenu(client,"副手武器",HandlerSpawnWeaponVice,weapon_vice_description,2)
}
public int HandlerSpawnWeaponVice(Menu menu,MenuAction action,int client,int param2)
{
	HandlerSpawnWeapon(menu,action,client,param2,weapon_vice)
}

static const char weapon_throw[3][]=
{
	"molotov",
	"pipe_bomb",
	"vomitjar",
}
static const char weapon_throw_description[3][]=
{
	"燃烧瓶",
	"土制炸弹",
	"胆汁罐",
}
void CreateThrowWeaponMenu(int client)
{
	CreateWeaponMenu(client,"投掷武器",HandlerSpawnWeaponThrow,weapon_throw_description,3)
}
public int HandlerSpawnWeaponThrow(Menu menu,MenuAction action,int client,int param2)
{
	HandlerSpawnWeapon(menu,action,client,param2,weapon_throw)
}

static const char weapon_supply[4][]=
{
	"adrenaline",
	"pain_pills",
	"first_aid_kit",
	"defibrillator",
}
static const char weapon_supply_description[4][]=
{
	"肾上腺素",
	"止痛药",
	"医疗包",
	"电击器",
}
void CreateSupplyWeaponMenu(int client)
{
	CreateWeaponMenu(client,"投掷武器",HandlerSpawnWeaponSupply,weapon_supply_description,4)
}
public int HandlerSpawnWeaponSupply(Menu menu,MenuAction action,int client,int param2)
{
	HandlerSpawnWeapon(menu,action,client,param2,weapon_supply)
}
//顶级主武器:大狙 鸟狙  榴弹  m60
//高级主武器:连喷  连狙  突击步枪
//次级主武器:单喷  微冲
//副手武器:马格南  电锯
//投掷武器:燃烧瓶  胆汁  土制炸弹
//补给品:医疗包  电击器  止痛药  肾上腺素

void CreateWeaponMainMenu(int client , const char[] title)
{
	Menu menu=CreateMenu(WeaponMainHandler);
	SetMenuTitle(menu,title);
	
	AddMenuItem(menu, "1", "顶级主武器");
	AddMenuItem(menu, "2", "高级主武器");
	AddMenuItem(menu, "3", "次级主武器");
	AddMenuItem(menu, "4", "副手武器");
	AddMenuItem(menu, "5", "投掷武器");
	AddMenuItem(menu, "6", "补给品");
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

int WeaponMainHandler(Menu menu,MenuAction action,int client,int param2)
{
	switch (action)
	{
		case MenuAction_End:
			delete menu;
			
		case MenuAction_Cancel:
			if (param2 == MenuCancel_ExitBack)
				CreateMainMenu(client);
					
		case MenuAction_Select:
		{
			char info[16];
			char name[MAX_NAME_LENGTH];
			
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int target = StringToInt(info);
				switch(target)
				{
					case 1:
					{
						CreateHyperWeaponMenu(client);
					}
					case 2:
					{
						CreateSuperWeaponMenu(client);
					}
					case 3:
					{
						CreateNormalWeaponMenu(client);
					}
					case 4:
					{
						CreateViceWeaponMenu(client);
					}
					case 5:
					{
						CreateThrowWeaponMenu(client);
					}
					case 6:
					{
						CreateSupplyWeaponMenu(client);
					}
				}
			}
		}
	}
}





