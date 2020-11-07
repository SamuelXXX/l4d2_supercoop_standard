#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Auto Kick Numeric Clients",
	author = "SamaelXXX",
	description = "Auto Kick Numeric ID",
	version = "1",
	url = ""
};

public bool OnClientConnect(int client, char[] rejectmsg, int maxlen)
{
	char name[128];
	GetClientName(client,name,128);
	if(IsNumericName(name))
	{
		strcopy(rejectmsg,maxlen,"本服务器禁止纯数字ID玩家加入");
		return false;
	}
	return true;
}

public bool IsNumericName(const char[] name)
{
	int i=0;
	char c=0;
	while(c=name[i])
	{
		if(!IsCharNumeric(c))
			return false;
		i++;
	}
	if(i<=3)
		return false;
	return true;
}