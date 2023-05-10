#include maps\_utility;
#include common_scripts\utility;
color_manager_think()
{
	
	if( IsDefined( level.color_manager_initialized ) )
		return;
	else
		level.color_manager_initialized = true;
	
	array_thread( GetEntArray( "color_manager", "targetname" ), ::color_manager_think_internal );
}
color_manager_think_internal() 
{
	
	color_trigger = GetEnt( self.target, "targetname" );	
	color_trigger.triggered = false;
	
	if( IsDefined( self.cm_flag ) )
	{
		if( !level flag_exists( self.cm_flag ) )
		{
			flag_init( self.cm_flag );
		}
	}
	
	if( IsDefined( self.script_aigroup ) )
	{
		self thread color_manager_track_ai_group();	
	}
	
	
	if( IsDefined( self.cm_flag ) )
	{
		self thread color_manager_track_flag();
		self waittill_any( "trigger", "ai_group_died", self.cm_flag );
	}
	else
	{
		self waittill_any( "trigger", "ai_group_died" );
	}
	
	if( IsDefined( self.cm_flag ) )
	{
		flag_wait( self.cm_flag );
	}
	
	
	if( IsDefined( self.script_aigroup ) )
	{	
		
		if( !IsDefined( self.cm_dont_kill ) )
		{
			
			if( IsDefined( self.cm_kill_delay ) )
			{
				wait( self.cm_kill_delay );
			}
			self color_manager_kill_spawners();
			array_thread( get_ai_group_ai( self.script_aigroup ), ::kill_ai );
		}
		
		waittill_ai_group_cleared( self.script_aigroup );
	}
	
	
	
	next_color_trigger_triggered = self color_manager_get_next_color_trigger_state( color_trigger );
	if( !next_color_trigger_triggered )
	{
		
		trigger_use( self.target, "targetname", get_players()[0] );
		color_trigger.triggered = true;
	}
	else
	{
		
		
		if( IsDefined( self.script_flag_set ) )
		{
			flag_set( self.script_flag_set );
		}
	}
	
	if( IsDefined( self.cm_delete ) )
	{
		self Delete();
	}
}
color_manager_get_next_color_trigger_state( color_trigger ) 
{
	if( IsDefined( color_trigger.target ) )
	{
		next_color_trigger = GetEnt( color_trigger.target, "targetname" );
		
		if( next_color_trigger.triggered )
		{
			return true;
		}
	}
	return false;
}
color_manager_track_ai_group() 
{
	self endon("trigger"); 
	
	
	waittill_ai_group_cleared( self.script_aigroup );
	
	self notify("ai_group_died");
}
color_manager_track_flag() 
{
	self endon("trigger"); 
	flag_wait( self.cm_flag );
	self notify( self.cm_flag );
}
color_manager_kill_spawners() 
{
	
	
	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		if( IsDefined( spawners[i].script_aigroup ) && spawners[i].script_aigroup == self.script_aigroup )
		{
			spawners[i] Delete();
		}
	}
}
kill_ai() 
{
	
	self DoDamage( self.health + 100, self.origin );
} 
 
  
 
 
 
