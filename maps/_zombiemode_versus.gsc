#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;
init()
{
	
	level.zombiemode_versus = true;
	level.vs_max_teams = 2;
	level.vs_max_ai = 20;				
	level.vs_min_ai_per_team = 5;		
	level.vs_max_ai_per_team = 15;		
	level.vs_team_zones = GetEntArray( "team_volume", "targetname" );
	
	level.vs_teams = [];
	
	for ( i=0; i<2; i++ )
	{
		level.vs_teams[i] = SpawnStruct();
		level.vs_teams[i].max_ai = int(level.vs_max_ai / 2);
		level.vs_teams[i].num_ai = 0;
	}
	
	level.round_spawn_func				= ::vs_round_spawning;
	level.round_think_func				= ::vs_round_think;
	level.create_spawner_list_func		= ::vs_create_spawner_list;
	level.Player_Spawn_func				= ::vs_coop_player_spawn_placement;
	
	get_team_assignments();
	
	zombies = getEntArray( "zombie_spawner", "script_noteworthy" ); 
	array_thread(zombies, ::add_spawn_function, ::vs_zombie_death);
}
get_team_number()
{
	if ( !IsDefined( self.script_index ) )
	{
		for ( i = 0; i < level.vs_team_zones.size; i++ )
		{
			if ( self IsTouching( level.vs_team_zones[i] ) )
			{
				self.script_index = level.vs_team_zones[i].script_index;
			}
		}
	}
}
get_team_assignments()
{
	spawners = GetEntArray( "zombie_spawner", "script_noteworthy" );
	for ( i=0; i<spawners.size; i++ )
	{
		spawners[i] get_team_number();
	}
	switches = GetEntArray("use_elec_switch","targetname");
	for ( i=0; i<switches.size; i++ )
	{
		switches[i] get_team_number();
	}
}
vs_zombie_death()
{
	AssertEx( IsDefined( self.script_index ), "vs_zombie_death: A zombie died without a .script_index defined.  He needs to belong to a team" );
	self waittill( "death" );
	team = level.vs_teams[ self.script_index ];
	team.num_ai--;
	if ( team.max_ai > level.vs_min_ai_per_team )
	{
		team.max_ai--;
	}
	
	if ( self.script_index == 0 )
	{
		enemy_team = level.vs_teams[1];
	}
	else
	{
		enemy_team = level.vs_teams[0];
	}
	if ( enemy_team.max_ai < level.vs_max_ai_per_team )
	{
		enemy_team.max_ai++;
	}
}
vs_coop_player_spawn_placement()
{
	flag_wait( "all_players_connected" ); 
	
	spawn_points = [];
	last_index = [];
	for ( t=0; t<level.vs_max_teams; t++ )
	{
		spawn_points[t] = [];
		last_index[t] = 0;
	}
	
	structs = getstructarray( "initial_spawn_points", "targetname" );
	for ( i=0; i<structs.size; i++ )
	{
		team = structs[i].script_index;
		spawn_points[ team ][ spawn_points[ team ].size ] = structs[i];
	}
	
	players = get_players(); 
	team = 0;
	for( i = 0; i < players.size; i++ )
	{
		spawn_point = spawn_points[team][last_index[team]];
		players[i] setorigin( spawn_point.origin ); 
		players[i] setplayerangles( spawn_point.angles ); 
		players[i].spectator_respawn = spawn_point;
		
		team++;
		if ( team >= level.team_pool.size )
		{
			team = 0;
		}
	}
}
vs_round_spawning()
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
	if( level.intermission )
	{
		return;
	}
	if( level.enemy_spawns.size < 1 )
	{
		ASSERTMSG( "No spawners with targetname zombie_spawner in map." ); 
		return; 
	}
	maps\_zombiemode::ai_calculate_health( level.round_number ); 
	count = 0; 
	max = level.zombie_vars["zombie_max_ai"];
	multiplier = level.round_number / 5;
	if( multiplier < 1 )
	{
		multiplier = 1;
	}
	
	if( level.round_number >= 10 )
	{
		multiplier *= level.round_number * 0.15;
	}
	player_num = get_players().size;
	if( player_num == 1 )
	{
		max += int( ( 0.5 * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	}
	else
	{
		max += int( ( ( player_num - 1 ) * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	}
	if( !isDefined( level.max_zombie_func ) )
	{
		level.max_zombie_func = maps\_zombiemode::default_max_zombie_func;
	}
	
	
	if ( !(IsDefined( level.kill_counter_hud ) && level.zombie_total > 0) )
	{
		level.zombie_total = [[ level.max_zombie_func ]]( max );
	}
	if ( level.round_number < 10 )
	{
		level thread maps\_zombiemode::zombie_speed_up();
	}
	mixed_spawns = 0;	
	
	
	old_spawn = undefined;
	while( level.zombie_total > 0 )
	{
		for ( team_num = 0; team_num < level.vs_teams.size; team_num++ )
		{
			
			if ( !flag("spawn_zombies" ) )
			{
				flag_wait( "spawn_zombies" );
			}
			while( get_enemy_count() > 31 )
			{
				wait( 0.1 );
			}
			team = level.vs_teams[team_num];
			if ( team.num_ai >= team.max_ai )
			{
				wait_network_frame();
				continue;
			}
			
			spawners = level.enemy_spawns[ team_num ];
			spawn_point = spawners[ RandomInt( spawners.size ) ];
			if( !IsDefined( old_spawn ) )
			{
				old_spawn = spawn_point;
			}
			else if( Spawn_point == old_spawn )
			{
				spawn_point = spawners[ RandomInt( spawners.size ) ];
			}
			old_spawn = spawn_point;
			ai = spawn_zombie( spawn_point ); 
			if( IsDefined( ai ) )
			{
				level.zombie_total--;
				count++; 
				team.num_ai++;
			}
			wait( level.zombie_vars["zombie_spawn_delay"] ); 
			wait_network_frame();
		}
	}
}
vs_round_think()
{
	level.zombie_vars["zombie_spawn_delay"] = 1.0;	
	for( ;; )
	{
		
		
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
			maxreward = 500;
		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
		
		level.pro_tips_start_time = getTime();
		maps\_zombiemode::chalk_one_up();
		
		maps\_zombiemode_powerups::powerup_round_start();
		players = get_players();
		array_thread( players, maps\_zombiemode_blockers::rebuild_barrier_reward_reset );
		array_thread( players, maps\_zombiemode_ability::giveHardpointItems );
		level thread maps\_zombiemode::award_grenades_for_survivors();
		bbPrint( "zombie_rounds: round %d player_count %d", level.round_number, players.size );
		level.round_start_time = getTime();
		level [[level.round_spawn_func]]();
		level.first_round = false;
		level notify( "end_of_round" );
		level thread maps\_zombiemode::spectators_respawn();
		level thread maps\_zombiemode::last_stand_revive();
		
		level thread maps\_zombiemode::chalk_round_over();
		wait( level.zombie_vars["zombie_between_round_time"] ); 
		
		if ( level.round_number > 5 )
		{
			
			timer = level.zombie_vars["zombie_spawn_delay"];
			if ( timer > 0.08 )
			{
				level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
			}
			else if ( timer < 0.08 )
			{
				level.zombie_vars["zombie_spawn_delay"] = 0.08;
			}
		}
		
		level.zombie_move_speed = level.round_number * 8;
		level.round_number++;
		level notify( "between_round_over" );
	}
}
vs_create_spawner_list( zkeys )
{
	for ( i=0; i<level.team_pool.size; i++ )
	{
		level.enemy_spawns[i] = [];
		level.enemy_dog_spawns[i] = [];
		level.enemy_dog_locations[i] = [];
		level.zombie_rise_spawners[i] = [];
	}
	for( z=0; z<zkeys.size; z++ )
	{
		zone = level.zones[ zkeys[z] ];
		if ( zone.is_enabled && zone.is_active )
		{
			
			for(x=0;x<zone.spawners.size;x++)
			{
				if ( zone.spawners[x].is_enabled )
				{
					team = zone.spawners[x].script_index;
					level.enemy_spawns[team][ level.enemy_spawns[team].size ] = zone.spawners[x];
				}
			}
			
			for(x=0;x<zone.dog_spawners.size;x++)
			{
				if ( zone.dog_spawners[x].is_enabled )
				{
					team = zone.dog_spawners[x].script_index;
					level.enemy_dog_spawns[team][ level.enemy_dog_spawns[team].size ] = zone.dog_spawners[x];
				}
			}
			
			for(x=0; x<zone.dog_locations.size; x++)
			{
				if ( zone.dog_locations[x].is_enabled )
				{
					team = zone.dog_locations[x].script_index;
					level.enemy_dog_locations[team][ level.enemy_dog_locations[team].size ] = zone.dog_locations[x];
				}
			}
			
			for(x=0; x<zone.rise_locations.size; x++)
			{
				if ( zone.rise_locations[x].is_enabled )
				{
					team = zone.rise_locations[x].script_index;
					level.zombie_rise_spawners[team][ level.zombie_rise_spawners[team].size ] = zone.rise_locations[x];
				}
			}
		}
	}
}  
