#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#include animscripts\anims;
#include common_scripts\Utility;

#using_animtree ("generic_human");

corner_think( direction )
{
	self endon ("killanimscript");

	self.coverNode = self.node;
	assert( IsDefined(self.coverNode) );

	setCornerDirection(direction);
	self.coverNode.desiredCornerDirection = direction;
	self.a.cornerMode = "unknown";
	
	self.a.standIdleThread = undefined;
	
	if( self.a.pose != "stand" && self.a.pose != "crouch" )
	{
		assert( self.a.pose == "prone" );
		self ExitProneWrapper(1);
		self.a.pose = "crouch";
	}

	self.isshooting = false;
	self.tracking = false;
	
	self.cornerAiming = false;
		
	animscripts\shared::setAnimAimWeight( 0 );
	
	self.haveGoneToCover = false;
		
	behaviorCallbacks = SpawnStruct();
	behaviorCallbacks.mainLoopStart			= ::mainLoopStart;
	behaviorCallbacks.reload				= ::cornerReload;
	behaviorCallbacks.leaveCoverAndShoot	= ::stepOutAndShootEnemy;
	behaviorCallbacks.look					= ::lookForEnemy;
	behaviorCallbacks.fastlook				= ::fastlook;
	behaviorCallbacks.idle					= ::idle;
	behaviorCallbacks.flinch				= ::flinch;
	behaviorCallbacks.grenade				= ::tryThrowingGrenade;
	behaviorCallbacks.grenadehidden			= ::tryThrowingGrenadeStayHidden;
	behaviorCallbacks.blindfire				= ::blindfire;
	behaviorCallbacks.resetWeaponAnims		= ::resetWeaponAnims;
	behaviorCallbacks.switchSides			= ::switchSides;
	
	animscripts\cover_behavior::main( behaviorCallbacks );
}

mainLoopStart()
{
	desiredStance = "stand";
	if ( !self.coverNode doesNodeAllowStance("stand") && self.coverNode doesNodeAllowStance("crouch") )
	{
		desiredStance = "crouch";
	}
	
	/#
	if ( GetDvarInt( #"scr_cornerforcecrouch") == 1 )
	{
		desiredStance = "crouch";
	}
	#/
	
	if ( self.haveGoneToCover )
	{
		self transitionToStance( desiredStance );
	}
	else
	{
		if ( self.a.pose == desiredStance )
		{
			GoToCover( animArray( "alert_idle" ), .4, .4 );
		}
		else
		{
			stanceChangeAnim = animArray("stance_change");
			GoToCover( stanceChangeAnim, .4, getAnimLength( stanceChangeAnim ) );
		}

		assert( self.a.pose == desiredStance );
		self.haveGoneToCover = true;
	}
}

// used within canSeeEnemyFromExposed() (in utility.gsc)
canSeePointFromExposedAtCorner( point, node )
{
	yaw = node GetYawToOrigin( point );
	if ( (yaw > 60) || (yaw < -60) )
	{
		return false;
	}

	if ( (node.type == "Cover Left" || node.type == "Cover Left Wide") && yaw > 14 )
	{
		return false;
	}

	if ( (node.type == "Cover Right" || node.type == "Cover Right Wide") && yaw < -12 )
	{
		return false;
	}

	return true;
}

shootPosOutsideLegalYawRange()
{
	if ( !IsDefined( self.shootPos ) )
	{
		return false;
	}

	// SUMEET/ALEX P, devtrack bug 1113 - AI should only be in this animscript if it is as cover_left or cover_right 
	AssertEx( IsDefined( self.coverNode ), "Covernode undefined, AI's current animscript is " + self.a.script );

	yaw = self.coverNode GetYawToOrigin( self.shootPos );
	
	if ( self.cornerDirection == "left" )
	{
		if ( self.a.cornerMode == "B" )
		{
			return yaw < 0-self.ABangleCutoff || yaw > 14;
		}
		else if ( self.a.cornerMode == "A" )
		{
			return yaw > 0-self.ABangleCutoff;
		}
		else
		{
			assert( self.a.cornerMode == "lean" );
			return yaw < -50 || yaw > 8; // TODO
		}
	}
	else
	{
		assert( self.cornerDirection == "right" );
		if ( self.a.cornerMode == "B" )
		{
			return yaw > self.ABangleCutoff || yaw < -12;
		}
		else if ( self.a.cornerMode == "A" )
		{
			return yaw < self.ABangleCutoff;
		}
		else
		{
			assert( self.a.cornerMode == "lean" );
			return yaw > 50 || yaw < -8; // TODO
		}
	}
}

// getCornerMode will return "none" if no corner modes are acceptable.
getCornerMode( node, point )
{
	yaw = 0;
	if ( IsDefined( point ) )
	{
		yaw = node GetYawToOrigin( point );
	}

	/#
		dvarval = GetDvar( #"scr_cornerforcestance");
	if ( dvarval == "lean" || dvarval == "a" || dvarval == "b" )
	{
		return dvarval;
	}
	#/

	if ( self.cornerDirection == "left" )
	{
		if ( self shouldLean() )
		{
			if ( yaw >= -40 && yaw <= 0 )
			{
				return "lean";
			}
			else if( usingPistol() ) // no anim support
			{
				return "none";
			}
		}

		if ( yaw > 14 )
		{
			return "none";
		}

		if ( yaw < 0-self.ABangleCutoff )
		{
			return "A";
		}
	}
	else
	{
		assert( self.cornerDirection == "right" );

		if ( shouldLean() )
		{
			if ( yaw <= 40 && yaw >= 0 )
			{
				return "lean";
			}
			else if( usingPistol() ) // no anim support
			{
				return "none";
			}
		}

		if ( yaw < -12 )
		{
			return "none";
		}

		if ( yaw > self.ABangleCutoff )
		{
			return "A";
		}
	}

	return "B";
}

// getBestStepOutPos never returns "none".
// it returns the best stepoutpos that we can get to from our current one.
getBestStepOutPos()
{
	yaw = 0;
	if (canSuppressEnemy())
	{
		yaw = self.coverNode GetYawToOrigin( getEnemySightPos() );
	}
	
	/#
	dvarval = GetDvar( #"scr_cornerforcestance");
	if ( dvarval == "lean" || dvarval == "a" || dvarval == "b" )
	{
		return dvarval;
	}
	#/

	if ( self.a.cornerMode == "lean" )
	{
		return "lean";
	}
	else if ( self.a.cornerMode == "B" )
	{
		if(self.cornerDirection == "left")
		{
			if(yaw < 0-self.ABangleCutoff)
			{
				return "A";
			}
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw > self.ABangleCutoff)
			{
				return "A";
			}
		}
		return "B";
	}
	else if ( self.a.cornerMode == "A" )
	{
		positionToSwitchTo = "B";
		if(self.cornerDirection == "left")
		{
			if(yaw > 0-self.ABangleCutoff)
			{
				return "B";
			}
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw < self.ABangleCutoff)
			{
				return "B";
			}
		}

		return "A";
	}
}

changeStepOutPos()
{
	self endon ("killanimscript");

	positionToSwitchTo = getBestStepOutPos();
	
	if ( positionToSwitchTo == self.a.cornerMode )
	{
		return false;
	}
	
	// can't switch between lean and other stepoutposes
	// so if this assert fails then getBestStepOutPos gave us a bad return value
	assert( self.a.cornerMode != "lean" && positionToSwitchTo != "lean" );
	
	self.changingCoverPos = true; self notify("done_changing_cover_pos");
	
	animname = self.a.cornerMode + "_to_" + positionToSwitchTo;
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );
	
	midpoint = getPredictedPathMidpoint();

	if ( !self mayMoveToPoint( midpoint ) )
	{
		return false;
	}

	if ( !self MayMoveFromPointToPoint( midpoint, getAnimEndPos( switchanim ) ) )
	{
		return false;
	}

	moveDelta = GetMoveDelta( switchanim, 0, 1 );
	
	self endStandIdleThread();
	
	// turn off aiming while we move.
	self StopAiming( .3 );
	
	prev_anim_pose = self.a.pose;
	
	self SetAnimLimited(animArray("straight_level"), 0, .2);
	
	self SetFlaggedAnimKnob( "changeStepOutPos", switchanim, 1, .2, 1 );
	self thread DoNoteTracksWithEndon( "changeStepOutPos" );
	
	if ( animHasNotetrack( switchanim, "start_aim" ) )
	{
		self waittillmatch( "changeStepOutPos", "start_aim" );
	}
	else
	{
		/#println("^1Corner position switch animation \"" + animname + "\" in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");#/
		self waittillmatch( "changeStepOutPos", "end" );
	}
	
	self StartAiming( undefined, false, .3 );

	self waittillmatch( "changeStepOutPos", "end" );
	self ClearAnim(switchanim, .1);
	self.a.cornerMode = positionToSwitchTo;
	
	self.changingCoverPos = false;
	self.coverPosEstablishedTime = GetTime();

	assert( self.a.pose == "stand" || self.a.pose == "crouch" );

	self ChangeAiming( undefined, true, .3 );
	
	return true;
}

shouldLean()
{
	if ( self usingPistol() )
	{
		return true;
	}

	if ( self.team == "allies" || self.animType == "spetsnaz" || self.lastAnimType == "spetsnaz" )
	{
		return true;
	}

	// ALEXP_MOD (9/9/09): if player is aiming at stepout pos, don't go exposed
	if ( IsDefined(self.coverSafeToPopOut) && !self.coverSafeToPopOut )
	{
		return true;
	}

	if( self.a.atPillarNode )
	{
		// vc have to lean since we don't have anims matching their exposed set
		if( self.animType == "vc" )
		{
			return true;
		}

		return RandomFloat(1) < 0.5;
	}

	if ( self isPartiallySuppressedWrapper() )
	{
		return true;
	}

	return false;
}

DoNoteTracksWithEndon( animname )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );
}

StartAiming( spot, fullbody, transtime )
{
	assert( !self.cornerAiming );
	self.cornerAiming = true;
	
	self SetAimingParams( spot, fullbody, transTime, self.a.cornerMode == "lean", true );
}

ChangeAiming( spot, fullbody, transtime )
{
	assert( self.cornerAiming );
	self SetAimingParams( spot, fullbody, transTime, self.a.cornerMode == "lean", false );
}

StopAiming( transtime )
{
	assert( self.cornerAiming );
	self.cornerAiming = false;
	
	// turn off shooting
	self ClearAnim( %add_fire, transtime );
	// and turn off aiming
	animscripts\shared::setAnimAimWeight( 0, transtime );
}

SetAimingParams( spot, fullbody, transTime, lean, start )
{
	assert( IsDefined(fullbody) );
	
	self.spot = spot; // undefined is ok
	
	self SetAnimLimited( %exposed_modern, 1, transTime );
	self SetAnimLimited( %exposed_aiming, 1, transTime );

	// use 0 transtime because the aiming is blended in internally already
	animscripts\shared::setAnimAimWeight( 1, 0 );

	if ( lean )
	{
		if( !start )
		{
			self SetAnimLimited(animArray("lean_aim_straight"), 1, transTime);
		}
		
		self SetAnimKnobLimited(animArray("lean_aim_left"), 1, transTime);	
		self SetAnimKnobLimited(animArray("lean_aim_right"), 1, transTime);			
		self SetAnimKnobLimited(animArray("lean_aim_up"), 1, transTime);	
		self SetAnimKnobLimited(animArray("lean_aim_down"), 1, transTime);	
	}
	else if ( fullbody )
	{
		self SetAnimLimited(animArray("straight_level"), 1, transTime);
		
		self SetAnimKnobLimited(animArray("add_aim_up"),1,transTime);
		self SetAnimKnobLimited(animArray("add_aim_down"),1,transTime);
		self SetAnimKnobLimited(animArray("add_aim_left"),1,transTime);
		self SetAnimKnobLimited(animArray("add_aim_right"),1,transTime);
	}
	else
	{
		self SetAnimLimited(animArray("straight_level"), 0, transTime);

		self SetAnimKnobLimited(animArray("add_turn_aim_up"),1,transTime);
		self SetAnimKnobLimited(animArray("add_turn_aim_down"),1,transTime);
		self SetAnimKnobLimited(animArray("add_turn_aim_left"),1,transTime);
		self SetAnimKnobLimited(animArray("add_turn_aim_right"),1,transTime);
	}
}

stepOut() /* bool */
{
	/#
	self animscripts\debug::debugPushState( "stepOut" );
	#/

	self.a.cornerMode = "alert";
	
	self AnimMode( "zonly_physics" );
	
	if ( self.a.pose == "stand" )
	{
		self.ABangleCutoff = 38;
	}
	else
	{
		assert( self.a.pose == "crouch" );
		self.ABangleCutoff = 31;
	}
	
	thisNodePose = self.a.pose;
	
	newCornerMode = "none";
	if ( hasEnemySightPos() )
	{
		newCornerMode = getCornerMode( self.coverNode, getEnemySightPos() );
	}
	else
	{
		newCornerMode = getCornerMode( self.coverNode );
	}
	
	if ( newCornerMode == "none" )
	{		
		/#
		self animscripts\debug::debugPopState( "stepOut", "newCornerMode = none" );
		#/

		return false;
	}
	
	animname = "alert_to_" + newCornerMode;
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );

	if ( !isPathClear( switchanim, newCornerMode != "lean" ) )
	{
		/#
		self animscripts\debug::debugPopState( "stepOut", "no room to step out" );
		#/

		return false;
	}

	self.a.cornerMode = newCornerMode;

	self set_aiming_limits();
	if ( self.a.cornerMode == "lean" )
	{
		if ( self.cornerDirection == "left" )
		{
			self.rightaimlimit = 0;
		}
		else
		{
			self.leftaimlimit = 0;
		}
	}

	if( self.a.cornerMode != "lean" )
	{
		resetAnimSpecial(0);
	}
	
	self.keepclaimednode = true;
	self.keepClaimedNodeInGoal = true;

	self.changingCoverPos = true; self notify("done_changing_cover_pos");

	self setFlaggedAnimKnobAllRestart( "stepout", switchanim, %root, 1, .2, 1.0 );
	self thread DoNoteTracksWithEndon( "stepout" );

	hasStartAim = animHasNotetrack( switchanim, "start_aim" );
	if ( hasStartAim )
	{
		self waittillmatch("stepout","start_aim");
	}
	else
	{
		/#println("^1Corner stepout animation \"" + animname + "\" in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");#/
		self waittillmatch( "stepout", "end" );
	}

	if ( newCornerMode == "B" && self.cornerDirection == "right" && !self.a.atPillarNode )
	{
		self.a.special = "corner_right_mode_b";
	}

	self StartAiming( undefined, false, .3 );
	self thread animscripts\shared::trackShootEntOrPos();

	if( newCornerMode == "lean" && self.a.pose == "stand" && !usingPistol() )
	{
		self.aimAngleOffset = self.coverNode.angles[1] - self.angles[1];
	}
	
	if ( hasStartAim )
	{
		self waittillmatch("stepout","end");
	}
	
	self ChangeAiming( undefined, true, 0.2 );
	self ClearAnim( %cover, 0.2 );
	self ClearAnim( %corner, 0.2 );
	
	self.changingCoverPos = false;
	self.coverPosEstablishedTime = GetTime();

	/#
	self animscripts\debug::debugPopState( "stepOut" );
	#/
	
	return true;
}

stepOutAndShootEnemy()
{
	/#
	self animscripts\debug::debugPushState( "stepOutAndShootEnemy" );
	#/

	if( rambo() )
		return true;

	if ( !StepOut() ) // may not be room to step out
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room to step out" );
		#/

		return false;
	}

	shootAsTold();

	if ( IsDefined( self.shootPos ) )
	{
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );
		// too close for RPG or out of ammo

		if( animscripts\shared::shouldThrowDownWeapon() )
		{
			//println("corner:shouldThrowDownWeapon was true"); // ALEXP_PRINT
			animscripts\shared::throwDownWeapon();

			resetWeaponAnims();

			self ChangeAiming( undefined, true, 0.2 );

			self animMode( "zonly_physics" );

			shootAsTold();
		}
	}
	
	returnToCover();

	/#
	self animscripts\debug::debugPopState( "stepOutAndShootEnemy" );
	#/
	
	return true;
}

rambo()
{
	/#
	self animscripts\debug::debugPushState( "rambo" );
	#/

	/#
		// Rambo debug
		if( GetDvarInt( #"forceRambo" ) == 1 )
		{
			self.rambochance = 100;	
			self.shootObjective = "normal";	
		}
	#/

	self evaluateRamboChance();
	shouldRambo = IsDefined( self.rambochance ) && ( RandomInt(100) < self.rambochance ) && self.shootObjective == "normal";
	shouldRambo = shouldRambo || ( IsDefined( self.coverNode.script_forcerambo ) 
											  && self.coverNode.script_forcerambo 
											  && IsDefined( self.rambochance )
											  && self.rambochance );

	if( shouldRambo && canDoRambo() )
	{
		if( ramboStepOut() )
		{			
			/#
			self animscripts\debug::debugPopState( "rambo" );
			#/

			return true;
		}
	}

	
	/#
	self animscripts\debug::debugPopState( "rambo", "not allowed or can't step out" );
	#/
	
	return false;
}

evaluateRamboChance()
{
	self.ramboChance	= 30;
	self.ramboJamChance = 20;
		
	// no rambo for friendlies, rocketlauncher, sniper
	weaponAnims = WeaponAnims();

	if( self.team == "allies" || WeaponAnims == "rocketlauncher" 
							  || WeaponAnims == "spread" 
							  || isSniper() )
	{
		self.ramboChance = 0;
	}
}

canDoRambo()
{
/#
	// Rambo debug
	if( GetDvarInt( #"forceRambo" ) == 1 )
	{
		return ( animArrayAnyExist("rambo") && animArrayAnyExist("rambo_45") );
	}
#/
	// if script_norambo is set then AI will not perform rambo at this node.
	if( IsDefined( self.coverNode.script_norambo ) && self.coverNode.script_norambo || IsDefined( level.norambo ) )
	 	return false;

	// these guys are too good for rambo
	if( self.animType == "spetsnaz" || self.lastAnimType == "spetsnaz" )
	{
		return false;
	}

	if ( !animscripts\weaponList::usingAutomaticWeapon() )
	{
		return false;
	}
	
	if( animArrayAnyExist("rambo") && animArrayAnyExist("rambo_45") && haventRamboedWithinTime( 5 ) )
		return true;
	
	return false;	
}

haventRamboedWithinTime( time )
{
	if ( !IsDefined( self.lastRamboTime ) )
	{
		return true;
	}

	return GetTime() - self.lastRamboTime > time * 1000;
}

ramboStepOut()
{
	animType = "rambo";

	// we dont want to see rambo jam as often
	if( RandomInt(100) < self.ramboJamChance )
	{
		animType = "rambo_jam";
	}

	// Use different animation based on the angle to enemy
	if ( hasEnemySightPos() && animType != "rambo_jam" )
	{
		yawToEnemy = self.coverNode GetYawToOrigin( getEnemySightPos() );

		if( self.cornerDirection == "left" && yawToEnemy < 0 )
			yawToEnemy = yawToEnemy * -1;

		// SUMEET_TODO - Need more variations for rambo_45 animations
		if( yawToEnemy > anim.ramboSwitchAngle )
		{
			animType = "rambo_45";
		}
	}

	assert( animArrayAnyExist( animType ) );

	ramboanim = animArrayPickRandom( animType );

	if( !isRamboPathClear( ramboanim ) )
		return false;

	resetAnimSpecial(0);
	
	self AnimMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;
	self.isRamboing = true;

	self setFlaggedAnimKnobAllRestart("rambo", ramboanim, %body, 1, 0);
	self animscripts\shared::DoNoteTracks("rambo");

//	self thread DoNoteTracksWithEndon( "rambo" );
//	
//	if ( animHasNotetrack( ramboanim, "start_aim" ) )
//	{
//		self waittillmatch( "rambo", "start_aim" );
//	}
//	else if( animHasNotetrack( ramboanim, "fire_spray" ) )
//	{
//		/#println("^1Rambo animation \"" + animType + "\" in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");#/
//		self waittillmatch( "rambo", "fire_spray" );
//	}
//
//	self StartAiming( undefined, false, .3 );
//	self thread animscripts\shared::trackShootEntOrPos();
//
//	self waittillmatch( "rambo", "end" );
//
//	self StopAiming( .3 );

	self.lastRamboTime = GetTime();

	self.keepClaimedNodeInGoal = false;
	self.isRamboing = false;
	
	return true;
}

isRamboPathClear( theanim )
{
	ramboOutNotetrackCheck = AnimHasNotetrack( theanim, "rambo_out" );

	Assert( ramboOutNotetrackCheck ); // Every rambo animation needs to have this notetrack for stepout position
	
	stepOutTimeArray = GetNotetrackTimes( theanim, "rambo_out" );

	Assert( stepOutTimeArray.size == 1 ); // There should be only one notetrack for stepout in the whole animation

	movedelta = GetMoveDelta( theanim, 0, stepOutTimeArray[0] );
	ramboOutPos  = self LocalToWorldCoords( movedelta );

	distToPos = Distance2D( self.origin, ramboOutPos );

	angles = self.coverNode.angles;
	right = AnglesToRight(angles);
	
	switch ( self.a.script )
	{
		case "cover_left":
			ramboOutPos = self.origin + vector_scale( right, distToPos * -1 );
			break;

		case "cover_right":
			ramboOutPos = self.origin + vector_scale( right, distToPos );
			break;
		
		default:
			Assert("Rambo behavior is not supported on cover node " + self.a.script );
	}
	
/#
	if( ramboOutNotetrackCheck )
	{
		self thread debugRamboOutPosition( ramboOutPos );
	}
		
#/
	return self mayMoveToPoint( ramboOutPos );

}


debugRamboOutPosition( ramboOutPos ) // self = ai
{
	if( GetDvar( #"ai_rambo") != "1" )
    	return;

	self endon("death");

	for ( i = 0;i< 30*20 ;i++ )
	{
		RecordLine( self.origin, ramboOutPos, ( 1,1,1 ), "Script", self );
	}
}

shootAsTold()
{
	self endon("need_to_switch_weapons");

	self maps\_gameskill::didSomethingOtherThanShooting();

	while(1)
	{
		/#
		self animscripts\debug::debugPushState( "shootAsTold" );
		#/

		while(1)
		{
			if ( self.shouldReturnToCover )
			{
				/#
				self animscripts\debug::debugPopState( "shootAsTold", "shouldReturnToCover" );
				#/

				break;
			}

			if( animscripts\cover_behavior::shouldSwitchSides(false) )
			{
				/#
				self animscripts\debug::debugPopState( "shootAsTold", "shouldSwitchSides" );
				#/

				break;
			}

			if ( !IsDefined( self.shootPos ) )
			{
				assert( !IsDefined( self.shootEnt ) );

				// give shoot_behavior a chance to iterate
				wait .05;
				waittillframeend;

				if ( IsDefined( self.shootPos ) )
				{
					continue;
				}

				/#
				self animscripts\debug::debugPopState( "shootAsTold", "no shootPos" );
				#/

				break;
			}

			if ( !self.bulletsInClip )
			{
				/#
				self animscripts\debug::debugPopState( "shootAsTold", "no ammo" );
				#/

				break;
			}
			
			if ( shootPosOutsideLegalYawRange() )
			{
				if ( !changeStepOutPos() )
				{
					// if we failed because there's no better step out pos, give up
					if ( !self.a.atPillarNode && getBestStepOutPos() == self.a.cornerMode )
					{
						/#
						self animscripts\debug::debugPopState( "shootAsTold", "shootPos outside yaw range and no better step out pos" );
						#/

						break;
					}
					
					// couldn't change position, shoot for a short bit and we'll try again
					shootUntilShootBehaviorChangeForTime( .2 );

					// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
					self flamethrower_stop_shoot();
					continue;
				}
				
				// if they're moving back and forth too fast for us to respond intelligently to them,
				// give up on firing at them for the moment
				if ( shootPosOutsideLegalYawRange() )
				{
					/#
					self animscripts\debug::debugPopState( "shootAsTold", "shootPos outside yaw range" );
					#/

					break;
				}
				
				continue;
			}
			
			shootUntilShootBehaviorChange_corner( true );

			if( animscripts\cover_wall::CoverRechamber() )
			{
				// make sure his weapon always goes back afterwards
				self notify ( "weapon_rechamber_done" );	
			}

			// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
			self flamethrower_stop_shoot();

			self ClearAnim( %add_fire, .2 );
		}

		if ( self canReturnToCover( self.a.cornerMode != "lean" ) )
		{
			break;
		}

		// couldn't return to cover. keep shooting and try again

		// (change step out pos if necessary and possible)
		if ( shootPosOutsideLegalYawRange() && changeStepOutPos() )
		{
			continue;
		}

		shootUntilShootBehaviorChangeForTime( .2 );

		if ( NeedToRechamber() )
		{
			if ( animscripts\cover_wall::CoverRechamber() )
			{
				// make sure his weapon always goes back afterwards
				self notify ( "weapon_rechamber_done" );	
			}
		}

		// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
		self flamethrower_stop_shoot();
	}
}

shootUntilShootBehaviorChangeForTime( time )
{
	self thread notifyStopShootingAfterTime( time );
	
	starttime = GetTime();
	
	shootUntilShootBehaviorChange_corner( false );
	self notify("stopNotifyStopShootingAfterTime");

	timepassed = (GetTime() - starttime) / 1000;
	if ( timepassed < time )
	{
		wait time - timepassed;
	}
}

notifyStopShootingAfterTime( time )
{
	self endon("killanimscript");
	self endon("stopNotifyStopShootingAfterTime");
	
	wait time;
	
	self notify("stopShooting");
}

shootUntilShootBehaviorChange_corner( runAngleRangeThread )
{
	self endon("return_to_cover");
	
	if ( runAngleRangeThread )
	{
		self thread angleRangeThread(); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	}

	self thread standIdleThread();
	
	shootUntilShootBehaviorChange();
}

standIdleThread()
{
	self endon("killanimscript");
	
	if ( IsDefined( self.a.standIdleThread ) )
	{
		return;
	}

	self.a.standIdleThread = true;
	
	self SetAnim( %add_idle, 1, .2 );
	standIdleThreadInternal();
	self ClearAnim( %add_idle, .2 );
}

endStandIdleThread()
{
	self.a.standIdleThread = undefined;
	self notify("end_stand_idle_thread");
}

standIdleThreadInternal()
{
	self endon("killanimscript");
	self endon("end_stand_idle_thread");
	
	animArrayArg = "exposed_idle";
	if ( self.a.cornerMode == "lean" )
	{
		animArrayArg = "lean_idle";
	}
	else if( !isValidEnemy( self.enemy ) )
	{
		animArrayArg = "exposed_idle_noncombat";
	}

	assert( animArrayAnyExist( animArrayArg ) );
	for( i = 0; ; i++ )
	{
		flagname = "idle" + i;
		idleanim = animArrayPickRandom( animArrayArg );
		
		self SetFlaggedAnimKnobLimitedRestart( flagname, idleanim, 1, 0.2 );
		
		self waittillmatch( flagname, "end" );
	}
}

angleRangeThread()
{
	self endon ("killanimscript");
	self notify ("newAngleRangeCheck");
	self endon ("newAngleRangeCheck");
	self endon ("take_cover_at_corner");
	
	while (1)
	{
		if ( shootPosOutsideLegalYawRange() )
		{
			break;
		}

		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}

canReturnToCover( doMidpointCheck )
{
	if ( !anim.maymoveCheckEnabled )
	{
		return true;
	}

	if ( doMidpointCheck )
	{
		midpoint = getPredictedPathMidpoint();

		if ( !self mayMoveToPoint( midpoint ) )
		{
			return false;
		}

		return self MayMoveFromPointToPoint( midpoint, self.coverNode.origin );
	}
	else
	{
		return self mayMoveToPoint( self.coverNode.origin );
	}
}

returnToCover()
{
	/#
	self animscripts\debug::debugPushState( "returnToCover" );
	#/

	assert( self canReturnToCover( self.a.cornerMode != "lean" ) );
	
	self endStandIdleThread();
	
	// Go back into hiding.
	suppressed = issuppressedWrapper();
	self notify ("take_cover_at_corner"); // Stop doing the adjust-stance transition thread
	
	if( self.a.cornerMode != "lean" )
	{
		self thread resetAnimSpecial( 0.3 );
	}
	
	if ( suppressed )
	{
		rate = 1.5;
	}
	else
	{
		rate = 1;
	}

	self.changingCoverPos = true; self notify("done_changing_cover_pos");
	
	animname = self.a.cornerMode + "_to_alert";
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );

	self StopAiming( .3 );
	self ClearAnim( %add_fire, .2 );
	
	reloading = false;
	if ( self.a.cornerMode != "lean" && suppressed && animArrayAnyExist( animname + "_reload" ) && RandomFloat(100) < 75 )
	{
		switchanim = animArrayPickRandom( animname + "_reload" );
		rate = 1;
		reloading = true;
	}

	// turn off the standing anim
	// use 0 goaltime to make sure none of the translation from the transition anim is lost
	if( self.a.cornerMode == "lean" )
	{
		self ClearAnim(animArray("lean_aim_straight"), 0);
	}
	else
	{
		self ClearAnim(animArray("straight_level"), 0);
	}
	
	// as we turn on the hiding anim
	self setFlaggedAnimRestart("hide", switchanim, 1, .1, rate);
	self animscripts\shared::DoNoteTracks("hide");
	self.a.alertness = "alert";	// Should be set in the aim2alert animation but sometimes isn't.
	
	if ( reloading )
	{
		self animscripts\weaponList::RefillClip();
	}
	
	self notify ( "stop updating angles" );
	self notify ("stop EyesAtEnemy");
	self notify ("stop tracking");
	
	self.changingCoverPos = false;
	
	setAnimSpecial();

	self.keepClaimedNodeInGoal = false;
	self.keepclaimednode = false;
	
	self ClearAnim( %exposed_modern, 0.2 );

	/#
	self animscripts\debug::debugPopState( "returnToCover" );
	#/
}

resetAnimSpecial( delay )
{
	self endon("killanimscript");

	if( delay > 0 )
		wait delay;

	self.a.special = "none";
}

blindfire()
{
	if ( !animArrayAnyExist("blind_fire") )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no blind fire anim" );
		#/

		return false;
	}

	self AnimMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;

	self setFlaggedAnimKnobAllRestart("blindfire", animArrayPickRandom("blind_fire"), %body, 1, 0, 1);
	self animscripts\shared::DoNoteTracks("blindfire");

	// SUMEET - Temp for feb 19th milestone. VC's would blindfire twice in a row.
	if( IsDefined( self.animType ) && self.animType == "vc" && RandomInt( 100 ) < level.secondBlindfireChance )
	{
		self setFlaggedAnimKnobAllRestart("blindfire", animArrayPickRandom("blind_fire"), %body, 1, 0, 1);
		self animscripts\shared::DoNoteTracks("blindfire");
	}

	self.keepClaimedNodeInGoal = false;
	
	return true;
}

tryThrowingGrenadeStayHidden( throwAt )
{
	return tryThrowingGrenade( throwAt, true );
}

tryThrowingGrenade( throwAt, safe )
{
	if ( !self mayMoveToPoint( self getPredictedPathMidpoint() ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room to throw" );
		#/

		return false;
	}

	theanim = undefined;
	if ( IsDefined(safe) && safe )
	{
		if ( !animArrayExist("grenade_safe") )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "no safe throw anim" );
			#/

			return false;
		}

		theanim = animArray("grenade_safe");
	}
	else
	{
		if ( !animArrayExist("grenade_exposed") )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "no exposed throw anim" );
			#/

			return false;
		}

		theanim = animArray("grenade_exposed");
	}

	self AnimMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	
	armOffset = (32,20,64); // needs fixing!
	threwGrenade = TryGrenade( throwAt, theanim );
	
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}

printYawToEnemy() 
{
	println("yaw: ",self getYawToEnemy());
}

lookForEnemy( lookTime )
{
	if ( !animArrayExist("alert_to_look") )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no look anim" );
		#/

		return false;
	}

	// no anim support for now
	if( usingPistol() )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no pistol anims" );
		#/

		return false;
	}
	
	self AnimMode( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	
	// look out from alert
	if ( !peekOut() )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room to peek out" );
		#/

		return false;
	}

	animscripts\shared::playLookAnimation( animArray("look_idle"), lookTime, ::canStopPeeking );

	lookanim = undefined;
	if ( self isSuppressedWrapper() )
	{
		lookanim = animArray("look_to_alert_fast");
	}
	else
	{
		lookanim = animArray("look_to_alert");
	}
	
	self setflaggedanimknoballrestart("looking_end", lookanim, %body, 1, .1, 1.0);
	animscripts\shared::DoNoteTracks("looking_end");
	
	self AnimMode( "zonly_physics" ); // Unlatch the feet
	
	self.keepClaimedNodeInGoal = false;
	
	return true;
}


peekOut()
{
	peekanim = animArray("alert_to_look");

	if ( !self mayMoveToPoint( getAnimEndPos( peekanim ) ) || self LookingAtEntity())
	{
		return false;
	}

	// not safe to stop peeking in the middle because it will screw up our deltas
	//self thread _peekStop();
	//self endon ("stopPeeking");
	
	self SetFlaggedAnimKnobAll("looking_start", peekanim, %body, 1, .2, 1);
	animscripts\shared::DoNoteTracks("looking_start");
	//self notify ("stopPeekCheckThread");
	
	return true;
}

canStopPeeking()
{
	return self mayMoveToPoint( self.coverNode.origin );
}

fastlook()
{
	if ( !animArrayExist("look") )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no fastlook anim" );
		#/

		return false;
	}

	peekanim = animArray("look");

	if ( !self mayMoveToPoint( getAnimEndPos( peekanim ) ) || self LookingAtEntity())
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room to fastlook out" );
		#/

		return false;
	}
	
	self.keepClaimedNodeInGoal = true;

	self setFlaggedAnimKnobAllRestart( "look", peekanim, %body, 1, .1 );
	self animscripts\shared::DoNoteTracks( "look" );
	
	self.keepClaimedNodeInGoal = false;
	
	return true;
}

cornerReload()
{
	// MikeD (10/9/2007): Flamethrower AI do not reload
	if( self usingGasWeapon() )
	{
		return flamethrower_reload();
	}

	assert( animArrayAnyExist( "reload" ) );

	reloadanim = animArrayPickRandom( "reload" );
	self SetFlaggedAnimKnobRestart( "cornerReload", reloadanim, 1, .2 );

	self animscripts\shared::DoNoteTracks( "cornerReload" );

	self animscripts\weaponList::RefillClip();

	self SetAnimRestart( animArray( "alert_idle" ), 1, .2 );
	self ClearAnim( reloadanim, .2 );

	return true;
}

isPathClear( stepoutanim, doMidpointCheck )
{
	if ( !anim.maymoveCheckEnabled )
	{
		return true;
	}

	if ( doMidpointCheck )
	{
		midpoint = getPredictedPathMidpoint();

		/#
		// set to true to get animation deltas in case they change
		if( false )
		{
			recordLine( self.origin, midpoint, (0,1,0), "Script", self );
			recordLine( midpoint, getAnimEndPos( stepoutanim ), (1,0,0), "Script", self );

			endPos = getAnimEndPos( stepoutanim );
			moveDelta = endPos - self.origin;
			recordenttext( "Delta: " + moveDelta[0] + ", " + moveDelta[1] + ", " + moveDelta[2], self, (0,1,0), "Script" );
		}
		#/

		if ( !self maymovetopoint( midpoint ) )
		{
			return false;
		}

		return self MayMoveFromPointToPoint( midpoint, getAnimEndPos( stepoutanim ) );
	}
	else
	{
		return self maymovetopoint( getAnimEndPos( stepoutanim ) );
	}
}

getPredictedPathMidpoint()
{

	// SUMEET/ALEX P, devtrack bug 478 - AI should only be in this animscript if it is as cover_left or cover_right 
	AssertEx( IsDefined( self.coverNode ), "Covernode undefined, AI's current animscript is " + self.a.script );

	angles = self.coverNode.angles;
	right = AnglesToRight(angles);
	switch ( self.a.script )
	{
		case "cover_left":
			right = vector_scale(right, -36);
			break;

		case "cover_right":
			right = vector_scale(right, 36);
			break;

		case "cover_pillar":
			if( self.cornerDirection == "left" )
			{
				right = vector_scale(right, -36);
			}
			else
			{
				right = vector_scale(right, 36);
			}
			break;
		
		default:
			assertEx(0, "What kind of node is this????");
	}
	
	return self.coverNode.origin + (right[0], right[1], 0);
}

idle()
{
	self endon("end_idle");
	
	while( 1 )
	{
		useTwitch = (RandomInt(2) == 0 && animArrayAnyExist("alert_idle_twitch"));
		if ( useTwitch && !self LookingAtEntity() )
		{
			idleanim = animArrayPickRandom("alert_idle_twitch");
		}
		else
		{
			idleanim = animArray("alert_idle");
		}

		playIdleAnimation( idleAnim, useTwitch );
	}
}

flinch()
{
	if ( !animArrayAnyExist("alert_idle_flinch") )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no flinch anim" );
		#/

		return false;
	}

	playIdleAnimation( animArrayPickRandom("alert_idle_flinch"), true );
	
	return true;
}

playIdleAnimation( idleAnim, needsRestart )
{
	if ( needsRestart )
	{
		self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, 1);
	}
	else
	{
		self SetFlaggedAnimKnobAll( "idle", idleAnim, %body, 1, .1, 1);
	}

	self animscripts\shared::DoNoteTracks( "idle" );
}

transitionToStance( stance )
{
	if (self.a.pose == stance)
	{
		return;
	}

//	self ExitProneWrapper(0.5);
	self setFlaggedAnimKnobAllRestart( "changeStance", animArray("stance_change"), %body);

	self animscripts\shared::DoNoteTracks( "changeStance" );
	assert( self.a.pose == stance );
	wait (0.2);
}

GoToCover( coveranim, transTime, playTime )
{	
	cornerAngle = GetNodeDirection();
	cornerOrigin = GetNodeOrigin();
	
	desiredYaw = cornerAngle + self.hideyawoffset;

	self OrientMode( "face angle", desiredYaw );

	self AnimMode ( "normal" );
	
	assert( transTime <= playTime );

	setAnimSpecial();
	
	self thread animscripts\shared::moveToOriginOverTime( cornerOrigin, transTime );
	self setFlaggedAnimKnobAllRestart( "coveranim", coveranim, %body, 1, transTime );
	self animscripts\shared::DoNoteTracksForTime( playTime, "coveranim" );
	
	while ( AbsAngleClamp180( self.angles[1] - desiredYaw ) > 1 )
	{
		self animscripts\shared::DoNoteTracksForTime( 0.1, "coveranim" );
	}
	
	self AnimMode( "zonly_physics" );
}

setAnimSpecial()
{
	if( self.a.atPillarNode )
	{
		self.a.special = "cover_pillar";
	}
	else if( self.cornerDirection == "left" )
	{
		self.a.special = "cover_left";
	}
	else if( !self.a.atPillarNode )
	{
		self.a.special = "cover_right";
	}
}

drawoffset()
{
	self endon("killanimscript");

	for(;;)
	{
		line(self.node.origin + (0,0,20),(0,0,20) + self.node.origin + vector_scale(AnglesToRight(self.node.angles + (0,0,0)),16));
		wait(0.05);	
	}
}

set_aiming_limits() 
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
}

runCombat()
{
	self notify( "killanimscript" );
	waittillframeend;
	/#
	debug_replay("coner.gsc runCombat()");
	#/
	self thread animscripts\combat::main();
}

resetWeaponAnims()
{
	assert( self.a.pose == "stand" || self.a.pose == "crouch" );

	self ClearAnim( %aim_4, 0 );
	self ClearAnim( %aim_6, 0 );
	self ClearAnim( %aim_2, 0 );
	self ClearAnim( %aim_8, 0 );
	self ClearAnim( %exposed_aiming, 0 );
}

setCornerDirection(direction)
{
	self.cornerDirection = direction;

	// to make it easier on the anim system
	if( self.a.script == "cover_pillar" )
	{
		self.a.script_suffix = "_" + direction;
	}
}

switchSides()
{
	if( !self.a.atPillarNode )
	{
		return false;
	}

	if( self.cornerDirection == "left" && !self.coverNode isNodeDontRight() )
	{
		setCornerDirection("right");
	}
	else if( !self.coverNode isNodeDontLeft() )
	{
		setCornerDirection("left");
	}
	
	self ClearAnim( %exposed_aiming, 0.2 );
	self animscripts\anims::clearAnimCache();

	self notify("dont_end_idle");

	// behavior callbacks need to have a wait
	wait(0.05);

	return true;
}