
#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_ability_airsupport;
precachehelicopter(model,type)
{
	if(!isdefined(type))
		type = "blackhawk";
	deathfx = loadfx ("explosions/fx_exp_tanker");
	
	precacheModel( model );
	level.vehicle_deathmodel[model] = model;
	
	
	precacheitem( "cobra_FFAR" );
	precacheitem( "zombie_cobra_20mm" );
	PreCacheModel("t5_veh_helo_huey_heavyhog");
	precachevehicle( "zombie_cobra" );
		
	
	
	
	
	level.cobra_missile_models = [];
	level.cobra_missile_models["cobra_Hellfire"] = "projectile_hellfire_missile";
	precachemodel( level.cobra_missile_models["cobra_Hellfire"] );
	
	
	level.heli_sound["allies"]["hit"] = "mpl_kls_cobra_helicopter_hit";
	level.heli_sound["allies"]["hitsecondary"] = "evt_helicopter_hit_secondary";
	level.heli_sound["allies"]["damaged"] = "null";
	level.heli_sound["allies"]["spinloop"] = "evt_helicopter_spin_loop";
	level.heli_sound["allies"]["spinstart"] = "evt_helicopter_spin_start";
	level.heli_sound["allies"]["crash"] = "evt_helicopter_crash";
	level.heli_sound["allies"]["missilefire"] = "wpn_hellfire_fire_npc";
	level.heli_sound["axis"]["hit"] = "mpl_kls_hind_helicopter_hit";
	level.heli_sound["axis"]["hitsecondary"] = "evt_helicopter_hit_secondary";
	level.heli_sound["axis"]["damaged"] = "null";
	level.heli_sound["axis"]["spinloop"] = "evt_helicopter_spin_loop";
	level.heli_sound["axis"]["spinstart"] = "evt_helicopter_spin_start";
	level.heli_sound["axis"]["crash"] = "evt_veh_helicopter_crash ";
	level.heli_sound["axis"]["missilefire"] = "evt_helicopter_crash";
	
	level.fx_heli_dust = loadfx ("vehicle/treadfx/fx_heli_dust_default");
	level.fx_heli_water = loadfx ("vehicle/treadfx/fx_heli_water_spray");
	level.fx_heli_dust_concrete = loadfx ("vehicle/treadfx/fx_heli_dust_concrete");
	level.fx_heli_snow = loadfx ("vehicle/treadfx/fx_heli_snow_spray");
	
	level._effect["rotor_full"] = LoadFX("vehicle/props/fx_huey_main_blade_full");
	level._effect["rotor_small_full"] = LoadFX("vehicle/props/fx_huey_small_blade_full");
	level._effect["exhaust_huey_engine"] = LoadFX("vehicle/exhaust/fx_exhaust_huey_engine");
	
	
	
	
	
}
useKillstreakHelicopter( hardpointType )
{
	if ( isDefined( level.chopper ) )
	{
		
		
		return false;
	}
	
	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) )
	{
		
		return false;
	}
	
		result = self targetHelicopterLocation();
		if ( !isdefined(result) || result == false )
			return false;
	level._abilities[ hardpointType ].in_use = true;
	
	destination = 0;
	missilesEnabled = false;
			
	random_path = randomint( level.heli_paths[destination].size );
	
	startnode = level.heli_paths[destination][random_path];
	
	protectLocation = undefined;
	
		protectLocation = (level.helilocation[0],  level.helilocation[1], startnode.origin[2]);
	
	
	
	
		iprintln( &"ZOMBIE_HELICOPTER_INBOUND" );
	
	thread heli_think( self, startnode, self.pers["team"], missilesEnabled, protectLocation, hardpointType );
	
	wait( 1.0 );
	
	flag_set("end_target_confirm");
	return true;
}
heli_path_graph()
{	
	
	path_start = getentarray( "heli_start", "targetname" ); 		
	path_dest = getentarray( "heli_dest", "targetname" ); 			
	loop_start = getentarray( "heli_loop_start", "targetname" ); 	
	leave_nodes = getentarray( "heli_leave", "targetname" ); 		
	crash_start = getentarray( "heli_crash_start", "targetname" );	
	
	assertex( ( isdefined( path_start ) && isdefined( path_dest ) ), "Missing path_start or path_dest" );
		
	
	for (i=0; i<path_dest.size; i++)
	{
		startnode_array = [];
		
		
		destnode_pointer = path_dest[i];
		destnode = getent( destnode_pointer.target, "targetname" );
		
		
		for ( j=0; j<path_start.size; j++ )
		{
			toDest = false;
			currentnode = path_start[j];
			
			while( isdefined( currentnode.target ) )
			{
				nextnode = getent( currentnode.target, "targetname" );
				if ( nextnode.origin == destnode.origin )
				{
					toDest = true;
					break;
				}
				
				
				debug_print3d_simple( "+", currentnode, ( 0, 0, -10 ) );
				if( isdefined( nextnode.target ) )
					debug_line( nextnode.origin, getent(nextnode.target, "targetname" ).origin, ( 0.25, 0.5, 0.25 ), 5);
				if( isdefined( currentnode.script_delay ) )
					debug_print3d_simple( "Wait: " + currentnode.script_delay , currentnode, ( 0, 0, 10 ) );
					
				currentnode = nextnode;
			}
			if ( toDest )
				startnode_array[startnode_array.size] = getent( path_start[j].target, "targetname" ); 
		}
		assertex( ( isdefined( startnode_array ) && startnode_array.size > 0 ), "No path(s) to destination" );
		
		
		level.heli_paths[level.heli_paths.size] = startnode_array;
	}	
	
	
	for (i=0; i<loop_start.size; i++)
	{
		startnode = getent( loop_start[i].target, "targetname" );
		level.heli_loop_paths[level.heli_loop_paths.size] = startnode;
	}
	assertex( isdefined( level.heli_loop_paths[0] ), "No helicopter loop paths found in map" );
	
	
	for (i=0; i<leave_nodes.size; i++)
		level.heli_leavenodes[level.heli_leavenodes.size] = leave_nodes[i];
	assertex( isdefined( level.heli_leavenodes[0] ), "No helicopter leave nodes found in map" );
	
	
	for (i=0; i<crash_start.size; i++)
	{
		crash_start_node = getent( crash_start[i].target, "targetname" );
		level.heli_crash_paths[level.heli_crash_paths.size] = crash_start_node;
	}
	assertex( isdefined( level.heli_crash_paths[0] ), "No helicopter crash paths found in map" );
}
init()
{
	
	path_start = getentarray( "heli_start", "targetname" ); 		
	loop_start = getentarray( "heli_loop_start", "targetname" ); 	
	if ( !path_start.size && !loop_start.size)
		return;
		
	precachehelicopter( "vehicle_mi24p_hind_desert" );
	precachehelicopter( "vehicle_cobra_helicopter_fly" );
	
	
	level.chopper = undefined;
	level.heli_paths = [];
	level.heli_loop_paths = [];
	level.heli_leavenodes = [];
	level.heli_crash_paths = [];
	
	
	thread heli_update_global_dvars();
	
	level.chopper_fx["explode"]["death"] = loadfx ("vehicle/vexplosion/fx_vexplode_helicopter_exp_mp");
	level.chopper_fx["explode"]["large"] = loadfx ("explosions/fx_exp_aerial_lg");
	level.chopper_fx["explode"]["medium"] = loadfx ("explosions/fx_exp_aerial");
	level.chopper_fx["smoke"]["trail"] = loadfx ("trail/fx_trail_heli_white_smoke");
	level.chopper_fx["fire"]["trail"]["medium"] = loadfx ("trail/fx_trail_heli_black_smoke");
	level.chopper_fx["fire"]["trail"]["large"] = loadfx ("trail/fx_trail_fire_smoke_black_lg");
	level.coptermainrotor_fx = loadfx ("vehicle/props/fx_cobra_rotor_main_run_mp");
	level.coptertailrotor_fx = loadfx ("vehicle/props/fx_cobra_rotor_small_run_mp");
	heli_path_graph();
}
heli_update_global_dvars()
{
	for( ;; )
	{
		
		level.heli_loopmax = heli_get_dvar_int( "scr_heli_loopmax", "2" );			
		level.heli_missile_rof = heli_get_dvar_int( "scr_heli_missile_rof", "2" );	
		level.heli_armor = heli_get_dvar_int( "scr_heli_armor", "500" );			
		
		level.heli_maxhealth = heli_get_dvar_int( "scr_heli_maxhealth", "1100" );	
		level.heli_missile_max = heli_get_dvar_int( "scr_heli_missile_max", "20" );	
		level.heli_dest_wait = heli_get_dvar_int( "scr_heli_dest_wait", "8" );		
		level.heli_debug = heli_get_dvar_int( "scr_heli_debug", "0" );				
		
		level.heli_targeting_delay = heli_get_dvar( "scr_heli_targeting_delay", "0.05" );	
		level.heli_turretReloadTime = heli_get_dvar( "scr_heli_turretReloadTime", "0.1" );	
		level.heli_turretClipSize = heli_get_dvar_int( "scr_heli_turretClipSize", "100" );	
		level.heli_visual_range = heli_get_dvar_int( "scr_heli_visual_range", "3500" );		
		level.heli_missile_range = heli_get_dvar_int( "scr_heli_missile_range", "100000" );	
		level.heli_health_degrade = heli_get_dvar_int( "scr_heli_health_degrade", "0" );	
				
		level.heli_target_spawnprotection = heli_get_dvar_int( "scr_heli_target_spawnprotection", "5" );
		level.heli_missile_regen_time = heli_get_dvar( "scr_heli_missile_regen_time", "10" );			
		level.heli_turret_spinup_delay = heli_get_dvar( "scr_heli_turret_spinup_delay", "0.1" );		
		level.heli_target_recognition = heli_get_dvar( "scr_heli_target_recognition", "0.1" );			
		level.heli_missile_friendlycare = heli_get_dvar_int( "scr_heli_missile_friendlycare", "512" );	
		level.heli_missile_target_cone = heli_get_dvar( "scr_heli_missile_target_cone", "0.6" );		
		level.heli_valid_target_cone = heli_get_dvar( "scr_heli_missile_valid_target_cone", "0.7" );	
		level.heli_armor_bulletdamage = heli_get_dvar( "scr_heli_armor_bulletdamage", "0.3" );			
		
		level.heli_attract_strength = heli_get_dvar( "scr_heli_attract_strength", "1000" );
		level.heli_attract_range = heli_get_dvar( "scr_heli_attract_range", "20000" );
		
		
		level.heli_protect_time = heli_get_dvar( "scr_heli_protect_time", "25" ); 				
		level.heli_protect_pos_time = heli_get_dvar( "scr_heli_protect_pos_time", "5" ); 		
		level.heli_protect_radius = heli_get_dvar_int( "scr_heli_protect_radius", "500" ); 	
		
		wait 1;
	}
}
heli_get_dvar_int( dvar, def )
{
	return int( heli_get_dvar( dvar, def ) );
}
heli_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}
spawn_helicopter( owner, origin, angles, model, targetname )
{
	
	
	
	chopper = spawnVehicle( "t5_veh_helo_huey_heavyhog", "t5_veh_helo_huey_heavyhog", "zombie_cobra", origin, angles );
	chopper.type = "helicopter";
	
	
	
	
	chopper.attackers = [];
	chopper.attackerData = [];
	chopper.attackerDamage = [];
	Target_Set(chopper, (0,0,-100));
	
	chopper setTeamForEntity( "allies" );
	return chopper;
}
damageFromConsoleThread()
{
	self endon ( "death" );
	wait (10);
	for (;;)
	{
		self waittill("touch");
		self thread heli_explode();
	}
}
heli_think( owner, startnode, heli_team, missilesEnabled, protectLocation, hardpointType )
{
	heliOrigin = startnode.origin;
	heliAngles = startnode.angles;
	
		chopper = spawn_helicopter( owner, heliOrigin, heliAngles, "t5_veh_helo_huey_heavyhog", "vehicle_cobra_helicopter_fly");
		
		
	
	
	chopper.defaultWeapon = "zombie_cobra_20mm";
	
	chopper.requiredDeathCount = owner.deathCount;
	
	
	
	
	
	chopper.team = heli_team;
	chopper.pers["team"] = heli_team;
	
	chopper.owner = owner;
	chopper thread heli_existance( hardpointType );
	
	
	
	level.chopper = chopper;
	
	
	chopper.reached_dest = false;						
	chopper.maxhealth = level.heli_maxhealth;			
	chopper.rocketDamage = chopper.maxhealth + 1;		
	chopper.chaffcount = 0;								
	chopper.waittime = level.heli_dest_wait;			
	chopper.loopcount = 0; 								
	chopper.evasive = false;							
	chopper.health_bulletdamageble = level.heli_armor;	
	chopper.health_evasive = level.heli_armor;			
	chopper.health_low = level.heli_maxhealth*0.8;		
	chopper.targeting_delay = level.heli_targeting_delay;		
	chopper.primaryTarget = undefined;					
	chopper.secondaryTarget = undefined;				
	chopper.attacker = undefined;						
	chopper.missile_ammo = level.heli_missile_max;		
	chopper.currentstate = "ok";						
	chopper.lastRocketFireTime = -1;
	chopper SetmaxHealth( 999 );
	
	
  	if ( IsDefined(protectLocation) ) 
  	{
  		chopper thread heli_protect( startNode, protectLocation );
  	}
  	else
  	{
		chopper thread heli_fly( startnode, 2.0 );					
	}
	
	
	
	chopper thread attack_targets( missilesEnabled );		
	chopper thread heli_targeting( missilesEnabled );		
	chopper thread heli_missile_regen();					
}
heli_existance( hardpointType )
{
	self waittill_any( "death", "crashing", "leaving" );
	level notify( "helicopter gone" );
	level._abilities[ hardpointType ].in_use = false;
	self.owner maps\_zombiemode_ability::update_player_ability_status();
}
heli_missile_regen()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	for( ;; )
	{
		debug_print3d( "Missile Ammo: " + self.missile_ammo, ( 0.5, 0.5, 1 ), self, ( 0, 0, -100 ), 0 );
		
		if( self.missile_ammo >= level.heli_missile_max )
			self waittill( "missile fired" );
		else
		{
			
			if ( self.currentstate == "heavy smoke" )
				wait( level.heli_missile_regen_time/4 );
			else if ( self.currentstate == "light smoke" )
				wait( level.heli_missile_regen_time/2 );
			else
				wait( level.heli_missile_regen_time );
		}
		if( self.missile_ammo < level.heli_missile_max )
			self.missile_ammo++;
	}
}
heli_targeting( missilesEnabled )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
 	
 	for ( ;; )
 	{		
 		
 		targets = [];
 		targetsMissile = [];
 
 		
 		players = GetAiSpeciesArray( "axis", "all" );
 		for (i = 0; i < players.size; i++)
 		{
 			player = players[i];
 			
 			
 			if( !isdefined(player.helitarget) || !player.helitarget )
 			{
 				continue;
 			}
 			
 			
 			{
 				if( isdefined( player ) )
 					targets[targets.size] = player;
 			}
 			if ( missilesEnabled )
 			{
 				if( isdefined( player ) )
 					targetsMissile[targetsMissile.size] = player;
 			}	
 			else
 				continue;
 				
 
 		}
 		
 		
 	
 		
 		
 		if ( targets.size == 0 && targetsMissile.size == 0 )
 		{
 			
 			self.primaryTarget = undefined;
 			self.secondaryTarget = undefined;
 			debug_print_target(); 
 			wait ( self.targeting_delay );
 			continue;
 		}
 		
 		if ( targets.size == 1 )
 		{
 			
 			if ( targets[0].isdog )
 			{
 				update_dog_threat ( targets[0] );
 			}
 			else
 			{
 				update_player_threat ( targets[0] );
 			}
 	
 			self.primaryTarget = targets[0];	
 			self notify( "primary acquired" );
 			self.secondaryTarget = undefined;
 			debug_print_target(); 
 		}
 		else if ( targets.size > 1 )
 		{
 			
 			assignPrimaryTargets( targets );
 		}
 		
 		if ( targetsMissile.size == 1 )
 		{
 			if ( !isdefined( targetsMissile[0].type ) || targetsMissile[0].type != "dog" )
 			{
 				self update_missile_player_threat ( targetsMissile[0] );
 			}
 			else if ( targetsMissile[0].isdog )
 			{
 				self update_missile_dog_threat( targetsMissile[0] );
 			}
 	
 			self.secondaryTarget = targetsMissile[0];	
 			self notify( "secondary acquired" );
 			debug_print_target(); 
 		}
 		else if ( targetsMissile.size > 1 )
 			assignSecondaryTargets( targetsMissile );
 					
 		wait ( self.targeting_delay );
 		
 		debug_print_target(); 
 	}	
}
canTargetPlayer_turret( player )
{
	canTarget = true;
	
	if ( !isalive( player ) || player.sessionstate != "playing" )
		return false;
	if ( player == self.owner )
	{
		self check_owner();
		return false;
	}
	if ( distance( player.origin, self.origin ) > level.heli_visual_range )
		return false;
	
	if ( !isdefined( player.pers["team"] ) )
		return false;
	
	if ( level.teamBased && player.pers["team"] == self.team )
		return false;
	
	
	if ( player.pers["team"] == "spectator" )
		return false;
	
	if ( isdefined( player.spawntime ) && ( gettime() - player.spawntime )/1000 <= level.heli_target_spawnprotection )
		return false;
		
	heli_centroid = self.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( self.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
	if (!isdefined(player.lastHit))
		player.lastHit = 0;
		
	
	
	
	
	
	
	return canTarget;
}
canTargetPlayer_missile( player )
{
	canTarget = true;
	
	if ( !isalive( player ) || player.sessionstate != "playing" )
		return false;
	if ( player == self.owner )
	{
		self check_owner();
		return false;
	}
		
	if ( distance( player.origin, self.origin ) > level.heli_missile_range )
		return false;
	
	if ( !isdefined( player.pers["team"] ) )
		return false;
	
	if ( level.teamBased && player.pers["team"] == self.team )
		return false;
	
	if ( player.pers["team"] == "spectator" )
		return false;
	
	if ( isdefined( player.spawntime ) && ( gettime() - player.spawntime )/1000 <= level.heli_target_spawnprotection )
		return false;
		
	if ( self missile_target_sight_check( player ) == false )
		return false;
	heli_centroid = self.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( self.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
	if (!isdefined(player.lastHit))
		player.lastHit = 0;
		
	
	return canTarget;
}
canTargetDog_turret( dog )
{
	canTarget = true;
		
	if ( !isdefined( dog ) )
		return false;
		
	if ( distance( dog.origin, self.origin ) > level.heli_visual_range )
		return false;
	
	if ( !isdefined( dog.aiteam ) )
		return false;
		
	if ( level.teamBased && (dog.aiteam == self.pers["team"]) )
		return false;
	
	if ( isdefined(dog.script_owner) && self.owner == dog.script_owner )
		return false;
	
	if ( self missile_target_sight_check( dog ) == false )
		return false;
		
	heli_centroid = self.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( self.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
	if (!isdefined(dog.lastHit))
		dog.lastHit = 0;
	
	
	
	return canTarget;
}
canTargetDog_missile( dog )
{
	canTarget = true;
		
	if ( !isdefined( dog ) )
		return false;
		
	if ( distance( dog.origin, self.origin ) > level.heli_missile_range )
		return false;
	
	if ( !isdefined( dog.aiteam ) )
		return false;
	
	if ( level.teamBased && (dog.aiteam == self.pers["team"]) )
		return false;
		
	if ( isdefined(dog.script_owner) && self.owner == dog.script_owner )
		return false;
		
	
	
		
	heli_centroid = self.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( self.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
	if (!isdefined(dog.lastHit))
		dog.lastHit = 0;
	
	
	
	return canTarget;
}
assignPrimaryTargets( targets )
{
	for( idx=0; idx<targets.size; idx++ )
	{
		if ( targets[idx].isdog ) 
		{ 
			update_dog_threat ( targets[idx] );
		}
		else
		{
			update_player_threat ( targets[idx] );
		}
	}
	assertex( targets.size >= 2, "Not enough targets to assign primary and secondary" );
	
	
	highest = 0;	
	second_highest = 0;
	primaryTarget = undefined;
	
	
	for( idx=0; idx<targets.size; idx++ )
	{
		assertex( isdefined( targets[idx].threatlevel ), "Target player does not have threat level" );
		if( targets[idx].threatlevel >= highest )
		{
			highest = targets[idx].threatlevel;
			primaryTarget = targets[idx];
		}
	}
	assertex( isdefined( primaryTarget ), "Targets exist, but none was assigned as primary" );
	self.primaryTarget = primaryTarget;
	self notify( "primary acquired" );
}
assignSecondaryTargets( targets )
{
	for( idx=0; idx<targets.size; idx++ )
	{
		if ( !isdefined(targets[idx].type) || targets[idx].type != "dog" ) 
		{
			self update_missile_player_threat ( targets[idx] );
		}
		else if ( targets[idx].isdog ) 
		{
			update_missile_dog_threat( targets[idx] );
		}
	}
	assertex( targets.size >= 2, "Not enough targets to assign primary and secondary" );
	
	
	highest = 0;	
	second_highest = 0;
	primaryTarget = undefined;
	secondaryTarget = undefined;
	
	
	for( idx=0; idx<targets.size; idx++ )
	{
		assertex( isdefined( targets[idx].missilethreatlevel ), "Target player does not have threat level" );
		if( targets[idx].missilethreatlevel >= highest )
		{
			highest = targets[idx].missilethreatlevel;
			secondaryTarget = targets[idx];
		}
	}
		
	assertex( isdefined( secondaryTarget ), "1+ targets exist, but none was assigned as secondary" );
	self.secondaryTarget = secondaryTarget;
	self notify( "secondary acquired" );
	
	
	
	
}
update_player_threat( player )
{
	player.threatlevel = 0;
	
	
	dist = distance( player.origin, self.origin );
	player.threatlevel += ( (level.heli_visual_range - dist)/level.heli_visual_range )*100; 
	
	
		
	if( isdefined( player.antithreat ) )
		player.threatlevel -= player.antithreat;
		
	if( player.threatlevel <= 0 )
		player.threatlevel = 1;
}
update_missile_player_threat( player )
{
	player.missilethreatlevel = 0;
	
	
	dist = distance( player.origin, self.origin );
	player.missilethreatlevel += ( (level.heli_missile_range - dist)/level.heli_missile_range )*100; 
	
	
		
	if( isdefined( player.antithreat ) )
		player.missilethreatlevel -= player.antithreat;
		
	if( player.missilethreatlevel <= 0 )
		player.missilethreatlevel = 1;
}
update_dog_threat( dog )
{
	dog.threatlevel = 0;
	
	
	dist = distance( dog.origin, self.origin );
	dog.threatlevel += ( (level.heli_visual_range - dist)/level.heli_visual_range )*100; 
}
update_missile_dog_threat( dog )
{
	dog.missilethreatlevel = 1;
}
heli_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	
	
	
	
	self setneargoalnotifydist( 256 );
	self setturningability(0.3);
}
heli_wait( waittime )
{
	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "evasive" );
	self thread heli_hover();
	wait( waittime );
	heli_reset();
	
	self notify( "stop hover" );
}
heli_hover()
{
	
	self endon( "death" );
	self endon( "stop hover" );
	self endon( "evasive" );
	self endon( "leaving" );
	self endon( "crashing" );
	randInt = randomint(360);
	self setgoalyaw( self.angles[1]+randInt, 90, 90 );
}
heli_chaff_weaponfired( player )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	for( ;; )
	{
		self waittill( "stinger_fired_at_me" );
			
		
		println( ">>>>>>>stinger_fired_at_me" );
		
		
		if( isdefined(self.chaffcount) && self.chaffcount>0 )
		{
			
			target_remove( self );
		
			
			vec_toForward = anglesToForward( self.angles );
			self.chaff_target = spawn( "script_origin", self.origin + ( 0, 0, -300 ) - vector_scale(vec_toForward, 600.0) );
			target_set( self.chaff_target );
		
			
 			playfx( level.fx_heli_flare, self.chaff_target.origin );
 			wait( 5.0 );
 			self.chaff_target Delete();
 			
 			
			target_set( self );
 		}
 		wait( 1.0 );
	}
}
heli_chaff_monitor( player )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	for( ;; )
	{
		if( isdefined( player ) && isdefined( player.missle_locking_on ) )
			player.missle_locking_on.alpha = 0.0;
		if( isdefined( player ) && isdefined( player.missle_locked_on ) )
			player.missle_locked_on.alpha = 0.0;
		if( target_isTarget( self ) )
		{
			if( IsDefined(self.locked_on) && self.locked_on )
			{
				if( isdefined( player ) && isdefined( player.missle_locked_on ) )
					player.missle_locked_on.alpha = 1.0;
			}
			else if( IsDefined(self.no_lock) && self.no_lock )
			{
				if( isdefined( player ) && isdefined( player.missle_locking_on ) )
					player.missle_locking_on.alpha = 1.0;
			}
		}
		
		wait( 0.1 );
	}
}
heli_evasive()
{
	
	self notify( "evasive" );
	
	self.evasive = true;
	
	
	loop_startnode = level.heli_loop_paths[0];
	self thread heli_fly( loop_startnode, 2.0 );
}
heli_crash()
{
	self endon( "death" );
	self notify( "crashing" );
	
	level.chopper = undefined;
	
	self stoploopsound(5);
	crashType = randomInt(3);
	switch (crashType)
	{
		case 0:
		{
			self thread crashOnNearestCrashPath();
		}
		break;
		case 1:
		{
			self thread heli_explode();
		}
		break;
		case 2:
		{
			heli_speed = 30+randomInt(50);
			heli_accel = 10+randomInt(25);
			
			
			
			random_leave_node = randomInt( level.heli_leavenodes.size );
			leavenode = level.heli_leavenodes[random_leave_node];
			
			self setspeed( heli_speed, heli_accel );	
			self setvehgoalpos( (leavenode.origin), 0 );
			
			rateOfSpin = 45 + randomint(90);
			
			
			self thread heli_spin( rateOfSpin );
			self waittill( "near_goal" ); 
			self thread heli_explode();
		}
		break;
	}
	
	time = randomInt(15);
	self thread waitThenExplode( time );
}
waitThenExplode( time )
{
	self endon( "death" );
	
	wait( time );	
	
	self thread heli_explode();
}
crashOnNearestCrashPath()
{	
	crashPathDistance = -1;
	crashPath = level.heli_crash_paths[0];
	for ( i = 0; i < level.heli_crash_paths.size; i++ )
	{
		currentDistance = distance(self.origin, level.heli_crash_paths[i].origin);
		if ( crashPathDistance == -1 || crashPathDistance > currentDistance )
		{
			crashPathDistance = currentDistance;
			crashPath = level.heli_crash_paths[i];
		}
	}
	
	heli_speed = 30+randomInt(50);
	heli_accel = 10+randomInt(25);
	
	
	self setspeed( heli_speed, heli_accel );	
			
	
	self thread heli_fly( crashPath, 2.0 );
	
	rateOfSpin = 45 + randomint(90);
	
	
	self thread heli_spin( rateOfSpin );
	
	
	self waittill ( "path start" );
	
	playfxontag( level.chopper_fx["explode"]["large"], self, "tag_engine_left" );
	
	self playSound ( level.heli_sound[self.team]["hitsecondary"] );
	
	
	self thread trail_fx( level.chopper_fx["fire"]["trail"]["large"], "tag_engine_left", "stop body fire" );
	
	self waittill( "destination reached" );
	self thread heli_explode();
}
heli_spin( speed )
{
	self endon( "death" );
	
	
	playfxontag( level.chopper_fx["explode"]["medium"], self, "tail_rotor_jnt" );
	
	self playSound ( level.heli_sound[self.team]["hit"] );
	
	
	self thread spinSoundShortly();
	
	
	self thread trail_fx( level.chopper_fx["smoke"]["trail"], "tail_rotor_jnt", "stop tail smoke" );
	
	
	self setyawspeed( speed, speed / 3 , speed / 3 );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}
spinSoundShortly()
{
	self endon("death");
	
	wait .25;
	
	self stopLoopSound();
	wait .05;
	self playLoopSound( level.heli_sound[self.team]["spinloop"] );
	wait .05;
	self playSound( level.heli_sound[self.team]["spinstart"] );
}
trail_fx( trail_fx, trail_tag, stop_notify )
{
	
	self notify( stop_notify );
	self endon( stop_notify );
	self endon( "death" );
		
	for ( ;; )
	{
		playfxontag( trail_fx, self, trail_tag );
		wait( 0.05 );
	}
}
heli_explode()
{
	self death_notify_wrapper();
	
	forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin;
	playfx ( level.chopper_fx["explode"]["death"], self.origin, forward );
	
	
	self playSound( level.heli_sound[self.team]["crash"] );
	
	if( isdefined( self.interior_model ) )
	{
		self.interior_model Delete();
		self.interior_model = undefined;
	}
	self delete();
}
heli_leave()
{
	self notify( "desintation reached" );
	self notify( "leaving" );
	
	self stoploopsound(10);
	
	
	random_leave_node = randomInt( level.heli_leavenodes.size );
	leavenode = level.heli_leavenodes[random_leave_node];
	
	heli_reset();
	self setspeed( 100, 20 );	
	self setvehgoalpos( leavenode.origin, 1 );
	self waittillmatch( "goal" );
	self death_notify_wrapper();
	
	if( isdefined( self.interior_model ) )
	{
		self.interior_model Delete();
		self.interior_model = undefined;
	}
	self delete();
}
	
heli_fly( currentnode, startwait )
{
	self endon( "death" );
	
	
	self notify( "flying");
	self endon( "flying" );
	
	
	self endon( "abandoned" );
	
	self.reached_dest = false;
	heli_reset();
	
	pos = self.origin;
	wait( startwait );
	while ( isdefined( currentnode.target ) )
	{	
		nextnode = getent( currentnode.target, "targetname" );
		assertex( isdefined( nextnode ), "Next node in path is undefined, but has targetname" );
		
		
		pos = nextnode.origin+(0,0,30); 
		
		
		if( isdefined( currentnode.script_airspeed ) && isdefined( currentnode.script_accel ) )
		{
			heli_speed = currentnode.script_airspeed;
			heli_accel = currentnode.script_accel;
		}
		else
		{
			heli_speed = 30+randomInt(20);
			heli_accel = 10+randomInt(5);
		}
		
		
		if ( !isdefined( nextnode.target ) )
			stop = 1;
		else
			stop = 0;
			
		
		debug_line( currentnode.origin, nextnode.origin, ( 1, 0.5, 0.5 ), 200 );
			
		
		if( self.currentstate == "heavy smoke" || self.currentstate == "light smoke" )	
		{
			
			self setspeed( heli_speed, heli_accel );	
			self setvehgoalpos( (pos), stop );
			
			self waittill( "near_goal" ); 
			self notify( "path start" );
		}
		else
		{
			
			if( isdefined( nextnode.script_delay ) ) 
				stop = 1;
	
			self setspeed( heli_speed, heli_accel );	
			self setvehgoalpos( (pos), stop );
			
			if ( !isdefined( nextnode.script_delay ) )
			{
				self waittill( "near_goal" ); 
				self notify( "path start" );
			}
			else
			{			
				
				self setgoalyaw( nextnode.angles[1] );
				
				
				self waittillmatch( "goal" );				
				heli_wait( nextnode.script_delay );
			}
		}
		
		
		for( index = 0; index < level.heli_loop_paths.size; index++ )
		{
			if ( level.heli_loop_paths[index].origin == nextnode.origin )
				self.loopcount++;
		}
		if( self.loopcount >= level.heli_loopmax )
		{
			level.chopper = undefined;
			self thread heli_leave();
			return;
		}
		currentnode = nextnode;
	}
	
	self setgoalyaw( currentnode.angles[1] );
	self.reached_dest = true;	
	self notify ( "destination reached" );
	
	heli_wait( self.waittime );
	
	
	if( isdefined( self ) )
		self thread heli_evasive();
}
heli_protect( startNode, protectDest )
{
	self endon( "death" );
		
	
	self notify( "flying");
	self endon( "flying" );
	
	
	self endon( "abandoned" );
	
	self.reached_dest = false;
	heli_reset();
	wait( 2 );
	
	timeInAir = 0;
	
	
	println( "protectDest: " + protectDest[0] + ", " + protectDest[1] + ", " + protectDest[2] + ", " ); 
	
	currentDest = protectDest;
	
	nodeHeight = 0;
	nodeHeight = protectDest[2];
	
	nextnode = startNode;
	while( isdefined( nextnode.target ) )
	{
		currentnode = nextnode;
		nextnode = getent( currentnode.target, "targetname" );
		if ( nodeHeight < nextnode.origin[2] )
			nodeHeight = nextnode.origin[2];
	}
	
	protectDest = ( protectDest[0], protectDest[1], nodeHeight );
	currentDest = protectDest;
	
	while ( timeInAir < level.heli_protect_time )
	{	
		heli_speed = 30+randomInt(20);
		heli_accel = 10+randomInt(5);
		stop = 1;
		
		
		if( self.currentstate == "heavy smoke" || self.currentstate == "light smoke" )	
		{
			
			self setspeed( heli_speed, heli_accel );	
			self setvehgoalpos( (currentDest), stop );
			
			self waittill( "near_goal" );
			self notify( "path start" );
		}
		else
		{
			self setspeed( heli_speed, heli_accel );	
			self setvehgoalpos( (currentDest), stop );
			self waittill( "near_goal" ); 
			self notify( "path start" );
		}
		
		wait ( level.heli_protect_pos_time );
		timeInAir += level.heli_protect_pos_time;
		
		direction = randomintrange(0,360);
		distance = randomintrange(0,level.heli_protect_radius);
		x = cos(direction);
		y = sin(direction);
		x = x * distance;
		y = y * distance;
		currentDest = (protectDest[0] + x, protectDest[1] + y, protectDest[2]);
	}
	self thread heli_leave();
}
fire_missile( sMissileType, iShots, eTarget )
{
 	if ( !isdefined( iShots ) )
 		iShots = 1;
 	assert( self.health > 0 );
 	
 	weaponName = undefined;
 	weaponShootTime = undefined;	
 	tags = [];
 	switch( sMissileType )
 	{
 		case "ffar":
 			
 				weaponName = "cobra_FFAR";
 			
 			
 				
 			tags[ 0 ] = "tag_flash";
 			break;
 		default:
 			assertMsg( "Invalid missile type specified. Must be ffar" );
 			break;
 	}
 	assert( isdefined( weaponName ) );
 	assert( tags.size > 0 );
 	
 	weaponShootTime = weaponfiretime( weaponName );
 	assert( isdefined( weaponShootTime ) );
 	
 	self setVehWeapon( weaponName );
 	nextMissileTag = -1;
 	for( i = 0 ; i < iShots ; i++ ) 
 	{
 		nextMissileTag++;
 		if ( nextMissileTag >= tags.size )
 			nextMissileTag = 0;
 		
 		if ( isdefined( eTarget ) )
 		{
 			eMissile = self fireWeapon( tags[ nextMissileTag ], eTarget );
 		}
 		else
 		{
 			eMissile = self fireWeapon( tags[ nextMissileTag ] );
 		}
 		self.lastRocketFireTime = gettime();
 		
 		if ( i < iShots - 1 )
 			wait weaponShootTime;
 	}
 	
}
check_owner()
{
	if ( !isdefined( self.owner ) || !isdefined( self.owner.pers["team"] ) || self.owner.pers["team"] != self.team )
	{
		self notify ( "abandoned" );
		self thread heli_leave();	
	}
}
attack_targets( missilesEnabled )
{
	
	self thread attack_primary();
	if ( missilesEnabled ) 
		self thread attack_secondary();
}
attack_secondary()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );	
	
	for( ;; )
	{
		if ( isdefined( self.secondaryTarget ) )
		{
			self.secondaryTarget.antithreat = undefined;
			self.missileTarget = self.secondaryTarget;
			
			antithreat = 0;
			while( isdefined( self.missileTarget ) && isalive( self.missileTarget ) )
			{
				
				if( self missile_target_sight_check( self.missileTarget ) )
					self thread missile_support( self.missileTarget, level.heli_missile_rof, true, undefined );
				else
					break;
				
				
				antithreat += 100;
				self.missileTarget.antithreat = antithreat;
				
				wait level.heli_missile_rof;
				
				if ( !isdefined( self.secondaryTarget ) || ( isdefined( self.secondaryTarget ) && self.missileTarget != self.secondaryTarget ) )
					break;
			}
			
			if ( isdefined( self.missileTarget ) )
				self.missileTarget.antithreat = undefined;
		}
		self waittill( "secondary acquired" );
		
		self check_owner();
	}	
}
missile_target_sight_check( missiletarget )
{
	heli2target_normal = vectornormalize( missiletarget.origin - self.origin );
	heli2forward = anglestoforward( self.angles );
	heli2forward_normal = vectornormalize( heli2forward );
	heli_dot_target = vectordot( heli2target_normal, heli2forward_normal );
	
	if ( heli_dot_target >= level.heli_missile_target_cone )
	{
		debug_print3d_simple( "Missile sight: " + heli_dot_target, self, ( 0,0,-40 ), 40 );
		return true;
	}
	return false;
}
missile_valid_target_check( missiletarget )
{
	heli2target_normal = vectornormalize( missiletarget.origin - self.origin );
	heli2forward = anglestoforward( self.angles );
	heli2forward_normal = vectornormalize( heli2forward );
	heli_dot_target = vectordot( heli2target_normal, heli2forward_normal );
	
	if ( heli_dot_target >= level.heli_valid_target_cone )
	{
		return true;
	}
	return false;
}
missile_support( target_player, rof, instantfire, endon_notify )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );	
	 
	if ( isdefined ( endon_notify ) )
		self endon( endon_notify );
			
	self.turret_giveup = false;
	
	if ( !instantfire )
	{
		wait( rof );
		self.turret_giveup = true;
		self notify( "give up" );
	}
	
	if ( isdefined( target_player ) )
	{
		{
			player = self.owner;
			if ( isdefined( player ) && isdefined( player.pers["team"] ) && player.pers["team"] == self.team && distance( player.origin, target_player.origin ) <= level.heli_missile_friendlycare )
			{
				debug_print3d_simple( "Missile omitted due to nearby friendly", self, ( 0,0,-80 ), 40 );
				self notify ( "missile ready" );
				return;
			}
		}
	}
	
	if ( self.missile_ammo > 0 && isdefined( target_player ) )
	{
		self fire_missile( "ffar", 1, target_player );
		self.missile_ammo--;
		self notify( "missile fired" );
	}
	else
	{
		return;
	}
	
	if ( instantfire )
	{
		wait ( rof );
		self notify ( "missile ready" );
	}
}
attack_primary()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	for( ;; )
	{
		if ( isdefined( self.primaryTarget ) )
		{
			self.primaryTarget.antithreat = undefined;
			self.turretTarget = self.primaryTarget;
			
			antithreat = 0;
			last_pos = undefined;
			
			
			
			while( isdefined( self.turretTarget ) && isalive( self.turretTarget ) )
			{
				
				self setTurretTargetEnt( self.turretTarget, ( 0, 0, 40 ) );
				
				self waittill( "turret_on_target" );
				
				
				
				
					
				self notify( "turret on target" );
				
				self thread turret_target_flag( self.turretTarget );
				
				
				wait( level.heli_turret_spinup_delay );
				
				
				weaponShootTime = weaponfiretime( self.defaultWeapon );
				self setVehWeapon( self.defaultWeapon );
				
				
				for( i = 0 ; i < level.heli_turretClipSize ; i++ )
				{
					
					if ( isdefined( self.turretTarget ) && isdefined( self.primaryTarget ) )
					{
						if ( self.primaryTarget != self.turretTarget )
							self setTurretTargetEnt( self.primaryTarget, ( 0, 0, 40 ) );
					}
					else
					{
						if ( isdefined( self.targetlost ) && self.targetlost && isdefined( self.turret_last_pos ) )
						{
							
							self setturrettargetvec( self.turret_last_pos );
						}
						else
						{
							self clearturrettarget();
						}	
					}
					if ( gettime() != self.lastRocketFireTime )
					{
						
						self setVehWeapon( self.defaultWeapon );
						miniGun = self fireWeapon( "tag_flash" );
					}
					
					
					if ( i < level.heli_turretClipSize - 1 )
						wait weaponShootTime;
				}
				self notify( "turret reloading" );
				
				
				
				wait( level.heli_turretReloadTime );
				
				
				if ( isdefined( self.turretTarget ) && isalive( self.turretTarget ) )
				{
					antithreat += 100;
					self.turretTarget.antithreat = antithreat;
				}
				
				
				if ( !isdefined( self.primaryTarget ) || ( isdefined( self.turretTarget ) && isdefined( self.primaryTarget ) && self.primaryTarget != self.turretTarget ) )
					break;
			}
			
			if ( isdefined( self.turretTarget ) )
				self.turretTarget.antithreat = undefined;
		}
		self waittill( "primary acquired" );
		
		
		self check_owner();
	}
}
turret_target_flag( turrettarget )
{
	
	self notify( "flag check is running" );
	self endon( "flag check is running" );
	
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	self endon( "turret reloading" );
	
	
	turrettarget endon( "death" );
	turrettarget endon( "disconnect" );
	
	self.targetlost = false;
	self.turret_last_pos = undefined;
	
	while( isdefined( turrettarget ) )
	{
		heli_centroid = self.origin + ( 0, 0, -160 );
		heli_forward_norm = anglestoforward( self.angles );
		heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
		sight_rec = turrettarget sightconetrace( heli_turret_point, self );
		if ( sight_rec < level.heli_target_recognition )
			break;
		
		wait 0.05;
	}
	
	if( isdefined( turrettarget ) && isdefined( turrettarget.origin ) )
	{
		assertex( isdefined( turrettarget.origin ), "turrettarget.origin is undefined after isdefined check" );
		self.turret_last_pos = turrettarget.origin + ( 0, 0, 40 );
		assertex( isdefined( self.turret_last_pos ), "self.turret_last_pos is undefined after setting it #1" );
		self setturrettargetvec( self.turret_last_pos );
		assertex( isdefined( self.turret_last_pos ), "self.turret_last_pos is undefined after setting it #2" );
		debug_print3d_simple( "Turret target lost at: " + self.turret_last_pos, self, ( 0,0,-70 ), 60 );
		self.targetlost = true;
	}
	else
	{
		self.targetlost = undefined;
		self.turret_last_pos = undefined;
	}
}
debug_print_target()
{
	if ( isdefined( level.heli_debug ) && level.heli_debug == 1.0 )
	{
		
		if( isdefined( self.primaryTarget ) && isdefined( self.primaryTarget.threatlevel ) )
		{
			if ( isdefined(self.primaryTarget.type) && self.primaryTarget.type == "zombie_dog" ) 
				name = "zombie_dog";
			else
				name = self.primaryTarget.name;
			primary_msg = "Primary: " + name + " : " + self.primaryTarget.threatlevel;
		}
		else
			primary_msg = "Primary: ";
			
		if( isdefined( self.secondaryTarget ) && isdefined( self.secondaryTarget.threatlevel ) )
		{
			if ( isdefined(self.secondaryTarget.type) && self.secondaryTarget.type == "zombie_dog" ) 
				name = "zombie_dog";
			else
				name = self.secondaryTarget.name;
			secondary_msg = "Secondary: " + name + " : " + self.secondaryTarget.threatlevel;
		}
		else
			secondary_msg = "Secondary: ";
			
		frames = int( self.targeting_delay*20 )+1;
		
		thread draw_text( primary_msg, (1, 0.6, 0.6), self, ( 0, 0, 40), frames );
		thread draw_text( secondary_msg, (1, 0.6, 0.6), self, ( 0, 0, 0), frames );
	}
}
improved_sightconetrace( helicopter )
{
	
	heli_centroid = helicopter.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( helicopter.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	debug_line( heli_turret_point, self.origin, ( 1, 1, 1 ), 5 );
	start = heli_turret_point;
	yes = 0;
	point = [];
	
	for( i=0; i<5; i++ )
	{
		if( !isdefined( self ) )
			break;
		
		half_height = self.origin+(0,0,36);
		
		tovec = start - half_height;
		tovec_angles = vectortoangles(tovec);
		forward_norm = anglestoforward(tovec_angles);
		side_norm = anglestoright(tovec_angles);
		point[point.size] = self.origin + (0,0,36);
		point[point.size] = self.origin + side_norm*(15, 15, 0) + (0, 0, 10);
		point[point.size] = self.origin + side_norm*(-15, -15, 0) + (0, 0, 10);
		point[point.size] = point[2]+(0,0,64);
		point[point.size] = point[1]+(0,0,64);
		
		
		debug_line( point[1], point[2], (1, 1, 1), 1 );
		debug_line( point[2], point[3], (1, 1, 1), 1 );
		debug_line( point[3], point[4], (1, 1, 1), 1 );
		debug_line( point[4], point[1], (1, 1, 1), 1 );
		
		if( bullettracepassed( start, point[i], true, self ) )
		{
			debug_line( start, point[i], (randomInt(10)/10, randomInt(10)/10, randomInt(10)/10), 1 );
			yes++;
		}
		waittillframeend;
		
	}
	
	return yes/5;
}
targetHelicopterLocation()
{
	level.helilocation = self.origin;
	return true;
} 
  
