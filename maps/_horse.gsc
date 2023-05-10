#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#using_animtree ("vehicles");
main() 
{
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );
	self build_horse_anims();
	
	
	self.soundsnout = spawn ("script_origin", (0,0,0)); 
	self.soundsnout LinkTo( self, "J_Nose", (0,0,0), (0,0,0) );
	
	precache_rumble();
	precache_fx();
	self.speed_idle = 0.1;
	self.speed_walk = 13;
	self.speed_run = 20;
	self.speed_jump = 5;
	self.sprint_scalar = 75;
	self.rumble_run_wait_time = 0.5;
	self.rumble_sprint_wait_time = 0.4;
	self thread watch_mounting();
	self thread horse_breathing();
	self thread maps\_vehicle_turret_ai::setup_driver_turret_aim_assist(undefined, 100, (0, 0, 40));
}
build_horse_anims() 
{
	self.anims = [];
	self.anims["jump"] = %v_horse_jump;
	
	self.anims["pullback"] = %v_horse_pullback;
	
	self.anims["idle1"] = %v_horse_idle1;
	self.anims["idle2"] = %v_horse_idle2;
	
	self.anims["walk_forward"] = %v_horse_walk_forward;
	self.anims["walk_left"] = %v_horse_walk_left;
	self.anims["walk_right"] = %v_horse_walk_right;
	self.anims["run_forward"] = %v_horse_run_forward;
	self.anims["run_left"] = %v_horse_run_left;
	self.anims["run_right"] = %v_horse_run_right;
	self.anims["sprint_forward"] = %v_horse_sprint_forward;
	self.anims["sprint_left"] = %v_horse_sprint_left;
	self.anims["sprint_right"] = %v_horse_sprint_right;
}
precache_rumble()
{
	PreCacheRumble("horse_gallop");
}
precache_fx()
{
	
	level._effect["player_wind"] = LoadFX("bio/animals/fx_horse_riding_wind");
}
set_wind_effect(fx_name)
{
	assertex(IsDefined(fx_name), "Please specify an fx name.");
	level._effect["player_wind"] = LoadFX(fx_name);
}
set_visionset_idle(visionset_name, visionset_fade) 
{
	assertex(IsDefined(visionset_name), "Please specify a vision set name.");
	assertex(IsDefined(visionset_fade), "Please specify a vision set fade time.");
	self.visionset_idle = visionset_name;
	self.visionset_idle_fade = visionset_fade;
}
set_visionset_run(visionset_name, visionset_fade) 
{
	assertex(IsDefined(visionset_name), "Please specify a vision set name.");
	assertex(IsDefined(visionset_fade), "Please specify a vision set fade time.");
	self.visionset_run = visionset_name;
	self.visionset_run_fade = visionset_fade;
}
set_vehicle_anims(positions)
{
	return positions;
}
#using_animtree ("generic_human");
setanims()
{
	positions = [];
	for(i = 0; i < 1; i++)
	{
		positions[i] = spawnstruct();
	}
	positions[0].sittag = "tag_driver";			
	positions[0].idle = %ai_huey_pilot1_idle_loop1;
	positions[0].getout = %crew_jeep1_driver_climbout;
	positions[0].getin = %crew_jeep1_driver_climbin;
	return positions;
}
unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ "default" ] = unload_groups[ "all" ];
	return unload_groups;
}
absolute_value( fowd )
{
	if( fowd < 0 )
		return (fowd*-1);
	else
		return fowd;
}
scale_wait(x1,x2,y1,y2,z)
{
	if ( z < x1)
		z = x1;
	if ( z > x2)
		z = x2;
	dx = x2 - x1;
	n = ( z - x1) / dx;
	dy = y2 - y1;
	w = (n*dy + y1);
	return w;
}
get_wait()
{
	min_speed = 1;
	max_speed = 50;
	min_wait = .088;
	max_wait = .2;
	speed = self GetSpeedMPH();
	abs_speed = absolute_value(int(speed));
	wait_time = scale_wait(min_speed, max_speed, max_wait, min_wait, abs_speed);
	
	return wait_time;
}
gallop_driving() 
{
	self endon("death");
	self endon("no_driver");
	while(1)
	{
		if(absolute_value(self GetSpeed()) < 0.1)
		{
			wait 0.01;
		}
		else if(absolute_value(self GetSpeed()) >= 0.1)
		{
			if((self GetSpeedMPH()) < 22)
				
			{
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_t_plr_01" );
				}
				wait( ( self get_wait() * 1.3) );
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_t_plr_02" );
				}
				wait( ( self get_wait() * 1.3) );
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_t_plr_03" );
				}
				wait( ( self get_wait() * 1.3) );			
				
			}		
			else if((self GetSpeedMPH() >= 22))
				
			{
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_g_plr_01" );
				}
				wait( ( self get_wait() ) );
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_g_plr_02" );
				}
				wait( ( self get_wait() ) );
				if (!self.isjumping)
				{
					self playsound( "fly_gear_run_plr" );
				}
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_g_plr_03" );
				}
				wait( ( self get_wait() ) * 2 );
			}
		}
	}
}
gallop_rumble_driving() 
{
	self endon("death");
	self endon("no_driver");
	while(true)
	{
		wait_time = self.rumble_run_wait_time;
		
		
		if(self ButtonPressed("BUTTON_LSTICK"))
		{
			wait_time = self.rumble_sprint_wait_time;
		}
		if((self GetSpeedMPH() >= self.speed_run))		
		{
			self.driver PlayRumbleOnEntity("horse_gallop");
			
			wait(wait_time);
		}
		else
		{
			wait(0.05);
		}
	}
}
wind_driving() 
{
	self endon("death");
	self endon("no_driver");
	
	player_offset = (0, 0, 56);
	while(true)
	{
		while((self GetSpeedMPH()) >= self.speed_run)
		{
			PlayFX(level._effect["player_wind"], self.driver.origin + player_offset);
			wait(0.3);
		}
		wait(0.05);
	}
}
horse_breathing() 
{
	self endon("death");
	
	while(true)
	{
		
		speed = self GetSpeedMPH();
		if(speed <= self.speed_idle)
		{
			speed = 1;
		}
		wait_time = 1.5 / speed;
		wait(wait_time);
		self veh_toggle_exhaust_fx(1);
		
		if(wait_time >= 1.5)
		{
			self.soundsnout playsound ("chr_horse_breath_i_mono");	
		}	
		else if(wait_time < 1.5)
		{
			self.soundsnout playsound ("chr_horse_breath_t_mono");	
		}						
		
		wait(1);
		self veh_toggle_exhaust_fx(0);
	}
}
#using_animtree("vehicles");
horse_animating() 
{
	self endon("death");
	self endon("no_driver");
	idle_counter = 0;
	
	
	rand_idle2_int = RandomIntRange(60, 360);
	playing_idle2 = false;
	playing_idle2_counter = 0;
	idle2_length = GetAnimLength(self.anims["idle2"]) / 0.05;
	wait_min = int(10 / 0.05); 
	wait_max = int(20 / 0.05); 
	
	self.isjumping = false;
	while(true)
	{
		
		
		
		norm_move = self.driver GetNormalizedMovement();
		speedMPH = self GetSpeedMPH();
		
		weight_pullback = 0;
		weight_idle1 = 0;
		weight_idle2 = 0; 
		weight_walk = 0;
		weight_walk_left = 0;
		weight_walk_right = 0;
		weight_run = 0;
		weight_run_left = 0;
		weight_run_right = 0;
		weight_sprint = 0;
		weight_sprint_left = 0;
		weight_sprint_right = 0;
		
		if(	speedMPH > self.speed_idle &&
			norm_move[0] == 0 &&
			norm_move[1] == 0)
		{
			weight_pullback = 1.0;
			if(IsDefined(self.visionset_idle))
			{
				VisionSetNaked(self.visionset_idle, self.visionset_idle_fade);
			}
		}
		
		if(speedMPH <= self.speed_idle)
		{
			weight_idle1 = 1.0;
		}
		
		if(speedMPH < self.speed_idle * -1)
		{
			weight_walk = 1.0;
			
			if(norm_move[1] < 0) 
			{
				weight_walk_left = norm_move[1] * -1;
				weight_walk = 1.0 - weight_walk_left;
			}
			if(norm_move[1] > 0) 
			{
				weight_walk_right = norm_move[1];
				weight_walk = 1.0 - weight_walk_right;
			}
		}
		
		if(	speedMPH > self.speed_idle &&
			speedMPH <= self.speed_walk)
		{
			weight_walk = 1.0;
			
			if(norm_move[1] < 0) 
			{
				weight_walk_left = norm_move[1] * -1;
				weight_walk = 1.0 - weight_walk_left;
			}
			if(norm_move[1] > 0) 
			{
				weight_walk_right = norm_move[1];
				weight_walk = 1.0 - weight_walk_right;
			}
		}
		
		
		if(	speedMPH > self.speed_walk &&
			speedMPH <= self.speed_walk + 2)
		{
			weight_walk = 0.75;
			weight_run = 0.25;
		}
		if(	speedMPH > self.speed_walk + 2 &&
			speedMPH <= self.speed_walk + 4)
		{
			weight_walk = 0.5;
			weight_run = 0.5;
		}
		if(	speedMPH > self.speed_walk + 4 &&
			speedMPH <= self.speed_run)
		{
			weight_walk = 0.25;
			weight_run = 0.75;
		}
		
		if(speedMPH > self.speed_run)
		{
			weight_run = 1.0;
			
			if(norm_move[1] < 0) 
			{
				weight_run_left = norm_move[1] * -1;
				weight_run = 1.0 - weight_run_left;
			}
			if(norm_move[1] > 0) 
			{
				weight_run_right = norm_move[1];
				weight_run = 1.0 - weight_run_right;
			}
			if(IsDefined(self.visionset_run))
			{
				VisionSetNaked(self.visionset_run, self.visionset_run_fade);
			}
			
			
			if(self ButtonPressed("BUTTON_LSTICK"))
			{
				weight_run = 0;
				weight_run_left = 0;
				weight_run_right = 0;
				weight_sprint = 1.0;
				
				if(norm_move[1] < 0) 
				{
					weight_sprint_left = norm_move[1] * -1;
					weight_sprint = 1.0 - weight_sprint_left;
				}
				if(norm_move[1] > 0) 
				{
					weight_sprint_right = norm_move[1];
					weight_sprint = 1.0 - weight_sprint_right;
				}
			}
		}
		
		if(playing_idle2)
		{
			
			weight_idle1 = 0;
			weight_idle2 = 1.0;
			playing_idle2_counter++;
			if(playing_idle2_counter > idle2_length)
			{
				playing_idle2 = false;
				playing_idle2_counter = 0;
			}
		}
		else
		{
			if(weight_idle1 == 1.0)
			{
				idle_counter++;
				if(idle_counter == rand_idle2_int)
				{
					weight_idle1 = 0;
					weight_idle2 = 1.0;
					idle_counter = 0;
					playing_idle2 = true;	
					self.soundsnout playsound ("chr_horse_snort_plr");			
					rand_idle2_int = RandomIntRange(wait_min, wait_max);
				}
			}
			else
			{
				idle_counter = 0;
			}
		}
		
		self SetAnim(self.anims["pullback"], weight_pullback);
		self SetAnim(self.anims["idle1"], weight_idle1);
		self SetAnim(self.anims["idle2"], weight_idle2);
		self SetAnim(self.anims["walk_forward"], weight_walk);
		self SetAnim(self.anims["walk_left"], weight_walk_left);
		self SetAnim(self.anims["walk_right"], weight_walk_right);
		self SetAnim(self.anims["run_forward"], weight_run);
		self SetAnim(self.anims["run_left"], weight_run_left);
		self SetAnim(self.anims["run_right"], weight_run_right);
		self SetAnim(self.anims["sprint_forward"], weight_sprint);
		self SetAnim(self.anims["sprint_left"], weight_sprint_left);
		self SetAnim(self.anims["sprint_right"], weight_sprint_right);
		wait(0.05);
	}
}
watch_for_jump() 
{
	self endon("death");
	self endon("no_driver");
	while(true)
	{
		if(self.driver JumpButtonPressed())
		{
			if((self GetSpeedMPH()) > self.speed_jump)
			{
				self SetAnim(self.anims["jump"]);
				
				self.isjumping = true;
				self.soundsnout playsound( "chr_horse_exert_plr" );
				forward_ang = AnglesToForward(self.angles);
				self LaunchVehicle((0, 0, 250), (1,0,0), 1);
				wait(1.0);
				
				self.isjumping = false;
				self playsound( "fly_horse_hoofhit_g_plr_02" );
				self playsound( "fly_horse_hoofhit_g_plr_03" );
			}
		}
		wait(0.05);
	}
}
watch_for_sprint() 
{
	self endon("death");
	self endon("no_driver");
	while(true)
	{
		
		if(self.driver ButtonPressed("BUTTON_LSTICK"))
		{
			forward_ang = AnglesToForward(self.angles);
			self LaunchVehicle(forward_ang * self.sprint_scalar);
			wait(1.0);
		}
		wait(0.05);
	}
}
watch_mounting() 
{
	self endon("death");
	while(true)
	{
		self.driver = self GetSeatOccupant(0);
		if(!IsDefined(self.driver))
		{
			
			self notify("no_driver");
			
			while(!IsDefined(self.driver))
			{
				self.driver = self GetSeatOccupant(0);
				wait(0.05);
			}
			self thread horse_animating();
			self thread gallop_driving();
			self thread gallop_rumble_driving();
			self thread watch_for_jump();
			self thread watch_for_sprint();
			self thread wind_driving();
		}
		wait(0.05);
	}
}