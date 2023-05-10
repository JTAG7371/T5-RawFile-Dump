#ifndef SPLITSCREEN_ENABLED // Don't want to duplicate this menu when included from splitscreen

//controls_common_info.inc
//#include "ui_mp/newframe.inc"

//backgound inc
#include "ui/blurredbg.inc"
// control settings

#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X						150

#undef BUTTON_BG_Y_START
#define BUTTON_BG_Y_START					50

#undef CHOICE_TEXTSTYLE
#define CHOICE_TEXTSTYLE					ITEM_TEXTSTYLE_NORMAL

#define LOCALIZATION_FILE					"@MENU"

#ifdef SINGLE_PLAYER
#undef LOCALIZATION_FILE
#define LOCALIZATION_FILE					"@MENU"
#endif

#undef OPTIONS_MENU_NAME
#define OPTIONS_MENU_NAME					options

#undef CONTROL_THUMBSTICK_NAME
#define CONTROL_THUMBSTICK_NAME				thumbstick

#undef CONTROL_BUTTONS_NAME
#define CONTROL_BUTTONS_NAME				buttons

#undef CONTROL_SENSITIVITY_NAME
#define CONTROL_SENSITIVITY_NAME			sensitivity

#undef CONTROL_SENSITIVITY_CUSTOM_NAME
#define CONTROL_SENSITIVITY_CUSTOM_NAME		sensitivity_custom

#undef CONTROL_TEAM_INDICATOR_NAME
#define CONTROL_TEAM_INDICATOR_NAME			team_indicator

#undef CONTROL_VOLUME_NAME
#define CONTROL_VOLUME_NAME					volume

#undef CONTROL_AUDIO_LISTEN_NAME
#define CONTROL_AUDIO_LISTEN_NAME			audio_listen

#undef CONTROL_AUDIO_SPEAKER_NAME
#define CONTROL_AUDIO_SPEAKER_NAME			audio_speaker

#undef CONTROL_BRIGHTNESS_NAME
#define CONTROL_BRIGHTNESS_NAME				brightness

#undef CONTROL_3D_OPTION_NAME
#define CONTROL_3D_OPTION_NAME				options_3d

#define BG_SHADE_COLOR						0 0 0 0.75


#ifdef CONTROL_IN_GAME
	#undef OPTIONS_MENU_NAME
	#define OPTIONS_MENU_NAME				ingameoptions
	
	#undef CONTROL_THUMBSTICK_NAME
	#define CONTROL_THUMBSTICK_NAME			ingameoptions_thumbstick
	
	#undef CONTROL_BUTTONS_NAME
	#define CONTROL_BUTTONS_NAME			ingameoptions_buttons
	
	#undef CONTROL_SENSITIVITY_NAME
	#define CONTROL_SENSITIVITY_NAME		ingameoptions_sensitivity

	#undef CONTROL_SENSITIVITY_CUSTOM_NAME
	#define CONTROL_SENSITIVITY_CUSTOM_NAME	ingameoptions_sensitivity_custom

	#undef CONTROL_TEAM_INDICATOR_NAME
	#define CONTROL_TEAM_INDICATOR_NAME		ingameoptions_team_indicator

	#undef CONTROL_VOLUME_NAME
	#define CONTROL_VOLUME_NAME				ingameoptions_volume

	#undef CONTROL_AUDIO_LISTEN_NAME
	#define CONTROL_AUDIO_LISTEN_NAME		ingameoptions_audio_listen

	#undef CONTROL_AUDIO_SPEAKER_NAME
	#define CONTROL_AUDIO_SPEAKER_NAME		ingameoptions_audio_speaker

	#undef CONTROL_BRIGHTNESS_NAME
	#define CONTROL_BRIGHTNESS_NAME			ingameoptions_brightness
	
	#undef CONTROL_3D_OPTION_NAME
	#define CONTROL_3D_OPTION_NAME			ingameoptions_options_3d

	#undef BG_SHADE_COLOR
	#define BG_SHADE_COLOR					0 0 0 0.75
#endif //#ifdef CONTROL_IN_GAME

#ifdef CONTROL_IN_GAME_SPLITSCREEN
	#undef OPTIONS_MENU_NAME
	#define OPTIONS_MENU_NAME				ingameoptions_splitscreen
	
	#undef CONTROL_THUMBSTICK_NAME
	#define CONTROL_THUMBSTICK_NAME			ingameoptions_thumbstick_splitscreen
	
	#undef CONTROL_BUTTONS_NAME
	#define CONTROL_BUTTONS_NAME			ingameoptions_buttons_splitscreen
	
	#undef CONTROL_SENSITIVITY_NAME
	#define CONTROL_SENSITIVITY_NAME		ingameoptions_sensitivity_splitscreen

	#undef CONTROL_SENSITIVITY_CUSTOM_NAME
	#define CONTROL_SENSITIVITY_CUSTOM_NAME	ingameoptions_sensitivity_splitscreen_custom

	#undef CONTROL_TEAM_INDICATOR_NAME
	#define CONTROL_TEAM_INDICATOR_NAME		ingameoptions_team_indicator_splitscreen
	
	#undef CONTROL_VOLUME_NAME
	#define CONTROL_VOLUME_NAME				ingameoptions_volume_splitscreen

	#undef CONTROL_AUDIO_LISTEN_NAME
	#define CONTROL_AUDIO_LISTEN_NAME		ingameoptiosn_audio_listen_splitscreen

	#undef CONTROL_AUDIO_SPEAKER_NAME
	#define CONTROL_AUDIO_SPEAKER_NAME		ingameoptions_audio_speaker_splitscreen

	#undef CONTROL_BRIGHTNESS_NAME
	#define CONTROL_BRIGHTNESS_NAME			ingameoptions_brightness_splitscreen

	#undef CONTROL_3D_OPTION_NAME
	#define CONTROL_3D_OPTION_NAME			ingameoptions_options_3d_splitscreen

	#undef BG_SHADE_COLOR
	#define BG_SHADE_COLOR					0 0 0 0.85
#endif //#ifdef CONTROL_IN_GAME_SPLITSCREEN

#ifdef PS3
	// ps3 voice volume control ==================
	#define LOCAL_VOICE_METER_RAW( dvar1, dvar2 )\
			execOnDvarFloatValue ps3_voiceSpeakerGain dvar1 "set ps3_voiceSpeakerGain "dvar2;
			
	#define LOCAL_VOICE_METER_1 \
			LOCAL_VOICE_METER_RAW( 1.2, "1.5" )\
			LOCAL_VOICE_METER_RAW( 1.5, "2.0" )\
			LOCAL_VOICE_METER_RAW( 2.0, "2.5" )\
			LOCAL_VOICE_METER_RAW( 2.5, "3.0" )\
			LOCAL_VOICE_METER_RAW( 3.0, "3.5" )\
			LOCAL_VOICE_METER_RAW( 3.5, "4.0" )\
			LOCAL_VOICE_METER_RAW( 4.0, "4.5" )\
			LOCAL_VOICE_METER_RAW( 4.5, "5.0" )\
			LOCAL_VOICE_METER_RAW( 5.0, "6.0" )\
			LOCAL_VOICE_METER_RAW( 6.0, "7.0" )\
			LOCAL_VOICE_METER_RAW( 7.0, "8.0" )\
			LOCAL_VOICE_METER_RAW( 8.0, "9.0" )\
			LOCAL_VOICE_METER_RAW( 9.0, "10.0")
			
	#define LOCAL_VOICE_METER_2 \
			LOCAL_VOICE_METER_RAW( 10.0, "9.0")\
			LOCAL_VOICE_METER_RAW( 9.0, "8.0" )\
			LOCAL_VOICE_METER_RAW( 8.0, "7.0" )\
			LOCAL_VOICE_METER_RAW( 7.0, "6.0" )\
			LOCAL_VOICE_METER_RAW( 6.0, "5.0" )\
			LOCAL_VOICE_METER_RAW( 5.0, "4.5" )\
			LOCAL_VOICE_METER_RAW( 4.5, "4.0" )\
			LOCAL_VOICE_METER_RAW( 4.0, "3.5" )\
			LOCAL_VOICE_METER_RAW( 3.5, "3.0" )\
			LOCAL_VOICE_METER_RAW( 3.0, "2.5" )\
			LOCAL_VOICE_METER_RAW( 2.5, "2.0" )\
			LOCAL_VOICE_METER_RAW( 2.0, "1.5" )\
			LOCAL_VOICE_METER_RAW( 1.5, "1.2" )
			
	#define LOCAL_VOICE_EXTRA \
		execKeyInt DPAD_RIGHT { LOCAL_VOICE_METER_1 }\
		execKeyInt APAD_RIGHT { LOCAL_VOICE_METER_1 }\
		execKeyInt DPAD_LEFT { LOCAL_VOICE_METER_2 }\
		execKeyInt APAD_LEFT { LOCAL_VOICE_METER_2 }

#endif //#ifdef PS3

#define LOCAL_BG \
		itemDef																					\
		{																						\
			style			WINDOW_STYLE_FILLED													\
			rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN	\
			backcolor		BG_SHADE_COLOR														\
			visible			1																	\
			decoration																			\
		}																						\
		itemDef																					\
		{																						\
			style			WINDOW_STYLE_SHADER													\
			rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0							\
			background		"gradient_top"														\
			visible			1																	\
			decoration																			\
		}																						\
		itemDef																					\
		{																						\
			style			WINDOW_STYLE_SHADER													\
			rect			0 410 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0							\
			background		"gradient_bottom"													\
			visible			1																	\
			decoration																			\
		}


// THUMBSTICK LAYOUT MENU
#undef CHOICE_BUTTON_NAME
#define CHOICE_BUTTON_NAME		"thumbstick_"

#undef MENUDEF_NAME
#define MENUDEF_NAME			CONTROL_THUMBSTICK_NAME

#undef CHOICE_GROUP
#define CHOICE_GROUP			"thumbstick"

#define STICK_LAYOUT_CLEAR_ALL_FOCUS			\
		hide "controls_thumbstick_default";		\
		hide "controls_thumbstick_southpaw";	\
		hide "controls_thumbstick_legacy";		\
		hide "controls_thumbstick_legacysouthpaw";

#define STICK_LAYOUT_ACTION						\
		STICK_LAYOUT_CLEAR_ALL_FOCUS			\
		if( dvarString( ui_sticksConfig ) == "thumbstick_default" )				\
		{																		\
			show "controls_thumbstick_default";									\
		}																		\
		elseif( dvarString( ui_sticksConfig ) == "thumbstick_southpaw" )		\
		{																		\
			show "controls_thumbstick_southpaw";								\
		}																		\
		elseif( dvarString( ui_sticksConfig ) == "thumbstick_legacy" )			\
		{																		\
			show "controls_thumbstick_legacy";									\
		}																		\
		elseif( dvarString( ui_sticksConfig ) == "thumbstick_legacysouthpaw" )	\
		{																		\
			show "controls_thumbstick_legacysouthpaw";							\
		}


menuDef
{
	name			CONTROL_THUMBSTICK_NAME
	control			MENU_CONTROL_OPENER
#ifdef CONTROL_IN_GAME
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		4.8
	legacySplitScreenScale
	onOpen 	
	{
		setdvar cg_drawhud "0";
		setDvar ui_allow_controlschange "0";
		setdvar ui_sticksConfig dvarString( gpad_sticksConfig );
		STICK_LAYOUT_ACTION
	}
	onclose	
	{
		setdvar gpad_sticksConfig dvarString( ui_sticksConfig )
		setdvar cg_drawhud "1";
		setDvar ui_allow_controlschange "1";
		execNow "updategamerprofile";
		open OPTIONS_MENU_NAME;
	}
	onEsc
	{ 
		close CONTROL_THUMBSTICK_NAME; 
		open OPTIONS_MENU_NAME;
	}

	//ingame background
	#include "ui_mp/ingamebg.inc"
	FRAME_TITLE_LEFT_DEFAULT( "@PLATFORM_STICK_LAYOUT_TITLE", 1 )
#else //#ifdef CONTROL_IN_GAME
	rect					0 0 640 480
	focuscolor				COLOR_FOCUSED
	style					WINDOW_STYLE_FILLED
	priority				MENU_PRI_ONTOP
	soundloop 				MENU_MUSIC
	openSlideSpeed			DEFAULT_SLIDE_IN_SPEED
	closeSlideSpeed			DEFAULT_SLIDE_OUT_SPEED
	openSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM
	closeSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM

	onOpen
	{
#ifndef SINGLE_PLAYER
		activateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_open;
		setdvar ui_sticksConfig dvarString( gpad_sticksConfig );
		STICK_LAYOUT_ACTION
	}

	onESC
	{
		setdvar gpad_sticksConfig dvarString( ui_sticksConfig )
#ifndef SINGLE_PLAYER
		deactivateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_close;

		execNow "updategamerprofile";
		FRAME_BACK_TO_FRAME_SLIDE_ACTION( CONTROL_THUMBSTICK_NAME, OPTIONS_MENU_NAME );
	}

#ifndef SINGLE_PLAYER
	FRAME_DEFAULT
#else //#ifndef SINGLE_PLAYER
	FRAME_SP_DEFAULT
#endif //#ifndef SINGLE_PLAYER

	FRAME_TITLE_DEFAULT( "@MENU_OPTIONS_CAPS" , 1 )
	FRAME_SUBTITLE_DEFAULT( "@PLATFORM_STICK_LAYOUT_CAPS", 1 )
#endif //#ifdef CONTROL_IN_GAME

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@PLATFORM_STICK_LAYOUT_TITLE" )
	#endif
	
	#define SETUP_ACTION( pconfig ) \
		setDvar gpad_sticksConfig pconfig \
		execNow "updategamerprofile"; \
		FRAME_BACK_TO_FRAME_SLIDE_ACTION( CONTROL_THUMBSTICK_NAME, OPTIONS_MENU_NAME );

	#define SETUP_EXTRA( pnum ) \
		dvartest "gpad_sticksConfig" focusdvar { pnum }


#ifndef	CONTROL_IN_GAME_SPLITSCREEN

	#include "ui/controls_thumbstick_set.menu"

	#undef	CHOICE_SIZE_X
	#define CHOICE_SIZE_X				375

	#undef CHOICE_DVAR_OFFSET_X
	#define CHOICE_DVAR_OFFSET_X		(CHOICE_SIZE_X-160)
	
	#define SETUP_FOCUS( pnum ) \
		show "controls_"pnum;
	
	#define SETUP_UNFOCUS( pnum ) \
		hide "controls_"pnum;
#else //#ifndef	CONTROL_IN_GAME_SPLITSCREEN
	#define SETUP_FOCUS( pnum ) ;
	#define SETUP_UNFOCUS( pnum ) ;
#endif //#ifndef	CONTROL_IN_GAME_SPLITSCREEN

	#undef	A_BUTTON_OFFSET_X
	#define A_BUTTON_OFFSET_X				100000

	FRAME_CHOICE_DVARSTRINGLIST_FOCUS_VIS(	1, "@PLATFORM_THUMBSTICK_LAYOUT_CAPS", ui_sticksConfig, 
											{ "@MENU_DEFAULT_CAPS" thumbstick_default "@MENU_SOUTHPAW_CAPS" thumbstick_southpaw 
											"@MENU_LEGACY_CAPS" thumbstick_legacy "@MENU_LEGACY_SOUTHPAW_CAPS" thumbstick_legacysouthpaw }, 
											STICK_LAYOUT_ACTION, 
											CLEARUIHINT, 
											CLEARUIHINT, 
											1 )


#ifdef CONTROL_IN_GAME
	PREPROC_TEXT_DRAW_VIS( CHOICE_X_START -17 70 17 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM, 0 0, "@PLATFORM_BACK", TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, 1 1 1 1, 1 )
#else //#ifdef CONTROL_IN_GAME
	FRAME_BACK_BUTTON_DEFAULT
#endif //#ifdef CONTROL_IN_GAME

	#include "ui/safearea.menu"
}

// BUTTON LAYOUT MENU
#undef CHOICE_BUTTON_NAME
#define CHOICE_BUTTON_NAME		"buttons_"

#undef MENUDEF_NAME
#define MENUDEF_NAME			CONTROL_BUTTONS_NAME

#undef CHOICE_GROUP
#define CHOICE_GROUP			"buttons"

#define BUTTON_LAYOUT_CLEAR_ALL_FOCUS				\
		hide "controls_buttons_default";			\
		hide "controls_buttons_experimental";		\
		hide "controls_buttons_lefty";				\
		hide "controls_buttons_nomad";				\
		hide "controls_buttons_charlie";			\
		hide "controls_buttons_default_alt";		\
		hide "controls_buttons_experimental_alt";	\
		hide "controls_buttons_lefty_alt";			\
		hide "controls_buttons_nomad_alt";

#define BUTTON_LAYOUT_ACTION					\
		BUTTON_LAYOUT_CLEAR_ALL_FOCUS			\
		if( dvarString( gpad_buttonsConfig ) == "buttons_default" )				\
		{																		\
			show "controls_buttons_default";									\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_experimental" )	\
		{																		\
			show "controls_buttons_experimental";								\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_lefty" )			\
		{																		\
			show "controls_buttons_lefty";										\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_nomad" )			\
		{																		\
			show "controls_buttons_nomad";										\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_charlie" )			\
		{																		\
			show "controls_buttons_charlie";									\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_default_alt" )		\
		{																		\
			show "controls_buttons_default_alt";								\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_experimental_alt" )\
		{																		\
			show "controls_buttons_experimental_alt";							\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_lefty_alt" )		\
		{																		\
			show "controls_buttons_lefty_alt";									\
		}																		\
		elseif( dvarString( gpad_buttonsConfig ) == "buttons_nomad_alt" )		\
		{																		\
			show "controls_buttons_nomad_alt";									\
		}


menuDef 
{
	name			CONTROL_BUTTONS_NAME
	control			MENU_CONTROL_OPENER
#ifdef CONTROL_IN_GAME
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		4.8
	legacySplitScreenScale
	onOpen 	
	{
		setdvar cg_drawhud "0";
		setDvar ui_allow_controlschange "0";
		BUTTON_LAYOUT_ACTION
	}
	onclose	
	{
		setdvar cg_drawhud "1";
		setDvar ui_allow_controlschange "1";
		execNow "updategamerprofile";
		open OPTIONS_MENU_NAME;
	}
	onEsc 	
	{
		close CONTROL_BUTTONS_NAME;
		open OPTIONS_MENU_NAME;
	}

	//ingame background
	#include "ui_mp/ingamebg.inc"
	FRAME_TITLE_LEFT_DEFAULT( "@MENU_OPTIONS_BUTTON_LAYOUT_TITLE", 1 )
#else //#ifdef CONTROL_IN_GAME
	rect					0 0 640 480
	focuscolor				COLOR_FOCUSED
	style					WINDOW_STYLE_FILLED
	priority				MENU_PRI_ONTOP
	soundloop 				MENU_MUSIC
	openSlideSpeed			DEFAULT_SLIDE_IN_SPEED
	closeSlideSpeed			DEFAULT_SLIDE_OUT_SPEED
	openSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM
	closeSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM

	onOpen
	{
#ifndef SINGLE_PLAYER
		activateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_open;
		BUTTON_LAYOUT_ACTION
	}

	onESC
	{
#ifndef SINGLE_PLAYER
		deactivateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_close;

		execNow "updategamerprofile";
		FRAME_BACK_TO_FRAME_SLIDE_ACTION( CONTROL_BUTTONS_NAME, OPTIONS_MENU_NAME );
	}

#ifndef SINGLE_PLAYER
	FRAME_DEFAULT
#else //#ifndef SINGLE_PLAYER
	FRAME_SP_DEFAULT
#endif //#ifndef SINGLE_PLAYER

	FRAME_TITLE_DEFAULT( "@MENU_OPTIONS_CAPS" , 1 )
	FRAME_SUBTITLE_DEFAULT( "@MENU_BUTTON_LAYOUT_CAPS", 1 )

#endif //#ifdef CONTROL_IN_GAME

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_BUTTON_LAYOUT_TITLE" )
	#endif
	
	#define SETUP_ACTION2( pconfig ) \
		setDvar gpad_buttonsConfig pconfig \
		execNow "updategamerprofile"; \
		FRAME_BACK_TO_FRAME_SLIDE_ACTION( CONTROL_BUTTONS_NAME, OPTIONS_MENU_NAME );
		
#ifndef CONTROL_IN_GAME_SPLITSCREEN

	#undef BUTTON_X_START
	#undef BUTTON_Y_START
	#include "ui_mp/controls_buttons_set.menu"

	#define SETUP_FOCUS2( pnum ) \
		show "controls_"pnum;
	
	#define SETUP_UNFOCUS2( pnum ) \
		hide "controls_"pnum;
#else
	#define SETUP_FOCUS2( pnum ) ;
	#define SETUP_UNFOCUS2( pnum ) ;
#endif	//	#ifndef CONTROL_IN_GAME_SPLITSCREEN
		

#ifdef XENON
		FRAME_CHOICE_DVARSTRINGLIST_FOCUS_VIS(	1, "@MENU_BUTTON_LAYOUT_CAPS", gpad_buttonsConfig, 
												{ "@MENU_DEFAULT_CAPS" buttons_default "@MENU_TACTICAL_CAPS" buttons_experimental "@MENU_LEFTY_CAPS" buttons_lefty 
												"@MENU_NOMAD" buttons_nomad "@MENU_CHARLIE_CAPS" buttons_charlie }, 
												BUTTON_LAYOUT_ACTION, 
												CLEARUIHINT, 
												CLEARUIHINT, 
												1 )

#else //#ifdef XENON
		FRAME_CHOICE_DVARSTRINGLIST_FOCUS_VIS(	1, "@MENU_BUTTON_LAYOUT_CAPS", gpad_buttonsConfig, 
												{ "@MENU_DEFAULT_CAPS" buttons_default "@MENU_TACTICAL_CAPS" buttons_experimental "@MENU_LEFTY_CAPS" buttons_lefty 
												"@MENU_NOMAD" buttons_nomad "@MENU_CHARLIE_CAPS" buttons_charlie "@PLATFORM_DEFAULT_ALT_CAPS" buttons_default_alt
												"@PLATFORM_TACTICAL_ALT_CAPS" buttons_experimental_alt "@PLATFORM_LEFTY_ALT_CAPS" buttons_lefty_alt "@PLATFORM_NOMAD_ALT_CAPS" buttons_nomad_alt }, 
												BUTTON_LAYOUT_ACTION, 
												CLEARUIHINT, 
												CLEARUIHINT, 
												1 )
#endif //#ifdef XENON
		
		#undef	A_BUTTON_OFFSET_X
		#define A_BUTTON_OFFSET_X			3

#ifdef CONTROL_IN_GAME
	PREPROC_TEXT_DRAW_VIS( CHOICE_X_START -17 70 17 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM, 0 0, "@PLATFORM_BACK", TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, 1 1 1 1, 1 )
#else //#ifdef CONTROL_IN_GAME
	FRAME_BACK_BUTTON_DEFAULT
#endif //#ifdef CONTROL_IN_GAME

	#include "ui/safearea.menu"
}


// VOLUME MENU
#undef CHOICE_BUTTON_NAME
#define CHOICE_BUTTON_NAME		"volume_"

#undef MENUDEF_NAME
#define MENUDEF_NAME			CONTROL_VOLUME_NAME

#undef CHOICE_GROUP
#define CHOICE_GROUP			"volume"

menuDef 
{
	name			CONTROL_VOLUME_NAME
	control			MENU_CONTROL_OPENER
#ifdef CONTROL_IN_GAME
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		BLUR_AMOUNT
	legacySplitScreenScale
	onclose	
	{
		setdvar cg_drawhud "1";
		setDvar ui_allow_controlschange "1";
	}
	onOpen 	
	{
		setdvar cg_drawhud "0";
		setDvar ui_allow_controlschange "0";
	}
	onEsc 
	{	
		execNow "updategamerprofile";
		close CONTROL_VOLUME_NAME;	
		open OPTIONS_MENU_NAME;
	}

	//ingame background
	#include "ui_mp/ingamebg.inc"
	FRAME_TITLE_LEFT_DEFAULT( "@MENU_OPTIONS_AUDIO_SETTINGS_TITLE", 1 )
#else //#ifdef CONTROL_IN_GAME

	rect					0 0 640 480
	focuscolor				COLOR_FOCUSED
	style					WINDOW_STYLE_FILLED
	priority				MENU_PRI_ONTOP
	soundloop 				MENU_MUSIC
	openSlideSpeed			DEFAULT_SLIDE_IN_SPEED
	closeSlideSpeed			DEFAULT_SLIDE_OUT_SPEED
	openSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM
	closeSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM

	onOpen
	{
#ifndef SINGLE_PLAYER
		activateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_open;
		execnow ui_animate CONTROL_VOLUME_NAME * highlightOff 0;
	}

	onESC
	{
#ifndef SINGLE_PLAYER
		deactivateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_close;

		execNow "updategamerprofile";
		FRAME_BACK_TO_FRAME_SLIDE_ACTION( CONTROL_VOLUME_NAME, OPTIONS_MENU_NAME );
	}

#ifndef SINGLE_PLAYER
	FRAME_DEFAULT
#else //#ifndef SINGLE_PLAYER
	FRAME_SP_DEFAULT
#endif //#ifndef SINGLE_PLAYER

	FRAME_TITLE_DEFAULT( "@MENU_OPTIONS_CAPS" , 1 )
	FRAME_SUBTITLE_DEFAULT( "@MENU_AUDIO_SETTINGS_CAPS", 1 )
#endif //#ifdef CONTROL_IN_GAME
	
	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_AUDIO_SETTINGS_CAPS" )
	#endif

	#undef	A_BUTTON_OFFSET_X
	#define A_BUTTON_OFFSET_X		100000

	#undef	CHOICE_ACTION_SOUND
	#define	CHOICE_ACTION_SOUND		"uin_navigation_slider"

	#undef	CHOICE_SIZE_X
	#define CHOICE_SIZE_X			375
	
	FRAME_DVARSLIDER_FOCUS_VIS(	1, "@MENU_VOICE_VOLUME_CAPS",		snd_menu_voice,			1.0, 0.0, 1.0, 
								;, 
								SET_HINT_TEXT( "@MENU_VOICE_VOLUME_DESC" ),
								CLEARUIHINT,
								1 )
	FRAME_DVARSLIDER_FOCUS_VIS( 2, "@MENU_MUSIC_VOLUME_CAPS",		snd_menu_music,			1.0, 0.0, 1.0, 
								;, 
								SET_HINT_TEXT( "@MENU_MUSIC_VOLUME_DESC" ),
								CLEARUIHINT,
								1 )
	FRAME_DVARSLIDER_FOCUS_VIS( 3, "@MENU_SFX_VOLUME_CAPS",			snd_menu_sfx,			1.0, 0.0, 1.0, 
								;, 
								SET_HINT_TEXT( "@MENU_SFX_VOLUME_DESC" ),
								CLEARUIHINT,
								1 )
	FRAME_DVARSLIDER_FOCUS_VIS( 4, "@MENU_MASTER_VOLUME_CAPS",		snd_menu_master,		1.0, 0.0, 1.0, 
								;, 
								SET_HINT_TEXT( "@MENU_MASTER_VOLUME_DESC" ),
								CLEARUIHINT,
								1 )
	FRAME_DVARSLIDER_FOCUS_VIS( 5, "@MENU_CINEMATICS_VOLUME_CAPS",	snd_menu_cinematic,		1.0, 0.0, 1.0,
								;, 
								SET_HINT_TEXT( "@MENU_CINEMATICS_VOLUME_DESC" ),
								CLEARUIHINT,
								!dvarBool( ui_multiplayer ) )

	//#ifdef PS3
	// DDO - PS3 doesn't have ps3_voiceSpeakerGain anymore anyway #if USING (SONY_LIBVOICE)
	//FRAME_DVARSLIDER_FOCUS_VIS( 6, "@MENU_VOIP_VOLUME_CAPS",		ps3_voiceSpeakerGain,	1.0, 0.0, 1.0,
								//;, 
								//SET_HINT_TEXT( "@MENU_VOIP_VOLUME_DESC" ),
								//CLEARUIHINT,
								//1 )
	//#else //#ifdef PS3
	itemDef
	{
			name	volume_6
			type	ITEM_TYPE_BUTTON_NO_TEXT
			rect	0 0 0 0
			visible	0
			decoration
			state
			{
				name		"highlightOff"
			}
			state
			{
				name		"disabled"
			}
	}
	//#endif //#ifdef PS3

	FRAME_CHOICE_DVARFLOATLIST_FOCUS_VIS(	7, "@MENU_LISTENING_LEVEL_CAPS", snd_menu_listen_level,
											{ "@MENU_QUIET_CAPS" 0 "@MENU_LOUD_CAPS" 1 }, 
											;, 
											CLEARUIHINT,
											CLEARUIHINT,
											1 )

	FRAME_CHOICE_DVARFLOATLIST_FOCUS_VIS(	8, "@MENU_SPEAKER_SETUP_CAPS", snd_menu_speaker_setup,
											{ "@MENU_TV_CAPS" 0 "@MENU_THEATRE_CAPS" 1 "@MENU_HEADPHONES_CAPS" 2 }, 
											;, 
											CLEARUIHINT,
											CLEARUIHINT,
											1 )

	#undef A_BUTTON_OFFSET_X
	#define A_BUTTON_OFFSET_X 3

		#ifndef HINT_Y_OFFSET
			#define HINT_Y_OFFSET				( Select( IsInGame(), ( -8 - CHOICE_SIZE_Y ), -8 ) )
		#endif
		#define HINT_WIDTH						( FRAME_DEFAULT_WIDTH - 30 )
		// Normal hint text
		HINT_TEXT_ADV_ALL(	17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, dvarString( ui_hint_text ),			1 1 1 1, ( dvarBool( ui_show_arrow ) ),				; )

		// Listening level hint text
		#define LISTENING_SELECTED				( localVarInt( ui_highlight ) == 7 )

		#define LISTENING_SETTING( setting )	( dvarInt( snd_menu_listen_level ) == setting )
		#define LISTENING_QUIET					LISTENING_SETTING( 0 )
		#define LISTENING_LOUD					LISTENING_SETTING( 1 )
		
		HINT_TEXT_ADV_ALL( 17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, "@MENU_LISTENING_LEVEL_QUIET_DESC",	1 1 1 1, ( LISTENING_SELECTED && LISTENING_QUIET ),	; )
		HINT_TEXT_ADV_ALL( 17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, "@MENU_LISTENING_LEVEL_LOUD_DESC",	1 1 1 1, ( LISTENING_SELECTED && LISTENING_LOUD ),	; )

		// Speaker setup hint text
		#define SPEAKER_SELECTED				( localVarInt( ui_highlight ) == 8 )
		
		#define SPEAKER_SETTING( setting )		( dvarInt( snd_menu_speaker_setup ) == setting )
		#define SPEAKER_TV						SPEAKER_SETTING( 0 )
		#define SPEAKER_THEATER					SPEAKER_SETTING( 1 )
		#define SPEAKER_HEADPHONES				SPEAKER_SETTING( 2 )
		
		HINT_TEXT_ADV_ALL( 17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, "@MENU_SPEAKER_SETUP_TV_DESC",		 1 1 1 1, ( SPEAKER_SELECTED && SPEAKER_TV ),			; )
		HINT_TEXT_ADV_ALL( 17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, "@MENU_SPEAKER_SETUP_THEATER_DESC",	 1 1 1 1, ( SPEAKER_SELECTED && SPEAKER_THEATER ),		; )
		HINT_TEXT_ADV_ALL( 17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, "@MENU_SPEAKER_SETUP_HEADPHONES_DESC", 1 1 1 1, ( SPEAKER_SELECTED && SPEAKER_HEADPHONES ),	; )

		// TV
		#define	SOUND_ON_ALPHA					0.8
		#define SOUND_OFF_ALPHA					0.3
		#define TV_COLOR						1 1 1 SOUND_ON_ALPHA
		#define TV_HEIGHT						60
		#define TV_WIDTH						100
		#define TV_X_START						( CHOICE_X_START + ( CHOICE_SIZE_X / 2 ) - ( TV_WIDTH / 2 ) )
		#define TV_Y_START						( CHOICE_Y( 10 ) -8 )

		PREPROC_SHADER_DRAW_VIS_EX( TV_X_START TV_Y_START TV_WIDTH TV_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN,
									"menu_mp_sound_tv", TV_COLOR,
									1, ; )
		

		// TV Sound lines
		#define LINES_COLOR						NEW_FRAME_ORANGE_RGB 1
		#define LINES1_HEIGHT					25
		#define LINES2_HEIGHT					35
		#define LINES_WIDTH						15
		#define TV_LINES1_LEFT_X_START			( TV_X_START - LINES_WIDTH )
		#define TV_LINES2_LEFT_X_START			( TV_LINES1_LEFT_X_START - ( LINES_WIDTH / 2 ) + 2 )
		#define TV_LINES1_RIGHT_X_START			( TV_X_START + TV_WIDTH )
		#define TV_LINES2_RIGHT_X_START			( TV_LINES1_RIGHT_X_START + ( LINES_WIDTH / 2 ) - 2 )
		#define TV_LINES1_Y_START				( TV_Y_START + ( TV_HEIGHT / 2 ) - ( LINES1_HEIGHT / 2 ) )
		#define TV_LINES2_Y_START				( TV_LINES1_Y_START - ( ( LINES2_HEIGHT - LINES1_HEIGHT ) / 2 ) )

		PREPROC_SHADER_DRAW_VIS_EX(	TV_LINES1_LEFT_X_START TV_LINES1_Y_START LINES_WIDTH LINES1_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines1", LINES_COLOR, 
									when( SPEAKER_TV );, 
									; )
		PREPROC_SHADER_DRAW_VIS_EX(	TV_LINES2_LEFT_X_START TV_LINES2_Y_START LINES_WIDTH LINES2_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines2", LINES_COLOR, 
									when( LISTENING_LOUD && SPEAKER_TV );, 
									; )
		
		PREPROC_SHADER_DRAW_VIS_EX(	TV_LINES1_RIGHT_X_START TV_LINES1_Y_START (-LINES_WIDTH) LINES1_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines1", LINES_COLOR, 
									when( SPEAKER_TV );, 
									; )
		PREPROC_SHADER_DRAW_VIS_EX(	TV_LINES2_RIGHT_X_START TV_LINES2_Y_START (-LINES_WIDTH) LINES2_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines2", LINES_COLOR, 
									when( LISTENING_LOUD && SPEAKER_TV );, 
									; )


		// Cables
		#define CABLES_Y_START					( TV_Y_START + TV_HEIGHT - 20 )
		#define CABLES_HEIGHT					TV_HEIGHT
		PREPROC_SHADER_DRAW_VIS_EX( TV_X_START CABLES_Y_START TV_WIDTH CABLES_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN,
									"menu_mp_sound_cables",	TV_COLOR,
									1,
									exp forecolor A ( Select( SPEAKER_THEATER, SOUND_OFF_ALPHA, SOUND_ON_ALPHA ) ) )


		// Speakers
		#define SPEAKER_HEIGHT					50
		#define SPEAKER_WIDTH					30
		#define SPEAKER_LEFT_X_START			( TV_X_START - SPEAKER_WIDTH + 1 )
		#define SPEAKER_RIGHT_X_START			( TV_X_START + TV_WIDTH - 1 )
		#define SPEAKER_Y_START					( CABLES_Y_START + CABLES_HEIGHT - SPEAKER_HEIGHT )

		PREPROC_SHADER_DRAW_VIS_EX( SPEAKER_LEFT_X_START SPEAKER_Y_START SPEAKER_WIDTH SPEAKER_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN,
									"menu_mp_sound_speaker", TV_COLOR, 
									1, 
									exp forecolor A ( Select( SPEAKER_THEATER, SOUND_ON_ALPHA, SOUND_OFF_ALPHA ) ) )
		
		PREPROC_SHADER_DRAW_VIS_EX( SPEAKER_RIGHT_X_START SPEAKER_Y_START (-SPEAKER_WIDTH) SPEAKER_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN,
									"menu_mp_sound_speaker", TV_COLOR, 
									1, 
									exp forecolor A ( Select( SPEAKER_THEATER, SOUND_ON_ALPHA, SOUND_OFF_ALPHA ) ) )


		// Speakers sound lines
		#define SPEAKER_LINES1_LEFT_X_START		( SPEAKER_LEFT_X_START - LINES_WIDTH )
		#define SPEAKER_LINES2_LEFT_X_START		( SPEAKER_LINES1_LEFT_X_START - ( LINES_WIDTH / 2 ) + 2 )
		#define SPEAKER_LINES1_RIGHT_X_START	( SPEAKER_RIGHT_X_START + SPEAKER_WIDTH )
		#define SPEAKER_LINES2_RIGHT_X_START	( SPEAKER_LINES1_RIGHT_X_START + ( LINES_WIDTH / 2 ) - 2 )
		#define SPEAKER_LINES1_Y_START			( SPEAKER_Y_START + ( SPEAKER_HEIGHT / 2 ) - ( LINES1_HEIGHT / 2 ) )
		#define SPEAKER_LINES2_Y_START			( SPEAKER_LINES1_Y_START - ( ( LINES2_HEIGHT - LINES1_HEIGHT ) / 2 ) )

		PREPROC_SHADER_DRAW_VIS_EX(	SPEAKER_LINES1_LEFT_X_START SPEAKER_LINES1_Y_START LINES_WIDTH LINES1_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines1", LINES_COLOR, 
									when( SPEAKER_THEATER );,
									; )
		PREPROC_SHADER_DRAW_VIS_EX(	SPEAKER_LINES2_LEFT_X_START SPEAKER_LINES2_Y_START LINES_WIDTH LINES2_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines2", LINES_COLOR, 
									when( LISTENING_LOUD && SPEAKER_THEATER );, 
									; )
		
		PREPROC_SHADER_DRAW_VIS_EX(	SPEAKER_LINES1_RIGHT_X_START SPEAKER_LINES1_Y_START (-LINES_WIDTH) LINES1_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines1", LINES_COLOR, 
									when( SPEAKER_THEATER );, 
									; )
		PREPROC_SHADER_DRAW_VIS_EX(	SPEAKER_LINES2_RIGHT_X_START SPEAKER_LINES2_Y_START (-LINES_WIDTH) LINES2_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines2", LINES_COLOR, 
									when( LISTENING_LOUD && SPEAKER_THEATER );, 
									; )


		// Headphones
		#define HEADPHONES_HEIGHT				40
		#define HEADPHONES_WIDTH				40
		#define HEADPHONES_X_START				( TV_X_START + ( TV_WIDTH / 2 ) - ( HEADPHONES_WIDTH / 2 ) )
		#define HEADPHONES_Y_START				( CABLES_Y_START + HEADPHONES_HEIGHT - 8 )//( CABLES_Y_START + CABLES_HEIGHT )

		PREPROC_SHADER_DRAW_VIS_EX( HEADPHONES_X_START HEADPHONES_Y_START HEADPHONES_WIDTH HEADPHONES_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN,
									"menu_mp_sound_headphones", TV_COLOR, 
									1, 
									exp forecolor A ( Select( SPEAKER_HEADPHONES, SOUND_ON_ALPHA, SOUND_OFF_ALPHA ) ) )
		

		#define HEADPHONES_LINES1_LEFT_X_START			( HEADPHONES_X_START - LINES_WIDTH )
		#define HEADPHONES_LINES2_LEFT_X_START			( HEADPHONES_LINES1_LEFT_X_START - ( LINES_WIDTH / 2 ) + 2 )
		#define HEADPHONES_LINES1_RIGHT_X_START			( HEADPHONES_X_START + HEADPHONES_WIDTH )
		#define HEADPHONES_LINES2_RIGHT_X_START			( HEADPHONES_LINES1_RIGHT_X_START + ( LINES_WIDTH / 2 ) - 2 )
		#define HEADPHONES_LINES1_Y_START				( HEADPHONES_Y_START + ( HEADPHONES_HEIGHT / 2 ) - ( LINES1_HEIGHT / 2 ) )
		#define HEADPHONES_LINES2_Y_START				( HEADPHONES_LINES1_Y_START - ( ( LINES2_HEIGHT - LINES1_HEIGHT ) / 2 ) )

		PREPROC_SHADER_DRAW_VIS_EX(	HEADPHONES_LINES1_LEFT_X_START HEADPHONES_LINES1_Y_START LINES_WIDTH LINES1_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines1", LINES_COLOR, 
									when( SPEAKER_HEADPHONES );, 
									; )
		PREPROC_SHADER_DRAW_VIS_EX(	HEADPHONES_LINES2_LEFT_X_START HEADPHONES_LINES2_Y_START LINES_WIDTH LINES2_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines2", LINES_COLOR, 
									when( LISTENING_LOUD && SPEAKER_HEADPHONES );, 
									; )
		
		PREPROC_SHADER_DRAW_VIS_EX(	HEADPHONES_LINES1_RIGHT_X_START HEADPHONES_LINES1_Y_START (-LINES_WIDTH) LINES1_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines1", LINES_COLOR, 
									when( SPEAKER_HEADPHONES );, 
									; )
		PREPROC_SHADER_DRAW_VIS_EX(	HEADPHONES_LINES2_RIGHT_X_START HEADPHONES_LINES2_Y_START (-LINES_WIDTH) LINES2_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 
									"menu_mp_sound_lines2", LINES_COLOR, 
									when( LISTENING_LOUD && SPEAKER_HEADPHONES );, 
									; )

#ifdef CONTROL_IN_GAME
	PREPROC_TEXT_DRAW_VIS( CHOICE_X_START -17 70 17 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM, 0 0, "@PLATFORM_BACK", TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, 1 1 1 1, 1 )
#else //#ifdef CONTROL_IN_GAME
	FRAME_BACK_BUTTON_DEFAULT
#endif //#ifdef CONTROL_IN_GAME
	
	#include "ui/safearea.menu"
}


// BRIGHTNESS MENU
menuDef 
{
	name			CONTROL_BRIGHTNESS_NAME
	control			MENU_CONTROL_OPENER
#ifdef CONTROL_IN_GAME
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		BLUR_AMOUNT
	legacySplitScreenScale
	onclose	
	{
		execNow "updategamerprofile";
		setdvar cg_drawhud "1";
		setDvar ui_allow_controlschange "1";
		open OPTIONS_MENU_NAME;
	}
	execkeyint BUTTON_START
	{
		execNow "updategamerprofile";
		close CONTROL_BRIGHTNESS_NAME;
	}
	onOpen
	{
		setdvar cg_drawhud "0";
		setDvar ui_allow_controlschange "0";
	}
	onEsc
	{	
		close CONTROL_BRIGHTNESS_NAME;
		execNow "updategamerprofile";
		#ifndef CONTROL_IN_GAME_SPLITSCREEN
			open OPTIONS_MENU_NAME;
		#endif //#ifndef CONTROL_IN_GAME_SPLITSCREEN
	}

	//ingame background
	#include "ui_mp/ingamebg.inc"
	FRAME_TITLE_LEFT_DEFAULT( "@MENU_OPTIONS_BRIGHTNESS_TITLE", 1 )
#else //#ifdef CONTROL_IN_GAME
	rect					0 0 640 480
	focuscolor				COLOR_FOCUSED
	style					WINDOW_STYLE_FILLED
	priority				MENU_PRI_ONTOP
	soundloop 				MENU_MUSIC
	openSlideSpeed			DEFAULT_SLIDE_IN_SPEED
	closeSlideSpeed			DEFAULT_SLIDE_OUT_SPEED
	openSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM
	closeSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM

	onOpen
	{
#ifndef SINGLE_PLAYER
		activateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_open;
	}

	onESC
	{
#ifndef SINGLE_PLAYER
		deactivateBlur;
#endif //#ifndef SINGLE_PLAYER
		play uin_navigation_menu_lg_close;

		execNow "updategamerprofile";
		FRAME_BACK_TO_FRAME_SLIDE_ACTION( CONTROL_BRIGHTNESS_NAME, OPTIONS_MENU_NAME );
	}

#ifndef SINGLE_PLAYER
	FRAME_DEFAULT
#else //#ifndef SINGLE_PLAYER
	FRAME_SP_DEFAULT
#endif //#ifndef SINGLE_PLAYER

	FRAME_TITLE_DEFAULT( "@MENU_OPTIONS_CAPS" , 1 )
	FRAME_SUBTITLE_DEFAULT( "@MENU_BRIGHTNESS_CAPS", 1 )

#endif //#ifdef CONTROL_IN_GAME

#ifdef CONTROL_IN_GAME
	PREPROC_TEXT_DRAW_VIS( CHOICE_X_START -17 70 17 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM, 0 0, "@PLATFORM_BACK", TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, 1 1 1 1, 1 )
#else //#ifdef CONTROL_IN_GAME
	FRAME_BACK_BUTTON_DEFAULT
#endif //#ifdef CONTROL_IN_GAME
	
	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_BRIGHTNESS_TITLE" )
	#endif

	#define CHOICE_BG_BOX( itemIndex, blackLevel, visArg ) \
		itemDef \
		{ \
			style			WINDOW_STYLE_SHADER \
			rect			CHOICE_ORIGIN( itemIndex ) (CHOICE_SIZE_X-(CHOICE_SIZE_Y/4)) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
			background		"white" \
			forecolor		blackLevel blackLevel blackLevel 1 \
			visible			visArg \
			decoration \
		}

	#undef CHOICE_SIZE_X
	#define CHOICE_SIZE_X			353//300
	
	#undef A_BUTTON_OFFSET_X
	#define A_BUTTON_OFFSET_X		100000

	#undef	CHOICE_ACTION_SOUND
	#define	CHOICE_ACTION_SOUND		"uin_navigation_slider"
	
	FRAME_DVARSLIDER_VIS( 1, "@MENU_BRIGHTNESS_CAPS", r_gamma,  1.0, 0.5, 1.50, ;, 1 )

	HINT_TEXT_ADV_ALL( 17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, "@MENU_BRIGHTNESS_DESC1",	1 1 1 1, 1,	; )

	#undef	CHOICE_ACTION_SOUND
	#define	CHOICE_ACTION_SOUND		"uin_navigation_click"

	#undef A_BUTTON_OFFSET_X
	#define A_BUTTON_OFFSET_X		3

	#undef CHOICE_X_START
	#define CHOICE_X_START			(0-(CHOICE_SIZE_X/2))

	#undef CHOICE_SIZE_X
	#define CHOICE_SIZE_X			300

//#ifndef PS3
	#undef CHOICE_HORIZONTAL_ALIGN
	#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER

	#undef CHOICE_TEXTALIGN
	#define	CHOICE_TEXTALIGN		ITEM_ALIGN_MIDDLE_CENTER

	#undef CHOICE_SIZE_Y
	#define CHOICE_SIZE_Y			60

	#undef CHOICE_Y_SPACING
	#define CHOICE_Y_SPACING		60

	#undef CHOICE_TEXT_OFFSET_X
	#define CHOICE_TEXT_OFFSET_X	0

#ifdef PS3
	CHOICE_BG_BOX( 2, 0.020, 1 );
#else
	CHOICE_BG_BOX( 2, 0.062, 1 );
#endif
	CHOICE_BG_BOX( 3, 0.125, 1 );
	CHOICE_BG_BOX( 4, 0.250, 1 );

	CHOICE_CAPTION_COLOR_VIS( 2, "@MENU_BRIGHTNESS_NOT_VISIBLE", 0 0 0 1, 1 );
	CHOICE_CAPTION_COLOR_VIS( 3, "@MENU_BRIGHTNESS_BARELY_VISIBLE", 0 0 0 1, 1 );
	CHOICE_CAPTION_COLOR_VIS( 4, "@MENU_BRIGHTNESS_EASILY_VISIBLE", 0 0 0 1, 1 );
//#endif

	#include "ui/safearea.menu"
}

#undef CHOICE_SEP_OFFSET_Y
#define CHOICE_SEP_OFFSET_Y		-2

#undef CHOICE_SEP_1
#define CHOICE_SEP_1			3

#include "ui_mp/popupstyle.inc"
#include "ui/choices_setup_popmenu.menu"

#undef CHOICE_TEXTALIGN
#define	CHOICE_TEXTALIGN		ITEM_ALIGN_MIDDLE_LEFT

#undef CHOICE_TEXT_OFFSET_X
#define CHOICE_TEXT_OFFSET_X	CHOICE_SIZE_Y

#ifdef SINGLE_PLAYER
#undef POPUP_BACKCOLOR
#define POPUP_BACKCOLOR			0.2 0.2 0.2 0.9
#endif //#ifdef SINGLE_PLAYER

#ifdef SINGLE_PLAYER

	#define OPEN_MATURE_DISABLE \
			setfocus mature_content_disable_warning_2; \
			execondvarstringvalue cg_mature 0 "set cg_mature 1; set cg_blood 1; closemenu mature_content_disable_warning"; \

		menuDef
		{
			SYSTEM_POPUP_SETUP_VIS( mature_content_disable_warning, OPEN_MATURE_DISABLE, ;, 1 )
			SYSTEM_POPUP_TITLE_VIS( "@MENU_GRAPHIC_CONTENT_CAPS", 1 )
			SYSTEM_POPUP_SUBTITLE_VIS( "@MENU_WARNING_DISABLE_MATURE_CONTENT", 1 );
			
			#define DISABLE_CONTENT			\
					close self;				\
					exec "set cg_blood 0";	\
					exec "set cg_mature 0";

			FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_YES_CAPS",	DISABLE_CONTENT,	1, ; )
			FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MENU_NO_CAPS",		close self,			1, name mature_content_disable_warning_2 )
		}

#endif //#ifdef SINGLE_PLAYER

//3D OPTION ON/OFF MENUS
#undef	POPUP_BUTTON_COUNT
#define	POPUP_BUTTON_COUNT		2

		menuDef
		{
			SYSTEM_POPUP_SETUP_VIS( options_3d_on, setfocus cancel_button, ;, 1 )
			SYSTEM_POPUP_TITLE_VIS( "@PLATFORM_3D_OPTION_TITLE_ON", 1 )

			FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_CONTINUE_CAPS", exec "toggle r_stereo3DOn"; close self, 1, ; )
			FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MENU_CANCEL_CAPS", close self, 1, name cancel_button; )
		}

		menuDef
		{
			SYSTEM_POPUP_SETUP_VIS( options_3d_off, setfocus cancel_button, ;, 1 )
			SYSTEM_POPUP_TITLE_VIS( "@PLATFORM_3D_OPTION_TITLE_OFF", 1 )
			
			FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_CONTINUE_CAPS", exec "toggle r_stereo3DOn"; close self, 1, ; )
			FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MENU_CANCEL_CAPS", close self, 1, name cancel_button; )
		}


#ifndef CONTROL_IN_GAME

#undef CHOICE_X_START
#define CHOICE_X_START				-270

#undef	CHOICE_Y_START
#define CHOICE_Y_START				FRAME_CHOICE_Y_START

#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X				375

#undef CHOICE_DVAR_OFFSET_X
#define CHOICE_DVAR_OFFSET_X		(CHOICE_SIZE_X-160)

#undef MEDIUM_GRAY
#define MEDIUM_GRAY		0.4 0.4 0.4 0.7

#undef CHOICE_BUTTON_NAME
#define CHOICE_BUTTON_NAME			"options_3d_"

#undef MENUDEF_NAME
#define MENUDEF_NAME				CONTROL_3D_OPTION_NAME

#undef CHOICE_GROUP
#define CHOICE_GROUP				"options_3d"

	menuDef
	{
		name					CONTROL_3D_OPTION_NAME
		rect					0 0 640 480
		focuscolor				COLOR_FOCUSED
		style					WINDOW_STYLE_FILLED
		soundloop 				MENU_MUSIC
		openSlideSpeed			DEFAULT_SLIDE_IN_SPEED
		closeSlideSpeed			DEFAULT_SLIDE_OUT_SPEED
		openSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM
		closeSlideDirection		MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM

		onOpen
		{
#ifndef SINGLE_PLAYER
			activateBlur;
#endif //#ifndef SINGLE_PLAYER
			play uin_navigation_menu_lg_open;
		}

		onESC
		{
#ifndef SINGLE_PLAYER
			deactivateBlur;
#endif //#ifndef SINGLE_PLAYER
			play uin_navigation_menu_lg_close;
			execnow "updategamerprofile";

			FRAME_BACK_TO_FRAME_SLIDE_ACTION( CONTROL_3D_OPTION_NAME, options );
		}
		onClose	{ }

#ifndef SINGLE_PLAYER
		FRAME_DEFAULT
#else //#ifndef SINGLE_PLAYER
		FRAME_SP_DEFAULT
#endif //#ifndef SINGLE_PLAYER

		FRAME_TITLE_DEFAULT( "@MENU_STEREO_3D_SETTINGS_CAPS", 1 )

		#define TITLE_NAME_X				CHOICE_X_START
		#define TITLE_NAME_Y				CHOICE_Y_START
		#define TITLE_NAME_SIZE				200 20

		#define WARNING_DESC_X				CHOICE_X_START
		#define WARNING_DESC_Y				(TITLE_NAME_Y+25)
		#define WARNING_DESC_SIZE			(FRAME_DEFAULT_WIDTH-25) (FRAME_DEFAULT_HEIGHT)
		#define WARNING_DESC_TEXTSCALE		0.28

		PREPROC_TEXT_DRAW( TITLE_NAME_X TITLE_NAME_Y TITLE_NAME_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
						  "@PLATFORM_3D_WARNING_TITLE_CAPS", 
						  TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_TOP_LEFT, WHITE )

		PREPROC_TEXT_DRAW_ALL(	WARNING_DESC_X WARNING_DESC_Y WARNING_DESC_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
								"@PLATFORM_3D_WARNING_TEXT",
								WARNING_DESC_TEXTSCALE, 0, 0, ITEM_ALIGN_TOP_LEFT, WHITE, 
								UI_FONT_SMALL, ITEM_TEXTSTYLE_NORMAL, 1, autowrapped )

		#define STEREO_3D_ON_OFF_ACTION				\
				if( dvarInt( r_stereo3DOn ) == 0 )	\
				{									\
					open options_3d_on;				\
				}									\
				else								\
				{									\
					open options_3d_off;			\
				}

		FRAME_CHOICE_DVARSTRINGLIST_FOCUS_VIS_EX(	14, "@MENU_STEREO_3D_CAPS", r_stereo3DOn,
													{ "@MENU_STEREO_3D_OFF" 0 "@MENU_STEREO_3D_ON" 1 }, 
													STEREO_3D_ON_OFF_ACTION, 
													SET_HINT_TEXT( "@MENU_STEREO_3D_DESC" ),
													CLEARUIHINT, 
													1, ;, actionOnEnterPressOnly )

		#undef	A_BUTTON_OFFSET_X
		#define A_BUTTON_OFFSET_X				100000

		FRAME_CHOICE_DVARFLOATLIST_FOCUS_VIS(	15, "@MENU_DRAW_CROSSHAIR", cg_drawCrosshair3D,
												{ "@MENU_STEREO_3D_OFF" 0 "@MENU_STEREO_3D_ON" 1},
												;, 
												SET_HINT_TEXT( "@MENU_DRAW_CROSSHAIR_DESC" ),
												CLEARUIHINT,
												( ( dvarInt( r_stereo3DOn ) == 1 ) && dvarbool( r_stereo3DAvailable ) ) )
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	15, "@MENU_DRAW_CROSSHAIR", 
											SET_HINT_TEXT( "@MENU_DRAW_CROSSHAIR_DESC" ),
											CLEARUIHINT,
											!( ( dvarInt( r_stereo3DOn ) == 1 ) && dvarbool( r_stereo3DAvailable ) ), ; )

		#undef A_BUTTON_OFFSET_X
		#define A_BUTTON_OFFSET_X		3

		HINT_TEXT_ADV_ALL( 17, CHOICE_X_START, HINT_Y_OFFSET, HINT_WIDTH, dvarString( ui_hint_text ), 1 1 1 1, dvarBool( ui_show_arrow ), ; )

		// Back button
		FRAME_BACK_BUTTON_DEFAULT

		#include "ui/safearea.menu"
	}
#endif //#ifndef CONTROL_IN_GAME

#endif //#ifndef SPLITSCREEN_ENABLED
