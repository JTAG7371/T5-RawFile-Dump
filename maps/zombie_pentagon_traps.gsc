#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_traps;
#include maps\_zombiemode_utility;
init_traps()
{
	level init_flags();
	
	level electric_trap_battery_init();
	level pentagon_fix_electric_trap_init();
	
	
	level quad_first_drop_fx_init();
}
init_flags()
{
	flag_init( "trap_elevator" );
	flag_init( "trap_quickrevive" );
	
	
}
electric_trap_battery_init()
{
	trap_batteries = GetEntArray( "trigger_trap_piece", "targetname" );
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		players[i]._trap_piece = 0;
	}
	
	array_thread( trap_batteries, ::pickup_trap_piece );
}
pickup_trap_piece()
{
	self endon( "_piece_placed" );
	
	if( !IsDefined( self.target ) )
	{
		
		return;
	}
	
	trap_piece = self spawn_trap_piece();
	
	self SetHintString( &"ZOMBIE_PENTAGON_GRAB_MISSING_PIECE" );
	self SetCursorHint( "HINT_NOICON" );
	
	
	self.picked_up = 0;
	
	
	self UseTriggerRequireLookAt();
	while( self.picked_up == 0 )
	{
		self waittill( "trigger", user );
	
		if( is_player_valid( user ) )
		{
			if( IsDefined( user._trap_piece ) && user._trap_piece > 0 ) 
			{
				play_sound_at_pos( "no_purchase", self.origin );
				continue;
			}
			else
			{	
				self trigger_off();
				
				if( IsDefined( trap_piece ) )
				{
					PlayFXOnTag( level._effect["switch_sparks"], trap_piece, "tag_origin" );
					
					
					trap_piece thread play_sound_on_entity( "zmb_battery_pickup" );
					user thread pentagon_have_battery_hud();
					user thread trap_piece_deliver_clean_up( self );
				}	
				user._trap_piece = 1;
				self.picked_up = 1;
				
				user thread pentagon_hide_piece_triggers();
				
				
				trap_piece Delete();
			}		
		}	
	}
}
spawn_trap_piece()
{
	spawn_struct = getstruct( self.target, "targetname" );
	
	trap_model = Spawn( "script_model", spawn_struct.origin );
	trap_model SetModel( "zombie_sumpf_power_switch" );
	trap_model.angles = spawn_struct.angles;
	
	return trap_model;
}
pentagon_hide_piece_triggers()
{	
	trap_piece_triggers = GetEntArray( "trigger_trap_piece", "targetname" );
	
	for( i = 0; i < trap_piece_triggers.size; i++ )
	{
		if( trap_piece_triggers[i].picked_up == 0 )
		{
			trap_piece_triggers[i] SetInvisibleToPlayer( self ); 
		}
	}
}
pentagon_fix_electric_trap_init()
{
	fix_trigger_array = GetEntArray( "trigger_battery_trap_fix", "targetname" );
	
	if( IsDefined( fix_trigger_array ) )
	{
		array_thread( fix_trigger_array, ::pentagon_fix_electric_trap );
	}
}
pentagon_fix_electric_trap()
{
	if( !IsDefined( self.script_flag_wait ) ) 
	{
		PrintLn( "trap at " + self.origin + " missing script flag" );
		return;
	}
	
	if( !IsDefined( self.script_string ) )
	{
		PrintLn( "trap at " + self.origin + " missing script string" );
	}
	
	self SetHintString( &"ZOMBIE_PENTAGON_MISSING_PIECE" );
	self SetCursorHint( "HINT_NOICON" );
	self UseTriggerRequireLookAt();
	
	trap_trigger = GetEntArray( self.script_flag_wait, "targetname" ); 
	array_thread( trap_trigger, ::electric_hallway_trap_piece_hide, self.script_flag_wait );
	
	trap_cover = GetEnt( self.script_string, "targetname" ); 
	level thread pentagon_trap_cover_remove( trap_cover, self.script_flag_wait );
	
	while( !flag( self.script_flag_wait ) ) 
	{
		self waittill( "trigger", who );
		
		if( is_player_valid( who ) )
		{
			if( !IsDefined( who._trap_piece ) || who._trap_piece == 0 ) 
			{
				play_sound_at_pos( "no_purchase", self.origin );
				
			}
			else if( IsDefined( who._trap_piece ) && who._trap_piece == 1 ) 
			{
				who._trap_piece = 0;
				
				self PlaySound( "zmb_battery_insert" );
				
				who thread pentagon_show_piece_triggers();
	
				flag_set( self.script_flag_wait ); 
				
				who notify( "trap_piece_returned" );
				
				who thread pentagon_remove_battery_hud();
			}
		}	
	}
	
	
	self SetHintString( "" );
	self trigger_off();
}
pentagon_show_piece_triggers()
{	
	trap_piece_triggers = GetEntArray( "trigger_trap_piece", "targetname" );
	
	for( i = 0; i < trap_piece_triggers.size; i++ )
	{
		if( trap_piece_triggers[i].picked_up == 0 )
		{
			trap_piece_triggers[i] SetVisibleToAll(); 
		}
	}
}
trap_piece_deliver_clean_up( ent_trig )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self waittill( "trap_piece_returned" );
	
	ent_trig notify( "_piece_placed" );
	
	ent_trig Delete();
}
electric_hallway_trap_piece_hide( str_flag )
{
	if( !IsDefined( str_flag ) )
	{
		return;
	}
	
	if( self.classname == "trigger_use" )
	{
		self SetHintString( &"ZOMBIE_NEED_POWER" );
		self thread electric_hallway_trap_piece_show( str_flag );
		self trigger_off();
	}
} 
electric_hallway_trap_piece_show( str_flag )
{
	if( !IsDefined( str_flag ) )
	{
		return;
	}
	
	flag_wait( str_flag );
	
	self trigger_on();
}
pentagon_trap_cover_remove( ent_cover, str_flag )
{
	flag_wait( str_flag );
	
	
	ent_cover NotSolid();
	ent_cover.fx = Spawn( "script_model", ent_cover.origin );
	ent_cover.fx SetModel( "tag_origin" );
	
	ent_cover MoveZ( 48, 1.0, 0.4, 0 );
	ent_cover waittill( "movedone" );
	
	ent_cover RotateRoll( ( 360 * RandomIntRange( 4, 10 ) ), 1.2, 0.6, 0 );
	PlayFXOnTag( level._effect["poltergeist"], ent_cover.fx, "tag_origin" );
	
	ent_cover waittill( "rotatedone" );
	
	ent_cover Hide();
	ent_cover.fx Hide();
	ent_cover.fx Delete();
	ent_cover Delete();
	
	
	
}
pentagon_have_battery_hud()
{
	self.powercellHud = create_simple_hud( self );
	self.powercellHud.foreground = true;
	self.powercellHud.sort = 2;
	self.powercellHud.hidewheninmenu = false;
	self.powercellHud.alignX = "center";
	self.powercellHud.alignY = "bottom";
	self.powercellHud.horzAlign = "user_right";
	self.powercellHud.vertAlign = "user_bottom";
	self.powercellHud.x = -200; 
	self.powercellHud.y = 0;
	self.powercellHud.alpha = 1;
	self.powercellHud setshader( "zom_icon_trap_switch_handle", 32, 32 );
	
	self thread pentagon_remove_hud_on_death();
}
pentagon_remove_battery_hud()
{
	if( IsDefined( self.powercellHud ) )
	{
		self.powercellHud Destroy();
	}
}
pentagon_remove_hud_on_death()
{
	self endon( "trap_piece_returned" );
	
	self waittill_either( "death", "_zombie_game_over" );
	
	self thread pentagon_remove_battery_hud()	;
}
quad_first_drop_fx_init()
{
	vent_drop_triggers = GetEntArray( "trigger_quad_intro", "targetname" );
	
	
	for( i = 0; i < vent_drop_triggers.size; i++ )
	{
		level thread quad_first_drop_fx( vent_drop_triggers[i] );
	}
}
quad_first_drop_fx( ent_trigger )
{
	if( !IsDefined( ent_trigger.script_int ) )
	{
		return;
	}
	
	exploder_id = ent_trigger.script_int;
	
	ent_trigger waittill( "trigger" );
	
	ent_trigger PlaySound( "evt_pentagon_quad_spawn" );
	
	exploder( exploder_id );
}