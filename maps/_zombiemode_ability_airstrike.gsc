
#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_ability_airsupport;
init()
{
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheModel( "t5_veh_jet_mig17" );
	precacheShader( "zom_ability_airstrike_active" );
	precacheShader( "zom_ability_airstrike_not_active" );
	precacheShader( "zom_ability_airstrike_busy" );
	level._effect["target_arrow_green"]			= loadfx("misc/fx_zombie_ui_airstrike_smk_grn");
	level._effect["target_arrow_yellow"]		= loadfx("misc/fx_zombie_ui_airstrike_smk_yellow");
	level._effect["target_arrow_red"]			= loadfx("misc/fx_zombie_ui_airstrike_smk_red");
	level._effect["jet_trail"]					= loadfx("trail/fx_geotrail_jet_contrail");
	level._effect["airstrike_afterburner"]		= loadfx("vehicle/exhaust/fx_exhaust_jet_afterburner");
	level._effect["jet_bomb"]					= loadfx("weapon/clusterbomb/fx_clusterbomb_mp");
	level._effect["bomb_explosion"]				= loadfx("weapon/clusterbomb/fx_clusterbomb_exp_mp");
	level.airstrikeDangerMaxRadius = 750;
	level.airstrikeDangerMinRadius = 300;
	level.airstrikeDangerForwardPush = 1.5;
	level.airstrikeDangerOvalScale = 6.0;
	level.airstrikeMapRange = level.airstrikeDangerMinRadius * .3 + level.airstrikeDangerMaxRadius * .7;	
	level.airstrikeDangerMaxRadiusSq = level.airstrikeDangerMaxRadius * level.airstrikeDangerMaxRadius;	
	level.airstrikeDangerCenters = [];
	level.airstrike_traceLength = 4000;			
}
call_airstrike( pos )
{
	set_airstrike_status( "busy" );
	
	trace = bullettrace( self.origin + (0,0,10000), self.origin, false, undefined );
	pos = (pos[0], pos[1], trace["position"][2] - 514);
	
	thread doAirstrike( pos, self, self.pers["team"] );
}
callStrike_planeSound( plane, bombsite )
{
	plane endon("death");
	
	plane thread play_loop_sound_on_entity( "mpl_kls_veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	
	
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	
	while( targetisclose( plane, bombsite ) )
		wait .05;
	
	
	plane waittill( "delete" );
	plane notify ( "stop sound" + "mpl_kls_veh_mig29_dist_loop" );
}
callAirStrike( owner, coord, yaw )
{	
	level.airstrikeDamagedEnts = [];
	level.airstrikeDamagedEntsCount = 0;
	level.airstrikeDamagedEntsIndex = 0;
	
	direction = ( 0, yaw, 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 2000;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;
	if ( isdefined( level.airstrikeHeightScale ) )
	{
		planeFlyHeight *= level.airstrikeHeightScale;
	}
	
	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );
	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	
	d = abs( d/2 - planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	owner endon("disconnect");
	
	requiredDeathCount = owner.deathCount;
	
	level.airstrikeDamagedEnts = [];
	level.airstrikeDamagedEntsCount = 0;
	level.airstrikeDamagedEntsIndex = 0;
	
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 5.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 5.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 5.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint, endPoint, bombTime, flyTime, direction );
}
getBestPlaneDirection( hitpos )
{
	return self.angles[1]+RandomFloatRange(-15, 15);
}
playPlaneFx()
{
	self endon ( "death" );
	playfxontag( level._effect["airstrike_afterburner"], self, "tag_engine" );
	playfxontag( level._effect["jet_trail"], self, "tag_right_wingtip" );
	playfxontag( level._effect["jet_trail"], self, "tag_left_wingtip" );
}
spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" ); 
	return bomb;
}
callStrike_bombEffect( plane, pathEnd, flyTime, launchTime, owner, requiredDeathCount )
{
	wait ( launchTime );
	
	plane thread playSoundinSpace( "mpl_kls_veh_mig29_sonic_boom" );
	planedir = anglesToForward( plane.angles );
	
	
	bomb = spawnbomb( plane.origin, plane.angles );
	bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 7000/4.0 ), 3.0 );
	
	bomb.ownerRequiredDeathCount = requiredDeathCount;
	
 	
 	wait (1.0);
	
	newBomb = spawn( "script_model", bomb.origin );
	newBomb setModel( "tag_origin" );
	newBomb.origin = bomb.origin;
	newBomb.angles = bomb.angles;
 	bomb setModel( "tag_origin" );
	wait (0.10);  
	
	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	playfxontag( level._effect["jet_bomb"], newBomb, "tag_origin" );
	wait 0.5;
	
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;
	
	hitpos = (0,0,0);
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		hitpos += traceHit;
		
		
		
		thread losRadiusDamage( traceHit + (0,0,16), 1512, 1200, 30, owner, newBomb ); 
	
		if ( i%3 == 0 )
		{
			thread playsoundinspace( "mpl_kls_artillery_impact", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
		}
		
		wait ( 0.05 );
	}
	
	hitpos = hitpos / repeat + (0,0,128);
	
	wait ( 5.0 );
	newBomb delete();
	
	bomb delete();
}
doPlaneStrike( owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction )
{
	
	
	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	
	plane = spawn( "script_model", pathStart );
	plane setModel( "t5_veh_jet_mig17" );
	plane.angles = direction;
	
	forward = anglesToForward( direction );
	plane thread playPlaneFx();
	
	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	
	thread callStrike_planeSound( plane, bombsite );
	
	thread callStrike_bombEffect( plane, pathEnd, flyTime, bombTime, owner, requiredDeathCount );
	
	
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}
airstrikeDamageEntsThread()
{
	self notify ( "airstrikeDamageEntsThread" );
	self endon ( "airstrikeDamageEntsThread" );
	for ( ; level.airstrikeDamagedEntsIndex < level.airstrikeDamagedEntsCount; level.airstrikeDamagedEntsIndex++ )
	{
		if ( !isDefined( level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] ) )
			continue;
		ent = level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( !ent.isPlayer || isAlive( ent.entity ) )
		{
			ent maps\_weapons::damageEnt(
				ent.eInflictor, 
				ent.damageOwner, 
				ent.damage, 
				"MOD_PROJECTILE_SPLASH", 
				"zombie_airstrike", 
				ent.pos, 
				vectornormalize(ent.damageCenter - ent.pos) 
			);			
			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer )
				wait ( 0.05 );
		}
		else
		{
			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
		}
	}
}
losRadiusDamage(pos, radius, max, min, owner, eInflictor)
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
		damage = int(max + (min-max)*dist/radius);
		if ( isDefined( ents[i].entity.maxAirstrikeDamage ) )
		{
			damage = min( damage, ents[i].entity.maxAirstrikeDamage );
		}
		ents[i].damage = damage;
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.airstrikeDamagedEnts[level.airstrikeDamagedEntsCount] = ents[i];
		level.airstrikeDamagedEntsCount++;
	}
	
	thread airstrikeDamageEntsThread();
}
pointIsInAirstrikeArea( point, targetpos, yaw )
{
	return distance2d( point, targetpos ) <= level.airstrikeDangerMaxRadius * 1.25;
}
doAirstrike(origin, owner, team)
{
	num = 17 + randomint(3);
	trace = bullettrace(origin, origin + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	
	yaw = getBestPlaneDirection( targetpos );
	
	if ( !isDefined( owner ) )
	{
		level.airSupportInProgress = undefined;
		return;
	}
	
	owner notify ( "begin_airstrike" );
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = anglesToForward( (0,yaw,0) );
	level.airstrikeDangerCenters[ level.airstrikeDangerCenters.size ] = dangerCenter;
	
	callAirStrike( owner, targetpos, yaw );
	wait 6.5;
	flag_set("end_target_confirm");
	found = false;
	newarray = [];
	for ( i = 0; i < level.airstrikeDangerCenters.size; i++ )
	{
		if ( !found && level.airstrikeDangerCenters[i].origin == targetpos )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.airstrikeDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.airstrikeDangerCenters.size - 1 );
	level.airstrikeDangerCenters = newarray;
	set_airstrike_status( "available" );
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
set_airstrike_status( status )
{
	switch( status )
	{
	case "available":
		level.airSupportInProgress = undefined;
		level._abilities[ "zombie_airstrike" ].in_use = false;
		break;
	case "busy":
		level.airSupportInProgress = true;
		level._abilities[ "zombie_airstrike" ].in_use = true;
		break;
	case "update":
	default:
		break;
	}
	players = get_players();
	array_thread( players, maps\_zombiemode_ability::update_player_ability_status );
}  
