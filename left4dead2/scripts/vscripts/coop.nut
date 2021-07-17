IncludeScript("VSLib");
Msg("\n\n\n>>>>>>>>>>>>>>>>>>>>>>Common Coop Director Scripts Start Load<<<<<<<<<<<<<<<<<<<<<<<<\n");

DirectorOptions <-
{
	//导演系统四大状态跳转条件参数配置
	BuildUpMinInterval = 1
	SustainPeakMinTime = 12
	SustainPeakMaxTime = 20
	IntensityRelaxThreshold = 1.0
	RelaxMaxFlowTravel = 1000
	RelaxMinInterval = 99999
	RelaxMaxInterval = 99999

	//特感刷新参数配置
	SpecialInitialSpawnDelayMin = 10
	SpecialInitialSpawnDelayMax = 10 //离开安全屋后第一波特感的刷新时间
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
	NumReservedWanderers = 20
	
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
	ZombieTankHealth=50000
	TankHitDamageModifierCoop = 5

	//其它设置
	AllowWitchesInCheckpoints = true
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS

	//道具转换
	weaponsToConvert =
	{
		weapon_vomitjar = "random_throwable"
		weapon_sniper_awp = "random_sniper"
		weapon_rifle = "random_rifle"
		weapon_rifle_ak47 = "random_rifle"
		weapon_rifle_desert = "random_rifle"
		weapon_rifle_sg552 = "random_rifle"
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
					if(rv < 0.2)
					{
						realConvertWeapon="weapon_molotov_spawn"
					}
					else
					{
						realConvertWeapon="weapon_pipe_bomb_spawn"
					}
					break;
				case "random_sniper":
					if(rv < 0.2)
					{
						realConvertWeapon="weapon_sniper_scout_spawn"
					}
					else if(rv < 0.6)
					{
						realConvertWeapon="weapon_sniper_military_spawn"
					}
					else
					{
						realConvertWeapon="weapon_hunting_rifle_spawn"
					}
					break;
				case "random_rifle":
					if(rv < 0.27)
					{
						realConvertWeapon="weapon_rifle_spawn"
					}
					else if(rv < 0.54)
					{
						realConvertWeapon="weapon_rifle_ak47_spawn"
					}
					else if(rv < 0.81)
					{
						realConvertWeapon="weapon_rifle_desert_spawn"
					}
					else
					{
						realConvertWeapon="weapon_rifle_sg552_spawn"
					}
					break;
				case "other_supply":
					if(rv < 0.33)
					{
						realConvertWeapon="weapon_first_aid_kit_spawn"
					}
					else if(rv < 0.66)
					{
						realConvertWeapon="weapon_adranaline_spawn"
					}
					else
					{
						realConvertWeapon="weapon_pain_pills_spawn"
					}
					break;
				case "magnum":
					realConvertWeapon="weapon_pistol_magnum_spawn"
					break;
				default:
					break;
			}
			Msg(">>>Convert "+classname+" to "+realConvertWeapon+"\n");
			return realConvertWeapon;
		}
		return 0;
	}

	weaponsToRemove =
	{
		weapon_sniper_awp = 0
		weapon_rifle_m60 = 0
		weapon_grenade_launcher = 0
	}

	function AllowWeaponSpawn( classname )
	{
		if ( classname in weaponsToRemove )
		{
			return false;
		}
		return true;
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

::RandomTime <- 0;
::HFlow <- 0;

function EasyLogic::Update::SpawnWitchWhenFlow ()
{
	local s = Players.SurvivorWithHighestFlow();
	if ( s == null )
		return;
	local flow = s.GetFlowDistance();
	if ( flow > HFlow )
	{
		local count = ((flow - HFlow) / 240).tointeger();
		for (; count > 0; count-- )
		{
			if(RandomTime == 0)
			{
				Convars.SetValue("sv_force_time_of_day","0")
				RandomTime = 1;
			}
			else if(RandomTime == 1)
			{
				Convars.SetValue("sv_force_time_of_day","2")
				RandomTime = 2;
			}
			else if(RandomTime == 2)
			{
				Convars.SetValue("sv_force_time_of_day","1")
				RandomTime = 0;
			}
			HFlow += 240;
		}
	}
}

Convars.SetValue("director_special_battlefield_respawn_interval",4) //防守时特感刷新的速度
Convars.SetValue("director_custom_finale_tank_spacing",2) //终局tank出现的时间间隔
Convars.SetValue("director_tank_checkpoint_interval",240)//允许tank出生的时间，自生还者离开安全屋开始计算

//决定Witch的刷新数量，可能吧，未验证
Convars.SetValue("director_threat_max_separation",1) 
Convars.SetValue("director_threat_min_separation",0) 
Convars.SetValue("director_threat_radius",0)
Convars.SetValue("director_max_threat_areas",40)
Convars.SetValue("z_tank_speed",250)
Convars.SetValue("sv_rescue_disabled",0)
Convars.SetValue("l4d2_tankfire_boost_enable",0)


Convars.SetValue("director_force_tank",0) //是否走两步就刷tank，应该是强制每个threat_area刷克，与director_max_threat_areas有关
Convars.SetValue("director_force_witch",0)


Convars.SetValue("z_witch_always_kills",1)

Convars.SetValue("tongue_victim_max_speed",225)
Convars.SetValue("tongue_range",1500)

//插件配置参数修改
//tank生成插件，默认在8-15分钟刷一只克，有些关卡第一关可能不希望刷这么多（把刷克时间改的尽可能长就行），有些关卡则希望能多点
Convars.SetValue("min_time_spawn_tank",9999)
Convars.SetValue("max_time_spawn_tank",9999)

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