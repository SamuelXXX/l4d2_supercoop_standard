#include <sourcemod>
#include <sdktools>

public Plugin myinfo={
	name="My First Plugin",
	author="SamaelXXX",
	description="The test plugin",
	version="1.0",
	url="http://www.sourcemod.net/"
};

ConVar defaultSlapDamage;

public void OnPluginStart()
{
	defaultSlapDamage=CreateConVar("sm_default_slap_damage","5","Default slap damage");
	AutoExecConfig(true,"plugin_myslap");
	RegAdminCmd("sm_myslap",Command_MySlap,ADMFLAG_SLAY);
	RegAdminCmd("sm_damage",Command_Damage,ADMFLAG_SLAY);
	LoadTranslations("common.phrases.txt");
}

public Action Command_MySlap(int client,int args)
{
	char arg1[32],arg2[32];
	int damage=0;
	
	GetCmdArg(1,arg1,sizeof(arg1));
	
	if(args>=2)
	{
		GetCmdArg(2,arg2,sizeof(arg2));
		damage=StringToInt(arg2);
	}
	
	int target=FindTarget(client,arg1);
	if(target==-1)
	{
		return Plugin_Handled;
	}
	
	SlapPlayer(target,damage);
	
	char name[MAX_NAME_LENGTH];
	GetClientName(target,name,sizeof(name));
	ReplyToCommand(client,"[SM] You slapped %s for %d damage!",name,damage);
	
	
	return Plugin_Handled;
}

public Action Command_Damage(int client,int args)
{
	char arg1[32];
	int damage=defaultSlapDamage.IntValue;
	
	GetCmdArg(1,arg1,sizeof(arg1));
	int target=FindTarget(client,arg1);
	
	if(target==-1)
	{
		ReplyToCommand(client,"No Target Found!");
		return Plugin_Handled;
	}
	SlapPlayer(target,damage);
	return Plugin_Handled;
}


