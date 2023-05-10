
#include maps\mp\_utility;
#include common_scripts\utility;
door_breach_init()
{
	door_breach_load_fx();
	
	
	
	
	
	door_breach_init_triggers();
	
	
}
door_breach_load_fx()
{
	
	level._effect["hinge_door_bash"] = loadfx("destructibles/fx_feature_door_break_reg");	
	precacherumble( "grenade_rumble" );
}
door_breach_init_triggers()
{
	trigs = getentarray("trig_hinge_door", "script_noteworthy");
	array_thread(trigs, ::hinge_door_open);
	
	
	
}
door_breach_init_gunnable_doors()
{
	trigs = getentarray("doorknob_dmg_trigger", "targetname");
	
	array_thread(trigs, ::doorknob_shoot_to_open);
	
	
	for(i = 0; i < trigs.size; i ++)
	{
		knob = getent(trigs[i].target, "targetname");
		bashtrig = getent(knob.target, "targetname");
		lerpstruct = getstruct(bashtrig.target, "targetname");
		door = getent(lerpstruct.target, "targetname");
		
		knob linkto(door);
	}
	
}
doorknob_shoot_to_open()
{
	self waittill("trigger");
	
	knob = getent(self.target, "targetname");
	
	trig = getent(knob.target, "targetname");
	trig.knob_shot = true;
	
	
	knob delete();
}
hint_string_print()
{
	players = get_players();
	
	array_thread(players, ::hint_text_while_in_trig, self);
}
hint_text_while_in_trig(trig)
{
	trig endon("breach_door_opened");
	self endon("disconnect");
	
	self thread destroy_prompt_on_open(trig);
	
	while(true)
	{
		if( self istouching( trig ) && isdefined(trig.safe_to_print) && trig.safe_to_print )
		{
			self give_door_open_prompt(trig);
		}
		
		wait(.1);
	}
}
destroy_prompt_on_open(trig)
{
	trig waittill("breach_door_opened");
	
	if( isdefined( self.door_prompt ) )
	{
		self.door_prompt destroy();
	}
}
give_door_open_prompt( trig )
{
	trig endon("breach_door_opened");
	self endon("disconnect");
	
	self.door_prompt = newClientHudElem( self );
	self.door_prompt.x = 0;
	self.door_prompt.y = 90;
	self.door_prompt.alignX = "center";
	self.door_prompt.alignY = "middle";
	self.door_prompt.horzAlign = "center";
	self.door_prompt.vertAlign = "middle";
	self.door_prompt.fontScale = 1.25;
	self.door_prompt SetText("Press X To Open Door");	
	while( self istouching(trig) && isdefined(trig.safe_to_print) && trig.safe_to_print )
	{
		wait(.1);
	}
	
	if( isdefined( self.door_prompt ) )
	{
		self.door_prompt destroy();
	}
}
hinge_door_open()
{	
	lerppos = getstruct(self.target, "targetname");
	self waittill("trigger");
	
	
	door = getent(lerppos.target, "targetname");
	
	door delete();
}
door_breach_wait_for_button_pressed( lerpstruct )
{
	waiting = true;
	player = undefined;
	
	while( waiting )
	{
		self waittill("trigger");
		
		wait(.05);
		players = get_players();
		
		if( isdefined( self.can_open ) && self.can_open == true )
		{
			for( i = 0; i < players.size; i++)
			{
				if( players[i] istouching(self) )
				{
					if( isdefined( self.knob_shot ) && self.knob_shot )
					{
						player = players[i];
						waiting = false;
					}
					else
					{
						
						dot = door_breach_get_player_struct_dot(players[i], lerpstruct);
						
						if( dot > 0)
						{
							self.safe_to_print = true;
							if( isdefined( self.shot_opened ) && self.shot_opened )
							{
								player = players[i];
								waiting = false;						
							}
							else if( players[i] usebuttonpressed() )
							{
								player = players[i];
								waiting = false;
							}
						}
						else
						{
							self.safe_to_print = false;
						}
					}
				}
			}
		}
	}	
	
	return player;
}
door_breach_get_player_struct_dot(player, struct)
{
	structforward = AnglestoForward(struct.angles);
	structnormalized = vectornormalize( structforward );
	playerforward = AnglestoForward( player getplayerangles() );
	playernormalized = VectorNormalize( playerforward);
	
	dot = vectordot( playernormalized, structnormalized );	
	
	return dot;
}
fx_play_slinters()
{
	
	playfx(level._effect["hinge_door_bash"], self.origin, self.angles );	
}
temp_play_fx_late(lerppos)
{
	wait(.3);
	
	playfx(level._effect["hinge_door_bash"], lerppos.origin, lerppos.angles );
}
door_breach_can_open()
{
	if( isdefined(self.can_open) )
	{
		return self.can_open;
	}
	else
	{
		assertmsg("Door Breach Trigger Not Initialized.  Does it have the proper script_noteworthy?");
	}
}
door_breach_trigger_on()
{
	self.can_open = true;
	self trigger_on();
}
door_breach_trigger_off()
{
	self.can_open = false;
	self trigger_off();
}
door_breach_door_reset()
{
	
	
	
	
	
}
door_breach_open_all_doors()
{
}
door_breach_get_struct_from_trig()
{
	struct = getstruct(self.target, "targetname");
	return struct;
}
door_breach_get_door_from_trig()
{
	struct = self door_breach_get_struct_from_trig();
	door = getent(struct.target, "targetname");
	
	return door;
} 
 
 
 
 
 
 
 
  
