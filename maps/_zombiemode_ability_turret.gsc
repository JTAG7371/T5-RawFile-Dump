#include maps\_utility;
#include common_scripts\utility;
init()
{
	precacheturret( "zombie_ability_turret" );
	precacheModel( "weapon_zombie_auto_turret" );
}
useTurret( posStart )
{
	
	
	turret = spawnTurret( "misc_turret", posStart, "zombie_ability_turret" );
	turret SetModel( "weapon_zombie_auto_turret" ); 	
	turret.angles = self.angles;
	
	
	turret setTeamForEntity( "allies" );
	turret setturretteam("allies");
	turret maketurretunusable();
	turret SetMode( "auto_nonai" );
	turret thread maps\_mgturret::burst_fire_unmanned();
	turret.turret_active = true;
	turret.curr_time = level.auto_turret_timeout;
	
	wait( 1.0 );
	
	flag_set("end_target_confirm");
	wait( level.auto_turret_timeout );
	
	
	turret.turret_active = false;
	turret.curr_time = -1;
	turret SetMode( "auto_ai" );
	turret notify( "stop_burst_fire_unmanned" );
	
	self notify( "turret_deactivated" );
	
	wait( 1.0 );
	
	if( isdefined( turret ) ) 
		turret Delete(); 
}