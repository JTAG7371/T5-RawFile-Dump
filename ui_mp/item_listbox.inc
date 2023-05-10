#undef SELECT_ICON	

#ifdef XENON
	#define SELECT_ICON	"ui_button_xenon_3d_a_32x32"
#endif
#ifdef PS3
	#define SELECT_ICON	"ui_button_ps3_x_32x32"
#endif

#define ITEM_LISTBOX( listName, feederType, actionArg, visArg ) \
		ITEM_LISTBOX_EX( listName, feederType, actionArg, ;, ;, visArg, ; ) \


#define ITEM_LISTBOX_SEL( listName, feederType, actionArg, selectionArg, visArg ) \
		ITEM_LISTBOX_EX( listName, feederType, actionArg, ;, selectionArg, visArg, ; ) \
	
#ifdef PC
	#define ITEM_LISTBOX_EX_PLATFORM_OPTIONS	\
		usePaging
#else //#ifdef PC
	#define ITEM_LISTBOX_EX_PLATFORM_OPTIONS	\
		noscrollbars
#endif //#ifdef PC

#define ITEM_LISTBOX_EX( listName, feederType, actionArg, focusArg, selectionArg, visArg, extraArgs )																\
		itemDef																																						\
		{																																							\
			name						listName																													\
			type						ITEM_TYPE_LISTBOX																											\
			feeder						feederType																													\
			rect						LIST_X_START LIST_Y_START LIST_WIDTH LIST_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN								\
			origin						0 0																															\
			elementwidth				30																															\
			elementheight				17																															\
			elementtype					LISTBOX_TEXT																												\
			textstyle					ITEM_TEXTSTYLE_NORMAL																										\
			textfont					UI_FONT_NORMAL																												\
			textscale					TEXTSIZE_SMALL																												\
			textalignx					12																															\
			forecolor					CHOICE_TEXTCOLOR																											\
			focusColor					CHOICE_TEXTCOLOR																											\
			disableColor				CHOICE_TEXTCOLOR																											\
			noBlinkingHighlight																																		\
			ITEM_LISTBOX_EX_PLATFORM_OPTIONS																														\
			/*				x						y					w					h			len	horzAlign		vertAlign*/								\
			userarea	8	-1						0					(BUTTON_BG_WIDTH+1)	17			32	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE	/* Background */	\				
							12						0					BUTTON_BG_WIDTH		17			32	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE	/* Name */			\				
							20						1					15					15			16	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE	/* Image */ 		\				
							(BUTTON_BG_WIDTH-85)	0					50					17			24	ITEM_ALIGN_RIGHT ITEM_ALIGN_MIDDLE	/* Cost */			\				
							(BUTTON_BG_WIDTH-15)	(17/2-LOCK_SIZE/2)	LOCK_SIZE			LOCK_SIZE	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE	/* Lock */			\				
							(BUTTON_BG_WIDTH-100)	0					50					17			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE	/* Count */			\				
							1						0					16 					17			16	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE	/* Extra Image */	\					
							BUTTON_BG_WIDTH			0					34 					17			16	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE	/* New Icon */		\			
			visible			visArg																																	\
			onfocus																																					\
			{																																						\
				play CHOICE_FOCUS_SOUND;																															\
				focusArg																																			\
			}																																						\
			onListboxSelectionChange																																\
			{																																						\
				play CHOICE_FOCUS_SOUND;																															\
				selectionArg																																		\
			}																																						\
			doubleclick																																				\		
			{																																						\
				actionArg;																																			\
			}																																						\
			extraArgs																																				\
		}


#define SORTED_ITEM_LISTBOX( listName, feederType, actionArg, visArg ) \
		SORTED_ITEM_LISTBOX_EX( listName, feederType, actionArg, visArg, ; ) 

#define SORTED_ITEM_ELEM_HEIGHT	19

#define SORTED_ITEM_LISTBOX_EX( listName, feederType, actionArg, visArg, extraArgs ) \
		itemDef \
		{ \
			name						listName \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						LIST_X_START LIST_Y_START LIST_WIDTH LIST_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
			origin						0 0 \
			elementwidth				30 \
			elementheight				SORTED_ITEM_ELEM_HEIGHT \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_NORMAL \
			textfont					UI_FONT_NORMAL \
			textscale					TEXTSIZE_DEFAULT \
			textalignx					12 \
			forecolor					NEW_FRAME_COMMON_TEXT_COLOR \
			focusColor					CHOICE_TEXTCOLOR \
			disableColor				CHOICE_TEXTCOLOR \
			noscrollbars \
			selectIcon					SELECT_ICON \
			outlineColor				NEW_FRAME_COMMON_HIGHLIGHT_COLOR \
			elementBackgroundColor		NEW_FRAME_TRANSPARENCY \
			noBlinkingHighlight \
			modal \
			/*				x					y					w							h							len		horzAlign		vertAlign*/ \
			userarea	5	26					0					LIST_WIDTH					(SORTED_ITEM_ELEM_HEIGHT-1)	32		ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \		/* Name		*/
							20					1					(SORTED_ITEM_ELEM_HEIGHT-2)	(SORTED_ITEM_ELEM_HEIGHT-2)	16		ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \		/* Image	*/ 
							(LIST_WIDTH-70)		0					50							(SORTED_ITEM_ELEM_HEIGHT-1)	24		ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \		/* Cost		*/
							(LIST_WIDTH)		(17/2-LOCK_SIZE/2)	LOCK_SIZE					LOCK_SIZE					24		ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \		/* Lock		*/
							(LIST_WIDTH-95)		0					50							(SORTED_ITEM_ELEM_HEIGHT-1)	24		ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \		/* Count	*/
			visible			visArg			\
			onfocus							\
			{								\
				play CHOICE_FOCUS_SOUND;	\
			}								\
			onListboxSelectionChange		\
			{								\
				play CHOICE_FOCUS_SOUND;	\
			}								\
			doubleclick						\
			{								\
				actionArg					\
			}								\
			extraArgs						\
		}

#define ATTACHMENTS_LISTBOX_EX( listName, feederType, actionArg, focusArg, selectionArg, visArg, extraArgs )											\
		itemDef																																			\
		{																																				\
			name						listName																										\
			type						ITEM_TYPE_LISTBOX																								\
			feeder						feederType																										\
			rect						LIST_X_START LIST_Y_START LIST_WIDTH LIST_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN					\
			origin						0 0																												\
			elementwidth				30																												\
			elementheight				17																												\
			elementtype					LISTBOX_TEXT																									\
			textstyle					ITEM_TEXTSTYLE_NORMAL																							\
			textfont					UI_FONT_NORMAL																									\
			textscale					TEXTSIZE_SMALL																									\
			textalignx					12																												\
			forecolor					NEW_FRAME_COMMON_TEXT_COLOR																						\
			focusColor					CHOICE_TEXTCOLOR																								\
			disableColor				CHOICE_TEXTCOLOR																								\
			noscrollbars																																\
			selectIcon					SELECT_ICON																										\
			noBlinkingHighlight																															\
			outlineColor				NEW_FRAME_COMMON_HIGHLIGHT_COLOR																				\
			elementBackgroundColor		NEW_FRAME_TRANSPARENCY																							\
			modal																																		\
			/*				x						y					w				h			len	horzAlign		vertAlign*/						\
			userarea	4	28						0					BUTTON_BG_WIDTH	17			32	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE /* Name */	\				
							20						1					15				15			16	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE /* Image */	\				 
							(BUTTON_BG_WIDTH-60)	0					50				17			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE /* Cost */	\				
							(BUTTON_BG_WIDTH)		(17/2-LOCK_SIZE/2)	LOCK_SIZE		LOCK_SIZE	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE /* Lock */	\				
			visible			visArg																														\
			onfocus																																		\
			{																																			\
				play CHOICE_FOCUS_SOUND;																												\
				focusArg																																\
			}																																			\
			onListboxSelectionChange																													\
			{																																			\
				play CHOICE_FOCUS_SOUND;																												\
				selectionArg;																															\
			}																																			\
			doubleclick																																	\
			{																																			\
				actionArg																																\
			}																																			\
			extraArgs																																	\
		}

#define SORTED_GLOBAL_EDIT_ITEM_LISTBOX( listName, feederType, command, visArg ) \
		SORTED_GLOBAL_EDIT_ITEM_LISTBOX_EX( listName, feederType, command, visArg, ; ) 

#define SORTED_GLOBAL_EDIT_ITEM_LISTBOX_EX( listName, feederType, command, visArg, extraArgs ) \
		itemDef \
		{ \
			name						listName \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						LIST_X_START LIST_Y_START LIST_WIDTH LIST_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
			origin						0 0 \
			elementwidth				30 \
			elementheight				16 \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_SHADOWED \
			textfont					UI_FONT_NORMAL \
			textscale					TEXTSIZE_SMALL \
			textalignx					12 \
			forecolor					CHOICE_TEXTCOLOR \
			focusColor					CHOICE_TEXTCOLOR \
			disableColor				CHOICE_TEXTCOLOR \
			selectBorder				0.8 0.95 1 0 \
			outlinecolor				MEDIUM_GRAY \
			noscrollbars \
			noBlinkingHighlight \
			/*				x				y					w			h			len	horzAlign		vertAlign*/ \
			userarea	7	15				-4  				150			20			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Name */
							15				-4					150			20			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Desc */
							20				1					0			0			0	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Image */ 
							(LIST_WIDTH-60)	-4					50			20			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Cost */
							(LIST_WIDTH)	(16/2-LOCK_SIZE/2)	LOCK_SIZE	LOCK_SIZE	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Lock */
							(LIST_WIDTH-60)	0					50			20			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Count */
							2				1					16  		16			16	ITEM_ALIGN_LEFT	ITEM_ALIGN_TOP \				/* Extra Image */
			visible			visArg \
			onfocus \
			{ \
				play CHOICE_FOCUS_SOUND; \
			} \
			onListboxSelectionChange \
			{ \
				play CHOICE_FOCUS_SOUND; \
			} \
			doubleclick \
			{ \
				play CHOICE_FOCUS_SOUND; \
				command; \
			} \
			extraArgs \
		}

#define CONTRACTS_LISTBOX_EX( listName, feederType, execCommand, visArg, extraArgs ) \
		itemDef\
		{ \
			name						listName \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						CONTRACTS_LIST_X_START CONTRACTS_LIST_Y_START LIST_WIDTH LIST_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
			origin						0 0 \
			elementwidth				30 \
			elementheight				18 \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_SHADOWED \
			textfont					UI_FONT_NORMAL \
			textscale					CHOICE_TEXTSIZE \
			textalignx					12 \
			forecolor					CHOICE_TEXTCOLOR \
			focusColor					CHOICE_TEXTCOLOR \
			disableColor				CHOICE_TEXTCOLOR \
			selectBorder				0.8 0.95 1 0 \
			outlinecolor				1 0.97 0.72 0.5  \
			outlinecolor				MEDIUM_GRAY \
			noBlinkingHighlight \
			noscrollbars \
			/*					x				y	w			h	len		horzAlign			vertAlign*/ \
			userarea	3		15				-1	LIST_WIDTH	20	32		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP \ 	/* Name */
								(LIST_WIDTH-65)	-1	50			20	24		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP \	/* Cost */
								5				1	18  		18	16		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP \ 	/* A Button */
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
				if ( !IsContractInProgress( GetCurrentContractIndex() ) && ( GetContractCost( GetCurrentContractIndex() ) <= GetStatByName( "CODPOINTS" ) ) ) \
				{ \
					open "PurchaseContractConfirmation"; \
				} \
			} \
			execKeyInt BUTTON_B \
			{ \
				execnow focusitem ( "contract_slot_button_"+(dvarint( ui_activeContract )+1) ); \
			} \
			extraArgs \
		}

#define COMBAT_RECORD_LISTBOX_EX( listName, feederType, execCommand, visArg, extraArgs ) \
		itemDef\
		{ \
			name						listName \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						COMBAT_RECORD_LIST_X_START COMBAT_RECORD_LIST_Y_START LIST_WIDTH LIST_HEIGHT CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
			origin						0 0 \
			elementwidth				30 \
			elementheight				18 \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_NORMAL \
			textfont					UI_FONT_NORMAL \
			textscale					CHOICE_TEXTSIZE \
			textaligny					-2 \
			textalignx					12 \
			forecolor					NEW_FRAME_COMMON_TEXT_COLOR \
			focusColor					CHOICE_TEXTCOLOR \
			disableColor				CHOICE_TEXTCOLOR \
			selectBorder				0.8 0.95 1 0 \
			outlinecolor				NEW_FRAME_COMMON_HIGHLIGHT_COLOR  \
			elementHighlightColor		NEW_FRAME_COMMON_HIGHLIGHT_TEXT_COLOR  \
			elementBackgroundColor		NEW_FRAME_TRANSPARENCY  \
			noBlinkingHighlight \
			modal \
			noscrollbars \
			/*					x				y	w			h	len		horzAlign			vertAlign*/ \
			userarea	1		0				-1	LIST_WIDTH	20	32		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP \ 	/* Name */
			visible			visArg \
			onfocus  \
			{ \
			} \
			onListboxSelectionChange \
			{ \
				play CHOICE_FOCUS_SOUND; \
			} \
			doubleclick \
			{ \
			} \
			extraArgs \
		}
		
#define PERSONAL_BEST_LISTBOX( listName, feederType ) \
		itemDef\
		{ \
			name						listName \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						LIST_X_START LIST_Y_START LIST_WIDTH LIST_HEIGHT HORIZONTAL_ALIGN_CENTER CHOICE_VERTICAL_ALIGN \
			origin						0 0 \
			elementwidth				30 \
			elementheight				18 \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_SHADOWED \
			textfont					UI_FONT_NORMAL \
			textscale					CHOICE_TEXTSIZE \
			textalignx					12 \
			forecolor					CHOICE_TEXTCOLOR \
			focusColor					CHOICE_TEXTCOLOR \
			disableColor				CHOICE_TEXTCOLOR \
			noscrollbars \
			decoration \
			/*					x					y	w			h	len		horzAlign			vertAlign*/ \
			userarea	3		10					-4  250			20	36		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP \	/* Name */
								(LIST_WIDTH-180)	-4	150			20	24		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP \	/* value */
								(LIST_WIDTH-60)		-4	50			20	24		ITEM_ALIGN_LEFT		ITEM_ALIGN_TOP \	/* delta */
			visible			1\
		}
		
