//坠入死亡
//-----------------------------------------------------
//
//
//-----------------------------------------------------
Msg("Initiating l4d2_fallindeath01 script\n");

local IntroNumberIni = 0

if ( RandomInt( 1, 100 ) < 50 )
{
	IntroNumberIni = 0
}
else
{
	IntroNumberIni = 1
}


if ( Director.GetGameMode() == "versus" )
{

Msg("Intro versus mode\n");
EntFire( "intro_choice", "InValue" , "2" )

}
else if ( Director.GetGameMode() == "coop" )
{

if ( IntroNumberIni == 0 ){
Msg("Intro longue coop mode\n");
EntFire( "intro_choice", "InValue" , "1" )
}
else
{
Msg("Intro courte coop mode\n");
EntFire( "intro_choice", "InValue" , "2" )
}


}

