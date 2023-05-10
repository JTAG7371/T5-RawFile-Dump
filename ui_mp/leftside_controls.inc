#undef		OPTIONS_STYLE
#undef		STYLE2_NOPOSITION
#define		OPTIONS_LEFT
#include "ui_mp/menustyle.inc"
#include "ui_mp/newframe.inc"
#undef		OPTIONS_LEFT

#undef CHOICE_TEXTSTYLE
#undef CHOICE_TEXTSIZE
#define CHOICE_TEXTSTYLE		ITEM_TEXTSTYLE_NORMAL
#define CHOICE_TEXTSIZE			TEXTSIZE_DEFAULT

#ifndef BACKGROUND_BLACK_LETTERBOX_BLURWORLD_VIS
#include "ui/overlaybg.inc"
#endif

//#ifndef FRAME_TITLE_DEFAULT
//#include "ui/frame.inc"
//#endif

#undef	LEFTSIDE_CONTROLS_HEIGHT
#undef	LEFTSIDE_CONTROLS_WIDTH
#define LEFTSIDE_CONTROLS_HEIGHT	332
#define LEFTSIDE_CONTROLS_WIDTH		LEFTSIDE_CONTROLS_HEIGHT * FRAME_ASPECT_RATIO

#include "ui_mp/leftside_tabs.inc"

// Need draw the background in beteen outer and inner frame
#undef	FRAME_TAB_BG
#define FRAME_TAB_BG \
	OPTIONS_TAB_BG( OPTIONS_TAB_2_X, when( !IsInGame() && dvarBool( ui_multiplayer ) ) )

#undef	FRAME_TAB_BG_INGAME
#define FRAME_TAB_BG_INGAME \
	OPTIONS_TAB_BG( OPTIONS_TAB_2_X, when( IsInGame() || !dvarBool( ui_multiplayer ) ) )																															\

#undef FRAME_TAB_BG

NEW_FRAME( NEW_FRAME_DEFAULT_WIDTH, NEW_FRAME_DEFAULT_HEIGHT )
NEW_FRAME_TITLE( NEW_FRAME_DEFAULT_WIDTH, NEW_FRAME_DEFAULT_HEIGHT, "@MENU_CONTROLS_CAPS", 1 )

#undef	BACK_OPEN
#define BACK_OPEN if(menuisopen(blackout_3d_tv)){close blackout_3d_tv;}; exec "wait";
#ifdef PC
NEW_FRAME_BACK_BUTTON_ACTION( NEW_FRAME_DEFAULT_WIDTH, NEW_FRAME_DEFAULT_HEIGHT, BACK_OPEN; close self; )
#else //#ifdef PC
#include "ui_mp/navcontrols.inc"
#endif //#ifdef PC

#undef	CHOICE_X_START
#undef	CHOICE_Y_START
#undef	CHOICE_HORIZONTAL_ALIGN
#undef	CHOICE_VERTICAL_ALIGN
#undef	CHOICE_DVAR_EXTRA_WIDTH

#define CHOICE_HORIZONTAL_ALIGN		HORIZONTAL_ALIGN_CENTER
#define CHOICE_VERTICAL_ALIGN		VERTICAL_ALIGN_CENTER
#define CHOICE_X_START				((-LEFTSIDE_CONTROLS_WIDTH/2) - 16)
#define CHOICE_Y_START				((-LEFTSIDE_CONTROLS_HEIGHT/2) + 32)
#define CHOICE_DVAR_EXTRA_WIDTH		120

fullScreen		0
rect			0 0 640 480	HORIZONTAL_ALIGN_FULLSCREEN

OPTIONS_TABS( OP_TAB_CONTROLS )

#undef		CHOICE_SIZE_X
#define CHOICE_SIZE_X			170


// Disable all options if gpad is enabled
FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_LOOK_CAPS",					LOCAL_CLOSE_ALL close self; open options_look,									( !dvarbool( gpad_enabled ) ),		; )
FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MENU_MOVE_CAPS",					LOCAL_CLOSE_ALL close self; open options_move,									( !dvarbool( gpad_enabled ) ),		; )
FRAME_CHOICE_BUTTON_VIS_EX( 3, "@MENU_COMBAT_CAPS",					LOCAL_CLOSE_ALL close self; open options_shoot,									( !dvarbool( gpad_enabled ) ),		; )
FRAME_CHOICE_BUTTON_VIS_EX( 4, "@MENU_INTERACT_CAPS",				LOCAL_CLOSE_ALL close self; open options_misc,									( !dvarbool( gpad_enabled ) ),		; )
FRAME_CHOICE_BUTTON_VIS_EX( 5, "@MENU_MULTIPLAYER_CAPS", 	LOCAL_CLOSE_ALL close self; open controls_multi,								( !dvarbool( gpad_enabled ) && dvarbool( ui_multiplayer ) ),	; )
FRAME_CHOICE_BUTTON_VIS_EX( 5, "@PATCH_COOPERATIVE_CAPS", 	LOCAL_CLOSE_ALL close self; open options_coop,									( !dvarbool( gpad_enabled ) && !dvarbool( ui_multiplayer ) ),	; )

FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX( 1, "@MENU_LOOK_CAPS",					;, ;, ( dvarbool( gpad_enabled ) ), ; )
FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX( 2, "@MENU_MOVE_CAPS",					;, ;, ( dvarbool( gpad_enabled ) ), ; )
FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX( 3, "@MENU_COMBAT_CAPS",					;, ;, ( dvarbool( gpad_enabled ) ), ; )
FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX( 4, "@MENU_INTERACT_CAPS",				;, ;, ( dvarbool( gpad_enabled ) ), ; )
FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX( 5, "@MENU_MULTIPLAYER_CAPS",	;, ;, ( dvarbool( gpad_enabled ) && dvarbool( ui_multiplayer ) ), ; )
FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX( 5, "@PATCH_COOPERATIVE_CAPS",	;, ;, ( dvarbool( gpad_enabled ) && !dvarbool( ui_multiplayer ) ), ; )

// Disable the gamepad button if there is no gamepad present
FRAME_CHOICE_BUTTON_VIS_EX( 6, "@PLATFORM_GAMEPAD_CAPS",			LOCAL_CLOSE_ALL close self; open options_gamepad,								( dvarbool( gpad_present ) || dvarbool( gpad_enabled ) ), ; )
FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX( 6, "@PLATFORM_GAMEPAD_CAPS",	;, ;, ( !dvarbool( gpad_present ) && !dvarbool( gpad_enabled ) ), ; )

FRAME_CHOICE_BUTTON_VIS_EX( 8, "@MENU_SET_DEFAULT_CONTROLS_CAPS", 	open options_control_defaults,										1,									; )		





#undef		CHOICE_SIZE_X
#undef		CHOICE_SIZE_Y

#define CHOICE_SIZE_X			170
#define CHOICE_SIZE_Y			17

#define		OPTIONS_STYLE			1
#undef		STYLE2_NOPOSITION
#define STYLE2_NOPOSITION
#include "ui_mp/menustyle.inc"

#undef CHOICE_TEXTSIZE
#define CHOICE_TEXTSIZE 	TEXTSIZE_SMALL
#undef	CHOICE_TEXTALIGN
#define	CHOICE_TEXTALIGN	ITEM_ALIGN_MIDDLE_RIGHT
#undef	CHOICE_TEXT_OFFSET_X
#define CHOICE_TEXT_OFFSET_X	(-(4+CHOICE_SIZE_Y)) //22

#undef  CHOICE_DVAR_OFFSET_X
#define CHOICE_DVAR_OFFSET_X	(CHOICE_SIZE_X+20)
#undef  CHOICE_DVAR_TEXTALIGN
#define CHOICE_DVAR_TEXTALIGN	ITEM_ALIGN_MIDDLE_LEFT
#undef CHOICE_DVAR_WIDTH_OFFSET
#define CHOICE_DVAR_WIDTH_OFFSET	120
#undef CHOICE_ACTION_SOUND	
#define CHOICE_ACTION_SOUND		"uin_mouse_click_t"

#undef CHOICE_Y_START
#define CHOICE_Y_START		60

#undef CHOICE_X_START
#define CHOICE_X_START		75

#undef CHOICE_TEXTCOLOR
#define CHOICE_TEXTCOLOR	1 1 1 1
