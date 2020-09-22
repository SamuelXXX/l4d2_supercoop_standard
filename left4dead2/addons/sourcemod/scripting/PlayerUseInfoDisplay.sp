#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <string>

public Plugin myinfo={
	name="Player Interact Info Display",
	author="SamaelXXX",
	description="Display player interact info",
	version="1.0",
	url="http://www.sourcemod.net/"
};

int triggerUserId;
int targetId;
bool triggerUserIsValid;
char triggerUserName[32];
char targetEntityClassName[128];

public void OnPluginStart()
{
	HookEvent("player_use",Event_PlayerUse);
}

void PrepareUserName(Event event)
{
	triggerUserId=event.GetInt("userid");	
	int userClient=GetClientOfUserId(triggerUserId);
    triggerUserIsValid=!IsFakeClient(userClient);
	GetClientName(userClient,triggerUserName,sizeof(triggerUserName));
}

void PrepareEntityName(Event event)
{
	targetId=event.GetInt("targetid");
	if(IsValidEdict(targetId))
		GetEdictClassname(targetId, targetEntityClassName, sizeof(targetEntityClassName));
}

public void Event_PlayerUse(Event event,const char[] name,bool dontBroadcast)
{
	PrepareUserName(event);
	PrepareEntityName(event);
	if(!IsValidEdict(targetId))
		return;
	

	PrintToChatAll ("\x04%s\x01使用了\x03%s！",triggerUserName,targetEntityClassName);

}

