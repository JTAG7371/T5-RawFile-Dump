#include "ui/menudefinition.h"

// Remove this to restore full frontend instead of limited EPD frontend
#define COOP_EPD		0

#if (defined(XENON) || defined(PS3) || defined(PC)) && !defined(MP)
#define INGAME_MENUS	1
#endif

// LDS - This enables a German SKU with Nazi Zombies enabled *SHOULD BE SET TO 0 IF NOT APPROVED*
#define GERMAN_ZOMBIE_BUILD 0

#define DEVMAP_LEVEL_FIRST "devmap cuba"
#define DEVMAP_LEVEL_TRAINING "devmap training"
#define LEVEL_FIRST "cuba"
#define LEVEL_TRAINING "training"
#define FIRST_PLAYABLE_ZOMBIE_LEVEL"zombie_theater"
#define FIRST_PLAYABLE_VS_LEVEL "vs_testmap01"
#define FIRST_PLAYABLE_SO_LEVEL "so_race1_pow"

// Size define for the hud compass
// These are used for both the dynamic & non-dynamic compass drawing
// If these are changed, the cgame should be recompiled
#define COMPASS_SIZE		160
#define MINIMAP_X			11.5
#define MINIMAP_Y			5
#define MINIMAP_W			89.5
#define	MINIMAP_H			89.5

#define COMPASS_SIZE_MP		125
#define MINIMAP_X_MP		0
#define MINIMAP_Y_MP		0
#define MINIMAP_W_MP		102
#define	MINIMAP_H_MP		102

#define FULLSCREEN			0 0 640 480
#define FULLSCREEN_WIDE		-107 0 854 480

#ifdef PC
	#define ORIGIN_TITLE		0 0
#else
	#define	ORIGIN_TITLE		0 0
#endif
#define ORIGIN_TITLE_SS		104 120

//#define COLOR_TITLE			1 0.8 0.4 1
#define COLOR_TITLE			1 1 1 1
#define COLOR_HEADER		0.69 0.69 0.69 1
#define COLOR_FOCUSED		0.95294 0.72156 0.21176 1 //1 0.788 0.129 1
//#define COLOR_FOCUS_YELLOW	0.95294 0.72156 0.21176 1
#define COLOR_UNFOCUSED		0.4823 0.4823 0.4823 1
//#define COLOR_DISABLED		0.35 0.35 0.35 1
#define COLOR_SAFEAREA		0 0 1 1

#define COLOR_INFO_YELLOW	COLOR_FOCUSED//1 0.84706 0 1
#define COLOR_TEXT			0.84313 0.84313 0.84313 1
#define COLOR_DISABLED		0.0 0.0 0.0 0.3
#define COLOR_TITLEBAR		0.14510 0.16078 0.16862 0.3//1
#define COLOR_RED_TEXT		0.69020 0.00784 0.00784 1

#define COLOR_FADEOUT		0.09412 0.09412 0.04912 0.65

#define COLOR_BODY_TEXT		0.62745 0.66667 0.67451 1
//titlebar_under_disabled_text	0.02389 0.25490 0.25882 1
/*
61 65 66
37 41 43

24 24 24
0.09412 0.09412 0.04912 1
*/

#ifdef PS3
#define A_BUTTON_SIZE_GLOBAL		0.365
#else //#ifdef PS3
#define A_BUTTON_SIZE_GLOBAL		0.33
#endif //#ifdef PS3

// These are the same as keycodes.h keyNum_t 
#define	BUTTON_A			1
#define	BUTTON_B			2
#define	BUTTON_X			3
#define	BUTTON_Y			4
#define	BUTTON_LSHLDR		5
#define	BUTTON_RSHLDR		6
#define	BUTTON_START		14
#define	BUTTON_BACK			15
#define	BUTTON_LSTICK		16
#define	BUTTON_RSTICK		17
#define	BUTTON_LTRIG		18
#define	BUTTON_RTRIG		19
#define	DPAD_UP				20
#define	DPAD_DOWN			21
#define	DPAD_LEFT			22
#define	DPAD_RIGHT			23
#define	KEY_ESCAPE			27
#define APAD_UP			28
#define APAD_DOWN		29
#define APAD_LEFT		30
#define APAD_RIGHT		31
#ifdef PC
#define K_UPARROW			154
#define K_DOWNARROW			155
#define K_LEFTARROW			156
#define K_RIGHTARROW		157
#define K_MOUSE1			200
#define K_MOUSE2			201
#endif //#ifdef PC
#define K_KP_HOME			182
#define K_KP_PGUP			184
#define K_KP_END			188
#define K_KP_PGDN			190
#define K_MWHEELDOWN		205
#define K_MWHEELUP			206

#define	COLOR_USMC		0 0.0196 0.41
#define COLOR_JPN		0.53 0.027 0.027
#define COLOR_USSR		0.368 0.035 0.035
#define COLOR_GER		0.937 0.9 0.607

#define DEFAULT_MP_CFG			"default_mp.cfg"
#define SPLITSCREEN_MP_CFG		"default_splitscreen.cfg"
#define SYSTEMLINK_MP_CFG		"default_systemlink.cfg"
#define XBOXLIVE_MP_CFG			"default_xboxlive.cfg"
#define PRIVATE_MP_CFG			"default_private.cfg"

#define	RANKXPZM_STAT	getDStat( "PlayerStatsList", "RANKXPZM" )
#define	PLEVELZM_STAT	getDStat( "PlayerStatsList", "PLEVELZM" )
#define	RANKZM_STAT		getDStat( "PlayerStatsList", "RANKZM" )
#define	MINXPZM_STAT	getDStat( "PlayerStatsList", "MINXPZM" )
#define	MAXXPZM_STAT	getDStat( "PlayerStatsList", "MAXXPZM" )
#define	LASTXPZM_STAT	getDStat( "PlayerStatsList", "LASTXPZM" )

#define MAX_RANK		int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1))
#define MAX_PRESTIGE	int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1))

#define PRESTIGE_AVAIL (GetStatByName(PLEVEL) < MAX_PRESTIGE && GetStatByName(RANKXP) == int(tableLookup("mp/rankTable.csv",0,MAX_RANK,7)))
#define PRESTIGE_NEXT (GetStatByName(PLEVEL) < MAX_PRESTIGE && GetStatByName(RANK) == MAX_RANK)
#define PRESTIGE_FINISH (GetStatByName(PLEVEL) == MAX_PRESTIGE)

#define CAN_RANK_UP	(GetStatByName(RANK) < MAX_RANK || GetStatByName(PLEVEL) < MAX_PRESTIGE)
#define GET_UNLOCK_LEVEL_STRING( ITEM_NAME ) \
 ( locString( PERKS_UNLOCKED_AT_LV, GetItemUnlockLevel( GetItemIndex( ITEM_NAME ) ) + 1  ) )
#define GET_UNLOCK_PLEVEL_STRING( ITEM_NAME ) \
 ( locString( CLASS_PRESTIGE_UNLOCK_DESC, GetItemUnlockPLevel( GetItemIndex( ITEM_NAME ) ) ) )
 

#define MENU_MUSIC		"mus_mp_frontend"
