
#undef	CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN					HORIZONTAL_ALIGN_CENTER
#undef	CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN					VERTICAL_ALIGN_TOP

#undef	CHOICE_TEXTALIGN
#define CHOICE_TEXTALIGN						ITEM_ALIGN_MIDDLE_LEFT

#undef	CHOICE_GROUP
#define CHOICE_GROUP							"flyout"

#undef	CHOICE_FOCUS_SOUND
#define	CHOICE_FOCUS_SOUND						"uin_navigation_submenu_over"

#define SWITCH_LOBBIES_FLYOUT_BG_WIDTH			CHOICE_SIZE_X
#define SWITCH_LOBBIES_FLYOUT_BG_X_START		( -258 + BUTTON_BG_WIDTH + 1 )

#undef	CHOICE_X_START
#define CHOICE_X_START							SWITCH_LOBBIES_FLYOUT_BG_X_START
#undef	CHOICE_SEP_1
#define CHOICE_SEP_1							8
#undef	CHOICE_SEP_2
#define CHOICE_SEP_2							8

#define SWITCH_LOBBIES_FLYOUT_TIME				120

#define SWITCH_LOBBIES_FADE_STATE( nextIndex, colorArg, menuName, nextName, buttonCount )									\
		state																												\
		{																													\
			name		"FadeIn"																							\
			forecolor	colorArg																							\
																															\
			onEnter																											\
			{																												\
				execNow if( nextIndex != 0 ) ui_animate menuName nextName FadeIn (SWITCH_LOBBIES_FLYOUT_TIME/buttonCount);	\
				execNow if( nextIndex == 0 ) set ui_flownOut 1;																\
			}																												\
		}

#define SWITCH_LOBBIES_FLYOUT_ARGS( menuName, colorArg, myIndex, nextIndex, buttonCount )	\
		name		Flyout##myIndex															\
		SWITCH_LOBBIES_FADE_STATE( nextIndex, colorArg, menuName, Flyout##nextIndex, buttonCount )	

#define SWITCH_LOBBY_BUTTON_ENABLED( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, SWITCH_ACTION, VISIBILITY_TEST  ) \
	TEMP_CHOICE_HIGHLIGHT_SOLID_WIDTH( INDEX, BG_HL_COLOR, SWITCH_LOBBIES_FLYOUT_BG_WIDTH, dvarInt( ui_flownOut ) == 1 ) \
	TEMP_CHOICE_BUTTON_ALL( INDEX, TITLE, 	\
							SWITCH_ACTION, 	\
							setDvar ui_lobby_desc DESCRIPTION;, 	\
							CLEARUIHINT, \
							1 1 1 0, \
							(dvarBool(ui_ethernetLinkActive) && CanSwitchToLobby(dvarInt( PARTY_COUNT_DVAR ), dvarInt( SPLITSCREEN_PLAYER_COUNT_DVAR ) ) && (VISIBILITY_TEST)), \
							SWITCH_LOBBIES_FLYOUT_ARGS( MENU, TEXT_COLOR_NO_HL, INDEX, NEXT_INDEX, BUTTON_COUNT ) ) \
	TEMP_CHOICE_BUTTON_HIGHLIGHT_TEXT( INDEX, TITLE, TEXT_COLOR_HL, dvarInt( ui_flownOut ) == 1 && (CanSwitchToLobby(dvarInt( PARTY_COUNT_DVAR ), dvarInt( SPLITSCREEN_PLAYER_COUNT_DVAR ) ) && (VISIBILITY_TEST)) ) 

#define SWITCH_LOBBY_BUTTON_DISABLED( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, VISIBILITY_TEST) \
	TEMP_CHOICE_BUTTON_ALL( INDEX, TITLE,  \
							/*NO-OP*/;,  \ 
							setDvar ui_lobby_desc DESCRIPTION;,  \
							CLEARUIHINT, \
							1 1 1 0, \
							!(dvarBool(ui_ethernetLinkActive) && CanSwitchToLobby( dvarInt( PARTY_COUNT_DVAR ), dvarInt( SPLITSCREEN_PLAYER_COUNT_DVAR ) ) && (VISIBILITY_TEST)), \ 
							SWITCH_LOBBIES_FLYOUT_ARGS( MENU, MEDIUM_GRAY, INDEX, NEXT_INDEX, BUTTON_COUNT ) ) \ 
	TEMP_CHOICE_BUTTON_HIGHLIGHT_TEXT( INDEX, TITLE, MEDIUM_GRAY, dvarInt( ui_flownOut ) == 1 && !(CanSwitchToLobby(dvarInt( PARTY_COUNT_DVAR ), dvarInt( SPLITSCREEN_PLAYER_COUNT_DVAR ) ) && (VISIBILITY_TEST) ) ) 

#define SWITCH_LOBBY_BUTTON_DISABLEABLE( INDEX, NEXT_INDEX,BUTTON_COUNT,  MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, SWITCH_ACTION, VISIBILITY_TEST  ) \
	SWITCH_LOBBY_BUTTON_ENABLED( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, SWITCH_ACTION, VISIBILITY_TEST  ) \
	SWITCH_LOBBY_BUTTON_DISABLED( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, VISIBILITY_TEST )

#define SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, SWITCH_ACTION) \
	SWITCH_LOBBY_BUTTON_ENABLED( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, SWITCH_ACTION, 1  ) \ 
	SWITCH_LOBBY_BUTTON_DISABLED( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, TITLE, DESCRIPTION, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, 1 )


#define START_LOBBY_BUTTON_PLAYERMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_PLAYER_MATCH_CAPS", "@MPUI_PLAYER_MATCH_DESC", party_maxplayers_partylobby, party_maxlocalplayers_playermatch, START_ACTION_PLAYERMATCH ) 

#define SWITCH_LOBBY_BUTTON_PLAYERMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_PLAYER_MATCH_CAPS", "@MPUI_PLAYER_MATCH_DESC", party_maxplayers_partylobby, party_maxlocalplayers_playermatch, SWITCH_ACTION_PLAYERMATCH( CLOSE_MENU ) ) 

#define CONVERT_LOBBY_BUTTON_PLAYERMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_PLAYER_MATCH_CAPS", "@MPUI_PLAYER_MATCH_DESC", party_maxplayers_partylobby, party_maxlocalplayers_playermatch, CONVERT_ACTION_PLAYERMATCH( CLOSE_MENU ) ) 

#define START_LOBBY_BUTTON_PRIVATEMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_CUSTOM_MATCH_CAPS", "@MPUI_CUSTOM_MATCH_DESC", party_maxplayers_privatematch, party_maxlocalplayers_privatematch, START_ACTION_PRIVATEMATCH ) 

#define SWITCH_LOBBY_BUTTON_PRIVATEMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_CUSTOM_MATCH_CAPS", "@MPUI_CUSTOM_MATCH_DESC", party_maxplayers_privatematch, party_maxlocalplayers_privatematch, SWITCH_ACTION_PRIVATEMATCH( CLOSE_MENU ) ) 

#define CONVERT_LOBBY_BUTTON_PRIVATEMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_CUSTOM_MATCH_CAPS", "@MPUI_CUSTOM_MATCH_DESC", party_maxplayers_privatematch, party_maxlocalplayers_privatematch, CONVERT_ACTION_PRIVATEMATCH( CLOSE_MENU ) ) 

#define START_LOBBY_BUTTON_WAGERMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU ) \
	SWITCH_LOBBY_BUTTON_DISABLEABLE( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_WAGER_MATCH_CAPS", "@MPUI_WAGER_MATCH_DESC", party_maxplayers_wagerpartylobby, party_maxlocalplayers_wagermatch, START_ACTION_WAGERMATCH, dvarBool(ui_mpWagerMatchEnabled) ) 

#define SWITCH_LOBBY_BUTTON_WAGERMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON_DISABLEABLE( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_WAGER_MATCH_CAPS", "@MPUI_WAGER_MATCH_DESC", party_maxplayers_wagerpartylobby, party_maxlocalplayers_wagermatch, SWITCH_ACTION_WAGERMATCH( CLOSE_MENU ), dvarBool(ui_mpWagerMatchEnabled) ) 

#define CONVERT_LOBBY_BUTTON_WAGERMATCH( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON_DISABLEABLE( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_WAGER_MATCH_CAPS", "@MPUI_WAGER_MATCH_DESC", party_maxplayers_wagerpartylobby, party_maxlocalplayers_wagermatch, CONVERT_ACTION_WAGERMATCH( CLOSE_MENU ), dvarBool(ui_mpWagerMatchEnabled) ) 

#define START_LOBBY_BUTTON_THEATER( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU ) \
	SWITCH_LOBBY_BUTTON_DISABLEABLE( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_THEATER_LOBBY_CAPS", "@MPUI_THEATER_LOBBY_DESC", party_maxplayers_theater, party_maxlocalplayers_theater, START_ACTION_THEATER, dvarBool(ui_mpTheaterEnabled) ) 

#define SWITCH_LOBBY_BUTTON_THEATER( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON_DISABLEABLE( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_THEATER_LOBBY_CAPS", "@MPUI_THEATER_LOBBY_DESC", party_maxplayers_theater, party_maxlocalplayers_theater, SWITCH_ACTION_THEATER( CLOSE_MENU ), dvarBool(ui_mpTheaterEnabled) ) 

#define CONVERT_LOBBY_BUTTON_THEATER( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON_DISABLEABLE( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_THEATER_LOBBY_CAPS", "@MPUI_THEATER_LOBBY_DESC", party_maxplayers_theater, party_maxlocalplayers_theater, CONVERT_ACTION_THEATER( CLOSE_MENU ), dvarBool(ui_mpTheaterEnabled)  ) 

#define START_LOBBY_BUTTON_BASICTRAINING( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_BASICTRAINING_CAPS", "@MPUI_BASICTRAINING_DESC", party_maxplayers_basictraining, party_maxlocalplayers_basictraining, START_ACTION_BASIC_TRAINING ) 

#define SWITCH_LOBBY_BUTTON_BASICTRAINING( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_BASICTRAINING_CAPS", "@MPUI_BASICTRAINING_DESC", party_maxplayers_basictraining, party_maxlocalplayers_basictraining, SWITCH_ACTION_BASIC_TRAINING( CLOSE_MENU ) ) 

#define CONVERT_LOBBY_BUTTON_BASICTRAINING( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, CLOSE_MENU ) \
	SWITCH_LOBBY_BUTTON( INDEX, NEXT_INDEX, BUTTON_COUNT, MENU, "@MPUI_BASICTRAINING_CAPS", "@MPUI_BASICTRAINING_DESC", party_maxplayers_basictraining, party_maxlocalplayers_basictraining, CONVERT_ACTION_BASIC_TRAINING( CLOSE_MENU ) ) 

#define CREATE_LOBBY_FLYOUT( MENUNAME, MENU_CONTROL, FIRST_INDEX, IS_START_FLYOUT, BUTTON_COUNT, FLYOUT_BUTTON1, FLYOUT_BUTTON2, FLYOUT_BUTTON3, FLYOUT_BUTTON4, FLYOUT_BUTTON5 ) \
	menuDef \
	{	\
		name			MENUNAME		\
		rect			0 0 640 480		\
		focusColor		COLOR_FOCUSED	\
		soundloop 		MENU_MUSIC		\
		control			MENU_CONTROL	\
		\
		onOpen	\  
		{ \
			execNow ui_animate MENUNAME ButtonBackground Fly SWITCH_LOBBIES_FLYOUT_TIME;						\
			execNow ui_animate MENUNAME Flyout##FIRST_INDEX FadeIn (SWITCH_LOBBIES_FLYOUT_TIME/BUTTON_COUNT);	\
			execNow "set ui_flownOut 0";																		\ 
			setDvar ui_flyoutHasFocus FLYOUT_LIVE;																\
			setDvar ui_used_flyout IS_START_FLYOUT;																\
		} \
		onESC 	{ close self; } \
		onClose \
		{ \
			execNow ui_animate MENUNAME ButtonBackground	Default 0; \
			if ( FIRST_INDEX == 1 ) \
			{ \
				execNow ui_animate MENUNAME Flyout1		Default 0; \
			} \
			execNow ui_animate MENUNAME Flyout2		Default 0; \
			execNow ui_animate MENUNAME Flyout3		Default 0; \
			execNow ui_animate MENUNAME Flyout4		Default 0; \
			execNow ui_animate MENUNAME Flyout5		Default 0; \
			execNow "set ui_flownOut 0"; \
			setDvar ui_flyoutHasFocus FLYOUT_NONE; \
		} \
		\	
		/* button background */  \
		itemDef \
		{ \
			name			"ButtonBackground" \
			style			WINDOW_STYLE_SHADER \  
			rect			CHOICE_ORIGIN( FIRST_INDEX ) SWITCH_LOBBIES_FLYOUT_BG_WIDTH CHOICE_Y_SPACING CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN   \
			forecolor		FLYOUT_BG_COLOR  \
			background		"white"  \
			visible			1  \
			decoration  \
			state \
			{ \
				name	"Fly" \
				rect	CHOICE_ORIGIN( FIRST_INDEX ) SWITCH_LOBBIES_FLYOUT_BG_WIDTH (CHOICE_Y_SPACING * BUTTON_COUNT) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
			} \
		} \
		HINT_TEXT_ALL( (BUTTON_COUNT + FIRST_INDEX), (CHOICE_X( FIRST_INDEX ) + 10), (5), (SWITCH_LOBBIES_FLYOUT_BG_WIDTH - 10), (dvarString( ui_lobby_desc )), 1 1 1 1, ( dvarInt( ui_flownOut ) == 1 ), ; ) \
		FLYOUT_BUTTON1 \
		FLYOUT_BUTTON2 \
		FLYOUT_BUTTON3 \
		FLYOUT_BUTTON4 \
		FLYOUT_BUTTON5 \
		FRIENDS_BUTTON \
	}

#define NOOP /*NO-OP*/

#ifdef PUBLIC_BETA

#define START_BUTTON_COUNT 3
#define SWITCH_BUTTON_COUNT 2

#define START_LOBBY_FLYOUT( MENUNAME, FLYOUT_BUTTON1, FLYOUT_BUTTON2, FLYOUT_BUTTON3 ) \
		CREATE_LOBBY_FLYOUT( MENUNAME, MENU_CONTROL_NO_GUESTS, 1, 0, START_BUTTON_COUNT, FLYOUT_BUTTON1, FLYOUT_BUTTON2, FLYOUT_BUTTON3, NOOP, NOOP ) 

#define SWITCH_LOBBY_FLYOUT( MENUNAME, FLYOUT_BUTTON1, FLYOUT_BUTTON2 ) \
		CREATE_LOBBY_FLYOUT( MENUNAME, 0, 2, 1, SWITCH_BUTTON_COUNT, FLYOUT_BUTTON1, FLYOUT_BUTTON2, NOOP, NOOP, NOOP ) 

#define MAIN_START_LOBBIES_FLYOUT( name ) \
		START_LOBBY_FLYOUT( name, \
		START_LOBBY_BUTTON_PLAYERMATCH( 1, 2, START_BUTTON_COUNT, name ),  \
		START_LOBBY_BUTTON_WAGERMATCH( 2, 3, START_BUTTON_COUNT, name ), \
		START_LOBBY_BUTTON_THEATER( 3, 0, START_BUTTON_COUNT, name ) )

#define PLAYERMATCH_SWITCH_LOBBIES_FLYOUT( name, close_menu ) \
		SWITCH_LOBBY_FLYOUT( name, \
		SWITCH_LOBBY_BUTTON_WAGERMATCH( 2, 3, SWITCH_BUTTON_COUNT, name, close_menu ),  \
		CONVERT_LOBBY_BUTTON_THEATER( 3, 0, SWITCH_BUTTON_COUNT, name, close_menu ) )

#define WAGERMATCH_SWITCH_LOBBIES_FLYOUT( name, close_menu ) \
		SWITCH_LOBBY_FLYOUT( name, \
		SWITCH_LOBBY_BUTTON_PLAYERMATCH( 2, 3, SWITCH_BUTTON_COUNT, name, close_menu ),  \
		CONVERT_LOBBY_BUTTON_THEATER( 3, 0, SWITCH_BUTTON_COUNT, name, close_menu ) )
		
#else //NOT PUBLIC_BETA

#define START_BUTTON_COUNT 5
#define SWITCH_BUTTON_COUNT 4

#define START_LOBBY_FLYOUT( MENUNAME, FLYOUT_BUTTON1, FLYOUT_BUTTON2, FLYOUT_BUTTON3, FLYOUT_BUTTON4, FLYOUT_BUTTON5 ) \
		CREATE_LOBBY_FLYOUT( MENUNAME, MENU_CONTROL_NO_GUESTS, 1, 0, START_BUTTON_COUNT, FLYOUT_BUTTON1, FLYOUT_BUTTON2, FLYOUT_BUTTON3, FLYOUT_BUTTON4, FLYOUT_BUTTON5 ) 

#define SWITCH_LOBBY_FLYOUT( MENUNAME, FLYOUT_BUTTON1, FLYOUT_BUTTON2, FLYOUT_BUTTON3, FLYOUT_BUTTON4 ) \
		CREATE_LOBBY_FLYOUT( MENUNAME, 0, 2, 1, SWITCH_BUTTON_COUNT, FLYOUT_BUTTON1, FLYOUT_BUTTON2, FLYOUT_BUTTON3, FLYOUT_BUTTON4, NOOP ) 

#define MAIN_START_LOBBIES_FLYOUT( name ) \
		START_LOBBY_FLYOUT( name, \
		START_LOBBY_BUTTON_PLAYERMATCH( 1, 2, START_BUTTON_COUNT, name ),  \
		START_LOBBY_BUTTON_PRIVATEMATCH( 2, 3, START_BUTTON_COUNT, name ),  \
		START_LOBBY_BUTTON_WAGERMATCH( 3, 4, START_BUTTON_COUNT, name ), \
		START_LOBBY_BUTTON_BASICTRAINING( 4, 5, START_BUTTON_COUNT, name ), \
		START_LOBBY_BUTTON_THEATER( 5, 0, START_BUTTON_COUNT, name ) )

#define PLAYERMATCH_SWITCH_LOBBIES_FLYOUT( name, close_menu ) \
		SWITCH_LOBBY_FLYOUT( name, \
		CONVERT_LOBBY_BUTTON_PRIVATEMATCH( 2, 3, SWITCH_BUTTON_COUNT, name, close_menu ),  \
		SWITCH_LOBBY_BUTTON_WAGERMATCH( 3, 4, SWITCH_BUTTON_COUNT, name, close_menu ), \
		CONVERT_LOBBY_BUTTON_BASICTRAINING( 4, 5, SWITCH_BUTTON_COUNT, name, close_menu ), \
		CONVERT_LOBBY_BUTTON_THEATER( 5, 0, SWITCH_BUTTON_COUNT, name, close_menu ) )

#define WAGERMATCH_SWITCH_LOBBIES_FLYOUT( name, close_menu ) \
		SWITCH_LOBBY_FLYOUT( name, \
		SWITCH_LOBBY_BUTTON_PLAYERMATCH( 2, 3, SWITCH_BUTTON_COUNT, name, close_menu ), \
		CONVERT_LOBBY_BUTTON_PRIVATEMATCH( 3, 4, SWITCH_BUTTON_COUNT, name, close_menu ),  \
		CONVERT_LOBBY_BUTTON_BASICTRAINING( 4, 5, SWITCH_BUTTON_COUNT, name, close_menu ), \
		CONVERT_LOBBY_BUTTON_THEATER( 5, 0, SWITCH_BUTTON_COUNT, name, close_menu ) )

#define PRIVATEMATCH_SWITCH_LOBBIES_FLYOUT( name, close_menu ) \
		SWITCH_LOBBY_FLYOUT( name, \
		CONVERT_LOBBY_BUTTON_PLAYERMATCH( 2, 3, SWITCH_BUTTON_COUNT, name, close_menu ), \
		CONVERT_LOBBY_BUTTON_WAGERMATCH( 3, 4, SWITCH_BUTTON_COUNT, name, close_menu ), \
		SWITCH_LOBBY_BUTTON_BASICTRAINING( 4, 5, SWITCH_BUTTON_COUNT, name, close_menu ), \
		SWITCH_LOBBY_BUTTON_THEATER( 5, 0, SWITCH_BUTTON_COUNT, name, close_menu ) )

#define BASICTRAINING_SWITCH_LOBBIES_FLYOUT( name, close_menu ) \
		SWITCH_LOBBY_FLYOUT( name, \
		CONVERT_LOBBY_BUTTON_PLAYERMATCH( 2, 3, SWITCH_BUTTON_COUNT, name, close_menu ), \
		SWITCH_LOBBY_BUTTON_PRIVATEMATCH( 3, 4, SWITCH_BUTTON_COUNT, name, close_menu ),  \
		CONVERT_LOBBY_BUTTON_WAGERMATCH( 4, 5, SWITCH_BUTTON_COUNT, name, close_menu ), \
		SWITCH_LOBBY_BUTTON_THEATER( 5, 0, SWITCH_BUTTON_COUNT, name, close_menu ) )

#define THEATER_SWITCH_LOBBIES_FLYOUT( name, close_menu ) \
		SWITCH_LOBBY_FLYOUT( name, \
		CONVERT_LOBBY_BUTTON_PLAYERMATCH( 2, 3, SWITCH_BUTTON_COUNT, name, close_menu ), \
		SWITCH_LOBBY_BUTTON_PRIVATEMATCH( 3, 4, SWITCH_BUTTON_COUNT, name, close_menu ),  \
		CONVERT_LOBBY_BUTTON_WAGERMATCH( 4, 5, SWITCH_BUTTON_COUNT, name, close_menu ), \
		SWITCH_LOBBY_BUTTON_BASICTRAINING( 5, 0, SWITCH_BUTTON_COUNT, name, close_menu ) )

#endif