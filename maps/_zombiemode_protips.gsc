
#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;
pro_tips_initialize()
{
	level.pro_tips = [];
	level.pro_tips_table = [];
	tipId = 1;
	tipStr = tableLookup( "mp/zm_proTipsTable.csv", 0, tipId, 2 );
		
	while ( isDefined( tipStr ) && tipStr != "" )
	{
		level.pro_tips_table[tipStr] = [];
		level.pro_tips_table[tipStr]["string1"] = tableLookupIString( "mp/zm_proTipsTable.csv", 0, tipId, 3 );
		level.pro_tips_table[tipStr]["stat"] = tableLookup( "mp/zm_proTipsTable.csv", 0, tipId, 2 );
		level.pro_tips_table[tipStr]["max_displays"] = int(tableLookup( "mp/zm_proTipsTable.csv", 0, tipId, 5 ));
		level.pro_tips_table[tipStr]["screen_time"] = int(tableLookup( "mp/zm_proTipsTable.csv", 0, tipId, 6 ));
		precacheString( level.pro_tips_table[tipStr]["string1"] );
		string2 = tableLookupIString( "mp/zm_proTipsTable.csv", 0, tipId, 4 );
		if( isDefined( string2 ) )
		{
			level.pro_tips_table[tipStr]["string2"] = string2;
			precacheString( level.pro_tips_table[tipStr]["string2"] );
		}
		tipId++;
		tipStr = tableLookup( "mp/zm_proTipsTable.csv", 0, tipId, 2 );
	}
	
	add_default_pro_tips();
}
add_default_pro_tips()
{
	
	
	
	addProTipTime(	1, 45, "zm_pt_wall_weapons" );
	addProTipFunction(	1, 5, ::player_pistol_ammo_low, "zm_pt_pistol_low_ammo", 0 );
	
	addProTipTime(	2, 5, "zm_pt_repair_boards" );
		
	
	addProTipFunction(	3, 35, ::player_please_buy_weapon, "zm_pt_please_buy_weapon", 1 );
	
	addProTipTime(	4, 35, "zm_pt_weapon_box" );
	addProTipTime(	5, 35, "zm_pt_reinforcements" );
	
	addProTipTimeCoop(	7, 5, "zm_pt_money_drop" );
	addProTipFunction(  1, 2, ::player_needs_reviving, "zm_pt_player_needs_reviving", 0 );
	addProTipFunction(  1, 2, ::player_down, "zm_pt_player_down", 0 );
	addProTipFunction(  1, 2, ::death_card, "zm_pt_death_card", 0 );
	addProTipFlag(	1, 2, "power_on", "zm_pt_machines_on" );
	addProTipFlag(	1, 5, "chest_has_been_used", "zm_pt_secret_weapons" );
	
}
player_init()
{
	self thread init_protip_threads();
}
init_protip_threads()
{
	self endon( "death" );
	self endon( "disconnect" );
	flag_wait( "begin_spawning" );
	while(1)
	{
		pro_tips = level.pro_tips;
		for( i=0; i<pro_tips.size; i++ )
		{
			tip = pro_tips[i];
			if( tip.round == level.round_number )
			{
				self thread threadProTip( tip );
			}
		}
		level waittill( "between_round_over" );
	}
}
addProTipTime( round, time, ref )
{
	tip = getProTipSlot( "time", ref );
	if( !IsDefined( tip ) )
		return;
	tip.round = round;
	tip.time = time;
}
addProTipTimeCoop( round, time, ref )
{
	tip = getProTipSlot( "time_coop", ref );
	if( !IsDefined( tip ) )
		return;
	tip.round = round;
	tip.time = time;
}
addProTipPosAngle( round, time, origin, angle, radius, ref )
{
	tip = getProTipSlot( "posangle", ref );
	if( !IsDefined( tip ) )
		return;
	tip.round = round;
	tip.time = time;
	tip.origin = origin;
	tip.angle = angle;
	tip.radius = radius;
}
addProTipZoneEnabled( round, time, zoneName, ref )
{
	tip = getProTipSlot( "zone_enabled", ref );
	if( !IsDefined( tip ) )
		return;
	tip.round = round;
	tip.time = time;
	tip.zoneName = zoneName;
}
addProTipTrigger( round, time, trigger, ref )
{
	tip = getProTipSlot( "trigger", ref );
	if( !IsDefined( tip ) )
		return;
	tip.round = round;
	tip.time = time;
	tip.trigger = trigger;
}
addProTipFlag( round, time, flag, ref )
{
	tip = getProTipSlot( "flag", ref );
	if( !IsDefined( tip ) )
		return;
	tip.round = round;
	tip.time = time;
	tip.flag = flag;
}
addProTipFunction( round, time, function, ref, skip_wait )
{
	tip = getProTipSlot( "function", ref );
	if( !IsDefined( tip ) )
		return;
	tip.round = round;
	tip.time = time;
	tip.function = function;
	
	if ( isdefined( skip_wait ) )
	{
		tip.skip_wait = skip_wait;
	}
}
getProTipSlot( type, ref )
{
	AssertEx( IsDefined( level.pro_tips_table[ref] ), 
		"Zombie ProTip: " + ref + " is not defined in zm_proTipsTabls.csv" );
	if( !IsDefined( level.pro_tips_table[ref] ) )
		return undefined;
	tip = SpawnStruct();
	
	tip.type = type;
	
	tip.round = 1;
	tip.time = 1;
	tip.origin = (0, 0, 0);
	tip.angle = 0.0;
	tip.radius = 1.0;
	tip.zoneName = undefined;
	tip.ref = ref;
	tip.skip_wait = 0;
	
	level.pro_tips[level.pro_tips.size] = tip;
	return( tip );
}
threadProTip( tip )
{
	
	
	
	self endon( "death" );
	self endon( "disconnect" );
	stat = self getdstat( "ZombieProTips", tip.ref );
	
	if( level.pro_tips_table[tip.ref]["max_displays"] != -1 )
	{
		if( !isDefined( stat ) || stat == 255 )
			return;
	}
	if( tip.type == "time" )
	{
		self displayProTip( tip );
	}
	else if( tip.type == "time_coop" )
	{
		self displayProTipTimeCoop( tip );
	}
	else if( tip.type == "zone_enabled" )
	{
		self displayProTipZone( tip );
	}
	else if( tip.type == "posangle" )
	{
		self displayProTipPosAngle( tip );
	}
	else if( tip.type == "trigger" )
	{
		self displayProTipTrigger( tip );
	}
	else if( tip.type == "function" )
	{
		self displayProTipFunction( tip );
	}
	else if( tip.type == "flag" )
	{
		self displayProTipFlag( tip );
	}
}
displayProTipTimeCoop( tip )
{
	while( 1 )
	{
		players = get_players();
		if( players.size > 1  )
		{
			self displayProTip( tip );
			return;
		}
		else
		{
			return;
		}
		wait( 1.1 );
	}
}
displayProTipZone( tip )
{
	while( 1 )
	{
		
		
		zone = level.zones[tip.zoneName];
		if( isdefined(zone) )
		{
			for( i=0; i<zone.volumes.size; i++ )
			{
				if( self IsTouching(zone.volumes[i]) )
				{
					self displayProTip( tip );
					return;
				}
			}
		}
		wait( 1.1 );
	}
}
displayProTipFunction( tip )
{
	while( 1 )
	{
		rval = self [ [tip.function] ]( tip );
		if( rval == -1 )
		{
			return;
		}
		else if( rval )
		{
			self displayProTip( tip );
			return;
		}
		
		wait( 1.1 );
	}
}
displayProTipPosAngle( tip )
{
	while( 1 )
	{
		playerPos = self GetOrigin();
		
		dist = ( (playerPos[0]-tip.origin[0]) * (playerPos[0]-tip.origin[0]) + 
				 (playerPos[1]-tip.origin[1]) * (playerPos[1]-tip.origin[1]) );
		dist = sqrt( dist );
		
		
		if( dist < tip.radius )
		{
			
			if( tip.angle == 0.0 )
			{
				self displayProTip( tip );
				return;
			}
				
			
			playerForward = AnglesToforward( self GetPlayerAngles() );
			
			
			dir = ( tip.origin[0]-playerPos[0], tip.origin[1]-playerPos[1], 0 );
			dirNorm = vectorNormalize( dir );
			dot = vectordot( dirNorm, playerForward );				
			
			if( dot > tip.angle )
			{
				self displayProTip( tip );
				return;
			}
		}
		wait( 1.1 );
	}
}
displayProTipTrigger( tip )
{
	trigger = GetEnt( tip.trigger, "targetname" );
	trigger waittill( "trigger" );
	self displayProTip( tip );
}
displayProTipFlag( tip )
{
	if( isDefined( level.flag[tip.flag] ) )
	{
		flag_wait( tip.flag );
		self displayProTip( tip );
	}
}
displayProTip( tip )
{
	if( !tip.skip_wait )
	{
		wait( tip.time );
	}
	tipRef = tip.ref;
	stat = self getdstat( "ZombieProTips", tipref );
	
	notifyData = spawnStruct();
	notifyData.sound = "evt_hint";
	notifyData.proTip1 = level.pro_tips_table[tipRef]["string1"];
	if( isDefined( level.pro_tips_table[tipRef]["string2"] ) )
		notifyData.proTip2 = level.pro_tips_table[tipRef]["string2"];
	notifyData.proTipWait = level.pro_tips_table[tipRef]["screen_time"];
	
	self maps\_hud_message::notifyMessage( notifyData );
	stat++;
	if( stat >= level.pro_tips_table[tipRef]["max_displays"] )
	{
		stat = 255;
	}
	
	self 	setdstat( "ZombieProTips", tipRef, stat );
}	
player_needs_reviving( tip )
{
	players = get_players();
	if( players.size > 1 )
	{
		for( i=0; i<players.size; i++ )
		{
			player = players[i];
			if ( player != self )
			{
				if( player maps\_laststand::player_is_in_laststand() )
				{
					return( 1 );
				}
			}
		}
	}
	else
	{
		return( -1 );
	}
	return( 0 );
}
player_please_buy_weapon( tip )
{
	
	if( !pro_tip_time_ready( tip ) )
	{
		return( 0 );
	}
	
	
	primaries = self GetWeaponsListPrimaries();
	for( i=0; i<primaries.size; i++ )
	{
		
		if ( primaries[i] == "m1911_zm" )
		{
			continue;
		}
		
		else
		{
			return( -1 );
		}
	}
	
	
	return( 1 );
}
player_pistol_ammo_low( tip )
{
	
	if( !pro_tip_time_ready( tip ) )
	{
		return( 0 );
	}
	
	
	wep_pistol = undefined;
	primaries = self GetWeaponsListPrimaries();
	for( i=0; i<primaries.size; i++ )
	{
		
		if ( primaries[i] == "m1911_zm" )
		{
			wep_pistol = primaries[i];
			continue;
		}
		
		else
		{
			return( -1 );
		}
	}
	
	
	
	if( isdefined( wep_pistol ) )
	{
		ammo_stock = self GetWeaponAmmoStock( wep_pistol );
		if( ammo_stock < 10 )
		{
			return( 1 );
		}
	}
	return( 0 );
}
player_down( tip )
{
	players = get_players();
	if( players.size > 1 )
	{
		if( self maps\_laststand::player_is_in_laststand() )
		{
			return( 1 );
		}
	}
	else
	{
		return( -1 );
	}
	return( 0 );
}
power_cell_pickup( tip )
{
	if( IsDefined( self.powercellEquipped ) )
	{
		if( self.powercellEquipped )
		{
			return( 1 );
		}
	}
	return( 0 );
}
death_card( tip )
{
	players = get_players();
	if( players.size == 1 )
	{
		return( -1 );
	}
	if( IsDefined( self.pro_tip_death_card_round ) )
	{
		if( level.round_number >= self.pro_tip_death_card_round )
		{
			return( 1 );
		}
	}
	return( 0 );
}
pro_tip_time_ready( tip )
{
	time = GetTime() - level.pro_tips_start_time;
	time /= 1000;
	
	if( (tip.round <= level.round_number) && (tip.time > time) )
	{
		return( 0 );
	}
	return( 1 );
} 
  
