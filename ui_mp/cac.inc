// general definitions

#undef	ORIGIN_TITLE
#define ORIGIN_TITLE				0 0

#ifdef CONSOLE
	#define CHOICE_X_START			-275
	#define CHOICE_Y_START			90
	#define RECT_ALIGN				;
#else
	#define CHOICE_X_START			-270
	#define CHOICE_Y_START			90
	#define RECT_ALIGN				;
#endif

#undef CHOICE_GROUP
#define CHOICE_GROUP CAC_MENU_NAME

#define BUTTON_BG_WIDTH				NEW_FRAME_BUTTON_WIDTH

#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"
 
#define MENU_FONT_COLOR2			1 1 1 0.5

#include "ui_mp/stats_info.inc"
#include "ui/framestyle.inc"
#include "ui_mp/newframe.inc"
#include "ui_mp/popup_player_info.inc"
#include "ui_mp/item_animate.inc"
#include "ui_mp/grid_common.inc"
#include "ui_mp/cac_viewer.inc"
#include "ui_mp/armor.inc"
#include "ui_mp/custom_mode.inc"

#define LIST_Y_START				110
#define LIST_HEIGHT					234
#define LIST_WIDTH					440
#define	LIST_ELEM_HEIGHT			18
#define LIST_X_START				0

#undef	CHOICE_TEXTSTYLE
#define	CHOICE_TEXTSTYLE			ITEM_TEXTSTYLE_NORMAL

#undef	CHOICE_VERTICAL_ALIGN
#define	CHOICE_VERTICAL_ALIGN		VERTICAL_ALIGN_CENTER

#undef	CHOICE_HORIZONTAL_ALIGN
#define	CHOICE_HORIZONTAL_ALIGN		HORIZONTAL_ALIGN_CENTER

#include "ui_mp/item_listbox.inc"

#ifdef PC
	#define UPLOADSTATS_CAC_PC_ONLY execnow "uploadstats";
#else //#ifdef PC
	#define UPLOADSTATS_CAC_PC_ONLY
#endif //#ifdef PC

#undef ON_ESC
#define ON_ESC																										\
	if ( dvarString( "ui_inside_popup" ) != "0" )																		\
	{																													\
		play CHOICE_FOCUS_SOUND;																					\
		execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;														\
	}																														\
	else																													\
	{																														\
		UPLOADSTATS_CAC_PC_ONLY																							\
		VIEWER_SET_EQUIP_WEAPON( primary );																				\
		VIEWER_SET_PLAYER_CAMERA( player );																				\
		closeimmediate self;																							\
		execnow changemenuopenslidedirection ( dvarString( "cac_back_menu_name" ) ) MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT;	\
		execnow changemenucloseslidedirection CAC_MENU_NAME MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT;							\
		openimmediate dvarString( "cac_back_menu_name" )																\
	}

	menuDef	
	{
		name					CAC_MENU_NAME
		rect					0 0 640 480 RECT_ALIGN
		focuscolor				COLOR_FOCUSED
		style					WINDOW_STYLE_EMPTY 
		control					MENU_CONTROL_OPENER
		soundloop 				MENU_MUSIC
		openSlideSpeed			DEFAULT_SLIDE_IN_SPEED
		closeSlideSpeed			DEFAULT_SLIDE_OUT_SPEED
		openSlideDirection		MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT
		closeSlideDirection		MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT
		popup
		onOpen
		{		
			// Enable controls
			setLocalVarInt ui_disable_controls 0;
			// Reset all items
			execnow ui_animate CAC_MENU_NAME * Default 0;
			setdvar ui_inside_popup 0;
			SHOW_VIEWER
			SET_VIEWER_MODE_PLAYER;
			setdvar ui_show_reset "1";
			setLocalVarBool ui_inside_dropdown 0;
		}
		onEsc
		{
			ON_ESC
		}
		onFocus 
		{  
			activateBlur;
			setLocalVarInt ui_highlight -1;
			setLocalVarString ui_choicegroup CHOICE_GROUP;
			if ( dvarBool( "ui_closeAfterPurchase" ) ) 
			{
				execnow	ui_animate CAC_MENU_NAME * CloseDropDownList 0;
				execnow set ui_closeAfterPurchase 0;
			}
		}
		onClose
		{
			HIDE_VIEWER;
			deactivateBlur;
		}

		#define CAC_HEIGHT				NEW_FRAME_DEFAULT_HEIGHT
		#define CAC_WIDTH				( CAC_HEIGHT * FRAME_ASPECT_RATIO )

		NEW_FRAME( CAC_WIDTH, CAC_HEIGHT )

		#include "ui_mp/cac_loadout.inc"

		#define IS_CUSTOM_CLASS_MODE	dvarInt( ui_useCustomClassInfo ) == 1
		#define IS_ONLINE_GAME				( dvarInt( splitscreen ) == 0 && dvarInt( systemlink ) == 0 )
		#define IS_BASICTRAINING_GAME		( dvarInt( xblive_basictraining ) > 0 )
		

		// Title
		NEW_FRAME_TITLE( CAC_WIDTH, CAC_HEIGHT, "@MPUI_CREATE_A_CLASS_CAPS", when( !IS_CUSTOM_CLASS_MODE ) )
		NEW_FRAME_TITLE( CAC_WIDTH, CAC_HEIGHT, "@CUSTOM_EDIT_CLASS_LOADOUT_CAPS", when( IS_CUSTOM_CLASS_MODE ) )
		NEW_FRAME_SUBTITLE( CAC_WIDTH, CAC_HEIGHT, dvarString( dvarString( ui_custom_name ) ), when( !IS_CUSTOM_CLASS_MODE && ( IS_ONLINE_GAME && !IS_BASICTRAINING_GAME ) ) )
		NEW_FRAME_SUBTITLE( CAC_WIDTH, CAC_HEIGHT, dvarString( dvarString( offline_custom_name ) ), when( !IS_CUSTOM_CLASS_MODE && ( !IS_ONLINE_GAME || IS_BASICTRAINING_GAME ) ) )
		NEW_FRAME_SUBTITLE( CAC_WIDTH, CAC_HEIGHT, dvarString( custom_class_name ), when( IS_CUSTOM_CLASS_MODE ) )
		
		PLAYER_INFO_VIS( CAC_WIDTH, CAC_HEIGHT, 1 )

		//=========================================================
		//================= ANIMATION CONTROLLER ==================
		//=========================================================

		#define CAC_SETUP_VIEWER(cam, weapon)		\
				VIEWER_SET_EQUIP_WEAPON(weapon);	\
				VIEWER_SET_PLAYER_CAMERA(cam);

		#define CAC_HEADER_NAME					"cac_header_"
		#define CAC_SELECTION_FADE_TIME			90
		#define CAC_SELECTION_SLIDE_TIME		80
		#define CAC_SELECTION_UNROLL_TIME		110
		#define CAC_COMMON_ANIMATION_STATES( rgbArg ) \
				NEW_FRAME_TRANSPARENT_STATE( rgbArg )

		#define CAC_NEW_RECT_STATE( nameArg, rectArg )	\
				state									\
				{										\
					name	nameArg						\
					rect	rectArg						\
				}

		// This is a dummy itemDef to disable controls.
		// Used when animating.
		itemDef
		{
			name	dummyButton
			type	ITEM_TYPE_BUTTON_NO_TEXT
			rect	0 0 0 0
			visible	when( localVarString( "ui_disable_controls" ) == 1 );
			
			execKeyInt APAD_UP {}
			execKeyInt DPAD_UP {}
			execKeyInt APAD_DOWN {}
			execKeyInt DPAD_DOWN {}
			execKeyInt APAD_LEFT {}
			execKeyInt DPAD_LEFT {}
			execKeyInt APAD_RIGHT {}
			execKeyInt DPAD_RIGHT {}
		}

		// This is a dummy itemDef that acts as the central hub for
		// animation control in the new CAC
		itemDef
		{
			name	anim_controller
			style	WINDOW_STYLE_SHADER
			rect	0 0 0 0
			visible 1
			decoration

			// Open dropdown
			state
			{
				name	OpenDropDownList
				onEnter
				{
					execnow ui_animate (CAC_MENU_NAME) * Transparent CAC_SELECTION_FADE_TIME;
					execnow ui_animate (CAC_MENU_NAME) list_hint Transparent 0;
					execnow ui_animate (CAC_MENU_NAME) (GRID_BUTTON_NAME+localVarInt(ui_cacButton)) Default 0;
					execnow ui_animate (CAC_MENU_NAME) anim_controller OpenDropDownList2 CAC_SELECTION_FADE_TIME;
				}
			}
			state
			{
				name	OpenDropDownList2
				onEnter
				{
					setLocalVarBool ui_inside_dropdown 1;
					execnow ui_animate (CAC_MENU_NAME) (GRID_BUTTON_NAME+localVarInt(ui_cacButton)) Top CAC_SELECTION_SLIDE_TIME;
					execnow ui_animate (CAC_MENU_NAME) anim_controller OpenDropDownList3 CAC_SELECTION_SLIDE_TIME;
				}
			}
			state
			{
				name	OpenDropDownList3
				onEnter
				{
					if ( localVarInt(ui_infoSide) == 1 )
					{
						ITEM_INFO_RIGHT_FADEIN( CAC_SELECTION_UNROLL_TIME );
					}
					setLocalVarInt ui_infoSide -1;
					execnow ui_animate (CAC_MENU_NAME) (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton)) Unrolled CAC_SELECTION_UNROLL_TIME;
					execnow ui_animate (CAC_MENU_NAME) x_button_prompt FadeIn CAC_SELECTION_UNROLL_TIME;
					execnow ui_animate (CAC_MENU_NAME) list_hint Default CAC_SELECTION_UNROLL_TIME;
					play uin_navigation_menu_sm_open;
				}
			}

			// Close dropdown
			state
			{
				name	CloseDropDownList
				onEnter
				{
					setLocalVarInt ui_disable_controls 1;
					setFocus dummyButton;
					if ( localVarString( ui_cacListboxCloseOverride ) != "" )
					{
						execnow ui_animate (CAC_MENU_NAME) (anim_controller) (localVarString( ui_cacListboxCloseOverride )) 0;
					}
					else
					{
						SET_VIEWER_MODE_PLAYER;
						CAC_SETUP_VIEWER(player, primary);
						execnow ui_animate (CAC_MENU_NAME) (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton)) Default CAC_SELECTION_UNROLL_TIME;
						execnow ui_animate (CAC_MENU_NAME) x_button_prompt Default CAC_SELECTION_UNROLL_TIME;
						execnow ui_animate (CAC_MENU_NAME) list_hint Transparent CAC_SELECTION_UNROLL_TIME;
						execnow ui_animate (CAC_MENU_NAME) anim_controller CloseDropDownList2 (CAC_SELECTION_UNROLL_TIME+30);
						ITEM_INFO_RIGHT_FADEOUT( CAC_SELECTION_UNROLL_TIME );
						play uin_navigation_menu_sm_close;
					}
				}
			}
			state
			{
				name	CloseDropDownList2
				onEnter
				{
					execnow "set ui_inside_popup 0";
					setLocalVarBool ui_inside_dropdown 0;
					execnow ui_animate (CAC_MENU_NAME) (GRID_BUTTON_NAME+localVarInt(ui_cacButton)) Default CAC_SELECTION_SLIDE_TIME;
					execnow ui_animate (CAC_MENU_NAME) anim_controller CloseDropDownList3 (CAC_SELECTION_SLIDE_TIME+30);
				}
			}
			state
			{
				name	CloseDropDownList3
				onEnter
				{
					execnow focusItem (GRID_BUTTON_NAME+localVarInt(ui_cacButton));
					setLocalVarInt ui_disable_controls 0;
					execnow ui_animate (CAC_MENU_NAME) * Default CAC_SELECTION_FADE_TIME;
				}
			}

			// Open color dropdown list
			state
			{
				name	OpenColorDropDownList
				onEnter
				{
					CAC_SETUP_VIEWER(player_head, primary);
					if ( GetItemName( GetFaceCamoIndex( STAT_CAC_FACEPAINT_PATTERN ) ) == "HEAD_STANDARD" )
					{
						setLocalVarString ui_cacListboxCloseOverride "";
						execnow ui_animate (CAC_MENU_NAME) (anim_controller) (CloseDropDownList) 0;
						play uin_navigation_zoom_out;
					}
					else
					{
						execnow ui_animate (CAC_MENU_NAME) (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton)) Default CAC_SELECTION_UNROLL_TIME;
						execnow ui_animate (CAC_MENU_NAME) (anim_controller) (OpenColorDropDownList2) (CAC_SELECTION_UNROLL_TIME+200);
						play uin_navigation_menu_sm_close;
					}
				}
			}
			state
			{
				name	OpenColorDropDownList2
				onEnter
				{
					execnow "set ui_inside_popup equipment_headcolor; set selected_loadout_slot facepaintcolor;";
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));					
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+"9");
					setLocalVarInt ui_disable_controls 0;
					SET_VIEWER_MODE_PLAYER_FACE_PATTERN_COLOR;
					execnow ui_animate (CAC_MENU_NAME) (GRID_DROPDOWN_LIST_NAME+"9") Unrolled CAC_SELECTION_UNROLL_TIME;
					setLocalVarString ui_cacListboxCloseOverride "";
					play uin_navigation_menu_sm_open;
				}
			}
		}

		#define CAN_PURCHASE_PRO_PERK ( isCurrentItemPurchased() && !IsProItemVersion( GetCurrentItemIndex() ) && IsProItemVersionUnlocked( GetCurrentItemIndex() ) && ( getProItemVersionCost( getCurrentItemIndex() ) <= GetStatByName( "CODPOINTS" ) ) )
		#define NOT_ENOUGH_CP_FOR_PRO ( isCurrentItemPurchased() && !IsProItemVersion( GetCurrentItemIndex() ) && IsProItemVersionUnlocked( GetCurrentItemIndex() ) && ( getProItemVersionCost( getCurrentItemIndex() ) > GetStatByName( "CODPOINTS" ) ) )
		#define CAN_CHECK_PRO_STATUS ( isCurrentItemPurchased() && !IsProItemVersion( GetCurrentItemIndex() ) && !IsProItemVersionUnlocked( GetCurrentItemIndex() ) && !dvarInt( ui_items_no_cost ) )
		#define IS_CUSTOM_MODE ( dvarInt( ui_items_no_cost ) )
		
		#define CAC_PRO_PERK_ACTION											\
			if ( CAN_PURCHASE_PRO_PERK )									\
			{																\
				play CHOICE_FOCUS_SOUND;									\
				open "PurchaseProConfirmation";								\
			}																\
			elseif( CAN_CHECK_PRO_STATUS )									\
			{																\
				play CHOICE_FOCUS_SOUND;									\
				execnow set globalChallengeType (GetCurrentItemName());		\
				execNow set perks_challenges_close 1;						\
				openImmediate menu_perks_challenges_list;					\
			}																\
			elseif( IS_CUSTOM_MODE )										\
			{																\
				play CHOICE_FOCUS_SOUND;									\
				CUSTOM_TOGGLE_PRO_PERKS										\
			}
					
		#define CAC_UPGRADE_ITEM_ACTION										\
			execKeyInt BUTTON_X												\
			{																\
				CAC_PRO_PERK_ACTION											\
			}

		//=========================================================
		//===================== LISTBOX SETUP =====================
		//=========================================================
#ifdef PC
	#define CAC_DROPDOWN_LIST_OPTIONS \
		usepaging
#else //#ifdef PC
	#define CAC_DROPDOWN_LIST_OPTIONS \
		noscrollbars
#endif //#ifdef PC

#define CAC_DROPDOWN_LIST( itemIndex, feederType, rectArg, execCommand, onActionArg, selectionChangeArgs, visArg, extraArgs, rclickAction ) \
		itemDef\
		{ \
			name						GRID_DROPDOWN_LIST_NAME#itemIndex \
			type						ITEM_TYPE_LISTBOX \
			feeder						feederType \
			rect						rectArg \
			origin						0 0 \
			elementwidth				30 \
			elementheight				17 \
			elementtype					LISTBOX_TEXT \
			textstyle					ITEM_TEXTSTYLE_NORMAL \
			textfont					UI_FONT_NORMAL \
			textscale					TEXTSIZE_SMALL \
			textalignx					12 \
			forecolor					CHOICE_TEXTCOLOR \
			focusColor					CHOICE_TEXTCOLOR \
			disableColor				CHOICE_TEXTCOLOR \
			CAC_DROPDOWN_LIST_OPTIONS \
			modal \
			noBlinkingHighlight \
			/*				x						y					w					h			len	horzAlign		vertAlign*/ \
			userarea	7	-1						0					(BUTTON_BG_WIDTH+1)	17			32	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Background */
							12						0					BUTTON_BG_WIDTH		17			32	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Name */
							20						1					15					15			16	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Image */ 
							(BUTTON_BG_WIDTH-60)	0					50					17			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Cost */
							(BUTTON_BG_WIDTH-15)	(17/2-LOCK_SIZE/2)	LOCK_SIZE			LOCK_SIZE	24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Lock */
							(BUTTON_BG_WIDTH-100)	0					50					17			24	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Count */
							1						0					16 					17			16	ITEM_ALIGN_LEFT	ITEM_ALIGN_MIDDLE \				/* Extra Image */
			visible			visArg \
			onfocus  \
			{ \
				setLocalVarString ui_cacListboxCloseOverride ""; \
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
					execCommand; \
					if( localVarInt( ui_cacOpenClearAttachmentNotification ) == 1 ) \
					{ \
						setDvar buyingAndEquippingProItem "0";	\
						execNow openMenu clearAttachmentNotification; \
						setLocalVarInt ui_cacOpenClearAttachmentNotification 0;	\
					} \
					else \
					{ \
						execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0; \
					} \
					onActionArg; \
				} \
				elseif ( !isItemlocked( GetCurrentItemIndex() ) && !IsCurrentItemClassified() && ( getCurrentItemCost() <= GetStatByName( "CODPOINTS" ) ) )\
				{ \
					open "PurchaseConfirmation"; \
				} \
			} \
			rightclick \
			{ \
				rclickAction; \
			} \
			execKeyInt BUTTON_B \
			{ \
				play CHOICE_FOCUS_SOUND; \
				execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0; \
				onActionArg; \
			} \
			execKeyInt KEY_ESCAPE \
			{ \
				play CHOICE_FOCUS_SOUND; \
				execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0; \
				onActionArg; \
			} \
			extraArgs \
		}
				
#ifdef CONSOLE
		//These need to be in cac_item_info for the PC menus to not cause strange highlights in the cac_main menu
		
		// Button indicies
		#define PRIMARY_WEAPON_BUTTON_INDEX			1
		#define SECONDARY_WEAPON_BUTTON_INDEX		2
		#define PRIMARY_GRENADE_BUTTON_INDEX		3
		#define SPECIAL_GRENADE_BUTTON_INDEX		4
		#define EQUIPMENT_BUTTON_INDEX				5
		#define PERK_1_BUTTON_INDEX					6
		#define PERK_2_BUTTON_INDEX					7
		#define PERK_3_BUTTON_INDEX					8
		#define FACEPAINT_BUTTON_INDEX				9
#endif //#ifdef CONSOLE

		//=========================================================
		//================ MENU SELECTION ACTIONS =================
		//=========================================================
		
		#define CAC_SETUP_ACTION_PRI																	\ 
				execNow setCurrentItemIndex ( STAT_CAC_PRIMARY );										\
				execnow "set ui_menu_selection_title @MPUI_PRIMARY_WEAPON";								\
				play CHOICE_FOCUS_SOUND;																\
				execnow "set selected_loadout_slot primary";											\
				execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));					\
				execnow "set ui_primary_selected Primary Weapon";										\
				CAC_SETUP_VIEWER(player, primary);														\
				execnow changemenucloseslidedirection CAC_MENU_NAME MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT; \
				execnow changemenuopenslidedirection cac_weapon MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT;		\
				closeimmediate self;																	\
				openimmediate "cac_weapon";
		
		#define CAC_PRI_BUTTON_VIS														\
				( !localVarInt( ui_inside_dropdown ) )

		#define CAC_SETUP_ACTION_SEC													\ 
				execNow setCurrentItemIndex ( STAT_CAC_SECONDARY );						\
				execnow "set ui_menu_selection_title @MPUI_SECONDARY_WEAPON";			\
				play CHOICE_FOCUS_SOUND;												\
				execnow "set selected_loadout_slot secondary";							\
				execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
				execnow "set ui_primary_selected Secondary Weapon";						\
				CAC_SETUP_VIEWER(player, secondary);									\
				closeimmediate self;													\
				openimmediate "cac_weapon";

		#define CAC_SEC_BUTTON_VIS														\
				( !localVarInt( ui_inside_dropdown ) )

		#define CAC_LEFT_BUTTON_ONFOCUS( itemIndex )									\ 
				execnow set ui_cac_main_hint_text "";									\
				execnow set cac_spec_focus itemIndex;									\
				CAC_SETUP_VIEWER(player, primary);
#ifdef PC
		#define CAC_BEGIN_BUTTON_ACTION_ANIMATION						\
			if ( !localVarBool( ui_inside_dropdown ) )					\
			{															\
				execnow ui_animate CAC_MENU_NAME * OpenDropDownList 0;	\
			}
#else //#ifdef PC
		#define CAC_BEGIN_BUTTON_ACTION_ANIMATION					\
			execnow ui_animate CAC_MENU_NAME * OpenDropDownList 0;
#endif //#ifdef PC

		#define CAC_PRI_GRENADE_BUTTON_ACTION												\
				if ( dvarString( ui_inside_popup ) != "0" )									\
				{																			\
					play CHOICE_FOCUS_SOUND;												\
					execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;					\
				}																			\
				else																		\
				{																			\
					setLocalVarInt ui_infoSide 1;											\
					setLocalVarInt ui_cacButton 3;											\
					execnow "set ui_inside_popup primarygrenade";							\
					execnow	"set selected_loadout_slot primarygrenade";						\
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton));	\
					CAC_BEGIN_BUTTON_ACTION_ANIMATION										\
				}
		
		#define CAC_PRI_GRENADE_BUTTON_VIS												\
				( !localVarInt( ui_inside_dropdown ) || ( dvarString( "ui_inside_popup" ) == "primarygrenade" ) )
				
		#define CAC_SPEC_GRENADE_BUTTON_ACTION												\
				if ( dvarString( ui_inside_popup ) != "0" )									\
				{																			\
					play CHOICE_FOCUS_SOUND;												\
					execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;					\
				}																			\
				else																		\
				{																			\
					setLocalVarInt ui_infoSide 1;											\
					setLocalVarInt ui_cacButton 4;											\
					execnow "set ui_inside_popup specialgrenade";							\
					execnow "set selected_loadout_slot specialgrenade";						\
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton));	\
					CAC_BEGIN_BUTTON_ACTION_ANIMATION										\
				}
		
		#define CAC_SPEC_GRENADE_BUTTON_VIS												\
				( !localVarInt( ui_inside_dropdown ) || ( dvarString( "ui_inside_popup" ) == "specialgrenade" ) )

		#define CAC_EQUIPMENT_BUTTON_ACTION													\
				if ( dvarString( ui_inside_popup ) != "0" )									\
				{																			\
					play CHOICE_FOCUS_SOUND;												\
					execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;					\
				}																			\
				else																		\
				{																			\
					setLocalVarInt ui_infoSide 1;											\
					setLocalVarInt ui_cacButton 5;											\
					execnow "set ui_inside_popup equipment";								\
					execnow "set selected_loadout_slot equipment";							\
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton));	\
					CAC_BEGIN_BUTTON_ACTION_ANIMATION										\
				}

		#define CAC_EQUIPMENT_BUTTON_VIS												\
				( !localVarInt( ui_inside_dropdown ) || ( dvarString( "ui_inside_popup" ) == "equipment" ) )
				
		#define CAC_PERK_1_BUTTON_ACTION													\  
				if ( dvarString( ui_inside_popup ) != "0" )									\
				{																			\
					play CHOICE_FOCUS_SOUND;												\
					execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;					\
				}																			\
				else																		\
				{																			\
					setLocalVarInt ui_infoSide 1;											\
					setLocalVarInt ui_cacButton 6;											\
					execnow "set ui_inside_popup specialties_1";							\
					execnow "set selected_loadout_slot specialty1";							\
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
					exec set challenges_category_name "@MPUI_PERK1_CAPS";					\
					CAC_SETUP_VIEWER(player, primary)										\
					SET_VIEWER_MODE_PLAYER_EDIT_BODY;										\
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton));	\
					CAC_BEGIN_BUTTON_ACTION_ANIMATION										\
				}

		#define CAC_PERK_1_BUTTON_VIS													\
				( !localVarInt( ui_inside_dropdown ) || ( dvarString( "ui_inside_popup" ) == "specialties_1" ) )

		#define CAC_PERK_2_BUTTON_ACTION													\
				if ( dvarString( ui_inside_popup ) != "0" )									\
				{																			\
					play CHOICE_FOCUS_SOUND;												\
					execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;					\
				}																			\
				else																		\
				{																			\
					setLocalVarInt ui_infoSide 1;											\
					setLocalVarInt ui_cacButton 7;											\
					execnow "set ui_inside_popup specialties_2";							\
					execnow "set selected_loadout_slot specialty2";							\
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
					exec set challenges_category_name "@MPUI_PERK2_CAPS";					\
					CAC_SETUP_VIEWER(player, primary)										\
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton));	\
					CAC_BEGIN_BUTTON_ACTION_ANIMATION										\
				}

		#define CAC_PERK_2_BUTTON_VIS													\
				( !localVarInt( ui_inside_dropdown ) || ( dvarString( "ui_inside_popup" ) == "specialties_2" ) )

		#define CAC_PERK_3_BUTTON_ACTION													\
				if ( dvarString( ui_inside_popup ) != "0" )									\
				{																			\
					play CHOICE_FOCUS_SOUND;												\
					execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;					\
				}																			\
				else																		\
				{																			\
					setLocalVarInt ui_infoSide 1;											\
					setLocalVarInt ui_cacButton 8;											\
					execnow "set ui_inside_popup specialties_3";							\
					execnow "set selected_loadout_slot specialty3";							\
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
					exec set challenges_category_name "@MPUI_PERK3_CAPS";					\
					CAC_SETUP_VIEWER(player, primary)										\
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton));	\
					CAC_BEGIN_BUTTON_ACTION_ANIMATION										\
				}

		#define CAC_PERK_3_BUTTON_VIS													\
				( !localVarInt( ui_inside_dropdown ) || ( dvarString( "ui_inside_popup" ) == "specialties_3" ) )

		#define CAC_HEAD_BUTTON_ACTION														\
				if ( dvarString( ui_inside_popup ) != "0" )									\
				{																			\
					play CHOICE_FOCUS_SOUND;												\
					execnow ui_animate CAC_MENU_NAME * CloseDropDownList 0;					\
				}																			\
				else																		\
				{																			\
					setLocalVarInt ui_infoSide 1;											\
					setLocalVarInt ui_cacButton 9;											\
					execnow "set ui_inside_popup equipment_head";							\
					execnow "set selected_loadout_slot facepaintpattern";					\
					execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));	\
					CAC_SETUP_VIEWER(player_head, primary);									\
					execnow focusItem (GRID_DROPDOWN_LIST_NAME+localVarInt(ui_cacButton));	\
					SET_VIEWER_MODE_PLAYER_FACE_PATTERN;									\
					CAC_BEGIN_BUTTON_ACTION_ANIMATION										\
					play uin_navigation_zoom_in;											\
				}

		#define CAC_HEAD_BUTTON_VIS														\
				( !localVarInt( ui_inside_dropdown ) || ( dvarString( "ui_inside_popup" ) == "equipment_head" ) )

		#define CAC_HEAD_LIST_ACTION											\
				execnow equipclasscurrentItem ( dvarString( ui_custom_name ) );	
				// setLocalVarString ui_cacListboxCloseOverride "OpenColorDropDownList";

		//=========================================================
		//===================== MENU SELECTION ====================
		//=========================================================

#undef	NEW_FRAME_BUTTON_NAME
#define NEW_FRAME_BUTTON_NAME				"grid_button_"
#define BUTTON_HEADER_Y_OFFSET				0
#define LEFT_BUTTONS_X						NEW_FRAME_CHOICE_X_START
#define RIGHT_BUTTONS_X						(CAC_WIDTH/2-15-BUTTON_BG_WIDTH)
#define TOP_BUTTONS_Y						NEW_FRAME_CHOICE_Y_START
#define LEFT_TOP_RECT						LEFT_BUTTONS_X	TOP_BUTTONS_Y							BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#define RIGHT_TOP_RECT						RIGHT_BUTTONS_X	TOP_BUTTONS_Y							BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#define CAC_LEFT_LISTBOX_RECT				LEFT_BUTTONS_X	(TOP_BUTTONS_Y+NEW_FRAME_BUTTON_HEIGHT)	BUTTON_BG_WIDTH 0						HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER

#ifdef PC
#define CAC_LEFT_LISTBOX_UNROLLED_RECT		LEFT_BUTTONS_X	(TOP_BUTTONS_Y+NEW_FRAME_BUTTON_HEIGHT)	(BUTTON_BG_WIDTH+16) 250						HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#else //#ifdef PC
#define CAC_LEFT_LISTBOX_UNROLLED_RECT		LEFT_BUTTONS_X	(TOP_BUTTONS_Y+NEW_FRAME_BUTTON_HEIGHT)	BUTTON_BG_WIDTH 250						HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#endif //#ifdef PC

#define CAC_RIGHT_LISTBOX_RECT				RIGHT_BUTTONS_X	(TOP_BUTTONS_Y+NEW_FRAME_BUTTON_HEIGHT)	BUTTON_BG_WIDTH 0						HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#define CAC_RIGHT_LISTBOX_UNROLLED_RECT		RIGHT_BUTTONS_X	(TOP_BUTTONS_Y+NEW_FRAME_BUTTON_HEIGHT)	BUTTON_BG_WIDTH 250						HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#define CAC_HEADER_ANIMATION_STATES( itemIndex, xPosition )	\
		name CAC_HEADER_NAME#itemIndex;						\
		CAC_COMMON_ANIMATION_STATES( NEW_FRAME_GREY_RGB )	\
		CAC_NEW_RECT_STATE( Top, xPosition (TOP_BUTTONS_Y+BUTTON_HEADER_Y_OFFSET) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER )

#define DIRT_IMAGE_WIDTH					400
#define DIRT_IMAGE_HEIGHT					128
#define DIRT_IMAGE_X						(-DIRT_IMAGE_WIDTH/2)
#define DIRT_IMAGE_Y						60

#include "ui_mp/cac_player_model.inc"
#ifndef PC_INGAME
		/* dirt image */
		PREPROC_SHADER_DRAW( DIRT_IMAGE_X DIRT_IMAGE_Y DIRT_IMAGE_WIDTH DIRT_IMAGE_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "menu_mp_lobby_cac_dirt", 1 1 1 0.2 )

		/* the player has to be after the dirt */
		CAC_FACTION_MODEL
		
#ifdef PC
		CAC_ROTATE_ARROWS
#endif // #ifdef PC
#endif		
#define HINT_EX_ARGS( listArg ) \
		name list_hint; \
		NEW_FRAME_TRANSPARENT_STATE( 1 1 1 )
		
#define ITEM_LIST_ONSELECTION																					\
		if ( IsCurrentItemClassified() )																		\
		{																										\
			execnow set ui_cac_main_hint_text (GetCurrentItemClassifiedHintText());								\
		}																										\
		elseif ( GetItemUnlockPLevel( GetCurrentItemIndex() ) > PRESTIGE )														\
		{																										\
			execnow set ui_cac_main_hint_text (GET_UNLOCK_PLEVEL_STRING(GetItemName(GetCurrentItemIndex())));	\ 
		}																										\
		elseif ( IsItemLocked( GetCurrentItemIndex() ) )														\
		{																										\
			execnow set ui_cac_main_hint_text (GET_UNLOCK_LEVEL_STRING(GetItemName(GetCurrentItemIndex())));	\ 
		}																										\
		else																									\
		{																										\
			execnow set ui_cac_main_hint_text "";																\
		}

		// Primary Weapon Button
#define PRIMARY_WEAPON_Y		TOP_BUTTONS_Y

		NEW_FRAME_BUTTON(	1, LEFT_BUTTONS_X PRIMARY_WEAPON_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_PRIMARY_WEAPON_CAPS", 
							CAC_SETUP_ACTION_PRI, 
							CAC_SETUP_VIEWER(player, primary); execnow set cac_armor_focus 1;, 
							;,
							CAC_PRI_BUTTON_VIS, CHOICE_UPNAV( 9 ), ; )
		NEW_FRAME_NEWICON_RECT_VIS( LEFT_BUTTONS_X, PRIMARY_WEAPON_Y, BUTTON_BG_WIDTH, NEW_FRAME_BUTTON_HEIGHT, HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
									( ANY_NEW_PRIMARY_FEATURE ), ; )

		// Secondary Weapon Button
#define SECONDARY_WEAPON_Y		(PRIMARY_WEAPON_Y+NEW_FRAME_BUTTON_HEIGHT*1.1)
		
		NEW_FRAME_BUTTON(	2, LEFT_BUTTONS_X SECONDARY_WEAPON_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_SECONDARY_WEAPON_CAPS", 
							CAC_SETUP_ACTION_SEC, 
							setdvar cac_secondary_selected 1; CAC_SETUP_VIEWER(player, secondary); execnow set cac_armor_focus 2;,
							setdvar cac_secondary_selected 0;,
							CAC_SEC_BUTTON_VIS, ;, ; )
		NEW_FRAME_NEWICON_RECT_VIS( LEFT_BUTTONS_X, SECONDARY_WEAPON_Y, BUTTON_BG_WIDTH, NEW_FRAME_BUTTON_HEIGHT, HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
									( ANY_NEW_SECONDARY_FEATURE ), ; )

		// Primary Grenades Button and Grenades Header
#define PRIMARY_GRENADES_Y		(SECONDARY_WEAPON_Y+NEW_FRAME_BUTTON_HEIGHT*1.92)
		
		NEW_FRAME_BUTTON(	3, LEFT_BUTTONS_X PRIMARY_GRENADES_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_PRIMARY_GRENADE_CAPS", 
							CAC_PRI_GRENADE_BUTTON_ACTION, 
							CAC_LEFT_BUTTON_ONFOCUS( 3 ),
							;,
							CAC_PRI_GRENADE_BUTTON_VIS, ;, CAC_NEW_RECT_STATE( Top, LEFT_TOP_RECT ) )

		CAC_DROPDOWN_LIST(	3, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							execnow "equipclasscurrentitem ( dvarString( ui_custom_name ) );", ;, ;, 
							when( dvarString( "ui_inside_popup" ) == "primarygrenade" ), 
							CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), ; )

		// Secondary Grenades Button
#define SECONDARY_GRENADES_Y		(PRIMARY_GRENADES_Y+NEW_FRAME_BUTTON_HEIGHT*1.1)
	
		NEW_FRAME_BUTTON(	4, LEFT_BUTTONS_X SECONDARY_GRENADES_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_SPECIAL_GRENADE_CAPS", 
							CAC_SPEC_GRENADE_BUTTON_ACTION, 
							CAC_LEFT_BUTTON_ONFOCUS( 4 ),
							;,
							CAC_SPEC_GRENADE_BUTTON_VIS, ;, CAC_NEW_RECT_STATE( Top, LEFT_TOP_RECT ) )

		CAC_DROPDOWN_LIST(	4, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							execnow "equipclasscurrentitem ( dvarString( ui_custom_name ) );", ;, ;, 
							when( dvarString( "ui_inside_popup" ) == "specialgrenade" ), 
							CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), ; )

		// Equipment Button
#define EQUIPMENT_Y		(SECONDARY_GRENADES_Y+NEW_FRAME_BUTTON_HEIGHT*1.1)
		
		NEW_FRAME_BUTTON(	5, LEFT_BUTTONS_X EQUIPMENT_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_EQUIPMENT_CAPS", 
							CAC_EQUIPMENT_BUTTON_ACTION, 
							CAC_LEFT_BUTTON_ONFOCUS( 5 ),
							;,
							CAC_EQUIPMENT_BUTTON_VIS, ;, CAC_NEW_RECT_STATE( Top, LEFT_TOP_RECT ) )

		CAC_DROPDOWN_LIST(	5, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							execnow "equipclasscurrentitem ( dvarString( ui_custom_name ) );", ;, ;, 
							when( dvarString( "ui_inside_popup" ) == "equipment" ), 
							CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), ; )

		// Perk 1 button
#define	BODY_TYPE_Y		(EQUIPMENT_Y+NEW_FRAME_BUTTON_HEIGHT*1.92)
		
		NEW_FRAME_BUTTON(	6, LEFT_BUTTONS_X BODY_TYPE_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_PERK1_CAPS", 
							CAC_PERK_1_BUTTON_ACTION, 
							CAC_LEFT_BUTTON_ONFOCUS( 6 ),
							;,
							CAC_PERK_1_BUTTON_VIS, ;, CAC_NEW_RECT_STATE( Top, LEFT_TOP_RECT ) )
			
		CAC_DROPDOWN_LIST(	6, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							execnow "equipclasscurrentitem (dvarString( ui_custom_name ));", ;, ;, 
							when( dvarString( "ui_inside_popup" ) == "specialties_1" ), 
							CAC_UPGRADE_ITEM_ACTION CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), CAC_PRO_PERK_ACTION )

#define IS_TWO_ATTACHMENT_PERK_EQUIPPED \ 
		( ( STAT_CAC_SPECIALTY2 == getItemIndex( "PERKS_PROFESSIONAL" ) ) || ( STAT_CAC_SPECIALTY2 == getItemIndex( "PERKS_PROFESSIONAL_PRO" ) ) )
	
#define TWO_ATTACHMENTS_EQUIPPED \
		( GetItemNumAttachmentsEquipped( dvarString( ui_custom_name ), STAT_CAC_PRIMARY ) > 1 || GetItemNumAttachmentsEquipped( dvarString( ui_custom_name ), STAT_CAC_SECONDARY ) > 1 )

#define TWO_ATTACHMENT_PERK_NOT_HIGHLIGHTED \
		( GetCurrentItemIndex() != getItemIndex( "PERKS_PROFESSIONAL" ) && GetCurrentItemIndex() != getItemIndex( "PERKS_PROFESSIONAL_PRO" ) )

#define PERK_2_EQUIP_ACTION																							\
		if( TWO_ATTACHMENTS_EQUIPPED && IS_TWO_ATTACHMENT_PERK_EQUIPPED && TWO_ATTACHMENT_PERK_NOT_HIGHLIGHTED )	\
		{																											\
			setLocalVarInt ui_cacOpenClearAttachmentNotification 1;													\
		}																											\
		else																										\
		{																											\
			execnow equipclasscurrentitem (dvarString( ui_custom_name ));											\
		}

		// Perk 2 button
#define	PERK_1_Y		(BODY_TYPE_Y+NEW_FRAME_BUTTON_HEIGHT*1.1)
		
		NEW_FRAME_BUTTON(	7, LEFT_BUTTONS_X PERK_1_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_PERK2_CAPS", 
							CAC_PERK_2_BUTTON_ACTION, 
							CAC_LEFT_BUTTON_ONFOCUS( 7 ),
							;,
							CAC_PERK_2_BUTTON_VIS, ;, CAC_NEW_RECT_STATE( Top, LEFT_TOP_RECT ) )
			
		CAC_DROPDOWN_LIST(	7, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							PERK_2_EQUIP_ACTION, ;, ;, 
							when( dvarString( "ui_inside_popup" ) == "specialties_2" ), 
							CAC_UPGRADE_ITEM_ACTION CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), CAC_PRO_PERK_ACTION )

		// Perk 3 button
#define	PERK_2_Y		(PERK_1_Y+NEW_FRAME_BUTTON_HEIGHT*1.1)
		
		NEW_FRAME_BUTTON(	8, LEFT_BUTTONS_X PERK_2_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@MPUI_PERK3_CAPS", 
							CAC_PERK_3_BUTTON_ACTION, 
							CAC_LEFT_BUTTON_ONFOCUS( 8 ),
							;,
							CAC_PERK_3_BUTTON_VIS, ;, CAC_NEW_RECT_STATE( Top, LEFT_TOP_RECT ) )
			
		CAC_DROPDOWN_LIST(	8, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							execnow "equipclasscurrentitem (dvarString( ui_custom_name ));", ;, ;, 
							when( dvarString( "ui_inside_popup" ) == "specialties_3" ), 
							CAC_UPGRADE_ITEM_ACTION CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), CAC_PRO_PERK_ACTION )

		 // Facepaint button
#define	HEAD_TYPE_Y		(PERK_2_Y+NEW_FRAME_BUTTON_HEIGHT*1.92)
		
		NEW_FRAME_BUTTON(	9, LEFT_BUTTONS_X HEAD_TYPE_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@FEATURE_FACEPAINT_CAPS", 
							CAC_HEAD_BUTTON_ACTION, 
							CAC_LEFT_BUTTON_ONFOCUS( 9 ) CLEAR_ITEM_NEW( FEATURE_FACEPAINT ),
							;,
							!IS_ITEM_LOCKED( FEATURE_FACEPAINT ) && CAC_HEAD_BUTTON_VIS, CHOICE_DOWNNAV( 1 ), CAC_NEW_RECT_STATE( Top, LEFT_TOP_RECT ) )
		NEW_FRAME_DBUTTON(	9, LEFT_BUTTONS_X HEAD_TYPE_Y BUTTON_BG_WIDTH NEW_FRAME_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
							"@FEATURE_FACEPAINT_CAPS", 
							;, 
							execnow set ui_cac_main_hint_text ( GET_UNLOCK_LEVEL_STRING( FEATURE_FACEPAINT ) ), 
							execnow set ui_cac_main_hint_text "";, 
							IS_ITEM_LOCKED( FEATURE_FACEPAINT ) && CAC_HEAD_BUTTON_VIS, ;, ; ) 
		NEW_FRAME_NEWICON_RECT_VIS( LEFT_BUTTONS_X, HEAD_TYPE_Y, BUTTON_BG_WIDTH, NEW_FRAME_BUTTON_HEIGHT, HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
									( IS_ITEM_NEW( FEATURE_FACEPAINT ) ), ; )
		NEW_FRAME_LOCKEDICON_RECT_VIS(	LEFT_BUTTONS_X, HEAD_TYPE_Y, BUTTON_BG_WIDTH, NEW_FRAME_BUTTON_HEIGHT, HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
										IS_ITEM_LOCKED( FEATURE_FACEPAINT ), ; )
		
		
	
		#define	RIGHT_BUTTON_X_OFFSET	370

		CAC_DROPDOWN_LIST(	9, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							CAC_HEAD_LIST_ACTION, ;, ITEM_LIST_ONSELECTION, 
							when( dvarString( "ui_inside_popup" ) == "equipment_head" ), 
							CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), ; )

		CAC_DROPDOWN_LIST(	9, FEEDER_ITEMSINSLOT, CAC_LEFT_LISTBOX_RECT, 
							execnow equipclasscurrentItem ( dvarString( ui_custom_name ) ); play uin_navigation_zoom_out;, ;, ;, 
							when( dvarString( "ui_inside_popup" ) == "equipment_headcolor" ), 
							CAC_NEW_RECT_STATE( Unrolled, CAC_LEFT_LISTBOX_UNROLLED_RECT ), ; )
							
		// Facepaint list hint
		HINT_TEXT_ALL(	14, LEFT_BUTTONS_X, 0, BUTTON_BG_WIDTH, 
						dvarString( ui_cac_main_hint_text ), 1 1 1 1, 
						( ( dvarString( ui_cac_main_hint_text ) != "" ) && ( dvarString( "ui_inside_popup" ) == "equipment_head" || dvarString( "ui_inside_popup" ) == "0" ) ), 
						HINT_EX_ARGS( GRID_DROPDOWN_LIST_NAME"9" ) )
		
		// Item info on right side 
		
#define IN_PERK_MENU ( ( dvarString( "ui_inside_popup" ) == "specialties_1" ) || ( dvarString( "ui_inside_popup" ) == "specialties_2" ) || ( dvarString( "ui_inside_popup" ) == "specialties_3" ) )

#define ITEM_INFO_X								115
#define ITEM_INFO_NAME_Y						(TOP_BUTTONS_Y-10)
#define ITEM_INFO_NAME_H						30

#define ITEM_INFO_IMAGE_Y						(ITEM_INFO_NAME_Y+ITEM_INFO_NAME_H)
#define ITEM_INFO_IMAGE_SIZE					80
	
#define ITEM_INFO_DESC_Y						( ITEM_INFO_IMAGE_Y + ITEM_INFO_IMAGE_SIZE + 20 )
#define ITEM_INFO_DESC_W						( ITEM_INFO_IMAGE_SIZE * 2.5 )
#define ITEM_INFO_DESC_X						( ITEM_INFO_X + ( ITEM_INFO_IMAGE_SIZE / 2 ) - ( ITEM_INFO_DESC_W / 2 ) )

#define ITEM_INFO_PERK_IMAGE_SIZE				100
#define ITEM_INFO_PERK_IMAGE_X					( ITEM_INFO_X + ( ITEM_INFO_IMAGE_SIZE / 2 ) - ( ITEM_INFO_PERK_IMAGE_SIZE / 2 ) )

#define ITEM_INFO_PRO_PERK_SIZE					48
#define ITEM_INFO_PERK_PRO_IMAGE_X				( ITEM_INFO_X + ( ITEM_INFO_IMAGE_SIZE / 2 ) - ( ITEM_INFO_PRO_PERK_SIZE / 2 ) )
#define ITEM_INFO_PERK_PRO_CLASSIFIED_X			( ITEM_INFO_X + ( ITEM_INFO_IMAGE_SIZE / 2 ) - ITEM_INFO_PRO_PERK_SIZE )	

#define ITEM_INFO_PRO_PERK_TEXT_Y				( ITEM_INFO_DESC_Y + 50 )
#define ITEM_INFO_PRO_PERK_TEXT_H				20
#define ITEM_INFO_PRO_PERK_IMAGE_Y				( ITEM_INFO_PRO_PERK_TEXT_Y + ITEM_INFO_PRO_PERK_TEXT_H )
#define ITEM_INFO_PRO_PERK_DESC_Y				( ITEM_INFO_PRO_PERK_TEXT_Y + ITEM_INFO_PRO_PERK_SIZE + 20 )

#define FACEPAINT_NAME_X						10
#define FACEPAINT_NAME_W						170
#define FACEPAINT_NAME_Y						( ITEM_INFO_NAME_Y + 3 )
#define FACEPAINT_CLASSIFIED_SIZE				( ITEM_INFO_IMAGE_SIZE * 1.5 )
#define FACEPAINT_CLASSIFIED_X					( FACEPAINT_NAME_X + ( FACEPAINT_NAME_W / 2 ) - ( FACEPAINT_CLASSIFIED_SIZE / 2 ) )

#define ITEM_CLASS_OR_LOCKED ( IsCurrentItemClassified() || ( GetItemUnlockPLevel( GetCurrentItemIndex() ) > PRESTIGE ) )
											
		/* item name */
		PREPROC_TEXT_DRAW_ALL(	ITEM_INFO_X ITEM_INFO_NAME_Y ITEM_INFO_IMAGE_SIZE ITEM_INFO_NAME_H HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
								toUpper( locString( "@" + GetCurrentItemName() ) ), 
								TEXTSIZE_SUBTITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0, UI_FONT_EXTRABIG, ITEM_TEXTSTYLE_NORMAL,
								when( !ITEM_CLASS_OR_LOCKED && ( dvarString( "ui_inside_popup" ) != "equipment_head" ) ), 
								name item_info_name_right; 
								ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )
								  
		/* facepaint name */
		PREPROC_TEXT_DRAW_ALL(	FACEPAINT_NAME_X FACEPAINT_NAME_Y FACEPAINT_NAME_W ITEM_INFO_NAME_H HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
								toUpper( locString( "@"+GetCurrentItemName() ) ), 
								TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0, UI_FONT_EXTRABIG, ITEM_TEXTSTYLE_NORMAL,
								when( ( !ITEM_CLASS_OR_LOCKED ) && ( dvarString( "ui_inside_popup" ) == "equipment_head" ) );, 
								name item_info_name_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )
		
		/* facepaint classified image */
		PREPROC_SHADER_DRAW_VIS_EX( FACEPAINT_CLASSIFIED_X (FACEPAINT_NAME_Y-37) FACEPAINT_CLASSIFIED_SIZE FACEPAINT_CLASSIFIED_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,
									"menu_mp_lobby_classified", 1 1 1 0, 
									when( ITEM_CLASS_OR_LOCKED ), 
									name item_info_icon_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ); )
		

		/* item image */
		PREPROC_SHADER_DRAW_VIS_EX( ITEM_INFO_X (ITEM_INFO_IMAGE_Y+7) ITEM_INFO_IMAGE_SIZE ITEM_INFO_IMAGE_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,
									GetItemImage( GetCurrentItemIndex() ) , 1 1 1 0, 
									when( ( GetItemImage( GetCurrentItemIndex() ) != "" ) && ( !ITEM_CLASS_OR_LOCKED ) && !IN_PERK_MENU ), 
									name item_info_icon_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ); )
		
		/* item desc */
		PREPROC_TEXT_DRAW_VIS_EX( ITEM_INFO_DESC_X ITEM_INFO_DESC_Y ITEM_INFO_DESC_W 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
								  "@" + GetItemDesc( GetCurrentItemIndex() ), 
								  TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0, 
								  when( !IsCurrentItemClassified() && !IsProItemVersion( GetCurrentItemIndex() ) && ( dvarString( "ui_inside_popup" ) != "equipment_head" ) ), 
								  autowrapped; name item_info_desc_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )
		PREPROC_TEXT_DRAW_VIS_EX( ITEM_INFO_DESC_X ITEM_INFO_DESC_Y ITEM_INFO_DESC_W 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
								  locString( "@"+GetItemDesc(GetCurrentItemIndex()-1))+"\n\n"+locString( "@"+GetItemDesc(GetCurrentItemIndex())), 
								  TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0, 
								  when( !IsCurrentItemClassified() && IN_PERK_MENU && IsProItemVersion( GetCurrentItemIndex() ) ), 
								  autowrapped;  name item_info_desc_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )		  

		/* perk item image */
		PREPROC_SHADER_DRAW_VIS_EX( ITEM_INFO_PERK_IMAGE_X ITEM_INFO_IMAGE_Y ITEM_INFO_PERK_IMAGE_SIZE ITEM_INFO_PERK_IMAGE_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,
									GetItemImage( GetCurrentItemIndex() ) + "_256", 1 1 1 0,
									when( IN_PERK_MENU && ( GetItemImage( GetCurrentItemIndex() ) != "" ) && ( !IsCurrentItemClassified() ) ), 
									name item_info_icon_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ); )
		

		/* pro perk text */
		PREPROC_TEXT_DRAW_ALL(	ITEM_INFO_DESC_X ITEM_INFO_PRO_PERK_TEXT_Y ITEM_INFO_DESC_W ITEM_INFO_PRO_PERK_TEXT_H HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
								toUpper( locString( "@" + GetItemName( GetCurrentItemIndex() + 1 ) ) ), 
								TEXTSIZE_LARGE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0, UI_FONT_EXTRABIG, ITEM_TEXTSTYLE_NORMAL,
								when( IN_PERK_MENU && ( !IsCurrentItemClassified() ) && !IsProItemVersion( GetCurrentItemIndex() ) && !IS_CUSTOM_MODE );, 
								name item_info_name_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )
								  
		/* pro perk image */
		PREPROC_SHADER_DRAW_VIS_EX( ITEM_INFO_PERK_PRO_IMAGE_X ITEM_INFO_PRO_PERK_IMAGE_Y ITEM_INFO_PRO_PERK_SIZE ITEM_INFO_PRO_PERK_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
									GetItemImage( GetCurrentItemIndex() + 1 ), 1 1 1 0,
									when( IN_PERK_MENU && ( !IsCurrentItemClassified() ) && !IsProItemVersion( GetCurrentItemIndex() ) && IsProItemVersionUnlocked( GetCurrentItemIndex() ) && !IS_CUSTOM_MODE );, 
									name item_info_icon_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )
		PREPROC_SHADER_DRAW_VIS_EX( ITEM_INFO_PERK_PRO_IMAGE_X ITEM_INFO_PRO_PERK_IMAGE_Y ITEM_INFO_PRO_PERK_SIZE ITEM_INFO_PRO_PERK_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
									GetItemImage( GetCurrentItemIndex() + 1 ), 0 0 0 0,
									when( IN_PERK_MENU && ( !IsCurrentItemClassified() ) && !IsProItemVersion( GetCurrentItemIndex() ) && !IsProItemVersionUnlocked( GetCurrentItemIndex() ) && !IS_CUSTOM_MODE );, 
									name item_info_icon_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 0 0 0 1, ; ) ; )
		PREPROC_SHADER_DRAW_VIS_EX( ITEM_INFO_PERK_PRO_CLASSIFIED_X (ITEM_INFO_PRO_PERK_IMAGE_Y-ITEM_INFO_PRO_PERK_SIZE/2) (ITEM_INFO_PRO_PERK_SIZE*2) (ITEM_INFO_PRO_PERK_SIZE*2) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 
									"menu_mp_lobby_classified", 1 1 1 0,
									when( IN_PERK_MENU && ( !IsCurrentItemClassified() ) && !IsProItemVersion( GetCurrentItemIndex() ) && !IsProItemVersionUnlocked( GetCurrentItemIndex() ) && !IS_CUSTOM_MODE );, 
									name item_info_icon_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )
									
		/* pro perk description */
		PREPROC_TEXT_DRAW_VIS_EX(	ITEM_INFO_DESC_X ITEM_INFO_PRO_PERK_DESC_Y ITEM_INFO_DESC_W 18 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
									"@" + GetItemDesc( GetCurrentItemIndex() + 1 ), 
									TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0, 
									when( IN_PERK_MENU && ( !IsCurrentItemClassified() ) && !IsProItemVersion( GetCurrentItemIndex() ) && IsProItemVersionUnlocked( GetCurrentItemIndex() ) );, 
									autowrapped; name item_info_name_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) ; )

		// equipment use description
		#define EQUIPMENT_USE_DESC_START_X	485
		#define EQUIPMENT_USE_DESC_START_Y	350
		PREPROC_TEXT_DRAW_VIS(	ITEM_INFO_DESC_X (ITEM_INFO_DESC_Y+65) ITEM_INFO_DESC_W 18 HORIZONTAL_ALIGN_CENTER HORIZONTAL_ALIGN_CENTER, 0 0, 
								"@PLATFORM_EQUIPMENT_USE_DESC",		
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, 1 1 1 0, 
								when( dvarString( "ui_inside_popup" ) == "equipment" ) ; name item_info_desc_right; ITEM_STATE( ITEM_INFO_FADEIN_STATE, forecolor 1 1 1 1, ; ) )

#include "ui_mp/cac_item_info.inc"

		#undef	A_BUTTON_OFFSET_X
		#define	A_BUTTON_OFFSET_X			-4

		#undef	SPECIALTY_IMAGE_WIDTH
		#define	SPECIALTY_IMAGE_WIDTH		32

		#undef	SPECIALTY_LOADOUT_WIDTH
		#define	SPECIALTY_LOADOUT_WIDTH		BUTTON_BG_WIDTH

		#undef	SPECIALTY_Y_OFFSET
		#define SPECIALTY_Y_OFFSET			75

		#undef	SPECIALTY_IMAGE_X
		#define	SPECIALTY_IMAGE_X			(CHOICE_X_START+RIGHT_BUTTON_X_OFFSET+(BUTTON_BG_WIDTH/2)-(SPECIALTY_IMAGE_WIDTH/2))

		#undef	SPECIALTY_IMAGE_Y
		#define SPECIALTY_IMAGE_Y			40

		#undef	CLASS_BONUS_IMAGE_X	
		#define CLASS_BONUS_IMAGE_X		(RIGHT_BUTTON_X_OFFSET+5)
		#undef	CLASS_BONUS_IMAGE_Y
		#define	CLASS_BONUS_IMAGE_Y		-100

#ifndef PC		
		// RESET BUTTON ==============================================================	
		itemDef
		{
			type			ITEM_TYPE_BUTTON
			rect			-165 ( CAC_HEIGHT / 2 ) 100 17 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
			text			"@PLATFORM_RESET_TO_DEFAULT"
			textfont		CHOICE_TEXTFONT
			textscale		TEXTSIZE_DEFAULT
			textalign		ITEM_ALIGN_BOTTOM_LEFT
			execkeyint		BUTTON_BACK {CAC_SETUP_ACTION_RESET}
			visible			when( dvarBool( ui_show_reset ) && dvarString( ui_inside_popup ) == "0" )
			decoration
		}
		// Rotate
		PREPROC_TEXT_DRAW_VIS(	95 (CAC_HEIGHT/2) 50 17 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 0, 
								"@PLATFORM_ROTATE", 
								TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, 1 1 1 1, 
								when( dvarString( ui_inside_popup ) != equipment_head ); )

		
#define PRO_PERK_X_BUTTON_RECT	(LEFT_BUTTONS_X+16) ( PRIMARY_WEAPON_Y + 21 ) BUTTON_BG_WIDTH 100 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#define PRO_PERK_COST_RECT		(LEFT_BUTTONS_X+143) ( PRIMARY_WEAPON_Y + 21 ) BUTTON_BG_WIDTH 100 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
#define PRO_PERK_X_PROMPT( rectArg, textArg, rgbArg, visArg ) \
		itemDef \
		{ \
			name			x_button_prompt \
			type			ITEM_TYPE_TEXT \
			rect			rectArg \
			exp 			text( textArg ); \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			textalign		ITEM_ALIGN_BOTTOM_LEFT \
			forecolor		rgbArg 0 \
			visible			when( IN_PERK_MENU && visArg ); \
			autowrapped \
			decoration \
			\
			state \
			{ \
				name		FadeIn \
				forecolor	rgbArg 1 \
			} \
		} \
		itemDef \
		{ \
			name			x_button_prompt \
			type			ITEM_TYPE_TEXT \
			rect			rectArg \
			exp				rect X( LEFT_BUTTONS_X ) \
			exp 			text( "@PLATFORM_BUTTON_X" ); \
			textfont		CHOICE_TEXTFONT \
			textscale		TEXTSIZE_SMALL \
			textalign		ITEM_ALIGN_BOTTOM_LEFT \
			forecolor		rgbArg 0 \
			visible			when( IN_PERK_MENU && visArg ); \
			autowrapped \
			decoration \
			\
			state \
			{ \
				name		FadeIn \
				forecolor	rgbArg 1 \
			} \
		}
		
		PRO_PERK_X_PROMPT( PRO_PERK_X_BUTTON_RECT, locString( "@MPUI_CHECK_PRO_STATUS", GetItemName( GetCurrentItemIndex() + 1 ) ), WHITE_RGB, CAN_CHECK_PRO_STATUS )
		PRO_PERK_X_PROMPT( PRO_PERK_X_BUTTON_RECT, locString( "@MPUI_UPGRADE_TO_PRO" ), NEW_FRAME_GREEN_RGB, CAN_PURCHASE_PRO_PERK )
		PRO_PERK_X_PROMPT( PRO_PERK_X_BUTTON_RECT, locString( "@MPUI_UPGRADE_TO_PRO" ), NEW_FRAME_RED_RGB, NOT_ENOUGH_CP_FOR_PRO )
		PRO_PERK_X_PROMPT( PRO_PERK_COST_RECT, locString( "@MENU_POINTS", GetItemCost( GetCurrentItemIndex() + 1 ) ), NEW_FRAME_GREEN_RGB, CAN_PURCHASE_PRO_PERK )
		PRO_PERK_X_PROMPT( PRO_PERK_COST_RECT, locString( "@MENU_POINTS", GetItemCost( GetCurrentItemIndex() + 1 ) ), NEW_FRAME_RED_RGB, NOT_ENOUGH_CP_FOR_PRO )

		PRO_PERK_X_PROMPT( PRO_PERK_X_BUTTON_RECT, locString( "@CUSTOM_PERKS_BUTTON_TOGGLE_PRO" ), WHITE_RGB, CUSTOM_IS_TOGGLE_PRO_PERKS_VIS );
		
		#undef  BACK_OPEN
		#define BACK_OPEN 	closeimmediate CAC_MENU_NAME; openimmediate cac_main;
		//#include "ui_mp/navcontrols.inc"
		NEW_FRAME_BACK_BUTTON( CAC_WIDTH, CAC_HEIGHT )
	
#else

		#define BUTTON_SPACING		20
		#define RENAME_OFFSET		( getTextWidth( locString( "@PLATFORM_BACK" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 + BUTTON_SPACING )
		#define COPY_BUTTON_OFFSET	( 0 )
		#define RESET_BUTTON_OFFSET	( -COPY_BUTTON_OFFSET - getTextWidth( locString( "@PLATFORM_COPY_CLASS" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) - 8 - BUTTON_SPACING )
		
		// rename button
		NEW_FRAME_BUTTON_PC_LEFT_OFFSET( CAC_WIDTH, CAC_HEIGHT, RENAME_OFFSET, "@PLATFORM_RENAME", CAC_SETUP_ACTION_RENAME, when( dvarString( ui_inside_popup ) == 0 && IS_ONLINE_GAME && !IS_BASICTRAINING_GAME ) )
		
		// reset to default button
		NEW_FRAME_BUTTON_PC_RIGHT_OFFSET( CAC_WIDTH, CAC_HEIGHT, RESET_BUTTON_OFFSET, "@PLATFORM_RESET_TO_DEFAULT", CAC_SETUP_ACTION_RESET, when( dvarBool( ui_show_reset ) && dvarString( ui_inside_popup ) == 0 ) )
		
		#undef CHOICE_TEXTSIZE
		#define CHOICE_TEXTSIZE			TEXTSIZE_DEFAULT
		
		#undef CHOICE_TEXTFONT
		#define CHOICE_TEXTFONT			UI_FONT_NORMAL
		
		// copy class button
		NEW_FRAME_BUTTON_PC_RIGHT_OFFSET( CAC_WIDTH, CAC_HEIGHT, COPY_BUTTON_OFFSET, "@PLATFORM_COPY_CLASS", open copyClassPopup;, when( IS_ONLINE_GAME && !IS_BASICTRAINING_GAME ) )
		NEW_FRAME_BUTTON_PC_RIGHT_OFFSET( CAC_WIDTH, CAC_HEIGHT, COPY_BUTTON_OFFSET, "@PLATFORM_COPY_CLASS", open copyCustomGametypeClassPopup;, when( dvarBool( xblive_privatematch ) ) )
		
		// back button
		NEW_FRAME_BACK_BUTTON_ACTION( CAC_WIDTH, CAC_HEIGHT, ON_ESC )
		
		// 190 total button width
		#define PRO_PERK_BUTTON_HEIGHT			142
		#define PRO_PERK_BUTTON_WIDTH			125
		#define PRO_PERK_COST_WIDTH				46
		#define PRO_PERK_BUTTON_RECT			(LEFT_BUTTONS_X)		(PRIMARY_WEAPON_Y+105) PRO_PERK_BUTTON_WIDTH PRO_PERK_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
		#define PRO_PERK_COST_RECT				(LEFT_BUTTONS_X+143)	(PRIMARY_WEAPON_Y+105) PRO_PERK_COST_WIDTH PRO_PERK_BUTTON_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
		#define PRO_PERK_BUTTON( width, textArg, costTextArg, rgbArg, hilightRGBArg, actionArg, visArg, costVisArg )	\
			itemDef															\
			{																\
				name		x_button_prompt									\
				type		ITEM_TYPE_TEXT									\
				rect		PRO_PERK_BUTTON_RECT							\
				exp			rect W( width );								\
				exp			text( textArg );								\
				textfont	CHOICE_TEXTFONT									\
				textscale	TEXTSIZE_SMALL									\
				textalign	ITEM_ALIGN_TOP_LEFT								\
				textalignx	2												\
				visible		when( IN_PERK_MENU && visArg );					\
				forecolor	rgbArg 0										\
				decoration													\
				autowrapped													\
				state														\
				{															\
					name		FadeIn										\
					forecolor	rgbArg 1									\
					backcolor	0 0 0 0.2									\
				}															\
			}																\
			itemDef															\
			{																\
				name		x_button_prompt									\
				type		ITEM_TYPE_TEXT									\
				rect		PRO_PERK_COST_RECT								\
				exp			text( costTextArg );							\
				textfont	CHOICE_TEXTFONT									\
				textscale	TEXTSIZE_SMALL									\
				textalign	ITEM_ALIGN_TOP_LEFT								\
				visible		when( IN_PERK_MENU && visArg && costVisArg );	\
				forecolor	rgbArg 0										\
				decoration													\
				autowrapped													\
				state														\
				{															\
					name		FadeIn										\
					forecolor	rgbArg 1									\
				}															\
			}
		
		PRO_PERK_BUTTON( BUTTON_BG_WIDTH, locString( "@PLATFORM_CHECK_PRO_STATUS", GetItemName( GetCurrentItemIndex() + 1 ) ), "", WHITE_RGB, BLACK_RGB, CAC_PRO_PERK_ACTION, CAN_CHECK_PRO_STATUS, 0 )
		PRO_PERK_BUTTON( PRO_PERK_BUTTON_WIDTH, locString( "@PLATFORM_UPGRADE_TO_PRO" ), locString( "@MENU_POINTS", GetItemCost( GetCurrentItemIndex() + 1 ) ), NEW_FRAME_GREEN_RGB,NEW_FRAME_GREEN_RGB,CAC_PRO_PERK_ACTION, CAN_PURCHASE_PRO_PERK, 1 )
		PRO_PERK_BUTTON( PRO_PERK_BUTTON_WIDTH, locString( "@MPUI_UPGRADE_TO_PRO" ), locString( "@MENU_POINTS", GetItemCost( GetCurrentItemIndex() + 1 ) ), NEW_FRAME_RED_RGB,	NEW_FRAME_RED_RGB,	CAC_PRO_PERK_ACTION, NOT_ENOUGH_CP_FOR_PRO, 1 )
		PRO_PERK_BUTTON( BUTTON_BG_WIDTH, locString( "@PLATFORM_PERKS_BUTTON_TOGGLE_PRO" ), "", WHITE_RGB, BLACK_RGB, CAC_PRO_PERK_ACTION, CUSTOM_IS_TOGGLE_PRO_PERKS_VIS, 0 );

#endif	// #ifndef PC

		#include "ui/safearea.menu"
	}
