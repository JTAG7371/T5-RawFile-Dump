#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_ability_airsupport;
init()
{
	
	
	
	
	
	
	
	
	
	level.napalmDangerMaxRadius = 750;
	level.napalmDangerMaxRadiusSq = level.napalmDangerMaxRadius * level.napalmDangerMaxRadius;	
	
	PreCacheItem( "zombie_napalmflare" );
	
	alliesplaneModel = "t5_veh_jet_f4_gearup";
	level.debugPlaneModel = alliesplaneModel;
	axisplaneModel  = "t5_veh_jet_mig17";
	precacheModel( alliesplaneModel );
	precacheModel( axisplaneModel );
	
	level.fx_jet_trail = loadfx("trail/fx_geotrail_jet_contrail");
	level.fx_jet_afterburner = loadfx("vehicle/exhaust/fx_exhaust_jet_afterburner");
	level.fx_napalm_bomb = loadfx ("weapon/napalm/fx_napalm_drop_mp");
	level.fx_napalm_explosion = loadfx ("weapon/napalm/fx_napalm_trail_em_sm_mp");
	level.fx_napalm_smoke = loadfx ("weapon/napalm/fx_napalm_trail_em_lg_mp");
	level.fx_napalm_no_smoke = loadfx ("weapon/napalm/fx_napalm_ground_burst_mp");
	level.fx_napalm_marker = loadfx ("weapon/napalm/fx_napalm_marker_mp");
	
	
	
	level.fx_flame_lg = "zombie_napalmground_lg";
	level.fx_flame_sm = "zombie_napalmground_sm";
	
	precacheItem( level.fx_flame_lg );
	precacheItem( level.fx_flame_sm );
	
	burnNapalmEffectRadiusSmall = getDvarIntDefault( #"scr_burnNapalmEffectRadiusSmall", 100.0 );
	burnNapalmEffectRadiusLarge = getDvarIntDefault( #"scr_burnNapalmEffectRadiusLarge", 150.0 );
	
	level.burnNapalmEffectRadiusSmall = 100;
	level.burnNapalmEffectRadiusLarge = 200;
	level.burnNapalmDuration = 8;
	level.napalmGroundDamage = 20;
	level.groundBurnTime = 3; 
		
	setupTimers();
}
useNapalm( posStart, yaw )
{
	if ( !IsDefined( yaw ) )
		yaw = 0;
	set_napalm_status( "busy" );
	trace = bullettrace( self.origin + (0,0,10000), self.origin, false, undefined );
	posStart = (posStart[0], posStart[1], trace["position"][2] - 514);
	
	thread doNapalm( posStart, yaw, self, self.pers["team"] );
}
callNapalmStrike( owner, coord, yaw )
{	
	level.napalmDamagedEnts = [];
	level.napalmDamagedEntsCount = 0;
	level.napalmDamagedEntsIndex = 0;
	
	
	
	direction = ( 0, yaw, 0 );
	debugDirection = direction;
	
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;	
	planeFlySpeed = 7000;
	if ( isdefined( level.airsupportHeightScale ) )
	{
		planeFlyHeight *= getDvarIntDefault( #"scr_airsupportHeightScale", level.airsupportHeightScale );	
	}
	
	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	
	if ( isdefined( level.forceAirsupportMapHeight ) )
	{
		startPoint = ( startPoint[0], startPoint[1], level.forceAirsupportMapHeight );
		endPoint = ( endPoint[0], endPoint[1], level.forceAirsupportMapHeight );
		coord  = ( coord[0], coord[1], level.forceAirsupportMapHeight );
	}	
	startPoint += ( 0, 0, planeFlyHeight );	
	endPoint += ( 0, 0, planeFlyHeight );
	
	
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	owner endon("disconnect");
	
	requiredDeathCount = owner.deathCount;
	
	flarePlane = Spawn( "script_model", startPoint );
	
	plane = Spawn( "script_model", startPoint );
	plane.angles = direction;
	
	team = owner.pers["team"];
	planeModel = "t5_veh_jet_mig17";
	
	flarePlane.angles = direction;
	
	
	
	
	flarePlane moveTo( endPoint, flyTime, 0, 0 );
	
	level thread releaseFlare( owner, flareplane, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction, planeFlyHeight );
	
	timeIncreaseBetweenPlanes = 3;
	wait ( timeIncreaseBetweenPlanes );
	
	plane moveTo( endPoint, flyTime, 0, 0 );
	
	level.napalmDamagedEnts = [];
	level.napalmDamagedEntsCount = 0;
	level.napalmDamagedEntsIndex = 0;
	
	level thread releaseNapalm( owner, plane, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction, yaw, planeFlyHeight );
	wait(0.2);
	level thread releaseNapalm( owner, plane, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction, yaw, planeFlyHeight );
	wait (0.2);
	level thread releaseNapalm( owner, plane, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction, yaw, planeFlyHeight );
	
	wait flyTime;
	plane notify( "delete" );
	plane delete();
	flareplane delete();
}
callStrike_bombEffect( plane, pathEnd, flyTime, launchTime, owner, requiredDeathCount, yaw, planeFlyHeight )
{	
	fxTimer = 0.15;
	bombSpeedScale = 1/2;
	planeflyspeed = 7000;
	
	
	
	
	
	
	
	
	
	
	
	bombWait = calculateReleaseTime( flyTime, planeFlyHeight, planeflyspeed, bombSpeedScale );
	wait ( bombWait );
	
	
	planedir = anglesToForward( plane.angles );
	killcamheightIncrease = ( 0, 0, 0 );
	if ( !isdefined(level.airsupportHeightScale) )
		killcamheightIncrease = ( 0, 0, 850 );
	
	
	velocity = vector_scale( anglestoforward( plane.angles ), planeflyspeed*bombSpeedScale );
	
	bomb = owner launchbomb( "zombie_napalm", plane.origin, velocity );
	bomb endon ( "napalmImpactedEarly" );
	bomb thread detonateOnImpact( owner );
	
	
	killCamEnt = spawn( "script_model", bomb.origin );
			
	killCamEnt thread deleteAfterTime( 15.0 );
	killCamEnt.startTime = gettime();
	killCamEnt linkto(bomb);
	
	fxTimer = calculateFallTime( planeFlyHeight ) - 0.25;
	killCamEnt thread unlinkKillcam(fxTimer);
	
	bomb.killCamEnt = killCamEnt;
	bomb.ownerRequiredDeathCount = requiredDeathCount;
		
	bomb thread debug_draw_bomb_path();
	
	
	maxX = getDvarIntDefault( #"scr_napalm_x", 10.0 );
	x = 0;
	
	z = getDvarIntDefault( #"scr_napalm_z", 15.0 );
	originalAngles = bomb.angles;
		
	looptime = 0.0;
	while( loopTime < fxTimer )	
	{
		wait (0.05);
		loopTime += 0.05;
		bomb.angles = ( bomb.angles[0] + x, bomb.angles[1], bomb.angles[2] + z);
		if ( x < maxX ) 
			x+=0.5;
	}
	bomb notify ( "stopDetonateOnImpact" );
	
	newBomb = spawn( "script_model", bomb.origin );
 	newBomb setModel( "tag_origin" );
  	newBomb.origin = bomb.origin;
  	newBomb.angles = originalAngles;
	bomb setModel( "tag_origin" );
	
	wait (0.10);  
	
	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	playfxontag( level.fx_napalm_bomb, newBomb, "tag_origin" );
	
	newBomb playsound ("mpl_kls_napalm_exlpo");
	newBomb playloopsound ("mpl_kls_napalm_fire");
	
	wait 0.5;
	repeat = 8;
	
	minAngle = 5;
	maxAngle = 45;
	
	
	if ( isdefined( level.napalmFlameMinAngle ) )
		minAngle = level.napalmFlameMinAngle;
	if ( isdefined( level.napalmFlameMaxAngle ) )
		maxAngle = level.napalmFlameMaxAngle;
	
	minAngles = getDvarIntDefault( #"scr_napalm_minAngles", minAngle );
	maxAngles = getDvarIntDefault( #"scr_napalm_maxAngles", maxAngle );
	angleDiff = (maxAngles - minAngles) / repeat;
	
	hitpos = (0,0,0);
	previousHeight = 0;
	
	
	traceDir = anglesToForward( originalAngles + (maxAngles-(angleDiff * (repeat/2)),0,0) );
	traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
	trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
	
	groundflamekillcament = Spawn( "script_model", trace["position"] );
	groundflamekillCamEnt thread deleteAfterTime( 15.0 );
		
	
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( originalAngles + (maxAngles-(angleDiff * i),0,0) );
		traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		hitpos += traceHit;
		hitNormal = trace["normal"];
		currentHeight = traceHit[2];
		thread debug_line( bombOrigin, traceHit, (1,0,0), 20 );
				
		if ( hitNormal[2] > 0.5 ) 
		{
			fxToPlay = level.fx_flame_sm;
			burnNapalmEffectRadius = getDvarIntDefault( #"scr_burnNapalmEffectRadiusSmall", level.burnNapalmEffectRadiusSmall);
			if ( i > 0 && i < repeat - 1 )
			{
				heightDifference = previousHeight - currentHeight;
				if ( heightDifference < 12 && heightDifference > -12 )
					fxToPlay = level.fx_flame_lg;
					burnNapalmEffectRadius = getDvarIntDefault( #"scr_burnNapalmEffectRadiusLarge", level.burnNapalmEffectRadiusLarge);
			}
			
			
			thread losRadiusDamage( traceHit + (0,0,16), 1512, 1200, 30, owner, newBomb, hitNormal, i, fxToPlay, yaw, burnNapalmEffectRadius, groundflamekillCamEnt ); 
	
		
			if ( i%3 == 0 )
			{
				playRumbleOnPosition( "artillery_rumble", traceHit );
				earthquake( 0.7, 0.75, traceHit, 1000 );
			}
		}
		
		previousHeight = currentHeight;
		
		wait ( 0.1 );
	}
	
	hitpos = hitpos / repeat + (0,0,128);
	
	wait ( 11.0 );
	
	if( isdefined(newBomb) )
	{
		newBomb stoploopsound (2);  
		
		newBomb Delete();
	}
	wait ( 4.0 );
}
detonateOnImpact( owner )
{
	self endon ( "stopDetonateOnImpact" );
	self endon ( "delete" );
	while (1)
	{
		owner waittill( "projectile_impact", name, position, explosionRadius, ent );
		if ( ent == self )
		{
			self notify ( "napalmImpactedEarly" );
			break;
		}
	}
}
unlinkKillcam(fxTimer)
{
	if ( fxTimer > 1.0 )
	 wait ( fxTimer - 0.25 );
	
	self unlink();
}
callStrike_flareEffect( plane, pathEnd, flyTime, owner, planeFlyHeight )
{	
	planeflyspeed = 7000;
	flareSpeedScale = 1/3;
	flareWait = calculateReleaseTime( flyTime, planeFlyHeight, planeflyspeed, flareSpeedScale );
	
	wait ( flareWait );
	planedir = anglesToForward( plane.angles );
	
	velocity = vector_scale( anglestoforward( plane.angles ), planeflyspeed*flareSpeedScale );
	flare = owner launchbomb( "zombie_napalmflare", plane.origin, velocity );
	
	owner waittill( "projectile_impact", name, position, explosionRadius );
	
	
	playfx(level.fx_napalm_marker, position );
	
	snd_flare_ent = spawn ("script_origin", position);
	snd_flare_ent playloopsound("mpl_kls_marker_loop");
	wait(5);
	snd_flare_ent delete();
}
releaseNapalm( owner, plane, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction, yaw, planeFlyHeight )
{
	
	
	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint;
	pathEnd   = endPoint;
	
	forward = anglesToForward( direction );
	
	
	thread callStrike_bombEffect( plane, pathEnd, flyTime, bombTime - 1.0, owner, requiredDeathCount, yaw, planeFlyHeight );
}
releaseFlare( owner, plane, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction, planeFlyHeight )
{
	
	
	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint;
	pathEnd   = endPoint;
	
	forward = anglesToForward( direction );
	
	thread debug_line( pathStart, pathEnd, (1,1,1), 10 );
	
	thread callStrike_flareEffect( plane, pathEnd, flyTime, owner, planeFlyHeight );
}
napalmDamageEntsThread()
{
	self notify ( "napalmDamageEntsThread" );
	self endon ( "napalmDamageEntsThread" );
	
	for ( ; level.napalmDamagedEntsIndex < level.napalmDamagedEntsCount; level.napalmDamagedEntsIndex++ )
	{
		if ( !isDefined( level.napalmDamagedEnts[level.napalmDamagedEntsIndex] ) )
			continue;
		ent = level.napalmDamagedEnts[level.napalmDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
		
		if ( !ent.isPlayer || isAlive( ent.entity ) )
		{
			ent maps\_weapons::damageEnt(
				ent.eInflictor, 
				ent.damageOwner, 
				ent.damage, 
				"MOD_BURNED", 
				"zombie_napalm", 
				ent.pos, 
				vectornormalize(ent.damageCenter - ent.pos) 
			);			
			level.napalmDamagedEnts[level.napalmDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer )
				wait ( 0.05 );
		}
		else
		{
			level.napalmDamagedEnts[level.napalmDamagedEntsIndex] = undefined;
		}
	}
}
losRadiusDamage(pos, radius, max, min, owner, eInflictor, normal, waitframes, fxToPlay, yaw, burnNapalmEffectRadius, groundflamekillCamEnt )
{
	ents = maps\_weapons::getDamageableEnts(pos, radius, true);
	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;
		
		dist = distance(pos, ents[i].damageCenter);
		
		
		if ( ents[i].isPlayer )
		{
			continue;
		}
		ents[i].damage = int(max + (min-max)*dist/radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.napalmDamagedEnts[level.napalmDamagedEntsCount] = ents[i];
		level.napalmDamagedEntsCount++;
	}
		
	thread napalmDamageEntsThread();
	if ((0.5 - (waitframes * 0.1)) > 0)
		wait (0.5 - (waitframes * 0.1));
		
	fxAngles = ( 270, yaw-180, 0 );
	spawnapalmgroundflame( pos-(0,0,16), fxToPlay, fxAngles);
	
	watchNapalmBurn( owner, groundflamekillCamEnt, pos, burnNapalmEffectRadius );
}
	
watchNapalmBurn( owner, eInflictor, pos, burnNapalmEffectRadius )
{	
	napalmGroundBurnArea = spawn("trigger_radius", pos, 0, burnNapalmEffectRadius, burnNapalmEffectRadius*2);
	loopWaitTime = 0.25;
	
	
	burnNapalmDuration =  getDvarIntDefault( #"scr_burnNapalmDuration", level.burnNapalmDuration);
	
	napalmBurnDist2 = burnNapalmEffectRadius * burnNapalmEffectRadius;
	
	while ( burnNapalmDuration > 0 )
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{	
			if (!isDefined(players[i].item))
			{
				players[i].item = 0;
			}	
			if ( ( !isDefined ( players[i].inGroundNapalm ) )  || ( players[i].inGroundNapalm == false ) )
			{
				if (players[i].sessionstate == "playing" )
				{
					
					
					dist2 = DistanceSquared( players[i].origin, pos );
					if ( dist2 < napalmBurnDist2 )
					{
						
						
							players[i].napalmlastburntby = owner;
	
						
					}
				}	
			}
			
		}
		wait (loopWaitTime);
		burnNapalmDuration -= loopWaitTime;
	}
	
	napalmGroundBurnArea delete();	
}
pointIsInAirstrikeArea( point, targetpos, yaw )
{
	return distance2d( point, targetpos ) <= level.airstrikeDangerMaxRadius * 1.25;
}
doNapalm(posStart, yaw, owner, team)
{
	targetpos = ( posStart[0], posStart[1], 0 );
	
	yaw = maps\_zombiemode_ability_airstrike::getBestPlaneDirection( targetpos );
			
	
	
	if ( !isDefined( owner ) )
	{
		level.airSupportInProgress = undefined;
		return;
	}
	
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) 
			{
	
	
			}
		}
	
	owner notify ( "begin_napalm" );
	
	
	ownerEntNum = owner GetEntityNumber();
	exitType = owner getPlaneExitType();
	
	
	yaw_offset = 0;
	for( i=0; i<2; i++ )
	{
		
		owner playClientNapalm( targetpos, int(yaw), "axis", "free", ownerEntNum, exitType );
		callNapalmStrike( owner, targetpos, yaw + yaw_offset );
		
		
		dx = randomfloatrange( -1, 1 );
		dy = randomfloatrange( -1, 1 );
		new_pos = ( targetpos[0]+dx, targetpos[1]+dy, targetpos[2] );
		targetpos = new_pos;
						
		yaw_offset += randomfloatrange( -15, 15 );
						
		wait( 8 );	
	}
	
	wait 2.0;
	
	flag_set("end_target_confirm");
	
	level.airSupportInProgress = undefined;
	set_napalm_status( "available" );
}
playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}
targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}
targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}
flaten_vector(vector)
{
	flatVec = (vector[0],vector[1],0);
	return flatVec;
}
getPlaneExitType()
{
	exitType = "straight";
	rank = self getScoreRank();	
	
	players = get_players();
	if ( isdefined(rank) )
	{	
		
		
		if ( rank / players.size > 0.6 )
			exitType = "left";
		else if ( rank / players.size > 0.2 )
			exitType = "right";
	}
	return exitType;	
}
getScoreRank()
{
	players = get_players();
	rank = players.size;
	
	if ( !isDefined( self.score ) || self.score < 1)
		return undefined;
	
	for( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) ||  players[i].score < 1)
		{
			rank--;
			continue;
		}
			
		if ( players[i].score < self.score )
		{
			rank--;
		}
	}
	return rank;
}
set_napalm_status( status )
{
	switch( status )
	{
	case "available":
		level.napalmInProgress = undefined;
		level._abilities[ "zombie_napalm" ].in_use = false;
		break;
	case "busy":
		level.napalmInProgress = true;
		level._abilities[ "zombie_napalm" ].in_use = true;
		break;
	case "update":
	default:
		break;
	}
	players = get_players();
	array_thread( players, maps\_zombiemode_ability::update_player_ability_status );
}  
