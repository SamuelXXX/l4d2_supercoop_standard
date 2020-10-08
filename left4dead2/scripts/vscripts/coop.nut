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


	//以下几个字段千万不要去掉，否则会带来无限刷特的问题
	//不要在这里设置cm_MaxSpecials，也会引起无限刷特问题
	//TankHitDamageModifierCoop貌似已经过时，千万不要再使用了，否则也会带来无限刷特的问题
	//在这里设置CommonLimit=30，也会造成无限刷特的问题哦；不过设置为0就不会，真让人头大！
	//如果server.cfg中的参数和DirectorOptions中的参数重复的话，也会出现无限刷特的问题
	ActiveChallenge = 1
	cm_ShouldHurry = 1
	SustainPeakMinTime = 10
	SustainPeakMaxTime = 15
	IntensityRelaxThreshold = 0.95

	cm_SpecialRespawnInterval=7 
	cm_AggressiveSpecials = true
}


Convars.SetValue("z_tank_health",RandomInt(8000,20000))
Convars.SetValue("director_force_tank",0) //是否走两步就刷tank
Convars.SetValue("director_force_witch",0)


Convars.SetValue("l4d2_spawn_uncommons_autochance",3)
Convars.SetValue("l4d2_spawn_uncommons_autotypes",31)
Convars.SetValue("z_witch_always_kills",1)
Convars.SetValue("director_max_threat_areas",40)
Convars.SetValue("tongue_victim_max_speed",225)
Convars.SetValue("tongue_range",1500)

//插件配置参数修改
//tank生成插件，默认在10-15分钟刷一只克，有些关卡第一关可能不希望刷这么多（把刷克时间改的尽可能长就行），有些关卡则希望能多点
Convars.SetValue("min_time_spawn_tank",600)
Convars.SetValue("max_time_spawn_tank",900)


Msg(">>>>>>>>>>>>>>>>>>>>>>Common Coop Director Scripts Load Succeed<<<<<<<<<<<<<<<<<<<<<<<<\n\n\n\n");