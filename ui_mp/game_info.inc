#ifndef GAMEINFO_ORIENTATION
	#define GAMEINFO_X				(CHOICE_X_START+CHOICE_SIZE_X-GAMEINFO_WIDTH+10)
	#define GAMEINFO_Y				226
	#define GAMEINFO_ORIGIN			GAMEINFO_X GAMEINFO_Y
	#define GAMEINFO_WIDTH			200
	#define GAMEINFO_WIDTH2			213
	#define GAMEINFO_HEIGHT			120
	#define GAMEINFO_DESC_X			-50
	#define GAMEINFO_DESC_Y			210
#endif

#define GAME_INFO( mapImageExp, mapNameExp, gameTypeExp, visArg )																		\
		/* map image */																													\
		PREPROC_SHADER_DRAW_VIS_EX( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 GAMEINFO_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,			\
									mapImageExp, 1 1 1 1, when( visArg );, ; )															\
		/* gray background below map */																									\
		PREPROC_SHADER_DRAW(	GAMEINFO_X (GAMEINFO_Y+GAMEINFO_HEIGHT) BUTTON_BG_WIDTH 20 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP,	\
								"white", 0.18 0.18 0.18 1 )																				\
		/* new gametype on mapname */																									\
		itemDef																															\
		{																																\
			type			ITEM_TYPE_OWNERDRAW_TEXT																					\
			rect			GAMEINFO_X (GAMEINFO_Y+GAMEINFO_HEIGHT+15) GAMEINFO_WIDTH 16 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP		\
			forecolor		CHOICE_TEXTCOLOR																							\
			ownerdraw		UI_GAMETYPE_MAPNAME																							\
			textfont		CHOICE_TEXTFONT																								\
			textscale		TEXTSIZE_SMALL																								\
			textstyle		CHOICE_TEXTSTYLE																							\
			textalign		ITEM_ALIGN_TOP_LEFT																							\
			visible			1																											\
			decoration																													\
		} 

#define GAME_INFO_VETO( mapImageExp, mapNameExp, gameTypeExp, visArg )																		\
		/* map image */																														\
		PREPROC_SHADER_DRAW_VIS_EX(	GAMEINFO_X (GAMEINFO_Y+20) GAMEINFO_WIDTH2 GAMEINFO_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,	\
									mapImageExp, 1 1 1 1, when( visArg );, ; )																\
		/* new gametype on mapname */																										\
		itemDef																																\
		{																																	\
			type			ITEM_TYPE_OWNERDRAW_TEXT																						\
			rect			GAMEINFO_ORIGIN GAMEINFO_WIDTH 16 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP									\
			origin			0 155																											\
			forecolor		CHOICE_TEXTCOLOR																								\
			ownerdraw		UI_GAMETYPE_MAPNAME																								\
			textfont		CHOICE_TEXTFONT																									\
			textscale		TEXTSIZE_SMALL																									\
			textstyle		CHOICE_TEXTSTYLE																								\
			textalign		ITEM_ALIGN_LEFT																									\
			visible			1																												\
			decoration																														\
		}																																	\
		/* veto status */																													\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_ORIGIN GAMEINFO_WIDTH 16 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 2 35, ( dvarstring( party_vetoStatus ) ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, 1 .4 .4 1, when( inlobby() ); )

#define GAME_INFO_VETO_COOP( mapImageExp, mapNameExp, gameTypeExp, visArg )																	\
		/* map image */																														\
		PREPROC_SHADER_DRAW_VIS_EX(	GAMEINFO_X (GAMEINFO_Y+20) GAMEINFO_WIDTH2 GAMEINFO_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,	\
									mapImageExp, 1 1 1 1, when( visArg );, ; )																\
		/* new gametype on mapname */																										\
		itemDef																																\
		{																																	\
			type			ITEM_TYPE_OWNERDRAW_TEXT																						\
			rect			GAMEINFO_ORIGIN GAMEINFO_WIDTH 16 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP									\
			origin			0 155																											\
			forecolor		CHOICE_TEXTCOLOR																								\
			ownerdraw		UI_GAMETYPE_MAPNAME																								\
			textfont		CHOICE_TEXTFONT																									\
			textscale		TEXTSIZE_SMALL																									\
			textstyle		CHOICE_TEXTSTYLE																								\
			textalign		ITEM_ALIGN_LEFT																									\
			visible			1																												\
			decoration																														\
		}																																	\
		/* veto status */																													\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_ORIGIN GAMEINFO_WIDTH 16 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 2 35, ( dvarstring( party_vetoStatus ) ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, 1 .4 .4 1, when( inlobby() ); )

#define GAME_INFO3( mapImageExp, gameTypeImageExp, gameTypeExp, mapNameExp, gameTypeDescExp, mapSizeExp, vehicleExp, visArg )																								\
		/* map image */																																																		\
		PREPROC_SHADER_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,							mapImageExp,		1 1 1 1, when( visArg );, ; ) 													\
		/* game type image */																																																\
		PREPROC_SHADER_DRAW_VIS_EX( (GAMEINFO_ORIGIN_X+150) (GAMEINFO_ORIGIN_Y+55) 45 45 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,	gameTypeImageExp,	1 1 1 1, when( visArg );, ; )													\
		/* game type name */																																																\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 120,			gameTypeExp,		CHOICE_TEXTSIZE,	0, 0, ITEM_ALIGN_LEFT, COLOR_INFO_YELLOW,	when( visArg ); )				\
		/* mapname */																																																		\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+15),		mapNameExp,			CHOICE_TEXTSIZE,	0, 0, ITEM_ALIGN_LEFT, COLOR_INFO_YELLOW,	when( visArg ); )				\
		/* game type description */																																															\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+50),	gameTypeDescExp,	TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_LEFT, COLOR_BODY_TEXT,		when( visArg );, autowrapped )	\
		/* map size */																																																		\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+175),	mapSizeExp,			TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_LEFT, COLOR_FOCUSED,		when( visArg ); )				\
		/* vehicle */																																																		\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+195),	vehicleExp,			TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_LEFT, COLOR_FOCUSED,		when( visArg ); )
		
#define GAME_INFO3_COOP( mapImageExp, gameTypeImageExp, gameTypeExp, mapNameExp, gameTypeDescExp, visArg )																									\
		/* map image */																																														\
		PREPROC_SHADER_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,										mapImageExp,		1 1 1 1, when( visArg );, ; )						\
		/* game type image */																																												\
		PREPROC_SHADER_DRAW_VIS_EX( (GAMEINFO_ORIGIN_X+110) (GAMEINFO_ORIGIN_Y+55) 45 45 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,	gameTypeImageExp,	1 1 1 1, when( visArg );, ; )						\
		/* game type name */																																												\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 120,			gameTypeExp,		TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR,	when( visArg ); )	\
		/* mapname */																																														\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+15),		mapNameExp,			TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR,	when( visArg ); )	\
		/* game type description */																																											\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+50),	gameTypeDescExp,	TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_BODY_TEXT,		when( visArg );, autowrapped ) 

#define GAME_INFO3_COOP_LOCKED( mapImageExp, gameTypeImageExp, gameTypeExp, mapNameExp, gameTypeDescExp, visArg )																							\
		/* map image */																																														\
		PREPROC_SHADER_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,										mapImageExp,		1 1 1 1, when( visArg );, ; )						\
		/* game type image */																																												\
		PREPROC_SHADER_DRAW_VIS_EX( (GAMEINFO_ORIGIN_X+110) (GAMEINFO_ORIGIN_Y+55) 45 45 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,	gameTypeImageExp,	1 1 1 1, when( visArg );, ; )						\
		/* game type name */																																												\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 120,			gameTypeExp,		TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR,	when( visArg ); )	\
		/* game type description */																																											\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+50),	gameTypeDescExp,	TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_BODY_TEXT,		when( visArg );, autowrapped ) 

#define GAME_INFO_CUSTOMMODE( gameTypeImageExp, gameTypeExp, gameTypeDescExp, visArg )																																	\
		/* game type image */																																															\
		PREPROC_SHADER_DRAW_VIS_EX( (GAMEINFO_X+150) (GAMEINFO_Y+50) 45 45 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, gameTypeImageExp, 1 1 1 1, when( visArg );, ; )													\
		/* game type name */																																															\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 120,			gameTypeExp,		CHOICE_TEXTSIZE,	0, 0, ITEM_ALIGN_LEFT, COLOR_INFO_YELLOW,	when( visArg ); )			\
		/* game type description */																																														\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (140),	gameTypeDescExp,	TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_LEFT, COLOR_BODY_TEXT,		when( visArg );, autowrapped )	\
		/* choice desc */																																																\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_ORIGIN (GAMEINFO_WIDTH+50) GAMEINFO_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, GAMEINFO_DESC_X GAMEINFO_DESC_Y,			dvarString( "ui_choice_desc" ),		TEXTSIZE_SMALL,	0, 0, ITEM_ALIGN_LEFT, 1 1 1 1,	when( visArg );, autowrapped )

#define GAME_INFO_PRIVATEMATCH( mapImageExp, gameTypeImageExp, gameTypeBaseName, gameTypeName, mapNameExp, gameTypeDescExp, mapSizeExp, visArg )																			\
		/* map image */																																																		\
		PREPROC_SHADER_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,							mapImageExp, 1 1 1 1, when( visArg );, ; )															\
		/* game type image */																																																\
		PREPROC_SHADER_DRAW_VIS_EX( (GAMEINFO_X+150) (GAMEINFO_Y+55) 45 45 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP,	gameTypeImageExp, 1 1 1 1, when( visArg );, ; )														\
		/* mapname */																																																		\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 115,			mapNameExp,			CHOICE_TEXTSIZE,	0, 0, ITEM_ALIGN_LEFT, COLOR_INFO_YELLOW,	when( visArg ); )				\
		/* game type base name */																																															\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (115+25),		gameTypeBaseName,	CHOICE_TEXTSIZE,	0, 0, ITEM_ALIGN_LEFT, COLOR_INFO_YELLOW,	when( visArg ); )				\
		/* game type name */																																																\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (115+40),	gameTypeName,		CHOICE_TEXTSIZE,	0, 0, ITEM_ALIGN_LEFT, COLOR_INFO_YELLOW,	when( visArg );, autowrapped )	\
		/* game type description */																																															\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+70),	gameTypeDescExp,	TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_LEFT, COLOR_BODY_TEXT,		when( visArg );, autowrapped )	\
		/* map size */																																																		\
		PREPROC_TEXT_DRAW_VIS( GAMEINFO_RECT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, 0 (120+195),	mapSizeExp,			TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_LEFT, COLOR_FOCUSED,		when( visArg ); )
