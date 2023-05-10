
#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_hud_util;
#using_animtree ("generic_human");
init_squad_control()
{
	load_sc_assets();
	
	level init_squad_global_vars();
	level init_squad_attack_targets();
	level init_squad_attack_functions();
	
	createthreatbiasgroup("squad_member");
	createthreatbiasgroup("squad_target");
}
load_sc_assets()
{
	
	precachemodel("tag_origin");
	PreCacheItem("test_hand_signal_go");
	
	
	level._effect["target_arrow_confirm"]			= loadfx ("misc/fx_ui_flagbase_gold");
	level._effect["target_arrow_too_far"]			= loadfx ("misc/fx_ui_flagbase_silver");
	level._effect["target_node"]							= loadfx ("misc/fx_ui_flagbase_blue");
	level._effect["target_arrow_attack"]			= loadfx ("misc/fx_ui_flagbase_red");
	level._effect["need_revive"]							= loadfx ("temp_effects/fx_mod2_heal_light");
	
	
	level.scr_anim["generic"]["sc_door_kick"] = %ch_scripted_tests_b0_coveralign;
	addNotetrack_customFunction("generic", "doorkick", ::kick_door_open, "sc_door_kick");		
}
init_squad_global_vars()
{
	hide_spot = getent("sc_marker_hide_pos", "targetname");
	
	level.sc_max_dist 							= (900 * 900);				
	level.sc_fx_marker_hide_pos 		= hide_spot.origin;		
	level.sc_search_size_increment 	= 16;									
}
init_squad_attack_targets()
{
	level.squad_attack_targs = getentarray("sc_target", "targetname");	
}
init_squad_attack_functions()
{
	level.squad_attack_funcs = [];
	level.squad_attack_funcs["sc_fire_rocket"] 	= ::squad_attack_fire_rocket;
	level.squad_attack_funcs["sc_vehicle"] 			= ::squad_attack_vehicle;
	level.squad_attack_funcs["sc_door_breach"] 	= ::squad_attack_door_breach;
	level.squad_attack_funcs["sc_push"] 				= ::squad_attack_push;
}
register_squad_attack_function( string_index, func_pointer)
{
	if( isDefined( level.squad_attack_funcs[string_index] ) )
	{
		assertmsg("SQUAD CONTROL: called register_squad_attack_function with a string_index that is already in use"); 
	}
	
	level.squad_attack_funcs[string_index] = func_pointer;
}
create_all_marker_fx()
{
	self.sc_fx_markers 				= [];		
	self.ainode_fx						= [];		
	self.squad_confirm 				= create_marker(level._effect["target_arrow_confirm"]);
	self.squad_confirm_toofar = create_marker(level._effect["target_arrow_too_far"]);
	self.squad_attack_target 	= create_marker(level._effect["target_arrow_attack"]);
	self.squad_marker 				= create_marker(undefined);
}
player_squad_control(num)
{
	self endon("death");
	self endon("disconnect");
	
	self._squad 	= [];		
	self.animname = "player";
	
	self create_all_marker_fx();
	
	guys = get_ai_group_ai("player_" + num + "_controllable_guys");
	array_thread(guys, ::add_ai_to_squad, self);
	
	self thread sc_revive_hud_init();
	self thread watch_lbumper_usage();		
	
}
remove_ai_from_squad(guy)
{
	self._squad = array_remove( self._squad, guy );
	guy enable_ai_color();
}
remove_all_ai_from_squad()
{
	removedSquad = [];
	
	removedSquad = self._squad;
	self._squad = "undefined";
	self._squad = [];
	
	for(i = 0; i < removedSquad.size; i++)
	{
		removedSquad[i] enable_ai_color();
	}
	
	return removedSquad;
}
add_ai_to_squad(player)
{	
	self disable_ai_color();
	self.goalradius = 32;
	self thread ai_health_regen();
	player sc_create_new_ainode_marker();	
	player._squad = array_add( player._squad, self);
}
show_squad_buddies()
{
	self endon("death");
	self endon("disconnect");
	self endon("stop squad control");
	
	while(true)
	{
		for(i = 0; i < self._squad.size; i++)
		{			
			if( isdefined(self._squad[i]) && isalive(self._squad[i]) )
			{
				if( isdefined(self._squad[i].isImmune) && self._squad[i].isImmune == true)
				{
					print3d( self._squad[i].origin + (0, 0, 80), "IMMUNE", (1, 1, 1), 1, 0.5 );
				}
				else if(self._squad[i].health > 10000)
				{
					print3d( self._squad[i].origin + (0, 0, 80), "REVIVE", (1, 1, 1), 1, 2 );
				}
				else
				{
					print3d( self._squad[i].origin + (0, 0, 80), self._squad[i].health, (1, 1, 1), 1, 0.5 );
				}
			}
		}
		wait(.05);
	}
}
watch_lbumper_usage()
{
	self endon("disconnect");
	self endon("death");
	
	eye_trace 				= undefined;
	dist_in_range 		= false;
	chose_attack_targ = false;
	moveto_nodes 			= [];
	
	while( true )
	{
		wait(.1);
		
		if( self buttonpressed("BUTTON_LSHLDR") )
		{
			while(self buttonpressed("BUTTON_LSHLDR") )
			{
			 	moveto_nodes = [];
				chose_attack_targ = false;
				
				
				direction = self getPlayerAngles();
				direction_vec = anglesToForward( direction );
				eye = self getEye();
				eye_trace = bullettrace( eye, eye + vector_scale( direction_vec , 4000 ), 0, undefined );				
								
				
				self.squad_marker.origin = eye_trace["position"];
				self.squad_marker rotateTo( vectortoangles( eye_trace["normal"] ), 0.15 );
				
				
				dist_in_range = is_dist_in_range( self.origin, self.squad_marker.origin );
				
				
				chose_attack_targ = self check_attack_targets();
				
				
				if(chose_attack_targ)
				{
					self hide_all_fx_markers();
					
					self.squad_attack_target thread set_as_targeting_effect(self.squad_marker);
				}
				
				
				if( (dist_in_range && !chose_attack_targ) ||
					( (chose_attack_targ && self.attack_targ.script_noteworthy == "sc_door_breach") && dist_in_range) ||
					( (chose_attack_targ && self.attack_targ.script_noteworthy == "sc_push") && dist_in_range) )
				{
					if( !chose_attack_targ )
					{
						self hide_all_fx_markers();
						self.squad_confirm thread set_as_targeting_effect( self.squad_marker );
					}
				
					
					moveto_nodes = self find_closest_cover_nodes(eye_trace);
				}
				
				else if(!chose_attack_targ)
				{
					self hide_all_fx_markers();
					self.squad_confirm_toofar thread set_as_targeting_effect(self.squad_marker);
				}
				wait(.1);
			}
			
			
			if(dist_in_range && !chose_attack_targ)
			{
				self thread detect_squad_target( self.squad_marker.origin, moveto_nodes );
				self thread play_squad_vo(moveto_nodes[0]);
			}
			else if(!chose_attack_targ)
			{
				
			}
			else if(chose_attack_targ)
			{				
				if( self.attack_targ.script_noteworthy == "sc_push" && dist_in_range || 
							self.attack_targ.script_noteworthy == "sc_door_breach" && dist_in_range)
				{
					
					for(i = 0; i < self._squad.size; i++)
					{
						self._squad[i] thread squad_moveto_new_pos(moveto_nodes[i]);
					}						
				}
				
				wait(.1); 
				chose_attack_targ = false;
				self thread squad_control_attack_targ();					
			}
		}
	}
}
check_attack_targets()
{
	chose_attack_target = false;
	
	for(i = 0; i < level.squad_attack_targs.size; i++)
	{
		if( self.squad_marker isTouching (level.squad_attack_targs[i]) )
		{
			if( isdefined( level.squad_attack_targs[i].target ))
			{
				self.attack_targ = getent( level.squad_attack_targs[i].target, "targetname");
				if( !isdefined(self.attack_targ) )		
				{
					self.attack_targ = getnode( level.squad_attack_targs[i].target, "targetname");
				}
				self.attack_trig = level.squad_attack_targs[i];
				
				chose_attack_target = true;
			}
		}
	}
	return chose_attack_target;
}
find_closest_cover_nodes(eye_trace)
{
	search_size = level.sc_search_size_increment;	
	moveto_nodes = [];
	while( moveto_nodes.size < self._squad.size )
	{
		moveto_nodes = getcovernodearray( eye_trace["position"], search_size );
		
		if( moveto_nodes.size > 0 )
		{
			good_nodes = [];								
			base_node_fwd = AnglestoForward(moveto_nodes[0].angles);
			
			for(i = 0; i < moveto_nodes.size; i++)
			{
				if( isdefined(moveto_nodes[i].script_noteworthy) && moveto_nodes[i].script_noteworthy == "sc_ignore")		
				{
					continue;
				}
				else
				{
					new_node_fwd = AnglestoForward(moveto_nodes[i].angles);
					dot = vectordot( base_node_fwd, new_node_fwd );
					
					if( dot >= 0 )
					{
						good_nodes = array_add(good_nodes, moveto_nodes[i]);
					}
				}
			}
			
			moveto_nodes = good_nodes;
		}
		search_size += level.sc_search_size_increment;
	}
	
	for(i = 0; i < self.ainode_fx.size; i++)
	{
		self.ainode_fx[i].origin = moveto_nodes[i].origin;
	}		
	
	return moveto_nodes;
}
play_squad_vo(first_node)
{
	if( isdefined(first_node.script_noteworthy) )
	{
		switch( first_node.script_noteworthy )
		{
			case "sc_sandbag":
				self playsound("vox_spl_sqd_0_order_issue_sandbags"); 
				
				break;
			case "sc_vehicle":
				self playsound("vox_spl_sqd_0_order_issue_truck"); 
				
				break;
			case "sc_house":
				self playsound("vox_spl_sqd_0_order_issue_house"); 
				
				break;
			case "sc_crate":
				self playsound("vox_spl_sqd_0_order_issue_crates"); 
				
				break;
			default:
				self playsound("vox_spl_sqd_0_order_issue"); 
				
				break;
		}
	}
	else
	{
		self playsound("vox_spl_sqd_0_order_issue"); 	
		
	}
	wait(2);
	self._squad[0] playsound("vox_spl_sqd_0_order_receive");	
}
detect_squad_target(fire_point, moveto_nodes )
{		
	self endon ("death");
	self endon ("disconnect");
	
	self.already_pressed  = true;
	
	for(i = 0; i < self._squad.size; i++)
	{
		self._squad[i] thread squad_moveto_new_pos(moveto_nodes[i]);
	}
	
	
	self thread target_aquired_fx();
	
	self.already_pressed = undefined;	
	
	
	wait(1);
	for(i = 0; i < self.ainode_fx.size; i++)
	{
		self.ainode_fx[i].origin = level.sc_fx_marker_hide_pos;
	}
	
	
	wait(2);
	if( isdefined( self.squad_confirm ) )
	{
		self.squad_confirm.origin = level.sc_fx_marker_hide_pos; 
	}
}
target_aquired_fx(pos)
{
	if(!isDefined(self.squad_confirm))
	{
		self.squad_confirm = spawn("script_model",self.squad_marker.origin);
		self.squad_confirm setmodel("tag_origin");
		self.squad_confirm.angles = self.squad_marker.angles;
		
		playfxontag(level._effect["target_arrow_confirm"],self.squad_confirm,"tag_origin");
	}
}
squad_moveto_new_pos(pos)
{
	self notify("new_goal_node"); 
	self endon("new_goal_node");
	
	self.ignoreall = true;
	self.ignoreme = true;	
	self.ignoresuppression = 1;
	self.grenadeawareness = 0;
	self.goalradius = 32;
	self.sc_goal_node = pos;		
	self setgoalnode(pos);	
	
	wait(.1);
	
	self thread goal_fx_delete();
	
	self waittill_either("goal","bad_path");	
	
	self.goalradius = 32;
	self.fixednode = false;	
	self.ignoreme = false;
	self.ignoresuppression = 1;
	self.grenadeawareness = 1;
	self.ignoreall = false;	
}
goal_fx_delete()
{
	wait(.1);
	self waittill("new_goal_node");
	
	if( isdefined(self.tnode) )
	{
		self.tnode delete();
	}
}
squad_control_attack_targ()
{
	self thread attack_hide_markers();
	
	if( isdefined(self.attack_targ) && isDefined( level.squad_attack_funcs[self.attack_targ.script_noteworthy] ) )	
	{
		self [[ level.squad_attack_funcs[self.attack_targ.script_noteworthy] ]]();
	}
	
	else
	{
		assertmsg("SQUAD CONTROL: unknown or no script_noteworthy set on entity at " + self.attack_targ.origin + ".");
	}
	
	
	if( is_in_array(level.squad_attack_targs, self.attack_trig) )		
	{
		level.squad_attack_targs = array_remove(level.squad_attack_targs, self.attack_trig);
		self.attack_trig delete();
	}
}
squad_attack_fire_rocket()
{
	
	rpg_guy = undefined;
	for(i = 0; i < self._squad.size; i++)
	{
		if( isalive(self._squad[i]) && self._squad[i].primaryweapon == "rpg" )
		{
			rpg_guy = self._squad[i];
			break;
		}
		else if( isalive(self._squad[i]) && self._squad[i].secondaryweapon == "rpg" )
		{
			rpg_guy = self._squad[i];
			break;
		}
	}
	if( isDefined(rpg_guy) )
	{
		level notify("sc_rpg_acquired");
		
		if( rpg_guy.weapon != "rpg" )
		{
			rpg_guy.a.allow_weapon_switch = true;
			rpg_guy switch_weapon_asap();
			rpg_guy waittill("weapon_switched");
			rpg_guy.a.allow_weapon_switch = false;
		}
		
		rpg_guy.shoot_notify = "rpg_fired";
		rpg_guy.perfectAim = true;
		rpg_guy.ignoreme = true;	
		rpg_guy.ignoresuppression = 1;
		rpg_guy.grenadeawareness = 0;	
		
		rpg_guy setentitytarget(self.attack_targ);
		
		rpg_guy waittill("rpg_fired");
		
		rpg_guy clearentitytarget();
		rpg_guy.perfectAim = false;
		rpg_guy.ignoreme = false;	
		rpg_guy.ignoresuppression = 1;
		rpg_guy.grenadeawareness = 1;
	}
	else
	{
		
	}										
}
squad_attack_vehicle()
{
	level notify("sc_vehicle_acquired");
	
	vehicle = getent(self.attack_targ.target, "targetname");
	if(isalive(vehicle))
	{
		
		for(i = 0; i < self._squad.size; i++)
		{
			self._squad[i] clearentitytarget();
			self._squad[i].perfectAim = true;
			self._squad[i] setstablemissile(true);
			self._squad[i].ignoresuppression = 1;
			self._squad[i].grenadeawareness = 0;							
			self._squad[i] setentitytarget( self.attack_targ );
		}
		
		vehicle thread temp_destroy_after_time();
		
		vehicle waittill("death");
		
		for(i = 0; i < self._squad.size; i++)
		{
			self._squad[i] clearentitytarget();
			self._squad[i].perfectAim = false;
			self._squad[i] setstablemissile(false);
			self._squad[i].ignoresuppression = 1;
			self._squad[i].grenadeawareness = 1;						
		}				
	}
}
temp_destroy_after_time()
{
	self endon("death");
	wait(5);
	
	radiusdamage( self.origin, 128, self.health + 100, self.health +100);
}
squad_attack_door_breach()
{
	level notify("sc_breach_acquired");
	node = self.attack_targ;
	guy = self get_ai_with_goal_node( node );
	guy.doortrig = getent( self.attack_trig.script_noteworthy, "targetname");
	node anim_generic_reach(guy, "sc_door_kick");
	wait RandomInt(2);
	
	node anim_generic_aligned(guy, "sc_door_kick");
	goalnode = GetNode(self.attack_targ.target, "targetname");
	guy SetGoalNode(goalnode);			
}
squad_attack_push()
{
	push_object = self.attack_targ;
	moveto_origin = getent(push_object.target, "targetname");
	push_nodes = getnodearray(push_object.target, "targetname");
	end_nodes = getnodearray(moveto_origin.target, "targetname");
	guys = [];
	for(i = 0; i < push_nodes.size; i++)
	{
		guys[i] = self get_ai_with_goal_node( push_nodes[i] );
	}
	
	array_wait(guys, "goal");
	for(i = 0; i < guys.size; i++)
	{
		guys[i] linkto(push_object);
	}
	push_object moveto(	moveto_origin.origin, 5, 1, 1);
	
	wait(5);
	
	for(i = 0; i < guys.size; i++)
	{
		guys[i] unlink();
		guys[i] SetGoalNode(end_nodes[i]);
	}
	
	level notify("squad_push_done");
}
kick_door_open(guy)
{
	doorstruct = getstruct(guy.doortrig.target, "targetname");
	door = getent(doorstruct.target, "targetname");
	
	guy.doortrig notify("breach_door_opened");
	guy.doortrig delete();
	door connectpaths();
	door delete();
}
animate_hand_signal()
{
	
	prev_weapon = self GetCurrentWeapon();
	
	self GiveWeapon("test_hand_signal_go");
	self SwitchToWeapon("test_hand_signal_go");
	wait(1.1);
	self SwitchToWeapon(prev_weapon);
	self TakeWeapon("test_hand_signal_go");
}
attack_hide_markers()
{
	wait(1);
	for(i = 0; i < self.ainode_fx.size; i++)
	{
		self.ainode_fx[i].origin = level.sc_fx_marker_hide_pos;
	}			
	
	wait(2);
	self.squad_attack_target.origin = level.sc_fx_marker_hide_pos;
}
get_ai_with_goal_node(node)
{
	guy = undefined;
	
	for(i = 0; i < self._squad.size; i++)
	{
		if( self._squad[i].sc_goal_node == node )
		{
			guy = self._squad[i];
		}
	}
	
	return guy;
}
wait_for_guys_to_reach_goals(guys)
{
	for(i = 0; i < guys.size; i++)
	{
		guys[i].sc_at_goal = false;
		guys[i] thread guy_wait_for_goal();
	}
	
	
	while(true)
	{
		all_at_goal = true;
		
		for(i = 0; i < guys.size; i++)
		{
			if( !guys[i].sc_at_goal )
			{
				all_at_goal = false;
			}
		}
		
		if(all_at_goal)
		{
			break;
		}
		wait(.1);
	}
}
guy_wait_for_goal()
{
	self waittill("goal");
	
	self.sc_at_goal = true;
}
create_marker(fx)
{
	marker = spawn("script_model", level.sc_fx_marker_hide_pos);
	marker setmodel("tag_origin");
	
	if(	isdefined(fx) )
	{
		self.sc_fx_markers = array_add(self.sc_fx_markers, marker);
		playfxontag( fx, marker, "tag_origin");
	}
	
	return marker;
}
is_dist_in_range( origin1, origin2 )
{
	dist = distancesquared( origin1, origin2 );
	if( dist < level.sc_max_dist )
	{
		return true;
	}
	else
	{
		return false;
	}
}
hide_all_fx_markers()
{
	for(i = 0; i < self.sc_fx_markers.size; i++)
	{  
		self.sc_fx_markers[i].origin = level.sc_fx_marker_hide_pos;
	}
}
sc_create_new_ainode_marker()
{
	marker = create_marker(level._effect["target_node"]);
	marker rotatepitch(-90, .05);
	self.ainode_fx = array_add( self.ainode_fx, marker );
}
set_as_targeting_effect( center )
{
	self.origin = center.origin;
	self rotateTo( center.angles, 0.15 );
}
ai_health_regen()
{
	self endon ("death");
	
	
	if( !IsDefined( self.flag ) )
	{
		self.flag = []; 
		self.flags_lock = []; 
	}
	if( !IsDefined(self.flag["player_has_red_flashing_overlay"]) )
	{
		self player_flag_init("player_has_red_flashing_overlay");
		self player_flag_init("player_is_invulnerable");
	}
	self player_flag_clear("player_has_red_flashing_overlay");
	self player_flag_clear("player_is_invulnerable");		
		
	
	self.maxhealth = level.player.maxhealth * 10;
	self.health = self.maxhealth;
	self.sc_max_hp = self.maxhealth;		
		
	oldratio = 1;						
	health_add = 0;
	
	regenRate = 0.1;
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	self thread aiHurtcheck();
	
	self.boltHit = false;
	
	playerInvulTimeScale = GetDvarFloat( #"scr_playerInvulTimeScale" );
	
	while(true)
	{
		wait( 0.05 );
		waittillframeend; 
		if( self.health == self.sc_max_hp )
		{
			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}
		
		if( self.health <= 500 )
		{ 
			self thread squad_init_revive();
			self waittill( "ai_revived" );	
		}
		
		wasVeryHurt = veryHurt;
		ratio = self.health / self.sc_max_hp;
		if( ratio <= .7 )
		{
			veryHurt = true;
			if( !wasVeryHurt )
			{
				hurtTime = gettime();
				self.hurtTime = hurtTime;
				
				playerJustGotRedFlashing = true;
			}
		}
		
		if( self.hurtAgain )
		{
			hurtTime = gettime();
			self.hurtAgain = false;
		}
		
		if( self.health / self.sc_max_hp >= oldratio )
		{
			if( gettime() - hurttime < level.playerHealth_RegularRegenDelay )
			{
				continue;
			}
			if( veryHurt )
			{
				newHealth = ratio;
				if( gettime() > hurtTime + level.longRegenTime )
				{
					newHealth += regenRate;
				}
			}
			else
			{
				newHealth = 1;
			}
			
							
			if( newHealth > 1.0 )
			{
				newHealth = 1.0;
			}
			
			if( newHealth <= 0 )
			{
				 
				return;
			}
			
			aiHealth = newHealth * self.sc_max_hp;
			self.health = int(aiHealth);
			
			oldRatio = self.health / self.sc_max_hp;
			continue;
		}
		
		oldratio = lastinvulRatio;
		invulWorthyHealthDrop = oldratio - ratio > level.worthyDamageRatio;
		oldRatio = self.health / self.sc_max_hp;
			
		health_add = 0;
		hurtTime = gettime();
		self.hurtTime = hurtTime;
		
		if( !invulWorthyHealthDrop || playerInvulTimeScale <= 0.0 )
		{
			continue;
		}	
		
		if( playerJustGotRedFlashing )
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = false;
		}
		else if( veryHurt )
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}
		
		invulTime *= playerInvulTimeScale;
		 
		lastinvulratio = self.health / self.sc_max_hp;
		self thread aiInvul( invulTime );
	}
}
aiInvul( invulTime )
{
	self.isImmune = true;
	self thread magic_bullet_shield();
	wait(invulTime);
	self.isImmune = false;
	self thread stop_magic_bullet_shield();
}
aiHurtcheck()
{
	self endon("death");
	
	self.hurtAgain = false;
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		
		if(isdefined(attacker) && isplayer(attacker) && attacker.team == self.team)
		{
			continue;
		}
		
		self.hurtAgain = true;
		self.damagePoint = point;
		self.damageAttacker = attacker;
	}
}
squad_init_revive()
{
	
	self allowedstances("prone");
	self.ignoreme = true;
	self.ignoreall = true;
	self thread magic_bullet_shield();
	
	self thread squad_bleedout(30);
	self thread squad_revive_trigger_spawn();
	
	self.dead_link = spawn("script_model", self.origin);
	self.dead_link.angles = (-90, 0, 0);
	self.dead_link setmodel("tag_origin");
	self linkto(self.dead_link);
	
	self thread play_revive_fx();
	
	level notify("sc_need_revive");
}
play_revive_fx()
{
	self endon("ai_revived");
	
	while( isdefined(self.dead_link) )
	{
		
		playfxontag(level._effect["need_revive"], self.dead_link, "tag_origin");
		wait(.78);
	}
}
squad_bleedout(bleedout_time)
{
	self endon("ai_revived");
	self endon("death");
	
	self.bleedout_time = bleedout_time;
	
	while ( self.bleedout_time > 0 )
	{
		self.bleedout_time -= 1;
		wait( 1 );
	}	
	
	while( self.revivetrigger.beingRevived == 1 )
	{
		wait( 0.1 );
	}	
	
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		
		
	}
	
	missionfailed();
}
squad_revive_trigger_spawn()
{
	radius = GetDvarInt( #"revive_trigger_radius" );
	self.revivetrigger = spawn( "trigger_radius", self.origin, 0, radius, radius );
	self.revivetrigger setHintString( "" ); 
	self.revivetrigger setCursorHint( "HINT_NOICON" );
	self.revivetrigger EnableLinkTo();
	self.revivetrigger LinkTo( self );  
	
	self.revivetrigger.beingRevived = 0;
	self.revivetrigger.createtime = gettime();
		
	self thread squad_revive_trigger_think();
}
squad_revive_trigger_think()
{
	self endon ( "death" );
	
	while ( 1 )
	{
		wait ( 0.1 );
		players = get_players();
			
		self.revivetrigger setHintString( "" );
		
		for ( i = 0; i < players.size; i++ )
		{
			
			d = 0;
			d = self depthinwater();
				
			if ( players[i] can_revive( self ) || d > 20)
			
			{
				
				
				
				
				
				self.revivetrigger setHintString( &"GAME_BUTTON_TO_REVIVE_PLAYER" );
				break;			
			}
		}
		
		for ( i = 0; i < players.size; i++ )
		{
			reviver = players[i];
			
			if ( !reviver is_reviving( self ) )
			{
				continue;
			}
			
			
			gun = reviver GetCurrentWeapon();
			assert( IsDefined( gun ) );
			
			assert( gun != "syrette" );
			reviver GiveWeapon( "syrette" );
			reviver SwitchToWeapon( "syrette" );
			reviver SetWeaponAmmoStock( "syrette", 1 );
			
			revive_success = reviver squad_do_revive( self );
			reviver revive_give_back_weapons( gun );
			
			
			
			if ( revive_success )
			{
				self thread revive_success( reviver );
				return;
			}
		}
	}
}
revive_success( reviver )
{
	self notify ( "ai_revived" );	
	
	self unlink();
	self.dead_link delete();
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	
	self thread stop_magic_bullet_shield();
	
	self.health = self.sc_max_hp;
	
	self allowedstances("prone", "crouch", "stand");
	
	self.ignoreme = false;
	self.ignoreall = false;
}
is_reviving( revivee )
{	
	return ( can_revive( revivee ) && self UseButtonPressed() );
}
is_facing( facee )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > 0.9 ); 
}
can_revive( revivee )
{
	if ( !isAlive( self ) )
	{
		return false;
	}
		
	if( !isDefined( revivee.revivetrigger ) )
	{
		return false;
	}
	
	if ( !self IsTouching( revivee.revivetrigger ) )
	{
		return false;
	}
		
	
	if (revivee depthinwater() > 10)
	{
		return true;
	}
	
	if ( !self is_facing( revivee ) )
	{
		return false;
	}
		
	if( !SightTracePassed( self.origin + ( 0, 0, 50 ), revivee.origin + ( 0, 0, 30 ), false, undefined ) )				
	{
		return false;
	}
	
	if(!bullettracepassed(self.origin + (0,0,50), revivee.origin + ( 0, 0, 30 ), false, undefined) )
	{
		return false;
	}
	
	
	if( IsDefined( level.is_zombie_level ) && level.is_zombie_level )
	{
		if( IsDefined( self.is_zombie ) && self.is_zombie )
		{
			return false;
		}
	}
		
	
	if(level.script == "nazi_zombie_asylum" && isdefined(self.is_drinking))
		return false;
		
	return true;
}
squad_do_revive( aiBeingRevived )
{
	assert( self is_reviving( aiBeingRevived) );
	
	
	
	reviveTime = 3;
	timer = 0;
	revived = false;
	
	
	aiBeingRevived.revivetrigger.beingRevived = 1;
	
	aiBeingRevived.revivetrigger setHintString( "" );
	
	
	if( !isdefined(self.reviveProgressBar) )
	{
		self.reviveProgressBar = self createPrimaryProgressBar();
	}
	if( !isdefined(self.reviveTextHud) )
	{
		self.reviveTextHud = newclientHudElem( self );	
	}
	
	
	self.reviveProgressBar updateBar( 0.01, 1 / reviveTime );
	self.reviveTextHud.alignX = "center";
	self.reviveTextHud.alignY = "middle";
	self.reviveTextHud.horzAlign = "center";
	self.reviveTextHud.vertAlign = "bottom";
	self.reviveTextHud.y = -113;
	if ( IsSplitScreen() )
	{
		self.reviveTextHud.y = -107;
	}
	self.reviveTextHud.foreground = true;
	self.reviveTextHud.font = "default";
	self.reviveTextHud.fontScale = 1.8;
	self.reviveTextHud.alpha = 1;
	self.reviveTextHud.color = ( 1.0, 1.0, 1.0 );
	self.reviveTextHud setText( &"GAME_REVIVING" );
	
	while( self is_reviving(aiBeingRevived) )
	{
		wait( 0.05 );					
		timer += 0.05;			
		if( timer >= reviveTime)
		{
			revived = true;	
			break;
		}
	}
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}		
	
	if ( !revived )
	{
		aiBeingRevived stoprevive( self );
	}
	
	aiBeingRevived.revivetrigger setHintString( &"GAME_BUTTON_TO_REVIVE_PLAYER" );
	aiBeingRevived.revivetrigger.beingRevived = 0;
	
	return revived;
}
revive_give_back_weapons( gun )
{
	
	self TakeWeapon( "syrette" );
	
	if ( gun != "none" && gun != "mine_bouncing_betty" )
	{
		self SwitchToWeapon( gun );
	}
	else 
	{
		
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}
sc_revive_hud_init()
{
	self sc_revive_hud_create();
	self thread sc_revive_hud_think();
}
sc_revive_hud_create()
{	
	self.sc_revive_hud = newclientHudElem( self );
	self.sc_revive_hud.alignX = "center";
	self.sc_revive_hud.alignY = "middle";
	self.sc_revive_hud.horzAlign = "center";
	self.sc_revive_hud.vertAlign = "bottom";
	self.sc_revive_hud.y = -100;
	self.sc_revive_hud.foreground = true;
	self.sc_revive_hud.font = "default";
	self.sc_revive_hud.fontScale = 1.5;
	self.sc_revive_hud.alpha = 0;
	self.sc_revive_hud.color = ( 1.0, 1.0, 1.0 );
	self.sc_revive_hud setText( "Squad Member Needs REVIVE" );
}
sc_revive_hud_think()
{
	self endon("disconnect");
	
	while(true)
	{
		level waittill("sc_need_revive");
		
		self.sc_revive_hud.alpha = 1;
		self.sc_revive_hud fadeOverTime( 3 );
		
		self.sc_revive_hud.alpha = 0;
	}
}