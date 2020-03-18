#include animscripts\Utility;
#include animscripts\Combat_Utility;
#include animscripts\SetPoseMovement;
#include animscripts\debug;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_utility; 
#using_animtree ("generic_human");

MoveRun()
{
	/#
	self animscripts\debug::debugPushState( "MoveRun" );
	#/

	desiredPose = self animscripts\utility::choosePose( "stand" );

	switch ( desiredPose )
	{
		case "stand":
			if ( BeginStandRun() ) // returns false (and does nothing) if we're already stand-running
			{
				/#
				self animscripts\debug::debugPopState( "MoveRun", "already running" );
				#/
				return;
			}
			
			if ( changeWeaponStandRun() )
			{
				/#
				self animscripts\debug::debugPopState( "MoveRun", "switched weapon" );
				#/
				return;
			}
			
			if ( ReloadStandRun() )
			{
				/#
				self animscripts\debug::debugPopState( "MoveRun", "reloaded" );
				#/
				return;
			}

			if( self call_overloaded_func( "animscripts\cqb", "shouldCQB" ) )
			{
				/#
				self animscripts\debug::debugPushState( "MoveStandCombatNormal (CQB)" );
				#/

				MoveStandCombatNormal();

				/#
				self animscripts\debug::debugPopState( "MoveStandCombatNormal (CQB)" );
				self animscripts\debug::debugPopState( "MoveRun" );
				#/

				// ALEXP 7/2/10: no reloads until we get anim support
				return;
			}
			
			if ( self animscripts\utility::IsInCombat() )
			{
				if ( IsDefined( self.run_combatanim ) )
				{
					/#
					self animscripts\debug::debugPushState( "MoveStandCombatOverride" );
					#/

					MoveStandCombatOverride();

					/#
					self animscripts\debug::debugPopState( "MoveStandCombatOverride" );
					#/
				}
				else
				{
					/#
					self animscripts\debug::debugPushState( "MoveStandCombatNormal" );
					#/

					MoveStandCombatNormal();

					/#
					self animscripts\debug::debugPopState( "MoveStandCombatNormal" );
					#/
				}
			}
			else
			{
				if ( IsDefined( self.run_noncombatanim ) )
				{
					/#
					self animscripts\debug::debugPushState( "MoveStandNoncombatOverride" );
					#/

					MoveStandNoncombatOverride();

					/#
					self animscripts\debug::debugPopState( "MoveStandNoncombatOverride" );
					#/
				}
				else
				{
					/#
					self animscripts\debug::debugPushState( "MoveStandNoncombatNormal" );
					#/

					MoveStandNoncombatNormal();

					/#
					self animscripts\debug::debugPopState( "MoveStandNoncombatNormal" );
					#/
				}
			}
			break;
			
		case "crouch":
			if ( BeginCrouchRun() ) // returns false (and does nothing) if we're already crouch-running
			{
				/#
				self animscripts\debug::debugPopState( "MoveRun", "already running" );
				#/
				return;
			}
			
			if ( IsDefined( self.crouchrun_combatanim ) )
			{
				/#
				self animscripts\debug::debugPushState( "MoveCrouchRunOverride" );
				#/

				MoveCrouchRunOverride();

				/#
				self animscripts\debug::debugPopState( "MoveCrouchRunOverride" );
				#/
			}
			else
			{
				/#
				self animscripts\debug::debugPushState( "MoveCrouchRunNormal" );
				#/

				MoveCrouchRunNormal();

				/#
				self animscripts\debug::debugPopState( "MoveCrouchRunNormal" );
				#/
			}
			break;
	
		default:
			assert(desiredPose == "prone");
			if ( BeginProneRun() ) // returns false (and does nothing) if we're already prone-running
			{
				/#
				self animscripts\debug::debugPopState( "MoveRun", "already running" );
				#/
				return;
			}
			
			ProneCrawl();
			break;
	}

	/#
	self animscripts\debug::debugPopState( "MoveRun" );
	#/
}

GetRunAnim()
{
	run_anim = undefined;

	if( self isCQBWalking() && self.a.pose == "stand" ) 
	{
		if ( self.movemode == "walk" || self.walk )
		{
			run_anim = animArrayPickRandom("cqb_walk_f", "move", true);
		}
		else if( self.sprint )
		{
			run_anim = animArrayPickRandom("cqb_sprint_f", "move", true);
		}
		else
		{
			run_anim = animArrayPickRandom("cqb_run_f", "move", true);
		}
	}
	else if ( IsDefined( self.a.combatRunAnim ) )
	{
		run_anim = self.a.combatRunAnim;
	}
	else if( self.sprint && self.a.pose == "stand" )
	{
		run_anim = animArray("sprint", "move");
	}
	else if( self.a.isAiming && self.a.pose == "stand" )
	{
		run_anim = animArray("run_n_gun_f", "move");
	}
	else
	{
		run_anim = animArray("combat_run_f", "move");
	}

	assertex(IsDefined(run_anim), "run.gsc - No run animation for this AI.");

	return run_anim;
}

GetCrouchRunAnim()
{
	if ( IsDefined( self.a.crouchRunAnim ) )
	{
		return self.a.crouchRunAnim;
	}

	if( self.a.pose != "crouch" )
	{
		return animArray("crouch_run_f", "move");	
	}

	return animArray("combat_run_f", "move");
}


ProneCrawl()
{
	/#
	self animscripts\debug::debugPushState( "proneCrawl" );
	#/

	self.a.movement = "run";
	self SetFlaggedAnimKnob( "runanim", animArray("combat_run_f"), 1, .3, self.moveplaybackrate );
	animscripts\shared::DoNoteTracksForTime(0.25, "runanim");

	/#
	self animscripts\debug::debugPopState();
	#/
}


DoNoteTracksNoShootStandCombat(animName)
{
	animscripts\shared::DoNoteTracksForTime(getRunAnimUpdateFrequency(), animName);	
}

MoveStandCombatOverride()
{
	self ClearAnim(%combatrun, 0.6);
	self SetAnimKnobAll(%combatrun, %body, 1, 0.5, self.moveplaybackrate);
	self SetFlaggedAnimKnob("runanim", self.run_combatanim, 1, 0.5, self.moveplaybackrate);
	DoNoteTracksNoShootStandCombat("runanim");
}

aimingOn()
{
	self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 );

	aimAnimName = "add_f";
	
	if( self call_overloaded_func( "animscripts\cqb", "shouldCQB" ) && self.a.pose == "stand" )
	{
		aimAnimName = "cqb_f";
	}

	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_up"     ),	1, 0.2 );
	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_down"   ),	1, 0.2 );
	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_left"   ),	1, 0.2 );
	self SetAnimKnobLimited( animArray( aimAnimName + "_aim_right"  ),	1, 0.2 );

	self.a.isAiming = true;
	self.aimAngleOffset = 0;
}

MoveStandCombatNormal()
{
	self ClearAnim( %walk_and_run_loops, 0.2 );

	self setanimknob( %combatrun, 1.0, 0.5, self.moveplaybackrate );

	decidedAnimation			= false;
	self.a.isAiming				= false;
	self.a.isStrafingBackwards	= false;

	runAnimName					= "run_n_gun";

	if( self isCQBWalking() )
	{
		if( self.movemode == "walk" || self.walk )
		{
			runAnimName = "cqb_walk";
		}
		else if( self.sprint )
		{
			runAnimName = "cqb_sprint";
		}
		else
		{
			runAnimName = "cqb_run";
		}

		// ALEXP 7/2/10: force infinite ammo until we get reload anims
		if( !self.bulletsInClip )
		{
			cheatAmmoIfNecessary();
		}

		// cqb may use POIs instead of enemy, so make sure aiming is on
		if( IsDefined(self.cqb_point_of_interest) )
		{
			aimingOn();
		}
	}

	self OrientMode( "face default" );

	if ( self.sprint && !self isCQBWalking() )
	{
		self SetFlaggedAnimKnob("runanim", animArray("sprint"), 1, 0.5 );

		decidedAnimation = true;
	}
	else if ( animscripts\move::MayShootWhileMoving() && self.bulletsInClip > 0 && isValidEnemy( self.enemy ) )
	{
		runShootWhileMovingThreads();

		canStrafeForward	= CanShootWhileRunningForward();
		canStrafeBackward	= CanShootWhileRunningBackward();

//		if ( self.shootStyle != "none" && !self usingSidearm() )
		if ( self.shootStyle != "none" || (IsDefined(self.scriptenemy) && self.scriptenemy == self.enemy && canStrafeForward) )
		{
			/#recordEntText( "enemy yaw: " + (self GetPredictedYawToEnemy( 0.2 )) + " motion angle: " + abs( self getMotionAngle() ), self, level.color_debug["yellow"], "Pathfind" );#/

			if ( IsPlayer( self.enemy ) )
			{
				self updatePlayerSightAccuracy();
			}

			// clearing walk_and_run_loops above removes aiming
			aimingOn();

			toEnemyYaw = VectorToAngles(self.enemy.origin - self.origin)[1];
			angleDiff  = AngleClamp180( toEnemyYaw - self.angles[1] );

			// if running backwards, face the opposite direction from the goal
			if( ShouldShootWhileRunningBackward() )
			{
				faceDir		= vector_scale(self.lookaheaddir, -1);
				faceAngle	= VectorToAngles(faceDir)[1];

				// turn towards the enemy
				if( angleDiff > 0 ) // enemy's on the left
				{
					turnDirSkew = 0.001;
				}
				else // enemy's on the right
				{
					turnDirSkew = -0.001;
				}

				// play the turnaround transition anim if necessary
				yawToEnemy = AbsAngleClamp180( self.angles[1] - faceAngle );
				if( yawToEnemy > 175 )
				{
					self thread stopShootWhileMovingThreads();
					self notify("stop tracking");

					self AnimMode( "gravity", false );
					self OrientMode( "face angle", self.angles[1] );

					if( angleDiff > 0 )
					{
						transitionAnim = animArray("run_f_to_bR", "move");
					}
					else
					{
						transitionAnim = animArray("run_f_to_bL", "move");
					}

					self SetFlaggedAnimKnob("transition", transitionAnim, 1, 0.2 );
					self animscripts\shared::DoNotetracks("transition");

					// force movement
					self.a.movement = "run";

					self ClearAnim( %exposed_modern, 0.2 );

					self AnimMode( "normal", false );

					canStrafeBackward	= true;

					self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 );
					runShootWhileMovingThreads();//
					self animscripts\shared::trackLoopStart();
				}

				// TODO: remove once reload anims are in place
				if( self.bulletsInClip < 10 )
				{
					self.bulletInClip = 10;
				}

				self OrientMode( "face angle", faceAngle - turnDirSkew );
			}

			if ( canStrafeForward || canStrafeBackward )
			{
				self SetFlaggedAnimKnob("runanim", animArrayPickRandom(runAnimName + "_f", "move", true), 1, 0.2, self.moveplaybackrate );
			}
			else if( angleDiff > 0 ) // enemy's on the left
			{
				self SetFlaggedAnimKnob("runanim", animArrayPickRandom(runAnimName + "_l", "move", true), 1, 0.2, self.moveplaybackrate );
			}
			else // enemy's on the right
			{
				self SetFlaggedAnimKnob("runanim", animArrayPickRandom(runAnimName + "_r", "move", true), 1, 0.2, self.moveplaybackrate );
			}

			decidedAnimation = true;
		}
	}

	if ( !decidedAnimation )
	{
		runAnim = GetRunAnim();
		self SetFlaggedAnimKnob("runanim", runAnim, 1, 0.5, self.moveplaybackrate );
	}

	// Play the appropriately weighted run animations for the direction he's moving
	useLeans = true; //GetDvarInt( #"ai_useLeanRunAnimations");

	if( self.a.isAiming || self isCQBWalking() )
	{
		self UpdateRunWeightsOnce(
			%combatrun_forward,
			animArray(runAnimName + "_b")
			);
	}
	else if( useLeans && self.isfacingmotion )
	{
		self UpdateRunWeightsOnce(
			%combatrun_forward,
			animArray("combat_run_b"),
			animArray("combat_run_lean_l"),
			animArray("combat_run_lean_r")
			);
	}
	else
	{
		self UpdateRunWeightsOnce(
			%combatrun_forward,
			animArray("combat_run_b"),
			animArray("combat_run_l"),
			animArray("combat_run_r")
			);
	}

	DoNoteTracksNoShootStandCombat("runanim"); // does getRunAnimUpdateFrequency() seconds

	self thread stopShootWhileMovingThreads();

	self notify("stopRunning");
}



runShootWhileMovingThreads()
{
	self notify("want_shoot_while_moving");

	if (IsDefined(self.shoot_while_moving_thread))
	{
		return;
	}

	self.shoot_while_moving_thread = true;

	self thread RunDecideWhatAndHowToShoot();
	self thread RunShootWhileMoving();
}
stopShootWhileMovingThreads() // we don't stop them if we shoot while moving again
{
	self endon("killanimscript");
	self endon("want_shoot_while_moving");

	wait .05;

	self notify("end_shoot_while_moving");
	self.shoot_while_moving_thread = undefined;
}

RunDecideWhatAndHowToShoot()
{
	self endon("killanimscript");
	self endon("end_shoot_while_moving");
	self animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
}

RunShootWhileMoving()
{
	self endon("killanimscript");
	self endon("end_shoot_while_moving");
	self animscripts\move::shootWhileMoving();
}

CanShootWhileRunningForward()
{
	if ( abs( self getMotionAngle() ) > 60 )
	{
		return false;
	}

	enemyyaw = self GetPredictedYawToEnemy( 0.2 );
	if ( abs( enemyyaw ) > 75 )
	{
		return false;
	}

	return true;
}

CanShootWhileRunningBackward()
{
	if ( 180 - abs( self getMotionAngle() ) >= 60 )
	{
		return false;
	}

	enemyyaw = self GetPredictedYawToEnemy( 0.2 );
	if ( abs( enemyyaw ) > 75 )
	{
		return false;
	}

	return true;
}

ShouldShootWhileRunningBackward()
{
	if( isValidEnemy( self.enemy ) )
	{
		toEnemy = self.enemy.origin - self.origin;
		toEnemyYaw = VectorToAngles(toEnemy)[1];

		toGoalYaw = VectorToAngles(self.lookaheadDir)[1];

		if( AbsAngleClamp180(toEnemyYaw - toGoalYaw) > 120 ) // aim angle max is 60
		{
			if( DistanceSquared(self.enemy.origin, self.origin) < 750*750 )
			{
				return true;
			}
		}
	}

	return false;
}

CanShootWhileRunning()
{
	return animscripts\move::MayShootWhileMoving() && isValidEnemy( self.enemy ) && (CanShootWhileRunningForward() || CanShootWhileRunningBackward());
}

GetPredictedYawToEnemy( lookAheadTime )
{
	assert( isValidEnemy( self.enemy ) );

	// don't run this more than once per frame
	if( IsDefined(self.predictedYawToEnemy) && IsDefined(self.predictedYawToEnemyTime) && self.predictedYawToEnemyTime == GetTime() )
	{
		return self.predictedYawToEnemy;
	}

	selfPredictedPos = self.origin;
	moveAngle = self.angles[1] + self getMotionAngle();
	selfPredictedPos += (cos( moveAngle ), sin( moveAngle ), 0) * 200.0 * lookAheadTime;

	yaw = self.angles[1] - VectorToAngles(self.enemy.origin - selfPredictedPos)[1];
	yaw = AngleClamp180( yaw );

	// cache
	self.predictedYawToEnemy = yaw;
	self.predictedYawToEnemyTime = GetTime();

	return yaw;
}

MoveStandNoncombatOverride()
{
	self endon("movemode");

	self ClearAnim(%combatrun, 0.6);
	self SetFlaggedAnimKnobAll("runanim", self.run_noncombatanim, %body, 1, 0.3, self.moveplaybackrate );
	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveStandNoncombatNormal()
{
	self endon("movemode");

	self ClearAnim(%combatrun, 0.6);
	
	self SetAnimKnobAll(%combatrun, %body, 1, 0.2, self.moveplaybackrate);
	
	// Uses run_lowready_F by default if self.a.combatRunAnim is undefined.
	prerunAnim = GetRunAnim();

	// changed it back to 0.3 because it pops when the AI goes from combat to noncombat
	self SetFlaggedAnimKnob("runanim", prerunAnim, 1, 0.3); // was 0.3

	useLeans = true; //GetDvarInt( #"ai_useLeanRunAnimations");

	if( useLeans && self.isfacingmotion )
	{
		self UpdateRunWeightsOnce(
			%combatrun_forward,
			animArray("combat_run_b"),
			animArray("combat_run_lean_l"),
			animArray("combat_run_lean_r")
			);
	}
	else
	{
		self UpdateRunWeightsOnce(
			%combatrun_forward,
			animArray("combat_run_b"),
			animArray("combat_run_l"),
			animArray("combat_run_r")
			);
	}

	animscripts\shared::DoNoteTracksForTime(getRunAnimUpdateFrequency(), "runanim");
}

MoveCrouchRunOverride()
{
	self endon("movemode");

	self SetFlaggedAnimKnobAll("runanim", self.crouchrun_combatanim, %body, 1, 0.4, self.moveplaybackrate);
	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveCrouchRunNormal()
{
	self ClearAnim( %walk_and_run_loops, 0.2 );

	self setanimknob( %combatrun, 1.0, 0.5, self.moveplaybackrate );

	self.a.isAiming		= false;

	self OrientMode( "face default" );

	if ( animscripts\move::MayShootWhileMoving() && self.bulletsInClip > 0 && isValidEnemy( self.enemy ) )
	{
		runShootWhileMovingThreads();

		if ( self.shootStyle != "none" )
		{
			/#recordEntText( "enemy yaw: " + (self GetPredictedYawToEnemy( 0.2 )) + " motion angle: " + abs( self getMotionAngle() ), self, level.color_debug["yellow"], "Pathfind" );#/

			canStrafeForward	= CanShootWhileRunningForward();
			canStrafeBackward	= CanShootWhileRunningBackward();

			if( ShouldShootWhileRunningBackward() )
			{
				self OrientMode( "face direction", vector_scale(self.lookaheaddir, -1) );
			}

			if ( canStrafeForward || canStrafeBackward )
			{
				if ( IsPlayer( self.enemy ) )
				{
					self updatePlayerSightAccuracy();
				}

				// clearing walk_and_run_loops above removes aiming
				aimingOn();
			}
		}
	}

	runAnim = GetCrouchRunAnim();
	self SetFlaggedAnimKnob("runanim", runAnim, 1, 0.5 );

	// Play the appropriately weighted run animations for the direction he's moving
	useLeans = true; //GetDvarInt( #"ai_useLeanRunAnimations");

	self UpdateRunWeightsOnce(
		%combatrun_forward,
		animArray("combat_run_b"),
		animArray("combat_run_l"),
		animArray("combat_run_r")
		);

	DoNoteTracksNoShootStandCombat("runanim"); // does getRunAnimUpdateFrequency() seconds

	self thread stopShootWhileMovingThreads();

	self notify("stopRunning");
}

ReloadStandRun()
{
	reloadIfEmpty = IsDefined( self.a.allowedPartialReloadOnTheRunTime ) && self.a.allowedPartialReloadOnTheRunTime > GetTime();
	reloadIfEmpty = reloadIfEmpty || ( IsDefined( self.enemy ) && DistanceSquared( self.origin, self.enemy.origin ) < 256 * 256 );
	if ( reloadIfEmpty )
	{
		if ( !self NeedToReload( 0 ) )
		{
			return false;
		}
	}
	else
	{
		if ( !self NeedToReload( .5 ) )
		{
			return false;
		}
	}

	if ( self CanShootWhileRunning() && !self NeedToReload( 0 ) )
	{
		return false;
	}

	if ( !IsDefined( self.pathGoalPos ) || DistanceSquared( self.origin, self.pathGoalPos ) < 256*256 )
	{
		return false;
	}

	motionAngle = AngleClamp180( self getMotionAngle() );

	// want to be running forward; otherwise we won't see the animation play!
	if ( abs( motionAngle ) > 25 )
	{
		return false;
	}

	if ( self WeaponAnims() != "rifle" )
	{
		if( !(self WeaponAnims() == "pistol" && IsDefined(self.forceSideArm) && self.forceSideArm) )
		{
			return false;
		}
	}

	// rusher AI should not reload, as its against the tactic
	if( self is_rusher() )
	{
		return false;
	}

	// need to restart the run cycle because the reload animation has to be played from start to finish!
	// the goal is to play it only when we're near the end of the run cycle.
	if ( !runLoopIsNearBeginning() )
	{
		return false;
	}

	// call in a separate function so we can cleanup if we get an endon
	ReloadStandRunInternal();

	self notify("stopRunning");
	// notify "abort_reload" in case the reload didn't finish, maybe due to "movemode" notify. works with handleDropClip() in shared.gsc
	self notify("abort_reload");

	return true;
}

ReloadStandRunInternal()
{
	self endon("movemode");

	flagName = "reload_" + getUniqueFlagNameIndex();

	reloadAnim = undefined;

	if( self isCQBWalking() ) 
	{
		if( self.movemode == "walk" || self.walk )
		{
			reloadAnim = animArrayPickRandom("cqb_reload_walk");
		}
		else
		{
			reloadAnim = animArrayPickRandom("cqb_reload_run");
		}
	}
	else
	{
		reloadAnim = animArrayPickRandom("reload");
	}

	assert( IsDefined(reloadAnim) );

	self SetFlaggedAnimKnobAllRestart( flagName, reloadAnim, %body, 1, 0.25 );

	self thread UpdateRunWeightsBiasForward(
		"stopRunning",
		%combatrun_forward,
		animArray("combat_run_b"),
		animArray("combat_run_l"),
		animArray("combat_run_r")
	);

	animscripts\shared::DoNoteTracks( flagName );
}

runLoopIsNearBeginning()
{
	// there are actually 3 loops (left foot, right foot) in one animation loop.

	animfraction = self getAnimTime( %walk_and_run_loops );
	loopLength = getAnimLength( animscripts\run::GetRunAnim() ) / 3.0;
	animfraction *= 3.0;

	if ( animfraction > 3 )
	{
		animfraction -= 2.0;
	}
	else if ( animfraction > 2 )
	{
		animfraction -= 1.0;
	}

	if ( animfraction < .15 / loopLength )
	{
		return true;
	}

	if ( animfraction > 1 - .3 / loopLength )
	{
		return true;
	}

	return false;
}


UpdateRunWeights(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
	self endon("killanimscript");
	self endon(notifyString);

	if ( GetTime() == self.a.scriptStartTime )
	{
		// our motion angle might change very quickly as we start to run, so reset the anim weights after one frame
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait 0.05;
	}

	for (;;)
	{
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait getRunAnimUpdateFrequency();
	}
}

GetLookaheadAngle()
{
	yawDiff = VectorToAngles(self.lookaheaddir)[1] - self.angles[1];
    yawDiff = yawDiff * (1.0 / 360.0);
    yawDiff = (yawDiff - floor(yawDiff + 0.5)) * 360.0;

	return yawDiff;
}

UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim )
{
	blendTime	= 0.1;
	rate		= 1;
	yawDiff		= 0;

	useLeans = true; //GetDvarInt( #"ai_useLeanRunAnimations");

	if(useLeans && self.isfacingmotion)
	{
		yawDiff = self GetLookaheadAngle();
	
	    // Play the appropriately weighted animations for the direction he's moving.
	    animWeights = animscripts\utility::QuadrantAnimWeights( yawDiff );
	}	
	else
	{	
		yawDiff = self getMotionAngle();
		animWeights = animscripts\utility::QuadrantAnimWeights( yawDiff );
	}

	// for slowdown test (wasn't very impressive)
	if( IsDefined(self.lastRunRate) )
	{
		rateBlendFactor = 1; //GetDvarFloat( #"ai_slowdownRateBlendFactor");
		rate = rate * rateBlendFactor + (1-rateBlendFactor) * self.lastRunRate;
	}

	self.lastRunRate = rate;

//	if( self.isfacingmotion )
//		recordEntText( "yaw/rate: " + yawDiff + " / " + rate + " (facing motion)", self, level.color_debug["white"], "Pathfind" );
//	else
//		recordEntText( "yaw/rate: " + yawDiff + " / " + rate + " (facing enemy)", self, level.color_debug["white"], "Pathfind" );
		
	// use back left/right strafes
	if( useLeans && animWeights["back"] > 0 )
	{
		animWeights["left"] = 0;
		animWeights["right"] = 0;
		animWeights["back"] = 1;
	}

	// play the anims
	self SetAnim(frontAnim, animWeights["front"], blendTime, rate );
	self SetAnim(backAnim,  animWeights["back"] , blendTime, rate );

	if( IsDefined(leftAnim) )
	{
		self SetAnim(leftAnim,  animWeights["left"] , blendTime, rate );
	}

	if( IsDefined(rightAnim) )
	{
		self SetAnim(rightAnim, animWeights["right"], blendTime, rate );
	}
}

// same as UpdateRunWeights but never lets the forward animation go below a weight of .2.
// good for "flagged" animations.
UpdateRunWeightsBiasForward(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
	self endon("killanimscript");
	self endon(notifyString);

	for (;;)
	{
		animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );

		if ( animWeights["front"] < .2 )
		{
			animWeights["front"] = .2;

			if ( animWeights["front"] < 0 )
			{
				animWeights["left"] = 0.0;
				animWeights["right"] = 0.0;
			}
		}

		self SetAnim(frontAnim, animWeights["front"], 0.2, 1);
		self SetAnim(backAnim,  0.0                 , 0.2, 1);
		self SetAnim(leftAnim,  animWeights["left"] , 0.2, 1);
		self SetAnim(rightAnim, animWeights["right"], 0.2, 1);
		wait getRunAnimUpdateFrequency();
	}
}

// TODO Make this use the notetrack from the run animation playing.
MakeRunSounds ( notifyString )
{
	self endon("killanimscript");
	self endon(notifyString);

	for (;;)
	{
		wait .5;
		self PlaySound ("fly_step_run_npc_concrete");
		wait .5;
		self PlaySound ("fly_step_run_npc_concrete");
	}
}

// change our weapon while running if we want to and can
changeWeaponStandRun()
{
	if ( !animscripts\shared::shouldSwitchWeapons() )
	{
		return false;
	}

	if ( !IsDefined( self.pathGoalPos ) || DistanceSquared( self.origin, self.pathGoalPos ) < 256*256 )
	{
		return false;
	}

	if ( usingSidearm() )
	{
		return false;
	}

	assert( self.weapon == self.primaryweapon || self.weapon == self.secondaryweapon );

	// want to be running forward; otherwise we won't see the animation play!
	motionAngle = AngleClamp180( self getMotionAngle() );
	if ( abs( motionAngle ) > 25 )
	{
		return false;
	}

	if ( !runLoopIsNearBeginning() )
	{
		return false;
	}

	/#
	self animscripts\debug::debugPushState( "changeWeaponStandRun" );
	#/

	//shotgunSwitchStandRunInternal( "shotgunPullout", %shotgun_CQBrun_pullout, "gun_2_chest", "none", self.secondaryweapon, "shotgun_pickup" );
	weaponSwitchStandRunInternal( "shotgunPullout", animArray("weapon_switch"), "gun_2_chest", "none", self.secondaryweapon, "shotgun_pickup" );	

	self notify("switchEnded");

	/#
	self animscripts\debug::debugPopState();
	#/

	return true;
}

weaponSwitchStandRunInternal( flagName, switchAnim, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
	self endon("movemode");

	self SetFlaggedAnimKnobAllRestart( flagName, switchAnim, %body, 1, 0.25 );

	self thread animscripts\run::UpdateRunWeightsBiasForward(
		"switchEnded",
		%combatrun_forward,
		animArray("combat_run_b"),
		animArray("combat_run_l"),
		animArray("combat_run_r")
	);

	self thread watchWeaponSwitchNotetracks( flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack );

	animscripts\shared::DoNoteTracksForTimeIntercept( getAnimLength( switchAnim ) - 0.25, flagName, ::interceptNotetracksForWeaponSwitch );
}

interceptNotetracksForWeaponSwitch( notetrack )
{
	if ( notetrack == "gun_2_chest" || notetrack == "gun_2_back" )
	{
		return true; // "don't do the default behavior for this notetrack"
	}
}

watchWeaponSwitchNotetracks( flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
	self endon("killanimscript");
	self endon("movemode");
	self endon("switchEnded");
	self endon("complete_weapon_switch");

	self waittillmatch( flagName, dropGunNotetrack );

	animscripts\shared::placeWeaponOn( self.weapon, putGunOnTag );
	self thread weaponSwitchFinish( newGun );

	self waittillmatch( flagName, pickupNewGunNotetrack );
	self notify( "complete_weapon_switch" );
}

weaponSwitchFinish( newGun )
{
	self endon( "death" );

	self waittill_any( "killanimscript", "movemode", "switchEnded", "complete_weapon_switch" );

	self.lastweapon = self.weapon;

	animscripts\shared::placeWeaponOn( newGun, "right" );
	assert( self.weapon == newGun ); // placeWeaponOn should have handled this

	// reset ammo (assume fully loaded weapon)
	self.bulletsInClip = weaponClipSize( self.weapon );
}

getRunAnimUpdateFrequency()
{
	return 0.05; //GetDvarFloat( #"ai_runAnimUpdateFrequency");
}
