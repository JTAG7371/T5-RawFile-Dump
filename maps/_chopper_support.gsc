#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\_vehicle_turret_ai;
#using_animtree("generic_human");
main()
{
	PreCacheModel("tag_origin");
	
	
	PreCacheShader("black");
	flag_init("chopper_pass_in_progress");
	flag_init("chopper_on_but_no_targetting");
	flag_init("chopper_doing_custom_action");
	flag_init("miniguns_on");
	flag_init("lower_radio");
	flag_init("failsafe_chopperstrike_called");
	level.scr_anim["hueyspot0"]["idle"][0]	= %ai_huey_pilot1_idle_loop1;
	level.scr_anim["hueyspot1"]["idle"][0]	= %ai_huey_gunner1;	
	level.scr_anim["hueyspot2"]["idle"][0]	= %ai_huey_gunner2;	
	level.scr_anim["hueyspot3"]["idle"][0]	= %ai_huey_pilot2_idle_loop1;	
	level.scr_anim["hueyspot4"]["idle"][0]	= %ai_huey_passenger_f_lt;	
	level.scr_anim["hueyspot5"]["idle"][0]	= %ai_huey_passenger_f_rt;	
	level.scr_anim["hueyspot6"]["idle"][0]	= %ai_huey_passenger_b_lt;	
	level.scr_anim["hueyspot7"]["idle"][0]	= %ai_huey_passenger_b_rt;
}
chopper_support_setup()
{	
	
	level._dont_face_nextspot = 0;
	level._successful_airstrike_calls = 0; 
	
	get_players()[0] GiveWeapon("rocket_barrage_sp");
	get_players()[0] SetActionSlot( 4, "weapon", "rocket_barrage_sp");
	get_players()[0] SwitchToWeapon("rocket_barrage_sp");
	
	get_players()[0] thread air_support_buttoncheck(); 
	get_players()[0] thread overlay();
	
	level thread chopper_patrol();
	level thread final_street_skydemon_strafe();
	level thread clear_screen_messages();
	level thread chopper_failsafe();
}
air_support_buttoncheck()
{
	level endon ("shut_down_chopper_support");
	
	level thread stop_drawing_fx();
	level thread air_support_reminder();
	lastweap = self getcurrentweapon();
	
	while( 1 ) 
	{
		if ( self getcurrentweapon() != "rocket_barrage_sp")
		{
			lastweap = self getcurrentweapon();
			level.player AllowPickupWeapons(true);
		}
		if ( self getcurrentweapon() == "rocket_barrage_sp" || flag("failsafe_chopperstrike_called") ) 
		{
			level.player AllowPickupWeapons(false);
			get_players()[0] thread ground_playerlook_trace();
			fired = air_support_fire_watch();  
			
			if ( fired )
			{
				level thread chopper_support_request_confirm_voiceover(level.airtargetspot);
				
				level notify ("stop_moving_target");
				level.last_airstrike_counter = 0;
				level._successful_airstrike_calls++;
				get_players()[0] thread put_away_radio(lastweap);
			
				level thread notify_on_notify("skydemon_at_firing_spot", level, "stop_moving_target");
				level thread notify_on_notify("skydemon_at_firing_spot", level, "stop_drawing_target");
			
				if (!flag("chopper_doing_custom_action"))
				{
					chopper_find_spot(level.airtargetspot); 
				}
			}
			else
			{
				level notify ("stop_moving_target");
				level notify ("stop_drawing_target");
			}
			
			flag_waitopen("chopper_doing_custom_action");
			get_players()[0] GiveWeapon("rocket_barrage_sp");
			get_players()[0] SetActionSlot( 4, "weapon", "rocket_barrage_sp");
			get_players()[0] SetWeaponAmmoClip("rocket_barrage_sp",1);
		}
		wait 0.05;
	}
	
}
stop_drawing_fx()
{
	level endon ("shut_down_chopper_support");
	while(1)
	{
		level waittill ("stop_drawing_target");
		if (IsDefined(level._draw_target_fx) )
		{
			level._draw_target_fx Delete();
			level._draw_target_fx = undefined;
		}
		if (IsDefined(level._last_draw_target_fx) )
		{
			level._last_draw_target_fx Delete();
			level._last_draw_target_fx = undefined;
		}
	}
}
put_away_radio(lastweap)
{
	wait 0.1;
	
	flag_wait("authorization_operation_said");
	
	if ( self getcurrentweapon() == "rocket_barrage_sp"  && IsDefined(lastweap) && lastweap !="none" )
	{
		get_players()[0] TakeWeapon("rocket_barrage_sp");
		get_players()[0] SwitchToWeapon(lastweap);
	}
	else if (self getcurrentweapon() == "rocket_barrage_sp" && ( !IsDefined(lastweap) || (IsDefined(lastweap) && lastweap =="none"))  )
	{
		wait 0.1;
		weapList = get_players()[0] GetWeaponsListPrimaries();
		get_players()[0] SwitchToWeapon(weapList[0]);
	}
	flag_clear("lower_radio");
}
air_support_fire_watch()
{
	level endon ("shut_down_chopper_support");
	while(1)
	{
		if (flag("failsafe_chopperstrike_called"))
		{
			return true;
		}
		
		if ( get_players()[0] AttackButtonPressed() && level.airtargetspot._color != "red")
		{
			level.airtargetspot._color = "yellow";
			return true;
		}
		if ( get_players()[0] getcurrentweapon() != "rocket_barrage_sp")
		{
			return false;
		}
		if ( get_players()[0] AttackButtonPressed() && level.airtargetspot._color == "red")
		{
			get_players()[0] GiveWeapon("rocket_barrage_sp");
			get_players()[0] SetActionSlot( 4, "weapon", "rocket_barrage_sp");
			get_players()[0] SetWeaponAmmoClip("rocket_barrage_sp",1);
			get_players()[0] SwitchToWeapon("rocket_barrage_sp");
		}
				
		wait 0.05;
	}
}
use_air_support()
{
	flag_wait("bomber_support_ready");
	
	screen_message_create(&"HUE_CITY_ACTION_4_BOMB");
	lastweap = self getcurrentweapon();
	get_players()[0] GiveWeapon("rocket_barrage_sp");
	get_players()[0] SetActionSlot( 4, "weapon", "rocket_barrage_sp");
	get_players()[0] SetWeaponAmmoClip("rocket_barrage_sp",1);
	
	while( 1 ) 
	{
		if ( self getcurrentweapon() != "rocket_barrage_sp")
		{
			lastweap = self getcurrentweapon();
			
			if(isDefined(level._last_draw_target_fx))
			{
				level._last_draw_target_fx Delete();
			}			
			if(isDefined(level._draw_target_fx))
			{
				level._draw_target_fx delete();
			}		
		}
		if ( self getcurrentweapon() == "rocket_barrage_sp"  ) 
		{
			get_players()[0] thread ground_playerlook_trace();
			fired = air_support_fire_watch();  
			
			if ( fired )
			{
				level notify ("stop_moving_target");
				get_players()[0] thread put_away_radio(lastweap);
				screen_message_delete();
				bombers_bomb_target();
				return;
			}
			else
			{
				level notify ("stop_moving_target");
				level notify ("stop_drawing_target");
			}
			
			get_players()[0] GiveWeapon("rocket_barrage_sp");
			get_players()[0] SetActionSlot( 4, "weapon", "rocket_barrage_sp");
			get_players()[0] SetWeaponAmmoClip("rocket_barrage_sp",1);
		}
		wait 0.05;
	}
}
player_called_bombers()
{
	level endon ("stop_air_targetting");
	get_players()[0] thread playerlook_trace();
	while( get_players()[0] AttackButtonPressed() == false ) 
	{
		wait 0.1;
	}
	
	level thread bombers_bomb_target();
	level notify ("stop_air_targetting");
}
chopper_find_spot(attackspot)
{
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	
	level notify("stop_air_targetting");
	
	flag_wait("authorization_operation_said");
	flag_waitopen("chopper_pass_in_progress");
	flag_set("chopper_pass_in_progress");
	
	
	chopperheight = 8250;
	foundaspot = 0;
	myspot = undefined;
	firstspot = undefined;
	counter = 0;
	level._chopperstrike_section = undefined;
	killtank = undefined;
	while(foundaspot ==0)
	{
		counter++;
		potentialspot = (attackspot.origin[0], attackspot.origin[1], chopperheight);
		if ( counter > 40 )		
		{
			potentialspot = (attackspot.origin[0], attackspot.origin[1], chopperheight);
			myspot = potentialspot+ random_offset(RandomIntRange(500,1200),RandomIntRange(500,1200),0);
		}
		
		
		else
		{
			is_there_a_choperstrike = new_chopper_findpath(attackspot); 
			if (IsDefined(is_there_a_choperstrike))
			{
				foundaspot = 1;
				myspot = is_there_a_choperstrike.origin;
				breakout = 1;
				break;
			}
			myzones = match_player_zone();
			breakout = 0;
			for (i=0; i < myzones.size; i++) 
			{
				if (level.skydemon IsTouching(myzones[i]) )
				{
					myspot = level.skydemon.origin;
					breakout = 1;
				}
			}
			
			if (!breakout)
			{
				myzone = myzones[RandomInt(myzones.size)];
				x = Int(myzone.radius);
				y = Int(myzone.script_int/2);
				z =  Int(myzone.height/2);
				
				myspot = myzone.origin+ random_offset(x ,y  ,z);
				myspot =  ( myspot[0], myspot[1], chopperheight);
				getstruct(myzone.targetname+"_struct", "targetname");
				firstspot = getstruct(myzone.targetname+"_struct", "targetname");
			}
		}
		
		trace = bullettrace(myspot, attackspot.origin, true, undefined);
		if (DistanceSquared(trace["position"]+(0,0,-60), attackspot.origin) < (300*300)  &&
				DistanceSquared(myspot, (attackspot.origin[0], attackspot.origin[1], chopperheight) ) > (500*500)	)		
			{
				foundaspot = 1;
				break;
			}
		wait 0.1;
		
		if (counter > 50)
		{
			level.skydemon notify ("stop_facing");
			level._dont_face_nextspot = 1;
			flag_clear("chopper_pass_in_progress");
			maps\hue_city_event2::chopper_support_negative_voiceover(1);
			return;
		}
	}
	skydemon = level.skydemon;
	skydemon SetCanDamage(false);
	if (!IsDefined(skydemon._custom_strafe_function))
	{
		skydemon SetLookAtEnt( attackspot);
		skydemon SetTurretTargetEnt(attackspot);
	}
	
	if (IsDefined(firstspot))
	{
		skydemon SetVehGoalPos( firstspot.origin);
		skydemon.goalradius = 200;
		skydemon SetLookAtEnt(attackspot);
		skydemon waittill ("goal");
		skydemon SetSpeed(10);
	}
	
	skydemon SetVehGoalPos( myspot, 1 );
	skydemon.goalradius = 50;
	level notify ("stop_moving_target");
	if (!IsDefined(skydemon._custom_strafe_function) )
	{
		level notify ("stop_drawing_target");
	}
	if (IsDefined(skydemon._custom_strafe_function) )
	{
		skydemon thread goal_when_cantsee();
	}
	if (!IsDefined(skydemon._fire_before_goal) )
	{
		skydemon waittill ("goal");
	}
	
	if (IsDefined(skydemon._custom_strafe_function))
	{
		level thread notify_delay("skydemon_at_firing_spot", 3);
		skydemon [[skydemon._custom_strafe_function]]();
		killtank = 1;
	}
	else
	{
		level notify ("skydemon_at_firing_spot");	
		skydemon chopper_fire(attackspot);
	}
	
	level notify ("clear_clearzone");
	level.clearzone = undefined;
	skydemon ResumeSpeed(20);
	skydemon._fire_before_goal = undefined;
	skydemon._custom_strafe_function = undefined;
	
	neworg = (skydemon.origin[0], skydemon.origin[1], 8300);
	skydemon SetVehGoalPos( neworg);
	skydemon.goalradius = 50;
	skydemon waittill ("goal");
	
	level thread area_clear_vo(killtank);
	wait 2;
	skydemon notify ("stop_facing");
	level notify ("chopper_pass_done");
	level._dont_face_nextspot = 1;
	
	flag_clear("chopper_pass_in_progress");
}
chopper_support_request_confirm_voiceover(attackspot, danger_close)
{
	if (!IsDefined(danger_close))
	{
		danger_close = undefined;
	}
	maps\hue_city_event2::chopper_support_request_voiceover(attackspot, danger_close);
	flag_set("lower_radio");
	maps\hue_city_event2::chopper_support_confirm_voiceover(attackspot, danger_close);
}
area_clear_vo(tank_killed)
{
	maps\hue_city_event2::chopper_support_confirm_kills_voiceover(tank_killed);
}
chopper_fire(attackspot)
{
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	
	self thread mg_fire(attackspot);
	
	trace = bullettrace(self GetTagOrigin("tag_flash"), attackspot.origin, true, undefined);
	org = attackspot.origin;
	
	
	if (IsDefined(level.clearzone))		
	{
		self clear_zone();
		return true;
	}
	
	delete_spawner_radius = 650;
	delete_spawners_in_radius(attackspot.origin, delete_spawner_radius); 
	
	
	
	self clear_area(attackspot);
	return true;
}
	
mg_fire(attackspot)
{
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	self notify ("new_mgfire");
	self endon ("new_mgfire");
	for (i=0; i < 5; i++)
	{
		hitspot = attackspot.origin;
		wait RandomFloatRange(0.5,2);
		validtargets = [];
		axis = GetAIArray("axis");
		validtarget_radius = 700;
		
		for (i=0; i < axis.size; i++)
		{
			if (DistanceSquared (hitspot, axis[i].origin) < (validtarget_radius*validtarget_radius) )
			{
				validtargets = array_add(validtargets, axis[i]);
			}
		}
		
		for (i=0; i < validtargets.size; i++)
		{
			if (IsDefined(validtargets[i]) && IsAlive(validtargets[i]) )
			{
				self SetGunnerTargetEnt( validtargets[i], (0,0,0), 2 );		
				shots = RandomIntRange(2,6);
				for (j=0; j < shots; j++)
				{
					if (IsDefined(validtargets[i]) && IsAlive(validtargets[i]) )
					{
						
						wait 0.25;
					}
				}
			}
		}
	}
}
chopper_find_target(spot)
{
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	guys = GetAIArray("axis");
	myguy = undefined;
	closeguys = [];
	for (i=0; i < guys.size; i++)
	{
		if ( DistanceSquared(guys[i].origin, spot.origin) < (500*500) )
		{
			array_add(closeguys, guys[i]);
		}
	}
		
	if (closeguys.size ==0)
	{
		wait 0.2;
		return;
	}
	
	if (!IsDefined(myguy))
	{
		myguy = guys[RandomInt(closeguys.size)];
	}
	
	spot Unlink();
	spot.origin = myguy.origin;
	spot LinkTo (myguy);
}
	
playerlook_trace()
{
	level endon ("shut_down_chopper_support");
	level endon ("stop_air_targetting");
	
	if (!IsDefined(level.airtargetspot))
	{
		level.airtargetspot = spawn_a_model("tag_origin", self.origin);
	}
	else
	{
		level.airtargetspot.origin = self.origin;
	}
	level.airtargetspot._color = "green";
	
	level thread draw_target_color(); 
	
	while(1)
	{
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();
		
		trace = bullettrace( eye, eye + vector_multiply( direction_vec , 10000 ), 0, undefined );
		level.airtargetspot.origin = trace["position"];
		
		
		level.airtargetspot.angles = direction *-1;
		
		if (DistanceSquared(get_players()[0].origin, level.airtargetspot.origin) < (175*175) )
		{
			if (level.airtargetspot._color == "green")
			{
				level thread text_display(&"HUE_CITY_TARGET_TOO_CLOSE", undefined, undefined,undefined,"stop_moving_target", undefined, 0.2 );
			}
			level.airtargetspot._color = "red";
		}	
							
		else 
		{
			if (level.airtargetspot._color == "red")
			{
				level thread text_display("");
			}
			level.airtargetspot._color = "green";
		}
		wait 0.05;
	}
}
		
ground_playerlook_trace()		
{
	level endon ("shut_down_chopper_support");
	level endon ("stop_moving_target");
		
	if (!IsDefined(level.airtargetspot))  
	{
		level.airtargetspot = spawn_a_model("tag_origin", self.origin);
	}
	else
	{
		level.airtargetspot.origin = self.origin;
	}
	level.airtargetspot._color = "green";
	current_color_state = "green";
	level thread draw_target_color();
	while(1) 
	{
		apc = GetEnt("e2_friendly_apc", "targetname");
		sdm = level.skydemon;
		defend_tank = getent("defend_tank","targetname");
		
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();
		trace = bullettrace( eye, eye + vector_multiply( direction_vec , 10000 ), 0, undefined );
		level.airtargetspot moveto(trace["position"], 0.05);
		
		level.airtargetspot RotateTo(VectorToAngles( trace["normal"] ), 0.05);
		
		if (DistanceSquared(get_players()[0].origin, level.airtargetspot.origin) < (250*250) )
		{
			if (current_color_state == "redb" || current_color_state == "green")
			{
				level thread text_display(&"HUE_CITY_TARGET_TOO_CLOSE", undefined, 305,265,"stop_moving_target", undefined, 0.8 );
				current_color_state = "reda";
			}
			level.airtargetspot._color = "red";
		}
		
		else if ( (IsDefined(apc) && ( DistanceSquared(apc.origin, level.airtargetspot.origin) < (300*300) ) )
				||		(IsDefined(sdm) && ( DistanceSquared(sdm.origin, level.airtargetspot.origin) < (300*300) ) ) )
		{
			if ( (IsDefined(apc) && level.airtargetspot IsTouching(apc)) || (IsDefined(sdm) && level.airtargetspot IsTouching(sdm)) )
			{
				if (current_color_state == "reda" || current_color_state == "green")
				{
					level thread text_display(&"HUE_CITY_TARGET_IS_FRIENDLY", undefined, 305,265,"stop_moving_target", undefined, 0.8 );
					current_color_state = "redb";
				}
				level.airtargetspot._color = "red";
			}
		}
		
		else if ( IsDefined(defend_tank) && DistanceSquared(defend_tank.origin, level.airtargetspot.origin) > (300*300) )
		{
			level.airtargetspot._color = "red";
		}		
				
		else 
		{
			if (level.airtargetspot._color == "red")
			{
				level thread text_display("");
			}
			level.airtargetspot._color = "green";
			current_color_state = "green";
		}
		level.airtargetspot waittill ("movedone");
	}
}
		
draw_target_color()
{
	level endon ("shut_down_chopper_support");
	level endon ("stop_drawing_target");
	level._last_draw_target_fx = spawn_a_model("tag_origin", level.airtargetspot.origin, level.airtargetspot.angles);
	level._last_draw_target_fx LinkTo(level.airtargetspot, "tag_origin", (0,0,0), (0,0,0) );
	
	lastcolor = "ship_brown";
	
		while (1)
		{
			if ( level.airtargetspot._color == "green" && lastcolor!= "green")
			{
				level._last_draw_target_fx Delete();
				if(isDefined(level._draw_target_fx))
				{
					level._draw_target_fx delete();
				}
				level._draw_target_fx = spawn_a_model("tag_origin", level.airtargetspot.origin, level.airtargetspot.angles);
				level._draw_target_fx LinkTo(level.airtargetspot, "tag_origin", (0,0,0), (0,0,0) );
	
				PlayFXOnTag(level._effect["airstrike_valid_target"], level._draw_target_fx, "tag_origin");	
				lastcolor = level.airtargetspot._color;
				level._last_draw_target_fx = level._draw_target_fx;
			}
			
			else if ( level.airtargetspot._color == "red" && lastcolor!= "red")
			{
				level._last_draw_target_fx Delete();
				if(isDefined(level._draw_target_fx))
				{
					level._draw_target_fx delete();
				}
				level._draw_target_fx = spawn_a_model("tag_origin", level.airtargetspot.origin, level.airtargetspot.angles);
				level._draw_target_fx LinkTo(level.airtargetspot, "tag_origin", (0,0,0), (0,0,0) );
	
				PlayFXOnTag(level._effect["airstrike_invalid_target"], level._draw_target_fx, "tag_origin");
				lastcolor = level.airtargetspot._color;	
				level._last_draw_target_fx = level._draw_target_fx;
			}
			
			else if ( level.airtargetspot._color == "yellow" && lastcolor!= "yellow")
			{
				
				level._last_draw_target_fx Delete();
				if(isDefined(level._draw_target_fx))
				{
					level._draw_target_fx delete();
				}
				level._draw_target_fx = spawn_a_model("tag_origin", level.airtargetspot.origin, level.airtargetspot.angles);
				level._draw_target_fx LinkTo(level.airtargetspot, "tag_origin", (0,0,0), (0,0,0) );
				
				PlayFXOnTag(level._effect["airstrike_confirmed_target"], level._draw_target_fx, "tag_origin");	
				lastcolor = level.airtargetspot._color;
				level._last_draw_target_fx = level._draw_target_fx;
			}
			wait 0.05;
		}
}
overlay()
{
	level endon ("shut_down_chopper_support");
	while(1)
	{
		level waittill ("start_overlay");
		
		bomber_black = newClientHudElem( self );
		bomber_black.x = 0;
		bomber_black.y = 0;
		bomber_black.alignX = "left";
		bomber_black.alignY = "top";
		bomber_black.horzAlign = "fullscreen";
		bomber_black.vertAlign = "fullscreen";
		bomber_black.foreground = true;
		bomber_black setshader ("black", 640, 480);
		bomber_black.alpha = 0;
		bomber_black FadeOverTime( 0.2 );
		bomber_black.alpha = 1; 
		wait 0.2;
		bomber_black FadeOverTime( 0.2 );
		bomber_black.alpha = 0.1;
		
		bomber_overlay = newClientHudElem( self );
		bomber_overlay.x = 0;
		bomber_overlay.y = 0;
		bomber_overlay.alignX = "center";
		bomber_overlay.alignY = "middle";
		bomber_overlay.horzAlign = "center";
		bomber_overlay.vertAlign = "middle";
		bomber_overlay.foreground = true;
		bomber_overlay setshader ("ac130_overlay_105mm", 640, 480);
		
		bomber_grain = newClientHudElem( self );
		bomber_grain.x = 0;
		bomber_grain.y = 0;
		bomber_grain.alignX = "left";
		bomber_grain.alignY = "top";
		bomber_grain.horzAlign = "fullscreen";
		bomber_grain.vertAlign = "fullscreen";
		bomber_grain.foreground = true;
		bomber_grain setshader ("ac130_overlay_grain", 640, 480);
		bomber_grain.alpha = 0.5;
				
		level thread increase_static(bomber_grain, bomber_black);
		level waittill ("end_overlay");
				
		bomber_black FadeOverTime( 0.2 );
		bomber_black.alpha = 1; 
		wait 0.2;
		bomber_overlay Destroy();
		bomber_grain Destroy();
		bomber_black FadeOverTime( 0.2 );
		bomber_black.alpha = 0;
		wait 0.2;
		bomber_black Destroy();
	}
}
increase_static(bomber_grain, bomber_black)
{
	level endon ("end_overlay");
	{
		while(1)
		{
			level waittill ("at_edge");
			bomber_grain.alpha = 1;
			bomber_grain FadeOverTime( 0.1 );
			bomber_black.alpha = 0.6;
			bomber_black FadeOverTime( 0.1 );
			wait 0.7;
			bomber_grain.alpha = 0.5;
			bomber_grain FadeOverTime( 0.1 );
			bomber_black.alpha = 0.1;
			bomber_black FadeOverTime( 0.1 );
		}
	}
}
chopper_spotlight_aim()
{
	self notify ("new_spotlight_target_loop");
	self endon ("new_spotlight_target_loop");
	self endon ("death");
	while(1)
	{
		chopper_spotlight_aim_loop();
		keep_other_gunners_target(0,3, 1);	
	}
}
chopper_spotlight_aim_loop()
{
	self notify ("new_spotlight_target");
	self endon ("new_spotlight_target");
	self endon ("death");
	level endon ("miniguns_on");
	self enable_turret(3, "huey_spotlight");
	flag_wait("miniguns_on");
}
chopper_shine_first_building()
{
	self notify ("new_spotlight_target");
	spot = getstruct("chopperstrike1_rocket_balcony_spot3", "targetname").origin + (0,0,-250) ;
	self setgunnertargetvec(spot, 3);
	wait 12;
	self thread chopper_spotlight_aim();
}
	
chopper_patrol()
{
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	
	spot = getstruct("chopper_first_patrol_spot", "script_noteworthy");
	while(!IsDefined(level.skydemon))
	{
		level.skydemon = GetEnt("skydemon", "targetname");
		wait 0.5;
	}
	
	level.skydemon SetForcenoCull();
	level.skydemon thread maps\hue_city::fill_huey_with_script_models("event2_over");
	
	
	
	
	flag_wait("chopper_pass_in_progress");
	wait 5;
	
	level.skydemon thread random_mg_target();
	level.skydemon thread side_gunners_gun();
	
	
	
	
	
	while(1)
	{
		flag_waitopen("chopper_pass_in_progress");
		spot = getstruct(spot.target, "targetname");
		nextspot = getstructent(spot.targetname, "targetname");
		travelto_next_spot(nextspot);
		
		flag_waitopen("chopper_pass_in_progress");
		nextspot Delete();
	}
	
}
side_gunners_gun()
{
	level endon ("shut_down_chopper_support");
	level endon ("chopper_doing_custom_action");
	
	ent = spawn( "script_origin" , (0,0,0));
	self thread audio_ent_fakelink( ent );
	ent thread audio_ent_fakelink_delete();
	
	
	self thread minigun_rumble();
	
	
	player = get_players()[0];
	self._track_0_gunnerturret = 1;
	
	while(1)
	{
		flag_wait("miniguns_on");
		if (flag("chopperstrike_5_called"))
		{
			flag_wait("end_strafe");
		}
		
		
		if (!flag("street1_tank_dead_now"))
		{
			ent playsound( "evt_minigun_spin_up_3p" , "sound_done" );
			ent waittill( "sound_done" );
			ent playloopsound( "wpn_minigun_fire_loop_npc" );	
		}
		
		self thread enable_turret(0, "huey_minigun");
		self thread keep_other_gunners_target(0,1);
		
		
			
		flag_waitopen("miniguns_on");
		ent playsound( "evt_minigun_spin_down_3p" );
		ent stoploopsound(.048);
		self thread disable_turret(0);
	}
}
keep_other_gunners_target(lead_gunner,following_gunner, dont_autofire)
{
	while(flag("miniguns_on"))
	{
		target = self getgunnertargetent(lead_gunner);
		wait 0.2;
		if (IsDefined(target) )
		{
			self setgunnertargetent(target,(0,0,0),following_gunner);
			if (!IsDefined(dont_autofire))
			{
				self FiregunnerWeapon(following_gunner);
			}
		}
	}
}
		
audio_ent_fakelink( ent )
{
	level endon("shut_down_chopper_support" );
	self endon ("death");
	
	while(1)
	{
		ent moveto( self.origin, .1 );
		ent waittill("movedone");
	}
}
audio_ent_fakelink_delete()
{
	level waittill( "shut_down_chopper_support" );
	
	self delete();
}
audio_ent_loopsound( notify_string )
{
	self playloopsound( "wpn_minigun_fire_loop_npc" );
	level waittill( notify_string );
	self playsound( "evt_minigun_spin_down_3p" );
	self stoploopsound(.05);
	
}
random_mg_target()
{
	level endon ("shut_down_chopper_support");
	level endon ("chopper_doing_custom_action");
	
	while(1)
	{
		wait (RandomIntRange(2,5) );
		flag_waitopen("chopper_pass_in_progress");
		self thread enable_turret(2);
		flag_wait("chopper_pass_in_progress");
		self thread disable_turret(2);
	}
}
	
	
travelto_next_spot(nextspot, mygoalradius)
{
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	level endon ("chopper_pass_in_progress");
	
	level.skydemon.goalradius = 800;
	if (IsDefined(mygoalradius))
	{
		level.skydemon.goalradius = mygoalradius;
	}
	
	level.skydemon SetVehGoalPos( nextspot.origin, 0 );
	if (level._dont_face_nextspot == 0)
	{
		level.skydemon SetLookAtEnt( nextspot);
	}
	else
	{
		level._dont_face_nextspot = 0;
	}
	level.skydemon waittill ("goal");
}
clear_screen_messages()
{
	level waittill ("shut_down_chopper_support");
	screen_message_delete();
}
air_support_reminder()
{
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	
	level endon ("shut_down_chopper_support");
	wait 3;
		
	while(	level._successful_airstrike_calls ==0) 
	{
		if (get_players()[0] getcurrentweapon() != "rocket_barrage_sp")
		{
			screen_message_create(&"HUE_CITY_ACTION_4_GUNSHIP");
		}
		else if ( get_players()[0] getcurrentweapon() == "rocket_barrage_sp")
		{
			screen_message_create(&"HUE_CITY_ACTION_4_GUNSHIP_FIRE");
		}
		wait 0.1;
	}
	screen_message_delete();
	
	
	level.last_airstrike_counter = 0;
	waittime = 50;
	while(1)
	{
		level.last_airstrike_counter++;
		wait 1;
		if (level.last_airstrike_counter > waittime  )
		{
			waittime += 5;
			level.last_airstrike_counter = 0;
			
			if (get_players()[0] getcurrentweapon() != "rocket_barrage_sp")
			{
				lastcall = level._successful_airstrike_calls;
				counter = 0;
				maps\hue_city_event2::chopper_support_reminder_voiceover();
				screen_message_create(&"HUE_CITY_ACTION_4_GUNSHIP");
				while(counter < 20 && lastcall == level._successful_airstrike_calls)
				{
					if (get_players()[0] getcurrentweapon() != "rocket_barrage_sp")
					{
						screen_message_create(&"HUE_CITY_ACTION_4_GUNSHIP");
					}
					else if ( get_players()[0] getcurrentweapon() == "rocket_barrage_sp")
					{
						screen_message_create(&"HUE_CITY_ACTION_4_GUNSHIP_FIRE");
					}			
					
					counter++;
					wait 0.2;
				}
				screen_message_delete();
			}
		}
	}
}
bombers_bomb_target()
{
	flag_set("final_airstrike_called");
	level waittill ("player_in_boat");
	trigger_use("knock_building_over_bomb", "script_noteworthy");
	
	playsoundatposition( "evt_final_airstrike_planes" , (0,0,0) );
	
	wait 1;
	level notify ("building_fallover_now");
	spots = getstructarray("defend_bombingrun", "targetname");
	
	
	playsoundatposition( "evt_final_airstrike2f" , (0,0,0) );
	
	exploder(800);
	
	ai = GetAIArray("axis");
	
	for (i=0; i < ai.size; i++)
	{
		ai[i] thread launch_me_baby();
	}
	wait 0.5;
}
launch_me_baby()
{
	self.force_gib = true;
	self.a.nodeath = true;
	self StartRagdoll();
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self setclientflag(level.CLIENT_RAGLAUNCH_FLAG);
	wait 0.05;
	self launchragdoll( (RandomIntRange(-100,100), 150, 250) );
	PlayFXOnTag( level._effect[ "squirting_blood" ], self, "tag_eye" );
}
final_street_skydemon_strafe()
{
	flag_wait("street_end_go");
	
	
	objective_delete(12);
	
	flag_set("chopper_doing_custom_action");
	flag_clear("miniguns_on");
	screen_message_delete();
	
	level.skydemon thread disable_turret(0);
	level.skydemon thread disable_turret(1);
	tank = GetEnt("enemytank1", "targetname");
	if (IsDefined(tank) && IsDefined(tank.health) && tank.health > 0) 
	{
		myspot = level.skydemon clear_section5();
		level.skydemon SetVehGoalPos( myspot.origin, 1 );
		level.skydemon.goalradius = 50;
		level.skydemon waittill ("goal");
		
		level.skydemon tank_strafe_run();
		
		spot0 = (-2758, 986, 8367);
		level.skydemon SetSpeed(20);
		level.skydemon.goalradius = 500;
		level.skydemon SetVehGoalPos(spot0);
		level.skydemon waittill ("goal");
		
	}
	
	delete_volumes();
	
	spot0 = getstruct("final_street_skydemon_strafe_intro", "targetname");
	spot1 = getstruct("final_street_skydemon_strafe_1", "targetname");
	spot2 = getstruct("final_street_skydemon_strafe_2", "targetname");
	spot3 = getstruct("final_street_skydemon_strafe_3", "targetname");
	spot4 = getstruct("final_street_skydemon_strafe_4", "targetname");
	spot5 = getstruct("final_street_skydemon_strafe_5", "targetname");	
	
	level.skydemon.goalradius = 1500;
	level.skydemon SetVehGoalPos(spot1.origin);
	level.skydemon waittill ("goal");
	
	
	for (i=1; i < 5; i++)
	{
		wait(.05);
		delete_array("street_spawnmanagers_"+i, "script_noteworthy");
	}
		
	exploder(2004);
	flag_set("miniguns_on");
	level.skydemon thread chopper_mow_everyone();
	level.skydemon thread chopper_explode_everyone();
	
	level.skydemon.goalradius = 100;
	level.skydemon SetVehGoalPos(spot1.origin, 1);
	level.skydemon waittill ("goal");
	
	level notify ("stop_moving_target");
	level notify ("stop_drawing_target");
	
	kill_spawnernum(150);
	kill_spawnernum(3005);
	
	level thread kill_earlier_sections_now();
	wait 0.05;
	level thread kill_everyone_in_10();
	
	while(GetAIArray("axis").size > 0)
	{
		wait 0.1;
	}
	
	flag_clear("miniguns_on");
	lookspot = getstructent("evasive_manuever_lookat_spot", "targetname");
	level.skydemon SetLookAtEnt(lookspot);
	
	trigger_use("aa_gun_trig");
	level.skydemon.goalradius = 300;
	level.skydemon SetVehGoalPos(spot2.origin);
	level.skydemon waittill ("goal");
	
	
	level.skydemon.goalradius = 25;
	level.skydemon SetVehGoalPos(spot3.origin, 1);
	level.skydemon waittill ("goal");
	
	touchtrig = GetEnt("ready_to_see_chopper_evade_volume", "targetname");
	looktrig = GetEnt("ready_to_see_chopper_evade_looktrig", "targetname");
	while(!get_players()[0] IsTouching(touchtrig) && !get_players()[0] IsLookingAt(looktrig))
	{
		wait 0.1;
	}
	
	
	
	level notify ("shut_down_chopper_support");
	
	level.player AllowPickupWeapons(true);
	
	level.skydemon thread disable_turret(0);
	level.skydemon thread disable_turret(1);
	
	level.skydemon ClearLookAtEnt();
	node = GetVehicleNode("aa_gun_evasive_startnode", "script_noteworthy");
	level.skydemon AttachPath(node);
	level.skydemon StartPath();
	level.skydemon ResumeSpeed(20);
	
	flag_set("skydemon_taking_aa_fire");
}
	
	
clear_zone()
{
	self thread rocket_zone();
	level endon ("clear_clearzone");
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	counter = 1;
	
	flag_set("miniguns_on");
	while(counter > 0)
	{
		counter = 0;
		axis = GetAIArray("axis");
		for (i=0; i < axis.size; i++)
		{
			if (axis[i] IsTouching(level.clearzone))
			{
				myguy = axis[i];
				counter++;
				myguy thread wait_and_kill(1);
				self SetGunnerTargetEnt( myguy, (0,0,0), 2 );		
				for (j=0; j < 2; j++)
				{
					
					wait 0.25;
				}
				break;
			}
		}
	}
	
	flag_clear("miniguns_on");
}
clear_area(attackspot)
{
	level endon ("clear_clearzone");
	level endon ("chopper_doing_custom_action");
	level endon ("shut_down_chopper_support");
	
	counter = 1;
	rocket_counter = 0;
	radius = 500;
	flag_set("miniguns_on");
		
	while(counter > 0)
	{
		radius--;
		rocket_counter++;
		counter = 0;
		axis = GetAIArray("axis");
	
		for (i=0; i < axis.size; i++)
		{
			if (rocket_counter > 8 && DistanceSquared(axis[i].origin, attackspot.origin) < (radius*radius) ) 
			{
				
				self SetLookAtEnt(axis[i]);
				self SetTurretTargetEnt(axis[i]);
				wait 0.2;
				for (j=0; j < 3; j++)
				{
					self fireweapon_quake( );
					wait 0.3;
				}
				rocket_counter = 0;
				break;
			}
			
			if (DistanceSquared(axis[i].origin, attackspot.origin) < (radius*radius) )
			{
				myguy = axis[i];
				counter++;
				myguy thread wait_and_kill(0.8);
				self SetGunnerTargetEnt( myguy, (0,0,0), 2 );		
				
				wait 0.25;
				break;
			}
		}
	}
	
	flag_clear("miniguns_on");
}
hackey_look_at_ent(guy)
{
		
	if (IsDefined(level._chopperstrike_section) && level._chopperstrike_section==2)
	{
		lookatspot = getstructent("chopperstrike_spot2_lookatspot", "targetname");
		lookatspot.origin = getstruct("chopperstrike_spot2_lookatspot", "targetname").origin;
		self SetLookAtEnt(lookatspot);
		
		lookatspot thread wait_and_delete(60);
	}
	else
	{
		self SetLookAtEnt(guy);
	}
}							
rocket_zone()
{
	level endon ("clear_clearzone");
	counter = 1;
	
	if ( IsDefined(level.clearzone._num) && level.clearzone._num == 1)
	{
		for (i=1; i < 4; i++)
		{
			spot = getstructent("chopperstrike1_rocket_balcony_spot"+i, "targetname");
			self SetTurretTargetEnt( spot);
			self SetLookAtEnt( spot);		
			wait 0.8;
			
			if (i==1)
			{
				level thread notify_delay ("sign_leyna_start", 0.2);
			}
			if (i==3)
			{
				level thread notify_delay ("balcony_start", 0.4);
			}
			
			
			for (j=0; j < 3; j++)
			{
				self fireweapon_quake();
				wait 0.3;
			}
			wait 1;
		}
			
	}
	
	while(counter > 0)
	{
		counter = 0;
		axis = GetAIArray("axis");
		for (i=0; i < axis.size; i++)
		{
			if (axis[i] IsTouching(level.clearzone))
			{
				myguy = axis[i];
				counter++;
				self SetTurretTargetEnt( myguy);
				
				self hackey_look_at_ent(myguy);
				
						
				myguy thread wait_and_kill(3.5);
				wait 2.5;
				for (j=0; j < 3; j++)
				{
					self fireweapon_quake();
					wait 0.3;
				}
				break;
			}
		}
	}
}
	
	
chopper_mow_everyone()
{
	wait 1.5;
	
	self thread enable_turret(0, "huey_minigun");
	self thread keep_other_gunners_target(0,1, 1);
	ent = spawn( "script_origin" , self.origin);
	self thread audio_ent_fakelink( ent );
	ent thread audio_ent_fakelink_delete();
	
	
	flag_set("miniguns_on");
	self thread minigun_rumble();
	
	ent playsound( "evt_minigun_spin_up_3p" , "sound_done" );
	ent waittill( "sound_done" );
	ent playloopsound( "wpn_minigun_fire_loop_npc" );		
	while(GetAIArray("axis").size > 0)
	{
		
		self firegunnerweapon(1);
		wait 0.2;
	}
	flag_clear("miniguns_on");
	ent playsound( "evt_minigun_spin_down_3p" );
	ent stoploopsound(.048);
	self thread disable_turret(2);
	self thread disable_turret(0);
	self thread disable_turret(1);
	
}
	
chopper_explode_everyone()
{
	wait 1;
	while(1)
	{
		axis = GetAIArray("axis");
		if (axis.size > 0)
		{
			myguy = axis[RandomInt(axis.size)];
			if (IsDefined(myguy.script_noteworthy) && myguy.script_noteworthy !="end_street_guys")
			{
				continue;
			}
			self SetTurretTargetEnt( myguy);
			self SetLookAtEnt( myguy);		
			wait 3;
			for (j=0; j < 2; j++)
			{
				self fireweapon_quake();
				wait 0.3;
			}
		}
		else
		{
			break;
		}
		wait 0.1;
	}
}
kill_everyone_in_10()
{
	wait 8.5;
	axis = GetAIArray("axis");
	for (i=0; i < axis.size; i++)
	{
		axis[i] thread wait_and_kill(RandomFloat(2));
	}
}
new_chopper_findpath(attackspot)
{
	level endon ("shut_down_chopper_support");
	level endon ("chopper_doing_custom_action");
	
	zones = GetEntArray("chopperstrike_zones", "script_noteworthy");
	myzone = undefined;
	num = undefined;
	
	for (i=0; i < zones.size; i++) 
	{
		if (attackspot IsTouching(zones[i]))
		{
			myzone = zones[i];
			for (j=0; j < zones.size; j++) 
			{
				tempnum = j+1;
				if (myzone.targetname == "chopperstrike_zone"+tempnum)
				{
							
					if (flag("chopperstrike_"+tempnum+"_called")   )
					{
						if ( tempnum !=5 || ( tempnum == 5 && flag("street1_tank_dead_now") ) )
						{
							return undefined;
						}
					}
					num = tempnum;
					level._chopperstrike_section = num;
					break;
				}
			}
			break;
		}
	}
	
	myspot = undefined;
	
	if ( !flag("chopperstrike_1_called") )
	{
		myspot = level.skydemon clear_section1();
		flag_set("chopperstrike_1_called");
		myzone = getent("chopperstrike_zone1","targetname");
		level._chopperstrike_section = 1;
		num = 1;
	}
	else if (!IsDefined(myzone)) 
	{
		level._chopperstrike_section = undefined;
		return undefined;
	}
	
	if (myzone.targetname == "chopperstrike_zone4") 
	{
		if (flag("apc_reached_end_node"))
		{
			flag_set("street_end_go");
		}
		return undefined;
	}
	else if (num ==2)
	{
		level.skydemon._fire_before_goal = 1;
		attackspot.origin = getstruct("chopperstrike_spot2_lookatspot", "targetname").origin;
		myspot = clear_section_generic(num, attackspot, myzone);
	}
	else if (num ==5)
	{
		tank = GetEnt("enemytank1", "targetname");
		if (IsDefined(tank) )
		{
			if (DistanceSquared(tank.origin, attackspot.origin) < (400*400) || 
			( flag("tank_in_final_position") && DistanceSquared(tank.origin, attackspot.origin) < (600*600) ) )
			{
				myspot = level.skydemon clear_section5();
			}
			else 
				return undefined;
		}
		else 
				return undefined;
	}
	else
	{
		myspot = clear_section_generic(num, attackspot, myzone);
	}
	
	level.clearzone = myzone;
	level.clearzone._num = num;
	kill_spawnernum(2000+num);
	level thread fire_zone_exploder(num);
	
	retreater_trig = GetEnt("street_retreaters_"+num, "target");
	if (IsDefined(retreater_trig))
	{
		retreater_trig thread trig_on_notify("clear_clearzone");
	}
	
	level thread notify_zone_whendone("chopperstrike_spot"+num+"_fire");
	
	flag_set("chopperstrike_"+num+"_called");
	return myspot;
}
clear_section5()
{
	spots = getstructarray("pre_strafing_run_spots", "targetname");
	myspot = get_array_of_closest( self.origin, spots)[0];
	
	self SetSpeed(60,10,10);
	self SetVehGoalPos( myspot.origin);
	self.goalradius = 700;
	
	flag_wait("tank_ok_to_target");
	self._custom_strafe_function = ::tank_strafe_run;
	return myspot;
}
clear_section1()
{
	spots = getstructarray("chopperstrike_spot1_prefire", "script_noteworthy");
	newspots = get_array_of_closest( self.origin, spots);
	spot = spots[0];
	lookatspot = getstructent("chopperstrike_spot1_lookatspot", "targetname");
	self SetLookAtEnt(lookatspot);
	self SetSpeed(10, 30, 30);
	self thread chopper_shine_first_building();
	
	while(1)
	{
		if (spot.targetname == "chopperstrike_spot1_fire")
		{
			break;
		}
		self SetVehGoalPos( spot.origin );
		self.goalradius = 100;
		self waittill ("goal");
		
		spot = getstruct(spot.target, "targetname");
	}
	
	self._fire_before_goal = 1;
	return spot;
}
	
clear_section_generic(num, attackspot, myzone)
{
	myspots = getstructarray("chopperstrike_spot"+num+"_prefire", "script_noteworthy");
	myspot = undefined;
	shortest = 10000*10000;
	
	for (i=0; i < myspots.size; i++)
	{
		if (DistanceSquared(level.skydemon.origin, attackspot.origin) < (shortest) )
		{
			myspot = myspots[i];
			shortest = DistanceSquared(level.skydemon.origin, attackspot.origin);
		}
	}
	
	level.skydemon SetLookAtEnt( attackspot);
	level.skydemon SetVehGoalPos( myspot.origin );
	level.skydemon.goalradius = 300;
	level.skydemon waittill ("goal");
	level.skydemon SetSpeed(20, 30, 30);
	
	myspot = getstruct("chopperstrike_spot"+num+"_fire", "targetname");
	return myspot;
}		
fire_zone_exploder(num)
{
	level waittill ("skydemon_at_firing_spot");
	exploder(2000+num);
	
	if(num==1)
	{
		explo_sound = getstruct( "chopperstrike_spot1_lookatspot" , "targetname" );
		playsoundatposition( "evt_hue_window_explo" , explo_sound.origin );
	}
}
notify_zone_whendone(mynotify)
{
	level waittill ("clear_clearzone");
	level notify (mynotify);
}
match_player_zone()
{
	if (!IsDefined (level.playerzone))
	{
		level.playerzone = GetEnt("zone1_player", "targetname");
		level.playerzonenum = 1;
	}
	
	zones = GetEntArray("player_zones", "script_noteworthy");
	chopperzones = level.playerzone find_best_zone(level.playerzonenum);
	
	for (i=0; i < zones.size; i++)
	{
		num = i+1;
		zone = GetEnt("zone"+num+"_player", "targetname");
		if (get_players()[0] IsTouching(zone) )
		{
			level.playerzone = zone;
			chopperzones = level.playerzone find_best_zone(num);
			level.playerzonenum = num;
			break;
		}
	}
	
	return chopperzones;
}
	
		
		
find_best_zone(num)
{
	player = get_players()[0];
	mytrigs = undefined;
	
	
	if (IsDefined(self.script_parameters) )
	{
		params = strtok(self.script_parameters, " ");
		for (i=0; i < params.size; i++)
		{
			trig = GetEnt("zone"+params[i]+"_lookat", "targetname");
			mytrigs = GetEntArray("zone"+params[i]+"_chopper", "targetname");
		}
	}
	
	if (!IsDefined(mytrigs))
	{
		mytrigs = GetEntArray("zone"+num+"_chopper", "targetname");
	}
	
	return mytrigs;
}
kill_earlier_sections_now()
{
	kill_spawnernum(5);
	axis = GetAIArray("axis");
	volume = GetEnt("chopperstrike_zone4", "targetname");
	
	for (i=0; i < axis.size; i++)
	{
		if (!axis[i] IsTouching(volume))
		{
			wait(.05);
			axis[i] killme();
		}
	}
}
tank_strafe_run()
{
	node1 = GetVehicleNode("tank_strafe_start1", "targetname");
	node2 = GetVehicleNode("tank_strafe_start2", "targetname");
	tank = GetEnt("enemytank1", "targetname");
	level thread maps\hue_city_event2::clear_guys_near_etank1();
	self AttachPath(node1);
	while (!flag("tank_in_final_position") && IsDefined(tank))
	{
		tank SetSpeed(8);
		wait 1;
	}
	flag_wait("tank_in_final_position");
	trig = GetEnt("tank_destruction_lookat", "targetname");
	trig thread notify_delay("trigger", 5);
	trigger_wait("tank_destruction_lookat");
	flag_set("tank_strafe_commencing");
	
	self SetSpeed(40);
	endnode = GetVehicleNode("tank_strafe_end1", "targetname");
	self thread tank_strafe_kill();
	endnode thread tank_strafe_end();
	flag_wait("end_strafe");
}
tank_strafe_end()
{
	tank = GetEnt("enemytank1", "targetname");
	tank waittill ("death");
	flag_set("street1_tank_dead_now");
	
	wait 4;
	flag_set("end_strafe");
	
	objective_add(12, "current" );
	Objective_Position( 12, (-2225, -322, 7728)  );	
	objective_Set3D ( 12, 1, "default", &"HUE_CITY_TARGET" );
	
	level thread remove_building_target();
	
	
	start_dist = 161.418;
	half_dist = 261.877;
	half_height = 309.262;
	base_height = 7715.52;
	fog_r = 0.305882;
	fog_g = 0.290196;
	fog_b = 0.231373;
	fog_scale = 1;
	sun_col_r = 0.356863;
	sun_col_g = 0.286275;
	sun_col_b = 0.203922;
	sun_dir_x = -0.644323;
	sun_dir_y = 0.744678;
	sun_dir_z = 0.174078;
	sun_start_ang = 0;
	sun_stop_ang = 60.2511;
	time = 10;
	max_fog_opacity = 1;
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
	sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang,
	sun_stop_ang, time, max_fog_opacity);
	wait(time);
	
	SetCullDist(3500);
}
remove_building_target()
{
	flag_wait("street_end_go");
	
	wait(1.0);
	
	objective_delete(12);
}
tank_strafe_kill(node)
{
	self StartPath();
	
	
	tank = GetEnt("enemytank1", "targetname");
	self SetLookAtEnt(tank);
	self SetTurretTargetEnt(tank );
	
	while(DistanceSquared(self.origin, tank.origin) > (4200 * 4200) )
	{
		wait 0.1;
	}
	self thread tank_strafe_miniguns(tank);
	self ResumeSpeed(10);
		
	while(DistanceSquared(self.origin, tank.origin) > (1550 * 1550) && !flag("street1_tank_dead_now") )
	{
		wait 0.05;
	}
	
	for (i=0; i < 3; i++)
	{
		self fireweapon_quake();
		wait 0.3;
	}
	
	flag_wait("enemytank1_modelswap");
	tank vehicle_delete();
	self ClearLookAtEnt();
	
	level notify ("stop_strafe_miniguns");
	flag_clear("miniguns_on");
	self thread disable_turret(0);
	self thread disable_turret(1);
}
tank_strafe_miniguns(tank)
{
	level endon ("stop_strafe_miniguns");
	
	ent = spawn( "script_origin" , self.origin);
	self thread audio_ent_fakelink( ent );
	ent thread audio_ent_fakelink_delete();
	
	level thread notify_delay ("tank01_death_start", 1.7);
	
	left_target = getstructent("left_tankstrafe_target", "targetname");
	right_target = getstructent("right_tankstrafe_target", "targetname");
	
	self setgunnertargetent(right_target, (0,0,0), 0 );
	self setgunnertargetent(left_target, (0,0,0), 1 );
	left_target moveto(left_target.origin + (2000,100,0), 5);
	right_target moveto(right_target.origin + (2000,-100,0), 5);
	left_target thread kill_axis_near_spot();
	right_target thread kill_axis_near_spot();
	
	wait 0.3;
	flag_set("miniguns_on");
	
	ent playsound( "evt_minigun_spin_up_3p" , "sound_done" );
	ent waittill( "sound_done" );
	ent thread audio_ent_loopsound( "stop_strafe_miniguns" );
	
	while( !flag("street1_tank_dead_now") )
	{
		self firegunnerweapon(0);
		self firegunnerweapon(1);
		wait 0.1;
		PlayFX(level._effect["strafe_hit"], left_target.origin);
		PlayFX(level._effect["strafe_hit"], right_target.origin);
		
	}
}
kill_axis_near_spot()
{
	level endon ("stop_strafe_miniguns");
	while(1)
	{
		axis = GetAIArray("axis");
		for (i=0; i < axis.size; i++)
		{
			if (DistanceSquared(axis[i].origin, self.origin) < (150*150) )
			{
				axis[i] DoDamage(10000,level.skydemon.origin);
			}
		}
		wait 0.2;
	}
}
fireweapon_quake()
{
	self fire_rocket();
	wait 0.1;
	dist = 3000;
	
	Earthquake(0.4, 0.8, level.airtargetspot.origin, dist);
	if (DistanceSquared(get_players()[0].origin, level.airtargetspot.origin) < (2000*2000) )
	{
		get_players()[0] PlayRumbleOnEntity("artillery_rumble");
	}
}
minigun_rumble()
{
	level endon ("shut_down_chopper_support");
	self endon ("death");
	counter = 0;
	
	while(1)
	{
		flag_wait("miniguns_on");
		if (counter == 4)
		{
			Earthquake(0.1, 1, level.skydemon.origin, 3000);
			counter = 0;
		}
		counter++;
		get_players()[0] PlayRumbleOnEntity("pistol_fire");
		wait 0.5;
	}
}
fire_rocket()
{
	if (!IsDefined(self._last_fire_tag))
	{
		self._last_fire_tag = "tag_rocket_right";
	}
	
	if (self._last_fire_tag == "tag_rocket_right" )
	{
		self FireWeapon("tag_rocket_left");
		self._last_fire_tag = "tag_rocket_left";
	}
	else if (self._last_fire_tag == "tag_rocket_left" )
	{
		self FireWeapon();
		self._last_fire_tag = "tag_rocket_right";
	}
}
	
chopper_failsafe()
{
	level endon ("shut_down_chopper_support");
	if ( is_hard_mode() )
	{
		return;
	}
	
	wait_time = 300;
	counter = 0;
	
	while( !flag("chopperstrike_1_called") )
	{
		counter++;
		if (counter > wait_time)
		{
			zone = GetEnt("chopperstrike_zone1", "targetname");
			if ( !IsDefined(level.airtargetspot) )
			{
				level.airtargetspot = spawn_a_model("tag_origin", self.origin);
			}
			level.airtargetspot.origin = zone.origin;
			spot = Spawn("script_origin", zone.origin);
			level.airtargetspot LinkTo(spot);
			flag_set("failsafe_chopperstrike_called");
			wait 1;
			level.airtargetspot Unlink();
			spot Delete();
			flag_clear("failsafe_chopperstrike_called");
		}
		wait 1;
	}
	
	flag_waitopen("chopper_pass_in_progress");
	counter = 0;
	
	while( !flag("chopperstrike_2_called") && !flag("tank_ok_to_target") )
	{
		counter++;
		if (counter > wait_time)
		{
			zone = GetEnt("chopperstrike_zone2", "targetname");
			if ( !IsDefined(level.airtargetspot) )
			{
				level.airtargetspot = spawn_a_model("tag_origin", self.origin);
			}
			level.airtargetspot.origin = zone.origin;
			spot = Spawn("script_origin", zone.origin);
			level.airtargetspot LinkTo(spot);
			flag_set("failsafe_chopperstrike_called");
			wait 1;
			level.airtargetspot Unlink();
			spot Delete();
			flag_clear("failsafe_chopperstrike_called");
		}
		wait 1;
	}
	
	flag_waitopen("chopper_pass_in_progress");
	counter = 0;
	flag_wait("tank_ok_to_target");
	
	while( !flag("chopperstrike_5_called") )
	{
		counter++;
		if (counter > wait_time)
		{
			tank = GetEnt("enemytank1", "targetname");
			if ( !IsDefined(level.airtargetspot) )
			{
				level.airtargetspot = spawn_a_model("tag_origin", self.origin);
			}
			level.airtargetspot.origin = tank.origin;
			spot = Spawn("script_origin", tank.origin);
			level.airtargetspot LinkTo(spot);
			flag_set("failsafe_chopperstrike_called");
			wait 1;
			level.airtargetspot Unlink();
			spot Delete();
			flag_clear("failsafe_chopperstrike_called");
		}
		wait 1;
	}
}
delete_volumes()
{
	zones = array_combine(GetEntArray("player_zones", "script_noteworthy"), GetEntArray("chopper_zones", "script_noteworthy") );
	zones = array_combine(zones, GetEntArray("chopperstrike_zones", "script_noteworthy"));
	zones = array_combine(zones, GetEntArray("custom_building_volumes", "script_noteworthy"));
	
	myvolume = GetEnt("chopperstrike_zone4", "targetname");
	for (i=0; i < zones.size; i++)
	{
		if (zones[i] != myvolume)
		{
			wait(.05);
			zones[i] Delete();
		}
	}
}  
