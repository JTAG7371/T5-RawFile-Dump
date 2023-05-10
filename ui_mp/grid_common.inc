
#define GRID_BUTTON_NAME			"grid_button_"
#define GRID_DROPDOWN_LIST_NAME		"grid_dropdown_list_"
#define GRID_DROPDOWN_LIST_BG_NAME	"grid_dropdown_list_bg_"

#define GRID_BUTTON_Y_OFFSET	30

#define GRID_OUTLINE_COLOR 0.3 0.3 0.3 1
//=========================================================
//================= CaC Main Menu RECTs ===================
//=========================================================
#define GRID_RECT_CUSTOM( xOffset, yOffset, w, h, horizAlign, vertAlign ) \
		(CHOICE_X_START+xOffset) (CHOICE_Y_START+yOffset) w h horizAlign vertAlign

#define GRID_RECT_NORMAL_LEFT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( xOffset, yOffset, CHOICE_SIZE_X, CHOICE_SIZE_Y, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP )

#define GRID_RECT_NORMAL_HIGHLIGHT_LEFT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( xOffset, yOffset, BUTTON_BG_WIDTH, CHOICE_SIZE_Y, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP )

#define GRID_RECT_NORMAL_OUTLINE_LEFT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (BUTTON_BG_WIDTH+4), (CHOICE_SIZE_Y+2), HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP )

#define GRID_RECT_NORMAL_RIGHT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( xOffset, yOffset, CHOICE_SIZE_X, CHOICE_SIZE_Y, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP )

#define GRID_RECT_NORMAL_HIGHLIGHT_RIGHT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( xOffset, yOffset, BUTTON_BG_WIDTH, CHOICE_SIZE_Y, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP )

#define GRID_RECT_NORMAL_OUTLINE_RIGHT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (BUTTON_BG_WIDTH+4), (CHOICE_SIZE_Y+2), HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP )

#define SPECIALTIES_BUTTON_WIDTH	BUTTON_BG_WIDTH
#define SPECIALTIES_BUTTON_HEIGHT	150

#define GRID_RECT_SPECIALTIES_RIGHT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( xOffset, yOffset, SPECIALTIES_BUTTON_WIDTH, SPECIALTIES_BUTTON_HEIGHT, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_BOTTOM )

#define GRID_RECT_SPECIALTIES_HIGHLIGHT_RIGHT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( xOffset, yOffset, SPECIALTIES_BUTTON_WIDTH, SPECIALTIES_BUTTON_HEIGHT, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_BOTTOM )

#define GRID_RECT_SPECIALTIES_OUTLINE_RIGHT( xOffset, yOffset ) \
		GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), (SPECIALTIES_BUTTON_HEIGHT+2), HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_BOTTOM )

//=========================================================
//=================== Navigation macros ===================
//=========================================================
#define CHOICE_LEFTNAV( leftfocus ) \
		execkeyint DPAD_LEFT { setfocus GRID_BUTTON_NAME#leftfocus; } \
		execkeyint APAD_LEFT { setfocus GRID_BUTTON_NAME#leftfocus; } 
			
#define CHOICE_SPECIALTY_LEFTNAV \
		execkeyint DPAD_LEFT \
		{ \
			if( dvarInt( cac_spec_focus ) == 4 ) { setfocus GRID_BUTTON_NAME"4"; } \
			else { setfocus GRID_BUTTON_NAME"3"; } \
		} \
		execkeyint APAD_LEFT \
		{ \
			if( dvarInt( cac_spec_focus ) == 4 ) { setfocus GRID_BUTTON_NAME"4"; } \
			else { setfocus GRID_BUTTON_NAME"3"; } \
		}

#define CHOICE_ARMOR_LEFTNAV \
		execkeyint DPAD_LEFT \
		{ \
			setfocus GRID_BUTTON_NAME"2"; \
		} \
		execkeyint APAD_LEFT \
		{ \
			setfocus GRID_BUTTON_NAME"2"; \
		}

#define CHOICE_RIGHTNAV( rightfocus ) \
		execkeyint DPAD_RIGHT { setfocus GRID_BUTTON_NAME#rightfocus; } \
		execkeyint APAD_RIGHT { setfocus GRID_BUTTON_NAME#rightfocus; } 

#define CHOICE_PRI_RIGHTNAV \
		execkeyint DPAD_RIGHT \
		{ \
			setfocus GRID_BUTTON_NAME"6"; \
		} \
		execkeyint APAD_RIGHT \
		{ \
			setfocus GRID_BUTTON_NAME"6"; \
		}

#define CHOICE_UPNAV( upfocus ) \
		execkeyint DPAD_UP { setfocus GRID_BUTTON_NAME#upfocus; } \
		execkeyint APAD_UP { setfocus GRID_BUTTON_NAME#upfocus; } 

#define CHOICE_ARMOR_UPNAV \
		execkeyint DPAD_UP \
		{ \
			setfocus GRID_BUTTON_NAME"7"; \
		} \
		execkeyint APAD_UP \
		{ \
			setfocus GRID_BUTTON_NAME"7"; \
		}
			
#define CHOICE_DOWNNAV( downfocus ) \
		execkeyint DPAD_DOWN { setfocus GRID_BUTTON_NAME#downfocus; } \
		execkeyint APAD_DOWN { setfocus GRID_BUTTON_NAME#downfocus; } 
		
#define CHOICE_SPECIALTY_DOWNNAV \
		execkeyint DPAD_DOWN \
		{ \
			setfocus GRID_BUTTON_NAME"6"; \
		} \
		execkeyint APAD_DOWN \
		{ \
			setfocus GRID_BUTTON_NAME"6"; \
		}

#define CHOICE_NAV( left, right, up, down ) \
		CHOICE_LEFTNAV( left ) \
		CHOICE_RIGHTNAV( right ) \
		CHOICE_UPNAV( up ) \
		CHOICE_DOWNNAV( down )

//=========================================================
//====================== Buttons ==========================
//=========================================================
#define	BG_SOLID_COLOR			0.4 0.4 0.4 0.2
#define	BG_SOLID_COLOR_NO_ALPHA	0.4 0.4 0.4 0
#define BG_HL_COLOR_NO_ALPHA	1 1 1 0
		

#define GRID_BUTTON_LEFT( itemIndex, yOffset, textArg, actionArg, slideDistance, dropDownDuration, onFocusArg, leaveFocusArg, visArg, extraArgs ) \
		CHOICE_BUTTON_BG_SOLID_RECT_EX( GRID_RECT_NORMAL_OUTLINE_LEFT( 0, yOffset ), BG_SOLID_COLOR, visArg, name GRID_BUTTON_NAME"_outline"#itemIndex; \
			ITEM_STATE_FADEOUT( BG_SOLID_COLOR_NO_ALPHA, ; ) ; \
			ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_NORMAL_OUTLINE_LEFT( 0, (yOffset-slideDistance) ), \
			ITEM_ANIMATE( menu_cac_custom, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, Maximized, dropDownDuration ); \
			ITEM_ANIMATE( menu_cac_custom, GRID_DROPDOWN_LIST_NAME#itemIndex, Maximized, dropDownDuration ); ) ; \
			ITEM_STATE_SLIDE( GRID_RECT_NORMAL_OUTLINE_LEFT( (-GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ) )  \		
		CHOICE_HIGHLIGHT_SOLID_RECT_EX( itemIndex, GRID_RECT_NORMAL_HIGHLIGHT_LEFT( 0, yOffset ), BG_HL_COLOR, visArg, \
			name GRID_BUTTON_NAME"_rect"#itemIndex; \
			ITEM_STATE_FADEOUT( BG_HL_COLOR_NO_ALPHA, ; ) ; \
			ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_NORMAL_HIGHLIGHT_LEFT( 0, (yOffset-slideDistance) ), ; ) ; \
			ITEM_STATE_SLIDE( GRID_RECT_NORMAL_OUTLINE_LEFT( (-GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ) )  \		
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX( itemIndex, GRID_RECT_NORMAL_LEFT( 0, yOffset ), GRID_BUTTON_NAME, \
			textArg, CHOICE_TEXTCOLOR, actionArg, onFocusArg;, leaveFocusArg, visArg, \
			ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR_NO_ALPHA, ; ); \
			ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_NORMAL_LEFT( 0, (yOffset-slideDistance) ), ; ) ; \
			ITEM_STATE_SLIDE( GRID_RECT_NORMAL_LEFT( (-GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ) ;   \
			HIGHLIGHT_STATES( TEXT_COLOR_HL, TEXT_COLOR_NO_HL, MEDIUM_GRAY );	\
			extraArgs ) 

#define GRID_BUTTON_RIGHT( itemIndex, xOffset, yOffset, textArg, actionArg, slideDistance, dropDownDuration, onFocusArg, leaveFocusArg, visArg, extraArgs ) \
		CHOICE_BUTTON_BG_SOLID_RECT_EX( GRID_RECT_NORMAL_OUTLINE_RIGHT( xOffset, yOffset ), BG_SOLID_COLOR, visArg, name GRID_BUTTON_NAME"_outline"#itemIndex; \
			ITEM_STATE_FADEOUT( BG_SOLID_COLOR_NO_ALPHA, ; ) ; \
			ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_NORMAL_OUTLINE_RIGHT( xOffset, (yOffset-slideDistance) ), \
			ITEM_ANIMATE( menu_cac_custom, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, Maximized, dropDownDuration ); \
			ITEM_ANIMATE( menu_cac_custom, GRID_DROPDOWN_LIST_NAME#itemIndex, Maximized, dropDownDuration ); ) ; \
			ITEM_STATE_SLIDE( GRID_RECT_NORMAL_OUTLINE_RIGHT( (xOffset+GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ) )  \		
		CHOICE_HIGHLIGHT_SOLID_RECT_EX( itemIndex, GRID_RECT_NORMAL_HIGHLIGHT_RIGHT( xOffset, yOffset ), BG_HL_COLOR, visArg, \
			name GRID_BUTTON_NAME"_rect"#itemIndex; \
			ITEM_STATE_FADEOUT( BG_HL_COLOR_NO_ALPHA, ; ) ; \
			ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_NORMAL_HIGHLIGHT_RIGHT( xOffset, (yOffset-slideDistance) ), ; ) ; \
			ITEM_STATE_SLIDE( GRID_RECT_NORMAL_HIGHLIGHT_RIGHT( (xOffset+GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ) )  \		
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX( itemIndex, GRID_RECT_NORMAL_RIGHT( xOffset, yOffset ), GRID_BUTTON_NAME, textArg, CHOICE_TEXTCOLOR, \
			actionArg, onFocusArg, leaveFocusArg, when( visArg );, \
			ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR_NO_ALPHA, ; ); \
			ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_NORMAL_RIGHT( xOffset, (yOffset-slideDistance) ), ; ) ; \
			ITEM_STATE_SLIDE( GRID_RECT_NORMAL_RIGHT( (xOffset+GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ) ;   \
			HIGHLIGHT_STATES( TEXT_COLOR_HL, TEXT_COLOR_NO_HL, MEDIUM_GRAY );	\
			extraArgs ) 

#define GRID_SPECIALTIES_INFO_ALIGN HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP

#define GRID_SPECIALTIES_INFO_Y  CHOICE_Y_START

#define GRID_SPECIALTY_EXTRA_ARGS( xpos, ypos, nameArg ) \
		name nameArg; \
		ITEM_STATE_SLIDE( xpos (ypos-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_LOADOUT_WIDTH 18 GRID_SPECIALTIES_INFO_ALIGN, ; ); \
		ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR_NO_ALPHA, ; ); \
		ITEM_STATE( GRID_SPECIALTIES_FADEIN_NAME, forecolor CHOICE_TEXTCOLOR;, ; )

#define GRID_SPECIALTY( xpos, ypos, ptext, nameArg, visArg ) \
		PREPROC_TEXT_DRAW_VIS_EX( xpos ypos SPECIALTY_LOADOUT_WIDTH 18 GRID_SPECIALTIES_INFO_ALIGN, 0 0, \
								  ptext, TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR_NO_ALPHA, \
								  visArg, GRID_SPECIALTY_EXTRA_ARGS( xpos, ypos, nameArg ) ) 

#define GRID_SPECIALTIES_INFO																																																			\
		/* specialty 1 name ------------- */																																															\
		GRID_SPECIALTY( CHOICE_X_START, (GRID_SPECIALTIES_INFO_Y+104), "@" + GetCurrentItemName(), grid_specialty1,																\
						when( ( dvarString( "ui_grid_specialties_vis" ) == "1" ) || ( dvarString( "ui_item_info_left_vis" ) == "1" ) ) )										\
		/* specialty 1 icon */																																					\
		PREPROC_SHADER_DRAW_VIS_EX(	CHOICE_X_START GRID_SPECIALTIES_INFO_Y 96 96 GRID_SPECIALTIES_INFO_ALIGN,																	\
									GetItemImage( GetCurrentItemIndex() ), 1 1 1 0,																				\
									when( dvarString( "ui_grid_specialties_vis" ) == "1" ),																						\
									name grid_specialty_1_icon; ITEM_STATE( GRID_SPECIALTIES_FADEIN_NAME, forecolor 1 1 1 1, ; ) )												\
		/* specialty 1 desc */																																					\
		PREPROC_TEXT_DRAW_VIS_EX( (CHOICE_X_START) (GRID_SPECIALTIES_INFO_Y+141) (SPECIALTY_LOADOUT_WIDTH-50) 18 GRID_SPECIALTIES_INFO_ALIGN, 0 0,								\
								  "@" + GetItemDesc( GetCurrentItemIndex() ), SPECIALTY_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR_NO_ALPHA,	\
								  when( ( dvarString( "ui_grid_specialties_vis" ) == "1" ) || ( dvarString( "ui_item_info_left_vis" ) == "1" ) ),								\
								  autowrapped; name grid_specialty_1_desc;																										\
								  ITEM_STATE( GRID_SPECIALTIES_FADEIN_NAME, forecolor CHOICE_TEXTCOLOR; , ; ) )																	\
		/* clear Specialties button */																																			\
		itemDef																																									\
		{																																										\
			type			ITEM_TYPE_BUTTON																																	\
			text			"@PLATFORM_CLEAR_PERKS"																																\
			rect			(SPECIALTY_IMAGE_X) (-50) SPECIALTY_LOADOUT_WIDTH 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM													\
			style			WINDOW_STYLE_FILLED																																	\
			textstyle		ITEM_TEXTSTYLE_SHADOWED																																\
			textfont		CHOICE_TEXTFONT																																		\
			textscale		TEXTSIZE_SMALL																																		\
			textalign		ITEM_ALIGN_LEFT																																		\
			textaligny		18																																					\
			visible			when( dvarString( "ui_grid_specialties_vis" ) == "1" && dvarString( "ui_inside_popup" ) == "specialties" )											\
		}

#define GRID_BUTTON_SPECIALTIES_DUMMY( itemIndex, xOffset, yOffset, textArg, actionArg, onFocusArg, leaveFocusArg, visArg, extraArgs ) \
		CHOICE_BUTTON_BG_SOLID_RECT_EX( GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), (CHOICE_SIZE_Y+2), HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ),\
									 BG_SOLID_COLOR_NO_ALPHA, when( visArg );, \
									 name GRID_BUTTON_NAME"_outline"#itemIndex; ITEM_STATE_FADEOUT( BG_SOLID_COLOR, ;) ) \
		CHOICE_HIGHLIGHT_SOLID_RECT_EX( itemIndex, GRID_RECT_CUSTOM( xOffset, yOffset, SPECIALTIES_BUTTON_WIDTH, CHOICE_SIZE_Y, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ), \
										BG_HL_COLOR_NO_ALPHA, visArg, \
										name GRID_BUTTON_NAME"_rect"#itemIndex; ITEM_STATE_FADEOUT( GRID_OUTLINE_COLOR, ; ) ) \
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX( itemIndex, GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), (CHOICE_SIZE_Y+2), HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ), \
											  GRID_BUTTON_NAME, textArg, CHOICE_TEXTCOLOR_NO_ALPHA, actionArg, onFocusArg, leaveFocusArg, \
											  when( visArg );, \
											  ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR, ; ); extraArgs ) 

#define GRID_BUTTON_SPECIALTIES( itemIndex, xOffset, yOffset, actionArg, dropDownDuration, visArg, extraArgs ) \
		CHOICE_BUTTON_BG_SOLID_RECT_EX( GRID_RECT_SPECIALTIES_OUTLINE_RIGHT( xOffset, yOffset ), BG_SOLID_COLOR, visArg, \
									 name GRID_BUTTON_NAME"_outline"#itemIndex; \
									 ITEM_STATE_FADEOUT( BG_SOLID_COLOR_NO_ALPHA, ; ); \
									 ITEM_STATE( STATE_SLIDE_RIGHT, rect GRID_RECT_SPECIALTIES_OUTLINE_RIGHT( (xOffset+GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ); \
									 ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_SPECIALTIES_OUTLINE_RIGHT( xOffset, yOffset-SLIDE_DISTANCE_SPECIALTIES ); forecolor 1 1 1 0;, ; ) ) \
		CHOICE_HIGHLIGHT_SOLID_RECT_EX( itemIndex, GRID_RECT_SPECIALTIES_HIGHLIGHT_RIGHT( xOffset, yOffset ), BG_HL_COLOR, visArg, \
										name GRID_BUTTON_NAME"_rect"#itemIndex; \
										ITEM_STATE_FADEOUT( BG_HL_COLOR_NO_ALPHA, ; ); \
										ITEM_STATE( STATE_SLIDE_RIGHT, rect GRID_RECT_SPECIALTIES_HIGHLIGHT_RIGHT( (xOffset+GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ); \
										ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_SPECIALTIES_HIGHLIGHT_RIGHT( xOffset, yOffset-SLIDE_DISTANCE_SPECIALTIES ), ; ) ) \
		CHOICE_BUTTON_RECT_FOCUS_VIS_NOHI_EX(	itemIndex, GRID_RECT_SPECIALTIES_OUTLINE_RIGHT( xOffset, yOffset ), GRID_BUTTON_NAME, "", CHOICE_TEXTCOLOR, actionArg; setfocus GRID_DROPDOWN_LIST_NAME#itemIndex;, \
												;, ;, visArg, \
												ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR_NO_ALPHA, ; ); \
												ITEM_STATE( STATE_SLIDE_RIGHT, rect GRID_RECT_SPECIALTIES_OUTLINE_RIGHT( (xOffset+GRID_BUTTON_SLIDE_DISTANCE), yOffset ), ; ); \
												ITEM_STATE( STATE_SLIDE_UP, rect GRID_RECT_SPECIALTIES_OUTLINE_RIGHT( xOffset, yOffset-SLIDE_DISTANCE_SPECIALTIES ), \
															ITEM_ANIMATE( menu_cac_custom, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, Maximized, dropDownDuration ); \
															ITEM_ANIMATE( menu_cac_custom, GRID_DROPDOWN_LIST_NAME#itemIndex, Maximized, dropDownDuration ); ); \
												extraArgs ) 

			
//=========================================================
//====================== Lists ============================
//=========================================================

#define GRID_BUTTON_DROPDOWN_LIST_RIGHT( itemIndex, xOffset, yOffset, textArg, actionArg, slideDistance, slideDuration, onFocusArg, leaveFocusArg, dropDownDuration, visArg, extraArgs ) \			
		GRID_BUTTON_RIGHT( itemIndex, xOffset, yOffset, textArg, \
						   GRID_BUTTON_ANIMATE( menu_cac_custom, itemIndex, STATE_SLIDE_UP, slideDuration ); actionArg; setfocus GRID_DROPDOWN_LIST_NAME#itemIndex;, \
						   slideDistance, dropDownDuration, onFocusArg, leaveFocusArg, visArg, extraArgs ) 

#define GRID_DROPDOWN_LIST_RIGHT( itemIndex, feederType, menuName, xOffset, yOffset, listHeight, listBgHeight, elementHeightArg, execCommand, onActionArg, dropDownDuration, onEnterArgs, selectionChangeArgs, visArg, extraArgs ) \
		GRID_DROPDOWN_LIST( itemIndex, feederType, menuName, xOffset, yOffset, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP, \
							listHeight, listBgHeight, elementHeightArg, execCommand, onActionArg, dropDownDuration, onEnterArgs, selectionChangeArgs, visArg, extraArgs ) \
		
#define GRID_BUTTON_DROPDOWN_LIST_LEFT( itemIndex, yOffset, textArg, actionArg, slideDistance, slideDuration, onFocusArg, leaveFocusArg, dropDownDuration, visArg, extraArgs ) \
		GRID_BUTTON_LEFT( itemIndex, yOffset, textArg, \
						  GRID_BUTTON_ANIMATE( menu_cac_custom, itemIndex, STATE_SLIDE_UP, slideDuration ); actionArg; setfocus GRID_DROPDOWN_LIST_NAME#itemIndex;,\
						  slideDistance, dropDownDuration, onFocusArg, leaveFocusArg, visArg, extraArgs ) 

#define GRID_DROPDOWN_LIST_LEFT( itemIndex, feederType, menuName, xOffset, yOffset, listHeight, listBgHeight, elementHeightArg, execCommand, onActionArg, dropDownDuration, onEnterArgs, selectionChangeArgs, visArg, extraArgs ) \
		GRID_DROPDOWN_LIST( itemIndex, feederType, menuName, xOffset, yOffset, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP, \
							listHeight, listBgHeight, elementHeightArg, execCommand, onActionArg, dropDownDuration, onEnterArgs, selectionChangeArgs, visArg, extraArgs ) \
		
#define GRID_DROPDOWN_LIST( itemIndex, feederType, menuName, xOffset, yOffset, horizontalAlign, vertAlign, listHeight, listBgHeight, elementHeightArg, execCommand, onActionArg, dropDownDuration, onEnterArgs, selectionChangeArgs, visArg, extraArgs ) \
		itemDef \
		{ \
			name			GRID_DROPDOWN_LIST_BG_NAME#itemIndex \
			style			WINDOW_STYLE_SHADER \
			rect			GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1+(CHOICE_SIZE_Y+2)), (BUTTON_BG_WIDTH+4), 0, horizontalAlign, vertAlign ) \
			forecolor		MEDIUM_GRAY_NO_ALPHA \
			background		"white" \ 
			visible			visArg \ 
			decoration \ 
			state \
            { \
                  name          "Maximized" \
				  forecolor		BG_SOLID_COLOR \  
                  rect          GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1+(CHOICE_SIZE_Y+2)), (BUTTON_BG_WIDTH+4), listBgHeight, horizontalAlign, vertAlign ) \
            } \    
		} \
		itemDef\
		{ \
			name						GRID_DROPDOWN_LIST_NAME#itemIndex \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1+(CHOICE_SIZE_Y+2)), (BUTTON_BG_WIDTH+4), 0, horizontalAlign, vertAlign ) \
			origin						0 0 \
			elementwidth				30 \
			elementheight				elementHeightArg \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_SHADOWED \
			textfont					UI_FONT_NORMAL \
			textscale					TEXTSIZE_SMALL \
			textalignx					12 \
			forecolor					CHOICE_TEXTCOLOR_NO_ALPHA \
			focusColor					CHOICE_TEXTCOLOR_NO_ALPHA \
			disableColor				CHOICE_TEXTCOLOR_NO_ALPHA \
			outlinecolor				LIGHT_GRAY_NO_ALPHA  \
			noscrollbars \
			modal \
			noBlinkingHighlight \
			/*					x				y	w	h	len	horzAlign		vertAlign*/ \
			userarea	7		10				-4  150	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Name */
								10				-4	150	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Desc */
								2				 1	16	16	16	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Image */ 
								((BUTTON_BG_WIDTH+4)-60)	-4	50	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \	/* Cost */
								((BUTTON_BG_WIDTH+4)-70)	0	16	16	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \	/* Lock */
								((BUTTON_BG_WIDTH+4)-60)	0	50	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \	/* Count */
								2				1	16  16	16	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Extra Image */
			visible			visArg \
			onfocus  \
			{ \
				play CHOICE_FOCUS_SOUND; \
			}	\
			onListboxSelectionChange \
			{ \
				play CHOICE_FOCUS_SOUND; \
				selectionChangeArgs \
			} \
			doubleclick \
			{ \
				if ( isCurrentItemPurchased() ) \
				{ \
					play CHOICE_FOCUS_SOUND; \
					execnow execCommand;\
					ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, default, dropDownDuration ); \
					ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_NAME#itemIndex, Minimized, dropDownDuration ); \ 
					GRID_BUTTON_RESET_POS( menuName, itemIndex ) \
					onActionArg; \
				} \
				elseif ( !isItemlocked( GetCurrentItemIndex() ) && ( getCurrentItemCost() <= GetStatByName( "CODPOINTS" ) ) )\
				{ \
					open "PurchaseConfirmation"; \
				} \
			} \
			execKeyInt BUTTON_B \
			{ \
				play CHOICE_FOCUS_SOUND; \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, default, dropDownDuration ); \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_NAME#itemIndex, Minimized, dropDownDuration ); \
				GRID_BUTTON_RESET_POS( menuName, itemIndex ) \
				onActionArg; \
			} \
			execKeyInt KEY_ESCAPE \
			{ \
				play CHOICE_FOCUS_SOUND; \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, default, dropDownDuration ); \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_NAME#itemIndex, Minimized, dropDownDuration ); \
				GRID_BUTTON_RESET_POS( menuName, itemIndex ) \
				onActionArg; \
			} \
			leavefocus \
			{ \
				play CHOICE_FOCUS_SOUND; \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, default, dropDownDuration ); \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_NAME#itemIndex, Minimized, dropDownDuration ); \ 
				GRID_BUTTON_RESET_POS( menuName, itemIndex ) \
				onActionArg; \
			} \
			extraArgs \
			state \
            { \
					name				"Maximized" \
                    rect				GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1+(CHOICE_SIZE_Y+2)), (BUTTON_BG_WIDTH+4), listHeight, horizontalAlign, vertAlign ) \
					forecolor			CHOICE_TEXTCOLOR \
					focusColor			CHOICE_TEXTCOLOR \
					outlinecolor		LIGHT_GRAY  \
					onEnter \
					{ \
						onEnterArgs; \
					} \
            }   \
			state \
            { \
                    name				"Minimized" \
                    rect				GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1+(CHOICE_SIZE_Y+2)), (BUTTON_BG_WIDTH+4), 0, horizontalAlign, vertAlign ) \
					forecolor			CHOICE_TEXTCOLOR_NO_ALPHA \
					focusColor			CHOICE_TEXTCOLOR_NO_ALPHA \
					outlinecolor		LIGHT_GRAY_NO_ALPHA  \					  
					onEnter \
					{ \
						setfocus GRID_BUTTON_NAME#itemIndex; \
						execnow "set ui_inside_popup 0";\
					} \
            } \ 
		}


#define GRID_DROPDOWN_LIST_SPECIALTIES( itemIndex, feederType, menuName, xOffset, yOffset, listHeight, list_bg_height, elementHeightArg, execCommand, onActionArg, dropDownDuration, onEnterArgs, visArg, extraArgs ) \
		itemDef \
		{ \
			name			GRID_DROPDOWN_LIST_BG_NAME#itemIndex \
			style			WINDOW_STYLE_SHADER \
			rect			GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), 0, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ) \
			forecolor		MEDIUM_GRAY_NO_ALPHA \
			background		"white" \ 
			visible			visArg \ 
			decoration \ 
			state \
            { \
                  name          "Maximized" \
				  forecolor		BG_SOLID_COLOR \  
                  rect          GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), list_bg_height, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ) \
            } \    
		} \
		itemDef\
		{ \
			name						GRID_DROPDOWN_LIST_NAME#itemIndex \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), 0, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ) \
			origin						0 0 \
			elementwidth				30 \
			elementheight				elementHeightArg \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_SHADOWED \
			textfont					UI_FONT_NORMAL \
			textscale					TEXTSIZE_SMALL \
			textalignx					12 \
			forecolor					CHOICE_TEXTCOLOR_NO_ALPHA \
			focusColor					CHOICE_TEXTCOLOR_NO_ALPHA \
			disableColor				CHOICE_TEXTCOLOR_NO_ALPHA \
			outlinecolor				LIGHT_GRAY_NO_ALPHA  \
			noscrollbars \
			modal \
			noBlinkingHighlight \
			/*				x				y	w	h	len	horzAlign		vertAlign*/ \
			userarea	7	30				-4  150	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Name */
							30				-4	150	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Desc */
							20				1	16	16	16	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Image */ 
							((SPECIALTIES_BUTTON_WIDTH+4)-70)	-4	50	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Cost */
							((SPECIALTIES_BUTTON_WIDTH+4)-80)	0	16	16	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Lock */
							((SPECIALTIES_BUTTON_WIDTH+4)-70)	0	50	20	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Count */
							2				1	16  16	16	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Extra Image */
			visible			visArg \
			onfocus  \
			{ \
				play CHOICE_FOCUS_SOUND; \
			}	\
			onListboxSelectionChange \
			{ \
				play CHOICE_FOCUS_SOUND; \
			} \
			doubleclick \
			{ \
				if ( isCurrentItemPurchased() ) \
				{ \
					play CHOICE_FOCUS_SOUND; \
					execnow execCommand;\
				} \
				elseif ( !isItemlocked( GetCurrentItemIndex() ) && ( getCurrentItemCost() <= GetStatByName( "CODPOINTS" ) ) )\
				{ \
					open "PurchaseConfirmation"; \
				} \
			} \
			execKeyInt BUTTON_B \
			{ \
				play CHOICE_FOCUS_SOUND; \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, default, dropDownDuration ); \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_NAME#itemIndex, Minimized, dropDownDuration ); \ 
				onActionArg; \
			} \
			execKeyInt KEY_ESCAPE \
			{ \
				play CHOICE_FOCUS_SOUND; \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, default, dropDownDuration ); \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_NAME#itemIndex, Minimized, dropDownDuration ); \ 
				onActionArg; \
			} \
			leavefocus \
			{ \
				play CHOICE_FOCUS_SOUND; \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_BG_NAME#itemIndex, default, dropDownDuration ); \
				ITEM_ANIMATE( menuName, GRID_DROPDOWN_LIST_NAME#itemIndex, Minimized, dropDownDuration ); \ 
				onActionArg; \
			} \
			extraArgs \
			state \
            { \
					name				"Maximized" \
                    rect				GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), listHeight, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ) \
					forecolor			CHOICE_TEXTCOLOR \
					focusColor			CHOICE_TEXTCOLOR \
					outlinecolor		LIGHT_GRAY  \
					onEnter \
					{ \
						onEnterArgs; \
					} \
            }   \
			state \
            { \
                    name				"Minimized" \
                    rect				GRID_RECT_CUSTOM( (xOffset-2), (yOffset-1), (SPECIALTIES_BUTTON_WIDTH+4), 0, HORIZONTAL_ALIGN_CENTER, VERTICAL_ALIGN_TOP ) \
					forecolor			CHOICE_TEXTCOLOR_NO_ALPHA \
					focusColor			CHOICE_TEXTCOLOR_NO_ALPHA \
					outlinecolor		LIGHT_GRAY_NO_ALPHA  \					  
					onEnter \
					{ \
						setfocus GRID_BUTTON_NAME#itemIndex; \
						execnow "set ui_inside_popup 0";\
					} \
            } \ 
			execKeyInt BUTTON_Y \
			{ \
				play CHOICE_FOCUS_SOUND; \
				CAC_SETUP_ACTION_CLEAR_SLOTS \
			} \
		}
