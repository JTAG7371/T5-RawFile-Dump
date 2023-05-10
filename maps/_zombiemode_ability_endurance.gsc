#include maps\_utility;
#include common_scripts\utility;
init()
{
}
useEndurance()
{
	wait( 1.0 );
	flag_set("end_target_confirm");
	
	
	self VisionSetNaked( "zombie_turned", 1 );
	
	
	
	self AllowSprint( false ); 
	self setPerk( "specialty_endurance" );
	wait( 30.0 );
	self UnsetPerk( "specialty_endurance" );
	self AllowSprint( true ); 
	
	
	
	self VisionSetNaked( level.zombie_visionset, 1 );
	
	return true;
}