Msg("Start elevator event\n");
//白森林
wf2MDMmax <- 25
wf2MDMmin <- 8
wf2MDMscan <- 3


DirectorOptions <-
{
	ProhibitBosses = true

	CommonLimit = 50
	cm_MaxSpecials = 8
	cm_DominatorLimit = 8
	
	PanicForever = 1
	
	MusicDynamicMobSpawnSize = wf2MDMmax
	MusicDynamicMobStopSize = wf2MDMmin
	MusicDynamicMobScanStopSize = wf2MDMscan

}
