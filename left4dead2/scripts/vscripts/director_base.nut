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

	if ( DirectorScript.MapScript.LocalScript.rawin( "DirectorOptions") )
	{
		if ( result != null )
		{
			DirectorScript.MapScript.LocalScript.DirectorOptions.setdelegate( result );
		}
		result = DirectorScript.MapScript.LocalScript.DirectorOptions;
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
	return result;
}

function GetFinalePanicWaveCount()
{
	return RandomInt(4,6)
}

function GetFinalePanicWaveCount1()
{
	return RandomInt(3,5)
}

function GetFinalePanicWaveCount2()
{
	return RandomInt(4,6)
}

function GetFinalePanicWaveCount3()
{
	return RandomInt(5,7)
}


//公用终局的参数列表
CommonFinaleOptions <-
{
	//尸潮参数设置
	CommonLimit = 30
	MegaMobSize = 120
	MobRechargeRate = 10 	//待机尸潮的小僵尸增加速度
	MobMinSize = 40		//待机尸潮的下限数目（充能基底值），其实还是从0开始充能，只是充能结果如果小于这个值，就以该值为准刷尸潮
	MobMaxSize = 60		//待机尸潮的上限数目（充能上限值）
	MobMaxPending = 30 	//当刷出来的小僵尸超过CommonLimit后，超出的小僵尸数目会保留在一个池子里等待刷新
	MobSpawnMinTime = 10	//待机尸潮冷却时间下限
	MobSpawnMaxTime = 15	//待机尸潮冷却时间上限，在下限与上限之间随机取值，当冷却时间见底时就会刷尸潮（前提还是处于Build_Up或者Sustain_Peak状态）

	//特感参数设置
	cm_MaxSpecials = 14
	DominatorLimit = 10
	TankLimit = 24
	ProhibitBosses = false
	WitchLimit = 0
	SpecialRespawnInterval = 2
	cm_SpecialRespawnInterval=2
	TankHitDamageModifierCoop = RandomFloat(1,5)
	ZombieTankHealth = RandomInt(15000,20000)

	HordeEscapeCommonLimit = 30
	
	//导演参数设置
	PanicWavePauseMax = 5
	PanicWavePauseMin = 10
}

function ApplyCommonFinaleOptions(finaleOptions)
{
	local tempTable={}
	InjectTable(CommonFinaleOptions, tempTable)
	InjectTable(finaleOptions, tempTable)
	InjectTable(tempTable, finaleOptions)
	foreach(k,v in finaleOptions)
	{
		Msg(k)
		Msg(":")
		Msg(v)
		Msg("\n")
	}
}

