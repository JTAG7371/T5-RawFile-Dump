
#ifndef CHOICE_TEXTFONT
	#define CHOICE_TEXTFONT UI_FONT_NORMAL
#endif

#define HORIZ_RATIO		dvarfloat( "safeareatweakable_horizontal" )
#define VERT_RATIO		dvarfloat( "safeareatweakable_vertical" )

#define SAFE_AREA_BG_RECT( visArg )																\
		PREPROC_SHADER_DRAW_ADV_VIS_EX( ( ( 640 - ( 640 * HORIZ_RATIO ) ) / 2 ),				\
										( ( 480 - ( 480 * VERT_RATIO ) ) / 2 ),					\
										( 640 * HORIZ_RATIO ),									\
										( 480 * VERT_RATIO ),									\
										HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN,	\
										"white", 0.4 0.4 0.4 0.4, visArg, ; )	

#define SAFE_AREA_ARROWS( visArg )																							\
		PREPROC_TEXT_DRAW(	0 130 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0,									\
							"@PLATFORM_SAFE_AREA_ADJUST_HORIZONTAL", TEXTSIZE_DEFAULT,										\
							0, 0, ITEM_ALIGN_TOP_CENTER, 1 1 1 1 )															\
		PREPROC_TEXT_DRAW(	0 150 1 1 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0,									\
							"@PLATFORM_SAFE_AREA_ADJUST_VERTICAL", TEXTSIZE_DEFAULT,										\
							0, 0, ITEM_ALIGN_TOP_CENTER, 1 1 1 1 )															\
		/* left arrow */																									\
		PREPROC_SHADER_DRAW_VIS_EX(	0 0 64 64 HORIZONTAL_ALIGN_USER_LEFT VERTICAL_ALIGN_USER_CENTER REF_CENTER_LEFT,		\
									"menu_safearea_arrow", 1 1 1 1, 1, rotation 0 )											\
		/* top arrow */																										\
		PREPROC_SHADER_DRAW_VIS_EX(	0 0 64 64 HORIZONTAL_ALIGN_USER_CENTER VERTICAL_ALIGN_USER_TOP REF_TOP_CENTER,			\
									"menu_safearea_arrow", 1 1 1 1, 1, rotation 90 )										\
		/* right arrow */																									\
		PREPROC_SHADER_DRAW_VIS_EX(	0 0 64 64 HORIZONTAL_ALIGN_USER_RIGHT VERTICAL_ALIGN_USER_CENTER REF_CENTER_RIGHT,		\
									"menu_safearea_arrow", 1 1 1 1, 1, rotation 180 )										\
		/* bottom arrow */																									\
		PREPROC_SHADER_DRAW_VIS_EX(	0 0 64 64 HORIZONTAL_ALIGN_USER_CENTER VERTICAL_ALIGN_USER_BOTTOM REF_BOTTOM_CENTER,	\
									"menu_safearea_arrow", 1 1 1 1, 1, rotation 270 )										\

	
#define SAFE_AREA_DPAD_CONTROLS																							\					
		execKeyInt DPAD_UP																								\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_vertical ( dvarfloat( "safeareatweakable_vertical" ) + float(0.005) );		\
			execNow setupviewport;																						\
		}																												\
		execKeyInt DPAD_DOWN																							\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_vertical ( dvarfloat( "safeareatweakable_vertical" ) - float(0.005) );		\
			execNow setupviewport;																						\
		}																												\
		execKeyInt DPAD_LEFT																							\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_horizontal ( dvarfloat( "safeareatweakable_horizontal" ) - float(0.005) );	\
			execNow setupviewport;																						\
		}																												\
		execKeyInt DPAD_RIGHT																							\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_horizontal ( dvarfloat( "safeareatweakable_horizontal" ) + float(0.005) );	\
			execNow setupviewport;																						\
		}																												\
		execKeyInt APAD_UP																								\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_vertical ( dvarfloat( "safeareatweakable_vertical" ) + float(0.005) );		\
			execNow setupviewport;																						\
		}																												\
		execKeyInt APAD_DOWN																							\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_vertical ( dvarfloat( "safeareatweakable_vertical" ) - float(0.005) );		\
			execNow setupviewport;																						\
		}																												\
		execKeyInt APAD_LEFT																							\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_horizontal ( dvarfloat( "safeareatweakable_horizontal" ) - float(0.005) );	\
			execNow setupviewport;																						\
		}																												\
		execKeyInt APAD_RIGHT																							\
		{																												\
			play "uin_navigation_over";																					\
			execNow set safeAreaTweakable_horizontal ( dvarfloat( "safeareatweakable_horizontal" ) + float(0.005) );	\
			execNow setupviewport;																						\
		}

