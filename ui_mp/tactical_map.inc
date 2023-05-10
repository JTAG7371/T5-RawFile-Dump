#ifndef SPLITSCREEN_ENABLED
	#ifndef MAP_X
	#define MAP_X					(- (MAP_WIDTH - RIGHTITEM_OFFSET + 31 ))
	#endif
	
	#ifndef MAP_Y
	#define MAP_Y					95
	#endif
	
	#ifndef MAP_WIDTH
	#define MAP_WIDTH				220
	#endif
	
	#ifndef MAP_HEIGHT	
	#define MAP_HEIGHT				275
	#endif
	
	#define ORIGIN_MAP_FRAME		MAP_X MAP_Y
	#define MAP_WIDTH2				(MAP_WIDTH+5)
#else
	#ifndef MAP_X
	#define MAP_X					(- (MAP_WIDTH - RIGHTITEM_OFFSET+4 ))
	#endif
	
	#ifndef MAP_Y
	#define MAP_Y					27
	#endif
	
	#ifndef MAP_WIDTH
	#define MAP_WIDTH				140
	#endif
	
	#ifndef MAP_HEIGHT	
	#define MAP_HEIGHT				120
	#endif
	
	#define ORIGIN_MAP_FRAME		MAP_X MAP_Y
	#define MAP_WIDTH2				(MAP_WIDTH+5)
#endif

#ifndef SHOW_TEXT_ON_MAP
#define SHOW_TEXT_ON_MAP 1
#endif

#ifndef TACTICAL_MAP_ALPHA
#define TACTICAL_MAP_ALPHA 0.6
#endif

#ifndef TEAM_IS_MARINES
#error "TEAM_IS_MARINES undefined"
#endif

#ifndef TEAM_IS_OPFOR
#error "TEAM_IS_OPFOR undefined"
#endif

#define ALLIES_HAVE_UAV (dvarint( ui_uav_allies ) && team( name ) == "TEAM_ALLIES" )
#define AXIS_HAVE_UAV (dvarint( ui_uav_axis ) && team( name ) == "TEAM_AXIS" )
#define CLIENT_HAS_UAV (dvarint( ui_uav_client ) && team( name ) == "TEAM_FREE" )
//#define SHOULD_SHOW_MAP ( dvarbool( ui_hud_hardcore ) == 0 || ALLIES_HAVE_UAV || AXIS_HAVE_UAV || CLIENT_HAS_UAV )
#ifndef SHOULD_SHOW_MAP
#define SHOULD_SHOW_MAP 1
#endif

#ifndef SPLITSCREEN_ENABLED
	#define GAMETYPE_HEIGHT MAP_HEIGHT
#else
	#define GAMETYPE_HEIGHT (MAP_WIDTH+5)
#endif 

// map display ================================================
#define MAP_OFFSET		0 21

	itemDef
   	{
		name			"mini_map2"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		background		"compass_map_default"
		ownerdraw		CG_PLAYER_FULLMAP_MAP
		visible			when ( SHOULD_SHOW_MAP );
		decoration
   	}

	itemDef
   	{
		style			WINDOW_STYLE_SHADER
		type			ITEM_TYPE_IMAGE
		name			"mini_map2_overlay"
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		exp				material( tableLookup( "mp/mapsTable.csv", 0, dvarString( mapname ), 7 ) )
		visible			0
		decoration
   	}

	// Friendly scrambler icons
	itemDef
	{
		name			"mapscramblerfriendly"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		ownerdraw		CG_PLAYER_FULLMAP_SCRAMBLER_FRIENDLY
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits  	bits( !BIT_IN_KILLCAM )
		decoration
	}

	// Friendly scrambler icons
	itemDef
	{
		name			"tacticalmapstatic"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		background		"tow_filter_overlay_no_signal"
		ownerdraw		CG_PLAYER_FULLMAP_STATIC
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits  	bits( !BIT_IN_KILLCAM )
		decoration
	}

	// Grid
	itemDef
   	{
		name			"map_grid"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 0.75
		background		"map_grid_square"
		ownerdraw		CG_PLAYER_FULLMAP_GRID
		visible			when ( SHOULD_SHOW_MAP );
		decoration
   	}
	itemDef
	{
		name			"grid_points"
		type			ITEM_TYPE_OWNERDRAW_TEXT
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 0.7
		textscale		0.3
		textfont		UI_FONT_NORMAL
		textalign		ITEM_ALIGN_MIDDLE_CENTER
		textstyle		ITEM_TEXTSTYLE_SHADOWED
		ownerdraw		CG_PLAYER_FULLMAP_GRID_POINTS
		visible			when ( SHOULD_SHOW_MAP );
		decoration
	}
   	
	// Objective pointers
	itemDef
	{
		name			"compasspointers2"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		background		"objective_line"
		ownerdraw		CG_PLAYER_FULLMAP_POINTERS
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits  	bits( !BIT_IN_KILLCAM )
		decoration
	}
   	// Friendlies pointers
	itemDef
	{
		name			"compassfriendlies2"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		background		"compassping_friendly"
		ownerdraw		CG_PLAYER_FULLMAP_FRIENDS
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits  	bits( !BIT_IN_KILLCAM )
		decoration
	}
   	// Enemy pings
	itemDef
	{
		name			"compassenemies2"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		background		"compassping_enemy"
		ownerdraw		CG_PLAYER_FULLMAP_ENEMIES
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits 		bits( !BIT_IN_KILLCAM )
		decoration
	}
   	// Fake fire pings
	itemDef
	{
		name			"compassfakefire2"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		background		"compassping_enemy"
		ownerdraw		CG_PLAYER_FULLMAP_FAKE_FIRE
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits 		bits( !BIT_IN_KILLCAM )
		decoration
	}
	
	// Player direction indicator
	itemDef
	{
		name			"compassplayer2"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		background		"compassping_player"
		ownerdraw		CG_PLAYER_FULLMAP_PLAYER
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits  	bits( !BIT_IN_KILLCAM )
		decoration
	}		
	// Vehicles
	itemDef
	{
		name			"mapvehicles"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		ownerdraw		CG_PLAYER_FULLMAP_VEHICLES
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits  	bits( !BIT_IN_KILLCAM )
		decoration
	}	
   	// Artillery Icon
	itemDef
	{
		name			"mapartilleryicon"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		ownerdraw		CG_PLAYER_FULLMAP_ARTILLERY_ICON
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits  	bits( !BIT_IN_KILLCAM )
		decoration
	}
	// Dogs
	itemDef
	{
		name			"mapdogs"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		ownerdraw		CG_PLAYER_FULLMAP_DOGS
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits		bits( !BIT_IN_KILLCAM )
		decoration
	}
	// Turrets
	itemDef
	{
		name			"mapturrets"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		ownerdraw		CG_PLAYER_FULLMAP_TURRETS
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits		bits( !BIT_IN_KILLCAM )
		decoration
	}
	// Guided Missiles
	itemDef
	{
		name			"mapguidedmissiles"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 TACTICAL_MAP_ALPHA
		ownerdraw		CG_PLAYER_FULLMAP_GUIDED_MISSILE
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits		bits( !BIT_IN_KILLCAM )
		decoration
	}
	// Radar lines
	itemDef
	{
		name			"mapradareffects"
		type			ITEM_TYPE_OWNERDRAW
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		1 1 1 1
		ownerdraw		CG_PLAYER_FULLMAP_RADAR_EFFECTS
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits		bits( !BIT_IN_KILLCAM )
		decoration
	}
	// Extra cam
	itemDef
   	{
		style			WINDOW_STYLE_SHADER
		type			ITEM_TYPE_IMAGE
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		exp				material( "extracam2d" );
		forecolor		1 1 1 1
		visible			when ( SHOULD_SHOW_MAP );
		visibilityBits	bits( !BIT_EXTRACAM_STATIC BIT_EXTRACAM_ACTIVE !BIT_IN_KILLCAM );
		decoration
   	}
   	// REC text
	itemDef
	{
		type			ITEM_TYPE_TEXT
		rect			(MAP_X+2) (MAP_Y+16) MAP_WIDTH MAP_HEIGHT RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		textstyle		ITEM_TEXTSTYLE_NORMAL
		textalign		ITEM_ALIGN_LEFT
		textfont		UI_FONT_NORMAL
		textscale		0.33
		forecolor		EXTRACAM_RED_COLOR 1
		text			"REC"
		visible			when( SHOULD_SHOW_MAP );
		visibilityBits	bits( !BIT_EXTRACAM_STATIC BIT_EXTRACAM_ACTIVE !BIT_IN_KILLCAM );
		decoration
	}
	// Blinking REC light
	itemDef
	{
		style			WINDOW_STYLE_SHADER
		type			ITEM_TYPE_IMAGE
		rect			(MAP_X+24) (MAP_Y+3.5) 9 9 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		forecolor		EXTRACAM_RED_COLOR 1
		exp				material( "hud_dpad_eqip_count_backing" );
		visible			when( SHOULD_SHOW_MAP );
		visibilityBits	bits( !BIT_EXTRACAM_STATIC BIT_EXTRACAM_ACTIVE );
		decoration
		
		state
		{
			name		"spike_cam_on"
			onEnter
			{
				changeState	spike_cam_on_wait 750;
			}
		}
		state
		{
			name		"spike_cam_on_wait"
			onEnter
			{
				changeState spike_cam_off 0;
			}
		}
		state
		{
			name		"spike_cam_off"
			forecolor	EXTRACAM_RED_COLOR 0
			onEnter
			{
				changeState spike_cam_off_wait 750;
			}
		}
		state
		{
			name		"spike_cam_off_wait"
			forecolor	EXTRACAM_RED_COLOR 0
			onEnter
			{
				changeState spike_cam_on 0;
			}
		}
	}
   	itemDef
   	{
		style			WINDOW_STYLE_SHADER
		type			ITEM_TYPE_IMAGE
		rect			ORIGIN_MAP_FRAME MAP_WIDTH MAP_WIDTH RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		origin			MAP_OFFSET
		exp				material( "compass_static" );
		forecolor		1 1 1 1
		visible			when ( SHOULD_SHOW_MAP && ( isVisibilityBitSet( BIT_EXTRACAM_STATIC ) || isVisibilityBitSet( BIT_IN_KILLCAM ) );
		decoration
   	}
