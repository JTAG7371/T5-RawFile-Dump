
#undef MODEL_HORIZ_ALIGN	
#define MODEL_HORIZ_ALIGN	HORIZONTAL_ALIGN_CENTER
#ifdef CONSOLE
#undef MODEL_START_X	
#define MODEL_START_X		-55
#else
#undef MODEL_START_X	
#define MODEL_START_X		-70
#endif
#undef MODEL_W	
#define MODEL_W				120

#undef NEW_FRAME_DEFAULT_HEIGHT
#define NEW_FRAME_DEFAULT_HEIGHT 377

#undef CAC_FACTION_CYCLE_LEFT	
#define CAC_FACTION_CYCLE_LEFT( first, second, third, fourth, fifth, sixth, seventh, eighth ) \ 
	if ( dvarString( ui_faction ) == first ) { execnow set ui_faction eighth; } \
	elseif ( dvarString( ui_faction ) == second ) { execnow set ui_faction first; } \
	elseif ( dvarString( ui_faction ) == third ) { execnow set ui_faction second; } \
	elseif ( dvarString( ui_faction ) == fourth ) { execnow set ui_faction third; } \
	elseif ( dvarString( ui_faction ) == fifth ) { execnow set ui_faction fourth; } \
	elseif ( dvarString( ui_faction ) == sixth ) { execnow set ui_faction fifth; } \
	elseif ( dvarString( ui_faction ) == seventh ) { execnow set ui_faction sixth; } \
	elseif ( dvarString( ui_faction ) == eighth ) { execnow set ui_faction seventh; } 
	

#undef CAC_FACTION_CYCLE_RIGHT	
#define CAC_FACTION_CYCLE_RIGHT( first, second, third, fourth, fifth, sixth, seventh, eighth ) \ 
	if ( dvarString( ui_faction ) == first ) { execnow set ui_faction second; } \
	elseif ( dvarString( ui_faction ) == second ) { execnow set ui_faction third; } \
	elseif ( dvarString( ui_faction ) == third ) { execnow set ui_faction fourth; } \
	elseif ( dvarString( ui_faction ) == fourth ) { execnow set ui_faction fifth; } \
	elseif ( dvarString( ui_faction ) == fifth ) { execnow set ui_faction sixth; } \
	elseif ( dvarString( ui_faction ) == sixth ) { execnow set ui_faction seventh; } \
	elseif ( dvarString( ui_faction ) == seventh ) { execnow set ui_faction eighth; } \
	elseif ( dvarString( ui_faction ) == eighth ) { execnow set ui_faction first; } 

#ifdef PUBLIC_BETA
#define FIRST_FACTION   "usa_cia"
#define SECOND_FACTION  "rus_spet"
#define THIRD_FACTION   "usa_ciawin"
#define FOURTH_FACTION  "rus_spetwin"
#define FIFTH_FACTION   "usa_cia"
#define SIXTH_FACTION   "rus_spet"
#define SEVENTH_FACTION "usa_ciawin"
#define EIGHTH_FACTION  "rus_spetwin"
#else
#define FIRST_FACTION   "usa_sog"
#define SECOND_FACTION  "vtn_nva"
#define THIRD_FACTION   "usa_cia"
#define FOURTH_FACTION  "rus_spet"
#define FIFTH_FACTION   "usa_ciawin"
#define SIXTH_FACTION   "rus_spetwin"
#define SEVENTH_FACTION "cub_rebels"
#define EIGHTH_FACTION  "cub_tropas"
#endif


#ifdef CONSOLE
#undef FACTION_LEFT_SHOULDER	
#define FACTION_LEFT_SHOULDER \
	execkeyint	BUTTON_LSHLDR { CAC_FACTION_CYCLE_LEFT( FIRST_FACTION, SECOND_FACTION, THIRD_FACTION, FOURTH_FACTION, FIFTH_FACTION, SIXTH_FACTION, SEVENTH_FACTION, EIGHTH_FACTION ) }

#undef FACTION_RIGHT_SHOULDER	
#define FACTION_RIGHT_SHOULDER \
	execkeyint	BUTTON_RSHLDR { CAC_FACTION_CYCLE_RIGHT( FIRST_FACTION, SECOND_FACTION, THIRD_FACTION, FOURTH_FACTION, FIFTH_FACTION, SIXTH_FACTION, SEVENTH_FACTION, EIGHTH_FACTION ) }
#else
#undef FACTION_LEFT_SHOULDER	
#define FACTION_LEFT_SHOULDER \
	mouseEnter 		{ play CHOICE_FOCUS_SOUND; }\
	action { play CHOICE_FOCUS_SOUND; execnow ui_animate cac_main LB Flash 0; CAC_FACTION_CYCLE_LEFT( FIRST_FACTION, SECOND_FACTION, THIRD_FACTION, FOURTH_FACTION, FIFTH_FACTION, SIXTH_FACTION, SEVENTH_FACTION, EIGHTH_FACTION ) }

#undef FACTION_RIGHT_SHOULDER	
#define FACTION_RIGHT_SHOULDER \
	mouseEnter 		{ play CHOICE_FOCUS_SOUND; }\
	action { play CHOICE_FOCUS_SOUND; execnow ui_animate cac_main RB Flash 0; CAC_FACTION_CYCLE_RIGHT( FIRST_FACTION, SECOND_FACTION, THIRD_FACTION, FOURTH_FACTION, FIFTH_FACTION, SIXTH_FACTION, SEVENTH_FACTION, EIGHTH_FACTION ) }
#endif
	
#ifdef PS3
#define CAC_FACTION_NAME_TEXTFONT		UI_FONT_SMALL
#else //#ifdef PS3
#define CAC_FACTION_NAME_TEXTFONT		UI_FONT_NORMAL
#endif //#ifdef PS3

#undef CAC_FACTION_NAME_AND_IMAGE	
#ifdef CONSOLE
#define CAC_FACTION_NAME_AND_IMAGE( textArg, imageArg, visArg ) \
	itemDef \
	{ \
		type			ITEM_TYPE_BUTTON \
		rect			(MODEL_START_X+(MODEL_W/2)) ( NEW_FRAME_DEFAULT_HEIGHT / 2 + 18 ) 0 0 MODEL_HORIZ_ALIGN VERTICAL_ALIGN_CENTER \
		origin			0 0 \
		exp				text ( textArg ) \
		textfont		CAC_FACTION_NAME_TEXTFONT \
		textscale		TEXTSIZE_DEFAULT \
		textalign		ITEM_ALIGN_CENTER \
		visible			visArg \
		FACTION_LEFT_SHOULDER \
		FACTION_RIGHT_SHOULDER \
		decoration \
	} \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		type			ITEM_TYPE_IMAGE \
		rect			(MODEL_START_X) ( -NEW_FRAME_DEFAULT_HEIGHT / 2 + 55 ) (MODEL_W*1.75) (MODEL_W*1.75) MODEL_HORIZ_ALIGN VERTICAL_ALIGN_CENTER \
		forecolor		1 1 1 0.05 \
		exp				material( imageArg ); \
		visible			visArg \
		decoration \
	}

#else // #ifdef CONSOLE
	#define CAC_FACTION_NAME_AND_IMAGE( textArg, imageArg, visArg ) \
		itemDef \
		{ \
			style			WINDOW_STYLE_SHADER \
			type			ITEM_TYPE_IMAGE \
			rect			(MODEL_START_X-83) ( -NEW_FRAME_DEFAULT_HEIGHT / 2 + 55 ) (MODEL_W*1.35) (MODEL_W*1.35) MODEL_HORIZ_ALIGN VERTICAL_ALIGN_CENTER \
			origin 			0 0 \
			forecolor		1 1 1 0.2 \
			exp				material( imageArg ); \
			border			0 \
			bordersize		0 \
			bordercolor		0 0 0 0 \
			visible			visArg \
			decoration \
		}
#endif // #ifdef CONSOLE

#ifdef CONSOLE
	#undef CAC_FACTION_MODEL 
	#define CAC_FACTION_MODEL \
		/* faction name */ \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_MARINE_SHORT" ), "menu_mp_lobby_sog", when( dvarString( ui_faction ) == "usa_sog" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_NVA_SHORT" ), "menu_mp_lobby_nva", when( dvarString( ui_faction ) == "vtn_nva" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_SPECOPS_URBAN_SHORT" ), "menu_mp_lobby_ops", when( dvarString( ui_faction ) == "usa_cia" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_RUSSIAN_URBAN_SHORT" ), "menu_mp_lobby_spets", when( dvarString( ui_faction ) == "rus_spet" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_SPECOPS_WINTER_SHORT" ), "menu_mp_lobby_ops", when( dvarString( ui_faction ) == "usa_ciawin" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_RUSSIAN_WINTER_SHORT" ), "menu_mp_lobby_spets", when( dvarString( ui_faction ) == "rus_spetwin" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_REBELS_SHORT" ), "menu_mp_lobby_op40", when( dvarString( ui_faction ) == "cub_rebels" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( GetcacFactionNameWithButtons( "MPUI_TROPAS_SHORT" ), "menu_mp_lobby_tropas", when( dvarString( ui_faction ) == "cub_tropas" ); ) \
		/* player model */  \
		ADD_PLAYER_VIEWER
#else // #ifdef CONSOLE
	#undef CAC_FACTION_MODEL 
	#define CAC_FACTION_MODEL \
		/* faction name */ \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_MARINE_SHORT", "menu_mp_lobby_sog", when( dvarString( ui_faction ) == "usa_sog" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_NVA_SHORT", "menu_mp_lobby_nva", when( dvarString( ui_faction ) == "vtn_nva" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_SPECOPS_URBAN_SHORT", "menu_mp_lobby_ops", when( dvarString( ui_faction ) == "usa_cia" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_RUSSIAN_URBAN_SHORT", "menu_mp_lobby_spets", when( dvarString( ui_faction ) == "rus_spet" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_SPECOPS_WINTER_SHORT", "menu_mp_lobby_ops", when( dvarString( ui_faction ) == "usa_ciawin" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_RUSSIAN_WINTER_SHORT", "menu_mp_lobby_spets", when( dvarString( ui_faction ) == "rus_spetwin" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_REBELS_SHORT", "menu_mp_lobby_op40", when( dvarString( ui_faction ) == "cub_rebels" ); ) \
		CAC_FACTION_NAME_AND_IMAGE( "@MPUI_TROPAS_SHORT", "menu_mp_lobby_tropas", when( dvarString( ui_faction ) == "cub_tropas" ); ) \	
		FRAME_CHOICE_DVARSTRINGLIST_CENTERED_VIS( "cac_faction_button", 0 ( NEW_FRAME_DEFAULT_HEIGHT / 2 + 4 ) 94 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0, ui_faction,	\
			{ "@MPUI_MARINE_SHORT" usa_sog "@MPUI_NVA_SHORT" vtn_nva "@MPUI_SPECOPS_URBAN_SHORT" usa_cia "@MPUI_RUSSIAN_URBAN_SHORT" rus_spet					\
			"@MPUI_SPECOPS_WINTER_SHORT" usa_ciawin "@MPUI_RUSSIAN_WINTER_SHORT" rus_spetwin "@MPUI_REBELS_SHORT" cub_rebels									\
			 "@MPUI_TROPAS_SHORT" cub_tropas }, execnow ui_animate cac_main RB Flash 0;, 1 )																	\
		/* player model */  \
		ADD_PLAYER_VIEWER
#endif // #else // #ifdef CONSOLE

#ifdef PC
	#undef ARROW_X
	#undef ARROW_Y
	#undef ARROW_W
	#undef ARROW_H
	#undef ARROW_SPREAD
	#define ARROW_SPREAD 10
	#define ARROW_W 32
	#define ARROW_H 32
	#define ARROW_X (-ARROW_W-(ARROW_SPREAD/2))
	#define ARROW_Y 155
	
	
	#undef CAC_ROTATE_ARROWS
	#define CAC_ROTATE_ARROWS																											\
		itemDef																															\
		{																																\
			name			"rotate_left_arrow"																							\
			type			ITEM_TYPE_BUTTON																							\
			style			WINDOW_STYLE_SHADER																							\
			rect			ARROW_X ARROW_Y ARROW_W ARROW_H HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER								\
			origin			0 0																											\
			background		"ui_arrow_rotation_left"																								\
			forecolor		1 1 1 1																										\
			visible			when( dvarString( ui_inside_popup ) != equipment_head )														\
			mouseEnter { play CHOICE_FOCUS_SOUND; setcolor forecolor 0.98 0.83 0.25 1 ; }							\
			mouseexit { setcolor forecolor 1 1 1 1 ; }														\	
			action			{ play CHOICE_FOCUS_SOUND; execNow viewerRotateRightRepeatEnabled; }											\
		}																																\
		itemDef																															\
		{																																\
			name			"rotate_right_arrow"																						\
			type			ITEM_TYPE_BUTTON																							\
			style			WINDOW_STYLE_SHADER																							\
			rect			(ARROW_X+ARROW_SPREAD+ARROW_W) ARROW_Y ARROW_W ARROW_H HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER				\
			origin			0 0																											\
			background		"ui_arrow_rotation_right"																							\
			forecolor		1 1 1 1																										\
			visible			when( dvarString( ui_inside_popup ) != equipment_head )														\
			mouseEnter { play CHOICE_FOCUS_SOUND; setcolor forecolor 0.98 0.83 0.25 1 ; }							\
			mouseexit { setcolor forecolor 1 1 1 1 ; }														\	
			action			{ play CHOICE_FOCUS_SOUND; execNow viewerRotateLeftRepeatEnabled; }										\
		}
#endif // #ifdef PC