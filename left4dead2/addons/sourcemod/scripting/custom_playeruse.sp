#include <sourcemod>
#include <sdktools>

public Plugin myinfo={
	name="Player Use Info Display",
	author="SamaelXXX",
	description="Display the using info",
	version="1.0",
	url="http://www.sourcemod.net/"
};

public void OnPluginStart()
{
	HookEvent("player_use",Event_PlayerUse);
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


