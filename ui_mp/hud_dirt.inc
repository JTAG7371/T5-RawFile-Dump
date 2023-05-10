#define DIRT_COLOR 0.56 0.53 0.4
#define SNOW_COLOR 1 1 1
#define DIRT_FADE_IN_1_4 65
#define DIRT_FADE_IN_1_2 130
#define DIRT_FADE_IN_3_4 195
#define DIRT_FADE_IN_TIME 260
#define DIRT_WAIT_TIME 2000
#define DIRT_FADE_OUT_TIME 1000
#define DIRT_WAIT_TIME_SHORT 500
#define DIRT_FADE_OUT_TIME_SHORT 250
#define DUST_FULL_ALPHA 0.25

// Dirt overlay
menuDef
{
	name			"fullscreen_dirt"
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	fullScreen		0
	visible			when( !isInGuidedMissile() )
	visibilityBits  bits( !BIT_DEMO_CAMERA_MODE_THIRDPERSON !BIT_DEMO_CAMERA_MODE_MOVIECAM !BIT_DEMO_ALL_GAME_HUD_HIDDEN )
	
	itemDef 
	{
		name			"dirt"
		style			WINDOW_STYLE_SHADER
		rect	 		-192 -144 1024 768
		background		"fullscreen_dirt_bottom";
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		320 540 1 1
			forecolor	DIRT_COLOR 1
			onEnter { changeState in_2 DIRT_FADE_IN_3_4; }
		}
		state
		{
			name		"in_2"
			rect		-64 27 768 576
			forecolor	DIRT_COLOR 0.25
			onEnter
			{
				changeState in_3 DIRT_FADE_IN_1_4;
				execnow ui_animate fullscreen_dirt blurred_dirt in DIRT_FADE_IN_1_4;
			}
		}
		state
		{
			name		"in_3"
		}
	}
	
	itemDef
	{
		name			"dirt_right"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_right"
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		700 240 1 1
			forecolor	DIRT_COLOR 0
			onEnter { changeState in_2 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_2"
			rect		525 120 160 120
			forecolor	DIRT_COLOR 0.5
			onEnter { changeState in_3 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_3"
			forecolor	DIRT_COLOR 1
			onEnter
			{
				execnow ui_animate fullscreen_dirt dirt_right_splash out 0;
				changeState Default 0;
			}
		}
	}
	
	itemDef
	{
		name			"dirt_right_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_right"
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	DIRT_COLOR 1
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	DIRT_COLOR 1
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	
	itemDef
	{
		name			"dirt_left"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_left"
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		-60 240 1 1
			forecolor	DIRT_COLOR 0
			onEnter { changeState in_2 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_2"
			rect		-45 120 160 120
			forecolor	DIRT_COLOR 0.5
			onEnter { changeState in_3 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_3"
			forecolor	DIRT_COLOR 1
			onEnter
			{
				
				execnow ui_animate fullscreen_dirt dirt_left_splash out 0;
				changeState Default 0;
			}
		}
	}
	
	itemDef
	{
		name			"dirt_left_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_left"
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	DIRT_COLOR 1
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	DIRT_COLOR 1
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	
	itemDef 
	{
		name			"blurred_dirt"
		style			WINDOW_STYLE_SHADER
		rect			-64 27 768 576
		background		"fullscreen_dirt_bottom_b";
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR 1
			onEnter { changeState wait DIRT_WAIT_TIME; }
		}
		state
		{
			name		"wait"
			rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR 1
			onEnter { changeState out DIRT_FADE_OUT_TIME; }
		}
		state
		{
			name		"out"
			rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR 0
		}
	}
	
	itemDef 
	{
		name			"blurred_dirt_random"
		style			WINDOW_STYLE_SHADER
		rect			-192 -144 1024 768
		exp rect X(-292 + dvarint(blurred_dirt_random_X))
		exp rect Y(-244 + dvarint(blurred_dirt_random_Y))
		background		"fullscreen_dirt_bottom_b";
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
//				rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR 1
			onEnter 
			{ 
				changeState wait DIRT_WAIT_TIME_SHORT; 
			}
		}
		state
		{
			name		"wait"
//				rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR 1
			onEnter 
			{ 
				changeState out DIRT_FADE_OUT_TIME_SHORT; 
			}
		}
		state
		{
			name		"out"
//				rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR 0
			onEnter 
			{ 
				execnow set blurred_dirt_random_X ( randomintrange( 0, 200 ) );
				execnow set blurred_dirt_random_Y ( randomintrange( 0, 200 ) );
			}
		}
	}	
}
menuDef
{
	name			"fullscreen_dust"
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	fullScreen		0
	visible			when( !isInGuidedMissile() )
	visibilityBits  bits( !BIT_DEMO_CAMERA_MODE_THIRDPERSON !BIT_DEMO_CAMERA_MODE_MOVIECAM !BIT_DEMO_ALL_GAME_HUD_HIDDEN )
	
	itemDef 
	{
		name			"dust"
		style			WINDOW_STYLE_SHADER
		rect	 		-192 -144 1024 768
		background		"fullscreen_dirt_bottom";
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		320 540 1 1
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter { changeState in_2 DIRT_FADE_IN_3_4; }
		}
		state
		{
			name		"in_2"
			rect		-64 27 768 576
			forecolor	DIRT_COLOR 0.25
			onEnter
			{
				changeState in_3 DIRT_FADE_IN_1_4;
				execnow ui_animate fullscreen_dust blurred_dust in DIRT_FADE_IN_1_4;
			}
		}
		state
		{
			name		"in_3"
		}
	}
	
	itemDef
	{
		name			"dust_right_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_right"
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	itemDef
	{
		name			"dust_left_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_left"
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	
	itemDef 
	{
		name			"blurred_dust"
		style			WINDOW_STYLE_SHADER
		rect			-64 27 768 576
		background		"fullscreen_dirt_bottom_b";
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter { changeState wait DIRT_WAIT_TIME; }
		}
		state
		{
			name		"wait"
			rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter { changeState out DIRT_FADE_OUT_TIME; }
		}
		state
		{
			name		"out"
			rect 		-192 -144 1024 768
			forecolor	DIRT_COLOR 0
		}
	}
	
	itemDef 
	{
		name			"blurred_dust_random"
		style			WINDOW_STYLE_SHADER
		rect			-192 -144 1024 768
		exp rect X(-292 + dvarint(blurred_dust_random_X))
		exp rect Y(-244 + dvarint(blurred_dust_random_Y))
		background		"fullscreen_dirt_bottom_b";
		forecolor		DIRT_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter 
			{ 
				changeState wait DIRT_WAIT_TIME_SHORT; 
			}
		}
		state
		{
			name		"wait"
			forecolor	DIRT_COLOR DUST_FULL_ALPHA
			onEnter 
			{ 
				changeState out DIRT_FADE_OUT_TIME_SHORT; 
			}
		}
		state
		{
			name		"out"
			forecolor	DIRT_COLOR 0
			onEnter 
			{ 
				execnow set blurred_dust_random_X ( randomintrange( 0, 200 ) );
				execnow set blurred_dust_random_Y ( randomintrange( 0, 200 ) );
			}
		}
	}	
}

// Snow overlay
menuDef
{
	name			"fullscreen_snow"
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	fullScreen		0
	visible			when( !isInGuidedMissile() )
	visibilityBits  bits( !BIT_DEMO_CAMERA_MODE_THIRDPERSON !BIT_DEMO_CAMERA_MODE_MOVIECAM !BIT_DEMO_ALL_GAME_HUD_HIDDEN )
	
	itemDef 
	{
		name			"dirt"
		style			WINDOW_STYLE_SHADER
		rect	 		-192 -144 1024 768
		background		"fullscreen_dirt_bottom";
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		320 540 1 1
			forecolor	SNOW_COLOR 1
			onEnter { changeState in_2 DIRT_FADE_IN_3_4; }
		}
		state
		{
			name		"in_2"
			rect		-64 27 768 576
			forecolor	SNOW_COLOR 0.25
			onEnter
			{
				changeState in_3 DIRT_FADE_IN_1_4;
				execnow ui_animate fullscreen_snow blurred_dirt in DIRT_FADE_IN_1_4;
			}
		}
		state
		{
			name		"in_3"
		}
	}
	
	itemDef
	{
		name			"dirt_right"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_right"
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		700 240 1 1
			forecolor	SNOW_COLOR 0
			onEnter { changeState in_2 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_2"
			rect		525 120 160 120
			forecolor	SNOW_COLOR 0.5
			onEnter { changeState in_3 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_3"
			forecolor	SNOW_COLOR 1
			onEnter
			{
				execnow ui_animate fullscreen_snow dirt_right_splash out 0;
				changeState Default 0;
			}
		}
	}
	
	itemDef
	{
		name			"dirt_right_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_right"
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	SNOW_COLOR 1
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	SNOW_COLOR 1
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	
	itemDef
	{
		name			"dirt_left"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_left"
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		-60 240 1 1
			forecolor	SNOW_COLOR 0
			onEnter { changeState in_2 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_2"
			rect		-45 120 160 120
			forecolor	SNOW_COLOR 0.5
			onEnter { changeState in_3 DIRT_FADE_IN_1_2; }
		}
		state
		{
			name		"in_3"
			forecolor	SNOW_COLOR 1
			onEnter
			{
				
				execnow ui_animate fullscreen_snow dirt_left_splash out 0;
				changeState Default 0;
			}
		}
	}
	
	itemDef
	{
		name			"dirt_left_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_left"
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	SNOW_COLOR 1
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	SNOW_COLOR 1
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	
	itemDef 
	{
		name			"blurred_dirt"
		style			WINDOW_STYLE_SHADER
		rect			-64 27 768 576
		background		"fullscreen_dirt_bottom_b";
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR 1
			onEnter { changeState wait DIRT_WAIT_TIME; }
		}
		state
		{
			name		"wait"
			rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR 1
			onEnter { changeState out DIRT_FADE_OUT_TIME; }
		}
		state
		{
			name		"out"
			rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR 0
		}
	}
	
	itemDef 
	{
		name			"blurred_dirt_random"
		style			WINDOW_STYLE_SHADER
		rect			-192 -144 1024 768
		exp rect X(-292 + dvarint(blurred_dirt_random_X))
		exp rect Y(-244 + dvarint(blurred_dirt_random_Y))
		background		"fullscreen_dirt_bottom_b";
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
//				rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR 1
			onEnter 
			{ 
				changeState wait DIRT_WAIT_TIME_SHORT; 
			}
		}
		state
		{
			name		"wait"
//				rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR 1
			onEnter 
			{ 
				changeState out DIRT_FADE_OUT_TIME_SHORT; 
			}
		}
		state
		{
			name		"out"
//				rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR 0
			onEnter 
			{ 
				execnow set blurred_dirt_random_X ( randomintrange( 0, 200 ) );
				execnow set blurred_dirt_random_Y ( randomintrange( 0, 200 ) );
			}
		}
	}	
}
menuDef
{
	name			"fullscreen_snow_dust"
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	fullScreen		0
	visible			when( !isInGuidedMissile() )
	visibilityBits  bits( !BIT_DEMO_CAMERA_MODE_THIRDPERSON !BIT_DEMO_CAMERA_MODE_MOVIECAM !BIT_DEMO_ALL_GAME_HUD_HIDDEN )
	
	itemDef 
	{
		name			"dust"
		style			WINDOW_STYLE_SHADER
		rect	 		-192 -144 1024 768
		background		"fullscreen_dirt_bottom";
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect		320 540 1 1
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter { changeState in_2 DIRT_FADE_IN_3_4; }
		}
		state
		{
			name		"in_2"
			rect		-64 27 768 576
			forecolor	SNOW_COLOR 0.25
			onEnter
			{
				changeState in_3 DIRT_FADE_IN_1_4;
				execnow ui_animate fullscreen_snow_dust blurred_dust in DIRT_FADE_IN_1_4;
			}
		}
		state
		{
			name		"in_3"
		}
	}
	
	itemDef
	{
		name			"dust_right_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_right"
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	itemDef
	{
		name			"dust_left_splash"
		style			WINDOW_STYLE_SHADER
		rect			0 0 640 480
		background		"fullscreen_dirt_left"
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter { changeState out DIRT_WAIT_TIME_SHORT; }
		}	
		state
		{
			name		"out"
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter { changeState Default DIRT_FADE_OUT_TIME; }
		}	
	}
	
	itemDef 
	{
		name			"blurred_dust"
		style			WINDOW_STYLE_SHADER
		rect			-64 27 768 576
		background		"fullscreen_dirt_bottom_b";
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter { changeState wait DIRT_WAIT_TIME; }
		}
		state
		{
			name		"wait"
			rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter { changeState out DIRT_FADE_OUT_TIME; }
		}
		state
		{
			name		"out"
			rect 		-192 -144 1024 768
			forecolor	SNOW_COLOR 0
		}
	}
	
	itemDef 
	{
		name			"blurred_dust_random"
		style			WINDOW_STYLE_SHADER
		rect			-192 -144 1024 768
		exp rect X(-292 + dvarint(blurred_dust_random_X))
		exp rect Y(-244 + dvarint(blurred_dust_random_Y))
		background		"fullscreen_dirt_bottom_b";
		forecolor		SNOW_COLOR 0
		visible			1
		decoration
		
		state
		{
			name		"in"
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter 
			{ 
				changeState wait DIRT_WAIT_TIME_SHORT; 
			}
		}
		state
		{
			name		"wait"
			forecolor	SNOW_COLOR DUST_FULL_ALPHA
			onEnter 
			{ 
				changeState out DIRT_FADE_OUT_TIME_SHORT; 
			}
		}
		state
		{
			name		"out"
			forecolor	SNOW_COLOR 0
			onEnter 
			{ 
				execnow set blurred_dust_random_X ( randomintrange( 0, 200 ) );
				execnow set blurred_dust_random_Y ( randomintrange( 0, 200 ) );
			}
		}
	}	
}