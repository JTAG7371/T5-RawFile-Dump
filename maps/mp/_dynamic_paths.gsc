
#include maps\mp\_utility;
#include common_scripts\utility;
init()
{
	triggers = GetEntArray( "dynamic_path_trig", "targetname" );
	array_thread( triggers, ::dyn_path_trigger_init );
	array_thread( triggers, ::dyn_path_trigger_watch );
	array_thread( triggers, ::dyn_path_trigger_think );
}
dyn_path_trigger_init()
{
	if ( self.classname == "trigger_damage" )
	{
		self trigger_destroy_init();
	}
	else if ( self.classname == "trigger_use" )
	{
		self trigger_repair_init();
	}
}
trigger_destroy_init()
{
	self barrier_init();
	self SetCursorHint( "HINT_NOICON" );
	if ( !self.barrier.destroyed )
	{
		self Show();
	}
	else
	{
		self Hide();
	}
}
trigger_repair_init()
{
	self barrier_init();
	self SetCursorHint( "HINT_NOICON" );
	if ( !self.barrier.destroyed )
	{
		self Hide();
		self SetHintString( "" );
	}
	else
	{
		self Show();
		self SetHintString( "Press [Use] to repair" );
	}
}
barrier_init()
{
	
	self.barrier = GetEnt( self.target, "targetname" );
	assert( IsDefined( self.barrier ) );
	
	if ( !IsDefined( self.barrier.destroyed ) )
	{
		self.barrier.destroyed = false;
		if ( IsDefined( self.barrier.script_noteworthy ) )
		{
			if ( self.barrier.script_noteworthy == "destroyed" )
			{
				self.barrier.destroyed = true;
			}
		}
	}
}
dyn_path_trigger_watch()
{
	for ( ;; )
	{
		result = self.barrier waittill_any_return( "barrier_destroyed", "barrier_repaired" );
		if ( result == "barrier_destroyed" )
		{
			if ( self.classname == "trigger_damage" )
			{
				self Hide();
			}
			else
			{
				assert( self.classname == "trigger_use" );
				self Show();
				self SetHintString( "Press [Use] to repair" );
			}
		}
		else
		{
			assert( result == "barrier_repaired" );
			if ( self.classname == "trigger_damage" )
			{
				self Show();
			}
			else
			{
				assert( self.classname == "trigger_use" );
				self Hide();
				self SetHintString( "" );
			}
		}
	}
}
dyn_path_trigger_think()
{
	if ( self.classname == "trigger_damage" )
	{
		self trigger_destroy_think();
	}
	else if ( self.classname == "trigger_use" )
	{
		self trigger_repair_think();
	}
}
trigger_destroy_think()
{
	for ( ;; )
	{
		self waittill( "trigger", player );
		self.barrier notify( "barrier_destroyed" );
		self.barrier.destroyed = true;
		self set_barrier_state();
		self.barrier waittill( "barrier_repaired" );
	}
}
trigger_repair_think()
{
	for ( ;; )
	{
		self waittill( "trigger", player );
		self.barrier notify( "barrier_repaired" );
		self.barrier.destroyed = false;
		self set_barrier_state();
		self.barrier waittill( "barrier_destroyed" );
	}
}
set_barrier_state()
{
	if ( self.barrier.destroyed == true )
	{
		self.barrier Hide();
		self.barrier NotSolid();
	}
	else
	{
		self.barrier Show();
		self.barrier Solid();
	}
}  
