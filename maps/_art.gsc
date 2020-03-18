// This function should take care of grain and glow settings for each map, plus anything else that artists 
// need to be able to tweak without bothering level designers.
#include maps\_utility;
#include common_scripts\utility;

main()
{
/#
	if( getDvar( #"scr_art_tweak" ) == "" || getDvar( #"scr_art_tweak" ) == "0" )
	{
		SetDvar( "scr_art_tweak", 0 );
	}

	if( getDvar( #"scr_dof_enable" ) == "" )
	{
		SetDvar( "scr_dof_enable", "1" );
	}
		
	if( getDvar( #"scr_cinematic_autofocus" ) == "" )
	{
		SetDvar( "scr_cinematic_autofocus", "1" );
	}

	if( getDvar( #"scr_art_visionfile" ) == "" )
	{
		SetDvar( "scr_art_visionfile", level.script );
	}
#/

	if( !IsDefined( level.dofDefault ) )
	{
		level.dofDefault["nearStart"] = 0; 
		level.dofDefault["nearEnd"] = 1; 
		level.dofDefault["farStart"] = 8000; 
		level.dofDefault["farEnd"] = 10000; 
		level.dofDefault["nearBlur"] = 6; 
		level.dofDefault["farBlur"] = 0; 
	}

	level.curDoF = ( level.dofDefault["farStart"] - level.dofDefault["nearEnd"] ) / 2;
	
/#
	thread tweakart();
#/
	
	if( !IsDefined( level.script ) )
	{
		level.script = tolower( GetDvar ( "mapname" ) );
	}
	

}

artfxprintln(file,string)
{
	// printing to file is optional now
	if(file == -1)
	{
		return;
	}
	fprintln(file,string);
}


// Nate - hack Fixmed and replace with proper script command call once it's fixed.
// assumes " " as the deliiter. I'm not getting fancy.  
// I would really like to go work on jeepride so here's a 
// quick function that works for now untill engineering fixes strtok.

strtok_loc( string, par1 )
{
	stringlist = [];
	indexstring = "";
	for( i = 0 ; i < string.size ; i ++ )
	{
		if(string[ i ] == " ")
		{
			stringlist[stringlist.size] = indexstring;
			indexstring = ""; 
		}
		else
		{
			indexstring = indexstring+string[i];
		}
	}
	if(indexstring.size)
	{
		stringlist[stringlist.size] = indexstring;
	}
	return stringlist;
}


setfogsliders()
{
	//fixme.  replace strtok_loc with strtok if it ever works properly.
	fogall = strtok_loc( getDvar( #"g_fogColorReadOnly" ), " " ) ;
	red = fogall[ 0 ];
	green = fogall[ 1 ];
	blue = fogall[ 2 ];
	halfplane = getDvar( #"g_fogHalfDistReadOnly" );
	nearplane = getDvar( #"g_fogStartDistReadOnly" );
		
	if ( !isdefined( red )
		 || !isdefined( green )
		 || !isdefined( blue )
		 || !isdefined( halfplane )
		 )
	{
		red = 1;
		green = 1;
		blue = 1;
		halfplane = 10000001;
		nearplane = 10000000;
	}
	setdvar("scr_fog_exp_halfplane",halfplane);
	setdvar("scr_fog_nearplane",nearplane);
	setdvar("scr_fog_color",red+" "+green+" "+blue);
}

tweakart()
{
	/#
	if(!isdefined(level.tweakfile))
	{
		level.tweakfile = false;
	}
	
	// blah scriptgen stuff ignore this.
	if(level.tweakfile && level.bScriptgened)
	{
		script_gen_dump_addline("maps\\createart\\"+level.script+"_art::main();",level.script+"_art");  // adds to scriptgendump
	}

	// Default values
	
	if(getDvar( #"scr_fog_baseheight") == "")
	{
		setdvar("scr_fog_exp_halfplane", "500");
		setdvar("scr_fog_exp_halfheight", "500");
		setdvar("scr_fog_nearplane", "0");
		setdvar("scr_fog_baseheight", "0");
	}

	// not in DEVGUI
	setdvar("scr_fog_fraction", "1.0");
	setdvar("scr_art_dump", "0");
	setdvar("scr_art_sun_fog_dir_set", "0");

	// update the devgui variables to current settings
	setdvar("scr_dof_nearStart",level.dofDefault["nearStart"]);
	setdvar("scr_dof_nearEnd",level.dofDefault["nearEnd"]);
	setdvar("scr_dof_farStart",level.dofDefault["farStart"]);
	setdvar("scr_dof_farEnd",level.dofDefault["farEnd"]);
	setdvar("scr_dof_nearBlur",level.dofDefault["nearBlur"]);
	setdvar("scr_dof_farBlur",level.dofDefault["farBlur"]);	


	file = undefined;
	filename = undefined;
	
	// set dofvars from < levelname > _art.gsc
	dofvarupdate();
	
	wait_for_first_player();
	players = get_players();

	tweak_toggle = 1;	
	for(;;)
	{
		while(getDvarInt( #"scr_art_tweak" ) == 0 )
		{
			tweak_toggle = 1;
			wait .05;
		}
		
		if(tweak_toggle)
		{
			tweak_toggle = 0;
			fogsettings = getfogsettings();

			SetDvar( "scr_fog_nearplane", fogsettings[0] ); 
			SetDvar( "scr_fog_exp_halfplane", fogsettings[1] ); 
			SetDvar( "scr_fog_exp_halfheight", fogsettings[3] ); 
			SetDvar( "scr_fog_baseheight", fogsettings[2] ); 

			SetDvar("scr_fog_color", fogsettings[4]+" "+fogsettings[5]+" "+fogsettings[6]);
			SetDvar("scr_fog_color_scale", fogsettings[7]);
			SetDvar("scr_sun_fog_color", fogsettings[8]+" "+fogsettings[9]+" "+fogsettings[10]);
			
			level.fogsundir = [];
			level.fogsundir[0] = fogsettings[11];
			level.fogsundir[1] = fogsettings[12];
			level.fogsundir[2] = fogsettings[13];

			SetDvar("scr_sun_fog_start_angle",fogsettings[14] );
			SetDvar("scr_sun_fog_end_angle",fogsettings[15] );

			setdvar("scr_fog_max_opacity", fogsettings[16]);
			

		}
		

		//translate the slider values to script variables

		level.fogexphalfplane = getDvarFloat( #"scr_fog_exp_halfplane");
		level.fogexphalfheight = getDvarFloat( #"scr_fog_exp_halfheight");
		level.fognearplane = getDvarFloat( #"scr_fog_nearplane");
		level.fogbaseheight = getDvarFloat( #"scr_fog_baseheight");

		level.fogcolorred = getdvarcolorred("scr_fog_color");
		level.fogcolorgreen = getdvarcolorgreen("scr_fog_color");
		level.fogcolorblue = getdvarcolorblue("scr_fog_color");
		level.fogcolorscale = getDvarFloat( #"scr_fog_color_scale");

		level.sunfogcolorred = getdvarcolorred("scr_sun_fog_color");
		level.sunfogcolorgreen = getdvarcolorgreen("scr_sun_fog_color");
		level.sunfogcolorblue = getdvarcolorblue("scr_sun_fog_color");
		
		level.sunstartangle = getDvarFloat( #"scr_sun_fog_start_angle");
		level.sunendangle = getDvarFloat( #"scr_sun_fog_end_angle");
		level.fogmaxopacity = getDvarFloat( #"scr_fog_max_opacity");

		if(	getDvarInt( #"scr_art_sun_fog_dir_set") ) 
		{
			setdvar( "scr_art_sun_fog_dir_set", "0" );
			
			println("Setting sun fog direction to facing of player");
			
			players = get_players();

			dir = VectorNormalize( AnglesToForward( players[0] GetPlayerAngles() ) );

			level.fogsundir = [];
			level.fogsundir[0] = dir[0];
			level.fogsundir[1] = dir[1];
			level.fogsundir[2] = dir[2];
		}
		
		dofvarupdate();
		
		// catch all those cases where a slider can be pushed to a place of conflict
		fovslidercheck();
		
		dumpsettings();// dumps and returns true if the dump dvar is set
		
		// updates fog to the variables

		if ( ! getDvarInt( #"scr_fog_disable" ) )
		{
			if(!IsDefined(level.fogsundir)) {
				level.fogsundir = [];
				level.fogsundir[0] = 1;
				level.fogsundir[1] = 0;
				level.fogsundir[2] = 0;
			}

			setVolFog( level.fognearplane, level.fogexphalfplane, level.fogexphalfheight, level.fogbaseheight, level.fogcolorred, level.fogcolorgreen, level.fogcolorblue, 
				level.fogcolorscale, level.sunfogcolorred, level.sunfogcolorgreen, level.sunfogcolorblue, level.fogsundir[0], level.fogsundir[1], level.fogsundir[2], level.sunstartangle, level.sunendangle, 0, level.fogmaxopacity ); 
		}
		else
		{
			setExpFog( 100000000, 100000001, 0, 0, 0, 0 );// couldn't find discreet fog disabling other than to never set it in the first place
		}

		players[0] setDefaultDepthOfField();
		
		
		wait .1;
	}
	
	#/ 
}         

fovslidercheck()
{
		//catch all those cases where a slider can be pushed to a place of conflict
		if(level.dofDefault["nearStart"] >= level.dofDefault["nearEnd"])
		{
			level.dofDefault["nearStart"] = level.dofDefault["nearEnd"]-1;
			setdvar("scr_dof_nearStart",level.dofDefault["nearStart"]);
		}
		if(level.dofDefault["nearEnd"] <= level.dofDefault["nearStart"])
		{
			level.dofDefault["nearEnd"] = level.dofDefault["nearStart"]+1;
			setdvar("scr_dof_nearEnd",level.dofDefault["nearEnd"]);
		}
		if(level.dofDefault["farStart"] >= level.dofDefault["farEnd"])
		{
			level.dofDefault["farStart"] = level.dofDefault["farEnd"]-1;
			setdvar("scr_dof_farStart",level.dofDefault["farStart"]);
		}
		if(level.dofDefault["farEnd"] <= level.dofDefault["farStart"])
		{
			level.dofDefault["farEnd"] = level.dofDefault["farStart"]+1;
			setdvar("scr_dof_farEnd",level.dofDefault["farEnd"]);
		}
		if(level.dofDefault["farBlur"] >= level.dofDefault["nearBlur"])
		{
			level.dofDefault["farBlur"] = level.dofDefault["nearBlur"]-.1;
			setdvar("scr_dof_farBlur",level.dofDefault["farBlur"]);
		}
		if(level.dofDefault["farStart"] <= level.dofDefault["nearEnd"])
		{
			level.dofDefault["farStart"] = level.dofDefault["nearEnd"]+1;
			setdvar("scr_dof_farStart",level.dofDefault["farStart"]);
		}
} 

dumpsettings()
{
	 /#
	if ( getDvar( #"scr_art_dump" ) != "0" )
	{
		PrintLn("\tstart_dist = " + level.fognearplane + ";");
		PrintLn("\thalf_dist = " + level.fogexphalfplane + ";");
		PrintLn("\thalf_height = " + level.fogexphalfheight + ";");
		PrintLn("\tbase_height = " + level.fogbaseheight + ";");
		PrintLn("\tfog_r = " + level.fogcolorred + ";");
		PrintLn("\tfog_g = " + level.fogcolorgreen + ";");
		PrintLn("\tfog_b = " + level.fogcolorblue + ";");
		PrintLn("\tfog_scale = " + level.fogcolorscale + ";");
		PrintLn("\tsun_col_r = " + level.sunfogcolorred + ";");
		PrintLn("\tsun_col_g = " + level.sunfogcolorgreen + ";");
		PrintLn("\tsun_col_b = " + level.sunfogcolorblue + ";");
		PrintLn("\tsun_dir_x = " + level.fogsundir[0] + ";");
		PrintLn("\tsun_dir_y = " + level.fogsundir[1] + ";");
		PrintLn("\tsun_dir_z = " + level.fogsundir[2] + ";");
		PrintLn("\tsun_start_ang = " + level.sunstartangle + ";");
		PrintLn("\tsun_stop_ang = " + level.sunendangle + ";");
		PrintLn("\ttime = 0;");
		PrintLn("\tmax_fog_opacity = " + level.fogmaxopacity +";");
		PrintLn("");
		PrintLn("\tsetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,");
		PrintLn("\t\tsun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, ");
		PrintLn("\t\tsun_stop_ang, time, max_fog_opacity);");
		
		setdvar( "scr_art_dump", "0" );
	}
	#/
}

dofvarupdate()
{
		level.dofDefault["nearStart"] = getDvarInt( #"scr_dof_nearStart");
		level.dofDefault["nearEnd"] = getDvarInt( #"scr_dof_nearEnd");
		level.dofDefault["farStart"] = getDvarInt( #"scr_dof_farStart");
		level.dofDefault["farEnd"] = getDvarInt( #"scr_dof_farEnd");
		level.dofDefault["nearBlur"] = getDvarFloat( #"scr_dof_nearBlur");
		level.dofDefault["farBlur"] = getDvarFloat( #"scr_dof_farBlur");	
}

setdefaultdepthoffield()
{
	if( IsDefined( level.do_not_use_dof ) )
	{
		return;
	}

		self setDepthOfField( 
								level.dofDefault["nearStart"], 
								level.dofDefault["nearEnd"],
								level.dofDefault["farStart"],
								level.dofDefault["farEnd"],
								level.dofDefault["nearBlur"],
								level.dofDefault["farBlur"]
								);
}
		
