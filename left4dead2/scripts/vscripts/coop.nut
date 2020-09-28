Msg("\n\n\n>>>>>>>>>>>>>>>>>>>>>>Common Coop Director Scripts Start Load<<<<<<<<<<<<<<<<<<<<<<<<\n");

//在coop.nut文件中的DirectorOptions是写死的，无法被其它脚本修改的内容，所以其中的内容的更改一定要谨慎
//可以被后面脚本覆写的参数写在ConVar中
DirectorOptions <-
{
	//这部分字段用于调试，其它时候请注释掉
	//CommonLimit = 0
	//ZombieTankHealth = 1
	//cm_MaxSpecials = 1
	//DominatorLimit = 0
	//BoomerLimit = 0
	//SmokerLimit = 0
	//HunterLimit = 0
	//SpitterLimit = 0
	//JockeyLimit = 0
	//ChargerLimit = 0
	//WitchLimit = 0
	//MaxSpecials = 12
	//DominatorLimit = 12
	//TankLimit = 24
	//WitchLimit = 24
	
	cm_MaxSpecials = 8 //先锁死刷特数量，熟悉后在改回来
	CommonLimit = 30
	TankLimit = 1
	//DominatorLimit = 7 //有控制能力的特要控制在7只,DominatorLimit这个参数貌似不会生效

	SpecialRespawnInterval = 10
	ProhibitBosses = false
	TankHitDamageModifierCoop = RandomFloat(1,5)
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS

	cm_AggressiveSpecials = true
	cm_ProhibitBosses = false
	AllowWitchesInCheckpoints = true
}


IntensityRelaxThreshold <- 0.80
RelaxMaxFlowTravel <- RandomInt(1200,1500)
RelaxMinInterval <- 99999
RelaxMaxInterval <- 99999
Convars.SetValue("director_intensity_relax_threshold",IntensityRelaxThreshold)
Convars.SetValue("director_relax_max_flow_travel",RelaxMaxFlowTravel)
Convars.SetValue("director_relax_min_interval",RelaxMinInterval)
Convars.SetValue("director_relax_max_interval",RelaxMaxInterval)

ZombieTankHealth <- RandomInt(8000,20000)
Convars.SetValue("z_tank_health",ZombieTankHealth)
Convars.SetValue("director_force_tank",0) //是否走两步就刷tank
Convars.SetValue("director_force_witch",0)


Convars.SetValue("l4d2_spawn_uncommons_autochance",3)
Convars.SetValue("l4d2_spawn_uncommons_autotypes",31)
Convars.SetValue("z_witch_always_kills",1)
Convars.SetValue("director_max_threat_areas",40)
Convars.SetValue("tongue_victim_max_speed",225)
Convars.SetValue("tongue_range",1500)

//插件配置参数修改
//tank生成插件，默认在15-20分钟刷一只克，有些关卡第一关可能不希望刷这么多（把刷克时间改的尽可能长就行），有些关卡则希望能多点
Convars.SetValue("min_time_spawn_tank",900)
Convars.SetValue("max_time_spawn_tank",1200)

//隐藏武器插件，有些三方图关卡不关闭隐藏武器会造成服务器闪退
Convars.SetValue("l4d2_wu_enable",1)


Msg("##################Relax Max Flow Travel:"+RelaxMaxFlowTravel+"\n");
Msg("##################Tank Health:"+ZombieTankHealth+"\n");
Msg("##################Tank Hit Damage Modifier Coop:"+DirectorOptions.TankHitDamageModifierCoop+"\n");

Msg(">>>>>>>>>>>>>>>>>>>>>>Common Coop Director Scripts Load Succeed<<<<<<<<<<<<<<<<<<<<<<<<\n\n\n\n");