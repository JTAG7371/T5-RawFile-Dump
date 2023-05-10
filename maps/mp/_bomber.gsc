#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\_airsupport;
init()
{
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheShader("ac130_overlay_grain");
	precacheShader("ac130_overlay_105mm");
	PreCacheItem("mk82_mp");
	
	alliesplaneModel = "t5_veh_jet_f4_gearup";
	axisplaneModel  = "t5_veh_jet_f4_gearup";
	
	level.debugPlaneModel = alliesplaneModel;
	
		
	precacheModel( alliesplaneModel );
	precacheModel( axisplaneModel );
	
	level.bomberDangerMaxRadius = 750;
	level.bomberDangerMinRadius = 300;
	level.bomberDangerForwardPush = 1.5;
	level.bomberDangerOvalScale = 6.0;
	level.bomberMapRange = level.bomberDangerMinRadius * .3 + level.bomberDangerMaxRadius * .7;	
	level.bomberDangerMaxRadiusSq = level.bomberDangerMaxRadius * level.bomberDangerMaxRadius;	
	level.fx_jet_trail = loadfx("trail/fx_geotrail_jet_contrail");
	level.fx_bomber_afterburner = loadfx("vehicle/exhaust/fx_exhaust_jet_afterburner");
	level.fx_jet_bomb = loadfx ("weapon/clusterbomb/fx_clusterbomb_mp");
	level.fx_bomb_explosion = loadfx ("weapon/clusterbomb/fx_clusterbomb_exp_mp");
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowbomber" ) )
	{
		maps\mp\gametypes\_hardpoints::registerKillstreak("bomber_mp", "bomber_mp", "killstreak_bomber","bomber_used", ::useKillstreakBomber, true);
		maps\mp\gametypes\_hardpoints::registerKillstreakStrings("bomber_mp", &"MP_EARNED_BOMBER", &"MP_BOMBER_NOT_AVAILABLE",&"MP_WAR_AIRSTRIKE_INBOUND", &"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION");
		maps\mp\gametypes\_hardpoints::registerKillstreakDialog("bomber_mp", "mp_killstreak_bomber", "friendlybomber", "","enemybomber", "", "bomber");
		maps\mp\gametypes\_hardpoints::registerKillstreakDevDvar("bomber_mp", "scr_givebomber");
	}
}
useKillstreakBomber(hardpointType)
{
	if ( isDefined( level.airSupportInProgress ) )
	{
		self iPrintLnBold( level.killstreaks[hardpointType].notAvailableText );
		return false;
	}
		
	result = self maps\mp\_bomber::selectBomberLocation();
	
	if ( !isDefined( result ) || !result )
		return false;
	return true;
}
selectBomberLocation()
{
	self beginLocationSelection( "map_artillery_selector", level.bomberDangerMaxRadius * 1.2 );
	self.selectingLocation = true;
	self thread endSelectionThink();
	self waittill( "confirm_location", location );
	if ( !IsDefined( location ) )
	{
		
		return false;
	}
	if ( isDefined( level.airSupportInProgress ) )
	{
		self iPrintLnBold( level.killstreaks["bomber_mp"].notAvailableText );
		return false;
	}
	self thread finishHardpointLocationUsage( location, ::useBomber );
	return true;
}
useBomber( pos )
{
	level.airSupportInProgress = true;
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "team", "allowHardpointStreakAfterDeath" ) )
	{
		ownerDeathCount = self.deathCount;
	}
	else
	{
		ownerDeathCount = self.pers["hardPointItemDeathCountbomber_mp"];
	}
	
	level.bomberPlanes = [];
	
	thread doBomber( pos, self, self.team );
}
getBestPlaneDirection()
{
	random = randomint( 360 );	
	random = int( getDvarIntDefault( #"scr_random", random ) );
		
	return random;
}
spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" ); 
	return bomb;
}
getbombVelocity(planeAngle, planeFlySpeed, bombSpeedScale )
{
	scaledBy = getDvarIntDefault( #"scr_bomberSpeedScale", planeFlySpeed * bombSpeedScale );
	return vector_scale( anglestoforward(planeAngle ), scaledBy );
}
callStrike_bombEffect( plane, pathEnd, flyTime, launchTime, planeFlySpeed, bombSpeedScale, owner, requiredDeathCount )
{
	wait ( launchTime );
	
	planedir = anglesToForward( plane.angles );
	
	bomb_create_time = GetTime();
	bomb = spawnbomb( plane.origin, plane.angles );
	
	bombVelocity = getbombVelocity( plane.angles, planeFlySpeed, bombSpeedScale );
	bomb moveGravity( bombVelocity, 10.0 );
	
	bomb.ownerRequiredDeathCount = requiredDeathCount;
	
	killCamEnt = spawn( "script_model", plane.origin + (0,0,100) - planedir * 200 );
	bomb.killCamEnt = killCamEnt;
	killCamEnt.startTime = gettime();
	killCamEnt thread deleteAfterTime( 15.0 );
	killCamEnt.angles = planedir;
	killCamEnt moveTo( pathEnd + (0,0,100), flyTime, 0, 0 );
	
	bomb thread debug_draw_bomb_path( );
	
	wait .4;
	killCamEnt moveTo( killCamEnt.origin + planedir * 4000, 1, 0, 0 );
	
	wait .45;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.2)) * 3500, 2, 0, 0 );
	
	wait ( 0.15 );
	
	fxTimer = 0.25;
	
	
	if ( isdefined ( level.bomberFxTimer ) )
		fxTimer = level.bomberFxTimer;
	
	fxtimer = getDvarIntDefault( #"scr_fxTimer", fxTimer );
	
	x = getDvarIntDefault( #"scr_bomber_x", 1.0 );
	z = getDvarIntDefault( #"scr_bomber_z", 15.0 );
	maxX = getDvarIntDefault( #"scr_bomber_max_x", 30.0 );
		
	looptime = 0.0;
	while( loopTime < fxTimer )	
	{
		wait (0.05);
		loopTime += 0.05;
		if ( bomb.angles[0] > maxX )	
			x = 0.0;
		bomb.angles = ( bomb.angles[0] + x, bomb.angles[1], bomb.angles[2] + z);
	}
	
	bomb setModel( "tag_origin" );
	
	newBomb = spawn( "script_model", bomb.origin );
	newBomb.killCamEnt = killCamEnt;
	newBomb setModel( "tag_origin" );
 	newBomb.angles = bomb.angles;
 	
	wait (0.10);  
 	
	playfxontag( level.fx_jet_bomb, newBomb, "tag_origin" );
	
	
	
	repeat = 12;
	minAngle = 5;
	maxAngle = 45;
	
	if ( isdefined( level.bomberMinAngle ) )
		minAngle = level.bomberMinAngle;
	if ( isdefined( level.bomberMaxAngle ) )
		maxAngle = level.bomberMaxAngle;
	
	minAngles = getDvarIntDefault( #"scr_bomber_minAngles", minAngle );
	maxAngles = getDvarIntDefault( #"scr_bomber_maxAngles", maxAngle );
	
	angleDiff = (maxAngles - minAngles) / repeat;
		
	hitpos = (0,0,0);
	
	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		hitpos += traceHit;
		
		thread debug_line( bombOrigin, traceHit, (1,0,0) );
		
		thread maps\mp\_airsupport::losRadiusDamage( traceHit + (0,0,16), 512, 200, 30, owner, newBomb );
	
		if ( i%3 == 0 )
		{
			thread playsoundinspace( "mpl_kls_bomb_impact", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
			thread checkPlayersTinitus (traceHit);
		}
		
		wait ( 0.05 );
	}
	
	hitpos = hitpos / repeat + (0,0,128);
	killCamEnt moveto( bomb.killCamEnt.origin * .35 + hitpos * .65, 1.5, 0, .5 );
	
	wait ( 5.0 );
	newBomb delete();
	bomb delete();
}
planeSpawnedCallback( owner, requiredDeathCount, pathStart, pathEnd, bombTime, bombSpeedScale, flyTime, flyspeed, direction, planeSpawnedFunction )
{
	self setModel( level.debugPlaneModel );
	
	if ( level.bomberPlanes.size == 0 )
	{
		self bomber_attachPlayer(owner);
	}
	
	level.bomberPlanes[level.bomberPlanes.size] = self;
	
	
self thread bombDropWaiter( owner );
}
bombDropWaiter( owner )
{
	owner endon("disconnect");
	owner endon("death");
	owner endon("bombing_done");
	
	for(;;)
	{
		while( self != owner.currentPlane || !owner AttackButtonPressed() )
			wait 0.05;
		
		self thread bombsAway(owner);
		
		while( owner AttackButtonPressed() )
			wait 0.05;
			
		plane = getNextPlane(self, true);
		
		if ( plane == self )
		{
			wait(2);
			
			owner notify("bombing_done");
		}
		else
		{
			plane attachPlayer( owner );
		}
		return;
	}
}
dropBomb( origin, velocity )
{
	bombOffsetMax = ( 50,50,50 );
	bombOffsetMin = ( -50,-50,-50 );
	offset = ( RandomFloatRange(bombOffsetMin[0], bombOffsetMax[0]), RandomFloatRange(bombOffsetMin[1], bombOffsetMax[1]), RandomFloatRange(bombOffsetMin[2], bombOffsetMax[2]) );
	bombVelOffsetMax = ( 10,10,0 );
	bombVelOffsetMin = ( -10,10,0 );
	vel_offset = ( RandomFloatRange(bombVelOffsetMin[0], bombVelOffsetMax[0]), RandomFloatRange(bombVelOffsetMin[1], bombVelOffsetMax[1]), RandomFloatRange(bombVelOffsetMin[2], bombVelOffsetMax[2]) );
	bomb = self launchbomb( "mk82_mp", origin + offset, velocity + vel_offset );
	bomb thread debug_draw_bomb_path(true);
}
bombsAway( owner )
{
	owner endon("disconnect");
	bombCount = 10;
	bombSpacingMin = 0.05;
	bombSpacingMax = 0.2;
	
	for ( i = 0; i < bombCount; i++ )
	{
		bombVelocity = getbombVelocity( self.angles, level.bomberFlightPlan.speed, level.bomberFlightPlan.bombSpeedScale );
		
		owner dropBomb( self.origin, bombVelocity );
		
		wait(RandomFloatRange(bombSpacingMin, bombSpacingMax));
	}
}
bomberDamageEntsThread()
{
	self notify ( "bomberDamageEntsThread" );
	self endon ( "bomberDamageEntsThread" );
	for ( ; level.bomberDamagedEntsIndex < level.bomberDamagedEntsCount; level.bomberDamagedEntsIndex++ )
	{
		if ( !isDefined( level.bomberDamagedEnts[level.bomberDamagedEntsIndex] ) )
			continue;
		ent = level.bomberDamagedEnts[level.bomberDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( ( !ent.isPlayer && !ent.isActor ) || isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, 
				ent.damageOwner, 
				ent.damage, 
				"MOD_PROJECTILE_SPLASH", 
				"bomber_mp", 
				ent.pos, 
				vectornormalize(ent.damageCenter - ent.pos) 
			);			
			level.bomberDamagedEnts[level.bomberDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer || ent.isActor )
				wait ( 0.05 );
		}
		else
		{
			level.bomberDamagedEnts[level.bomberDamagedEntsIndex] = undefined;
		}
	}
}
doBomber( origin, owner, team )
{
	targetPoint = maps\mp\_airsupport::determineTargetPoint( owner, origin );
	debug_line( targetPoint + (0,0,1000), targetPoint + (0,0,-1000), (1,0,0) );
	debug_star( targetPoint, (1,0,0) );
	
	
	owner maps\mp\gametypes\_hardpoints::playKillstreakStartDialog( "bomber_mp", team );
	owner maps\mp\gametypes\_persistence::statAdd( "BOMBER_USED", 1, false );
	wait 2;
	if ( !isDefined( owner ) )
	{
		level.airSupportInProgress = undefined;
		return;
	}
	
	owner notify ( "begin_bomber" );
	
	if ( !IsDefined(level.bomberFlightPlan) )
	{
		level.bomberFlightPlan =  SpawnStruct();
	}
	level.bomberFlightPlan.distance = getDvarIntDefault( #"scr_bomber_distance", 48000 );
	level.bomberFlightPlan.height = getDvarIntDefault( #"scr_bomber_height", 4000 );
	level.bomberFlightPlan.speed = getDvarIntDefault( #"scr_bomber_speed", 2000 );
	level.bomberFlightPlan.bombSpeedScale = getDvarIntDefault( #"scr_bomber_bomb_speed_scale", 1 );
	level.bomberFlightPlan.target = targetPoint;
	level.bomberFlightPlan.owner = owner;
	level.bomberFlightPlan.yaw = "random";
	level.bomberFlightPlan.planeSpawnCallback = ::planeSpawnedCallback;
	
	
	
	level.bomberFlightPlan.planeSpacing = ( calculateFallTime( level.bomberFlightPlan.height ) + 1 );
	
	maps\mp\_airsupport::callStrike( level.bomberFlightPlan );
	
	wait 8.5;
	
	level.airSupportInProgress = undefined;
}
bomber_attachPlayer( player )
{
	player endon("disconnect");
	player endon("death");
		
	player takeAllWeapons();
	player giveWeapon( "mk82_mp" );
	player switchToWeapon( "mk82_mp" );
	player setClientDvar( "cg_fov", getDvarIntDefault( #"scr_bomber_fov", 30 ) );
	player overlay();
	
	origin = player.origin;
	angles = player.angles;
	
	self attachPlayer( player );
	
	player thread changePlanes();
	self thread bomber_dettachPlayer( player, origin, angles );
	self thread bomber_dettachPlayerEarlyWaiter( player );
	self thread bomber_dettachPlayerOnPlaneDeleteWaiter( player );
}
bomber_dettachPlayerEarlyWaiter( player )
{
	player endon("disconnect");
	player endon("bombing_done");
	for(;;)
	{
		while( !player FragButtonPressed() )
			wait 0.05;
			
		player notify("bombing_done");
		return;
	}
}
bomber_dettachPlayerOnPlaneDeleteWaiter( player )
{
	player endon("disconnect");
	player endon("bombing_done");
	self waittill( "delete" );
	
	player notify("bombing_done");
}
bomber_dettachPlayer( player, origin, angles )
{
	player waittill("bombing_done");
	player Unlink();
	
	player SetOrigin( origin );
	player.angles = angles;
	
	player setClientDvar( "cg_fov", 65 );	
	player.currentPlane = undefined;
}
attachPlayer(player)
{
	
	falltime = calculateFallTime( level.bomberFlightPlan.height );
	bomb_x = (level.bomberFlightPlan.speed * level.bomberFlightPlan.bombSpeedScale) * falltime;
	
	player_offset = ( getDvarIntDefault( #"scr_bomber_playerx", -1000 ), 0, getDvarIntDefault( #"scr_bomber_playerz", -100 ) );
	if ( player_offset[0] > bomb_x )
		player_offset[0] = bomb_x;
		
	angles = ( ATan( (level.bomberFlightPlan.height + player_offset[2] ) / (  bomb_x - player_offset[0] ) ), 0, 0 );
	
	player playerLinkToDelta (self, "tag_origin", 1.0, 0, 0, 0, 0, false, player_offset, angles);
	
	
	player_point = self.origin + RotatePoint(player_offset, self.angles);
	target_point = player_point + RotatePoint(vector_scale( anglestoforward( angles ), 10000), self.angles);
	debug_star( player_point, (0,0,1) );
	debug_line( player_point, target_point, (0,0,1) );
	
	player.currentPlane = self;
}
getNextPlane( lastPlane, do_not_wrap )
{
	currentPlaneIndex = 0;
	if ( IsDefined( lastPlane ) )
	{
		for ( i = 0; i < level.bomberPlanes.size; i++ )
		{
			if ( lastPlane == level.bomberPlanes[i] )
			{
				currentPlaneIndex = i;
				break;
			}
		}
	}
	
	if ( !IsDefined(do_not_wrap) || do_not_wrap == false )
	{
		nextPlaneIndex = ( currentPlaneIndex + 1 ) % level.bomberPlanes.size;
	}
	else
	{
		nextPlaneIndex = currentPlaneIndex + 1;
		if ( nextPlaneIndex >= level.bomberPlanes.size )
		{
			nextPlaneIndex = level.bomberPlanes.size - 1;
		}
	}
	Assert( nextPlaneIndex >= 0 && nextPlaneIndex < level.bomberPlanes.size );
	
	return level.bomberPlanes[nextPlaneIndex];
}
changePlanes()
{
	self endon("disconnect");
	self endon("death");
	self endon("bombing_done");
	
	for(;;)
	{
		while( !self useButtonPressed() )
			wait 0.05;
		
		plane = getNextPlane(self.currentPlane);
		
		plane attachPlayer( self );
		
		while( self useButtonPressed() )
			wait 0.05;
	}
}
overlay()
{
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
	self thread destroy_overlay_on_bombing_done(bomber_overlay,bomber_grain );
	self thread destroy_overlay_on_death(bomber_overlay,bomber_grain );
}
destroy_overlay_on_death(bomber_overlay,bomber_grain )
{
	self endon("disconnect");
	self endon("bombing_done");
	
	self waittill("death");
	
	bomber_overlay Destroy();
	bomber_grain Destroy();
}
destroy_overlay_on_bombing_done(bomber_overlay,bomber_grain )
{
	self endon("disconnect");
	self endon("death");
	
	self waittill("bombing_done");
	
	bomber_overlay Destroy();
	bomber_grain Destroy();
}
checkPlayersTinitus ( bomsite )
{
  players = get_players();
 
  for ( i = 0; i < players.size; i++ )
	{
		area = 1000 * 1000;
		if (isdefined (bomsite))
		{
			if ( DistanceSquared( bomsite.origin, self.origin ) < area )		
			{
				self playlocalsound("mpl_kls_exlpo_tinitus");	
			}
		}			
	}	
}  
