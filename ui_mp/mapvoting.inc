
#define VOTE_BG_SIZE								14

#define HL_GREEN									0.42 0.68 0.46 1

#define IS_MAP_VOTING_ALLOWED						( 1 )
#define IS_MAP_SELECTION_VISIBLE					( !IsPartyReady() && InLobby() && IS_MAP_VOTING_ALLOWED && IsCurrentOrPreviousMapEntryAvailable() )
#define IS_SELECTED( itemIndex )					( localVarInt( ui_highlight ) == itemIndex && localVarString( ui_choicegroup ) == CHOICE_GROUP )

#define SELECTION_IMAGE( materialArg )				( "menu_" + materialArg + "_map_select" )
#define SELECTION_IMAGE_BW( materialArg )			( "menu_" + materialArg + "_map_select_bw" )
#define SELECTION_IMAGE_BIG( materialArg )			( "menu_" + materialArg + "_map_select_big" )
#define SELECTION_IMAGE_FINAL( materialArg )		( "menu_" + materialArg + "_map_select_final" )
		
#define MAP_SELECTION_IMAGE( itemIndex, xPos, yPos, widthArg, heightArg, materialArg )							\
		PREPROC_SHADER_DRAW_VIS_EX(	xPos yPos widthArg heightArg HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP, 	\
									SELECTION_IMAGE( materialArg ), 1 1 1 1,									\
									when( IS_MAP_SELECTION_VISIBLE && IS_SELECTED( itemIndex ) );, ; )			\
		PREPROC_SHADER_DRAW_VIS_EX(	xPos yPos widthArg heightArg HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP, 	\
									SELECTION_IMAGE_BW( materialArg ), 1 1 1 1,									\
									when( IS_MAP_SELECTION_VISIBLE && !IS_SELECTED( itemIndex ) );, ; )							

#define MAP_SELECTION_COUNT( xPos, yPos, heightArg, selectedMapDvar, voteCountDvar )																\
		PREPROC_SHADER_DRAW_VIS_EX(	(xPos+4) (yPos+heightArg-VOTE_BG_SIZE-2) VOTE_BG_SIZE VOTE_BG_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\
									"white", 0 0 0 0.8,																								\
									when( IS_MAP_SELECTION_VISIBLE && dvarInt( selectedMapDvar ) == 0 );, ; )										\		
		PREPROC_SHADER_DRAW_VIS_EX(	(xPos+4) (yPos+heightArg-VOTE_BG_SIZE-2) VOTE_BG_SIZE VOTE_BG_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\
									"white", HL_GREEN,																								\
									when( IS_MAP_SELECTION_VISIBLE && dvarInt( selectedMapDvar ) == 1 );, ; )										\
		PREPROC_TEXT_DRAW_VIS(	(xPos+3) (yPos+heightArg-VOTE_BG_SIZE-1.5) VOTE_BG_SIZE VOTE_BG_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\
								0 0, dvarInt( voteCountDvar ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_CENTER, CHOICE_TEXTCOLOR,						\
								when( IS_MAP_SELECTION_VISIBLE && dvarInt( selectedMapDvar ) == 0 ); )												\
		PREPROC_TEXT_DRAW_VIS(	(xPos+3) (yPos+heightArg-VOTE_BG_SIZE-1.5) VOTE_BG_SIZE VOTE_BG_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\
								0 0, dvarInt( voteCountDvar ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_CENTER, 0 0 0 1,								\
								when( IS_MAP_SELECTION_VISIBLE && dvarInt( selectedMapDvar ) == 1 ); )

#define MAP_SELECTION_BUTTON( itemIndex, xPos, yPos, widthArg, heightArg, onFocusArg, leaveFocusArg, actionArg )							\
		CHOICE_BUTTON_NT_RECT_FOCUS_VIS_NOHI_EX(	itemIndex, xPos yPos widthArg heightArg HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,		\
													actionArg, onFocusArg, leaveFocusArg, when( IS_MAP_SELECTION_VISIBLE );, ; )			\
		/* Green highlighted border */																										\
		PREPROC_SHADER_DRAW_ALL(	(xPos-2) (yPos-2) (widthArg+2) (heightArg+2) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP, 0 0,			\
									"white", 0 0 0 0, 1, 1.5, HL_GREEN,																		\
									when( IS_MAP_SELECTION_VISIBLE && IS_SELECTED( itemIndex ) ), ; )
							
	
#define MAP_SELECTION_VOTE_DESC( xPos, yPos, widthArg, heightArg, textArg, selectedMapDvar )												\
		PREPROC_TEXT_DRAW_VIS(	(xPos+VOTE_BG_SIZE+6) (yPos+heightArg-VOTE_BG_SIZE-1.5) 48 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\
								0 0, textArg, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_LEFT, 1 1 1 1,											\
								when( IS_MAP_SELECTION_VISIBLE && dvarInt( selectedMapDvar ) == 0 ); )										\
		PREPROC_TEXT_DRAW_VIS(	(xPos+VOTE_BG_SIZE+6) (yPos+heightArg-VOTE_BG_SIZE-1.5) 48 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\
								0 0, textArg, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_LEFT, HL_GREEN,											\
								when( IS_MAP_SELECTION_VISIBLE && dvarInt( selectedMapDvar ) == 1 ); )

#define SELECTION_WIDTH			96
#define MAP_SELECTION_INFO( xPos, yPos, widthArg, heightArg, mapName, gametypeName, visArg )																		\
		PREPROC_TEXT_DRAW_ALL( (xPos+widthArg-SELECTION_WIDTH-4) (yPos+heightArg-VOTE_BG_SIZE+1-18) SELECTION_WIDTH 24 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\ 
								0 0, toUpper( mapName ), TEXTSIZE_LARGE, 0, 0, ITEM_ALIGN_TOP_RIGHT, 1 1 1 1, UI_FONT_EXTRABIG, ITEM_TEXTSTYLE_NORMAL,				\
								visArg, ; )																															\
		PREPROC_TEXT_DRAW_VIS(	(xPos+widthArg-SELECTION_WIDTH-4) (yPos+heightArg-VOTE_BG_SIZE-1) SELECTION_WIDTH 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,	\
								0 0, gametypeName, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_RIGHT, 1 1 1 1,																\
								visArg )

#define VOTE_BUTTON( itemIndex, xPos, yPos, widthArg, heightArg,													\
					 imageNameArg, materialArg,																		\
					 onFocusArg, leaveFocusArg, actionArg,															\
					 selectedMapDvar, voteCountDvar, descTextArg )													\
		MAP_SELECTION_IMAGE( itemIndex, xPos, yPos, widthArg, heightArg, materialArg )								\
		MAP_SELECTION_COUNT( xPos, yPos, heightArg, selectedMapDvar, voteCountDvar )								\
		MAP_SELECTION_BUTTON( itemIndex, xPos, yPos, widthArg, heightArg, onFocusArg, leaveFocusArg, actionArg )	\
		MAP_SELECTION_VOTE_DESC( xPos, yPos, widthArg, heightArg, descTextArg, selectedMapDvar ) 

#define VOTE_BUTTON_WITH_NAME(	itemIndex, xPos, yPos, widthArg, heightArg,				\
								imageNameArg, buttonNameArg, materialArg,				\
								onFocusArg, leaveFocusArg, actionArg,					\
								selectedMapDvar, voteCountDvar, 						\
								descTextArg, mapNameArg, gametypeName )					\
		VOTE_BUTTON(	itemIndex, xPos, yPos, widthArg, heightArg,						\
						imageNameArg, materialArg,										\
						onFocusArg, leaveFocusArg, actionArg,							\
						selectedMapDvar, voteCountDvar, descTextArg )					\
		MAP_SELECTION_INFO( xPos, yPos, widthArg, heightArg, mapNameArg, gametypeName, when( IS_MAP_SELECTION_VISIBLE ); )	


#define VOTE_WIDTH				183
#define VOTE_ASPECT_RATIO		(76/275)
#define VOTE_HEIGHT				(VOTE_WIDTH*VOTE_ASPECT_RATIO)
#define VOTE_X_OFFSET			(VOTE_WIDTH+2)
#define VOTE_Y_OFFSET			14
#define VOTE_X_START			(CHOICE_X_START+CHOICE_SIZE_X-VOTE_WIDTH-10)
#define VOTE_Y_START			(242)
//Voting in progress	
		PREPROC_TEXT_DRAW_VIS(	VOTE_X_START (VOTE_Y_START-16) 100 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP, 
								0 0, "@MPUI_VOTE_FOR", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_LEFT, LOBBY_STATUS_COLOR,
								when( !IsPartyReady() && InLobby() && IS_MAP_VOTING_ALLOWED ); )
		
		PREPROC_TEXT_DRAW_VIS(	VOTE_X_START (VOTE_Y_START-VOTE_Y_OFFSET) 100 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,
								0 0, "@MENU_MAPVOTINGLOCKED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_LEFT, LOBBY_STATUS_COLOR,
								when( IsPartyReady() && InLobby() && IS_MAP_VOTING_ALLOWED ); )
//Current/Next Map image
#define CURRENT_BUTTON_ON_FOCUS			\
		exec "set ui_current_button 1";	\
		exec "set ui_votebutton 1";				

#define CURRENT_BUTTON_LEAVE_FOCUS \
		; 

#define CURRENT_BUTTON_ACTION												\
		exec "set current_map_bg 1";										\
		exec "set previous_map_bg 0";										\
		exec "set next_map_bg 0";											\
		play CHOICE_FOCUS_SOUND;											\
		exec set ui_bg_image SELECTION_IMAGE_BIG( GetCurrentMapName() );	\
		exec "xpartyveto 1";


#define MAPIMAGE			( GetCurrentMapName() )

#define CURRENT_DESC		( "@MPUI_NEXT_CAPS" )
#define CURRENT_MAPNAME		( locstring( tableLookup( "mp/mapstable.csv",		0, GetCurrentMapName(),		3 ) ) )
#define CURRENT_GAMETYPE	( locstring( tableLookup( "mp/gametypesTable.csv",	0, GetCurrentGameType(),	1 ) ) )
			
		VOTE_BUTTON_WITH_NAME(	7, VOTE_X_START, VOTE_Y_START, VOTE_WIDTH, VOTE_HEIGHT, 
								"current_map_image", current_button, MAPIMAGE, 
								CURRENT_BUTTON_ON_FOCUS, CURRENT_BUTTON_LEAVE_FOCUS, CURRENT_BUTTON_ACTION, 
								current_map_bg, party_currentMapVetoCount,  
								CURRENT_DESC, CURRENT_MAPNAME, CURRENT_GAMETYPE )

//Previous Map image
#define PREVIOUS_BUTTON_ON_FOCUS		\
		exec "set ui_current_button 2";	\
		exec "set ui_votebutton 1";				

#define PREVIOUS_BUTTON_LEAVE_FOCUS \
		; 

#define PREVIOUS_BUTTON_ACTION												\
		exec "set current_map_bg 0";										\
		exec "set previous_map_bg 1";										\
		exec "set next_map_bg 0";											\
		exec set ui_bg_image SELECTION_IMAGE_BIG( GetPreviousMapName() );	\
		play CHOICE_FOCUS_SOUND;											\
		exec "xpartyveto 2";


#define PREVIOUSMAPIMAGE	( GetPreviousMapName() )

#define PREVIOUS_DESC		( "@MPUI_PREV_CAPS" )
#define PREVIOUS_MAPNAME	( locstring( tableLookup( "mp/mapstable.csv",		0, GetPreviousMapName(),	3 ) ) )
#define PREVIOUS_GAMETYPE	( locstring( tableLookup( "mp/gametypesTable.csv",	0, GetPreviousGameType(),	1 ) ) )

		VOTE_BUTTON_WITH_NAME(	8, VOTE_X_START, (VOTE_Y_START+VOTE_HEIGHT+5), VOTE_WIDTH, VOTE_HEIGHT, 
								"previous_map_image", previous_button, PREVIOUSMAPIMAGE, 
								PREVIOUS_BUTTON_ON_FOCUS, PREVIOUS_BUTTON_LEAVE_FOCUS, PREVIOUS_BUTTON_ACTION, 
								previous_map_bg, party_previousMapVetoCount,  
								PREVIOUS_DESC, PREVIOUS_MAPNAME, PREVIOUS_GAMETYPE )

//Random Map image	
#define NEXT_BUTTON_ON_FOCUS			\
		exec "set ui_current_button 3";	\
		exec "set ui_votebutton 1";				

#define NEXT_BUTTON_LEAVE_FOCUS \
		;

#define NEXT_BUTTON_ACTION											\
		exec "set current_map_bg 0";								\
		exec "set previous_map_bg 0";								\
		exec "set next_map_bg 1";									\
		exec set ui_bg_image SELECTION_IMAGE_BIG( "mp_random" );	\
		play CHOICE_FOCUS_SOUND;									\
		exec "xpartyveto 3";

#define NEXT_DESC ( "@MPUI_RANDOM_CAPS" )

		VOTE_BUTTON(	9, VOTE_X_START, (VOTE_Y_START+(VOTE_HEIGHT*2)+10), VOTE_WIDTH, (VOTE_HEIGHT*0.56), 
						"next_map_image", "mp_random", 
						NEXT_BUTTON_ON_FOCUS, NEXT_BUTTON_LEAVE_FOCUS, NEXT_BUTTON_ACTION, 
						next_map_bg, party_nextMapVetoCount, NEXT_DESC )

					
#define MAP_X_START				VOTE_X_START
#define MAP_Y_START				(VOTE_Y_START+5)
#define MAP_WIDTH				VOTE_WIDTH
#define MAP_ASPECT_RATIO		(203/275)
#define MAP_HEIGHT				(MAP_WIDTH*MAP_ASPECT_RATIO)

#define MAPTOBEPLAYEDIMAGE		SELECTION_IMAGE_FINAL( dvarString( ui_mapname ) )
#define MAPTOBEPLAYEDNAME		locString( tableLookup( "mp/mapsTable.csv", 0, dvarString( ui_mapname ), 3 ) )
#define GAMETYPETOBEPLAYED		dvarString( party_gametype )

//After the map is locked, we need to display only one selected map image
						
		PREPROC_SHADER_DRAW_VIS_EX(	MAP_X_START MAP_Y_START MAP_WIDTH MAP_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP,
									MAPTOBEPLAYEDIMAGE, 1 1 1 1,
									when( ( IsPartyReady() || !IS_MAP_VOTING_ALLOWED ) && InLobby() );, ; )		
		
		MAP_SELECTION_INFO(	(MAP_X_START-4), (MAP_Y_START-4), MAP_WIDTH, MAP_HEIGHT, 
							MAPTOBEPLAYEDNAME, GAMETYPETOBEPLAYED, 
							when( ( IsPartyReady() || !IS_MAP_VOTING_ALLOWED ) && InLobby() ); )

