#include common_scripts\utility;
#include maps\_utility; 

// cleaned up by DPG (4/4/07)


/*
==============
///GSCDocBegin
"Name: main()"
"Summary: sets up script for an intro screen to work"
"CallOn: Should only be called as a function, not a thread"
"ScriptFile: "
"MandatoryArg: "
"OptionalArg: "
"Example: "
"NoteLine: maps\_introscreen::main() is called in _load. Each level's introscreen should be set up in the switch statement contained in this file's main() function"
"LEVELVAR: level.script - used for determining which introscreen to display"
"LEVELVAR: pullup_weapon - not used for anything as of yet...
"LEVELVAR: introscreen_complete - used to signify when all the introscreen behavior is finished
"SPCOOP: both"
///GSCDocEnd
==============
*/
main()
{
	/#
	debug_replay("File: _introscreen.gsc. Function: main()\n");
	#/
	
	flag_init( "pullup_weapon" ); 
	flag_init( "starting final intro screen fadeout" );
	flag_init( "introscreen_complete" ); // used to notify when introscreen is complete
	
	PrecacheShader( "black" ); 
	
	if( GetDvar( #"introscreen" ) == "" )
	{
		SetDvar( "introscreen", "1" ); 
	}

	level.splitscreen = GetDvarInt( #"splitscreen" );
	level.hidef = GetDvarInt( #"hidef" );

	level thread introscreen_report_disconnected_clients();
	

	switch( level.script )
	{
		case "example":
			/*
			PrecacheString( &"INTROSCREEN_EXAMPLE_TITLE" ); 
			PrecacheString( &"INTROSCREEN_EXAMPLE_PLACE" ); 
			PrecacheString( &"INTROSCREEN_EXAMPLE_DATE" ); 
			PrecacheString( &"INTROSCREEN_EXAMPLE_INFO" ); 
			introscreen_delay( &"INTROSCREEN_EXAMPLE_TITLE", &"INTROSCREEN_EXAMPLE_PLACE", &"INTROSCREEN_EXAMPLE_DATE", &"INTROSCREEN_EXAMPLE_INFO" ); 
			*/
			break; 

//-------------------//
// Production Levels //
//-------------------//
	
		
		case "so_narrative1_frontend":
		case "so_narrative2_frontend":
		case "so_narrative3_frontend":
		case "so_narrative4_frontend":
		case "so_narrative5_frontend":
		case "so_narrative6_frontend":
		case "int_escape":
			introscreen_delay( undefined, undefined, undefined, undefined, undefined, 1, 0, 0, true );
		break;
		

		case "cuba":
			//introscreen_redact_delay( &"CUBA_INTROSCREEN_TITLE", &"CUBA_INTROSCREEN_PLACE", &"CUBA_INTROSCREEN_TARGET", &"CUBA_INTROSCREEN_TEAM", &"CUBA_INTROSCREEN_DATE", 2, 15, 1.5, 1.8, 2 );
			break;
		case "vorkuta":
			introscreen_delay( &"VORKUTA_INTROSCREEN_EXTRA", &"VORKUTA_INTROSCREEN_TITLE", &"VORKUTA_INTROSCREEN_PLACE", &"VORKUTA_INTROSCREEN_DATE");
			break;

		case "quagmire":
		case "creek_1":
			introscreen_delay( "", "", "", "", undefined, undefined, undefined, 4+7 );
			break;

		case "kowloon":
			introscreen_redact_delay( &"KOWLOON_INTROSCREEN_TITLE", &"KOWLOON_INTROSCREEN_PLACE", &"KOWLOON_INTROSCREEN_NAME", &"KOWLOON_INTROSCREEN_DATE", undefined, 1.0, undefined, undefined, undefined, 0.8 );
			break;

		case "hue_city":
			break;
		
		case "khe_sanh":
			introscreen_redact_delay( &"KHE_SANH_INTRO_LINE_ONE", &"KHE_SANH_INTRO_LINE_TWO", &"KHE_SANH_INTRO_LINE_THREE", &"KHE_SANH_INTRO_LINE_FOUR", &"KHE_SANH_INTRO_LINE_FIVE", 1, undefined, undefined, undefined, 0.8 );
			//introscreen_delay( &"QUAGMIRE_INTROSCREEN_TITLE", &"QUAGMIRE_INTROSCREEN_DATE", &"QUAGMIRE_INTROSCREEN_PLACE", &"QUAGMIRE_INTROSCREEN_NAME", &"QUAGMIRE_INTROSCREEN_INFO" );
			break;
			
		case "flashpoint":
			introscreen_redact_delay( &"FLASHPOINT_INTROSCREEN_TITLE", &"FLASHPOINT_INTROSCREEN_PLACE", &"FLASHPOINT_INTROSCREEN_INFO", &"FLASHPOINT_INTROSCREEN_DATE", undefined );
			break;
			
		case "pow":
			level.introscreen_shader = "none";
			//introscreen_redact_delay( &"POW_REDACTED_ONE", &"POW_REDACTED_TWO", &"POW_REDACTED_THREE", &"POW_REDACTED_FOUR", &"POW_REDACTED_FIVE", 3.0, 22.0, 12, undefined, 1, (1,1,1)); //currently uses custom introscreen in pow_utility::demo_intro_screen();
			introscreen_redact_delay( &"POW_REDACTED_ONE", &"POW_REDACTED_TWO", &"POW_REDACTED_THREE", &"POW_REDACTED_FOUR", &"POW_REDACTED_FIVE", undefined, undefined, undefined, undefined, undefined, (1,1,1));
			break;
		
		case "nazi_zombie_prototype":
			introscreen_delay();
			break;
			
		case "pentagon":
			introscreen_redact_delay( &"PENTAGON_INTROSCREEN_0", &"PENTAGON_INTROSCREEN_1", &"PENTAGON_INTROSCREEN_2", &"PENTAGON_INTROSCREEN_3" );
			break;
			
		case "fullahead":
			// played later on in the level script
			//introscreen_redact_delay( &"FULLAHEAD_INTROSCREEN_1", &"FULLAHEAD_INTROSCREEN_2", &"FULLAHEAD_INTROSCREEN_3", &"FULLAHEAD_INTROSCREEN_4", &"FULLAHEAD_INTROSCREEN_5" );
			introscreen_delay();
			break;
			
		case "rebirth":
			if(!IsDefined(level.start_point))//For createFX mode
				introscreen_redact_delay( &"REBIRTH_MASON_INTROSCREEN_1", &"REBIRTH_MASON_INTROSCREEN_2", &"REBIRTH_MASON_INTROSCREEN_3", &"REBIRTH_MASON_INTROSCREEN_4", &"REBIRTH_MASON_INTROSCREEN_5" );
			else
			{	
				if(level.start_point == "default" || level.start_point == "mason_stealth" || level.start_point == "mason_lab")
					introscreen_redact_delay( &"REBIRTH_MASON_INTROSCREEN_1", &"REBIRTH_MASON_INTROSCREEN_2", &"REBIRTH_MASON_INTROSCREEN_3", &"REBIRTH_MASON_INTROSCREEN_4", &"REBIRTH_MASON_INTROSCREEN_5" );
				else
				{
					if(level.start_point != "btr_rail")
						introscreen_redact_delay( &"REBIRTH_MASON_INTROSCREEN_1", &"REBIRTH_HUDSON_INTROSCREEN_2", &"REBIRTH_HUDSON_INTROSCREEN_3", &"REBIRTH_HUDSON_INTROSCREEN_4" );				
				}
			}
			break;

		case "river":
			introscreen_redact_delay( &"RIVER_INTROSCREEN_1", &"RIVER_INTROSCREEN_3", &"RIVER_INTROSCREEN_4", &"RIVER_INTROSCREEN_5", undefined );
			break;
			
		case "wmd_sr71":
			introscreen_redact_delay( &"WMD_SR71_INTRO_LEVELNAME", &"WMD_SR71_INTRO_DATE", &"WMD_SR71_INTRO_EXTRA", &"WMD_SR71_INTRO_NAME", &"WMD_SR71_INTRO_LOCATION");
			break;
			
		case "wmd":
			introscreen_redact_delay( &"WMD_INTRO_LEVELNAME", &"WMD_INTRO_LOCATION", &"WMD_INTRO_EXTRA", &"WMD_INTRO_NAME", &"WMD_INTRO_DATE" );
			break;

		case "underwaterbase":
			introscreen_redact_delay( &"UNDERWATERBASE_INTROSCREEN_1", &"UNDERWATERBASE_INTROSCREEN_2", &"UNDERWATERBASE_INTROSCREEN_3", &"UNDERWATERBASE_INTROSCREEN_4", &"UNDERWATERBASE_INTROSCREEN_5" );
			break;
				
			
//-------------//
// Test Levels //
//-------------//
		default:
			// Shouldn't do a notify without a wait( statement before it, or bad things can happen when loading a save game.
			wait( 0.05 ); 
			level notify( "finished final intro screen fadein" ); 
			wait( 0.05 ); 
			flag_set( "starting final intro screen fadeout" ); 
			wait( 0.05 ); 
			level notify( "controls_active" ); // Notify when player controls have been restored
			wait( 0.05 ); 
			flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
			break; 
	}
	
	/#
	debug_replay("File: _introscreen.gsc. Function: main() - COMPLETE\n");
	#/
}

/* 
============= 
///ScriptDocBegin
"Name: introscreen_create_redacted_line()"
"Summary: creates a hud-element for the specified string ,sets its initial values, and does the redaction."
"CallOn: level"
"MandatoryArg: <string> : String for this line to display."
"OptionalArg: <redacted_line_time> : Time before string line starts to fade out"
"OptionalArg: <start_rubout_time> : Time before string line starts to get the rubout / redacted effect."
"OptionalArg: <rubout_time> : Time it takes to finish rub/redacting one line of text from when it starts."
"OptionalArg: <color> : color of text"
"OptionalArg: <type> : Determines placement of text."
"OptionalArg: <scale> : Determines size of text."
"OptionalArg: <font> : Sets the font of the text."

"introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time ); "
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
introscreen_create_redacted_line( string, redacted_line_time, start_rubout_time, rubout_time, color, type, scale, font )
{
	index = level.introstring.size; 
	yPos = ( index * 30 ); 
	
	if (level.console)
	{
		yPos -= 90; 
		xPos = 0;
	}
	else
	{
		yPos -= 120;
		xPos = 10;
	}

	align_x = "center";
	align_y = "middle";
	horz_align = "center";
	vert_align = "middle";

	// MikeD (4/28/2008): Default to lower left
	if( !IsDefined( type ) )
	{
		type = "lower_left";
	}

	if( IsDefined( type ) )
	{
		switch( type )
		{
			case "lower_left":
				yPos -= 30;
				align_x = "left";
				align_y = "bottom";
				horz_align = "left";
				vert_align = "bottom";
				break;
		}
	}

	if ( !isDefined( scale ) )
	{
		if ( level.splitscreen && !level.hidef )
			fontScale = 2.5;
		else
			fontScale = 1.5;
	}
	else
		fontScale = scale;
	
	level.introstring[index] = NewHudElem(); 
	level.introstring[index].x = xPos; 
	level.introstring[index].y = yPos; 
	level.introstring[index].alignX = align_x; 
	level.introstring[index].alignY = align_y; 
	level.introstring[index].horzAlign = horz_align; 
	level.introstring[index].vertAlign = vert_align; 
	level.introstring[index].sort = 1; // force to draw after the background
	level.introstring[index].foreground = true; 
	level.introstring[index].fontScale = fontScale; 
	level.introstring[index].color = (0,0,0);
	level.introstring[index] SetText( string );
	level.introstring[index] SetRedactFX( redacted_line_time, 700, start_rubout_time, rubout_time ); // param1 - time before text fades away, param2 - time it takes text to fade away, param 3 - time before start redacting text , param 4 - time it takes to cross out text
	level.introstring[index].alpha = 0; 
	level.introstring[index] FadeOverTime( 1.2 ); 
	level.introstring[index].alpha = 1; 

	if( IsDefined( font ) )
	{
		level.introstring[index].font = font;
	}
	
	if( IsDefined( color ) )
	{
		level.introstring[index].color = color;
	}

	if( IsDefined( level.introstring_text_color ) )
	{
		level.introstring[index].color =  level.introstring_text_color;
	}
}

// creates a hud-element for the specified string and sets its initial values
introscreen_create_line( string, type, scale, font, color )
{
	index = level.introstring.size; 
	yPos = ( index * 30 ); 
	
	if (level.console)
	{
		yPos -= 90; 
		xPos = 0;
	}
	else
	{
		yPos -= 120;
		xPos = 10;
	}

	align_x = "center";
	align_y = "middle";
	horz_align = "center";
	vert_align = "middle";

	// MikeD (4/28/2008): Default to lower left
	if( !IsDefined( type ) )
	{
		type = "lower_left";
	}

	if( IsDefined( type ) )
	{
		switch( type )
		{
			case "lower_left":
				yPos -= 30;
				align_x = "left";
				align_y = "bottom";
				horz_align = "left";
				vert_align = "bottom";
				break;
		}
	}

	if ( !isDefined( scale ) )
	{
		if ( level.splitscreen && !level.hidef )
			fontScale = 2.75;
		else
			fontScale = 1.75;
	}
	else
		fontScale = scale;
	
	level.introstring[index] = NewHudElem(); 
	level.introstring[index].x = xPos; 
	level.introstring[index].y = yPos; 
	level.introstring[index].alignX = align_x; 
	level.introstring[index].alignY = align_y; 
	level.introstring[index].horzAlign = horz_align; 
	level.introstring[index].vertAlign = vert_align; 
	level.introstring[index].sort = 1; // force to draw after the background
	level.introstring[index].foreground = true; 
	level.introstring[index].fontScale = fontScale; 
	level.introstring[index] SetText( string ); 
	level.introstring[index].alpha = 0; 
	level.introstring[index] FadeOverTime( 1.2 ); 
	level.introstring[index].alpha = 1; 

	if( IsDefined( font ) )
	{
		level.introstring[index].font = font;
	}
	
	if( IsDefined( color ) )
	{
		level.introstring[index].color = color;
	}
}

// fades out each line of text, then destroys each hud-element associated with each line
introscreen_fadeOutText()
{
	for( i = 0; i < level.introstring.size; i++ )
	{
		level.introstring[i] FadeOverTime( 1.5 ); 
		level.introstring[i].alpha = 0; 
	}

	wait( 1.5 ); 

	for( i = 0; i < level.introstring.size; i++ )
	{
		level.introstring[i] Destroy(); 
	}
	
	wait(0.25);
	
}




/* 
============= 
///ScriptDocBegin
"Name: introscreen_redact_delay()"
"Summary: Does the introscreen, displays strings, with redacted effect."
"CallOn: level"
"MandatoryArg: <string1> : 1st string in the introscreen."
"OptionalArg: <string2> : 2nd string in the introscreen."
"OptionalArg: <string3> : 3rd string in the introscreen."
"OptionalArg: <string4> : 4th string in the introscreen."
"OptionalArg: <string5> : 5th string in the introscreen."
"OptionalArg: <pausetime> : Amount of time to pause before starting to display each consecutive string line."
"OptionalArg: <totaltime> : Total time all introscreen text will be displayed."
"OptionalArg: <time_to_redact> : Time at which the first string starts to be redacted ."
"OptionalArg: <delay_after_text> : Time to wait after text all fades away before background hudelem fades."
"OptionalArg: <rubout_time> : Time it takes to redact one line of text.  Temp until we have a code solution to handle based on string length"

"introscreen_redact_delay( &"HUE_CITY_INTROSCREEN_LINE1", &"HUE_CITY_INTROSCREEN_LINE2", &"HUE_CITY_INTROSCREEN_LINE3", &"HUE_CITY_INTROSCREEN_LINE4", &"HUE_CITY_INTROSCREEN_LINE5"  );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
introscreen_redact_delay( string1, string2, string3, string4, string5, pausetime, totaltime, time_to_redact, delay_after_text, rubout_time, color )
{
	/#
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay()\n");
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - START WAIT waittillframeend x2\n");
	
	// MikeD: use waittillframend so starts get setup properly before the introscreen refers to any
	// level.start
	waittillframeend; 
	waittillframeend; 

	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - STOP WAIT waittillframeend x2\n");
	
	// SCRIPTER_MOD
	// MikeD( 3/16/200 ):  level.start_point is for their start, ( aka skipto ) stuff... But it did not check to see if it's already defined.
	//[ceng 5/18/2010] Fixed typo from IsDefined( level.start ) to IsDefined( level.start_point ).
	skipIntro = false; 
	if( IsDefined( level.start_point ) )
	{
		skipIntro = level.start_point != "default"; 
	}

	if( GetDvar( #"introscreen" ) == "0" )
	{
		skipIntro = true; 
	}
		
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - BEFORE VARIOUS WAITS\n");
	
	if( skipIntro )
	{
		// wait until the first player spawns into the game before sending
		// out the introscreen notifies
		//level waittill("first_player_ready",player);
		flag_wait( "all_players_connected" );
		
		if( IsDefined( level.custom_introscreen ) )
		{
			[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
			return;
		}
	
		waittillframeend; 
		level notify( "finished final intro screen fadein" ); 
		waittillframeend; 
		flag_set( "starting final intro screen fadeout" ); 
		waittillframeend; 
		level notify( "controls_active" ); // Notify when player controls have been restored
		waittillframeend; 
		flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" ); 
		return; 
	}
	#/

	if( IsDefined( level.custom_introscreen ) )
	{
		[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
		return;
	}

	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true;

	// Alex Liu 6-26-10: Added a way for a level to specify a introscreen shader, such as "white"
	// level is responsible to precache its own shader.  set to "none" if you want none
	if( !isdefined( level.introscreen_shader ) )
	{
		level.introblack SetShader( "white", 640, 480 );
	}
	else if (level.introscreen_shader != "none")
	{
		level.introblack SetShader( level.introscreen_shader, 640, 480 );
	}	


	// CODER_MOD: Austin (8/15/08): wait until all players have connected before showing black screen
	// the briefing menu will be displayed for network co-op in synchronize_players()
	flag_wait( "all_players_connected" );

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	if( !IsDefined( level.introscreen_dontfreezcontrols ) )
		freezecontrols_all( true ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	wait( 0.5 ); // Used to be 0.05, but we have to wait longer since the save takes precisely a half-second to finish.
 
	level.introstring = []; 
	
	
	if( !IsDefined( pausetime ) ) 
	{
		pausetime = 0.75;
	}
	if (!IsDefined(totaltime))
	{
		totaltime = 14.25;
	}
	if (!IsDefined(time_to_redact))
	{
		time_to_redact = ( 0.525 * totaltime);
	}
	if (!IsDefined(rubout_time))
	{
		rubout_time = 1;
	}

	delay_between_redacts_min = 350; // this is a slight pause added when redacting each line, so it isn't robotically smooth
	delay_between_redacts_max = 500;
	
	start_rubout_time = Int( time_to_redact*1000 );// convert to miliseconds and fraction of total time to start rubbing out the text
	totalpausetime = 0; // track how much time we've waited so we can wait total desired waittime
	rubout_time = Int(rubout_time*1000); // convert to miliseconds 

			// following 2 lines are used in and logically could exist in isdefined(string1), but need to be initialized so exist here
	redacted_line_time = Int( 1000* (totaltime - totalpausetime) ); // each consecutive line waits the total time minus the total pause time so far, so they all go away at once.



	if( IsDefined( string1 ) )
	{
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
	
		level thread introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time, color ); 

		wait( pausetime );
		totalpausetime += pausetime;	
	}

	if( IsDefined( string2 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomInt(delay_between_redacts_min,delay_between_redacts_max);
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
				
		level thread introscreen_create_redacted_line( string2, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomInt(delay_between_redacts_min,delay_between_redacts_max);	
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
	
		
		level thread introscreen_create_redacted_line( string3, redacted_line_time,  start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}
	
	if( IsDefined( string4 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) )	+ RandomInt(delay_between_redacts_min,delay_between_redacts_max);		
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
	
		
		level thread introscreen_create_redacted_line( string4, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}		
	
	if( IsDefined( string5 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomInt(delay_between_redacts_min,delay_between_redacts_max);			
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		//rubout_time = get_redact_length(string1) //**  TODO - Need code function to tell us how long it will take out to finish rubbing out based on localized string length
	
		level thread introscreen_create_redacted_line( string5, redacted_line_time, start_rubout_time, rubout_time, color);
	
		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	level notify( "finished final intro screen fadein" );
	
	// SRS 7/14/2008: scripter can make introscreen wait on text before fading up
	if( IsDefined( level.introscreen_waitontext_flag ) )
	{
		level notify( "introscreen_blackscreen_waiting_on_flag" );
		flag_wait( level.introscreen_waitontext_flag );
	}
	
	wait (totaltime - totalpausetime);


	if (IsDefined(delay_after_text))
	{
		wait delay_after_text;
	}
	else
	{
		wait 2.5;
	}

	// fadeout introscreen shader
	if( IsDefined( level.introscreen_shader_fadeout_time ) )
		level.introblack FadeOverTime( level.introscreen_shader_fadeout_time ); 
	else
		level.introblack FadeOverTime( 1.5 ); 
		
	level.introblack.alpha = 0; 

	flag_set( "starting final intro screen fadeout" );
	
	// Restore player controls part way through the fade in
	level thread freezecontrols_all( false, 0.75 ); // 0.75 delay, since the autosave does a 0.5 delay

	level._introscreen = false;

	level notify( "controls_active" ); // Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
	
	/#
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - COMPLETE\n");
	#/
}

// handles the displaying and fading of introscreen strings
//
//String1 = Title of the level
//String2 = Place, Country or just Country
//String3 = Month Day, Year
//String4 = Optional additional detailed information
//Pausetime1 = length of pause in seconds after title of level
//Pausetime2 = length of pause in seconds after Month Day, Year
//Pausetime3 = length of pause in seconds before the level fades in 

introscreen_delay( string1, string2, string3, string4, string5, pausetime1, pausetime2, timebeforefade, skipwait )
{
	/#
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay()\n");
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - START WAIT waittillframeend x2\n");
	
	// MikeD: use waittillframend so starts get setup properly before the introscreen refers to any
	// level.start
	waittillframeend; 
	waittillframeend; 

	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - STOP WAIT waittillframeend x2\n");
	
	// SCRIPTER_MOD
	// MikeD( 3/16/200 ):  level.start_point is for their start, ( aka skipto ) stuff... But it did not check to see if it's already defined.
	//[ceng 5/18/2010] Fixed typo from IsDefined( level.start ) to IsDefined( level.start_point ).
	skipIntro = false; 
	if( IsDefined( level.start_point ) )
	{
		skipIntro = level.start_point != "default"; 
	}

	if( GetDvar( #"introscreen" ) == "0" )
	{
		skipIntro = true; 
	}
		
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - BEFORE VARIOUS WAITS\n");
	
	if( skipIntro )
	{
		// wait until the first player spawns into the game before sending
		// out the introscreen notifies
		//level waittill("first_player_ready",player);
		flag_wait( "all_players_connected" );
		
		if( IsDefined( level.custom_introscreen ) )
		{
			[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
			return;
		}
	
		waittillframeend; 
		level notify( "finished final intro screen fadein" ); 
		waittillframeend; 
		flag_set( "starting final intro screen fadeout" ); 
		waittillframeend; 
		level notify( "controls_active" ); // Notify when player controls have been restored
		waittillframeend; 
		flag_set( "introscreen_complete" ); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" ); 
		return; 
	}
	#/

	if( IsDefined( level.custom_introscreen ) )
	{
		[[level.custom_introscreen]]( string1, string2, string3, string4, string5 );
		return;
	}

	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true;
	
	// Alex Liu 6-26-10: Added a way for a level to specify a introscreen shader, such as "white"
	// level is responsible to precache its own shader
	if( !isdefined( level.introscreen_shader ) )
	{
		level.introblack SetShader( "black", 640, 480 );
	}
	else
	{
		level.introblack SetShader( level.introscreen_shader, 640, 480 );
	}
	
	if(!IsDefined(skipwait))
	{
		flag_wait( "all_players_connected" );
	}

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	if( !IsDefined( level.introscreen_dontfreezcontrols ) )
		freezecontrols_all( true ); 
	
	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	if(IsDefined(skipwait))
	{
		flag_wait( "all_players_connected" );
	}
	
	wait( 0.5 ); // Used to be 0.05, but we have to wait longer since the save takes precisely a half-second to finish.
	
	level.introstring = []; 
	
	//Title of level
	
	if( IsDefined( string1 ) )
	{
		introscreen_create_line( string1 ); 
	}
	
	if( IsDefined( pausetime1 ) )
	{
		wait( pausetime1 ); 
	}
	else
	{
		wait( 2 ); 	
	}
	
	//City, Country, Date
	
	if( IsDefined( string2 ) )
	{
		introscreen_create_line( string2 ); 
	}

	if( IsDefined( string3 ) )
	{
		introscreen_create_line( string3 ); 
	}
	
	//Optional Detailed Statement
	
	if( IsDefined( string4 ) )
	{
		if( IsDefined( pausetime2 ) )
		{
			wait( pausetime2 ); 
		}
		else
		{
			wait( 2 ); 
		}

		introscreen_create_line( string4 ); 
	}

	if( IsDefined( string5 ) )
	{
		if( IsDefined( pausetime2 ) )
		{
			wait( pausetime2 ); 
		}
		else
		{
			wait( 2 ); 
		}

		introscreen_create_line( string5 ); 
	}

	level notify( "finished final intro screen fadein" );
	
	// SRS 7/14/2008: scripter can make introscreen wait on text before fading up
	if( IsDefined( level.introscreen_waitontext_flag ) )
	{
		level notify( "introscreen_blackscreen_waiting_on_flag" );
		flag_wait( level.introscreen_waitontext_flag );
	}
	
	if( IsDefined( timebeforefade ) )
	{
		wait( timebeforefade ); 
	}
	else
	{
		wait( 3 ); 
	}

	// Fade out black
	level.introblack FadeOverTime( 1.5 ); 
	level.introblack.alpha = 0; 

	flag_set( "starting final intro screen fadeout" );
	
	// Restore player controls part way through the fade in
	level thread freezecontrols_all( false, 0.75 ); // 0.75 delay, since the autosave does a 0.5 delay

	level._introscreen = false;

	level notify( "controls_active" ); // Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
	
	/#
	debug_replay("File: _introscreen.gsc. Function: introscreen_delay() - COMPLETE\n");
	#/
}

introscreen_player_connect()
{
	// MikeD (11/14/2007): If player connects during the introscreen, then freeze their controls.
	if( IsDefined(level._introscreen) && level._introscreen )
	{
		self FreezeControls( true );
	}
}

introscreen_report_disconnected_clients()
{
	flag_wait("introscreen_complete");
	
	if(isdefined(level._disconnected_clients))
	{
		for(i = 0; i < level._disconnected_clients.size; i ++)
		{
			ReportClientDisconnected(level._disconnected_clients[i]);
		}
	}
}

//If for some reason (Rebirth), this will be called more than once in a level
introscreen_clear_redacted_flags()
{
	flag_clear("introscreen_complete");
	flag_clear( "starting final intro screen fadeout" );
}
