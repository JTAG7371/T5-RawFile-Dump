
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\utility;
#include animscripts\debug;
door_breach_init(model,int_model)
{
	door_breach_load_player_anims();
	door_breach_load_door_anims();
	door_breach_load_fx();
	
	if(!IsDefined(model))
	{
		model = level.player_interactive_hands;
	}
	door_breach_set_viewmodel(model);
	
	if(!isDefined(int_model))
	{
		int_model = level.player_interactive_model;
	}
	
	door_breach_set_interactive_model(int_model);
	
	
	flag_init("player_breaching");
	
	flag_wait("all_players_connected");
	
	door_breach_init_triggers();
	
	door_breach_init_gunnable_doors();
}
door_breach_load_fx()
{
	
	level._effect["hinge_door_bash"] 		= loadfx("destructibles/fx_feature_door_break_reg");	
	level._effect["slide_door_breach"]	= loadfx("destructibles/fx_feature_door_sliding_reg");	
	level._effect["lift_door_breach"]		= loadfx("destructibles/fx_feature_door_lift_reg");	
	
	precacherumble( "grenade_rumble" );
}
door_breach_init_triggers()
{
	trigs = getentarray("trig_hinge_door", "script_noteworthy");
	array_thread(trigs, ::hinge_door_open);
	
	trigs_slide = getentarray("trig_slide_door", "script_noteworthy");
	array_thread(trigs_slide, ::slide_door_open);
	
	trigs_rolltop = getentarray("trig_rolltop_door", "script_noteworthy");	
	array_thread(trigs_rolltop, ::rolltop_door_open);	
	
	
	trigs_kick =  getentarray("trig_kick_door", "script_noteworthy");	 
	array_thread(trigs_kick, ::kick_door_open);	
	
	
	trigs = array_combine(trigs, trigs_slide);
	trigs = array_combine(trigs, trigs_rolltop);
	
	
	trigs = array_combine(trigs, trigs_kick);
	
	
	for(i = 0; i < trigs.size; i++)
	{
		trigs[i] door_breach_trigger_on();
		door = trigs[i] door_breach_get_door_from_trig();
		door disconnectpaths();
		
		door.originalAngles = door.angles;
		door.originalOrigin = door.origin;
	}
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
	
	while( isdefined(trig) )
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
	screen_message_delete();
}
give_door_open_prompt( trig )
{
	trig endon("breach_door_opened");
	self endon("disconnect");
	
	self SetScriptHintString(&"SCRIPT_HINT_DOOR");
	
	while( self istouching(trig) && isdefined(trig.safe_to_print) && trig.safe_to_print )
	{
		wait(.1);
	}
	
	self SetScriptHintString("");
}
draw_tags( model )
{
	model endon( "willcleanup" );
	
}
hinge_door_open()
{	
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();	
	
	self notify("door_opening");
	
	
	
	player lerp_player_view_to_position(lerppos.origin, lerppos.angles, .05, 1);
	
	
	player_hands = Spawn_anim_model( "door_breach_player_hands" );	
	player_hands.angles = player.angles;
	player_hands.origin = player.origin;
	
	
	
	player PlayerLinkToAbsolute( player_hands, player.door_link);
	player_hands SetVisibleToPlayer( player );
	player HideViewModel();
	
	
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	door connectpaths();
	
	
	flag_set("player_breaching");
	door thread anim_ents( door, "door_breach_shoulder", undefined, "hinge_door");
	
	
	
	
	level thread temp_play_fx_late(lerppos);
	
	
	player thread play_sound_on_entity("fly_door_breach_1p");
	player playeranimscriptevent( "breach_shoulder" ); 	
	player_hands animscripted( "door_opened", player_hands.origin, player_hands.angles, level.scr_anim["door_breach_player_hands"]["door_breach_shoulder"]);
	
	player playrumbleonentity("grenade_rumble");	
	
	player_hands waittillmatch("door_opened", "end");
	
	player_hands notify("willcleanup");
	
	
	player_hands Delete();
	player Unlink();
	player ShowViewModel();
	player stopdoorbreach();
	
	door unlink();
	
	
	flag_clear("player_breaching");
	
	self notify("breach_door_opened");
	player notify("door_breached");
	waittillframeend;
	self trigger_off();
}
kick_door_open()
{	
	
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();	
	
	
	currentweapon = player getcurrentweapon();
	
	weaponModel = GetWeaponModel(currentweapon); 
	
	self notify("door_opening");
	
	player StartCameraTween( 0.2 );
	player lerp_player_view_to_position(lerppos.origin, lerppos.angles, .05, 1);
	
	
	
	
	
	
	player_hands = spawn_anim_model("door_breach_player_body",(0,0,0));
		
	player_hands hide();
	player_hands.angles = player.angles;
	player_hands.origin = player.origin;
	
	
	player_hands Attach(weaponModel, "tag_weapon" ); 
	
	player_hands useweaponhidetags( currentweapon);
	
	player PlayerLinkTo( player_hands, "tag_player");
	player_hands SetVisibleToPlayer( player );
	
	
	player HideViewModel();
	
	
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	door connectpaths();
	
	flag_set("player_breaching");
	
	door thread anim_ents( door, "door_breach_kick", undefined, "kick_door");
	
	
	level thread door_kick_sound_and_fx(lerppos, player);
		
	
	player_hands animscripted( "door_opened", player_hands.origin, player_hands.angles, level.scr_anim["door_breach_player_hands"]["door_breach_kick"]);
	
	
	wait(.05);
	
	
	player_hands show();
	
	player thread rumble_delay(0.4, "grenade_rumble");
	player_hands waittillmatch("door_opened", "end");
	
	player_hands notify("willcleanup");
	
	
	player_hands Delete();
	player Unlink();
	player ShowViewModel();
	player stopdoorbreach();
	
	door unlink();
		
	
	flag_clear("player_breaching");
	
	self notify("kick_door_opened");
	player notify("door_breached");
	waittillframeend;
	self trigger_off();
}
slide_door_open()
{
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();		
	
	self notify("door_opening");
	
	
	lerppos = getstruct(self.target, "targetname");
	
	org = GetStartOrigin( lerppos.origin, lerppos.angles, level.scr_anim["door_breach_player_hands"]["door_breach_slide"] );
	angles = GetStartAngles( lerppos.origin, lerppos.angles, level.scr_anim["door_breach_player_hands"]["door_breach_slide"] );	
	
	player lerp_player_view_to_position(org, angles, .05, 1);
	
	
	player_hands = Spawn_anim_model( "door_breach_player_hands" );	
	
	player_hands.origin = org;
	player_hands.angles = angles; 	
	
	player PlayerLinkToAbsolute( player_hands, player.door_link);
	player_hands SetVisibleToPlayer( player );
	player HideViewModel();
	
	
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	door connectpaths();
		
	
	flag_set("player_breaching");
	
	door thread anim_ents( door, "door_breach_slide", undefined, "slide_door");
	
	playfx(level._effect["slide_door_breach"], lerppos.origin, lerppos.angles );	
	
	player thread play_sound_on_entity("fly_door_slide_3p");
	player playeranimscriptevent( "breach_slide" ); 	
	player_hands animscripted( "door_opened", lerppos.origin, lerppos.angles, level.scr_anim["door_breach_player_hands"]["door_breach_slide"]);
	
	player_hands waittillmatch("door_opened", "end");	
	
	
	player_hands Delete();
	player Unlink();
	player ShowViewModel();
	player stopdoorbreach();
		
	door unlink();
		
	
	flag_clear("player_breaching");
		
	self trigger_off();	
	self notify("breach_door_opened");
}
rolltop_door_open()
{	
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();		
	
	self notify("door_opening");
	
	
	player lerp_player_view_to_position(lerppos.origin, lerppos.angles, .05, 1);
	
	
	player_hands = Spawn_anim_model( "door_breach_player_hands" );	
	player_hands.angles = lerppos.angles;
	player_hands.origin = lerppos.origin;
	
	player PlayerLinkToAbsolute( player_hands, player.door_link);
	player_hands SetVisibleToPlayer( player );
	player HideViewModel();
	
	
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	door connectpaths();
		
	
	flag_set("player_breaching");
		
	door thread anim_ents( door, "door_breach_rolltop", undefined, "rolltop_door");
	
	playfx(level._effect["lift_door_breach"], lerppos.origin, lerppos.angles );	
	
	
	player thread play_sound_on_entity("fly_roll_up_door_3p");
	player playeranimscriptevent( "breach_lift" ); 	
	player_hands animscripted( "door_opened", player_hands.origin, player_hands.angles, level.scr_anim["door_breach_player_hands"]["door_breach_rolltop"]);
	
	player_hands waittillmatch("door_opened", "end");
	
	
	player_hands Delete();
	player Unlink();
	player ShowViewmodel();
	player stopdoorbreach();
		
	door unlink();	
	
	flag_clear("player_breaching");
			
	self trigger_off();
	self notify("breach_door_opened");
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
							else if( players[i] use_button_held() )
							{
								player = players[i];
								player.door_link = "tag_origin";
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
door_kick_sound_and_fx(lerppos, player)
{
	wait(.6);
	
	player playsound ("fly_dtp_launch_plr");
	
	wait(.5);
	
	playfx(level._effect["hinge_door_bash"], lerppos.origin, lerppos.angles );
	player  playsound ("fly_wmd_door_breach");
	
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
	self.can_open = true;
	
	
	door = self door_breach_get_door_from_trig();
	door.script_linkto = "origin_animate_jnt";
	
	switch( self.script_noteworthy )
	{
		case "trig_hinge_door":
			door thread anim_ents( door, "door_breach_shoulder_close", undefined, "hinge_door");
			break;
		case "trig_slide_door":
			door thread anim_ents( door, "door_breach_slide_close", undefined, "slide_door");
			break;
		case "trig_rolltop_door":
			door thread anim_ents( door, "door_breach_rolltop_close", undefined, "rolltop_door");
			break;			
	}	
	
	
	
	
	
}
door_breach_open_all_doors()
{
	trigs = getentarray("trig_hinge_door", "script_noteworthy");	
	trigs_slide = getentarray("trig_slide_door", "script_noteworthy");	
	trigs_rolltop = getentarray("trig_rolltop_door", "script_noteworthy");
	
	for(i = 0; i < trigs.size; i++)
	{
		if(trigs[i].can_open)
		{
			door = trigs[i] door_breach_get_door_from_trig();
			door.script_linkto = "origin_animate_jnt";
			level thread anim_ents( door, "door_breach_shoulder", undefined, undefined, door, "hinge_door");
			
			trigs[i] door_breach_trigger_off();
		}
	}
	for(i = 0; i < trigs_slide.size; i++)
	{
		if(trigs_slide[i].can_open)
		{		
			door = trigs_slide[i] door_breach_get_door_from_trig();
			door.script_linkto = "origin_animate_jnt";
			level thread anim_ents( door, "door_breach_slide", undefined, undefined, door, "slide_door");
			
			trigs_slide[i] door_breach_trigger_off();
		}
	}
	for(i = 0; i < trigs_rolltop.size; i++)
	{
		if(trigs_rolltop[i].can_open)
		{
			door = trigs_rolltop[i] door_breach_get_door_from_trig();
			door.script_linkto = "origin_animate_jnt";
			level thread anim_ents( door, "door_breach_rolltop", undefined, undefined, door, "rolltop_door");
			
			trigs_rolltop[i] door_breach_trigger_off();
		}
	}		
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
#using_animtree("player");
door_breach_load_player_anims()
{
	level.scr_animtree[ "door_breach_player_hands" ] 	= #animtree;		
	level.scr_anim["door_breach_player_hands"]["door_breach_shoulder"]			= %int_breach_shoulder;
	level.scr_anim["door_breach_player_hands"]["door_breach_slide"]					= %int_breach_slide;
	level.scr_anim["door_breach_player_hands"]["door_breach_rolltop"]				= %int_breach_lift;
	
	
	level.scr_anim["door_breach_player_hands"] ["door_breach_kick"] = %ch_wmd_b01_kickbreach_player;
	
	
	level.scr_animtree[ "door_breach_player_body" ] 	= #animtree;		
	level.scr_anim["door_breach_player_body"] ["door_breach_kick"] = %ch_wmd_b01_kickbreach_player;
}
door_breach_set_viewmodel(model)
{
	level.scr_model[ "door_breach_player_hands" ] = model;
}
door_breach_set_interactive_model(model)
{
	level.scr_model[ "door_breach_player_body" ] = model;
}
#using_animtree("door_breach");
door_breach_load_door_anims()
{
	level.scr_animtree["hinge_door"] 											= #animtree;
	level.scr_model["hinge_door"] 												= "tag_origin_animate";
	level.scr_anim["hinge_door"]["door_breach_shoulder"] 	= %o_breach_shoulder;
	level.scr_anim["hinge_door"]["door_breach_shoulder_close"] 	= %o_breach_shoulder_close;
	
	
	level.scr_animtree["slide_door"]											= #animtree;
	level.scr_model["slide_door"]													= "tag_origin_animate";
	level.scr_anim["slide_door"]["door_breach_slide"]			= %o_breach_slide;
	level.scr_anim["slide_door"]["door_breach_slide_close"]			= %o_breach_slide_close;
	
	level.scr_animtree["rolltop_door"]										= #animtree;
	level.scr_model["rolltop_door"]												= "tag_origin_animate";
	level.scr_anim["rolltop_door"]["door_breach_rolltop"]	= %o_breach_lift;
	level.scr_anim["rolltop_door"]["door_breach_rolltop_close"]	= %o_breach_lift_close;
	
	
	level.scr_animtree["kick_door"]											= #animtree;
	level.scr_model["kick_door"]												= "tag_origin_animate";
	level.scr_anim["kick_door"]["door_breach_kick"]			= %ch_wmd_b01_kickbreach_door;
} 
 
 
 
  
