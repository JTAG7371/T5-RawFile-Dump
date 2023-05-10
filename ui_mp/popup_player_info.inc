

#define PLAYER_INFO_PAD			2
#define PLAYER_INFO_WIDTH		185
#define PLAYER_INFO_HEIGHT		40
#define PLAYER_INFO_ALIGN		HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#ifdef SPLITSCREEN_ENABLED
#define RANK_SIZE				(17*SPLITSCREEN_MULTIPLIER)
#else
#define RANK_SIZE				17
#endif

#define	PLAYER_INFO_X_START( frameWidth )		( ( frameWidth / 2 ) - PLAYER_INFO_WIDTH )
#define	PLAYER_INFO_Y_START( frameHeight )		( ( -frameHeight / 2 ) + PLAYER_INFO_PAD )

#define RANK_ICON( px, py, pshader, pvis ) \
		PREPROC_SHADER_DRAW_VIS_EX( px py RANK_SIZE RANK_SIZE PLAYER_INFO_ALIGN, pshader, 1 1 1 1, pvis, ; )

#define RANK_ICON_ADV( px, py, palign, pshader, pvis ) \
		PREPROC_SHADER_DRAW_ADV_VIS_EX( px, py, RANK_SIZE, RANK_SIZE, palign, pshader, 1 1 1 1, pvis, ; )

#define PLAYER_RANK_ICON_AND_LEVEL( px, py, visArg )																							\ 
		/* Player rank icon */																													\
		RANK_ICON(	(px+18), py,																												\
					tablelookup( "mp/rankIconTable.csv", 0, getDStat( "PlayerStatsList", "RANK" ), getDStat( "PlayerStatsList", "PLEVEL" )+1 ),	\
					when( visArg ) )																											\
		/* Player level */																														\
		PREPROC_TEXT_DRAW_ALL(	px py RANK_SIZE RANK_SIZE PLAYER_INFO_ALIGN, 0 0,																\
								tablelookup( "mp/ranktable.csv", 0, getDStat( "PlayerStatsList", "RANK" ), 14 ), TEXTSIZE_SMALL, 0, 0,			\
								ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
								when( visArg ), ; )	

#define FRIEND_RANK_ICON_AND_LEVEL( px, py, visArg )																															\ 
		/* Friend rank icon */																																					\
		RANK_ICON( (px+18), py,																																					\
					tablelookup( "mp/rankIconTable.csv", 0, GetRankByXUID( dvarString( "selectedPlayerXuid" ) ), GetPrestigeByXUID( dvarString( "selectedPlayerXuid" ) )+1 ),	\
					when( visArg ) )																																			\
		/* Friend level */																																						\
		PREPROC_TEXT_DRAW_ALL(	px py RANK_SIZE RANK_SIZE PLAYER_INFO_ALIGN, 0 0,																								\
								GetDisplayLevelByXUID( dvarString( "selectedPlayerXuid" ) ), TEXTSIZE_SMALL, 0, 0,																\
								ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,															\
								when( visArg ), ; )		
						
#define PLAYER_RANK_ICON_AND_LEVEL_ADV( px, py, pHorizAlign, pVertAlign, pvis )																											\ 
		/* Player rank icon */																																							\
		RANK_ICON_ADV(	(px+18), py, pHorizAlign pVertAlign,																															\
						tablelookup( "mp/rankIconTable.csv", 0, GetRankByXUID( dvarString( "highlightedPlayerXuid" ) ), GetPrestigeByXUID( dvarString( "highlightedPlayerXuid" ) )+1 ),	\
						when( pvis ) )																																					\
		/* Player level */																																								\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, RANK_SIZE, RANK_SIZE, pHorizAlign, pVertAlign,																								\
									GetDisplayLevelByXUID( dvarString( "highlightedPlayerXuid" ) ), TEXTSIZE_SMALL, 0, 0,																\
									ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,																\
									when( pvis ), ; )		

#define NAME_WIDTH						145
#define CLAN_TAG_WIDTH					40


#define PLAYER_NAME( px, py, visArg )																				\
		PREPROC_TEXT_DRAW_ALL(	px py NAME_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,									\
								GetSelfGamerTag(), TEXTSIZE_SMALL, 0, 0,											\
								ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,	\
								when( visArg && !USE_SMALLER_FONT ), ; )											\
		PREPROC_TEXT_DRAW_ALL(	px py NAME_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,									\
								GetSelfGamerTag(), (TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER), 0, 0,			\
								ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,	\
								when( visArg && USE_SMALLER_FONT ), ; )																						

#define PLAYER_CLAN_TAG( px, py, visArg )																			\
		PREPROC_TEXT_DRAW_ALL(	px py CLAN_TAG_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,								\
								GetClanName(), TEXTSIZE_SMALL, 0, 0, 												\
								ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,	\
								when( visArg && !USE_SMALLER_FONT ), ; )											\
		PREPROC_TEXT_DRAW_ALL(	px py CLAN_TAG_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,								\
								GetClanName(), (TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER), 0, 0, 				\
								ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,	\
								when( visArg && USE_SMALLER_FONT ), ; )											
			
#define PLAYER_CLAN_TAG_AND_NAME( px, py, visArg )																	\
		PREPROC_TEXT_DRAW_ALL(	px py (NAME_WIDTH + CLAN_TAG_WIDTH) RANK_SIZE PLAYER_INFO_ALIGN, 0 0,				\
								GetClanTagAndName(), TEXTSIZE_SMALL, 0, 0,											\
								ITEM_ALIGN_BOTTOM_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,	\
								when( visArg ), ; )

#define FRIEND_NAME( px, py, visArg )																						\
		PREPROC_TEXT_DRAW_ALL(	px py NAME_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,											\
								dvarString( "selectedFriendName" ), TEXTSIZE_SMALL, 0, 0,									\
								ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,			\
								when( visArg && !USE_SMALLER_FONT ), ; )													\
		PREPROC_TEXT_DRAW_ALL(	px py NAME_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,											\
								dvarString( "selectedFriendName" ), ( TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER ), 0, 0,	\
								ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,			\
								when( visArg && USE_SMALLER_FONT ), ; )		
									
#define FRIEND_CLAN_TAG( px, py, visArg )																						\
		PREPROC_TEXT_DRAW_ALL(	px py CLAN_TAG_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,											\
								dvarString( "selectedFriendClanTag" ), TEXTSIZE_SMALL, 0, 0, 									\
								ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,				\
								when( visArg && !USE_SMALLER_FONT ), ; )																				\
		PREPROC_TEXT_DRAW_ALL(	px py CLAN_TAG_WIDTH RANK_SIZE PLAYER_INFO_ALIGN, 0 0,											\
								dvarString( "selectedFriendClanTag" ), (TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER), 0, 0,	\
								ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,				\
								when( visArg && USE_SMALLER_FONT ), ; )	
										
#define PLAYER_NAME_ADV( px, py, pHorizAlign, pVertAlign, pvis )																				\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, NAME_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,														\
									dvarString( "highlightedPlayerName" ), TEXTSIZE_SMALL, 0, 0,												\
									ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) != GetSelfGamerTag() ) && !USE_SMALLER_FONT ), ; )	\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, NAME_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,														\
									GetSelfGamerTag(), TEXTSIZE_SMALL, 0, 0,																	\
									ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) == GetSelfGamerTag() ) && !USE_SMALLER_FONT ), ; )	\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, NAME_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,														\
									dvarString( "highlightedPlayerName" ), ( TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER ), 0, 0,				\
									ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) != GetSelfGamerTag() ) && USE_SMALLER_FONT ), ; )		\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, NAME_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,														\
									GetSelfGamerTag(), ( TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER ), 0, 0,									\
									ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) == GetSelfGamerTag() ) && USE_SMALLER_FONT ), ; )

#define PLAYER_CLAN_TAG_ADV( px, py, pHorizAlign, pVertAlign, pvis )																			\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, CLAN_TAG_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,													\
									dvarString( "highlightedPlayerClanTag" ), TEXTSIZE_SMALL, 0, 0,												\
									ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) != GetSelfGamerTag() ) && !USE_SMALLER_FONT ), ; )	\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, CLAN_TAG_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,													\
									GetClanName(), TEXTSIZE_SMALL, 0, 0,																		\
									ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) == GetSelfGamerTag() ) && !USE_SMALLER_FONT ), ; )	\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, CLAN_TAG_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,													\
									dvarString( "highlightedPlayerClanTag" ), (TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER), 0, 0,				\
									ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) != GetSelfGamerTag() ) && USE_SMALLER_FONT ), ; )		\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, CLAN_TAG_WIDTH, RANK_SIZE, pHorizAlign, pVertAlign,													\
									GetClanName(), (TEXTSIZE_SMALL * FOREIGN_LANGUAGE_MULTIPLIER), 0, 0,										\
									ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) == GetSelfGamerTag() ) && USE_SMALLER_FONT ), ; )

#define EMBLEM_SIZE				32

#define PLAYER_EMBLEM( px, py, visArg )	\
		PLAYER_EMBLEM_ALL( px, py, EMBLEM_SIZE, EMBLEM_SIZE, visArg )

#define PLAYER_EMBLEM_ALL( px, py, pw, ph, visArg )			\
		itemDef												\
		{													\
			type            ITEM_TYPE_OWNERDRAW				\
			ownerdraw       UI_PLAYER_EMBLEM				\
			rect            px py pw ph PLAYER_INFO_ALIGN	\
			exp             ownerdata( getxuid() );			\
			visible         when( visArg )					\
			decoration										\
		}
			
#define FRIEND_EMBLEM( px, py, visArg )	\
		FRIEND_EMBLEM_ALL( px, py, EMBLEM_SIZE, EMBLEM_SIZE, visArg )
										
#define FRIEND_EMBLEM_ALL( px, py, pw, ph, visArg )								\
		itemDef																	\
		{																		\
			type            ITEM_TYPE_OWNERDRAW									\
			ownerdraw       UI_PLAYER_EMBLEM									\
			rect            px py pw ph PLAYER_INFO_ALIGN						\
			exp             ownerdata( dvarString( "selectedPlayerXuid" ) );	\
			visible         when( visArg )										\
			decoration															\
		} 

#define PLAYER_EMBLEM_ADV( px, py, pHorizAlign, pVertAlign, pvis )				\
		itemDef																	\
		{																		\
			type            ITEM_TYPE_OWNERDRAW									\
			ownerdraw       UI_PLAYER_EMBLEM									\
			rect            px 0 EMBLEM_SIZE EMBLEM_SIZE pHorizAlign pVertAlign	\
			exp				rect Y( py )										\
			exp             ownerdata( dvarString( "highlightedPlayerXuid" ) );	\
			visible         when( pvis )										\
			decoration															\
		} 

#define POINTS_SIZE				70

#define PLAYER_CP( px, py, visArg )																						\
		PREPROC_TEXT_DRAW_ALL(	px py POINTS_SIZE RANK_SIZE PLAYER_INFO_ALIGN, 0 0,										\
								locString( "@MENU_POINTS", GetStatByName("CODPOINTS") ), TEXTSIZE_SMALL, 0, 0,			\
								ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,	\
								when( visArg ), ; )	

#define PLAYER_CP_ADV( px, py, pHorizAlign, pVertAlign, pvis )																						\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, POINTS_SIZE, RANK_SIZE, pHorizAlign, pVertAlign,														\
									locString( "@MENU_POINTS", GetCodpointsByXUID( dvarString( "highlightedPlayerXuid" ) ) ), TEXTSIZE_SMALL, 0, 0,	\
									ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) != GetSelfGamerTag() ) ), ; )								\
		PREPROC_TEXT_DRAW_ADV_ALL(	px, py, POINTS_SIZE, RANK_SIZE, pHorizAlign, pVertAlign,														\
									locString( "@MENU_POINTS", GetStatByName("CODPOINTS") ), TEXTSIZE_SMALL, 0, 0,									\
									ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
									when( pvis && ( dvarString( "highlightedPlayerName" ) == GetSelfGamerTag() ) ), ; )

#define FRIEND_CP( px, py, visArg )																												\		
		PREPROC_TEXT_DRAW_ALL(	px py POINTS_SIZE RANK_SIZE PLAYER_INFO_ALIGN, 0 0,																\
								locString( "@MENU_POINTS", GetCodpointsByXUID( dvarString( "selectedPlayerXuid" ) ) ), TEXTSIZE_SMALL, 0, 0,	\
								ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_SHADOWED,							\
								when( visArg ), ; )		

#define FRIEND_INFO_BG_VIS( px, py, visArg )																										\
		PREPROC_SHADER_DRAW_VIS_EX( px py PLAYER_INFO_WIDTH PLAYER_INFO_HEIGHT PLAYER_INFO_ALIGN, emblem_bg_nocod, 1 1 1 1,  when( visArg ), ; )	\
		PREPROC_SHADER_DRAW_VIS_EX( px py PLAYER_INFO_WIDTH PLAYER_INFO_HEIGHT PLAYER_INFO_ALIGN, emblemPlayerBackgroundMaterial( dvarString( "selectedPlayerXuid" ), 0 ), 1 1 1 1,  when( visArg ), ; )

#define PLAYER_INFO_BG_VIS( px, py, visArg )																										\
		PREPROC_SHADER_DRAW_VIS_EX( px py PLAYER_INFO_WIDTH PLAYER_INFO_HEIGHT PLAYER_INFO_ALIGN, emblem_bg_nocod, 1 1 1 1, when( visArg ), ; )	\
		PREPROC_SHADER_DRAW_VIS_EX( px py PLAYER_INFO_WIDTH PLAYER_INFO_HEIGHT PLAYER_INFO_ALIGN, emblemPlayerBackgroundMaterial( getxuid(), 0 ), 1 1 1 1, when( visArg ), ; )

#define PLAYER_INFO_BG_ADV( px, py, pHorizAlign, pVertAlign, pVis )																								\
		PREPROC_SHADER_DRAW_ADV_VIS_EX( px, py, PLAYER_INFO_WIDTH, PLAYER_INFO_HEIGHT, pHorizAlign pVertAlign, emblem_bg_nocod, 1 1 1 1, when( pVis ), ; )	\
		PREPROC_SHADER_DRAW_ADV_VIS_EX( px, py, PLAYER_INFO_WIDTH, PLAYER_INFO_HEIGHT, pHorizAlign pVertAlign, emblemPlayerBackgroundMaterial( dvarString( "highlightedPlayerXuid" ), 0	), 1 1 1 1, when( pVis ), ; )

#define	EMBLEM_X_OFFSET			4
#define EMBLEM_Y_OFFSET			4
#define NAME_X_OFFSET			( EMBLEM_X_OFFSET + EMBLEM_SIZE + 3 )
#define NAME_Y_OFFSET			( EMBLEM_Y_OFFSET - 2 )
#define RANK_X_OFFSET			( NAME_X_OFFSET + CLAN_TAG_WIDTH - 2 )
#define RANK_Y_OFFSET			( EMBLEM_Y_OFFSET + EMBLEM_SIZE - RANK_SIZE + 2 )
#define POINT_X_OFFSET			( RANK_X_OFFSET + ( RANK_SIZE * 2 ) - 3 )

#define PLAYER_INFO_VIS( pw, ph, visArg )																										\
		PLAYER_INFO_BG_VIS(			(PLAYER_INFO_X_START( pw )),					(PLAYER_INFO_Y_START( ph )),					visArg )	\
		PLAYER_EMBLEM(				(PLAYER_INFO_X_START( pw ) + EMBLEM_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + EMBLEM_Y_OFFSET),	visArg )	\
		PLAYER_NAME(				(PLAYER_INFO_X_START( pw ) + NAME_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + NAME_Y_OFFSET),	visArg )	\ 
		PLAYER_CLAN_TAG(			(PLAYER_INFO_X_START( pw ) + NAME_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + RANK_Y_OFFSET),	visArg )	\
		PLAYER_RANK_ICON_AND_LEVEL(	(PLAYER_INFO_X_START( pw ) + RANK_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + RANK_Y_OFFSET),	visArg )	\
		PLAYER_CP(					(PLAYER_INFO_X_START( pw ) + POINT_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + RANK_Y_OFFSET),	visArg )	

#define FRIEND_INFO_VIS( pw, ph, visArg )																										\
		FRIEND_INFO_BG_VIS(			(PLAYER_INFO_X_START( pw )),					(PLAYER_INFO_Y_START( ph )),					visArg )	\
		FRIEND_EMBLEM(				(PLAYER_INFO_X_START( pw ) + EMBLEM_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + EMBLEM_Y_OFFSET),	visArg )	\
		FRIEND_NAME(				(PLAYER_INFO_X_START( pw ) + NAME_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + NAME_Y_OFFSET),	visArg )	\ 
		FRIEND_CLAN_TAG(			(PLAYER_INFO_X_START( pw ) + NAME_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + RANK_Y_OFFSET),	visArg )	\
		FRIEND_RANK_ICON_AND_LEVEL(	(PLAYER_INFO_X_START( pw ) + RANK_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + RANK_Y_OFFSET),	visArg )	\
		FRIEND_CP(					(PLAYER_INFO_X_START( pw ) + POINT_X_OFFSET),	(PLAYER_INFO_Y_START( ph ) + RANK_Y_OFFSET),	visArg ) 	

#define	PLAYER_INFO_ADV( px, py, pHorizAlign, pVertAlign, pvis )														\ 
		PLAYER_INFO_BG_ADV(				(px),					(py),					pHorizAlign, pVertAlign, pvis )	\
		PLAYER_EMBLEM_ADV(				(px + EMBLEM_X_OFFSET),	(py + EMBLEM_Y_OFFSET),	pHorizAlign, pVertAlign, pvis )	\
		PLAYER_NAME_ADV(				(px + NAME_X_OFFSET),	(py + NAME_Y_OFFSET),	pHorizAlign, pVertAlign, pvis )	\ 
		PLAYER_CLAN_TAG_ADV(			(px + NAME_X_OFFSET),	(py + RANK_Y_OFFSET),	pHorizAlign, pVertAlign, pvis )	\	
		PLAYER_RANK_ICON_AND_LEVEL_ADV(	(px + RANK_X_OFFSET),	(py + RANK_Y_OFFSET),	pHorizAlign, pVertAlign, pvis )	\
		PLAYER_CP_ADV(					(px + POINT_X_OFFSET),	(py + RANK_Y_OFFSET),	pHorizAlign, pVertAlign, pvis )
