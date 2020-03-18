#include clientscripts\_utility; 
#include clientscripts\_music;
#include clientscripts\_audio;

// *************************************************
// INIT HELI SOUNDS
//
// List of availible sound specific bones
// "SND_Cockpit"
// "SND_INT_F_L"
// "SND_INT_F_R"
// "SND_INT_R_L"
// "SND_INT_R_R"
// "SND_INT_Rotor"
// "SND_Rotor"
// "SND_Tail_Rotor"
// "SND_UNDER_Body"
// "SND_WIND_Left"
// "SND_WIND_Right"
//
// *************************************************

init()
{
	level._entityShutDownCBFunc = clientscripts\_helicopter_sounds::heli_linkto_sound_ents_delete;
	level.heliSoundValues = [];
	
	init_heli_sound_values( "huey", "cockpit",				65, 0.6, 0.8, 65, 1, 1.1 );
	init_heli_sound_values( "huey", "cockpit2",				45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "int_eng",				45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "int_eng2",				45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "int_eng3", 			45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "ext_rotor",			45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "tail_rotor",			45, 0.5, 1, 45, 0.95, 1.1);
	init_heli_sound_values( "huey", "tail_rotor",			45, 0.5, 1, 45, 0.95, 1.1);
	
	init_heli_sound_values( "hind", "cockpit", 				95, 0.6, 0.8, 95, 1, 1.1 );
	init_heli_sound_values( "hind", "cockpit2",				95, 0.5, 0.8, 95, 1, 1.2 );
	init_heli_sound_values( "hind", "int_eng", 				65, 0.5, 0.8, 65, 1, 1.1 );
	init_heli_sound_values( "hind", "int_eng2",				65, 0.4, 0.9, 65, 1, 1.1 );
	init_heli_sound_values( "hind", "eng_dmg", 				40, 0.3, 0.5, 65, 1, 1.1 );
	init_heli_sound_values( "hind", "ext_rotor",			70, 0.5, 1, 70, 0.95, 1.1 );
	
	init_heli_sound_values( "hip", "turbine",				15, 0.85, 1, 20, 1, 1.0 );
	init_heli_sound_values( "hip", "top_rotor",				15, 0.85, 1, 20, 0.95, 1);
	init_heli_sound_values( "hip", "tail_rotor",			15, 0.85, 1, 20, 0.95, 1.1);
	
	init_heli_sound_values( "hind_enemy", "turbine",		45, 0.6, 0.8, 65, 1, 1.0 );
	init_heli_sound_values( "hind_enemy", "top_rotor",		15, 0.5, 1, 25, 0.95, 1.0);
	init_heli_sound_values( "hind_enemy", "tail_rotor",		45, 0.5, 1, 45, 0.95, 1.0);
	
	init_heli_sound_values( "huey_toda", "turbine", 		25, 0.75, 0.8, 65, 1,  1);		
	init_heli_sound_values( "huey_toda", "top_rotor",		15, 0.85, 1, 25, 0.95, 1); 
	init_heli_sound_values( "huey_toda", "tail_rotor", 		25, 0.95, 1, 35, 0.95, 1); 
	
	init_heli_sound_values( "heli_chinook", "turbine",		15, 0.80, 1, 35, 0.95, 1.05);
	init_heli_sound_values( "heli_chinook", "top_rotor",	15, 0.80, 1, 35, 0.95, 1.05);	

	init_heli_sound_values( "huey_player", "turbine", 		65, 0.6, 0.8, 65, 1, 1.1 );		
	init_heli_sound_values( "huey_player", "top_rotor",		45, 0.5, 1, 45, 0.95, 1.1); 	
	init_heli_sound_values( "huey_player", "tail_rotor", 	45, 0.5, 1, 45, 0.95, 1.0); 	
	init_heli_sound_values( "huey_player", "wind_rt", 		45, 0.5, 1, 45, 0.95, 1.0); 	
	init_heli_sound_values( "huey_player", "wind_lft", 		45, 0.5, 1, 45, 0.95, 1.0); 	 		 
/#
	if ( getdvar( #"helisounds" ) == "" )
	{
		setdvar( "helisounds", "" );
	}

	level thread command_parser();
#/
}

init_heli_sound_values( heli_type, part_type, max_speed_vol, min_vol, max_vol, max_speed_pitch, min_pitch, max_pitch )
{
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		level.heliSoundValues[heli_type] = [];
	}
	if( !IsDefined( level.heliSoundValues[heli_type][part_type] ) )
	{
		level.heliSoundValues[heli_type][part_type] = spawnStruct();
	}
	
	level.heliSoundValues[heli_type][part_type].speedVolumeMax = max_speed_vol;
	level.heliSoundValues[heli_type][part_type].speedPitchMax = max_speed_pitch;
	level.heliSoundValues[heli_type][part_type].volumeMin = min_vol;
	level.heliSoundValues[heli_type][part_type].volumeMax = max_vol;
	level.heliSoundValues[heli_type][part_type].pitchMin = min_pitch;
	level.heliSoundValues[heli_type][part_type].pitchMax = max_pitch;
	
	if( getdvarint( #"debug_heli" ) > 0 )
	{
		println("Init Heli Sounds heli_type: " + heli_type );
		println("Init Heli Sounds part_type: " + part_type );	
		println("Init Heli Sounds max_speed_vol: " + max_speed_vol );	
		println("Init Heli Sounds min_vol: " + min_vol );	
		println("Init Heli Sounds max_vol: " + max_vol );
		println("Init Heli Sounds max_speed_pitch: " + max_speed_pitch );
		println("Init Heli Sounds min_pitch: " + min_pitch );	
		println("Init Heli Sounds max_pitch: " + max_pitch );	
	}							
}

/#
command_parser()
{
	while(1)
	{
		command = getdvar( #"helisounds" );
		if ( command != "" )
		{
			success = true;
			tokens = strtok( command, " " );
			if ( !isdefined( tokens[0] ) || !IsDefined(level.heliSoundValues[tokens[0]]) )
			{
				if ( isdefined( tokens[0] ) )
					println("helisounds Did not recognize helicopter type:  " + tokens[0] );
				else
					println("helisounds Did not recognize helicopter type" );
					
					
				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				
				success = false;
			}	
//			else if ( !isdefined( tokens[1] )|| !IsDefined(level.heliSoundValues[heli_type][tokens[1]]))
			else if ( !isdefined( tokens[1] ) )
			{
				if ( isdefined( tokens[1] ) )
					println("helisounds Did not recognize helicopter part:  " + tokens[0] + " for heli: " + tokens[1] );
				else
				println("helisounds Did not recognize helicopter part for heli: " + tokens[0] );
				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				success = false;
			}	
			else if ( !isdefined( tokens[2] ) )
			{
				println("helisounds Did not recognize helicopter value name for heli:" + tokens[0] + " part: " + tokens[1] );

				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				success = false;
			}	
			else if ( !isdefined( tokens[3] ) )
			{
				println("helisounds Did not recognize helicopter value for heli:" + tokens[0] + " part: " + tokens[1] );

				println("helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				success = false;
			}	
		
			if ( success )
			{
				heli_type = tokens[0];
				heli_part = tokens[1];
				value_name = tokens[2];
				value = float(tokens[3]);
				//value = value / 10
				switch( value_name )
				{
					case "volumemin":
						level.heliSoundValues[heli_type][heli_part].volumeMin = value;
						println("Setting volumeMin to " + value );
						break;
					case "volumemax":
						level.heliSoundValues[heli_type][heli_part].volumeMax = value;
						println("Setting volumeMax to " + value );
						break;
					case "pitchmin":
						level.heliSoundValues[heli_type][heli_part].pitchMin = value;
						println("Setting pitchMin to " + value );				
						break;
					case "pitchmax":
						level.heliSoundValues[heli_type][heli_part].pitchMax = value;
						println("Setting pitchMax to " + value );
						break;
					case "speedvolumemax":
						level.heliSoundValues[heli_type][heli_part].speedVolumeMax = value;
						println("Setting speedVolumeMax to " + value );
						break;
					case "speedpitchmax":
						level.heliSoundValues[heli_type][heli_part].speedPitchMax = value;
						println("Setting speedPitchMax to " + value );
						break;
					default:
						//iprintln("helisounds Did not recognize helicopter value name for heli:" + heli_name + " part: " + part_name + " value name:" + value_name);
						println("no case match - helisounds usage: helisounds <heli name> <part name> <value name> <value>" );
				}
			}
			setdvar( "helisounds", "" );
		}
		wait(0.1);		
	}	
}
#/


//tag, type, bone, run
init_heli_sounds_huey_toda() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hind_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hind_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_hind_tail" ); 			// Tail Rotor
	self setup_heli_sounds( "lfe",			"engine",		"snd_rotor",		"veh_hind_rotor_lfe" ); 	// Distant LFE	
}

init_heli_sounds_huey() //self == helicopter
{
	self setup_heli_sounds( "cockpit",		"engine",		"snd_cockpit",		"veh_huey_whine_int_idle" );
	self setup_heli_sounds( "cockpit2",		"engine",		"snd_rotor",		"veh_huey_hf_int_idle" );
	self setup_heli_sounds( "int_eng",		"engine",		"snd_rotor",		"veh_huey_lf_int_idle" );
	self setup_heli_sounds( "int_eng2",		"engine",		"snd_tail_rotor",	"veh_huey_dist_idle" );
	self setup_heli_sounds( "int_eng3",		"engine",		"snd_wind_right",	"veh_huey_ringing_dist" );
	self setup_heli_sounds( "ext_rotor",	"engine",		"snd_wind_left",	"veh_huey_rotor_idle" );
}

init_heli_sounds_hind() //self == helicopter
{
	self setup_heli_sounds( "cockpit",		"engine",		"snd_cockpit",		"veh_hind_whine_int_idle" );
	self setup_heli_sounds( "cockpit2",		"engine",		"snd_cockpit",		"veh_hind_hf_int_idle" );
	self setup_heli_sounds( "int_eng",		"engine",		"snd_int_rotor",	"veh_hind_lf_int_idle" );
	self setup_heli_sounds( "int_eng2",		"engine",		"snd_int_rotor",	"veh_hind_dist_idle1" );
	self setup_heli_sounds( "ext_rotor",	"engine",		"snd_rotor",		"veh_hind_rotor_idle" );
	self setup_heli_sounds( "eng_dmg",		"engine",		"snd_int_rotor",	"veh_hind_sputter" );
	self setup_heli_sounds( "eng_dmg_alarm","engine",		"snd_cockpit",		"veh_hind_alarm_damage_high_loop" );	
}

init_heli_sounds_hip() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hip_turbine" );		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hip_rotor" );			// Top Rotor
	//self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_hip_tail" );			// Tail Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_rotor",		"veh_hip_tail" );			// Tail Rotor
	self setup_heli_sounds( "lfe",			"engine",		"snd_rotor",		"veh_hip_rotor_lfe" ); 	// Distant LFE	
}

init_heli_sounds_chinook() //self == helicopter
{
	self setup_heli_sounds( "turbine",		"engine",		"tag_origin",		"veh_chinook_turbine" );	// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"main_rotor_jnt",	"veh_chinook_rotor" );		// Top Rotor
	self setup_heli_sounds( "top_rotor",	"engine",		"tail_rotor_jnt",	"veh_chinook_rotor" );		// Top Rotor
	self setup_heli_sounds( "lfe",			"engine",		"tag_origin",		"veh_chinook_rotor_lfe" ); 	// Distant LFE
}

init_heli_sounds_hind_enemy() //self == helicopter
{
	self setup_heli_sounds( "lfe",			"engine",		"snd_cockpit",		"veh_hind_epow_rotor_lfe" ); 	// Distant LFE
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hind_epow_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hind_epow_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_hind_epow_tail" ); 			// Tail Rotor
}

init_heli_sounds_hind_vorkuta() //tag, type, bone, run
{
	self setup_heli_sounds( "lfe",			"engine",		"snd_cockpit",		"veh_hind_rotor_lfe" ); 	// Distant LFE
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hind_turbine" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hind_rotor" ); 		// Top Rotor
	self setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_hind_tail" ); 			// Tail Rotor
}
init_heli_sounds_huey_player() //tag, type, bone, run
{
	setup_heli_sounds( "lfe",			"engine",		"snd_cockpit",		"veh_huey_rotor_lfe" ); 	//  Distant LFE
	setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_huey_turbine" ); 		//  Turbine
	setup_heli_sounds( "top_rotor",		"engine",		"snd_rotor",		"veh_huey_rotor" ); 		//  Top Rotor
	setup_heli_sounds( "tail_rotor",	"engine",		"snd_tail_rotor",	"veh_huey_tail" ); 			//  Tail Rotor	
	setup_heli_sounds( "wind_rt",		"engine",		"snd_wind_right",	"veh_huey_door_wind"); 		//	Wind right
	setup_heli_sounds( "wind_lft",		"engine",		"snd_wind_left",	"veh_huey_door_wind"); 		//	Wind left  
	setup_heli_sounds( "radio",			"engine",		"snd_cockpit",		"veh_huey_radio"); 			//	radio cockpit  	
}
init_heli_sounds_zombietron()
{
	self setup_heli_sounds( "turbine",		"engine",		"snd_rotor",		"veh_hind_turbine_zt" ); 		// Turbine
	self setup_heli_sounds( "top_rotor",	"engine",		"snd_rotor",		"veh_hind_rotor_zt" ); 		// Top Rotor
}

setup_heli_sounds( bone_location, type, tag, run, dmg1, dmg2, dmg3 ) //self == helicopter
{
	self.heli[bone_location] = spawnStruct();
	self.heli[bone_location].sound_type = type;

	self.heli[bone_location].run = spawn( 0, self.origin, "script_origin" );
	self.heli[bone_location].run linkto( self, tag );
	self.heli[bone_location].run.alias = run;

	self.sound_ents[self.sound_ents.size] = self.heli[bone_location].run;
	self thread delete_loop_sound_save_restore( self.heli[bone_location].run );

	if( IsDefined( dmg1 ) )
	{
		self.heli[bone_location].dmg1 = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].dmg1 linkto( self, tag );
		self.heli[bone_location].dmg1.alias = dmg1;

		self.sound_ents[self.sound_ents.size] = self.heli[bone_location].dmg1;
		self thread delete_loop_sound_save_restore( self.heli[bone_location].dmg1 );
	}
	if( IsDefined( dmg2 ) )
	{
		self.heli[bone_location].idle = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].idle linkto( self, tag );
		self.heli[bone_location].idle.alias = dmg2;

		self.sound_ents[self.sound_ents.size] = self.heli[bone_location].dmg2;
		self thread delete_loop_sound_save_restore( self.heli[bone_location].dmg2 );
	}
	if( IsDefined( dmg3 ) )
	{
		self.heli[bone_location].idle = spawn( 0, self.origin, "script_origin" );
		self.heli[bone_location].idle linkto( self, tag );
		self.heli[bone_location].idle.alias = dmg3;

		self.sound_ents[self.sound_ents.size] = self.heli[bone_location].dmg3;
		self thread delete_loop_sound_save_restore( self.heli[bone_location].dmg3 );
	}
}

init_terrain_sounds() //self == helicopter
{
	self.surface_type = [];
	// dirt
	self.surface_type["default"]	= "dirt";
	self.surface_type["metal"]		= "dirt";
	self.surface_type["concrete"]	= "dirt";
	self.surface_type["wood"] 		= "dirt";
	self.surface_type["dirt"] 		= "dirt";
	self.surface_type["gravel"]		= "dirt";
	self.surface_type["grass"]		= "dirt";
	self.surface_type["mud"]		= "dirt";
	self.surface_type["snow"]		= "dirt";
	self.surface_type["asphalt"]	= "dirt";
	self.surface_type["brick"]		= "dirt";
	self.surface_type["glass"]		= "dirt";
	self.surface_type["plaster"]	= "dirt";
	self.surface_type["sand"]		= "dirt";
	self.surface_type["rock"]		= "dirt";
	// water
	self.surface_type["water"]		= "water";
	// foliage
	self.surface_type["foliage"]	= "dirt";
	//self.surface_type["foliage"]	= "foliage";

	// create ents
	self setup_terrain_sounds( "dirt",		"veh_chopper_prop_wash_dirt"	);
	self setup_terrain_sounds( "water",		"veh_chopper_prop_wash_water"	);
	//self setup_terrain_sounds( "foliage",	"veh_chopper_prop_wash_foliage"	);
	
}

setup_terrain_sounds( surface_type, alias ) //self == helicopter
{
	self.terrain_ent_array[surface_type] = spawn( 0, self.origin, "script_origin" );
	self.terrain_ent_array[surface_type].alias = alias;

	self thread terrain_loop_sound_delete( self.terrain_ent_array[surface_type] );
}

start_helicopter_sounds( localClientNum ) //self == helicopter
{
	//printLn( "^5 ********* in start_helicopter_sounds ***********" );

	if( IsDefined( self.vehicletype ) )
	{
		self.heli = [];
		self.terrain = [];
		self.sound_ents = [];
		self.cur_speed = 0;
		self.idle_run_trans_speed = 5; // in MPH

		play_terrain_sounds = true;
		switch( self.vehicletype )
		{
			case "zombie_cobra":
				self init_heli_sounds_huey();
				self play_huey_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;

			case "heli_huey_small":
			// this the first wave heli in POW
			case "heli_huey_gunship":
				self init_heli_sounds_huey();
				self play_huey_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;				

			// POW flyable 
			case "heli_hind_player":			
				self init_heli_sounds_hind();
				self play_hind_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;

			//The final POW heli
			case "heli_hind":	
			//BIG enemy choppers in POW
			case "heli_hind_doublesize":
			case "heli_hind_doublesize_uwb":	
			//River Hinds
			case "heli_hind_river":		
				self init_heli_sounds_hind_enemy();
				self play_hind_enemy_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;

			
			// this the first wave heli in POW
			case "heli_hip":
			case "rebirth_heli_hip_sidegun_spotlight":
			case "heli_hip_sidegun_spotlight":
			case "heli_hip_noseturret":
			case "heli_cobra":
			case "heli_cobra_khesanh":
			case "heli_hip_sidegun_uwb":
				self init_heli_sounds_hip();
				self play_hip_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;				

			// this the heli Hue City
			case "heli_huey_assault":
			// Khe Sanh Huey's
			case "heli_huey":
			case "heli_huey_usmc_heavyhog":
			case "heli_huey_usmc":
			case "heli_huey_usmc_khesanh":
			case "heli_huey_side_minigun":
			case "heli_huey_player":
			case "heli_huey_player_uwb":
			case "heli_huey_heavyhog_river":				
			case "heli_huey_assault_river":		
			case "heli_huey_gunship_river":		
			case "heli_huey_usmc_khesanh_std":	
			case "heli_huey_medivac_khesanh":
			case "heli_huey_usmc_heavyhog_khesanh":
			case "heli_huey_medivac_river":
			case "heli_huey_side_minigun_uwb":
			case "heli_huey_vista":

			
				self init_heli_sounds_huey_toda();
				self play_huey_toda_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;
			
			case "heli_chinook":
			case "heli_seaknight":
				self init_heli_sounds_chinook();
				self play_chinook_sounds();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;
			
			//Creek Huey's
			case "heli_huey_heavyhog_creek":
			case "heli_huey_heavyhog":			
			//Vorkuta Hip
			case "heli_hip_sidegun":
			//Rebith Heli
			case "heli_hip_spotlight":
				self init_heli_sounds_hind_vorkuta();
				self play_hind_sounds_vorkuta();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;
				
			/* REMOVED FOR NOW REPLACED WITH HUEY TODA 
			// Underwater Base Huey's
			case "heli_huey_player_TEST":
				self init_heli_sounds_huey_player(); 
				self play_heli_sounds_huey_player();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;
			*/
				
			//ZOMBIETRON MINI HELICOPTER	
			case "heli_mini_zt":
				self init_heli_sounds_zombietron();
				self play_hind_sounds_zombietron();
				printLn( "helicopter type: " + self.vehicletype + " found; playing helicopter sounds" );
				break;	
				
			default:
				play_terrain_sounds = false;
				printLn( "^5helicopter type: " + self.vehicletype + " NOT FOUND; playing NO helicopter sounds" );
				break;
		
		
		
		
		}

		if( play_terrain_sounds )
		{
			self init_terrain_sounds();
			self thread terrain_trace();
		}
	}
	else
	{
		printLn( "^6helicopter type: " + self.vehicletype + " not defined" );
	}
}


delete_loop_sound_save_restore( real_ent ) //self == helicopter
{
	self endon( "heli_entityshutdown" );
	level waittill( "save_restore" );
	PrintLn( "heli_script: got save restoring" );
	
	if( IsDefined( real_ent ) )
	{
		PrintLn( "heli_script: killing helicopter sound ent" );
		real_ent StopLoopSound( 0 );
		real_ent Delete();
	}
}

terrain_loop_sound_delete( real_ent ) //self == helicopter
{
	self thread delete_loop_sound_save_restore( real_ent );	

	level endon( "save_restore" );
	self waittill( "entityshutdown" );
	self notify( "heli_entityshutdown" );

	PrintLn( "heli_script: deleting terrain ents" );
	if( IsDefined( real_ent) )
	{
		real_ent StopLoopSound( 4 );
		real_ent Delete();
	}
}


heli_linkto_sound_ents_delete( localClientNum, entity )
{
	entity notify( "heli_entityshutdown" );
	array_thread( entity.sound_ents, ::heli_delete_sound_loops );
}

heli_delete_sound_loops() //self == linkto sound ents that are to be deleted
{
	PrintLn( "heli_script: deleting linkto ents" );

	if( IsDefined( self ) )
	{
		self StopLoopSound( 4 );
		self Delete();
	}
}


// *************************************************	
// PLAY HELICOPTER SOUNDS SECTION
// This section plays the Helicopter sounds 
// heli_sound_play () - Starts a thread to play a loop unaffected by the entity speed
// heli_idle_run_transition () - Starts a thread that will pitch and volume the loop based on the arguments
// heli_bone - The tag to play the loop on, this is set to a bone in the init
// max_speed_vol - the speed at which volume will stop attenuation
// min_vol - This is the volume of the loop when not moving
// max_vol - This is the volume of the loop when at max_speed_vol
// max_speed_pitch - The speed at which pitch will no longer change
// min_pitch - This is the pitch of the loop when not moving
// max_pitch - This is the amount of pitch when at max_speed_vol
// *************************************************	
play_hind_sounds() // self == helicopter
{
	// ******* heli Hind sounds **************
	//self thread heli_sound_play( self.heli["eng_dmg_alarm"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hind", "cockpit" );		 
	self thread heli_idle_run_transition( "hind", "cockpit2");  
	self thread heli_idle_run_transition( "hind", "int_eng");
	self thread heli_idle_run_transition( "hind", "int_eng2" );		 
//	self thread heli_idle_run_transition( "hind", "eng_dmg_alarm");  
	self thread heli_idle_run_transition( "hind", "ext_rotor");			
}

play_hind_enemy_sounds() // self == helicopter
{
	// ******* heli Hind sounds, this is the AI controled heli **************
	self thread heli_sound_play( self.heli["lfe"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hind_enemy", "turbine" );		 
	self thread heli_idle_run_transition( "hind_enemy", "top_rotor");  
	self thread heli_idle_run_transition( "hind_enemy", "tail_rotor");	
}

play_huey_sounds() // self == helicopter
{
	// ******* heli Huey sounds **************	
	self thread heli_sound_play( self.heli["lfe"] ); // non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey", "cockpit" );		 
	self thread heli_idle_run_transition( "huey", "cockpit2");  
	self thread heli_idle_run_transition( "huey", "int_eng");	
	self thread heli_idle_run_transition( "huey", "int_eng2" );		 
	self thread heli_idle_run_transition( "huey", "int_eng3");
	self thread heli_idle_run_transition( "huey", "ext_rotor" );		 
}

play_hip_sounds() // self == helicopter
{
	// ******* heli hip **************	
	self thread heli_sound_play( self.heli["lfe"] );		
	self thread heli_idle_run_transition( "hip", "turbine" );		 
	self thread heli_idle_run_transition( "hip", "top_rotor");  
	self thread heli_idle_run_transition( "hip", "tail_rotor");	
}

play_huey_toda_sounds() // self == helicopter
{
	// ******* heli huey toada sounds, this is the AI controled heli in Hue City **************
	self thread heli_sound_play( self.heli["lfe"] );							// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey_toda", "turbine" );		 
	self thread heli_idle_run_transition( "huey_toda", "top_rotor");  
	self thread heli_idle_run_transition( "huey_toda", "tail_rotor");
}

play_chinook_sounds()
{
	self thread heli_idle_run_transition( "heli_chinook", "top_rotor");  
	self thread heli_idle_run_transition( "heli_chinook", "turbine");
	self thread heli_sound_play( self.heli["lfe"] );	
}

play_hind_sounds_vorkuta() // self == helicopter
{
	//self thread heli_sound_play( self.heli["lfe"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hip", "turbine" );		 
	self thread heli_idle_run_transition( "hip", "top_rotor");  
	self thread heli_idle_run_transition( "hip", "tail_rotor");	
}

play_hind_sounds_zombietron()
{																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "hip", "turbine" );		 
	self thread heli_idle_run_transition( "hip", "top_rotor");  
}
play_heli_sounds_huey_player() // self == helicopter
{
	// ******* heli Huey sounds, this is used on the hueys in underwaterbase  **************	
	self heli_sound_play( self.heli["lfe"] ); 
	self heli_sound_play( self.heli["radio"] );																											// non-occulded, non-pitched 3d lfe
	self thread heli_idle_run_transition( "huey_player", "turbine" );		 
	self thread heli_idle_run_transition( "huey_player", "top_rotor");  
	self thread heli_idle_run_transition( "huey_player", "tail_rotor");	
	self thread heli_idle_run_transition( "huey_player", "wind_rt" );		 
	self thread heli_idle_run_transition( "huey_player", "wind_lft");  
}

// *************************************************
//	END OF PLAY HELICOPTER SOUNDS SECTION
// *************************************************

// *************************************************
//	HELICOPTER VOLUME/PITCH CHANGES
// *************************************************
heli_sound_play( heli_bone ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );

	while( 1 )
	{
		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			self waittill( "play_heli_sounds" );
		}

		heli_bone.run PlayLoopSound( heli_bone.run.alias, 2 );
		self waittill( "stop_heli_sounds" );
	}
}


heli_idle_run_transition( heli_type, heli_part ) //self == helicopter
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
//	self endon( "death" );	
	
	MPH_TO_INCHES_PER_SEC = 17.6;

	heli_bone = self.heli[heli_part];
	run_id = undefined;
	heli_damage = "none";
	
	if( !IsDefined( level.heliSoundValues[heli_type] ) )
	{
		printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "'." );
		return;
	}
	if( !IsDefined( level.heliSoundValues[heli_type][heli_part] ) )
	{
		printLn( "^5a speed vol/pitch parameter was not defined for heli_type '" + heli_type + "' and heli_part '" + heli_part + "'." );
		return;
	}

	while( IsDefined( self ) )
	{
		wait( 0.5 );

		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			heli_bone.run StopLoopSound( 0.5 );
			run_id = undefined;

			self waittill( "play_heli_sounds" );
			continue;
		}

		if( !IsDefined( run_id ) )
			run_id = heli_bone.run PlayLoopSound( heli_bone.run.alias, 0.5 );

		max_speed_vol =		level.heliSoundValues[heli_type][heli_part].speedVolumeMax;
		min_vol =			level.heliSoundValues[heli_type][heli_part].volumeMin;
		max_vol =			level.heliSoundValues[heli_type][heli_part].volumeMax;
		max_speed_pitch =	level.heliSoundValues[heli_type][heli_part].speedPitchMax;
		min_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMin;
		max_pitch =			level.heliSoundValues[heli_type][heli_part].pitchMax;
	
		self.cur_speed = self getspeed() / MPH_TO_INCHES_PER_SEC;
		
		//scale_speed( min_speed, max_speed, min_vol, max_vol, cur_speed );
		run_volume = scale_speed( self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed );
		run_pitch = scale_speed( self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed );

		if( IsDefined( run_volume ) && IsDefined( run_pitch ) )
		{
			setSoundVolume( run_id, run_volume );
			setSoundPitch( run_id, run_pitch );
			setSoundPitchRate( run_id, 0.25 );
			
			if( IsDefined ( self.isdamaged ) && ( heli_damage == "none"  ))
			{
				//heli_bone StopLoopSound( 1 );
				//dmg1_id = heli_bone PlayLoopSound( heli_bone.dmg1.alias, 0.5 );
				//heli_damage = "stage_1";
				return;
			}	
						
			if( getdvarint( #"debug_heli" ) > 0 )
			{
				printLn( "^5a self.cur_speed = " + self.cur_speed );
				printLn( "^5a run_pitch . " + run_pitch );			
				printLn( "^5a self.cur_speed = " + self.cur_speed );
				printLn( "^5a run_volume. " + run_volume );

			}
		}
	}
}

// *************************************************	
// HELICOPTER TERRAIN SOUNDS (PROP WASH)
// *************************************************
terrain_trace() //self == helicopter
{
	self endon( "entityshutdown" ); 
	level endon( "save_restore" );

	trace = undefined; 
	trace_ent = self;

	pre_terrain = undefined;
	next_terrain = undefined;

	pre_trace_real_ent = undefined;
	trace_real_ent = undefined;
	pre_origin = ( 100000, 100000, 100000 );

	while( IsDefined( self ) )
	{
		wait( 1 + RandomFloatRange( 0.0, 0.2) );

		if( IsDefined( self.should_not_play_sounds ) && self.should_not_play_sounds )
		{
			if( IsDefined( pre_trace_real_ent ) )
				pre_trace_real_ent StopLoopSound();

			if( IsDefined( trace_real_ent ) )
				trace_real_ent StopLoopSound();

			self waittill( "play_heli_sounds" );
			continue;
		}
		
		// do checks only if we moved more than a feet
		if( DistanceSquared( pre_origin, trace_ent.origin ) < 144 )
		{
			continue;
		}
			
		pre_origin = trace_ent.origin;

		trace = tracepoint( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ) );
		//println( "btrace " + trace_ent.origin );
		trace_surface_type = trace["surfacetype"];


		if( !IsDefined( trace ) )
			continue; 

		pre_terrain = next_terrain;
		next_terrain = trace_surface_type;
		if( !IsDefined( pre_terrain ) || !IsDefined( next_terrain ) )
		{
			//printLn( "heli_script: this is in non defined trerrain" );
			continue;
		}

		if( !IsDefined( self.surface_type[next_terrain] ) || !IsDefined( self.surface_type[pre_terrain] ) )
		{
			/#
			//printLn( "^6 prop wash for terrain type: " + next_terrain + " or " + pre_terrain + " is not set up" );
			#/
			continue;
		}

		surf_type = self.surface_type[next_terrain];
		trace_real_ent = self.terrain_ent_array[surf_type];

		pre_surf_type = self.surface_type[pre_terrain];
		pre_trace_real_ent = self.terrain_ent_array[pre_surf_type];

		if( !IsDefined( trace["position"] ) )
		{
			if( IsDefined( pre_trace_real_ent ) )
			{
				pre_trace_real_ent StopLoopSound( 0.5 );
				//printLn( "^5heli_script: STOP playing terrain sound (position undefined): " + pre_surf_type );
			}
			continue; 
		}

		//update origin
		trace_real_ent.origin = trace["position"];
		pre_trace_real_ent.origin = trace["position"];
		if( IsDefined( surf_type ) )
		{
			if( ( surf_type == pre_surf_type ) && ( pre_trace_real_ent IsPlayingLoopSound() ) )
				continue;

			//printLn( "^5heli_script: STOP playing terrain sound: " + pre_surf_type + " surface '" + pre_terrain + "'" );
			pre_trace_real_ent StopLoopSound( 0.5 );

			//printLn( "^6heli_script: START playing terrain sound: " + surf_type + " surface '" + next_terrain + "'" );
			trace_real_ent PlayLoopSound( trace_real_ent.alias, 0.5 );
		}
	}	
}

// *************************************************
// Update Helicopter Sounds
// *************************************************
update_helicopter_sounds() //self == helicopter
{
	//-- Setup the sound arrays in here
	if( IsDefined( self.engine_damage_low ) && self.engine_damage_low )
	{
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				if( !IsDefined( self.low_dmg ) )
				{
					self thread heli_idle_run_transition( "hind", "eng_dmg" ); 
				}
				self.low_dmg = true;
				playsound( 0, "veh_hind_alarm_damage_high", (0,0,0) );
				level.heliSoundValues["hind"]["cockpit"].volumeMax = 1;
				level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.3;
				printLn( "^5a activating heli sound damage stage 1");
				break;
			
			default:
				printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );
				break;
		}
	}

	if( IsDefined( self.engine_damage_high ) && self.engine_damage_high && IsDefined( self.engine_damage_low ) && !self.engine_damage_low )
	{
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				//level.heliSoundValues["hind"]["eng_dmg"].volumeMax = .5;
				//level.heliSoundValues["hind"]["eng_dmg"].volumeMin = .3;
				//level.heliSoundValues["hind"]["cockpit"].volumeMax = 1;
				//level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.3;
				//playsound( 0, "veh_hind_alarm_damage_high", (0,0,0) );

				// set up damage states
				level.heliSoundValues["hind"]["eng_dmg"].volumeMax = 1;
				level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.5;
				wait( 0.1 );
				level.heliSoundValues["hind"]["eng_dmg"].volumeMin = 1;
				// Play an alarm loop
				//self heli_sound_play( self.heli["eng_dmg_alarm"] );
				printLn( "^5a activating heli sound damage stage 2");
				break;
			
			default:
				printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );
				break;
		}
	}

	if( IsDefined( self.engine_damage_high ) && self.engine_damage_high && IsDefined( self.engine_damage_low ) && self.engine_damage_low )
	{
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				playsound( 0, "veh_hind_alarm_damage_high", (0,0,0) );
				level.heliSoundValues["hind"]["eng_dmg"].volumeMax = 1;
				level.heliSoundValues["hind"]["ext_rotor"].pitchMax = 1.5;
				wait( 0.1 );
				level.heliSoundValues["hind"]["eng_dmg"].volumeMin = 1;
				printLn( "^5a activating heli sound damage stage 3");
				break;
			
			default:
				printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );
				break;
		}
	}
	
	if( IsDefined( self.engine_damage_low ) && !self.engine_damage_low && IsDefined( self.engine_damage_high ) && !self.engine_damage_high )
	{
		printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; Atempting to reset Defaults" );
		
		switch( self.vehicletype )
		{
			case "heli_hind_player":
				init_heli_sound_values( "hind", "cockpit", 			95, 0.6, 0.8, 95, 1, 1.1 );
				init_heli_sound_values( "hind", "cockpit2",			95, 0.5, 0.8, 95, 1, 1.2);
				init_heli_sound_values( "hind", "int_eng", 			65, 0.5, 0.8, 65, 1, 1.1 );
				init_heli_sound_values( "hind", "int_eng2",			65, 0.4, 0.9, 65, 1, 1.3 );
				init_heli_sound_values( "hind", "eng_dmg", 			40, 0.2, 0.4, 65, 1, 1.1 );
				init_heli_sound_values( "hind", "ext_rotor",		70, 0.5, 1, 70, 0.95, 1.1);
				//self.heli["eng_dmg"] stoploopsound( 1 );
				printLn( "^5a Setting Defaults ");
				break;
				
			default:
				printLn( "^5helicopter type: " + self.vehicletype + " vehicletype; has no helicopter damage sounds" );
				break;
		}
	}
}

