//======== Copyright (c) 2009, Valve Corporation, All rights reserved. ========
//
//=============================================================================

Msg("\n\n\n");
Msg(">>>director_base\n");
printl( "Initializing Director's script" );
Msg("\n\n\n");
//紧跟coop xxx_coop之后执行


DirectorOptions <-
{

	finaleStageList = []
	OnChangeFinaleMusic	= ""

	function OnChangeFinaleStage( from, to)
	{
		if ( to > 0 && to < finaleStageList.len() )
		{
			OnChangeFinaleMusic = finaleStageList[to];
		}
	}

	MaxSpecials = 8		
}

// temporarily leaving stage strings as diagnostic for gauntlet mode
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_1, "FINALE_GAUNTLET_1" );
DirectorOptions.finaleStageList.insert( FINALE_HORDE_ATTACK_1, "Event.FinaleStart" );
DirectorOptions.finaleStageList.insert( FINALE_HALFTIME_BOSS, "Event.TankMidpoint" );
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_2, "FINALE_GAUNTLET_2" );
DirectorOptions.finaleStageList.insert( FINALE_HORDE_ATTACK_2, "Event.FinaleWave4" );
DirectorOptions.finaleStageList.insert( FINALE_FINAL_BOSS, "Event.TankBrothers" );
DirectorOptions.finaleStageList.insert( FINALE_HORDE_ESCAPE, "" );
DirectorOptions.finaleStageList.insert( FINALE_CUSTOM_PANIC, "FINALE_CUSTOM_PANIC" );
DirectorOptions.finaleStageList.insert( FINALE_CUSTOM_TANK, "Event.TankMidpoint" );
DirectorOptions.finaleStageList.insert( FINALE_CUSTOM_SCRIPTED, "FINALE_CUSTOM_SCRIPTED" );
DirectorOptions.finaleStageList.insert( FINALE_CUSTOM_DELAY, "FINALE_CUSTOM_DELAY" );
DirectorOptions.finaleStageList.insert( FINALE_CUSTOM_CLEAROUT, "FINALE_CUSTOM_DELAY" );
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_START, "Event.FinaleStart" );
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_HORDE, "FINALE_GAUNTLET_HORDE" );
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_HORDE_BONUSTIME, "FINALE_GAUNTLET_HORDE_BONUSTIME" );
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_BOSS_INCOMING, "Event.TankMidpoint" );
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_BOSS, "FINALE_GAUNTLET_BOSS" );
DirectorOptions.finaleStageList.insert( FINALE_GAUNTLET_ESCAPE, "" );
	

function GetDirectorOptions()
{
	//这里改动了DirectorOptions的生效顺序
	//MapScript的东西可以覆写ModeScript的内容，而非相反
	local result;
	if ( "DirectorOptions" in DirectorScript )
	{
		result = DirectorScript.DirectorOptions;
	}
	
	if ( DirectorScript.MapScript.ChallengeScript.rawin( "DirectorOptions" ) )
	{
		if ( result != null )
		{
			DirectorScript.MapScript.ChallengeScript.DirectorOptions.setdelegate( result );
		}
		result = DirectorScript.MapScript.ChallengeScript.DirectorOptions;
	}

	if ( DirectorScript.MapScript.rawin( "DirectorOptions") )
	{
		if ( result != null )
		{
				DirectorScript.MapScript.DirectorOptions.setdelegate( result );
		}
		result = DirectorScript.MapScript.DirectorOptions;
	}

	if ( DirectorScript.MapScript.LocalScript.rawin( "DirectorOptions") )
	{
		if ( result != null )
		{
			DirectorScript.MapScript.LocalScript.DirectorOptions.setdelegate( result );
		}
		result = DirectorScript.MapScript.LocalScript.DirectorOptions;
	}
	return result;
}

function GetFinalePanicWaveCount()
{
	return RandomInt(3,5)
}


CommonFinaleOptions <-
{
	CommonLimit = 40
	MegaMobSize = 180
	cm_MaxSpecials = 10
	DominatorLimit = 10
	TankLimit = 24
	ProhibitBosses = false
	WitchLimit = 0
	SpecialRespawnInterval = 4
	TankHitDamageModifierCoop = RandomFloat(3,5)

	HordeEscapeCommonLimit = 30
	ZombieTankHealth = RandomInt(15000,20000)
	//影响终局两个wave之间的时间间隔
	PanicWavePauseMax = 20
	PanicWavePauseMin = 30
}

function ApplyCommonFinaleOptions(finaleOptions)
{
	local tempTable={}
	InjectTable(CommonFinaleOptions, tempTable)
	InjectTable(finaleOptions, tempTable)
	InjectTable(tempTable, finaleOptions)
	Msg("Merge tables\n")
	foreach(k,v in finaleOptions)
	{
		Msg(k)
		Msg(":")
		Msg(v)
		Msg("\n")
	}
}

