Msg("\n\n\n");
Msg(">>>c10m3_church\n");
Msg("\n\n\n");
//教堂防守关触发

EntFire( "@director", "PanicEvent", 0 )
EntFire( "relay_enable_chuch_zombie_loop", "trigger", "", 90 )

DirectorOptions <-
{
}
