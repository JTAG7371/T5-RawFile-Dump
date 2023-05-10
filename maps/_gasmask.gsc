#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_utility;
#include maps\_busing;
main()
{
	thread init_and_run();
}
init_and_run( toggle )
{
	if(!IsDefined(toggle))
	{
		toggle = true;
	}
	
	wait_for_all_players();
	
	players = get_players();
	
	for( i=0; i < players.size; i++)
	{
		if(toggle)
		{
			players[i] thread gasmask_watch_buttonpress();
		}
	
	  players[i].gas_mask = false;
		players[i] thread gasmask_toggle();
	}
}
gasmask_watch_buttonpress()
{
	self endon( "_gasmask_stop_watching_buttons" );
	
	button = "DPAD_DOWN";
	
	while( 1 )
	{
		if( self ButtonPressed( button ) )
		{
			self notify( "_gasmask_button_pressed" );
			
			while( self ButtonPressed( button ) )
			{
				wait( 0.05 );
			}			
		}
		wait 0.05;
	}	
}
gasmask_toggle()
{
	self endon ( "death" );
	
	for (;;)
	{
		self waittill_either( "_gasmask_button_pressed", "night_vision_on" );	
		gasmask_put_on();
		self waittill_either( "_gasmask_button_pressed", "night_vision_off" ); 
		gasmask_remove();
		wait 0.05;
	}
}
gasmask_put_on()
{
	self.gas_mask = true;
	clientNotify( "_gasmask_on_pristine" );
	setClientSysState("levelNotify", "gmon", self);
  setBusState( "gasmask_on" );
}
gasmask_remove()
{
	self.gas_mask = false;
	clientNotify( "_gasmask_off" );
	setClientSysState("levelNotify", "gmoff", self);
	setBusState( "default" );
}