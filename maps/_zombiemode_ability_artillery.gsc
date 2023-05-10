#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_ability_airsupport;
init()
{
	
	
	
	
	
	level.artilleryDangerMaxRadius = 750;
	level.artilleryDangerMinRadius = 300;
	level.artilleryDangerForwardPush = 1.5;
	level.artilleryDangerOvalScale = 6.0;
	level.artilleryCanonShellCount =  5;
	level.artilleryCanonCount = 5;
	level.artilleryShellsInAir = 0;
	level.artilleryMapRange = level.artilleryDangerMinRadius * .3 + level.artilleryDangerMaxRadius * .7;
	level.artilleryDangerMaxRadiusSq = level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius;
	level.artilleryDangerCenters = [];
	level.artilleryfx = loadfx ("weapon/artillery/fx_artillery_strike_dirt_mp");	
	
	precacheShellshock("artilleryblast_friendly");
	precacheShellshock("artilleryblast_enemy");
	precacheLocationSelector( "map_artillery_selector" );
}
useArtillery( pos )
{
	level.artilleryInProgress = true;
	level._abilities[ "zombie_artillery" ].in_use = true;
	
	trace = bullettrace( self.origin + (0,0,10000), self.origin, false, undefined );
	pos = (pos[0], pos[1], trace["position"][2] - 514);
 	ownerDeathCount = 0;
	teamType = "none";
		
	thread doArtillery( pos, self, teamType, ownerDeathCount );
}
callStrike_bomb( bombTime, coord, repeat, owner )
{
	accuracyRadius = 512;
	
	for( i = 0; i < repeat; i++ )
	{
		randVec = ( 0, randomint( 360 ), 0 );
		bombPoint = coord + vector_scale( anglestoforward( randVec ), accuracyRadius );
		
		wait bombTime;
		
		thread playsoundinspace( "mpl_kls_artillery_impact", bombPoint );
		radiusArtilleryShellshock( bombPoint, 512, 8, 4);
		losRadiusDamage( bombPoint + (0,0,16), 768, 300, 50, owner); 
	}
}
startArtilleryCanon(  owner, coord, yaw, distance, initial_delay, ownerDeathCount)
{
	owner endon("disconnect");
	wait ( initial_delay );
	
	cannonAccuracyRadiusMin = 0;	 
	cannonAccuracyRadiusMax = 500; 
	shellAccuracyRadiusMin = 0;	 
	shellAccuracyRadiusMax = 520; 
	volleyCount = 1;
	volleyWaitMin = 1.2;
	volleyWaitMax = 1.6;
	shellWaitMin = 2;
	shellWaitMax = 4;
	requiredDeathCount = ownerDeathCount;
	
	for( volley = 0; volley < volleyCount; volley++ )
	{		
		volleyCoord = randPointRadiusAway( coord, randomfloatrange( cannonAccuracyRadiusMin, cannonAccuracyRadiusMax ) );
		for( shell = 0; shell < level.artilleryCanonShellCount; shell++ )
		{
			wait randomFloatRange( shellWaitMin, shellWaitMax );
			strikePos = randPointRadiusAway( volleyCoord, randomintrange( shellAccuracyRadiusMin, shellAccuracyRadiusMax ) );
			level thread doArtilleryStrike( owner, requiredDeathCount, strikePos, yaw, distance );
		}
		
		cannonAccuracyRadiusMin -= cannonAccuracyRadiusMin / (volleyCount - volley + 1);
		cannonAccuracyRadiusMax -= cannonAccuracyRadiusMax / (volleyCount - volley + 1);
		wait randomFloatRange( volleyWaitMin, volleyWaitMax );
	}
}
callArtilleryStrike( owner, coord, yaw, distance, ownerDeathCount )
{	
	owner endon("disconnect");
	level.artilleryDamagedEnts = [];
	level.artilleryDamagedEntsCount = 0;
	level.artilleryDamagedEntsIndex = 0;
	
	volleyCoord = coord;
	level.artilleryKillcamModelCounts = 0;
	
	minDistanceRandom = -100;
	maxDistanceRandom = 100;
	minYawRandom = 1;
	maxYawRandom = 3;	
	
	minInitialDelay = 0;
	maxInitialDelay = 1;
	
	for( i=0; i<8; i++ )
	{
		delay = RandomFloatRange( minInitialDelay, maxInitialDelay );
	
		thread startArtilleryCanon( owner, coord, yaw - RandomIntRange( minYawRandom, maxYawRandom ) , distance - RandomFloatRange( minDistanceRandom, maxDistanceRandom ), delay ,ownerDeathCount);
		
		wait( RandomIntRange(5,9) );
	}
	
	wait( 18 );
	level notify( "artillery_strike_complete" );
}
getBestFlakDirection( hitpos, team )
{
	targetname = "artillery_"+team;
	spawns = getentarray(targetname,"targetname");
	
	if ( !isdefined(spawns) || spawns.size == 0 )
	{
		origins = get_random_artillery_origins();
	}
	else
	{
		origins = get_origin_array( spawns );
	}
	
	closest_dist = 99999999*99999999;
	closest_index = randomint(origins.size);
	negative_t = false;
	
	for ( i = 0; i < origins.size; i++)
	{
		result = closest_point_on_line_to_point( hitpos, level.mapcenter, origins[i] );
		
		
		
		
		if ( result.t > 0 && negative_t )
			continue;
			
		if ( result.distsqr < closest_dist || (!negative_t && result.t < 0 ) )
		{
			closest_dist = result.distsqr;
			closest_index = i;
			
			if ( result.t < 0 )
			{
				negative_t = true;
			}
		}
	}
	spot = origins[closest_index];
	
	
	
  direction = level.mapcenter - spot ;
  
  angles = vectortoangles(direction);
  
  return angles[1];
} 
get_random_artillery_origins()
{
	
	
	
	maxs = level.nodesMaxs + ( 1000, 1000, 0);
	mins = level.nodesMins - ( 1000, 1000, 0);
	origins = [];
	
	x_length = abs( maxs[0] - mins[0] );
	y_length = abs( maxs[1] - mins[1]);
	major_axis = 0;
	minor_axis = 1;
	if ( y_length > x_length )
	{
		major_axis = 1;
		minor_axis = 0;
	}
	for ( i = 0; i < 3; i++ )
	{
		major_value = mins[major_axis] - randomfloatrange( mins[major_axis], level.mapcenter[major_axis]) * ( 2.0 );
		minor_value = randomfloatrange( mins[minor_axis], maxs[minor_axis]);
		 
		if ( major_axis == 0)
		{
			origins[origins.size] = ( major_value, minor_value, level.mapCenter[2] );
		}
		else
		{
			origins[origins.size] = ( minor_value, major_value, level.mapCenter[2] );
		}
		
		major_value = maxs[major_axis] + randomfloatrange( level.mapcenter[major_axis], maxs[major_axis]) * ( 2.0 );
		minor_value = randomfloatrange( mins[minor_axis], maxs[minor_axis]);
		 
		if ( major_axis == 0)
		{
			origins[origins.size] = ( major_value, minor_value, level.mapCenter[2] );
		}
		else
		{
			origins[origins.size] = ( minor_value, major_value, level.mapCenter[2] );
		}
	}
			
	return origins;
}
artilleryImpactEffects( )
{
	self endon("disconnect");
	self endon( "artillery_status_change" );
	while ( level.artilleryShellsInAir )
	{
		self waittill("projectile_impact", weapon, position, radius );
		
		if ( weapon == "zombie_artillery" )
		{
			playRumbleOnPosition( "artillery_rumble", position );
			radiusArtilleryShellshock( position, radius * 1.1, 3, 1.5, self );
			earthquake( 0.7, 0.75, position, 1000 );
		}
	}
}
callStrike_artilleryBombEffect( spawnPoint, bombdir, velocity, owner, requiredDeathCount, distance )
{
 	bomb_velocity = vector_scale(anglestoforward(bombdir), velocity);
	bomb = owner launchbomb( "zombie_artillery", spawnPoint, bomb_velocity );
	
	bomb.requiredDeathCount = requiredDeathCount;
	
	
	
	airTime = distance / ( velocity * cos( bombdir[0] ) );
	bomb thread referenceCounter();
	
	bombsite = spawnPoint + vector_scale( anglestoforward( (0,bombdir[1],0) ), distance );
	
	bomb thread debug_draw_bomb_path();
}
doArtilleryStrike( owner, requiredDeathCount, bombsite, yaw, distance )
{
	if ( !isDefined( owner ) ) 
		return;
	
		
	
	fireAngle = ( 0, yaw, 0 );
	firePos = bombsite + vector_scale( anglestoforward( fireAngle ), -1 * distance );
	
	
	
	pitch = GetDvarFloat( #"scr_artilleryAngle");
	if( pitch != 0 )
	{
		pitch *= -1;
	}
	else
	{
		pitch = -60;
	}
	pitch += randomintrange( -3, 3 );
	
	fireAngle += (pitch,0,0);
	
	
	
	gravity = GetDvarInt( #"bg_gravity" );
	velocity = sqrt( (gravity * distance) / sin( -2 * pitch ) );
	thread callStrike_ArtilleryBombEffect( firePos, fireAngle, velocity, owner, requiredDeathCount, distance );
	
	wait( 1.0 );
	
	flag_set("end_target_confirm");
}
artilleryShellshock(type, duration)
{
	if (isdefined(self.beingArtilleryShellshocked) && self.beingArtilleryShellshocked)
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingArtilleryShellshocked = false;
}
radiusArtilleryShellshock(pos, radius, maxduration, minduration, owner )
{
	players = GetPlayers();
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]))
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius) 
		{
			duration = int(maxduration + (minduration-maxduration)*dist/radius);
			
			
			{
				shock = "artilleryblast_enemy";
				players[i] thread artilleryShellshock(shock, duration);
			}
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
		
		if ( ents[i].isPlayer || ents[i].isActor )
		{
			
			indoors = !maps\_weapons::weaponDamageTracePassed( ents[i].entity.origin, ents[i].entity.origin + (0,0,130), 0, undefined );
			if ( !indoors )
			{
				indoors = !maps\_weapons::weaponDamageTracePassed( ents[i].entity.origin + (0,0,130), pos + (0,0,130 - 16), 0, undefined );
				if ( indoors )
				{
					
					dist *= 4;
					if ( dist > radius )
						continue;
				}
			}
		}
		ents[i].damage = int(max + (min-max)*dist/radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.artilleryDamagedEnts[level.artilleryDamagedEntsCount] = ents[i];
		level.artilleryDamagedEntsCount++;
	}
	
	thread artilleryDamageEntsThread();
}
artilleryDamageEntsThread()
{
	self notify ( "artilleryDamageEntsThread" );
	self endon ( "artilleryDamageEntsThread" );
	for ( ; level.artilleryDamagedEntsIndex < level.artilleryDamagedEntsCount; level.artilleryDamagedEntsIndex++ )
	{
		if ( !isDefined( level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] ) )
			continue;
		ent = level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( ( !ent.isPlayer && !ent.isActor ) || isAlive( ent.entity ) )
		{
			ent maps\_weapons::damageEnt(
				ent.eInflictor, 
				ent.damageOwner, 
				ent.damage, 
				"MOD_PROJECTILE_SPLASH", 
				"zombie_artillery", 
				ent.pos, 
				vectornormalize(ent.damageCenter - ent.pos) 
			);			
			level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer || ent.isActor )
				wait ( 0.05 );
		}
		else
		{
			level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] = undefined;
		}
	}
}
pointIsInArtilleryArea( point, targetpos )
{
	return distance2d( point, targetpos ) <= level.artilleryDangerMaxRadius * 1.25;
}
getSingleArtilleryDanger( point, origin, forward )
{
	center = origin + level.artilleryDangerForwardPush * level.artilleryDangerMaxRadius * forward;
	
	diff = point - center;
	diff = (diff[0], diff[1], 0);
	
	forwardPart = vectorDot( diff, forward ) * forward;
	perpendicularPart = diff - forwardPart;
	
	circlePos = perpendicularPart + forwardPart / level.artilleryDangerOvalScale;
	
	distsq = lengthSquared( circlePos );
	
	if ( distsq > level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius )
		return 0;
	
	if ( distsq < level.artilleryDangerMinRadius * level.artilleryDangerMinRadius )
		return 1;
	
	dist = sqrt( distsq );
	distFrac = (dist - level.artilleryDangerMinRadius) / (level.artilleryDangerMaxRadius - level.artilleryDangerMinRadius);
	
	assertEx( distFrac >= 0 && distFrac <= 1, distFrac );
	
	return 1 - distFrac;
}
getArtilleryDanger( point )
{
	danger = 0;
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		origin = level.artilleryDangerCenters[i].origin;
		forward = level.artilleryDangerCenters[i].forward;
		
		danger += getSingleArtilleryDanger( point, origin, forward );
	}
	return danger;
}
doArtillery(origin, owner, team, ownerDeathCount )
{	
	self notify( "artillery_status_change", owner );
	trace = bullettrace(origin, origin + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	
	
	if ( targetpos[2] < origin[2] - 9999 )
	{
		if ( isdefined( owner ) )
		{
			targetpos = ( targetpos[0], targetpos[1], owner.origin[2]);
		}
		else
		{
			targetpos = ( targetpos[0], targetpos[1], 0);
		}		
	}
	
	clientNum = -1;
	if ( isdefined ( owner ) )
		clientNum = owner getEntityNumber();
	
	
	
	uncertaintyRadiusMin = 0;
	uncertaintyRadiusMax = 10;
	targetpos = randPointRadiusAway(targetpos,RandomIntRange(uncertaintyRadiusMin,uncertaintyRadiusMax));
	
	
	yaw = getBestFlakDirection( targetpos, team );
	direction = ( 0, yaw, 0 );
	
	flakDistance = 10000;
	flakCenter = targetPos + vector_scale( anglestoforward( direction ), -1 * flakDistance );
	
	
	
	if ( !isDefined( owner ) )
	{
		level.artilleryInProgress = undefined;
		level.artilleryShellsInAir = undefined;
		level._abilities[ "zombie_artillery" ].in_use = false;
		
		
		self notify( "artillery_status_change", owner );
		return;
	}
	
	owner notify ( "begin_artillery" );
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = (0,0,0);
	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	
	
	
	level.artilleryShellsInAir = level.artilleryCanonCount * level.artilleryCanonShellCount;
	owner thread artilleryImpactEffects( );
	level thread callArtilleryStrike( owner, targetpos, yaw, flakDistance, ownerDeathCount );
	
	owner endon("disconnect");
	level waittill( "artillery_strike_complete" );
	found = false;
	newarray = [];
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		if ( !found && level.artilleryDangerCenters[i].origin == targetpos )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.artilleryDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.artilleryDangerCenters.size - 1 );
	level.artilleryDangerCenters = newarray;
	
	
	level.artilleryInProgress = undefined;
	level._abilities[ "zombie_artillery" ].in_use = false;
	
	self notify( "artillery_status_change", owner );
	
	wait( 1.0 );
	
	owner maps\_zombiemode_ability::update_player_ability_status();
	
	flag_set("end_target_confirm");
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
referenceCounter()
{
	self waittill( "death" );
	
	level.artilleryShellsInAir = level.artilleryShellsInAir - 1;
}
randPointRadiusAway( origin, accuracyRadius )
{
	randVec = ( 0, randomint( 360 ), 0 );
	newPoint = origin + vector_scale( anglestoforward( randVec ), accuracyRadius );
	return newPoint;
}
get_origin_array( from_array )
{
	origins = [];
	
	for ( i = 0; i < from_array.size; i++ )
	{
		origins[origins.size] = from_array[i].origin;
	}
	return origins;
}
closest_point_on_line_to_point( Point, LineStart, LineEnd )
{
	result = spawnstruct();
	
	LineMagSqrd = lengthsquared(LineEnd - LineStart);
 
    t =	( ( ( Point[0] - LineStart[0] ) * ( LineEnd[0] - LineStart[0] ) ) +
				( ( Point[1] - LineStart[1] ) * ( LineEnd[1] - LineStart[1] ) ) +
				( ( Point[2] - LineStart[2] ) * ( LineEnd[2] - LineStart[2] ) ) ) /
				( LineMagSqrd );
 
 	result.t = t;
	start_x = LineStart[0] + t * ( LineEnd[0] - LineStart[0] );
	start_y = LineStart[1] + t * ( LineEnd[1] - LineStart[1] );
	start_z = LineStart[2] + t * ( LineEnd[2] - LineStart[2] );
		
	result.point = (start_x,start_y,start_z);
	result.distsqr = distancesquared( result.point, point );
	
	return result;
}
air_raid_audio()
{
	air_raid_1 = getent( "air_raid_1", "targetname" );
	if(isdefined(air_raid_1))
	{
		air_raid_1 playsound("air_raid_a");
	}
}  
