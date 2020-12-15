Msg("\n\n\n>>>>>>>>>>>>>>>>>>>>>>Common Coop Director Scripts Start Load<<<<<<<<<<<<<<<<<<<<<<<<\n");

DirectorOptions <-
{
	//导演系统四大状态跳转条件参数配置
	BuildUpMinInterval = 1
	SustainPeakMinTime = 12
	SustainPeakMaxTime = 20
	IntensityRelaxThreshold = 1.0
	RelaxMaxFlowTravel = RandomInt(700,1200)
	RelaxMinInterval = 99999
	RelaxMaxInterval = 99999

	//特感刷新参数配置
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 20 //离开安全屋后第一波特感的刷新时间
	SpecialRespawnInterval=3
	cm_SpecialRespawnInterval=3  //特感通道冷却时间，该通道特感死亡后开始冷却，冷却时间见底后会从特感池中刷新一个新的特感
	cm_AggressiveSpecials = true

	//尸潮刷新参数配置
	MobRechargeRate=0.5 	//待机尸潮的小僵尸增加速度
	MobMinSize=20		//待机尸潮的下限数目（充能基底值），其实还是从0开始充能，只是充能结果如果小于这个值，就以该值为准刷尸潮
	MobMaxSize=40		//待机尸潮的上限数目（充能上限值）
	MobMaxPending = 20 	//当刷出来的小僵尸超过CommonLimit后，超出的小僵尸数目会保留在一个池子里等待刷新
	MobSpawnMinTime=5	//待机尸潮冷却时间下限
	MobSpawnMaxTime=20	//待机尸潮冷却时间上限，在下限与上限之间随机取值，当冷却时间见底时就会刷尸潮（前提还是处于Build_Up或者Sustain_Peak状态）
	
	//各类丧尸数量限制，不要删除这些字段，因为有些插件依赖这些字段
	WitchLimit=24
	CommonLimit=30
	cm_MaxSpecials = 8
	DominatorLimit = 6
	BoomerLimit = 4
	ChargerLimit = 3
	HunterLimit = 4
	JockeyLimit = 3
	SmokerLimit = 2
	SpitterLimit = 4
	TankLimit=1  //战役模式不希望刷太多克，终局脚本改回来

	//Tank相关设置
	ZombieTankHealth=RandomInt(12000,20000)
	TankHitDamageModifierCoop = RandomInt(1,5)

	//其它设置
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS

	//道具转换
	weaponsToConvert =
	{
		weapon_vomitjar = "random_throwable"
		weapon_rifle_m60 = "random_sniper"
		weapon_grenade_launcher = "random_sniper"
	}

	function ConvertWeaponSpawn( classname )
	{
		if ( classname in weaponsToConvert )
		{
			local realConvertWeapon = weaponsToConvert[classname];
			local rv = RandomFloat(0,1)
			switch(weaponsToConvert[classname])
			{
				case "random_throwable":
					if(rv < 0.5)
					{
						realConvertWeapon="weapon_pipebomb_spawn"
					}
					else
					{
						realConvertWeapon="weapon_molotov_spawn"
					}
					break;
				case "random_supply":
					if(rv < 0.25)
					{
						realConvertWeapon="weapon_defibrillator_spawn"
					}
					else if(rv < 0.5)
					{
						realConvertWeapon="weapon_first_aid_kit_spawn"
					}
					else if(rv < 0.75)
					{
						realConvertWeapon="weapon_pain_pills_spawn"
					}
					else
					{
						realConvertWeapon="weapon_adrenaline_spawn"
					}
					break;
				case "random_sniper":
					if(rv < 0.1)
					{
						realConvertWeapon="weapon_sniper_awp_spawn"
					}
					else if(rv < 0.2)
					{
						realConvertWeapon="weapon_sniper_scout_spawn"
					}
					else if(rv < 0.8)
					{
						realConvertWeapon="weapon_rifle_ak47_spawn"
					}
					else
					{
						return 0;
					}
					break;
				default:
					break;
			}
			Msg(">>>Convert "+classname+" to "+realConvertWeapon+"\n");
			return realConvertWeapon;
		}
		return 0;
	}

	function KillAllSpecialInfected()
	{
		//杀死所有除了tank之外的其它所有特感
		local playerEnt = null
		Msg(">>>Kill All Special Infected\n");

		while ( playerEnt = Entities.FindByClassname( playerEnt, "player" ) )
		{
			local zombieType=playerEnt.GetZombieType()
			if (zombieType>=1&&zombieType<=6) //所有特感
				playerEnt.TakeDamage(10000, -1, null)
		}
	}
}

Convars.SetValue("director_special_battlefield_respawn_interval",4) //防守时特感刷新的速度
Convars.SetValue("director_custom_finale_tank_spacing",2) //终局tank出现的时间间隔
Convars.SetValue("director_tank_checkpoint_interval",120)//允许tank出生的时间，自生还者离开安全屋开始计算

//决定Witch的刷新数量，可能吧，未验证
Convars.SetValue("director_threat_max_separation",1) 
Convars.SetValue("director_threat_min_separation",0) 
Convars.SetValue("director_threat_radius",0)
Convars.SetValue("director_max_threat_areas",40)


Convars.SetValue("director_force_tank",0) //是否走两步就刷tank
Convars.SetValue("director_force_witch",0)


Convars.SetValue("l4d2_spawn_uncommons_autochance",3)
Convars.SetValue("l4d2_spawn_uncommons_autotypes",31)
Convars.SetValue("z_witch_always_kills",1)

Convars.SetValue("tongue_victim_max_speed",225)
Convars.SetValue("tongue_range",1500)

//插件配置参数修改
//tank生成插件，默认在8-15分钟刷一只克，有些关卡第一关可能不希望刷这么多（把刷克时间改的尽可能长就行），有些关卡则希望能多点
Convars.SetValue("min_time_spawn_tank",480)
Convars.SetValue("max_time_spawn_tank",900)

// function Update()
// {
// 	//随机均分刷特插件需要读取convar，但是convar和DirectorOptions里的设置有不一样，所以在这里强行做绑定
// 	local result=GetDirectorOptions();
// 	Convars.SetValue("z_spitter_limit",result.SpitterLimit)
// 	Convars.SetValue("z_boomer_limit",result.BoomerLimit)
// 	Convars.SetValue("z_hunter_limit",result.HunterLimit)
// 	Convars.SetValue("z_smoker_limit",result.SmokerLimit)
// 	Convars.SetValue("z_charger_limit",result.ChargerLimit)
// 	Convars.SetValue("z_jockey_limit",result.JockeyLimit)
// 	// result.KillAllSpecialInfected()
// }


Msg(">>>>>>>>>>>>>>>>>>>>>>Common Coop Director Scripts Load Succeed<<<<<<<<<<<<<<<<<<<<<<<<\n\n\n\n");