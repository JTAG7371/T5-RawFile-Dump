#include maps\_utility;
#include maps\_zombiemode_utility;
#include common_scripts\utility;
init()
{
	level.friendlyDogModel = "german_shepherd";
	precacheModel(level.friendlyDogModel);
	precacheShellshock("dog_bite");
	level.maxDogsAttackingPerPlayer = 2;
	level.spawnTimeWaitMin = 2;
	level.spawnTimeWaitMax = 5;
	level.dog_spawner = getent("dog_spawner","targetname" );
	if( !isDefined( level.dog_spawner ) )
	{
		level.no_dogs = true;
		return;
	}
	level.dog_spawner add_spawn_function( ::init_dog );
		
	level.no_dogs = false;
		
	init_node_arrays();
	
	if ( level.no_pathnodes )
		level.no_dogs = true;
	dog_dvar_update();
	thread dog_dvar_updater();
	thread dog_usage_init();
}
pick_random_nodes( from, count )
{
	to = [];
	
	if ( from.size < count )
	{
		to = from;
	}
	else
	{
		for ( i = 0; i < count; i++ )
		{
			to[i] = from[randomInt(from.size)];
		}
	}
	
	return to;
}
init_node_arrays()
{
	nodes = getallnodes();
	pathnodes = [];
	
	for ( i = 0; i < nodes.size; i++ )
	{
		
		if ( isdefined(nodes[i].script_noteworthy) )
			continue;
			
		if ( isdefined(nodes[i].targetname) && nodes[i].targetname == "traverse" )
			continue;
			
		if ( isdefined(nodes[i].classname) && !(nodes[i].classname == "node_pathnode") )
			continue;
			
		pathnodes[pathnodes.size] = nodes[i]; 
	} 
	if ( pathnodes.size == 0 )
	{
		level.no_pathnodes = true;
	}
	else
	{
		level.no_pathnodes = false;
	}
	
	level.patrolnodes = [];
	
	level.patrolnodes = pick_random_nodes( pathnodes, 200 ); 
	
	level.dogspawnnodes = [];
	level.dogspawnnodes = getnodearray( "dog_spawn", "script_noteworthy");
	
	if ( level.dogspawnnodes.size == 0 )
	{
		
		
		level.dogspawnnodes = pick_random_nodes( pathnodes, 20 );
	}
	
	level.dogexitnodes = [];
	level.dogexitnodes = getnodearray( "exit", "script_noteworthy");
	
	if ( level.dogexitnodes.size == 0 )
	{
		
		level.dogexitnodes = pick_random_nodes( pathnodes, 20 );
	}
}
dog_dvar_update()
{
	level.attack_dog_time = dog_get_dvar_int("scr_attack_dog_time_zm", "45" );
	level.attack_dog_kills = dog_get_dvar_int("scr_attack_dog_kills_zm", "25" ); 
	level.attack_dog_health = dog_get_dvar_int("scr_attack_dog_health_zm", "100000" );
	level.attack_dog_count = dog_get_dvar_int("scr_attack_dog_count_zm", "3" );
	level.attack_dog_count_max_at_once = dog_get_dvar_int("scr_attack_dog_max_at_once_zm", "3" );
	
	if ( level.attack_dog_count < level.attack_dog_count_max_at_once )
	{
		level.attack_dog_count_max_at_once = level.attack_dog_count;
	}
		
	level.dog_debug = dog_get_dvar_int("debug_dogs", "1" );
	level.dog_debug_sound = dog_get_dvar_int("debug_dog_sound", "0" );
	level.dog_debug_anims = dog_get_dvar_int("debug_dog_anims", "1" );
	level.dog_debug_anims_ent = dog_get_dvar_int("debug_dog_anims_ent", "0" );
	level.dog_debug_turns = dog_get_dvar_int("debug_dog_turns", "0" );
	level.dog_debug_orient = dog_get_dvar_int("debug_dog_orient", "0" );
	level.dog_debug_usage = dog_get_dvar_int("debug_dog_usage", "1" );
}
dog_dvar_updater()
{
	while(1)
	{
		dog_dvar_update();
		
		
		if ( level.attack_dog_count > 16 )
		{
			level.attack_dog_count = 16;
		}
		wait (1);
	}
}
init_dog()
{
	if ( !isai(self) )
		return;
	self.aiteam = "allies";
	self dog_set_team( "allies" );
	
	self.animname = "zombie_dog";
	self.animTree = "dog.atr";
	self.accuracy = 0.2;
	self.health = level.attack_dog_health;
	self.maxhealth = level.attack_dog_health;  
	self hide();
	self.aiweapon = "dog_bite_zm";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeAmmo = 0;
	self.goalradius = 128;
	self.noDodgeMove = true;
	self.ignoreSuppression = true;
	self.ignoreme = true; 
	self.suppressionThreshold = 1;
	self.disableArrivals = false;
	self.pathEnemyFightDist = 512;
	self.meleeAttackDist = 102; 
	self setModel( level.friendlyDogModel );
	self.a.disablePain = true;
	self.allowPain = false;
}
get_spawn_node( team )
{
	return dog_pick_node_away_from_enemy(level.dogspawnnodes, team);
}
dog_spawn_fx( spawn_info )
{
	if ( spawn_info.play_buildup_fx )
	{
		Playfx( level._effect["lightning_dog_spawn"], spawn_info.pos );
		playsoundatposition( "pre_spawn", spawn_info.pos );
		wait( 1.5 );
	}
	playsoundatposition( "zmb_bolt", spawn_info.pos );
	Earthquake( 0.5, 0.75, spawn_info.pos, 1000);
	PlayRumbleOnPosition("explosion_generic", spawn_info.pos );
	playsoundatposition( "spawn", spawn_info.pos );
	
	angles = self.angles;
	if ( isdefined( self.enemy ) )
	{
		angle = VectorToAngles( self.enemy.origin - spawn_info.pos );
		angles = ( self.angles[0], angle[1], self.angles[2] );
	}
	self ForceTeleport( spawn_info.pos, angles );
	assertex( IsDefined( self ), "Ent isn't defined." );
	assertex( IsAlive( self ), "Ent is dead." );
	assertex( self.isdog, "Ent isn't a dog;" );
	wait( 0.05 ); 
	self show();
}
kill_zombie_for_spawn_pos( spawn_info )
{
	kill_zombie = undefined;
	zombies = get_array_of_closest( spawn_info.owner.origin, GetAiSpeciesArray( "axis", "all" ) );
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( zombies[i] in_playable_area() )
		{
			spawn_info.pos = zombies[i].origin;
			kill_zombie = zombies[i];
			break;
		}
	}
	
	if ( i == zombies.size )
	{
		get_spawn_pos_near_owner( spawn_info );
		
		if ( getailimit() == getaicount() )
		{
			kill_zombie = zombies[zombies.size - 1];
		}
	}
	if ( isdefined( kill_zombie ) )
	{
		
		Playfx( level._effect["lightning_dog_spawn"], spawn_info.pos );
		playsoundatposition( "pre_spawn", spawn_info.pos );
		kill_zombie dodamage( kill_zombie.health + 666, kill_zombie.origin, undefined, undefined, "impact", "torso_upper" );
		kill_zombie waittill( "death" );
	}
}
get_spawn_pos_near_owner( spawn_info )
{
	crumbIndex = randomint( spawn_info.owner.zombie_breadcrumbs.size );
	spawn_info.pos = spawn_info.owner.zombie_breadcrumbs[crumbIndex];
}
dog_manager_spawn_dog( owner, team, index, requiredDeathCount )
{
	level.dog_spawner.count = 666;
	
	spawn_info = spawnstruct();
	spawn_info.owner = owner;
	spawn_info.pos = (0, 0, 0);
	spawn_info.play_buildup_fx = true;
	
	if ( getailimit() == getaicount() )
	{
		kill_zombie_for_spawn_pos( spawn_info );
	}
	else
	{
		get_spawn_pos_near_owner( spawn_info );
	}
	dog = level.dog_spawner CodeSpawnerForceSpawn();
	
	if( spawn_failed( dog ) )
	{
		assertex( 0, "dog spawn failed" );
		return;			
	}
	
	if( isdefined( dog ) )	
	{
  		
  		
		dog.owner = owner;
		dog thread dog_usage(index);
		dog thread dog_clean_up();
		dog thread dog_notify_level_on_death();
  		
  		dog dog_spawn_fx( spawn_info );
	}
		
	return dog;
}
dog_manager_spawn_dogs( team, enemyTeam, deathCount )
{
	
	level endon("dogs done");
	level endon("dogs leaving");
	self endon("disconnect");
	if ( level.no_dogs )
		return;
		
	requiredDeathCount = deathCount;
	
	if ( !isdefined( level.dog_spawner ) )
		return;
	
	level.dogs = [];
	level._abilities[ "zombie_dogs" ].in_use = true;
	
	level thread dog_manager_game_ended();
	level thread dog_manager_dog_alive_tracker( self );
	level thread dog_manager_dog_time_limit();
	level thread dog_manager_dog_kills_limit();
	level thread dog_usage_monitor();
	
	more_dogs_on_death_count = level.attack_dog_count - level.attack_dog_count_max_at_once;
	if ( more_dogs_on_death_count )
	{
		level thread dog_manager_spawn_more_dogs_on_death( self, more_dogs_on_death_count, team );
	}
	
	for ( i = 0; i < level.attack_dog_count_max_at_once; i++ )
	{
		level.dogs[i] = dog_manager_spawn_dog( self, team, i, requiredDeathCount );
		
		wait ( randomfloat( level.spawnTimeWaitMin, level.spawnTimeWaitMax ) );
	}
	
	if ( !more_dogs_on_death_count )
	{
		level notify("all dogs spawned");
	}
}
dog_manager_spawn_more_dogs_on_death( owner, count, team )
{
	level endon("dogs done");
	level endon("dogs leaving");
	while( count > 0 )
	{
		level waittill("dog died");
	
		
		wait ( randomfloat( level.spawnTimeWaitMin, level.spawnTimeWaitMax ) );
		
		level.dogs[level.dogs.size] = dog_manager_spawn_dog( owner, team, level.dogs.size );
		count -= 1;
	} 
	
	level notify("all dogs spawned");
}
dog_manager_dog_time_limit()
{
	level endon("dogs done");
	level endon("dogs leaving");
	wait( level.attack_dog_time );
	
	
	level notify("dogs leaving");
}
dog_manager_dog_kills_limit()
{
	level endon("dogs done");
	level endon("dogs leaving");
	killcount = 0;
	while ( killcount < level.attack_dog_kills )
	{
		level waittill( "attack_dog_kill" );
		killcount++;
	}	
	
	
	level notify("dogs leaving");
}
dog_cleanup_wait( wait_for, notify_name )
{
	self endon( notify_name );
	self waittill( wait_for );
	self notify( notify_name, wait_for ); 
}
dog_cleanup_waiter()
{
	self thread dog_cleanup_wait( "all dogs spawned", "start_tracker");
	self thread dog_cleanup_wait( "dogs leaving", "start_tracker" );
	self waittill( "start_tracker", wait_for );
}
dog_manager_dog_alive_tracker( owner )
{
	level dog_cleanup_waiter();
	
	while (1)
	{
	 	alive_count = 0;
	 	for ( i = 0; i < level.dogs.size; i ++ )
	 	{
	 		if ( !isdefined(level.dogs[i]) )
	 			continue;
	 			
	 		if ( !isalive(level.dogs[i]) )
	 			continue;
	 			
	 		alive_count++;
	 	}	
	 	
	 	if ( alive_count == 0 )
	 	{
 			wait(1);
	 		dog_manager_delete_dogs( owner );
	 		level notify("dogs done");
	 		
	 		return;
		}	
		
 	
		
		wait (1);
	}
}
dog_manager_delete_dogs( owner )
{
		for ( i = 0; i < level.dogs.size; i ++ )
	 	{
	 		if ( !isdefined(level.dogs[i]) )
	 			continue;
	 			
	 		level.dogs[i] delete();
		} 	
		level.dogs = undefined;
		level._abilities[ "zombie_dogs" ].in_use = false;
	owner maps\_zombiemode_ability::update_player_ability_status();
}
dog_manager_game_ended()
{
	level waittill("game_ended");
	make_all_dogs_leave();
}
make_all_dogs_leave()
{
	
	level notify("dogs leaving");
}
dog_set_team( team )
{
	self.team = team;
	self.aiteam = team;
}
dog_clean_up()
{
	self endon("death");
	self endon("leaving");
	level waittill("dogs leaving");
	
	thread dog_leave();
}
dog_notify_level_on_death()
{
	self endon("leaving");
	self waittill("death");
	
	
	
	level notify("dog died");
}
dog_thread_behavior_function()
{
		self thread dog_patrol_when_no_enemy();
}
dog_leave()
{
	self notify("leaving");
	if ( isdefined( self.enemy ) && isalive( self.enemy ) && isdefined( self.enemy.syncedMeleeTarget ) && self == self.enemy.syncedMeleeTarget )
	{
		self waittill( "killed" );
	}
	
	self clearentitytarget();
	self.ignoreall = true;
	self.goalradius = 30;
	
	Playfx( level._effect["lightning_dog_spawn"], self.origin );
	playsoundatposition( "pre_spawn", self.origin );
	wait( 1.5 );
	playsoundatposition( "zmb_bolt", self.origin );
	self delete();
}
dog_patrol_when_no_enemy()
{
	self endon("death");
	self endon("leaving");
	
	while(1)
	{
		if ( !isdefined(self.enemy) )
		{
			self dog_debug_print( "no enemy starting patrol" );
			self thread dog_patrol();	
		}
		self waittill("enemy");	
	}	
}
dog_patrol_wait( wait_for, notify_name )
{
	self endon("attacking");
	dog_wait( wait_for, notify_name );
}
dog_wait( wait_for, notify_name )
{
	self endon("death");
	self endon("leaving");
	self endon( notify_name );
	self waittill( wait_for );
	self notify( notify_name, wait_for ); 
}
dog_patrol_path_waiter()
{
	self thread dog_patrol_wait( "bad_path", "next_patrol_point");
	self thread dog_patrol_wait( "goal", "next_patrol_point" );
	self waittill( "next_patrol_point", wait_for );
}
dog_patrol()
{
	self endon("death");
	self endon("enemy");
	self endon("leaving");
	self endon("attacking");
	self notify("on patrol");
	
	self dog_patrol_debug();
	
	while(1)
	{
		node = level.patrolnodes[randomInt(level.patrolnodes.size)];
		
		
		if ( !isdefined( node.script_noteworthy ) )
		{
			println( "=================dog_patrol = setgoalnode" );
			self setgoalnode( node );
			self dog_patrol_path_waiter();
		}
	}	
}
dog_wait_print( wait_for )
{
}
dog_patrol_debug()
{
	self thread dog_wait_print("death");
	self thread dog_wait_print("enemy");
	self thread dog_wait_print("leaving");
	self thread dog_wait_print("attacking");
}
dog_get_dvar_int( dvar, def )
{
	return int( dog_get_dvar( dvar, def ) );
}
dog_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}
dog_usage_init()
{
	level.dog_usage = [];
	
	for ( index = 0; index < level.attack_dog_count; index++ )
	{
		level.dog_usage[index] = spawnStruct();
		level.dog_usage[index].spawn_time = 0;
		level.dog_usage[index].death_time = 0;
		level.dog_usage[index].kills = 0;
		level.dog_usage[index].died = false;
	}
}
dog_usage_monitor()
{
	start_time = GetTime();
	
	level waittill("dogs done");
	index = 0;
	total_kills = 0;
	last_alive = 0;
	all_dead = true;
	alive_count = 0;
	never_spawned_count = 0;
	total_count = 0;
	
	for ( index = 0; index < level.attack_dog_count; index++ )
	{
		total_count++;
		
		if ( level.dog_usage[index].spawn_time == 0 )
		{
			never_spawned_count++;
			continue;
		}
		else if ( !level.dog_usage[index].died )
		{
			alive_count++;
			all_dead = false;
		}		
		
		seconds = (level.dog_usage[index].death_time - level.dog_usage[index].spawn_time) / 1000;
		if ( seconds > last_alive )
		{
			last_alive = seconds;
		}		
		
		total_kills += level.dog_usage[index].kills;
	}	
	
}
dog_usage(index)
{
	level.dog_usage[index].spawn_time = GetTime();
	level.dog_usage[index].death_time = 0;
	level.dog_usage[index].kills = 0;
	level.dog_usage[index].died = false;
	
	self thread dog_usage_kills(index);
	self thread dog_usage_time_alive(index);
}
dog_usage_kills(index)
{
	self endon("death");
	
	while(1)
	{
		self waittill("killed", player);
		level.dog_usage[index].kills++;
		level notify( "attack_dog_kill" );
	}	
}
dog_usage_time_alive(index)
{
	self endon("leaving");
	self waittill("death");
	level.dog_usage[index].death_time = GetTime();
	level.dog_usage[index].died = true;
	
	seconds = (level.dog_usage[index].death_time - level.dog_usage[index].spawn_time) / 1000 ;
}
dog_get_exit_node()
{
	return getclosest( self.origin, level.dogexitnodes );
}
dog_debug_print( message )
{
}
getAllOtherPlayers()
{
	aliveplayers = [];
	
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if ( !isdefined( players[i] ) )
			continue;
		player = players[i];
		
		if ( player.sessionstate != "playing" || player == self )
			continue;
		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}
dog_pick_node_away_from_enemy(nodes, team)
{
	
	if(!isdefined(nodes))
		return undefined;
	
	initWeights(nodes);
	update_all_nodes( nodes, team );
	aliveplayers = getAllOtherPlayers();
	
	
	
	idealDist = 1600;
	badDist = 1200;
	
	if (aliveplayers.size > 0)
	{
		for (i = 0; i < nodes.size; i++)
		{
			totalDistFromIdeal = 0;
			nearbyBadAmount = 0;
			for (j = 0; j < aliveplayers.size; j++)
			{
				dist = distance(nodes[i].origin, aliveplayers[j].origin);
				
				if (dist < badDist)
					nearbyBadAmount += (badDist - dist) / badDist;
				
				distfromideal = abs(dist - idealDist);
				totalDistFromIdeal += distfromideal;
			}
			avgDistFromIdeal = totalDistFromIdeal / aliveplayers.size;
			
			wellDistancedAmount = (idealDist - avgDistFromIdeal) / idealDist;
			
			
			
			
			
			nodes[i].weight = wellDistancedAmount - nearbyBadAmount * 2 + randomfloat(.2);
		}
	}
	
	avoidSpawnReuse(nodes);
	avoidEnemies(nodes, team, true);
	
	return dog_pick_node_final(nodes, team, aliveplayers);
}
dog_pick_node_random( nodes, team )
{
	
	if(!isdefined(nodes))
		return undefined;
	
	for(i = 0; i < nodes.size; i++)
	{
		j = randomInt(nodes.size);
		node = nodes[i];
		nodes[i] = nodes[j];
		nodes[j] = node;
	}
	
	return dog_pick_node_final(nodes, team, undefined, false);
}
dog_pick_node_final( nodes, team, enemies, useweights )
{
	
	
	bestnode = undefined;
	
	if ( !isdefined( nodes ) || nodes.size == 0 )
		return undefined;
	
	if ( !isdefined( useweights ) )
		useweights = true;
	
	if ( useweights )
	{
		
		
		bestnode = getBestWeightedNode( nodes, team, enemies );
	}
	else
	{
		
		
		for ( i = 0; i < nodes.size; i++ )
		{
			if ( positionWouldTelefrag( nodes[i].origin ) )
				continue;
			
			bestnode = nodes[i];
			break;
		}
	}
	
	if ( !isdefined( bestnode ) )
	{
		
		if ( useweights )
		{
			
			bestnode = nodes[randomint(nodes.size)];
		}
		else
		{
			bestnode = nodes[0];
		}
	}
	
	self finalizeNodeChoice( bestnode );
	
	
	return bestnode;
}
getBestWeightedNode( nodes, team, enemies )
{
	maxSightTracedNodes = 3;
	for ( try = 0; try <= maxSightTracedNodes; try++ )
	{
		bestnodes = [];
		bestweight = undefined;
		bestnode = undefined;
		for ( i = 0; i < nodes.size; i++ )
		{
			if ( !isdefined( bestweight ) || nodes[i].weight > bestweight ) 
			{
				if ( positionWouldTelefrag( nodes[i].origin ) )
					continue;
				
				bestnodes = [];
				bestnodes[0] = nodes[i];
				bestweight = nodes[i].weight;
			}
			else if ( nodes[i].weight == bestweight ) 
			{
				if ( positionWouldTelefrag( nodes[i].origin ) )
					continue;
				
				bestnodes[bestnodes.size] = nodes[i];
			}
		}
		if ( bestnodes.size == 0 )
			return undefined;
		
		
		bestnode = bestnodes[randomint( bestnodes.size )];
		
		if ( try == maxSightTracedNodes )
			return bestnode;
		
		if ( isdefined( bestnode.lastSightTraceTime ) && bestnode.lastSightTraceTime == gettime() )
			return bestnode;
		
		if ( !lastMinuteSightTraces( bestnode, team, enemies ) )
			return bestnode;
		
		penalty = getLosPenalty();
		bestnode.weight -= penalty;
		
		bestnode.lastSightTraceTime = gettime();
	}
}
finalizeNodeChoice( node )
{
	time = getTime();
	
	self.lastnode = node;
	self.lastspawntime = time;
	node.lastspawneddog = self;
	node.lastspawntime = time;
}
getLosPenalty()
{
	return 100000;
}
lastMinuteSightTraces( node, dog_team, enemies )
{
	
	
	team = "all";
	
	if ( !isdefined( enemies ) )
		return false;
	
	closest = undefined;
	closestDistsq = undefined;
	secondClosest = undefined;
	secondClosestDistsq = undefined;
	for ( i = 0; i < enemies.size; i++ )
	{
		player = node.nearbyPlayers[team][i];
		
		if ( !isdefined( player ) )
			continue;
		if ( player.sessionstate != "playing" )
			continue;
		if ( player == self )
			continue;
		
		distsq = distanceSquared( node.origin, player.origin );
		if ( !isdefined( closest ) || distsq < closestDistsq )
		{
			secondClosest = closest;
			secondClosestDistsq = closestDistsq;
			
			closest = player;
			closestDistSq = distsq;
		}
		else if ( !isdefined( secondClosest ) || distsq < secondClosestDistSq )
		{
			secondClosest = player;
			secondClosestDistSq = distsq;
		}
	}
	
	if ( isdefined( closest ) )
	{
		if ( bullettracepassed( closest.origin  + (0,0,50), node.origin + (0,0,50), false, undefined) )
			return true;
	}
	if ( isdefined( secondClosest ) )
	{
		if ( bullettracepassed( secondClosest.origin + (0,0,50), node.origin + (0,0,50), false, undefined) )
			return true;
	}
	
	return false;
}
update_all_nodes( nodes, team )
{
	for ( i = 0; i < nodes.size; i++ )
	{
		nodeUpdate( nodes[i], team );
	}
}
avoidEnemies(nodes, team,teambased)
{
	lospenalty = getLosPenalty();
	
	otherteam = "axis";
	if ( team == "axis" )
		otherteam = "allies";
	minDistTeam = otherteam;
	
	
	
		minDistTeam = "all";
	
	
	avoidWeight = GetDvarFloat( #"scr_spawn_enemyavoidweight");
	if ( avoidWeight != 0 )
	{
		nearbyEnemyOuterRange = GetDvarFloat( #"scr_spawn_enemyavoiddist");
		nearbyEnemyOuterRangeSq = nearbyEnemyOuterRange * nearbyEnemyOuterRange;
		nearbyEnemyPenalty = 1500 * avoidWeight; 
		nearbyEnemyMinorPenalty = 800 * avoidWeight; 
		
		lastAttackerOrigin = (-99999,-99999,-99999);
		lastDeathPos = (-99999,-99999,-99999);
		
		for ( i = 0; i < nodes.size; i++ )
		{
			
			mindist = nodes[i].minDist[minDistTeam];
			if ( mindist < nearbyEnemyOuterRange*2 )
			{
				penalty = nearbyEnemyMinorPenalty * (1 - mindist / (nearbyEnemyOuterRange*2));
				if ( mindist < nearbyEnemyOuterRange )
					penalty += nearbyEnemyPenalty * (1 - mindist / nearbyEnemyOuterRange);
				if ( penalty > 0 )
				{
					nodes[i].weight -= penalty;
				}
			}
		}
	}
				
	
	
}
nodeUpdate( node, team )
{
			node.sights = 0;
			
			node.nearbyPlayers["all"] = [];
		
		node.nearbyDogs = [];
		
		nodedir = node.forward;
		
		debug = false;
		
		node.distSum["all"] = 0;
		node.distSum["allies"] = 0;
		node.distSum["axis"] = 0;
		node.distSum["dogs"] = 0;
		
		node.minDist["all"] = 9999999;
		node.minDist["allies"] = 9999999;
		node.minDist["axis"] = 9999999;
		node.minDist["dogs"] = 9999999;
	
		node.numPlayersAtLastUpdate = 0;
		node.numDogsAtLastUpdate = 0;
		
		players = GetPlayers();
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if ( player.sessionstate != "playing" )
				continue;
			
			diff = player.origin - node.origin;
			diff = (diff[0], diff[1], 0);
			dist = length( diff ); 
						
			player_team = "all";
	
			if ( dist < 1024 )
			{
				node.nearbyPlayers[player_team][node.nearbyPlayers[player_team].size] = player;
			}
			
			if ( dist < node.minDist[player_team] )
				node.minDist[player_team] = dist;
		
			node.distSum[ player_team ] += dist;
			node.numPlayersAtLastUpdate++;
		}
		
		for (i = 0; i < level.dogs.size; i++)
		{
			dog = level.dogs[i];
			
			if ( !isdefined(dog) || !isalive(dog) )
				continue;
			
			diff = dog.origin - node.origin;
			diff = (diff[0], diff[1], 0);
			dist = length( diff ); 
						
			if ( dist < 1024 )
			{
				node.nearbyDogs[node.nearbyDogs.size] = dog;
			}
			
			if ( dist < node.minDist["dogs"] )
				node.minDist["dogs"] = dist;
		
			node.distSum[ "dogs" ] += dist;
			node.numDogsAtLastUpdate++;
		}
}
initWeights(nodes)
{
	for (i = 0; i < nodes.size; i++)
		nodes[i].weight = 0;
}
avoidSpawnReuse(nodes)
{
	time = getTime();
	
	maxtime = 3*1000;
	maxdistSq = 1024 * 1024;
	for (i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		
		if (!isdefined(node.lastspawntime))
			continue;
			
		timepassed = time - node.lastspawntime;
		if (timepassed < maxtime)
		{
			worsen = 1000 * (1 - timepassed/maxtime);
			node.weight -= worsen;
		}
	}
}  
