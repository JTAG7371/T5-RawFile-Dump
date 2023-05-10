#define	SPLITSCREEN_ENABLED 1
#define SPLITSCREEN_MULTIPLIER 1.5

#include "ui/menudef.h"
#include "ui_mp/common_macro.inc"
#include "ui_mp/stats_info.inc"
#include "ui/framestyle.inc"
#include "ui_mp/newframe.inc"


#undef  CHOICE_X_START
#define CHOICE_X_START				30
#undef  CHOICE_Y_START
#define CHOICE_Y_START				80

#ifdef PC
	#define	PC_INGAME //for background in overlaybg.inc
#endif

#define CHOICE_SEP_OFFSET_Y			-2
#define CHOICE_SEP_1				5

#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"
#include "ui_mp/overlaybg.inc"

#define HIGH_BOUND					1000

#undef	BUTTON_BG_X_START
#define BUTTON_BG_X_START			30
#undef	BUTTON_BG_Y_START
#define	BUTTON_BG_Y_START			42

#undef	CHOICE_TEXTSTYLE
#define	CHOICE_TEXTSTYLE			ITEM_TEXTSTYLE_NORMAL

#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X				(200*SPLITSCREEN_MULTIPLIER)

#undef	CHOICE_SIZE_Y
#define	CHOICE_SIZE_Y				(17*SPLITSCREEN_MULTIPLIER)

#undef	A_BUTTON_SIZE
#define A_BUTTON_SIZE				(A_BUTTON_SIZE_GLOBAL*SPLITSCREEN_MULTIPLIER)

#undef	CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN		HORIZONTAL_ALIGN_LEFT

#undef	CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN		VERTICAL_ALIGN_TOP

// ------
			

{
	menuDef
	{
		name			CHANGECLASS_SPLITSCREEN_MENU_NAME
		rect			0 0 640 480 
		focuscolor		COLOR_FOCUSED
		style			WINDOW_STYLE_EMPTY
#ifdef CONSOLE
		blurWorld		7.0
#endif
		onOpen
		{
			// update player's XP
			execNow "statGetByNameInDvar RANKXP ui_stat_rankxp";
			
			if ( localVarString( ui_custom_name ) == "" )
			{
				setLocalVarString ui_custom_name customclass1;
			}
			
			if( localVarString( ui_class ) == "" )
			{
				setLocalVarString ui_class class_smg; 
			}
			/*set ui_multi_s "HIGH_BOUND"; set ui_multi_dt 0";*/
			
			setfocusbydvar "ui_customclass_selected";
			//focusFirst
		}
		onEsc 
		{
			scriptMenuResponse "back";
		}
		
		execkeyint BUTTON_START
		{
			close self;
		}
		
		
#ifdef PC // background overlay
		BACKGROUND_BLACK_LETTERBOX_BLURWORLD( 1.0 )
		OVERLAY_BACKGROUND
#else
		#include "ui_mp/ingamebg.inc"
#endif		// background overlay

		// ------------------ TREE TITLE ------------------
		
		CHOICE_MENU_TITLE_ALIGN_VIS( "@MPUI_CHOOSE_CLASS_CAPS",  HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP, ITEM_ALIGN_MIDDLE_LEFT, 1 )
		
		//=========================================================================
		//================ MENU SELECTION FOR ONLINE/OFFLINE GAME =================
		//=========================================================================

		#define IS_ONLINE_GAME		( dvarInt( splitscreen ) == 0 && dvarInt( systemlink ) == 0 )

		#define FOCUS_CHECK( pnum ) \
				dvartest "ui_customclass_selected" focusdvar { pnum }

		#define ACTION_COMMON( pnum ) \
				setDvar ui_customclass_selected pnum; 

		#define FOCUS_COMMON_CUSTOM( customName, multi_s, multi_dt )	\
				setLocalVarString ui_custom_name customName;			\
				setLocalVarString ui_multi_s multi_s;					\
				setLocalVarString ui_multi_dt multi_dt;

		#define FOCUS_COMMON_DEFAULT( defaultName, multi_s, multi_dt )	\
				setLocalVarString ui_class defaultName;					\
				setLocalVarString ui_multi_s multi_s;					\
				setLocalVarString ui_multi_dt multi_dt;

		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	1, dvarString( customclass1 ), 
											scriptMenuResponse "custom1,0"; ACTION_COMMON( 6 ), 
											FOCUS_COMMON_CUSTOM( customclass1, 0, HIGH_BOUND ), 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	1, dvarString( customclass1 ), 
											;, 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && IS_ONLINE_GAME ), decoration )


											
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	2, dvarString( customclass2 ), 
											scriptMenuResponse "custom2,0"; ACTION_COMMON( 7 ), 
											FOCUS_COMMON_CUSTOM( customclass2, 0, HIGH_BOUND ), 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	2, dvarString( customclass2 ), 
											;, 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && IS_ONLINE_GAME ), decoration )



		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	3, dvarString( customclass3 ), 
											scriptMenuResponse "custom3,0"; ACTION_COMMON( 8 ), 
											FOCUS_COMMON_CUSTOM( customclass3, 0, HIGH_BOUND ), 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	3, dvarString( customclass3 ), 
											;, 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && IS_ONLINE_GAME ), decoration )

		

		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	4, dvarString( customclass4 ), 
											scriptMenuResponse "custom4,0"; ACTION_COMMON( 9 ), 
											FOCUS_COMMON_CUSTOM( customclass4, 0, HIGH_BOUND ), 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	4, dvarString( customclass4 ), 
											;, 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && IS_ONLINE_GAME ), decoration )



		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	5, dvarString( customclass5 ), 
											scriptMenuResponse "custom5,0"; ACTION_COMMON( 10 ), 
											FOCUS_COMMON_CUSTOM( customclass5, 0, HIGH_BOUND ), 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	5, dvarString( customclass5 ), 
											;, 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && IS_ONLINE_GAME ), decoration )


											
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	6, "@CLASS_CLASS1", 
											scriptMenuResponse "smg_mp,0"; ACTION_COMMON( 1 ), 
											FOCUS_COMMON_DEFAULT( class_smg, HIGH_BOUND, 0 ), 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_1 ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	6, dvarString( prestigeclass1 ), 
											scriptMenuResponse "prestige1,0"; ACTION_COMMON( 11 ),
											FOCUS_COMMON_CUSTOM( prestigeclass1, 0, HIGH_BOUND ) /*CLEAR_ITEM_NEW( FEATURE_PRESTIGE_CLASS_1 )*/, 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_1 ) && ( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) ) && IS_ONLINE_GAME ), ; )
		//CHOICE_NEWICON_VIS( 6, "menu_mp_lobby_new", when( IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_1 ) && IS_ONLINE_GAME ) )

											
											
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	7, "@CLASS_CLASS2", 
											scriptMenuResponse "cqb_mp,0"; ACTION_COMMON( 2 ), 
											FOCUS_COMMON_DEFAULT( class_cqb, HIGH_BOUND, 0 ), 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_2 ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	7, dvarString( prestigeclass2 ), 
											scriptMenuResponse "prestige2,0"; ACTION_COMMON( 12 ),
											FOCUS_COMMON_CUSTOM( prestigeclass2, 0, HIGH_BOUND ) /*CLEAR_ITEM_NEW( FEATURE_PRESTIGE_CLASS_2 )*/, 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_2 ) && ( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) ) && IS_ONLINE_GAME ), ; )
		//CHOICE_NEWICON_VIS( 7, "menu_mp_lobby_new", when( IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_2 ) && IS_ONLINE_GAME ) )

											

		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	8, "@CLASS_CLASS3", 
											scriptMenuResponse "assault_mp,0"; ACTION_COMMON( 3 ), 
											FOCUS_COMMON_DEFAULT( class_assault, HIGH_BOUND, 0 ), 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) || IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_3 ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	8, dvarString( prestigeclass3 ), 
											scriptMenuResponse "prestige3,0"; ACTION_COMMON( 13 ),
											FOCUS_COMMON_CUSTOM( prestigeclass3, 0, HIGH_BOUND ) /*CLEAR_ITEM_NEW( FEATURE_PRESTIGE_CLASS_3 )*/, 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_3 ) && ( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) ) && IS_ONLINE_GAME ), ; )
		//CHOICE_NEWICON_VIS( 8, "menu_mp_lobby_new", when( IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_3 ) && IS_ONLINE_GAME ) )


		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	9, "@CLASS_CLASS4", 
											scriptMenuResponse "lmg_mp,0"; ACTION_COMMON( 4 ), 
											FOCUS_COMMON_DEFAULT( class_lmg, HIGH_BOUND, 0 ) CLEAR_ITEM_NEW( FEATURE_CLOSEASSAULT ), 
											;, 
											( ( !IS_ITEM_LOCKED( FEATURE_CLOSEASSAULT ) && ( IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_4 ) || ( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_4 ) ) ) ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	9, dvarString( prestigeclass4 ), 
											scriptMenuResponse "prestige4,0";ACTION_COMMON( 14 ),
											FOCUS_COMMON_CUSTOM( prestigeclass4, 0, HIGH_BOUND ) /*CLEAR_ITEM_NEW( FEATURE_PRESTIGE_CLASS_4 )*/, 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && !IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_4 ) && IS_ONLINE_GAME ), ; )
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	9, "@CLASS_CLASS4", 
											;, 
											;, 
											( IS_ITEM_LOCKED( FEATURE_CLOSEASSAULT ) && IS_ONLINE_GAME ), decoration )
		CHOICE_NEWICON_VIS( 9, "menu_mp_lobby_new", when( ( IS_ITEM_NEW( FEATURE_CLOSEASSAULT ) /*|| IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_4 )*/ ) && IS_ONLINE_GAME ) )



		
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	10, "@CLASS_CLASS5", 
											scriptMenuResponse "sniper_mp,0"; ACTION_COMMON( 5 ), 
											FOCUS_COMMON_DEFAULT( class_sniper, HIGH_BOUND, 0 ) CLEAR_ITEM_NEW( FEATURE_SNIPER ), 
											;, 
											( ( !IS_ITEM_LOCKED( FEATURE_SNIPER ) && ( IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_5 ) || ( IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && !IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_5 ) ) ) ) || !IS_ONLINE_GAME ), ; )	
		FRAME_CHOICE_BUTTON_FOCUS_VIS_EX(	10, dvarString( prestigeclass5 ), 
											scriptMenuResponse "prestige5,0"; ACTION_COMMON( 15 ),
											FOCUS_COMMON_CUSTOM( prestigeclass5, 0, HIGH_BOUND ) /*CLEAR_ITEM_NEW( FEATURE_PRESTIGE_CLASS_5 )*/, 
											;, 
											( !IS_ITEM_LOCKED( FEATURE_CREATE_A_CLASS ) && !IS_ITEM_LOCKED( FEATURE_PRESTIGE_CLASS_5 ) && IS_ONLINE_GAME ), ; )
		FRAME_CHOICE_DBUTTON_FOCUS_VIS_EX(	10, "@CLASS_CLASS5", 
											;, 
											;, 
											( IS_ITEM_LOCKED( FEATURE_SNIPER ) && IS_ONLINE_GAME ), decoration )
		CHOICE_NEWICON_VIS( 10, "menu_mp_lobby_new", when( ( IS_ITEM_NEW( FEATURE_SNIPER ) /*|| IS_ITEM_NEW( FEATUTE_PRESTIVE_CLASS_5 )*/ ) && IS_ONLINE_GAME ) )

		
		#define DATA_TABLE_PRIMARY_GRENADE			GetDefaultClassSlot( localVarString( ui_class ), "primarygrenade" )
		#define DATA_TABLE_PRIMARY					GetDefaultClassSlot( localVarString( ui_class ), "primary" )
		// no default attachments or camo for now
		#define DATA_TABLE_PRIMARY_ATTACHMENT		0
		#define DATA_TABLE_PRIMARY_CAMO				0
		#define DATA_TABLE_SECONDARY				GetDefaultClassSlot( localVarString( ui_class ), "secondary" )
		// no default attachments or camo for now
		#define DATA_TABLE_SECONDARY_ATTACHMENT		0
		#define DATA_TABLE_SECONDARY_CAMO			0
		#define DATA_TABLE_SPECIALTY1				GetDefaultClassSlot( localVarString( ui_class ), "specialty1" )
		#define DATA_TABLE_SPECIALTY2				GetDefaultClassSlot( localVarString( ui_class ), "specialty2" )
		#define DATA_TABLE_SPECIALTY3				GetDefaultClassSlot( localVarString( ui_class ), "specialty3" )		
		#define DATA_TABLE_EQUIPMENT				GetDefaultClassSlot( localVarString( ui_class ), "equipment" )
		#define DATA_TABLE_SPECIAL_GRENADE			GetDefaultClassSlot( localVarString( ui_class ), "specialgrenade" )
		#define DATA_TABLE_BODY						GetDefaultClassSlot( localVarString( ui_class ), "body" )
		#define DATA_TABLE_DEATHSTREAK				GetDefaultClassSlot( localVarString( ui_class ), "deathstreak" )
		#define DATA_TABLE_KILLSTREAK_TIER1			GetDefaultClassSlot( localVarString( ui_class ), "killstreak1" )
		#define DATA_TABLE_KILLSTREAK_TIER2			GetDefaultClassSlot( localVarString( ui_class ), "killstreak2" )
		#define DATA_TABLE_KILLSTREAK_TIER3			GetDefaultClassSlot( localVarString( ui_class ), "killstreak3" )

		/* ==================================== custom classes ============================================= */

		#define STATS_PRIMARY					getCACItemIndex( ( localVarString( ui_custom_name ) ),  "primary" )
		#define STATS_PRIMARY_ATTACHMENT		getCACItemIndex( ( localVarString( ui_custom_name ) ),  "primaryattachment" )
		#define STATS_PRIMARY_CAMO				getCACItemIndex( ( localVarString( ui_custom_name ) ),  "primarycamo" )
		#define STATS_SECONDARY					getCACItemIndex( ( localVarString( ui_custom_name ) ),  "secondary" )
		#define STATS_SECONDARY_ATTACHMENT		getCACItemIndex( ( localVarString( ui_custom_name ) ),  "secondaryattachment" )
		#define STATS_SECONDARY_CAMO			getCACItemIndex( ( localVarString( ui_custom_name ) ),  "secondarycamo" )
		#define STATS_PRIMARY_GRENADE			getCACItemIndex( ( localVarString( ui_custom_name ) ),  "primarygrenade" )               
		#define STATS_SPECIALTY1				getCACItemIndex( ( localVarString( ui_custom_name ) ),  "specialty1" )                    
		#define STATS_SPECIALTY2				getCACItemIndex( ( localVarString( ui_custom_name ) ),  "specialty2" )                   
		#define STATS_SPECIALTY3				getCACItemIndex( ( localVarString( ui_custom_name ) ),  "specialty3" )                   		
		#define STATS_EQUIPMENT					getCACItemIndex( ( localVarString( ui_custom_name ) ),  "equipment" )                   
		#define STATS_SPECIAL_GRENADE			getCACItemIndex( ( localVarString( ui_custom_name ) ),  "specialgrenade" ) 
		#define STATS_BODY						getCACItemIndex( ( localVarString( ui_custom_name ) ),  "body" )              
		#define STATS_DEATHSTREAK				getCACItemIndex( "cacLoadouts", "deathstreak" )                  
		#define STATS_KILLSTREAK_TIER1			getCACItemIndex( "cacLoadouts", "killstreak1" )                  
		#define STATS_KILLSTREAK_TIER2			getCACItemIndex( "cacLoadouts", "killstreak2" )                  
		#define STATS_KILLSTREAK_TIER3			getCACItemIndex( "cacLoadouts", "killstreak3" )                  

		#include "ui/safearea.menu"
		
		/* ================================================================================= */
		/* ================================ LOADOUT DISPLAY ================================ */
		/* ================================================================================= */

		
		#define STAT_CAC_PRIMARY_GRENADE		int(min( STATS_PRIMARY_GRENADE		+ localVarInt(ui_multi_s), DATA_TABLE_PRIMARY_GRENADE		+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_PRIMARY				int(min( STATS_PRIMARY				+ localVarInt(ui_multi_s), DATA_TABLE_PRIMARY				+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_PRIMARY_ATTACHMENT		int(min( STATS_PRIMARY_ATTACHMENT	+ localVarInt(ui_multi_s), DATA_TABLE_PRIMARY_ATTACHMENT	+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_PRIMARY_CAMO			int(min( STATS_PRIMARY_CAMO			+ localVarInt(ui_multi_s), DATA_TABLE_PRIMARY_CAMO			+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_SECONDARY				int(min( STATS_SECONDARY			+ localVarInt(ui_multi_s), DATA_TABLE_SECONDARY				+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_SECONDARY_ATTACHMENT	int(min( STATS_SECONDARY_ATTACHMENT	+ localVarInt(ui_multi_s), DATA_TABLE_SECONDARY_ATTACHMENT	+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_SECONDARY_CAMO			int(min( STATS_SECONDARY_CAMO		+ localVarInt(ui_multi_s), DATA_TABLE_SECONDARY_CAMO		+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_SPECIALTY1				int(min( STATS_SPECIALTY1			+ localVarInt(ui_multi_s), DATA_TABLE_SPECIALTY1			+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_SPECIALTY2				int(min( STATS_SPECIALTY2			+ localVarInt(ui_multi_s), DATA_TABLE_SPECIALTY2			+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_SPECIALTY3				int(min( STATS_SPECIALTY3			+ localVarInt(ui_multi_s), DATA_TABLE_SPECIALTY3			+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_EQUIPMENT				int(min( STATS_EQUIPMENT			+ localVarInt(ui_multi_s), DATA_TABLE_EQUIPMENT				+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_SPECIAL_GRENADE		int(min( STATS_SPECIAL_GRENADE		+ localVarInt(ui_multi_s), DATA_TABLE_SPECIAL_GRENADE		+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_BODY					int(min( STATS_BODY					+ localVarInt(ui_multi_s), DATA_TABLE_BODY					+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_DEATHSTREAK			int(min( STATS_DEATHSTREAK			+ localVarInt(ui_multi_s), DATA_TABLE_DEATHSTREAK			+ localVarInt(ui_multi_dt) ))
		#define STAT_CAC_KILLSTREAK_TIER1		STATS_KILLSTREAK_TIER1
		#define STAT_CAC_KILLSTREAK_TIER2		STATS_KILLSTREAK_TIER2
		#define STAT_CAC_KILLSTREAK_TIER3		STATS_KILLSTREAK_TIER3
		#define FIRST_ATTACHMENT_PRIMARY_WEAPON \
				Select( localVarInt( ui_multi_s ) == 0, GetItemEquippedAttachment( localVarString( ui_custom_name ), STAT_CAC_PRIMARY, 0 ), -1 )
		#define SECOND_ATTACHMENT_PRIMARY_WEAPON \
				Select( localVarInt( ui_multi_s ) == 0, GetItemEquippedAttachment( localVarString( ui_custom_name ), STAT_CAC_PRIMARY, 1 ), -1 )
		#define FIRST_ATTACHMENT_SECONDARY_WEAPON \
				Select( localVarInt( ui_multi_s ) == 0, GetItemEquippedAttachment( localVarString( ui_custom_name ), STAT_CAC_SECONDARY, 0 ), -1 )
		#define SECOND_ATTACHMENT_SECONDARY_WEAPON \
				Select( localVarInt( ui_multi_s ) == 0, GetItemEquippedAttachment( localVarString( ui_custom_name ), STAT_CAC_SECONDARY, 1 ), -1 )
			
		#undef SPLITSCREEN_MULTIPLIER
		#define SPLITSCREEN_MULTIPLIER 2
	
		// Frame setup
		#define	CAC_HEIGHT							NEW_FRAME_DEFAULT_HEIGHT
		#define CAC_WIDTH							( CAC_HEIGHT * FRAME_ASPECT_RATIO )
		#define COMMON_ITEM_INFO_X					( -410 * SPLITSCREEN_MULTIPLIER )
		#define COMMON_ITEM_INFO_Y					( -CAC_HEIGHT/2 + NEW_FRAME_BG_Y_OFFSET( CAC_HEIGHT ) )
		#define COMMON_ITEM_HORIZONTAL_ALIGN		HORIZONTAL_ALIGN_RIGHT

		#ifdef INCLUDE_CAC_INFO
		#include "ui_mp/cac_item_info.inc"
		#endif

		// Back button
		PREPROC_TEXT_DRAW_VIS( CHOICE_X_START -17 50 17 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_BOTTOM, 0 0, "@PLATFORM_BACK", TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_BOTTOM_LEFT, 1 1 1 1, 1 )
	}
}