
#include maps\_utility;
#include common_scripts\utility;
setteam(team)
{
	switch(team)
	{
		case "allies":
		case "axis":
			self.team = team;
			self.sessionteam = team;
			break;
		default:
			println("Unknown team " + team + " passed to maps/_vsmode::setteam()");
			break;
	}
}
precache_callback()
{
	println("VS Mode precache_callback running...");
	precacheShader("headicon_dead");
		
	assertex(isDefined(level.axis_player_precache),"No axis character precache function was found");
	[[level.axis_player_precache]]();
	
	if(isdefined(level._axis_weapons))
	{
		for(i = 0; i < level._axis_weapons.size; i ++)
		{
			precacheitem(level._axis_weapons[i]);
		}
	}
	
	maps\_gib::precache_gib_fx();
	
}
getspawnpoint()
{
	spawn_managers = getentarray("spawn_manager","classname");
	
	spawners = [];
	
	for(i = 0; i < spawn_managers.size; i ++)
	{
		assertex(isDefined(spawn_managers[i].target),"Spawn manager at " + spawn_managers[i].origin + " does not have any spawners targeted");
	
		manager_spawners = getentarray(spawn_managers[i].target,"targetname");
		
		for(j = 0; j < manager_spawners.size; j ++)
		{
			spawners[spawners.size] = manager_spawners[j];
		}
	}
	
	index = randomintrange(0, spawners.size);
	
	return(spawners[index].origin);
	
}
postClassLoadoutViewModel()
{
	wait(1.0);	
	
	assertex(isDefined(level.axis_player_setup),"No level.axis_player_setup character function pointer was found.");
	self [[level.axis_player_setup]]();
}
store_loadout()
{
	self player_flag_wait("loadout_given");
	self.weaponInventory = self GetWeaponsList();
	self.lastActiveWeapon = self GetCurrentWeapon();
	
	self.weaponAmmo = [];
	for( i = 0; i < self.weaponInventory.size; i++ )
	{
		weapon = self.weaponInventory[i];
		if ( weapon == "syrette" )
		{
			
			self.lastActiveWeapon = "none";
			continue;
		}
		self.weaponAmmo[weapon]["clip"] = self GetWeaponAmmoClip( weapon );
		self.weaponAmmo[weapon]["stock"] = self GetWeaponAmmoStock( weapon );
		
		println("Storing off weapon : " + weapon + " for player " + self getentitynumber());
		
	}
	
	println("Stored current weapon " + self.lastActiveWeapon + " for player " + self getentitynumber());
	
}
connect_cb()
{
	self endon("disconnect");
	self._num_spawns = 0;
	
	while(1)
	{
		self waittill( "spawned_player" ); 
		waittillframeend;
		println("VS Mode playerconnect_callback running..." + self getentitynumber() + " " + self.sessionteam);
	
		
		if(level._round_number == 0)
		{
			if(GetDvarInt( #"xblive_privatematch"))
			{
				switch(self getentitynumber())
				{
					case 1:
					case 3:
						self setteam("axis");
						break;
					default:
						self setteam("allies");
						break;
				}
			}
			else
			{
				self setteam(self.sessionteam);
			}
		}
				
		allied_starts = getstructarray("vs_allies_start","targetname");
		axis_starts = getstructarray("vs_axis_start","targetname");
		
		if(self._num_spawns == 0)	
		{
			starts = allied_starts;
			
			if(self.sessionteam == "axis")
			{
				self thread postClassLoadoutViewModel();
				self thread show_message( 5.0, "Defend the VIP", 0 );
				starts = axis_starts;
			}
			
			if(self.sessionteam == "allies")
			{
				msg = "Eliminate the VIP";
				
				if(isDefined(level._attack_obj_msg))
				{
					msg = level._attack_obj_msg;
				}
				self thread show_message( 5.0, msg, 0 );
			}
			
			
			index = randomint(starts.size);
			
			self setorigin(starts[index].origin);
			self setplayerangles(starts[index].angles);
			
			self._vsmode_start = self.origin;
			self._vsmode_ang = self.angles;			
		}
		else
		{
			if(self.sessionteam == "axis")
			{
				self thread postClassLoadoutViewModel();
			}
			
		}
		
		println("Player " + self getentitynumber() + " sess team " + self.sessionteam + " " + self.team);
		self._num_spawns ++;
	}
}
playerconnect_callback()
{
	self thread connect_cb();
}
cull_badspawners(array)
{
	spawners = [];
	
	for(i = 0; i < array.size; i ++)
	{
		spawner = array[i];
		if(!isdefined(spawner.script_noteworthy) || spawner.script_noteworthy != "versus_mode_nospawn")
		{
			spawners[spawners.size] = spawner;
		}
	}
	
	return(spawners);
}
show_message( time, message, y, player )
{	
	self endon( "disconnect" );
	
			
	if(!isDefined(self.message_hud))
	{
		self.message_hud = newclientHudElem( self );
		self.message_hud.hidewheninmenu = true;
		self.message_hud.horzAlign = "center";
		self.message_hud.vertAlign = "middle";
		self.message_hud.alignX = "center";
		self.message_hud.alignY = "middle";
		self.message_hud.x = 0;
		self.message_hud.y = y;
		self.message_hud.foreground = true;
		self.message_hud.font = "default";
		self.message_hud.fontScale = 2.0;
		self.message_hud.color = ( 1.0, 1.0, 1.0 );			
	}
	
	if( isDefined ( player ) )
	{
		self.message_hud setText( message, player );
	}
	else
	{
		self.message_hud setText( message );
	}
	self.message_hud.alpha = 1;
	self.message_hud fadeOverTime( time );
	
	self.message_hud.alpha = 0;
	
	wait( time + 0.2 );
	
	
}
getclosestn(org, array, number, exclude)
{
	if(isdefined(exclude))
	{
		new_array = [];
		
		for(i = 0; i < array.size; i ++)
		{
			if(array[i] != exclude)
			{
				new_array[new_array.size] = array[i];
			}
		}
		
		array = new_array;
	}
	if(array.size < number)
	{
		return array;
	}
	
	ret_array = [];
	
	for(i = 0; i < number; i ++)
	{
		closest = getclosest(org, array);
		
		ret_array[ret_array.size] = closest;
		
		new_array = [];
		
		for(j = 0; j < array.size; j ++)
		{
			if(array[j] != closest)
			{
				new_array[new_array.size] = array[j];
			}
		}
		
		array = new_array;
	}
	
	return ret_array;
}
delayStartRagdoll( ent, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath )
{
	if ( isDefined( ent ) )
	{
		deathAnim = ent getcorpseanim();
		if ( animhasnotetrack( deathAnim, "ignore_ragdoll" ) )
			return;
	}
	
	
	wait( 0.2 );
	
	if ( !isDefined( ent ) )
		return;
	
	if ( ent isRagDoll() )
		return;
	
	deathAnim = ent getcorpseanim();
	startFrac = 0.35;
	if ( animhasnotetrack( deathAnim, "start_ragdoll" ) )
	{
		times = getnotetracktimes( deathAnim, "start_ragdoll" );
		if ( isDefined( times ) )
			startFrac = times[0];
	}
	waitTime = startFrac * getanimlength( deathAnim );
	wait( waitTime );
	if ( isDefined( ent ) )
	{
		println( "Ragdolling after " + waitTime + " seconds" );
		ent startragdoll( 1 );
	}
}
createDeadBody( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_jib, body )
{
	if ( ragdoll_jib || self isOnLadder() || self isMantling() || sMeansOfDeath == "MOD_CRUSH" )
		body startRagDoll();
	thread delayStartRagdoll( body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );
	if( sMeansOfDeath == "MOD_BURNED" || isdefined( self.burning ) )
	{
	
	}	
	if ( sMeansOfDeath == "MOD_CRUSH" )
	{
	
	}
	
	self.body = body;
	thread addDeathicon( body, self, self.team, 5.0 );
}
set_third_person( value )
{
	if( value )
	{
		self SetClientDvars( "cg_thirdPerson", "1",
			"cg_fov", "40",
			"cg_thirdPersonAngle", "354" );
		self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
	}
	else
	{
		self SetClientDvars( "cg_thirdPerson", "0",
			"cg_fov", "65",
			"cg_thirdPersonAngle", "0" );
		self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
	}
}
resetweapons()
{
	println("**** VS MODE RESET WEAPONS");
	self TakeAllWeapons();
	
	for( i = 0; i < self.weaponInventory.size; i++ )
	{
		weapon = self.weaponInventory[i];
		if ( weapon == "syrette" )
		{
			
			continue;
		}
		println("Giving weapon " + weapon + " to player " + self getentitynumber());
		self GiveWeapon( weapon );
		self SetWeaponAmmoClip( weapon, self.weaponAmmo[weapon]["clip"] );
		if ( WeaponType( weapon ) != "grenade" )
		{
			self SetWeaponAmmoStock( weapon, self.weaponAmmo[weapon]["stock"] );
		}
	}
	
	
	if( self.lastActiveWeapon != "none" && self.lastActiveWeapon != "mortar_round")
	{
		self SwitchToWeapon( self.lastActiveWeapon );
		println("Switching to " + self.lastActiveWeapon + " player " + self getentitynumber());
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
spectate_delay(eAttacker)
{
	self set_third_person(true);
	wait(1.0);	
	self.sessionstate = "spectator";
	self.spectatorclient = self getentitynumber();
	self allowSpectateTeam( "allies", true );
	self allowSpectateTeam( "axis", true );
	self allowSpectateTeam( "none", false );
	self allowSpectateTeam( "freelook", false );
	self Spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );
	
	if(isplayer(eAttacker))
	{
		self.spectatorclient = eAttacker getentitynumber();
	}
	wait(3.0);
	
	friendlies = getaiarray(self.team);
	
	pos = self._vsmode_start;
	ang = self.angles;
	
	if(self.team == "allies" && isDefined(level.attacker_respawn_logic))
	{
		spot = [[level.attacker_respawn_logic]]();
		pos = spot.origin;
		ang = spot.angles;
	}
	
	if(isdefined(friendlies) && friendlies.size > 0)
	{
		centroid = (0,0,0);
		
		for(i = 0; i < friendlies.size; i ++)
		{
			centroid += friendlies[i].origin;	
		}
		
		centroid /= friendlies.size;
		
		spawners = getspawnerarray();
		
		spawners = cull_badspawners(spawners);
		
		spawners = getclosestn(centroid, spawners,5, self._last_spawner);
		
		if(isdefined(spawners) && spawners.size > 0)
		{
			spawner = spawners[randomintrange(0, spawners.size)];
			
			pos = spawner.origin;
			ang = spawner.angles;
			
			self._last_spawner = spawner;
		}
		
	}	
	
	self.sessionstate = "playing";
	self.spectatorclient = -1;	
	self allowSpectateTeam( "allies", false );
	self allowSpectateTeam( "axis", false );
	self allowSpectateTeam( "none", false );
	self allowSpectateTeam( "freelook", false );
	self set_third_person(false);
	self setorigin(pos);	
	self [[level.spawnPlayer]]();
	self setplayerangles(ang);	
	self show();
	
	
}
isHeadShot( sWeapon, sHitLoc, sMeansOfDeath )
{
	return (sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_BAYONET" && sMeansOfDeath != "MOD_IMPACT"; 
}
playerkilled_callback( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	println("Vs Mode custon playerkilled callback...");
	
	if( isHeadShot( sWeapon, sHitLoc, sMeansOfDeath ) )
	{
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}
	
	obituary(self, eAttacker, sWeapon, sMeansOfDeath);
	
	body = self clonePlayer( deathAnimDuration );
	vAttackerOrigin = undefined;
	if ( isdefined( eAttacker ) )
		vAttackerOrigin = eAttacker.origin;
	ragdoll_now = false;
	if( IsDefined(self.usingvehicle) && self.usingvehicle && IsDefined(self.vehicleposition) && self.vehicleposition == 1 )
		ragdoll_now = true;
	else
		ragdoll_now = self maps\_gib::gib_player(iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDir, vAttackerOrigin);
		
	self createDeadBody( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDir, vAttackerOrigin, deathAnimDuration, eInflictor, ragdoll_now, body );
	
	self hide();
	
	self setmovespeedscale( 1.0 ); 
	self.ignoreme = false; 
	self notify( "killed_player" ); 
	
	self thread spectate_delay(eAttacker);
	
}
playerlaststand_callback( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	println("VS Mode Custom laststand callback...");
	
}
addDeathIcon( entity, dyingplayer, team, timeout )
{
	
	iconOrg = entity.origin;
	
	dyingplayer endon("spawned_player");
	dyingplayer endon("disconnect");
	
	wait .05;
	
	
	assert(team == "allies" || team == "axis");
	
	
	if ( isdefined( self.lastDeathIcon ) )
		self.lastDeathIcon destroy();
	
	newdeathicon = newTeamHudElem( team );
	newdeathicon.x = iconOrg[0];
	newdeathicon.y = iconOrg[1];
	newdeathicon.z = iconOrg[2] + 54;
	newdeathicon.alpha = .61;
	newdeathicon.archived = true;
	if ( level.splitscreen )
		newdeathicon setShader("headicon_dead", 14, 14);
	else
		newdeathicon setShader("headicon_dead", 7, 7);
	newdeathicon setwaypoint(true);
	
	self.lastDeathIcon = newdeathicon;
	
	newdeathicon thread destroySlowly ( timeout );
}
destroySlowly( timeout )
{
	self endon("death");
	
	wait timeout;
	
	self fadeOverTime(1.0);
	self.alpha = 0;
	
	wait 1.0;
	self destroy();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player.selfDeathIcons = []; 
	}
}
init_callbacks()
{
	println("VS Mode init callbacks.");
	
	level.callbackPlayerLastStand = ::playerlaststand_callback;	
	level.callbackPlayerKilled = ::playerkilled_callback;
}
delete_all_ai()
{
	ai = getaiarray("axis");
	
	for(i = 0; i < ai.size; i ++)
	{
		ai[i] delete();
	}
	ai = getaiarray("allies");
	
	for(i = 0; i < ai.size; i ++)
	{
		ai[i] delete();
	}
}
any_spectators()
{
	players = get_players("all");
	
	for(i = 0; i < players.size; i ++)
	{
		if(players[i].team == "spectator")
		{
			return(true);
		}
	}
	
	return(false);
}
switch_player_teams_and_respawn()
{
	while(any_spectators())
	{
		wait(1.0);		
	}
	delete_all_ai();
	players = get_players("all");
	
	println("SPTaR! " + players.size);
	
	for(i = 0; i < players.size; i ++)
	{
		if(players[i].team == "axis")
		{
			players[i] setteam("allies");
		}
		else
		{
			players[i] setteam("axis");
		}
		
		players[i]._num_spawns = 0;
		
		
		players[i] thread [[level.spawnPlayer]]();		
	}	
	wait(1);
	level notify("teams_switched");
}
next_round()
{
	level._round_number ++;
	
	
	
	level notify("round_end");
	if(isDefined(level._round_end_logic))
	{
		[[level._round_end_logic]]();
	}
	switch_player_teams_and_respawn();	
}
end_game()
{
	level notify("match_end");
}
turn_yellow()
{
	self waittill("yellow");
	level endon("kill_timer");
	
	self.color = ( 1.0, 1.0, 0.1);	
}
turn_red_and_flash()
{
	self waittill("red");
	self endon("stop_flash");
	level endon("kill_timer");
	
	self.color = ( 0.8, 0.2, 0.2 );
	
	alpha = self.alpha;
	
	while(1)
	{
		alpha += 0.05;
		if( alpha >= 1 )
		{
			alpha = 0;
		}
		self.alpha = alpha;
		wait( 0.05 ); 
		
	}
}
monitor_timer()
{
	level endon("timer_ended");
	level waittill("kill_timer");
	
	self destroy();
	level notify("timer_ended");
}
do_countdown(duration)
{
	level endon("kill_timer");
	end_time = gettime() + (duration * 1000);
	self thread monitor_timer();
	level._timer_expired = false;
	
	while(gettime() < end_time)
	{
		remaining = (end_time - gettime()) / 1000;
		
		level._time_remaining = remaining;
		
		minutes = int(remaining / 60);
		seconds = int(remaining) % 60;
		
		if(minutes == 0)
		{
			if(seconds == 30)
			{
				self notify("yellow");
			}
			else if(seconds == 10)
			{
				self notify("red");
			}
		}
		
		time_text = create_time_text(minutes,seconds);
		self setText( time_text );
		wait(1.0);
	}
	
	level._timer_expired = true;
	level._time_remaining = 0;
	
	self setText("00:00");
	
	wait(1.0);
	
	
	self notify("stop_flash");
	level notify("timer_ended");
	self destroy();
}
do_round(duration)
{
	
	
	
	
		
		og_duration = duration;
		
		if(isDefined(level._attack_vip_time ))
		{
			duration = level._attack_vip_time;
			level._round_duration = duration;
		}
		
		timer_hud = newHudElem( );
		timer_hud.hidewheninmenu = true;
		timer_hud.horzAlign = "center";
		timer_hud.vertAlign = "middle";
		timer_hud.alignX = "center";
		timer_hud.alignY = "middle";
		timer_hud.x = 280;
		timer_hud.y = -180;
		timer_hud.foreground = true;
		timer_hud.font = "default";
		timer_hud.fontScale = 2.0;
		timer_hud.color = ( 0.8, 0.8, 0.8 );	
		timer_hud.alpha = 1;
		
		timer_hud thread turn_yellow();
		timer_hud thread turn_red_and_flash();
		timer_hud thread do_countdown(duration);
		level waittill("timer_ended");
		
		if(!level._vip_killed)
		{
			return;
		}
		
		if(level._round_number > 0 && !isDefined(level._charge_planted_round_1 ))
		{
			return;			
		}
		
		level waittill("next_objective");			
			
		[[level._hq_objective]]();
		
		if( isDefined(level._hq_time_to_plant) )
		{
			duration = level._hq_time_to_plant;
			level._round_duration = duration;
		}		
		else
		{
			duration = og_duration;
			level._round_duration = duration;
		}
		
		timer_hud = newHudElem( );
		timer_hud.hidewheninmenu = true;
		timer_hud.horzAlign = "center";
		timer_hud.vertAlign = "middle";
		timer_hud.alignX = "center";
		timer_hud.alignY = "middle";
		timer_hud.x = 280;
		timer_hud.y = -180;
		timer_hud.foreground = true;
		timer_hud.font = "default";
		timer_hud.fontScale = 2.0;
		timer_hud.color = ( 0.8, 0.8, 0.8 );	
		timer_hud.alpha = 1;
		
		timer_hud thread turn_yellow();
		timer_hud thread turn_red_and_flash();
		timer_hud thread do_countdown(duration);
		level waittill("timer_ended");		
		
	
	
}
game_timer()
{
	wait(0.25);
	flag_wait("all_players_connected");
	
	do_round(level._round_duration);		
	next_round();
	do_round(level._round_duration);
	end_game();
		
}
custom_loadout()
{
	if(self.sessionteam == "axis" && isdefined(level._axis_weapons))
	{
		self GiveWeapon( level._axis_weapons[1] );
		self giveweapon(level._axis_weapons[0]);
		self setSpawnWeapon( level._axis_weapons[0] );
		
		return 1;
	}
	return 0; 
}
set_axis_weapons(primary, secondary)
{
	level._axis_weapons = [];
	level._axis_weapons[0] = primary;
	level._axis_weapons[1] = secondary;
}
set_round_duration(seconds)
{
	level._round_duration = seconds;
}
init()
{
	println("VS Mode Init.");
	SetDvar( "scr_coopCAC", 1 );
	
	level._round_number = 0;
	level._round_duration = 180;
	
	level._gamemode_precache = ::precache_callback;
	level._gamemode_playerconnect = ::playerconnect_callback;
	level._gamemode_norandomdogs = 1;
	
	level._gamemode_initcallbacks = ::init_callbacks;
	
	level._gamemode_custom_loadout = ::custom_loadout;
	
	level thread onPlayerConnect();
	level thread game_timer();
}
add_objective_icon( entity, team, offset, on_ent )
{
	
	img = undefined;
	
	iconOrg = entity.origin;
	
	wait .05;
	
	assert(team == "allies" || team == "axis");
		
	objicon = newTeamHudElem( team );
	objicon.x = iconOrg[0];
	objicon.y = iconOrg[1];
	objicon.z = iconOrg[2] + offset;
	objicon.alpha = .61;
	objicon.archived = true;
	
	if(team == "allies")
	{
		img = level.iconCapture3D ;
	}
	else
	{
		img = level.iconDefend3D;
	}
	if ( level.splitscreen )
		objicon setShader(img, 14, 14);
	else
		objicon setShader(img, 7, 7);
	objicon setwaypoint(true);
	
	if(!isDefined(level._objective_icons))
	{
		level._objective_icons = [];
	}	
	level._objective_icons[level._objective_icons.size]= objicon;
	
	if(isDefined(on_ent) && on_ent)
	{
		while(isDefined(entity) && isAlive(entity))
		{
			wait(.05);
			icon_ent = entity;
			if(!isDefined(icon_ent))
			{
				break;
			}
			iconOrg = icon_ent.origin;
			objicon.x = iconOrg[0];
			objicon.y = iconOrg[1];
			objicon.z = iconOrg[2] + offset;
		}
		objicon destroy();
	}	
}
destroy_objective_icons()
{
	
	for(i=0;i<level._objective_icons.size;i++)
	{
		if(isDefined(level._objective_icons[i]))
		{
			level._objective_icons[i] destroy();
		}
	}
	
}
create_time_text(minutes,seconds)
{
	time_text ="";
	
	if(minutes > 9)
	{
		time_text = time_text + minutes;
	}
	else if(minutes > 0)
	{
		time_text = time_text + "0" + minutes;
	}
	else
	{
		time_text = time_text + "00";
	}
	
	if(seconds > 9)
	{
		time_text = time_text + ":" + seconds;
	}
	else if(seconds > 0)
	{
		time_text = time_text + ":0" + seconds;
	}
	else
	{
		time_text = time_text + ":00";
	}
	
	return time_text;
}  
