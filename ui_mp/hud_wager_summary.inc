// CONSOLE HUD - MP

#ifndef SPLITSCREEN_ENABLED
	#undef	SPLITSCREEN_MULTIPLIER
	#define SPLITSCREEN_MULTIPLIER	1
#endif

#define TIME_COLOR						0.74 0.84 0.86

#define SPEC_HUD_WIDTH					(160*SPLITSCREEN_MULTIPLIER)
#define PLAYER_INFO_ABBREV_HEIGHT		(17*SPLITSCREEN_MULTIPLIER)

#define SUMMARY_HEIGHT					(PLAYER_INFO_ABBREV_HEIGHT*(4*SPLITSCREEN_MULTIPLIER))
#define SUMMARY_START_Y					(-SUMMARY_HEIGHT)
#define SUMMARY_PLACE_PLAYER_SPACE		(25*SPLITSCREEN_MULTIPLIER)
#define SUMMARY_SPACING					(5*SPLITSCREEN_MULTIPLIER)
#define SUMMARY_YOU_COLOR				1 1 0.3 HUD_ALPHA
#define SUMMARY_SEPARATOR_WIDTH			(3*SPLITSCREEN_MULTIPLIER)

#define	WAGER_SUMMARY_ALIGN		HORIZONTAL_ALIGN_USER_LEFT VERTICAL_ALIGN_USER_BOTTOM

#define IS_PLAYER( playerNum ) \
		( getClientName( getClientInPlace( playerNum ) ) == player( localname ) )
	
#define IS_SCORE_DEFAULT( place ) \
		( 0 )
		//( getScoreForClient( getClientInPlace( place ) ) == dvarInt( "scr_wager_defaultScore" ) )
	
#define IS_PLACE_BLANK( place ) \
		( getClientInPlace( place ) < 0 )
	
#define IS_PLAYER_SCORE_DEFAULT \
		( player( score ) == dvarInt( "scr_wager_defaultScore" ) )

#define WIDGET_TEXT( x, y, width, height, align, font, scale, color, textExp, visibleExp )	\
		itemDef																				\
		{																					\
			type			ITEM_TYPE_TEXT													\
			rect			x y width height WAGER_SUMMARY_ALIGN							\
			textstyle		ITEM_TEXTSTYLE_NORMAL											\
			textalign		align															\
			textfont		font															\
			textscale		scale															\
			forecolor		color															\
			textExp																			\
			visible			visibleExp														\
			decoration																		\
		}
	
#define WIDGET_TEXT_SHADOWED( x, y, width, height, align, font, scale, color, textExp, visibleExp )	\
		itemDef																						\
		{																							\
			type			ITEM_TYPE_TEXT															\
			rect			x y width height WAGER_SUMMARY_ALIGN									\
			textstyle		ITEM_TEXTSTYLE_SHADOWED													\
			textalign		align																	\
			textfont		font																	\
			textscale		scale																	\
			forecolor		color																	\
			textExp																					\
			visible			visibleExp																\
			decoration																				\
		}

#define WIDGET_BACKGROUND_SHADER( x, y, width, height, color, bgMtl, visibleExp )	\
		itemDef																		\
		{																			\
			style			WINDOW_STYLE_SHADER										\
			rect			x y width height WAGER_SUMMARY_ALIGN					\
			forecolor		color													\
			background		bgMtl													\
			visible			visibleExp												\
			decoration																\
		}

#define BAR_SCORE_PERCENT ( player( score ) / dvarInt( "ui_scorelimit" ) )

#define SCORE_BAR( x, y, width, height, materialName, color, visibleExp )	\
		itemDef																\
		{																	\
			style			WINDOW_STYLE_SHADER								\
			type			ITEM_TYPE_IMAGE									\
			rect			x y width height WAGER_SUMMARY_ALIGN			\
			exp				rect W( width * BAR_SCORE_PERCENT );			\
			exp				material( materialName );						\
			forecolor		color											\
			visible 		visibleExp										\
			decoration														\
		}

#define BAR_SCORE_PERCENT_TEAM ( marinesfield( score ) / dvarInt( "ui_scorelimit" ) )

#define TEAM_SCORE_BAR( x, y, width, height, materialName, color, visibleExp )	\
		itemDef																	\
		{																		\
			style			WINDOW_STYLE_SHADER									\
			type			ITEM_TYPE_IMAGE										\
			rect			x y width height WAGER_SUMMARY_ALIGN				\
			exp				rect W( width * BAR_SCORE_PERCENT_TEAM );			\
			exp				material( materialName );							\
			forecolor		color												\
			visible 		visibleExp											\
			decoration															\
		}

#define TIMER_HEIGHT		(100*SPLITSCREEN_MULTIPLIER)

#define WAGER_GAME_TIMER \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			0 (SUMMARY_START_Y-TIMER_HEIGHT) SPEC_HUD_WIDTH TIMER_HEIGHT WAGER_SUMMARY_ALIGN \
			exp text		( secondsAsCountdown( timeLeft() ) ); \
			textfont		UI_FONT_DEFAULT \
			textscale		TEXTSIZE_DEFAULT \
			textalign		ITEM_ALIGN_BOTTOM_RIGHT \
			textstyle		ITEM_TEXTSTYLE_SHADOWED \
			visible 		when ( (timeLeft() / 1000) >= 60 ); \
			forecolor		TIME_COLOR HUD_FOREGROUND_ALPHA \
			decoration \
		} \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			0 (SUMMARY_START_Y-TIMER_HEIGHT) SPEC_HUD_WIDTH TIMER_HEIGHT WAGER_SUMMARY_ALIGN \
			exp text		( secondsAsCountdown( timeLeft() ) ); \
			textfont		UI_FONT_DEFAULT \
			textscale		TEXTSIZE_DEFAULT \
			textalign		ITEM_ALIGN_BOTTOM_RIGHT \
			textstyle		ITEM_TEXTSTYLE_SHADOWED \
			forecolor		1 0.75 0 HUD_FOREGROUND_ALPHA \
			visible 		when ( (timeLeft() / 1000) >= 30 && (timeLeft() / 1000) < 60 ); \
			decoration \
		} \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			0 (SUMMARY_START_Y-TIMER_HEIGHT) SPEC_HUD_WIDTH TIMER_HEIGHT WAGER_SUMMARY_ALIGN \
			exp text		( secondsAsCountdown( timeLeft(), 1 ) ); \
			textfont		UI_FONT_NORMAL \
			textscale		0.3 \
			textalign		ITEM_ALIGN_BOTTOM_RIGHT \
			textstyle		ITEM_TEXTSTYLE_SHADOWED \
			forecolor		1 0.5 0 1 \
			visible 		when ( (timeLeft() / 1000) >= 0 && (timeLeft() / 1000) < 30 ); \
			decoration \
		}

#define SUMMARY_PLACE( itemNumber ) \
		WIDGET_TEXT( SUMMARY_SPACING, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),				SPEC_HUD_WIDTH, 								PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_LEFT,		UI_FONT_NORMAL,	TEXTSIZE_SMALL, 1 1 1 HUD_ALPHA,	exp text( getPlaceWithTiesForScore( getScoreForClient( getClientInPlace( itemNumber ) ) ) ), when( !IS_PLAYER( itemNumber ) && !IS_PLACE_BLANK( itemNumber ) && !IS_SCORE_DEFAULT( itemNumber ) ) ) \
		WIDGET_TEXT( SUMMARY_SPACING, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),				SPEC_HUD_WIDTH, 								PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_LEFT,		UI_FONT_BOLD,	TEXTSIZE_SMALL, SUMMARY_YOU_COLOR,	exp text( getPlaceWithTiesForScore( getScoreForClient( getClientInPlace( itemNumber ) ) ) ), when( IS_PLAYER( itemNumber ) && !IS_PLACE_BLANK( itemNumber ) && !IS_SCORE_DEFAULT( itemNumber ) ) ) \
		WIDGET_TEXT( SUMMARY_SPACING, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),				SPEC_HUD_WIDTH, 								PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_LEFT,		UI_FONT_NORMAL,	TEXTSIZE_SMALL, 1 1 1 HUD_ALPHA,	exp text( itemNumber ), when( IS_PLACE_BLANK( itemNumber ) ) )
	
#define YOU_PLACE( itemNumber ) \
		WIDGET_TEXT( SUMMARY_SPACING, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),				SPEC_HUD_WIDTH,									PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_LEFT,		UI_FONT_BOLD,	TEXTSIZE_SMALL, SUMMARY_YOU_COLOR,	exp text( getPlaceWithTiesForScore( player( score ) ) ), 1 )

#define SUMMARY_PLAYERNAME( itemNumber ) \
		WIDGET_TEXT( SUMMARY_SPACING, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),				(SPEC_HUD_WIDTH-SUMMARY_PLACE_PLAYER_SPACE),	PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_LEFT,		UI_FONT_NORMAL, TEXTSIZE_SMALL, 1 1 1 HUD_ALPHA,	exp text( getClientName( getClientInPlace( itemNumber ) ) ), when( !IS_SCORE_DEFAULT( itemNumber ) ) )

#define YOU_PLAYERNAME( itemNumber ) \
		WIDGET_TEXT( SUMMARY_SPACING, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),				(SPEC_HUD_WIDTH-SUMMARY_PLACE_PLAYER_SPACE),	PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_LEFT,		UI_FONT_BOLD,	TEXTSIZE_SMALL, 1 1 1 HUD_ALPHA,	exp text( player( name ) ), when( player( place ) > 3 ) )

#define SUMMARY_SCORE( itemNumber ) \
		WIDGET_TEXT( (-SUMMARY_SPACING), (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),			SPEC_HUD_WIDTH,									PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_RIGHT,	UI_FONT_NORMAL,	TEXTSIZE_SMALL, 1 1 1 HUD_ALPHA,	exp text( getScoreForClient( getClientInPlace( itemNumber ) ) ), when( !IS_PLACE_BLANK( itemNumber ) && !IS_SCORE_DEFAULT( itemNumber ) ) ) \
	
#define YOU_SCORE( itemNumber ) \
		WIDGET_TEXT( (-SUMMARY_SPACING), (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(itemNumber-1)),			SPEC_HUD_WIDTH, 								PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_RIGHT,	UI_FONT_BOLD,	TEXTSIZE_SMALL, 1 1 1 HUD_ALPHA,	exp text( player( score ) ), when( player( place ) > 3 ) )
	
#define WAGER_STATUS_TEXT( textArg, visArg ) \
		WIDGET_TEXT( SUMMARY_SPACING, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*(4*SPLITSCREEN_MULTIPLIER)),	SPEC_HUD_WIDTH, 								PLAYER_INFO_ABBREV_HEIGHT,	ITEM_ALIGN_MIDDLE_LEFT,		UI_FONT_BOLD,	TEXTSIZE_SMALL, 1 1 1 HUD_ALPHA,	exp text( textArg ), visArg )

#define HUD_SCORE_TOP_THREE_SUMMARY( placeColText, scoreColText ) \
		WIDGET_TEXT_SHADOWED( 0, (SUMMARY_START_Y-(100*SPLITSCREEN_MULTIPLIER)), SPEC_HUD_WIDTH, (100*SPLITSCREEN_MULTIPLIER), ITEM_ALIGN_BOTTOM_LEFT, UI_FONT_BOLD, TEXTSIZE_DEFAULT, 1 1 1 HUD_ALPHA, exp text ( placeColText ), 1 ) \
		WIDGET_TEXT( 0, (SUMMARY_START_Y-(100*SPLITSCREEN_MULTIPLIER)), SPEC_HUD_WIDTH, (100*SPLITSCREEN_MULTIPLIER), ITEM_ALIGN_BOTTOM_RIGHT, UI_FONT_BOLD, TEXTSIZE_DEFAULT, 1 1 1 HUD_ALPHA, exp text ( scoreColText ), 1 ) \
		SUMMARY_PLAYERNAME( 1 ) \
		SUMMARY_PLAYERNAME( 2 ) \
		SUMMARY_PLAYERNAME( 3 ) \
		YOU_PLAYERNAME( 4 ) \
		SUMMARY_SCORE( 1 ) \
		SUMMARY_SCORE( 2 ) \
		SUMMARY_SCORE( 3 ) \
		YOU_SCORE( 4 )

#define HUD_SCORE_BACKGROUND( showTopBg, showBottomBg ) \
		WIDGET_BACKGROUND_SHADER( 0, (-45*SPLITSCREEN_MULTIPLIER), SPEC_HUD_WIDTH, (32*SPLITSCREEN_MULTIPLIER), 0 0 0 0.3, "white", 1 ) \
		itemDef \
		{ \
			style			WINDOW_STYLE_SHADER \
			type			ITEM_TYPE_IMAGE \
			rect			(1*SPLITSCREEN_MULTIPLIER) (-45*SPLITSCREEN_MULTIPLIER) (32*SPLITSCREEN_MULTIPLIER) (32*SPLITSCREEN_MULTIPLIER) WAGER_SUMMARY_ALIGN \
			exp				material( dvarString( "g_TeamIcon_Allies" ) ); \
			visible			1 \
			forecolor		1 1 1 1 \
			decoration \
		} \
		WIDGET_BACKGROUND_SHADER( (70*SPLITSCREEN_MULTIPLIER), (-45*SPLITSCREEN_MULTIPLIER), (55*SPLITSCREEN_MULTIPLIER), (13*SPLITSCREEN_MULTIPLIER), 0 0 0 0.3, "white", showTopBg ) \
		WIDGET_BACKGROUND_SHADER( (70*SPLITSCREEN_MULTIPLIER), (-28*SPLITSCREEN_MULTIPLIER), (55*SPLITSCREEN_MULTIPLIER), (13*SPLITSCREEN_MULTIPLIER), 0 0 0 0.3, "white", showBottomBg )

	
#define HUD_WAGER_FFA_SUMMARY( gametypeName, showScoreBar, statusTextArg ) \
		menuDef \
		{ \
			name			"scorebar_wager_"gametypeName \
			rect			BOTTOM_RECT_X BOTTOM_RECT_Y 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN	\
			exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) );									\
			fullScreen		0																							\
			visible 		1																							\
			visibilityBits	bits( !BIT_IN_KILLCAM !BIT_UI_ACTIVE !BIT_SPECTATING_CLIENT )								\
			WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+(1*SPLITSCREEN_MULTIPLIER)),								SPEC_HUD_WIDTH, (PLAYER_INFO_ABBREV_HEIGHT-(2*SPLITSCREEN_MULTIPLIER)), 0 0 0 HUD_ALPHA,			"white", when( !IS_PLACE_BLANK( 1 ) && !IS_PLAYER( 1 ) ) ) \
			WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+(1*SPLITSCREEN_MULTIPLIER)),								SPEC_HUD_WIDTH, (PLAYER_INFO_ABBREV_HEIGHT-(2*SPLITSCREEN_MULTIPLIER)), 0.03 0.3 0.03 HUD_ALPHA,	"white", when( !IS_PLACE_BLANK( 1 ) && IS_PLAYER( 1 ) ) ) \
			WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT+(1*SPLITSCREEN_MULTIPLIER)),	SPEC_HUD_WIDTH, (PLAYER_INFO_ABBREV_HEIGHT-(2*SPLITSCREEN_MULTIPLIER)), 0 0 0 HUD_ALPHA,			"white", when( !IS_PLACE_BLANK( 2 ) && !IS_PLAYER( 2 ) ) ) \
			WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT+(1*SPLITSCREEN_MULTIPLIER)),	SPEC_HUD_WIDTH, (PLAYER_INFO_ABBREV_HEIGHT-(2*SPLITSCREEN_MULTIPLIER)), 0.03 0.3 0.03 HUD_ALPHA,	"white", when( !IS_PLACE_BLANK( 2 ) && IS_PLAYER( 2 ) ) ) \
			WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*2+(1*SPLITSCREEN_MULTIPLIER)),	SPEC_HUD_WIDTH, (PLAYER_INFO_ABBREV_HEIGHT-(2*SPLITSCREEN_MULTIPLIER)), 0 0 0 HUD_ALPHA,			"white", when( !IS_PLACE_BLANK( 3 ) && !IS_PLAYER( 3 ) ) ) \
			WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*2+(1*SPLITSCREEN_MULTIPLIER)),	SPEC_HUD_WIDTH, (PLAYER_INFO_ABBREV_HEIGHT-(2*SPLITSCREEN_MULTIPLIER)), 0.03 0.3 0.03 HUD_ALPHA,	"white", when( !IS_PLACE_BLANK( 3 ) && IS_PLAYER( 3 ) ) ) \
			/* WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*3-SUMMARY_SEPARATOR_WIDTH/2), SPEC_HUD_WIDTH, SUMMARY_SEPARATOR_WIDTH, 0 0 0 0.8, "white", 1 ) */ \
			WIDGET_BACKGROUND_SHADER( 0, (SUMMARY_START_Y+PLAYER_INFO_ABBREV_HEIGHT*3+(1*SPLITSCREEN_MULTIPLIER)),	SPEC_HUD_WIDTH, (PLAYER_INFO_ABBREV_HEIGHT-(2*SPLITSCREEN_MULTIPLIER)), 0.3 0.03 0.03 HUD_ALPHA,	"white", when( player( place ) > 3 ) ) \
			WAGER_GAME_TIMER \
			HUD_SCORE_TOP_THREE_SUMMARY( statusTextArg, "" ) \
			SCORE_BAR( (70*SPLITSCREEN_MULTIPLIER), (-44*SPLITSCREEN_MULTIPLIER), (55*SPLITSCREEN_MULTIPLIER), (12*SPLITSCREEN_MULTIPLIER), "hud_scorebar_green", 1 1 1 0.5, showScoreBar ) \
		}

#define HUD_WAGER_FFA_SUMMARY_NO_PLACES( gametypeName, showScoreBar ) \
		menuDef \
		{ \
			name			"scorebar_wager_"gametypeName \
			rect			BOTTOM_RECT_X BOTTOM_RECT_Y 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN	\
			exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) );									\
			fullScreen		0																							\
			visible 		1																							\
			visibilityBits	bits( !BIT_IN_KILLCAM !BIT_UI_ACTIVE !BIT_SPECTATING_CLIENT )								\
			HUD_SCORE_BACKGROUND( 1, 1 )																				\
			WIDGET_TEXT( (35*SPLITSCREEN_MULTIPLIER), (-30*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), ITEM_ALIGN_LEFT, UI_FONT_NORMAL, TEXTSIZE_DEFAULT, 1 1 1 HUD_ALPHA, text "@CGAME_SB_SCORE", 1 ) \
			WIDGET_TEXT( (35*SPLITSCREEN_MULTIPLIER), (-15*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), ITEM_ALIGN_LEFT, UI_FONT_NORMAL, TEXTSIZE_DEFAULT, 1 1 1 HUD_ALPHA, text "@MP_PLACE", 1 ) \
			SCORE_BAR( (70*SPLITSCREEN_MULTIPLIER), (-45*SPLITSCREEN_MULTIPLIER), (55*SPLITSCREEN_MULTIPLIER), (13*SPLITSCREEN_MULTIPLIER), "hud_scorebar_green", 1 1 1 0.5, showScoreBar ) \
			WIDGET_TEXT( (75*SPLITSCREEN_MULTIPLIER), (-30*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), ITEM_ALIGN_LEFT, UI_FONT_NORMAL, TEXTSIZE_DEFAULT, 1 1 1 HUD_ALPHA, exp text( player( score ) ), 1 ) \
			WIDGET_TEXT( (75*SPLITSCREEN_MULTIPLIER), (-15*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), (20*SPLITSCREEN_MULTIPLIER), ITEM_ALIGN_LEFT, UI_FONT_NORMAL, TEXTSIZE_DEFAULT, 1 1 1 HUD_ALPHA, exp text( player( place ) ), when( !IS_PLAYER_SCORE_DEFAULT ) ) \
		}

#define HUD_WAGER_FFA_SUMMARY_CUSTOM( gametypeName, placeColText, scoreColText, showTopBgBar, showBottomBgBar ) \
		menuDef \
		{ \
			name "scorebar_wager_"gametypeName \
			rect			BOTTOM_RECT_X BOTTOM_RECT_Y 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN	\
			exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) );									\
			fullScreen		0																							\
			visible 		1																							\
			visibilityBits	bits( !BIT_IN_KILLCAM !BIT_UI_ACTIVE !BIT_SPECTATING_CLIENT )								\
			HUD_SCORE_TOP_THREE_SUMMARY( placeColText, scoreColText ) \
			HUD_SCORE_BACKGROUND( showTopBgBar, showBottomBgBar ) \
		}
	
#define BAR_START_X				(42*SPLITSCREEN_MULTIPLIER)
#define BAR_START_Y				(-42*SPLITSCREEN_MULTIPLIER)
#define BAR_HEIGHT_TOP			(20*SPLITSCREEN_MULTIPLIER)
#define BAR_HEIGHT_BOTTOM		(16*SPLITSCREEN_MULTIPLIER)
#define BG_OFFSET_X				(-15*SPLITSCREEN_MULTIPLIER)
#define BG_OFFSET_Y				(-5*SPLITSCREEN_MULTIPLIER)
#define BG_START_X				(BAR_START_X+BG_OFFSET_X)
#define BG_START_Y				(BAR_START_Y+BG_OFFSET_Y)
#define FACTION_ICON_WIDTH		(64*SPLITSCREEN_MULTIPLIER)
#define FACTION_ICON_HEIGHT		FACTION_ICON_WIDTH
#define FACTION_BG_WIDTH		(92*SPLITSCREEN_MULTIPLIER)
#define FACTION_BG_HEIGHT		FACTION_BG_WIDTH
#define	FACTION_BG_X_START		(BAR_START_X-(FACTION_BG_WIDTH/2))
#define	FACTION_BG_Y_START		(BAR_START_Y-(FACTION_BG_HEIGHT/2))
	
#define HUD_WAGER_FFA( nameArg, scoreTextArg, statusTextArg ) \
		menuDef \
		{ \
			name			nameArg \
			rect			BOTTOM_RECT_X BOTTOM_RECT_Y 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
			exp				rect Y( BOTTOM_RECT_Y - (ONLINEGAME * ONLINEGAME_OFFSET) ); \
			fullScreen		0 \
			visible 		1 \
			visibilityBits	bits( BIT_HUD_VISIBLE !BIT_IN_KILLCAM !BIT_UI_ACTIVE !BIT_SPECTATING_CLIENT HUD_VISIBILITY SHOULD_DISPLAY_SCOREBAR ) \
			\
			/* score background */ \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			BG_START_X BG_START_Y (187*SPLITSCREEN_MULTIPLIER) (46*SPLITSCREEN_MULTIPLIER) WAGER_SUMMARY_ALIGN \
				exp				material( "hud_frame_faction_fade" ); \
				forecolor		1 1 1 0.5 \
				visible 		1 \
				decoration \
			} \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			(BAR_START_X-(69*SPLITSCREEN_MULTIPLIER)) (BG_START_Y-(14*SPLITSCREEN_MULTIPLIER)) (240*SPLITSCREEN_MULTIPLIER) (59*SPLITSCREEN_MULTIPLIER) WAGER_SUMMARY_ALIGN \
				exp				material( "hud_frame_faction_lines" ); \
				forecolor		1 1 1 0.4 \
				visible 		1 \
				decoration \
			} \
			/* FACTION ICONS */ \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			FACTION_BG_X_START FACTION_BG_Y_START FACTION_BG_WIDTH FACTION_BG_HEIGHT WAGER_SUMMARY_ALIGN \
				exp				material( "hud_faction_back_light" ); \
				forecolor		1 1 1 0.25 \
				visible 		1 \
				decoration \
			} \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			FACTION_BG_X_START FACTION_BG_Y_START FACTION_BG_WIDTH FACTION_BG_HEIGHT WAGER_SUMMARY_ALIGN \
				exp				material( "hud_faction_backing" ); \
				forecolor		1 1 1 0.2 \
				visible 		1 \
				decoration \
			} \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			(FACTION_BG_X_START+(FACTION_BG_WIDTH/2)-FACTION_ICON_WIDTH/2) (FACTION_BG_Y_START+(FACTION_BG_HEIGHT/2)-FACTION_ICON_HEIGHT/2) FACTION_ICON_WIDTH FACTION_ICON_HEIGHT WAGER_SUMMARY_ALIGN \
				exp				material( "hud_icon_wager_first" ); \
				visible			when( player( place ) == 1 ); \
				forecolor		1 1 1 1 \
				decoration \
			} \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			(FACTION_BG_X_START+(FACTION_BG_WIDTH/2)-FACTION_ICON_WIDTH/2) (FACTION_BG_Y_START+(FACTION_BG_HEIGHT/2)-FACTION_ICON_HEIGHT/2) FACTION_ICON_WIDTH FACTION_ICON_HEIGHT WAGER_SUMMARY_ALIGN \
				exp				material( "hud_icon_wager_second" ); \
				visible			when( player( place ) == 2 ); \
				forecolor		1 1 1 1 \
				decoration \
			} \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			(FACTION_BG_X_START+(FACTION_BG_WIDTH/2)-FACTION_ICON_WIDTH/2) (FACTION_BG_Y_START+(FACTION_BG_HEIGHT/2)-FACTION_ICON_HEIGHT/2) FACTION_ICON_WIDTH FACTION_ICON_HEIGHT WAGER_SUMMARY_ALIGN \
				exp				material( "hud_icon_wager_third" ); \
				visible			when( player( place ) == 3 ); \
				forecolor		1 1 1 1 \
				decoration \
			} \
			itemDef \
			{ \
				style			WINDOW_STYLE_SHADER \
				type			ITEM_TYPE_IMAGE \
				rect			(FACTION_BG_X_START+(FACTION_BG_WIDTH/2)-FACTION_ICON_WIDTH/2) (FACTION_BG_Y_START+(FACTION_BG_HEIGHT/2)-FACTION_ICON_HEIGHT/2) FACTION_ICON_WIDTH FACTION_ICON_HEIGHT WAGER_SUMMARY_ALIGN \
				exp				material( "hud_icon_wager_fourth" ); \
				visible			when( player( place ) > 3 ); \
				forecolor		1 1 1 1 \
				decoration \
			} \
			WIDGET_TEXT( (FACTION_BG_X_START+(FACTION_BG_WIDTH/2)-(FACTION_ICON_WIDTH/2)-(0.5*SPLITSCREEN_MULTIPLIER)), (FACTION_BG_Y_START+(FACTION_BG_HEIGHT/2)-(FACTION_ICON_HEIGHT/2)-(0.5*SPLITSCREEN_MULTIPLIER)), FACTION_ICON_WIDTH, FACTION_ICON_HEIGHT, ITEM_ALIGN_MIDDLE_CENTER, UI_FONT_BIG, TEXTSIZE_LARGEST, 1 1 1 0.3, exp text( player( place ) ), when( player( place ) > 3 ); ) \
			WIDGET_TEXT_SHADOWED( (BAR_START_X+FACTION_BG_WIDTH/2), (-42*SPLITSCREEN_MULTIPLIER), (1*SPLITSCREEN_MULTIPLIER), BAR_HEIGHT_TOP,		ITEM_ALIGN_MIDDLE_LEFT, UI_FONT_EXTRABIG, TEXTSIZE_LARGE, 1 1 1 HUD_ALPHA, scoreTextArg, 1 ) \
			WIDGET_TEXT_SHADOWED( (BAR_START_X+FACTION_BG_WIDTH/2), (-21*SPLITSCREEN_MULTIPLIER), (1*SPLITSCREEN_MULTIPLIER), BAR_HEIGHT_BOTTOM,	ITEM_ALIGN_MIDDLE_LEFT, UI_FONT_EXTRABIG, TEXTSIZE_LARGE, 1 1 1 HUD_ALPHA, statusTextArg, 1 ) \
		}