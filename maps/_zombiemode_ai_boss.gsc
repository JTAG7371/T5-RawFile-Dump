#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include animscripts\zombie_Utility;
init()
{
	PrecacheRumble( "explosion_generic" );
	init_boss_zombie_anims();
	
	level._effect["boss_groundhit"] = loadfx("maps/zombie/fx_zombie_boss_grnd_hit");
	level._effect["boss_spawn"] = loadfx("maps/zombie/fx_zombie_boss_spawn");
	
	
	
	if( !isDefined( level.boss_zombie_spawn_heuristic ) )
	{
		level.boss_zombie_spawn_heuristic = maps\_zombiemode_ai_boss::boss_zombie_default_spawn_heuristic;
	}
	
	
	
	if( !isDefined( level.boss_zombie_pathfind_heuristic ) )
	{
		level.boss_zombie_pathfind_heuristic = maps\_zombiemode_ai_boss::boss_zombie_default_pathfind_heuristic;
	}
	if ( !isDefined( level.boss_zombie_enter_level ) )
	{
		level.boss_zombie_enter_level = maps\_zombiemode_ai_boss::boss_zombie_default_enter_level;
	}
	precacheshellshock( "electrocution" );
	
	
	level.boss_idle_nodes = GetNodeArray( "boss_idle", "script_noteworthy" );
	
	level.num_boss_zombies = 0;
	level.boss_zombie_spawners = GetEntArray( "boss_zombie_spawner", "targetname" );
	array_thread( level.boss_zombie_spawners, ::add_spawn_function, maps\_zombiemode_ai_boss::boss_prespawn );
	
	if( !isDefined( level.max_boss_zombies ) )
	{
		level.max_boss_zombies = 1;
	}
	if( !isDefined( level.boss_respawn_timer ) )
	{
		level.boss_respawn_timer = 30;
	}
	if( !isDefined( level.boss_zombie_health_mult ) )
	{
		level.boss_zombie_health_mult = 7;
	}
	if( !isDefined( level.boss_zombie_damage_mult ) )
	{
		level.boss_zombie_damage_mult = 2;
	}
	if( !isDefined( level.boss_zombie_min_health ) )
	{
		level.boss_zombie_min_health = 5000;
	}
	if( !isDefined( level.boss_zombie_scream_a_chance ) )
	{
		level.boss_zombie_scream_a_chance = 100;
	}
	if( !isDefined( level.boss_zombie_scream_a_radius ) )
	{
		level.boss_zombie_scream_a_radius_sq = 512*512;
	}
	if( !isDefined( level.boss_zombie_scream_b_chance ) )
	{
		level.boss_zombie_scream_b_chance = 0;
	}
	if( !isDefined( level.boss_zombie_scream_b_radius ) )
	{
		level.boss_zombie_scream_b_radius_sq = 512*512;
	}
	if( !isDefined( level.boss_zombie_groundhit_damage ) )
	{
		level.boss_zombie_groundhit_damage = 90;
	}
	if( !isDefined( level.boss_zombie_groundhit_radius ) )
	{
		level.boss_zombie_groundhit_radius = 256;
	}
	if( !isDefined( level.boss_zombie_proximity_wake ) )
	{
		level.boss_zombie_proximity_wake = 1296;
	}
	if( !isDefined( level.boss_thundergun_damage ) )
	{
		level.boss_thundergun_damage = 1000;
	}
	if( !isDefined( level.boss_fire_damage ) )
	{
		level.boss_fire_damage = 500;
	}
	if( !isDefined( level.boss_ground_attack_delay ) )
	{
		level.boss_ground_attack_delay = 5000;
	}
	
	
	
	firstSpawners = GetEntArray( "first_boss_spawner", "script_noteworthy" );
	
	if( isDefined( firstSpawners ) && firstSpawners.size > 0 )
	{
		if( firstSpawners.size > level.max_boss_zombies )
		{
			chosenSpawners = [];
			while( chosenSpawners.size < level.max_boss_zombies )
			{
				index = RandomInt( firstSpawners.size );
				if( firstSpawners[index].script_string == "boss" ) 
				{
					chosenSpawners = array_add( chosenSpawners, firstSpawners[index] );
				}
				firstSpawners = array_remove( firstSpawners, firstSpawners[index] );
			}
		}
		else
		{
			chosenSpawners = firstSpawners;
		}
		
		for( i = 0; i < chosenSpawners.size; i++ )
		{
			chosenSpawners[i] boss_zombie_spawn();
		}
	}
	
	level thread boss_zombie_manager();
	
	level.ammo_spawn = true;
	level.boss_death = 0;
	level.boss_death_ammo = 2;
	level.boss_health_reduce = 0.7;
	level thread boss_adjust_max_ammo();
}
#using_animtree( "generic_human" );
boss_prespawn()
{
	self.animname = "boss_zombie";
	
	self.custom_idle_setup = maps\_zombiemode_ai_boss::boss_zombie_idle_setup;
	
	self.damage_mult = level.boss_zombie_damage_mult;
	self.a.idleAnimOverrideArray = [];
	self.a.idleAnimOverrideArray["stand"] = [];
	self.a.idleAnimOverrideWeights["stand"] = [];
	self.a.idleAnimOverrideArray["stand"][0][0] 	= %ai_zombie_boss_idle_a;
	self.a.idleAnimOverrideWeights["stand"][0][0] 	= 10;
	self.a.idleAnimOverrideArray["stand"][0][1] 	= %ai_zombie_boss_idle_b;
	self.a.idleAnimOverrideWeights["stand"][0][1] 	= 10;
	self.ignoreall = true; 
	self.allowdeath = true; 			
	self.is_zombie = true; 			
	self.has_legs = true; 			
															
	self allowedStances( "stand" ); 
	self.gibbed = false; 
	self.head_gibbed = false;
	
	
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatInitialized = false; 
	self.a.disablePain = true;
	self disable_react(); 
	
	
	self.freezegun_damage = 0;
	
	self.dropweapon = false; 
	self thread maps\_zombiemode_spawner::zombie_damage_failsafe();
	self thread maps\_zombiemode_spawner::delayed_zombie_eye_glow();	
	self.flame_damage_time = 0;
	self.meleeDamage = 50;
	self.no_powerups = true;
	self thread maps\_zombiemode_ai_boss::boss_set_airstrike_damage();
	self.thundergun_disintegrate_func = ::boss_thundergun_disintegrate;
	self.thundergun_fling_func = ::boss_thundergun_disintegrate;
	self.fire_damage_func = ::boss_fire_damage;
	
	self.custom_damage_func = ::boss_custom_damage;
	self.actor_damage_func = ::boss_actor_damage;
	self.nuke_damage_func = ::boss_nuke_damage;
	self.noChangeDuringMelee = true;
	self setTeamForEntity( "axis" );
	self setPhysParams( 18, 0, 72 );
	self notify( "zombie_init_done" );
}
boss_health_watch()
{
	self endon( "death" );
	while ( 1 )
	{
		
		wait( 1 );
	}
}
boss_set_airstrike_damage()
{
	flag_wait( "all_players_connected" );
	players = GetPlayers();
	if ( players.size == 4 )
	{
		self.maxAirstrikeDamage = 125;
	}
	else
	{
		self.maxAirstrikeDamage = 100;
	}
}
boss_zombie_idle_setup()
{
	self.a.array["turn_left_45"] = %exposed_tracking_turn45L;
	self.a.array["turn_left_90"] = %exposed_tracking_turn90L;
	self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
	self.a.array["turn_left_180"] = %exposed_tracking_turn180L;
	self.a.array["turn_right_45"] = %exposed_tracking_turn45R;
	self.a.array["turn_right_90"] = %exposed_tracking_turn90R;
	self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
	self.a.array["turn_right_180"] = %exposed_tracking_turn180L;
	self.a.array["exposed_idle"] = array( %ai_zombie_boss_idle_a, %ai_zombie_boss_idle_b );
	self.a.array["straight_level"] = %ai_zombie_boss_idle_a;
	self.a.array["stand_2_crouch"] = %ai_zombie_shot_leg_right_2_crawl;
}
init_boss_zombie_anims()
{
	
	level.scr_anim["boss_zombie"]["death1"] 	= %ai_zombie_boss_death;
	level.scr_anim["boss_zombie"]["death2"] 	= %ai_zombie_boss_death_a;
	level.scr_anim["boss_zombie"]["death3"] 	= %ai_zombie_boss_death_explode;
	level.scr_anim["boss_zombie"]["death4"] 	= %ai_zombie_boss_death_mg;
	
	
	level.scr_anim["boss_zombie"]["walk1"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk2"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk3"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk4"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk5"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk6"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk7"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["walk8"] 	= %ai_zombie_boss_walk_a;
	level.scr_anim["boss_zombie"]["run1"] 	= %ai_zombie_walk_fast_v1;
	level.scr_anim["boss_zombie"]["run2"] 	= %ai_zombie_walk_fast_v2;
	level.scr_anim["boss_zombie"]["run3"] 	= %ai_zombie_walk_fast_v3;
	level.scr_anim["boss_zombie"]["run4"] 	= %ai_zombie_run_v2;
	level.scr_anim["boss_zombie"]["run5"] 	= %ai_zombie_run_v4;
	level.scr_anim["boss_zombie"]["run6"] 	= %ai_zombie_run_v3;
	level.scr_anim["boss_zombie"]["sprint1"] = %ai_zombie_boss_sprint_a;
	level.scr_anim["boss_zombie"]["sprint2"] = %ai_zombie_boss_sprint_a;
	level.scr_anim["boss_zombie"]["sprint3"] = %ai_zombie_boss_sprint_b;
	level.scr_anim["boss_zombie"]["sprint4"] = %ai_zombie_boss_sprint_b;
	
	level.scr_anim["boss_zombie"]["crawl1"] 	= %ai_zombie_crawl;
	level.scr_anim["boss_zombie"]["crawl2"] 	= %ai_zombie_crawl_v1;
	level.scr_anim["boss_zombie"]["crawl3"] 	= %ai_zombie_crawl_v2;
	level.scr_anim["boss_zombie"]["crawl4"] 	= %ai_zombie_crawl_v3;
	level.scr_anim["boss_zombie"]["crawl5"] 	= %ai_zombie_crawl_v4;
	level.scr_anim["boss_zombie"]["crawl6"] 	= %ai_zombie_crawl_v5;
	level.scr_anim["boss_zombie"]["crawl_hand_1"] = %ai_zombie_walk_on_hands_a;
	level.scr_anim["boss_zombie"]["crawl_hand_2"] = %ai_zombie_walk_on_hands_b;
	level.scr_anim["boss_zombie"]["crawl_sprint1"] 	= %ai_zombie_crawl_sprint;
	level.scr_anim["boss_zombie"]["crawl_sprint2"] 	= %ai_zombie_crawl_sprint_1;
	level.scr_anim["boss_zombie"]["crawl_sprint3"] 	= %ai_zombie_crawl_sprint_2;
	if( !isDefined( level._zombie_melee ) )
	{
		level._zombie_melee = [];
	}
	if( !isDefined( level._zombie_walk_melee ) )
	{
		level._zombie_walk_melee = [];
	}
	if( !isDefined( level._zombie_run_melee ) )
	{
		level._zombie_run_melee = [];
	}
	level._zombie_melee["boss_zombie"] = [];
	level._zombie_walk_melee["boss_zombie"] = [];
	level._zombie_run_melee["boss_zombie"] = [];
	level._zombie_melee["boss_zombie"][0] 				= %ai_zombie_boss_attack_multiswing_a; 
	level._zombie_melee["boss_zombie"][1] 				= %ai_zombie_boss_attack_multiswing_b; 
	level._zombie_melee["boss_zombie"][2] 				= %ai_zombie_boss_attack_swing_overhead; 
	level._zombie_melee["boss_zombie"][3] 				= %ai_zombie_boss_attack_swing_swipe;	
	level._zombie_melee["boss_zombie"][3] 				= %ai_zombie_boss_headbutt;	
	if( isDefined( level.boss_zombie_anim_override ) )
	{
		[[ level.boss_zombie_anim_override ]]();
	}
	
	
	level._zombie_run_melee["boss_zombie"][0]				=	%ai_zombie_boss_attack_running;
	level._zombie_run_melee["boss_zombie"][1]				=	%ai_zombie_boss_attack_sprinting;
	level._zombie_run_melee["boss_zombie"][2]				=	%ai_zombie_boss_attack_running;
	
	if( !isDefined( level._zombie_melee_crawl ) )
	{
		level._zombie_melee_crawl = [];
	}
	level._zombie_melee_crawl["boss_zombie"] = [];
	level._zombie_melee_crawl["boss_zombie"][0] 		= %ai_zombie_attack_crawl; 
	level._zombie_melee_crawl["boss_zombie"][1] 		= %ai_zombie_attack_crawl_lunge;
	if( !isDefined( level._zombie_stumpy_melee ) )
	{
		level._zombie_stumpy_melee = [];
	}
	level._zombie_stumpy_melee["boss_zombie"] = [];
	level._boss_zombie_stumpy_melee["boss_zombie"][0] = %ai_zombie_walk_on_hands_shot_a;
	level._boss_zombie_stumpy_melee["boss_zombie"][1] = %ai_zombie_walk_on_hands_shot_b;
	
	if( !isDefined( level._zombie_tesla_deaths ) )
	{
		level._zombie_tesla_deaths = [];
	}
	level._zombie_tesla_death["boss_zombie"] = [];
	level._zombie_tesla_death["boss_zombie"][0] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][1] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][2] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][3] = %ai_zombie_boss_tesla_death_a;
	level._zombie_tesla_death["boss_zombie"][4] = %ai_zombie_boss_tesla_death_a;
	if( !isDefined( level._zombie_tesla_crawl_death ) )
	{
		level._zombie_tesla_crawl_death = [];
	}
	level._zombie_tesla_crawl_death["boss_zombie"] = [];
	level._zombie_tesla_crawl_death["boss_zombie"][0] = %ai_zombie_tesla_crawl_death_a;
	level._zombie_tesla_crawl_death["boss_zombie"][1] = %ai_zombie_tesla_crawl_death_b;
	
	if( !isDefined( level._zombie_deaths ) )
	{
		level._zombie_deaths = [];
	}
	level._zombie_deaths["boss_zombie"] = [];
	level._zombie_deaths["boss_zombie"][0] = %ai_zombie_boss_death;
	level._zombie_deaths["boss_zombie"][1] = %ai_zombie_boss_death_a;
	level._zombie_deaths["boss_zombie"][2] = %ai_zombie_boss_death_explode;
	level._zombie_deaths["boss_zombie"][3] = %ai_zombie_boss_death_mg;
	
	
	if( !isDefined( level._zombie_rise_anims ) )
	{
		level._zombie_rise_anims = [];
	}
	level._zombie_rise_anims["boss_zombie"] = [];
	level._zombie_rise_anims["boss_zombie"][1]["walk"][0]		= %ai_zombie_traverse_ground_v1_walk;
	level._zombie_rise_anims["boss_zombie"][1]["run"][0]		= %ai_zombie_traverse_ground_v1_run;
	level._zombie_rise_anims["boss_zombie"][1]["sprint"][0]	= %ai_zombie_traverse_ground_climbout_fast;
	level._zombie_rise_anims["boss_zombie"][2]["walk"][0]		= %ai_zombie_traverse_ground_v2_walk_altA;
	
	if( !isDefined( level._zombie_rise_death_anims ) )
	{
		level._zombie_rise_death_anims = [];
	}
	level._zombie_rise_death_anims["boss_zombie"] = [];
	level._zombie_rise_death_anims["boss_zombie"][1]["in"][0]		= %ai_zombie_traverse_ground_v1_deathinside;
	level._zombie_rise_death_anims["boss_zombie"][1]["in"][1]		= %ai_zombie_traverse_ground_v1_deathinside_alt;
	level._zombie_rise_death_anims["boss_zombie"][1]["out"][0]		= %ai_zombie_traverse_ground_v1_deathoutside;
	level._zombie_rise_death_anims["boss_zombie"][1]["out"][1]		= %ai_zombie_traverse_ground_v1_deathoutside_alt;
	level._zombie_rise_death_anims["boss_zombie"][2]["in"][0]		= %ai_zombie_traverse_ground_v2_death_low;
	level._zombie_rise_death_anims["boss_zombie"][2]["in"][1]		= %ai_zombie_traverse_ground_v2_death_low_alt;
	level._zombie_rise_death_anims["boss_zombie"][2]["out"][0]		= %ai_zombie_traverse_ground_v2_death_high;
	level._zombie_rise_death_anims["boss_zombie"][2]["out"][1]		= %ai_zombie_traverse_ground_v2_death_high_alt;
	
	
	if( !isDefined( level._zombie_run_taunt ) )
	{
		level._zombie_run_taunt = [];
	}
	if( !isDefined( level._zombie_board_taunt ) )
	{
		level._zombie_board_taunt = [];
	}
	
	level._zombie_run_taunt["boss_zombie"] = [];
	level._zombie_board_taunt["boss_zombie"] = [];
	
	level._zombie_board_taunt["boss_zombie"][0] = %ai_zombie_taunts_4;
	level._zombie_board_taunt["boss_zombie"][1] = %ai_zombie_taunts_7;
	level._zombie_board_taunt["boss_zombie"][2] = %ai_zombie_taunts_9;
	level._zombie_board_taunt["boss_zombie"][3] = %ai_zombie_taunts_5b;
	level._zombie_board_taunt["boss_zombie"][4] = %ai_zombie_taunts_5c;
	level._zombie_board_taunt["boss_zombie"][5] = %ai_zombie_taunts_5d;
	level._zombie_board_taunt["boss_zombie"][6] = %ai_zombie_taunts_5e;
	level._zombie_board_taunt["boss_zombie"][7] = %ai_zombie_taunts_5f;
}
boss_zombie_spawn()
{
	self.script_moveoverride = true; 
	
	if( !isDefined( level.num_boss_zombies ) )
	{
		level.num_boss_zombies = 0;
	}
	level.num_boss_zombies++;
	
	boss_zombie = self maps\_zombiemode_net::network_safe_stalingrad_spawn( "boss_zombie_spawn", 1 );
	
	
	
	self playsound( "zmb_engineer_spawn" );
	
	self.count = 666; 
	self.last_spawn_time = GetTime();
	if( !spawn_failed( boss_zombie ) ) 
	{ 
		boss_zombie.script_noteworthy = self.script_noteworthy;
		boss_zombie.targetname = self.targetname;
		boss_zombie.target = self.target;
		boss_zombie.deathFunction = maps\_zombiemode_ai_boss::boss_zombie_die;
		boss_zombie.animname = "boss_zombie";
	
		boss_zombie thread boss_zombie_think();
		
		if( isDefined( level.boss_zombie_death_pos ) && level.boss_zombie_death_pos.size > 0 )
		{
			level.boss_zombie_death_pos = array_remove( level.boss_zombie_death_pos, level.boss_zombie_death_pos[0] );
		}
	}
	else
	{
		level.num_boss_zombies--;
	}
}
boss_zombie_manager()
{
	
	start_boss = getent( "start_boss_spawner", "script_noteworthy" );
	if ( isDefined( start_boss ) )
	{
		while ( true )
		{
			if ( level.num_boss_zombies < level.max_boss_zombies )
			{
				start_boss boss_zombie_spawn();
				break;
			}
			wait( 0.5 );
		}
	}
	while( true ) 
	{
		AssertEx( isDefined( level.num_boss_zombies ) && isDefined( level.max_boss_zombies ), "Either max_boss_zombies or num_boss_zombies not defined, this should never be the case!" );
		while( level.num_boss_zombies < level.max_boss_zombies ) 
		{
			spawner = boss_zombie_pick_best_spawner();
			if( isDefined( spawner ) )
			{
				spawner boss_zombie_spawn();
			}
			wait( 10 );
		}
		wait( 10 );
	}
}
boss_zombie_pick_best_spawner()
{
	best_spawner = undefined;
	best_score = -1;
	for( i = 0; i < level.boss_zombie_spawners.size; i++ )
	{
		score = [[ level.boss_zombie_spawn_heuristic ]]( level.boss_zombie_spawners[i] );
		if( score > best_score )
		{
			best_spawner = level.boss_zombie_spawners[i];
			best_score = score;
		}
	}
	return best_spawner;
}
boss_zombie_think()
{
	self endon( "death" );
	
	self.is_activated = false;
	self.entered_level = false;
	
	self thread boss_zombie_check_for_activation();
	self thread boss_zombie_check_player_proximity();
	self thread boss_zombie_choose_run();
	
	
	
	self.ignoreall = false;
	self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;
	self.maxhealth = level.zombie_health * level.boss_zombie_health_mult;
	self.health = level.zombie_health * level.boss_zombie_health_mult;
	
	if( self.maxhealth < level.boss_zombie_min_health )
	{
		self.maxhealth = level.boss_zombie_min_health;
		self.health = level.boss_zombie_min_health;
	}
	if ( level.boss_health_reduce < 1.0 )
	{
		reduce = int( self.health * level.boss_health_reduce );
		level.boss_health_reduce += 0.1;
		self.health = reduce;
		self.maxhealth = reduce;
	}
	else
	{
		level.boss_health_reduce = 1.0;
	}
	players = GetPlayers();
	if ( players.size == 4 )
	{
		bonus = int( self.health * .5 );
		self.maxhealth += bonus;
		self.health += bonus;
	}
	
	
	self.maxsightdistsqrd = 96 * 96;
	
	self.zombie_move_speed = "walk";
	
	self thread [[ level.boss_zombie_enter_level ]]();
	if ( isDefined( level.boss_zombie_custom_think ) )
	{
		self thread [[ level.boss_zombie_custom_think ]]();
	}
	while( true )
	{
		if ( !self.entered_level )
		{
			wait_network_frame();
			continue;
		}
		else if ( isDefined( self.custom_think ) && self.custom_think )
		{
			wait_network_frame();
			continue;
		}
		else if( isDefined( self.performing_activation ) && self.performing_activation ) 
		{
			wait_network_frame();
			continue;
		}
		else if ( isDefined( self.ground_hit ) && self.ground_hit )
		{
			wait_network_frame();
			continue;
		}
		else if( !isDefined( self.following_player ) || !self.following_player ) 
		{
			self thread maps\_zombiemode_spawner::find_flesh();
			self.following_player = true;
		}
		wait( 1 );
	}
}
boss_zombie_pick_idle_point()
{
	best_score = -1;
	best_node = undefined;
	
	for( i = 0; i < level.boss_idle_nodes.size; i++ )
	{
		score = [[ level.boss_zombie_pathfind_heuristic ]]( level.boss_idle_nodes[i] );
		
		if( score > best_score )
		{
			best_score = score;
			best_node = level.boss_idle_nodes[i];
		}
	}
	
	return best_node;
}
boss_zombie_default_pathfind_heuristic( node ) 
{
	
	if( !isDefined( node.targetname ) || !isDefined( level.zones[node.targetname] ) )
	{
		return -1;
	}
	
	
	if( isDefined( node.is_claimed ) && node.is_claimed && ( !isDefined( self.curr_idle_node ) || self.curr_idle_node != node ) )
	{
		return -1;
	}
	
	players = get_players();
	score = 0;
	
	for( i = 0; i < players.size; i++ )
	{
		dist = distanceSquared( node.origin, players[i].origin );
		if( dist > 10000*10000 )
		{
			dist = 10000*10000;
		}
		if( dist <= 1 )
		{
			score += 10000*10000;
			continue;
		}
		score += int( 10000*10000/dist );
	}
	
	return score;
}
boss_zombie_default_spawn_heuristic( spawner )
{
	if( isDefined( spawner.last_spawn_time ) && (GetTime() - spawner.last_spawn_time < 30000) )
	{
		return -1;
	}
	
	if( !isDefined( spawner.script_noteworthy ) )
	{
		return -1;
	}
	if( spawner.script_noteworthy != "first_boss_spawner" && (!isDefined( level.zones ) || !isDefined( level.zones[ spawner.script_noteworthy ] ) || !level.zones[ spawner.script_noteworthy ].is_enabled ) )
	{
		return -1;
	}
	
	score = 0;
	
	
	if( !isDefined( level.boss_zombie_death_pos ) || level.boss_zombie_death_pos.size == 0 )
	{
		players = get_players();
		
		for( i = 0; i < players.size; i++ )
		{
			score = int( distanceSquared( spawner.origin, players[i].origin ) );
		}
	}
	else
	{
		dist = int( distanceSquared( level.boss_zombie_death_pos[0], spawner.origin ) );
		if( dist > 10000*10000 )
		{
			dist = 10000*10000;
		}
		if( dist <= 1 )
		{
			dist = 1;
			
		}
		score = int( 10000*10000/dist );
	}
	
	return score;
}
boss_zombie_choose_run()
{
	self endon( "death" );
	
	while( true ) 
	{
		if( self.is_activated )
		{
			self.zombie_move_speed = "sprint";
			if ( level.round_number > 20 )
			{
				self.moveplaybackrate = 1.0;
			}
			else if ( level.round_number > 15 )
			{
				self.moveplaybackrate = 0.95;
			}
			else if ( level.round_number > 10 )
			{
				self.moveplaybackrate = 0.90;
			}
			else if ( level.round_number > 5 )
			{
				self.moveplaybackrate = 0.85;
			}
			else 
			{
				self.moveplaybackrate = 0.8;
			}
			rand = randomIntRange( 1, 4 );
			self set_run_anim( "sprint"+rand );
			self.run_combatanim = level.scr_anim["boss_zombie"]["sprint"+rand];
			self.crouchRunAnim = level.scr_anim["boss_zombie"]["sprint"+rand];
			self.crouchrun_combatanim = level.scr_anim["boss_zombie"]["sprint"+rand];
			self.needs_run_update = true;
			randf = randomFloatRange( 2, 3 );
			wait( randf );
		}
		else
		{
			self.zombie_move_speed = "walk";
			self set_run_anim( "walk1" );
			self.run_combatanim = level.scr_anim["boss_zombie"]["walk1"];
			self.crouchRunAnim = level.scr_anim["boss_zombie"]["walk1"];
			self.crouchrun_combatanim = level.scr_anim["boss_zombie"]["walk1"];
			self.needs_run_update = true;
		}
		wait( 0.05 );
	}
}
boss_zombie_health_manager()
{
	self endon( "death" );
	
	self thread wait_for_round_over();
	self thread wait_for_activation();
	
	while( true )
	{
		self waittill( "update_health" ); 
		self.maxhealth = level.zombie_health * level.boss_zombie_health_mult;
		self.health = level.zombie_health * level.boss_zombie_health_mult;
		if( self.maxhealth < level.boss_zombie_min_health )
		{
			self.maxhealth = level.boss_zombie_min_health;
			self.health = level.boss_zombie_min_health;
		}
		if( self.is_activated )
		{
			return;
		}
		wait( 0.05 );
	}
}
wait_for_round_over()
{
	self endon( "stop_managing_health" );
	
	while( true )
	{
		level waittill( "between_round_over" );
		self notify( "update_health" );
		wait( 0.05 );
	}
}
wait_for_activation()
{
	self waittill( "boss_activated" );
	self notify( "update_health" );
	self notify( "stop_managing_health" );
}
boss_zombie_check_player_proximity()
{
	self endon( "death" );
	while ( 1 )
	{
		if ( isdefined( self.performing_activation ) && self.performing_activation )
		{
			break;
		}
		players = getplayers();
		for ( i = 0; i < players.size; i++ )
		{
			dist = DistanceSquared( self.origin, players[i].origin );
			
			if ( dist < level.boss_zombie_proximity_wake )
			{
				self notify( "hit_player" );
				break;
			}
		}
		wait_network_frame();
	}
}
boss_zombie_update_proximity_wake()
{
	while ( !isdefined( level.round_number ) )
	{
		wait( 1 );
	}
	while ( 1 )
	{
		if ( level.round_number >= 20 )
		{
			level.boss_zombie_proximity_wake = 120;
			break;
		}
		else if ( level.round_number >= 15 )
		{
			level.boss_zombie_proximity_wake = 102;
		}
		else if ( level.round_number >= 10 )
		{
			level.boss_zombie_proximity_wake = 84;
		}
		wait( 1 );
	}
}
boss_zombie_check_for_activation()
{
	self endon( "death" );
	
	if( self.is_activated == true )
	{
		if( isDefined( self.curr_idle_node ) )
		{
			self.curr_idle_node.is_claimed = false;
		}
		return;
	}
	while( !self.entered_level )
	{
		wait_network_frame();
	}
		
	self waittill_either( "damage", "hit_player" );
	
	self notify( "stop_finding_flesh" );
	self.following_player = false;
	self.performing_activation = true;
	self.ground_hit = true;
	self thread scream_a_watcher( "groundhit_anim" );
	self thread groundhit_watcher( "groundhit_anim" );
	
	
	
	
	self playsound( "zmb_engineer_vocals_hit" );
	
	time = getAnimLength( %ai_zombie_boss_enrage_start );
	
	self animscripted( "groundhit_anim", self.origin, self.angles, %ai_zombie_boss_enrage_start, "normal", %body, 3 );
	
	time = time / 3.0;
	wait( time );
	
	self notify( "stop_activation_sequence" );
	self.performing_activation = false;
	self.ground_hit = false;
	
	self.is_activated = true;
	
	self notify( "boss_activated" );
	
	if( isDefined( self.curr_idle_node ) )
	{
		self.curr_idle_node.is_claimed = false;
	}
	
	self thread boss_zombie_ground_hit_think();
}
boss_zombie_shockwave_attack()
{
	self endon( "death" );
	if ( IsDefined( self.performing_activation ) && self.performing_activation )
	{
		return;
	}
	
	self notify( "stop_finding_flesh" );
	self.following_player = false;
	self.performing_activation = true;
	self thread groundhit_watcher( "groundhit_anim" );
	
	
	
	self playsound( "zmb_engineer_vocals_hit" );
	
	time = getAnimLength( %ai_zombie_boss_enrage_start );
	
	self animscripted( "groundhit_anim", self.origin, self.angles, %ai_zombie_boss_enrage_start );
	
	wait( time );
	
	self.performing_activation = false;
}
boss_zombie_ground_hit()
{
	self endon( "death" );
	if ( self.ground_hit )
	{
		return;
	}
	
	self notify( "stop_finding_flesh" );
	self.following_player = false;
	self.ground_hit = true;
	self thread groundhit_watcher( "groundhit_anim" );
	
	
	
	time = getAnimLength( %ai_zombie_boss_run_hitground );
	delta = getMoveDelta( %ai_zombie_boss_run_hitground, 0, 1 );
	d = length( delta );
	
	
	self SetFlaggedAnimKnobAllRestart( "groundhit_anim", %ai_zombie_boss_run_hitground, %body, 1, .1, 1 );
	
	animscripts\traverse\zombie_shared::wait_anim_length(%ai_zombie_boss_run_hitground, .02);
	
	self.ground_hit = false;
	self.nextGroundHit = GetTime() + level.boss_ground_attack_delay;
	self thread animscripts\zombie_combat::main();
}
boss_zombie_ground_hit_think()
{
	self endon( "death" );
	self.ground_hit = false;
	self.nextGroundHit = GetTime() + level.boss_ground_attack_delay;
	while( 1 )
	{
		if ( !self.ground_hit && GetTime() >= self.nextGroundHit )
		{
			players = GetPlayers();
			closeEnough = false;
			origin = self GetEye();
			for ( i = 0; i < players.size; i++ )
			{
				if ( players[i] maps\_laststand::player_is_in_laststand() )
				{
					continue;
				}
				test_origin = players[i] GetEye();
				d = DistanceSquared( origin, test_origin );
				if ( d > level.boss_zombie_groundhit_radius * level.boss_zombie_groundhit_radius )
				{
					continue;
				}
				if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
				{
					continue;
				}
				closeEnough = true;
				break;
			}
			if ( closeEnough )
			{
				self animcustom( ::boss_zombie_ground_hit );
			}
		}
		wait_network_frame();
	}
}
scream_a_watcher( animname )
{
	self endon( "death" );
	rand = RandomInt( 100 );
	if( rand > level.boss_zombie_scream_a_chance )
	{
		return; 
	}
	
	self waittillmatch( animname, "scream_a" );
	
	players = get_players();
	affected_players = [];
	for( i = 0; i < players.size; i++ )
	{
		if( distanceSquared( players[i].origin, self.origin ) < level.boss_zombie_scream_a_radius_sq )
		{
			affected_players = array_add( affected_players, players[i] );
		}
	}
	for( i = 0; i < affected_players.size; i++ )
	{
		affected_players[i] ShellShock( "electrocution", 1.5, true );
	}
}
groundhit_watcher( animname )
{
	self endon( "death" );
	self waittillmatch( animname, "wrench_hit" );
	
	playfxontag(level._effect["boss_groundhit"],self,"tag_origin");
	
	origin = self GetEye();
	zombies = get_array_of_closest( origin, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, level.boss_zombie_groundhit_radius );
	if ( IsDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( !IsDefined( zombies[i] ) )
			{
				continue;
			}
			if ( is_magic_bullet_shield_enabled( zombies[i] ) )
			{
				continue;
			}
			test_origin = zombies[i] GetEye();
			if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
			{
				continue;
			}
			if ( zombies[i] == self )
			{
				continue;
			}
			if ( zombies[i].animname == "boss_zombie" )
			{
				continue;
			}
			refs = []; 
			refs[refs.size] = "guts"; 
			refs[refs.size] = "right_arm"; 
			refs[refs.size] = "left_arm"; 
			refs[refs.size] = "right_leg"; 
			refs[refs.size] = "left_leg"; 
			refs[refs.size] = "no_legs"; 
			refs[refs.size] = "head"; 
			if( refs.size )
			{
				zombies[i].a.gib_ref = random( refs ); 
			}
			zombies[i] DoDamage( zombies[i].health + 666, self.origin, self );
		}
	}
	players = get_players();
	affected_players = [];
	for( i = 0; i < players.size; i++ )
	{
		test_origin = players[i] GetEye();
		if( distanceSquared( origin, test_origin ) > level.boss_zombie_groundhit_radius * level.boss_zombie_groundhit_radius )
		{
			continue;
		}
		if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
		{
			continue;
		}
		affected_players = array_add( affected_players, players[i] );
	}
	for( i = 0; i < affected_players.size; i++ )
	{
		
		affected_players[i] ShellShock( "electrocution", 1.5, true );
	}
}
scream_b_watcher( animname )
{
	self endon( "death" );
	rand = RandomInt( 100 );
	if( rand > level.boss_zombie_scream_b_chance )
	{
		return; 
	}
	
	self waittillmatch( animname, "scream_b" );
	
	players = get_players();
	affected_players = [];
	for( i = 0; i < players.size; i++ )
	{
		if( distanceSquared( players[i].origin, self.origin ) < level.boss_zombie_scream_b_radius_sq )
		{
			affected_players = array_add( affected_players, players[i] );
		}
	}
	for( i = 0; i < affected_players.size; i++ )
	{
		affected_players[i] ShellShock( "electrocution", 1.5, true );
	}
}
boss_zombie_die()
{
	self maps\_zombiemode_spawner::reset_attack_spot();
	self.grenadeAmmo = 0;
	if( isDefined( self.curr_idle_node ) )
	{
		self.curr_idle_node.is_claimed = false;
	}
	
	
	
	self playsound( "zmb_engineer_death_bells" );
	
	
	
	level maps\_zombiemode_spawner::zombie_death_points( self.origin, self.damagemod, self.damagelocation, self.attacker,self );
	if( self.damagemod == "MOD_BURNED" )
	{
		self thread animscripts\zombie_death::flame_death_fx();
	}
	if( !isDefined( level.boss_zombie_death_pos ) )
	{
		level.boss_zombie_death_pos = [];
	}	
	
	level.boss_zombie_death_pos = array_add( level.boss_zombie_death_pos, self.origin );
	level notify( "boss_zombie_died" );
	self thread boss_zombie_wait_for_respawn();
	for ( i = 0; i < level.zombie_powerup_array.size; i++ )
	{
		if ( level.zombie_powerup_array[i] == "full_ammo" )
		{
			if ( level.ammo_spawn )
			{
				level.ammo_spawn = false;
				level.zombie_powerup_boss = i;
			}
			else
			{
				if ( i == level.zombie_powerup_array.size - 1 )
				{
					level.zombie_powerup_boss = 0;
				}
				else
				{
					level.zombie_powerup_boss = i+1;
				}
			}
			break;
		}
	}
	play_sound_2D( "mus_bright_sting" );
	level.zombie_vars["zombie_drop_item"] = 1;
	level.powerup_drop_count--;
	level thread maps\_zombiemode_powerups::powerup_drop( self.origin );
	level.boss_death++;
	if ( level.boss_death >= level.boss_death_ammo )
	{
		level.ammo_spawn = true;
		level.boss_death = 0;
	}
	return false;
}
boss_adjust_max_ammo()
{
	while ( 1 )
	{
		level waittill( "between_round_over" );
		
		
		
		
		
		
		
		wait_network_frame();
	}
}
boss_zombie_wait_for_respawn()
{
	
	level thread wait_for_round();
	level thread wait_for_immediate();
	level waittill( "respawn_now" );
	level.num_boss_zombies--;
}
wait_for_round()
{
	level endon( "respawn_now" );
	level waittill( "between_round_over" );	
	wait( 1 );
	level waittill( "between_round_over" );
	
	level notify( "respawn_now" );
}
wait_for_immediate()
{
	level endon( "respawn_now" );
	level waittill( "respawn_boss_immediate" );
	
	level notify( "respawn_now" );
}
boss_thundergun_disintegrate( player )
{
	self endon( "death" );
	self DoDamage( level.boss_thundergun_damage, player.origin, player );
	if ( self.health > 0 )
	{
		self boss_zombie_shockwave_attack();
	}
}
boss_fire_damage( trap )
{
	self endon( "death" );
	
	self DoDamage( level.boss_fire_damage, self.origin );			
	while ( 1 )
	{
		wait( 0.25 );
		if ( self IsTouching( trap ) )
		{
			self DoDamage( level.boss_fire_damage, self.origin, trap );			
		}
		else
		{
			if ( self.health > 0 )
			{
				self.marked_for_death = undefined;
			}
			break;
		}
	}
}
boss_trap_reaction( trap )
{
	self endon( "death" );
	trap notify( "trap_done" );
}
boss_custom_damage( player )
{
	self endon( "death" );
	if ( isDefined( self.ground_hit ) && self.ground_hit )
	{
		return level.boss_zombie_groundhit_damage;
	}
	return self.meleeDamage;
}
boss_actor_damage( weapon, damage, attacker )
{
	self endon( "death" );
	switch( weapon )
	{
	case "spas_zm":
	case "spas_upgraded_zm":
	case "ithaca_zm":
	case "ithaca_upgraded_zm":
		damage *= 0.5;
		break;
	}
	if ( level.zombie_vars["zombie_insta_kill"] )
	{
		damage *= 2;
	}
	return damage;
}
boss_nuke_damage()
{
	self endon( "death" );
	if ( self.is_activated )
	{
		damage = self.maxhealth * 0.5;
		self DoDamage( damage, self.origin );			
	}
	if ( self.health > 0 )
	{
		self boss_zombie_shockwave_attack();
	}
}
boss_zombie_default_enter_level()
{
	Playfx( level._effect["boss_spawn"], self.origin );
	playsoundatposition( "zmb_bolt", self.origin );
	PlayRumbleOnPosition("explosion_generic", self.origin);
	self.entered_level = true;
}