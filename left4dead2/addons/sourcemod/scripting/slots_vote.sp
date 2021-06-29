#pragma semicolon 1

#include <sourcemod>
#include <builtinvotes>
#include <colors>

new Handle:g_hVote;
new String:g_sSlots[32];
new Handle:hMaxSlots;
new MaxSlots;

public Plugin:myinfo =
{
	name = "Slots?! Voter",
	description = "Slots Voter",
	author = "Sir",
	version = "",
	url = ""
};

public OnPluginStart()
{
	RegConsoleCmd("sm_slots", SlotsRequest);
	hMaxSlots = CreateConVar("sv_slots_vote_max", "12", "Maximum amount of slots you wish players to be able to vote for? (DON'T GO HIGHER THAN 30)");
	SetConVarInt(FindConVar("sv_maxplayers"), 8);
	MaxSlots = GetConVarInt(hMaxSlots);
	HookConVarChange(hMaxSlots, CVarChanged);
}

public Action:SlotsRequest(client, args)
{
	if (!client)
	{
		return Plugin_Handled;
	}
	if (args == 1)
	{
		new String:sSlots[64];
		GetCmdArg(1, sSlots, sizeof(sSlots));
		new Int = StringToInt(sSlots);
		if (Int > MaxSlots)
		{
			CPrintToChat(client, "{blue}[{default}Slots{blue}] {default}此服务器你不能投票超过{olive}%i{default}个位置", MaxSlots);
		}
		else
		{
			if (GetAdminFlag(GetUserAdmin(client), Admin_Root))
			{
				CPrintToChatAll("{blue}[{default}Slots{blue}] {olive}管理员{default}将位置限制为{blue}%i个", Int);
				SetConVarInt(FindConVar("sv_maxplayers"), Int);
			}
			else if (Int < GetConVarInt(FindConVar("survivor_limit")))
			{
				CPrintToChat(client, "{blue}[{default}Slots{blue}] {default}位置数不能小于所需要的玩家数.");
			}
			else if (StartSlotVote(client, sSlots))
			{
				strcopy(g_sSlots, sizeof(g_sSlots), sSlots);
				FakeClientCommand(client, "Vote Yes");
			}
		}
	}
	else
	{
		CPrintToChat(client, "{blue}[{default}Slots{blue}] {default}用法: {olive}!slots{default}<{olive}数字{default}> {blue}| {default}例如: {olive}!slots 8");
	}
	return Plugin_Handled;
}

bool:StartSlotVote(client, String:Slots[])
{
	if (GetClientTeam(client) == 1)
	{
		PrintToChat(client, "旁观者不允许发起投票.");
		return false;
	}

	if (IsNewBuiltinVoteAllowed())
	{
		new iNumPlayers;
		decl iPlayers[MaxClients];
		for (new i=1; i<=MaxClients; i++)
		{
			if (!IsClientInGame(i) || IsFakeClient(i) || (GetClientTeam(i) == 1))
			{
				continue;
			}
			iPlayers[iNumPlayers++] = i;
		}
		
		new String:sBuffer[64];
		g_hVote = CreateBuiltinVote(VoteActionHandler, BuiltinVoteType_Custom_YesNo, BuiltinVoteAction_Cancel | BuiltinVoteAction_VoteEnd | BuiltinVoteAction_End);
		Format(sBuffer, sizeof(sBuffer), "限制位置为'%s'个?", Slots);
		SetBuiltinVoteArgument(g_hVote, sBuffer);
		SetBuiltinVoteInitiator(g_hVote, client);
		SetBuiltinVoteResultCallback(g_hVote, SlotVoteResultHandler);
		DisplayBuiltinVote(g_hVote, iPlayers, iNumPlayers, 20);
		return true;
	}

	PrintToChat(client, "现在不能投票.");
	return false;
}

public void SlotVoteResultHandler(Handle vote, int num_votes, int num_clients, const int[][] client_info, int num_items, const int[][] item_info)
{
	for (new i=0; i<num_items; i++)
	{
		if (item_info[i][BUILTINVOTEINFO_ITEM_INDEX] == BUILTINVOTES_VOTE_YES)
		{
			if (item_info[i][BUILTINVOTEINFO_ITEM_VOTES] > (num_votes / 2))
			{
				new Slots = StringToInt(g_sSlots, 10);
				DisplayBuiltinVotePass(vote, "限制服务器位置中...");
				SetConVarInt(FindConVar("sv_maxplayers"), Slots);
				return;
			}
		}
	}
	DisplayBuiltinVoteFail(vote, BuiltinVoteFail_Loses);
}

public VoteActionHandler(Handle:vote, BuiltinVoteAction:action, param1, param2)
{
	switch (action)
	{
		case BuiltinVoteAction_End:
		{
			g_hVote = INVALID_HANDLE;
			CloseHandle(vote);
		}
		case BuiltinVoteAction_Cancel:
		{
			DisplayBuiltinVoteFail(vote, BuiltinVoteFailReason:param1);
		}
	}
}

public CVarChanged(Handle:cvar, String:oldValue[], String:newValue[])
{
	MaxSlots = GetConVarInt(hMaxSlots);
}

