// generic shader draw, text draw, ui art elements to be included by menu scripts that use such

// generic shader draw
#define PREPROC_SHADER_DRAW( prect, pshader, pcolor )	\
		PREPROC_SHADER_DRAW_VIS_EX( prect, pshader, pcolor, 1, ; )	
		
#define PREPROC_SHADER_DRAW_VIS_EX( prect, pshader, pcolor, visArg, extraArgs )	\
		PREPROC_SHADER_DRAW_ALL( prect, 0 0, pshader, pcolor, 0, 0, 0 0 0 0, visArg, extraArgs )	

#define PREPROC_SHADER_DRAW_ALL( prect, porigin, pshader, pcolor, pborder, pbordersize, pbordercolor, visArg, extraArgs )	\
		itemDef																												\
		{																													\
			style			WINDOW_STYLE_SHADER																				\
			type			ITEM_TYPE_IMAGE																					\ 
			rect			prect																							\
			origin 			porigin																							\
			forecolor		pcolor																							\
			exp				material( pshader );																			\
			border			pborder																							\
			bordersize		pbordersize																						\
			bordercolor		pbordercolor																					\
			visible			visArg																							\
			decoration																										\
			extraArgs																										\
		}		

#define PREPROC_SHADER_DRAW_ADV( px, py, pw, ph, palign, pshader, pcolor ) \
		PREPROC_SHADER_DRAW_ADV_VIS_EX( px, py, pw, ph, palign, pshader, pcolor, 1, ; )		
		
#define PREPROC_SHADER_DRAW_ADV_VIS_EX( px, py, pw, ph, palign, pshader, pcolor, pvis, extraArgs )	\
		PREPROC_SHADER_DRAW_ADV_ALL( px, py, pw, ph, palign, pshader, pcolor, 0, 0, 0 0 0 0, pvis, extraArgs )	

#define PREPROC_SHADER_DRAW_ADV_ALL( px, py, pw, ph, palign, pshader, pcolor, pborder, pbordersize, pbordercolor, pvis, extraArgs )	\
		itemDef																														\
		{																															\
			style			WINDOW_STYLE_SHADER																						\
			type			ITEM_TYPE_IMAGE																							\
			rect			0 0 0 0 palign																							\
			exp				rect X( px )																							\
			exp				rect Y( py )																							\
			exp				rect W( pw )																							\
			exp				rect H( ph )																							\
			forecolor		pcolor																									\
			exp				material( pshader );																					\
			border			pborder																									\
			bordersize		pbordersize																								\
			bordercolor		pbordercolor																							\
			visible			pvis																									\
			decoration																												\
			extraArgs																												\
		}
		
// generic ownerdraw
#define PREPROC_OWNERDRAW_ALL( prect, pcolor, pownerdraw, pvis, extraArgs )						\
		itemDef																					\
		{																						\
			type			ITEM_TYPE_OWNERDRAW													\
			rect			prect																\
			forecolor		pcolor																\
			ownerdraw		pownerdraw															\
			visible			pvis																\
			decoration																			\
			extraArgs																			\
		}

// generic text draw
#define PREPROC_TEXT_DRAW( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor ) \
		PREPROC_TEXT_DRAW_VIS( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, 1 )

#define PREPROC_TEXT_DRAW_VIS( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pvis ) \
		PREPROC_TEXT_DRAW_VIS_EX( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pvis, ; ) 
			
#define PREPROC_TEXT_DRAW_VIS_EX( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pvis, extraArgs ) \
		PREPROC_TEXT_DRAW_ALL( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_NORMAL, pvis, extraArgs ) 

#define PREPROC_TEXT_DRAW_ALL( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pfont, pstyle, pvis, extraArgs ) \
		itemDef								\
		{									\
			type			ITEM_TYPE_TEXT	\
			rect			prect			\
			origin 			porigin			\
			textalignx		palignx			\
			textaligny		paligny			\
			textfont		pfont			\
			textstyle		pstyle			\
			textalign		palign			\
			textscale		psize			\
			forecolor		pcolor			\
			exp				text( ptext );	\
			visible			pvis			\
			decoration						\
			extraArgs						\
		}

#define PREPROC_BUTTON_DRAW_VIS( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pvis, act ) \
		PREPROC_BUTTON_DRAW_VIS_EX( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pvis, ;, act ) 
			
#define PREPROC_BUTTON_DRAW_VIS_EX( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pvis, extraArgs, act ) \
		PREPROC_BUTTON_DRAW_ALL( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, CHOICE_TEXTFONT, ITEM_TEXTSTYLE_NORMAL, pvis, extraArgs, act ) 

#ifdef CONSOLE
#define PREPROC_BUTTON_DRAW_ALL( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pfont, pstyle, pvis, extraArgs, act ) \
		PREPROC_TEXT_DRAW_ALL( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pfont, pstyle, pvis, extraArgs )
#else // #ifdef CONSOLE
#define PREPROC_BUTTON_DRAW_ALL( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, pfont, pstyle, pvis, extraArgs, act ) \
		itemDef								\
		{									\
			type			ITEM_TYPE_BUTTON \
			rect			prect			\
			exp				rect W( getTextWidth(locString(ptext),pfont,psize)+8 ) \
			origin 			porigin			\
			textalignx		palignx			\
			textaligny		paligny			\
			textfont		pfont			\
			textstyle		pstyle			\
			textalign		palign			\
			textscale		psize			\
			forecolor		pcolor			\
			exp				text( ptext );	\
			visible			pvis			\
			style			WINDOW_STYLE_FILLED \
			backcolor		1 1 1 0			\
			border			1								\
			bordersize		1								\
			bordercolor		CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA \
			mouseEnter		{ play CHOICE_FOCUS_SOUND; setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_SELECTED_RGBA; } \
			mouseexit		{ setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA; } \
			action		{ play CHOICE_FOCUS_SOUND ; act } \
			extraArgs						\
		}
#endif // #else #ifdef CONSOLE

#define PREPROC_TEXT_DRAW_ADV_VIS_EX( px, py, pw, ph, pHorizAlign, pVertAlign, ptext, psize, palignx, paligny, palign, pcolor, pvis, extraArgs ) \
		PREPROC_TEXT_DRAW_ADV_ALL( px, py, pw, ph, pHorizAlign, pVertAlign, ptext, psize, palignx, paligny, palign, pcolor, CHOICE_TEXTFONT, CHOICE_TEXTSTYLE, pvis, extraArgs ) 
		
#define PREPROC_TEXT_DRAW_ADV_ALL( px, py, pw, ph, pHorizAlign, pVertAlign, ptext, psize, palignx, paligny, palign, pcolor, pfont, pstyle, pvis, extraArgs ) \
		itemDef												\
		{													\
			type			ITEM_TYPE_BUTTON				\
			rect			0 0 0 0 pHorizAlign pVertAlign	\
			exp				rect X( px )					\
			exp				rect Y( py )					\
			exp				rect W( pw )					\
			exp				rect H( ph )					\
			textalign		palign							\
			textalignx		palignx							\
			textaligny		paligny							\
			textstyle		pstyle							\
			textfont		pfont							\
			textscale		psize							\
			forecolor		pcolor							\
			exp				text( ptext );					\
			visible			pvis							\
			decoration										\
			extraArgs										\
		}

#define PREPROC_DRAW_LINE( p1x, p1y, p2x, p2y, pHorizAlign, pVertAlign, pLineWidth, pColor )	\
		itemDef																					\
		{																						\
			type		ITEM_TYPE_OWNERDRAW														\
			ownerdraw	UI_PRETTY_LINE															\
			rect		p1x p1y (p2x-p1x) (p2y-p1y) pHorizAlign pVertAlign						\
			borderSize	pLineWidth																\
			forecolor	pColor																	\
			visible		1																		\
			decoration																			\
		}

#ifndef DYNAMIC_MENU_COMMON_FIELDS
#define DYNAMIC_MENU_COMMON_FIELDS \
	name						dynamic_menu_feeder \
	type						ITEM_TYPE_LISTBOX \
	feeder						FEEDER_DYNAMIC_MENU \
	origin						0 0 \
	elementwidth				CHOICE_SIZE_X \
	elementheight				CHOICE_SIZE_Y \ 
	elementtype					LISTBOX_TEXT \
	textstyle					CHOICE_TEXTSTYLE \
	textfont					CHOICE_TEXTFONT \
	textscale					CHOICE_TEXTSIZE \
	textalignx					CHOICE_TEXT_OFFSET_X \
	forecolor					CHOICE_TEXTCOLOR \
	focusColor					CHOICE_TEXTCOLOR \
	disableColor				COLOR_DISABLED \
	selectBorder				0.8 0.95 1 0 \
	modal \
	noscrollbars \
	noBlinkingHighlight \
	visible						1 
#endif

#ifndef DYNAMIC_MENU_COMMON_COLUMNS
#define DYNAMIC_MENU_COMMON_COLUMNS																\
		/* BACKGROUND */																		\
		menuColDef																				\
		{																						\
			type		MENU_ITEM_TYPE_IMAGE													\
			rect		0 1 CHOICE_SIZE_X CHOICE_SIZE_Y ITEM_ALIGN_LEFT ITEM_ALIGN_MIDDLE		\
			maxChars	50																		\
		}																						\
		/*  HIGHLIGHT */																		\
		menuColDef																				\
		{																						\
			type		MENU_ITEM_TYPE_IMAGE_ON_HOVER											\
			rect		0 1 CHOICE_SIZE_X CHOICE_SIZE_Y ITEM_ALIGN_LEFT ITEM_ALIGN_MIDDLE		\
			maxChars	50																		\
		}																						\
		/* SELECT BUTTON */																		\
		menuColDef																				\
		{																						\
			type		MENU_ITEM_TYPE_IMAGE_ON_HOVER											\
			rect		1 1 (CHOICE_SIZE_Y-1) (CHOICE_SIZE_Y) ITEM_ALIGN_LEFT ITEM_ALIGN_MIDDLE	\
			maxChars	50																		\
		}																						
#endif

#ifndef DYNAMIC_MENU_INIT
#define DYNAMIC_MENU_INIT( menuName ) \
		exec updateListboxPos menuName;
#endif


// tab button action
#ifdef CONSOLE
#define TAB_ACTION_BUTTON( pnum, prect, porigin, actionArg, visArg, extraArgs )

#define TAB_ACTION_BUTTON_ADV( px, py, pw, ph, pHorizAlign, pVertAlign, actionArg, visArg, extraArgs )
#else
#define TAB_ACTION_BUTTON( pnum, prect, porigin, actionArg, visArg, extraArgs ) \
	itemDef{										\
		type			ITEM_TYPE_BUTTON_NO_TEXT	\
		rect			prect						\
		origin			porigin						\
		visible			visArg						\
		onFocus{									\
		play CHOICE_FOCUS_SOUND; }					\
	action{											\
		play CHOICE_FOCUS_SOUND;					\
		actionArg }									\
		extraArgs }									

#define TAB_ACTION_BUTTON_ADV( px, py, pw, ph, pHorizAlign, pVertAlign, actionArg, visArg, extraArgs )	\
	itemDef																								\
	{																									\
		type ITEM_TYPE_BUTTON																			\
		style WINDOW_STYLE_FILLED																		\
		rect 0 0 0 0 pHorizAlign pVertAlign																\
		exp rect X( px )																				\
		exp rect Y( py )																				\
		exp rect W( pw )																				\
		exp rect H( ph )																				\
		forecolor 1 1 1 1																				\
		visible visArg																					\
		mouseenter																						\
		{																								\
			play CHOICE_FOCUS_SOUND;																	\
		}																								\
		action																							\
		{																								\
			play CHOICE_FOCUS_SOUND;																	\
			actionArg																					\
		}																								\
		extraArgs																						\
	}

#endif

#ifdef PC
#define PREPROC_LOBBY_CHAT( px, py, pw, ph, psize, palign, pcolor ) \
	itemDef																								\
	{																									\
		style           WINDOW_STYLE_SHADER_FRAMED														\
		rect            (px-15) (py+10) (pw+15) (ph) HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP						\
		background      "menu_mp_lobby_frame_outer"														\
		forecolor       1 1 1 1																			\
		visible         1																				\
		decoration																						\
		frame           26 0.1 FRAME_SIDE_ALL															\
	}																									\
	itemDef																								\
	{																									\
		style           WINDOW_STYLE_SHADER_FRAMED														\
		rect            (px+20) (py+ph+5) (pw-28) (ph/8) HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP				\
		background      "white"														\
		forecolor		0 0 0 0.5																			\
		visible         1																				\
		decoration																						\
	}																									\
	itemDef \
	{ \
		type		ITEM_TYPE_TEXT					\
		rect		px (py-10) pw (ph/6) HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
		textalign	ITEM_ALIGN_MIDDLE_LEFT \
		textstyle	ITEM_TEXTSTYLE_SHADOWED \
		textfont	UI_FONT_NORMAL \
		text		"@MENU_LOBBY_CHAT" \
		textscale	(psize*2.0) \
		forecolor	pcolor \
		visible		1 \
		action \
		{ \
			setFocus chat_text_input; \
		} \
	} \ 
	itemDef \
	{ \
		type		ITEM_TYPE_OWNERDRAW_TEXT \
		rect		(px) py (pw) ph HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
		textalign	ITEM_ALIGN_MIDDLE_LEFT \
		textstyle	ITEM_TEXTSTYLE_SHADOWED \
		textfont	UI_FONT_SMALL \
		textscale	psize \
		forecolor	pcolor \
		visible		1 \
		ownerdraw	UI_LOBBY_CHAT \
		action \
		{ \
			setFocus chat_text_input; \
		} \
	} \
	itemDef \
	{ \
		type		ITEM_TYPE_TEXT	\
		rect		(px-5) (py+ph+5) 20 (ph/8) HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
		textalign	ITEM_ALIGN_MIDDLE_LEFT \
		textstyle	ITEM_TEXTSTYLE_SHADOWED \	
		textfont	UI_FONT_NORMAL \
		text		"@MENU_TALK" \
		textscale	psize \
		forecolor	pcolor \
		visible		1 \
		action \
		{ \
			setFocus chat_text_input; \
		} \
	} \ 
	itemDef \
	{ \
		name			"chat_text_input" \
		type			ITEM_TYPE_EDITFIELD \
		text			" " \
		dvar			ui_tempChatText \
		rect			(px+15) (py+ph+5) (pw-15) (ph/8) HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
		textalign		ITEM_ALIGN_MIDDLE_LEFT \
		textalignx		0 \
		textscale		psize \
		textstyle		ITEM_TEXTSTYLE_SHADOWED \
		style			WINDOW_STYLE_FILLED \
		forecolor		pcolor \
		visible			1 \
		maxChars		60 \
		maxpaintchars	60 \
		accept \
		{ \
			play CHOICE_ACTION_SOUND; \
			execNow "check_chat_input"; \
			exec "wait"; \
			setdvar ui_tempChatText ""; \
			setfocus chat_text_input; \
		} \
	} \
	PREPROC_SHADER_DRAW_VIS_EX((px+pw-50) (py+ph+(ph/8)+10) 50 (ph/8) HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP, \
		"white", 1 1 1 1, when( localVarInt( ui_zombie_lobby_send_highlight ) == 1 );,;) \
	itemDef \
	{ \
		rect		(px+pw-50) (py+ph+(ph/8)+10) 50 (ph/8) HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP \
		exp			rect W( getTextWidth(locString("@MENU_SEND"),UI_FONT_NORMAL,psize)+8 ) \
		type		ITEM_TYPE_BUTTON \
		textalign	ITEM_ALIGN_MIDDLE_CENTER \
		textstyle	ITEM_TEXTSTYLE_SHADOWED \
		textfont	UI_FONT_NORMAL \
		text		"@MENU_SEND" \
		textscale	psize \
		background      "white" \
		forecolor		1 1 1 1 \
		border			1								\
		bordersize		1								\
		bordercolor		CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA \
		visible		1 \
		action \
		{ \
			play CHOICE_ACTION_SOUND; \
			execNow "check_chat_input"; \
			exec "wait"; \
			setdvar ui_tempChatText ""; \
			setfocus chat_text_input; \
		} \
		mouseEnter		{ play CHOICE_FOCUS_SOUND; setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_SELECTED_RGBA; } \
		mouseexit		{ setcolor bordercolor CHOICE_BUTTON_BORDER_COLOR_UNSELECTED_RGBA; } \
	}
#endif // #ifdef PC

#define DEFAULT_SLIDE_IN_SPEED		180
#define DEFAULT_SLIDE_OUT_SPEED		180

#define DEFAULT_FADE_IN_TIME		300
#define DEFAULT_FADE_OUT_TIME		250

#ifndef CHANGE_MENU_SLIDE_DIRECTION
#define CHANGE_MENU_SLIDE_DIRECTION( menuName, openSlideDirection, closeSlideDirection ) \
		execnow changemenuopenslidedirection menuName openSlideDirection; \
		execnow changemenucloseslidedirection menuName closeSlideDirection; 
#endif

#define EXTRACAM_RED_COLOR 0.94 0.32 0.32

#define LOCK_SIZE 12

#define	JOIN_SERVER_ACTION \
	if( isWagerServer() ) \
	{ \
		uiScript WagerWarning; \
	} \
	else \
	{ \
		uiScript JoinServer; \
	}
	
#define JOIN_RESERVED_ACTION \
		uiScript JoinReserved;

#ifdef PC
	#ifndef PC_TAB_SWITCH_ACTIONS_PREV
	#define PC_TAB_SWITCH_ACTIONS_PREV
	#endif
	#ifndef PC_TAB_SWITCH_ACTIONS_NEXT
	#define PC_TAB_SWITCH_ACTIONS_NEXT
	#endif

	#undef PC_TAB_SWITCH_ACTIONS
	#define PC_TAB_SWITCH_ACTIONS( currMenu, prevMenu, nextMenu ) \
		execKeyInt K_LEFTARROW { \
			PC_TAB_SWITCH_ACTIONS_PREV \
			execNow closeMenuImmediate (currMenu); \
			execNow openMenuImmediate (prevMenu); \
		} \
		execKeyInt K_RIGHTARROW { \
			PC_TAB_SWITCH_ACTIONS_NEXT \
			execNow closeMenuImmediate (currMenu); \
			execNow openMenuImmediate (nextMenu); \
		}
	
	#undef PC_TAB_SWITCH_SAME_MENU_ACTIONS
	#define PC_TAB_SWITCH_SAME_MENU_ACTIONS \
		execKeyInt K_LEFTARROW { \
				PC_TAB_SWITCH_ACTIONS_PREV \
			} \
			execKeyInt K_RIGHTARROW { \
				PC_TAB_SWITCH_ACTIONS_NEXT \
			}
#else //#ifdef PC
	#undef PC_TAB_SWITCH_ACTIONS
	#define PC_TAB_SWITCH_ACTIONS( currMenu, prevMenu, nextMenu )
	
	#undef PC_TAB_SWITCH_SAME_MENU_ACTIONS
	#define PC_TAB_SWITCH_SAME_MENU_ACTIONS
#endif //#ifdef PC

#define TAB_MOUSEOVER_HIGHLIGHT \
	mouseenter { setcolor forecolor 1 1 1 1 } \
	mouseexit { setcolor forecolor NEW_FRAME_GRAY_TEXT_COLOR }
	
	
// Fileshare

#undef FILESHARE_SELECTOR_WIDTH
#undef FILESHARE_SELECTOR_HEIGHT
#undef FILESHARE_SELECTOR_X
#undef FILESHARE_SELECTOR_Y
#undef FILESHARE_BOTTOM_BUTTONS
#undef FILESHARE_COMMON_OPTIONS
#undef FILESHARE_SLOT_NUMBER_Y
#undef FILESHARE_SLOT_ARROW_Y
#undef FILESHARE_SLOT_NUMBER
#undef FILESHARE_TOOLTIP_PC_Y
#undef	RECT_BUTTON_SPACING
#undef	RECT_HOME_BUTTON_OFFSET
#undef	RECT_PGDN_BUTTON_OFFSET
#undef	RECT_PGUP_BUTTON_OFFSET
#undef	RECT_BUTTON_PC_RIGHT_OFFSET
	
#ifdef PC
	#define FILESHARE_SELECTOR_WIDTH	296
	#define FILESHARE_SELECTOR_HEIGHT	215
	#define FILESHARE_SELECTOR_X		-271
	#define FILESHARE_SELECTOR_Y		-127
	#define FILESHARE_SLOT_NUMBER_Y		166
	#define FILESHARE_SLOT_ARROW_Y		168
	#define FILESHARE_TOOLTIP_PC_Y		124
	#define RECT_BUTTON_SPACING			20
	#define RECT_HOME_BUTTON_OFFSET		( 0 )
	#define RECT_PGDN_BUTTON_OFFSET		( RECT_HOME_BUTTON_OFFSET - getTextWidth( locString( "@MPUI_LB_HOME" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 - RECT_BUTTON_SPACING )
	#define RECT_PGUP_BUTTON_OFFSET		( RECT_PGDN_BUTTON_OFFSET - getTextWidth( locString( "@MPUI_LB_PGDN" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 - RECT_BUTTON_SPACING )
	
	#define RECT_BUTTON_PC_RIGHT_OFFSET( RECT_X_START, RECT_Y_START, RECT_WIDTH, RECT_HEIGHT, offsetArg, textArg, actionArg, visArg ) \
		NEW_FRAME_BUTTON_PC_ALL( 0 ( RECT_Y_START + RECT_HEIGHT + 5 ) 10 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
			exp rect W( getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 ) \
			exp rect X( RECT_X_START + RECT_WIDTH - 2 + (offsetArg) - getTextWidth( locString( textArg ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 ), \
			textArg, \
			CHOICE_TEXTFONT, TEXTSIZE_DEFAULT, ITEM_ALIGN_MIDDLE_CENTER, \
			actionArg, \
			visArg )
	
	#define FILESHARE_BOTTOM_BUTTONS( STARTX, STARTY, FRAME_WIDTH, FRAME_HEIGHT, fileshareArg )																												\
		RECT_BUTTON_PC_RIGHT_OFFSET( STARTX, STARTY, FRAME_WIDTH, FRAME_HEIGHT, RECT_HOME_BUTTON_OFFSET, "@MPUI_LB_HOME", setFocus fileshareArg; execKeyPress K_KP_HOME, when( IsPremiumSubscriber() ); )	\
		RECT_BUTTON_PC_RIGHT_OFFSET( STARTX, STARTY, FRAME_WIDTH, FRAME_HEIGHT, RECT_PGDN_BUTTON_OFFSET, "@MPUI_LB_PGDN", setFocus fileshareArg; execKeyPress K_KP_PGDN, when( IsPremiumSubscriber() ); )	\
		RECT_BUTTON_PC_RIGHT_OFFSET( STARTX, STARTY, FRAME_WIDTH, FRAME_HEIGHT, RECT_PGUP_BUTTON_OFFSET, "@MPUI_LB_PGUP", setFocus fileshareArg; execKeyPress K_KP_PGUP, when( IsPremiumSubscriber() ); )
	#define FILESHARE_SLOT_NUMBER( isUserArg )																													\
		PREPROC_TEXT_DRAW_VIS(	-144 FILESHARE_SLOT_NUMBER_Y 30 15 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0,													\
					( int( getFeederData( "fileShareSlots", "slot" ) ) + " " + locString( "@MENU_FILESHARE_OF6") ),									\
					TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, 1 1 1 1, when( !IsPremiumSubscriber() && isUserArg ) )										\
		PREPROC_TEXT_DRAW_VIS(	-144 FILESHARE_SLOT_NUMBER_Y 30 15 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0,													\
							( int( getFeederData( "fileShareSlots", "slot" ) ) + " " + locString( "@MENU_FILESHARE_OF18") ),						\
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, 1 1 1 1, when( IsPremiumSubscriber() && isUserArg ) )									\
		PREPROC_TEXT_DRAW_VIS(	-144 FILESHARE_SLOT_NUMBER_Y 30 15 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0,													\
			( int( getFeederData( "fileShareSlots", "slot" ) ) + " " + locString( "MENU_FILESHARE_OF" ) + " " + dvarInt( fsMaxPrivateSlotRowsOther ) * 3 ),									\
			TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, 1 1 1 1, when( isTaskInProgress( "LiveFileShareGetListing" ) != 1 && !isUserArg ) )										\
		PREPROC_SHADER_DRAW_VIS_EX(	-114 FILESHARE_SLOT_ARROW_Y 11 11 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,													\
									"ui_arrow_left", COLOR_BODY_TEXT,																				\
									when( IsPremiumSubscriber() && getFeederData( "fileShareSlots", "slot" ) > 6 ),															\
									rotation 90; )																									\
		PREPROC_SHADER_DRAW_VIS_EX(	-107 FILESHARE_SLOT_ARROW_Y 11 11 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,													\
									"ui_arrow_right", COLOR_BODY_TEXT,																				\
									when( IsPremiumSubscriber() && getFeederData( "fileShareSlots", "slot" ) > 6 && getFeederData( "fileShareSlots", "slot" ) < 13 ),		\
									rotation 90; )																									\
		PREPROC_SHADER_DRAW_VIS_EX(	-114 FILESHARE_SLOT_ARROW_Y 11 11 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,													\
									"ui_arrow_right", COLOR_BODY_TEXT,																				\
									when( IsPremiumSubscriber() && getFeederData( "fileShareSlots", "slot" ) <= 6 ),															\
									rotation 90; ) 

	#define FILESHARE_COMMON_OPTIONS																														\
		group	fileshareControls																															\
		rect	FILESHARE_SELECTOR_X FILESHARE_SELECTOR_Y FILESHARE_SELECTOR_WIDTH FILESHARE_SELECTOR_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
		usepaging
	
	#define FILESHARE_BOTTOM( fileshareArg, isUserArg )																										\
		FILESHARE_BOTTOM_BUTTONS( FILESHARE_SELECTOR_X, FILESHARE_SELECTOR_Y, FILESHARE_SELECTOR_WIDTH, FILESHARE_SELECTOR_HEIGHT, fileshareArg )	\
		FILESHARE_SLOT_NUMBER( isUserArg )

#else //#ifdef PC
	#define FILESHARE_SELECTOR_WIDTH 250
	#define FILESHARE_SELECTOR_HEIGHT 250
	#define FILESHARE_SELECTOR_X -265
	#define FILESHARE_SELECTOR_Y -127
	#define FILESHARE_BOTTOM( fileshareArg )
	
	#define FILESHARE_COMMON_OPTIONS																										\
		rect	FILESHARE_SELECTOR_X FILESHARE_SELECTOR_Y FILESHARE_SELECTOR_WIDTH FILESHARE_SELECTOR_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER	\
		noscrollbars
		
	#define FILESHARE_BOTTOM
		
#endif //#ifdef PC
