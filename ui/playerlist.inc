

#define ELEMENT_HEIGHT					16
#define PLAYERLIST_WIDTH				235
#ifdef PC
	#define PLAYERLIST_X				(-PLAYERLIST_WIDTH - 10)
#else // #ifdef PC
	#define PLAYERLIST_X				(-PLAYERLIST_WIDTH)
#endif // #else #ifdef PC

#define COLUMN_SCORE_WIDTH				34
#define RANK_BG_WIDTH					33
#define COLUMN_NAME_WIDTH				(PLAYERLIST_WIDTH - COLUMN_SCORE_WIDTH - RANK_BG_WIDTH)
#define PLAYER_FEEDER_Y					16

#define BACKGROUND_TEXTURE_COLOR		0 0 0 0.7
#define COLUMN_HEADER_COLOR				1 1 1 1

#ifndef PLAYERLIST_SELECTED_ACTIONS
	#define PLAYERLIST_SELECTED_ACTIONS ;
#endif

#undef PLAYERLIST_SCOREVIS
#define PLAYERLIST_SCOREVIS				( ( dvarbool( arcademode ) || dvarbool( zombiemode ) ) && !dvarInt( splitscreen ) && InLobby() )

#ifndef FEEDER_MENU_NAME
	#define FEEDER_MENU_NAME			"playerlist.inc needs a menu name defined"
#endif

#ifdef PARTY_THEME
	#define PLATING_COLOR				0.3 0.225 0.2 1
	#define HL_COLOR					1 0.85 0.825 0.2
	#define PARTY_LABEL_COLOR			1 0.925 0.7 0.07
	#define PARTY_LABEL_SCALE			1.75
#else
	#define PLATING_COLOR				0.175 0.2 0.25 1
	#define HL_COLOR					0.85 0.85 0.925 0.2
	#define PARTY_LABEL_COLOR			0.9 0.925 1 0.07
	#define PARTY_LABEL_SCALE			1.75
#endif

#ifdef SPLITSCREEN_PLAYERLIST
	
	#undef	PLATING_COLOR		
	#define PLATING_COLOR		0.2 0.2 0.225 1
	#undef	HL_COLOR			
	#define HL_COLOR			0.85 0.85 0.925 0.2
	#undef	PARTY_LABEL_COLOR	
	#define PARTY_LABEL_COLOR	0.9 0.925 1 0.07
	#undef	PARTY_LABEL		
	#define PARTY_LABEL			""
	#undef	PARTY_LABEL_SCALE	
	#define PARTY_LABEL_SCALE	1.75
	
	#ifndef PS3
		#undef	LIST_BOX_HEIGHT
		#define LIST_BOX_HEIGHT		149
	#else
		#undef	LIST_BOX_HEIGHT
		#define LIST_BOX_HEIGHT		310
	#endif
#endif

// do not want this listbox dependent on the dvar on PC
#undef LIST_DVAR_TEST
#ifdef PC
	#define LIST_DVAR_TEST
#else //#ifdef PC
	#define LIST_DVAR_TEST																											\
		dvarTest		ui_selectlobby																								\	
		enableDvar		{ "1" }
#endif //#ifdef PC

#ifdef PC
	#ifndef LIST_MODAL
	#define LIST_MODAL
	#endif
	#ifndef LIST_DECOR
	#define LIST_DECOR
	#endif
	#define PLAYERLIST_ONFOCUS_OR_MOUSEENTER	mouseenter
#else // #ifdef PC
	#define LIST_MODAL
	#define PLAYERLIST_ONFOCUS_OR_MOUSEENTER	onfocus
#endif // #else #ifdef PC
	
//#ifndef SYSTEMLINK_PLAYLIST
#define PLAYERLIST_PARTYFEEDER( feederName, feederArg, yOffsetArg, heightArg, disableColorArg, backColorArg, actionsArg, visArg )			\	
		itemDef																																\
		{																																	\
			name				feederName																									\
			type				ITEM_TYPE_LISTBOX																							\
			feeder				feederArg																									\
			rect				PLAYERLIST_X yOffsetArg PLAYERLIST_WIDTH heightArg HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP				\
			elementwidth		300																											\
			elementheight		ELEMENT_HEIGHT																								\
			elementtype			LISTBOX_TEXT																								\
			textfont			UI_FONT_SMALL																								\
			textscale			FONTSCALE_LOBBY																								\
			forecolor			1 1 1 1																										\
			focusColor			1 1 1 1																										\
			selectBorder		1 1 1 0.6																										\
			disableColor		disableColorArg																								\
			outlinecolor		0 0 0 0																										\
			backcolor			0 0 0 0																										\
			visible				when( visArg )																								\
			LIST_DECOR																														\
			LIST_DVAR_TEST																													\
			LIST_MODAL																														\
			noscrollbars																													\
			noBlinkingHighlight																												\
			/*					x		y	w					h	len		horzAlign			vertAlign*/									\
			userarea	8		-35		0	18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* controller icon	*/		\
								-17		0	18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* talking icon		*/		\
								0		0	PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* background		*/		\
								0		0	PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* alternating bg	*/		\
								0		0	0					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank bg			*/		\
								3		-1	18					18	2		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank				*/		\
								14		0	18					18	3		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank icon		*/		\
								34		-1	COLUMN_NAME_WIDTH	18	40		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* player name		*/		\
			PLAYERLIST_ONFOCUS_OR_MOUSEENTER																								\
			{																																\
				play CHOICE_FOCUS_SOUND;																									\
				hide selection_left;																										\
				show selection_right;																										\
				exec "updateListboxPos "FEEDER_MENU_NAME;																					\
			}																																\
			onListboxSelectionChange { play CHOICE_FOCUS_SOUND; }																			\
			actionsArg																														\
		}

#define	SCORE_START_X	(PLAYERLIST_WIDTH-COLUMN_SCORE_WIDTH-4)
		
#define PLAYERLIST_LOBBYFEEDER( feederName, feederArg, yOffsetArg, heightArg, disableColorArg, backColorArg, actionsArg, visArg )				\	
		itemDef																																	\
		{																																		\
			name				feederName																										\
			type				ITEM_TYPE_LISTBOX																								\
			feeder				feederArg																										\
			rect				PLAYERLIST_X yOffsetArg PLAYERLIST_WIDTH heightArg HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP					\
			elementwidth		300																												\
			elementheight		ELEMENT_HEIGHT																									\
			elementtype			LISTBOX_TEXT																									\
			textfont			UI_FONT_SMALL																									\
			textscale			FONTSCALE_LOBBY																									\
			forecolor			1 1 1 1																											\
			focusColor			1 1 1 1																											\
			selectBorder		1 1 1 0.6																											\
			disableColor		disableColorArg																									\
			outlinecolor		0 0 0 0																											\
			backcolor			0 0 0 0																											\
			visible				when( visArg )																									\
			LIST_DVAR_TEST																														\
			LIST_MODAL																															\
			LIST_DECOR																															\
			noscrollbars																														\
			noBlinkingHighlight																													\
			/*					x				y	w					h	len		horzAlign			vertAlign*/								\
			userarea	9		-35				0	18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* controller icon	*/	\
								-17				0	18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* talking icon		*/	\
								0				0	PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* background		*/	\
								0				0	PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* alternating bg	*/	\
								0				0	0					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank bg			*/	\
								3				-1	18					18	2		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank				*/	\
								14				0	18					18	3		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank icon		*/	\
								34				-1	COLUMN_NAME_WIDTH	18	40		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* player name		*/	\
								SCORE_START_X	-1	COLUMN_SCORE_WIDTH	18	9		ITEM_ALIGN_RIGHT	ITEM_ALIGN_TOP	/* score			*/	\
			PLAYERLIST_ONFOCUS_OR_MOUSEENTER																									\
			{																																	\
				play CHOICE_FOCUS_SOUND;																										\
				hide selection_left;																											\
				show selection_right;																											\
				exec "updateListboxPos "FEEDER_MENU_NAME;																						\
			}																																	\
			onListboxSelectionChange { play CHOICE_FOCUS_SOUND; }																				\
			actionsArg																															\
		}

#define PLAYERLIST_GAMELOBBYFEEDER( feederName, feederArg, yOffsetArg, heightArg, disableColorArg, backColorArg, actionsArg, visArg )			\	
		itemDef																														\
		{																															\
			name				feederName																										\
			type			ITEM_TYPE_LISTBOX																						\
			feeder			feederArg																								\
			rect			PLAYERLIST_X yOffsetArg PLAYERLIST_WIDTH heightArg HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP			\
			elementwidth		300																												\
			elementheight		ELEMENT_HEIGHT																									\
			elementtype			LISTBOX_TEXT																									\
			textfont			UI_FONT_SMALL																									\
			textscale			FONTSCALE_LOBBY																									\
			forecolor		1 1 1 1																									\	
			focusColor		1 1 1 1																									\
			selectBorder		1 1 1 0.6																											\
			disableColor		disableColorArg																									\
			outlinecolor		0 0 0 0																											\
			backcolor			0 0 0 0																											\
			visible				when( visArg )																									\
			LIST_DVAR_TEST																														\
			LIST_MODAL																															\
			LIST_DECOR																															\
			noscrollbars																											\
			noBlinkingHighlight																													\
			/*					x				y	w					h	len		horzAlign			vertAlign*/								\
			userarea	10		-35				0	18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* controller icon	*/	\
								-17				0	18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* talking icon		*/	\
								0				0	PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* background		*/	\
								0				0	PLAYERLIST_WIDTH	18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* alternating bg	*/	\
								0				0	0					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank bg			*/	\
								3				-1	18					18	2		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank				*/	\
								14				0	18					18	3		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* rank icon		*/	\
								34				-1	COLUMN_NAME_WIDTH	18	40		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* player name		*/	\
								SCORE_START_X	-1	COLUMN_SCORE_WIDTH	18	9		ITEM_ALIGN_RIGHT	ITEM_ALIGN_TOP	/* score			*/	\
								0				0	18					18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP	/* readyup icon		*/	\
			PLAYERLIST_ONFOCUS_OR_MOUSEENTER																									\
			{																														\
				play CHOICE_FOCUS_SOUND;																										\
				hide selection_left;																								\
				show selection_right;																								\
				exec "updateListboxPos "FEEDER_MENU_NAME;																						\
			}																														\
			onListboxSelectionChange { play CHOICE_FOCUS_SOUND; }																				\
			actionsArg																															\
		}

#ifdef PC
	#define PLAYERLIST_SCORE_X -60
#else // #ifdef PC
	#define PLAYERLIST_SCORE_X -50
#endif // #else #ifdef PC

#ifndef SPLITSCREEN_PLAYERLIST
		
		PREPROC_TEXT_DRAW(	PLAYERLIST_X (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 90 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
							dvarString( party_partyPlayerCount ), 
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, COLUMN_HEADER_COLOR )

		PREPROC_TEXT_DRAW_VIS(	PLAYERLIST_SCORE_X (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 50 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
								"@MPUI_SCORE_CAPS", 
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_RIGHT, COLUMN_HEADER_COLOR,
								when( PLAYERLIST_SCOREVIS ) )

#else	//	#ifndef SPLITSCREEN_PLAYERLIST
											
		PREPROC_TEXT_DRAW(	PLAYERLIST_X (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 90 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
							dvarString( splitscreen_partyPlayerCount ), 
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, COLUMN_HEADER_COLOR )
	
		PREPROC_TEXT_DRAW_VIS(	PLAYERLIST_SCORE_X (PLAYER_FEEDER_Y - ELEMENT_HEIGHT + 2 ) 50 ELEMENT_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 0, 
								"@MPUI_SCORE_CAPS", 
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_BOTTOM_RIGHT, COLUMN_HEADER_COLOR,
								when( PLAYERLIST_SCOREVIS ) )

#endif	//	#ifndef SPLITSCREEN_PLAYERLIST
		
#ifdef PC
#define LOBBY_LIST_BOX_HEIGHT					100
#else //#ifdef PC
#define LOBBY_LIST_BOX_HEIGHT					342
#endif //#ifdef PC

#ifndef SPLITSCREEN_PLAYERLIST
		#define TEAMBASED ( dvarbool( party_teambased ) && dvarbool( party_autoteams ) )
		#define COUNTDOWN ( dvarbool( party_timerVisible ) )
		#define CLANMATCH ( dvarbool( xblive_clanmatch ) )
		#define PLAYERLIST_PARTYVIS ((!COUNTDOWN || !TEAMBASED) && !InLobby())
		#define PLAYERLIST_MEMBERVIS (((!COUNTDOWN && !CLANMATCH) || !TEAMBASED) && InLobby())
		#define PLAYERLIST_TEAMSVIS ( ( COUNTDOWN || CLANMATCH ) && TEAMBASED && InLobby())

		PLAYERLIST_PARTYFEEDER( "partyList", FEEDER_PARTY_MEMBERS, PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, WHITE, BACKGROUND_TEXTURE_COLOR, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_PARTYVIS )

		PLAYERLIST_LOBBYFEEDER( "lobbyList", FEEDER_LOBBY_MEMBERS, PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, WHITE, BACKGROUND_TEXTURE_COLOR, PLAYERLIST_SELECTED_ACTIONS, !( !dvarbool( xblive_privatematch ) && dvarbool( onlinegame ) && !PLAYERLIST_TEAMSVIS ) )

		// game lobby with ready up icon
		PLAYERLIST_GAMELOBBYFEEDER( "lobbyList", FEEDER_LOBBY_MEMBERS, PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, WHITE, BACKGROUND_TEXTURE_COLOR, PLAYERLIST_SELECTED_ACTIONS, ( !dvarbool( xblive_privatematch ) && dvarbool( onlinegame ) && !PLAYERLIST_TEAMSVIS ) )

#else //#ifndef SPLITSCREEN_PLAYERLIST
		#define PLAYERLIST_TEAMSVIS		1

		PLAYERLIST_LOBBYFEEDER( "splitscreen_playerlist", FEEDER_SPLITSCREENPLAYERS, PLAYER_FEEDER_Y, LOBBY_LIST_BOX_HEIGHT, 1 1 1 1, 0.5 0.5 0.5 0, decoration, 1 )
#endif // #ifndef SPLITSCREEN_PLAYERLIST
	
	// private party host icon
#ifdef SHOW_PRIVATE_PARTY_HOST
		#define HOST_ICON_SIZE		14
		
#ifdef PC
		#define HOST_ICON_X ( -HOST_ICON_SIZE - 10 )
#else // #ifdef PC
		#define HOST_ICON_X ( -HOST_ICON_SIZE )
#endif // #else #ifdef PC

		PREPROC_SHADER_DRAW( HOST_ICON_X ( PLAYER_FEEDER_Y + 4 ) HOST_ICON_SIZE HOST_ICON_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, "ui_host", 0.825 0.825 0.825 0.7 )
#endif	
	
