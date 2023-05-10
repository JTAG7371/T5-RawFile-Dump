#include maps\_utility;
#include common_scripts\utility; 
	
		
		
		
climb_player_start( first_struct_name )
{
	self climb_initialize_on_player();
	
	
	player_mover 	= spawn( "script_model", self.origin );
	player_mover setmodel( "tag_origin" );
	player_mover.angles = self GetPlayerAngles( );
	
	self PlayerLinkToDelta( player_mover, "tag_origin", 1, 15, 15, 15, 15, true );
	moveto_point 	= getstruct( first_struct_name, "targetname" );	
	
	
	self thread [[ self.climb_movement[ moveto_point.script_noteworthy ] ]]();
	
	while( true )
	{	
		self thread climb_check_tutorial( moveto_point ); 	
		
		while( !self [[ self.climb_button ]]() )						
		{
			wait( .05 );
		}
		
		self notify( "climb_advance" );
		
		player_mover moveto( moveto_point.origin, .5 );
		player_mover RotateTo( moveto_point.angles, .5 );
		player_mover waittill( "movedone" );	
		
		self.climb_steps++;
		self notify( "climb_step_done" );
		
		if( !IsDefined( moveto_point.target ) )
		{
			break;
		}
		
		moveto_point = getstruct( moveto_point.target, "targetname" );
		self climb_check_movement_type( moveto_point );
	}
	
	self AllowCrouch( true );
	self AllowProne( true );	
	
	return player_mover;
}
	
climb_initialize_on_player()
{
	self.climb_steps = 0;
	self AllowCrouch( false );
	self AllowProne( false );
	self DisableWeapons();
	
	self.climb_movement = [];
	self.climb_movement[ "climb_scale" ] 			= ::climb_movement_scale;
	self.climb_movement[ "climb_horizontal" ] = ::climb_movement_horizontal;
	self.climb_movement[ "climb_leap" ]				= ::climb_movement_leap;
}
climb_check_tutorial( next_node )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	if( !IsDefined( next_node.script_noteworthy ) )
	{
		return;
	}
	
	switch( next_node.script_noteworthy )
	{
		case "climb_scale":
			screen_message_create( "Alternate between ^3[{+speed_throw}]^7 and ^3[{+attack}]^7 to Climb" );
			self waittill( "climb_step_done" );	
			screen_message_delete();
			break;
		case "climb_horizontal":
			screen_message_create( "Use ^3[{+breath_sprint}]^7 to Climb Horizontally" );
			self waittill( "climb_step_done" );
			screen_message_delete();
			break;
		
		case "climb_leap":
			screen_message_create( "Press ^3[{+gostand}]^7 to Leap to Next Handhold" );
			self waittill( "climb_step_done" );
			screen_message_delete();		
			break;
			
		default:
		
	}
}
	
climb_check_movement_type( next_struct )
{
	if( !IsDefined( next_struct.script_noteworthy ) )
	{
		return; 	
	}
	
	self thread [[ self.climb_movement[ next_struct.script_noteworthy ] ]]();
}
	
climb_movement_scale()
{
	self notify( "climb_type_changed" );
	self endon( "climb_type_changed" );
	
	while( true )
	{
		self.climb_button = ::climb_ads_button_pressed;
		self waittill( "climb_advance" );
		
		self.climb_button = ::climb_attack_button_pressed;
		self waittill( "climb_advance" );		
	}
}
	
climb_movement_horizontal()
{
	self notify( "climb_type_changed" );
	self endon( "climb_type_changed" );	
	
	self.climb_button = ::climb_move_button_pressed;
}
	
climb_movement_leap()
{
	self notify( "climb_type_changed" );
	self endon( "climb_type_changed" );
	
	self.climb_button = ::climb_jump_button_pressed;
}
climb_attack_button_pressed()
{
	return self AttackButtonPressed();
}
climb_ads_button_pressed()
{
	return self ThrowButtonPressed();
}
climb_move_button_pressed()
{
	movement = self GetNormalizedMovement();
	
	if( movement[1] > .3 )
	{	
		return( true );
	}
	else
	{
		return( false );
	}
}
climb_jump_button_pressed()
{
	return self jumpbuttonpressed();
}