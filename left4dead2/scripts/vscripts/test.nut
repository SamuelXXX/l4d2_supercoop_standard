//--------------DO NOT MODIFY THIS---------------------------------------
local Dopts = DirectorScript.DirectorOptions;
//-----------------------------------------------------------------------
//巴塞罗那

//--------------------------SETTINGS-------------------------------------

//To change a specific setting for the director, just change the value on it. Follow the descriptions if you are lost.
//If you still have doubts about an option, please, read the plugins forum topic.

//----------------------SPECIAL INFECTED SETTINGS----------------------
Dopts.MaxSpecials <- 24; //Number of maximum special spawned by the director. (Default: 2) [Number of SI]

Dopts.BoomerLimit <- 0; //Number of boomers spawned at the same time. (Default: 1) [Number of boomers]
Dopts.SmokerLimit <- 0; //Number of smokers spawned at the same time. (Default: 1) [Number of smokers]
Dopts.HunterLimit <- 0; //Number of hunters spawned at the same time. (Default: 1) [Number of hunters]
Dopts.ChargerLimit <- 0; //Number of charger spawned at the same time. (Default: 1) [Number of chargers]
Dopts.SpitterLimit <- 0; //Number of spitters spawned at the same time. (Default: 1) [Number of spitters]
Dopts.JockeyLimit <- 0; //Number of jockeys spawned at the same time. (Default: 1) [Number of jockeys]

//------------------GENERAL DIRECTOR SETTINGS----------------------------------
Dopts.CommonLimit <- 0; //Maximum amount of common infected on the map (Default: 30)
Dopts.ProhibitBosses <- 1; //If set to 1, no Tanks or witches will be spawned at all. (Default: 0) [1: Yes 0: No]
Dopts.AlwaysAllowWanderers <- 0; //Always allow wander common infected?  [1: Yes 0: No]
Dopts.MobMinSize <- 0; //Minimum amount of common infected spawned in a mob (Default: 10) [Amount]
Dopts.MobMaxSize <- 0; //Maximum amount of common infected spawned in a mob (Default: 30) [Amount]
Dopts.SustainPeakMinTime <- 0; //Maximum amount of time that the director will be on 'Sustain Peak' mode [Seconds]
Dopts.SustainPeakMaxTime <- 0; //Minimum amount of time that the director will be on 'Sustain Peak' mode [Seconds]
Dopts.RelaxMinInterval <- 0; //Maximum amount of time that the director will be on 'Relaxed' mode [Seconds]
Dopts.RelaxMaxInterval <- 0; //Minimum amount of time that the director will be on 'Relaxed' mode [Seconds]
Dopts.RelaxMaxFlowTravel <- 7000; //Maximum amount of distance travelled by survivors before director disables 'Relaxed' mode [Value]
Dopts.SpecialRespawnInterval <- -1; //Special infected re-spawn interval (Default: 45) [Seconds]
Dopts.NumReservedWanderers <- 0; //Number of reserver common infected wanderers. Will always be this amount of wander infected (Default: 0) [Amount]implemented.