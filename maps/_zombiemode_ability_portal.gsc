#include maps\_utility;
#include common_scripts\utility;
init()
{
	level._effect["portal_core"]		= loadfx( "maps/zombie/fx_zombie_portal_core" );
	level._effect["portal_core_exit"]	= loadfx( "maps/zombie/fx_zombie_portal_core_exit" );
	level._effect["portal_wormhole"]	= loadfx( "maps/zombie/fx_zombie_portal_wormhole" );
	level.teleport_ae_funcs = [];
	
	SetDvar( "PortalAftereffectOverride", "-1" );
	if( !IsSplitscreen() )
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = ::teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = ::teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = ::teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = ::teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = ::teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = ::teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = ::teleport_aftereffect_flare_vision;
	level thread spawn_wormhole_fx();
}
spawn_wormhole_fx()
{
	level waittill( "all_players_connected" );
	
	
	level.portal_room_spots = [];
	for ( i=0; i<4; i++ )
	{
		spot			= GetStruct( "player_teleport_" + (i+1), "targetname" );
		if ( IsDefined( spot ) )
		{
			level.portal_room_spots[i] = spot;
			
			fx_forward_vec	= AnglesToForward(spot.angles+(0,180,0));
			fx_org			= spot.origin+(0,0,60) + (vector_scale( AnglesToForward(spot.angles), 100) );
			wormhole_fx = PlayFx( level._effect["portal_wormhole"], fx_org, fx_forward_vec );
		}
	}
}
usePortal( posStart )
{
	level.portalSupportInProgress = true;
	
	
	portalfx = PlayFx( level._effect["portal_core"], posStart );
	
	playsoundatposition("zmb_spawn_portal", posStart);
	portalLoop = spawn( "script_origin", posStart );
	portalLoop playloopsound( "zmb_spawn_portal_loop", 0.2 );
	
	wait( 0.1 );
	flag_set("end_target_confirm");
	
	spawnFlag = 2;
	portal_trig = Spawn( "trigger_radius", posStart, spawnFlag, 50, 1000 );
	
	
	
	spawn_points = check_for_valid_teleport_location( portal_trig.origin );
	if( IsDefined(spawn_points) && (spawn_points.size > 0) )
	{
		
		players = getplayers();
		for ( i = 0; i < players.size; i++ )
		{
			players[i] thread portal_think( portal_trig, spawn_points, i );
		}
	}
	
	wait( 30.0 );
	portal_trig Delete();
	portalLoop stoploopsound( 1.2 );
	level.portalSupportInProgress = undefined;
	wait( 1.5 );
	portalLoop delete();
}
portal_think( trigger, spawn_points, index )
{
	trigger endon( "death" );
	self endon( "death" );
	self endon( "disconnect" );
	
	while( 1 )
	{
		
		trigger waittill( "trigger" );
		
		if( self istouching( trigger ) )
		{
			
			clientnotify( "pt0" );	
			
			self thread teleport_player( spawn_points, index, trigger );
			
			wait( 3.0 );	
		}
	}
}
teleport_player( spawn_points, index, trigger )
{
	self endon( "death" );
	self endon( "disconnect" );
	prone_offset = (0, 0, 20);
	crouch_offset = (0, 0, 20);
	stand_offset = (0, 0, 0);
	
	self disableOffhandWeapons();
	self disableweapons();
	self FreezeControls( true );
	self SetPlayerAngles( level.portal_room_spots[index].angles );
	if ( level.portal_room_spots.size > 0 )
	{
		desired_origin = (0,0,0);	
		if( self getstance() == "prone" )
		{
			desired_origin = level.portal_room_spots[index].origin + prone_offset;
		}
		else if( self getstance() == "crouch" )
		{
			desired_origin = level.portal_room_spots[index].origin + crouch_offset;
		}
		else
		{
			desired_origin = level.portal_room_spots[index].origin + stand_offset;
		}
		
		self.teleport_origin = spawn( "script_origin", self.origin );
		self.teleport_origin.angles = self.angles;
		self linkto( self.teleport_origin );
		self.teleport_origin.origin = desired_origin;
		self.teleport_origin.angles = level.portal_room_spots[index].angles;
		setClientSysState( "levelNotify", "black_box_start", self );
		
		wait( 2 );
	}
	
	spawn_point = find_open_spawn_point( spawn_points, trigger );
	spawn_point thread teleport_nuke( undefined, 200);	
	playfx( level._effect["portal_core_exit"], spawn_point.origin );
	wait_network_frame();
	self unlink();
	if ( IsDefined( self.teleport_origin ) )
	{
		self.teleport_origin delete();
		self.teleport_origin = undefined;
	}
	self enableweapons();
	self enableoffhandweapons();
	self setorigin( spawn_point.origin );
	self setplayerangles( spawn_point.angles );
	self FreezeControls( false );
	self thread teleport_aftereffects();
		
	
}
check_for_valid_teleport_location( portal_origin )
{
	spawn_locs = getstructarray("player_respawn_point", "targetname");
	AssertEx( (spawn_locs.size > 0), "check_for_valid_teleport_location: no repawn locations found!" );
	spawn_locs = array_randomize( spawn_locs );
	location = undefined;
	players = get_players();
	
	for( i = 0 ; i < spawn_locs.size; i++ )
	{
		if (spawn_locs[i].locked == false)
		{
			location = spawn_locs[i];
			too_close = false;
			
			for ( p=0; p<players.size; p++ )
			{
				if ( DistanceSquared( players[p].origin, spawn_locs[i].origin ) < 4000000 )
				{
					too_close = true;
					break;
				}
			}
			if ( !too_close )
			{
				location = spawn_locs[i];
				break;
			}
		}
	}
	if ( IsDefined( location ) )
	{
		spawn_points = GetStructArray( location.target, "targetname" );
		return spawn_points;
	}
	return undefined;
}
find_open_spawn_point( spawn_points, trigger )
{
	players = get_players();
	for ( i=0; i<spawn_points.size; i++ )
	{
		occupied = false;
		
		if ( IsDefined( trigger ) && DistanceSquared( spawn_points[i].origin, trigger.origin ) < 4096 )	
		{
			occupied = true;
		}
		else
		{
			for ( p=0; p<players.size; p++ )
			{
				if ( DistanceSquared( spawn_points[i].origin, players[p].origin ) < 1024 )	
				{
					occupied = true;
					break;
				}
			}
		}
		if ( !occupied )
		{
			return spawn_points[i];
		}
	}
	return spawn_points[0];
}
teleport_nuke( max_zombies, range )
{
	zombies = getaispeciesarray("axis");
	zombies = get_array_of_closest( self.origin, zombies, undefined, max_zombies, range );
	for (i = 0; i < zombies.size; i++)
	{
		wait (randomfloatrange(0.2, 0.3));
		if( !IsDefined( zombies[i] ) )
		{
			continue;
		}
		if( isDefined( zombies[i].animname ) && 
			( zombies[i].animname != "boss_zombie" && zombies[i].animname != "ape_zombie" && zombies[i].animname != "zombie_dog" ) &&
			zombies[i].health < 5000)
		{
			zombies[i] maps\_zombiemode_spawner::zombie_head_gib();
		}
		zombies[i] dodamage( 5000, zombies[i].origin );
		playsoundatposition( "nuked", zombies[i].origin );
	}
}
teleport_aftereffects()
{
	if( GetDvar( #"PortalAftereffectOverride" ) == "-1" )
	{
		self thread [[ level.teleport_ae_funcs[RandomInt(level.teleport_ae_funcs.size)] ]]();
	}
	else
	{
		self thread [[ level.teleport_ae_funcs[int(GetDvar( #"PortalAftereffectOverride" ))] ]]();
	}
}
teleport_aftereffect_shellshock()
{
	println( "*** Explosion Aftereffect***\n" );
	self shellshock( "explosion", 4 );
}
teleport_aftereffect_shellshock_electric()
{
	println( "***Electric Aftereffect***\n" );
	self shellshock( "electrocution", 4 );
}
teleport_aftereffect_fov()
{
	setClientSysState( "levelNotify", "tae", self );
}
teleport_aftereffect_bw_vision( localClientNum )
{
	setClientSysState( "levelNotify", "tae", self );
}
teleport_aftereffect_red_vision( localClientNum )
{
	setClientSysState( "levelNotify", "tae", self );
}
teleport_aftereffect_flashy_vision( localClientNum )
{
	setClientSysState( "levelNotify", "tae", self );
}
teleport_aftereffect_flare_vision( localClientNum )
{
	setClientSysState( "levelNotify", "tae", self );
}  
