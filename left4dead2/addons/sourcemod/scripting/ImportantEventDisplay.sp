#include <sourcemod>
#include <sdktools>

public Plugin myinfo={
	name="Important Game Event Info Display",
	author="SamaelXXX",
	description="Display important game event info",
	version="1.0",
	url="http://www.sourcemod.net/"
};

public void OnPluginStart()
{
	HookEvent("player_use",Event_PlayerUse);
	HookEvent("success_checkpoint_button_used",Event_FinalCheckPoint);
}

public void Event_PlayerUse(Event event,const char[] name,bool dontBroadcast)
{
	int userId=event.GetInt("userid");
	int targetId=event.GetInt("targetid");
	
	int userClient=GetClientOfUserId(userId);
	
	char name[MAX_NAME_LENGTH];
	GetClientName(userClient,name,sizeof(name));
	
    ShowActivity2(userClient, "[SM] ", "Player %s use %d!", name, targetId);
}

public void Event_FinalCheckPoint(Event event,const char[] name,bool dontBroadcast)
{
	int userId=event.GetInt("userid");
	int targetId=event.GetInt("targetid");
	
	int userClient=GetClientOfUserId(userId);
	
	char name[MAX_NAME_LENGTH];
	GetClientName(userClient,name,sizeof(name));
	
    ShowActivity2(userClient, "[SM] ", "Player %s use %d!", name, targetId);
}


