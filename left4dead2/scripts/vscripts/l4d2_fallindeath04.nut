//坠入死亡
Msg("l4d2_fallindeath04 Auto Start Final---------------------------------------------------------------------\n");

function AutoStartFinal()
{
    Msg("** l4d2_fallindeath04 AutoStartFinal **\n")    
	EntFire( "@director", "EndScript" )
	EntFire( "autostartfinal_model", "Enable" )
    EntFire( "autostartfinal_model", "ForceFinaleStart" )
	EntFire( "autostartfinal_model", "Disable" )
}
