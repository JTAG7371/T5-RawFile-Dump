#include maps\_utility;
#include common_scripts\utility;
init()
{
	
	game["locking_on_sound"] = "uin_alert_lockon_start";
	game["locked_on_sound"] = "uin_alert_lockon";
	thread onPlayerConnect();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );
		player thread onPlayerSpawned();
		
	}
}
onPlayerSpawned()
{
	self endon( "disconnect" );
	for(;;)
	{
		self waittill( "spawned_player" );
		self ClearIRTarget();
		thread StingerToggleLoop();
		
		self thread StingerFiredNotify();
	}
}
ClearIRTarget()
{
	self notify( "stinger_irt_cleartarget" );
	self notify( "stop_lockon_sound" );
	self notify( "stop_locked_sound" );
	self.stingerlocksound = undefined;
	
	self.stingerLockStartTime = 0;
	self.stingerLockStarted = false;
	self.stingerLockFinalized = false;
	if( isdefined(self.stingerTarget) )
	{
		self.stingerTarget.no_lock = 0;
		self.stingerTarget.locked_on = 0;
	}
	self.stingerTarget = undefined;
	self WeaponLockFree();
	self WeaponLockTargetTooClose( false );
	self WeaponLockNoClearance( false );
	self StopLocalSound( game["locking_on_sound"] );
	self StopLocalSound( game["locked_on_sound"] );
}
StingerFiredNotify()
{
	self endon( "disconnect" );
	self endon( "death" );
	while ( true )
	{
		self waittill( "weapon_fired" );
		weap = self getCurrentWeapon();
		if ( weap != "strela_sp" )
			continue;
			
		if( isdefined(self.stingerTarget) )
			self.stingerTarget notify( "stinger_fired_at_me" );
			
		self notify( "stinger_fired" );
	}
}
StingerToggleLoop()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	for (;;)
	{
		while( !self PlayerStingerAds() )
			wait 0.05;
		self thread StingerIRTLoop();
		while( self PlayerStingerAds() )
			wait 0.05;
		self notify( "stinger_IRT_off" );
		self ClearIRTarget();
	}
}
StingerIRTLoop()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "stinger_IRT_off" );
	lockLength = self getLockOnSpeed();
	for (;;)
	{
		wait 0.05;
		
		
		
		
		
		
		
		if ( self.stingerLockFinalized )
		{
			passed = SoftSightTest();
			if ( !passed )
				continue;
			if ( ! IsStillValidTarget( self.stingerTarget ) )
			{
				self ClearIRTarget();
				continue;
			}
			
			self.stingerTarget.no_lock = 0;
			self.stingerTarget.locked_on = 1;
			thread LoopLocalLockSound( game["locked_on_sound"], 0.75 );
			self SetTargetTooClose( self.stingerTarget );
			self SetNoClearance();
			
			continue;
		}
		if ( self.stingerLockStarted )
		{
			if ( ! IsStillValidTarget( self.stingerTarget ) )
			{
				self ClearIRTarget();
				continue;
			}
			
			
			self.stingerTarget.no_lock = 1;
			self.stingerTarget.locked_on = 0;
			passed = SoftSightTest();
			if ( !passed )
				continue;
			timePassed = getTime() - self.stingerLockStartTime;
			if ( timePassed < lockLength )
				continue;
			assert( isdefined( self.stingerTarget ) );
			self notify( "stop_lockon_sound" );
			self.stingerLockFinalized = true;
			self WeaponLockFinalize( self.stingerTarget );
			self SetTargetTooClose( self.stingerTarget );
			self SetNoClearance();
			continue;
		}
		
		bestTarget = self GetBestStingerTarget();
		if ( !isDefined( bestTarget ) )
			continue;
		if ( !( self LockSightTest( bestTarget ) ) )
			continue;
		self.stingerTarget = bestTarget;
		self.stingerLockStartTime = getTime();
		self.stingerLockStarted = true;
		
		
		self thread LoopLocalSeekSound( game["locking_on_sound"], 0.6 );
	}
}
LockSightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isDefined( target ) ) 
		return false;
	
	passed = false;
	passed = BulletTracePassed( eyePos, target.origin, false, target );
	if ( !passed )
		return false;
	front = target GetPointInBounds( 1, 0, 0 );
	BulletTracePassed( eyePos, front, false, target );
	if ( !passed )
		return false;
	back = target GetPointInBounds( -1, 0, 0 );
	passed = BulletTracePassed( eyePos, back, false, target );
	if ( !passed )
		return false;
	return true;
}
SoftSightTest()
{
	LOST_SIGHT_LIMIT = 500;
	if ( self LockSightTest( self.stingerTarget ) )
	{
		self.stingerLostSightlineTime = 0;
		return true;
	}
	if ( self.stingerLostSightlineTime == 0 )
		self.stingerLostSightlineTime = getTime();
	timePassed = GetTime() - self.stingerLostSightlineTime;
	
	if ( timePassed >= LOST_SIGHT_LIMIT )
	{
		
		self ClearIRTarget();
		return false;
	}
	
	return true;
}
GetBestStingerTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];
	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if( self InsideStingerReticleNoLock( targetsAll[idx] ) )
		{
			targetsValid[targetsValid.size] = targetsAll[idx];
		}
	}
	if ( targetsValid.size == 0 )
		return undefined;
	chosenEnt = targetsValid[0];
	if ( targetsValid.size > 1 )
	{
		
	}
	
	return chosenEnt;
}
InsideStingerReticleNoLock( target )
{
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}
InsideStingerReticleLocked( target )
{
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}
IsStillValidTarget( ent )
{
	if ( ! isDefined( ent ) )
		return false;
	if ( ! target_isTarget( ent ) )
		return false;
	if ( ! InsideStingerReticleLocked( ent ) )
		return false;
	return true;
}
PlayerStingerAds()
{
	weap = self getCurrentWeapon();
	if ( weap != "strela_sp" && weap != "flashpoint_strela_sp" )
		return false;
	if ( self playerads() == 1.0 )
		return true;
	return false;
}
SetNoClearance()
{
	ORIGINOFFSET_UP = 60;
	ORIGINOFFSET_RIGHT = 10;
	DISTANCE = 400;
	
	COLOR_PASSED = (0,1,0);
	COLOR_FAILED = (1,0,0);
	checks = [];
	checks[0] = ( 0, 0, 80 );
	checks[1] = ( -40, 0, 120 );
	checks[2] = ( 40, 0, 120 );
	checks[3] = ( -40, 0, 40 );
	checks[4] = ( 40, 0, 40 );
	
	if ( GetDvar( #"missileDebugDraw" ) == "1" )
		debug = true;
	else
		debug = false;
	
	playerAngles = self GetPlayerAngles();
	forward = AnglesToForward( playerAngles );
	right = AnglesToRight( playerAngles );
	up = AnglesToUp( playerAngles );
	origin = self.origin + (0,0,ORIGINOFFSET_UP) + right * ORIGINOFFSET_RIGHT;
	obstructed = false;
	for( idx = 0; idx < checks.size; idx++ )
	{
		endpoint = origin + forward * DISTANCE + up * checks[idx][2] + right * checks[idx][0];
		trace = BulletTrace( origin, endpoint, false, undefined );
		
		if ( trace["fraction"] < 1 )
		{
			obstructed = true;
			if ( debug )
				line( origin, trace["position"], COLOR_FAILED, 1 );
			else
				break;
		}
		else
		{
			if ( debug )
				line( origin, trace["position"], COLOR_PASSED, 1 );
		}
	}
	
	self WeaponLockNoClearance( obstructed );
	self.noclearance = obstructed;
}
SetTargetTooClose( ent )
{
	MINIMUM_STI_DISTANCE = 1000;
	if ( ! isDefined( ent ) )
		return false;
	dist = Distance2D( self.origin, ent.origin );
	
	
	
	if ( dist < MINIMUM_STI_DISTANCE )
	{
		self.targettoclose = true;
		self WeaponLockTargetTooClose( true );
	}
	else
	{
		self.targettoclose = false;
		self WeaponLockTargetTooClose( false );
	}
}
LoopLocalSeekSound( alias, interval )
{
	self endon ( "stop_lockon_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self playLocalSound( alias );
		
		wait interval;
	}
}
LoopLocalLockSound( alias, interval )
{
	self endon ( "stop_locked_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	
	if ( isdefined( self.stingerlocksound ) )
		return;
	self.stingerlocksound = true;
	for (;;)
	{
		
		
		self playLocalSound( alias );
		
		wait interval/3;
		self playLocalSound( alias );
		
		wait interval/3;
		self playLocalSound( alias );
		
		wait interval/3;
		
	}
	self.stingerlocksound = undefined;
} 
  
