// general definitions

#ifdef CONSOLE
	#define CHOICE_X_START			0//22
	#define CHOICE_Y_START			65//85//58//34
	#define RECT_ALIGN				;
	
	#undef ORIGIN_TITLE
	#define ORIGIN_TITLE			0 0
#else
	#define CHOICE_X_START			30//22
	#define CHOICE_Y_START			65//85//58//34
	#define RECT_ALIGN				HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN;
#endif

#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"
 
#define MENU_FONT_COLOR2		1 1 1 0.5

#include "ui_mp/stats_info.inc"
#include "ui_mp/overlaybg.inc"
#include "ui/framestyle.inc"
#include "ui_mp/newframe.inc"


	menuDef	
	{
		name			BLACKMARKET_MENU_NAME
		rect			0 0 640 480 RECT_ALIGN
		focuscolor		COLOR_FOCUSED
		style			WINDOW_STYLE_EMPTY
		soundloop 		MENU_MUSIC
		onOpen 
		{
			setdvar invite_visible "0"			

			// set focus to first menu selection	
			setfocus primary_weapon_selection;		
		}
		onEsc 
		{
			execnow "uploadstats";
			setdvar invite_visible "1";
			close self;
			close BLACKMARKET_MENU_NAME;
		}
		onFocus { setdvar ui_show_reset "1" }

		// background from overlaybg.inc
		#ifdef PC
			BACKGROUND_BLACK_LETTERBOX_BLURWORLD_VIS( 1.0, 0 )
		#endif
		OVERLAY_BACKGROUND

		#include "ui_mp/blackmarket_loadout.inc"
		BLACKMARKET_LOADOUT_BLACKMARKET_TITLE

		#include "ui_mp/navcontrols.inc"

		#include "ui/safearea.menu"
		//=========================================================
		//===================== MENU SELECTION ====================
		//=========================================================
		
		// PRIMARY WEAPON BUTTON =============================================================                          
		#define BLACKMARKET_SETUP_ACTION1									\                          
				execnow "set ui_primary_selected Primary Weapon";			\                          
				exec "set ui_menu_selection_title @MPUI_PRIMARY_WEAPON";	\                          
				play CHOICE_FOCUS_SOUND;									\                          
				open "popup_blackmarket_primary";                          
		                          
		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MPUI_PRIMARY_WEAPON", BLACKMARKET_SETUP_ACTION1, 1, name primary_weapon_selection )                          
		
		#define BLACKMARKET_SETUP_ACTION2( title, loadoutSlot )		\
				exec "set ui_menu_selection_title "title;			\
				play CHOICE_FOCUS_SOUND;							\
				execnow "set selected_loadout_slot "loadoutSlot;	\
				open "popup_blackmarket_secondaries";

		FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MPUI_SECONDARY_WEAPON", BLACKMARKET_SETUP_ACTION2( "@MPUI_SECONDARY_WEAPON", "secondary"),	1, ;  )
		
		#define BLACKMARKET_SETUP_ACTION( title, loadoutSlot )		\
				exec "set ui_menu_selection_title "title;			\
				play CHOICE_FOCUS_SOUND;							\
				execnow "set selected_loadout_slot "loadoutSlot;	\
				open "popup_blackmarket_items";

	
		FRAME_CHOICE_BUTTON_VIS_EX( 3, "@MPUI_EQUIPMENT", BLACKMARKET_SETUP_ACTION( "@MPUI_EQUIPMENT", "primarygrenade" ),	1, ;  )
		
		FRAME_CHOICE_BUTTON_VIS_EX( 4, "@MPUI_SPECIAL_GRENADE", BLACKMARKET_SETUP_ACTION( "@MPUI_SPECIAL_GRENADE", "specialgrenade" ),	1, ;  )
	
		// SPECIALTIES BUTTON ===================================================
		#define BLACKMARKET_SETUP_ACTION5									\		
				exec "set ui_menu_selection_title @MPUI_SPECIALTIES_TITLE";	\
				play CHOICE_FOCUS_SOUND;									\
				open "popup_blackmarket_specialties";		

		FRAME_CHOICE_BUTTON_VIS_EX( 5, "@MPUI_SPECIALTIES_PRE", BLACKMARKET_SETUP_ACTION5,	1, ;  )

		// KILLSTREAK BUTTON ===================================================
		#define BLACKMARKET_SETUP_ACTION6 \		
			exec "set ui_menu_selection_title @MPUI_KILLSTREAK_TITLE"; \
			play CHOICE_FOCUS_SOUND; \
			open "popup_blackmarket_killstreak";		

		FRAME_CHOICE_BUTTON_VIS_EX( 6, "@MPUI_KILLSTREAK", BLACKMARKET_SETUP_ACTION6,	1, ;  )
	}
	

// ===========================================================================================================================
// ===========================================================================================================================
// ===========================================================================================================================

#ifdef CONSOLE
	#undef CHOICE_X_START
	#define CHOICE_X_START			0
	#undef CHOICE_Y_START
	#define CHOICE_Y_START			90

	#undef ORIGIN_TITLE
	#define ORIGIN_TITLE			0 0
#else
	#undef CHOICE_X_START
	#define CHOICE_X_START			30
	#undef CHOICE_Y_START
	#define CHOICE_Y_START			90
#endif

	#define LOCAL_WEAPON_CLASS_INFO_WINDOW \
		/* weapon class title*/\
		PREPROC_TEXT_DRAW( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN,	ORIGIN_LOADOUT, dvarString( ui_weapon_class ),			TEXTSIZE_DEFAULT,	0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW ) \
		/* weapon class description */\
		PREPROC_TEXT_DRAW( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN,	ORIGIN_LOADOUT, dvarString( ui_weapon_class )+"_DESC",	TEXTSIZE_SMALL,		0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR ) \

	#define LOCAL_WEAPON_CLASS( itemNum, ptext, plabel, pVis ) \
		CHOICE_BUTTON_FOCUS_VIS_EX( itemNum, plabel, play CHOICE_FOCUS_SOUND; execnow "set selected_loadout_slot primary; set selected_group weapon_"ptext"; set ui_weapon_class_selected "plabel; open "popup_blackmarket_primaries";, exec "set ui_weapon_class "plabel, ;, 1, name ptext ) \
		CHOICE_NEWICON_VIS( itemNum, "menu_mp_lobby_new", when( pVis ) )		

	menuDef	{
		BLACKMARKET_POPUP_SWAP( "popup_blackmarket_primary", execnow "set ui_inside_popup weapon_class; set ui_show_preview 1", execnow "set ui_show_preview 0; set ui_primary_highlighted 0; set ui_attachment_highlighted 0"; )
		LOCAL_WEAPON_CLASS_INFO_WINDOW 
		LOCAL_WEAPON_CLASS( 1, "SMG", "@MPUI_SUB_MACHINE_GUNS", IsItemGroupNew( "weapon_smg" ) )
		LOCAL_WEAPON_CLASS( 2, "CQB", "@MPUI_CQBS", IsItemGroupNew( "weapon_cqb" ) )
		LOCAL_WEAPON_CLASS( 3, "assault", "@MPUI_ASSAULT_RIFLES", IsItemGroupNew( "weapon_assault" ) )
		LOCAL_WEAPON_CLASS( 4, "LMG", "@MPUI_LIGHT_MACHINE_GUNS", IsItemGroupNew( "weapon_lmg" ) )
		LOCAL_WEAPON_CLASS( 5, "sniper", "@MPUI_SNIPER_RIFLES", IsItemGroupNew( "weapon_sniper" ) )
	}
	
// ====================================================================================================
// primary weapon selection ===========================================================================
// ====================================================================================================
				
	
#define LIST_Y_START				110
#define LIST_HEIGHT					234
#define LIST_WIDTH					440
#define	LIST_ELEM_HEIGHT			18
#define LIST_X_START				0 /*( 640 - LIST_WIDTH )*/

#include "ui_mp/item_listbox.inc"

	// primary weapon selection popup menus
	menuDef	{
		BLACKMARKET_POPUP_SWAP( "popup_blackmarket_primaries", execnow "set ui_inside_popup primaries", ; )
		ITEM_LISTBOX( primaryweapons, FEEDER_ITEMSINSLOTANDGROUP, "purchasecurrentitem; openAttachmentMenuForCurrentItem bm_attachment_popup;", 1 )
	}
	
	// primary weapon selection popup menus
	menuDef	{
		BLACKMARKET_POPUP_SWAP( "popup_blackmarket_secondaries", execnow "set ui_inside_popup secondaries", ; )
		ITEM_LISTBOX( secondaryweapons, FEEDER_ITEMSINSLOT, "purchasecurrentitem; openAttachmentMenuForCurrentItem bm_attachment_popup;", 1 )
	}

	

// ====================================================================================================
// primary and second primary attachment selection ====================================================
// ====================================================================================================

	menuDef { 
		BLACKMARKET_POPUP_SWAP( "bm_attachment_popup", execnow "set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )
		ITEM_LISTBOX( attachments, FEEDER_ATTACHMENTS, "purchasecurrentitemattachment", 1 )
		/*Current codpoints*/
		PREPROC_TEXT_DRAW( LOADOUT_DESC_X (LOADOUT_DESC_Y+80) (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, locString( "@PERKS_CODPOINTSBANK", GetStatByName( "CODPOINTS" ) ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )
	}


	// ====================================================================================================
	// item selection =================================================================================
	// ====================================================================================================
	
	menuDef	
	{
		BLACKMARKET_POPUP_SWAP( "popup_blackmarket_items", execnow "set ui_inside_popup items", execnow "set ui_inside_popup 0" )
		ITEM_LISTBOX( items, FEEDER_ITEMSINSLOT, "purchasecurrentitem", 1 )
	}

