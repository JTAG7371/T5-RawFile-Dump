#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
init()
{
	level.supplyStationModelFriendly = "mp_supplydrop_ally";
	level.supplyStationModelEnemy= "mp_supplydrop_axis";
	level.supplyStationHelicopter = "vehicle_ch46e";
	
	PreCacheModel( level.supplyStationModelFriendly );
	PreCacheModel( level.supplyStationModelEnemy );
	PreCacheModel( level.supplyStationHelicopter );
	PreCacheShader( "waypoint_recon_artillery_strike" );
	PreCacheShader( "waypoint_x_green" );
	PreCacheString( &"MP_CAPTURING_CRATE" );
	
	
	maps\mp\gametypes\_hardpoints::registerKillstreak("supply_station_mp", "supplystation_mp", "killstreak_supply_station", "supply_station_used", ::useKillstreakSupplyStation);
	maps\mp\gametypes\_hardpoints::registerKillstreakStrings("supply_station_mp", &"MP_EARNED_SUPPLY_STATION", &"MP_AIRSPACE_FULL");
	maps\mp\gametypes\_hardpoints::registerKillstreakDialog("supply_station_mp", "mp_supply_drop", "kls_supply_used", "","kls_supply_enemy", "", "kls_supply_ready");
	maps\mp\gametypes\_hardpoints::registerKillstreakDevDvar("supply_station_mp", "scr_givesupplyStation");
	
	maps\mp\gametypes\_supplydrop::registerCrateType( "supplystation_mp", "supplystation", "supplystation", 1, &"MP_SUPPLY_STATION", "SHARE_PACKAGE_SUPPLY_STATION", ::doGiveAmmo );
}
canUseSupplyStation( player )
{
	if( level.teambased )
	{
		if( player.team != self.ownerTeam )
			return false;
	}
	else 
	{
		if( player != self.owner )
			return false;
	}
	return true;
}
supplyStationCrateThink()
{
	self endon ( "death" );
	self thread supplyStationCrateTimer();
	
	while ( 1 )
	{
		self waittill("captured", player);
		if( self canUseSupplyStation( player ) )
		{
			player doGiveAmmo();
		}
		else
		{
			self setSupplyStationOwner( player );
		}
	}
}
supplyStationCrateTimer()
{
	supplyStationDuration = getDvarIntDefault( #"supply_station_duration", 60 );
	supplyStationDuration *= 1000;
	supplyStationDuration += GetTime();
	while ( supplyStationDuration > GetTime() )
	{
		wait( 0.1 );
	}
	self maps\mp\gametypes\_supplydrop::crateDelete();
}
supplyStationBuffThink()
{
	self endon ( "death" );
	self waittill("captured", player);
	supplyStationBuffTime = getDvarIntDefault( #"supply_station_buff_time", 2 );
	while( 1 )
	{
		wait( supplyStationBuffTime );
		self buffPlayersInRadius();
	}
}
buffPlayersInRadius()
{
	radius = getDvarIntDefault( #"supply_station_buff_radius", 175 );
	
	for (i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if (!isalive(player) || player.sessionstate != "playing")
			continue;
		if( !self canUseSupplyStation( player ) )
			continue;
		playerpos = player.origin;
		dist = distance(self.origin, playerpos);
		if (dist < radius )
		{
			player buffPlayer();
		}
	}
}
buffPlayer()
{
	healthBuffPercentage = getDvarIntDefault( #"supply_station_buff_health_percentage", 25 ) / 100.0;
	ammoBuffPercentage = getDvarIntDefault( #"supply_station_buf_ammo_percentage", 25 ) / 100.0;
	self.health += int( self.maxhealth * healthBuffPercentage );
	if( self.health > self.maxhealth )
	{
		self.health = self.maxhealth;
	}
	weaponsList = self GetWeaponsList();
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];
		currentAmmo = self getWeaponAmmoStock( weapon );
		ammoToGive = currentAmmo + ( weaponStartAmmo( weapon ) * ammoBuffPercentage );
		self setWeaponAmmoStock( weapon, int( ammoToGive ) );
	}
}
setSupplyStationOwner( player )
{
	self.owner = player;
	if( self.ownerTeam != player.team )
	{
		self.ownerTeam = player.team;
		self SetTeam(self.ownerTeam);
		if ( level.teambased )
		{
			objective_team( self.friendlyObjID, self.ownerTeam );
			objective_team( self.enemyObjID, level.otherTeam[ self.ownerTeam ] );
		}
	}
}
doClassChange( ammo )
{
	self.usingSupplyStation = true;
	self maps\mp\gametypes\_globallogic_ui::beginClassChoice();
}
doGiveAmmo( ammo )
{
	self.usingSupplyStation = true;
	weaponsList = self GetWeaponsList();
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];
		self GiveMaxAmmo( weapon );
	}
}
useKillstreakSupplyStation(hardpointType)
{
	if ( self maps\mp\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;
	
	self thread maps\mp\gametypes\_supplydrop::refCountDecChopperOnDisconnect();
	
	result = self maps\mp\gametypes\_supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );
	if ( !IsDefined(result) || !result )
	{
		return false;
	}
	return result;
} 
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
