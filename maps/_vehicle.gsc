 /* 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

VEHICLE script

This handles playing the various effects and animations on a vehicle.
It handles initializing a vehicle( giving it life, turrets, machine guns, treads and things )

It also handles spawning of vehicles in a very ugly way for now, we're getting code to make it pretty

Most things you see in the vehicle menu in Radiant are handled here.  There's all sorts of properties
that you can set on a trigger to access some of this functionality.  A trigger can spawn a vehicle, 
toggle different behaviors, 


HIGH LEVEL FUNCTIONS

 // vehicle_init( vehicle )
	this give the vehicle life, treads, turrets, machine guns, all that good stuff

 // main()
	this is setup, sets up spawners, trigger associations etc is ran on first frame by _load

 // trigger_process( trigger, vehicles )
	since triggers are multifunction I made them all happen in the same thread so that
	the sequencing would be easy to handle

 // vehicle_paths()
	This makes the nodes get notified trigger when they are hit by a vehicle, we hope
	to move this functionality to CODE side because we have to use a lot of wrappers for
	attaching a vehicle to a path

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 */ 
#include maps\_utility; 
#include common_scripts\utility; 
#using_animtree( "vehicles" );

init_vehicles()
{
	/#
	debug_replay("File: _vehicle.gsc. Function: init_vehicles()\n");
	#/
	
	precachemodel( "fx" );
	
	if(IsDefined(level.bypassVehicleScripts))
	{
		return;
	}
	
	level.heli_default_decel = 10; // will likely go back to 10 in the near future

	thread dump_handle();// press the hotkey and xenon will export a map with all the current vehicle positions

	// MikeD (06/14/07): Added aircraft
	init_aircraft_list();	

	// MikeD (4/3/2008): Added boats
	init_boat_list();

	// this removes the requirement of putting vehicletype on vehicles
	maps\_vehicletypes::setup_types();
	
	//  This exports script_vehicles for script_model based vehicles in the level
	generate_colmaps_vehicles();
	
	 // put all the vehicles with targetnames into an array so we can spawn vehicles from
	 // a string instead of their vehicle group #
	setup_targetname_spawners();

	 // vehicle related dvar initializing goes here
	setup_dvars();

	 // initialize all the level wide vehicle system variables
	setup_levelvars();

	array_thread( getentarray( "truckjunk", "targetname" ), ::truckjunk );

	 // drives vehicle through level
	 // helpful on levels where vehicles don't always make it through the whole path
	/# vclogin_vehicles(); #/

	 // pre - associate ai and spawners with their vehicles
	setup_ai();

	 // pre - associate vehicle triggers and vehicle nodes with stuff.
	setup_triggers();

	 // check precacheing of vehicle scripts.
	allvehiclesprespawn = precache_scripts();

	 // setup spawners and non - spawning vehicles
	setup_vehicles( allvehiclesprespawn );

	 // send the setup triggers to be processed
	array_levelthread( level.vehicle_processtriggers, ::trigger_process );

	// CHECKME
	level.vehicle_processtriggers = undefined;
	
	init_level_has_vehicles();
	
	/#
	debug_replay("File: _vehicle.gsc. Function: init_vehicles() - COMPLETE\n");
	#/
	
	// SCRIPTER_MOD: dguzzo: 3-9-09 : this looks to be used only for arcade mode. going to leave in the one cod:waw reference as an example.
	// CODER_MOD: Tommy K
	level.vehicle_enemy_tanks = [];	
	level.vehicle_enemy_tanks[ "vehicle_ger_tracked_king_tiger" ] 		= true;
}

init_aircraft_list()
{
	level.aircraft_list = [];
	
	// SCRIPTER_MOD: dguzzo: 3-9-09 : old cod:waw types
	level.aircraft_list[ "player_corsair" ] = true;
	level.aircraft_list[ "rufe" ] = true;
	level.aircraft_list[ "corsair" ] = true;
	
	level.aircraft_list[ "zero" ] = true;                                                  
	level.aircraft_list[ "pby" ] = true;
	level.aircraft_list[ "pby_blackcat" ] = true;
	level.aircraft_list[ "jap_gunboat" ] = true;
	
	level.aircraft_list[ "il2" ] = true;
		
}

init_boat_list()
{
	// SCRIPTER_MOD: dguzzo: 3-9-09 : old cod:waw types
	level.boat_list = [];	
	level.boat_list["rubber_raft"] = true;
	level.boat_list[ "jap_ptboat" ] = true;
	level.boat_list[ "jap_shinyo" ] = true;
	level.boat_list[ "jap_merchant_ship" ] = true;
}

init_level_has_vehicles()
{
	level.levelHasVehicles = false;
	
	// if there is a vehicle spawner then the level has vehicles
	if ( level.vehicle_spawngroup.size > 0 )
	{
		level.levelHasVehicles = true;
	}

	if ( level.vehicle_spawners.size > 0 )
	{
		level.levelHasVehicles = true;
	}
	
	// if there are any vehicles prespawned of any team in the level then there are vehicles
	if ( level.vehicles[ "allies" ].size > 0 )
	{
		level.levelHasVehicles = true;
	}

	if ( level.vehicles[ "axis" ].size > 0 )
	{
		level.levelHasVehicles = true;
	}

	if ( level.vehicles[ "neutral" ].size > 0 )
	{
		level.levelHasVehicles = true;
	}
	
	// if there are any script_vehicle classname there are vehicles
	classname = getentarray( "script_vehicle", "classname" );
	if ( classname.size > 0 )
	{
		level.levelHasVehicles = true;
	}
}

trigger_getlinkmap( trigger )
{
	linkMap = []; 
	if( IsDefined( trigger.script_linkTo ) )
	{
		links = strtok( trigger.script_linkTo, " " );
		for( i = 0; i < links.size; i++ )
		{
			linkMap[ links[ i ] ] = true; 
		}
		links = undefined; 
	}
	return linkMap; 
}

// setup_script_gatetrigger( trigger, linkMap )
setup_script_gatetrigger( trigger )
{
	gates = []; 
	if( IsDefined( trigger.script_gatetrigger ) )
	{
		return level.vehicle_gatetrigger[ trigger.script_gatetrigger ]; 
	}
	return gates; 
}

// setup_script_vehiclespawngroup( trigger, vehicles, linkMap )
setup_script_vehiclespawngroup( trigger, vehicles )
{
	script_vehiclespawngroup = false; 
	if( IsDefined( trigger.script_vehiclespawngroup ) )
	{
		script_vehiclespawngroup = true; 
	}
	return script_vehiclespawngroup; 
}

trigger_process( trigger )
{
	 // these triggers only trigger once where vehicle paths trigger everytime a vehicle crosses them
	if( IsDefined( trigger.classname ) && ( trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat" ) )
	{
		bTriggeronce = true;
	}
	else
	{
		bTriggeronce = false;
	}

	trigger.processed_trigger = undefined;  // clear out this flag that was used to get the trigger to this point.
	
	 // override to make a trigger loop
	if( IsDefined( trigger.script_noteworthy ) && trigger.script_noteworthy == "trigger_multiple" )
	{
		bTriggeronce = false;
	}

	gates = setup_script_gatetrigger( trigger );

	script_vehiclespawngroup = IsDefined( trigger.script_vehiclespawngroup );
	
	// origin paths and script struct paths get this value
	script_vehicledetour = IsDefined( trigger.script_vehicledetour ) && ( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) ) ;

	 // ground paths get this value
	detoured = IsDefined( trigger.detoured ) && !( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );
	gotrigger = true;

	while( gotrigger )
	{
		trigger waittill( "trigger", other );
		
		if ( IsDefined( trigger.script_vehicletriggergroup ) )
		{
			if( !IsDefined( other.script_vehicletriggergroup ) )
			{
				continue;
			}

			if( IsDefined(other) && other.script_vehicletriggergroup != trigger.script_vehicletriggergroup )
			{
				continue;
			}
		}

		if( IsDefined( trigger.enabled ) && !trigger.enabled )
		{
			trigger waittill( "enable" );
		}
			
		if ( IsDefined( trigger.script_flag_set ) )
		{
			if ( IsDefined(other) && IsDefined( other.vehicle_flags ) )
			{
				other.vehicle_flags[ trigger.script_flag_set ] = true;
			}

			if ( IsDefined(other) )
			{
				other notify( "vehicle_flag_arrived", trigger.script_flag_set );
			}
			flag_set( trigger.script_flag_set );
		}

		if ( IsDefined( trigger.script_flag_clear ) )
		{
			if ( IsDefined(other) && IsDefined( other.vehicle_flags ) )
			{
				other.vehicle_flags[ trigger.script_flag_clear ] = false;
			}
			flag_clear( trigger.script_flag_clear );
		}

		if( IsDefined(other) && script_vehicledetour )
		{
			other thread path_detour_script_origin( trigger );
		}
		else if ( detoured && IsDefined( other ) )
		{
			other thread path_detour( trigger );
		}
		
		if ( IsDefined( trigger.script_delay ) )
		{
			wait trigger.script_delay; 
		}

		targs = []; 
		if( bTriggeronce )
		{
			if( IsDefined( trigger.target ) && IsDefined( level.vehicle_target[ trigger.target ] ) )
			{
				targs = level.vehicle_target[ trigger.target ]; 
			}
			gotrigger = false; 
		}

		if ( IsDefined( trigger.script_vehicleGroupDelete ) )
		{
			if( !IsDefined( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] ) )
			{
				println( "failed to find deleteable vehicle with script_vehicleGroupDelete group number: ", trigger.script_vehicleGroupDelete );
				level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] = []; 
			}
			array_delete( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] );
		}

		if( script_vehiclespawngroup )
		{
			level notify( "spawnvehiclegroup" + trigger.script_vehiclespawngroup );
			waittillframeend; 
		}

		if ( gates.size > 0 && bTriggeronce )
		{
			array_levelthread( gates, ::path_gate_open );
		}

		if ( IsDefined( trigger.script_VehicleStartMove ) )
		{
			if ( !IsDefined( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ] ) )
			{
				println( "^3Vehicle start trigger is: ", trigger.script_VehicleStartMove );
				return; 
			}

			// AE 5-18-09: changed this from array_levelthread to array_thread because gopath doesn't take any parameters anymore
			//array_levelthread( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ], ::gopath  );
			array_thread( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ], ::gopath  );
		}
	}
}

path_detour_get_detourpath( detournode )
{
	detourpath = undefined; 
	for( j = 0; j < level.vehicle_detourpaths[ detournode.script_vehicledetour ].size; j++ )
	{
		if( level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ] != detournode )
		{
			if( !islastnode( level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ] ) )
			{
				detourpath = level.vehicle_detourpaths[ detournode.script_vehicledetour ][ j ]; 
			}
		}
	}

	return detourpath; 
}

path_detour_script_origin( detournode )
{
	detourpath = path_detour_get_detourpath( detournode );
	if( IsDefined( detourpath ) )
	{
		self thread vehicle_paths( detourpath );
	}
}

crash_detour_check( detourpath )
{
	 // long somewhat complex set of conditions on which a vehicle will detour through a crashpath.
	return
	( 
		IsDefined( detourpath.script_crashtype )
		&& 
		( 
			IsDefined( self.deaddriver ) 
			|| self.health <= 0 
			|| detourpath.script_crashtype == "forced" 
			|| ( level.vclogin_vehicles )
		)
		&& 
		( 
			!IsDefined( detourpath.derailed )  
			|| ( IsDefined( detourpath.script_crashtype ) && detourpath.script_crashtype == "plane" ) 
		)
	);
}

crash_derailed_check( detourpath )
{
	return IsDefined( detourpath.derailed ) && detourpath.derailed; 
}

path_detour( node )
{
	detournode = getvehiclenode( node.target, "targetname" );
	detourpath = path_detour_get_detourpath( detournode );

	// be more aggressive with this maybe? 
	if( !IsDefined( detourpath ) )
	{
		return; 
	}

	if( node.detoured && !IsDefined( detourpath.script_vehicledetourgroup ) )
	{
		return; 
	}
		
	if( crash_detour_check( detourpath ) )  
	{
		self notify( "crashpath", detourpath );
		detourpath.derailed = 1; 
		self notify( "newpath" );
		self setSwitchNode( node, detourpath );
		return; 
	}
	else
	{
		if( crash_derailed_check( detourpath ) )
		{
			return;  // .derailed crashpaths fail crash check. this keeps other vehicles from following.
		}

		 // detour paths specific to grouped vehicles. So they can share a lane and detour when they need to be exciting.			
		if( IsDefined( detourpath.script_vehicledetourgroup ) )
		{
			if( !IsDefined( self.script_vehicledetourgroup ) )
			{
				return;
			}

			if( detourpath.script_vehicledetourgroup != self.script_vehicledetourgroup )
			{
				return;
			}
		}
	}
}

vehicle_Levelstuff( vehicle, trigger )
{
	// associate with links
	if( IsDefined( vehicle.script_linkname ) )
	{
		level.vehicle_link = array_2dadd( level.vehicle_link, vehicle.script_linkname, vehicle );
	}

	// associate with targets
	if( IsDefined( vehicle.targetname ) )
	{
		level.vehicle_target = array_2dadd( level.vehicle_target, vehicle.targetname, vehicle );
	}

	if( IsDefined( vehicle.script_VehicleSpawngroup ) )
	{
		level.vehicle_SpawnGroup = array_2dadd( level.vehicle_SpawnGroup, vehicle.script_VehicleSpawngroup, vehicle );
	}

	if( IsDefined( vehicle.script_VehicleStartMove ) )
	{
		level.vehicle_StartMoveGroup = array_2dadd( level.vehicle_StartMoveGroup, vehicle.script_VehicleStartMove, vehicle );
	}

	if( IsDefined( vehicle.script_vehicleGroupDelete ) )
	{
		level.vehicle_DeleteGroup = array_2dadd( level.vehicle_DeleteGroup, vehicle.script_vehicleGroupDelete, vehicle );
	}
}

spawn_array( spawners )
{
	ai = []; 
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ].count = 1;
		dronespawn = false;
		if( IsDefined( spawners[ i ].script_drone ) )
		{
			dronespawn = true; 
			spawned = dronespawn( spawners[ i ] );
		}
		else 
		{
			spawned = spawners[ i ] spawn_ai();
			if (!IsAlive(spawned))
			{
				continue;
			}
		}
		
		assert( IsDefined( spawned ) );
		ai[ ai.size ] = spawned; 
	}

	ai = remove_non_riders_from_array( ai );	
	return ai;
}

remove_non_riders_from_array( ai )
{
	living_ai = [];
	for( i = 0; i < ai.size; i++ )
	{
		if ( !ai_should_be_added( ai[ i ] ) )
		{
			continue;
		}

		living_ai[ living_ai.size ] = ai[ i ];
	}
	return living_ai; 
}

ai_should_be_added( ai )
{
	if( isalive( ai ) )
	{
		return true;
	}
	
	if ( !IsDefined( ai ) )
	{
		return false;
	}
	
	if ( !IsDefined( ai.classname ) )
	{
		return false;
	}
		
	return ai.classname == "script_model";
}

spawn_group()
{
	HasRiders = ( IsDefined( self.script_vehicleride ) );
	HasWalkers = ( IsDefined( self.script_vehiclewalk ) );
	if( !( HasRiders || HasWalkers ) )
	{
		return; 
	}
	spawners = []; 

	riderspawners = []; 
	walkerspawners = []; 

	if( HasRiders )
	{
		riderspawners = level.vehicle_RideSpawners[ self.script_vehicleride ]; 
	}
	
	if( !IsDefined( riderspawners ) )
	{
		riderspawners = []; 
	}

	if( HasWalkers )
	{
		walkerspawners = level.vehicle_walkspawners[ self.script_vehiclewalk ]; 
	}
	
	if( !IsDefined( walkerspawners ) )
	{
		walkerspawners = []; 
	}


	spawners = array_combine( riderspawners, walkerspawners );
	startinvehicles = []; 
	
	for(i = 0; i < spawners.size; i ++)
	{
		spawners[i].script_forcespawn = true;	// All riders and walkers should always spawn...  DSL
	}

	ai = spawn_array( spawners );

	if( HasRiders )
	{
		if( IsDefined( level.vehicle_RideAI[ self.script_vehicleride ] ) )
		{
			ai = array_combine( ai, level.vehicle_RideAI[ self.script_vehicleride ] );
		}
	}
	
	if( HasWalkers )
	{
		if( IsDefined( level.vehicle_WalkAI[ self.script_vehiclewalk ] ) )
		{
			ai = array_combine( ai, level.vehicle_WalkAI[ self.script_vehiclewalk ] );
			ai vehicle_rider_walk_setup (self);
		}
	}

	ai = sort_by_startingpos( ai );
	
	for ( i = 0; i < ai.size; i++ )
	{
		ai[ i ] thread maps\_vehicle_aianim::vehicle_enter( self, self.script_tag );
	}
}
		
sort_by_startingpos( guysarray )
{
	firstarray = [];
	secondarray = [];

	for ( i = 0 ; i < guysarray.size ; i++ )
	{
		if ( IsDefined( guysarray[ i ].script_startingposition ) )
		{
			firstarray[ firstarray.size ] = guysarray[ i ];
		}
		else
		{
			secondarray[ secondarray.size ] = guysarray[ i ];
		}
	}

	return array_combine( firstarray, secondarray );
}

vehicle_rider_walk_setup( vehicle )
{
	if ( !IsDefined( self.script_vehiclewalk ) )
	{
		return;
	}

	if ( IsDefined( self.script_followmode ) )
	{
		self.FollowMode = self.script_followmode; 
	}
	else
	{
		self.FollowMode = "cover nodes"; 
	}

	// check if the AI should go to a node after walking with the vehicle
	if ( !IsDefined( self.target ) )
	{
		return;
	}

	node = getnode( self.target, "targetname" );
	if( IsDefined( node ) )
	{
		self.NodeAftervehicleWalk = node; 
	}
}

runtovehicle( guy )
{
	guyarray = []; 

	climbinnode = self.climbnode; 
	climbinanim = self.climbanim; 
	closenode = climbinnode[ 0 ]; 
	currentdist = 5000; 
	thenode = undefined;

	for( i = 0; i < climbinnode.size; i++ )
	{
		climborg = self gettagorigin( climbinnode[ i ] );
		climbang = self gettagangles( climbinnode[ i ] );
		org = getstartorigin( climborg, climbang, climbinanim[ i ] );
		distance = distance( guy.origin, climborg );
		if( distance < currentdist )
		{
			currentdist = distance; 
			closenode = climbinnode[ i ]; 
			thenode = i; 
		}
	}

	climbang = undefined; 
	climborg = undefined; 
	thread runtovehicle_setgoal( guy );

	while( !guy.vehicle_goal )
	{
		climborg = self gettagorigin( climbinnode[ thenode ] );
		climbang = self gettagangles( climbinnode[ thenode ] );
		org = getStartOrigin( climborg, climbang, climbinanim[ thenode ] );
		guy set_forcegoal();
		guy setgoalpos( org );
		guy.goalradius = 64; 
		wait .25; 
	}

	guy unset_forcegoal();

	if( self getspeedmph() < 1 )
	{
		guy linkto( self );
		guy animscripted( "hopinend", climborg, climbang, climbinanim[ thenode ] );
		guy waittillmatch( "hopinend", "end" );
		guy enter_vehicle(  self );
	}
}

runtovehicle_setgoal( guy )
{
	guy.vehicle_goal = false; 
	self endon( "death" );
	guy endon( "death" );
	guy waittill( "goal" );
	guy.vehicle_goal = true; 
}

setup_groundnode_detour( node )
{
	realdetournode = getvehiclenode( node.targetname, "target" );
	if( !IsDefined( realdetournode ) )
	{
		return;
	}

	realdetournode.detoured = 0; 
	add_proccess_trigger( realdetournode );	
}

add_proccess_trigger( trigger )
{
	// TODO: next game. stop trying to make everything a trigger.  remove trigger process. I'd do it this game but there is too much complexity in Detour nodes.
	 // .processedtrigger is a flag that I set to keep a trigger from getting added twice.
	if( IsDefined( trigger.processed_trigger ) )
	{
		return; 
	}

	level.vehicle_processtriggers[ level.vehicle_processtriggers.size ] = trigger; 
	trigger.processed_trigger = true; 
}

islastnode( node )
{
	if( !IsDefined( node.target ) )
	{
		return true; 
	}

	if( !IsDefined( getvehiclenode( node.target, "targetname" ) ) && !IsDefined( get_vehiclenode_any_dynamic( node.target ) )  )
	{
		return true; 
	}

	return false; 
}

// AE 5-15-09: cleaned up by taking out the aircraft bool as a parameter (that wasn't being used)
vehicle_paths( node )
{
	assertex( IsDefined( node ) || IsDefined( self.attachedpath ), "vehicle_path() called without a path" );
	self notify( "newpath" );

	 // dynamicpaths unique.  node isn't defined by info vehicle node calls to this function
	if( IsDefined( node ) )
	{
		self.attachedpath = node; 
	}
	
	pathstart = self.attachedpath; 
	self.currentNode = self.attachedpath; 

	if( !IsDefined( pathstart ) )
	{
		return; 
	}

	self endon( "newpath" );

	nextpoint = pathstart;

	while ( IsDefined( nextpoint ) )
	{
		self waittill( "reached_node", nextpoint );	

		if( !IsDefined( self ) )
		{
			return; 
		}
			
		self.currentNode = nextpoint; 

		if( IsDefined( nextpoint.gateopen ) && !nextpoint.gateopen )
		{
			 // threaded because vehicle may setspeed( 0, 15 ) and run into the next node
			self thread path_gate_wait_till_open( nextpoint );
		}
		// the sweet stuff! Pathpoints handled in script as triggers!
		nextpoint notify( "trigger", self );
		
		// SRS 05/03/07: added for _planeweapons to drop bombs
		// amount, delay, delay trace
		if( IsDefined( nextpoint.script_dropbombs ) && nextpoint.script_dropbombs > 0 )
		{
			amount = nextpoint.script_dropbombs;
			delay = 0;
			delaytrace = 0;
			
			if( IsDefined( nextpoint.script_dropbombs_delay ) && nextpoint.script_dropbombs_delay > 0 )
			{
				delay = nextpoint.script_dropbombs_delay;
			}
			
			if( IsDefined( nextpoint.script_dropbombs_delaytrace ) && nextpoint.script_dropbombs_delaytrace > 0 )
			{
				delaytrace = nextpoint.script_dropbombs_delaytrace;
			}
			
			self notify( "drop_bombs", amount, delay, delaytrace );
		}

		if ( IsDefined( nextpoint.script_volumedown ) )
		{
			assertex( !IsDefined( nextpoint.script_volumedown ), "Tried to volume down while voluming up, or vice versa" );
			self thread volume_down( nextpoint.script_volumedown );
		}

		if ( IsDefined( nextpoint.script_volumeup ) )
		{
			assertex( !IsDefined( nextpoint.script_volumeup ), "Tried to volume down while voluming up, or vice versa" );
			self thread volume_up( nextpoint.script_volumeup );
		}
		
		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			self notify( nextpoint.script_noteworthy );
			self notify( "noteworthy", nextpoint.script_noteworthy );
		}

		if ( IsDefined( nextpoint.script_notify) )
		{
			self notify( nextpoint.script_notify );
			level notify( nextpoint.script_notify );
		}
		
		waittillframeend; // this lets other scripts interupt
		
		if( !IsDefined( self ) )
		{
			return; 
		}

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			if ( nextpoint.script_noteworthy == "godon" )
			{
				self godon();
			}
			else if ( nextpoint.script_noteworthy == "godoff" )
			{
				self godoff();
			}
			else if ( nextpoint.script_noteworthy == "deleteme" )
			{
				self Delete();
				return;
			}
			else if ( nextpoint.script_noteworthy == "drivepath" )
			{
				self DrivePath();	// this will auto tilt and stuff for helicopters
			}
			else if ( nextpoint.script_noteworthy == "lockpath" )
			{
				self StartPath();	// this will stop the auto tilting and lock the heli back on the spline
			}
			else if ( nextpoint.script_noteworthy == "brake" )
			{
				if( self.isphysicsvehicle )
				{
					self SetBrake(1);
				}
			}
		}
		
		if ( IsDefined( nextpoint.script_crashtypeoverride ) )
		{
			self.script_crashtypeoverride = nextpoint.script_crashtypeoverride; 
		}

		if ( IsDefined( nextpoint.script_badplace ) )
		{
			self.script_badplace = nextpoint.script_badplace; 
		}

		if ( IsDefined( nextpoint.script_turretmg ) )
		{
			self.script_turretmg = nextpoint.script_turretmg; 
		}

		if ( IsDefined( nextpoint.script_team ) )
		{
			self.vteam = nextpoint.script_team; 
		}

		if ( IsDefined( nextpoint.script_turningdir ) )
		{
			self notify( "turning", nextpoint.script_turningdir );
		}
			
		if ( IsDefined( nextpoint.script_deathroll ) )
		{
			if ( nextpoint.script_deathroll == 0 )
			{
				self thread deathrolloff();
			}
			else
			{
				self thread deathrollon();
			}
		}
		
		if ( IsDefined( nextpoint.script_vehicleaianim ) )
		{
			if ( IsDefined( nextpoint.script_parameters ) && nextpoint.script_parameters == "queue" )
			{
				self.queueanim = true;
			}
			if ( IsDefined( nextpoint.script_startingposition ) )
			{
				self.groupedanim_pos = nextpoint.script_startingposition;
			}
			self notify( "groupedanimevent", nextpoint.script_vehicleaianim );
		}
	
		if ( IsDefined( nextpoint.script_wheeldirection ) )
		{
			self wheeldirectionchange( nextpoint.script_wheeldirection );
		}

		if ( IsDefined( nextpoint.script_exploder ) )
		{
			level exploder( nextpoint.script_exploder );
		}

		if ( IsDefined( nextpoint.script_flag_set ) )
		{
			if ( IsDefined( self.vehicle_flags ) )
			{
				self.vehicle_flags[ nextpoint.script_flag_set ] = true;
			}
			self notify( "vehicle_flag_arrived", nextpoint.script_flag_set );
			flag_set( nextpoint.script_flag_set );
		}

		if ( IsDefined( nextpoint.script_flag_clear ) )
		{
			if ( IsDefined( self.vehicle_flags ) )
			{
				self.vehicle_flags[ nextpoint.script_flag_clear ] = false;
			}
			flag_clear( nextpoint.script_flag_clear );
		}
					
		if ( IsDefined( nextpoint.script_unload ) )
		{
			self thread unload_node( nextpoint );
		}

		if (IsDefined(nextpoint.script_wait))
		{
			self SetSpeed( 0, 10, 10 );
			nextpoint script_wait();
			self ResumeSpeed(10);
		}

		if( IsDefined( nextpoint.script_flag_wait ) )
		{			
			if ( !IsDefined( self.vehicle_flags ) )
			{
				self.vehicle_flags = [];
			}

			self.vehicle_flags[ nextpoint.script_flag_wait ] = true;
			self notify( "vehicle_flag_arrived", nextpoint.script_flag_wait );
			self ent_flag_set("waiting_for_flag");

			// helicopters stop on their own because they know to stop at destination for script_flag_wait
			// may have to provide a smoother way to stop and go tho, this is rather arbitrary, for tanks
			// in this case
			if ( !flag( nextpoint.script_flag_wait ) )
			{
				self SetSpeed( 0, 10, 10 );
			}

			 // wait at the end point if it has flag wait
			flag_wait( nextpoint.script_flag_wait );
			self ent_flag_clear("waiting_for_flag");
			self ResumeSpeed(10);
		}
			
		if ( IsDefined( self.set_lookat_point ) )
		{
			self.set_lookat_point = undefined;
			self clearLookAtEnt();
		}
	
		if (IsDefined(nextpoint.script_lights_on))
		{
			if (nextpoint.script_lights_on)
			{
				self lights_on();
			}
			else
			{
				self lights_off();
			}
		}

		if (IsDefined(nextpoint.script_sirens_on))
		{
			if (nextpoint.script_sirens_on)
			{
				self sirens_on();
			}
			else
			{
				self sirens_off();
			}
		}

		if ( !IsDefined( nextpoint.target ) )
		{
			break;
		}
	}

	self notify( "reached_dynamic_path_end" );
	
	if( IsDefined( self.script_vehicle_selfremove ) )
	{
		self delete();
	}
}

must_stop_at_next_point( nextpoint )
{
	// gotta be able to slow down for unload nodes
	if( IsDefined( nextpoint.script_unload ) )
	{
		return true;
	}
		
	// gotta stop if it depends on a flag
	return IsDefined( nextpoint.script_flag_wait ) && !flag( nextpoint.script_flag_wait );
}

setvehgoalnode( node )
{
	self endon( "death" );

	stop = false; 
	if( !IsDefined( stop ) )
	{
		stop = true; 
	}
	if( IsDefined( node.script_stopnode ) ) // z: stop at nodes if there is a script_stopnode = 1 value
	{
		stop = node.script_stopnode; 
	}
	if( IsDefined( node.script_unload ) )
	{
		stop = true; 
	}

	script_anglevehicle = IsDefined( node.script_anglevehicle ) && node.script_anglevehicle;
	script_goalyaw =  IsDefined( node.script_goalyaw ) && node.script_goalyaw;
	
	if ( IsDefined( node.script_anglevehicle ) || IsDefined( node.script_goalyaw ) )
	{
		self forcetarget( node, script_goalyaw, script_anglevehicle );
	}
	else
	{
		self unforcetarget();
	}
		
	if( IsDefined( node.script_flag_wait ) )
	{
		if( !flag( node.script_flag_wait ) )
		{
			 // if the flag gets set during flight, we should update the setvehgoalpos to not stop
			stop = true;
		}
	}
	if( !IsDefined( node.target ) )
	{
		 // stop if this is the end of the path
		stop = true;
	}
	
	self setvehgoalpos_wrap( node.origin, stop ); // Z: second param = false dont stop at each node.
}

forcetarget( node, script_goalyaw, script_anglevehicle )
{
	// [ 14:45 ] [ jiesang - ?? ]: lookat entity > goalyaw > targetyaw
	if ( script_goalyaw )
	{
		self cleartargetyaw();
		self setgoalyaw( node.angles[ 1 ] );
	}
	else
	{
		self cleargoalyaw(); // clear this thing
		self settargetyaw( node.angles[ 1 ] );
	}
}

unforcetarget()
{
	self cleargoalyaw(); // clear this thing
	self cleartargetyaw(); // clear the stuff
}

deathrollon()
{
	if( self.health > 0 )
	{
		self.rollingdeath = 1; 
	}
}

deathrolloff()
{
	self.rollingdeath = undefined; 
	self notify( "deathrolloff" );
}

// AE 5-15-09: cleaned this up and added the path_start parameter
getonpath(path_start) // self == vehicle
{
	if( !IsDefined( path_start ) )
	{
		return;
	}
	
	//[ceng 4/26/2010] If a vehicle previously used go_path() then .hasstarted 
	//would be set but never cleared, preventing the vehicle from using go_path()
	//again. This allows the vehicle to follow more paths beyond their first.
	if( isDefined( self.hasstarted ) )
	{
		self.hasstarted = undefined;
	}
	
	self.attachedpath = path_start;	
	
	if( !IsDefined(self.drivepath) || !self.drivepath )
	{
		self.origin = path_start.origin;
		self AttachPath( path_start );
	}
	
	if( !IsDefined( self.dontDisconnectPaths ) )
	{
		self DisconnectPaths();
	}

	if (is_true(self.isphysicsvehicle))
	{
		self SetBrake(true);
	}

	self thread vehicle_paths();
}


/* 
============= 
///ScriptDocBegin
"Name: create_vehicle_from_spawngroup_and_gopath( <spawnGroup> )"
"Summary: spawns and returns and array of the vehicles in the specified spawngroup starting them on their paths"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <spawnGroup> : the script_vehiclespawngroup asigned to the vehicles in radiant"
"Example: maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( spawnGroup )"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

create_vehicle_from_spawngroup_and_gopath( spawnGroup )
{
	vehicleArray = maps\_vehicle::scripted_spawn( spawnGroup );
	for( i = 0; i < vehicleArray.size; i++ )
	{
		if (IsDefined(vehicleArray[ i ]))
		{
			vehicleArray[ i ] thread maps\_vehicle::gopath();
		}
	}
	return vehicleArray; 
}

// AE 5-15-09: cleaned up by taking out the vehicle parameter and just having the vehicle as self
gopath() // self == vehicle
{
	self endon( "death" );
	self endon( "stop path" );
	
	if( self.isphysicsvehicle )
	{
		//wait 0.3;	// need to wait a little bit after the vehicle has spawned for the code to setup the physics
		self SetBrake(false);
	}

	if( IsDefined( self.script_vehiclestartmove ) )
	{
		level.vehicle_StartMoveGroup[ self.script_vehiclestartmove ] = array_remove( level.vehicle_StartMoveGroup[ self.script_vehiclestartmove ], self );
	}
	
	if( IsDefined( self.hasstarted ) )
	{
		println( "vehicle already moving when triggered with a startmove" );
		return; 
	}
	else
	{
		self.hasstarted = true; 
	}

	// if there's a delay then it'll run
	self script_delay();

	self notify( "start_vehiclepath" );

	if( IsDefined( self.drivepath ) && self.drivepath )
	{
		self DrivePath( self.attachedpath );
	}
	else
	{
		self StartPath();
	}
			
	// start waiting for the end of the path
	wait .05; 
	self ConnectPaths();
	self waittill( "reached_end_node" );

	if ( !IsDefined( self.dontDisconnectPaths ) )
	{
		self DisconnectPaths();
	}

	if( IsDefined( self.currentnode ) && IsDefined( self.currentnode.script_noteworthy ) && self.currentnode.script_noteworthy == "deleteme" )
	{
		return;
	}

	if ( !IsDefined( self.dontunloadonend ) )
	{
		do_unload( self.script_unloaddelay );
	}
}

do_unload( delay ) // self == vehicle
{
	self endon( "unload" );

	if (IsDefined(delay) && delay > 0)
	{
		wait delay;
	}

	self notify( "unload" );
}

path_gate_open( node )
{
	node.gateopen = true; 
	node notify( "gate opened" );
}

path_gate_wait_till_open( pathspot )
{
	self endon( "death" );
	self.waitingforgate = true;
	self vehicle_setspeed( 0, 15, "path gate closed" );
	pathspot waittill( "gate opened" );
	self.waitingforgate = false;

	if( self.health > 0 )
	{
		script_resumespeed( "gate opened", level.vehicle_ResumeSpeed );
	}
}

spawner_setup( vehicles, spawngroup, from )
{
	if( !IsDefined( level.vehicleSpawners ) )
	{
		level.vehicleSpawners = []; 
	}

	level.vehicleSpawners[ spawngroup ] = []; 

	vehicle = [];  // vehicle is an array of vehiclegroup array's
	for( i = 0; i < vehicles.size; i++ )
	{
		
		vehicles[i] thread vehicle_main();
		
		if( !IsDefined( vehicle[ spawngroup ] ) )
		{
			vehicle[ spawngroup ] = []; 
		}

		script_struct = SpawnStruct();
		
		 // creates struct that copies certain values from the vehicle to be added when the vehicle is spawned.
		script_struct setspawnervariables( vehicles[ i ], from );

		vehicle[ spawngroup ] = array_add(vehicle[ spawngroup ], script_struct);
		level.vehicleSpawners[ spawngroup ][ i ] = script_struct; 
	}

	while( 1 )
	{
		spawnedvehicles = []; 
		level waittill( "spawnvehiclegroup" + spawngroup );

		for( i = 0; i < vehicle[ spawngroup ].size; i++ )
		{
			spawnedvehicles[ spawnedvehicles.size ] = vehicle_spawn( vehicle[ spawngroup ][ i ] );
		}

		level notify( "vehiclegroup spawned" + spawngroup, spawnedvehicles );
	}
}

/* 
============= 
///ScriptDocBegin
"Name: scripted_spawn( <group> )"
"Summary: spawns and returns a vehiclegroup, you will need to tell it to maps\_vehicle::gopath() when you want it to go"
"Module: Vehicle"
"CallOn: An entity"
"MandatoryArg: <group> : "
"Example: bmps = maps\_vehicle::scripted_spawn( 32 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

scripted_spawn( group )
{
	thread scripted_spawn_go( group );
	level waittill( "vehiclegroup spawned" + group, vehicles );
	return vehicles; 
}

scripted_spawn_go( group )
{
	waittillframeend; 
	level notify( "spawnvehiclegroup" + group );
}

setspawnervariables( vehicle, from )
{
	self.spawnermodel = vehicle.model; 
	self.angles = vehicle.angles; 
	self.origin = vehicle.origin; 
	if( IsDefined( vehicle.script_delay ) )
	{
		self.script_delay = vehicle.script_delay; 
	}

	if( IsDefined( vehicle.script_noteworthy ) )
	{
		self.script_noteworthy = vehicle.script_noteworthy; 
	}

	if( IsDefined( vehicle.script_parameters ) )
	{
		self.script_parameters = vehicle.script_parameters; 
	}

	if( IsDefined( vehicle.script_team ) )
	{
		self.vteam = vehicle.script_team; 
	}

	if( IsDefined( vehicle.script_vehicleride ) )
	{
		self.script_vehicleride = vehicle.script_vehicleride; 
	}

	if( IsDefined( vehicle.target ) )
	{
		self.target = vehicle.target; 
	}
	
	if( IsDefined( vehicle.targetname ) )
	{
		self.targetname = vehicle.targetname; 
	}
	else
	{
		self.targetname = "notdefined"; 
	}

	self.spawnedtargetname = self.targetname; 

	self.targetname = self.targetname + "_vehiclespawner"; 
	if( IsDefined( vehicle.triggeredthink ) )
	{
		self.triggeredthink = vehicle.triggeredthink; 
	}

	if( IsDefined( vehicle.script_sound ) )
	{
		self.script_sound = vehicle.script_sound; 
	}

	if( IsDefined( vehicle.script_turretmg ) )
	{
		self.script_turretmg = vehicle.script_turretmg; 
	}

	if( IsDefined( vehicle.script_startinghealth ) )
	{
		self.script_startinghealth = vehicle.script_startinghealth; 
	}

	if( IsDefined( vehicle.spawnerNum ) )
	{
		self.spawnerNum = vehicle.spawnerNum; 
	}

	if( IsDefined( vehicle.script_deathnotify ) )
	{
		self.script_deathnotify = vehicle.script_deathnotify; 
	}

	if( IsDefined( vehicle.script_turret ) )
	{
		self.script_turret = vehicle.script_turret; 
	}

	if( IsDefined( vehicle.script_linkTo ) )
	{
		self.script_linkTo = vehicle.script_linkTo; 
	}

	if( IsDefined( vehicle.script_VehicleSpawngroup ) )
	{
		self.script_VehicleSpawngroup = vehicle.script_VehicleSpawngroup; 
	}

	if( IsDefined( vehicle.script_VehicleStartMove ) )
	{
		self.script_VehicleStartMove = vehicle.script_VehicleStartMove; 
	}

	if( IsDefined( vehicle.script_vehicleGroupDelete ) )
	{
		self.script_vehicleGroupDelete = vehicle.script_vehicleGroupDelete; 
	}

	if( IsDefined( vehicle.script_vehicle_selfremove ) )
	{
		self.script_vehicle_selfremove = vehicle.script_vehicle_selfremove; 
	}

	if( IsDefined( vehicle.script_nomg ) )
	{
		self.script_nomg = vehicle.script_nomg; 
	}

	if( IsDefined( vehicle.script_badplace ) )
	{
		self.script_badplace = vehicle.script_badplace; 
	}

	if( IsDefined( vehicle.script_vehicleride ) )
	{
		self.script_vehicleride = vehicle.script_vehicleride; 
	}

	if( IsDefined( vehicle.script_vehiclewalk ) )
	{
		self.script_vehiclewalk = vehicle.script_vehiclewalk; 
	}

	if( IsDefined( vehicle.script_linkName ) )
	{
		self.script_linkName = vehicle.script_linkName; 
	}

	if( IsDefined( vehicle.script_crashtypeoverride ) )
	{
		self.script_crashtypeoverride = vehicle.script_crashtypeoverride; 
	}

	if( IsDefined( vehicle.script_unloaddelay ) )
	{
		self.script_unloaddelay = vehicle.script_unloaddelay; 
	}

	if( IsDefined( vehicle.script_unloadmgguy ) )
	{
		self.script_unloadmgguy = vehicle.script_unloadmgguy; 
	}

	if( IsDefined( vehicle.script_keepdriver ) )
	{
		self.script_keepdriver = vehicle.script_keepdriver; 
	}

	if( IsDefined( vehicle.script_fireondrones ) )
	{
		self.script_fireondrones = vehicle.script_fireondrones; 
	}

	if( IsDefined( vehicle.script_tankgroup ) )
	{
		self.script_tankgroup = vehicle.script_tankgroup; 
	}

	if( IsDefined( vehicle.script_playerconeradius ) )
	{
		self.script_playerconeradius = vehicle.script_playerconeradius; 
	}

	if( IsDefined( vehicle.script_cobratarget ) )
	{
		self.script_cobratarget = vehicle.script_cobratarget; 
	}

	if( IsDefined( vehicle.script_targettype ) )
	{
		self.script_targettype = vehicle.script_targettype; 
	}

	if( IsDefined( vehicle.script_targetoffset_z ) )
	{
		self.script_targetoffset_z = vehicle.script_targetoffset_z; 
	}

	if( IsDefined( vehicle.script_wingman ) )
	{
		self.script_wingman = vehicle.script_wingman; 
	}

	if( IsDefined( vehicle.script_mg_angle ) )
	{
		self.script_mg_angle = vehicle.script_mg_angle; 
	}

	if( IsDefined( vehicle.script_physicsjolt ) )
	{
		self.script_physicsjolt = vehicle.script_physicsjolt; 
	}

	if( IsDefined( vehicle.script_lights_on ) )
	{
		self.script_lights_on = vehicle.script_lights_on; 
	}

	if( IsDefined( vehicle.script_sirens_on ) )
	{
		self.script_sirens_on = vehicle.script_sirens_on; 
	}

	if( IsDefined( vehicle.script_vehicledetourgroup ) )
	{
		self.script_vehicledetourgroup = vehicle.script_vehicledetourgroup; 
	}

	if( IsDefined( vehicle.speed ) )
	{
		self.speed = vehicle.speed; 
	}

	if( IsDefined( vehicle.script_vehicletriggergroup ) )
	{
		self.script_vehicletriggergroup = vehicle.script_vehicletriggergroup; 
	}

	if( IsDefined( vehicle.script_cheap ) )
	{
		self.script_cheap = vehicle.script_cheap; 
	}

	if ( IsDefined( vehicle.script_volume ) )
	{
		self.script_volume = vehicle.script_volume;
	}

	// SCRIPTER_MOD: JesseS (7/21/2007): added script_nonmovingvehicle to eventually replace script_flak88
	if( IsDefined( vehicle.script_nonmovingvehicle ) )
	{
		self.script_nonmovingvehicle = vehicle.script_nonmovingvehicle; 
	}

	if( IsDefined( vehicle.script_flag ) )
	{
		self.script_flag = vehicle.script_flag; 
	}

	if ( IsDefined( vehicle.script_disconnectpaths ) )
	{
		self.script_disconnectpaths = vehicle.script_disconnectpaths; 
	}

	if ( IsDefined( vehicle.script_bulletshield ) )
	{
		self.script_bulletshield = vehicle.script_bulletshield; 
	}

	if ( IsDefined( vehicle.script_volumeramp ) )
	{
		self.script_volumeramp = vehicle.script_volumeramp; 
	}

	if ( IsDefined( vehicle.script_godmode ) )
	{
		self.script_godmode = vehicle.script_godmode; 
	}

	//// SCRIPTER_MOD: JesseS (5/12/200) - script_vehicleattackgroup added back in
	if (IsDefined (vehicle.script_vehicleattackgroup))
	{
		self.script_vehicleattackgroup = vehicle.script_vehicleattackgroup;
	}

	if (IsDefined (vehicle.script_vehicleattackgroupwait))
	{
		self.script_vehicleattackgroupwait = vehicle.script_vehicleattackgroupwait;
	}
	
	// guzzo - 4/1/08 - made it so script_friendname carries over to the spawned vehicle from the spawner
	if (IsDefined (vehicle.script_friendname))
	{
		self.script_friendname = vehicle.script_friendname;
	}

	// SCRIPTER_MOD: KevinD (4/8/2010): script_unload added to specify the unload group on the vehicle spawner
	if( IsDefined( vehicle.script_unload ) )
	{
		self.script_unload = vehicle.script_unload; 
	}
	
	if( IsDefined(vehicle.script_string))
	{
		self.script_string = vehicle.script_string;
	}
	
	if( IsDefined(vehicle.script_int))
	{
		self.script_int = vehicle.script_int;
	}

	if( IsDefined(vehicle.script_ignoreme))
	{
		self.script_ignoreme = vehicle.script_ignoreme;
	}
	
	if( vehicle.count > 0 )
	{
		self.count = vehicle.count; 
	}
	else
	{
		self.count = 1; 
	}

	if( !IsDefined(self.vehicletype) )
	{
		if( IsDefined( vehicle.vehicletype ) )
		{
			self.vehicletype = vehicle.vehicletype; 
		}
		else
		{
			self.vehicletype = maps\_vehicletypes::get_type( vehicle.model );
		}
	}
	
	if( IsDefined(vehicle.destructibledef) )
	{
		self.destructibledef = vehicle.destructibledef;
	}
	
	// can't call vehicle functions if it is a spawner
	if( !(vehicle.spawnflags & 2) && vehicle IsVehicleUsable() )
	{
		self.usable = 1;
	}
	
	if ( IsDefined( vehicle.drivepath ) )
	{
		self.drivepath = vehicle.drivepath;
	}
			
	// SRS 05/03/07: added to support _planeweapons dropping bombs
	if( IsDefined( vehicle.script_numbombs ) )
	{
		self.script_numbombs = vehicle.script_numbombs;
	}	
	
	if( IsDefined(vehicle.exhaust_fx))
	{
		self.exhaust_fx = vehicle.exhaust_fx; 
	}

	if( IsDefined(vehicle.deathfx))
	{
		self.deathfx = vehicle.deathfx;
	}
		
	vehicle delete();
	
	id = vehicle_spawnidgenerate( self.origin );
	self.spawner_id = id; 
	level.vehicle_spawners[ id ] = self; 
}

vehicle_spawnidgenerate( origin )
{
	return "spawnid" + int( origin[ 0 ] ) + "a" + int( origin[ 1 ] ) + "a" + int( origin[ 2 ] );
}

// CODER_MOD: Tommy K
vehicleDamageAssist()
{
	self endon( "death" );
	
	self.attackers = [];
	self.attackerData = [];	
		
	while( true )
	{
		self waittill( "damage", amount, attacker );
		
		if( !IsDefined ( attacker ) || !isPlayer(attacker) )
		{
			continue;
		}
	
		if ( !IsDefined( self.attackerData[ attacker getEntityNumber() ] ) )
		{
			self.attackers[ self.attackers.size ] = attacker;
			self.attackerData[ attacker getEntityNumber() ] = false;
		}
	}

}

vehicle_spawn( vspawner, from )
{
	if( !vspawner.count )
	{
		return; 
	}

	vehicle = spawnVehicle( vspawner.spawnermodel, vspawner.spawnedtargetname, vspawner.vehicletype, vspawner.origin, vspawner.angles, vspawner.destructibledef );

	if (IsDefined(vspawner.destructibledef))
	{
		vehicle.destructibledef = vspawner.destructibledef;
		vehicle thread maps\_destructible::destructible_think();
	}
		
	if( IsDefined( vspawner.script_delay ) )
	{ 
		vehicle.script_delay =	vspawner.script_delay; 
	} 
	
	if( IsDefined( vspawner.script_noteworthy ) ) 
	{
		vehicle.script_noteworthy = vspawner.script_noteworthy; 
	} 
	
	if( IsDefined( vspawner.script_parameters ) ) 
	{ 
		vehicle.script_parameters =	vspawner.script_parameters; 
	} 
	
	if( IsDefined( vspawner.script_team ) )
	{
		vehicle.vteam = vspawner.script_team; 
	} 
	
	if( IsDefined( vspawner.script_vehicleride ) ) 
	{ 
		vehicle.script_vehicleride = vspawner.script_vehicleride; 
	} 
	
	if( IsDefined( vspawner.target ) ) 
	{
		vehicle.target = vspawner.target; 
	} 
	
	if( IsDefined( vspawner.vehicletype ) && !IsDefined( vehicle.vehicletype ) ) 
	{ 
		vehicle.vehicletype =	vspawner.vehicletype; 
	} 
	
	if( IsDefined( vspawner.triggeredthink ) ) 
	{
		vehicle.triggeredthink = vspawner.triggeredthink; 
	} 
	
	if( IsDefined( vspawner.script_sound ) ) 
	{ 
		vehicle.script_sound = vspawner.script_sound; 
	}
	
	if( IsDefined( vspawner.script_turretmg ) ) 
	{ 
		vehicle.script_turretmg =	vspawner.script_turretmg; 
	} 
	
	if( IsDefined( vspawner.script_startinghealth ) )
	{ 
		vehicle.script_startinghealth = vspawner.script_startinghealth; 
	} 
	
	if(IsDefined( vspawner.script_deathnotify ) ) 
	{ 
		vehicle.script_deathnotify = vspawner.script_deathnotify; 
	} 
	
	if( IsDefined( vspawner.script_turret ) ) 
	{
		vehicle.script_turret = vspawner.script_turret; 
	} 
	
	if( IsDefined(vspawner.script_linkTo ) ) 
	{ 
		vehicle.script_linkTo = vspawner.script_linkTo; 
	}
	
	if( IsDefined( vspawner.script_VehicleSpawngroup ) ) 
	{
		vehicle.script_VehicleSpawngroup = vspawner.script_VehicleSpawngroup; 
	} 
	
	if(	IsDefined( vspawner.script_VehicleStartMove ) ) 
	{
		vehicle.script_VehicleStartMove = vspawner.script_VehicleStartMove; 
	} 
	
	if(	IsDefined( vspawner.script_vehicleGroupDelete ) ) 
	{
		vehicle.script_vehicleGroupDelete = vspawner.script_vehicleGroupDelete; 
	}
	
	if( IsDefined( vspawner.script_vehicle_selfremove ) )
	{
		vehicle.script_vehicle_selfremove = vspawner.script_vehicle_selfremove; 
	}

	if( IsDefined( vspawner.script_nomg ) )
	{
		vehicle.script_nomg = vspawner.script_nomg; 
	}

	if( IsDefined( vspawner.script_badplace ) )
	{
		vehicle.script_badplace = vspawner.script_badplace; 
	}

	if( IsDefined( vspawner.script_vehicleride ) )
	{
		vehicle.script_vehicleride = vspawner.script_vehicleride; 
	}

	if( IsDefined( vspawner.script_vehiclewalk ) )
	{
		vehicle.script_vehiclewalk = vspawner.script_vehiclewalk; 
	}

	if( IsDefined( vspawner.script_linkName ) )
	{
		vehicle.script_linkName = vspawner.script_linkName; 
	}

	if( IsDefined( vspawner.script_crashtypeoverride ) )
	{
		vehicle.script_crashtypeoverride = vspawner.script_crashtypeoverride; 
	}

	if( IsDefined( vspawner.script_unloaddelay ) )
	{
		vehicle.script_unloaddelay = vspawner.script_unloaddelay; 
	}

	if( IsDefined( vspawner.script_unloadmgguy ) )
	{
		vehicle.script_unloadmgguy = vspawner.script_unloadmgguy; 
	}

	if( IsDefined( vspawner.script_keepdriver ) )
	{
		vehicle.script_keepdriver = vspawner.script_keepdriver; 
	}

	if( IsDefined( vspawner.script_fireondrones ) )
	{
		vehicle.script_fireondrones = vspawner.script_fireondrones; 
	}

	if( IsDefined( vspawner.script_tankgroup ) )
	{
		vehicle.script_tankgroup = vspawner.script_tankgroup; 
	}

	if( IsDefined( vspawner.script_playerconeradius ) )
	{
		vehicle.script_playerconeradius = vspawner.script_playerconeradius; 
	}

	if( IsDefined( vspawner.script_cobratarget ) )
	{
		vehicle.script_cobratarget = vspawner.script_cobratarget; 
	}

	if( IsDefined( vspawner.script_targettype ) )
	{
		vehicle.script_targettype = vspawner.script_targettype; 
	}

	if( IsDefined( vspawner.script_targetoffset_z ) )
	{
		vehicle.script_targetoffset_z = vspawner.script_targetoffset_z; 
	}

	if( IsDefined( vspawner.script_wingman ) )
	{
		vehicle.script_wingman = vspawner.script_wingman; 
	}

	if( IsDefined( vspawner.script_mg_angle ) )
	{
		vehicle.script_mg_angle = vspawner.script_mg_angle; 
	}

	if( IsDefined( vspawner.script_physicsjolt ) )
	{
		vehicle.script_physicsjolt = vspawner.script_physicsjolt; 
	}

	if( IsDefined( vspawner.script_cheap ) )
	{
		vehicle.script_cheap = vspawner.script_cheap; 
	}

	if ( IsDefined( vspawner.script_flag ) )
	{
		vehicle.script_flag = vspawner.script_flag; 
	}

	if( IsDefined( vspawner.script_lights_on ) )
	{
		vehicle.script_lights_on = vspawner.script_lights_on; 
	}

	if( IsDefined( vspawner.script_sirens_on ) )
	{
		vehicle.script_sirens_on = vspawner.script_sirens_on; 
	}

	if( IsDefined( vspawner.script_vehicledetourgroup ) )
	{
		vehicle.script_vehicledetourgroup = vspawner.script_vehicledetourgroup; 
	}

	if( IsDefined( vspawner.speed ) )
	{
		vehicle.speed = vspawner.speed; 
	}

	if ( IsDefined( vspawner.script_volume ) )
	{
		vehicle.script_volume = vspawner.script_volume; 
	}

	if( IsDefined( vspawner.spawner_id ) )
	{
		vehicle.spawner_id = vspawner.spawner_id; 
	}

	if( IsDefined( vspawner.script_vehicletriggergroup ) )
	{
		vehicle.script_vehicletriggergroup = vspawner.script_vehicletriggergroup; 
	}

	if ( IsDefined( vspawner.script_disconnectpaths ) )
	{
		vehicle.script_disconnectpaths = vspawner.script_disconnectpaths; 
	}
	
	if ( IsDefined( vspawner.script_godmode ) )
	{
		vehicle.script_godmode = vspawner.script_godmode; 
	}
	
	if ( IsDefined( vspawner.script_bulletshield ) )
	{
		vehicle.script_bulletshield = vspawner.script_bulletshield; 
	}
	if ( IsDefined( vspawner.script_volumeramp ) )
	{
		vehicle.script_volumeramp = vspawner.script_volumeramp; 
	}
	
	// SRS 05/03/07: added to support _planeweapons dropping bombs
	if( IsDefined( vspawner.script_numbombs ) )
	{
		vehicle.script_numbombs = vspawner.script_numbombs;
	}	

	if( IsDefined( vspawner.script_flag ) )
	{
		vehicle.script_flag = vspawner.script_flag; 
	}

	// SCRIPTER_MOD: JesseS (7/21/2007): script_nonmovingvehicle added to eventually replace script_flak88
	if( IsDefined( vspawner.script_nonmovingvehicle ) )
	{
		vehicle.script_nonmovingvehicle = vspawner.script_nonmovingvehicle; 
	}

	// SCRIPTER_MOD: JesseS (5/12/200) - script_vehicleattackgroup readded
	if( IsDefined( vspawner.script_vehicleattackgroup ) )
	{
		vehicle.script_vehicleattackgroup = vspawner.script_vehicleattackgroup; 
	}

	if( IsDefined( vspawner.script_vehicleattackgroupwait ) )
	{
		vehicle.script_vehicleattackgroupwait = vspawner.script_vehicleattackgroupwait; 
	}
	
	// guzzo - 4/1/08 - made it so script_friendname carries over to the spawned vehicle from the spawner
	if (IsDefined (vspawner.script_friendname))
	{
		vehicle.script_friendname = vspawner.script_friendname;
	}

	// SCRIPTER_MOD: KevinD (4/8/2010): script_unload_group added to specify the unload group on the vehicle spawner
	if( IsDefined( vspawner.script_unload ) )
	{
		vehicle.unload_group = vspawner.script_unload; 
	}
	
	if(IsDefined(vspawner.script_string))
	{
		vehicle.script_string = vspawner.script_string;
	}		
	
	if(IsDefined(vspawner.script_int))
	{
		vehicle.script_int = vspawner.script_int;
	}		

	vehicle_init( vehicle );

	if( IsDefined( vehicle.targetname ) )
	{
		level notify( "new_vehicle_spawned" + vehicle.targetname, vehicle );
	}

	if( IsDefined( vehicle.script_noteworthy ) )
	{
        level notify( "new_vehicle_spawned" + vehicle.script_noteworthy, vehicle );
	}

	if ( IsDefined( vehicle.spawner_id ) )
	{
		level notify( "new_vehicle_spawned" + vehicle.spawner_id, vehicle );
	}
	
	if( IsDefined( vspawner.usable ) )
	{
		vehicle makeVehicleUsable();
	}
	
	if( IsDefined( vspawner.drivepath ) )
	{
		vehicle.drivepath = vspawner.drivepath;
	}
	
	if( IsDefined(vspawner.exhaust_fx))
	{
		vehicle.exhaust_fx = vspawner.exhaust_fx; 
	}

	if( IsDefined(vspawner.deathfx))
	{
		vehicle.deathfx = vspawner.deathfx;
	}
	
	if( IsDefined(vspawner.script_ignoreme))
	{
		vehicle.script_ignoreme = vspawner.script_ignoreme;
	}

	// CODER_MOD: Tommy K
	if ( vehicle.vteam == "axis" && IsDefined( level.vehicle_enemy_tanks[ vspawner.spawnermodel ] ) )
	{		
		vehicle thread vehicleDamageAssist();
	}			
	
	//-- GLocke: Vehicle Spawn Functions
	if( IsDefined(vspawner.spawn_funcs) )
	{
		for( i = 0; i < vspawner.spawn_funcs.size; i++ )
		{
			if (IsDefined(vehicle))
			{
				func = vspawner.spawn_funcs[ i ];
				single_thread(vehicle, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ]);
			}
		}
	}
	
	return vehicle; 
}

waittill_vehiclespawn( targetname )
{
	level waittill( "new_vehicle_spawned" + targetname, vehicle );
	return vehicle; 
}

waittill_vehiclespawn_noteworthy( noteworthy )
{
    level waittill( "new_vehicle_spawned" + noteworthy, vehicle );
    return vehicle; 
}

/* 
============= 
///ScriptDocBegin
"Name: waittill_vehiclespawn_spawner_id( <spawner_id> )"
"Summary: Waits for a specific vehicle to spawn with the specified < spawner id > "
"Module: Vehicle"
"MandatoryArg: <spawner_id> : id of the vehicle to spawn. This value can be found in the array level.vehicle_spawners in any level with spawned vehicles."
"Example: eVehicle = waittill_vehiclespawn_spawner_id( self.spawner_id );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
waittill_vehiclespawn_spawner_id( spawner_id )
{
    level waittill( "new_vehicle_spawned" + spawner_id, vehicle );
    return vehicle; 
}

wait_vehiclespawn( targetname )
{
	println( "wait_vehiclespawn() called; change to waittill_vehiclespawn()" );
	level waittill( "new_vehicle_spawned" + targetname, vehicle );
	return vehicle; 
}

spawn_through( vehicle )
{
	struct = spawnstruct();
	struct  setspawnervariables( vehicle );
	return vehicle_spawn( struct );
}

vehicle_init( vehicle )
{
	vehicle UseAnimTree( #animtree );

	if( vehicle.classname == "script_model" )
	{
		vehicle = spawn_through( vehicle ); // this sends non - spawned script models through the spawner process to get vehicleinfo.
		return; 
	}

	vehicle ent_flag_init("waiting_for_flag");
	vehicle.takedamage = !is_true(vehicle.script_godmode);

	vehicle.zerospeed = true; 

	if( !IsDefined( vehicle.modeldummyon ) )
	{
		vehicle.modeldummyon = false; 
	}

	type = vehicle.vehicletype;

	 // give the vehicle health
	vehicle vehicle_life();

	// call the vehicle-specific init function
	vehicle thread vehicle_main();

	 // set the team value used everywhere to determine which team the vehicle belongs to
	vehicle vehicle_setteam();

	vehicle thread maingun_FX();

	vehicle.riders = []; 
	vehicle.unloadque = [];  // for ai. wait till a vehicle is unloaded all the way

	// SCRIPTER_MOD: KevinD (4/8/2010): script_unload added to specify the unload group on the vehicle spawner
	if( !IsDefined(vehicle.unload_group) )
	{
		vehicle.unload_group = "default"; 
	}
	
	// getoutrig means fastrope. 
	vehicle.getoutrig = []; 
	if( IsDefined( level.vehicle_attachedmodels ) && IsDefined( level.vehicle_attachedmodels[ type ] ) )
	{
		rigs = level.vehicle_attachedmodels[ type ]; 
		strings = getarraykeys( rigs );
		for( i = 0; i < strings.size; i++ )
		{
			vehicle.getoutrig[ strings[ i ] ] = undefined; 
			vehicle.getoutriganimating[ strings[ i ] ] = false; 
		}
	}

	 // make ai run way from vehicle
	vehicle thread vehicle_badplace();

	 // toggle vehicle lights on / off
	if (is_true(vehicle.script_lights_on))
	{
		vehicle lights_on();
	}

	if (is_true(vehicle.script_sirens_on))
	{
		vehicle sirens_on();
	}

	 // regenerate friendly fire damage
	if( !vehicle isCheap() )
	{
		vehicle friendlyfire_shield();
	}

	 // handles guys riding and doing stuff on vehicles
	vehicle thread maps\_vehicle_aianim::handle_attached_guys();

	 // special stuff for unloading
	if( !vehicle isCheap() )
	{
		vehicle thread vehicle_handleunloadevent();
	}

	 // Make the main turret think
	vehicle thread turret_attack_think();

	 // Shellshock player on main turret fire.
	if( !vehicle isCheap() )
	{
		vehicle thread vehicle_weapon_fired(); // moved to indiviual tank scripts.
	}

	 // make vehicle shake physics objects.
	if( IsDefined( vehicle.script_physicsjolt ) && vehicle.script_physicsjolt )
	{
		vehicle thread physicsjolt_proximity();
	}

	 // associate vehicle with living level variables.
	vehicle_Levelstuff( vehicle );

	 // handle the compassicon for vehicles
	vehicle thread vehicle_compasshandle();

	 // make the wheels rotate
	vehicle thread animate_drive_idle();

	 // handle machine guns
	if( !vehicle isCheap() )
	{
		vehicle thread mginit();
	}

	if( IsDefined( level.vehicleSpawnCallbackThread ) )
	{
		level thread [[ level.vehicleSpawnCallbackThread ]]( vehicle );
	}

	// every vehicle that stops will disconnect its paths
	if( !vehicle isCheap() )
	{
		vehicle thread disconnect_paths_whenstopped();
	}

	 // get on path and start the path handler thread
	// SCRIPTER_MOD: JesseS (5/9/07): Shouldnt need this for stationary guns
	if (!IsDefined (vehicle.script_nonmovingvehicle))
	{
		// AE 5-15-09: put in this path_start to pass to getonpath
		path_start = undefined;
		if(IsDefined(vehicle.target))
		{
			path_start = GetVehicleNode(vehicle.target, "targetname");
			if(!IsDefined(path_start))
			{
				path_start = GetEnt(vehicle.target, "targetname");
				if(!IsDefined(path_start))
				{
					path_start = getstruct(vehicle.target, "targetname");
				}
			}
		}

		if(IsDefined(path_start) && vehicle.vehicletype != "inc_base_jump_spotlight")
		{
			vehicle thread getonpath(path_start);
		}
	}
	
	if (IsDefined (vehicle.script_vehicleattackgroup))
	{
		vehicle thread attackgroup_think();
	}
	
	 // helicopters do dust kickup fx
	if( vehicle hasHelicopterDustKickup() )
	{
		if(!level.clientscripts)
		{
			vehicle thread aircraft_dust_kickup();
		}
	}

/#
	// MikeD (8/1/2007): Debug info for vehicles
	vehicle thread debug_vehicle();
#/

	 // spawn the vehicle and it's associated ai
	vehicle spawn_group();
	vehicle thread kill();
	
	if ( !IsDefined( vehicle.script_volume ) )
	{
		vehicle thread init_ramp_volume();
	}
	
	vehicle apply_truckjunk();
}

init_ramp_volume()
{
	time = 2;
	if ( self is_plane() )
	{
		time = 1;
	}
	
	if ( IsDefined( self.script_volumeramp ) )
	{
		time = self.script_volumeramp;
	}
		
//	thread lerp_enginesound( time, 0, 1 );
	self volume_up( time );
}

kill_damage()
{	
	if( !IsDefined(self) || self.radiusdamageradius <= 0 )
	{
		return;
	}
	
 	wait(0.05);

	if (IsDefined(self))
	{
		self RadiusDamage( self.origin, self.radiusdamageradius, self.radiusdamagemax, self.radiusdamagemin, self, "MOD_EXPLOSIVE" );
	}
}

kill()
{
	self endon( "nodeath_thread" );
	type = self.vehicletype; 
	model = self.model; 
	targetname = self.targetname;
	attacker = undefined;
	arcadeModePointsRewarded = false;
	
	while ( 1 )
	{
		
		rumbletrigger = self.rumbletrigger;
		mgturret = self.mgturret;
		vteam = self.vteam;
		script_linkname = self.script_linkname;
		// waittill death twice. in some cases the vehicle dies and does a bunch of stuff. then it gets deleted. which it then needs to do more stuff
		if ( IsDefined( self ) )
		{
			self waittill( "death", attacker );
		}

		// CODER MOD: TOMMY K
		if( arcadeMode() && false == arcadeModePointsRewarded )
		{
			if( IsDefined(self.vteam) && (self.vteam != "allies") )
			{	
				if ( IsDefined( self.attackers ) )
				{
					for ( i = 0; i < self.attackers.size; i++ )
					{
						player = self.attackers[i];
						
						if ( !IsDefined( player ) )
						{
							continue;
						}
						
						if ( player == attacker )
						{
							continue;
						}
// removing coop challenges for now MGORDON			
//						maps\_challenges_coop::doMissionCallback( "playerAssist", player );
						
						player.assists++;	
						
						arcademode_assignpoints( "arcademode_score_tankassist", player );
					}
					self.attackers = [];
					self.attackerData = [];
				}						
			
				if( IsPlayer( attacker ) )
				{
					//ye killed a enemy tank
					arcademode_assignpoints( "arcademode_score_tank", attacker );
					
					// increment the player kills for tank kill
					attacker.kills++;
				}
			}
			else
			{	//u killed a friendly tank
				arcademode_assignpoints( "arcademode_score_tank_friendly", attacker );
			}
			arcadeModePointsRewarded = true;
		}

		if (IsDefined(self))
		{
			self lights_off();
			self sirens_off();
			self interior_lights_off();
		}
	
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// some tank and turret cleanup
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

		// MIKED TODO: Do we need this since it's on the clientside??
		if( IsDefined( rumbletrigger ) )
		{
			rumbletrigger delete();
		}
	
		if( IsDefined( mgturret ) )
		{
			array_levelthread( mgturret, ::turret_deleteme );
			mgturret = undefined;
		}

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		if( IsDefined( vteam ) )
		{
			level.vehicles[ vteam ] = array_remove( level.vehicles[ vteam ], self );
		}

		if ( IsDefined( script_linkname ) )
		{
			level.vehicle_link[ script_linkname ] = array_remove( level.vehicle_link[ script_linkname ], self );
		}

		if( IsDefined( targetname ) )
		{
			level.vehicle_target[ targetname ] = array_remove( level.vehicle_target[ targetname ], self );
		}
	
		if( IsDefined( self.script_VehicleSpawngroup ) )
		{
			level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ] = array_remove( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ], self );
		}
	
		if( IsDefined( self.script_VehicleStartMove ) )
		{
			level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ] = array_remove( level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ], self );
		}
	
		if( IsDefined( self.script_vehicleGroupDelete ) )
		{
			level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ] = array_remove( level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ], self );
		}
		
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
			
		// if vehicle is gone then delete the ai here.
		if( !IsDefined( self ) || is_corpse() )
		{
			if ( IsDefined( self.riders ) )
			{
				for ( j = 0; j < self.riders.size; j++ )
				{
					if ( IsDefined( self.riders[ j ] ) )
					{
						self.riders[ j ] delete();
					}
				}
			}

			if( self is_corpse() )
			{
				self.riders = [];
				continue;
			}
			
			self notify( "delete_destructible" );// kills some destructible fxs
			return; 
		}


		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	
		if( IsDefined( level.vehicle_death_thread[ type ] ) )
		{
			thread [[ level.vehicle_death_thread[ type ] ]]();
		}

		if( IsDefined( self.deathquakescale ) && self.deathquakescale > 0 )
		{
			Earthquake( 
				self.deathquakescale, 
				self.deathquakeduration, 
				self.origin, 
				self.deathquakeradius
				);
		}

		thread kill_damage();

		if( !IsDefined( self.destructibledef ) )
		{
			if( IsDefined( self.deathmodel ) && self.deathmodel != "" )
			{
				self thread set_death_model( self.deathmodel, self.modelswapdelay );
			}

			// Do kill_fx if it has not been mantled
			if( (!IsDefined( self.mantled ) || !self.mantled ) && !IsDefined(self.nodeathfx) )
			{
				thread kill_fx();
			}
			
			if( IsDefined( self.delete_on_death ) )
			{
				wait( 0.05 );
				if( !IsDefined( self.dontDisconnectPaths ) )
				{
					self disconnectpaths();
				}
				self freevehicle();
				self.isacorpse = true;
				wait 0.05; 
				self notify( "death_finished" );
				self delete();
				continue;
			}
		}		
		
		// makes riders blow up
		maps\_vehicle_aianim::blowup_riders();
	
		thread kill_badplace( type );

		// I used this for identifying when the players tank kills stuff in libya for dialog
		if( IsDefined( level.vehicle_deathnotify ) && IsDefined( level.vehicle_deathnotify[ self.vehicletype ] ) )
		{
			level notify( level.vehicle_deathnotify[ self.vehicletype ], attacker );
		}	
		// all the vehicles get the same jolt..
		if ( self.classname == "script_vehicle" )
		{
			self thread kill_jolt( type );
		}
	
		if( !IsDefined( self.destructibledef ) )
		{
			if( IsDefined( self.script_crashtypeoverride ) )
			{
				crashtype = self.script_crashtypeoverride; 
			}
			else if( self is_plane() )
			{
				crashtype = "aircraft"; 
			}
			else if(self is_helicopter())
			{
				crashtype = "helicopter"; 
			}
			else if( IsDefined( self.currentnode ) && crash_path_check( self.currentnode ) )
			{
				crashtype = "none"; 
			}
			else
			{
				crashtype = "tank";  // tanks used to be the only vehicle that would stop. legacy nonsense from CoD1
			}
		
			if( crashtype == "aircraft" )
			{
				self thread aircraft_crash();
			}

			if( crashtype == "helicopter" )
			{
				if(IsDefined(self.script_nocorpse))
				{
					// GLocke - Does not drop a physics script model on death
					self thread helicopter_explode();
				}
				else
				{
					self thread helicopter_crash();
				}
			}
		
			if( crashtype == "tank" )
			{
				if( !IsDefined( self.rollingdeath ) )
				{
					self vehicle_setspeed( 0, 25, "Dead" );
				}
				else
				{
					// dpg 3/12/08 removed this. if you need it for something, let someone know
					//self vehicle_setspeed( 8, 25, "Dead rolling out of path intersection" );
					self waittill( "deathrolloff" );
					self vehicle_setspeed( 0, 25, "Dead, finished path intersection" );
				}
				wait .4; 
				self vehicle_setspeed( 0, 10000, "deadstop" );
		
				self notify( "deadstop" );
				if ( !IsDefined( self.dontDisconnectPaths ) )
				{
					self disconnectpaths();
				}
				
				if( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
				{
					self waittill( "animsdone" ); // tankgetout will never get notified if there are no guys getting out
				}
			}
		}
		
		if( IsDefined( self.turretweapon ) && self.turretweapon != "" )
		{
			self clearTurretTarget();
		}
		
		if( IsDefined(self) && (self is_plane() || self is_boat()) )
		{
			if( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
			{
				self waittill( "crash_done" );
			}
		}
		else
		{
			if( IsDefined(self.isphysicsvehicle) && self.isphysicsvehicle )
			{
				//GLocke 2/16/10 - just wait for physics vehicles to get close to 0
				while( IsDefined(self) && self GetSpeedMPH() > 2.0 )
				{
					wait(0.1);
				}
			}
			else
			{
				while( IsDefined( self ) && self getspeedmph() > 0 )
				{
					wait( 0.1 );
				}
			}
		}
	
		self notify( "stop_looping_death_fx" );
		self notify( "death_finished" );
	
		wait( 0.5 ); 
		
		if( is_corpse() )
		{
			continue;
		}
	
		if( IsDefined( self ) )
		{
			while( IsDefined( self.dontfreeme ) && IsDefined(self) )
			{
				wait( .05 );
			}
			
			if( !IsDefined( self ) )
			{
				continue;
			}
			
			// AE 2-18-09: if the player is using it, then spit them out or kill them before freeing the vehicle
			occupants = self GetVehOccupants();
			if(IsDefined(occupants) && occupants.size)
			{
				for(i = 0; i < occupants.size; i++)
				{
					self UseBy(occupants[i]);
				}
			}

			self freevehicle();
			self.isacorpse = true;
			
			if ( self.modeldummyon )
			{
				self hide();
			}
		}
		
		if( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
		{
			self delete();
			continue;
		}
	}
}


is_corpse()
{
	if (IsDefined(self))
	{
		if (is_true(self.isacorpse))
		{
			return true;
		}
		else if ( IsDefined(self.classname) && (self.classname == "script_vehicle_corpse"))
		{
			return true;
		}
	}

	return false;
}

set_death_model( sModel, fDelay )
{
	assert( IsDefined( sModel ) );
	
	if( IsDefined( fDelay ) && ( fDelay > 0 ) )
	{
		wait fDelay;
	}
	
	if(!IsDefined(self))
	{
		return;
	}
	
	eModel = get_dummy();
	
	eModel clearanim( %root, 0 );
	
	if( IsDefined( self ) )
	{
		eModel setmodel( sModel );
		eModel SetVehicleAttachments( 1 );
	}
}


aircraft_crash()
{
	self.crashing = true; 

	if( IsDefined( self.unloading ) )
	{
		while( IsDefined( self.unloading ) )
		{
			wait( 0.05 ); 
		}
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	self thread aircraft_crash_move();
}

helicopter_crash()
{
	self.crashing = true; 

	if( IsDefined( self.unloading ) )
	{
		while( IsDefined( self.unloading ) )
		{
			wait( 0.05 ); 
		}
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	level thread helicopter_crash_move(self);
}

helicopter_explode()
{	
	fx_origin = self GetTagOrigin(self.kill_fx_struct.tag);
	PlayFx( self.kill_fx_struct.effect, fx_origin );
	self Delete();
}

get_unused_crash_locations()
{
	unusedLocations = [];
	for ( i = 0; i < level.helicopter_crash_locations.size; i++ )
	{
		if ( IsDefined( level.helicopter_crash_locations[ i ].claimed ) )
		{
			continue; 
		}
		unusedLocations[ unusedLocations.size ] = level.helicopter_crash_locations[ i ]; 
	}
	return unusedLocations;
}

aircraft_crash_move()
{
	self endon( "death" );

	// MikeD (7/30/2007): TODO: Will need something better, like splines?

	forward 	= AnglesToForward( self.angles + ( 45, 0, 0 ) );
	dest_point 	= self.origin + vector_scale( forward, 10000 );

	dest_point = ( dest_point[0], dest_point[1], -700 );

	self SetSpeed( 300, 30 );
	self SetNearGoalNotifyDist( 300 );
	self SetVehGoalPos( dest_point, 1 );
	self waittill_any( "goal", "near_goal" );

	self notify( "crash_done" );
}

helicopter_crash_move(heli)
{
	// swap the model for a script_model and put into physics
	death_model = heli.deathmodel;
	death_org = heli.origin;
	death_angles = heli.angles;
	
	death_heli = Spawn("script_model", death_org);
	death_heli SetModel(death_model);
	death_heli.angles = death_angles;
	death_heli PhysicsLaunch(death_heli.origin, (200, 0, 0));
	if (isDefined(heli.kill_fx_struct.effect) && isDefined(heli.kill_fx_struct.tag) )
	{
		PlayFxOnTag( heli.kill_fx_struct.effect, death_heli, heli.kill_fx_struct.tag );
	}
	
	heli Delete();
}

crash_path_check( node )
{
	 // find a crashnode on the current path
	 // this only works on ground info_vehicle_node vheicles. not dynamic helicopter script_origin paths. they have their own dynamic crashing.
	targ = node; 
	search_depth = 5;

	while( IsDefined( targ ) && search_depth >= 0 )
	{
		if( ( IsDefined( targ.detoured ) ) && ( targ.detoured == 0 ) )
		{
			detourpath = path_detour_get_detourpath( getvehiclenode( targ.target, "targetname" ) );
			if( IsDefined( detourpath ) && IsDefined( detourpath.script_crashtype ) )
			{
	 			return true; 
	 		}
		}
		if( IsDefined( targ.target ) )
		{
			// Edited for the case of nodes targetting eachother for looping paths 1/30/08 TFlame
			targ1 = getvehiclenode( targ.target, "targetname" );
			if (IsDefined(targ1) && IsDefined(targ1.target) && IsDefined(targ.targetname) && targ1.target == targ.targetname)
			{
				return false;
			}
			else if (IsDefined(targ1) && targ1 == node) // circular case -AP 1/15/09
			{
				return false;
			}
			else 
			{
				targ = targ1;
			}
			
		}
		else
		{
			targ = undefined; 
		}

		search_depth--;
	}
	return false; 

}

death_firesound( sound )
{
	self thread play_loop_sound_on_tag( sound, undefined, false );
	self waittill_any( "fire_extinguish", "stop_crash_loop_sound" );
	if ( !IsDefined( self ) )
	{
		return;
	}
	self notify( "stop sound" + sound );
}

kill_fx()
{
	 // going to use vehicletypes for identifying a vehicles association with effects.
	 // will add new vehicle types if vehicle is different enough that it needs to use
	 // different effect. also handles the sound
	if( self isdestructible() )
	{
		return;
	}
	level notify( "vehicle_explosion", self.origin );
	self explode_notify_wrapper();

// commented out until I get multiple deathFx support in -AP 1/14/09
//	for( i = 0; i < level.vehicle_death_fx[ type ].size; i++ )
//	{
		struct = build_death_fx( self.deathfx, self.deathfxtag, self.deathfxsound  );//, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
		thread kill_fx_thread( struct );
//	}
}


/* 
============= 
///ScriptDocBegin
"Name: vehicle_flag_arrived( <msg> )"
"Summary: Script waits until the vehicle hits the node that has script_flag_wait with this msg"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <msg> :  The flag"
"Example: heli vehicle_flag_arrived( "surrender_to_me" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

vehicle_flag_arrived( msg )
{
	if ( !IsDefined( self.vehicle_flags ) )
	{
		self.vehicle_flags = [];
	}

	while ( !IsDefined( self.vehicle_flags[ msg ] ) )
	{
		self waittill( "vehicle_flag_arrived", notifymsg );
		if ( msg == notifymsg )
		{
			return;
		}
	}
}


kill_fx_thread( struct )
{
	assert( IsDefined( struct ) );
	if( IsDefined( struct.waitDelay ) )
	{
		if( struct.waitDelay >= 0 )
		{
			wait struct.waitDelay; 
		}
		else
		{
			self waittill( "death_finished" );
		}
	}
	
	if ( !IsDefined( self ) )
	{
		// self may have been removed during the wait
		return;
	}
	
	if( self is_helicopter() )
	{
		// helicopter swap out to a new model that crashes, so the kill_fx is played in helicopter_crash_move()
		self.kill_fx_struct = struct;
		return;
	}

	if( IsDefined( struct.notifyString ) )
	{
		self notify( struct.notifyString );
	}

	eModel = get_dummy();
	if( IsDefined( struct.effect ) )
	{
		if( ( struct.bEffectLooping ) && ( !IsDefined( self.delete_on_death ) ) )
		{
			if( IsDefined( struct.tag ) )
			{
				if( ( IsDefined( struct.stayontag ) ) && ( struct.stayontag == true ) )
				{
					thread loop_fx_on_vehicle_tag( struct.effect, struct.delay, struct.tag );
				}
				else
				{
					thread playLoopedFxontag( struct.effect, struct.delay, struct.tag );
				}
			}
			else
			{
				forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin; 
				playfx( struct.effect, eModel.origin, forward );
			}
		}
		else if( IsDefined( struct.tag ) )
		{
			if ( IsDefined(self.modeldummyon) && self.modeldummyon )
			{
				playfxontag( struct.effect, deathfx_ent(), struct.tag );
			}
			else
			{
				playfxontag( struct.effect, self, struct.tag );
			}
		}
		else
		{
			forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin; 
			playfx( struct.effect, eModel.origin, forward );
		}
	}

	if( ( IsDefined( struct.sound ) ) && ( !IsDefined( self.delete_on_death ) ) )
	{
		if( struct.bSoundlooping )
		{
			thread death_firesound( struct.sound );
		}
		else
		{
			self play_sound_in_space( struct.sound );
		}
	}
}

loop_fx_on_vehicle_tag( effect, loopTime, tag )
{
	assert( IsDefined( effect ) );
	assert( IsDefined( tag ) );
	assert( IsDefined( loopTime ) );

	self endon( "stop_looping_death_fx" );

	while( IsDefined( self ) )
	{
		playfxontag( effect, deathfx_ent(), tag );
		wait loopTime; 
	}
}

build_death_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
{
	if( !IsDefined( bSoundlooping ) )
	{
		bSoundlooping = false; 
	}
	if( !IsDefined( bEffectLooping ) )
	{
		bEffectLooping = false; 
	}
	if( !IsDefined( delay ) )
	{
		delay = 1; 
	}
	struct = spawnstruct();
	struct.effect = effect;
	struct.tag = tag; 
	struct.sound = sound; 
	struct.bSoundlooping = bSoundlooping; 
	struct.delay = delay; 
	struct.waitDelay = waitDelay; 
	struct.stayontag = stayontag; 
	struct.notifyString = notifyString; 
	struct.bEffectLooping = bEffectLooping; 
	return struct; 
}

get_script_modelvehicles()
{
	array = []; 
	models = getentarray( "script_model", "classname" );

	if ( IsDefined( level.modelvehicles ) )
	{
		return level.modelvehicles;
	}

	level.modelvehicles = [];
	
	for( i = 0; i < models.size; i++ )
	{
		if( IsDefined( models[ i ].targetname ) 
				 && ( models[ i ].targetname == "destructible" 
				 || models[ i ].targetname == "zpu"  
				 || models[ i ].targetname == "exploder" ) )
		{
				continue; 
		}
		if( IsDefined( models[ i ].script_noteworthy ) && models[ i ].script_noteworthy == "notvehicle" )
		{
			continue; 
		}
		if( maps\_vehicletypes::is_type( models[ i ].model ) ) 
		{
			array[ array.size ] = models[ i ]; 
			models[ i ].vehicletype = maps\_vehicletypes::get_type( models[ i ].model );			
		}
	}
			
	level.modelvehicles = array;
	return level.modelvehicles; 
}

precache_scripts()
{
	 // find all the vehicles in the level and initialize precaching( calling of vehicles main() mostly )
	vehicles = getentarray( "script_vehicle", "classname" );
	vehicles = array_combine( vehicles, get_script_modelvehicles() );

	playerdrivablevehicles = []; 
	allvehiclesprespawn = []; 

	for( i = 0; i < vehicles.size; i++ )
	{
		//vehicles[ i ].vehicletype = tolower( vehicles[ i ].vehicletype );
		
		if (vehicles[ i ] has_spawnflag(level.SPAWNFLAG_VEHICLE_USEABLE))
		{
			playerdrivablevehicles[ playerdrivablevehicles.size ] = vehicles[ i ]; 
		}

		allvehiclesprespawn[ allvehiclesprespawn.size ] = vehicles[ i ];
	}

	if( playerdrivablevehicles.size > 0 )
	{
		thread maps\_vehicledrive::main(); // precache driveable vehicle huds and such.
	}
	return allvehiclesprespawn; 
}


vehicle_modelinarray( arrayofmodels, model )
{
	for( i = 0; i < arrayofmodels.size; i++ )
	{
		if( arrayofmodels[ i ] == model )
		{
			return true; 
		}
	}
	return false; 
}

vehicle_kill_disconnect_paths_forever()
{
	self notify( "kill_disconnect_paths_forever" );
}

disconnect_paths_whenstopped()
{
	
	self endon( "death" );
	self endon( "kill_disconnect_paths_forever" );
	if ( IsDefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
	{
		self.dontDisconnectPaths = true;// lets other parts of the script know not to disconnect script
		return;		
	}
	wait( randomfloat( 1 ) );
	while( IsDefined( self ) )
	{
		if( self getspeed() < 1 )
		{
			if ( !IsDefined( self.dontDisconnectPaths ) )
			{
				self disconnectpaths();
			}
			self notify( "speed_zero_path_disconnect" );
			while( self getspeed() < 1 )
			{
				wait( 0.05 ); 
			}
		}
		self connectpaths();
		wait( 1 ); 
	}
}

vehicle_setspeed( speed, rate, msg )
{
	if( self getspeedmph() ==  0 && speed == 0 )
	{
		return;  // potential for disaster? keeps messages from overriding previous messages
	}

	 /#
	self thread debug_vehiclesetspeed( speed, rate, msg );
	#/ 
	self setspeed( speed, rate );
}

debug_vehiclesetspeed( speed, rate, msg )
{
	 /#
	self notify( "new debug_vehiclesetspeed" );
	self endon( "new debug_vehiclesetspeed" );
	self endon( "resuming speed" );
	self endon( "death" );
	while( 1 )
	{
		while( GetDvar( #"debug_vehiclesetspeed" ) != "off" )
		{
			print3d( self.origin + ( 0, 0, 192 ), "vehicle setspeed: " + msg, ( 1, 1, 1 ), 1, 3 );
			wait .05; 
		}
		wait .5; 
	}
	#/ 
}

script_resumespeed( msg, rate )
{
	self endon( "death" );
	fSetspeed = 0; 
	type = "resumespeed"; 
	if( !IsDefined( self.resumemsgs ) )
	{
		self.resumemsgs = []; 
	}
	if( IsDefined( self.waitingforgate ) && self.waitingforgate )
	{
		return; // ignore resumespeeds on waiting for gate.
	}

	if( IsDefined( self.attacking ) && self.attacking )
	{
		fSetspeed = self.attackspeed; 
		type = "setspeed"; 
	}

	self.zerospeed = false; 
	if( fSetspeed == 0 )
	{
		self.zerospeed = true; 
	}
	if( type == "resumespeed" )
	{
		self resumespeed( rate );
	}
	else if( type == "setspeed" )
	{
		self vehicle_setspeed( fSetspeed, 15, "resume setspeed from attack" );
	}
	self notify( "resuming speed" );
	/# self thread debug_vehicleresume( msg + " :" + type ); #/

}

/#
debug_vehicleresume( msg )
{
	if( GetDvar( #"debug_vehicleresume" ) == "off" )
	{
		return; 
	}
	self endon( "death" );
	number = self.resumemsgs.size; 
	self.resumemsgs[ number ] = msg; 
	timer = 3; 
	self thread print_resumespeed( gettime() + ( timer * 1000 ) );

	wait timer; 
	newarray = []; 
	for( i = 0; i < self.resumemsgs.size; i++ )
	{
		if( i != number )
		{
			newarray[ newarray.size ] = self.resumemsgs[ i ]; 
		}
	}
	self.resumemsgs =  newarray; 
}
#/

print_resumespeed( timer )
{
	self notify( "newresumespeedmsag" );
	self endon( "newresumespeedmsag" );
	self endon( "death" );
	while( gettime() < timer && IsDefined( self.resumemsgs ) )
	{
		if( self.resumemsgs.size > 6 )
		{
			start = self.resumemsgs.size - 5; 
		}
		else
		{
			start = 0; 
		}
		for( i = start; i < self.resumemsgs.size; i++ )  // only display last 5 messages
		{
			position = i * 32; 
			print3d( self.origin + ( 0, 0, position ), "resuming speed: " + self.resumemsgs[ i ], ( 0, 1, 0 ), 1, 3 );
		}
		wait .05; 
	}
}

/#
vclogin_vehicles()
{
	if( GetDvar( #"vclogin_vehicles" ) == "off" )
	{
		return; 
	}

	precachemodel( "vehicle_blackhawk" );
	level.vclogin_vehicles = 1;

	vehicles = getentarray( "script_vehicle", "classname" );
	for( i = 0; i < vehicles.size; i++ )
	{
		vehicles[ i ] delete();
	}

	paths = GetAllVehicleNodes();
	for( i = 0; i < paths.size; i++ )
	{
		if( !paths[i] has_spawnflag(level.SPAWNFLAG_START_NODE) )
		{
			crashtype = paths[ i ].script_crashtype; 
			if( !IsDefined( crashtype ) )
			{
				crashtype = "default"; 
			}
			if( crashtype == "plane" )
			{
				vehicle = spawnVehicle( "vehicle_blackhawk", "vclogger", "blackhawk", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			}
			else
			{
				vehicle = spawnVehicle( "vehicle_blackhawk", "vclogger", "blackhawk", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			}
			vehicle attachpath( paths[ i ] );

			// SCRIPTER_MOD: JesseS (8/10/2007): removed level.player references
			if( IsDefined( vehicle.model ) && vehicle.model == "vehicle_blackhawk" )
			{
				tagorg = vehicle gettagorigin( "tag_bigbomb" );
				get_players()[0] setorigin( tagorg );
				get_players()[0] playerLinkTodelta( vehicle, "tag_bigbomb", 1.0 );
			}
			else
			{
				tagorg = vehicle gettagorigin( "tag_player" );
				get_players()[0] setorigin( tagorg );
				get_players()[0] playerLinkToDelta( vehicle, "tag_player", 0.1 );
			}


			vehicle startpath();
			vehicle.zerospeed = false;
			vehicle waittill( "reached_end_node" );
			get_players()[0] unlink();
			vehicle delete();
			crashtype = undefined;
		}
	}

	level waittill( "never" ); // map needs to be restarted at this point
}

#/

godon()
{
	self.takedamage = false; 
}

godoff()
{
	self.takedamage = true;
}

setturretfireondrones( b )
{
	if( IsDefined( self.mgturret ) && self.mgturret.size )
	{
		for( i = 0; i < self.mgturret.size; i++ )
		{
			self.mgturret[ i ].script_fireondrones = b; 
		}
	}
}

getnormalanimtime( animation )
{
	animtime = self getanimtime( animation );
	animlength = getanimlength( animation );
	if( animtime == 0 )
	{
		return 0; 
	}
	return self getanimtime( animation ) / getanimlength( animation );
}

rotor_anim()
{
	length = getanimlength( self getanim( "rotors" ) );
	for ( ;; )
	{
		self setanim( self getanim( "rotors" ), 1, 0, 1 );
		wait( length );
	}
}

animate_drive_idle()
{
	if( !IsDefined( self.wheeldir ) )
	{
		self.wheeldir = 1; 
	}

	model = self.model; 
	
	if( IsDefined( self.isphysicsvehicle ) && self.isphysicsvehicle )
	{
		return;
	}
	
	if( !IsDefined( level.vehicle_DriveIdle[ model ] ) )
	{
		return; 
	}

	newanimtime = undefined;
	
	if( !IsDefined( level.vehicle_DriveIdle_r[ model ] ) )
	{
		level.vehicle_DriveIdle_r[ model ] = level.vehicle_DriveIdle[ model ];  // use forward animation if no backwards anim exists
	}
	self endon( "death" );
	normalspeed = level.vehicle_DriveIdle_normal_speed[ model ]; 

	thread animate_drive_idle_death();

	animrate = 1.0; 
	if( ( IsDefined( level.vehicle_DriveIdle_animrate ) ) && ( IsDefined( level.vehicle_DriveIdle_animrate[ model ] ) ) )
	{
		animrate = level.vehicle_DriveIdle_animrate[ model ]; 
	}

	lastdir = self.wheeldir; 

	animatemodel = self; 
	animation = level.vehicle_DriveIdle[ model ]; 

	while( 1 )
	{
		if( !normalspeed )
		{
				 // vehicles like helicopters always play the same rate. will come up with better design if need arises.
				animatemodel setanim( level.vehicle_DriveIdle[ model ], 1, .2, animrate );
				thread animtimer( .5 );
				self waittill( "animtimer" );
				continue; 
		}

		speed = self getspeedmph();

		if( lastdir != self.wheeldir )
		{
			dif = 0; 
			if( self.wheeldir )
			{
				animation = level.vehicle_DriveIdle [ model ]; 
				dif = 1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle_r [ model ] );
				animatemodel clearanim( level.vehicle_DriveIdle_r [ model ], 0 );
			}
			else
			{
				animation = level.vehicle_DriveIdle_r[ model ];  // reverse direction
				dif  =  1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle [ model ] );
				animatemodel clearanim( level.vehicle_DriveIdle[ model ], 0 );
			}

			newanimtime = 0.01; 
			if( newanimtime >= 1 || newanimtime == 0 )
			{
				newanimtime = 0.01; // think setting animtime to 0 or 1 messes things up
			}
			lastdir = self.wheeldir; 
		}

		if( speed == 0 )
		{
			animatemodel setanim( animation, 1, .2, 0 );
		}
		else
		{
			animatemodel setanim( animation, 1, .2, speed / normalspeed );
		}

		if( IsDefined( newanimtime ) )
		{
			animatemodel setanimtime( animation, newanimtime );
			newanimtime = undefined; 
		}

		thread animtimer( .2 );
		self waittill( "animtimer" );
	}
}

animtimer( time )
{
	self endon( "animtimer" );
	wait time; 
	self notify( "animtimer" );
}

animate_drive_idle_death()
{
	model = self.model; 
	self UseAnimTree( #animtree );
	self waittill( "death_finished" );
	if( IsDefined( self ) )
	{
		self clearanim( level.vehicle_DriveIdle[ model ], 0 );
	}
}

setup_dynamic_detour( pathnode , get_func )
{
	prevnode = [[ get_func ]]( pathnode.targetname );
	assertex( IsDefined( prevnode ), "detour can't be on start node" );
	prevnode.detoured = 0; 
}

 /* 
setup_origins()
{
	triggers = []; 
	origins = getentarray( "script_origin", "classname" );
	for( i = 0; i < origins.size; i++ )
	{
		if( IsDefined( origins[ i ].script_vehicledetour ) )
		{

			level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, origins[ i ].script_vehicledetour, origins[ i ] );
			if( level.vehicle_detourpaths[ origins[ i ].script_vehicledetour ].size > 2 )
				println( "more than two script_vehicledetour grouped in group number: ", origins[ i ].script_vehicledetour );

			prevnode = getent( origins[ i ].targetname, "target" );
			assertex( IsDefined( prevnode ), "detour can't be on start node" );
			triggers[ triggers.size ] = prevnode; 
			prevnode.detoured = 0; 
			prevnode = undefined; 
		}
	}
	return triggers; 
}
 */ 

setup_ai()
{
	ai = getaiarray();
	for( i = 0; i < ai.size; i++ )
	{
		if( IsDefined( ai[ i ].script_vehicleride ) )
		{
			level.vehicle_RideAI = array_2dadd( level.vehicle_RideAI, ai[ i ].script_vehicleride, ai[ i ] );
		}
		else if( IsDefined( ai[ i ].script_vehiclewalk ) )
		{
			level.vehicle_WalkAI = array_2dadd( level.vehicle_WalkAI, ai[ i ].script_vehiclewalk, ai[ i ] );
		}
	}
	ai = getspawnerarray();

	for( i = 0; i < ai.size; i++ )
	{
		if( IsDefined( ai[ i ].script_vehicleride ) )
		{
			level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, ai[ i ].script_vehicleride, ai[ i ] );
		}
		if( IsDefined( ai[ i ].script_vehiclewalk ) )
		{
			level.vehicle_walkspawners = array_2dadd( level.vehicle_walkspawners, ai[ i ].script_vehiclewalk, ai[ i ] );
		}
	}
}

array_2dadd( array, firstelem, newelem )
{
	if( !IsDefined( array[ firstelem ] ) )
	{
		array[ firstelem ] = []; 
	}
	array[ firstelem ][ array[ firstelem ].size ] = newelem; 
	return array; 
}

is_node_script_origin( pathnode )
{
	return IsDefined( pathnode.classname ) && pathnode.classname == "script_origin"; 
}

// this determines if the node will be sent through trigger_process.  The uber trigger function that may get phased out.
node_trigger_process()
{
	processtrigger = false; 

	// special treatment for start nodes
	if( self has_spawnflag( level.SPAWNFLAG_VEHICLE_NODE_START_NODE ) )
	{
		if( IsDefined( self.script_crashtype ) )
		{
			level.vehicle_crashpaths[ level.vehicle_crashpaths.size ] = self; 
		}
		level.vehicle_startnodes[ level.vehicle_startnodes.size ] = self; 
	}

	if( IsDefined( self.script_vehicledetour ) && IsDefined( self.targetname ) )
	{
		get_func = undefined;
		// get_func is differnt for struct types and script_origin types of paths
		if( IsDefined( get_from_entity( self.targetname ) ) )
		{
			get_func = ::get_from_entity_target;
		}
		if( IsDefined( get_from_spawnstruct( self.targetname ) ) )
		{
			get_func = ::get_from_spawnstruct_target;
		}

		if( IsDefined( get_func ) )
		{
			setup_dynamic_detour( self, get_func );
			processtrigger = true;  // the node with the script_vehicledetour waits for the trigger here unlike ground nodes which need to know 1 node in advanced that there's a detour, tricky tricky.
		}
		else
		{
			setup_groundnode_detour( self ); // other trickery.  the node is set to process in there.
		}

		level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, self.script_vehicledetour, self );
		if( level.vehicle_detourpaths[ self.script_vehicledetour ].size > 2 )
		{
			println( "more than two script_vehicledetour grouped in group number: ", self.script_vehicledetour );
		}
	}

	// if a gate isn't open then the vehicle will stop there and wait for it to become open.
	if( IsDefined( self.script_gatetrigger ) )
	{
		level.vehicle_gatetrigger = array_2dadd( level.vehicle_gatetrigger, self.script_gatetrigger, self );
		self.gateopen = false; 
	}

	// init the flags! 
	if ( IsDefined( self.script_flag_set ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_set ] ) )
		{
			flag_init( self.script_flag_set );
		}
	}

	// init the flags! 
	if ( IsDefined( self.script_flag_clear ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_clear ] ) )
		{
			flag_init( self.script_flag_clear );
		}
	}

	if( IsDefined( self.script_flag_wait ) )
	{
		if ( !IsDefined( level.flag[ self.script_flag_wait ] ) )
		{
			flag_init( self.script_flag_wait );
		}
	}

	// various nodes that will be sent through trigger_process
	if (IsDefined( self.script_VehicleSpawngroup )
		|| IsDefined( self.script_VehicleStartMove )
		|| IsDefined( self.script_gatetrigger )
		|| IsDefined( self.script_Vehiclegroupdelete ))
	{
		processtrigger = true; 
	}

	if( processtrigger )
	{
		add_proccess_trigger( self );
	}
}

setup_triggers()
{
	 // TODO: move this to _load under the triggers section.  larger task than this simple cleanup.

	 // the processtriggers array is all the triggers and vehicle node triggers to be put through
	 // the trigger_process function.   This is so that I only do a waittill trigger once
	 // in script to assure better sequencing on a multi - function trigger.

	 // some of the vehiclenodes don't need to waittill trigger on anything and are here only
	 // for being linked with other trigger

	level.vehicle_processtriggers = []; 

	triggers = [];
	triggers = array_combine( getallvehiclenodes(), getentarray( "script_origin", "classname" ) );
	triggers = array_combine( triggers, level.struct );
	triggers = array_combine( triggers, getentarray( "trigger_radius", "classname" ) );
	triggers = array_combine( triggers, getentarray( "trigger_multiple", "classname" ) );
	triggers = array_combine( triggers, getentarray( "trigger_lookat", "classname" ) );
	
	array_thread( triggers, ::node_trigger_process );
	
}

is_node_script_struct( node )
{
	if( ! IsDefined( node.targetname ) )
	{
		return false;
	}
	return IsDefined( getstruct( node.targetname, "targetname" ) );
}

setup_vehicles( allvehiclesprespawn )
{
 // 	vehicles = getentarray( "script_vehicle", "classname" );
	
 // old setup required targetname. blahrg
 // 	vehicles = array_combine( vehicles, getentarray( "vehiclespawnmodel", "targetname" ) );


	 // this could be dangerous but lets give it a try and see what happesn.. yeehaw! - Nate
 // 	vehicles = array_combine( vehicles, getentarray( "script_model", "classname" ) );
	
	vehicles = allvehiclesprespawn; 
	
	spawnvehicles = []; 
	groups = []; 
	nonspawned = []; 

	for( i = 0; i < vehicles.size; i++ )
	{
		vehicles[ i ] vehicle_load_assets();
		
		if( vehicles[ i ] has_spawnflag(level.SPAWNFLAG_VEHICLE_SPAWNER) )
		{
			AssertEX(IsDefined(vehicles[i].script_vehiclespawngroup), "Vehicle of type: " + vehicles[i].vehicletype + " has SPAWNER flag set, but is not part of a script_vehiclespawngroup or doesn't have a targetname." );
		}

		if( IsDefined( vehicles[ i ].script_vehiclespawngroup ) )
		{
			if( !IsDefined( spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ] ) )
			{
				spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ] = []; 
			}

			spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ]
			[ spawnvehicles[ vehicles[ i ].script_vehiclespawngroup ].size ] = vehicles[ i ]; 
			addgroup[ 0 ] = vehicles[ i ].script_vehiclespawngroup; 
			groups = array_merge( groups, addgroup );
			continue; 
		}
 // 		else if( vehicles[ i ].classname == "script_vehicle" )
		else 
		{
			nonspawned[ nonspawned.size ] = vehicles[ i ]; 
		}
	}

	for( i = 0; i < groups.size; i++ )
	{
		thread spawner_setup( spawnvehicles[ groups[ i ] ], groups[ i ], "main" );
	}

	 // init vehicles that aren't spawned
	for( i = 0; i < nonspawned.size; i++ )
	{
		thread vehicle_init( nonspawned[ i ] );
	}
}

vehicle_life()
{
	if (IsDefined(self.destructibledef))
	{
		self.health = 99999;
	}
	else
	{
		type = self.vehicletype; 

		if( !IsDefined( self.healthdefault ) )
		{
			wait 2; 
		}

		assertEX( IsDefined( self.healthdefault ), "need to specify health settings in vehicle gdt for vehicletype: " + type );

		if( IsDefined( self.script_startinghealth ) )
		{
			self.health = self.script_startinghealth; 
		}
		else
		{
			if( self.healthdefault == -1 )
			{
				return; 
			}
			else if( IsDefined( self.healthmin ) && IsDefined( self.healthmax ) && (self.healthmax - self.healthmin) > 0 )
			{
				self.health  = ( randomint( self.healthmax - self.healthmin ) + self.healthmin );
				println("set range health: " + self.health);
			}
			else
			{
				self.health = self.healthdefault; 
				println("set health: " + self.health);
			}
		}
		
		//	if( IsDefined( level.destructible_model[ self.model ] ) )
		//	{
		//		self.health = 2000;
		//		self.destructible_type = level.destructible_model[ self.model ]; 
		//		self maps\_destructible::setup_destructibles( true );
		//	}
	}
}

vehicle_load_assets()
{
	// vehicle
	precachevehicle( self.vehicletype );

	// model
	precachemodel( self.model );
	
	precache_extra_models(); //GLOCKE: moved TFlame's temp solution to a new function so it could be specified by vehicle type

	// death model
	if( IsDefined(self.deathmodel) && self.deathmodel != "" )
	{
		// 6/7/2010 - TFLAME - Added support for no deathmodel needing to be loaded , if desired
		precache_death_model_wrapper( self.deathmodel );
	}

	// shoot shock
	if( IsDefined(self.shootshock) && self.shootshock != "" )
	{
		precacheShader( "black" );
		precacheShellShock( self.shootshock );
	}

	// shoot rumble
	if( IsDefined(self.shootrumble) && self.shootrumble != "" )
	{
		PrecacheRumble( self.shootrumble );
	}

	// rumble
	if( IsDefined( self.rumbletype ) && self.rumbletype != "" )
	{
		precacherumble( self.rumbletype );
	}	

	// secondary turrets
	if( IsDefined(self.secturrettype) && self.secturrettype != "" )
	{
		precacheturret( self.secturrettype );
	}

	if( IsDefined(self.secturretmodel) && self.secturretmodel != "" )
	{
		precachemodel( self.secturretmodel );
	}

	self vehicle_load_fx();

}


precache_death_model_wrapper( death_model_name )
{
	if (!IsDefined(self.script_string) || (IsDefined(self.script_string) && self.script_string != "no_deathmodel") )
	{
		PrecacheModel( death_model_name );
	}			
}

precache_extra_models()
{
	switch( self.vehicletype )	// Don't judge me :)
	{
		case "heli_huey":
		case "heli_huey_player":
		case "heli_huey_small":
		case "heli_huey_heavyhog":
		case "heli_huey_heavyhog_creek":
		case "heli_huey_usmc_heavyhog_khesanh":	
		case "heli_huey_medivac":
		case "heli_huey_medivac_khesanh":
		case "heli_huey_gunship":
		case "heli_huey_assault":
		case "heli_huey_usmc":
		case "heli_huey_usmc_khesanh":
		case "heli_huey_usmc_khesanh_std":
		case "heli_huey_side_minigun":
		case "heli_huey_side_minigun_uwb":
			self maps\_huey::precache_submodels();
			break;
		
		case "heli_hind_player":
			self maps\_hind_player::precache_models();
			self maps\_hind_player::precache_weapons();
			self maps\_hind_player::precache_hud();
		break;
		
		case "truck_gaz63_camorack":
			PrecacheModel("t5_veh_truck_gaz63_camo_rack");
			break;
			
		case "truck_gaz63_canvas":
		case "truck_gaz66_canvas":
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			PrecacheModel("t5_veh_gaz66_canvas");
			PrecacheModel("t5_veh_gaz66_canvas_dead");
			break;
			
		case "truck_gaz63_canvas_camorack":
			PrecacheModel("t5_veh_gaz66_troops");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			PrecacheModel("t5_veh_gaz66_canvas");
			PrecacheModel("t5_veh_gaz66_canvas_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_canvas");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_dead");
			break;
		
		case "truck_gaz63_flatbed":
		case "truck_gaz66_flatbed":
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;
			
		case "truck_gaz63_flatbed_camorack":
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_dead");
			break;
		
		case "truck_gaz63_tanker":
		case "truck_gaz66_tanker":
		case "truck_gaz66_tanker_physics":
			PrecacheModel("t5_veh_gaz66_tanker");
			precache_death_model_wrapper("t5_veh_gaz66_tanker_dead"); // check added for no_deathmodel - PeterL 083010(BETA)
			break;
		
		case "truck_gaz63_troops":
		case "truck_gaz66_troops":
		case "truck_gaz66_troops_physics":
		case "truck_gaz63_troops_bulletdamage":
			PrecacheModel("t5_veh_gaz66_troops");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			break;
			
		case "truck_gaz63_troops_camorack":
			PrecacheModel("t5_veh_gaz66_troops");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_dead");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back");
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_back_dead");
			break;
			
		case "truck_gaz66_troops_attacking_physics":
		
			PrecacheModel("t5_veh_gaz66_troops_no_benches");
			PrecacheModel("t5_veh_gaz66_troops_dead");
			break;	
			
		
		case "truck_gaz63_single50":
		case "truck_gaz66_single50":
			PrecacheModel("t5_veh_gaz66_single50");
			PrecacheModel("t5_veh_gaz66_single50_dead");
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;
			
		case "truck_gaz63_player_single50":
		case "truck_gaz63_player_single50_physics":
		case "truck_gaz66_player_single50":
		case "truck_gaz63_player_single50_bulletdamage":
			PrecacheModel("t5_veh_gunner_turret_enemy_50cal");
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;	
		
		case "truck_gaz63_player_single50_nodeath":
			PrecacheModel("t5_veh_gunner_turret_enemy_50cal");
			PrecacheModel("t5_veh_gaz66_flatbed");
			break;	
						
		case "truck_gaz63_quad50":
		case "truck_gaz66_quad50":
			PrecacheModel("t5_veh_gaz66_quad50");
			PrecacheModel("t5_veh_gaz66_quad50_dead");
			PrecacheModel("t5_veh_gaz66_flatbed");
			PrecacheModel("t5_veh_gaz66_flatbed_dead");
			break;
		
		case "truck_gaz63_camorack_low":
			PrecacheModel("t5_veh_truck_gaz63_camo_rack_low");
			break;
			
		case "truck_gaz63_canvas_low":
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			PrecacheModel("t5_veh_gaz66_canvas_low");
			PrecacheModel("t5_veh_gaz66_canvas_dead_low");
			break;
		
		case "truck_gaz63_flatbed_low":
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			break;
		
		case "truck_gaz63_tanker_low":
			PrecacheModel("t5_veh_gaz66_tanker_low");
			PrecacheModel("t5_veh_gaz66_tanker_dead_low");
			break;
		
		case "truck_gaz63_troops_low":
			PrecacheModel("t5_veh_gaz66_troops_low");
			PrecacheModel("t5_veh_gaz66_troops_dead_low");
			break;
		
		case "truck_gaz63_single50_low":
			PrecacheModel("t5_veh_gaz66_single50_low");
			PrecacheModel("t5_veh_gaz66_single50_dead_low");
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			break;
		
		case "truck_gaz63_quad50_low":
			PrecacheModel("t5_veh_gaz66_quad50_low");
			PrecacheModel("t5_veh_gaz66_quad50_dead_low");
			PrecacheModel("t5_veh_gaz66_flatbed_low");
			PrecacheModel("t5_veh_gaz66_flatbed_dead_low");
			break;
			
		case "truck_gaz63_quad50_low_no_deathmodel":
			PrecacheModel("t5_veh_gaz66_quad50_low");
			break;
			
		case "tank_snowcat_plow":
			precacheModel("t5_veh_snowcat_plow");
			break;

		case "boat_pbr":
			PreCacheModel( "t5_veh_boat_pbr_set01_friendly" );
			PreCacheModel( "t5_veh_boat_pbr_waterbox" );
			break;
			
		case "boat_pbr_player":
			PrecacheModel( "t5_veh_boat_pbr_set01" );
			PrecacheModel( "t5_veh_boat_pbr_stuff" );
			break;

		case "police":
			PrecacheModel( "t5_veh_police_lightbar" );
			break;
	}
}

vehicle_load_fx()
{
	// exhaust fx
	if( IsDefined( self.exhaustfxname ) && self.exhaustfxname != "" )
	{
		self.exhaust_fx = loadfx( self.exhaustfxname ); 
	}

	// tread fx
	maps\_treadfx::loadtreadfx(self);

	// death fx
	if( IsDefined(self.deathfxname) && self.deathfxname != "" )
	{
		self.deathfx = loadfx( self.deathfxname );
	}

	// rotor fx
	if( IsDefined( self.rotorMainRunningFxName ) && self.rotorMainRunningFxName != "" )
	{
		self.rotorMainRunningFx = loadfx( self.rotorMainRunningFxName );
	}

	if( IsDefined( self.rotorTailRunningFxName ) && self.rotorTailRunningFxName != "" )
	{
		self.rotorTailRunningFx = loadfx( self.rotorTailRunningFxName );
	}
	
	if( IsDefined( self.rotorMainIdleFxName ) && self.rotorMainIdleFxName != "" )
	{
		self.rotorMainIdleFx = loadfx( self.rotorMainIdleFxName );
	}

	if( IsDefined( self.rotorTailIdleFxName ) && self.rotorTailIdleFxName != "" )
	{
		self.rotorTailIdleFx = loadfx( self.rotorTailIdleFxName );
	}
	
	if( IsDefined( self.rotorMainStartFxName ) && self.rotorMainStartFxName != "" )
	{
		self.rotorMainStartFx = loadfx( self.rotorMainStartFxName );
	}

	if( IsDefined( self.rotorTailStartFxName ) && self.rotorTailStartFxName != "" )
	{
		self.rotorTailStartFx = loadfx( self.rotorTailStartFxName );
	}

	if( IsDefined( self.rotorMainStopFxName ) && self.rotorMainStopFxName != "" )
	{
		self.rotorMainStopFx = loadfx( self.rotorMainStopFxName );
	}

	if( IsDefined( self.rotorTailStopFxName ) && self.rotorTailStopFxName != "" )
	{
		self.rotorTailStopFx = loadfx( self.rotorTailStopFxName );
	}

	if (is_true(level._vehicle_load_lights))
	{
		// TODO: this stuff really needs to not be hardcoded. We need GDT support.

		if (self.vehicletype == "police")
		{
			self.headlightFX = LoadFX("vehicle/light/fx_cuba_police_headlight");
			self.taillightLeftFX = LoadFX("vehicle/light/fx_cuba_police_taillight_left");
			self.taillightRightFX = LoadFX("vehicle/light/fx_cuba_police_taillight_right");
			self.frontDLightFX = LoadFX("maps/cuba/fx_cuba_veh_front_end_lights");
			self.interiorLightFX = LoadFX("maps/cuba/fx_cuba_veh_interior_lights");
		}
		else if (self.vehicletype == "cuba_player")
		{
			self.taillightFX = LoadFX("vehicle/light/fx_cuba_car_brakelight");
		}
		else
		{
			self.headlightFX = LoadFX( "vehicle/light/fx_jeep_uaz_headlight" );
			self.taillightFX = LoadFX( "vehicle/light/fx_jeep_uaz_taillight" );
		}
	}

	if (is_true(level._vehicle_load_sirens))
	{
		// TODO: these should be specified in the vehicle GDT
		self.sirenlightFX = LoadFX( "maps/cuba/fx_cuba_siren_light" );
	}
}

mginit()
{
	type = self.vehicletype; 

	if( (( IsDefined( self.script_nomg ) ) && ( self.script_nomg > 0 ) ) )
	{
		return; 
	}

	// dpg 3/12/08 removed is_plane()
	if( !IsDefined( self.secturrettype ) || self.secturrettype == "" )
	{
		return; 
	}

	mgangle = 0; 
	if( IsDefined( self.script_mg_angle ) )
	{
		mgangle = self.script_mg_angle; 
	}

// need to add support for multiple secondary turrets -AP 1/15/09
//	for( i = 0; i < turret_template.size; i++ )
//	{
	self.mgturret[ 0 ] = spawnTurret( "misc_turret", ( 0, 0, 0 ), self.secturrettype );
	self.mgturret[ 0 ] linkto( self, self.secturrettag, ( 0, 0, 0 ), ( 0, -1 * mgangle, 0 ) );
	self.mgturret[ 0 ] setmodel( self.secturretmodel );
	//self.mgturret[ 0 ].bAiControlled = self.secturretaicontrolled; // not sure why this was omitted, but it breaks mgon() if used -AP 1/15/09
	self.mgturret[ 0 ].angles = self.angles; 
	self.mgturret[ 0 ].isvehicleattached = true; // lets mgturret know not to mess with this turret
	self.mgturret[ 0 ] thread maps\_mgturret::burst_fire_unmanned();
	self.mgturret[ 0 ] maketurretunusable();
	level thread maps\_mgturret::mg42_setdifficulty( self.mgturret[ 0 ], getdifficulty() );
	if( IsDefined( self.script_fireondrones ) )
	{
		self.mgturret[ 0 ].script_fireondrones = self.script_fireondrones; 
	}
	self.mgturret[ 0 ] setshadowhint( "never" );
	if ( IsDefined( self.secturretdeletedelay ) )
	{
		self.mgturret[ 0 ].deletedelay = self.secturretdeletedelay;
	}
	if( IsDefined( self.secturretdefaultoffmode ) )
	{
		self.mgturret[ 0 ] setmode( self.secturretdefaultoffmode );
	}
	if( IsDefined( self.secturretmaxrange ) )
	{
		self.mgturret[ 0 ].maxrange = self.secturretmaxrange; 
	}
//		if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "onemg" )
//				break; 
//		}

	if( !IsDefined( self.script_turretmg ) )
	{
		self.script_turretmg = true;; 
	}

	if( IsDefined( self.script_turretmg ) && self.script_turretmg == 0 )
	{
		self thread mgoff();
	}
	else
	{
		self.script_turretmg = 1; 
		self thread mgon();
	}

	self thread mgtoggle();
}

mgtoggle()
{
	self endon( "death" );
	if( self.script_turretmg )
	{
		lasttoggle = 1; 
	}
	else
	{
		lasttoggle = 0; 
	}
	while( 1 )
	{
		if( lasttoggle != self.script_turretmg )
		{
			lasttoggle = self.script_turretmg; 
			if( self.script_turretmg )
			{
				self thread mgon();
			}
			else
			{
				self thread mgoff();
			}
		}
		wait .5; 
	}
}

mgoff()
{
	type = self.vehicletype; 
	self.script_turretmg = 0; 

	if( ( self is_plane() ) && ( self hasHelicopterTurret() ) )
	{
		self thread chopper_Turret_Off();
		return; 
	}

	// dpg 7/3/07: if self isn't defined, return
	if( !IsDefined( self ) || !IsDefined( self.mgturret ) )
	{
		return; 
	}
	for( i = 0; i < self.mgturret.size; i++ )
	{
		if( IsDefined( self.mgturret[ i ].script_fireondrones ) )
		{
			self.mgturret[ i ].script_fireondrones = false; 
		}
		if( IsDefined( self.secturretdefaultoffmode ) )
		{
			self.mgturret[ i ] setmode( self.secturretdefaultoffmode );
		}
		else
		{
			self.mgturret[ i ] setmode( "manual" );
		}
	}
}

mgon()
{
	type = self.vehicletype; 
	self.script_turretmg = 1; // fix me.. defense for scripts using mgon();

// MikeD 04/26/07: Helicopters not in CoD5.
//	if( ( self is_plane() ) && ( self hasHelicopterTurret() ) )
//	{
//		self thread chopper_Turret_On();
//		return; 
//	}
	// dpg 7/3/07: if self isn't defined, return
	if( !IsDefined( self ) || !IsDefined( self.mgturret ) )
	{
		return; 
	}
	for( i = 0; i < self.mgturret.size; i++ )
	{
		if( IsDefined( self.mgturret[ i ].bAiControlled ) && !self.mgturret[i].bAiControlled )
		{
			continue;
		}
		if( IsDefined( self.mgturret[ i ].script_fireondrones ) )
		{
			self.mgturret[ i ].script_fireondrones = true; 
		}
		if( IsDefined( self.secturretdefaultonmode ) )
		{
			self.mgturret[ i ] setmode( self.secturretdefaultonmode );
		}
		else
		{
			self.mgturret[ i ] setmode( "auto_nonai" );
		}
		if( ( self.vteam == "allies" ) || ( self.vteam == "friendly" ) )
		{
			self.mgturret[ i ] setTurretTeam( "allies" );
		}
		else if( ( self.vteam == "axis" ) || ( self.vteam == "enemy" ) )
		{
			self.mgturret[ i ] setTurretTeam( "axis" );
		}
	}
}

isCheap()
{
	if( !IsDefined( self.script_cheap ) )
	{
		return false; 
	}

	if( !self.script_cheap )
	{
		return false; 
	}

	return true; 
}


hasHelicopterDustKickup()
{
	if( !is_plane() )
	{
		return false; 
	}

	if( isCheap() )
	{
		return false; 
	}

	return true; 
}

hasHelicopterTurret()
{
	if( !IsDefined( self.vehicletype ) )
	{
		return false; 
	}
	if( isCheap() )
	{
		return false; 
	}
	if( self.vehicletype == "cobra" )
	{
		return true; 
	}
	if( self.vehicletype == "cobra_player" )
	{
		return true; 
	}
	return false; 
}

// MikeD 04/26/07: Helicopters not in CoD5.
//Chopper_Turret_On()
//{
//	self endon( "death" );
//	self endon( "mg_off" );
//
//	cosine55 = cos( 55 );
//
//	while( self.health > 0 )
//	{
//		 // target range, target fov, getAITargets, doTrace
//		eTarget = self maps\_helicopter_globals::getEnemyTarget( 16000, cosine55, true, true );
//		if( IsDefined( eTarget ) )
//			self thread maps\_helicopter_globals::shootEnemyTarget_Bullets( eTarget );
//		wait 2; 
//	}
//}

chopper_Turret_Off()
{
	self notify( "mg_off" );
}

playLoopedFxontag( effect, durration, tag )
{
 	eModel = get_dummy();
	effectorigin = spawn( "script_origin", eModel.origin );

	self endon( "fire_extinguish" );
	thread playLoopedFxontag_originupdate( tag, effectorigin );
	while( 1 )
	{
		playfx( effect, effectorigin.origin, effectorigin.upvec );
		wait durration; 
	}
}

playLoopedFxontag_originupdate( tag, effectorigin )
{
	effectorigin.angles = self gettagangles( tag );
	effectorigin.origin  = self gettagorigin( tag );
	effectorigin.forwardvec = anglestoforward( effectorigin.angles );
	effectorigin.upvec = anglestoup( effectorigin.angles );
	while( IsDefined( self ) && self.classname == "script_vehicle" && self getspeedmph() > 0 )
	{
		eModel = get_dummy();
		effectorigin.angles = eModel gettagangles( tag );
		effectorigin.origin  = eModel gettagorigin( tag );
		effectorigin.forwardvec = anglestoforward( effectorigin.angles );
		effectorigin.upvec = anglestoup( effectorigin.angles );
		wait .05; 
	}
}


//build_turret( info, tag, model, bAicontrolled, maxrange, defaultONmode, defaultOFFmode, deletedelay, max_turrets )

setup_dvars()
{
	/#
	if( GetDvar( #"debug_tankcrush" ) == "" )
	{
		setdvar( "debug_tankcrush", "0" );
	}
	if( GetDvar( #"vclogin_vehicles" ) == "" )
	{
		setdvar( "vclogin_vehicles", "off" );
	}
	if( GetDvar( #"debug_vehicleresume" ) == "" )
	{
		setdvar( "debug_vehicleresume", "off" );
	}
	if( GetDvar( #"debug_vehiclesetspeed" ) == "" )
	{
		setdvar( "debug_vehiclesetspeed", "off" );
	}
	#/
}

setup_levelvars()
{
	level.vehicle_ResumeSpeed = 5; 
	level.vehicle_DeleteGroup = []; 
	level.vehicle_SpawnGroup = []; 
	level.vehicle_StartMoveGroup = []; 
	level.vehicle_RideAI =  []; 
	level.vehicle_WalkAI =  []; 
	level.vehicle_DeathSwitch = []; 
	level.vehicle_RideSpawners = []; 
	level.vehicle_walkspawners = []; 
	level.vehicle_gatetrigger = []; 
	level.vehicle_crashpaths = []; 
	level.vehicle_target = []; 
	level.vehicle_link = []; 
	level.vehicle_truckjunk = [];
	level.vehicle_detourpaths = []; 
// 	level.vehicle_linkedpaths = []; 
	level.vehicle_startnodes = []; 
	level.vehicle_spawners =  []; 

	// AE 3-5-09: added this vehicle_walkercount so we can have ai walk with vehicles
	level.vehicle_walkercount = [];

	level.helicopter_crash_locations = getentarray( "helicopter_crash_location", "targetname" );

	level.vclogin_vehicles = 0; 
	level.playervehicle = spawn( "script_origin", ( 0, 0, 0 ) ); // no IsDefined for level.playervehicle
	level.playervehiclenone = level.playervehicle; // no IsDefined for level.playervehicle

	// TODO in a thousand next games.. I don't like managing this variable. not so much that I don't like it, just that I haven't been = / 
	level.vehicles = []; 	 // will contain all the vehicles that are spawned and alive
	level.vehicles[ "allies" ] = []; 
	level.vehicles[ "axis" ] = []; 
	level.vehicles[ "neutral" ] = []; 

	if( !IsDefined( level.vehicle_death_thread ) )
	{
		level.vehicle_death_thread = []; 
	}
	if( !IsDefined( level.vehicle_DriveIdle ) )
	{
		level.vehicle_DriveIdle = []; 
	}
	if( !IsDefined( level.vehicle_DriveIdle_r ) )
	{
		level.vehicle_DriveIdle_r = []; 
	}
	if( !IsDefined( level.attack_origin_condition_threadd ) )
	{
		level.attack_origin_condition_threadd = []; 
	}
	if( !IsDefined( level.vehiclefireanim ) )
	{
		level.vehiclefireanim = []; 
	}
	if( !IsDefined( level.vehiclefireanim_settle ) )
	{
		level.vehiclefireanim_settle = []; 
	}
	if( !IsDefined( level.vehicle_hasname ) )
	{
		level.vehicle_hasname = []; 
	}
	if( !IsDefined( level.vehicle_turret_requiresrider ) )
	{
		level.vehicle_turret_requiresrider = []; 
	}
	if( !IsDefined( level.vehicle_isStationary ) )
	{
		level.vehicle_isStationary = []; 
	}
	if( !IsDefined( level.vehicle_compassicon ) )
	{
		level.vehicle_compassicon = []; 
	}
	if( !IsDefined( level.vehicle_unloadgroups ) )
	{
		level.vehicle_unloadgroups = []; 
	}
	if( !IsDefined( level.vehicle_aianims ) )
	{
		level.vehicle_aianims = []; 
	}
	if( !IsDefined( level.vehicle_unloadwhenattacked ) )
	{
		level.vehicle_unloadwhenattacked = []; 
	}
	if( !IsDefined( level.vehicle_deckdust ) )
	{
		level.vehicle_deckdust = []; 
	}
//	if( !IsDefined( level.destructible_model ) )
//		level.destructible_model = []; 
	if( !IsDefined( level.vehicle_types ) )
	{
		level.vehicle_types = []; 
	}
	if( !IsDefined( level.vehicle_compass_types ) )
	{
		level.vehicle_compass_types = [];
	}
	if( !IsDefined( level.vehicle_bulletshield ) )
	{
		level.vehicle_bulletshield = [];
	}
	if( !IsDefined( level.vehicle_death_jolt ) )
	{
		level.vehicle_death_jolt = [];
	}
	if( !IsDefined( level.vehicle_death_badplace ) )
	{
		level.vehicle_death_badplace = [];
	}

//	if( !IsDefined( level.vehicle_shoot_rumble ) )
//	{
//		level.vehicle_shoot_rumble = []; 
//	}
		
	maps\_vehicle_aianim::setup_aianimthreads();
		
}


attacker_isonmyteam( attacker )
{
	if( ( IsDefined( attacker ) ) && IsDefined( attacker.vteam ) && ( IsDefined( self.vteam ) ) && ( attacker.vteam == self.vteam ) )
	{
		return true; 
	}
	else
	{
		return false; 
	}
}

is_godmode()
{
	return (!self.takedamage);
}

attacker_troop_isonmyteam( attacker )
{
	if ( IsDefined( self.vteam ) && self.vteam == "allies" && IsDefined( attacker ) && IsDefined(level.player) && attacker == level.player )
	{
		return true;  // player is always on the allied team.. hahah! future CoD games that let the player be the enemy be damned!
	}
	else if( isai( attacker ) && attacker.team == self.vteam )
	{
		return true; 
	}
	else
	{
		return false; 
	}
}

bulletshielded( type )
{
	if ( !IsDefined( self.script_bulletshield ) )
	{
		return false;
	}
	
	type = tolower( type );
		
	if ( ! IsDefined( type ) || ! issubstr( type, "bullet" ) )
	{
		return false;
	}
		
	if ( self.script_bulletshield )
	{
		return true;
	}
	else
	{
		return false;
	}
}

friendlyfire_shield()
{
	self.friendlyfire_shield = true;

	if ( IsDefined( level.vehicle_bulletshield[ self.vehicletype ] ) && !IsDefined( self.script_bulletshield ) )
	{
		self.script_bulletshield = level.vehicle_bulletshield[ self.vehicletype ];
	}
}

friendlyfire_shield_callback( attacker, amount, type )
{
	if( !IsDefined(self.friendlyfire_shield) || !self.friendlyfire_shield )
	{
		return false;
	}

	if( 
		( ! IsDefined( attacker ) && self.vteam != "neutral" ) || 	
		attacker_isonmyteam( attacker ) || 	
		attacker_troop_isonmyteam( attacker ) || 	
		isDestructible() || 				// destructible pieces take the damage
		bulletshielded( type )
	)
	{
		return true;
	}
	
	return false;
}


vehicle_kill_rumble_forever()
{
	self notify( "kill_rumble_forever" );
}

vehicle_kill_badplace_forever()
{
	self notify( "kill_badplace_forever" );
}

vehicle_badplace()
{
	if( !IsDefined( self.script_badplace ) )
	{
		return; 
	}
	self endon( "kill_badplace_forever" );
	self endon( "death" );
	self endon( "delete" );
	if( IsDefined( level.custombadplacethread ) )
	{
		self thread [[ level.custombadplacethread ]]();
		return; 
	}
	hasturret = IsDefined( self.turretweapon ) && self.turretweapon != ""; 
	bp_duration = .5; 
	bp_height = 300; 
	bp_angle_left = 17; 
	bp_angle_right = 17; 
	for( ;; )
	{
		if( !self.script_badplace )
		{
 // 		badplace_delete( "tankbadplace" );
			while( !self.script_badplace )
			{
				wait .5; 
			}
		}
		speed = self getspeedmph();
		if( speed <= 0 )
		{
			wait bp_duration; 
			continue; 
		}
		if( speed < 5 )
		{
			bp_radius = 200; 
		}
		else if( ( speed > 5 ) && ( speed < 8 ) )
		{
			bp_radius = 350; 
		}
		else
		{
			bp_radius = 500; 
		}

		if( IsDefined( self.BadPlaceModifier ) )
		{
			bp_radius = ( bp_radius * self.BadPlaceModifier );
		}

 // 	bp_direction = anglestoforward( self.angles );
		if( hasturret )
		{
			bp_direction = anglestoforward( self gettagangles( "tag_turret" ) );
		}
		else
		{
			bp_direction = anglestoforward( self.angles );
		}

		badplace_arc( "", bp_duration, self.origin, bp_radius * 1.9, bp_height, bp_direction, bp_angle_left, bp_angle_right, "allies", "axis" );
		badplace_cylinder( "", bp_duration, self.origin, 200, bp_height, "allies", "axis" );
 ///			badplace_cylinder( "", bp_duration, self.colidecircle[ 1 ].origin, 200, bp_height, "allies", "axis" );
		wait bp_duration + .05; 
	}
}

turret_attack_think()
{
	 // chad - disable this for now, will eventually handle shooting of missiles at targets
	if( self is_plane() )
	{
		return; 
	}

	 // Nathan - Turrets don't think anymore. Sorry, and your welcome.
	thread turret_shoot();
}

isStationary()
{
	type = self.vehicletype; 
	if( IsDefined( level.vehicle_isStationary[ type ] ) && level.vehicle_isStationary[ type ] )
	{
		return true; 
	}
	else
	{
		return false; 
	}

}

turret_shoot()
{
	type = self.vehicletype; 
	self endon( "death" );
	self endon( "stop_turret_shoot" );
	index = 0;
	turrets = self.turrettagarray;
	while( self.health > 0 )
	{
		self waittill( "turret_fire" );// next game remove this. just a simple fireturret command should do
		self notify( "groupedanimevent", "turret_fire" );
		if ( ! turrets.size )
		{
			self fireWeapon();
		}
		else if( IsDefined(turrets[ index ]) && turrets[ index ] != "" )
		{
			self fireweapon( turrets[ index ] );
			index++ ;
			if ( index >= turrets.size )
			{
				index = 0;
			}
		}
	}
}

vehicle_weapon_fired()
{
	 // if no shellshock is specified just get out of here.
//	if( !IsDefined( level.vehicle_shoot_shock[ self.model ] ) )
//	{
//		return; 
//	}

	if( !(self is_tank() ) )
	{
		return;	
	}

	self endon( "death" );

	while( true )
	{
		self waittill( "weapon_fired" ); // waits for Code notify when fireWeapon() is called.
//		if( IsDefined( self.shock_distance ) )
//		{
//			shock_distance = self.shock_distance; 
//		}
//		else
//		{
//			shock_distance = 400; 
//		}
//
//		if( IsDefined( self.black_distance ) )
//		{
//			black_distance = self.black_distance; 
//		}
//		else
//		{
//			black_distance = 800; 
//		}

		owner = self GetVehicleOwner();
		if( IsDefined( owner ) && IsPlayer( owner ) )
		{
			if( !IsDefined( owner.vehicle_shoot_shock_overlay ) )
			{
				owner.vehicle_shoot_shock_overlay = newClientHudElem( owner );
				owner.vehicle_shoot_shock_overlay.x = 0; 
				owner.vehicle_shoot_shock_overlay.y = 0; 
				owner.vehicle_shoot_shock_overlay setshader( "black", 640, 480 );
				owner.vehicle_shoot_shock_overlay.alignX = "left"; 
				owner.vehicle_shoot_shock_overlay.alignY = "top"; 
				owner.vehicle_shoot_shock_overlay.horzAlign = "fullscreen"; 
				owner.vehicle_shoot_shock_overlay.vertAlign = "fullscreen"; 
				owner.vehicle_shoot_shock_overlay.alpha = 0; 
			}

			owner.vehicle_shoot_shock_overlay.alpha = .5; 
			owner.vehicle_shoot_shock_overlay fadeOverTime( 0.2 );
			owner.vehicle_shoot_shock_overlay.alpha = 0;
		}

//		players = get_players();
//		for( i = 0; i < players.size; i++ )
//		{
//			player_distance = distance( self.origin, players[i].origin );
//		
//			if( player_distance > black_distance )
//			{
//				continue;
//			}
//
//			if( player_distance > shock_distance )
//			{
//				continue;
//			}
//
//			fraction = player_distance / shock_distance; 
//			time = 4 - ( 3 * fraction );
//		
//			vehicle_occupants = self GetVehOccupants();
//		
//			if( IsDefined( players[i] ) )
//			{
//				if( ( IsDefined( owner ) && players[i] == owner ) || is_in_array( vehicle_occupants, players[i] ) )
//				{
//					// play different effect here					
//				}
//				else
//				{
//					players[i] ShellShock( level.vehicle_shoot_shock[ self.model ], time );	
//
////					if( IsDefined( level.vehicle_shoot_rumble[ self.model ] ) )
////					{
////						PlayRumbleOnPosition( level.vehicle_shoot_rumble[ self.model ], self.origin + ( 0, 0, 32 ) );
////					}
//				}
//				
//			}
//		}
	}
}

vehicle_compasshandle()
{
	wait_for_first_player();

	self endon( "stop_vehicle_compasshandle" );
	
	type = self.vehicletype; 
	if( !IsDefined(self.addtocompass) || !self.addtocompass )
	{
		return;
	}
	self endon( "death" );
	level.compassradius = int( GetDvar( #"compassMaxRange" ) );
	self.onplayerscompass = false; 
	// TODO: complain to Code about this feature.  I shouldn't have to poll the distance of the tank to remove it from the compass
	while ( 1 )
	{
		player = get_closest_player( self.origin );
	
		if ( distance( self.origin, player.origin ) < level.compassradius )
		{
			if ( !( self.onplayerscompass ) )
			{
				self AddVehicleToCompass( maps\_vehicletypes::get_compassTypeForVehicleType( self.vehicletype ) );
				self.onplayerscompass = true; 
			}
		}
		else
		{
			if ( self.onplayerscompass )
			{
				self RemoveVehicleFromCompass();
				self.onplayerscompass = false; 
			}
		}
		wait .5; 
	}
}


vehicle_setteam()
{
	type = self.vehicletype; 
	
	// guzzo 4/1/08, reverting to cod2 method of assigning vehicle names
	//if( IsDefined( level.vehicle_hasname[ type ] ) )
	//		self thread maps\_vehiclenames::get_name();
	
	// only allied vehicles get names
	if( IsDefined( self.vteam ) && self.vteam == "allies" )
	{
		
		// check if it's an aircraft or explicitly set to have no name
		no_name = self is_plane() || ( IsDefined( self.script_friendname ) && ( self.script_friendname == "" || self.script_friendname == "none" || self.script_friendname == "0" ) );
		// only tanks should have names. this replaces cod2's method of using "vehicle.simpletype"
		correct_type = ( type == "sherman" || type == "sherman_flame" || type == "t34" || type == "ot34" || type == "see2_t34" || type == "see2_ot34" );
		
		if( !no_name && correct_type )
		{
			self maps\_vehiclenames::get_name();		
		}
	}
	
	level.vehicles[ self.vteam ] = array_add( level.vehicles[ self.vteam ], self );
	
}



vehicle_handleunloadevent()
{
	self endon( "death" );

	type = self.vehicletype; 
	while( 1 )
	{
		self waittill( "unload", who );

		 // setting an unload group unloaded guys resets to "default"
		// SCRIPTER_MOD: JesseS (5/14/2007) -  took this out "who" for now, seems to be breaking unloadgroups.
		//if( IsDefined( who ) )
		//	self.unload_group = who; 
		 // makes ai unload
		self notify( "groupedanimevent", "unload" );

 // 		if( IsDefined( self.turretweapon ) && self.turretweapon != "" && riders_check() )
 // 			self clearTurretTarget();
	}
}

get_vehiclenode_any_dynamic( target )
{
	 // the should return undefined
	path_start = getvehiclenode( target, "targetname" );
	
	if( !IsDefined( path_start ) )
	{
		path_start = getent( target, "targetname" );
	}
	else if( is_plane() )
	{
		println( "helicopter node targetname: " + path_start.targetname );
		println( "vehicletype: " + self.vehicletype );
		assertmsg( "helicopter on vehicle path( see console for info )" );
	}
	if( !IsDefined( path_start ) )
	{
		path_start = getstruct( target, "targetname" );
	}		
	return path_start;		
}


vehicle_resumepathvehicle()
{
	if( !self is_plane() )
	{
		self resumespeed( 35 );
		return;
	}

	node = undefined; 
	
	if( IsDefined( self.currentnode.target ) )
	{
		node = get_vehiclenode_any_dynamic( self.currentnode.target );
	}
	if( !IsDefined( node ) )
	{
		return; 
	}
	vehicle_paths( node );
}

vehicle_landvehicle()
{
	self setNearGoalNotifyDist( 2 );
	self sethoverparams( 0, 0, 0 );
	self cleargoalyaw();
	self settargetyaw( flat_angle( self.angles )[ 1 ] );
	self setvehgoalpos_wrap( groundpos( self.origin ), 1 );
	self waittill( "goal" );
}

setvehgoalpos_wrap( origin, bStop )
{
	if( self.health <= 0 )
	{
		return; 
	}
	if( IsDefined( self.originheightoffset ) )
	{
		origin += ( 0, 0, self.originheightoffset ); // TODO - FIXME: this is temporarily set in the vehicles init_local function working on getting it this requirement removed
	}
	self setvehgoalpos( origin, bStop );
}

vehicle_liftoffvehicle( height )
{
	if( !IsDefined( height ) )
	{
		height = 512; 
	}
	dest = self.origin + ( 0, 0, height );
	self setNearGoalNotifyDist( 10 );
	self setvehgoalpos_wrap( dest, 1 );
	self waittill( "goal" );
}

waittill_stable()
{
	 // wait for it to level out before unloading
	offset = 12; 
	stabletime = 400; 
	timer = gettime() + stabletime; 
	while( IsDefined( self ) )
	{
		if( self.angles[ 0 ] > offset || self.angles [ 0 ] < ( - 1 * offset ) )
		{
			timer = gettime() + stabletime; 
		}
		if( self.angles[ 2 ] > offset || self.angles [ 2 ] < ( - 1 * offset ) )
		{
			timer = gettime() + stabletime; 
		}
		if( gettime() > timer )
		{
			break; 
		}
		wait .05; 
	}
}

unload_node( node )
{

	if ( !IsDefined( node.script_flag_wait ) )
	{
		// going to stop anyway so no need to kill the path
		self notify( "newpath" );
	}
	
	assert( IsDefined( self ) );
 // 	self vehicle_detachfrompath();

	pathnode = getnode( node.targetname, "target" );
	if( IsDefined( pathnode ) && self.riders.size )
	{
		for( i = 0; i < self.riders.size; i++ )
		{
			if( isai( self.riders[ i ] ) )
			{
				self.riders[ i ] thread maps\_spawner::go_to_node( pathnode );
			}
		}
	}

	if( self is_plane() )
	{
		waittill_stable();
	}
	else
	{
		self setspeed( 0, 35 );
	}

// 	self vehicle_to_dummy();

	if( IsDefined( node.script_noteworthy ) )
	{
		if( node.script_noteworthy == "wait_for_flag" )
		{
			flag_wait( node.script_flag );
		}
	}

	self notify( "unload", node.script_unload );

	if ( maps\_vehicle_aianim::riders_unloadable( node.script_unload ) )
	{
		self waittill( "unloaded" );
	}

// 	self dummy_to_vehicle();
	
	// if we want the helis to hang around for bog_b we can do some script_magic here.
//	wait 1; 

	if ( IsDefined( node.script_flag_wait ) )
	{
		return;
	}

	if( IsDefined( self ) )
	{
		thread vehicle_resumepathvehicle();
	}
}


move_turrets_here( model )
{
	type = self.vehicletype; 
	if( !IsDefined( self.mgturret ) )
	{
		return; 
	}
	if( self.mgturret.size == 0 )
	{
		return; 
	}
	for( i = 0; i < self.mgturret.size; i++ )
	{
		self.mgturret[ i ] unlink();
		self.mgturret[ i ] linkto( model, self.secturrettag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
}

vehicle_pathdetach()
{
	self.attachedpath = undefined; 
	self notify( "newpath" );

	self setGoalyaw( flat_angle( self.angles )[ 1 ] );
	self setvehgoalpos( self.origin + ( 0, 0, 4 ), 1 );

}

vehicle_to_dummy()
{
	 // create a dummy model that takes the place of a vehicle, the vehicle gets hidden
	assertEx( !IsDefined( self.modeldummy ), "Vehicle_to_dummy was called on a vehicle that already had a dummy." );
	self.modeldummy = spawn( "script_model", self.origin );
	self.modeldummy setmodel( self.model );
	self.modeldummy.origin = self.origin; 
	self.modeldummy.angles = self.angles; 
	self.modeldummy useanimtree( #animtree );
	self hide();
	self notify( "animtimer" );
	 // move rider characters to dummy model
	self thread model_dummy_death();
	move_riders_here( self.modelDummy );
	move_turrets_here( self.modeldummy );
	move_ghettotags_here( self.modeldummy );
	move_lights_here( self.modeldummy );
	move_effects_ent_here( self.modeldummy );
	copy_destructable_attachments( self.modeldummy );// destructables are all attach()'d. Little bit different but not too tricky

	 // flag for various looping functions keeps them from doing IsDefined a lot
	self.modeldummyon = true; 
	return self.modeldummy; 
}

move_effects_ent_here( model )
{
	ent = deathfx_ent();
	ent unlink();
	ent linkto( model );
}

model_dummy_death()
{
// delete model dummy when the vehicle is deleted.
	modeldummy = self.modeldummy;
	modeldummy endon( "death" );
	while ( IsDefined( self ) )
	{
		self waittill( "death" );
		waittillframeend;
	}
	modeldummy delete();
}

move_lights_here( model )
{
	if ( !IsDefined( self.lights ) )
	{
		return;
	}
	keys = getarraykeys( self.lights );
	for ( i = 0 ; i < keys.size ; i++ )
	{
// 		if ( ! IsDefined( self.lights[ keys[ i ] ] ) )
// 			continue;// 
		self.lights[ keys[ i ] ] unlink();
		self.lights[ keys[ i ] ] linkto( model, self.lights[ keys[ i ] ].lighttag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
}

move_ghettotags_here( model )
{
	
	if ( !IsDefined( self.ghettotags ) )
	{
		return;
	}
	for ( i = 0 ; i < self.ghettotags.size ; i++ )
	{
		self.ghettotags[ i ] unlink();
		self.ghettotags[ i ] linkto( model );
	}
}

dummy_to_vehicle()
{
	assertEx( IsDefined( self.modeldummy ), "Tried to turn a vehicle from a dummy into a vehicle. Can only be called on vehicles that have been turned into dummies with vehicle_to_dummy." );

	if( self is_plane() )
	{
		self.modeldummy.origin = self gettagorigin( "tag_ground" );
	}
	else
	{
		self.modeldummy.origin = self.origin; 
		self.modeldummy.angles = self.angles; 
	}
	
	self show();

	 // move rider characters back to the vehicle
	move_riders_here( self );
	move_turrets_here( self );
	move_lights_here( self );
	move_effects_ent_here( self );


	 // flag for various looping functions keeps them from doing IsDefined a lot
	self.modeldummyon = false; 
	self.modeldummy delete();
	self.modeldummy = undefined; 
	
	// helicopters do dust kickup fx
	if ( self hasHelicopterDustKickup() )
	{
		if(!level.clientscripts)
		{
			self notify( "stop_kicking_up_dust" );
			self thread aircraft_dust_kickup();
		}
	}
	
	return self.modeldummy; 
}

move_riders_here( base )
{
	if ( !IsDefined( self.riders ) )
	{
		return;
	}
	riders = self.riders; 
	 // move rider characters to their new location
	for( i = 0; i < riders.size; i++ )
	{
		if( !IsDefined( riders[ i ] ) )
		{
			continue; 
		}
		guy = riders[ i ]; 
		guy unlink();
		animpos = maps\_vehicle_aianim::anim_pos( self, guy.pos );
		guy linkto( base, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
		if( isai( guy ) )
		{
			guy teleport( base gettagorigin( animpos.sittag ) );
		}
		else
		{
			guy.origin = base gettagorigin( animpos.sittag );
		}
	}
}

setup_targetname_spawners()
{
	level.vehicle_targetname_array = [];

	vehicles = array_combine( getentarray( "script_vehicle", "classname" ), get_script_modelvehicles() );

	highestGroup = 0;
	// get the highest script_vehicleSpawnGroup in use
	for( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];
		if( IsDefined( vehicle.script_vehicleSpawnGroup ) )
		{
			if( vehicle.script_vehicleSpawnGroup > highestGroup )
			{
				highestGroup = vehicle.script_vehicleSpawnGroup;
			}
		}
	}

	for( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];
		if( IsDefined( vehicle.targetname ) && vehicle has_spawnflag(level.SPAWNFLAG_VEHICLE_SPAWNER))
		{
			if( !IsDefined( vehicle.script_vehicleSpawnGroup ) )
			{
				// vehicle spawners that have no script_vehiclespawngroup get assigned one, if they have a targetname
				highestGroup ++ ;
				vehicle.script_vehicleSpawnGroup = highestGroup;
			}

			if( !IsDefined( level.vehicle_targetname_array[ vehicle.targetname ] ) )
			{
				level.vehicle_targetname_array[ vehicle.targetname ] = []; 
			}

			level.vehicle_targetname_array[ vehicle.targetname ][ vehicle.script_vehicleSpawnGroup ] = true; 
		}
	}
}

spawn_vehicles_from_targetname( name )
{
	 // spawns an array of vehicles that all have the specified targetname in the editor, 
	 // but are deleted at runtime
	assertEx( IsDefined( level.vehicle_targetname_array[ name ] ), "No vehicle spawners had targetname " + name );

	array = level.vehicle_targetname_array[ name ]; 
	keys = getArrayKeys( array );

	vehicles = []; 
	for( i = 0; i < keys.size; i++ )
	{
		vehicleArray = scripted_spawn( keys[ i ] );
		vehicles = array_combine( vehicles, vehicleArray );
	}

	return vehicles; 
}

spawn_vehicle_from_targetname( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	assertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );

	return vehicleArray[ 0 ]; 
}

spawn_vehicle_from_targetname_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	assertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );

	vehicleArray[ 0 ] thread gopath();
	return vehicleArray[ 0 ]; 
}

spawn_vehicles_from_targetname_and_drive( name )
{
	 // spawns 1 vehicle and makes sure it gets 1
	vehicleArray = spawn_vehicles_from_targetname( name );
	for( i = 0; i < vehicleArray.size; i++ )
	{
		vehicleArray[ i ] thread goPath();
	}

	return vehicleArray; 
}

aircraft_dust_kickup( model )
{
	self endon( "death" );
	self endon( "death_finished" );
	self endon( "stop_kicking_up_dust" );

	assert( IsDefined( self.vehicletype ) );

	maxHeight = 1200; 
	minHeight = 350; 

	slowestRepeatWait = 0.15; 
	fastestRepeatWait = 0.05; 

	numFramesPerTrace = 3; 
	doTraceThisFrame = numFramesPerTrace; 

	defaultRepeatRate = 1.0; 
	repeatRate = defaultRepeatRate; 

	trace = undefined; 
	d = undefined; 

	trace_ent = self;
	if ( IsDefined( model ) )
	{
		trace_ent = model;
	}

	while( IsDefined( self ) )
	{
		if( repeatRate <= 0 )
		{
			repeatRate = defaultRepeatRate; 
		}
		wait repeatRate; 
		
		if( !IsDefined( self ) )
		{
			return; 
		}
		
		doTraceThisFrame -- ; 

		 // prof_begin( "helicopter_dust_kickup" );

		if( doTraceThisFrame <= 0 )
		{
			doTraceThisFrame = numFramesPerTrace; 

			trace = bullettrace( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ), false, trace_ent );
			 /* 
			trace[ "entity" ]
			trace[ "fraction" ]
			trace[ "normal" ]
			trace[ "position" ]
			trace[ "surfacetype" ]
			 */ 

			d = distance( trace_ent.origin, trace[ "position" ] );

			repeatRate = ( ( d - minHeight ) / ( maxHeight - minHeight ) ) * ( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait; 
		}

		if( !IsDefined( trace ) )
		{
			continue; 
		}

		assert( IsDefined( d ) );

		if( d > maxHeight )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( IsDefined( trace[ "entity" ] ) )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( !IsDefined( trace[ "position" ] ) )
		{
			repeatRate = defaultRepeatRate; 
			continue; 
		}

		if( !IsDefined( trace[ "surfacetype" ] ) )
		{
			trace[ "surfacetype" ] = "dirt"; 
		}
		assertEx( IsDefined( level._vehicle_effect[ self.vehicletype ] ), self.vehicletype + " vehicle script hasn't run _tradfx properly" );
		assertEx( IsDefined( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] ), "UNKNOWN SURFACE TYPE: " + trace[ "surfacetype" ] );

		 // prof_end( "helicopter_dust_kickup" );

		if( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ] != -1 )
		{
			playfx( level._vehicle_effect[ self.vehicletype ][ trace[ "surfacetype" ] ], trace[ "position" ] );
		}
	}
}

tank_crush( crushedVehicle, endNode, tankAnim, truckAnim, animTree, soundAlias )
{
	 // Chad G's tank crushing vehicle script. Self corrects for node positioning errors.

	assert( IsDefined( crushedVehicle ) );
	assert( IsDefined( endNode ) );
	assert( IsDefined( tankAnim ) );
	assert( IsDefined( truckAnim ) );
	assert( IsDefined( animTree ) );



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Create an animatable tank and move the real tank to the next path and store required info
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	animatedTank = vehicle_to_dummy();
	self setspeed( 7, 5, 5 );


	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Total time for animation, and correction and uncorrection times
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	animLength = getanimlength( tankAnim );
	move_to_time = ( animLength / 3 );
	move_from_time = ( animLength / 3 );



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Node information used for calculating both starting and ending points for the animation
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	 // get node vecs
	node_origin = crushedVehicle.origin; 
	node_angles = crushedVehicle.angles; 
	node_forward = anglesToForward( node_angles );
	node_up = anglesToUp( node_angles );
	node_right = anglesToRight( node_angles );



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Calculate Starting Point for the animation from crushedVehicle and create the dummy
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	 // get anim starting point origin and angle
	anim_start_org = getStartOrigin( node_origin, node_angles, tankAnim );
	anim_start_ang = getStartAngles( node_origin, node_angles, tankAnim );

	 // get anim starting point vecs
	animStartingVec_Forward = anglesToForward( anim_start_ang );
	animStartingVec_Up = anglesToUp( anim_start_ang );
	animStartingVec_Right = anglesToRight( anim_start_ang );

	 // get tank vecs
	tank_Forward = anglesToForward( animatedTank.angles );
	tank_Up = anglesToUp( animatedTank.angles );
	tank_Right = anglesToRight( animatedTank.angles );

	 // spawn dummy with appropriate offset
	offset_Vec = ( node_origin - anim_start_org );
	offset_Forward = vectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = vectorDot( offset_Vec, animStartingVec_Right );
	dummy = spawn( "script_origin", animatedTank.origin );
	dummy.origin += vector_scale( tank_Forward, offset_Forward );
	dummy.origin += vector_scale( tank_Up, offset_Up );
	dummy.origin += vector_scale( tank_Right, offset_Right );

	 // set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = anglesToForward( node_angles );
	offset_Forward = vectorDot( offset_Vec, animStartingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animStartingVec_Up );
	offset_Right = vectorDot( offset_Vec, animStartingVec_Right );
	dummyVec = vector_scale( tank_Forward, offset_Forward );
	dummyVec += vector_scale( tank_Up, offset_Up );
	dummyVec += vector_scale( tank_Right, offset_Right );
	dummy.angles = vectorToAngles( dummyVec );



	 // -- -- -- -- -- -- -- -- -- -- - 
	 // Debug Lines
	 // -- -- -- -- -- -- -- -- -- -- - 
	/#
	if( GetDvar( #"debug_tankcrush" ) == "1" )
	{
		 // line to where tank1 is
		thread draw_line_from_ent_for_time( get_players()[0], animatedTank.origin, 1, 0, 0, animLength / 2 );

		 // line to where tank1 SHOULD be
		thread draw_line_from_ent_for_time( get_players()[0], anim_start_org, 0, 1, 0, animLength / 2 );

		 // line to the dummy
		thread draw_line_from_ent_to_ent_for_time( get_players()[0], dummy, 0, 0, 1, animLength / 2 );
	}
	#/


	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Animate the animatable tank and self correct into the crushed vehicle
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	if( IsDefined( soundAlias ) )
	{
		level thread play_sound_in_space( soundAlias, node_origin );
	}

	animatedTank linkto( dummy );
	crushedVehicle useAnimTree( animTree );
	animatedTank useAnimTree( animTree );

	assert( IsDefined( level._vehicle_effect[ "tankcrush" ][ "window_med" ] ) );
	assert( IsDefined( level._vehicle_effect[ "tankcrush" ][ "window_large" ] ) );

	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_left_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.2 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_window_right_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.4 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_back_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 0.7 );
	crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_front_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 1.5 );

	crushedVehicle animscripted( "tank_crush_anim", node_origin, node_angles, truckAnim );
	animatedTank animscripted( "tank_crush_anim", dummy.origin, dummy.angles, tankAnim );
	// animatedTank VehForceMaterialSpeed( true, 20 );

	dummy moveTo( node_origin, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
	dummy rotateTo( node_angles, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
	wait move_to_time; 

	animLength -= move_to_time; 
	animLength -= move_from_time; 

	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	 // Tank plays animation in the exact correct location for a while
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	wait animLength; 

	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	 // Calculate Ending Point for the animation from crushedVehicle
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

	 // get anim ending point origin and angle
	 // anim_end_org = anim_start_org + getMoveDelta( tankAnim, 0, 1 );
	temp = spawn( "script_model", ( anim_start_org ) );
	temp.angles = anim_start_ang; 
	anim_end_org = temp localToWorldCoords( getMoveDelta( tankAnim, 0, 1 ) );
	anim_end_ang = anim_start_ang + ( 0, getAngleDelta( tankAnim, 0, 1 ), 0 );
	temp delete();

	 // get anim ending point vecs
	animEndingVec_Forward = anglesToForward( anim_end_ang );
	animEndingVec_Up = anglesToUp( anim_end_ang );
	animEndingVec_Right = anglesToRight( anim_end_ang );

	 // get ending tank pos vecs
	attachPos = self getAttachPos( endNode );
	tank_Forward = anglesToForward( attachPos[ 1 ] );
	tank_Up = anglesToUp( attachPos[ 1 ] );
	tank_Right = anglesToRight( attachPos[ 1 ] );

	 // see what the dummy's final origin will be
	offset_Vec = ( node_origin - anim_end_org );
	offset_Forward = vectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = vectorDot( offset_Vec, animEndingVec_Right );
	dummy.final_origin = attachPos[ 0 ]; 
	dummy.final_origin += vector_scale( tank_Forward, offset_Forward );
	dummy.final_origin += vector_scale( tank_Up, offset_Up );
	dummy.final_origin += vector_scale( tank_Right, offset_Right );

	 // set dummy angles to reflect the different in animation starting angles and the tanks actual angles
	offset_Vec = anglesToForward( node_angles );
	offset_Forward = vectorDot( offset_Vec, animEndingVec_Forward );
	offset_Up = vectorDot( offset_Vec, animEndingVec_Up );
	offset_Right = vectorDot( offset_Vec, animEndingVec_Right );
	dummyVec = vector_scale( tank_Forward, offset_Forward );
	dummyVec += vector_scale( tank_Up, offset_Up );
	dummyVec += vector_scale( tank_Right, offset_Right );
	dummy.final_angles = vectorToAngles( dummyVec );

	 // -- -- -- -- -- -- -- -- -- -- - 
	 // Debug Lines
	 // -- -- -- -- -- -- -- -- -- -- - 
	// SCRIPTER_MOD: JesseS (8/10/2007): level.player referneces removed
	if( GetDvar( #"debug_tankcrush" ) == "1" )
	{
		 // line to where tank2 is
		thread draw_line_from_ent_for_time( get_players()[0], self.origin, 1, 0, 0, animLength / 2 );

		 // line to where tank2 SHOULD be
		thread draw_line_from_ent_for_time( get_players()[0], anim_end_org, 0, 1, 0, animLength / 2 );

		 // line to the dummy
		thread draw_line_from_ent_to_ent_for_time( get_players()[0], dummy, 0, 0, 1, animLength / 2 );
	}



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	 // Tank uncorrects to the real location of the tank on the spline
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

	dummy moveTo( dummy.final_origin, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	dummy rotateTo( dummy.final_angles, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
	wait move_from_time; 



	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	 // Tank is done animating now, remove the animatable tank and show the real one( they should be perfectly aligned now )
	 // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	self dontInterpolate();
	self attachPath( endNode );
	dummy_to_vehicle();
}

tank_crush_fx_on_tag( tagName, fxName, soundAlias, startDelay )
{
	if( IsDefined( startDelay ) )
	{
		wait startDelay; 
	}
	playfxontag( fxName, self, tagName );
	if( IsDefined( soundAlias ) )
	{
		self thread play_sound_on_tag( soundAlias, tagName );
	}
}

loadplayer( player, position, animfudgetime )
{
	/#
	if( GetDvar( #"fastrope_arms" ) == "" )
	{
		setdvar( "fastrope_arms", "0" );
	}
	#/	
		
	if( !IsDefined( animfudgetime ) )
	{
		animfudgetime = 0; 
	}
	assert( IsDefined( self.riders ) );
	assert( self.riders.size );
	guy = undefined; 
	for( i = 0; i < self.riders.size; i++ )
	{
		if( self.riders[ i ].pos == position )
		{
			guy = self.riders[ i ]; 
			guy.drone_delete_on_unload = true; 
			guy.playerpiggyback = true; 
			break; 
		}
	}

	assertex( !isai( guy ), "guy in position of player needs to have script_drone set, use script_startingposition ans script drone in your map" );
	assert( IsDefined( guy ) );
	thread show_rigs( position );
	animpos = maps\_vehicle_aianim::anim_pos( self, position );

 // 	guy stopanimscripted();
 // 	guy stopuseanimtree();
	guy notify( "newanim" );
	guy detachall();
 // 	guy setmodel( "" );
	guy setmodel( "fastrope_arms" );
	guy useanimtree( animpos.player_animtree );
	thread maps\_vehicle_aianim::guy_idle( guy, position );
	 // playerlinktodelta( <linkto entity> , <tag> , <viewpercentag fraction> , <right arc> , <left arc> , <top arc> , <bottom arc> )
	
	// SCRIPTER_MOD: JesseS (8/10/2007):  passing in player now, use player instead of level.player
	player playerlinktodelta( guy, "tag_player", 1.0, 70, 70, 90, 90 );

	 // level.player setplayerangles( guy gettagangles( "tag_player" ) );

	 // level.player allowcrouch( false );
	 // level.player allowprone( false );
	 // level.player allowstand( true );

	guy hide();

	animtime = getanimlength( animpos.getout );
	animtime -= animfudgetime; 
	self waittill( "unload" );

	/#
	
	if( GetDvar( #"fastrope_arms" ) != "0" )
		guy show();
	#/
	
	player disableweapons();
 // 	guy waittill( "jumpedout" );

	guy notsolid();

	wait animtime; 

	player unlink();
	player enableweapons();
	 // level.player allowcrouch( true );
	 // level.player allowprone( true );
}

show_rigs( position )
{
	wait .01; 
	self thread maps\_vehicle_aianim::getout_rigspawn( self, position ); // spawn the getoutrig for this position
	if( !self.riders.size )
	{
		return; 
	}
	for( i = 0; i < self.riders.size; i++ )
	{
		self thread maps\_vehicle_aianim::getout_rigspawn( self, self.riders[ i ].pos );
	}
}

turret_deleteme( turret )
{
	if ( IsDefined( self ) )
	{
		if ( IsDefined( turret.deletedelay ) )
		{
			wait turret.deletedelay;
		}
	}
			
	turret delete();
}


wheeldirectionchange( direction )
{
	if( direction <= 0 )
	{
		self.wheeldir = 0; 
	}
	else
	{
		self.wheeldir = 1; 
	}
}

maingun_FX()
{
	if( !IsDefined( level.vehicle_deckdust[ self.model ] ) )
	{
		return; 
	}
	self endon( "death" );
	while( true )
	{
		self waittill( "weapon_fired" ); // waits for Code notify when fireWeapon() is called.
		playfxontag( level.vehicle_deckdust[ self.model ], self, "tag_engine_exhaust" );
		barrel_origin = self gettagorigin( "tag_flash" );
		ground = physicstrace( barrel_origin, barrel_origin + ( 0, 0, -128 ) );
		physicsExplosionSphere( ground, 192, 100, 1 );
	}
}

group_light( model, name, group )
{
	if( !IsDefined( level.vehicle_lights_group ) )
	{
		level.vehicle_lights_group = []; 
	}
	if( !IsDefined( level.vehicle_lights_group[ model ] ) )
	{
		level.vehicle_lights_group[ model ] = []; 
	}
	if( !IsDefined( level.vehicle_lights_group[ model ][ group ] ) )
	{
		level.vehicle_lights_group[ model ][ group ] = []; 
	}
	level.vehicle_lights_group[ model ][ group ][ level.vehicle_lights_group[ model ][ group ].size ] = name; 
}

lights_on()
{
	self SetClientFlag(10);
}

lights_off()
{
	self ClearClientFlag(10);
}

sirens_on()
{
	self SetClientFlag(11);
}

sirens_off()
{
	self ClearClientFlag(11);
}

interior_lights_on()
{
	self SetClientFlag(12);
}

interior_lights_off()
{
	self ClearClientFlag(12);
}

deathfx_ent()
{
	if ( !IsDefined( self.deathfx_ent ) )
	{
		ent = spawn( "script_model", ( 0, 0, 0 ) );
		emodel = get_dummy();
		ent setmodel( self.model );
		ent.origin = emodel.origin;
		ent.angles = emodel.angles;
		ent notsolid();
		ent hide();
		ent linkto( emodel );
		self.deathfx_ent = ent;
	}
	else
	{
		self.deathfx_ent setmodel( self.model );
	}
	return self.deathfx_ent;
}

/* 
 ============= 
 ///ScriptDocBegin
"Name: build_drive( <forward> , <reverse> , <normalspeed> , <rate> )"
"Summary: called in individual vehicle file - assigns animations to be used on vehicles"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <forward> : forward animation"
"OptionalArg: <reverse> : reverse animation"
"OptionalArg: <normalspeed> : speed at which animation will be played at 1x defaults to 10mph"
"OptionalArg: <rate> : scales speed of animation( please only use this for testing )"
"Example: vehicle build_drive( %abrams_movement, %abrams_movement_backwards, 10 );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_drive( forward, reverse, normalspeed, rate )
{
	if( !IsDefined( normalspeed ) )
	{
		normalspeed = 10; 
	}
	level.vehicle_DriveIdle[ self.model ] = forward; 
	
	if( IsDefined( reverse ) )
	{
		level.vehicle_DriveIdle_r[ self.model ] = reverse; 
	}
	level.vehicle_DriveIdle_normal_speed[ self.model ] = normalspeed; 
	if( IsDefined( rate ) )
	{
		level.vehicle_DriveIdle_animrate[ self.model ] = rate; 
	}
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_aianims( <aithread> , <vehiclethread> )"
"Summary: called in individual vehicle file - set threads for ai animation and vehicle animation assignments"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <aithread> : ai thread"
"OptionalArg: <vehiclethread> : vehicle thread"
"Example: vehicle build_aianims( ::setanims, ::set_vehicle_anims );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_aianims( aithread, vehiclethread )
{
	level.vehicle_aianims[ self.vehicletype ] = [[ aithread ]]();
	if( IsDefined( vehiclethread ) )
	{
		level.vehicle_aianims[ self.vehicletype ] = [[ vehiclethread ]]( level.vehicle_aianims[ self.vehicletype ] );
	}
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_crashanim( <modelsthread> )"
"Summary: called in individual vehicle file - thread for building attached models( ropes ) with animation"
"Module: Vehicle"
"CallOn: "
"MandatoryArg: <modelsthread> : thread"
"Example: build_attach_models( ::set_attached_models );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_attach_models( modelsthread )
{
	level.vehicle_attachedmodels[ level.vttype ] = [[ modelsthread ]]();; 
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_unload_groups( <unloadgroupsthread> )"
"Summary: called in individual vehicle file - thread for building unload groups"
"Module: Vehicle"
"CallOn: A vehicle"
"MandatoryArg: <modelsthread> : thread"
"Example: vehicle build_unload_groups( ::Unload_Groups );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_unload_groups( unloadgroupsthread )
{
	level.vehicle_unloadgroups[ self.vehicletype ] = [[ unloadgroupsthread ]]();
}

 /* 
 ============= 
 ///ScriptDocBegin
"Name: build_vehiclewalk( <walk num> )"
"Summary: called in individual vehicle file - this sets the max numer of walkers the vehicle has
"Module: Vehicle"
"CallOn: "
"MandatoryArg: <walk num> :  max number of walkers this vehicle supports"
"Example: build_vehiclewalk( 6 );"
"SPMP: singleplayer"
 ///ScriptDocEnd
 ============= 
 */ 

build_vehiclewalk( num_walkers )
{
	level.vehicle_walkercount[ level.vttype ] = num_walkers; 
}

get_from_spawnstruct( target )
{
	return getstruct( target, "targetname" );
}

get_from_entity( target )
{
	return getent( target, "targetname" );
}

get_from_spawnstruct_target( target )
{
	return getstruct( target, "target" );
}

get_from_entity_target( target )
{
	return getent( target, "target" );
}

get_from_vehicle_node( target )
{
	return getvehiclenode( target, "targetname" );
}

set_lookat_from_dest( dest )
{
	viewTarget = getent( dest.script_linkto, "script_linkname" );

	if ( !IsDefined( viewTarget ) )
	{
		return; 
	}

	self setLookAtEnt( viewTarget );
	self.set_lookat_point = true;
}

getspawner_byid( id )
{
	return level.vehicle_spawners[ id ]; 
}

vehicle_getspawner()
{
	assert( IsDefined( self.spawner_id ) );
	return getspawner_byid( self.spawner_id );
}

isDestructible()
{
	return IsDefined( self.destructible_type );	
}

// SCRIPTER_MOD: JesseS (5/12/200) -  readded script_vehicleattackgroup scripting
// This allows vehicles to attack other vehicles automatically. Just set the script_vehicleattackgroup of the attacker
// to the script_vehiclespawngroup you want to attack.
attackgroup_think()
{
	self endon ("death");
	self endon ("switch group");
	self endon ("killed all targets");
	
	if (IsDefined (self.script_vehicleattackgroupwait))
	{
		wait (self.script_vehicleattackgroupwait);
	}
	
	for(;;)
	{
		//get all the vehicles
		group = getentarray("script_vehicle", "classname");
		
		// get our target array
		valid_targets = [];
		for (i = 0; i< group.size; i++)
		{
			// dpg: not all script vehicles have a script_vehiclespawngroup 
			if( !IsDefined( group[i].script_vehiclespawngroup ) )
			{
				continue;	
			}
			// get all vehicles with the same spawngroup as the agroup we want to attack
			if (group[i].script_vehiclespawngroup == self.script_vehicleattackgroup)
			{
				// Make sure we only attack different teams vehicles
				if (group[i].vteam != self.vteam)
				{
					valid_targets = array_add(valid_targets, group[i]);
				}
			}
		}
		
		// Try again every .5 seconds if there are no valid targets.
		if (valid_targets.size == 0)
		{
			wait (0.5);
			continue;
		}
		
		// Main loop which makes the vehicle fire on the nearest group it's been set to attack
		for (;;)
		{
			current_target = undefined;
			if (valid_targets.size != 0)
			{
				current_target = self get_nearest_target(valid_targets);
			}
			else
			{
				// We killed them all, end this thread
				self notify ("killed all targets");
			}
			
			// if it's a death vehicle, remove it from the list of valid targets
			if (current_target.health <= 0)
			{
				valid_targets = array_remove(valid_targets, current_target);
				continue;
			}
			else
			{
				// set the target ent for the vehicle. offset a bit so it doesnt shoot into the ground
				self setturrettargetent( current_target, (0,0,50) );
				
				// DPG 10/22/07 - in case we want specific wait values on the vehicle
				if( IsDefined( self.fire_delay_min ) && IsDefined( self.fire_delay_max ) )
				{
					// in case max is less than min
					if( self.fire_delay_max < self.fire_delay_min )
					{
						self.fire_delay_max = self.fire_delay_min;	
					}
					
					wait ( randomintrange(self.fire_delay_min, self.fire_delay_max) );
				}
				
				else
				{
					wait (randomintrange(4, 6));
				}
				self fireweapon();
			}
		}
	}


	// if this is called again, just add new group to queue
	// queue should be sorted by distance
	// delete from queue once vehicle is dead, check to see if vehicles health > 0
}

// Gets the nearest ent to self
get_nearest_target(valid_targets)
{
	nearest_dist = 999999;
	nearest = undefined;
	
	for (i = 0; i < valid_targets.size; i++)
	{
		if( !IsDefined( valid_targets[i] ) )
		{
			continue;
		}
		current_dist = distance( self.origin, valid_targets[i].origin );
		if (current_dist < nearest_dist)
		{
			nearest_dist = current_dist;
			nearest = valid_targets[i];
		}
	}
	return nearest;
}

//---------------//
// Debug section //
//---------------//
/#
debug_vehicle()
{
	self endon( "death" );

	if( GetDvar( #"debug_vehicle_health" ) == "" )
	{
		SetDvar( "debug_vehicle_health", "0" );
	}

	while( 1 )
	{
		if( GetDvarInt( #"debug_vehicle_health" ) > 0 )
		{
			print3d( self.origin, "Health: " + self.health, ( 1, 1, 1 ), 1, 3 );
		}

		wait( 0.05 );
	}
}
#/

generate_colmaps_vehicles()
{
	/#
	
	if ( !IsDefined( level.vehicleInitThread ) || ! level.vehicleInitThread.size )
	{
		return;
	}
	
	// detect missing script_vehicles
	script_vehicles = getentarray( "script_vehicle", "classname" );
	hascol = [];
	for ( i = 0 ; i < script_vehicles.size ; i++ )
	{
		if ( !IsDefined( hascol[ script_vehicles[ i ].vehicletype ] ) )
		{
			hascol[ script_vehicles[ i ].vehicletype ] = [];
		}
		hascol[ script_vehicles[ i ].vehicletype ][ script_vehicles[ i ].model ] = true;
	}
	dump = false;
	keys1 = getarraykeys( level.vehicleInitThread );
	needscol = [];
	for ( i = 0 ; i < keys1.size ; i++ )
	{
		keys2 = getarraykeys( level.vehicleInitThread [ keys1[ i ] ] );
		for ( j = 0 ; j < keys2.size ; j++ )
		{
			if ( !IsDefined( hascol[ keys1[ i ] ] ) || !IsDefined( hascol[ keys1[ i ] ][ keys2[ j ] ] ) )
			{
				dump = true;
				needscol[ keys1[ i ] ][ keys2[ j ] ] = true;
			}
		}
		if ( dump )
		{
			break;
		}
	}
	// finished detecting
	
	if ( dump )
	{
		dump_vehicles();
	}

	#/
	
	// delete the models that go in the prefab
	array_delete(GetEntArray( "colmap_vehicle", "targetname" ));
	
}

dump_vehicles()
{
 /#

	level.script = tolower( GetDvar( #"mapname" ) );
	fileprint_map_start( level.script + "_vehicledump" );

	stackupinc = 64;// probably unnessesary but may help make it unique looking in the editor and easily identified as the cache pile
	keys1 = getarraykeys( level.vehicleInitThread );
	for ( i = 0 ; i < keys1.size ; i++ )
	{
		keys2 = getarraykeys( level.vehicleInitThread [ keys1[ i ] ] );
		for ( j = 0 ; j < keys2.size ; j++ )
		{
			origin = fileprint_radiant_vec( ( 0, 0, ( stackupinc * i ) ) );// convert these vectors to mapfile keypair format
			fileprint_map_entity_start();
				fileprint_map_keypairprint( "classname", "script_vehicle" );
				fileprint_map_keypairprint( "model", keys2[ j ] );
				fileprint_map_keypairprint( "origin", origin );
				fileprint_map_keypairprint( "vehicletype", keys1[ i ] );
				fileprint_map_keypairprint( "targetname", "colmap_vehicle" );// these get deleted by _vehicle
			fileprint_map_entity_end();
		}
	}

	fileprint_end();
	
	println( " " );
	println( " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - " );
	println( " " );
	println( "add this prefab to your map, it contains the vehicles needed to make the system happy" );
	fabname = "xenon_export\\" + level.script + "_vehicledump.map";
	println( "prefab is : " + fabname );
	println( " " );
	println( "after you've done this you'll need to compile" );
	println( "I appologize for this very roundabout workaround to some stuff. " );
	println( "It's on my next - game list to be fixed - nate" );
	println( "the workaround is for getting colmaps on script_vehicles that exists as script_models in the map source and are purely spawned by scripts" );
	println( " " );
	println( " -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - " );
	println( " " );
	
// 	assertmsg( "Colmap .map file generated follow instructions in console.log" );
#/ 

}

copy_destructable_attachments( modeldummy )
{
	// does all attachments
	attachedModelCount = self getattachsize();
	attachedModels = [];
	for ( i = 0 ; i < attachedModelCount ; i++ )
	{
		attachedModels[ i ] = tolower( self getAttachModelName( i ) );
	}

	for ( i = 0 ; i < attachedModels.size ; i++ )
	{
		modeldummy attach( attachedModels[ i ], tolower( self getattachtagname( i ) ) );
	}
	
	// original model still has it's own attachments because that's too much script to rewrite 
	// to move them completely to the dummy, I just want to translate the effects of an 
	// explosion to the dummy so that's all I'm doing.  So don't expect a dummy destructable 
	// vehicle to react to damage and all of that jazz it's the original model that will do this
}

get_dummy()
{
	if ( self.modeldummyon )
	{
		eModel = self.modeldummy;
	}
	else
	{
		eModel = self;
	}
	return eModel;
}

apply_truckjunk( eVehicle, truckjunk )
{
	if ( !IsDefined( self.spawner_id ) )
	{
		return;
	}
	if ( !IsDefined( level.vehicle_truckjunk[ self.spawner_id ] ) )
	{
		return;
	}
	truckjunk = level.vehicle_truckjunk[ self.spawner_id ];
	self.truckjunk = [];
	for ( i = 0 ; i < truckjunk.size ; i++ )
	{
		model = spawn( "script_model", self.origin );
		model setmodel( truckjunk[ i ].model );
		model linkto( self, "tag_body", truckjunk[ i ].origin, truckjunk[ i ].angles );
		self.truckjunk[ i ] = model; 
	}
}

truckjunk()
{
	assert( IsDefined( self.target ) );
	linked_vehicle = getent( self.target, "targetname" );
	assert( IsDefined( linked_vehicle ) );
	spawner_id = vehicle_spawnidgenerate( linked_vehicle.origin );
	target = getent( self.target, "targetname" );
	ghettotag = ghetto_tag_create( target );
	
	if ( IsDefined( self.script_noteworthy ) )
	{
		ghettotag.script_noteworthy = self.script_noteworthy;
	}
	if ( !IsDefined( level.vehicle_truckjunk[ spawner_id ] ) )
	{
		level.vehicle_truckjunk[ spawner_id ] = [];
	}
	if ( IsDefined( self.script_startingposition ) )
	{
		ghettotag.script_startingposition = self.script_startingposition;
	}
	
	level.vehicle_truckjunk[ spawner_id ][ level.vehicle_truckjunk[ spawner_id ].size ] = ghettotag;
	self delete();
}

ghetto_tag_create( target )
{
	struct = spawnstruct();
	struct.origin = self.origin - target gettagorigin( "tag_body" );
	struct.angles = self.angles - target gettagangles( "tag_body" );
	struct.model = self.model;
	if ( IsDefined( struct.targetname ) )
	{
		level.struct_class_names[ "targetname" ][ struct.targetname ] = undefined;// done with this forever. don't stick around
	}
	if ( IsDefined( struct.target ) )
	{
		level.struct_class_names[ "target" ][ struct.target ] = undefined;// done with this forever. don't stick around
	}
	return struct;
}



/* 
============= 
///ScriptDocBegin
"Name: vehicle_dump()"
"Summary: exports current vehicle positions to a map.  Usefull for scripting complex interactions with vehicles"
"Module: Vehicle"
"CallOn: level"
"Example: vehicle_dump();"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

vehicle_dump()
{
 /#
	// starts a map with the necessary blank layer info and a blank worldspawn.  
	// Throught he magic of junction this file ends up in "map_source\xenon_export\jeepride_veh_ref.map"  
	// I keep the directory structure somewhat flat because permissions in winnt is painful when dealing with the xenonremote share stuff. 
	// junction.bat keeps it in check
	 
	// this simple script exports all of the vehicles as script models that have a delete_on_load targetname
	 
	predumpvehicles = getentarray( "script_vehicle", "classname" );
	vehicles = [];
	
	// dumping can jump a frame in which the information could be altered, this stores the necessary info real quick
	for ( i = 0 ; i < predumpvehicles.size ; i++ )
	{
		struct = spawnstruct();
		struct.classname = predumpvehicles[ i ].classname;
		struct.origin = predumpvehicles[ i ].origin;
		struct.angles = predumpvehicles[ i ].angles;
		struct.spawner_id = predumpvehicles[ i ].spawner_id;
		struct.speedbeforepause = predumpvehicles[ i ] getspeedmph();
		struct.script_vehiclespawngroup = predumpvehicles[ i ].script_vehiclespawngroup;
		struct.script_vehiclestartmove = predumpvehicles[ i ].script_vehiclestartmove;
		struct.model = predumpvehicles[ i ].model;
		struct.angles = predumpvehicles[ i ].angles;
		
		if ( IsDefined( level.playersride ) && predumpvehicles[ i ] == level.playersride )
		{
			struct.playersride = true;
		}

		vehicles[ i ] = struct; 
	}

	fileprint_map_start( level.script + "_veh_ref" );
	for ( i = 0;i < vehicles.size;i++ )
	{
		origin = fileprint_radiant_vec( vehicles[ i ].origin );// convert these vectors to mapfile keypair format
		angles = fileprint_radiant_vec( vehicles[ i ].angles );

		fileprint_map_entity_start();
		fileprint_map_keypairprint( "classname", "script_struct" );
		fileprint_map_keypairprint( "spawnflags", "4" );
		fileprint_map_keypairprint( "model", vehicles[ i ].model );
		fileprint_map_keypairprint( "origin", origin );
		fileprint_map_keypairprint( "angles", angles );
		
		if ( IsDefined( vehicles[ i ].playersride ) )
		{
			fileprint_map_keypairprint( "target", "delete_on_load" );// _load deletes these.
		}
		else
		{
			fileprint_map_keypairprint( "target", "structtarg" + i );// _load deletes these.
			fileprint_map_keypairprint( "targetname", "delete_on_load" );// _load deletes these.
		}

		if ( IsDefined( vehicles[ i ].speedbeforepause ) )
		{
			fileprint_map_keypairprint( "current_speed", vehicles[ i ].speedbeforepause );
		}

		if ( IsDefined( vehicles[ i ].script_vehiclespawngroup ) )
		{
			fileprint_map_keypairprint( "script_vehiclespawngroup", vehicles[ i ].script_vehiclespawngroup );
		}

		if ( IsDefined( vehicles[ i ].script_vehiclestartmove ) )
		{
			fileprint_map_keypairprint( "script_vehiclestartmove", vehicles[ i ].script_vehiclestartmove );
		}

		fileprint_map_entity_end();

		// struct shows where the spawner is
		if (!IsDefined( vehicles[ i ].spawner_id )
			|| !IsDefined( level.vehicle_spawners )
			|| !IsDefined( level.vehicle_spawners[ vehicles[ i ].spawner_id ] ))
		{
			continue;
		}

		fileprint_map_entity_start();
		fileprint_map_keypairprint( "classname", "script_struct" );
		fileprint_map_keypairprint( "origin", fileprint_radiant_vec( level.vehicle_spawners[ vehicles[ i ].spawner_id ].origin ) );
		fileprint_map_keypairprint( "_color", "0.300000 0.300000 0.300000" );
		fileprint_map_keypairprint( "angles", angles );
		fileprint_map_keypairprint( "model", vehicles[ i ].model );
		fileprint_map_keypairprint( "targetname", "structtarg" + i );

		if ( IsDefined( vehicles[ i ].speedbeforepause ) )
		{
			fileprint_map_keypairprint( "current_speed", vehicles[ i ].speedbeforepause );
		}

		if ( IsDefined( vehicles[ i ].script_vehiclespawngroup ) )
		{
			fileprint_map_keypairprint( "script_vehiclespawngroup", vehicles[ i ].script_vehiclespawngroup );
		}

		if ( IsDefined( vehicles[ i ].script_vehiclestartmove ) )
		{
			fileprint_map_keypairprint( "script_vehiclestartmove", vehicles[ i ].script_vehiclestartmove );
		}

		fileprint_map_entity_end();		
	}

	fileprint_end();
//	iprintlnbold( "dumped vehicles" ); <- localize or die
#/ 
}

dump_handle()
{
	/#
	button1 = "r";
	button2 = "CTRL";

	wait_for_first_player();

	while ( 1 )
	{
		while ( !twobuttonspressed( button1, button2 ) )
		{
			wait .05;
		}

		vehicle_dump();

		while ( twobuttonspressed( button1, button2 ) )
		{
			wait .05;
		}
	}
	#/ 
}

twobuttonspressed( button1, button2 )
{
/#
	players = get_players("all");
	if(!IsDefined(players[0]))
	{
		return false;
	}
	return players[0] buttonpressed( button1 ) && players[0] buttonpressed( button2 );
#/
}

vehicle_load_ai( ai )
{
	maps\_vehicle_aianim::load_ai( ai );
}

volume_up( timer )
{
	self notify( "new_volume_command" );
	self endon( "new_volume_command" );
	assertex( IsDefined( timer ), "No timer defined! ");
	self endon( "death" );
	timer = timer * 20;
	for ( i = 0; i <= timer; i++ )
	{
		self setenginevolume( i / timer );
		wait( 0.05 );
	}
}

volume_down( timer )
{
	self notify( "new_volume_command" );
	self endon( "new_volume_command" );
	assertex( IsDefined( timer ), "No timer defined! ");
	self endon( "death" );
	timer = timer * 20;
	for ( i = 0; i <= timer; i++ )
	{
		self setenginevolume( ( timer - i ) / timer );
		wait( 0.05 );
	}
}

kill_badplace( type )
{
	if ( !IsDefined( level.vehicle_death_badplace[ type ] ) )
	{
		return;
	}

	struct = level.vehicle_death_badplace[ type ];
	if ( IsDefined( struct.delay ) )
	{
		wait struct.delay;
	}

	if(!IsDefined(self))
	{
		return;
	}
	BadPlace_Cylinder( "vehicle_kill_badplace", struct.duration, self.origin, struct.radius, struct.height, struct.team1, struct.team2 );
}

kill_jolt( type )
{
	if ( IsDefined( level.vehicle_death_jolt[ type ] ) )
	{
		self.dontfreeme = true;
		wait level.vehicle_death_jolt[ type ].delay;// this is all that exists currently, not to elaborate untill needed.
	}

	if( !IsDefined( self ) )
	{
		return;
	}

	self joltbody( ( self.origin + ( 23, 33, 64 ) ), 3 );
	wait 2;

	if( !IsDefined( self ) )
	{
		return;
	}

	self.dontfreeme = undefined;
}

vehicle_main()
{
	switch( self.vehicletype )
	{
		// TANKS //
		case "tank_t72":
			self maps\_t72::main();
			break;
		
		case "tank_zsu23":
		case "tank_zsu23_low":
			self maps\_tank_zsu23::main();
			break;
			
		// TRANSPORT //
		case "truck_bm21":
		case "truck_bm21_troops":
		case "truck_maz543":
			self maps\_truck::main();
			break;

		// BOAT - PBR //
		case "boat_pbr":
		case "boat_pbr_player":
			self maps\_boat_pbr::main();
			break;

		// TRUCK - GAZ66 //
		case "truck_gaz66":
		case "truck_gaz66_physics":
		case "truck_gaz66_canvas":
		case "truck_gaz66_flatbed":
		case "truck_gaz66_tanker":
		case "truck_gaz66_tanker_physics":
		case "truck_gaz66_troops":
		case "truck_gaz66_troops_physics":
		case "truck_gaz66_troops_attacking_physics":	
		case "truck_gaz66_single50":
		case "truck_gaz66_quad50":
		case "truck_gaz66_player_single50":
			self maps\_truck_gaz66::main();
			break;
			
		// TRUCK - GAZ63 //
		case "truck_gaz63":
		case "truck_gaz63_canvas":
		case "truck_gaz63_canvas_camorack":
		case "truck_gaz63_flatbed":
		case "truck_gaz63_flatbed_camorack":
		case "truck_gaz63_tanker":
		case "truck_gaz63_troops":
		case "truck_gaz63_troops_bulletdamage":
		case "truck_gaz63_troops_camorack":
		case "truck_gaz63_single50":
		case "truck_gaz63_player_single50":
		case "truck_gaz63_player_single50_nodeath":
		case "truck_gaz63_player_single50_physics":
		case "truck_gaz63_player_single50_bulletdamage":
		case "truck_gaz63_quad50":
		case "truck_gaz63_camorack":
		case "truck_gaz63_low":
		case "truck_gaz63_canvas_low":
		case "truck_gaz63_flatbed_low":
		case "truck_gaz63_tanker_low":
		case "truck_gaz63_troops_low":
		case "truck_gaz63_single50_low":
		case "truck_gaz63_quad50_low":
		case "truck_gaz63_quad50_low_no_deathmodel":
		case "truck_gaz63_camorack_low":
			self maps\_truck_gaz63::main();
			break;
			
		case "jeep_uaz":
		case "jeep_uaz_closetop":
		case "jeep_uaz_closetop_physics":
		case "jeep_uaz_physics":
			self maps\_uaz::main();
			break;

		case "jeep_intl":
		// AE 2-17-09: module 5 vehicles
		case "jeep_player":
		case "jeep_player_slow":
		case "jeep_willys":
		case "jeep_ultimate":
			self maps\_jeep::main();
			break;

		// HELICOPTERS /////
		case "heli_chinook":
			self maps\_chinook::main();
			break;

		case "heli_cobra":
		case "heli_cobra_khesanh":
			self maps\_cobra::main();
			break;

		case "heli_hip":
		case "heli_hip_sidegun":
		case "heli_hip_sidegun_uwb":
		case "heli_hip_sidegun_spotlight":
			self maps\_hip::main();
			break;
			
		case "heli_huey":
		case "heli_huey_vista":
		case "heli_huey_assault":
		case "heli_huey_assault_river":
		case "heli_huey_gunship":
		case "heli_huey_gunship_river":
		case "heli_huey_heavyhog":
		case "heli_huey_heavyhog_creek":
		case "heli_huey_usmc_heavyhog_khesanh":	
		case "heli_huey_heavyhog_river":
		case "heli_huey_medivac":
		case "heli_huey_medivac_khesanh":	
		case "heli_huey_medivac_river":
		case "heli_huey_minigun":
		case "heli_huey_player":
		case "heli_huey_small":		
		case "heli_huey_usmc":
		case "heli_huey_usmc_gunship":
		case "heli_huey_usmc_heavyhog":
		case "heli_huey_usmc_khesanh":
		case "heli_huey_usmc_khesanh_std":
		case "heli_huey_usmc_minigun":
		case "heli_huey_side_minigun":
		case "heli_huey_side_minigun_uwb":
		{
			self maps\_huey::main();			
		}
			break;
		
		case "heli_hind_player":
			self maps\_hind_player::main();
			break;
	
		// PLANES //	
		case "plane_mig17":
			self maps\_mig17::main();
			break;
			
		case "plane_phantom":
			self maps\_mig17::main();
			break;
			
		// WEAPONS //
		case "wpn_zpu_antiair":
			self maps\_zpu_antiair::main();
			break;

		// APC //
		case "apc_brt40":
		case "apc_m113":
		case "apc_m113_khesanh_outcasts":
		case "apc_m113_khesanh_warchicken":
		case "apc_m113_khesanh_plain":
		case "apc_bmp":
			self maps\_apc::main();
			break;

		case "apc_btr40_flashpoint":
		case "apc_btr60":
		case "apc_btr60_grenade":
			self maps\_btr::main();
			break;

		case "civ_tanker":
		case "civ_tanker_civ":
		case "civ_sedan_luxury":
			self maps\_civ_vehicle::main();
			break;

		case "tiara":
			self maps\_tiara::main();
			break;

		case "police":
			self maps\_policecar::main();
			break;
			
		// snowcat //
		case "tank_snowcat":
		case "tank_snowcat_plow":
		case "tank_snowcat_troops":
			self maps\_snowcat::main();
			break;

		case "rcbomb":
			self maps\_rcbomb::main();
			break;
		
		case "boat_sampan_pow":
		case "boat_sampan":
			self maps\_sampan::main();
			break;
		
		case "boat_nvapbr":
			self maps\_boat_nvapbr::main();
			break;
		
		case "boat_patrol_nva":
			self maps\_boat_patrol_nva::main();
			break;
		
		case "motorcycle_ai":
			self maps\_motorcycle::main();
			break;
		default:
			//ASSERTMSG( "Vehicle type: " + self.vehicletype + " not handled in _vehicle.gsc::vehicle_main" );
			break;
		
	}
}
