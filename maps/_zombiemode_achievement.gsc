#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility; 
init()
{
}
deferred_init()
{
	flag_wait( "all_players_connected" );
	if ( is_map_dlc1() )
	{
		level.achievement_monitor_func = ::dlc1_damage_monitor;
		array_thread (GetPlayers(),::dlc1_check_achievement_nolegs );
		level thread dlc1_check_achievement_oldtimer();
		level thread dlc1_check_achievement_hardway();
		level thread dlc1_check_achievement_pistolero();
		if ( does_dlc_map_have_dogs() )
		{
			level thread dlc1_check_achievement_bigbaddaboom();
		}
	}
}
does_dlc_map_have_dogs()
{
	curMap = Tolower( GetDvar( #"mapname" ) ); 
	if (!isDefined(curMap) )
	{
		return false;
	}
		
	if ( curMap == "zombie_cod5_factory" 		||
			 curMap == "zombie_cod5_sumpf" )
	{
		return true;
	}
	
	return false;	
}
zombie_giveachievement_wrapper(string_id)
{
	if (!IsPlayer(self))
	{
		return false;
	}
	if (!isDefined(string_id))
	{
		return false;
	}
	if( self.sessionstate == "spectator" )
	{
		return false;
	}
	
	switch (string_id)
	{ 
		case "SP_ZOM_NODAMAGE":
		case "SP_ZOM_TRAPS":
		case "SP_ZOM_COLLECTOR":
		case "SP_ZOM_SILVERBACK":
		case "SP_ZOM_CHICKENS":
		case "SP_ZOM_FLAMINGBULL":
		{
			self thread giveachievement_wrapper(string_id);
			return true;
		}
		
		
		case "DLC1_ZOM_OLDTIMER":
		case "DLC1_ZOM_HARDWAY":
		case "DLC1_ZOM_PISTOLERO":
		case "DLC1_ZOM_BIGBADDABOOM":
		case "DLC1_ZOM_NOLEGS":
		{
			if ( is_map_dlc1() )
			{
				self thread giveachievement_wrapper(string_id);
				return true;
			}
			return false;
		}
	}
	return false;
}
is_map_dlc1()
{
	curMap = Tolower( GetDvar( #"mapname" ) ); 
	if (!isDefined(curMap) )
	{
		return false;
	}
		
	if ( curMap == "zombie_cod5_asylum" 		|| 
			 curMap == "zombie_cod5_factory" 		||
			 curMap == "zombie_cod5_prototype" 	||
			 curMap == "zombie_cod5_sumpf" )
	{
		return true;
	}
	
	return false;	
}
dlc1_damage_monitor()
{
	switch (self.animname)
	{
		case "zombie":
			self thread dlc1_melee_damage_monitor();
		break;
		case "zombie_dog":
			self thread dlc1_dog_damage_monitor();
		break;
	}
}
dlc1_check_achievement_oldtimer()
{
	while (1)
	{
		result = true;
		level waittill( "end_of_round" );
		
		if ( level.round_number >= 10 )
		{
			players = GetPlayers();
			for (i=0;i<players.size;i++)
			{
				if ( isDefined(players[i]) && !isDefined(players[i].last_box_weapon) )
				{
					players[i] zombie_giveachievement_wrapper("DLC1_ZOM_OLDTIMER");
				}
			}
			return;
		}
	}
}
dlc1_check_achievement_hardway()
{
	while (1)
	{
		level waittill( "end_of_round" );
		
		if ( level.round_number >= 5 )
		{
			players = GetPlayers();
			for (i=0;i<players.size;i++)
			{
				if ( isDefined(players[i]) && !isDefined(players[i].bought_weapons) && !isDefined(players[i].last_box_weapon) )
				{
					players[i] zombie_giveachievement_wrapper("DLC1_ZOM_HARDWAY");
				}
			}
			return;
		}
	}
}
dlc1_check_achievement_pistolero()
{
	while (1)
	{
		level waittill( "end_of_round" );
		
		if ( level.round_number >= 15 )
		{
			players = GetPlayers();
			for (i=0;i<players.size;i++)
			{
				if ( isDefined(players[i]) && !isDefined(players[i].last_pistol_swap) )
				{
					players[i] zombie_giveachievement_wrapper("DLC1_ZOM_PISTOLERO");
				}
			}
			return;
		}
	}
}
dlc1_dog_damage_monitor()
{
	while (isDefined(self))
	{
		self waittill( "damage", amount, inflictor, direction, point, type, modelName, tagName );
		if ( !isDefined(type) || (amount > self.health && type != "MOD_EXPLOSIVE") )
		{
			level.dog_death_by_nonexplosive = true;
		}
	}
}
dlc1_check_achievement_bigbaddaboom()
{
	while (1)
	{
		level.dog_death_by_nonexplosive = undefined;
		level waittill( "dog_round_ending" );
		
		if ( !isDefined(level.dog_death_by_nonexplosive) )
		{
			players = GetPlayers();
			for (i=0;i<players.size;i++)
			{
					players[i] zombie_giveachievement_wrapper("DLC1_ZOM_BIGBADDABOOM");
			}
			return;
		}
	}
}
dlc1_melee_damage_monitor()
{
	while (isDefined(self))
	{
		self waittill( "damage", amount, inflictor, direction, point, type, modelName, tagName );
		if ( type == "MOD_MELEE" )
		{
			if( self.animname == "zombie" && !self.has_legs )
			{
				inflictor.melee_counter++;
			}
		}
	}
}
dlc1_check_achievement_nolegs()  
{
	self endon("disconnect");
	self.melee_counter = 0;
	
	while(1)
	{
		if ( self.melee_counter >= 10 )
		{
			self zombie_giveachievement_wrapper("DLC1_ZOM_NOLEGS");
			return;
		}
		wait 5;
	}
}