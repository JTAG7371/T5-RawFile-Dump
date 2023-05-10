#include maps\_utility;
#include common_scripts\utility;
init()
{
}
useCloak()
{
	wait( 1.0 );
	flag_set("end_target_confirm");
	
	
	self VisionSetNaked( "zombie_turned", 1 );
	
	
	self setclientflag( level._ZOMBIE_PLAYER_FLAG_CLOAK_WEAPON );	
	
	
	self.ignoreme = true;
	wait( 35.0 );
	self.ignoreme = false;
	
	
	self clearclientflag( level._ZOMBIE_PLAYER_FLAG_CLOAK_WEAPON );	
	
	
	self VisionSetNaked( level.zombie_visionset, 1 );
	
	return true;
}