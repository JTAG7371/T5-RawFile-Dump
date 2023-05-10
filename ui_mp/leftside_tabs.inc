#ifndef OPTIONS_TAB
#define OPTIONS_TAB
		
#define OPTIONS_HEIGHT				NEW_FRAME_DEFAULT_HEIGHT
#define OPTIONS_WIDTH				( OPTIONS_HEIGHT * FRAME_ASPECT_RATIO )

#define CHOICE_TAB_TEXTSIZE			TEXTSIZE_DEFAULT
#define TAB_1_TEXT					( locString( "@MENU_SETTINGS_CAPS" ) )
#define TAB_2_TEXT					( locString( "@MENU_CONTROLS_CAPS" ) )

#define TAB_BG_PAD					5
#define TAB_1_WIDTH					( getTextWidth( TAB_1_TEXT, CHOICE_TEXTFONT, TEXTSIZE_SMALL ) + (TAB_BG_PAD*2) )
#define TAB_2_WIDTH					( getTextWidth( TAB_2_TEXT, CHOICE_TEXTFONT, TEXTSIZE_SMALL ) + (TAB_BG_PAD*2) )
#define TAB_HEIGHT					15

#define OPTIONS_TAB_1_X		4
#define OPTIONS_TAB_2_X		( OPTIONS_TAB_1_X + TAB_1_WIDTH )

#define OPTIONS_TAB_Y			( ( -OPTIONS_HEIGHT / 2 ) + NEW_FRAME_HEADER_HEIGHT - TAB_HEIGHT )

#define OP_TAB_SETTINGS		1
#define OP_TAB_CONTROLS		2

#define OPTIONS_TAB_OPEN( menuName )	\
	LOCAL_CLOSE_ALL						\
	close options_new_pc;				\
	close options_controls_new_pc;		\
	open menuName;


#define OPTIONS_TAB_HEADERS( selectedTabIndex )																					\
		PREPROC_TEXT_DRAW_ADV_VIS_EX(	( -OPTIONS_WIDTH / 2 + OPTIONS_TAB_1_X ),												\
										OPTIONS_TAB_Y,																			\
										TAB_1_WIDTH,																			\
										TAB_HEIGHT,																				\
										HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_CENTER,											\
										TAB_1_TEXT, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_CENTER,								\
										NEW_FRAME_GRAY_TEXT_COLOR,  when( selectedTabIndex != OP_TAB_SETTINGS ), TAB_MOUSEOVER_HIGHLIGHT; )			\
		PREPROC_TEXT_DRAW_ADV_VIS_EX(	( -OPTIONS_WIDTH / 2 + OPTIONS_TAB_1_X ),												\
										OPTIONS_TAB_Y,																			\
										TAB_1_WIDTH,																			\
										TAB_HEIGHT,																				\
										HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_CENTER,											\
										TAB_1_TEXT, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_CENTER,								\
										NEW_FRAME_ORANGE_RGB 1,  when( selectedTabIndex == OP_TAB_SETTINGS ), ; )				\
		PREPROC_TEXT_DRAW_ADV_VIS_EX(	( -OPTIONS_WIDTH / 2 + OPTIONS_TAB_2_X ),												\
										OPTIONS_TAB_Y,																			\
										TAB_2_WIDTH,																			\
										TAB_HEIGHT,																				\
										HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_CENTER,											\
										TAB_2_TEXT, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_CENTER,								\
										NEW_FRAME_GRAY_TEXT_COLOR,  when( selectedTabIndex != OP_TAB_CONTROLS ), TAB_MOUSEOVER_HIGHLIGHT; )			\
		PREPROC_TEXT_DRAW_ADV_VIS_EX(	( -OPTIONS_WIDTH / 2 + OPTIONS_TAB_2_X ),												\
										OPTIONS_TAB_Y,																			\
										TAB_2_WIDTH,																			\
										TAB_HEIGHT,																				\
										HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_CENTER,											\
										TAB_2_TEXT, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_CENTER,								\
										NEW_FRAME_ORANGE_RGB 1,  when( selectedTabIndex == OP_TAB_CONTROLS ), ; )				\

#define OPTIONS_TAB_BUTTONS																		\
		/* Tab 1 */																				\
		TAB_ACTION_BUTTON_ADV( 			( -OPTIONS_WIDTH / 2 + OPTIONS_TAB_1_X ),				\
										OPTIONS_TAB_Y,											\
										TAB_1_WIDTH,											\
										TAB_HEIGHT,												\
										HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_CENTER,			\
										OPTIONS_TAB_OPEN( options_new_pc ), 1, ; )				\
		/* Tab 2 */																				\
		TAB_ACTION_BUTTON_ADV( 			( -OPTIONS_WIDTH / 2 + OPTIONS_TAB_2_X ),				\
										OPTIONS_TAB_Y,											\
										TAB_2_WIDTH,											\
										TAB_HEIGHT,												\
										HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_CENTER,			\
										OPTIONS_TAB_OPEN( options_controls_new_pc ), 1, ; )		\

#define OPTIONS_TAB_BG( px, pw, selected )																		\
		itemDef																									\
		{																										\
			style           WINDOW_STYLE_SHADER_FRAMED															\
			frame           16 0.2 FRAME_OPEN_BOTTOM															\
			rect            0 OPTIONS_TAB_Y 0 TAB_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER			\
			exp				rect X( ( -OPTIONS_WIDTH / 2 + px ) )												\
			exp				rect W(	pw )																		\
			background      "menu_mp_tab_frame_inner"															\
			forecolor       0.5 0.5 0.5 0.5																		\
			visible         when( selected && (IsInGame() || dvarBool( ui_multiplayer )) )						\
			decoration																							\
		}																										\
		itemDef																									\
		{																										\
			style           WINDOW_STYLE_SHADER_FRAMED															\
			frame           16 0.2 FRAME_OPEN_BOTTOM															\
			rect            0 OPTIONS_TAB_Y 0 TAB_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER			\
			exp				rect X( ( -OPTIONS_WIDTH / 2 + px ) )												\
			exp				rect W(	pw )																		\
			background      "menu_mp_tab_frame_inner"															\
			forecolor       1 1 1 1																				\
			visible         when( !selected && (IsInGame() || dvarBool( ui_multiplayer )) )						\
			decoration																							\
		}																										\
		itemDef																									\
		{																										\
			style           WINDOW_STYLE_SHADER_FRAMED															\
			frame           16 0.2 FRAME_OPEN_BOTTOM															\
			rect            0 OPTIONS_TAB_Y 0 TAB_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER			\
			exp				rect X( ( -OPTIONS_WIDTH / 2 + px ) )												\
			exp				rect W(	pw )																		\
			background      "menu_mp_tab_frame_inner"															\
			forecolor       0.472 0.707 1 0.75																	\
			visible         when( selected && ( dvarBool( zombietron ) || ( !IsInGame() && !dvarBool( ui_multiplayer ) ) ) )						\
			decoration																							\
		}																										\
		itemDef																									\
		{																										\
			style           WINDOW_STYLE_SHADER_FRAMED															\
			frame           16 0.2 FRAME_OPEN_BOTTOM															\
			rect            0 OPTIONS_TAB_Y 0 TAB_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER			\
			exp				rect X( ( -OPTIONS_WIDTH / 2 + px ) )												\
			exp				rect W(	pw )																		\
			background      "menu_mp_tab_frame_inner"															\
			forecolor       .125 .1875 .265 1																	\
			visible         when( !selected && ( dvarBool( zombietron ) || ( !IsInGame() && !dvarBool( ui_multiplayer ) ) ) )						\
			decoration																							\
		}

#define OPTIONS_TABS( selectedTabIndex )														\
	OPTIONS_TAB_BG( OPTIONS_TAB_1_X, TAB_1_WIDTH, ( selectedTabIndex == OP_TAB_SETTINGS ) )		\
	OPTIONS_TAB_BG( OPTIONS_TAB_2_X, TAB_2_WIDTH, ( selectedTabIndex == OP_TAB_CONTROLS ) )		\
	OPTIONS_TAB_HEADERS( selectedTabIndex )														\
	OPTIONS_TAB_BUTTONS

#endif // #ifndef OPTIONS_TAB