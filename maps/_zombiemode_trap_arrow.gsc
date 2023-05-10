#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
setup_arrow_traps( enable_flag )
{
	if( !isDefined( level.arrow_trap_cost ) )
	{
		level.arrow_trap_cost = 1000;
	}
	traps = getentarray( "arrow_trap_start_trigger", "targetname" );
	for( i = 0 ; i < traps.size; i++ )
	{
		traps[i] SetCursorHint( "HINT_NOICON" );
		traps[i] sethintstring( &"ZOMBIE_FLAMES_UNAVAILABLE" );
	}
	if ( IsDefined(enable_flag) )
	{
		flag_wait( enable_flag );
	}
	for( i = 0 ; i < traps.size; i++ )
	{
		arrow_start_loc = getstruct( traps[i].target, "targetname" );
		arrow_start_loc thread arrow_trap_think( traps[i] );
	}
}
arrow_trap_think( start_trigger )
{
	arrow = getent( self.target, "targetname" );
	arrow_original_origin = arrow.origin;
	arrow_trig = getent( arrow.target, "targetname" );
	arrow_trig enablelinkto();
	arrow_trig linkto( arrow );
	distance_struct = getstruct( arrow_trig.target, "targetname" );
	arrow_slit = getent(distance_struct.target, "targetname");
	distance = distance2d(self.origin, distance_struct.origin);
	forward_vec = AnglesToForward( self.angles );
	end_spot = arrow.origin + ( forward_vec[0] * distance, forward_vec[1] * distance, 0 );
	arrow thread arrow_trigger_think();
	wait(0.05);
	while(1)
	{
		cost = level.arrow_trap_cost;
		start_trigger SetHintString( &"ZOMBIE_BUTTON_NORTH_FLAMES", cost );
		start_trigger waittill("trigger", ent);
		
		if (ent maps\_laststand::player_is_in_laststand() )
		{
			continue;
		}
		if(ent in_revive_trigger())
		{
			continue;
		}
		if ( ent.score < cost )
		{
			start_trigger playsound("deny");
			continue;
		}
		ent maps\_zombiemode_score::minus_to_player_score( cost ); 
		start_trigger trigger_off();
		playfx( level._effect["wood_chunk_destory"], arrow_slit.origin ); 
		arrow_slit movez(30, 0.5);
		arrow_slit waittill("movedone");
		trap_timer = gettime() + 30000;
		while(Gettime() < trap_timer)
		{
			arrow moveto( end_spot, 1);
			playsoundatposition( "zmb_bolt", arrow.origin );
			arrow waittill_either("movedone", "ent hit");
			arrow moveto( arrow_original_origin, 0.05 );
			arrow waittill("movedone");
			wait(2);
		}
		arrow_slit movez(-30, 0.5);
		playfx( level._effect["wood_chunk_destory"], arrow_slit.origin ); 
		arrow_slit waittill("movedone");
		start_trigger trigger_on();
	}
}
arrow_trigger_think()
{
	arrow_trig = getent( self.target, "targetname" );
	while(1)
	{
		arrow_trig waittill( "trigger", ent );
		if( isplayer( ent ) )
		{
			ent dodamage(ent.health + 200, (0, 0, 0));
			arrow_trig notify("ent hit");
		}
		else
		{
			ent dodamage(ent.health + 200, (0, 0, 0));
			arrow_trig notify("ent hit");
		}
		wait(0.05);
	}
}