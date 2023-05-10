#define LOADOUT_WIDTH 			270

#define LOADOUT_IMAGE_X			110
#define LOADOUT_IMAGE_Y			0

#define LOADOUT_TITLE_X			20
#define LOADOUT_TITLE_Y			(LOADOUT_IMAGE_Y + 100)

#define LOADOUT_DESC_X			(LOADOUT_TITLE_X)
#define LOADOUT_DESC_Y			(LOADOUT_TITLE_Y + 20)

#ifdef PC
	#define ORIGIN_LOADOUT			((-(LOADOUT_WIDTH - RIGHTITEM_OFFSET))-80) 38
#else
	#define ORIGIN_LOADOUT			((-(LOADOUT_WIDTH - RIGHTITEM_OFFSET))-10) 38
#endif

#define RATEBAR_FRAME_BORDER		0//WINDOW_BORDER_SUNKEN
#define RATEBAR_FRAME_BORDERSIZE	2
#define RATEBAR_FRAME_BORDERCOLOR	0.4 0.4 0.425 1

#define RATEBAR_BAR_SHADER			"gradient_fadein"
#define RATEBAR_BAR_COLOR			1 1 1 0.3

#define ATTRIBUTE_BACK_COLOR		0.1804 0.1961 0.2078 0.5
#define ATTRIBUTE_FILL_COLOR		0.2862 0.3098 0.3098 0.8

#define RATE_BAR_WIDTH				98
#define RATE_BAR_HEIGHT				12
	
/* ================================================================================= */
/* ================================ LOADOUT DISPLAY ================================ */
/* ================================================================================= */

	#define LOADOUT_ALIGN 	HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	
// attributes box ======================

#ifndef HIDE_WEAPON_ATTRIBUTE		

	#define INFO_BOX_ORIENT			0
	#define INFO_BOX_WIDTH			222
	#define INFO_BOX_HEIGHT			126
	#define INFO_BOX_X				(CHOICE_X_START+CHOICE_SIZE_X-INFO_BOX_WIDTH)+150
	#define ATTRIBUTE_BAR_X			INFO_BOX_X+118

	#ifdef PC  
		#define INFO_BOX_Y				320
	#else     
		#define INFO_BOX_Y				285//274
	#endif     
	
	#define ORIGIN_ATTRIBUTE_LABEL	(INFO_BOX_X) (INFO_BOX_Y)//(INFO_BOX_Y+10)

	// meter bar unit dividers
	#define ATTRIBUTE_UNITS( px, py )																																\
			PREPROC_SHADER_DRAW( (px+(RATE_BAR_WIDTH/4)) (py+RATE_BAR_HEIGHT) 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,		"line_vertical", 1 1 1 0.2 )	\
			PREPROC_SHADER_DRAW( (px+(RATE_BAR_WIDTH/2)) (py+RATE_BAR_HEIGHT) 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,		"line_vertical", 1 1 1 0.2 )	\
			PREPROC_SHADER_DRAW( (px+((RATE_BAR_WIDTH/4)*3)) (py+RATE_BAR_HEIGHT) 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,	"line_vertical", 1 1 1 0.2 )
		
		#define PREVIEW_VIS_CONDITION visible when( PREVIEW_VIS_CONDITION_RAW );
	#define PREVIEW_VIS_CONDITION_RAW dvarInt( ui_show_preview )
#endif

#ifdef PC
	#define BLACKMARKET_POPUP_BACK_BUTTON \
		NEW_FRAME_BACK_BUTTON_ACTION_PC( close self; )
#else
	#define BLACKMARKET_POPUP_BACK_BUTTON
#endif

	#define BLACKMARKET_POPUP_SWAP( nameArg, onOpenArg, onCloseArg ) \
			BLACKMARKET_POPUP_SWAP_VIS( nameArg, onOpenArg, onCloseArg, 1 )

	#define BLACKMARKET_POPUP_SWAP_VIS( nameArg, onOpenArg, onCloseArg, visArg ) \
		name			nameArg \
		rect			0 0 640 480 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
		focusColor		COLOR_FOCUSED \
		style			WINDOW_STYLE_FILLED \
		popup \
		visible			1 \
		onOpen \
		{ \
			onOpenArg; \
			setdvar ui_show_reset "0"; \
		} \
		onESC \
		{ \
			play CHOICE_FOCUS_SOUND; \
			close self; \
		} \
		onClose { onCloseArg } \
		OVERLAY_BACKGROUND_VIS( 0 ) \
		CHOICE_OVERLAY_TITLE( "@MPUI_BLACK_MARKET" ) \
		CHOICE_OVERLAY_SUB_TITLE( dvarstring(ui_menu_selection_title) ) \
		BLACKMARKET_POPUP_BACK_BUTTON \

// perk loadout info display =============
	#ifdef PC
		#define PERK_DESC_TEXTSIZE	0.25
	#else
		#define PERK_DESC_TEXTSIZE 	TEXTSIZE_SMALL
	#endif
	
	#define PERK_IMAGE_X		25//(PERK_TITLE_X+25)
	#define PERK_IMAGE_Y		198//196(g@20) //(PERK_TITLE_Y)//190

	#define PERK_TITLE_X		(PERK_IMAGE_X+35)
	#define PERK_TITLE_Y		(PERK_IMAGE_Y)

	#define PERK_DESC_X			(PERK_TITLE_X-4)
	#define PERK_DESC_Y			(PERK_IMAGE_Y+15)

	#define PERK_Y_OFFSET		38//204//206
	#define GRENADE_Y_OFFSET	24//20(d-176)//21//36

	// perk 1 name -------------
	#define LOCAL_PERK1( ptext, visArg ) \
			PREPROC_TEXT_DRAW_VIS( PERK_TITLE_X (PERK_TITLE_Y) (LOADOUT_WIDTH-50) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, ptext, TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW, when( visArg ); )


//SPECIAL LOADOUT SCREENS FOR CREATE A CLASS MENUS
#define BLACKMARKET_LOADOUT_BLACKMARKET_TITLE \
	CHOICE_OVERLAY_TITLE( "@MPUI_BLACK_MARKET" ) \


#define WEAPON_TITLE_X		-5
#define WEAPON_TITLE_Y		-10

#define WEAPON_IMAGE_X		130//90//74
#define WEAPON_IMAGE_Y		(WEAPON_TITLE_Y+20)

#define ATTACHMENT_TITLE_X	10
#define ATTACHMENT_TITLE_Y	(WEAPON_TITLE_Y+72)//64

#define ATTACHMENT_IMAGE_X	30
#define ATTACHMENT_IMAGE_Y	(WEAPON_IMAGE_Y)//32

#define SECONDARY_OFFSET_Y	92

#define LOCKED_CLASS \
		LOCKED_CLASS_VIS( 1 )

#define LOCKED_CLASS_VIS( visArg )															\
		/* image*/																			\
		PREPROC_SHADER_DRAW_VIS_EX( LOADOUT_IMAGE_X  LOADOUT_IMAGE_Y 90 90 LOADOUT_ALIGN,	\
									"menu_mp_lobby_locked_big", 1 1 1 0.75,					\
									visArg, ; )												\
		/* title*/																			\
		PREPROC_TEXT_DRAW_VIS( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN,	ORIGIN_LOADOUT, "@MPUI_BLACK_MARKET",					TEXTSIZE_DEFAULT,	0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW, visArg )	\
		/* perk desc unlocked*/																																																				\
		PREPROC_TEXT_DRAW_VIS( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN,	ORIGIN_LOADOUT, dvarString( ui_prestige_unlock_desc ),	TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,	visArg )

