/*
//-- Level: Underwater Base
//-- Level Designer: Gavin Goslin
//-- Scripter: Alfeche/Vento
*/

#include maps\_utility;
#include common_scripts\utility; 
#include maps\_utility_code;
#include maps\underwaterbase_util;
#include maps\_vehicle_aianim;
#include maps\_anim;
#include maps\_music;

// The level-skip shortcuts go here, the main level flow goes straight to run()
run_skipto()
{		
	//player_to_struct( "snipe_start" );
	
	flag_set("heavy_resistance_encountered");

	// place player in helicopter	
	maps\underwaterbase_huey::start((0,90,0));

	// Put Hudson in the co-pilots seat
	level.heroes["hudson"] LinkTo(level.huey, "tag_passenger");
	level.huey thread anim_loop_aligned(level.heroes["hudson"], "pilot_idle", "tag_passenger");

	// init friendly helicopters
	init_jumpto_helis();
	
	// do objectives
	level thread objectives(0);
	
	// move the heli	
	heli_snipe_origin = GetStruct("snipe_heli_start", "targetname");
	AssertEx( IsDefined(heli_snipe_origin), "THE HELI SKIPTO ORIGIN IS NOT DEFINED!");
	AssertEx( IsDefined(level.huey), "THE huey IS NOT DEFINED AND THE LEVEL JUST BROKE!");	
	level.huey.origin = heli_snipe_origin.origin;	

	get_players()[0] setclientdvar( "cg_objectiveIndicatorFarFadeDist", "99999" );
	get_players()[0] setClientDvar( "cg_fov", level.huey_fov );

	// play all of the effects that have occurred up to and including the start of the level
//	play_all_deck_effects_snipe_skipto();
 		
	// remove sam missiles
	missiles = GetEntArray("sam_missile_stern", "script_noteworthy");
	array_delete(missiles);
	
	missiles = GetEntArray("sam_missile_mid_ship", "script_noteworthy");
	array_delete(missiles);
	
	missiles = GetEntArray("sam_missile_bow", "script_noteworthy");
	array_delete(missiles);

	aa_guns = GetEntArray("aa_gun_heavy_resistance_bow", "script_noteworthy");
	array_delete(aa_guns);

	aa_guns = GetEntArray("aa_gun_heavy_resistance_mid", "script_noteworthy");
	array_delete(aa_guns);

	aa_guns = GetEntArray("aa_gun_heavy_resistance_stern", "script_noteworthy");
	array_delete(aa_guns);

	player = get_player();
	player FreezeControls(false);

	level.huey thread maps\underwaterbase_huey::init_huey_weapons();

	// start the water movement
	//level thread update_water_plane("ship_exterior", 40.0, 25.0, (-0.5,0,0.5));

	// set aggressive cull radius
	player = get_players()[0];
	player SetClientDvar("cg_aggressiveCullRadius", 500);

	run();
}

run()
{
	autosave_by_name("hind_fight");

	level thread hind_intro();
	level thread support_huey_think();
	level thread landing_pad_watcher();
	level thread dialogue();

	flag_wait("player_lands_huey");

	cleanup();

	maps\underwaterbase_rendezvous::run();
}

// gets run through at start of level
init_flags()
{
	flag_init( "enemy_hind_start" );	
	flag_init( "enemy_hind_dead" );
	flag_init( "player_lands_huey" );
	
	maps\underwaterbase_rendezvous::init_flags();
	level thread music_switch();
}

cleanup()
{
	ub_print( "cleanup snipe\n" );
	
	player = get_player();
	
	if(IsDefined(level.default_fov))
	{
		player setClientDvar( "cg_fov", level.default_fov );
	}
	
	// turn on friendly fire 
//	level.friendlyFireDisabled = 0;	
//	SetDvar( "friendlyfire_enabled", "1" );
}

objectives( starting_obj_num )
{
	level.curr_obj_num = starting_obj_num;

	flag_wait("enemy_hind_start");

	// clear front of ship	
	Objective_Add( level.curr_obj_num, "current", &"UNDERWATERBASE_OBJ_DESTROY_HIND" );
	Objective_Set3D( level.curr_obj_num, true, "default", &"UNDERWATERBASE_OBJ_TARGET" );
	Objective_Position( level.curr_obj_num, level.hind );

	flag_wait( "enemy_hind_dead" );
	Objective_State( level.curr_obj_num, "done" );
	Objective_Delete( level.curr_obj_num );

	// Land the Huey
 	level.curr_obj_num++;
	Objective_Add( level.curr_obj_num, "current", &"UNDERWATERBASE_OBJ_LAND_HELICOPTER" );
	Objective_Position( level.curr_obj_num, struct_origin("land_chopper_objective") );
	Objective_Set3D( level.curr_obj_num, true );
	flag_wait( "player_lands_huey" );

	Objective_State( level.curr_obj_num, "done" );
	Objective_Delete( level.curr_obj_num);

	level.curr_obj_num++;
	maps\underwaterbase_rendezvous::objectives( level.curr_obj_num );
}

support_huey_think()
{
	flag_wait("enemy_hind_start");

	//wait(2.5);

	level.support_huey = GetEnt("friendly_huey_A", "targetname");

	level.support_huey notify("stop_engage");
	level.support_huey notify("stop_rpg_support");

	level.support_huey thread heli_engage(level.hind, 2000, 0, 250, 500, 0.5, 1, "stop_engage", 2);

	level.support_huey.lockheliheight = true;

	flag_wait("enemy_hind_dead");

	level.support_huey.lockheliheight = false;

	airsupport_pos = GetStruct("airsupport_pos_2", "targetname");
	
	look_ent_1 = spawn("script_origin", airsupport_pos.origin);
	look_ent_2 = spawn("script_origin", airsupport_pos.origin + AnglesToForward(airsupport_pos.angles) * 1500);

	level.support_huey SetSpeed(60, 30, 30);

	level.support_huey SetVehGoalPos(airsupport_pos.origin, 1);
	level.support_huey SetLookAtEnt(look_ent_1);

	level.support_huey waittill("goal");

	level.support_huey SetLookAtEnt(look_ent_2);

	flag_wait("player_lands_huey");
}

hind_intro()
{
	trigger_use("trig_air2air_hind");

	wait(0.05);

	// hind height 450
	level.hind = GetEnt("air2air_hind", "targetname");
	level.hind SetCanDamage(false);
	level.hind SetSpeed(100, 50, 50);
	level.hind.health = 70000;
	level.hind ent_flag_init("im_out_this_bitch");
	level.hind.hind_target = get_players()[0];
	level.vehicle_death_thread[level.hind.vehicletype] = ::heli_crash_think;

	// Calculate a point be-Hind the player and teleport him there!  waka waka
	player = get_players()[0];
	player_angles	= player GetPlayerAngles();
	rear_angles		= ( 0, -1*player_angles[1], 0 );	// only care about the yaw
	rear_origin		= player.origin + (vector_scale( AnglesToForward(rear_angles), 50) ) + (0,0,850);
	level.hind Hide();
	level.hind.origin = rear_origin;
	level.hind.angles = player_angles;
	wait( 0.05 );

	level.hind Show();

	// These are the Hind's goal spots
	intro_pos_1 = GetEnt("air2air_hind_intro_1", "targetname");
	intro_pos_2 = GetEnt("air2air_hind_intro_2", "targetname");

	// If the hind is too far away, we will need to make him attack sooner.
	dist = Distance2D( level.hind.origin, intro_pos_1.origin );
	if ( dist > 5000 || dist < 1000 )
	{
		forward_angles	= ( 0, player_angles[1], 0 );	// only care about the yaw
		forward_origin	= player.origin + (vector_scale( AnglesToForward(forward_angles), 4300) );
		// Don't let it get below the ship
		if ( forward_origin[2] < 1660 )
		{
			forward_origin = ( forward_origin[0], forward_origin[1], 1660 );
		}
		intro_pos_1.origin = forward_origin;
		intro_pos_2.origin = forward_origin;
	}

	level.hind SetVehGoalPos(intro_pos_1.origin);
	level.hind SetLookAtEnt(level.huey);

	level.hind waittill("goal");

	level.hind SetVehGoalPos(intro_pos_2.origin, 1);
	level.hind SetLookAtEnt(level.huey);

	level.hind waittill("goal");

	flag_set("enemy_hind_start");

	//TUEY set music to ENEMY_CHOPPER
	setmusicstate ("ENEMY_CHOPPER");

	// HAXXZOR...give the player full heatlh at the start
	level.huey.current_damage = 0;

	// start the fight
	level.hind thread hind_start_battle();
}

/*----------------------------------------------------------------------

		HIND VS HIND

----------------------------------------------------------------------*/

hind_start_battle()
{
//	self.hind_target = get_players()[0];
//	level.vehicle_death_thread[self.vehicletype] = ::heli_crash_think;
	self SetLookAtEnt( self.hind_target );
	self SetNearGoalNotifyDist( 120 );
	self.lockheliheight = true;
	self SetCanDamage(true);
	
	level.huey thread missile_lock_sounds( "enemy_hind_dead" ); //-- should end on that thread
	
	//self ent_flag_init("im_out_this_bitch");

	if(IsDefined(self.script_noteworthy))
	{
		self enemy_hind_fire_rocket_barrage();
//		flag_set("music_twohinds");
		
		goal_pos = getstruct("last_hind_fallback", "targetname").origin;
//		flag_set("vo_hind_fallback");
		self SetVehGoalPos( goal_pos, true );
	}
	else
	{
		self SetVehGoalPos( self.origin, true );
	}
	
	self waittill_any("goal", "near_goal");
	
	self thread enemy_hind_think();
}

enemy_hind_think( no_weapon )
{
	self endon("death");
	
	//-- entity flags
	self ent_flag_init("too_close_to_target");
	
	//-- Behavior Threads
	self thread enemy_hind_dmg_fx();
	self thread enemy_hind_move_position();
	self thread heli_avoidance();
	
//	if(self.vehicletype != "heli_hip")
//	{
//		self thread enemy_hind_set_flag_on_death("vo_one_hind_down");
//	}
	
	if( !IsDefined(no_weapon))
	{
		self thread enemy_hind_weapon_think();
	}
}

enemy_hind_set_flag_on_death( flag_str )
{
	self waittill("death");
	flag_set(flag_str);
}

enemy_hind_move_position()
{
	self endon("death");
	
	self notify("forced_move_now");
	self endon("forced_move_now");
	
	dist_to_keep = 2400;
	rotation_degree = 36;
	
	//-- circle strafing
	self SetLookAtEnt( self.hind_target );
	times_moved = 0;
	stop_at_goal = false;
	
	//-- don't get too close to player
	self thread enemy_hind_keep_dist_from_target( dist_to_keep );
	
	curr_direction = 1;
	
	while(1)
	{		
		//-- Find the new goal point
		curr_angle = VectorToAngles( self.origin - self.hind_target.origin );
		new_angle = (0, curr_angle[1] + (rotation_degree * curr_direction), 0);
		dir_to_goal = AnglesToForward(new_angle);
		goal_point = self.hind_target.origin + (dir_to_goal * dist_to_keep);
		
		//-- Don't fly through walls)
		trace = BulletTrace(self.origin, goal_point, false, self);
		if(trace["position"] != goal_point)
		{
			//IPrintLnBold("switched directions");
			curr_direction = curr_direction * -1;
			wait(0.05);
			continue;
		}
		
		times_moved++;
		self SetVehGoalPos( goal_point, stop_at_goal );
		self SetNearGoalNotifyDist( 1200 );
		//self waittill_any("goal", "near_goal");
		
		if(self.smoke_fx_on)
		{
			self waittill_any_or_timeout(2, "goal", "near_goal");
			rotation_degree = RandomIntRange(24, 72);
			if(RandomInt(100) < 30)
			{
				curr_direction = curr_direction * -1;
			}
		}
		else
		{
			self waittill_any_or_timeout(5, "goal", "near_goal");
		}
		
		//-- rocket barrage, unless the player is too close
		if(stop_at_goal == true && !self ent_flag("too_close_to_target"))
		{
			wait(2);
			self notify("fire_rockets");
			wait(5);
			stop_at_goal = false;
			times_moved = 0;
			curr_direction = curr_direction * -1;
		}
		
		//-- stop at the goal point the next time you move
		if(times_moved == 2)
		{
			stop_at_goal = true;
		}
	}
}

enemy_hind_keep_dist_from_target( dist_to_target )
{
	self endon("death");
	self endon("forced_move_now");
	
	//-- alleviates constant spawn problem
	wait(1);
	
	while(1)
	{
		curr_dist = DistanceSquared( self.origin, self.hind_target.origin );
		if( curr_dist <= dist_to_target * dist_to_target )
		{
			self ent_flag_set("too_close_to_target");			
			self thread enemy_hind_move_position();
			//IPrintLnBold("forced move");
		}
		else
		{
			self ent_flag_clear("too_close_to_target");
		}
		
		wait(0.25);
	}
}

enemy_hind_weapon_think()
{
	self endon("death");
	self thread enemy_hind_rocket_attack();
	
	while(1)
	{
		self enemy_hind_minigun_attack(3);
		wait(3.0);
	}
}

enemy_hind_rocket_attack() //self = enemy hind
{
	self endon( "death" );

	while( IsAlive( self ) )
	{
		self thread enemy_hind_fire_single_rocket();
		self waittill("fire_rockets");
		self enemy_hind_fire_rocket_barrage();
	}
}

enemy_hind_fire_rocket_barrage() //-- self == Hind
{
	self endon("death");
	println("JMORELLI DEBUG");
	
	if( !isDefined(self) )
		return;

	player = get_players()[0];
	switch(self.vehicletype)
	{
		case "heli_hind_doublesize_uwb":
		case "heli_hind_doublesize":
		case "heli_hind":
			for(i = 0; i < 4; i++)
			{
				for(j = 2; j < 4; j++)
				{
					//"tag_rocket1"
					//"tag_rocket2"
					rocket = MagicBullet( "hind_rockets_sp_uwb", self GetTagOrigin("tag_rocket" + j), self.hind_target.origin, self, self.hind_target );
					level.huey.missiles_incoming[level.huey.missiles_incoming.size] = rocket;
					rocket.origin_pt = self GetTagOrigin("tag_rocket" + j);
					
					out_this_bitch = false;
					if (self ent_flag("im_out_this_bitch"))
					{
						out_this_bitch = true;
					}

					rocket thread rocket_rumble_when_close(player, out_this_bitch);
					wait(0.15);
					if( !isDefined(self) )
						return;
				}	
			}
		break;

		case "heli_hip_sidegun":
		case "heli_hip_sidegun_uwb":
			for(i = 0; i < 4; i++)
			{
				//"tag_rocket1-4"
				rocket = MagicBullet( "hind_rockets_sp_uwb", self GetTagOrigin("tag_rocket" + (i + 1)), self.hind_target.origin, self, self.hind_target );
				rocket thread rocket_rumble_when_close(player);
				wait(0.15);
				if( !isDefined(self) )
					return;
			}

		break;
	}
}

enemy_hind_fire_single_rocket()
{
	self endon("fire_rockets");
	self endon("death");
	
	rocket_tag = "tag_origin";
	wait_min = 5;
	wait_max = 8.5;
	
	rocket_weapon = "hind_rockets_sp";
	switch(self.vehicletype)
	{
		case "heli_hind_doublesize":
		case "heli_hind_doublesize_uwb":
		case "heli_hind":
			rocket_tag = "tag_rocket1";
			wait_min = 5;
			wait_max = 8.5;
			rocket_weapon = "hind_rockets_sp_uwb";
		break;
		
		case "heli_hip":
			rocket_tag = "tag_rocket_left";
			wait_min = 2;
			wait_max = 3.5;
			rocket_weapon = "hind_rockets_sp";
		break;
	}
		
	while(true)
	{
		rand_wait = RandomFloatRange(wait_min, wait_max);
		wait(rand_wait);
		forward = AnglesToForward(self.angles);
		start_point = self GetTagOrigin(rocket_tag) + (60 * forward);
		player = get_players()[0];
		rocket = MagicBullet( rocket_weapon, start_point, self.hind_target.origin, self, self.hind_target );
		rocket thread rocket_rumble_when_close(player);
	}
}

missile_lock_sounds( flag_name ) //-- self == trigger volume
{
	sound_on = false;
	player = get_players()[0];
	
	while(!flag( flag_name ))
	{
			while(self missiles_headed_at_me(self.missiles_incoming) )
			{
				if(!sound_on)
				{
					//iprintlnbold("missiles incoming");
					self.ent = spawn ("script_origin", player.origin );
					self.ent LinkTo( player );
					self.ent playloopsound("wpn_rocket_warning_loop");
					sound_on = true;
				}
			
				wait(0.05);
				self.missiles_incoming = array_removeUndefined(self.missiles_incoming);		
			}
			
			if(sound_on)
			{
				//iprintlnbold("stop looped_sound");
				self.ent StopLoopSound();
				self.ent delete();
				sound_on = false;
				
				self notify("stop_warning_indicator");
			}
			
			wait(0.05);
	}
	
	if(IsDefined(self.ent))
	{
		self.ent StopLoopSound();
		self.ent Delete();
	}
}

missiles_headed_at_me( missiles ) // are missiles headed at me?
{
	missile_warning_range = 20000;
	
	if( missiles.size <= 0 )
	{
		//-- no missiles exist, so none are headed at you
		return false;
	}
	
	for( i=0; i < missiles.size; i++)
	{
		if(IsDefined(missiles[i]))
		{
			me_to_origin = VectorNormalize( self.origin - missiles[i].origin_pt );
			me_to_missile = self.origin - missiles[i].origin;
			dot = VectorDot( me_to_origin, me_to_missile );
			if(  dot > 0 && dot < missile_warning_range)
			{
				if ( dot < 10000 )
				{
					missiles[i]	play_rocket_flyby();
				}			
				
				return true;
			}
		}
	}
	
	return false;
}

play_rocket_flyby()
{
	self endon ("death");
	
	if(IsDefined ( self.flybysound ) )
	{
		return;	
	}
	
	self.flybysound = true;
	self playsound("evt_rocket_flyby_close");		
}

enemy_hind_minigun_attack( burst_time )
{
	self endon("death");
	self endon("stop_firing");
	
	//Kevin adding audio ent
	ent = spawn( "script_origin" , (0,0,0));
	self thread audio_ent_fakelink( ent );
	ent thread audio_ent_fakelink_delete( burst_time );
	
	self SetTurretTargetEnt( self.hind_target );
	
	time_fired = 0;
	
	while( IsAlive(self) && time_fired < burst_time )
	{
		ent playloopsound( "wpn_huey_toda_minigun_fire_npc_loop2" );
		self FireWeapon();
		wait(0.05);
		time_fired += 0.05;
	}
	ent stoploopsound(.048);
}

///////////////////////////////////Kevin mini gun audio functions
audio_ent_fakelink( ent )
{
	self endon("stop_firing" );
	self endon ("death");
	ent endon( "stop_audio_ent" );
	
	while(1)
	{
		ent moveto( self.origin, .05 );
		wait(.1);
	}
}

audio_ent_fakelink_delete( burst_time )
{
	level waittill_any_or_timeout( burst_time + 1, "stop_firing", "death" );
	self notify( "stop_audio_ent" );
	self delete();
}
///////////////////////////////////
/*-----------------------------------------------------------------------/
		Enemy Hind Damage FX and things
*/

enemy_hind_dmg_fx() //-- self == heli_hind
{
	self endon("death");
	
	self.smoke_fx_on = false;
	
	while(1)
	{

		self waittill("damage");
		
		if(!self.smoke_fx_on && self.health < (self.healthmax / 2) )
		{
			PlayFXOnTag( level._effect["huey_fire"], self, "tag_origin" );
			self.smoke_fx_on = true;
		}
	}
}
music_switch()
{
	
	flag_wait ("enemy_hind_dead");
	//TUEY set music to CRASHING
	setmusicstate ("CRASHING");	
	
}
#using_animtree("vehicles");
heli_crash_think()
{
	flag_set("enemy_hind_dead");
	
	 

	
	
	level notify("enemy_hind_dead");

	time = undefined;
	if(self.vehicletype == "heli_hind_doublesize" || self.vehicletype == "heli_hind_doublesize_uwb")
	{
		time = 3;
	}
	else if (self.vehicletype == "heli_huey_side_minigun" || self.vehicletype == "heli_huey_side_minigun_uwb")
	{
		time = -1;
	}
	else if (self.vehicletype == "heli_hip_sidegun" || self.vehicletype == "heli_hip_sidegun_uwb")
	{
		time = -1;
	}
	
	new_heli = Spawn("script_model", self.origin);
	new_heli SetModel(self.model);
	new_heli.animname = "helicopter";
	new_heli.angles = self.angles;
	new_heli UseAnimTree(#animtree);
	new_heli.vehicletype = self.vehicletype;
	new_heli PlaySound( "evt_enemy_crash" );

	if (self.vehicletype == "heli_huey_side_minigun" || self.vehicletype == "heli_huey_side_minigun_uwb")
	{
		new_heli Attach("t5_veh_helo_huey_att_interior");
	}
	
	self notify("nodeath_thread");
	self Hide();
	self SetCanDamage(false);
	
	println("JMORELLI DEBUG2");

	new_heli thread heli_crash_basic_crash(time);
	wait(0.05);
	self Delete(); 

}

heli_crash_basic_crash( time )
{
	self HidePart("tail_rotor_jnt");
	
	//play some crashing sound CDC
	self thread heli_crash_spin_audio ();
	
	if(self.vehicletype == "heli_hip" || self.vehicletype == "heli_hip_sidegun" || self.vehicletype == "heli_hip_sidegun_uwb")
	{
		PlayFXOnTag( level._effect["huey_fire"], self, "origin_animate_jnt");
		PlayFXOnTag( level._effect["prop_main"], self, "main_rotor_jnt");
		PlayFXOnTag( level._effect["prop_tail"], self, "tail_rotor_jnt");

		if (IsDefined(level.hips_killed))
		{
			if (level.hips_killed == 1)
			{
				self thread anim_single( self, "heli_crash_missile_02" );
				time = 2.65;
			}
			else if (level.hips_killed == 2)
			{
				self thread anim_single( self, "heli_crash_missile_03" );	
			}
		}
	}
	else if(self.vehicletype == "heli_hind" || self.vehicletype == "heli_hind_doublesize" || self.vehicletype == "heli_hind_doublesize_uwb")
	{
		PlayFXOnTag( level._effect["huey_fire"], self, "origin_animate_jnt");
		PlayFXOnTag( level._effect["prop_main"], self, "main_rotor_jnt");
		PlayFXOnTag( level._effect["prop_tail"], self, "tail_rotor_jnt");

		self thread anim_single( self, "heli_crash_missile_03" );
	}
	else if(self.vehicletype == "heli_huey_side_minigun" || self.vehicletype == "heli_huey_side_minigun_uwb")
	{
		PlayFXOnTag( level._effect["huey_fire"], self, "origin_animate_jnt");
		PlayFXOnTag( level._effect["huey_rotor_main"], self, "main_rotor_jnt");
		PlayFXOnTag( level._effect["huey_rotor_tail"], self, "tail_rotor_jnt");

		self thread anim_single( self, "heli_crash_missile_03" );
	}
	else
	{
		AssertEX(false, "non defined type of helicopter going through the crash script");
	}
	
	if(IsDefined(time))
	{
		// if less than 0 time wait till either we hit the ground or the animation ends
		if (time < 0)
		{
			self thread heli_crash_watch_for_anim_end();
			self thread heli_crash_watch_for_ground_then_explode();
		}
		else
		{
			wait(time);
			self thread heli_crash_watch_for_ground_then_explode( true );
		}
	}
	else
	{
		self thread heli_crash_watch_for_ground_then_explode();
	}
}

heli_crash_spin_audio()
{
	self playloopsound ( "veh_heli_crash_loop" );
	self waittill_any_or_timeout( 15, "death" );
	if( IsDefined(self) )
	    self StopLoopSound( 1 );
}

heli_crash_pitch_random_until_death()
{
	self endon("death");
	self endon("hit_surface");
	
	first = true;
	//play some crashing sound CDC
	
	while(1)
	{
		new_pitch = RandomIntRange(-20, 20);
		new_roll = RandomIntRange(-10, 10);
		if(first)
		{
			self RotateVelocity( (new_pitch, 400,new_roll), 4, 2, 1 );
		}
		else
		{
			self RotateVelocity( (new_pitch, 400, new_roll), 4, 0, 0 );
		}
		wait(3);
		self RotateVelocity( (new_pitch * -1, 400 , new_roll), 4, 0, 0 );
		wait(3);
	}
}

heli_crash_watch_for_ground_then_explode( right_away )
{
	self endon("death");
	
	if(!IsDefined(right_away))
	{
		right_away = false;	
	}
	
	
	if(!right_away)
	{
		original_position = self.origin;
		
		heli_trace = 500;
		if(self.vehicletype == "heli_hip_sidegun" || self.vehicletype == "heli_hip_sidegun_uwb")
		{
			heli_trace = 200;
		}
		else 
		{
			heli_trace = 800;
		}
		
		wait(0.1);
		
		while(1)
		{
			current_position = self GetTagOrigin("origin_animate_jnt");
		
			dir_movement = VectorNormalize(original_position - current_position);
			
			//TODO: Change this look in the direction the helicopter is going
			trace_origin = self GetTagOrigin("origin_animate_jnt");
			trace_direction = AnglesToForward(dir_movement) * 5000;
			trace = BulletTrace( trace_origin, trace_origin - (0,0,5000), false, self );
			
			trace_dist_sq = Distance( trace_origin, trace["position"] );
			//IPrintLnBold(trace_dist_sq);
			
			if( trace_dist_sq < 200 )
			{
				break;
			}
			
			wait(0.1);
		}
	}
	
	origin = self GetTagOrigin("origin_animate_jnt");

	death_fx = "";
	if( self.vehicletype == "heli_hip_sidegun" || self.vehicletype == "heli_hip_sidegun_uwb" )
	{
		death_fx = level._effect["hip_dead"];
		PlayFX(death_fx, origin, (0,0,1), (1,0,0));
	}
	else if ( self.vehicletype == "heli_hind_doublesize" || self.vehicletype == "heli_hind_doublesize_uwb")
	{
		death_fx = level._effect["hind_dead"];
		PlayFX(death_fx, origin);
	}
	else
	{
		death_fx = level._effect["explosion_heli"];
		forward = (0,0,1);
		up = (1,0,0);
		PlayFX(death_fx, origin, forward, up);
	}
		
	//Play the explo CDC
	playsoundatposition( "exp_veh_large" , origin );	
	playsoundatposition( "exp_barrel" , origin );
		
	wait(0.1);
	self Delete();
	level notify("crashed");
}

heli_crash_watch_for_anim_end()
{
	self waittillmatch("single anim", "end");

	origin = self GetTagOrigin("origin_animate_jnt");

	death_fx = "";
	if( self.vehicletype == "heli_hip_sidegun" || self.vehicletype == "heli_hip_sidegun_uwb" )
	{
		death_fx = level._effect["hip_dead"];
		PlayFX(death_fx, origin);
	}
	else if ( self.vehicletype == "heli_hind_doublesize" || self.vehicletype == "heli_hind_doublesize_uwb")
	{
		death_fx = level._effect["hind_dead"];
		PlayFX(death_fx, origin);
	}
	else
	{
		death_fx = level._effect["explosion_heli"];
		forward = AnglesToForward( self.angles );
		up = AnglesToUp( self.angles );
		PlayFX(death_fx, origin, forward, up);
	}
		
	//Play the explo CDC
	playsoundatposition( "exp_veh_large" , origin );	
	playsoundatposition( "exp_barrel" , origin );
		
	wait(0.1);
	self Delete();
	level notify("crashed");
}

landing_pad_watcher()
{
	flag_wait("enemy_hind_dead");

	trigger_on("huey_landing_pad_trigger","targetname");
	trigger_wait("huey_landing_pad_trigger");
	
	

	PlayFXOnTag(level._effect["huey_bandaid"], level.huey, "tag_spark_r");

	level.huey thread maps\underwaterbase_huey::player_helicopter_crashing_anims();

	wait(0.2);

	player = get_player();
	player thread maps\_flashgrenades::applyFlash(2.75, 0.5);
	player PlaySound( "dst_flash", player.origin );

	wait(0.1);

	level.support_huey notify("done_avoiding");
	enemies = GetAIArray("axis");
	array_delete(enemies);

	align_node = GetStruct("anim_align_heli_blocker", "targetname");
	align_node.angles = (0,0,0);

	level.huey Unlink();
	level.huey ReturnPlayerControl();
	
	player_body = level.huey.player_body;

	body_anim = player_body get_anim("heli_crash");
	body_start_pos = GetStartOrigin(align_node.origin, align_node.angles, body_anim);
	body_start_angles = GetStartAngles(align_node.origin, align_node.angles, body_anim);

	SetSavedDvar("cg_cameraVehicleExitTweenTime", 0.0);

	level.huey UseBy(player);
	level.huey MakeVehicleUnusable();
	level.huey Hide();

	if(IsDefined(level.default_fov))
	{
		player setClientDvar( "cg_fov", level.default_fov );
	}

	player_body UnLink();
	player_body StopAnimScripted();
	player_body ClearAnim(%root, 0);

	player PlayerLinkToAbsolute(player_body, "tag_player");

	level.heroes["hudson"] UnLink();
	level.heroes["hudson"] StopAnimScripted();

	Earthquake(0.4, 1.0, player.origin, 512);


	//wait(0.05);

	level.huey notify("end_player_heli");
	level.huey notify("stop_flightstick");
	level notify("end_player_heli");

	new_heli = Spawn("script_model", level.huey.origin);
	new_heli Attach("t5_veh_helo_huey_att_interior", "tag_body");
	new_heli SetModel(level.huey.model);
	new_heli.animname = "helicopter";
	new_heli.angles = level.huey.angles;
	new_heli UseAnimTree(#animtree);

	PlayFXOnTag(level._effect["huey_fire"], new_heli, "origin_animate_jnt");
	PlayFXOnTag( level._effect["panel_dmg_md"], new_heli, "tag_spark_l" );
	PlayFXOnTag( level._effect["panel_dmg_md"], new_heli, "tag_spark_r" );

	level.huey.necklace_mod UnLink();
	level.huey.necklace_mod LinkTo(new_heli, "tag_body");

	level.huey.damage_mod UnLink();
	level.huey.damage_mod LinkTo(new_heli, "tag_body");

	heli_anim = new_heli get_anim("heli_crash");
	heli_start_pos = GetStartOrigin(align_node.origin, align_node.angles, heli_anim);
	heli_start_angles = GetStartAngles(align_node.origin, align_node.angles, heli_anim);

	new_heli.origin = heli_start_pos;
	new_heli.angles = heli_start_angles;

	level thread crash_shake();

	actors = array(level.heroes["hudson"], new_heli, player_body);
	align_node thread anim_single_aligned(actors, "heli_crash");
	//align_node anim_first_frame(actors, "heli_crash");

	player_body waittillmatch("single anim", "door_open");
	//TUEY set music to CRASHING
	level thread maps\_audio::switch_music_wait("JUMP", 0.5);
	
	wait(0.25);

	// put a failsafe here for the alarm sound
	level.huey.playing_alarm_loop = false;
	level.huey.alarm_snd_ent StopLoopSound();
	level.huey Delete();

	level notify("shake_stop");

	player_body waittillmatch("single anim", "hit_ground");

	maps\createart\underwaterbase_art::set_rendezvous_fog_and_vision();
	Earthquake(0.5, 1.0, player.origin, 512);
	player PlayRumbleOnEntity("grenade_rumble");

	player_body waittillmatch("single anim", "chopper_explode");

	// do the parts animation
	level thread crash_parts_animation();

	// TODO...replace with a notetrack
	playsoundatposition( "exp_veh_large", new_heli.origin );
	playsoundatposition( "exp_barrel", new_heli.origin );
	PlayFx( level._effect["explosion_heli"], new_heli GetTagOrigin("origin_animate_jnt"), (0,0,1), (1,0,0) );

	level clientNotify ("ssdflt");

	// exploders
	exploder(103);
	stop_exploder(101);
	stop_exploder(107);

	// Destroyed huey
	dead_huey = spawn("script_model", new_heli GetTagOrigin("origin_animate_jnt"));
	dead_huey SetModel("t5_veh_helo_huey_damaged_low");
	dead_huey.angles = new_heli GetTagAngles("origin_animate_jnt");
	new_heli Delete();

	player_body waittillmatch("single anim", "chopper_move_in");

	support_heli = GetEnt("friendly_huey_A", "targetname");
	support_heli thread maps\underwaterbase_rendezvous::support_huey_drop();

	player_body waittillmatch("single anim", "end");

	player UnLink();
	player_body delete();
	player DisableInvulnerability();
	player EnableWeapons();
	
 	flag_set( "player_lands_huey" );	
}

crash_shake()
{
	level endon("shake_stop");
	player = get_players()[0];

	while (1)
	{
		Earthquake(0.35, 0.5, player.origin, 512);
		player PlayRumbleOnEntity("damage_heavy");
		wait(0.05);
	}
}

init_jumpto_helis()
{
	trigger_use("trig_start_friendly_hueys");
	wait(0.05);

	// delete destoryed hueys
	huey_c = GetEnt("friendly_huey_C", "targetname");
	huey_c delete();

	huey_d = GetEnt("friendly_huey_D", "targetname");
	huey_d delete();

	// init weaver heli
	heli_b = GetEnt("friendly_huey_B", "targetname");
	heli_b delete();

	// init support heli
	support_heli = GetEnt("friendly_huey_A", "targetname");
	support_heli init_friendly_heli( "support_heli_air2air_jumpto" );
	support_heli thread heli_avoidance();
}

dialogue()
{
	player = get_players()[0];
	player.animname = "mason";

	flag_wait("enemy_hind_start");

	level.heroes["hudson"] anim_single(level.heroes["hudson"], "a_hind");

	wait(3.0);

	nag_lines = array("take_down_hind", "fire_on_hind", "keep_on_em");
	level thread nag_dialog( level.heroes["hudson"], nag_lines, 6, "hind_dead" );

	flag_wait("enemy_hind_dead");

	level notify("hind_dead");

	wait(2.0);

	level.heroes["hudson"] anim_single(level.heroes["hudson"], "helipad");
	player anim_single(player, "roger_that_2");
}

crash_parts_animation()
{
	rotor = spawn_anim_model("heli_rotor", (0,0,0), (0,0,0), true);
	rotor SetForceNoCull();

	rotor_hub = spawn_anim_model("heli_hub", (0,0,0), (0,0,0), true);
	rotor_hub SetForceNoCull();

	door = spawn_anim_model("heli_door", (0,0,0), (0,0,0), true);
	door SetForceNoCull();

	align_node = GetStruct("anim_align_heli_blocker", "targetname");
	align_node.angles = (0,0,0);

	parts = array(rotor, rotor_hub, door);
	align_node anim_single(parts, "crash");

//	align_node thread anim_single(rotor, "crash");
//	align_node thread anim_single(rotor_hub, "crash");
//	align_node thread anim_single(door, "crash");
	array_delete(parts);
}



