#define ACTION_IF_UNLOCKED_FOR_PLAYER( itemIndex, execArg )								\
			if ( IS_ITEM_LOCKED( itemIndex ) ) 											\
			{																			\
				setDvar com_errorTitle "@MPUI_LOCKED_POPUP_TITLE";						\
				execnow set ui_temp GET_UNLOCK_LEVEL_STRING( itemIndex );		\
				setdvar com_errorMessage dvarString( ui_temp );		\
				open error_popmenu_lobby;												\
			}																			\
			else																		\
			{																			\
				execArg																	\
			}

#define SETUP_ACTION_CREATEACLASS								\				
		ACTION_IF_UNLOCKED_FOR_PLAYER( FEATURE_CREATE_A_CLASS,	\
			exec "set ui_cac_ingame 0";							\
			setdvar invite_visible "0";							\
			open cac_main;										\
		)
		
#define SETUP_ACTION_CONTRACTS			\				
		ACTION_IF_UNLOCKED_FOR_PLAYER( FEATURE_CONTRACTS, open menu_xboxlive_contracts; )
				
#define SETUP_ACTION_KILLSTREAKS		\				
		ACTION_IF_UNLOCKED_FOR_PLAYER( FEATURE_KILLSTREAKS, open menu_xboxlive_killstreaks; )
		
#define LOBBY_BUTTON( itemArg, textArg, descArg, actionArg, visArg ) \
	TEMP_CHOICE_BUTTON_FOCUS_VIS(	itemArg, textArg, \
								actionArg, \
								SET_HINT_TEXT( descArg ), \
								CLEARUIHINT, \
								visArg && dvarInt( ui_flyoutHasFocus ) == FLYOUT_NONE ) \
	PREPROC_TEXT_DRAW_VIS( CHOICE_RECT( itemArg ), 0 0, textArg, CHOICE_TEXTSIZE, CHOICE_TEXT_OFFSET_X, 0, CHOICE_TEXTALIGN, NO_BG_DISABLED_COLOR, when( visArg && dvarInt( ui_flyoutHasFocus ) != FLYOUT_NONE ); )
		
#define LOBBY_BUTTON_WITH_NEW( itemArg, textArg, descArg, actionArg, newArg, visArg ) \
	LOBBY_BUTTON( itemArg, textArg, descArg, actionArg, visArg ) \
	CHOICE_NEWICON_VIS(		itemArg, "menu_mp_lobby_new", when( newArg && visArg && dvarInt( ui_flyoutHasFocus ) == FLYOUT_NONE ) )
		
#define LOBBY_FEATURE_BUTTON( itemArg, itemIndex, textArg, descArg, actionArg, newArg, visArg ) \
	TEMP_CHOICE_BUTTON_FOCUS_VIS(	itemArg, textArg, \
									actionArg, \
									exec "set ui_votebutton 0"; SET_HINT_TEXT( descArg ) CLEAR_ITEM_NEW( itemIndex ), \
									CLEARUIHINT, \
									!IS_ITEM_LOCKED_FOR_ALL( itemIndex ) && dvarInt( ui_flyoutHasFocus ) == FLYOUT_NONE && visArg ) \
	TEMP_CHOICE_DBUTTON_FOCUS_VIS_EX(	itemArg, textArg, \
									exec "set ui_votebutton 0"; SET_HINT_TEXT( GET_UNLOCK_LEVEL_STRING( itemIndex ) ), \
									CLEARUIHINT, \
									IS_ITEM_LOCKED_FOR_ALL( itemIndex ) && dvarInt( ui_flyoutHasFocus ) == FLYOUT_NONE && visArg, ; ) \
	PREPROC_TEXT_DRAW_VIS( CHOICE_RECT( itemArg ), 0 0, textArg, CHOICE_TEXTSIZE, CHOICE_TEXT_OFFSET_X, 0, CHOICE_TEXTALIGN, NO_BG_DISABLED_COLOR, when( visArg && dvarInt( ui_flyoutHasFocus ) != FLYOUT_NONE ); ) \
	CHOICE_NEWICON_VIS(		itemArg, "menu_mp_lobby_new",		when( ( IS_ITEM_NEW( itemIndex ) || newArg )			&& visArg && dvarInt( ui_flyoutHasFocus ) == FLYOUT_NONE )	) \
	CHOICE_LOCKEDICON_VIS(	itemArg, "menu_mp_lobby_locked",	when( IS_ITEM_LOCKED_FOR_ALL( itemIndex )				&& visArg && dvarInt( ui_flyoutHasFocus ) == FLYOUT_NONE )	)
	
#define LOBBY_SWITCH_LOBBIES_BUTTON( itemIndex, actionArg, visArg ) \
	PREPROC_SHADER_DRAW_VIS_EX( CHOICE_ORIGIN( itemIndex ) (CHOICE_SIZE_X + 1) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, "white", FLYOUT_BG_COLOR, when( visArg && dvarInt( ui_flyoutHasFocus ) != FLYOUT_NONE );, ; ) \
	TEMP_CHOICE_BUTTON_FOCUS_VIS_EX(	itemIndex, "@MENU_SWITCH_LOBBIES_CAPS", \
									actionArg, \
									SET_HINT_TEXT( "@MPUI_SWITCH_LOBBIES_DESC" ), \
									CLEARUIHINT, \
									visArg, name switch_lobbies_button )