#define FILESHARE_FILETYPE_FILM         	1
#define FILESHARE_FILETYPE_CLIP         	2
#define FILESHARE_FILETYPE_SCREENSHOT   	3 
#define FILESHARE_FILETYPE_CUSTOMGAME   	4

#define FILESHARE_LOADHEATMAP_DELAY     	2000

#define FILESHARE_FRAME_HEIGHT				NEW_FRAME_DEFAULT_HEIGHT
#define FILESHARE_FRAME_WIDTH				( FILESHARE_FRAME_HEIGHT * FRAME_ASPECT_RATIO )

#define FILESHARE_MAP_WIDTH					230 
#define FILESHARE_MAP_HEIGHT				150
#define FILESHARE_MAP_NAME_WIDTH			100
#define FILESHARE_MAP_NAME_HEIGHT			20
#define FILESHARE_MAP_PAD					12

#define FILESHARE_DETAILS_PAD				( FILESHARE_MAP_PAD - 4 )
#define FILESHARE_DETAILS_BG_BAR_HEIGHT		20
#define FILESHARE_DETAILS_BG_HEIGHT			( FILESHARE_DETAILS_BG_BAR_HEIGHT * 6 )
#define FILESHARE_DETAILS_BG_WIDTH			( FILESHARE_MAP_WIDTH - 10 )
#define FILESHARE_DETAILS_BG_X( px )		( px + ( FILESHARE_MAP_WIDTH / 2 ) - ( FILESHARE_DETAILS_BG_WIDTH / 2 ) + 1 )
#define FILESHARE_DETAILS_BG_Y_OFFSET		5
#define FILESHARE_DETAILS_BG_Y( py )		( py + FILESHARE_MAP_HEIGHT + FILESHARE_DETAILS_BG_Y_OFFSET )

#define FILESHARE_TYPEICON_SIZE				64
#define FILESHARE_TYPEICON_X( px )			( FILESHARE_DETAILS_BG_X( px ) + ( FILESHARE_DETAILS_BG_WIDTH / 2 ) - ( FILESHARE_TYPEICON_SIZE / 2 ) )
#define FILESHARE_TYPEICON_Y( py )			( FILESHARE_DETAILS_BG_Y( py ) + ( FILESHARE_DETAILS_BG_HEIGHT / 2 ) - ( FILESHARE_TYPEICON_SIZE / 2 ) )

#ifdef CONSOLE
	#define FILESHARE_BACK_BUTTON_ACTION( px, py, actionArg )	\
		FILESHARE_BACK_BUTTON_TEXT( px, py )
#else // #ifdef CONSOLE
	#define FILESHARE_BACK_BUTTON_ACTION( px, py, actionArg ) \
		NEW_FRAME_BACK_BUTTON_ACTION( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT, actionArg )
#endif // #ifdef CONSOLE

#define FILESHARE_BACK_BUTTON_TEXT( px, py )\
	itemDef \
	{ \
		type			ITEM_TYPE_TEXT \
		rect			px ( py + 16 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
		text			"@PLATFORM_BACK" \
		textfont		CHOICE_TEXTFONT  \
		textscale		TEXTSIZE_DEFAULT  \
		textalign		ITEM_ALIGN_BOTTOM_LEFT  \
		visible			1  \
		decoration		\
	} 	
#define FILESHARE_RATING_BG_WIDTH			65
#define FILESHARE_RATING_BG_Y( py )			( py + FILESHARE_MAP_HEIGHT - FILESHARE_DETAILS_BG_BAR_HEIGHT - 9 )

#define FILESHARE_SLOTS_USERAREAS																\
		userarea 12		0	0	88	60	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\	
						95	0	88	60	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						190	0	88	60	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						1	1	86	58	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						96	1	86	58	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						191	1	86	58	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						55	26	32	32	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						150	26	32	32	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						245	26	32	32	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER   \
						0	-15	86	58	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						95	-15	86	58	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	\
						190	-15	86	58	50		HORIZONTAL_ALIGN_LEFT	VERTICAL_ALIGN_CENTER	

#define FILESHARE_BUTTON_TAGS( px, py, itemText, highLighted ) \
		/* left arrow */	\
		itemDef		\
		{	\
			style			WINDOW_STYLE_SHADER \
			rect			(px + FILESHARE_TAG_X_OFFSET-FILESHARE_TAG_ARROW_SPACING) py 18 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin			0 0 \
			background		"ui_arrow_left" \
			forecolor		0 0 0 1 \
			visible			when( highLighted  )\
			decoration \
		} \
		/* right arrow */\
		itemDef \
		{ \
			style			WINDOW_STYLE_SHADER \
			rect			(px+FILESHARE_TAG_X_OFFSET+FILESHARE_TAG_BUTTON_WIDTH+FILESHARE_TAG_ARROW_SPACING) py 18 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin			0 0 \
			background		"ui_arrow_right" \
			forecolor		0 0 0 1 \
			visible			when( highLighted )\
			decoration \
		}\
		/* Header */ \
		/* White Text */ \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(px+FILESHARE_TAG_X_OFFSET+2*FILESHARE_TAG_ARROW_SPACING-5) (py-2) 400 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_DEFAULT \
			textstyle 		ITEM_TEXTSTYLE_NORMAL \
			textalign		ITEM_ALIGN_MIDDLE \
			style			WINDOW_STYLE_FILLED \
			exp				text( itemText )\
			forecolor		1 1 1 1 \
			visible			when( !( highLighted ) )\
			decoration  \
		}\
		/* Black Text */ \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(px+FILESHARE_TAG_X_OFFSET+2*FILESHARE_TAG_ARROW_SPACING-5) (py-2) 400 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_DEFAULT \
			textstyle 		ITEM_TEXTSTYLE_NORMAL \
			textalign		ITEM_ALIGN_MIDDLE \
			style			WINDOW_STYLE_FILLED \
			exp				text( itemText )\
			forecolor		0 0 0 1 \
			visible			when( highLighted ) \
			decoration  \
		}\

#define FILESHARE_PROGRESS_INDICATOR_SIZE( px, py, pw, ph, showBG, visArg )												\
    itemDef                                                                                 							\
	{                                                                                       							\
			name            "frame"                                                         							\
			style           WINDOW_STYLE_SHADER_FRAMED																	\
			frame           16 0.5 FRAME_SIDE_ALL																		\
			background      "menu_mp_lobby_frame_circle"																\
			type			ITEM_TYPE_IMAGE                                                 							\
			rect			( px - ( pw / 2 ) ) ( py - ( ph / 2 ) ) pw ph HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
			forecolor		.2 .2 .2 0.5																				\
			visible			when( visArg && showBG )                                        							\
			decoration                                                                      							\
	}                                                                                       							\
	itemDef                                                                                 							\
	{                                                                                       							\
		style WINDOW_STYLE_SPINNER                                                          							\
		rect ( px - ( pw / 2 ) ) ( py - ( ph / 2 ) ) pw ph HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER				\
    	visible when( visArg )                                                              							\
		decoration                                                                          							\
	}

#define FILESHARE_PROGRESS_INDICATOR( px, py, visArg )  \
    FILESHARE_PROGRESS_INDICATOR_SIZE( px, py, 80, 80, 1, visArg )

#define FILESHARE_DOWNLOAD_PROGRESS_INDICATOR( px, py )									\
    FILESHARE_PROGRESS_INDICATOR( px, py, isTaskInProgress( "LiveFileShareReadFile" ) )	\
	itemDef                                                                             \
	{                                                                                   \
		type			ITEM_TYPE_TEXT                                                  \
		rect			px py 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER			\
		textfont		UI_FONT_NORMAL                                                  \
		textscale		TEXTSIZE_SMALL                                                  \
		textalign       ITEM_ALIGN_MIDDLE_CENTER                                        \
		exp				text ( getDownloadProgress() )                                  \
		visible			when( isTaskInProgress( "LiveFileShareReadFile" ) )             \
		decoration                                                                      \
	}

#define FILESHARE_UPLOAD_PROGRESS_INDICATOR( px, py )                                       \
    FILESHARE_PROGRESS_INDICATOR( px, py, isTaskInProgress( "LiveFileShareWriteFile" ) )	\
	itemDef                                                                                 \
	{                                                                                       \
		type			ITEM_TYPE_TEXT                                                      \
		rect		    px py 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER				\
		textfont		UI_FONT_NORMAL                                                      \   
		textscale		TEXTSIZE_SMALL                                                      \
		textalign       ITEM_ALIGN_MIDDLE_CENTER                                            \
		exp				text ( getUploadProgress() )                                        \
		visible			when( isTaskInProgress( "LiveFileShareWriteFile" ) )                \
		decoration                                                                          \
	}

#define FILESHARE_TASKSINPROGRESS								\
		isTaskInProgress( "LiveFileShareRemoveFile" ) == 1 ||	\
		isTaskInProgress( "LiveFileShareWriteFile" ) == 1 ||	\
		isTaskInProgress( "LiveFileShareSearch" ) == 1 ||		\
		isTaskInProgress( "LiveFileShareTransfer" ) == 1 ||		\
		isTaskInProgress( "LiveFileShareReadFile" ) == 1 ||     \
        isTaskInProgress( "LiveFileShareGetListing" ) == 1 ||   \
        isTaskInProgress( "LiveFileGetTopRated" ) == 1


#define FILESHARE_SEARCHPOPULATED( feederName ) \
		( getFeederData( feederName, "count" ) > 0.0 && !FILESHARE_SEARCHTASKS_TRUECONDITION( feederName ) )

#define FILESHARE_DETAILS_TYPEICON( px, py, hAlign, vAlign, menuName, feederName, visArg )		\
		PREPROC_SHADER_DRAW_VIS_EX(	FILESHARE_TYPEICON_X( px )									\
									FILESHARE_TYPEICON_Y( py )									\
									FILESHARE_TYPEICON_SIZE										\
									FILESHARE_TYPEICON_SIZE										\
									hAlign vAlign,												\
									( getFeederData( feederName, "typeIconName" ) ), 1 1 1 0.2,	\
									when( visArg && FILESHARE_SEARCHPOPULATED( feederName ) );,	\
									; )
	
#define FILESHARE_DETAILS_CR_BG( px, py, hAlign, vAlign, visArg )												\
		PREPROC_SHADER_DRAW_VIS_EX(	FILESHARE_DETAILS_BG_X( px )												\ 
									( FILESHARE_DETAILS_BG_Y( py ) + ( FILESHARE_DETAILS_BG_BAR_HEIGHT * 3 ) ) 	\
									FILESHARE_DETAILS_BG_WIDTH													\
									FILESHARE_DETAILS_BG_BAR_HEIGHT												\
									hAlign vAlign,																\ 
									"white", 0 0 0 0.1,															\
									when( visArg );, ; )														\
		PREPROC_SHADER_DRAW_VIS_EX(	FILESHARE_DETAILS_BG_X( px )												\ 
									( FILESHARE_DETAILS_BG_Y( py ) + ( FILESHARE_DETAILS_BG_BAR_HEIGHT * 2 ) )	\
									FILESHARE_DETAILS_BG_WIDTH													\
									FILESHARE_DETAILS_BG_BAR_HEIGHT												\
									hAlign vAlign,																\ 
									"white", 0 0 0 0.2,															\
									when( visArg );, ; )														

#define FILESHARE_DETAILS_BG( px, py, hAlign, vAlign, visArg )													\
		PREPROC_SHADER_DRAW_VIS_EX(	FILESHARE_DETAILS_BG_X( px )												\ 
									FILESHARE_DETAILS_BG_Y( py )												\
									FILESHARE_DETAILS_BG_WIDTH													\
									FILESHARE_DETAILS_BG_HEIGHT													\
									hAlign vAlign,																\ 
									"white", 0 0 0 0.1,															\
									when( visArg );, ; )														\
		PREPROC_SHADER_DRAW_VIS_EX(	FILESHARE_DETAILS_BG_X( px )												\ 
									( FILESHARE_DETAILS_BG_Y( py ) + ( FILESHARE_DETAILS_BG_BAR_HEIGHT * 2 ) )	\
									FILESHARE_DETAILS_BG_WIDTH													\
									FILESHARE_DETAILS_BG_BAR_HEIGHT												\
									hAlign vAlign,																\ 
									"white", 0 0 0 0.2,															\
									when( visArg );, ; )														\
		PREPROC_SHADER_DRAW_VIS_EX(	FILESHARE_DETAILS_BG_X( px )												\ 
									( FILESHARE_DETAILS_BG_Y( py ) + ( FILESHARE_DETAILS_BG_BAR_HEIGHT * 4 ) )	\
									FILESHARE_DETAILS_BG_WIDTH													\
									FILESHARE_DETAILS_BG_BAR_HEIGHT												\
									hAlign vAlign,																\ 
									"white", 0 0 0 0.2,															\
									when( visArg );, ; )

#define FILESHARE_MAP_AND_GAMETYPE( px, py, hAlign, vAlign, menuName, feederName, visArg )					\
		PREPROC_TEXT_DRAW_VIS(	( px + FILESHARE_MAP_WIDTH - FILESHARE_MAP_NAME_WIDTH - FILESHARE_MAP_PAD )	\
								( py + FILESHARE_MAP_HEIGHT - ( FILESHARE_MAP_NAME_HEIGHT * 2 ) )			\
								FILESHARE_MAP_NAME_WIDTH													\
								FILESHARE_MAP_NAME_HEIGHT													\
								hAlign vAlign, 0 0,															\
								locString( getFeederData( menuName, feederName, "mapName" ) ),				\
								TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_BOTTOM_RIGHT, 1 1 1 1,					\
								when( visArg ); )															\
		PREPROC_TEXT_DRAW_VIS(	( px + FILESHARE_MAP_WIDTH - FILESHARE_MAP_NAME_WIDTH - FILESHARE_MAP_PAD )	\
								( py + FILESHARE_MAP_HEIGHT - FILESHARE_MAP_NAME_HEIGHT )					\
								FILESHARE_MAP_NAME_WIDTH													\
								FILESHARE_MAP_NAME_HEIGHT													\
								hAlign vAlign, 0 0,															\
								getFeederData( menuName, feederName, "gametypeName" ),						\
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_RIGHT, 1 1 1 1,						\
								when( visArg ); )													

#define FILESHARE_DETAILS_NAME( px, py, hAlign, vAlign, menuName, feederName, visArg )  									\
		PREPROC_TEXT_DRAW_VIS(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD )									\
								FILESHARE_DETAILS_BG_Y( py )																\
								( FILESHARE_DETAILS_BG_WIDTH - ( FILESHARE_DETAILS_PAD * 2 ) )								\
								FILESHARE_DETAILS_BG_BAR_HEIGHT																\
								hAlign vAlign, 0 0,																			\
								getFeederData( menuName, feederName, "name" ),												\
								TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, 1 1 1 1,									\
								when( visArg && !USE_SMALLER_FONT ); )														\
		PREPROC_TEXT_DRAW_VIS(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD )									\
								FILESHARE_DETAILS_BG_Y( py )																\
								( FILESHARE_DETAILS_BG_WIDTH - ( FILESHARE_DETAILS_PAD * 2 ) )								\
								FILESHARE_DETAILS_BG_BAR_HEIGHT																\
								hAlign vAlign, 0 0,																			\
								getFeederData( menuName, feederName, "name" ),												\
								(TEXTSIZE_DEFAULT * FOREIGN_LANGUAGE_MULTIPLIER), 0, 0, ITEM_ALIGN_MIDDLE_LEFT, 1 1 1 1,	\
								when( visArg && USE_SMALLER_FONT ); ) 

#define FILESHARE_DETAILS_DESCRIPTION( px, py, hAlign, vAlign, menuName, feederName, visArg )							\
		PREPROC_TEXT_DRAW_VIS(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD )								\
								( FILESHARE_DETAILS_BG_Y( py ) + FILESHARE_DETAILS_BG_BAR_HEIGHT )						\
								( FILESHARE_DETAILS_BG_WIDTH - ( FILESHARE_DETAILS_PAD * 2 ) )							\
								FILESHARE_DETAILS_BG_BAR_HEIGHT															\
								hAlign vAlign, 0 0,																		\
								getFeederData( menuName, feederName, "description" ),									\
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, 1 1 1 1,									\
								when( visArg && !USE_SMALLER_FONT ); )													\
		PREPROC_TEXT_DRAW_VIS(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD )								\
								( FILESHARE_DETAILS_BG_Y( py ) + FILESHARE_DETAILS_BG_BAR_HEIGHT )						\
								( FILESHARE_DETAILS_BG_WIDTH - ( FILESHARE_DETAILS_PAD * 2 ) )							\
								FILESHARE_DETAILS_BG_BAR_HEIGHT															\
								hAlign vAlign, 0 0,																		\
								getFeederData( menuName, feederName, "description" ),									\
								(TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER), 0, 0, ITEM_ALIGN_MIDDLE_LEFT, 1 1 1 1,	\
								when( visArg && USE_SMALLER_FONT ); ) 

#define FILESHARE_DETAILS_BOTH( bgInfoLine, px, py, hAlign, vAlign, leftText, rightText, colorArg, visArg )			\
		PREPROC_TEXT_DRAW_VIS(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD )							\
								( FILESHARE_DETAILS_BG_Y( py ) + ( FILESHARE_DETAILS_BG_BAR_HEIGHT * bgInfoLine ) )	\
								( FILESHARE_DETAILS_BG_WIDTH - ( FILESHARE_DETAILS_PAD * 2 ) )						\
								FILESHARE_DETAILS_BG_BAR_HEIGHT														\
								hAlign vAlign, 0 0,																	\
								leftText,																			\
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, colorArg,								\
								when( visArg ); )																	\
		PREPROC_TEXT_DRAW_VIS(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD )							\
								( FILESHARE_DETAILS_BG_Y( py ) + ( FILESHARE_DETAILS_BG_BAR_HEIGHT * bgInfoLine ) )	\
								( FILESHARE_DETAILS_BG_WIDTH - ( FILESHARE_DETAILS_PAD * 2 ) )						\
								FILESHARE_DETAILS_BG_BAR_HEIGHT														\
								hAlign vAlign, 0 0,																	\
								rightText,																			\
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, colorArg,							\
								when( visArg ); ) 

#define FILESHARE_DETAILS_DATETIME( px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_BOTH(	2, px, py, hAlign, vAlign,									\
								locString( "@MENU_FILESHARE_DATETIME" ),					\
								getFeederData( menuName, feederName, "datetime" ),			\
								1 1 1 1, visArg )


#define FILESHARE_DETAILS_LENGTH( px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_BOTH(	3, px, py, hAlign, vAlign,									\
								locString( "@MENU_FILESHARE_LENGTH" ),						\
								getFeederData( menuName, feederName, "length" ),			\
								1 1 1 1, visArg )


#define FILESHARE_DETAILS_AUTHOR( px, py, hAlign, vAlign, menuName, feederName, visArg )    \
		FILESHARE_DETAILS_BOTH(	4, px, py, hAlign, vAlign,									\
								locString( "@MENU_FILESHARE_AUTHOR" ),						\
								getFeederData( menuName, feederName, "author" ),			\
								1 1 1 1, visArg )

#define FILESHARE_DETAILS_TOTALVOTES( px, py, hAlign, vAlign, menuName, feederName, visArg )    \
		FILESHARE_DETAILS_BOTH(	5, px, py, hAlign, vAlign,										\
								locString( "@MENU_FILESHARE_TOTALVOTES" ),						\
								int( getFeederData( menuName, feederName, "getTotalVotes" ) ),	\
								1 1 1 1, visArg )


#define FILESHARE_DETAILS_RATINGBG( px, py, hAlign, vAlign, menuName, feederName, visArg )		\
		PREPROC_SHADER_DRAW_VIS_EX(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD )	\
									FILESHARE_RATING_BG_Y( py )									\
									FILESHARE_RATING_BG_WIDTH									\
									FILESHARE_DETAILS_BG_BAR_HEIGHT								\
									hAlign vAlign,												\
									"white", 0.0 0.0 0.0 0.4,									\
									when( visArg && FILESHARE_SEARCHPOPULATED( feederName ) );,	\
									; ) 

#define FILESHARE_DETAILS_RATING( px, py, hAlign, vAlign, feederName, visArg )					\
		PREPROC_OWNERDRAW_ALL(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD + 2 )	\
								( FILESHARE_RATING_BG_Y( py ) + 3 )								\
								12																\
								12																\
								hAlign vAlign,													\
								1 1 1 0.2, UI_FILESHARE_RATING,									\
								when( visArg && FILESHARE_SEARCHPOPULATED( feederName ) ), ; )	

#define FILESHARE_DETAILS_RATING_PRIVATE( px, py, hAlign, vAlign, feederName, visArg )			\
		PREPROC_OWNERDRAW_ALL(	( FILESHARE_DETAILS_BG_X( px ) + FILESHARE_DETAILS_PAD  + 2 )	\
								( FILESHARE_RATING_BG_Y( py ) + 3 )								\
								12																\
								12																\
								hAlign vAlign,													\
								1 1 1 0.2, UI_FILESHARE_PRIVATERATING,							\
								when( visArg && FILESHARE_SEARCHPOPULATED( feederName ) ), ; )	
	

#define FILESHARE_DETAILS_COMMON( px, py, hAlign, vAlign, menuName, feederName, visArg )								\
		itemDef																											\
		{																												\
			style			WINDOW_STYLE_SHADER_FRAMED																	\
			rect			px py FILESHARE_MAP_WIDTH FILESHARE_MAP_HEIGHT hAlign vAlign 								\
			frame           16 0.5 FRAME_SIDE_ALL																		\
			background      "menu_mp_lobby_frame_circle"																\
			forecolor       0.4 0.4 0.4 0.2																				\
			visible         when( visArg && getFeederData( feederName, "count" ) < 1.0 );								\
			decoration																									\
		}																												\
		/* Map image */																									\
		PREPROC_SHADER_DRAW_VIS_EX( px py FILESHARE_MAP_WIDTH FILESHARE_MAP_HEIGHT hAlign vAlign,						\
									( "menu_" + getFeederData( feederName, "map" ) + "_map_select_final" ), 1 1 1 0.7,	\
									when( visArg && FILESHARE_SEARCHPOPULATED( feederName ) );,							\
									; )                                                                                 \
		FILESHARE_MAP_AND_GAMETYPE(	px, py, hAlign, vAlign,																\
									menuName, feederName, visArg && FILESHARE_SEARCHPOPULATED( feederName ) )			


#define FILESHARE_DETAILS_FILMSANDCLIPS( px, py, hAlign, vAlign, menuName, feederName, visArg )																\
		FILESHARE_DETAILS_COMMON(		px, py, hAlign, vAlign, menuName, feederName, visArg	)															\
		FILESHARE_DETAILS_NAME(			px, py, hAlign, vAlign, menuName, feederName, visArg	)															\
		FILESHARE_DETAILS_DESCRIPTION(	px, py, hAlign, vAlign, menuName, feederName, visArg	)															\
		FILESHARE_DETAILS_DATETIME(		px, py, hAlign, vAlign, menuName, feederName, visArg	)															\
		FILESHARE_DETAILS_LENGTH(		px, py, hAlign, vAlign, menuName, feederName, visArg	)															\
		FILESHARE_DETAILS_AUTHOR(		px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && getFeederData( feederName, "fileType" ) != "film"	)	\
		FILESHARE_DETAILS_TOTALVOTES(	px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && getFeederData( feederName, "fileType" ) != "film"	)	\
		FILESHARE_DETAILS_TOTALVOTES(	px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && getFeederData( feederName, "fileType" ) == "film"	)       
    
#define FILESHARE_DETAILS_SCREENSHOT( px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_COMMON(		px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_NAME(			px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_DESCRIPTION(	px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_DATETIME(		px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_AUTHOR(		px, py, hAlign, vAlign, menuName, feederName, visArg )	\
		FILESHARE_DETAILS_TOTALVOTES(	px, py, hAlign, vAlign, menuName, feederName, visArg )       

#define FILESHARE_DETAILS_CUSTOMGAMES( px, py, hAlign, vAlign, menuName, feederName, visArg )						\
		itemDef																										\
		{																											\
			style			WINDOW_STYLE_SHADER_FRAMED																\
			rect			( px + 5 ) py ( FILESHARE_MAP_WIDTH - 8 ) ( FILESHARE_MAP_HEIGHT - 2 ) hAlign vAlign 	\
			frame           16 0.5 FRAME_SIDE_ALL																	\
			background      "menu_mp_lobby_frame_circle"															\
			forecolor       0 0 0 0.3																				\
			visible         when( visArg && FILESHARE_SEARCHPOPULATED( feederName ) );								\
			decoration																								\
		}																											\
		PREPROC_SHADER_DRAW_VIS_EX(	( px + ( ( FILESHARE_MAP_WIDTH - 8 ) / 2 ) - ( FILESHARE_MAP_HEIGHT / 2 ) )		\
									py																				\
									FILESHARE_MAP_HEIGHT															\
									FILESHARE_MAP_HEIGHT															\
									hAlign vAlign,																	\
									"playlist_custom", 1 1 1 0.7,													\
									when( visArg && FILESHARE_SEARCHPOPULATED( feederName ) );, ; )					\
		FILESHARE_DETAILS_NAME(			px, py, hAlign, vAlign, menuName, feederName, visArg )						\
		FILESHARE_DETAILS_DESCRIPTION(	px, py, hAlign, vAlign, menuName, feederName, visArg )						\
		FILESHARE_DETAILS_DATETIME(		px, py, hAlign, vAlign, menuName, feederName, visArg )						\
		FILESHARE_DETAILS_AUTHOR(		px, py, hAlign, vAlign, menuName, feederName, visArg )						\
		FILESHARE_DETAILS_TOTALVOTES(	px, py, hAlign, vAlign, menuName, feederName, visArg )       
    
#define FILESHARE_DETAILS_COMBATRECORD( px, py, hAlign, vAlign, menuName, feederName, visArg )                      \
        FILESHARE_DETAILS_CR_BG( px, py, hAlign, vAlign, visArg )                                                   \
        FILESHARE_DETAILS_BOTH(	2, px, py, hAlign, vAlign,									                        \
								locString( "@MENU_FILESHARE_DATETIME" ),					                        \
								getFeederData( menuName, feederName, "datetime" ),			                        \
								1 1 1 1, visArg )                                                                            \
        FILESHARE_DETAILS_BOTH(	3, px, py, hAlign, vAlign,									                        \
								locString( "@MENU_FILESHARE_LENGTH" ),						                        \
								getFeederData( menuName, feederName, "length" ),			                        \
								1 1 1 1, visArg )
            
    
/* SLOT EMPTY */
#define SLOT_EMPTY_CONDITION( menuName, feederName )	\
		( getFeederData( menuName, feederName, "slotOccupied" ) != 1 )

#define FILESHARE_EMPTYSLOT_DETAILS( px, py, hAlign, vAlign, menuName, feederName )									\
		/* Blank image */																							\
		itemDef																										\
		{																											\
			style			WINDOW_STYLE_SHADER_FRAMED																\
			rect			( px + 5 ) py ( FILESHARE_MAP_WIDTH - 8 ) ( FILESHARE_MAP_HEIGHT - 2 ) hAlign vAlign 	\
			frame           16 0.5 FRAME_SIDE_ALL																	\
			background      "menu_mp_lobby_frame_circle"															\
			forecolor       0 0 0 0.3																				\
			visible         when( SLOT_EMPTY_CONDITION( menuName, feederName ) );									\
			decoration																								\
		}																											\
		/* Slot Empty Text */																						\
		PREPROC_TEXT_DRAW_VIS(	( px + 5 + ( ( FILESHARE_MAP_WIDTH - 8 ) / 2 ) - ( FILESHARE_MAP_NAME_WIDTH / 2 ) )	\
								( py + ( ( FILESHARE_MAP_HEIGHT - 2 ) / 2 ) - ( FILESHARE_MAP_NAME_HEIGHT / 2 ) )	\
								FILESHARE_MAP_NAME_WIDTH															\
								FILESHARE_MAP_NAME_HEIGHT															\
								hAlign vAlign, 0 0,																	\
								locString( "MENU_FILESHARE_SLOTEMPTY" ),											\
								TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0.2,						\
								when( SLOT_EMPTY_CONDITION( menuName, feederName ) ); )			

/* SLOT CLASSIFIED */
#define SLOT_CLASSIFIED_CONDITION( menuName, feederName )		( getFeederData( menuName, feederName, "slot" ) > 6 )
#define CLASSIFIED_IMAGE_WIDTH									200
#define CLASSIFIED_IMAGE_HEIGHT									180
#define CLASSIFIED_IMAGE_X( px )								( px + 5 + ( ( FILESHARE_MAP_WIDTH - 8 ) / 2 ) - ( CLASSIFIED_IMAGE_WIDTH / 2 ) )
#define CLASSIFIED_IMAGE_Y( py )								( py + ( ( FILESHARE_MAP_HEIGHT - 2 ) / 2 ) - ( CLASSIFIED_IMAGE_HEIGHT / 2 ) )

#define FILESHARE_CLASSIFIEDSLOT_DETAILS( px, py, hAlign, vAlign, menuName, feederName )							\
		/* Blank image */																							\
		itemDef																										\
		{																											\
			style			WINDOW_STYLE_SHADER_FRAMED																\
			rect			( px + 5 ) py ( FILESHARE_MAP_WIDTH - 8 ) ( FILESHARE_MAP_HEIGHT - 2 ) hAlign vAlign 	\
			frame           16 0.5 FRAME_SIDE_ALL																	\
			background      "menu_mp_lobby_frame_circle"															\
			forecolor       0 0 0 0.3																				\
			visible         when( SLOT_CLASSIFIED_CONDITION( menuName, feederName ) );								\
			decoration																								\
		}																											\
		/* Classified Image */																						\
		PREPROC_SHADER_DRAW_VIS_EX(	CLASSIFIED_IMAGE_X( px )														\
									CLASSIFIED_IMAGE_Y( py )														\
									CLASSIFIED_IMAGE_WIDTH															\
									CLASSIFIED_IMAGE_HEIGHT															\
									hAlign vAlign,																	\
									"menu_mp_lobby_classified", 1 1 1 0.3,											\
									when( SLOT_CLASSIFIED_CONDITION( menuName, feederName ) );, rotation -30; )

#define FILMSANDCLIPS_CONDITION( feederName )	\
		( getFeederData( feederName, "fileType" ) != "screenshot" && getFeederData( feederName, "fileType" ) != "customgamemode" )
#define SCREENSHOT_CONDITION( feederName )		\
		( getFeederData( feederName, "fileType" ) == "screenshot" && getFeederData( feederName, "fileType" ) != "customgamemode" )
#define CUSTOMGAMES_CONDITION( feederName )		\
		( getFeederData( feederName, "fileType" ) == "customgamemode" )

#define FILESHARE_DETAILS( px, py, hAlign, vAlign, menuName, feederName, visArg )																	\
		FILESHARE_DETAILS_TYPEICON(			px, py, hAlign, vAlign, menuName, feederName, visArg )													\
		FILESHARE_DETAILS_BG(				px, py, hAlign, vAlign, visArg )																		\
   		FILESHARE_DETAILS_FILMSANDCLIPS(	px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && FILMSANDCLIPS_CONDITION( feederName )	)	\
		FILESHARE_DETAILS_SCREENSHOT(		px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && SCREENSHOT_CONDITION( feederName )		)	\  
		FILESHARE_DETAILS_CUSTOMGAMES(		px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && CUSTOMGAMES_CONDITION( feederName )		)	\  
		FILESHARE_DETAILS_RATINGBG(			px, py, hAlign, vAlign, menuName, feederName, visArg )      											\
		FILESHARE_DETAILS_RATING_PRIVATE(	px, py, hAlign, vAlign, feederName, visArg )															\
		FILESHARE_EMPTYSLOT_DETAILS(		px, py, hAlign, vAlign, menuName, feederName )															

#define FILESHARE_DETAILS_COMMUNITY( px, py, hAlign, vAlign, menuName, feederName, visArg )				\
		FILESHARE_DETAILS_TYPEICON(			px, py, hAlign, vAlign, menuName, feederName, visArg )		\
		FILESHARE_DETAILS_BG(				px, py, hAlign, vAlign, visArg )							\
		FILESHARE_DETAILS_FILMSANDCLIPS(	px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && getFeederData( feederName, "fileType" ) != "screenshot" && getFeederData( feederName, "fileType" ) != "customgamemode" ) \
		FILESHARE_DETAILS_SCREENSHOT(		px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && getFeederData( feederName, "fileType" ) == "screenshot" && getFeederData( feederName, "fileType" ) != "customgamemode" )    \  
		FILESHARE_DETAILS_CUSTOMGAMES(		px, py, hAlign, vAlign, menuName, feederName, ( visArg ) && getFeederData( feederName, "fileType" ) == "customgamemode" )    \  
		FILESHARE_DETAILS_RATINGBG(			px, py, hAlign, vAlign, menuName, feederName, visArg )      \
		FILESHARE_DETAILS_RATING(			px, py, hAlign, vAlign, feederName, visArg )
    
    

#define FILESHARE_MOVIE_DETAILS( px, py, hAlign, vAlign, visArg )   \
    itemDef     \
	{   \
		type			ITEM_TYPE_TEXT      \
		rect			px py 50 CHOICE_POPUP_TITLE_HEIGHT hAlign vAlign     \
		exp				text( getMySlotInfo( 20, "name" ) );   \
		textfont		UI_FONT_NORMAL      \
		textscale		TEXTSIZE_DEFAULT    \
		textAlign		ITEM_ALIGN_LEFT    \
		textstyle		ITEM_TEXTSTYLE_NORMAL    \
		forecolor		CHOICE_TEXTCOLOR    \
		visible			when( visArg );     \
		decoration  \
	}   \
    itemDef     \
	{   \
		type			ITEM_TYPE_TEXT      \
		rect			px ( py + 20 ) 50 CHOICE_POPUP_TITLE_HEIGHT hAlign vAlign     \
		exp				text( getMySlotInfo( 20, "description" ) );   \
		textfont		UI_FONT_NORMAL      \
		textscale		TEXTSIZE_DEFAULT    \
		textAlign		ITEM_ALIGN_LEFT    \
		textstyle		ITEM_TEXTSTYLE_NORMAL    \
		forecolor		CHOICE_TEXTCOLOR    \
		visible			when( visArg );     \
		decoration  \
	}   \
    itemDef     \
	{   \
		type			ITEM_TYPE_TEXT  \
		rect			px ( py + 40 ) 50 CHOICE_POPUP_TITLE_HEIGHT hAlign vAlign   \
		exp				text( locString( "@MENU_FILESHARE_DATETIME" ) );    \
		textfont		UI_FONT_NORMAL  \
		textscale		TEXTSIZE_DEFAULT  \
		textAlign		ITEM_ALIGN_LEFT    \
		textstyle		ITEM_TEXTSTYLE_NORMAL    \
		forecolor		CHOICE_TEXTCOLOR    \
		visible			when( visArg );   \
		decoration  \ 
	}       \
    itemDef     \
	{   \
		type			ITEM_TYPE_TEXT  \
		rect			( px + 155) ( py + 40 ) 75 CHOICE_POPUP_TITLE_HEIGHT hAlign vAlign  \
		exp				text( ( getMySlotInfo( 20, "datetime" ) );    \
		textfont		UI_FONT_NORMAL  \
		textscale		TEXTSIZE_DEFAULT  \
		textAlign		ITEM_ALIGN_RIGHT    \
		textstyle		ITEM_TEXTSTYLE_NORMAL    \
		forecolor		CHOICE_TEXTCOLOR    \
		visible			when( visArg );   \
		decoration  \
	}  \
    itemDef     \
	{   \
		type			ITEM_TYPE_TEXT  \
		rect			px ( py + 60 ) 50 CHOICE_POPUP_TITLE_HEIGHT hAlign vAlign   \
		exp				text( locString( "@MENU_FILESHARE_LENGTH" ) );  \
		textfont		UI_FONT_NORMAL    \
		textscale		TEXTSIZE_DEFAULT  \
		textAlign		ITEM_ALIGN_LEFT    \
		textstyle		ITEM_TEXTSTYLE_NORMAL    \
		forecolor		CHOICE_TEXTCOLOR    \
		visible			when( visArg );   \
		decoration  \
	}   \
	itemDef     \
	{   \
		type			ITEM_TYPE_TEXT  \
		rect			( px + 155 ) ( py + 60 ) 75 CHOICE_POPUP_TITLE_HEIGHT hAlign vAlign  \
		exp				text( ( getMySlotInfo( 20, "length" ) );  \
		textfont		UI_FONT_NORMAL  \
		textscale		TEXTSIZE_DEFAULT  \
		textAlign		ITEM_ALIGN_RIGHT    \
		textstyle		ITEM_TEXTSTYLE_NORMAL    \
		forecolor		CHOICE_TEXTCOLOR    \
		visible			when( visArg );   \
		decoration  \
	}      
   

#define FILESHARE_SPINNERNAME( spinnerName, px, py, visArg, singleRotationMS ) \
	itemDef {	\
		name			spinnerName	\
		style			WINDOW_STYLE_SPINNER \
		rect			px py 64 64 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
		origin 			-31 -31		\
		forecolor		1 1 1 1 \
		border			0	\
		visible			visArg	\
		decoration	\
	}

#define FILESHARE_SPINNER( px, py, visArg, singleRotationMS ) \
	FILESHARE_SPINNERNAME( spinner, px, py, visArg, singleRotationMS )
	
#ifdef PC
#define SEARCH_SPINNER_PC_ACTIONS( disableArg )																				\
	execkeyint		K_RIGHTARROW	{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftRight;	} } \
	execkeyint		K_LEFTARROW		{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftLeft;	} } \
	execkeyint		K_MOUSE1		{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftRight;	} } \
	execkeyint		K_MOUSE2		{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftLeft;	} }
#else //#ifdef PC
#define SEARCH_SPINNER_PC_ACTIONS( disableArg )
#endif //#ifdef PC

#define SEARCH_SPINNER( itemText, rowNum, nextItemIndex, prevItemIndex, px, py, pw, focusAction, visArg, disableArg ) \
		/* back highlight */\
		itemDef \
		{ \
			style			WINDOW_STYLE_SHADER \
			rect			( px - 90 ) py pw 15   \
			background		"white"  \
			forecolor		1 1 1 1 \
			visible			when( hasFocus( "fileShareSearchRow"#rowNum ) && visArg )\
			decoration \
		} \
		/* left arrow */	\
		itemDef		\
		{	\
			style			WINDOW_STYLE_SHADER \
			rect			px py 15 15  \
			origin			0 0 \
			background		"ui_arrow_left" \
			forecolor		DARK_GRAY\
			visible			when( hasFocus( "fileShareSearchRow"#rowNum ) && visArg )\
			decoration \
		} \
		/* right arrow */\
		itemDef \
		{ \
			style			WINDOW_STYLE_SHADER \
			rect			( px + 150 ) py 15 15   \
			origin			0 0 \
			background		"ui_arrow_right" \
			forecolor		DARK_GRAY\
			visible			when( hasFocus( "fileShareSearchRow"#rowNum ) && visArg )\
			decoration \
		}\
		/* Header */ \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			( px - 85 ) ( py + 15 ) 0 0     \
			forecolor		TEXT_COLOR_NO_HL \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			style			WINDOW_STYLE_FILLED \
			exp				text( locString( itemText ) )\
			visible			when( !hasFocus( "fileShareSearchRow"#rowNum ) && visArg && !disableArg )\
			decoration  \
		}\
        itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			( px - 85 ) ( py + 15 ) 0 0     \
			forecolor		TEXT_COLOR_HL \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			style			WINDOW_STYLE_FILLED \
			exp				text( locString( itemText ) )\
			visible			when( hasFocus( "fileShareSearchRow"#rowNum ) && visArg && !disableArg )\
			decoration  \
		}\
        itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			( px - 85 ) ( py + 15 ) 0 0     \
			forecolor		0.5 0.5 0.5 0.5 \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			style			WINDOW_STYLE_FILLED \
			exp				text( locString( itemText ) )\
			visible			when( visArg && disableArg )\
			decoration  \
		}\
        /* Data */\
		itemDef \
		{	\
			name			"fileShareSearchRow"#rowNum \
			type			ITEM_TYPE_BUTTON_NO_TEXT	\
			rect			( px + 4 ) py pw 15   \
			onFocus			{ play CHOICE_FOCUS_SOUND; focusAction;	}	\
			action			{ if( !disableArg ) { play CHOICE_FOCUS_SOUND ;	execnow fileShareSearchShiftRight; } } \
			execkeyint		APAD_DOWN	{ play CHOICE_FOCUS_SOUND; setfocus "fileShareSearchRow"#nextItemIndex; } \
			execkeyint		APAD_UP		{ play CHOICE_FOCUS_SOUND; setfocus "fileShareSearchRow"#prevItemIndex; } \
			execkeyint		DPAD_DOWN	{ play CHOICE_FOCUS_SOUND; setfocus "fileShareSearchRow"#nextItemIndex; } \
			execkeyint		DPAD_UP		{ play CHOICE_FOCUS_SOUND; setfocus "fileShareSearchRow"#prevItemIndex; } \
			execkeyint		APAD_RIGHT	{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftRight;	} } \
			execkeyint		APAD_LEFT	{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftLeft;	} } \
            execkeyint		DPAD_RIGHT	{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftRight;	} } \
			execkeyint		DPAD_LEFT	{ if ( !disableArg ) { play CHOICE_FOCUS_SOUND; execnow fileShareSearchShiftLeft;	} } \
			SEARCH_SPINNER_PC_ACTIONS( disableArg ) \
			visible			when( visArg )	\
		}	\
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			exp				text( dvarString( "fsSearchRowText"#rowNum ) ) \
			rect			( px + 4 ) py pw 15  \
			textalign		CHOICE_SPINNER_DVAR_TEXTALIGN \
			textalignx		CHOICE_SPINNER_DVAR_TEXT_OFFSET_X \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			style			WINDOW_STYLE_FILLED \
			forecolor		TEXT_COLOR_NO_HL \		
			visible			when( !hasFocus( "fileShareSearchRow"#rowNum ) && visArg && !disableArg ) \
			decoration \
		}   \
        itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			exp				text( dvarString( "fsSearchRowText"#rowNum ) ) \
			rect			( px + 4 ) py pw 15  \
			textalign		CHOICE_SPINNER_DVAR_TEXTALIGN \
			textalignx		CHOICE_SPINNER_DVAR_TEXT_OFFSET_X \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			style			WINDOW_STYLE_FILLED \
			forecolor		TEXT_COLOR_HL \		
			visible			when( hasFocus( "fileShareSearchRow"#rowNum ) && visArg && !disableArg ) \
			decoration \
		} \
        itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			exp				text( dvarString( "fsSearchRowText"#rowNum ) ) \
			rect			( px + 4 ) py pw 15  \
			textalign		CHOICE_SPINNER_DVAR_TEXTALIGN \
			textalignx		CHOICE_SPINNER_DVAR_TEXT_OFFSET_X \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			style			WINDOW_STYLE_FILLED \
			forecolor		0.5 0.5 0.5 0.5 \		
			visible			when( visArg && disableArg )\
			decoration \
		}\


#define FILESHARE_SEARCHTASKS_TRUECONDITION( feederName ) \
	( isTaskInProgress( "LiveFileShareSearch" ) == 1 || getFeederData( feederName, "fileSize" ) == 0.0 || isTaskInProgress( "LiveFileGetTopRated" ) == 1 )


#define FILESHARE_RECENTGAMES_HEATMAP( px, py, hAlign, vAlign, menuName )   \
    itemDef     \
	{   \
		name			"heatMap"   \
		type			ITEM_TYPE_OWNERDRAW     \
		rect			( px + 40 ) py 150 150 hAlign vAlign \
		forecolor		1 1 1 0 \
		ownerdraw		UI_DRAWHEATMAP      \
		visible 		1   \
		decoration      \
        state   \
        {   \
            name        "Hidden"    \
            forecolor   1 1 1 0 \
        }   \
		state   \
		{   \
			name		"RemoveStaleHeatmap"    \
			forecolor	1 1 1 0 \
			onEnter \
			{   \
                if ( getFeederData( "fileShareRecentGames", "isSummaryCached" ) == 0 )    \
                {   \
                    execnow fileShareExpireFileDetails; \
                    execnow set showHeatmapSpinner 1;   \
                    execnow ui_animate menuName heatMap DelayHeatmapLoad ( dvarInt( "heatMapLoadDelay" ) ); \
                }   \
                else    \
                {   \
                    execnow ui_animate menuName heatMap DelayHeatmapLoad 0; \
                }   \
			}   \
		}   \
		state   \
		{   \
			name		"DelayHeatmapLoad"  \
			forecolor	1 1 1 0 \
			onEnter \
			{   \
                if ( !( FILESHARE_TASKSINPROGRESS ) )       \
                {   \
				    execnow fileShareGetSummary ( getFeederData( "fileShareRecentGames", "selection" ) );   \
				    changeState WaitForHeatmap 0;   \
                }  \
                else \
	            { \
                    changeState WaitForHeatmap 10; \
            	} \
			}   \
		}   \
    	state   \
		{   \
			name		"WaitForHeatmap"    \
			forecolor	1 1 1 0 \
			onEnter \
			{   \
				changeState CheckHeatmapLoaded 0;   \
			}   \
		}   \
	    state   \
        {   \
			name		"CheckHeatmapLoaded"    \
			forecolor	1 1 1 0 \
			onEnter \
            {   \
				if ( getFeederData( "fileShareRecentGames", "hasSummary" ) > 0.0 && isTaskInProgress( "LiveFileGetShareSummary" ) != 1 )    \
				{   \
					changeState LoadHeatmap 500;    \
				}          \
				else   \
				{   \
					changeState WaitForHeatmap 500; \
				}   \
			}   \
        }           \
		state   \
		{   \
			name		"LoadHeatmap"   \
			forecolor	1 1 1 1 \
            onEnter \
            {   \
                execnow set showHeatmapSpinner 0;   \
            }   \
		}   \
	}  \
    FILESHARE_PROGRESS_INDICATOR_SIZE( 150, -45, 64, 64, 0, ( dvarInt( showHeatmapSpinner ) == 1 ) )


#define FILESHARE_ERROR_MENU( errorMenuName, errorText )					\
		menuDef																\
		{																	\
			SYSTEM_POPUP_SETUP_VIS( errorMenuName, ;, ;, 1 )				\
			SYSTEM_POPUP_TITLE_VIS( locString( errorText ), 1 )				\
			FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )	\
		}

#undef POPUP_BG_WIDTH
#define POPUP_BG_WIDTH			400

#undef POPUP_BG_HEIGHT
#define POPUP_BG_HEIGHT			230

#define FILESHARE_INGAME_SAVESCREEN( titleArg )														\
		/* background overlay*/																		\
		itemDef	{																					\ 
			style			WINDOW_STYLE_FILLED														\ 
			rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN		\
			backcolor		0 0 0 0.8																\ 
			visible			1																		\
			decoration																				\
		}																							\ 
		/* gradient_top */																			\
		itemDef	{																					\
			style 			WINDOW_STYLE_SHADER														\
			rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0								\ 
			background		"gradient_top"															\
			visible			1																		\
			decoration																				\
		}																							\
		/* gradient_bottom */																		\
		itemDef	{																					\
			style			WINDOW_STYLE_SHADER														\ 
			rect			0 410 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0								\
			background		"gradient_bottom"														\
			visible			1																		\
			decoration																				\
		}																							\
		/* Popup Box */																				\
		itemDef	{																					\
			style           WINDOW_STYLE_SHADER_FRAMED												\
			frame           16 0.5 FRAME_SIDE_ALL													\
			background      "menu_mp_lobby_frame_circle"											\
			rect			(-POPUP_BG_WIDTH/2) (-POPUP_BG_HEIGHT/2) POPUP_BG_WIDTH POPUP_BG_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			forecolor		0.2 0.2 0.2 0.8															\
			visible			1																		\
			decoration																				\
		}																							\
		/* Title */																					\
		itemDef																						\
		{																							\
			type			ITEM_TYPE_TEXT															\
			rect			((-POPUP_BG_WIDTH/2)+15) ((-POPUP_BG_HEIGHT/2)+10) POPUP_BG_WIDTH POPUP_BG_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			text			titleArg																\
			textfont		CHOICE_TEXTFONT															\
			textscale		TEXTSIZE_DEFAULT														\
			textAlign		ITEM_ALIGN_TOP_LEFT														\
			textstyle		ITEM_TEXTSTYLE_NORMAL													\
			forecolor		1 1 1 1																	\
			visible			1																		\
			decoration																				\
		}

#undef FILESHARE_INGAME_FEEDER_WIDTH
#define FILESHARE_INGAME_FEEDER_WIDTH ((POPUP_BG_WIDTH*95)/100)

#undef FILESHARE_INGAME_FEEDER_HEIGHT
#define FILESHARE_INGAME_FEEDER_HEIGHT (POPUP_BG_HEIGHT-50)

#define READ_FILE_SHARE \
	exec ReadFileShare;

#ifdef PC
#define FILESHARE_INGAME_SLOTSELECTION_BOTTOM_BUTTONS \
	NEW_FRAME_BACK_BUTTON_ACTION( POPUP_BG_WIDTH, POPUP_BG_HEIGHT, escMenuAction; close self )
#else
#define FILESHARE_INGAME_SLOTSELECTION_BOTTOM_BUTTONS \
	GAMEPAD_BUTTON( (-POPUP_BG_WIDTH/2) ((POPUP_BG_HEIGHT/2)+15) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "@PLATFORM_BACK", BUTTON_B{ if ( dvarInt( slot_selected ) != 1 ) { escMenuAction } close self; }, when ( 1 ) ) \
	GAMEPAD_BUTTON( ((-POPUP_BG_WIDTH/2)+80) ((POPUP_BG_HEIGHT/2)+15) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, actionText, BUTTON_A{ setdvar slot_selected 1; play CHOICE_FOCUS_SOUND; selectedSlotAction }, when ( 1 ) )
#endif

#define FILESHARE_INGAME_SLOTSELECTION( menuName, actionText, selectedSlotAction, escMenuAction )	\
	menuDef																							\
	{																								\
		name					menuName															\
		fullScreen				0																	\
		rect					0 0 640 480	HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN	\
		focusColor				COLOR_FOCUSED														\
		soundloop				""																	\
		blurworld				2.0																	\
		onOpen { focusFirst; setdvar slot_selected 0; READ_FILE_SHARE }								\
		onEsc  { if ( dvarInt( slot_selected ) != 1 ) { escMenuAction } close self; }				\
		execkeyint BUTTON_START { }																	\
																									\
		/* background overlay*/																		\
		itemDef	{																					\ 
			style			WINDOW_STYLE_FILLED														\ 
			rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN		\
			backcolor		0 0 0 0.8																\ 
			visible			1																		\
			decoration																				\
		}																							\ 
		/* gradient_top */																			\
		itemDef	{																					\
			style 			WINDOW_STYLE_SHADER														\
			rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0								\ 
			background		"gradient_top"															\
			visible			1																		\
			decoration																				\
		}																							\
		/* gradient_bottom */																		\
		itemDef	{																					\
			style			WINDOW_STYLE_SHADER														\ 
			rect			0 410 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0								\
			background		"gradient_bottom"														\
			visible			1																		\
			decoration																				\
		}																							\
		/* Popup Box */																				\
		itemDef	{																					\
			style           WINDOW_STYLE_SHADER_FRAMED												\
			frame           16 0.5 FRAME_SIDE_ALL													\
			background      "menu_mp_lobby_frame_circle"											\
			rect			(-POPUP_BG_WIDTH/2) (-POPUP_BG_HEIGHT/2) POPUP_BG_WIDTH POPUP_BG_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			forecolor		0.2 0.2 0.2 0.8															\
			visible			1																		\
			decoration																				\
		}																							\
		/* Title */																					\
		itemDef																						\
		{																							\
			type			ITEM_TYPE_TEXT															\
			rect			((-POPUP_BG_WIDTH/2)+15) ((-POPUP_BG_HEIGHT/2)+10) POPUP_BG_WIDTH POPUP_BG_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			text			"@MENU_FILESHARE_CHOOSESLOT" \
			textfont		CHOICE_TEXTFONT  \
			textscale		TEXTSIZE_DEFAULT \
			textAlign		ITEM_ALIGN_TOP_LEFT \
			textstyle		ITEM_TEXTSTYLE_NORMAL \
			forecolor		1 1 1 1 \
			visible			1 \
			decoration \
		} \
		/* Feeder */ \
		itemDef		\
		{	\
			name				fileShareSlots	\
			type				ITEM_TYPE_LISTBOX	\
			feeder				FEEDER_FILESHARE_MYSLOTS_INGAME	\
			rect				((-POPUP_BG_WIDTH/2)+10) ((-POPUP_BG_HEIGHT/2)+30) FILESHARE_INGAME_FEEDER_WIDTH FILESHARE_INGAME_FEEDER_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin				0 0	\
			elementwidth		80	\
			elementheight		28  \
			elementtype			LISTBOX_TEXT		\
			textstyle			ITEM_TEXTSTYLE_NORMAL	\
			textalign			HORIZONTAL_ALIGN_LEFT	\
			textfont			UI_FONT_NORMAL	\
			textscale			TEXTSIZE_SMALL \
			forecolor			CHOICE_TEXTCOLOR	\
			outlinecolor				1 1 1 1 \
			disablecolor		CHOICE_TEXTCOLOR \
			elementHighlightColor		0 0 0 1 \
			elementBackgroundColor		NEW_FRAME_TRANSPARENCY \
			noBlinkingHighlight \
			modal \
			noscrollbars	\
            onListboxSelectionChange  {     play CHOICE_FOCUS_SOUND;    }   \
			doubleclick			\	
            {                                                                                   \
                if ( getFeederData( "ingameSlot" ) <= 6 && !isTaskInProgress( "LiveFileShareWriteFile" ) ) \
                {                                                                               \
                    play CHOICE_FOCUS_SOUND;                                                    \
		            if ( getFeederData( "slotOccupied" ) != 1  )                                 \
		            {                                                                           \
			           setdvar slot_selected 1;													\
  				       selectedSlotAction														\
		            }                                                                           \
		            else                                                                        \
		            {                                                                           \
				        open menuName##_##confirm;                                              \
    		        }                                                                           \
                }                                                                               \   
            }                                                                                   \
			/*					x	y	w	h	len	horzAlign		vertAlign*/			        \
			userarea	3		10	-7	30	28	50	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE		\
								30	5	20	19	50	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE		\
								55	-7	150	28	50	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE		\
			visible		1 \
		} \
		/* Details Box */ \
		itemDef	{ \
			style			WINDOW_STYLE_SHADER \
			rect			((-POPUP_BG_WIDTH/2)+FILESHARE_INGAME_FEEDER_WIDTH+20) ((-POPUP_BG_HEIGHT/2)+33) (POPUP_BG_WIDTH-FILESHARE_INGAME_FEEDER_WIDTH-30) (FILESHARE_INGAME_FEEDER_HEIGHT-13) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			background		"white" \
			forecolor		NEW_FRAME_TRANSPARENCY \
			visible			when( FILESHARE_TASKSINPROGRESS ) \
			decoration \
		}\
        /*FILESHARE_SPINNER( 0, 0, when( FILESHARE_TASKSINPROGRESS ), 350 ) */ \
        FILESHARE_UPLOAD_PROGRESS_INDICATOR( 0, 0 ) \
        execKeyInt BUTTON_B {   execnow fileShareAbortOperation; close self; }   \
        FILESHARE_INGAME_SLOTSELECTION_BOTTOM_BUTTONS \
	}   

#ifdef PC
	#define FILESHARE_SLOT_SELECTOR_BACK_BUTTON( escArgs ) \
		NEW_FRAME_BACK_BUTTON_ACTION( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT, close self; escArgs )
	#define FILESHARE_SAVE_BACK_BUTTON \
		NEW_FRAME_BACK_BUTTON_ACTION( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT, close self; )
	#define FILESHARE_CONSOLE_INC_SLOT_NUMBER
#else //#ifdef PC
	#define FILESHARE_SLOT_SELECTOR_BACK_BUTTON( escArgs ) \
		NEW_FRAME_BACK_BUTTON( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT )
	#define FILESHARE_SAVE_BACK_BUTTON \
		FILESHARE_BACK_BUTTON_TEXT( 0, 230 )
	#define FILESHARE_CONSOLE_INC_SLOT_NUMBER \
		itemDef     \
		{   \
			type			ITEM_TYPE_TEXT  \
			rect			-146 165 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER   \
			exp				text( int( getFeederData( "fileShareSlots", "slot" ) ) )    \
			textfont		CHOICE_TEXTFONT     \
			textscale		TEXTSIZE_SMALL  \
			textalign		ITEM_ALIGN_MIDDLE_RIGHT \
			forecolor		1 1 1 1 \
			visible			1   \
			decoration      \
		}   \
		itemDef     \
		{   \
			type			ITEM_TYPE_TEXT  \
			rect			-142 165 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER   \
			text			"@MENU_FILESHARE_OF18"  \
			textfont		CHOICE_TEXTFONT     \
			textscale		TEXTSIZE_SMALL  \
			textalign		ITEM_ALIGN_MIDDLE_LEFT      \
			forecolor		1 1 1 1 \
			visible			1   \
		}   \
		PREPROC_SHADER_DRAW_VIS_EX( -114 160 11 11 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "ui_arrow_left", COLOR_BODY_TEXT, when( getFeederData( "fileShareSlots", "slot" ) > 6 ), rotation 90; )	\
		PREPROC_SHADER_DRAW_VIS_EX( -107 160 11 11 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "ui_arrow_right", COLOR_BODY_TEXT, when( getFeederData( "fileShareSlots", "slot" ) > 6 && getFeederData( "fileShareSlots", "slot" ) < 13 ), rotation 90; ) \
		PREPROC_SHADER_DRAW_VIS_EX( -114 160 11 11 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "ui_arrow_right", COLOR_BODY_TEXT, when( getFeederData( "fileShareSlots", "slot" ) <= 6 ), rotation 90; )

#endif //#ifdef PC

#ifdef CONSOLE
	#define FILESHARE_SELECTOR_CONFIRM_BACK_BUTTON \
	    FILESHARE_BACK_BUTTON_ACTION( 0, 162, deactivateblur; close self; )
#else // #ifdef CONSOLE
	#define FILESHARE_SELECTOR_CONFIRM_BACK_BUTTON
#endif // #ifdef CONSOLE

#define FILESHARE_SLOT_SELECTOR( menuName, action )  FILESHARE_SLOT_SELECTOR_EX( menuName, action, ;, ; ,; )
#define FILESHARE_SLOT_SELECTOR_EX( menuName, action, openArgs, escArgs, extraArgs )                              \
menuDef                                                                                     \
{                                                                                           \
	name					menuName                                                        \
	rect					0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	focuscolor				COLOR_FOCUSED                                                   \
	style					WINDOW_STYLE_FILLED                                             \
	priority				MENU_PRI_ONTOP                                                  \
	soundloop 				MENU_MUSIC                                                      \
    extraArgs                                                                               \    
    onOpen	                                                                                \
	{                                                                                       \
		openArgs;                                                                           \
		READ_FILE_SHARE;                                                                    \
	}                                                                                       \
	onFocus                                                                                 \
	{                                                                                       \
        play CHOICE_FOCUS_SOUND;                                                            \
        activateBlur;                                                                       \
	}                                                                                       \
	onClose	                                                                                \
	{                                                                                       \
        deactivateblur;                                                                     \        
	}                                                                                       \
	onESC	                                                                                \
	{                                                                                       \      
        escArgs;                                                                            \
		close self;                                                                         \
	}                                                                                       \
	NEW_FRAME( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT )                              \
	NEW_FRAME_TITLE( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT, "@MENU_FILESHARE_MYSHARE_CAPS", 1 )			\
	NEW_FRAME_SUBTITLE( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT, "@MENU_FILESHARE_CHOOSESLOT", 1 )	\
	PLAYER_INFO_VIS( FILESHARE_FRAME_WIDTH, FILESHARE_FRAME_HEIGHT, 1 )						\
	itemDef                                                                                 \       
	{                                                                                       \
		name				fileShareSlots                                                  \
		type				ITEM_TYPE_LISTBOX                                               \
		feeder				FEEDER_FILESHARE_MYSLOTS                                        \
		FILESHARE_COMMON_OPTIONS														    \
		origin				0 0                                                             \
		elementwidth		70                                                              \
		elementheight		70                                                              \
		elementtype			LISTBOX_TEXT	                                                \
		textalign			HORIZONTAL_ALIGN_LEFT                                           \
		textfont			UI_FONT_NORMAL                                                  \
		forecolor			CHOICE_TEXTCOLOR                                                \       
		modal											\
		doubleclick	                                                                    \	
		{                                                                                   \
            if ( getFeederData( "slot" ) <= 6 )                                             \
            {                                                                               \
                if ( !( FILESHARE_TASKSINPROGRESS ) )                                           \
                {                                                                               \
                    play CHOICE_FOCUS_SOUND;                                                \
			        if ( getFeederData( "slotOccupied" ) != 1 ) \
			        {                                                                           \
                        open menuName##_##save;                                                 \
			        }                                                                           \
			        else                                                                        \
			        {                                                                           \
    				    open menuName##_##confirm;                                              \
	    		    }                                                                           \
                }                                                                               \   
            }                                                                                   \
		}                                                                                   \
        onListboxSelectionChange    { play CHOICE_FOCUS_SOUND;  }                           \
		visible				1                                                               \
		FILESHARE_SLOTS_USERAREAS	                                                        \
	}			                                                                            \
    execKeyInt APAD_LEFT    {	play CHOICE_FOCUS_SOUND;    }                               \
    execKeyInt DPAD_LEFT	{	play CHOICE_FOCUS_SOUND;	}                               \
    execKeyInt APAD_RIGHT	{	play CHOICE_FOCUS_SOUND;	}                               \
    execKeyInt DPAD_RIGHT	{	play CHOICE_FOCUS_SOUND;	}                               \
	FILESHARE_DETAILS( 35, (NEW_FRAME_CHOICE_Y_START-1), HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_CENTER, menuName, "fileShareSlots", getFeederData( "fileShareSlots", "slotOccupied" ) && getFeederData( "fileShareSlots", "count" ) > 0.0 )  \
	execKeyInt APAD_UP \
	{ \
		execnow set fshSelectLastSlotRow 1; \
		setfocus fileShareSlots; \
	} \
	execKeyInt DPAD_UP \
	{ \
		execnow set fshSelectLastSlotRow 1; \
		setfocus fileShareSlots; \
	} \
	execKeyInt APAD_DOWN \
	{ \
		execnow set fshSelectFirstSlotRow 1; \
		setfocus fileShareSlots; \
	} \
	execKeyInt DPAD_DOWN \
	{ \
		execnow set fshSelectFirstSlotRow 1; \
		setfocus fileShareSlots; \
	} \
	FILESHARE_BOTTOM( fileShareSlots, 1 ) \
	FILESHARE_CONSOLE_INC_SLOT_NUMBER \
	FILESHARE_SLOT_SELECTOR_BACK_BUTTON( escArgs )							                \
}                                                                                           \
menuDef                                                                                     \
{                                                                                           \
	SYSTEM_POPUP_SETUP_VIS( menuName##_##confirm, ;, ;, 1 )									\
	SYSTEM_POPUP_TITLE_VIS( "@MENU_FILESHARE_REPLACECONFIRM", 1 )							\
	itemDef                                                                                 \
	{		                                                                                \
		DYNAMIC_MENU_COMMON_FIELDS                                                          \
		backgroundItemListbox		"white"                                                 \
		rect CHOICE_X_START CHOICE_Y_START CHOICE_SIZE_X 400	                            \
   		menuItemsDef                                                                        \
		{                                                                                   \
			maxRows 4                                                                       \
			DYNAMIC_MENU_COMMON_COLUMNS                                                     \
			menuColDef                                                                      \
			{                                                                               \
				type MENU_ITEM_TYPE_LOC_TEXT                                                \
				rect 0 0 50 CHOICE_SIZE_Y ITEM_ALIGN_LEFT ITEM_ALIGN_MIDDLE                 \
				maxChars 50                                                                 \
			}                                                                               \
		}                                                                                   \
		onEvent Yes			                                                                \
		{	                                                                                \      
            open menuName##_##save;                                                         \
			close self;                                                                     \
		}                                                                                   \
		onEvent No																			\
		{																					\
			if (IsInGame())																	\
			{																				\
				showMenu menuName;															\
			}																				\
			close self;																		\
		}																					\
		onEvent Clear		{	execNow clearFeeder;	}                                   \
		onEvent Populate	{	                                                            \
			execNow addToFeeder Yes	MENU_YES;	                                            \
			execNow	addToFeeder	No	MENU_CANCEL;	                                        \		
		}                                                                                   \
		onfocus						{	play CHOICE_FOCUS_SOUND;	}		                \
		onListboxSelectionChange	{	play CHOICE_FOCUS_SOUND;	}                       \
		doubleclick					{	play CHOICE_FOCUS_SOUND;		                    \
										execNow raiseFeederEvent; 	}                       \
	}                                                                                       \
	onOpen                                                                                  \
	{                                                                                       \
		activateblur;                                                                       \
		execNow raiseFeederEvent Populate;		                                            \
		if (IsInGame())																		\
		{																					\
			hideMenu menuName;																\
		}																					\
	}                                                                                       \
	onClose	                                                                                \
	{                                                                                       \
		deactivateblur;                                                                     \
		play CHOICE_FOCUS_SOUND;                                                            \
		execNow raiseFeederEvent Clear;                                                     \        
	}                                                                                       \
	onFocus { }                                                                             \
	onESC                                                                                   \
	{                                                                                       \
		deactivateblur;                                                                     \
		if (IsInGame())																		\
		{																					\
			showMenu menuName;																\
		}																					\
		close self;                                                                         \        
	}                                                                                       \
}                                                                                           \
menuDef                                                                                     \
{                                                                                           \
	SMALL_CENTER_POPUP_SETUP_INGAME( menuName##_##save, 0, 1, 1 )                           \
	itemDef                                                                                 \
	{                                                                                       \
		type			ITEM_TYPE_TEXT                                                      \
		rect			8 10 1 1                                                            \
		text			"@MENU_SAVE_INFORMATION"                                            \
		textfont		CHOICE_TEXTFONT                                                     \
		textscale		TEXTSIZE_DEFAULT                                                    \
		textAlign		ITEM_ALIGN_TOP_LEFT                                                 \
		textstyle		ITEM_TEXTSTYLE_NORMAL                                               \
		forecolor		NEW_FRAME_LT_GREY_RGB 1                                             \
		visible			1                                                                   \
		decoration                                                                          \
	}                                                                                       \
	NEW_FRAME_BUTTON_TEXT( 1, 28 50 330 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, locString( "@MPUI_TITLE" )+" :", TEXTSIZE_SMALL, CHOICE_TEXTALIGN, 1, ; )  \
	NEW_FRAME_BUTTON( 2, 28 70 330 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, dvarString(fsSelectedFileName), execNow demo_keyboard fileshareFileName;, ;, ;, 1, ;, ; )  \
	NEW_FRAME_BUTTON_TEXT( 3, 28 100 330 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, locString( "@MPUI_DESCRIPTION" )+" :", TEXTSIZE_SMALL, CHOICE_TEXTALIGN, 1, ; )   \
	NEW_FRAME_BUTTON( 4, 28 120 330 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, dvarString(fsSelectedFileDescription), execNow demo_keyboard fileshareFileDescription;, ;, ;, 1, ;, ; )   \
	NEW_FRAME_BUTTON( 6, 28 160 330 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "@MENU_CONTINUE", action; close self; close menuName;, ;, ;, 1, ;, ; )  \
    FILESHARE_SAVE_BACK_BUTTON		                                                        \
    onOpen                                                                                  \
	{                                                                                       \
		activateblur;                                                                       \
        /*setFocus new_frame_button_6;*/                                                    \
		if (IsInGame())																		\
		{																					\
			hideMenu menuName;																\
		}																					\		
	}                                                                                       \
	onClose	                                                                                \
	{                                                                                       \
		deactivateblur;                                                                     \
		play CHOICE_FOCUS_SOUND;                                                            \
		if (IsInGame())																		\
		{																					\
			showMenu menuName;																\
		}																					\
	}                                                                                       \
    onFocus { }                                                                             \
	onESC                                                                                   \
	{                                                                                       \
		deactivateblur;                                                                     \
		close self;                                                                         \
	}                                                                                       \
}                                                                                                          



#define FILESHARE_MOVIE_BORDER 2
#define FILESHARE_MOVIE_PADDING 3
#define FILESHARE_MOVIE_HIGHLIGHT_COLOR 0.5 1.0 0.5 0.8
#define FILESHARE_MOVIE_HIGHLIGHT_COLOR_NOSEL  1.0 0.2 0.2 0.8
#define FILESHARE_MOVIE_COLOR 1 1 1 1

#define FILESHARE_MOVIE_BORDER_HI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg )	\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY posW FILESHARE_MOVIE_BORDER posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX ( posY + posH - FILESHARE_MOVIE_BORDER ) posW FILESHARE_MOVIE_BORDER posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY FILESHARE_MOVIE_BORDER posH posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( ( posX + posW - FILESHARE_MOVIE_BORDER ) posY FILESHARE_BLURB_BORDER posH posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR, when( visArg ) , ; )		\

#define FILESHARE_MOVIE_BORDER_HI_NOSEL( posX, posY, posW ,posH, posAlignX, posAlignY, visArg )	\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY posW FILESHARE_MOVIE_BORDER posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR_NOSEL, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX ( posY + posH - FILESHARE_MOVIE_BORDER ) posW FILESHARE_MOVIE_BORDER posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR_NOSEL, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY FILESHARE_MOVIE_BORDER posH posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR_NOSEL, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( ( posX + posW - FILESHARE_MOVIE_BORDER ) posY FILESHARE_BLURB_BORDER posH posAlignX posAlignY, "white", FILESHARE_MOVIE_HIGHLIGHT_COLOR_NOSEL, when( visArg ) , ; )		\


#define FILESHARE_MOVIE_BORDER_NOHI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg )	\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY posW FILESHARE_MOVIE_BORDER posAlignX posAlignY, "white", FILESHARE_MOVIE_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX ( posY + posH - FILESHARE_MOVIE_BORDER ) posW FILESHARE_MOVIE_BORDER posAlignX posAlignY, "white", FILESHARE_MOVIE_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY FILESHARE_MOVIE_BORDER posH posAlignX posAlignY, "white", FILESHARE_MOVIE_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( ( posX + posW - FILESHARE_MOVIE_BORDER ) posY FILESHARE_MOVIE_BORDER posH posAlignX posAlignY, "white", FILESHARE_MOVIE_COLOR, when( visArg ) , ; )		\

#define FILESHARE_MOVIE( posX, posY, posW ,posH, posAlignX, posAlignY, visArg, hiArg )	\
	FILESHARE_MOVIE_BORDER_HI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg && hiArg )	\
	FILESHARE_MOVIE_BORDER_NOHI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg && !hiArg ) \
	PREPROC_SHADER_DRAW_VIS_EX( ( posX + FILESHARE_MOVIE_BORDER + FILESHARE_MOVIE_PADDING) ( posY + FILESHARE_MOVIE_BORDER + FILESHARE_MOVIE_PADDING) ( posW - ( FILESHARE_MOVIE_BORDER * 2 ) - ( FILESHARE_MOVIE_PADDING * 2 ) )  ( posH  - ( FILESHARE_MOVIE_BORDER * 2 ) - ( FILESHARE_MOVIE_PADDING * 2 ) ) posAlignX posAlignY, "menu_" + getMySlotInfo( 20, map ) +"_map_select_final", 1 1 1 0.5, when( visArg ) , ; )		\
    

#define FILESHARE_NOMOVIE( posX, posY, posW ,posH, posAlignX, posAlignY, visArg, hiArg )	\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY posW posH posAlignX posAlignY, "white", 0 0 0 0.2, when( visArg ) , ; )		\
    itemDef												\
	{													\
		type            ITEM_TYPE_TEXT					\
		rect            posX ( posY - 10 )posW posH HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		exp             text( locString( "MENU_FILESHARE_MOVIE_DESC" ) )                     \
		textalign		ITEM_ALIGN_MIDDLE_CENTER		\
		textfont		CHOICE_TEXTFONT					\                                      
		textscale		TEXTSIZE_DEFAULT		    		\                                       
		textstyle		CHOICE_TEXTSTYLE				\                                           
		forecolor		NEW_FRAME_LT_GREY_RGB 1			\
		visible			when( visArg )					\
        autowrapped                                     \
		decoration										\		
	}

#define FILESHARE_BLURB_BORDER 2
#define FILESHARE_BLURB_PADDING 3
#define FILESHARE_BLURB_HIGHLIGHT_COLOR 0.5 1.0 0.5 0.8
#define FILESHARE_BLURB_COLOR 1 1 1 1

#define FILESHARE_BLURB_BORDER_HI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg )	\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY posW FILESHARE_BLURB_BORDER posAlignX posAlignY, "white", FILESHARE_BLURB_HIGHLIGHT_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX ( posY + posH - FILESHARE_BLURB_BORDER ) posW FILESHARE_BLURB_BORDER posAlignX posAlignY, "white", FILESHARE_BLURB_HIGHLIGHT_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY FILESHARE_BLURB_BORDER posH posAlignX posAlignY, "white", FILESHARE_BLURB_HIGHLIGHT_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( ( posX + posW - FILESHARE_BLURB_BORDER ) posY FILESHARE_BLURB_BORDER posH posAlignX posAlignY, "white", FILESHARE_BLURB_HIGHLIGHT_COLOR, when( visArg ) , ; )		\
	
#define FILESHARE_BLURB_BORDER_NOHI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg )	\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY posW FILESHARE_BLURB_BORDER posAlignX posAlignY, "white", FILESHARE_BLURB_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX ( posY + posH - FILESHARE_BLURB_BORDER ) posW FILESHARE_BLURB_BORDER posAlignX posAlignY, "white", FILESHARE_BLURB_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( posX posY FILESHARE_BLURB_BORDER posH posAlignX posAlignY, "white", FILESHARE_BLURB_COLOR, when( visArg ) , ; )		\
	PREPROC_SHADER_DRAW_VIS_EX( ( posX + posW - FILESHARE_BLURB_BORDER ) posY FILESHARE_BLURB_BORDER posH posAlignX posAlignY, "white", FILESHARE_BLURB_COLOR, when( visArg ) , ; )		\

#define FILESHARE_LIVEBLURB( posX, posY, posW ,posH, posAlignX, posAlignY, visArg, hiArg )	\
	FILESHARE_BLURB_BORDER_HI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg && hiArg )	\
	FILESHARE_BLURB_BORDER_NOHI( posX, posY, posW ,posH, posAlignX, posAlignY, visArg && !hiArg )	\
	PREPROC_SHADER_DRAW_VIS_EX( ( posX + FILESHARE_BLURB_BORDER + FILESHARE_BLURB_PADDING) ( posY + FILESHARE_BLURB_BORDER + FILESHARE_BLURB_PADDING) 90 90 posAlignX posAlignY, "menu_mp_playlist_map", 1 1 1 0.5, when( visArg ) , ; )		\
	itemDef												\
	{													\
		name fileshareMarketingBlurb					\
		type ITEM_TYPE_TEXT								\
		rect (posX + 100) (posY + FILESHARE_BLURB_PADDING) (posW - 110) posH posAlignX posAlignY	\
		exp text( dvarString( "fshLiveBlurb" ) )\
		textalign		ITEM_ALIGN_TOP_LEFT				\
		textfont		CHOICE_TEXTFONT					\                                      
		textscale		TEXTSIZE_DEFAULT				\                                       
		textstyle		CHOICE_TEXTSTYLE				\                                           
		forecolor		NEW_FRAME_LT_GREY_RGB 1			\
		visible			when( visArg )					\
		decoration										\
		autowrapped										\
	}

#ifdef PC
	#define FILESHARE_RATINGSUBMITTED_MENU_CONSOLE_OR_PC \
		SYSTEM_POPUP_BACK_BUTTON
#else // #ifdef PC
	#define FILESHARE_RATINGSUBMITTED_MENU_CONSOLE_OR_PC \
	    itemDef     \
		{   \
			type			ITEM_TYPE_TEXT  \
			rect			3 180 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER     \
			text			"@PLATFORM_BACK"    \
			textfont		CHOICE_TEXTFONT     \
			textscale		TEXTSIZE_DEFAULT    \
			textalign		ITEM_ALIGN_BOTTOM_LEFT      \
			visible			1   \
			decoration		    \
		} 	    
#endif // #else #ifdef PC

#define FILESHARE_RATINGSUBMITTED_MENU_BODY( menuName ) \
    itemDef \
	{   \
		type			ITEM_TYPE_OWNERDRAW \
		rect			60 72 12 12 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
		forecolor		1 1 1 0.2   \
		ownerdraw		UI_FILESHARE_MYRATING   \
		visible			1   \
		decoration  \
	}   \
	FILESHARE_RATINGSUBMITTED_MENU_CONSOLE_OR_PC

#define STAR_BUTTON_NAME( index ) "fileshare_rating_star_button"#index

#ifdef PC
	#define FILESHARE_RATING_STAR_BUTTON_START_X 60
	#define FILESHARE_RATING_STAR_BUTTON_START_Y 106
	#define FILESHARE_RATING_STAR_BUTTON_WIDTH 30
	#define FILESHARE_RATING_STAR_BUTTON_HEIGHT 30
	
	#define FILESHARE_RATING_STAR_BUTTON( index ) \
	itemDef \
	{ \
		type			ITEM_TYPE_BUTTON_NO_TEXT \
		name			STAR_BUTTON_NAME( index ) \
		rect			FILESHARE_RATING_STAR_BUTTON_START_X FILESHARE_RATING_STAR_BUTTON_START_Y FILESHARE_RATING_STAR_BUTTON_WIDTH FILESHARE_RATING_STAR_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		exp				rect X( FILESHARE_RATING_STAR_BUTTON_START_X + (index - 1) * FILESHARE_RATING_STAR_BUTTON_WIDTH ) \
		visible			1 \
		onfocus \
		{ \
			play CHOICE_FOCUS_SOUND; \
			execNow fileShareSetRatingPreview index; \
		} \
		leavefocus \
		{ \
			execNow fileShareResetRatingPreview; \
		} \
		action \
		{ \
			execNow fileShareSetRating index; \
		} \
	}
	
	#define FILESHARE_RATINGCLOSE_ACTION	\
		close self;							\
		
	#define FILESHARE_RATING_MENU_CONSOLE_OR_PC \
	SYSTEM_POPUP_BUTTON_X( "@PLATFORM_BACK", 0, FILESHARE_RATINGCLOSE_ACTION, 1 ) \
	FILESHARE_RATING_STAR_BUTTON( 1 ) \
	FILESHARE_RATING_STAR_BUTTON( 2 ) \
	FILESHARE_RATING_STAR_BUTTON( 3 ) \
	FILESHARE_RATING_STAR_BUTTON( 4 ) \
	FILESHARE_RATING_STAR_BUTTON( 5 ) \
	SYSTEM_POPUP_BUTTON2( "@MENU_ACCEPT", \
		execNow fileShareSubmitRating( dvarString( fsSelectedFileID ) ); FILESHARE_RATINGCLOSE_ACTION, \
		when ( getFileShareRating() > 0 ); )
#else // #ifdef PC

	#define FILESHARE_RATINGCLOSE_ACTION	\
		close self;							\

	#define FILESHARE_RATING_MENU_CONSOLE_OR_PC \
		itemDef     \
		{   \
			name			"leftArrow" \
			style			WINDOW_STYLE_SHADER     \
			rect			40 115 12 12 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
			origin			0 0     \
			background		"ui_arrow_left"     \
			forecolor		MEDIUM_GRAY \
			visible			when( getFileShareRating() > 0 )    \
			decoration  \
			state   \
			{   \
				name "blink"    \
				forecolor NEW_FRAME_ORANGE_RGB 1    \
				onEnter \
				{   \
					changeState "normal" 500;   \
				}   \
			}   \
			state   \
			{   \
				name "normal"   \
				forecolor MEDIUM_GRAY   \
			}   \
		}   \
		itemDef     \
		{   \
			name			"rightArrow"    \
			style			WINDOW_STYLE_SHADER     \
			rect			217 115 12 12 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			origin			0 0     \
			background		"ui_arrow_right"    \
			forecolor		MEDIUM_GRAY \
			visible			when( getFileShareRating() < 5 )    \
			decoration  \
			state   \
			{   \
				name "blink"    \
				forecolor NEW_FRAME_ORANGE_RGB 1    \
				onEnter \
				{   \
					changeState "normal" 500;   \
				}   \
			}   \
			state   \
			{   \
				name "normal"   \
				forecolor  MEDIUM_GRAY  \
			}   \
		}   \
		itemDef     \
		{   \
			type			ITEM_TYPE_TEXT  \
			rect			3 180 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER     \
			text			"@PLATFORM_BACK"    \
			textfont		CHOICE_TEXTFONT     \
			textscale		TEXTSIZE_DEFAULT    \
			textalign		ITEM_ALIGN_BOTTOM_LEFT      \
			visible			1   \
			decoration		    \
		} 	    \
		GAMEPAD_BUTTON( 70 180 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "@PLATFORM_FILESHARE_SUBMITRATING", BUTTON_A{ execnow fileShareSubmitRating ( dvarString( fsSelectedFileID ) ); play CHOICE_FOCUS_SOUND; FILESHARE_RATINGCLOSE_ACTION }, when ( getFileShareRating() > 0 ) )
#endif // #else #ifdef PC

#define FILESHARE_RATING_MENU_BODY( menuName, rateAction ) \
    execKeyInt APAD_LEFT	{ execNow fileShareDecreaseRating; execnow ui_animate menuName leftArrow blink 0; play CHOICE_FOCUS_SOUND; } \
	execKeyInt APAD_RIGHT	{ execNow fileShareIncreaseRating; execnow ui_animate menuName rightArrow blink 0; play CHOICE_FOCUS_SOUND; } \
	execKeyInt DPAD_LEFT	{ execNow fileShareDecreaseRating; execnow ui_animate menuName leftArrow blink 0; play CHOICE_FOCUS_SOUND; } \
	execKeyInt DPAD_RIGHT	{ execNow fileShareIncreaseRating; execnow ui_animate menuName rightArrow blink 0; play CHOICE_FOCUS_SOUND; } \
	itemDef     \
	{   \
		type			ITEM_TYPE_TEXT  \
		rect			65 65 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		text			"@MENU_FILESHARE_AVERAGERATING"     \
		textfont		CHOICE_TEXTFONT     \
		textscale		TEXTSIZE_SMALL  \
		textalign		ITEM_ALIGN_LEFT \
		visible			1   \
		decoration      \
    }	    \
	itemDef \
	{   \
		type			ITEM_TYPE_OWNERDRAW \
		rect			148 53 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER    \
		forecolor		1 1 1 0.2   \
		ownerdraw		UI_FILESHARE_AVGSUBMITRATING    \
		visible			1   \
		decoration  \
	}   \
	itemDef     \
	{   \
		type			ITEM_TYPE_TEXT  \
		rect			65 85 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		text			"@MENU_FILESHARE_NUMRATINGS"    \
		textfont		CHOICE_TEXTFONT     \
		textscale		TEXTSIZE_SMALL  \
		textalign		ITEM_ALIGN_LEFT     \
		visible			1   \
		decoration      \
	}   \
	itemDef     \
	{   \
		type			ITEM_TYPE_TEXT  \
		rect			145 85 60 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER   \
		exp				text( getFileShareTotalVotes() )	 \
		textfont		CHOICE_TEXTFONT     \
		textscale		TEXTSIZE_SMALL  \
		textalign		ITEM_ALIGN_RIGHT    \
		visible			1   \
		decoration      \
	}   \
	itemDef \
	{   \
		type			ITEM_TYPE_OWNERDRAW \
		rect			60 105 12 12 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER  \
		forecolor		1 1 1 0.2   \
		ownerdraw		UI_FILESHARE_SUBMITRATING   \
		visible			1   \
		decoration  \
	}   \
	FILESHARE_RATING_MENU_CONSOLE_OR_PC

#define FILESHARE_LOADER( menuName, progressCondition, successCondition, onSuccess, onFailure )	\
	menuDef	\
	{	\
		name					menuName	\
		rect					0 0 640 480	\
		focuscolor				COLOR_FOCUSED	\
		style					WINDOW_STYLE_FILLED	\
		priority				MENU_PRI_ONTOP	\
		soundloop 				MENU_MUSIC	\
		onOpen		\
		{	\
			execnow ui_animate menuName loadSpinner Loading 0;	\
		}	\
		onFocus		\
		{	\			
		}	\
		onClose		\
		{	\			
		}	\
		onESC		\
		{	\			
		}	\	
        itemDef	\
        {	\
			name loadSpinner	\
            style WINDOW_STYLE_SPINNER	\
            rect -40 -40 80 80 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
            visible 1	\
            decoration	\
			state	\
			{	\
				name "CheckIfDone"	\
				onEnter	\
				{	\
					if ( progressCondition )	\
					{	\
						changeState Loading 10;	\
					}	\
					else	\
					{	\
						if ( successCondition )		\
						{	\
							close self;	\
							onSuccess;	\						
						}	\
						else	\
						{	\
							close self;	\
							onFailure;		\						
						}	\
					}	\
				}	\
			}	\
			state	\ 
			{	\
				name "Loading"	\	
				onEnter	\
				{	\
					changeState CheckIfDone 10;	\
				}	\
			}	\
        }	\
	}	



#define FILESHARE_MATCHDETAILS_X 37
#define FILESHARE_MATCHDETAILS_Y 40
#define FILESHARE_MATCHDETAILS_W 225

#define FILESHARE_TEXTITEM_KEY( itemIndex, expArg, visArg )	\
	itemDef		\
	{ \
		type			ITEM_TYPE_TEXT	\
		rect			FILESHARE_MATCHDETAILS_X ( FILESHARE_MATCHDETAILS_Y + 73 + ( 20 * ( itemIndex - 1 ) ) ) FILESHARE_MATCHDETAILS_W 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
		exp				expArg	\
		textfont		CHOICE_TEXTFONT		\
		textalign		ITEM_ALIGN_LEFT	\
		textscale		TEXTSIZE_SMALL		\
		forecolor		LIGHT_GRAY	\
		visible			visArg	\
		decoration		\
	}	

#define FILESHARE_TEXTITEM_VALUE( itemIndex, expArg, visArg )	\
	itemDef		\
	{ \
		type			ITEM_TYPE_TEXT	\
		rect			FILESHARE_MATCHDETAILS_X ( FILESHARE_MATCHDETAILS_Y + 73 + ( 20 * ( itemIndex - 1 ) ) ) FILESHARE_MATCHDETAILS_W 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
		exp				expArg	\
		textfont		CHOICE_TEXTFONT		\
		textalign		ITEM_ALIGN_RIGHT	\
		textscale		TEXTSIZE_SMALL		\
		forecolor		LIGHT_GRAY	\
		visible			visArg	\
		decoration		\
	}	

#define FILESHARE_MATCHDETAILS_BGX ( FILESHARE_MATCHDETAILS_X - 2 )
#define FILESHARE_MATCHDETAILS_BGY ( FILESHARE_MATCHDETAILS_Y - 164 )
#define FILESHARE_MATCHDETAILS_BGW ( FILESHARE_MATCHDETAILS_W + 5 )
