#include maps\_utility;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include animscripts\debug;
#include common_scripts\utility;

/*
This file contains the overall behavior for all "whack-a-mole" cover nodes.

Callbacks which must be defined:

 All callbacks should return true or false depending on whether they succeeded in doing something.
 If functionality for a callback isn't available, just don't define it.

mainLoopStart()
	optional
reload()
	plays a reload animation in a hidden position
leaveCoverAndShoot()
	does the main attacking; steps out or stands up and fires, goes back to hiding.
	should obey orders from decideWhatAndHowToShoot in shoot_behavior.gsc.
look( maxtime )
	looks for up to maxtime, stopping and returning if enemy becomes visible or if suppressed
fastlook()
	looks quickly
idle()
	idles until the "end_idle" notify.
flinch()
	flinches briefly (1-2 seconds), doesn't need to return true or false.
grenade( throwAt )
	steps out and throws a grenade at the given player / ai
grenadehidden( throwAt )
	throws a grenade at the given player / ai without leaving cover
blindfire()
	blindfires from cover
switchSides()
	switches from left to right, if possible (ex. pillar nodes);

example:
behaviorCallbacks = SpawnStruct();
behaviorCallbacks.reload = ::reload;
...
animscripts\cover_behavior::main( behaviorCallbacks );

*/

main( behaviorCallbacks )
{
	/#
	if ( GetDvar( #"scr_forceshotgun") == "on" && self.primaryweapon != "winchester1200" )
	{
		self.secondaryweapon = self.primaryweapon;
		
		self.primaryweapon = "winchester1200";
		self animscripts\init::initWeapon( self.primaryweapon );
		self animscripts\init::initWeapon( self.secondaryweapon );
		self animscripts\shared::placeWeaponOn( self.secondaryweapon, "back");
		self animscripts\shared::placeWeaponOn( self.primaryweapon, "right");
		self.weapon = self.primaryweapon;
		self animscripts\weaponList::RefillClip();
	}
	#/
	
	//prof_begin("cover_main");
	
	self.couldntSeeEnemyPos = self.origin; // (set couldntSeeEnemyPos to a place the enemy can't be while we're in corner behavior)
	
	time = GetTime();
	nextAllowedLookTime = time - 1;
	nextAllowedSuppressTime = time - 1;
	
	// we won't look for better cover purely out of boredom until this time
	self.a.getBoredOfThisNodeTime = GetTime() + randomintrange( 2000, 6000 );
	resetSeekOutEnemyTime();
	self.a.lastEncounterTime = time;
	
	self.a.idlingAtCover = false;
	self.a.movement = "stop";

	self thread watchSuppression();
//	self thread attackEnemyWhenFlashed();

	self.coverSafeToPopOut = true;
	self thread watchPlayerAim();

	self thread animscripts\utility::idleLookatBehavior(160, true);
	
	desynched = (GetTime() > 2500);
	
	correctAngles = self.coverNode.angles;
	if ( self.coverNode.type == "Cover Left" || self.coverNode.type == "Cover Left Wide" )
	{
		correctAngles = (correctAngles[0], correctAngles[1] + 90, correctAngles[2]);
	}
	else if ( self.coverNode.type == "Cover Right" || self.coverNode.type == "Cover Right Wide" )
	{
		correctAngles = (correctAngles[0], correctAngles[1] - 90, correctAngles[2]);
	}
	else if( self.coverNode.type == "Cover Pillar" && usingPistol() ) // no pillar specific anims for pillar, use cover left or right instead
	{
		if( self.a.script == "cover_left" )
		{
			correctAngles = (correctAngles[0], correctAngles[1] + 90, correctAngles[2]);
		}
		else
		{
			correctAngles = (correctAngles[0], correctAngles[1] - 90, correctAngles[2]);
		}
	}
	
	/#
	if ( GetDvar( #"scr_coveridle") == "1" )
	{
		self.coverNode.script_onlyidle = true;
	}
	#/
	
	//prof_end("cover_main");

	for(;;)
	{
		//prof_begin("cover_main_A");
		if ( IsDefined( behaviorCallbacks.mainLoopStart ) )
		{
			startTime = GetTime();
			self thread endIdleAtFrameEnd();

			//prof_end("cover_main_A");
			[[ behaviorCallbacks.mainLoopStart ]]();

			if ( GetTime() == startTime )
			{
				self notify("dont_end_idle");
			}
		}
		
		self Teleport( self.covernode.origin, correctAngles );
		
		if ( IsDefined( self.coverNode.script_onlyidle ) )
		{
			assert( self.coverNode.script_onlyidle ); // true or undefined
			//prof_end("cover_main_A");
			idle( behaviorCallbacks );
			continue;
		}
		else if (IsDefined(self.a.coverIdleOnly) && self.a.coverIdleOnly)
		{
			idle( behaviorCallbacks );
			continue;
		}
		
		if ( !desynched )
		{
			//prof_end("cover_main_A");
			idle( behaviorCallbacks, 0.05 + RandomFloat( 1.5 ) );
			desynched = true;
			continue;
		}

		if( shouldSwitchSides(true) )
		{
			if( switchSides( behaviorCallbacks ) )
			{
				continue;
			}
		}
		
		//prof_end("cover_main_A");
		
		//prof_begin("cover_main_B");
		
		// if we're suppressed, we do other things.
		if ( suppressedBehavior( behaviorCallbacks ) )
		{
			if ( isEnemyVisibleFromExposed() )
			{
				resetSeekOutEnemyTime();
			}

			self.a.lastEncounterTime = GetTime();
			//prof_end("cover_main_B");
			continue;
		}

		// ALEXP_MOD (9/8/09): covering teammates is high priority
		if( shouldProvideCoveringFire() )
		{
			//recordEntText( "Try Covering Fire!", self, level.color_debug["green"], "Messaging" );
			if ( leaveCoverAndShoot( behaviorCallbacks, "suppress" ) )
			{
				resetSeekOutEnemyTime();
				self.a.lastEncounterTime = GetTime();
				continue;
			}
		}
		
		//prof_end("cover_main_B");
		
		//prof_begin("cover_main_C");

		if( animscripts\shared::shouldSwitchWeapons() )
		{
			//println("cover_behavior:shouldSwitchWeapons was true"); // ALEXP_PRINT

			animscripts\shared::switchWeapons();

			[[ behaviorCallbacks.resetWeaponAnims ]]();

			continue;
		}
		
		// reload if we need to; everything in this loop involves shooting.
		if ( coverReload( behaviorCallbacks, 0 ) )
		{
			//prof_end("cover_main_C");
			continue;
		}
				
		// determine visibility and suppressability of enemy.
		visibleEnemy = false;
		suppressableEnemy = false;
		if ( IsAlive(self.enemy) )
		{
			visibleEnemy = isEnemyVisibleFromExposed();
			suppressableEnemy = canSuppressEnemyFromExposed();
		}
		
		if ( IsDefined( anim.throwGrenadeAtPlayerASAP ) && self.team == "axis" )
		{
			players = GetPlayers();
			for( i = 0; i < players.size; i++ )
			{
				if( IsAlive( players[i] ) )
				{
					if ( tryThrowingGrenade( players[i], 200 ) )
					{
						//prof_end("cover_main_C");
						continue;
					}
				}
			}
		}
		
		//prof_end("cover_main_C");

		// decide what to do.
		if ( visibleEnemy )
		{
			//prof_begin("cover_visible_enemy");
			if ( DistanceSquared( self.origin, self.enemy.origin ) > 750 * 750 )
			{
				if ( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
				{
					//prof_end("cover_visible_enemy");
					continue;
				}
			}
			
			if ( leaveCoverAndShoot( behaviorCallbacks, "normal" ) )
			{
				resetSeekOutEnemyTime();
				self.a.lastEncounterTime = GetTime();
			}
			else
			{
				//prof_end("cover_visible_enemy");
				idle( behaviorCallbacks );
			}
			
			//prof_end("cover_visible_enemy");
		}
		else
		{
			//prof_begin("cover_notvisible_enemy");
			if ( !visibleEnemy && enemyIsHiding() && !self.fixedNode )
			{
				if ( advanceOnHidingEnemy() )
				{
					//prof_end("cover_notvisible_enemy");
					return;
				}
			}

			if ( suppressableEnemy )
			{
				// randomize the order of trying the following options
				permutation = getPermutation(2);
				done = false;
				for ( i = 0; i < permutation.size && !done; i++ )
				{
					switch( i )
					{
					case 0:
						if ( self.provideCoveringFire || GetTime() >= nextAllowedSuppressTime )
						{
							preferredActivity = "suppress";
							if ( !self.provideCoveringFire && (GetTime() - self.lastSuppressionTime) > 5000 && RandomInt(3) < 2 )
							{
								preferredActivity = "ambush";
							}

							if ( !self animscripts\shoot_behavior::shouldSuppress() )
							{
								preferredActivity = "ambush";
							}

							if ( leaveCoverAndShoot( behaviorCallbacks, preferredActivity ) )
							{
								nextAllowedSuppressTime = GetTime() + randomintrange( 3000, 20000 );
								// if they're there, we've seen them
								if ( isEnemyVisibleFromExposed() )
								{
									self.a.lastEncounterTime = GetTime();
								}

								done = true;
							}
						}
						break;

					case 1:
						if ( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
						{
							done = true;
						}
						break;
					}
				}

				if ( done )
				{
					continue;
				}
				
				//prof_end("cover_notvisible_enemy");
				idle( behaviorCallbacks );
			}
			else
			{
				// nothing to do!
				
				if ( coverReload( behaviorCallbacks, 0.1 ) )
				{
					//prof_end("cover_notvisible_enemy");
					continue;
				}
				
				if ( isValidEnemy( self.enemy ) )
				{
					if ( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
					{
						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				if ( self.team == "axis" && self weaponAnims() != "rocketlauncher" && (IsDefined(self.shootPos) || RandomInt(100) < 30) )
				{
					if ( leaveCoverAndShoot( behaviorCallbacks, "ambush" ) )
					{
						nextAllowedSuppressTime = GetTime() + randomintrange( 3000, 20000 );
						// if they're there, we've seen them
						if ( isEnemyVisibleFromExposed() )
						{
							self.a.lastEncounterTime = GetTime();
						}

						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				if ( GetTime() >= nextAllowedLookTime )
				{
					if ( lookForEnemy( behaviorCallbacks ) )
					{
						nextAllowedLookTime = GetTime() + randomintrange( 4000, 15000 );
						
						// if they're there, we've seen them
						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				// we're *really* bored right now
				if ( GetTime() > self.a.getBoredOfThisNodeTime )
				{
					if ( cantFindAnythingToDo() )
					{
						//prof_end("cover_notvisible_enemy");
						return;
					}
				}
				
				if ( GetTime() >= nextAllowedSuppressTime && isValidEnemy( self.enemy ) )
				{
					// be ready to ambush them if they happen to Show up
					if ( leaveCoverAndShoot( behaviorCallbacks, "ambush" ) )
					{
						if ( isEnemyVisibleFromExposed() )
						{
							resetSeekOutEnemyTime();
						}

						self.a.lastEncounterTime = GetTime();
						nextAllowedSuppressTime = GetTime() + randomintrange( 6000, 20000 );
						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				//prof_end("cover_notvisible_enemy");
				idle( behaviorCallbacks );
			}
		}
	}
}

isEnemyVisibleFromExposed()
{
	if ( !IsDefined( self.enemy ) )
	{
		return false;
	}

	// if we couldn't see our enemy last time we stepped out, and they haven't moved, assume we still can't see them.
	if ( DistanceSquared(self.enemy.origin, self.couldntSeeEnemyPos) < 16*16 )
	{
		return false;
	}
	else
	{
		return canSeeEnemyFromExposed();
	}
}

suppressedBehavior( behaviorCallbacks )
{
	if ( !isSuppressedWrapper() )
	{
		return false;
	}
	
	nextAllowedBlindfireTime = GetTime();
	
	justlooked = true;
	
	//prof_begin( "suppressedBehavior" );

	/#
	self animscripts\debug::debugPushState( "suppressedBehavior" );
	#/
	

	while ( isSuppressedWrapper() )
	{
		justlooked = false;

		self Teleport( self.coverNode.origin );
		
		if ( tryToGetOutOfDangerousSituation() )
		{
			self notify("killanimscript");
			waittillframeend;

			//prof_end( "suppressedBehavior" );
			/#
			self animscripts\debug::debugPopState( "suppressedBehavior", "found better cover" );
			#/

			return true;
		}

		if( shouldProvideCoveringFire() )
		{
			/#
			self animscripts\debug::debugPopState( "suppressedBehavior", "should provide covering fire" );
			#/

			return false;
		}
		
		canThrowGrenade = isEnemyVisibleFromExposed() || canSuppressEnemyFromExposed();
		
		
		// if we're only at a concealment node, and it's not providing cover, we shouldn't try to use the cover to keep us safe!
		if ( self.a.atConcealmentNode && self canSeeEnemy() )
		{
			//prof_end( "suppressedBehavior" );
			/#
			self animscripts\debug::debugPopState( "suppressedBehavior", "at unsafe concealment node" );
			#/

			return false;
		}
		
		if ( canThrowGrenade && IsDefined( anim.throwGrenadeAtPlayerASAP ) && self.team == "axis" )
		{
			players = GetPlayers();
			for( i = 0; i < players.size; i++ )
			{
				if( IsAlive( players[i] ) )
				{
					if ( tryThrowingGrenade( players[i], 200 ) )
					{
						//prof_end("cover_main_C");
						continue;
					}
				}
			}
		}

		if ( coverReload( behaviorCallbacks, 0 ) )
		{
			continue;
		}

		if( shouldSwitchSides(true) )
		{
			if( switchSides( behaviorCallbacks ) )
			{
				continue;
			}
		}
		
		// randomize the order of trying the following options
		permutation = getPermutation(2);
		done = false;
		for ( i = 0; i < permutation.size && !done; i++ )
		{
			switch( i )
			{
			case 0:
				if ( self.team != "allies" && GetTime() >= nextAllowedBlindfireTime )
				{
					AssertEx( level.blindfireTimeMin < level.blindfireTimeMax, "level.blindfireTimeMin should be smaller than and level.blindfireTimeMax." );

					if ( blindfire( behaviorCallbacks ) )
					{
						nextAllowedBlindfireTime = GetTime() + randomintrange( level.blindfireTimeMin, level.blindfireTimeMax );
						done = true;
					}
				}
				break;
				
			case 1:
				if ( canThrowGrenade && tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
				{
					justlooked = true;
					done = true;
				}
				break;
			}
		}

		if ( done )
		{
			continue;
		}


		if ( coverReload( behaviorCallbacks, 0.1 ) )
		{
			continue;
		}

		//prof_end( "suppressedBehavior" );
		idle( behaviorCallbacks );
	}
	
	if ( !justlooked && RandomInt(2) == 0 )
	{
		lookfast( behaviorCallbacks );
	}

	/#
	self animscripts\debug::debugPopState( "suppressedBehavior" );
	#/

	//prof_end( "suppressedBehavior" );
	return true;
}

// returns array of integers 0 through n-1, in random order
getPermutation( n )
{
	permutation = [];
	assert( n > 0 );

	if ( n == 1 )
	{
		permutation[0] = 0;
	}
	else if ( n == 2 )
	{
		permutation[0] = RandomInt(2);
		permutation[1] = 1 - permutation[0];
	}
	else
	{
		for ( i = 0; i < n; i++ )
		{
			permutation[i] = i;
		}

		for ( i = 0; i < n; i++ )
		{
			switchIndex = i + RandomInt(n - i);
			temp = permutation[switchIndex];
			permutation[SwitchIndex] = permutation[i];
			permutation[i] = temp;
		}
	}

	return permutation;
}

callOptionalBehaviorCallback( callback, arg, arg2, arg3 )
{
	if ( !IsDefined( callback ) )
	{
		return false;
	}
	
	//prof_begin( "callOptionalBehaviorCallback" );
	self thread endIdleAtFrameEnd();
	
	starttime = GetTime();
	
	val = undefined;
	if( IsDefined( arg3 ) )
	{
		val = [[callback]]( arg, arg2, arg3 );
	}
	else if ( IsDefined( arg2 ) )
	{
		val = [[callback]]( arg, arg2 );
	}
	else if ( IsDefined( arg ) )
	{
		val = [[callback]]( arg );
	}
	else
	{
		val = [[callback]]();
	}
	
	/#
	// if this assert fails, a behaviorCallback callback didn't return true or false.
	assert( IsDefined( val ) && (val == true || val == false) );
	
	// behaviorCallbacks must return true if and only if they let time pass.
	// (it is also important that they only let time pass if they did what they were supposed to do,
	//  but that's not so easy to enforce.)
	if ( val )
	{
		assert( GetTime() != starttime );
	}
	else
	{
		assert( GetTime() == starttime );
	}
	#/

	if ( !val )
	{
		self notify("dont_end_idle");
	}
		
	//prof_end( "callOptionalBehaviorCallback" );
	
	return val;
}

watchSuppression()
{
	self endon("killanimscript");

	// self.lastSuppressionTime is the last time a bullet whizzed by.
	// self.suppressionStart is the last time we were thinking it was safe when a bullet whizzed by.

	self.lastSuppressionTime = GetTime() - 100000;
	self.suppressionStart = self.lastSuppressionTime;

	while(1)
	{
		self waittill("suppression");

		time = GetTime();
		if ( self.lastSuppressionTime < time - 700 )
		{
			self.suppressionStart = time;
		}

		self.lastSuppressionTime = time;
	}
}

coverReload( behaviorCallbacks, threshold )
{
	assert(isdefined(self.bulletsInClip));
	assert(isdefined(self.weapon));
	assert(isdefined(threshold));
	assert(isdefined(weaponClipSize( self.weapon )));

	if ( self.bulletsInClip > weaponClipSize( self.weapon ) * threshold )
	{
		return false;
	}

	self.isreloading = true;

	/#
	self animscripts\debug::debugPushState( "reload" );
	#/
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.reload );

	/#
	self animscripts\debug::debugPopState( "reload" );
	#/
	
	self.isreloading = false;
	
	return result;
}

// initialGoal can be either "normal", "suppress", or "ambush".
leaveCoverAndShoot( behaviorCallbacks, initialGoal )
{
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( initialGoal );
	
	if ( !self.fixedNode )
	{
		self thread breakOutOfShootingIfWantToMoveUp();
	}

	/#
	self animscripts\debug::debugPushState( "leaveCoverAndShoot" );
	#/

	val = callOptionalBehaviorCallback( behaviorCallbacks.leaveCoverAndShoot );

	/#
	self animscripts\debug::debugPopState( "leaveCoverAndShoot" );
	#/
	
	self notify("stop_deciding_how_to_shoot");
	
	return val;
}

lookForEnemy( behaviorCallbacks )
{
	if ( self.a.atConcealmentNode && self canSeeEnemy() )
	{
		return false;
	}

	if ( self.a.lastEncounterTime + 6000 > GetTime() )
	{
		return lookfast( behaviorCallbacks );
	}
	else
	{
		/#
		self animscripts\debug::debugPushState( "lookForEnemy" );
		#/

		if( usingGasWeapon() )
		{
			result = callOptionalBehaviorCallback( behaviorCallbacks.look, 5 + RandomFloat( 2 ) );
		}
		else
		{
			result = callOptionalBehaviorCallback( behaviorCallbacks.look, 2 + RandomFloat( 2 ) );
		}

		if ( result )
		{
			/#
			self animscripts\debug::debugPopState( "lookForEnemy" );
			#/

			return true;
		}

		result = callOptionalBehaviorCallback( behaviorCallbacks.fastlook );

		/#
		self animscripts\debug::debugPopState( "lookForEnemy", "look failed, used fastlook" );
		#/

		return result;
	}
}

lookfast( behaviorCallbacks )
{
	/#
	self animscripts\debug::debugPushState( "lookfast" );
	#/

	// look fast if possible
	result = callOptionalBehaviorCallback( behaviorCallbacks.fastlook );
	if ( result )
	{
		/#
		self animscripts\debug::debugPopState( "lookfast" );
		#/

		return true;
	}

	result = callOptionalBehaviorCallback( behaviorCallbacks.look, 0 );

	/#
	self animscripts\debug::debugPopState( "lookfast", "fastlook failed, used look" );
	#/

	return result;
}

idle( behaviorCallbacks, howLong )
{
	/#
	self animscripts\debug::debugPushState( "idle" );
	#/

	self.flinching = false;
	
	if ( IsDefined( behaviorCallbacks.flinch ) )
	{
		// flinch if we just started getting shot at very recently
		if ( !self.a.idlingAtCover && GetTime() - self.suppressionStart < 600 )
		{
			if ( [[ behaviorCallbacks.flinch ]]() )
			{
				/#
				self animscripts\debug::debugPopState( "idle", "flinched" );
				#/

				return true;
			}
		}
		else
		{
			// if bullets aren't already whizzing by, idle for now but flinch if we get incoming fire
			self thread flinchWhenSuppressed( behaviorCallbacks );
		}
	}
	
	if ( !self.a.idlingAtCover )
	{
		assert( IsDefined( behaviorCallbacks.idle ) ); // idle must be available!
		self thread idleThread( behaviorCallbacks.idle ); // this thread doesn't stop until "end_idle", which must be notified before we start anything else! use endIdleAtFrameEnd() to do this.
		self.a.idlingAtCover = true;
	}

	if ( IsDefined( howLong ) )
	{
		self idleWait( howLong );
	}
	else
	{
		self idleWaitABit();
	}

	if ( self.flinching )
	{
		self waittill("flinch_done");
	}
	
	self notify("stop_waiting_to_flinch");

	/#
	self animscripts\debug::debugPopState( "idle" );
	#/
}

idleWait( howLong )
{
	self endon("end_idle");
	wait howLong;
}

idleWaitAbit()
{
	self endon("end_idle");
	wait 0.3 + RandomFloat( 0.1 );
	self waittill("do_slow_things");
}

idleThread( idlecallback )
{
	self endon("killanimscript");
	self [[ idlecallback ]]();
}

flinchWhenSuppressed( behaviorCallbacks )
{
	self endon ("killanimscript");
	self endon ("stop_waiting_to_flinch");
	
	lastSuppressionTime = self.lastSuppressionTime;
	
	while(1)
	{
		self waittill("suppression");
		
		time = GetTime();
		
		if ( lastSuppressionTime < time - 2000 )
		{
			break;
		}

		lastSuppressionTime = time;
	}

	/#
	self animscripts\debug::debugPushState( "flinchWhenSuppressed" );
	#/
	
	self.flinching = true;
	
	self thread endIdleAtFrameEnd();
	
	assert( IsDefined( behaviorCallbacks.flinch ) );
	val = [[ behaviorCallbacks.flinch ]]();
	
	if ( !val )
	{
		self notify("dont_end_idle");
	}

	self.flinching = false;
	self notify("flinch_done");

	/#
	self animscripts\debug::debugPopState( "flinchWhenSuppressed" );
	#/
}

endIdleAtFrameEnd()
{
	self endon("killanimscript");
	self endon("dont_end_idle");
	waittillframeend;
	self notify("end_idle");
	self.a.idlingAtCover = false;
}

tryThrowingGrenade( behaviorCallbacks, throwAt )
{
	result = undefined;

	/#
	self animscripts\debug::debugPushState( "tryThrowingGrenade" );
	#/

	if ( self isPartiallySuppressedWrapper() )
	{
		result = callOptionalBehaviorCallback( behaviorCallbacks.grenadehidden, throwAt );
	}
	else
	{
		result = callOptionalBehaviorCallback( behaviorCallbacks.grenade, throwAt );
	}

	/#
	self animscripts\debug::debugPopState( "tryThrowingGrenade" );
	#/

	return result;
}

blindfire( behaviorCallbacks )
{
	if ( !canBlindFire() )
	{
		return false;
	}

	/#
	self animscripts\debug::debugPushState( "blindfire" );
	#/
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.blindfire );

	/#
	self animscripts\debug::debugPopState( "blindfire" );
	#/

	return result;
}

breakOutOfShootingIfWantToMoveUp()
{
	self endon("killanimscript");
	self endon("stop_deciding_how_to_shoot");
	
	while(1)
	{
		if ( self.fixedNode )
		{
			return;
		}

		wait 0.5 + RandomFloat( 0.75 );
		
		if ( !isValidEnemy( self.enemy ) )
		{
			continue;
		}

		if ( enemyIsHiding() )
		{
			if ( advanceOnHidingEnemy() )
			{
				return;
			}
		}

		if ( !self canSeeEnemy() && !self canSuppressEnemy() )
		{
			if ( GetTime() > self.a.getBoredOfThisNodeTime )
			{
				if ( cantFindAnythingToDo() )
				{
					return;
				}
			}
		}
	}
}

enemyIsHiding()
{
	// if this function is called, we already know that our enemy is not visible from exposed.
	// check to see if they're doing anything hiding-like.
	
	if ( !IsDefined( self.enemy ) )
	{
		return false;
	}

	if ( self.enemy isFlashed() )
	{
		return true;
	}

	if ( IsPlayer( self.enemy ) )
	{
		if ( IsDefined( self.enemy.health ) && self.enemy.health < self.enemy.maxhealth )
		{
			return true;
		}
	}
	else
	{
		if ( IsSentient( self.enemy ) && self.enemy isSuppressedWrapper() )
		{
			return true;
		}
	}

	if ( IsDefined( self.enemy.isreloading ) && self.enemy.isreloading )
	{
		return true;
	}
	
	return false;
}

wouldBeSmartForMyAITypeToSeekOutEnemy()
{
	if ( self weaponAnims() == "rocketlauncher" )
	{
		return false;
	}

	if ( self isSniper() )
	{
		return false;
	}

	return true;
}

resetSeekOutEnemyTime()
{
	// we'll be willing to actually run right up to our enemy in order to find them if we haven't seen them by this time.
	// however, we'll try to find better cover before seeking them out
	self.seekOutEnemyTime = GetTime() + randomintrange( 3000, 5000 );
}

// these next functions are "look for better cover" functions.
// they don't always need to cause the actor to leave the node immediately,
// but if they keep being called over and over they need to become more and more likely to do so,
// as this indicates that new cover is strongly needed.
cantFindAnythingToDo()
{
	return advanceOnHidingEnemy();
}

advanceOnHidingEnemy()
{
	foundBetterCover = false;
	if ( !isValidEnemy( self.enemy ) || !self.enemy isFlashed() )
	{
		foundBetterCover = lookForBetterCover();
	}

	if ( !foundBetterCover && isValidEnemy( self.enemy ) && wouldBeSmartForMyAITypeToSeekOutEnemy() && !self canSeeEnemyFromExposed() )
	{
		if ( GetTime() >= self.seekOutEnemyTime || self.enemy isFlashed() )
		{
			return tryRunningToEnemy( false );
		}
	}

	// maybe at this point we could look for someone who's suppressing our enemy,
	// and if someone is, we can say "cover me!" and have them say "i got you covered" or something.
	
	return foundBetterCover;
}

tryToGetOutOfDangerousSituation()
{
	// maybe later we can do something more sophisticated here
	return lookForBetterCover();
}

shouldProvideCoveringFire()
{
	return isEnemyVisibleFromExposed() && self animscripts\squadmanager::hasMessage("coverMe") && !self isSniper();
}

watchPlayerAim()
{
	self endon("killanimscript");
	self endon("death");
	self endon("stop_watchPlayerAim");

	// delete the old trigger if it's still around
	if( IsDefined(self.coverLookAtTrigger) )
	{
		self.coverLookAtTrigger Delete();
	}

	assert( IsDefined(self.coverNode) );

	// find approximate stepout pos
	stepOutPos = self.coverNode.origin;

	// offset for left/right stepouts
	if( self.a.script == "cover_left" || (self.a.script == "cover_pillar" && self.cornerDirection == "left") )
	{
		stepOutPos -= vector_scale( AnglesToRight(self.coverNode.angles), 32 );
	}
	else if( self.a.script == "cover_right" || (self.a.script == "cover_pillar" && self.cornerDirection == "right") )
	{
		stepOutPos += vector_scale( AnglesToRight(self.coverNode.angles), 32 );
	}

	triggerWidth = 15;	// AIPHYS_RADIUS
	triggerHeight = 72;
	if( self.a.pose == "crouch" )
	{
		triggerHeight = 48;
	}

	// create temp lookat trigger at step out pos
	self.coverLookAtTrigger = Spawn( "trigger_lookat", stepOutPos, 0, triggerWidth, triggerHeight );
	
	/#
	//	PrintLn( "Spawning coverLookAtTrigger for entity " + self GetEntityNumber() + " at time " + GetTime() );
	#/

	while( true )
	{
		// wait till end of frame to allow other threads to access the info below
		waittillframeend;

		self.coverSafeToPopOut = true;
		self.playerAimSuppression = false;

		//if( IsDefined(self.enemy) && IsPlayer(self.enemy) && self.enemy IsLookingAt(self.coverLookAtTrigger) )
		self.coverLookAtTrigger waittill( "trigger", watcher );

		if( IsDefined(watcher) && IsDefined(self.enemy) && watcher == self.enemy )
		{
			/#
			self thread watchPlayerAimDebug(12);
			#/

			//canLean = self.a.pose == "stand" && (self.a.script == "cover_left" || self.a.script == "cover_right");

			self.coverSafeToPopOut = false;

			// ALEXP_TODO: this is temp, need to figure out a better way of controlling blindfire due to player aiming
			self.playerAimSuppression = RandomFloat(1) < 0.9;

			wait(0.5);
		}

		wait(0.05);
	}

	self.coverSafeToPopOut = true;
	self.playerAimSuppression = false;

	// delete temp trigger
	self.coverLookAtTrigger Delete();
}

/#
watchPlayerAimDebug(numFrames)
{
	self endon("death");

	i = 0;
	while( i < numFrames )
	{
		recordEntText( "Cover Trigger Watched", self, level.color_debug["white"], "Suppression" );
		i++;

		wait(0.05);
	}
}
#/

shouldSwitchSides( forVariety )
{
	if(	self.a.atPillarNode )
	{
		if( self.cornerDirection != self.coverNode.desiredCornerDirection )
		{
			return true;
		}
		else if( forVariety && GetTime() - self.a.lastSwitchSidesTime > 10000 && RandomFloat(1) > 0.5 )
		{
			if( self.cornerDirection == "left" && !self.coverNode isNodeDontRight() )
			{
				self.coverNode.desiredCornerDirection = "right";
			}
			else if( !self.coverNode isNodeDontLeft() )
			{
				self.coverNode.desiredCornerDirection = "left";
			}

			return true;
		}
		else if( IsDefined(self.enemy) )
		{
			yaw = self.coverNode GetYawToOrigin( self.enemy.origin );

			if( self.cornerDirection == "left" && yaw > 5 && !self.coverNode isNodeDontRight() )
			{
				self.coverNode.desiredCornerDirection = "right";
				return true;
			}
			else if( self.cornerDirection == "right" && yaw < -5 && !self.coverNode isNodeDontLeft() )
			{
				self.coverNode.desiredCornerDirection = "left";
				return true;
			}
		}
	}

	return false;
}

switchSides( behaviorCallbacks )
{
	if ( !canSwitchSides() )
	{
		return false;
	}

	/#
	self animscripts\debug::debugPushState( "switchSides" );
	#/
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.switchSides );

	if( result )
	{
		// reset the player aim trigger
		self notify("stop_watchPlayerAim");
		self thread watchPlayerAim();

		//self.a.nextAllowedSwitchSidesTime = GetTime() + 3000;
		self.a.lastSwitchSidesTime = GetTime();
	}

	/#
	self animscripts\debug::debugPopState( "switchSides" );
	#/

	return result;
}