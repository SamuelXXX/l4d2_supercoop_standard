#include <sourcemod>
#include <sdktools>

public Plugin myinfo={
	name="Client Fake Info Display",
	author="SamaelXXX",
	description="Display fake info if target is fake client",
	version="1.0",
	url="http://www.sourcemod.net/"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_dpclient",Command_DisplayClientInfo,0);
	LoadTranslations("common.phrases.txt");
}

public Action Command_DisplayClientInfo(int client,int args)
{
	char arg1[32];
	
	GetCmdArg(1,arg1,sizeof(arg1));
	
	int target=FindTarget(client,arg1);
	if(target==-1)
	{
		return Plugin_Handled;
	}
	
	char name[MAX_NAME_LENGTH];
	GetClientName(target,name,sizeof(name));
	
	if(IsFakeClient(target))
	{
		ReplyToCommand(client,"%s is a FAKE client!",name);
	}
	else
	{
		ReplyToCommand(client,"%s is NOT a fake client!",name);
	}
	
	return Plugin_Handled;
}

