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
	PMVoiceMute=3,
	PMTakeOverBot=4,
	PMKick=5
}

bool menuOn=false;
void CreateMainMenu(int client)
{	
	Menu menu=CreateMenu(MainMenuHandler,MENU_ACTIONS_DEFAULT);
	SetMenuTitle(menu,"主菜单");
	AddMenuItem(menu,"1","发起踢人投票");
	AddMenuItem(menu,"2","发起处死投票");
	AddMenuItem(menu,"3","静音玩家");
	AddMenuItem(menu,"4","接管电脑玩家");
	if(CheckCommandAccess(client,"sm_kick",ADMFLAG_KICK,false))
		AddMenuItem(menu,"5","踢出玩家（管理员）");
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
					case PMVoiceMute:
					{
						CreatePlayerListMuteMenu(param1,"切换静音状态",8,HandlerVoiceMute,false);
					}
					case PMTakeOverBot:
					{
						ClientCommand(param1,"sm_pickbot");
					}
					
					case PMKick:
					{
						CreatePlayerListMenu(param1,"选择踢出目标",8,HandlerKick,false);
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
				ClientCommand(client,"sm_votekick %s",name);
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
				ClientCommand(client,"sm_kick %s",name);
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
				ClientCommand(client,"sm_voteslay %s",name);
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






