#define CHOICE_SIZE_X			150

// safe area
#ifdef PC
	#define CHOICE_X_START			48
	#define CHOICE_Y_START			56
#else
	#define CHOICE_X_START			48
	#define CHOICE_Y_START			34
#endif

#define STYLE2_NOPOSITION
#include "ui_mp/menustyle.inc"

#undef CHOICE_TEXTSIZE
#define CHOICE_TEXTSIZE 	TEXTSIZE_SMALL
#define	CHOICE_TEXTALIGN	ITEM_ALIGN_MIDDLE_RIGHT //ITEM_ALIGN_MIDDLE_LEFT
#define CHOICE_TEXT_OFFSET_X	(-(4+CHOICE_SIZE_Y)) //22
#define CHOICE_Y_COUNT			14
#define CHOICE_SIDENAV			1

#ifndef A_BUTTON_OFFSET_X
#define A_BUTTON_OFFSET_X		(-4)//(CHOICE_SIZE_X-20)

#define CHOICE_X_SPACING		280
#undef CHOICE_HORIZONTAL_ALIGN

#define CHOICE_DVAR_OFFSET_X	(CHOICE_SIZE_X+20)
#define CHOICE_DVAR_TEXTALIGN	ITEM_ALIGN_MIDDLE_LEFT
#define CHOICE_DVAR_WIDTH_OFFSET	120
#define CHOICE_ACTION_SOUND		"uin_mouse_click_t"

#include "ui/choices_setup_common.menu"

#define POPUP_ITEM_HEIGHT	15
#define	POPUP_ITEM_WIDTH	110
#define POPUP_ITEM_OFFSET	150

#ifndef PC
	#define XBOX_LIVE_PRIVATE ( dvarint( xblive_privatematch ) == 1 && dvarint( systemlink ) == 0 )
#else
	#define XBOX_LIVE_PRIVATE 1
#endif

// Defining the Difficulty Pop Up alone, because we need to send in the difficulty parameter
#define PREPROC_DIFFICULTY_DVAR_POPUP( pp_itemIndex, pp_name, pp_items, pp_dvar, pp_string1, pp_string2, pp_string3, pp_string4, pp_setdvar1, pp_setdvar2, pp_setdvar3, pp_setdvar4, pp_xOffset ) \
menuDef	{ \
	name			GAME_OPTIONS_MENU_NAME"_"pp_name \
	visible			1 \
	fullscreen		0 \
	rect			0 0 640 480 0 0 \
	focusColor		COLOR_FOCUSED \
	style			WINDOW_STYLE_FILLED popup \
	onOpen { \
		focusFirst; \
		setfocusbydvar pp_dvar; \
	} \
	onESC { \
		play CHOICE_FOCUS_SOUND; \
		close GAME_OPTIONS_MENU_NAME"_"pp_name; \
	} \
	BACK_BUTTON_CLOSE \
	itemDef { \
		style			WINDOW_STYLE_SHADER \
		rect			(CHOICE_X(pp_itemIndex)+pp_xOffset) (CHOICE_Y(pp_itemIndex)-2) 110 (10+(POPUP_ITEM_HEIGHT*pp_items)) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
		forecolor		0.2 0.2 0.22 1 \
		background		"white" \
		border			1 \
		bordersize		2 \
		bordercolor		0.4 0.4 0.42 1 \
		visible			1 decoration \
	}	\
	PREPROC_DVAR_POPUP_CHOICE_EX( 1, setdvar pp_dvar pp_setdvar1 exec difficultyEasy, (CHOICE_X( pp_itemIndex )+pp_xOffset), (CHOICE_Y( pp_itemIndex )+(POPUP_ITEM_HEIGHT*0)), pp_string1, ( pp_string1 != "" ), dvartest pp_dvar focusdvar { pp_setdvar1 } ) \
	PREPROC_DVAR_POPUP_CHOICE_EX( 2, setdvar pp_dvar pp_setdvar2 exec difficultyMedium, (CHOICE_X( pp_itemIndex )+pp_xOffset), (CHOICE_Y( pp_itemIndex )+(POPUP_ITEM_HEIGHT*1)), pp_string2, ( pp_string2 != "" ), dvartest pp_dvar focusdvar { pp_setdvar2 } ) \
	PREPROC_DVAR_POPUP_CHOICE_EX( 3, setdvar pp_dvar pp_setdvar3 exec difficultyhard, (CHOICE_X( pp_itemIndex )+pp_xOffset), (CHOICE_Y( pp_itemIndex )+(POPUP_ITEM_HEIGHT*2)), pp_string3, ( pp_string3 != "" ), dvartest pp_dvar focusdvar { pp_setdvar3 } ) \
	PREPROC_DVAR_POPUP_CHOICE_EX( 4, setdvar pp_dvar pp_setdvar4 exec difficultyfu, (CHOICE_X( pp_itemIndex )+pp_xOffset), (CHOICE_Y( pp_itemIndex )+(POPUP_ITEM_HEIGHT*3)), pp_string4, ( pp_string4 != "" ), dvartest pp_dvar focusdvar { pp_setdvar4 } ) \
}

// Defining Main game Options Menu
menuDef {
	name			GAME_OPTIONS_MENU_NAME	
	fullscreen		1
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_FILLED
#ifndef INGAME_MENUS
	soundloop 		MENU_MUSIC
#endif // #ifndef INGAME_MENUS
	border			0
	onOpen			
	{ 
		focusFirst; 
	}
	onEsc			
	{ 
		close GAME_OPTIONS_MENU_NAME; 
	}
	
//	execkeyInt BUTTON_Y{ play CHOICE_FOCUS_SOUND; execnow "exec "GAMESETUP_CFG; UPDATE_VALUES UPDATE_VALUES2 }

#ifdef INGAME_MENUS
	itemDef
	{
		style			WINDOW_STYLE_FILLED
		rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
		backcolor		0 0 0 1
		visible			1
		decoration
	}
#else
	#include "ui/blurredbg.inc"
	#include "ui/overlaybg.inc"
	OVERLAY_BACKGROUND
#endif // #ifdef INGAME_MENUS

	CHOICE_MENU_TITLE( "@MENU_GAME_RULES_CAPS" )

	// -----------------------------------------
	#ifdef PC
		#define BACK_OPEN	;
	#endif
	#include "ui/navcontrols.inc"
	// -----------------------------------------
	
	#undef TEXTSIZE_TITLE
	#define TEXTSIZE_TITLE TEXTSIZE_DEFAULT
	
	#define CHOICE_LEFTNAV( itemIndex, leftfocus ) \
		name "sidenav_button_"itemIndex \
		execkeyint DPAD_LEFT { setfocus "sidenav_button_"leftfocus; } \
		execkeyint APAD_LEFT { setfocus "sidenav_button_"leftfocus; } 
		
	#define CHOICE_RIGHTNAV( itemIndex, rightfocus ) \
		name "sidenav_button_"itemIndex \
		execkeyint DPAD_RIGHT { setfocus "sidenav_button_"rightfocus; } \
		execkeyint APAD_RIGHT { setfocus "sidenav_button_"rightfocus; } 

	#define RNAV1	CHOICE_RIGHTNAV( "1", "15" )
	#define RNAV2	CHOICE_RIGHTNAV( "2", "16" )
	#define RNAV3	CHOICE_RIGHTNAV( "3", "17" )
	#define RNAV4	CHOICE_RIGHTNAV( "4", "18" )
	// The below RNAVs are not used in the game rules
	#define RNAV5	CHOICE_RIGHTNAV( "5", "19" )
	#define RNAV6	CHOICE_RIGHTNAV( "6", "20" )
	#define RNAV7	CHOICE_RIGHTNAV( "7", "21" )
	#define RNAV8	CHOICE_RIGHTNAV( "8", "22" )
	#define RNAV9	CHOICE_RIGHTNAV( "9", "23" )
	#define RNAV10	CHOICE_RIGHTNAV( "10", "24" )
	#define RNAV11	CHOICE_RIGHTNAV( "11", "25" )
	#define RNAV12	CHOICE_RIGHTNAV( "12", "26" )
	#define RNAV13	CHOICE_RIGHTNAV( "13", "27" )
	#define RNAV14	CHOICE_RIGHTNAV( "14", "28" )

	#define LNAV15	CHOICE_LEFTNAV( "15", "1" )
	#define LNAV16	CHOICE_LEFTNAV( "16", "2" )
	#define LNAV17	CHOICE_LEFTNAV( "17", "3" )
	#define LNAV18	CHOICE_LEFTNAV( "18", "4" )
	// Since we have only 4 indexes in our left hand side, we will point other item's left to the last index of the RNAV i.e. 5
	#define LNAV19	CHOICE_LEFTNAV( "19", "4" )
	#define LNAV20	CHOICE_LEFTNAV( "20", "4" )
	#define LNAV21	CHOICE_LEFTNAV( "21", "4" )
	#define LNAV22	CHOICE_LEFTNAV( "22", "4" )
	#define LNAV23	CHOICE_LEFTNAV( "23", "4" )
	#define LNAV24	CHOICE_LEFTNAV( "24", "4" )
	#define LNAV25	CHOICE_LEFTNAV( "25", "4" )
	#define LNAV26	CHOICE_LEFTNAV( "26", "4" )
	#define LNAV27	CHOICE_LEFTNAV( "27", "4" )
	#define LNAV28	CHOICE_LEFTNAV( "28", "4" )

	// Hardcore Mode Texts
#if 0
	#define CHOICE_HARDCORE_TEXT		"@MENU_RULES_HARDCORE"
	#define CHOICE_HARDCORE_DVAR		"scr_hardcore"
	#define CHOICE_HARDCORE_DVARTEXT	CHOICE_HARDCORE_DVAR"_text"
	#define CHOICE_HARDCORE_SHOW		1
	#define CHOICE_HARDCORE_EXEC1		execNowOnDvarIntValue scr_hardcore 0 "difficultyFu";
	#define CHOICE_HARDCORE_EXEC2		execNowOnDvarIntValue scr_hardcore 1 "difficultyMedium";
	#define CHOICE_HARDCORE_STRLIST	{ "@MENU_DISABLED" 0 "@MENU_ENABLED" 1}
	#ifndef PC
		#define CHOICE_HARDCORE_EXEC		execNow "toggle "CHOICE_HARDCORE_DVAR" 0 1"; play CHOICE_FOCUS_SOUND; CHOICE_HARDCORE_EXEC1 CHOICE_HARDCORE_EXEC2
	#else
		#define CHOICE_HARDCORE_EXEC	play CHOICE_FOCUS_SOUND;
	#endif
	#define CHOICE_HARDCORE_HINT		setdvar ui_hint_text "@MENU_RULES_HARDCORE_HINT";
#endif

	// Arcade Scoring Texts
	#define CHOICE_ARCADESCORING_TEXT		"@MENU_RULES_COMPETITIVESCORING"
	#define CHOICE_ARCADESCORING_DVAR		"arcademode"
	#define CHOICE_ARCADESCORING_DVARTEXT	CHOICE_ARCADESCORING_DVAR"_text"
	#define CHOICE_ARCADESCORING_STRLIST	{ "@MENU_DISABLED" 0 "@MENU_ENABLED" 1 }
	#ifndef PC
		#define CHOICE_ARCADESCORING_EXEC		exec "toggle "CHOICE_ARCADESCORING_DVAR" 0 1"; execNow "xupdatepartystate"; play CHOICE_FOCUS_SOUND;
	#else
		#define CHOICE_ARCADESCORING_EXEC		play CHOICE_FOCUS_SOUND;
	#endif
	#define CHOICE_ARCADESCORING_HINT		setdvar ui_hint_text "@MENU_RULES_COMPETITIVESCORING_HINT";

	// Difficulty Level Texts
	#define CHOICE_DIFFICULTY_TEXT			"@MENU_RULES_DIFFICULTY"
	#define CHOICE_DIFFICULTY_DVAR			"g_gameskill"
	#define CHOICE_DIFFICULTY_DVARTEXT		CHOICE_DIFFICULTY_DVAR"_text"
	#define CHOICE_DIFFICULTY_SHOW			1
	#define CHOICE_DIFFICULTY_STR1			"@MENU_RECRUIT_CAPS"
	#define CHOICE_DIFFICULTY_STR2			"@MENU_REGULAR_CAPS"
	#define CHOICE_DIFFICULTY_STR3			"@MENU_HARDENED_CAPS"
	#define CHOICE_DIFFICULTY_STR4			"@MENU_VETERAN_CAPS"
	#define CHOICE_DIFFICULTY_STR5			""
	#define CHOICE_DIFFICULTY_STR6			""
	#define CHOICE_DIFFICULTY_VAL1			0
	#define CHOICE_DIFFICULTY_VAL2			1
	#define CHOICE_DIFFICULTY_VAL3			2
	#define CHOICE_DIFFICULTY_VAL4			3
	#define CHOICE_DIFFICULTY_VAL5			0
	#define CHOICE_DIFFICULTY_VAL6			0
	#define CHOICE_DIFFICULTY_EXEC1			execNowOnDvarIntValue g_gameskill 0 "difficultyeasy";
	#define CHOICE_DIFFICULTY_EXEC2			execNowOnDvarIntValue g_gameskill 1 "difficultymedium";
	#define CHOICE_DIFFICULTY_EXEC3			execNowOnDvarIntValue g_gameskill 2 "difficultyhard";
	#define CHOICE_DIFFICULTY_EXEC4			execNowOnDvarIntValue g_gameskill 3 "difficultyfu";
	#define CHOICE_DIFFICULTY_EXEC			open popmenu_coop_difficulty
	#define CHOICE_DIFFICULTY_STRLIST		{ CHOICE_DIFFICULTY_STR1 CHOICE_DIFFICULTY_VAL1 CHOICE_DIFFICULTY_STR2 CHOICE_DIFFICULTY_VAL2 CHOICE_DIFFICULTY_STR3 CHOICE_DIFFICULTY_VAL3 CHOICE_DIFFICULTY_STR4 CHOICE_DIFFICULTY_VAL4 }
	#define CHOICE_DIFFICULTY_NUMVALS		4
	#define CHOICE_DIFFICULTY_HINT			setdvar ui_hint_text "@MENU_RULES_DIFFICULTY_HINT";

	// Death Card Texts
	#define CHOICE_DEATHCARDS_TEXT		"@MENU_RULES_DEATHCARDS"
	#define CHOICE_DEATHCARDS_DVAR		"ui_hostOptionsEnabled"
	#define CHOICE_DEATHCARDS_DVARTEXT	CHOICE_DEATHCARDS_DVAR"_text"
#ifndef PC
	#define CHOICE_DEATHCARDS_SHOW		when( dvarint( xblive_privatematch ) == 1 && dvarint( systemlink ) == 0 && dvarInt( cheat_items_set1 ) )
#else
	#define CHOICE_DEATHCARDS_SHOW		1
#endif	
	#define CHOICE_ARCADESCORING_SHOW	1
	#define CHOICE_DEATHCARDS_STRLIST	{ "@MENU_DISABLED" 0 "@MENU_ENABLED" 1}
	#ifndef PC
		#define CHOICE_DEATHCARDS_EXEC		execNow "toggle "CHOICE_DEATHCARDS_DVAR" 0 1"; play CHOICE_FOCUS_SOUND; execNow "xupdatepartystate";
	#else
		#define CHOICE_DEATHCARDS_EXEC	play CHOICE_FOCUS_SOUND;
	#endif
	#define CHOICE_DEATHCARDS_HINT		setdvar ui_hint_text "@MENU_RULES_DEATHCARDS_HINT";

	// Headshots Only Text
	#define CHOICE_HEADSHOTS_TEXT		"@MENU_RULES_HEADSHOTS_ONLY"
	#define CHOICE_HEADSHOTS_DVAR		"scr_game_onlyheadshots"
	#define CHOICE_HEADSHOTS_DVARTEXT	CHOICE_HEADSHOTS_DVAR"_text"
	#define CHOICE_HEADSHOTS_SHOW		1
	#define CHOICE_HEADSHOTS_STRLIST	{ "@MENU_DISABLED" 0 "@MENU_ENABLED" 1}
	#ifndef PC
		#define CHOICE_HEADSHOTS_EXEC	exec "toggle "CHOICE_HEADSHOTS_DVAR" 0 1"; play CHOICE_FOCUS_SOUND;
	#else
		#define CHOICE_HEADSHOTS_EXEC	play CHOICE_FOCUS_SOUND;
	#endif

	CHOICE_SECTION_TITLE( 1, GAMETYPE_OPTIONS )	

	#ifdef CAMPAIGN_MODE 
		CHOICE_DVARFLOATLIST_FOCUS_VIS( 2, CHOICE_ARCADESCORING_TEXT, CHOICE_ARCADESCORING_DVAR, CHOICE_ARCADESCORING_STRLIST, CHOICE_ARCADESCORING_EXEC, CHOICE_ARCADESCORING_HINT, ;,CHOICE_ARCADESCORING_SHOW )
		CHOICE_DVARFLOATLIST_FOCUS_VIS( 3, CHOICE_DIFFICULTY_TEXT, CHOICE_DIFFICULTY_DVAR, CHOICE_DIFFICULTY_STRLIST, CHOICE_DIFFICULTY_EXEC, CHOICE_DIFFICULTY_HINT, ;, 1 )
		//CHOICE_DVARFLOATLIST_FOCUS_VIS( 4, CHOICE_HARDCORE_TEXT, CHOICE_HARDCORE_DVAR RNAV4, CHOICE_HARDCORE_STRLIST, CHOICE_HARDCORE_EXEC, CHOICE_HARDCORE_HINT, ;, 1 )
		CHOICE_DVARFLOATLIST_FOCUS_VIS( 4, CHOICE_DEATHCARDS_TEXT, CHOICE_DEATHCARDS_DVAR, CHOICE_DEATHCARDS_STRLIST, CHOICE_DEATHCARDS_EXEC, CHOICE_DEATHCARDS_HINT, ;, CHOICE_DEATHCARDS_SHOW )
		CHOICE_BUTTON_NT_FOCUS_VIS_NOHI_EX( 4, ;, setdvar ui_hint_text "@MENU_RULES_DEATHCARDS_LOCKED_HINT";, ;, when( XBOX_LIVE_PRIVATE && !dvarInt( cheat_items_set1 ) ), ; )
		CHOICE_DBUTTON_VIS( 4, "@MENU_RULES_DEATHCARDS", when( XBOX_LIVE_PRIVATE && !dvarInt( cheat_items_set1 ) ) )
		CHOICE_BUTTON_FOCUS_VIS_EX( 5, "@MENU_SELECT_CHEATS", open menu_select_death_cards;, setdvar ui_hint_text "@MENU_SELECT_CHEATS_HINT";, ;, when( XBOX_LIVE_PRIVATE && dvarbool( ui_hostOptionsEnabled ) ), ; )
		CHOICE_DBUTTON_VIS( 5, "@MENU_SELECT_CHEATS", when( XBOX_LIVE_PRIVATE && !dvarbool( ui_hostOptionsEnabled ) ) )
	#endif

	#ifdef ZOMBIE_MODE 
		CHOICE_DVARFLOATLIST_FOCUS_VIS( 2, CHOICE_DIFFICULTY_TEXT, CHOICE_DIFFICULTY_DVAR, CHOICE_DIFFICULTY_STRLIST, CHOICE_DIFFICULTY_EXEC, CHOICE_DIFFICULTY_HINT, ;, 1 )
		//CHOICE_DVARFLOATLIST_FOCUS_VIS( 3, CHOICE_HARDCORE_TEXT, CHOICE_HARDCORE_DVAR RNAV3, CHOICE_HARDCORE_STRLIST, CHOICE_HARDCORE_EXEC, CHOICE_HARDCORE_HINT, ;, 1 )
		CHOICE_DVARFLOATLIST_FOCUS_VIS( 3, CHOICE_DEATHCARDS_TEXT, CHOICE_DEATHCARDS_DVAR, CHOICE_DEATHCARDS_STRLIST, CHOICE_DEATHCARDS_EXEC, CHOICE_DEATHCARDS_HINT, ;, CHOICE_DEATHCARDS_SHOW )
		CHOICE_BUTTON_FOCUS_VIS_EX( 4, "@MENU_SELECT_CHEATS", open menu_select_death_cards;, setdvar ui_hint_text "@MENU_SELECT_CHEATS_HINT";, ;, when( XBOX_LIVE_PRIVATE && dvarbool( ui_hostOptionsEnabled ) ), ; )
		CHOICE_DBUTTON_VIS( 4, "@MENU_SELECT_CHEATS", when( XBOX_LIVE_PRIVATE && !dvarbool( ui_hostOptionsEnabled ) ) )
	#endif
	
	#ifdef VS_MODE
	
		CHOICE_DVARFLOATLIST( 2, CHOICE1_TEXT, CHOICE1_DVAR RNAV2, CHOICE1_STRLIST, CHOICE1_EXEC )
		#ifdef CHOICE2_SHOW
		CHOICE_DVARFLOATLIST( 3, CHOICE2_TEXT, CHOICE2_DVAR RNAV3, CHOICE2_STRLIST, CHOICE2_EXEC )
		#endif
		#ifdef CHOICE3_SHOW
		CHOICE_DVARFLOATLIST( 4, CHOICE3_TEXT, CHOICE3_DVAR RNAV4, CHOICE3_STRLIST, CHOICE3_EXEC )
		#endif
		#ifdef CHOICE4_SHOW
		CHOICE_DVARFLOATLIST( 5, CHOICE4_TEXT, CHOICE4_DVAR RNAV5, CHOICE4_STRLIST, CHOICE4_EXEC )
		#endif
		#ifdef CHOICE5_SHOW
		CHOICE_DVARFLOATLIST( 6, CHOICE5_TEXT, CHOICE5_DVAR RNAV6, CHOICE5_STRLIST, CHOICE5_EXEC )
		#endif
		#ifdef CHOICE6_SHOW
		CHOICE_DVARFLOATLIST( 7, CHOICE6_TEXT, CHOICE6_DVAR RNAV7, CHOICE6_STRLIST, CHOICE6_EXEC )
		#endif
		#ifdef CHOICE7_SHOW
		CHOICE_DVARFLOATLIST( 8, CHOICE7_TEXT, CHOICE7_DVAR RNAV8, CHOICE7_STRLIST, CHOICE7_EXEC )
		#endif
		
	#endif


	#undef CHOICE_X_START
	#undef CHOICE_Y_START
#ifdef PC
	#define CHOICE_X_START			48
	#define CHOICE_Y_START			56
#else
	#define CHOICE_X_START			68
	#define CHOICE_Y_START			34
#endif

#define COLOR_DESC_TEXT 0 0 0 1
	// Hint Text
	HINT_TEXT( 6, SECTION_X_OFFSET, dvarString( ui_hint_text ), 1 )

////////////////////////

	#define COLLECTIBLE_STICKSSTONES	0
	#define COLLECTIBLE_VAMPIRE			1
	#define COLLECTIBLE_BERSERKER		2
	#define COLLECTIBLE_ZOMBIE			3
	#define COLLECTIBLE_PAINTBALL		4
	#define COLLECTIBLE_DIRTYHARRY		5
	#define COLLECTIBLE_MORPHINE		6
	#define COLLECTIBLE_THUNDER			7
	#define COLLECTIBLE_FLAK_JACKET		8
	#define COLLECTIBLE_HARDCORE		9
	#define COLLECTIBLE_BODY_ARMOR		10
	#define COLLECTIBLE_HARD_HEADED		11
	#define COLLECTIBLE_DEAD_HANDS		12

	#define HAS_COLLECTIBLE(collectible) ( ( ( dvarint( cheat_items_set1 ) & ( 1 << collectible ) ) != 0 ) )
	#define NOT_HAVE_COLLECTIBLE(collectible) ( ( ( dvarint( cheat_items_set1 ) & ( 1 << collectible ) ) == 0 ) )
	
	#define	COLLECTIBLE_ENABLED(collectible) ( ( ( dvarint( ui_hostOptions ) & ( 1 << collectible ) ) != 0 ) )
	#define	COLLECTIBLE_DISABLED(collectible) ( ( ( dvarint( ui_hostOptions ) & ( 1 << collectible ) ) == 0 ) )

	#undef CHOICE_SIDEITEM_SPACING
	#define CHOICE_SIDEITEM_SPACING 80

	#define CHOICE_COLLECTIBLE_TEXT_COLOR CHOICE_TEXTCOLOR_DISABLED

	#define COLLECTIBLE_FAKE_BUTTON( itemIndex, string, closedImage, openImage, bit, hintText, navArg ) \
		CHOICE_COLLECTIBLEICON_VIS( itemIndex, closedImage, when( XBOX_LIVE_PRIVATE && NOT_HAVE_COLLECTIBLE( bit ) ) ) \
		CHOICE_COLLECTIBLEICON_VIS( itemIndex, openImage,  when( XBOX_LIVE_PRIVATE && HAS_COLLECTIBLE( bit ) ) ) \
		CHOICE_DBUTTON_VIS( itemIndex, string, when ( XBOX_LIVE_PRIVATE ) ) \
		CHOICE_RIGHTITEM_VIS( itemIndex, "@MENU_DISABLED", CHOICE_COLLECTIBLE_TEXT_COLOR, when ( XBOX_LIVE_PRIVATE && HAS_COLLECTIBLE( bit ) && COLLECTIBLE_DISABLED( bit ) && dvarbool( ui_hostOptionsEnabled ) ) ) \
		CHOICE_RIGHTITEM_VIS( itemIndex, "@MENU_ENABLED", CHOICE_COLLECTIBLE_TEXT_COLOR, when( XBOX_LIVE_PRIVATE && HAS_COLLECTIBLE( bit ) && COLLECTIBLE_ENABLED( bit ) && dvarbool( ui_hostOptionsEnabled ) ) )
/*
	#ifdef CAMPAIGN_MODE
		COLLECTIBLE_FAKE_BUTTON ( 16, "@MENU_HOST_OPTION_ZOMBIE", "menu_deathcard_russian_mini", "menu_deathcard_zombie_mini", COLLECTIBLE_ZOMBIE, "@MENU_HOST_OPTION_ZOMBIE_HINT", LNAV16 );
		COLLECTIBLE_FAKE_BUTTON ( 17, "@MENU_HOST_OPTION_DIRTYHARRY", "menu_deathcard_american_mini", "menu_deathcard_dirty_harry_mini", COLLECTIBLE_DIRTYHARRY, "@MENU_HOST_OPTION_DIRTYHARRY_HINT", LNAV17 );
		COLLECTIBLE_FAKE_BUTTON ( 18, "@MENU_HOST_OPTION_VAMPIRE", "menu_deathcard_american_mini", "menu_deathcard_vampire_mini", COLLECTIBLE_VAMPIRE, "@MENU_HOST_OPTION_VAMPIRE_HINT", LNAV18 );
		COLLECTIBLE_FAKE_BUTTON ( 19, "@MENU_HOST_OPTION_BODY_ARMOR", "menu_deathcard_russian_mini", "menu_deathcard_body_armor_mini", COLLECTIBLE_BODY_ARMOR, "@MENU_HOST_OPTION_BODY_ARMOR_HINT", LNAV19 );
		COLLECTIBLE_FAKE_BUTTON ( 20, "@MENU_HOST_OPTION_MORPHINE", "menu_deathcard_american_mini", "menu_deathcard_morphine_shot_mini", COLLECTIBLE_MORPHINE, "@MENU_HOST_OPTION_MORPHINE_HINT", LNAV20 );
		COLLECTIBLE_FAKE_BUTTON ( 21, "@MENU_HOST_OPTION_FLAK_JACKET", "menu_deathcard_american_mini", "menu_deathcard_flak_jacket_mini", COLLECTIBLE_FLAK_JACKET, "@MENU_HOST_OPTION_FLAK_JACKET_HINT", LNAV21 );
		COLLECTIBLE_FAKE_BUTTON ( 22, "@MENU_HOST_OPTION_THUNDER", "menu_deathcard_american_mini", "menu_deathcard_thunder_mini", COLLECTIBLE_THUNDER, "@MENU_HOST_OPTION_THUNDER_HINT", LNAV22 );
		COLLECTIBLE_FAKE_BUTTON ( 23, "@MENU_HOST_OPTION_STICKSSTONES", "menu_deathcard_russian_mini", "menu_deathcard_sticks_stones_mini", COLLECTIBLE_STICKSSTONES, "@MENU_HOST_OPTION_STICKSSTONES_HINT", LNAV23 );
		COLLECTIBLE_FAKE_BUTTON ( 24, "@MENU_HOST_OPTION_PAINTBALL", "menu_deathcard_russian_mini", "menu_deathcard_paintball_mini", COLLECTIBLE_PAINTBALL, "@MENU_HOST_OPTION_PAINTBALL_HINT", LNAV24 );		
		COLLECTIBLE_FAKE_BUTTON ( 25, "@MENU_HOST_OPTION_DEAD_HANDS", "menu_deathcard_russian_mini", "menu_deathcard_cold_dead_hands_mini", COLLECTIBLE_DEAD_HANDS, "@MENU_HOST_OPTION_DEAD_HANDS_HINT", LNAV25 );
		COLLECTIBLE_FAKE_BUTTON ( 26, "@MENU_HOST_OPTION_HARD_HEADED", "menu_deathcard_american_mini", "menu_deathcard_hard_headed_mini", COLLECTIBLE_HARD_HEADED, "@MENU_HOST_OPTION_HARD_HEADED_HINT", LNAV26 );
		COLLECTIBLE_FAKE_BUTTON ( 27, "@MENU_HOST_OPTION_BERSERKER", "menu_deathcard_american_mini", "menu_deathcard_berserker_mini", COLLECTIBLE_BERSERKER, "@MENU_HOST_OPTION_BERSERKER_HINT", LNAV27 );	
		COLLECTIBLE_FAKE_BUTTON ( 28, "@MENU_HOST_OPTION_HARDCORE", "menu_deathcard_russian_mini", "menu_deathcard_midas_touch_mini", COLLECTIBLE_HARDCORE, "@MENU_HOST_OPTION_HARDCORE_HINT", LNAV28 );	
	#endif

	#ifdef ZOMBIE_MODE
		COLLECTIBLE_FAKE_BUTTON ( 16, "@MENU_HOST_OPTION_ZOMBIE", "menu_deathcard_russian", "menu_deathcard_zombie_mini", COLLECTIBLE_ZOMBIE, "@MENU_HOST_OPTION_ZOMBIE_HINT", LNAV16 );
		COLLECTIBLE_FAKE_BUTTON ( 17, "@MENU_HOST_OPTION_DIRTYHARRY", "menu_deathcard_american", "menu_deathcard_dirty_harry_mini", COLLECTIBLE_DIRTYHARRY, "@MENU_HOST_OPTION_DIRTYHARRY_HINT", LNAV17 );
		COLLECTIBLE_FAKE_BUTTON ( 18, "@MENU_HOST_OPTION_VAMPIRE", "menu_deathcard_american", "menu_deathcard_vampire_mini", COLLECTIBLE_VAMPIRE, "@MENU_HOST_OPTION_VAMPIRE_HINT", LNAV18 );
		COLLECTIBLE_FAKE_BUTTON ( 19, "@MENU_HOST_OPTION_BODY_ARMOR", "menu_deathcard_russian", "menu_deathcard_body_armor_mini", COLLECTIBLE_BODY_ARMOR, "@MENU_HOST_OPTION_BODY_ARMOR_HINT", LNAV19 );
		COLLECTIBLE_FAKE_BUTTON ( 20, "@MENU_HOST_OPTION_MORPHINE", "menu_deathcard_american", "menu_deathcard_morphine_shot_mini", COLLECTIBLE_MORPHINE, "@MENU_HOST_OPTION_MORPHINE_HINT", LNAV20 );
		COLLECTIBLE_FAKE_BUTTON ( 21, "@MENU_HOST_OPTION_FLAK_JACKET", "menu_deathcard_american", "menu_deathcard_flak_jacket_mini", COLLECTIBLE_FLAK_JACKET, "@MENU_HOST_OPTION_FLAK_JACKET_HINT", LNAV21 );
		COLLECTIBLE_FAKE_BUTTON ( 22, "@MENU_HOST_OPTION_THUNDER", "menu_deathcard_american", "menu_deathcard_thunder_mini", COLLECTIBLE_THUNDER, "@MENU_HOST_OPTION_THUNDER_HINT", LNAV22 );
		COLLECTIBLE_FAKE_BUTTON ( 23, "@MENU_HOST_OPTION_STICKSSTONES", "menu_deathcard_russian", "menu_deathcard_sticks_stones_mini", COLLECTIBLE_STICKSSTONES, "@MENU_HOST_OPTION_STICKSSTONES_HINT", LNAV23 );
		COLLECTIBLE_FAKE_BUTTON ( 24, "@MENU_HOST_OPTION_PAINTBALL", "menu_deathcard_russian", "menu_deathcard_paintball_mini", COLLECTIBLE_PAINTBALL, "@MENU_HOST_OPTION_PAINTBALL_HINT", LNAV24 );		
		COLLECTIBLE_FAKE_BUTTON ( 25, "@MENU_HOST_OPTION_DEAD_HANDS", "menu_deathcard_russian", "menu_deathcard_cold_dead_hands_mini", COLLECTIBLE_DEAD_HANDS, "@MENU_HOST_OPTION_DEAD_HANDS_HINT", LNAV25 );
		COLLECTIBLE_FAKE_BUTTON ( 26, "@MENU_HOST_OPTION_HARD_HEADED", "menu_deathcard_american", "menu_deathcard_hard_headed_mini", COLLECTIBLE_HARD_HEADED, "@MENU_HOST_OPTION_HARD_HEADED_HINT", LNAV26 );
		COLLECTIBLE_FAKE_BUTTON ( 27, "@MENU_HOST_OPTION_BERSERKER", "menu_deathcard_american", "menu_deathcard_berserker_mini", COLLECTIBLE_BERSERKER, "@MENU_HOST_OPTION_BERSERKER_HINT", LNAV27 );	
		COLLECTIBLE_FAKE_BUTTON ( 28, "@MENU_HOST_OPTION_HARDCORE", "menu_deathcard_russian", "menu_deathcard_midas_touch_mini", COLLECTIBLE_HARDCORE, "@MENU_HOST_HARDCORE_TOUCH_HINT", LNAV28 );	
	#endif
*/}

PREPROC_DIFFICULTY_DVAR_POPUP( 3, CHOICE_DIFFICULTY_TEXT, CHOICE_DIFFICULTY_NUMVALS, CHOICE_DIFFICULTY_DVAR, CHOICE_DIFFICULTY_STR1, CHOICE_DIFFICULTY_STR2, CHOICE_DIFFICULTY_STR3, CHOICE_DIFFICULTY_STR4, CHOICE_DIFFICULTY_VAL1, CHOICE_DIFFICULTY_VAL2, CHOICE_DIFFICULTY_VAL3, CHOICE_DIFFICULTY_VAL4, POPUP_ITEM_OFFSET )

menuDef {
	name			menu_select_death_cards
	rect			0 0 640 470 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	focuscolor		COLOR_FOCUSED
	//backColor		0 0 0 0.2
	style			WINDOW_STYLE_FILLED
	soundloop 		MENU_MUSIC
	border			0
	onOpen			
	{ 
		focusFirst; 
	}
	onEsc			
	{
		exec "xupdatepartystate";			 
		close self; 
	}
	onClose
	{
		exec "xupdatepartystate";	
	}

	#undef CHOICE_COLLECTIBLE_TEXT_COLOR
	#define CHOICE_COLLECTIBLE_TEXT_COLOR CHOICE_TEXTCOLOR
	#undef CHOICE_COLLECTIBLE_RIGHT_TEXT_COLOR
	#define CHOICE_COLLECTIBLE_RIGHT_TEXT_COLOR CHOICE_TEXTCOLOR_SELECTABLE

	#define COLLECTIBLE_BUTTON( itemIndex, string, closedImage, openImage, bit, hintText, navArg ) \
		CHOICE_COLLECTIBLEICON_VIS( itemIndex, closedImage, when( XBOX_LIVE_PRIVATE && NOT_HAVE_COLLECTIBLE( bit ) ) ) \
		CHOICE_COLLECTIBLEICON_VIS( itemIndex, openImage,  when( XBOX_LIVE_PRIVATE && HAS_COLLECTIBLE( bit ) ) ) \
		CHOICE_BUTTON_FOCUS_VIS_EX( itemIndex, string, toggleCollectible bit, setdvar ui_hint_text hintText;, ;, when ( XBOX_LIVE_PRIVATE && HAS_COLLECTIBLE( bit ) && dvarbool( ui_hostOptionsEnabled ) ), navArg; foreColor CHOICE_COLLECTIBLE_TEXT_COLOR) \
		CHOICE_DBUTTON_VIS( itemIndex, string, when ( XBOX_LIVE_PRIVATE && NOT_HAVE_COLLECTIBLE( bit ) || !dvarbool( ui_hostOptionsEnabled ) ) ) \
		CHOICE_RIGHTITEM_VIS( itemIndex, "@MENU_DISABLED", CHOICE_COLLECTIBLE_RIGHT_TEXT_COLOR, when ( XBOX_LIVE_PRIVATE && HAS_COLLECTIBLE( bit ) && COLLECTIBLE_DISABLED( bit ) && dvarbool( ui_hostOptionsEnabled ) ) ) \
		CHOICE_RIGHTITEM_VIS( itemIndex, "@MENU_ENABLED", CHOICE_COLLECTIBLE_RIGHT_TEXT_COLOR, when( XBOX_LIVE_PRIVATE && HAS_COLLECTIBLE( bit ) && COLLECTIBLE_ENABLED( bit ) && dvarbool( ui_hostOptionsEnabled ) ) )

/*
	#ifdef CAMPAIGN_MODE
		COLLECTIBLE_BUTTON ( 16, "@MENU_HOST_OPTION_ZOMBIE", "menu_deathcard_russian_mini", "menu_deathcard_zombie_mini", COLLECTIBLE_ZOMBIE, "@MENU_HOST_OPTION_ZOMBIE_HINT", LNAV16 );
		COLLECTIBLE_BUTTON ( 17, "@MENU_HOST_OPTION_DIRTYHARRY", "menu_deathcard_american_mini", "menu_deathcard_dirty_harry_mini", COLLECTIBLE_DIRTYHARRY, "@MENU_HOST_OPTION_DIRTYHARRY_HINT", LNAV17 );
		COLLECTIBLE_BUTTON ( 18, "@MENU_HOST_OPTION_VAMPIRE", "menu_deathcard_american_mini", "menu_deathcard_vampire_mini", COLLECTIBLE_VAMPIRE, "@MENU_HOST_OPTION_VAMPIRE_HINT", LNAV18 );
		COLLECTIBLE_BUTTON ( 19, "@MENU_HOST_OPTION_BODY_ARMOR", "menu_deathcard_russian_mini", "menu_deathcard_body_armor_mini", COLLECTIBLE_BODY_ARMOR, "@MENU_HOST_OPTION_BODY_ARMOR_HINT", LNAV19 );
		COLLECTIBLE_BUTTON ( 20, "@MENU_HOST_OPTION_MORPHINE", "menu_deathcard_american_mini", "menu_deathcard_morphine_shot_mini", COLLECTIBLE_MORPHINE, "@MENU_HOST_OPTION_MORPHINE_HINT", LNAV20 );
		COLLECTIBLE_BUTTON ( 21, "@MENU_HOST_OPTION_FLAK_JACKET", "menu_deathcard_american_mini", "menu_deathcard_flak_jacket_mini", COLLECTIBLE_FLAK_JACKET, "@MENU_HOST_OPTION_FLAK_JACKET_HINT", LNAV21 );
		COLLECTIBLE_BUTTON ( 22, "@MENU_HOST_OPTION_THUNDER", "menu_deathcard_american_mini", "menu_deathcard_thunder_mini", COLLECTIBLE_THUNDER, "@MENU_HOST_OPTION_THUNDER_HINT", LNAV22 );
		COLLECTIBLE_BUTTON ( 23, "@MENU_HOST_OPTION_STICKSSTONES", "menu_deathcard_russian_mini", "menu_deathcard_sticks_stones_mini", COLLECTIBLE_STICKSSTONES, "@MENU_HOST_OPTION_STICKSSTONES_HINT", LNAV23 );
		COLLECTIBLE_BUTTON ( 24, "@MENU_HOST_OPTION_PAINTBALL", "menu_deathcard_russian_mini", "menu_deathcard_paintball_mini", COLLECTIBLE_PAINTBALL, "@MENU_HOST_OPTION_PAINTBALL_HINT", LNAV24 );		
		COLLECTIBLE_BUTTON ( 25, "@MENU_HOST_OPTION_DEAD_HANDS", "menu_deathcard_russian_mini", "menu_deathcard_cold_dead_hands_mini", COLLECTIBLE_DEAD_HANDS, "@MENU_HOST_OPTION_DEAD_HANDS_HINT", LNAV25 );
		COLLECTIBLE_BUTTON ( 26, "@MENU_HOST_OPTION_HARD_HEADED", "menu_deathcard_american_mini", "menu_deathcard_hard_headed_mini", COLLECTIBLE_HARD_HEADED, "@MENU_HOST_OPTION_HARD_HEADED_HINT", LNAV26 );
		COLLECTIBLE_BUTTON ( 27, "@MENU_HOST_OPTION_BERSERKER", "menu_deathcard_american_mini", "menu_deathcard_berserker_mini", COLLECTIBLE_BERSERKER, "@MENU_HOST_OPTION_BERSERKER_HINT", LNAV27 );	
		COLLECTIBLE_BUTTON ( 28, "@MENU_HOST_OPTION_HARDCORE", "menu_deathcard_russian_mini", "menu_deathcard_midas_touch_mini", COLLECTIBLE_HARDCORE, "@MENU_HOST_OPTION_HARDCORE_HINT", LNAV28 );	
	#endif

	#ifdef ZOMBIE_MODE
		COLLECTIBLE_BUTTON ( 16, "@MENU_HOST_OPTION_ZOMBIE", "menu_deathcard_russian", "menu_deathcard_zombie_mini", COLLECTIBLE_ZOMBIE, "@MENU_HOST_OPTION_ZOMBIE_HINT", LNAV16 );
		COLLECTIBLE_BUTTON ( 17, "@MENU_HOST_OPTION_DIRTYHARRY", "menu_deathcard_american", "menu_deathcard_dirty_harry_mini", COLLECTIBLE_DIRTYHARRY, "@MENU_HOST_OPTION_DIRTYHARRY_HINT", LNAV17 );
		COLLECTIBLE_BUTTON ( 18, "@MENU_HOST_OPTION_VAMPIRE", "menu_deathcard_american", "menu_deathcard_vampire_mini", COLLECTIBLE_VAMPIRE, "@MENU_HOST_OPTION_VAMPIRE_HINT", LNAV18 );
		COLLECTIBLE_BUTTON ( 19, "@MENU_HOST_OPTION_BODY_ARMOR", "menu_deathcard_russian", "menu_deathcard_body_armor_mini", COLLECTIBLE_BODY_ARMOR, "@MENU_HOST_OPTION_BODY_ARMOR_HINT", LNAV19 );
		COLLECTIBLE_BUTTON ( 20, "@MENU_HOST_OPTION_MORPHINE", "menu_deathcard_american", "menu_deathcard_morphine_shot_mini", COLLECTIBLE_MORPHINE, "@MENU_HOST_OPTION_MORPHINE_HINT", LNAV20 );
		COLLECTIBLE_BUTTON ( 21, "@MENU_HOST_OPTION_FLAK_JACKET", "menu_deathcard_american", "menu_deathcard_flak_jacket_mini", COLLECTIBLE_FLAK_JACKET, "@MENU_HOST_OPTION_FLAK_JACKET_HINT", LNAV21 );
		COLLECTIBLE_BUTTON ( 22, "@MENU_HOST_OPTION_THUNDER", "menu_deathcard_american", "menu_deathcard_thunder_mini", COLLECTIBLE_THUNDER, "@MENU_HOST_OPTION_THUNDER_HINT", LNAV22 );
		COLLECTIBLE_BUTTON ( 23, "@MENU_HOST_OPTION_STICKSSTONES", "menu_deathcard_russian", "menu_deathcard_sticks_stones_mini", COLLECTIBLE_STICKSSTONES, "@MENU_HOST_OPTION_STICKSSTONES_HINT", LNAV23 );
		COLLECTIBLE_BUTTON ( 24, "@MENU_HOST_OPTION_PAINTBALL", "menu_deathcard_russian", "menu_deathcard_paintball_mini", COLLECTIBLE_PAINTBALL, "@MENU_HOST_OPTION_PAINTBALL_HINT", LNAV24 );		
		COLLECTIBLE_BUTTON ( 25, "@MENU_HOST_OPTION_DEAD_HANDS", "menu_deathcard_russian", "menu_deathcard_cold_dead_hands_mini", COLLECTIBLE_DEAD_HANDS, "@MENU_HOST_OPTION_DEAD_HANDS_HINT", LNAV25 );
		COLLECTIBLE_BUTTON ( 26, "@MENU_HOST_OPTION_HARD_HEADED", "menu_deathcard_american", "menu_deathcard_hard_headed_mini", COLLECTIBLE_HARD_HEADED, "@MENU_HOST_OPTION_HARD_HEADED_HINT", LNAV26 );
		COLLECTIBLE_BUTTON ( 27, "@MENU_HOST_OPTION_BERSERKER", "menu_deathcard_american", "menu_deathcard_berserker_mini", COLLECTIBLE_BERSERKER, "@MENU_HOST_OPTION_BERSERKER_HINT", LNAV27 );	
		COLLECTIBLE_BUTTON ( 28, "@MENU_HOST_OPTION_HARDCORE", "menu_deathcard_russian", "menu_deathcard_midas_touch_mini", COLLECTIBLE_HARDCORE, "@MENU_HOST_HARDCORE_TOUCH_HINT", LNAV28 );	
	#endif
*/
}