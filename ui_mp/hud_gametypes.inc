#ifdef PC
	#define	BOTTOM_RECT_X -5
	#define	BOTTOM_RECT_Y 2
#else
	#define	BOTTOM_RECT_X 0
	#define	BOTTOM_RECT_Y 2
#endif

#define ONLINEGAME (dvarInt( "onlinegame" ) && !dvarInt( "xblive_privatematch" ) )
#define ONLINEGAME_OFFSET 10

#define HUD_ALPHA 0.65
#define HUD_FOREGROUND_ALPHA 0.75
#define DPAD_ICON_ALPHA 0.65

#define NOT_SPECTATING (!spectatingClient())

#define TEAM_IS_LOSING	( 0 - ( team(score) < otherteam(score) ) )
#define TEAM_IS_LOSING2	( 0 - TEAM_IS_LOSING )

#define PLAYER_IS_LOSING	(0 - ( player(score) < scoreatrank(1) ) )
#define PLAYER_IS_LOSING2	(0 - PLAYER_IS_LOSING )

#define ISPREGAME BIT_PREGAME

#define SHOULD_DISPLAY_SCOREBAR !BIT_TEAM_SPECTATOR !BIT_DEMO_CAMERA_MODE_MOVIECAM !BIT_DEMO_ALL_GAME_HUD_HIDDEN !ISPREGAME	

#define BARWIDTH	400
#define RANK_ORIGIN 0 6

{
	assetGlobalDef
	{
		fadeClamp		1					// sets the fadeup alpha
		fadeCycle		1					// how often fade happens in milliseconds
		fadeAmount		0.1					// amount to adjust alpha per cycle
	}
}

#define HUD_VISIBILITY !BIT_IN_VEHICLE 