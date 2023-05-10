
#include maps\_utility;
#include common_scripts\utility;
spawn_manager_main()
{
	level.spawn_manager_pacing_intensity = 0;
	level.spawn_manager_max_frame_spawn = 3;
	level.spawn_manager_total_count = 0;
	level.spawn_manager_max_ai = 32;
	level.spawn_manager_active_ai = 0;
	level.spawn_manager_quasi_base = 32;
	level.spawn_manager_quasi_index = randomintrange(0,level.spawn_manager_quasi_base);
	level.spawn_manager_last_targetname = "invalid";
	level thread spawn_manager_throttle_think();
	level thread spawn_manager_pacing_tracker();
	array_thread(getentarray("spawn_manager","classname"), ::spawn_manager_think);
	start_triggers("trigger_multiple");
	start_triggers("trigger_once");
	start_triggers("trigger_use");
	start_triggers("trigger_radius");
	start_triggers("trigger_lookat");
	start_triggers("trigger_damage");
	if ( GetDvar( #"spawn_manager_debug" ) == "" )
	{
		SetDvar( "spawn_manager_debug", "off" );
	}
	
}
start_triggers(trigger_type)
{
	triggers = getentarray(trigger_type,"classname");
	for(i=0; i<triggers.size; i++)
	{
		if(isdefined(triggers[i].script_killspawner))
		{
			triggers[i] thread script_manager_kill_trigger_think();
		}
		if(isdefined(triggers[i].target))
		{
			managers = getentarray("spawn_manager","classname");
			for(j=0; j<managers.size; j++)
			{
				if(isdefined(managers[j].targetname) && (managers[j].targetname == triggers[i].target))
				{
					triggers[i] thread script_manager_enable_trigger_think();
					break;
				}
			}
		}	
	}
}
van_der_corput(b,n)
{
	n0 = n;
	c = 0;
	ib = 1.0/b;
	while(n0 > 0)
	{
		n1 = floor(n0/b);
		i = n0 - n1 * b;
		c = c + ib * i;
		ib = ib / b;
		n0 = n1;
	}
	return c;
}
spawn_manager_random_count(min, max)
{
	x =  floor((max-min)*van_der_corput(level.spawn_manager_quasi_base,level.spawn_manager_quasi_index) + min);
	x = int(x);
	assert(x >= min);
	assert(x < max);
	return x;
}
spawn_manager_player_tracker()
{
	oldOrigins = [];
	oldOrigins[0] = (0,0,0);
	oldOrigins[1] = (0,0,0);
	oldOrigins[2] = (0,0,0);
	oldOrigins[3] = (0,0,0);
	for(;;)
	{
		wait(5);
		players = get_players();
		for(i=0; i<players.size; i++)
		{
			if(distance(players[i].origin, (0,0,0)) < 5)
			{
				continue;
			}
			if( distance(players[i].origin, oldOrigins[i]) < 5 )
			{
				continue;
			}
			status = "alive";
			if(players[i] maps\_laststand::player_is_in_laststand())
			{
				status = "laststand";
			}
			bbprint("player_tracking: playerid %d, x %f, y %f, z %f, status %s",
					i, 
					players[i].origin[0], 
					players[i].origin[1], 
					players[i].origin[2],
					status);
			oldOrigins[i] = players[i].origin;
		}
	}
}
spawn_manager_pacing_tracker()
{
	thread spawn_manager_player_tracker();
	managers = getentarray("spawn_manager","classname");
	lastManagerActiveCount = -1;
	lastActiveCount = -1;
	lastTotalCount = -1;
	lastMaxAi = -1;
	lastPlayerCount = -1;
	lastPlayerDownCount = -1;
	lastManagerPotentialSpawnCount = -1;
	for(;;)
	{
		wait_network_frame();
		managerActiveCount = 0;
		managerPotentialSpawnCount = 0;
		activeManagers = [];
		for(i=0; i<managers.size; i++)
		{
			if(isdefined(managers[i]) && managers[i].enable )
			{
				if(managers[i].count > managers[i].spawnCount)
				{
					managerActiveCount += 1;
					managerPotentialSpawnCount += managers[i].script_spawn_active_count;
				}
				activeManagers[activeManagers.size] = managers[i];
			}
		}
		if(	(lastActiveCount != level.spawn_manager_active_ai)
			||
			(lastTotalCount != level.spawn_manager_total_count)
			||
			(lastMaxAi != level.spawn_manager_max_ai)
			||
			(lastManagerActiveCount != managerActiveCount)
			||
			(lastManagerPotentialSpawnCount != managerPotentialSpawnCount)
			)
		{
			bbprint("spawn_manager_globals: active_ai %d total_count %d max_ai %d active_managers %d potential_ai %d intensity %f",
					level.spawn_manager_active_ai,
					level.spawn_manager_total_count,
					level.spawn_manager_max_ai,
					managerActiveCount,
					managerPotentialSpawnCount,
					level.spawn_manager_pacing_intensity
					);
			lastActiveCount = level.spawn_manager_active_ai;
			lastTotalCount = level.spawn_manager_total_count;
			lastMaxAi = level.spawn_manager_max_ai;
			lastManagerActiveCount = managerActiveCount;
			lastManagerPotentialSpawnCount = managerPotentialSpawnCount;
		}
		spawn_manager_debug_update(level.spawn_manager_active_ai,
								   level.spawn_manager_total_count,
								   level.spawn_manager_max_ai,
								   managerActiveCount,
								   managerPotentialSpawnCount,
								   activeManagers);
		playerCount = get_players().size;
		playerDownCount = maps\_laststand::player_num_in_laststand();
		if((lastPlayerCount != playerCount)
		|| (lastPlayerDownCount != playerDownCount))
		{
			bbprint("player_count: connected %d laststand %d", playerCount, playerDownCount);
			lastPlayerCount = playerCount;
			lastPlayerDownCount = playerDownCount;
		}
	}
}
spawn_manager_debug_update(active_ai, spawn_ai, max_ai, active_managers, potential_ai, activeManagers)
{
	if ( GetDvar( #"spawn_manager_debug" ) == "on" )
	{
		if(!isdefined(level.spawn_manager_debug_hud))
		{
			level.spawn_manager_debug_hud_title = NewHudElem();
			level.spawn_manager_debug_hud_title.alignX = "left";
			level.spawn_manager_debug_hud_title.x = -50;
			level.spawn_manager_debug_hud_title.y = 60;
			level.spawn_manager_debug_hud_title.fontScale = 1.25;
			level.spawn_manager_debug_hud_title.color = (1,1,1);
			level.spawn_manager_debug_hud = [];
		}
		level.spawn_manager_debug_hud_title SetText("Spawn Manager Debug: total ai:"+spawn_ai+"  active ai:"+active_ai+"  max ai:"+max_ai+"  potential ai:"+potential_ai+"\n  active managers:"+active_managers);
		for(i=0; i<activeManagers.size; i++)
		{
			if(!isdefined(level.spawn_manager_debug_hud[i]))
			{
				level.spawn_manager_debug_hud[i] = NewHudElem();
				level.spawn_manager_debug_hud[i].alignX = "left";
				level.spawn_manager_debug_hud[i].x = -50;
				level.spawn_manager_debug_hud[i].y = level.spawn_manager_debug_hud_title.y + (i+1) * 15;
				level.spawn_manager_debug_hud[i].color = (1,1,1);
			}
			level.spawn_manager_debug_hud[i] SetText("    "
													+"  targetname: "+activeManagers[i].targetname
													+"  count:"+activeManagers[i].count+"("+activeManagers[i].count_min+","+activeManagers[i].count_max+")"
													+"  spawn count:"+activeManagers[i].spawnCount
													+"  active count:"+activeManagers[i].script_spawn_active_count+"("+activeManagers[i].script_spawn_active_count_min+","+activeManagers[i].script_spawn_active_count_max+")"
													+"  currently active:"+activeManagers[i].activeAI.size
													+"  spawners:"+activeManagers[i].spawners.size
													);
		}
		for(; i<level.spawn_manager_debug_hud.size; i++)
		{
			level.spawn_manager_debug_hud[i] SetText("");
		}
	}
}
spawn_manager_throttle_think()
{
	managers = getentarray("spawn_manager","classname");
	for(;;)
	{
		level.spawn_manager_frame_spawns = 0;
		level notify("spawn_manager_throttle_reset");
		wait_network_frame();
	}
}
spawn_manager_activate(spawn_manager_name)
{
	managers = getentarray( spawn_manager_name, "targetname");
	for(i=0; i<managers.size; i++)
	{
		managers[i] notify("enable");
	}	
}
spawn_manager_spawn(force, maxDelay)
{
	self endon ("death");
	start = gettime();
	for(;;)
	{
		while(level.spawn_manager_frame_spawns >= level.spawn_manager_max_frame_spawn
			||level.spawn_manager_active_ai >= level.spawn_manager_max_ai)
		{
			level waittill("spawn_manager_throttle_reset");
		}
		if(force)
		{
			ai = self stalingradSpawn();
		}
		else
		{
			ai = self dospawn();
		}
		if(isdefined(ai) && !spawn_failed(ai)) 
		{
			
			ai maps\_names::get_name(); 
			return ai;
		}
		else if((gettime() - start) > (1000*maxDelay)) 
		{
			return ai;
		}
		wait_network_frame();
	}
}
remove_from_array(item,array)
{
	index = 0;
	for(; index<array.size; index++)
	{
		if(array[index] == item)
		{
			break;
		}		
	}	
	
	array[index] = undefined;
	
	for(i=index; i<array.size; i++)
	{
		array[i] = array[i+1];
		array[i+1] = undefined;
	}	
	
	return array;
}
spawn_accounting(spawner, manager)
{
	targetname = manager.targetname;
	classname = spawner.classname;
	level.spawn_manager_total_count += 1;
	manager.spawnCount += 1;
	level.spawn_manager_active_ai += 1;
	origin = spawner.origin;
	manager.activeAI[manager.activeAI.size] = self;
	spawner.activeAI[spawner.activeAI.size] = self;
	self waittill("death");
	
	if(isdefined(spawner))
	{
		spawner.activeAI = remove_from_array(self, spawner.activeAI);
	}
	if(isdefined(manager))
	{
		manager.activeAI = remove_from_array(self, manager.activeAI);
	}
	level.spawn_manager_active_ai -= 1;
	bbprint("spawn_manager_spawns: manager %s event death classname %s posx %f posy %f posz %f", targetname, classname, origin[0], origin[1], origin[2]);
}
spawn_manager_setup()
{
	assert(isdefined(self));
	assert(isdefined(self.target));
	
	
	if(!isdefined(self.script_spawn_delay))
	{
		self.script_spawn_delay = 0.1;
	}
	if(!isdefined(self.script_spawn_group_size))
	{
		self.script_spawn_group_size = 1;
	}
	if(!isdefined(self.script_spawn_player_seek))
	{
		self.script_spawn_player_seek = 0;
	}
	
	if(!isdefined(self.script_selected_spawner_count)) 
	{
		self.script_selected_spawner_count = getentarray(self.target,"targetname").size;
	}
	
	if(!isdefined(self.script_forcespawn))
	{
		self.script_forcespawn = 0;
	}
	
	
	
	if(!isdefined(self.count_min) && !isdefined(self.count_max))
	{
		if(isdefined(self.count))
		{
			self.count_min = self.count;
			self.count_max = self.count;
		}
		else
		{
			self.count_min = 0;
			self.count_max = 0;
		}
	}	
	else if(!isdefined(self.count_min) && isdefined(self.count_max))
	{
		self.count_min = self.count_max;
	}	
	else if(isdefined(self.count_min) && !isdefined(self.count_max))
	{
		self.count_max = self.count_min;
	}	
	self.count = spawn_manager_random_count(self.count_min, self.count_max+1);
	
	if(self.script_spawn_group_size > self.count)
	{
		self.script_spawn_group_size = self.count;
	}
	
	if(!isdefined(self.script_spawn_active_count_min) && !isdefined(self.script_spawn_active_count_max))
	{
		if(isdefined(self.script_spawn_active_count))
		{
			self.script_spawn_active_count_min = self.script_spawn_active_count;
			self.script_spawn_active_count_max = self.script_spawn_active_count;
		}
		else
		{
			self.script_spawn_active_count_min = self.count;
			self.script_spawn_active_count_max = self.count;
		}
	}	
	else if(!isdefined(self.script_spawn_active_count_min) && isdefined(self.script_spawn_active_count_max))
	{
		self.script_spawn_active_count_min = self.script_spawn_active_count_max;
	}	
	else if(isdefined(self.script_spawn_active_count_min) && !isdefined(self.script_spawn_active_count_max))
	{
		self.script_spawn_active_count_max = self.script_spawn_active_count_min;
	}	
	self.script_spawn_active_count = spawn_manager_random_count(self.script_spawn_active_count_min, self.script_spawn_active_count_max+1);
	if(self.script_spawn_group_size > self.script_spawn_active_count)
	{
		self.script_spawn_group_size = self.script_spawn_active_count;
	}
	assert(self.script_selected_spawner_count <= getentarray(self.target,"targetname").size);
	
	self.spawners = self spawn_manager_get_spawners();
	assert(self.count >= self.count_min);
	assert(self.count <= self.count_max);
	assert(self.script_spawn_active_count >= self.script_spawn_active_count_min);
	assert(self.script_spawn_active_count <= self.script_spawn_active_count_max);
}
spawn_manager_resetup()
{
	self.count = spawn_manager_random_count(self.count_min, self.count_max+1);
	
	if(self.script_spawn_group_size > self.count)
	{
		self.script_spawn_group_size = self.count;
	}
	self.script_spawn_active_count = spawn_manager_random_count(self.script_spawn_active_count_min, self.script_spawn_active_count_max+1);
	if(self.script_spawn_group_size > self.script_spawn_active_count)
	{
		self.script_spawn_group_size = self.script_spawn_active_count;
	}
	
}
spawn_manager_get_spawners()
{
	allSpawners = getentarray(self.target,"targetname");
	forceSpawners = [];
	groupSpawners = [];	
	
	for(i=0; i<allSpawners.size; i++)
	{
		
		
		if((isdefined(level._gamemode_norandomdogs)) && (allSpawners[i].classname == "actor_enemy_dog"))
		{
			continue;
		}
		allSpawners[i].activeAI = [];
		if(!isdefined(allSpawners[i].script_spawn_active_count))
		{
			allSpawners[i].script_spawn_active_count = level.spawn_manager_max_ai;
			forceSpawners[forceSpawners.size] = allSpawners[i];
		}
		else if(self.script_selected_spawner_count <= 0)
		{
			forceSpawners[forceSpawners.size] = allSpawners[i];
		}
		else
		{
			groupSpawners[groupSpawners.size] = allSpawners[i];
		}
	}
	
	spawners = [];
	groupSpawnCount = self.script_selected_spawner_count;
	if(groupSpawnCount > groupSpawners.size)
	{
		groupSpawnCount = groupSpawners.size;
	}
		
	if(groupSpawners.size > 0 && groupSpawnCount > 0)
	{
		while(spawners.size < groupSpawnCount)
		{
			idx = randomIntRange(0, groupSpawners.size); 
			
			if(isdefined(groupSpawners[idx]))
			{
				spawners[spawners.size] = groupSpawners[idx];
				groupSpawners = remove_from_array(groupSpawners[idx], groupSpawners );
			}
		}
	}
	
	for(i=0; i<forceSpawners.size; i++)
	{
		spawners[spawners.size] = forceSpawners[i];
	}
	for(i=0; i<spawners.size; i++)
	{
		spawners[i].activeAI = [];
	}
	return spawners;
}
spawn_manager_sanity()
{
	assert(self.activeAI.size <= self.script_spawn_active_count);
	assert(self.spawnCount <= self.count);
}
spawn_manager_can_spawn()
{
	totalFree = self.count - self.spawnCount;
	activeFree = self.script_spawn_active_count - self.activeAI.size;
	haveSpawns = self.activeAI.size != 0;
	canSpawnGroup =  (activeFree >= self.script_spawn_group_size)
				  && (totalFree >=  self.script_spawn_group_size)
				  && (self.script_spawn_group_size > 0)
				  ;
	globalFree = level.spawn_manager_max_ai - getaiarray().size;
	
	if(!haveSpawns) 
	{
		canSpawnGroup = true;
	}
	if(self.script_forcespawn == 0)
	{
		return (totalFree > 0)  
			&& (activeFree > 0) 
			&& (globalFree > self.script_spawn_group_size) 
			&& canSpawnGroup    
			&& self.enable      
			;
	}
	else
	{
		return (totalFree > 0)  
			&& (activeFree > 0) 
			&& self.enable      
			;
	}
}
spawn_manager_get_spawn_group_size(spawner)
{
	assert(isdefined(spawner));
	spawnerFree = spawner.script_spawn_active_count - spawner.activeAI.size;
	managerFree = self.script_spawn_active_count - self.activeAI.size;
	
	spawnGroupSize = RandomIntRange(0,self.script_spawn_group_size)+1;
	if(spawnGroupSize > spawnerFree) 
	{
		spawnGroupSize = spawnerFree;
	}
	if(spawnGroupSize > managerFree) 
	{
		spawnGroupSize = managerFree;
	}
	return spawnGroupSize;
}
spawn_manager_spawn_group(manager, spawner, spawnGroupSize)
{
	for(i=0; i<spawnGroupSize; i++)
	{
		force = false;
		if(isdefined(spawner.script_forcespawn) && spawner.script_forcespawn)
		{
			force = true;
		}
		if(isdefined(self.script_forcespawn) && self.script_forcespawn)
		{
			force = true;
		}
		ai = undefined;
		if (isdefined(spawner) && isdefined(spawner.targetname) ) 
		{
			ai = spawner spawn_manager_spawn(force, 2.0);
		}
		else
		{
			continue;
		}
		if(isdefined(ai) && !spawn_failed(ai))
		{
			level.spawn_manager_frame_spawns += 1;
			
			if(isdefined(self.script_radius))
			{
				ai.script_radius = self.script_radius;
			}			
			if(isdefined(spawner.script_radius))
			{
				ai.script_radius = spawner.script_radius;
			}
			ai thread spawn_accounting(spawner, self);
		}
		wait(.1);
	}
}
cleanup_spawners()
{
	spawners = [];
	for(i=0; i<self.spawners.size; i++)
	{
		if(isdefined(self.spawners[i]))
		{
			if(self.spawners[i].count != 0)
			{
				spawners[spawners.size] = self.spawners[i];
			}
			else
			{
				self.spawners[i] delete();
			}
		}
	}
	if(spawners.size == 0)
	{
		self notify("kill"); 
		wait(.01);
	}
	self.spawners = spawners;
}
spawn_manager_think()
{
	self thread spawn_manger_enable_think();
	self thread spawn_manger_kill_think();
	self endon("kill");
	self.enable = false;
	self.activeAI = [];
	self.spawnCount = 0;
	self.needsResetup = false;
	self waittill("enable");
	self spawn_manager_setup();
	if(self.targetname != level.spawn_manager_last_targetname)
	{
		level.spawn_manager_last_targetname = self.targetname;
		level.spawn_manager_quasi_index = (level.spawn_manager_quasi_index+1)%level.spawn_manager_quasi_base;
	}
	for(;;)
	{
		if(self.needsResetup)
		{
			spawn_manager_resetup();
			self.needsResetup = false;
		}
		cleanup_spawners();
		if(self spawn_manager_can_spawn())
		{
			assert(self.script_spawn_group_size != 0);
			spawner = self.spawners[randomIntRange(0,self.spawners.size)];
			spawnGroupSize = self spawn_manager_get_spawn_group_size(spawner);
			if(spawnGroupSize > 0)
			{
				self spawn_manager_spawn_group(self, spawner, spawnGroupSize);
			}
			else
			{
				wait(self.script_spawn_delay); 
			}
		}
		else
		{
			wait(self.script_spawn_delay); 
		}
		if(self.count <= self.spawnCount)
		{
			bbprint("spawn_manager: manager %s event complete", self.targetname);
			level notify(self.targetname+"_complete");
			self notify("kill");
		}
		if(self.script_forcespawn == 0)
		{
			wait(maps\_laststand::player_num_in_laststand()/get_players().size * 8);
		}
	}
}
spawn_manger_kill_think()
{
	self waittill("kill");
	wait(.1);
	self delete();
}
spawn_manger_enable_think()
{
	self endon("kill");
	for(;;)
	{
		self.enable = false;
		self waittill("enable");
		bbprint("spawn_manager: targetname %s event enable", self.targetname);
		self.enable = true;
		self waittill("disable");
		bbprint("spawn_manager: targetname %s event disable", self.targetname);
	}
}
script_manager_enable_trigger_think()
{
	assert(isdefined(self));
	
	
	
	self waittill("trigger");	
	
	managers = getentarray("spawn_manager","classname");
	
	for(j=0; j<managers.size; j++)
	{
		if(managers[j].targetname == self.target)
		{
			managers[j] notify("enable");	
		}
	}	
}
script_manager_kill_trigger_think()
{
	assert(isdefined(self.script_killspawner));
	killspawner = self.script_killspawner; 
	self waittill( "trigger" ); 
	sms = getentarray("spawn_manager","classname");
	for(i=0; i<sms.size; i++)
	{
		if(isdefined(sms[i].script_killspawner) && (sms[i].script_killspawner == killspawner))
		{
			bbprint("spawn_manager: targetname %s event kill", self.targetname);
			sms[i] notify("kill");
			sms[i].enable = false;
		}
	}
} 
 
 
 
 
  
