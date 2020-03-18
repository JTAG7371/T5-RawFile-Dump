#include animscripts\Utility;
#include animscripts\Debug;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include animscripts\shared;
#include animscripts\anims;
#include common_scripts\Utility;
#include maps\_utility;

#using_animtree("generic_human");

main()
{
	//prof_begin("combat_init");
	
	self endon("killanimscript");
	
	[[ self.exception[ "exposed" ] ]]();

	animscripts\utility::initialize("combat");
	self.a.arrivalType = undefined;
	
	/#
	if ( GetDvar( #"scr_testgrenadethrows") == "on" )
	{
		testGrenadeThrowAnimOffsets();
	}
	#/
	
	//if ( self.fixedNode && self IsInGoal( self.origin ) )
	//	self.keepClaimedNodeInGoal = true;
	
	self setup();
	
	//prof_end("combat_init");
	
	self exposedCombatMainLoop();
	
	self notify( "stop_deciding_how_to_shoot" );
}

/#
testGrenadeThrowAnimOffsets()
{
	testanims = [];
	testanims[0] = %exposed_grenadeThrowB;
	testanims[1] = %exposed_grenadeThrowC;
	testanims[2] = %corner_standL_grenade_A;
	testanims[3] = %corner_standL_grenade_B;
	testanims[4] = %CornerCrL_grenadeA;
	testanims[5] = %CornerCrL_grenadeB;
	testanims[6] = %corner_standR_grenade_A;
	testanims[7] = %corner_standR_grenade_B;
	testanims[8] = %CornerCrR_grenadeA;
	testanims[9] = %covercrouch_grenadeA;
	testanims[10] = %covercrouch_grenadeB;
	testanims[11] = %coverstand_grenadeA;
	testanims[12] = %coverstand_grenadeB;
	testanims[13] = %prone_grenade_A;
	testanims[14] = %ai_pillar_stand_grenade_throw_01;
	testanims[15] = %ai_pillar_stand_grenade_throw_02;
	testanims[16] = %ai_pillar_stand_grenade_throw_03;
	testanims[17] = %ai_pillar_crouch_grenade_throw_01;
	testanims[18] = %ai_pillar_crouch_grenade_throw_02;
	testanims[19] = %ai_pillar_crouch_grenade_throw_03;
	
	model = getGrenadeModel();
	
	self AnimMode("zonly_physics");
	for ( i = 0; i < testanims.size; i++ )
	{
		forward = AnglesToForward( self.angles );
		right   = AnglesToRight( self.angles );
		startpos = self.origin;
		
		tag = "TAG_INHAND";
		
		self setFlaggedAnimKnobAllRestart( "grenadetest", testanims[i], %root, 1, 0, 1 );
		for (;;)
		{
			self waittill("grenadetest", notetrack);
			if ( notetrack == "grenade_left" || notetrack == "grenade_right" )
			{
				self attach (model, tag);
			}

			if ( notetrack == "grenade_throw" || notetrack == "grenade throw" )
			{
				break;
			}

			assert(notetrack != "end"); // we shouldn't hit "end" until after we've hit "grenade_throw"!
			if ( notetrack == "end" ) // failsafe
			{
				break;
			}
		}
		
		pos = self GetTagOrigin( tag );
		baseoffset = pos - startpos;
		
		offset = ( vectordot( baseoffset, forward ), -1 * vectordot( baseoffset, right ), baseoffset[2] );
		
		// check our answer =)
		endpos = startpos + forward * offset[0] - right * offset[1] + (0,0,1) * offset[2];
		thread debugLine( startpos, endpos, (1,1,1), 20 );
		
		//println( "^2Grenade throw anim #" + i + " (", testanims[i], "): offset = " + pos );
		println( "else if ( throwAnim == %", testanims[i], " ) offset = ", offset, ";" );
		
		self detach(model, tag);
		
		wait 1;
	}
}
#/

idleThread()
{
	self endon("killanimscript");
	self endon("kill_idle_thread");

	for(;;)
	{
		if( isValidEnemy( self.enemy ) )
		{
			idleAnim = animArrayPickRandom( "exposed_idle" );
		}
		else
		{
			idleAnim = animArrayPickRandom( "exposed_idle_noncombat" );
		}

		self SetFlaggedAnimKnobLimitedRestart("idle", idleAnim );
		self waittillmatch( "idle", "end" );
		self ClearAnim( idleAnim, .2 );
	}
}

exposedBehavior()
{	
	// idle strafing
	if( idleStrafe() )
		return true;

	return false;
}

idleStrafe()
{
	self endon("killanimscript");
	
	if( !self shouldIdleStrafe() )	
		return false;
		
	// stand if not already standing
	if( self.a.pose != "stand" )
		idleStrafeTransitionTo("stand");
	
	/#
		self animscripts\debug::debugPushState( "idleStrafe" );
	#/

	// the animation is going to get wiped out by the idle strafe so kill the thread
	self notify("kill_idle_thread");

	// decide strafing direction and animation and steps
	sideStepAnim	   = idleStrafeDecideDirectionAndAnim();
	idleStrafeNumSteps = idleStrafeDecideNumSteps();
	numTakenSteps	   = 0;

	// strafe for number of steps decided
	for( numTakenSteps = 0; numTakenSteps < idleStrafeNumSteps; numTakenSteps++ )
	{
		// check if can move
		endPos	  = getAnimEndPos( sideStepAnim );	
		canStrafe = self MayMoveFromPointToPoint( self.origin, endPos );

		if( !canStrafe )
		{
			// stop trying for a little while
			if( numTakenSteps == 0 )
			{
				self.a.nextIdleStrafeTime = GetTime() + RandomIntRange( 0, 500 );
			}

			break;
		}

		// play the transition anim first
		if( numTakenSteps == 0 )
		{
			// setup idlestrafing state, so that it will not be interrupted 
			self.a.idleStrafing = true;

			// idle thread can end on kill animscript which will prevent from 
			self thread idleStrafeCleanUpOnKillAnimscript();

			startTransAnim = idleStrafeGetStartTransitionAnim( self.a.strafeDirection );

			// play the anim
			self AnimMode( "gravity", false );
			self SetFlaggedAnimKnobAllRestart( "transAnim", startTransAnim, %root, 1, 0.2, 1 );

			// re-enable aiming since the knob part above kills it			
			self SetAnim( %exposed_aiming, 1, 0 );

			self waittillmatch( "transAnim", "end" );

			// clear out all the exposed stand stuff so that when the endTransAnim anim is played, it won't blend with anything but the aims
			self ClearAnim( startTransAnim, 0.2 );
			self ClearAnim( %add_idle, 0.2 );
			self ClearAnim( animArray("straight_level"), 0.2 );

			// hide it all until endTransAnim is played
			self SetAnim( %exposed_modern, 0, 0.2 );

			// now we can strafe then setup strafing aims
			self thread idleStrafeTracking();
		}

		// play actual anim, this also starts aiming and 
		idleStrafePlayAnim( sideStepAnim );
	}

	// play the outro
	if( numTakenSteps > 0 )
	{
		endTransAnim = idleStrafeGetEndTransitionAnim( self.a.strafeDirection );

		self animscripts\shared::setAimingAnims(  %aim_2, %aim_4, %aim_6, %aim_8 );

		// play the anim
		self AnimMode( "gravity", false );
		self SetFlaggedAnimKnobAll( "transAnim", endTransAnim, %root, 1, 0.2, 1 );

		// re-enable aiming since the knob part above kills it
		self SetAnim( %exposed_aiming, 1, 0 );

		self waittillmatch( "transAnim", "end" );

		// clear out the anim
		self ClearAnim( endTransAnim, 0.2 );
	}

	// clean up the anim tree
	self ClearAnim( %walk_and_run_loops, 0.1 );

	// done with strafing do cleanup now
	idleStrafeCleanUp();

	// restart the additive idle thread
	self thread idleThread();
	
	if( numTakenSteps == 0 )
	{
		/#
			self animscripts\debug::debugPopState( "idleStrafe", "all anims blocked" );
		#/

		return false; // if this is first step and we couldnt strafe then return false
	}
	else
	{
		/#
			self animscripts\debug::debugPopState( "idleStrafe", "took " + numTakenSteps + " steps" );
		#/

		return true; // we strafed atleast one step
	}

	return true;
}

idleStrafePlayAnim( sideStepAnim )
{	
	self endon("killanimscript");
	
	// change the anim mode so that there will be movement
	self AnimMode( "gravity", false );

	self SetFlaggedAnim( "sideStepAnim", sideStepAnim, 1, 0.2, 1 );
	self waittillmatch( "sideStepAnim", "end" );
	self ClearAnim( sideStepAnim, 0.2 );
}

idleStrafeDecideNumSteps()
{
	MAX_STRAFE_STEPS = 4;
	MIN_STRAFE_STEPS = 1;

	return RandomIntRange( MIN_STRAFE_STEPS, MAX_STRAFE_STEPS );
}

idleStrafeDecideDirectionAndAnim()
{
	if( !IsDefined( self.a.strafeDirection ) )
	{
		chance = RandomInt( 100 );
	
		if( chance > 75 )
		{
			self.a.strafeDirection = "forward";
		}
		else
		{
			if( cointoss() )
				self.a.strafeDirection = "right";
			else			
				self.a.strafeDirection = "left";
		}
	}
	
	sideStepAnim = undefined;

	if( self.a.strafeDirection == "left" )
		sideStepAnim = animArrayPickRandom( "idle_strafe_left" );
	else if( self.a.strafeDirection == "right" )
		sideStepAnim = animArrayPickRandom( "idle_strafe_right" );
	else	
		sideStepAnim = animArrayPickRandom( "idle_strafe_forward" );
	
	return sideStepAnim;
}

idleStrafeGetStartTransitionAnim( direction )
{	
	transAnim = undefined;

	if( direction == "left" )
		transAnim = animArrayPickRandom( "idle_strafe_stop_2_l" );
	else if( direction == "right" )
		transAnim = animArrayPickRandom( "idle_strafe_stop_2_r" );
	else
		transAnim = animArrayPickRandom( "idle_strafe_stop_2_f" );
	
	return transAnim;
}

idleStrafeGetEndTransitionAnim( direction )
{	
	transAnim = undefined;

	if( direction == "left" )
		transAnim = animArrayPickRandom( "idle_strafe_l_2_stop" );
	else if( direction == "right" )
		transAnim = animArrayPickRandom( "idle_strafe_r_2_stop" );
	else
		transAnim = animArrayPickRandom( "idle_strafe_f_2_stop" );
	
	return transAnim;
}

idleStrafeCleanUpOnKillAnimscript()
{	
	// if already strafe tracking then we already started this thread, dont do anything
	if( IsDefined( self.a.idleStrafeCleanUpThreadActive ) && self.a.idleStrafeCleanUpThreadActive )
		return;

	self.a.idleStrafeCleanUpThreadActive = true;

	/#
	//recordEntText( "starting to wait for idlestrafe cleanup", self, level.color_debug["white"], "Script" );
	#/

	result = self waittill_any_return( "killanimscript", "kill_idlestrafe_thread" );

	self.a.idleStrafeCleanUpThreadActive = false;
	
	idleStrafeCleanUp( result );
}

// special stance changing for idlestrafing, this version doesnt kill the idle thread
idleStrafeTransitionTo( newPose )
{
	if ( self.a.pose == newPose )
	{
		return;
	}

	/#
	self animscripts\debug::debugPushState( "idleStrafeTransitionTo: " + newPose );
	#/

	self ClearAnim( %root, .3 );
	
	transAnim = animArray( self.a.pose + "_2_" + newPose );
	if ( newPose == "stand" )
	{
		rate = 2; // gotta stand up fast!
	}
	else
	{
		rate = 1;
	}

	if ( !animHasNoteTrack( transAnim, "anim_pose = \"" + newPose + "\"" ) )
	{
		println( "error: " + self.a.pose + "_2_" + newPose + " missing notetrack to set pose!" );
	}

	self setFlaggedAnimKnobAllRestart( "trans", transanim, %body, 1, .2, rate );

	//restart aiming
	setupAim( 0 );
	self SetAnim( %exposed_aiming, 1, 0 );

	transTime = getAnimLength( transanim ) / rate;
	playTime = transTime - 0.3;
	if ( playTime < 0.2 )
	{
		playTime = 0.2;
	}

	self animscripts\shared::DoNoteTracksForTime( playTime, "trans" );
	self ClearAnim( transanim, 0.2 );

	self.a.pose = newPose;

	// start aiming in case the idleStrafe animations can't be played after this
	self SetAnimKnobAllRestart( animarray("straight_level"), %body, 1, .2 );
	setupAim( .2 );

	self SetAnim( %add_idle );
	self thread idleThread();

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#
	self animscripts\debug::debugPopState();
	#/
}

idleStrafeCleanUp( reason )
{
	self endon("death"); // adding this specifically as this might happen when we are cleaning up

	if( !IsDefined( self ) )
		return;

	// already cleaned up
	if( IsDefined(self.a.idleStrafing) && !self.a.idleStrafing )
		return;
		
	if( !IsDefined( reason ) )
		reason = "kill_idlestrafe_thread";

	// stop shoot while running thread otherwise it will conflict with regular idle thread
	self notify( "doing_shootWhileMoving" );

	// stop idle strafe shooting as we are stoping now	
	self notify("stop_idle_strafe_tracking");
	self.a.idleStrafeTracking = false;

	self.a.strafeDirection = undefined;

	// if strafing before then we need to start regular tracking again
	if( IsDefined( self ) && self.a.idleStrafing )
	{
		/#
		//recordEntText( "Did idlestrafe cleanup", self, level.color_debug["white"], "Script" );
		#/

		if( usingPistol() )
		{
			self.a.nextIdleStrafeTime = GetTime() + RandomIntRange( 1000, 3000 );
		}
		else
		{
			self.a.nextIdleStrafeTime = GetTime() + RandomIntRange( 0, 1000 );
		}

		// reset the regular aims, only if the we are not going to new animscript
		if( reason == "kill_idlestrafe_thread" && IsAlive( self ) )
		{
			self resetRegularIdle();
		
			// start regular tracking
			self thread trackShootEntOrPos();
			self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
		}
	}

	self.a.idleStrafing = false;

	/#
		self animscripts\debug::debugPopState( "idleStrafe" );
	#/
}

shouldIdleStrafe()
{
	if( IsDefined( self.disableIdleStrafing ) && self.disableIdleStrafing )
		return false;
	
	// idle strafing is only for axis AI
	if( self.team == "allies" )
		return false;
	
	// if the AI goalradius is smaller than 128 then assume that he should be stationary
	if( self.goalradius < 128 )
		return false;
		
	// if this AI doesn have a weapon, then dont do idlestrafing
	if( !IsDefined( self.weapon ) || self.weapon == "none" )	
		return false;

	// if out of ammo, reload first, otherwise it seems like AI has an infinite clip since idlestrafing cheats ammo
	if( IsDefined(self.bulletsInClip) && !self.bulletsInClip )
		return false;

	// if the closest player is way too far then there is no point in idlestrafing
	player = get_closest_player( self.origin );
	if( Distance2DSquared( self.origin, player.origin ) > 1000 * 1000 )
		return false;

	// if any nearby AI is idleStrafing, then dont do it
	closeByAi = get_array_of_closest( self.origin, GetAIArray( self.team ), undefined, undefined, 200 ); 
	
	for( i = 0; i < closeByAi.size; i++ )
	{
		if( IsDefined( closeByAi[i].a.idleStrafing ) && closeByAi[i].a.idleStrafing )
			return false;
	}

	// we need to make sure that we are facing our enemy before starting to strafe
	if( needToTurn() )
		return false;

	// no idle strafing while using side arm, or rocket launcher
	if( weaponAnims() == "rocketlauncher" )
		return false;

	// check if allowed to stand
	if( !self IsStanceAllowed( "stand" ) )
		return false;

	if( IsDefined( self.a.exposedReloading ) && self.a.exposedReloading )
		return false;
	
	// this should be the last check in this function always
	if( IsDefined( self.a.nextIdleStrafeTime ) )	
	{
		if( GetTime() > self.a.nextIdleStrafeTime )
			return true;
		else
			return false;
	}

	return true;
}

idleStrafeTracking()
{	
	// if already strafe tracking then dont do anything more
	if( IsDefined( self.a.idleStrafeTracking ) && self.a.idleStrafeTracking )
		return;

	// stop using previous shooting threads as we are going to start a new one
	self notify("stopShooting");
	
	self.a.idleStrafeTracking = true;

	self endon("killanimscript");
	self endon("stop_idle_strafe_tracking");
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
	
	self SetAnimLimited( animArray("idle_strafe_aim_down") );
	self SetAnimLimited( animArray("idle_strafe_aim_left") );
	self SetAnimLimited( animArray("idle_strafe_aim_right") );
	self SetAnimLimited( animArray("idle_strafe_aim_up") );
	
	self.shoot_while_moving_thread = undefined;
	self thread animscripts\run::runShootWhileMovingThreads();

	self animscripts\shared::setAimingAnims(  %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 );
	self animscripts\shared::trackLoopStart();
}

resetRegularIdle()
{
	self animscripts\run::stopShootWhileMovingThreads();

	self set_aimturn_limits();

	if( animArrayExist( "straight_level" ) )
	{
		self SetAnimKnobAllRestart( animarray("straight_level"), %body, 1, .2 );
	}
		
	self ClearAnim( %stand_and_crouch, .2 );
	
	setupAim( .2 );

	self SetAnim( %add_idle );
	self SetAnim( %exposed_aiming, 1, .2 );
}


setup()
{

	//self setupExposedSet();

	if ( usingSidearm() )
	{
		transitionTo("stand");
	}

	self set_aimturn_limits();
	
	self.isturning = false;
	self thread stopShortly();
	self.previousPitchDelta = 0.0;
	
	self ClearAnim( %root, .2 );
	self SetAnim( animarray("straight_level") );
	self SetAnim( %add_idle );
	self ClearAnim( %aim_4, .2 );
	self ClearAnim( %aim_6, .2 );
	self ClearAnim( %aim_2, .2 );
	self ClearAnim( %aim_8, .2 );
	
	setupAim(.2);
	
	self thread idleThread();

	self.a.meleeState = "aim";
}

stopShortly()
{
	self endon("killanimscript");
	self endon("melee");
	// we want to stop at about the time we blend out of whatever we were just doing.
	wait .2;
	self.a.movement = "stop";
}

setupAim( transTime )
{
	assert( IsDefined( transTime ) );
	self SetAnimKnobLimited( animArray("add_aim_up"   ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_down" ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_left" ), 1, transTime );
	self SetAnimKnobLimited( animArray("add_aim_right"), 1, transTime );
}

set_aimturn_limits()
{
	switch(self.a.pose)
	{
		case "stand":
		case "crouch":
			self.turnThreshold = 35;
			break;
		case "prone":
			assert( !usingSidearm() );
			self.turnThreshold = 45;
			break;
		default:
			assertMsg( "Unsupported self.a.pose: " + self.a.pose + " at " + self.origin );
			break;
	}

	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;

	self.turnleft180limit =  -130;
	self.turnright180limit = 130;
	self.turnleft90limit = -70;
	self.turnright90limit = 70;
}

banzai_exposed_monitor()
{
	self endon( "death" );
	self endon ("killanimscript");
	self endon ("melee");

	lastPos = self.origin;
	nonmovements = 0;
	while(1)
	{
		if ( self is_banzai() )
		{
			distance = DistanceSquared(lastPos, self.origin);
			if (distance < 36 )//havent moved 6 inches, wtf
			{
				nonmovements++;
				if ( self.a.movement == "stop" || nonmovements>5 )
				{
					self.banzai = false;
					self.goalradius = 768;
					self.minDist = 128;
					self FindCoverNearSelf();
					return;
				}
			}
		}
	
		lastPos = self.origin;
		wait(2);
	}
}

exposedCombatMainLoop()
{
	self endon ("killanimscript");
	self endon ("melee");
	
	//prof_begin("combat_init2");
	
	self thread trackShootEntOrPos();
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
	
	self thread banzai_exposed_monitor();

	// aim awareness 
	self thread trackAimAwarenessLoop();

	if ( !self is_banzai() )
	{
		self thread ReacquireWhenNecessary();
	}
	
	self thread watchShootEntVelocity();
	
//	self thread attackEnemyWhenFlashed();
	
	if ( self.a.magicReloadWhenReachEnemy )
	{
		self animscripts\weaponList::RefillClip();
		self.a.magicReloadWhenReachEnemy = false;
	}
	
	self AnimMode("zonly_physics", false);
	
	// before, we oriented to enemy briefly and then changed to face current.
	// now we just face current immediately and rely on turning.
	self OrientMode( "face angle", self.angles[1] );
	nextShootTime = 0;
	
	self resetGiveUpOnEnemyTime();
	
	// hesitate to crouch.
	// crouching too early can look stupid because we'll tend to stand right back up in a lot of cases.
	self.a.dontCrouchTime = GetTime() + randomintrange( 500, 1500 );
	
	//prof_end("combat_init2");
	
	//prof_begin("combat");
	
	justWaited = false;
		
	for(;;)
	{		
		self IsInCombat(); // reset our in-combat state

		if ( !justWaited )
		{
			self set_aimturn_limits();
		}
		
		justWaited = false;
		
		//prof_begin("combat_partA");
		// it is important for this to be *after* the set_animarray calls!
		if ( EnsureStanceIsAllowed() )
		{
			continue;
		}
		
		if ( TryMelee() )
		{
			return;
		}
		
		// try idle strafing or aim reactions
		if( exposedBehavior() )
		{
			continue;
		}

		if( animscripts\shared::shouldThrowDownWeapon() && !self.a.idleStrafing )
		{
			lastWeaponType = weaponAnims();

			if ( self.a.pose != "stand" && self.a.pose != "crouch" )
			{
				transitionTo("crouch");
			}

			self notify( "kill_idle_thread" );

			animscripts\shared::throwDownWeapon();

			// AI_TODO: RPG throwdown anim ends in stand pose - why?
			if( lastWeaponType == "rocketlauncher" )
			{
				self.a.pose = "stand";
			}

			// restart aiming
			resetWeaponAnims();

			self SetAnim( %add_idle );
			self thread idleThread();

			continue;
		}
		
		if ( !IsDefined( self.shootPos ) )
		{
			assert( !IsDefined( self.shootEnt ) );

			/#
			self animscripts\debug::debugPushState( "cantSeeEnemyBehavior" );
			#/

			cantSeeEnemyBehavior();

			/#
			self animscripts\debug::debugPopState( "cantSeeEnemyBehavior" );
			#/

			continue;
		}
		
		assert( IsDefined( self.shootPos ) ); // we can use self.shootPos after this point.
		self resetGiveUpOnEnemyTime();

		// if we're too close to our enemy, stand up
		// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );

		if ( self.a.pose != "stand" && self IsStanceAllowed("stand") )
		{
			if ( distSqToShootPos < squared( 285 ) )
			{
				transitionTo("stand");
				continue;
			}

			if ( standIfMakesEnemyVisible() )
			{
				continue;
			}
		}

		if ( needToTurn() )
		{
			predictTime = 0.25;
			if ( IsDefined( self.shootEnt ) && !IsSentient( self.shootEnt ) )
			{
				predictTime = 1.5;
			}
			
			yawToShootEntOrPos = getPredictedAimYawToShootEntOrPos( predictTime ); // yaw to where we think our enemy will be in x seconds
			if ( TurnToFaceRelativeYaw( yawToShootEntOrPos ) )
			{
				continue;
			}
		}
		
		if ( self is_banzai() )
		{
			wait 0.05;
			justWaited = true;
			continue;
		}
		
		if ( considerThrowGrenade() ) // TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
		{
			continue;
		}
		
		//prof_end("combat_partA");
		
		//prof_begin("combat_partB");

/#
		if( GetDvarInt( #"scr_forceSideArm" ) == 1 )
		{
			self.forceSideArm = true;
		}
#/		

		
		if( IsDefined( self.forceSideArm ) && self.forceSideArm && self.a.pose == "stand" && !usingSidearm() && !self.a.idleStrafing )
		{
			if ( self tryUsingSidearm() )
			{
				continue;
			}
		}
		
		if ( NeedToReload( 0 ) )
		{
			// TODO: tweak prone exposed reloading to be considered safer
			// requiring self.weapon == self.primaryweapon because we dont want him to drop his shotgun and then, if wantshotgun = false, decide to pick up his rifle when he's done
		
			distSQ = lengthsquared( self.origin - self.shootPos );
			if ( distSQ > anim.chargeRangeSq && distSQ < anim.standRangeSq )
			{
				if ( !usingSidearm() && weaponAnims() != "rocketlauncher" && self IsStanceAllowed("stand") && self.weapon == self.primaryweapon )
				{
					// we need to be standing to switch weapons
					if ( self.a.pose != "stand" )
					{
						transitionTo("stand");
						//prof_end("combat_partB");
						continue;
					}
				
					if ( self tryUsingSidearm() )
					{
						//prof_end("combat_partB");
						continue;
					}
				}
			}
			else
			{
				if( usingSidearm() && (!IsDefined(self.forceSideArm) || !self.forceSideArm) )
				{
					switchToLastWeapon( animArray("pistol_putaway") );				
				}
			}

			if ( TryMelee() )
			{
				return;
			}
			
			if ( self exposedReload(0) )
			{
				//prof_end("combat_partB");
				continue;
			}
		}

		if ( usingSidearm() && self.a.pose == "stand" && lengthsquared( self.origin - self.shootPos ) > squared( 512 ) )
		{
			switchToLastWeapon( animArray("pistol_putaway") );
		}
		
		if ( distSqToShootPos > squared( 600 ) && self.a.pose != "crouch" && self IsStanceAllowed("crouch") && !usingSidearm() && GetTime() >= self.a.dontCrouchTime && !self.a.idleStrafing )
		{
			if ( lengthSquared( self.shootEntVelocity ) < 100*100 )
			{
				if ( !IsDefined( self.shootPos ) || sightTracePassed( self.origin + (0,0,36), self.shootPos, false, undefined ) )
				{
					transitionTo("crouch");

					// wait a little while before standing up to strafe
					self.a.nextIdleStrafeTime = GetTime() + RandomIntRange( 500, 1500 );

					//prof_end("combat_partB");
					continue;
				}
			}
		}

		//prof_end("combat_partB");
		
		//prof_begin("combat_partC");

		if ( aimedAtShootEntOrPos() && GetTime() >= nextShootTime && !self.a.idleStrafing )
		{
			/#
			self animscripts\debug::debugPushState( "shootUntilNeedToTurn" );
			#/

			// just in case shootWhileTurning is still running
			self notify("done turning");

			self shootUntilNeedToTurn();

			/#
			self animscripts\debug::debugPopState( "shootUntilNeedToTurn" );
			#/

			if ( !self usingShotgun() && !self usingBoltActionWeapon() )
			{
				self ClearAnim( %add_fire, .2 );
			}

			if ( self exposedRechamber() )
			{
				self notify ( "weapon_rechamber_done" );
				continue;
			}

			//prof_end("combat_partC");
			continue;
		}
	
		//prof_end("combat_partC");

		/#
		self animscripts\debug::debugPushState( "exposedWait" );
		#/

		// idleThread() is running, so just waiting a bit will cause us to idle
		exposedWait();
		justWaited = true;

		/#
		self animscripts\debug::debugPopState();
		#/
	}
	
	//prof_end("combat");
}

exposedWait()
{
	if ( !IsDefined( self.enemy ) || !self cansee( self.enemy ) )
	{
		self endon("enemy");
		self endon("shoot_behavior_change");
		
		wait 0.2 + RandomFloat( 0.1 );
		self waittill("do_slow_things");
	}
	else
	{
		wait 0.05;
	}
}

standIfMakesEnemyVisible()
{
	assert( self.a.pose != "stand" );
	assert( self IsStanceAllowed("stand") );
	
	if ( IsDefined( self.enemy ) && (!self cansee( self.enemy ) || !self canShoot( self.enemy GetShootAtPos() )) && sightTracePassed( self.origin + (0,0,64), self.enemy GetShootAtPos(), false, undefined ) )
	{
		self.a.dontCrouchTime = GetTime() + 3000;
		transitionTo("stand");
		return true;
	}

	return false;
}

needToTurn()
{
	// Old way, slower
/*	
	yawToShootEntOrPos = getAimYawToShootEntOrPos(); // yaw to where we think our enemy will be in x seconds
	
	return (abs( yawToShootEntOrPos ) > self.turnThreshold);
*/

	// New way
	point = self.shootPos;

	if ( !IsDefined( point ) )
	{
		return false;
	}

	yaw = self.angles[ 1 ] - VectorToAngles( point - self.origin )[1];

	// need to have fudge factor because the gun's origin is different than our origin,
	// the closer our distance, the more we need to fudge. 
	distsq = DistanceSquared( self.origin, point );
	if ( distsq < 256*256 )
	{
		dist = sqrt( distsq );
		if ( dist > 3 )
		{
			yaw += asin(-3/dist);
		}
	}

	return AbsAngleClamp180( yaw ) > self.turnThreshold;
}

EnsureStanceIsAllowed()
{
	curstance = self.a.pose;

	stances = array( "stand", "crouch", "prone" );

	if ( !self IsStanceAllowed( curstance ) )
	{
		assert( curstance == "stand" || curstance == "crouch" || curstance == "prone" );

		for( i=0; i < stances.size; i++ )
		{
			otherstance = stances[i];

			if( otherstance == curstance )
			{
				continue;
			}

			if ( self IsStanceAllowed( otherstance ) )
			{
				if ( curstance == "stand" && usingSidearm() )
				{
					if( switchToLastWeapon( animArray("pistol_putaway") ) )
					{
						return true;
					}
				}

				transitionTo( otherstance );
				return true;
			}
		}
	}
	return false;
}

cantSeeEnemyBehavior()
{
	//prof_begin("combat_cantSeeEnemyBehavior");

	if ( self.a.pose != "stand" && self IsStanceAllowed("stand") && standIfMakesEnemyVisible() )
	{
		return true;
	}

	time = GetTime();

	self.a.dontCrouchTime = time + 1500;

	if ( IsDefined( self.node ) && self.node.type == "Guard" )
	{
		relYaw = AngleClamp180( self.angles[1] - self.node.angles[1] );			
		if ( self TurnToFaceRelativeYaw( relYaw ) )
		{
			return true;
		}
	}
	else if (self.goalangle[1] != 0.0)
	{
		relYaw = AngleClamp180( self.angles[1] - self.goalangle[1] );			
		if ( self TurnToFaceRelativeYaw( relYaw ) )
		{
			return true;
		}
	}
	else if ( time > self.a.scriptStartTime + 1200 )
	{
		likelyEnemyDir = self getAnglesToLikelyEnemyPath();
		if ( IsDefined( likelyEnemyDir ) )
		{
			relYaw = AngleClamp180( self.angles[1] - likelyEnemyDir[1] );
			if ( self TurnToFaceRelativeYaw( relYaw ) )
			{
				return true;
			}
		}
		else if ( IsDefined( self.enemy ) && !IsAi( self.enemy ) && !IsPlayer( self.enemy ) ) //face script_origins and whatnot (ALEXP 3/12/10)
		{
			to_enemy = self.enemy.origin - self.origin;
			to_enemy_angles = VectorToAngles( to_enemy );

			relYaw = AngleClamp180( self.angles[1] - to_enemy_angles[1] );
			if ( self TurnToFaceRelativeYaw( relYaw ) )
			{
				return true;
			}
		}
	}

	if ( considerThrowGrenade() )
	{
		return true;
	}

	givenUpOnEnemy = (self.a.nextGiveUpOnEnemyTime < time);

	threshold = 0;
	if ( givenUpOnEnemy )
	{
		threshold = 0.99999;
	}

	if ( self exposedReload( threshold ) )
	{
		return true;
	}

	if ( givenUpOnEnemy && usingSidearm() )
	{
		// switch back to main weapon so we can reload it too before another enemy appears
		if( switchToLastWeapon( animArray("pistol_putaway") ) )
		{
			return true;
		}
	}

	cantSeeEnemyWait();	
	return true;
}

cantSeeEnemyWait()
{
	self endon("shoot_behavior_change");
	
	wait 0.4 + RandomFloat( 0.4 );
	self waittill("do_slow_things");
}

resetGiveUpOnEnemyTime()
{
	self.a.nextGiveUpOnEnemyTime = GetTime() + randomintrange( 2000, 4000 );
}

TurnToFaceRelativeYaw( faceYaw )
{
	/#
	self animscripts\debug::debugPushState( "turnToFaceRelativeYaw", faceYaw );
	#/

	if ( faceYaw < 0-self.turnThreshold )
	{
		if ( self.a.pose == "prone" )
		{
			self animscripts\cover_prone::proneTo( "crouch" );
			self set_aimturn_limits();
		}

		self turn("left", 0-faceYaw);
		self maps\_gameskill::didSomethingOtherThanShooting();

		/#
		self animscripts\debug::debugPopState( "turnToFaceRelativeYaw", "faceYaw < 0-self.turnThreshold" );
		#/

		return true;
	}

	if ( faceYaw > self.turnThreshold )
	{
		if ( self.a.pose == "prone" )
		{
			self animscripts\cover_prone::proneTo( "crouch" );
			self set_aimturn_limits();
		}

		self turn("right",  faceYaw);
		self maps\_gameskill::didSomethingOtherThanShooting();

		/#
		self animscripts\debug::debugPopState( "turnToFaceRelativeYaw", "faceYaw > self.turnThreshold" );
		#/

		return true;
	}

	/#
	self animscripts\debug::debugPopState();
	#/

	return false;
}

watchShootEntVelocity()
{
	self endon("killanimscript");

	self.shootEntVelocity = (0,0,0);

	prevshootent = undefined;
	prevpos = self.origin;
	
	interval = .15;
	
	while(1)
	{
		if ( IsDefined( self.shootEnt ) && IsDefined( prevshootent ) && self.shootEnt == prevshootent )
		{
			curpos = self.shootEnt.origin;
			self.shootEntVelocity = vector_scale( curpos - prevpos, 1 / interval );
			prevpos = curpos;
		}
		else
		{
			if ( IsDefined( self.shootEnt ) )
			{
				prevpos = self.shootEnt.origin;
			}
			else
			{
				prevpos = self.origin;
			}

			prevshootent = self.shootEnt;

			self.shootEntVelocity = (0,0,0);
		}

		wait interval;
	}
}

// does turntable movement to face the enemy;
// should be used sparingly because turn animations look better.
faceEnemyImmediately()
{
	self endon("killanimscript");
	self notify("facing_enemy_immediately");
	self endon("facing_enemy_immediately");
	
	maxYawChange = 5; // degrees per frame

	while(1)
	{
		yawChange = 0 - GetYawToEnemy();

		if ( abs( yawChange ) < 2 )
		{
			break;
		}

		if ( abs( yawChange ) > maxYawChange )
		{
			yawChange = maxYawChange * sign( yawChange );
		}

		self OrientMode( "face angle", self.angles[1] + yawChange );

		wait .05;
	}

	self OrientMode( "face current" );	

	self notify("can_stop_turning");
}

isDeltaAllowed( theanim )
{
	delta = getMoveDelta( theanim, 0, 1 );
	endPoint = self localToWorldCoords( delta );
	
	return self IsInGoal( endPoint ) && self mayMoveToPoint( endPoint );
}

turn( direction, amount )
{
	/#
	self animscripts\debug::debugPushState( "turn", direction + " by " + amount );
	#/

	knowWhereToShoot = IsDefined( self.shootPos );
	rate = 1;
	transTime = 0.2;
	mustFaceEnemy = (IsDefined( self.enemy ) && self canSee( self.enemy ) && DistanceSquared( self.enemy.origin, self.origin ) < 512*512);
	if ( self.a.scriptStartTime + 500 > GetTime() )
	{
		transTime = 0.25; // if it's the first thing we're doing, always blend slowly
		if ( mustFaceEnemy )
		{
			self thread faceEnemyImmediately();
		}
	}
	else
	{
		if ( mustFaceEnemy )
		{
			urgency = 1.0 - (distance( self.enemy.origin, self.origin ) / 512);
			rate = 1 + urgency * 1;

			// ( ensure transTime <= 0.2 / rate )
			if ( rate > 2 )
			{
				transTime = .05;
			}
			else if ( rate > 1.3 )
			{
				transTime = .1;
			}
			else
			{
				transTime = .15;
			}
		}
	}

	angle = 0;
	if ( amount > 157.5 )
	{
		angle = 180;
	}
	else if ( amount > 112.5 )
	{
		angle = 135;
	}
	else if ( amount > 67.5 )
	{
		angle = 90;
	}
	else
	{
		angle = 45;
	}

	animname = "turn_" + direction + "_" + angle;
	turnanim = animarray(animname);
	
	if ( IsDefined( self.node ) && self.node.type == "Guard" && DistanceSquared(self.origin, self.node.origin) < 16*16 && (self.goalradius < 16 || !IsDefined(self.enemy)) )
	{
		self AnimMode( "angle deltas" );
	}
	else if ( isDeltaAllowed( turnanim ) )
	{
		self AnimMode( "zonly_physics" );
	}
	else
	{
		self AnimMode( "angle deltas" );
	}

	self SetAnimKnobAll( %exposed_aiming, %body, 1, transTime );

	self.isturning = true;

//	println( self GetEntNum() + ": stop_tracking (time: " + GetTime() + ")" );

	waittillframeend;
	self notify("stop tracking");

	self _TurningAimingOn( transTime );

	self SetAnimLimited( %turn, 1, transTime );

	self SetFlaggedAnimKnobLimitedRestart( "turn", turnanim, 1, 0, rate );
	self notify("turning");

	if ( knowWhereToShoot && !self.heat )
	{
		self thread shootWhileTurning();
	}

	self thread turnStartAiming( turnanim, rate );

	doTurnNotetracks();

	self SetAnimLimited( %turn, 0, .2 );

	self _TurningAimingOff( .2 );

	self ClearAnim( %turn, .2 );
	self setanimknob( %exposed_aiming, 1, .2, 1 );

	// if we didn't actually turn, code prevented us from doing so.
	// give up and turntable.
	if ( IsDefined( self.turnLastResort ) )
	{
		self.turnLastResort = undefined;
		self thread faceEnemyImmediately();
	}

	if ( !self usingShotgun() && !self usingBoltActionWeapon() )
	{
		self ClearAnim( %add_fire, .2 );
	}

	/#
	self animscripts\debug::debugPopState( "turn" );
	#/
}

doTurnNotetracks()
{
	self endon("turning_isnt_working");
	self endon("can_stop_turning");
	
	//self thread makeSureTurnWorks(); // ALEXP 7/6/10: was causing a problem and saw that IW disabled this for MW2
	self animscripts\shared::DoNoteTracks( "turn" );
}

turnStartAiming( turnAnim, rate )
{
	self endon("killanimscript");
	self endon("death");

	if( animHasNotetrack( turnAnim, "start_aim" ) )
	{
		self waittillmatch( "turn", "start_aim" );
	}
	else
	{
		animLength = GetAnimLength( turnAnim ) / rate;
		wait( animLength * 0.8 );
	}

	self animscripts\shared::trackLoopStart();
}

makeSureTurnWorks()
{
	self endon("killanimscript");
	self endon("done turning");
	
	startAngle = self.angles[1];
	
	wait .3;
	
	if ( self.angles[1] == startAngle )
	{
		self notify("turning_isnt_working");
		self.turnLastResort = true;
	}
}

_TurningAimingOn( transTime )
{
	self SetAnimLimited    ( animarray("straight_level")    , 0, transTime );

	self SetAnim( %aim_2, 0, transTime );
	self SetAnim( %aim_4, 0, transTime );
	self SetAnim( %aim_6, 0, transTime );
	self SetAnim( %aim_8, 0, transTime );
	
	/*self SetAnimLimited( animarray("add_aim_up"   )     , 0, transTime );
	self SetAnimLimited( animarray("add_aim_down" )     , 0, transTime );
	self SetAnimLimited( animarray("add_aim_left" )     , 0, transTime );
	self SetAnimLimited( animarray("add_aim_right")     , 0, transTime );*/
	
	/*self SetAnimKnobLimited( animarray("add_turn_aim_up"   ), 1, transTime );
	self SetAnimKnobLimited( animarray("add_turn_aim_down" ), 1, transTime );
	self SetAnimKnobLimited( animarray("add_turn_aim_left" ), 1, transTime );
	self SetAnimKnobLimited( animarray("add_turn_aim_right"), 1, transTime );*/
	
	self SetAnim( %add_idle, 0, transTime );
}

_TurningAimingOff( transTime )
{
	self SetAnimLimited    ( animarray("straight_level")    , 1, transTime );
	
	/*self SetAnimKnobLimited( animarray("add_aim_up"   )     , 1, transTime );
	self SetAnimKnobLimited( animarray("add_aim_down" )     , 1, transTime );
	self SetAnimKnobLimited( animarray("add_aim_left" )     , 1, transTime );
	self SetAnimKnobLimited( animarray("add_aim_right")     , 1, transTime );*/
	
	/*self SetAnimLimited( animarray("add_turn_aim_up"   ), 0, transTime );
	self SetAnimLimited( animarray("add_turn_aim_down" ), 0, transTime );
	self SetAnimLimited( animarray("add_turn_aim_left" ), 0, transTime );
	self SetAnimLimited( animarray("add_turn_aim_right"), 0, transTime );*/
	
	self SetAnim( %add_idle, 1, transTime );
}

shootWhileTurning()
{
	self endon("killanimscript");
	self endon("done turning");
	
	if ( self weaponAnims() == "rocketlauncher" )
	{
		return;
	}

	// MikeD (10/11/2007): Stop the flamethrower from when turn starts, and delay the next shot for 250ms
	self flamethrower_stop_shoot( 250 );
	
	shootUntilShootBehaviorChange();

	// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
	self flamethrower_stop_shoot();

	
	self ClearAnim( %add_fire, .2 );
}

shootUntilNeedToTurn()
{
	self thread watchForNeedToTurnOrTimeout();
	self endon("need_to_turn");
	self endon("need_to_strafe");
	
	self thread keepTryingToMelee();
	self thread keepTryingToStrafe();
	
	shootUntilShootBehaviorChange();
	
	// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
	self flamethrower_stop_shoot();
	
	self notify("stop_watching_for_need_to_turn");
	self notify("stop_trying_to_melee");
	self notify("stop_trying_to_strafe");
}

watchForNeedToTurnOrTimeout()
{
	self endon("killanimscript");
	self endon("stop_watching_for_need_to_turn");
	self endon("need_to_strafe");
	
	endtime = GetTime() + 4000 + RandomInt(2000);
	
	while(1)
	{
		if ( GetTime() > endtime || needToTurn() )
		{
			self notify("need_to_turn");
			break;
		}
		wait .1;
	}
}

considerThrowGrenade()
{
	if ( !myGrenadeCoolDownElapsed() ) // early out for efficiency
	{
		return false;
	}

	self.a.nextGrenadeTryTime = GetTime() + 300; // don't try this too often

	players = GetPlayers();
	for (i=0;i<players.size;i++)
	{
		if ( IsDefined(players[i]) && IsDefined( players[i].throwGrenadeAtPlayerASAP ) && IsAlive(players[i]) )
		{
			if ( tryThrowGrenade( players[i], 200 ) )
			{
				return true;
			}
		}
	}

	if ( IsDefined( self.enemy ) )
	{
		return tryThrowGrenade( self.enemy, 850 );
	}

	return false;
}

tryThrowGrenade( throwAt, minDist )
{
	/#
	self animscripts\debug::debugPushState( "tryThrowGrenade" );
	#/

	if ( self.team == "axis" && RandomInt(100) < 25 )
	{
		/#
		self animscripts\debug::debugPopState( "tryThrowGrenade", "25% chance of fail" );
		#/

		return false;
	}

	threw = false;

	throwSpot = throwAt.origin;
	if ( !self canSee( throwAt ) )
	{
		if ( IsDefined( self.enemy ) && throwAt == self.enemy && IsDefined( self.shootPos ) )
		{
			throwSpot = self.shootPos;
		}
	}

	if ( !self canSee( throwAt ) )
	{
		minDist = 100;
	}
	
	if ( DistanceSquared( self.origin, throwSpot ) > minDist*minDist && self.a.pose == "stand" && !self.a.idleStrafing )
	{
		yaw = GetYawToSpot( throwSpot );
		if ( abs( yaw ) < 60 )
		{
			throwAnims = [];

			if ( isDeltaAllowed(animArray("grenade_throw_1")) )
			{
				throwAnims[throwAnims.size] = animArray("grenade_throw_1");
			}
			if ( isDeltaAllowed(animArray("grenade_throw_1")) )
			{
				throwAnims[throwAnims.size] = animArray("grenade_throw_1");
			}

			if ( throwAnims.size > 0 )
			{
				self SetAnim(%exposed_aiming, 0, .1);
				self AnimMode( "zonly_physics" );
				
				setAnimAimWeight(0, 0);
				
				threw = TryGrenade( throwAt, throwAnims[RandomInt(throwAnims.size)] );
				
				self SetAnim(%exposed_aiming, 1, .1);
				
				if ( threw )
				{
					setAnimAimWeight(1, .5); // ease into aiming
				}
				else
				{
					setAnimAimWeight(1, 0);
				}
			}
			else
			{
				/#
				self animscripts\debug::debugPopState( "tryThrowGrenade", "no throw anim that wouldn't collide with env" );
				#/
			}
		}
		else
		{
			/#
			self animscripts\debug::debugPopState( "tryThrowGrenade", "angle to enemy > 60" );
			#/
		}
	}
	else
	{
		if( DistanceSquared( self.origin, throwSpot ) < minDist*minDist )
		{
			/#
			self animscripts\debug::debugPopState( "tryThrowGrenade", "too close (<" + minDist + ")" );
			#/
		}
		else
		{
			/#
			self animscripts\debug::debugPopState( "tryThrowGrenade", "not standing" );
			#/
		}
	}

	if ( threw )
	{
		self maps\_gameskill::didSomethingOtherThanShooting();
	}

	/#
	self animscripts\debug::debugPopState( "tryThrowGrenade" );
	#/

	return threw;
}

transitionTo( newPose )
{
	if ( newPose == self.a.pose )
	{
		return;
	}

	/#
	self animscripts\debug::debugPushState( "transitionTo: " + newPose );
	#/
	
	// no stance change anims when using sidearm!
	//assert( !usingSidearm() );
	
	self ClearAnim( %root, .3 );
	
	self notify( "kill_idle_thread" );
/#
	//SUMEET_TODO - take this block out once the issues are resolved.
	if( GetDvar( #"debug_script_issues") == "on" )
	{
		if( self.a.script != "combat" && self.a.script != "cover_prone"  )
		{
			Print( "AI is in combat script but its script is " + self.a.script );
			anything = undefined;
			if( anything )
			{
				// do nothing, this is just to halt the script debugger, as on AssetEx, it does not halt sometimes.
			}
		}
		
		//AssertEx( ( self.a.script == "combat" ) || ( self.a.script == "cover_prone" ) , "AI is in combat script but its script is " + self.a.script );
	}
#/
	transAnim = animArray( self.a.pose + "_2_" + newPose );
	if ( newPose == "stand" )
	{
		rate = 2; // gotta stand up fast!
	}
	else
	{
		rate = 1;
	}

	if ( !animHasNoteTrack( transAnim, "anim_pose = \"" + newPose + "\"" ) )
	{
		println( "error: " + self.a.pose + "_2_" + newPose + " missing notetrack to set pose!" );
	}

	self setFlaggedAnimKnobAllRestart( "trans", transanim, %body, 1, .2, rate );

	//restart aiming
	setupAim( 0 );
	self SetAnim( %exposed_aiming, 1, 0 );

	transTime = getAnimLength( transanim ) / rate;
	playTime = transTime - 0.3;
	if ( playTime < 0.2 )
	{
		playTime = 0.2;
	}

	self animscripts\shared::DoNoteTracksForTime( playTime, "trans" );

	self ClearAnim( transanim, 0.2 );

	self.a.pose = newPose;

	self set_aimturn_limits();

	self SetAnimKnobAllRestart( animarray("straight_level"), %body, 1, .25 );
	setupAim( .25 );

	self SetAnim( %add_idle );
	self thread idleThread();

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#
	self animscripts\debug::debugPopState();
	#/
}

keepTryingToStrafe()
{
	self notify("stop_trying_to_strafe");

	self endon("killanimscript");
	self endon("stop_trying_to_strafe");
	self endon("shoot_behavior_change");
	self endon("need_to_strafe");
	self endon("kill_idle_thread");
	self endon("done turning");

	while(1)
	{
		if( self shouldIdleStrafe() )
		{
			self notify("need_to_strafe");
		}

		wait(0.1);
	}
}

keepTryingToMelee()
{
	self notify("stop_trying_to_melee");

	self endon("killanimscript");
	self endon("stop_trying_to_melee");
	self endon("done turning");
	self endon("need_to_turn");
	self endon("shoot_behavior_change");

	while(1)
	{
		wait .2 + RandomFloat(.3);

		// this function is running when we're doing something like shooting or reloading.
		// we only want to melee if we would look really stupid by continuing to do what we're trying to get done.
		// only melee if our enemy is very close.
		if ( IsDefined(self.enemy) && (DistanceSquared(self.enemy.origin, self.origin) < 100*100) && TryMelee() )
		{
			return;
		}
		else // Melee debugging
		{
			if( IsDefined( self.enemy ) && ( DistanceSquared( self.enemy.origin, self.origin) > 100*100 ) && ( IsDefined( self.a.exposedReloading ) && self.a.exposedReloading == true  ) )		
				animscripts\melee::debug_melee( "Not doing melee - Distance to enemy is more than 100 while reloading." );
		}
	}
}

TryMelee()
{
	/#
	self animscripts\debug::debugPushState( "tryMelee" );
	#/

	if( IsDefined( self.dontMelee ) && self.dontMelee )
		return false;

	if ( !IsDefined( self.enemy ) )
	{
		/#
		self animscripts\debug::debugPopState( "tryMelee", "no enemy" );
		#/

		return false;
	}

	// early out
	if ( DistanceSquared( self.origin, self.enemy.origin ) > 512*512 )
	{
		/#
		self animscripts\debug::debugPopState( "tryMelee", "enemy too far (>512)" );
		#/

		animscripts\melee::debug_melee( "Not doing melee - Distance to enemy is more than 512 units." );
		return false;
	}

	if ( self.a.pose == "prone" )
	{
		/#
		self animscripts\debug::debugPopState( "tryMelee", "in prone" );
		#/

		return false;
	}

	// MikeD (10/8/2007): No melee for flamethrower AI
	if( self usingGasweapon() )
	{
		/#
		self animscripts\debug::debugPopState( "tryMelee", "using gas weapon" );
		#/

		return false;
	}

	if ( !NeedToReload( 0 ) )
	{
		// we have other options, so don't melee unless we're really close
		if ( DistanceSquared(self.enemy.origin, self.origin) > 200*200 )
		{
			/#
			self animscripts\debug::debugPopState( "tryMelee", "don't need to reload and enemy is > 200 away" );
			#/

			animscripts\melee::debug_melee( "Not doing melee - No need to reload and distance to enemy is more than 200." );
			return false;
		}
	}

	canMelee = animscripts\melee::CanMeleeDesperate();

	if ( !canMelee )
	{
		/#
		self animscripts\debug::debugPopState( "tryMelee" );
		#/

		return false;
	}

	// TODO: this is dangerous. during a weapon switch, our enemy might die/change or the situation might change in other ways.
	// TryMelee needs to return false if it's not possible to *immediately* start a melee,
	// so the global logic function needs to be the one to do the weapon switch if it's necessary.
	//switchToLastWeapon( %pistol_stand_switch_F );
		
	if ( self can_banzai_melee() )
	{
		self thread animscripts\banzai::banzai_attack();
	}
	else
	{
		self thread startMelee();
	}

	/#
	self animscripts\debug::debugPopState( "tryMelee", "no enemy" );
	#/

	return true;
}

startMelee()
{
	self notify("killanimscript");
	waittillframeend;

	self thread animscripts\melee::MeleeCombat();
	self melee_notify_wrapper();
}

// If I am a banzai guy, and either I'm attacking an AI or else I randomly choose to, do a banzai attack.
can_banzai_melee()
{
	if ( !IsDefined( self.banzai ) || !self.banzai )
	{
		return false;
	}

	if ( !self maps\_bayonet::has_bayonet() )
	{
		return false;
	}

	//banzaiAttackChance = 100;

	//if ( IsDefined( self.script_banzai_attack_chance ) )
	//	banzaiAttackChance = self.script_banzai_attack_chance;
	
	// If I am a banzai guy, and either I'm attacking an AI or else I randomly choose to, do a banzai attack.
	//if ( IsPlayer( self.enemy ) &&  RandomInt( 100 ) >= banzaiAttackChance )
	//	return false;
		
	return !self.enemy animscripts\banzai::in_banzai_melee();
}

exposedReload(threshold)
{
	// if doing strafing then just refill the clip and dont do the actual reaload animation

	if ( NeedToReload( threshold ) )
	{
		// MikeD (10/9/2007): Flamethrower AI do not reload
		if( self usingGasWeapon() || self.a.idleStrafing )
		{
			self animscripts\weaponList::RefillClip();
			return true;
		}

		/#
		self animscripts\debug::debugPushState( "exposedReload" );
		#/

		self.a.exposedReloading = true;

		reloadAnim = animArrayPickRandom( "reload" );

		// if crouching will give us cover while reloading, do it
		if ( self.a.pose == "stand" && self IsStanceAllowed( "crouch" ) && animArrayAnyExist( "reload_crouchhide" ) && IsDefined( self.enemy ) && self canSee( self.enemy ) )
		{
			if ( !sightTracePassed( self.origin + (0,0,50), self.enemy GetShootAtPos(), false, undefined ) )
			{
				reloadAnim = animArrayPickRandom( "reload_crouchhide" );
			}
		}

		self thread keepTryingToMelee();
		
		self SetAnim( %reload,1,.2 );

		self ClearAnim( %add_fire, 0 );
		
		self.finishedReload = false;
		self doReloadAnim( reloadAnim, threshold > .05 ); // this will return at the time when we should start aiming
		self notify("abort_reload"); // make sure threads that doReloadAnim() started finish

		if ( self.finishedReload )
		{
			self animscripts\weaponList::RefillClip();
		}

		// If pose is changed after the reload is over then change the anim set		
		newPose = self.a.pose;	
	
		self set_aimturn_limits();
		
		// Clear the reload animation		
		self ClearAnim(%reload, 0.1);
		wait(0.1);

		self notify("stop_trying_to_melee");
		
		self.a.exposedReloading = false;
		
		self maps\_gameskill::didSomethingOtherThanShooting();
		
		// this should prevent the guys from shooting into the ground.
		// HACK: we should fix this properly at some point
		if (self usingBoltActionWeapon() )
		{
			wait 0.2;
		}

		/#
		self animscripts\debug::debugPopState();
		#/
		
		return true;
	}
	
	return false;
}

doReloadAnim( reloadAnim, stopWhenCanShoot )
{
	self endon("abort_reload");

	if ( stopWhenCanShoot )
	{
		self thread abortReloadWhenCanShoot();
	}

	animRate = 1;
	/*if ( !self usingSidearm() && !self usingShotgun() && IsDefined( self.enemy ) && self canSee( self.enemy ) && DistanceSquared( self.enemy.origin, self.origin ) < 1024*1024 )
	{
		dist = distance( self.enemy.origin, self.origin );
		urgency = 1 - ((dist - 512.0) / 512.0);
		if ( urgency > 1 )
			urgency = 1;
		animRate = 1 + urgency * 1;
	}*/
	
	flagName = "reload_" + getUniqueFlagNameIndex();
	
	// ALEXP_MOD (8/19/09) - allow aiming during reloads
	self SetFlaggedAnimKnobAllRestart( flagName, reloadAnim, %root, 1, .2, animRate );
	self SetAnim( %exposed_aiming, 1, 0 ); // re-enable aiming since the knob part above kills it

	self thread notifyOnStartAim( "abort_reload", flagName );
	self endon("start_aim");
	self animscripts\shared::DoNoteTracks( flagName );
	
	self.finishedReload = true;
}

abortReloadWhenCanShoot()
{
	self endon("abort_reload");
	self endon("killanimscript");

	while(1)
	{
		if ( IsDefined( self.shootEnt ) && self canSee( self.shootEnt ) )
		{
			break;
		}

		wait .05;
	}

	self notify("abort_reload");
}

notifyOnStartAim( endonStr, flagName )
{
	self endon( endonStr );
	self endon("killanimscript");
	self waittillmatch( flagName, "start_aim" );
	self.finishedReload = true;
	self notify( "start_aim" );
}

finishNoteTracks(animname)
{
	self endon("killanimscript");
	animscripts\shared::DoNoteTracks(animname);
}

tryUsingSidearm()
{
	if( !AIHasSidearm() )
	{
		return false;
	}

	// MikeD (10/9/2007): Flamethrower AI should not use sidearms
	if( self usingGasweapon() )
	{
		return false;
	}

	// If AI has secondary weapon other than pistol then AI should not use sidearm
	if( hasSecondaryWeapon() )
	{
		return false;
	}

	if( !self.a.allow_sideArm )
	{
		return false;
	}

	// already using a pistol, don't switch
	if( usingPistol() )
	{
		return false;
	}
	
	// dont try random chance if forceSideArm is set.
	if( !IsDefined( self.forceSideArm ) || ( IsDefined( self.forceSideArm ) && !self.forceSideArm ) )
	{
		if( RandomInt(100)<85 )
		{
			return false;
		}	
	}

	switchToSidearm( animArray("pistol_pullout") );
	return true;
}


switchToSidearm( swapAnim )
{
	self endon ( "killanimscript" );

	/#
	self animscripts\debug::debugPushState( "switchToSidearm" );
	#/

	assert( self.sidearm != "" );

	if( !IsDefined(self.forceSideArm) || !self.forceSideArm )
	{
		self thread putGunBackInHandOnKillAnimScript();
	}

	self ClearAnim( animArray("straight_level"), 0.2 );

	self OrientMode("face current");

	self.pistolSwitchTime = GetTime() + 9000 + RandomInt(3000);
	self.swapAnim = swapAnim;
	self setFlaggedAnimKnobAllRestart("weapon swap", swapAnim, %body, 1, .2, 1);
	self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePickup, "end_weapon_swap" );	
	self ClearAnim( self.swapAnim, 0 );

	self OrientMode("face default");
	
	self maps\_gameskill::didSomethingOtherThanShooting();

	/#
	self animscripts\debug::debugPopState();
	#/
}

DoNoteTracksPostCallbackWithEndon( flagName, interceptFunction, endonMsg )
{
	self endon( endonMsg );
	self animscripts\shared::DoNoteTracksPostCallback( flagName, interceptFunction );
}

faceEnemyDelay( delay )
{
	self endon("killanimscript");
	wait delay;
	self faceEnemyImmediately();
}

handlePickup( notetrack )
{
	if ( notetrack == "pistol_pickup" )
	{
		self ClearAnim( animarray("straight_level"), 0 );
		
		self thread faceEnemyDelay( 0.25 );
	}
	else if ( notetrack == "start_aim" )
	{
		if ( self needToTurn() )
		{
			self notify("end_weapon_swap");
		}
		else
		{
			self SetAnimLimited( animarray("straight_level"), 1, 0 );
			setupAim( 0 );
			self SetAnim( %exposed_aiming, 1, .2 );
		}
	}
}


// %pistol_stand_switch
switchToLastWeapon( swapAnim )
{
	self endon ( "killanimscript" );

	// don't switch back if it's forced
	if( usingPistol() )
	{
		if( IsDefined(self.forceSideArm) && self.forceSideArm )
		{
			return false;
		}
		else if( self.sideArm == self.weapon )
		{
			return false;
		}
	}

	// don't switch back if there's nothing to switch to
	if( !AIHasPrimaryWeapon() )
	{
		return false;
	}

	/#
	self animscripts\debug::debugPushState( "switchToLastWeapon" );
	#/

	assert( self.lastWeapon != getAISidearmWeapon() );
	assert( self.lastWeapon == getAIPrimaryWeapon() || self.lastWeapon == getAISecondaryWeapon() );

	self ClearAnim( animArray("straight_level"), 0.2 );

	self OrientMode("face current");
	
	self.swapAnim = swapAnim;
	self setFlaggedAnimKnobAllRestart( "weapon swap", swapAnim, %body, 1, .1, 1 );
	self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePutaway, "end_weapon_swap" );
	self ClearAnim( self.swapAnim, 0.2 );

	self OrientMode("face default");

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#
	self animscripts\debug::debugPopState();
	#/

	return true;
}

handlePutaway( notetrack )
{
	if ( notetrack == "pistol_putaway" )
	{
		self ClearAnim( animarray("straight_level"), 0 );
	}
	else if ( notetrack == "start_aim" )
	{
		if ( self needToTurn() )
		{
			self notify("end_weapon_swap");
		}
		else
		{
			self SetAnimLimited( animarray("straight_level"), 1, 0 );
			setupAim( 0 );
			self SetAnim( %exposed_aiming, 1, .2 );
		}
	}
}

ReacquireWhenNecessary()
{
	self endon("killanimscript");
	self endon("melee");

	self.a.exposedReloading = false;
	// don't look for a cover node right away. stand and fight.
	self.a.lookForNewCoverTime = GetTime() + randomintrange( 800, 1500 );

	if ( self.fixedNode )
	{
		return;
	}

	while(1)
	{
		wait .05;
		
		if ( self.fixedNode )
		{
			return;
		}

		TryExposedReacquire();
	}
}

ShouldFindCoverNearSelf()
{
	// don't look for cover right after starting exposed behavior
	if ( GetTime() < self.a.lookForNewCoverTime )
	{
		return false;
	}
	
	if ( self canSee( self.enemy ) )
	{
		// try to finish off the player if damaged
		if ( IsPlayer( self.enemy ) && self.enemy.health < self.enemy.maxHealth * .8 )
		{
			return false;
		}

		// stand and fight unless we need to reload soon
		return self NeedToReload( .5 );
	}
	else
	{
		// try sidestepping first
		if ( self.reacquire_state <= 2 )
		{
			return false;
		}

		if ( self.a.exposedReloading )
		{
			return false;
		}

		return true;
	}
}

// this function is meant to be called many times in succession.
// each time it tries another option, until eventually it finds something it can do.
TryExposedReacquire()
{
	//prof_begin( "TryExposedReacquire" );
	if ( !isValidEnemy(self.enemy) )
	{
		self.reacquire_state = 0;
		return;
	}
	
	if ( self ShouldFindCoverNearSelf() )
	{
		prevNode = self.node;

		if ( self FindCoverNearSelf() )
		{
			// don't do the cover search every frame if we keep
			// coming up with same node, but not moving towards it
			newNode = self.node;
			if( IsDefined(prevNode) && IsDefined(newNode) && newNode == prevNode )
			{
				self.a.lookForNewCoverTime = GetTime() + randomintrange( 500, 1000 );
			}

			self.reacquire_state = 0;
			return;
		}
	}
	
	if ( self canSee( self.enemy ) )
	{
		self.reacquire_state = 0;
		return;
	}
		
	if ( self.a.exposedReloading && NeedToReload( .25 ) && self.enemy.health > self.enemy.maxhealth * .5 )
	{
		self.reacquire_state = 0;
		return;
	}
	
	switch (self.reacquire_state)
	{
	case 0:
		if (self ReacquireStep(32))
		{
			assert(self.reacquire_state == 0);
			return;
		}
		break;

	case 1:
		if (self ReacquireStep(64))
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 2:
		if (self ReacquireStep(96))
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 3:
		if ( self.a.script != "combat" )
		{
			self.reacquire_state = 0;
			return;
		}

		self FindReacquireNode();
		self.reacquire_state++;
		// fall through

	case 4:
		node = self GetReacquireNode();
		if (IsDefined(node))
		{			
			oldKeepNodeInGoal = self.keepClaimedNodeInGoal;
			oldKeepNode = self.keepClaimedNode;
			self.keepClaimedNodeInGoal = false;
			self.keepClaimedNode = false;

			if (self UseReacquireNode(node))
			{
				self.reacquire_state = 0;
			}
			else
			{
				self.keepClaimedNodeInGoal = oldKeepNodeInGoal;
				self.keepClaimedNode = oldKeepNode;
			}
			
			return;
		}
		break;

	case 5:
		if ( tryRunningToEnemy( false ) )
		{
			self.reacquire_state = 0;
			return;
		}
			
		break;

	default:
		assert(self.reacquire_state == 6);
		self.reacquire_state = 0;
		if ( !(self canSee( self.enemy )) )
			self FlagEnemyUnattackable();
		return;
	}
	
	self.reacquire_state++;
}

shouldGoToNode( node )
{
	// This function used to prevent us from turning our back to our enemy.
	// This isn't necessary now that we can shoot while running away.
	return true;
	
	/*
	// if we're close to our enemy, and we can see them,
	// don't run away from them.
	
	if ( !isValidEnemy( self.enemy ) )
		return true;
	
	if ( !IsSentient( self.enemy ) )
		return true;
	
	if ( !self cansee( self.enemy ) )
		return true;
	
	// we're in our enemy's line of sight.
	
	enemyAngles = undefined;
	if ( IsPlayer( self.enemy ) ) {
		enemyAngles = self.enemy getPlayerAngles();
	}
	else {
		// would like to use tag_weapon, but no way to tell if they have one or not
		enemyAngles = self.enemy.angles;
	}
	
	angleToEnemyLook = vectordot( AnglesToForward( enemyAngles ), VectorNormalize( self.origin - self.enemy.origin ) );
	
	// if we're far away and our enemy isn't looking at us, it's ok to move
	if ( DistanceSquared( self.origin, self.enemy.origin ) > 400 * 400 && angleToEnemyLook < cos( 10 ) )
		return true;
	
	// if the cover is between us and our enemy, it's ok to move
	enemyDist = distance( self.origin, self.enemy.origin );
	if ( distance( self.enemy.origin, node.origin ) < enemyDist * .8 && distance( self.origin, node.origin ) < enemyDist * .8 )
		return true;
	
	// don't turn our back.
	return false;
	*/
}

exposedRechamber()	// only runs on guys with new_rechamber defined
{
	if( !NeedToRechamber() )
	{
		return false;
	}

	if( self.a.pose != "prone" )
	{	
		self.a.isRechambering = 1;

		self doRechamberAnim();

		self SetAnimKnobAllRestart( animarray("straight_level"), %body, 1, .2 );
		self SetAnim( %add_idle );

		self.a.needsToRechamber = 0;
		self.a.isRechambering = 0;

		wait (0.2);

		if ( IsDefined(self.primaryweapon) )
		{
			animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
		}
	}

	return true;
}

doRechamberAnim()
{
	self endon("killanimscript");
	self endon("abort_rechamber");

	self ClearAnim( %add_fire, 0 );

	flagName = "rechamber_" + getUniqueFlagNameIndex();
	rechamberAnim = animArray("rechamber");

	// Set the rechamber anim
	self SetFlaggedAnimKnobAllRestart(flagName, rechamberAnim, %body, 1, .2, 1);
	self SetAnim( %exposed_aiming, 1, 0 ); // re-enable aiming since the knob part above kills it

	self thread notifyOnStartAim("abort_rechamber", flagName);
	self endon("start_aim");	// end on this notetrack so we can start blending out the anim

	animscripts\shared::DoNoteTracks(flagName);
}

resetWeaponAnims()
{
	self ClearAnim( %aim_4, 0 );
	self ClearAnim( %aim_6, 0 );
	self ClearAnim( %aim_2, 0 );
	self ClearAnim( %aim_8, 0 );
	self ClearAnim( %exposed_aiming, 0 );
	
	self SetAnimKnobAllRestart( animarray("straight_level"), %body, 1, .2 );
	setupAim( .2 );
}

aimAwareAnimScript()
{
	self endon("death");
	self endon("killanimscript");
	
	// aim awareness anim
	reactionAnimArray = animArray( "aim_aware_reaction" );

	// remove blocked animations
	reactionAnimArray = animscripts\react::removeBlockedAnims( reactionAnimArray );

	// remove disallowed stance animations
	reactionAnimArray = removeDisallowedStanceAnims( reactionAnimArray );

	// select final animation
	if( reactionAnimArray.size > 0 )
		reactionAnim = reactionAnimArray[ RandomInt( reactionAnimArray.size ) ];
	else
		return false; // no animation to player based on current geo

	// for animation testing purposes
	/#
	debugAnimIndex = GetDvarInt( #"scr_aimAwareAnimIndex" );
	if( debugAnimIndex )
	{
		reactionAnimArray = animArray( "aim_aware_reaction" );
		
		if( (debugAnimIndex-1) < reactionAnimArray.size )
		{
			reactionAnim = reactionAnimArray[debugAnimIndex-1];
		}

	}
	#/

	self.a.reactingToAim = true;

	/#
		self animscripts\debug::debugPushState( "idleStrafe - Aware of Aim" );
	#/

	// set next aim awareness reaction time
	self.a.nextAimReactionTime = GetTime() + RandomIntRange( 2000, 4000 );

	self AnimMode("none");

	blendouttime = 0;
	time = GetAnimLength( reactionAnim );
	
	// play the animation here
	self ClearAnim( %body, 0.1 );
	self SetFlaggedAnimKnobAllRestart( "aim_reaction", reactionAnim, %body, 1, .1, 1 );
	self thread doAimAwareNotetracks( "aim_reaction" );

	if( animHasNotetrack( reactionAnim, "start_aim" ) )
	{
		self waittillmatch( "aim_reaction", "start_aim" );

		setupAim( 0.05 );

		self SetAnim( %add_idle );
		self thread idleThread();

		self trackShootEntOrPos();
	
		self.shoot_while_moving_thread = undefined;
		self thread animscripts\run::runShootWhileMovingThreads();
	}

	// wait for animation to blendout
	timeLeft = time - self GetAnimTime( reactionAnim ) * time - blendouttime;

	if( timeLeft > 0 )
	{
		wait( timeLeft );
	}

	self.a.reactingToAim = false;

	// don't idle strafe right away
	if( self.a.pose == "stand" )
	{
		self.a.nextIdleStrafeTime = GetTime() + RandomIntRange( 0, 500 );
	}
	else
	{
		self.a.nextIdleStrafeTime = GetTime() + RandomIntRange( 500, 1500 );
	}

	self thread animscripts\run::stopShootWhileMovingThreads();

	self notify("done_aimaware");

	/#
		self animscripts\debug::debugPopState( "idleStrafe - Aware of Aim" );
	#/
}

doAimAwareNotetracks( flagName )
{
	self notify("stop_DoNotetracks");

	self endon("killanimscript");
	self endon("death");
	self endon("stop_DoNotetracks");

	self animscripts\shared::DoNoteTracks( flagName );
}

shouldBeAwareOfAim()
{
	// disabling idlestrafing also disables aim awareness
	if( IsDefined( self.disableIdleStrafing ) && self.disableIdleStrafing )
		return false;

	// if the AI goalradius is smaller than 128 then assume that he should be stationary
	if( self.goalradius < 128 )
		return false;

	// only be aim aware if exposed
	if( self.a.script != "combat" )
		return false;

	// aim awareness is only for axis AI
	if( self.team == "allies" )
		return false;

	// VC is untrained
	if( self.animType == "vc" )
		return false;

	// if ignoring everyone
	if( self.ignoreall )
		return false;

	// no aim awareness for pistol and rocketlauncher AI
	if( usingPistol() || weaponAnims() == "rocketlauncher" )
		return false;

	// consider this behavior as a part of idle strafing
	if( IsDefined( self.a.nextAimReactionTime ) && ( GetTime() < self.a.nextAimReactionTime ) )
		return false;
	
	if( IsDefined( self.a.reactingToAim ) && self.a.reactingToAim )
		return false;

	// don't interfere with melee
	if( IsDefined( self.enemy ) && DistanceSquared( self.enemy.origin, self.origin ) < anim.meleeRangeSq )
		return false;

	// check if allowed to stand and crouch as reaction animations may change stance
	//if( !self IsStanceAllowed( "stand" ) || !self IsStanceAllowed( "crouch" ) )
	//	return false;

	// check if any animation exists for current stance
	if( !animArrayAnyExist( "aim_aware_reaction" ) )
		return false;

	return true;
}

trackAimAwarenessLoop()
{
	self notify("stop_trackAimAwarenessLoop");

	self endon("death");
	self endon("killanimscript");
	self endon("stop_trackAimAwarenessLoop");

	while(1)
	{
		if( !IsDefined( level.cos15 ) )
		{
			level.cos15 = cos(15);
			level.cos20 = cos(20);
		}

		// minimum distance for aim awareness
		minAwarenessDistSq = 800 * 800;

		// check if enemy is player
		if( !IsDefined( self.enemy ) || !IsPlayer( self.enemy ) )
		{
			wait(1);
			continue;
		}

		Assert( IsPlayer( self.enemy ) );

		player = self.enemy;

		// check if the player is near enough
		if( DistanceSquared( self.origin, player.origin ) > minAwarenessDistSq )
		{
			wait(1);
			continue;
		}

		playerForwardVec = AnglesToForward( self.enemy GetPlayerAngles() );
		playerEnemyVec	 = VectorNormalize( self.origin - player.origin );

		if( self.a.pose == "stand" )
			fovDot = level.cos15;
		else
			fovDot = level.cos20;

		// check if AI is player FOV and player is aimed down sights
		if( VectorDot( playerForwardVec, playerForwardVec ) > fovDot && player IsLookingAt( self ) )
		{
			// AI is within players FOV range, now check AI's FOV
			aiForwardVec = AnglesToForward( self.angles );
			aiEnemyVec	 = VectorNormalize( player.origin - self.origin );

			if( VectorDot( aiForwardVec, aiEnemyVec ) > fovDot && shouldBeAwareOfAim() )
			{
				// now that we know this AI is being aimed at
				// see if the reaction is needed
				self animcustom( ::aimAwareAnimScript );
			}
		}

		wait(0.05);
	}
}

// check out if there are stance changing notetracks and make sure the AI is allowed to be in that stance
removeDisallowedStanceAnims( animArray )
{
	newAnimArray = [];
	for ( i = 0; i < animArray.size; i++ )
	{
		animStanceIsOk = true;

		notetracks = GetNotetracksInDelta( animArray[i], 0, 9999 );

		for( j = 0; j < notetracks.size; j++ )
		{
			if( notetracks[j][1] == "anim_pose = \"stand\"" && !self IsStanceAllowed("stand") )
			{
				animStanceIsOk = false;
				break;
			}
			else if( notetracks[j][1] == "anim_pose = \"crouch\"" && !self IsStanceAllowed("crouch") )
			{
				animStanceIsOk = false;
				break;
			}
			else if( notetracks[j][1] == "anim_pose = \"prone\"" && !self IsStanceAllowed("prone") )
			{
				animStanceIsOk = false;
				break;
			}
		}

		if ( animStanceIsOk )
		{
			newAnimArray[newAnimArray.size] = animArray[i];
		}
	}

	return newAnimArray;
}