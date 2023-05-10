#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\debug;
#include maps\_anim;
#using_animtree( "generic_human" );
init_ai_rappel()
{
	level.scr_anim["generic"]["rappel_in"]	= %ai_rappel_in;
	level.scr_anim["generic"]["rappel"][0]  = %ai_rappel_loop_in_place;
	level.scr_anim["generic"]["rappel_out"] = %ai_rappel_out;    
	
	level.rappel_in_anim_length = GetAnimLength( level.scr_anim["generic"]["rappel_in"] );
	
	move_delta 	 		 = GetMoveDelta( level.scr_anim["generic"]["rappel_in"] );
	move_delta 	 		 = ( 0, 0, move_delta[2] ); 
	level.RAPPEL_IN_DIST = Length( move_delta );
	
	move_delta 	  		  = GetMoveDelta( level.scr_anim["generic"]["rappel_out"] );
	move_delta 	  		  = ( 0, 0, move_delta[2] ); 
	level.RAPPEL_OUT_DIST = Length( move_delta );
	level.MIN_RAPPEL_DIST = level.RAPPEL_IN_DIST + level.RAPPEL_OUT_DIST + 100;
	level.MIN_RAPPEL_TIME = 2.0; 
	level.rappel_initialized = true;
}
start_ai_rappel( time_to_rappel, rappel_point_struct, create_rope, delete_rope ) 
{
	self endon("death");
	
	
	if( !IsDefined( level.rappel_initialized ) )
		init_ai_rappel();		
	
	AssertEx( IsAI( self ), "start_ai_rappel should only be called on AI." );
	
	if( IsDefined( rappel_point_struct ) )
	{		
		if( IsString( rappel_point_struct ) ) 
			rappel_start = getstruct( rappel_point_struct, "targetname" );
		else
			rappel_start = rappel_point_struct;	
	}
	else
	{
		
		rappel_start = getstruct( self.target, "targetname" );
	}
	AssertEx( IsDefined( rappel_start ), "No rappel_start struct for rappel is defined." );
	
	if( !IsDefined( rappel_start.angles ) )
		rappel_start.angles = ( 0, 0, 0 );
	rappel_face_player = false;
	
	if( IsDefined( rappel_start.target ) )
	{
		rappel_end = getstruct( rappel_start.target, "targetname" );
	}
	else
	{
		
		rappel_end_pos = PhysicsTrace( rappel_start.origin, rappel_start.origin - ( 0, 0, 10000 ) );
		rappel_end = SpawnStruct();
		
		rappel_end.origin = rappel_end_pos;
		
		rappel_face_player = true;
	}
	if( !IsDefined( rappel_end.angles ) )
	{
		rappel_end.angles = ( 0, 0, 0 );	
	
		
		rappel_face_player = true;	
	}
		
	
	rappel_calulate_animation_points( rappel_start, rappel_end );
	
	self forceteleport( rappel_start.origin, rappel_start.angles );
	
	self thread rappel_handle_ai_death( rappel_start );
	
	if( IsDefined( create_rope ) )
	{
		rappel_handle_rope_creation( rappel_start, rappel_end, create_rope );
	}
	
	self thread rappel_handle_rope_deletion( rappel_start, delete_rope );
	
	self.allowDeath = true;
	
	
	
	if( !IsDefined( time_to_rappel ) )
	{
		velocity = ( 0, 0, 200 ); 
		dist = Distance( self.origin, self.out_point );
		time_to_rappel = dist / Length( velocity );
		if(time_to_rappel < level.MIN_RAPPEL_TIME  )
			time_to_rappel = level.MIN_RAPPEL_TIME;
	}
	
	
	
	
	move_ent = Spawn( "script_model", self.origin );
	move_ent.angles = self.angles;
	self thread rappel_move_ent_think( move_ent );
	
	self DisableClientLinkTo();
	
	self LinkTo( move_ent );
	
	self thread rappel_move_ai_thread( move_ent, rappel_start, rappel_end, time_to_rappel, rappel_face_player );
	
	self thread anim_generic_loop(self, "rappel");
	
	self waittill("start_exit");
	
	self StopAnimScripted();
	anim_single( self, "rappel_out", "generic" );
	
	self UnLink();
	
	move_ent Delete();		
	
	self notify("rappel_done");
}
rappel_calulate_animation_points( rappel_start, rappel_end ) 
{
	
	AssertEx( rappel_start.origin[0] ==  rappel_end.origin[0], "rappel start and end cant be away from each other vertically, their origin[0] value should be the same." );
	
	AssertEx( Distance( rappel_start.origin, rappel_end.origin ) >= level.MIN_RAPPEL_DIST, "Minimum distance for rappel is " + level.MIN_RAPPEL_DIST );
	
	self.out_point = rappel_end.origin + ( 0, 0, level.RAPPEL_OUT_DIST );
}
rappel_move_ai_thread( move_ent, rappel_start, rappel_end, time_to_rappel, rappel_face_player ) 
{
	self endon("death");
	
	if( rappel_face_player )
	{
		self thread rappel_face_player( move_ent, time_to_rappel );	
	}
	else
	{
		move_ent RotateTo( rappel_end.angles, RandomFloatRange(  1, time_to_rappel ) );
	}
	move_ent MoveTo( self.out_point, time_to_rappel, 1, 1 );
	move_ent waittill( "movedone" );
	self notify( "start_exit" );
}
rappel_face_player( move_ent, time_to_rappel ) 
{
	self endon("death");
	
	wait( time_to_rappel / 2 );
	
	player = get_closest_player( self.origin );
	angles = VectorToAngles( ( player.origin - self.origin ) );
	angles = ( 0, angles[1], 0 );
	move_ent RotateTo( angles, time_to_rappel / 2 );
}
rappel_move_ent_think( move_ent )
{
	self endon("rappel_done");
	
	self waittill("death");
	
	move_ent Delete();	
}
rappel_handle_rope_creation( rappel_start, rappel_end, create_rope ) 
{
	
	if( IsDefined( create_rope ) && create_rope )
		rappel_start.rappel_rope = CreateRope( rappel_start.origin, rappel_end.origin, Distance( rappel_start.origin, rappel_end.origin ) * 0.8 );
}
rappel_handle_rope_deletion( rappel_start, delete_rope ) 
{
	self waittill_any( "death", "rappel_done" );
	
	if( IsDefined( delete_rope ) && delete_rope && IsDefined( rappel_start.rappel_rope ) )
	{
		DeleteRope( rappel_start.rappel_rope );
		rappel_start.rappel_rope = undefined;
	}
}
rappel_struct_handle_rope_deletion()
{
	self endon("rappel_done");
	self waittill("delete_rope");
	
	if ( IsDefined( self.rappel_rope ) )
	{
		DeleteRope( self.rappel_rope );
		self.rappel_rope = undefined;	
	}
}
rappel_handle_ai_death( rappel_start )
{
	self endon("rappel_done");
	
	self waittill( "stop_rappel" );
	
	self StartRagdoll();
	self DoDamage( self.health, self.origin );
	
	if ( IsDefined( rappel_start.rappel_rope ) )
	{
		DeleteRope( rappel_start.rappel_rope );
		rappel_start.rappel_rope = undefined;	
	}
}	 
  
 
 
 
