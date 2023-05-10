// Update menudefinition.h in the code source if you change this file.

#ifndef SPLITSCREEN_MULTIPLIER
#define SPLITSCREEN_MULTIPLIER 2
#endif // #ifndef SPLITSCREEN_MULTIPLIER

#define ITEM_TYPE_DEFAULT			0		// default, base min of itemDef
#define ITEM_TYPE_TEXT				1		// simple text
#define ITEM_TYPE_IMAGE				2		// Flash movie for Scaleform GFx 
#define ITEM_TYPE_BUTTON			3		// button, basically text with a border
#define ITEM_TYPE_LISTBOX			4		// scrollable list
#define ITEM_TYPE_EDITFIELD 		5		// editable text, associated with a dvar
#define ITEM_TYPE_OWNERDRAW 		6		// owner draw, name specs what it is
#define ITEM_TYPE_NUMERICFIELD		7		// editable text, associated with a dvar
#define ITEM_TYPE_SLIDER			8		// mouse speed, volume, etc.
#define ITEM_TYPE_YESNO 			9		// yes no dvar setting
#define ITEM_TYPE_MULTI 			10		// multiple list setting, enumerated
#define ITEM_TYPE_DVARENUM 			11		// multiple list setting, enumerated from a dvar
#define ITEM_TYPE_BIND				12		// bind
#define ITEM_TYPE_VALIDFILEFIELD	13		// text must be valid for use in a dos filename
#define ITEM_TYPE_UPREDITFIELD		14		// editable text, associated with a dvar
#define ITEM_TYPE_GAME_MESSAGE_WINDOW 15	// game message window
#define ITEM_TYPE_BIND2				16		// bind2
#define ITEM_TYPE_HIGHLIGHT			17		// button highlight

#define ITEM_TYPE_OWNERDRAW_TEXT	18		// ownerdraws for text
#define ITEM_TYPE_OD_BUTTON			19		// ownerdraws for text
#define ITEM_TYPE_OD_TEXT_BUTTON	20		// ownerdraws for text
#define ITEM_TYPE_BUTTON_NO_TEXT	21		// buttons with no text (just focus and actions, etc...)

#define ITEM_TYPE_ALPHANUMERICFIELD 22		// editable alpha-numeric text, associated with a dvar

// CURRENTLY NOT IN USE
#define ITEM_TYPE_RADIOBUTTON		25		// toggle button, may be grouped
#define ITEM_TYPE_MODEL 			26		// model
#define ITEM_TYPE_CHECKBOX			27		// check box
#define ITEM_TYPE_COMBO 			28		// drop down list
#define ITEM_TYPE_MENUMODEL 		39		// special menu model
#define ITEM_TYPE_DECIMALFIELD		30		// editable text, associated with a dvar, which allows decimal input
#define ITEM_TYPE_CONFEDITFIELD		31		// Text edit boxes that require an enter key to confirm, associated with a dvar

#define ITEM_ALIGN_LEFT 			0		// aligns left of text to left of containing rectangle
#define ITEM_ALIGN_CENTER			1		// aligns center of text to center of containing rectangle
#define ITEM_ALIGN_RIGHT			2		// aligns right of text to right of containing rectangle
#define ITEM_ALIGN_X_MASK			3

#define ITEM_ALIGN_LEGACY 			0		// aligns bottom of text to top of containing rectangle
#define ITEM_ALIGN_TOP	 			4		// aligns top of text to top of containing rectangle
#define ITEM_ALIGN_MIDDLE			8		// aligns middle of text to middle of containing rectangle
#define ITEM_ALIGN_BOTTOM			12		// aligns bottom of text to bottom of containing rectangle
#define ITEM_ALIGN_Y_MASK			12

#define ITEM_ALIGN_LEGACY_LEFT		0
#define ITEM_ALIGN_LEGACY_CENTER	1
#define ITEM_ALIGN_LEGACY_RIGHT		2
#define ITEM_ALIGN_TOP_LEFT			4
#define ITEM_ALIGN_TOP_CENTER		5
#define ITEM_ALIGN_TOP_RIGHT		6
#define ITEM_ALIGN_MIDDLE_LEFT		8
#define ITEM_ALIGN_MIDDLE_CENTER	9
#define ITEM_ALIGN_MIDDLE_RIGHT		10
#define ITEM_ALIGN_BOTTOM_LEFT		12
#define ITEM_ALIGN_BOTTOM_CENTER	13
#define ITEM_ALIGN_BOTTOM_RIGHT		14

#define ITEM_TEXTSTYLE_NORMAL			0	// normal text
#define ITEM_TEXTSTYLE_BLINK			1	// fast blinking
#define ITEM_TEXTSTYLE_SHADOWED 		3	// drop shadow ( need a color for this )
#define ITEM_TEXTSTYLE_SHADOWEDMORE 	6	// drop shadow ( need a color for this )
#define ITEM_TEXTSTYLE_MONOSPACE		128

#define WINDOW_BORDER_NONE			0		// no border
#define WINDOW_BORDER_FULL			1		// full border based on border color ( single pixel )
#define WINDOW_BORDER_HORZ			2		// horizontal borders only
#define WINDOW_BORDER_VERT			3		// vertical borders only
#define WINDOW_BORDER_KCGRADIENT	4		// horizontal border using the gradient bars
#define WINDOW_BORDER_RAISED		5		// darken the bottom and right sides of the border
#define WINDOW_BORDER_SUNKEN		6		// darken the top and left sides of the border

#define WINDOW_STYLE_EMPTY				0	// no background
#define WINDOW_STYLE_FILLED 			1	// filled with background color
#define WINDOW_STYLE_GRADIENT			2	// gradient bar based on background color
#define WINDOW_STYLE_SHADER 			3	// shader based on background color
#define WINDOW_STYLE_TEAMCOLOR			4	// team color
#define WINDOW_STYLE_DVAR_SHADER		5	// draws the shader specified by the dvar
#define WINDOW_STYLE_LOADBAR 			6	// shader based on background color
#define WINDOW_STYLE_LOADSCREEN			7	// shader based on background color
#define WINDOW_STYLE_SPINNER            8   // busy spinner
#define WINDOW_STYLE_SPINNERLOADBAR     9   // loadbar as a spinner
#define WINDOW_STYLE_SHADER_FRAMED      10   // same as shader, but with a frame
#define WINDOW_STYLE_FRAMED 			11	// same as filled but with a frame
#define WINDOW_STYLE_SHADER_STREAMED    12  // WINDOW_STYLE_SHADER, except if the material is not streamed in it displays a spinner


#define MODE_BOTTOMUP_ALIGN_TOP		0 // text appears on bottom of list and moves up to specified Y coordinate as old text fades out
#define MODE_BOTTOMUP_ALIGN_BOTTOM	1 // text appears on bottom of list and moves away from specified Y coordinate as new text pushes it up
#define MODE_TOPDOWN_ALIGN_TOP		2 // text appears on top of list and moves away from specified Y coordinate as new text pushes it down
#define MODE_TOPDOWN_ALIGN_BOTTOM	3 // text appears on top of list and moves down to specified Y coordinate as old text fades out

#define MENU_TRUE			1
#define MENU_FALSE			0

#define HUD_VERTICAL			0x00
#define HUD_HORIZONTAL			0x01

#define RANGETYPE_ABSOLUTE		0
#define RANGETYPE_RELATIVE		1

// Menu priority types
#define	MENU_PRI_POPUP		0
#define	MENU_PRI_ONTOP		1
#define MENU_PRI_DEFAULT	2

// Direction for sliding animation on menu open or close
#define MENU_SLIDE_DIRECTION_LEFT_TO_RIGHT	0
#define MENU_SLIDE_DIRECTION_RIGHT_TO_LEFT	1
#define MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM	2
#define MENU_SLIDE_DIRECTION_BOTTOM_TO_TOP	3 

// list box element types
#define LISTBOX_TEXT				0x00
#define LISTBOX_IMAGE				0x01

// list feeders
#define FEEDER_HEADS						0x00	// model heads
#define FEEDER_MAPS 						0x01	// text maps based on game type
#define FEEDER_SERVERS						0x02	// servers
#define FEEDER_CLAN_MEMBERS					0x03	// clan names
#define FEEDER_ALLMAPS						0x04	// all maps available, in graphic format
#define FEEDER_REDTEAM_LIST 				0x05	// red team members
#define FEEDER_BLUETEAM_LIST				0x06	// blue team members
#define FEEDER_PLAYER_LIST					0x07	// players
#define FEEDER_TEAM_LIST					0x08	// team members for team voting
#define FEEDER_MODS 						0x09	// team members for team voting
#define FEEDER_DEMOS						0x0a	// lists all the demo files
#define FEEDER_SCOREBOARD					0x0b	// team members for team voting
#define FEEDER_Q3HEADS						0x0c	// model heads
#define FEEDER_SERVERSTATUS 				0x0d	// server status
#define FEEDER_FINDPLAYER					0x0e	// find player
#define FEEDER_CINEMATICS					0x0f	// cinematics
#define FEEDER_SAVEGAMES					0x10	// savegames
#define FEEDER_PICKSPAWN					0x11
#define FEEDER_LOBBY_MEMBERS				0x12	// list of players in your party
#define FEEDER_MUTELIST						0x13	// list of musted players
#define FEEDER_PLAYERSTALKING				0x14	// list of players who are currently talking
#define FEEDER_SPLITSCREENPLAYERS			0x15	// list of all players who are playing splitscreen
#define FEEDER_LOBBY_MEMBERS_READY			0x16	// icon for whether they are ready or not
#define FEEDER_PLAYER_PROFILES				0x17	// player profiles
#define FEEDER_PARTY_MEMBERS				0x18	// list of players in your party
#define FEEDER_PARTY_MEMBERS_READY			0x19	// icon for whether they are ready or not
#define FEEDER_PLAYLISTS					0x1a	// list of all playlists
#define FEEDER_GAMEMODES					0x1b	// list of all game type modes, including any player custom modes
#define FEEDER_CATEGORIES					0x1c	// list of all categories
#define FEEDER_LEADERBOARD					0x1d	// list of rows for a leaderboard
#define FEEDER_MYTEAM_MEMBERS				0x1e	// list of marine team members
#define FEEDER_ENEMY_MEMBERS				0x1f	// list of opfor team members
#define FEEDER_ONLINEFRIENDS				0x20	// list of your online friends
#define FEEDER_TESTMAPS						0x21	// department test maps
#define FEEDER_SYSTEMLINK_LOBBY_MEMBERS		0x22	// list of players in a system link lobby
#define FEEDER_VARIANT_COND_LHS_LIST		0x23	// list of conditional LHS values for gametype variant rules
#define FEEDER_VARIANT_COND_OP_LIST			0x24	// list of conditional operators for gametype variant rules
#define FEEDER_VARIANT_COND_RHS_LIST		0x25	// list of conditional RHS values for gametype variant rules
#define FEEDER_CUSTOM_GAMETYPES				0x26	// list of all the gametypes for custom matches
#define FEEDER_VARIANT_RULES				0x27	// list of gametype variant rules
#define FEEDER_VARIANT_EVENT_LIST			0x28	// list of events for gametype variant rules
#define FEEDER_VARIANT_ACTION_LIST			0x29	// list of actions for gametype variant rules
#define FEEDER_VARIANT_PARAM_LIST			0x2a	// list of parameters for gametype variant rules
#define FEEDER_VARIANT_TARGET_LIST			0x2b	// list of targets for gametype variant rules
#define FEEDER_VARIANT_RULES_SHORT			0x2c	// list of advanced game rules in short form
#define FEEDER_FRIENDS				        0x2d	// list of your friends
#define FEEDER_PENDINGFRIENDS				0x2e	// list of your pending friends
#define FEEDER_INVITES				        0x2f	// list of the game invites from your friends
#define FEEDER_GAMETYPES_BASE				0x30	// list of the base game types with no custom modes
#define FEEDER_CUSTOM_PERKSINSLOT			0x31	// list of perks for perks editor
#define FEEDER_RECENT_PLAYERS				0x32	// list of recent players
#define FEEDER_RECOMMENDED_PLAYERS			0x33	// list of players recommended to clan
#define FEEDER_EMBLEM_LAYERS				0x34	// available emblem layers
#define FEEDER_EMBLEM_ICONS					0x35	// available emblem layers
#define FEEDER_DYNAMIC_MENU					0x36
#define FEEDER_FRIENDS_STATS_COMPARE		0x37	// list of friends with whom you can compare stats
#define FEEDER_CLAN_STATS_COMPARE			0x38	// list of friends with whom you can compare stats
#define FEEDER_ATTACHMENTS					0x39	// list of attachments for currently selected weapon
#define FEEDER_ITEMSINSLOT					0x3a	// list of items in a given loadout slot
#define FEEDER_ITEMSINSLOTANDGROUP			0x3b	// list of items in a given loadout slot and group
#define FEEDER_WEAPONOPTIONS				0x3c	// list of available weapon options
#define FEEDER_CUSTOM_KILLSTREAKS			0x3d	// list of custom killstreaks
#define FEEDER_DEMO_PLAYERS					0x3e	// list of players playing in a server demo
#define FEEDER_INCOMING_CLAN_REQUESTS		0x3f	// list of incoming clan requests.
#define FEEDER_SKILLS						0x40	// list of sp skills
#define FEEDER_SORTEDITEMS					0x41	// list of items sorted according to their attribute for create a class
#define FEEDER_BLACKMARKETSORTEDITEMS		0x42	// list of items sorted according to their attribute for blackmarket
#define FEEDER_SORTEDGLOBALITEMS			0x43	// list of global items sorted according to their attribute for CAC
#define FEEDER_CONTRACTS					0x44	// list of contracts
#define FEEDER_COMBAT_RECORD_ITEMS			0x45	// list of items based on time spent using them
#define FEEDER_INGAMESTORE_MAPPACKS			0x46	// List of offers available in the ingame store under map packs.
#define FEEDER_COMBAT_RECORD_GAMETYPES		0x47	// list of all gametypes
#define FEEDER_PERSONALBESTS				0x48	// list of personal bests reached in the last game
#define FEEDER_GROUPS						0x49	// list of all the groups a player has joined.
#define FEEDER_FILESHARE_SEARCHRESULTS		0x4a	// list of recently played games
#define FEEDER_CLIP_SEGMENTS				0x4b	// list of segments of a clip
#define FEEDER_NEW_CATEGORIES				0x4c	// new-style category feeder
#define FEEDER_NEW_PLAYLISTS				0x4d	// new-style playlist feeder
#define FEEDER_WEAPON_GROUPS				0x4e	// list of weapon groups
#define FEEDER_FILESHARE_SLOTS				0x4f	// list of private file share slots for another player
#define FEEDER_FILESHARE_MYSLOTS			0x50	// list of private file share slots for the current player
#define FEEDER_LEADERBOARD_GAMETYPES		0x51	// list of leaderboards based on gamemodes
#define FEEDER_AAR_SCOREBOARD				0x52
#define FEEDER_AAR_SCOREBOARD_WAGER			0x53	// after action report scoreboard for wager matches
#define FEEDER_COMBAT_RECORD_RECENT_GAMES	0x54	// list of the recent games 
#define FEEDER_AUTOJOIN_MEMBERS				0x55	// auto join list of players
#define FEEDER_FILESHARE_MYSLOTS_INGAME		0x56	// list of private file share slots for the current player (for ingame)
#define FEEDER_INGAMEPLAYERLIST_TEAM_ALLIES 0x57	// Ingame list of players for team allies
#define FEEDER_INGAMEPLAYERLIST_TEAM_AXIS	0x58	// Ingame list of players for team axis
#define FEEDER_INGAMEPLAYERLIST_FFA			0x59	// Ingame list of players for free-for-all game type.
#define FEEDER_CLANTAG_FEATURES				0x5a	// list of the clan tag features
#define FEEDER_SERVERSTATUSSCOREBOARD		0x5b	// server status scoreboard
#define FEEDER_STATS_MILESTONES				0x5c	// list of stats milestones
#define FEEDER_CUSTOM_CLASSES				0x5d	// list of custom classes
#define FEEDER_STATS_WEAPONGROUP_MILESTONES	0x5e	// list of stats of a particular weapon group milestone.
#define FEEDER_STATS_GLOBALCHALLENGES		0x5f	// list of Global challenges based on the clobal challenge type.
#define FEEDER_STATS_ATTACHMENTS			0x60	// List of weapon attachments.
#define FEEDER_CHALLENGES_PERKS				0x61    // List of all the challenges perks for each perk category
#define FEEDER_STATS_KILLSTREAKS            0x62	// List of killstreaks challenges.
#define FEEDER_STATS_GRENADES				0x63	// List of grenade challenges.
#define FEEDER_CHALLENGES_KILLSTREAKS       0x64    // List of killstreaks
#define FEEDER_XBOXLIVE_PARTY				0x65    // List of the members in your xboxlive party
#define FEEDER_CLANTAG_FEATURES_EDIT		0x66   
#define FEEDER_KILLSTREAK_NUM_KILLS			0x67	// list of valid killstreak kill count numbers for custom games
#define FEEDER_GAMETYPES_INGAME				0x68	// list of the base game types for in-game voting, uses the ui_preview_gt dvar for multiple lists on screen at once
#define FEEDER_INGAMEPLAYERS_TEAM_ALLIES	0x69	// list of players for team allies
#define FEEDER_INGAMEPLAYERS_TEAM_AXIS		0x6a	// list of players for team axis
#define FEEDER_INGAMEPLAYERS_FFA_A			0x6b	// list of players for free-for-all game type in column A
#define FEEDER_INGAMEPLAYERS_FFA_B			0x6c	// list of players for free-for-all game type in column B
#define FEEDER_CUSTOM_GAMETYPE_CLASSES		0x6d	// list of custom gametype classes
#define FEEDER_INGAMESTORE_AVATARS			0x6e	// List of offers available in the ingame store under avatars.
#define FEEDER_INGAMESTORE_THEMES			0x6f	// List of offers available in the ingame store under themes.
#define FEEDER_INGAMESTORE_FREEOFFER		0x70	// List of free offer(themes) for DLC5 download.

// display flags
// display flags
#define CG_SHOW_BLUE_TEAM_HAS_REDFLAG		0x00000001
#define CG_SHOW_RED_TEAM_HAS_BLUEFLAG		0x00000002
#define CG_SHOW_ANYTEAMGAME					0x00000004
#define CG_SHOW_CTF 						0x00000020
#define CG_SHOW_OBELISK 					0x00000040
#define CG_SHOW_HEALTHCRITICAL				0x00000080
#define CG_SHOW_SINGLEPLAYER				0x00000100
#define CG_SHOW_TOURNAMENT					0x00000200
#define CG_SHOW_DURINGINCOMINGVOICE 		0x00000400
#define CG_SHOW_IF_PLAYER_HAS_FLAG			0x00000800
#define CG_SHOW_LANPLAYONLY 				0x00001000
#define CG_SHOW_MINED						0x00002000
#define CG_SHOW_HEALTHOK					0x00004000
#define CG_SHOW_TEAMINFO					0x00008000
#define CG_SHOW_NOTEAMINFO					0x00010000
#define CG_SHOW_OTHERTEAMHASFLAG			0x00020000
#define CG_SHOW_YOURTEAMHASENEMYFLAG		0x00040000
#define CG_SHOW_ANYNONTEAMGAME				0x00080000
#define CG_SHOW_TEXTASINT					0x00200000
#define CG_SHOW_HIGHLIGHTED					0x00100000

#define CG_SHOW_NOT_V_CLEAR					0x02000000

#define CG_SHOW_2DONLY						0x10000000


#define UI_SHOW_LEADER						0x00000001
#define UI_SHOW_NOTLEADER					0x00000002
#define UI_SHOW_FAVORITESERVERS 			0x00000004
#define UI_SHOW_ANYNONTEAMGAME				0x00000008
#define UI_SHOW_ANYTEAMGAME 				0x00000010
#define UI_SHOW_NEWHIGHSCORE				0x00000020
#define UI_SHOW_DEMOAVAILABLE				0x00000040
#define UI_SHOW_NEWBESTTIME 				0x00000080
#define UI_SHOW_FFA				 			0x00000100
#define UI_SHOW_NOTFFA						0x00000200
#define UI_SHOW_NETANYNONTEAMGAME			0x00000400
#define UI_SHOW_NETANYTEAMGAME				0x00000800
#define UI_SHOW_NOTFAVORITESERVERS			0x00001000

// font types
#define UI_FONT_DEFAULT			0	// auto-chose betwen big/reg/small
#define UI_FONT_NORMAL			1
#define UI_FONT_BIG				2
#define UI_FONT_SMALL			3
#define UI_FONT_BOLD			4
#define UI_FONT_CONSOLE			5
#define UI_FONT_EXTRABIG		6
#define UI_FONT_MAX				6

// font sizes
#define FONTSCALE_SMALL			0.2750
#define FONTSCALE_LOBBY			0.26 
#define FONTSCALE_NORMAL		0.3150
#define FONTSCALE_BOLD			0.4000
#define FONTSCALE_SUBBIG		0.5000
#define FONTSCALE_BIG			0.6500
#define FONTSCALE_EXTRABIG		1

#define TEXTSIZE_SMALL			FONTSCALE_SMALL
#define TEXTSIZE_SMALL_SS		(FONTSCALE_SMALL*SPLITSCREEN_MULTIPLIER)
#define TEXTSIZE_LOBBY			FONTSCALE_LOBBY
#define TEXTSIZE_LOBBY_SS		(FONTSCALE_LOBBY*SPLITSCREEN_MULTIPLIER)
#define TEXTSIZE_DEFAULT		FONTSCALE_NORMAL
#define TEXTSIZE_DEFAULT_SS		(FONTSCALE_NORMAL*SPLITSCREEN_MULTIPLIER)
#define TEXTSIZE_LARGE			FONTSCALE_BOLD
#define TEXTSIZE_LARGE_SS		(FONTSCALE_BOLD*SPLITSCREEN_MULTIPLIER)
#define TEXTSIZE_SUBTITLE		FONTSCALE_SUBBIG
#define TEXTSIZE_SUBTITLE_SS	(FONTSCALE_SUBBIG*SPLITSCREEN_MULTIPLIER)
#define TEXTSIZE_TITLE			FONTSCALE_BIG
#define TEXTSIZE_TITLE_SS		(FONTSCALE_BIG*SPLITSCREEN_MULTIPLIER)
#define TEXTSIZE_LARGEST		FONTSCALE_EXTRABIG
#define TEXTSIZE_LARGEST_SS		(FONTSCALE_EXTRABIG*SPLITSCREEN_MULTIPLIER)

#ifdef SPLITSCREEN_ENABLED
#undef	TEXTSIZE_SMALL
#define	TEXTSIZE_SMALL TEXTSIZE_SMALL_SS

#undef	TEXTSIZE_LOBBY
#define TEXTSIZE_LOBBY TEXTSIZE_LOBBY_SS

#undef 	TEXTSIZE_DEFAULT
#define	TEXTSIZE_DEFAULT TEXTSIZE_DEFAULT_SS

#undef	TEXTSIZE_LARGE
#define	TEXTSIZE_LARGE TEXTSIZE_LARGE_SS

#undef	TEXTSIZE_SUBTITLE
#define	TEXTSIZE_SUBTITLE TEXTSIZE_SUBTITLE_SS

#undef	TEXTSIZE_TITLE
#define	TEXTSIZE_TITLE TEXTSIZE_TITLE_SS

#undef	TEXTSIZE_LARGEST
#define	TEXTSIZE_LARGEST TEXTSIZE_LARGEST_SS
#endif

#define TEXTSIZE_BOLD			TEXTSIZE_DEFAULT
#define TEXTSIZE_BIG			TEXTSIZE_TITLE

// owner draw types
// ideally these should be done outside of this file but
// this makes it much easier for the macro expansion to
// convert them for the designers ( from the .menu files )
#define CG_OWNERDRAW_BASE			1
#define CG_PLAYER_AMMO_VALUE		5
#define CG_PLAYER_AMMO_BACKDROP		6
#define CG_PLAYER_HEAT_VALUE		7
#define CG_VEHICLE_PLAYER_HEAT_VALUE	8
#define CG_VEHICLE_WEAPON_RELOAD	9
#define CG_VEHICLE_WEAPON_RELOADED	10
#define CG_PLAYER_FUEL_AMMO_VALUE	11
#define CG_PLAYER_GUIDED_MISSILE_FUEL	12


#define CG_PLAYER_STANCE			20

#define CG_SPECTATORS				60

#define CG_HOLD_BREATH_HINT			71
#define CG_CURSORHINT				72
#define CG_PLAYER_POWERUP			73
#define CG_PLAYER_HOLDABLE			74
#define CG_PLAYER_INVENTORY			75
#define CG_HINT_AP					76
#define CG_CURSORHINT_STATUS		78	// like 'health' bar when pointing at a func_explosive

#define CG_PLAYER_BAR_HEALTH		79
#define CG_MANTLE_HINT				80

#define CG_PLAYER_WEAPON_NAME		81
#define CG_PLAYER_WEAPON_NAME_BACK	82

#define CG_CENTER_MESSAGE			90	// for things like "You were killed by ..."

#define CG_TANK_LEFT_TREAD			91
#define CG_TANK_RIGHT_TREAD			92
#define CG_TANK_DRIVER_SEAT			93
#define CG_TANK_GUNNER_SEAT			94
#define CG_TANK_BODY_DIR			95
#define CG_TANK_BARREL_DIR			96

#define CG_DEADQUOTE				97

#define CG_PLAYER_BAR_HEALTH_BACK	98

#define CG_MISSION_OBJECTIVE_HEADER		99
#define CG_MISSION_OBJECTIVE_LIST		100
#define CG_MISSION_OBJECTIVE_BACKDROP	101
#define CG_PAUSED_MENU_LINE				102

#define CG_OFFHAND_WEAPON_ICON_FRAG			103
#define CG_OFFHAND_WEAPON_ICON_SMOKEFLASH	104
#define CG_OFFHAND_WEAPON_AMMO_FRAG			105
#define CG_OFFHAND_WEAPON_AMMO_SMOKEFLASH	106
#define CG_OFFHAND_WEAPON_NAME_FRAG			107
#define CG_OFFHAND_WEAPON_NAME_SMOKEFLASH	108
#define CG_OFFHAND_WEAPON_SELECT_FRAG		109
#define CG_OFFHAND_WEAPON_SELECT_SMOKEFLASH	110
#define CG_SAVING							111
#define	CG_PLAYER_LOW_HEALTH_OVERLAY		112

#define CG_INVALID_CMD_HINT				113
#define CG_PLAYER_SPRINT_METER			114
#define CG_PLAYER_SPRINT_BACK			115

#define CG_PLAYER_WEAPON_BACKGROUND						116
#define CG_PLAYER_WEAPON_PRIMARY_ICON					117
#define CG_PLAYER_WEAPON_AMMO_CLIP_GRAPHIC				118
#define CG_PLAYER_WEAPON_AMMO_CLIP_GRAPHIC_DUAL_WIELD	119
#define CG_PLAYER_WEAPON_AMMO_CLIP						120
#define CG_PLAYER_WEAPON_AMMO_CLIP_DUAL_WIELD			121
#define CG_PLAYER_WEAPON_AMMO_STOCK						122
#define CG_PLAYER_WEAPON_LOW_AMMO_WARNING				123

#define CG_BATTLE_COMPASS_MARKERS		124
#define CG_BATTLE_FULLMAP_MARKERS		125

#define CG_PLAYER_LIFE_COUNTER_ALIVE_GRAPHIC	126
#define CG_PLAYER_LIFE_COUNTER_DEAD_GRAPHIC		127
#define CG_PLAYER_AMMO_COUNTER_SINGLE			128
#define CG_PLAYER_AMMO_COUNTER_SINGLE_LAST		129
#define CG_PLAYER_FUEL_PERCENTAGE				130

#define UI_WAGER_POKERCHIPS				131

#define CG_SUCCESSFUL_CMD_HINT			132

#define UI_BLUR				133

#define CG_WAR_TEXT			134

#define CG_PLAYER_COMPASS_TICKERTAPE		144
#define CG_PLAYER_COMPASS_TICKERTAPE_NO_OBJ	145

#define CG_PLAYER_COMPASS_GUIDED_MISSILE	146
#define CG_PLAYER_COMPASS_DOGS				147
#define CG_PLAYER_COMPASS_TURRETS			148
#define CG_PLAYER_COMPASS_ARTILLERY_ICON	149
#define CG_PLAYER_COMPASS_PLAYER		150
#define CG_PLAYER_COMPASS_BACK			151
#define CG_PLAYER_COMPASS_POINTERS		152
#define CG_PLAYER_COMPASS_ACTORS		153
#define CG_PLAYER_COMPASS_TANKS			154
#define CG_PLAYER_COMPASS_HELICOPTERS	155
#define CG_PLAYER_COMPASS_PLANES		156
#define CG_PLAYER_COMPASS_AUTOMOBILES	157
#define CG_PLAYER_COMPASS_FRIENDS		158
#define CG_PLAYER_COMPASS_MAP			159
#define CG_PLAYER_COMPASS_NORTHCOORD	160
#define CG_PLAYER_COMPASS_EASTCOORD		161
#define CG_PLAYER_COMPASS_NCOORD_SCROLL	162
#define CG_PLAYER_COMPASS_ECOORD_SCROLL	163
#define CG_PLAYER_COMPASS_GOALDISTANCE	164

#define CG_PLAYER_ACTIONSLOT_DPAD		165
#define CG_PLAYER_ACTIONSLOT_1			166
#define CG_PLAYER_ACTIONSLOT_2			167
#define CG_PLAYER_ACTIONSLOT_3			168
#define CG_PLAYER_ACTIONSLOT_4			169
#define CG_PLAYER_COMPASS_ENEMIES		170

#define CG_HUD_WAR_MOMENTUM_PROGRESS_BAR_EMPTY		171
#define CG_HUD_WAR_MOMENTUM_PROGRESS_BAR_FULL		172
#define CG_HUD_WAR_MOMENTUM_PROGRESS_BAR_OUTLINE	173
#define CG_HUD_WAR_BLITZKRIEG_PROGRESS_BAR_FULL		174

#define CG_PLAYER_FULLMAP_HELICOPTER	175
#define CG_PLAYER_FULLMAP_DOGS			176
#define CG_PLAYER_FULLMAP_VEHICLES		177
#define CG_PLAYER_FULLMAP_ARTILLERY_ICON		178
#define CG_PLAYER_FULLMAP_BACK			180
#define CG_PLAYER_FULLMAP_MAP			181
#define CG_PLAYER_FULLMAP_POINTERS		182
#define CG_PLAYER_FULLMAP_PLAYER		183
#define CG_PLAYER_FULLMAP_ACTORS		184
#define CG_PLAYER_FULLMAP_FRIENDS		185
#define CG_PLAYER_FULLMAP_LOCATION_SELECTOR 186
#define CG_PLAYER_FULLMAP_BORDER		187
#define CG_PLAYER_FULLMAP_ENEMIES		188
#define CG_PLAYER_FULLMAP_TURRETS		189
#define CG_PLAYER_FULLMAP_GUIDED_MISSILE	190

#define CG_PLAYER_COMPASS				191

#define CG_VEHICLE_RETICLE			192
#define CG_HUD_TARGETS_VEHICLE		193
#define CG_HUD_TARGETS_JAVELIN		194

#define CG_TALKER1					195
#define CG_TALKER2					196
#define CG_TALKER3					197
#define CG_TALKER4					198

#define CG_FRIENDLYARROWS			199
#define CG_FRIENDLYNAMES			200
#define CG_ENEMYARROWS				201

#define UI_OWNERDRAW_BASE			202
#define UI_HANDICAP 				203
#define UI_EFFECTS					204
#define UI_PLAYERMODEL				205
#define UI_GAMETYPE 				206
#define UI_SKILL					207
#define UI_RETICLE_PREVIEW			208
#define UI_LENS_PREVIEW				209
#define UI_NETSOURCE				220
#define UI_NETFILTER				222
#define UI_VOTE_KICK				238
#define UI_NETGAMETYPE				245
#define UI_SERVERREFRESHDATE		247
#define UI_SERVERMOTD				248
#define UI_GLINFO					249
#define UI_KEYBINDSTATUS			250
#define UI_JOINGAMETYPE 			253
#define UI_MAPPREVIEW				254
#define UI_MENUMODEL				257
#define	UI_SAVEGAME_SHOT			258
#define UI_SAVEGAMENAME				262
#define UI_SAVEGAMEINFO				263
#define UI_LOADPROFILING			264
#define UI_RECORDLEVEL				265
#define UI_AMITALKING				266
#define UI_TALKER1					267
#define UI_TALKER2					268
#define UI_TALKER3					269
#define UI_TALKER4					270
#define UI_PARTYSTATUS				271
#define UI_LOGGEDINUSER				272
#define UI_RESERVEDSLOTS			273
#define UI_PLAYLISTNAME				274
#define UI_PLAYLISTDESCRIPTION		275
#define UI_USERNAME					276
#define UI_CATEGORYNAME				279
#define UI_CATEGORYDESCRIPTION		280
#define UI_PLAYLISTICON				281
#define UI_CATEGORYICON				282
#define UI_GAMETYPE_MAPNAME			283

#define CG_HUD_WAR_MOMENTUM_PROGRESS					284
#define CG_HUD_WAR_MOMENTUM_MULTIPLIER					285
#define CG_HUD_WAR_MOMENTUM_MULTIPLIER_DETAIL			286
#define CG_HUD_WAR_MOMENTUM_MULTIPLIER_BLITZKRIEG		287

#define CG_COMPETITIVE_MODE_SCORES		288
#define UI_LOAD_STATUS_SCREEN			289

#define CG_PLAYER_ACTIONSLOT_BACK_1			290
#define CG_PLAYER_ACTIONSLOT_BACK_2			291
#define CG_PLAYER_ACTIONSLOT_BACK_3			292
#define CG_PLAYER_ACTIONSLOT_BACK_4			293

#define CG_PLAYER_ACTIONSLOT_ARROW_1			294
#define CG_PLAYER_ACTIONSLOT_ARROW_2			295
#define CG_PLAYER_ACTIONSLOT_ARROW_3			296
#define CG_PLAYER_ACTIONSLOT_ARROW_4			297

#define UI_DIFFICULTY_INFO						298
#define UI_DIFFICULTY_ICON						299

#define UI_LOBBY_CHAT							300
#define	UI_CONTROLLER_ICON						301
#define UI_SCROLLING_MESSAGE					302
#define UI_SCROLLING_MESSAGE_CATEGORY			303
#define UI_CUSTOM_EMBLEM_CREATOR          	304
#define UI_CUSTOM_EMBLEM_CLAN_CARD          305
#define UI_CUSTOM_EMBLEM_CLAN_LOCAL         306
#define UI_CUSTOM_EMBLEM_CLAN_HEADQUARTERS  307
#define	UI_CUSTOM_EMBLEM_CLANMANAGEMENT		308
#define UI_DISPLAY_CLAN_COUNT_ICON			309

#define UI_JOINMOD		 					310

#define CG_HOLD_BREATH_ZOOM_HINT			311

#define CG_PLAYER_COMPASS_FAKE_FIRE			312
#define CG_PLAYER_FULLMAP_FAKE_FIRE			313

#define UI_WAGER_TIER						314
#define CG_PLAYER_SPIKEACOUSTIC				315
#define CG_PLAYER_WRISTWATCH				316

#define CG_PLAYER_COMPASS_GRID				317
#define CG_PLAYER_FULLMAP_GRID				318
#define CG_PLAYER_COMPASS_GRID_POINTS		319
#define CG_PLAYER_FULLMAP_GRID_POINTS		320

#define CG_DEBUG_REFERENCE_ART				321

#define CG_HUD_3DOBJECTIVEINDICATORS		322

#define CG_DEMO_TIMELINE					323

#define CG_PLAYER_COMPASS_SCRAMBLER					324
#define CG_PLAYER_COMPASS_SCRAMBLER_FRIENDLY		325
#define CG_PLAYER_FULLMAP_SCRAMBLER					326
#define CG_PLAYER_FULLMAP_SCRAMBLER_FRIENDLY		327
#define CG_PLAYER_COMPASS_STATIC	328
#define CG_PLAYER_SWING_POPUPS	329
#define	CG_PLAYER_DIRECTIONAL_HIT_INDICATOR		330
#define CG_PLAYER_COMPASS_ROUND					331

#define CG_PLAYER_COMPASS_RADAR_EFFECTS		332
#define CG_PLAYER_FULLMAP_RADAR_EFFECTS		333
#define UI_DRAWHEATMAP						334
#define CG_PLAYER_TARGET_HIGHLIGHTS			335

#define CG_PLAYER_POPUPS				336
#define CG_PLAYER_COD7_TYPEWRITER_FX		337
#define	CG_PLAYER_POP_IN_TEXT				338
#define	CG_PLAYER_SWING_RANK_IMAGE			339

#define UI_COMBAT_RECORD_PIE_CHART				340
#define UI_COMBAT_RECORD_LINE_GRAPH				341
#define UI_COMBAT_RECORD_HISTOGRAM				342
#define UI_COMBAT_RECORD_BAR_GRAPH				343
#define UI_COMBAT_RECORD_HORIZONTAL_BAR_GRAPH	344
#define UI_COMBAT_RECORD_LINE_GRAPH_VALUES		345
#define UI_COMBAT_RECORD_LINE_GRAPH_GAMETYPES	346
#define UI_COMBAT_RECORD_HITLOC_HEATMAP			347

#define UI_EMBLEM_CAROUSEL 	         			348
#define UI_EMBLEM_ICON_THUMBNAIL       			349
#define UI_EMBLEM_COLORS 		      			350
#define CG_DEMO_CONTROLS 	         			351
#define UI_PLAYER_EMBLEM						352
#define CG_ZOMBIETRON_SCORES					354
#define UI_PRETTY_LINE							355
#define CG_DEC20_TERMINAL						356
#define CG_PLAYER_DPAD_BACKGROUND				357
#define UI_DRAWDOWNLOADPROGRESS					358
#define UI_DRAW_PARTY_MEMBER_DL_PROGRESS		359

#define CG_PLAYER_FULLMAP_STATIC				360
#define UI_FILESHARE_RATING						361
#define UI_FILESHARE_SUBMITRATING				362
#define UI_FILESHARE_AVGSUBMITRATING			363

#define UI_SCREENSHOT							364

#define CG_GUIDED_MISSILE_BOOST_HINT		364
#define CG_GUIDED_MISSILE_DETONATE_HINT		365
#define CG_GUIDED_MISSILE_VIEW_POS			366
#define CG_GUIDED_MISSILE_DIST_TO_TARG		367
#define CG_GUIDED_MISSILE_DIST_FROM_OWNER	368

#define UI_MICROFICHEREADER					369
#define UI_CREDITS							370

#define CG_RCBOMB_BOOST_HINT				371
#define CG_RCBOMB_DETONATE_HINT				372
#define CG_RCBOMB_STEERING_HINT				373
#define CG_RCBOMB_ACCELERATION_HINT			374
#define CG_RCBOMB_HANDBRAKE_HINT			375

#define CG_PLAYER_COMPASS_FLICKER			376
#define CG_PLAYER_FULLMAP_FLICKER			377
#define CG_PLAYER_PLACE_TURRET_HINT			378
#define CG_PLAYER_TARGET_HIGHLIGHTS_GUIDED_MISSILE 379

#define UI_NOISE							380
#define UI_DRAW_ATTRIBUTE_BAR				381
#define CG_ZOMBIETRON_BEZEL					382

#define CG_REDACTION_FX						383
#define UI_CUSTOM_EMBLEM_SELECTOR           384
#define UI_FILESHARE_MYRATING				385
#define UI_GAME_DEBUG_DASH_INFO				386
#define UI_FILESHARE_PRIVATERATING			387

#define UI_DRAWPLAYLISTPOPULATION			388
#define UI_PLAYER_EMBLEM_SERVER				389

#define CG_PLAYER_HEAT_VALUE_VERTICAL		390

#define CG_PLAYER_TARGET_HIGHLIGHTS_FRIENDLY	391

#define CG_PLAYER_ACTIONSLOT_BIND_1			392
#define CG_PLAYER_ACTIONSLOT_BIND_2			393
#define CG_PLAYER_ACTIONSLOT_BIND_3			394
#define CG_PLAYER_ACTIONSLOT_BIND_4			395

#define UI_COMBAT_RECORD_BAR_GRAPH_VALUES		396
#define UI_INGAMESTORE_PRODUCTIMAGE				397

#define UI_SCROLLING_LONG_MESSAGE				398
#define UI_SCROLLING_MOTD_MESSAGE				399

// Edge relative placement values for rect->h_align and rect->v_align
#define HORIZONTAL_ALIGN_SUBLEFT        0   // left edge of a 4:3 screen (safe area not included)
#define HORIZONTAL_ALIGN_LEFT           1   // left viewable (safe area) edge
#define HORIZONTAL_ALIGN_CENTER         2   // center of the screen (reticle)
#define HORIZONTAL_ALIGN_RIGHT          3   // right viewable (safe area) edge
#define HORIZONTAL_ALIGN_FULLSCREEN     4   // disregards safe area
#define HORIZONTAL_ALIGN_NOSCALE        5   // uses exact parameters - neither adjusts for safe area nor scales for screen size
#define HORIZONTAL_ALIGN_TO640          6   // scales a real-screen resolution x down into the 0 - 640 range
#define HORIZONTAL_ALIGN_CENTER_SAFEAREA 7  // center of the safearea
#define HORIZONTAL_ALIGN_USER_LEFT      8   // left edge user tweakable
#define HORIZONTAL_ALIGN_USER_CENTER    9   // center of the user tweakable
#define HORIZONTAL_ALIGN_USER_RIGHT     10  // right edge of user tweakable
#define HORIZONTAL_ALIGN_MAX            HORIZONTAL_ALIGN_USER_RIGHT
#define HORIZONTAL_ALIGN_DEFAULT        HORIZONTAL_ALIGN_SUBLEFT

#define VERTICAL_ALIGN_SUBTOP           0   // top edge of the 4:3 screen (safe area not included)
#define VERTICAL_ALIGN_TOP              1   // top viewable (safe area) edge
#define VERTICAL_ALIGN_CENTER           2   // center of the screen (reticle)
#define VERTICAL_ALIGN_BOTTOM           3   // bottom viewable (safe area) edge
#define VERTICAL_ALIGN_FULLSCREEN       4   // disregards safe area
#define VERTICAL_ALIGN_NOSCALE          5   // uses exact parameters - neither adjusts for safe area nor scales for screen size
#define VERTICAL_ALIGN_TO480            6   // scales a real-screen resolution y down into the 0 - 480 range
#define VERTICAL_ALIGN_CENTER_SAFEAREA  7   // center of the save area
#define VERTICAL_ALIGN_USER_TOP         8   // top edge user tweakable
#define VERTICAL_ALIGN_USER_CENTER      9   // center of the user tweakable
#define VERTICAL_ALIGN_USER_BOTTOM      10  // bottom edge of user tweakable
#define VERTICAL_ALIGN_MAX              VERTICAL_ALIGN_USER_BOTTOM
#define VERTICAL_ALIGN_DEFAULT          VERTICAL_ALIGN_SUBTOP

#define VERTICAL_REF_TOP                0
#define VERTICAL_REF_CENTER             1
#define VERTICAL_REF_BOTTOM             2
#define HORIZONTAL_REF_LEFT             0
#define HORIZONTAL_REF_CENTER           1
#define HORIZONTAL_REF_RIGHT            2

#define REF_TOP_LEFT                    HORIZONTAL_REF_LEFT VERTICAL_REF_TOP
#define REF_TOP_CENTER                  HORIZONTAL_REF_CENTER VERTICAL_REF_TOP
#define REF_TOP_RIGHT                   HORIZONTAL_REF_RIGHT VERTICAL_REF_TOP
#define REF_CENTER_LEFT                 HORIZONTAL_REF_LEFT VERTICAL_REF_CENTER
#define REF_CENTER                      HORIZONTAL_REF_CENTER VERTICAL_REF_CENTER
#define REF_CENTER_RIGHT                HORIZONTAL_REF_RIGHT VERTICAL_REF_CENTER
#define REF_BOTTOM_LEFT                 HORIZONTAL_REF_LEFT VERTICAL_REF_BOTTOM
#define REF_BOTTOM_CENTER               HORIZONTAL_REF_CENTER VERTICAL_REF_BOTTOM
#define REF_BOTTOM_RIGHT                HORIZONTAL_REF_RIGHT VERTICAL_REF_BOTTOM

#define MENU_ITEM_TYPE_TEXT				0	// menu item type plain text
#define MENU_ITEM_TYPE_LOC_TEXT			1	// menu item type plain text to be localized
#define MENU_ITEM_TYPE_IMAGE			2	// menu item type image
#define MENU_ITEM_TYPE_TEXT_ON_HOVER	3	// menu item type plain text, but only appears when being hovered
#define MENU_ITEM_TYPE_LOC_TEXT_ON_HOVER 4	// same as above, but needs to be localized
#define MENU_ITEM_TYPE_IMAGE_ON_HOVER	5	// menu item type image, but only appears when being hovered
#define MENU_ITEM_TYPE_TEXT_HIDDEN		6	// menu item type play text, but is never displayed
#define MENU_ITEM_TYPE_LOC_TEXT_HIDDEN	7	// same as above but will be localized
#define MENU_ITEM_TYPE_IMAGE_HIDDEN		8	// menu item type image, but is never displayed

#define	MENU_ROW_STATUS_NORMAL			0	// menu row appears normal
#define MENU_ROW_STATUS_DISABLED		1	// menu row appears disabled
#define MENU_ROW_STATUS_HIDDEN			2	// menu row is now shown

#define MENU_COLUMN_BACKGROUND			0	// background color
#define MENU_COLUMN_HIGHLIGHT			1	// highlight color
#define MENU_COLUMN_SELECT_BUTTON		2	// select button icon
#define MENU_COMMON_COLUMNS				3	// number of common columns above

#define	ATTACH_POINT_TOP				1
#define	ATTACH_POINT_BOTTOM				2
#define	ATTACH_POINT_TRIGGER			3
#define	ATTACH_POINT_MUZZLE				4

//#define MENU_CONTROL_UNSPECIFIED      0
#define MENU_CONTROL_EVERYONE			1	
#define MENU_CONTROL_USED 				2	// only used clients/controllers can control this menu
#define MENU_CONTROL_OPENER				3	// only the person who opened this menu can control it
#define MENU_CONTROL_NO_GUESTS 			4	// guests can not operate this menu
#define MENU_CONTROL_PRIMARY 			5	// only primary client can control this menu
#define MENU_CONTROL_PREGAME			6	// special case for frontend - everyone when introPlayed is false, just primary otherwise

// Ingame store selected item status
#define INGAMESTORE_ITEM_NOT_BOUGHT			0
#define INGAMESTORE_ITEM_BOUGHT				1

// visibility bits to replace dvars for hud visibility 

// the bits needed to sent the client visibility bits
#define CLIENT_HUD_VISIBILITY_BITS					4
#define CLIENT_HUD_VISIBILITY_SHIFT					0
#define CLIENT_HUD_VISIBILITY_BIT(x)				( (1 << x) >> CLIENT_HUD_VISIBILITY_SHIFT ) 

// these are the visibility bits which can be set on the client
// they should be contiguous so we can minimize network bandwidth
#define BIT_HUD_VISIBLE								0
#define BIT_G_COMPASS_SHOW_ENEMIES					1
#define BIT_RADAR_CLIENT							2
#define BIT_NEMESIS_KILLCAM							3

#define MATCH_HUD_VISIBILITY_BITS					13
#define MATCH_HUD_VISIBILITY_SHIFT					CLIENT_HUD_VISIBILITY_BITS

#define MATCH_HUD_VISIBILITY_BIT(x)					( (1 << x) >> MATCH_HUD_VISIBILITY_SHIFT ) 

// these are the visibility bits which can be set on the match
#define BIT_FINAL_KILLCAM							4
#define BIT_ROUND_END_KILLCAM						5
#define BIT_RADAR_ALLIES							6	
#define BIT_RADAR_AXIS								7	
#define BIT_ENABLE_POPUPS							8		
#define BIT_BOMB_TIMER								9	
#define BIT_BOMB_TIMER_A							10	
#define BIT_BOMB_TIMER_B							11	
#define BIT_AMMO_COUNTER_HIDE						12
#define BIT_HUD_HARDCORE							13
#define BIT_PREGAME									14
#define BIT_DRAW_SPECTATOR_MESSAGES					15
#define BIT_DISABLE_INGAME_MENU						16

// non-client non-match specific visibility bits
#define BIT_DEMO_CAMERA_MODE_THIRDPERSON			17	
#define BIT_DEMO_CAMERA_MODE_MOVIECAM				18	
#define BIT_DEMO_ALL_GAME_HUD_HIDDEN				19	
#define BIT_DEMO_HUD_HIDDEN							20
#define BIT_IN_KILLCAM								21
#define BIT_SELECTING_LOCATION						22
#define BIT_IS_FLASH_BANGED							23
#define BIT_UI_ACTIVE								24
#define BIT_SPECTATING_CLIENT						25
#define BIT_IS_SCOPED								26
#define BIT_IN_VEHICLE								27
#define BIT_IN_GUIDED_MISSILE						28
#define BIT_IS_FUEL_WEAPON							29
#define BIT_SELECTING_LOCATIONAL_KILLSTREAK			30
#define BIT_IS_DEMO_PLAYING							31
#define BIT_IS_DEMO_MOVIE_RENDERING					32
#define BIT_ADS_JAVELIN								33
#define BIT_EXTRACAM_ON								34
#define BIT_EXTRACAM_ACTIVE							35
#define BIT_EXTRACAM_STATIC							36
#define BIT_TACTICAL_MASK_OVERLAY					37
#define BIT_TEAM_FREE								38
#define BIT_TEAM_ALLIES								39
#define BIT_TEAM_AXIS								40
#define BIT_TEAM_SPECTATOR							41
#define BIT_COMPASS_VISIBLE							42
#define BIT_HUD_SHOWOBJICONS						43
#define BIT_SCOREBOARD_OPEN							44
#define BIT_POPUPS_VISIBLE							45
#define BIT_HUD_OBITUARIES							46
#define BIT_POF_SPEC_ALLOW_FREELOOK					47
#define BIT_POF_FOLLOW								48
#define BIT_IS_WAGER_MATCH							49
#define BIT_IN_GUIDED_MISSILE_STATIC				50
#define BIT_DRAW_DPAD_COMPASS						51

#define FRIEND_NOTJOINABLE				0
#define FRIEND_JOINABLE					1
#define FRIEND_AUTOJOINABLE				2
#define FRIEND_AUTOJOINED				3

#define EMBLEM_LAYER_LOCKED             0
#define EMBLEM_LAYER_UNLOCKED           1
#define EMBLEM_LAYER_EMPTY              2
#define EMBLEM_LAYER_INUSE              3

#define EMBLEM_ICON_CLASSIFIED          0
#define EMBLEM_ICON_LOCKED              1
#define EMBLEM_ICON_UNLOCKED            2
#define EMBLEM_ICON_PURCHASED           3
#define EMBLEM_ICON_INVALID             4

// Must match GFX_FRAME_SIDE_* define
#define FRAME_SIDE_LEFT                 1
#define FRAME_SIDE_RIGHT                2
#define FRAME_SIDE_TOP                  4
#define FRAME_SIDE_BOTTOM               8

#define FRAME_SIDE_ALL                  FRAME_SIDE_LEFT FRAME_SIDE_RIGHT FRAME_SIDE_BOTTOM FRAME_SIDE_TOP
#define FRAME_OPEN_LEFT                 FRAME_SIDE_RIGHT FRAME_SIDE_BOTTOM FRAME_SIDE_TOP
#define FRAME_OPEN_RIGHT                FRAME_SIDE_LEFT FRAME_SIDE_BOTTOM FRAME_SIDE_TOP
#define FRAME_OPEN_TOP                  FRAME_SIDE_LEFT FRAME_SIDE_RIGHT FRAME_SIDE_BOTTOM
#define FRAME_OPEN_BOTTOM               FRAME_SIDE_LEFT FRAME_SIDE_RIGHT FRAME_SIDE_TOP

#define BAN_REASON						0
#define BAN_LIVE_MP						1
#define BAN_LIVE_ZOMBIE					2
#define BAN_LEADERBOARD_WRITE_MP		3
#define BAN_LEADERBOARD_WRITE_ZOMBIE	4
#define BAN_MP_SPLIT_SCREEN				5
#define BAN_EMBLEM_EDITOR				6
#define BAN_PIRACY						7
#define BAN_PRESTIGE					8

#define SYSINFO_VERSION_NUMBER			0
#define SYSINFO_CONNECTIVITY_INFO		1
#define SYSINFO_NAT_TYPE				2
#define SYSINFO_CUSTOMER_SUPPORT_LINK	3
#define SYSINFO_BANDWIDTH				4
#define SYSINFO_IP_ADDRESS				5
#define SYSINFO_GEOGRAPHICAL_REGION		6
#define SYSINFO_Q						7

#define IS_FRENCH						( dvarInt( loc_language ) == 1 || dvarInt( loc_language ) == 2 )
#define IS_RUSSIAN						( dvarInt( loc_language ) == 8 )
#define IS_POLISH						( dvarint( loc_language ) == 9 )
#define IS_JAPANESE						( dvarint( loc_language ) == 11 || dvarint( loc_language ) == 13 )
#define USE_SMALLER_FONT				( IS_RUSSIAN || IS_POLISH || IS_JAPANESE )
#define FOREIGN_LANGUAGE_MULTIPLIER		0.85

#define INGAMESTORE_MAPPACKS			0
#define INGAMESTORE_AVATARS				1
#define INGAMESTORE_THEMES				2
#define INGAMESTORE_FREEOFFER			3
