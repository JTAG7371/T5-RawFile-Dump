#include maps\_utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_Utility;
#include animscripts\Debug;
#include animscripts\anims;
#include common_scripts\Utility;
#using_animtree ("generic_human");

// ===========================================================
//     AI vs Player melee
// ===========================================================

MeleeCombat()
{
  //self trackScriptState( "melee", "Exposed Combat said so" );
 	self endon("killanimscript");
	self melee_notify_wrapper();
//	self endon(anim.scriptChange);

	/#
	self animscripts\debug::debugPushState( "melee" );
	#/

	assert( CanMeleeAnyRange() );

	// AI vs AI melee disabled for now.
	if(IsDefined(level.allow_ai_vs_ai_melee ))
	{
		doingAIMelee = (isAI( self.enemy ) && self.enemy.type == "human");
	}
	else
	{
		doingAIMelee = false;
	}
	
	if ( doingAiMelee )
	{
		assert( animscripts\utility::okToMelee( self.enemy ) );
		animscripts\utility::IAmMeleeing( self.enemy );
		
		AiVsAiMeleeCombat();
		
		animscripts\utility::ImNotMeleeing( self.enemy );
		
		scriptChange();

		/#
		self animscripts\debug::debugPopState( "melee", "AIvsAI" );
		#/

		return;
	}
	
	realMelee = true;

	if ( animscripts\utility::okToMelee(self.enemy) )
	{
		animscripts\utility::IAmMeleeing(self.enemy);
	}
	else
	{
		realMelee = false;
	}

	self thread EyesAtEnemy();
	self OrientMode("face enemy");
	
	MeleeDebugPrint("Melee begin");
	
	self AnimMode( "zonly_physics" );
	
	resetGiveUpTime();

	first_time = true;
	
    for ( ;; )
    {
		// first, charge forward if we need to; get into place to play the melee animation
		if ( !PrepareToMelee(first_time) )
		{
			// if we couldn't get in place to melee, don't melee.
			// remember that we couldn't get in place so that we don't try again for a while.
			self.lastMeleeGiveUpTime = GetTime();
			break;
		}

		first_time = false;
		
		assert( self.a.pose == "stand");
		
		MeleeDebugPrint("Melee main loop" + RandomInt(100));
		
		// we should now be close enough to melee.
		
		// If no one else is meleeing this person, tell the system that I am, so no one else will charge him.
		if ( !realMelee && animscripts\utility::okToMelee(self.enemy) )
		{
			realMelee = true;
			animscripts\utility::IAmMeleeing(self.enemy);
		}

		self thread EyesAtEnemy();
		
		// TODO: we should use enemypose to play crouching melee anims when necessary.
		/*player = anim.player;
		if (self.enemy == player)
		{
			enemypose = player getstance();
		}
		else
		{
			enemypose = self.enemy.a.pose;
		}*/
		
		self OrientMode("face current");			
		
		if ( self maps\_bayonet::has_bayonet() && RandomInt( 100 ) < 0 ) // turned it off for now because the animation isn't done.
		{
			self SetFlaggedAnimKnobAllRestart("meleeanim", animArray("bayonet"), %body, 1, .2, 1);
		}
		else
		{	
			self SetFlaggedAnimKnobAllRestart("meleeanim", animArray("melee"), %body, 1, .2, 1);
		}
		
		while ( 1 )
		{
			self waittill("meleeanim", note);
			if ( note == "end" )
			{
				break;
			}
			else if ( note == "fire" )
			{
				if ( !IsDefined( self.enemy ) )
				{
					break;
				}
					
				oldhealth = self.enemy.health;
				self melee();

				if ( self.enemy.health < oldhealth )
				{
					resetGiveUpTime();
				}
			}
			else if ( note == "stop" )
			{
				// check if it's worth continuing with another melee.
				if ( !CanContinueToMelee() ) // "if we can't melee without charging"
				{
					break;
				}
			}
		}
		
		self OrientMode("face default");
    }
	
	if (realMelee)
	{
		animscripts\utility::ImNotMeleeing(self.enemy);
	}
	
	self AnimMode("none");

	/#
	self animscripts\debug::debugPopState( "melee" );
	#/
	
	//self thread animscripts\combat::main();
	/#
	debug_replay("melee.gsc MeleeCombat()");
	#/
	
	self thread backToCombat();
}

backToCombat()
{
	self notify("killanimscript");
	waittillframeend;

	self thread animscripts\combat::main();
	self notify ("stop EyesAtEnemy");
	self notify ("stop_melee_debug_print");
	scriptChange();
}

resetGiveUpTime()
{
	if ( DistanceSquared( self.origin, self.enemy.origin ) > anim.chargeRangeSq )
	{
		self.giveUpOnMeleeTime = GetTime() + randomintrange( 2700, 3300 );
	}
	else
	{
		self.giveUpOnMeleeTime = GetTime() + randomintrange( 1700, 2300 );
	}
}

MeleeDebugPrint(text)
{
	return;
	self.meleedebugprint = text;
	self thread meleeDebugPrintThreadWrapper();
}

meleeDebugPrintThreadWrapper()
{
	if ( !IsDefined(self.meleedebugthread) )
	{
		self.meleedebugthread = true;
		self meleeDebugPrintThread();
		self.meleedebugthread = undefined;
	}
}

meleeDebugPrintThread()
{
	self endon("death");
	self endon("killanimscript");
	self endon("stop_melee_debug_print");
	
	while(1)
	{
		Print3d(self.origin + (0,0,60), self.meleedebugprint, (1,1,1), 1, .1);
		wait .05;
	}
}

// Debug melee functions
debug_melee_on_actor()
{
	/#
	dvar = GetDvarInt( #"ai_debugMelee" );
	if ( dvar == 0 )
	{
		return false;
	}
	
	if ( dvar == 1 )
	{
		return true;
	}
	
	if ( int( dvar ) == self getentnum() )
	{
		return true;
	}
	#/

	return false;
}

debug_melee( msg )
{
/#
	if ( !debug_melee_on_actor() )
	{
		return;
	}

	PrintLn( msg );

	recordEntText( msg, self, level.color_debug["white"], "Script" );
#/
}

debug_melee_line( start, end, color, duration )
{
	/#
	dvar = GetDvarInt( #"ai_debugMelee" );
	if ( dvar == 0 )
	{
		return;
	}


	if( IsDefined(self) )
	{
		recordLine( start, end, color, "Script", self );
	}
	
	debugLine( start, end, color, duration );
	#/
}


getEnemyPose()
{
	if ( IsPlayer( self.enemy ) )
	{
		return self.enemy getStance();
	}
	else
	{
		return self.enemy.a.pose;
	}
}

CanContinueToMelee()
{
	return CanMeleeInternal( "already started" );
}

CanMeleeAnyRange()
{
	return CanMeleeInternal( "any range" );
}

CanMeleeDesperate()
{
	return CanMeleeInternal( "long range" );
}

CanMelee()
{
	return CanMeleeInternal( "normal" );
}

CanMeleeInternal( state )
{
	// no meleeing virtual targets
	if ( !IsSentient( self.enemy ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "can't melee non sentients" );
		#/

		debug_melee( "Not doing melee - Does not have a valid target." );
		return false;
	}

	// or dead ones
	if (!IsAlive(self.enemy))
	{
		/#
		self animscripts\debug::debugPopState( undefined, "can't melee dead targets" );
		#/

		return false;
	}
	
	if ( IsDefined( self.disableMelee ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "melee disabled" );
		#/

		assert( self.disableMelee ); // must be true or undefined
		debug_melee( "Not doing melee - Melee is disabled, self.disableMelee is set to true." );
		return false;
	}
	
	// Can't charge if we're not standing
	if (self.a.pose != "stand")
	{
		/#
		self animscripts\debug::debugPopState( undefined, "not standing" );
		#/

		debug_melee( "Not doing melee - Cant melee in " + self.a.pose );
		return false;
	}
	
	enemypose = getEnemyPose();
	if ( !IsPlayer( self.enemy ) && enemypose != "stand" && enemypose != "crouch" )
	{
		// banzai can charge prone enemies because the enemies will automatically pop up into a crouch.
		if ( !( self is_banzai() && enemypose == "prone" ) )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "enemy is prone" );
			#/

			debug_melee( "Not doing melee - Enemy is in prone." );
			return false;
		}
	}
	
	// if we're not at least partially facing the guy, wait until we are
	yaw = abs(getYawToEnemy());
	if ( self.a.allow_shooting && ((yaw > 60 && state != "already started") || yaw > 110) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "not facing enemy" );
		#/

		debug_melee( "Not doing melee - Not facing the enemy." );
		return false;
	}
	
	enemyPoint = self.enemy GetOrigin();
	vecToEnemy = enemyPoint - self.origin;
	self.enemyDistanceSq = lengthSquared( vecToEnemy );

	// so we don't melee charge a guy who has gained ignoreme in the past frame
	nearest_enemy_sqrd_dist = self GetClosestEnemySqDist();
	epsilon = 0.1; // Necessary to avoid rounding errors.

	
	if( IsDefined( nearest_enemy_sqrd_dist ) &&  ( nearest_enemy_sqrd_dist - epsilon > self.enemyDistanceSq ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "can't melee any range" );
		#/

		debug_melee( "Not doing melee - Entity " + self getEntityNumber() + " can't melee entity " + self.enemy getEntityNumber() + " at distSq " + self.enemyDistanceSq + " because there is a closer enemy at distSq " + nearest_enemy_sqrd_dist + "." );
		return false;
	}

	// AI vs AI melee disabled for now.
	if(IsDefined(level.allow_ai_vs_ai_melee ))
	{
		doingAIMelee = (isAI( self.enemy ) && self.enemy.type == "human");
	}
	else
	{
		doingAIMelee = false;
	}
	
	if ( doingAIMelee )
	{
		// temp disabled.
		//if ( self.enemyDistanceSq > anim.aiVsAiMeleeRangeSq )
		//	return false;
		
		// check if someone else is already meleeing my enemy.
		if ( !animscripts\utility::okToMelee(self.enemy) )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "enemy is alraedy being meleed" );
			#/

			debug_melee( "Not doing melee - Enemy is already being meleed." );	
			return false;
		}
		
		if ( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield && IsDefined( self.enemy.magic_bullet_shield ) && self.enemy.magic_bullet_shield )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "enemy has magic bullet shield" );
			#/

			debug_melee( "Not doing melee - Enemy has magic bullet shield." );	
			return false;
		}
	
		if ( !isMeleePathClear( vecToEnemy, enemyPoint ) )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "path to enemy is obstructed" );
			#/

			self notify("melee_path_blocked");

			return false;
		}
	}
	else
	{
		// this check can be removed when AI vs AI melee is working.
		if ( IsDefined( self.enemy.magic_bullet_shield ) && self.enemy.magic_bullet_shield )
		{
			// Banzai attacks are OK against those with magic_bullet_shield - as long as the
			// shielded ones always win the melee. 
			if ( !( self is_banzai() ) )
			{
				/#
				self animscripts\debug::debugPopState( undefined, "enemy has magic bullet shield" );
				#/

				//AI_TODO - In this case the heros should go through melee, but they do and look bad
				debug_melee( "Not doing melee - Enemy has magic bullet shield." );	
				return false;
			}
		}

		if (self.enemyDistanceSq <= anim.meleeRangeSq)
		{
				if ( !isMeleePathClear( vecToEnemy, enemyPoint ) )
				{
					if ( !self is_banzai() )
					{
						/#
						self animscripts\debug::debugPopState( undefined, "path to enemy is obstructed" );
						#/

						self notify("melee_path_blocked");

						return false;
					}
					//else
					//{
						//println( "Entity " + self getEntityNumber() + " melee path to entity " + self.enemy getEntityNumber() + " at distSq " + self.enemyDistanceSq + " not clear." );
						// If we've gotten to our banzai target and our path is blocked, reduce distance and start moving again.
						//self animscripts\banzai::set_banzai_melee_distance( 32 );
					//}
				}
				
			// Enemy is already close enough to melee.
			return true;
		}
		else if ( self is_banzai() )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "in banzai" );
			#/

			//println( "Banzai attacker not within melee range [sqrt(" + anim.meleeRangeSq + ")]" );
			return false;
		}
		
		if ( state != "any range" )
		{
			chargeRangeSq = anim.chargeRangeSq;
			if ( state == "long range" )
			{
				chargeRangeSq = anim.chargeLongRangeSq;
			}

			if (self.enemyDistanceSq > chargeRangeSq)
			{
				/#
				self animscripts\debug::debugPopState( undefined, "enemy is too far" );
				#/

				// Enemy isn't even close enough to charge.
				debug_melee( "Not doing melee - Enemy is not close enough to charge." );		
				return false;
			}
		}
		
		if ( state == "already started" ) // if we already started, we're checking to see if we can melee *without* charging.
		{
			/#
			self animscripts\debug::debugPopState( undefined, "already started" );
			#/

			return false;
		}
		
		// at this point, we can melee iff we can charge.
	
		// don't charge if we recently missed someone
		if ( ( !self is_banzai() || IsPlayer( self.enemy ) ) && self.a.allow_shooting && IsDefined( self.lastMeleeGiveUpTime ) && GetTime() - self.lastMeleeGiveUpTime < 3000 )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "recently melee and missed" );
			#/

			debug_melee( "Not doing melee - Recently meleed someone and missed." );		
			return false;
		}
		
		// check if someone else is already meleeing my enemy.
		if ( !animscripts\utility::okToMelee(self.enemy) )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "enemy is being meleed" );
			#/

			debug_melee( "Not doing melee - Enemy is being meleed." );		
			return false;
		}
			
		// okToMelee() doesn't check to see if someone is banzai attacking the enemy. Do that here.
		if ( self.enemy animscripts\banzai::in_banzai_attack() )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "enemy is being banzai'd" );
			#/

			return false;
		}
		
		// I can't melee someone else if I'm currently engaged in a banzai attack.
		if ( self animscripts\banzai::in_banzai_attack() )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "already in banzai" );
			#/

			//println( "t: " + GetTime() + " CanMeleeInternal() being called on ent " + self GetEntityNumber() + " who is already in banzai attack with ent " + self.favoriteenemy GetEntityNumber() + "." );
			return false;
		}
	
		if( !isMeleePathClear( vecToEnemy, enemyPoint ) )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "path to enemy is obstructed" );
			#/

			self notify("melee_path_blocked");

			return false;
		}
	}
	
	return true;
}

isMeleePathClear( vecToEnemy, enemyPoint )
{
	dirToEnemy = VectorNormalize( (vecToEnemy[0], vecToEnemy[1], 0 ) );
	meleePoint = enemyPoint - ( dirToEnemy[0]*32, dirToEnemy[1]*32, 0 );

	thread debug_melee_line( self.origin, meleePoint, ( 1,0,0 ), 1.5 );

	if ( !self IsInGoal( meleePoint ) )
	{
		debug_melee( "Not doing melee - Enemy is outside not in goal." );
		return false;
	}

	if ( self maymovetopoint(meleePoint) )
	{
		return true;
	}

	debug_melee( "Not doing melee - Can not move to the melee point, MayMoveToPoint failed." );
	return false;
}

// this function makes the guy run towards his enemy, and start raising his gun if he's close enough to melee.
// it will return false if he gives up, or true if he's ready to start a melee animation.
PrepareToMelee(first_time)
{
	if ( !CanMeleeAnyRange() )
	{
		return false;
	}
	
	if (self.enemyDistanceSq <= anim.meleeRangeSq)
	{
		isBatonGuard = IsDefined(self.baton_guard) && self.baton_guard;
		isRegularAi  = self.animType != "spetsnaz" && !isBatonGuard;

		// spets and baton guard melees are meant to be looped
		if( first_time || isRegularAi )
		{
			// just play a melee-from-standing transition
			self SetFlaggedAnimKnobAll("readyanim", animArray("stand_2_melee"), %body, 1, .3, 1);
			self animscripts\shared::DoNoteTracks("readyanim");
		}

		return true;
	}

	self PlayMeleeSound();
	
	prevEnemyPos = self.enemy.origin;
	
	sampleTime = 0.1;

	runToMeleeAnim = animArray("run_2_melee");

	raiseGunAnimTravelDist = length(getmovedelta(runToMeleeAnim, 0, 1));
	meleeAnimTravelDist = 32;
	shouldRaiseGunDist = anim.meleeRange * 0.75 + meleeAnimTravelDist + raiseGunAnimTravelDist;
	shouldRaiseGunDistSq = shouldRaiseGunDist * shouldRaiseGunDist;
	
	shouldMeleeDist = anim.meleeRange + meleeAnimTravelDist;
	shouldMeleeDistSq = shouldMeleeDist * shouldMeleeDist;
	
	raiseGunFullDuration = getanimlength(runToMeleeAnim) * 1000;
	raiseGunFinishDuration = raiseGunFullDuration - 100;
	raiseGunPredictDuration = raiseGunFullDuration - 200;
	raiseGunStartTime = 0;

	predictedEnemyDistSqAfterRaiseGun = undefined;
	
	
	runAnim = animscripts\run::GetRunAnim();
	
	self SetFlaggedAnimKnobAll("chargeanim", runAnim, %body, 1, .3, 1);
	raisingGun = false;
	
	while ( 1 )
	{
		MeleeDebugPrint("PrepareToMelee loop" + RandomInt(100));
		
		time = GetTime();
		
		willBeWithinRangeWhenGunIsRaised = (IsDefined( predictedEnemyDistSqAfterRaiseGun ) && predictedEnemyDistSqAfterRaiseGun <= shouldRaiseGunDistSq);
		
		if ( !raisingGun )
		{
			if ( willBeWithinRangeWhenGunIsRaised )
			{
				self SetFlaggedAnimKnobAllRestart("chargeanim", runToMeleeAnim, %body, 1, .2, 1);
				raiseGunStartTime = time;
				raisingGun = true;
			}
		}
		else
		{
			// if we *are* raising our gun, don't stop unless we're hopelessly out of range,
			// or if we hit the end of the raise gun animation and didn't melee yet
			withinRangeNow = self.enemyDistanceSq <= shouldRaiseGunDistSq;
			if ( time - raiseGunStartTime >= raiseGunFinishDuration || (!willBeWithinRangeWhenGunIsRaised && !withinRangeNow) )
			{
				self SetFlaggedAnimKnobAll("chargeanim", runAnim, %body, 1, .3, 1);
				raisingGun = false;
			}
		}
		self animscripts\shared::DoNoteTracksForTime(sampleTime, "chargeanim");
		
		// it's possible something happened in the meantime that makes meleeing impossible.
		if ( !CanMeleeAnyRange() )
		{
			return false;
		}

		assert( IsDefined( self.enemyDistanceSq ) ); // should be defined in CanMelee

		enemyVel = vector_scale( self.enemy.origin - prevEnemyPos, 1 / (GetTime() - time) ); // units/msec
		prevEnemyPos = self.enemy.origin;
		
		// figure out where the player will be when we hit them if we (a) start meleeing now, or (b) start raising our gun now
		predictedEnemyPosAfterRaiseGun = self.enemy.origin + vector_scale( enemyVel, raiseGunPredictDuration );
		predictedEnemyDistSqAfterRaiseGun = DistanceSquared( self.origin, predictedEnemyPosAfterRaiseGun );
		
		// if we're done raising our gun, and starting a melee now will hit the guy, our preparation is finished
		if ( raisingGun && self.enemyDistanceSq <= shouldMeleeDistSq && GetTime() - raiseGunStartTime >= raiseGunFinishDuration )
		{
			break;
		}

		// don't keep charging if we've been doing this for too long.
		if ( !raisingGun && GetTime() >= self.giveUpOnMeleeTime )
		{
			/#
			self animscripts\debug::debugPopState( undefined, "too long, giving up" );
			#/

			return false;
		}
	}

	return true;
}

PlayMeleeSound()
{
	if ( !IsDefined ( self.a.nextMeleeChargeSound ) )
	{
		 self.a.nextMeleeChargeSound = 0;
	}
	
	if ( GetTime() > self.a.nextMeleeChargeSound )
	{
		self animscripts\face::SaySpecificDialogue( undefined, "chr_play_grunt_" + self.voice, 0.3 );
		self.a.nextMeleeChargeSound = GetTime() + 8000;
	}
}

// ===========================================================
//     AI vs AI synced melee
// ===========================================================

AiVsAiMeleeCombat()
{
	self endon("killanimscript");
	self melee_notify_wrapper();
	
	self OrientMode("face enemy");
	
	self ClearAnim( %root, 0.3 );
	
	IWin = ( RandomInt(10) < 8 );
	if ( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		IWin = true;
	}

	if ( IsDefined( self.enemy.magic_bullet_shield ) && self.enemy.magic_bullet_shield )
	{
		IWin = false;
	}
	
	// TODO: more anims
	winAnim  = animArray("ai_vs_ai_win");
	loseAnim = animArray("ai_vs_ai_lose");
	
	if ( IWin )
	{
		myAnim = winAnim;
		theirAnim = loseAnim;
	}
	else
	{
		myAnim = loseAnim;
		theirAnim = winAnim;
	}
	
	// TODO: associate this with the anim
	desiredDistSqrd = 72 * 72;
	
	self PlayMeleeSound();
	
	// charge into correct distance
	AiVsAiMeleeCharge( desiredDistSqrd );
	
	if ( DistanceSquared( self.origin, self.enemy.origin ) > desiredDistSqrd )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "AIvsAI (too far)" );
		#/

		return false;
	}
	
	// TODO: if too close, Teleport backwards?
	
	// TODO: disable pushing?
	
	// TODO: need a tag_sync to LinkTo, like is done with dogs
	
	// start animation, start enemy on animation
	self.meleePartner = self.enemy;
	self.enemy.meleePartner = self;
	
	//self thread meleeLink();
	
	self.enemy.meleeAnim = theirAnim;
	self.enemy animcustom( ::AiVsAiAnimCustom );
	
	self.meleeAnim = myAnim;
	self animcustom( ::AiVsAiAnimCustom ); // TODO: we should try to avoid using animcustom on ourselves
}

AiVsAiMeleeCharge( desiredDistSqrd )
{
	giveUpTime = GetTime() + 2500;
	self SetAnimKnobAll( animscripts\run::GetRunAnim(), %body, 1, 0.2 );
	
	while ( DistanceSquared( self.origin, self.enemy.origin ) > desiredDistSqrd && GetTime() < giveUpTime )
	{
		// play run forward anim
		wait .05;
	}
}

AiVsAiAnimCustom()
{
	self endon("killanimscript");
	self AiVsAiMeleeAnim( self.meleeAnim );
}

AiVsAiMeleeAnim( myAnim )
{
	self endon("end_melee");
	self thread endMeleeOnKillanimscript();
	
	partnerDir = self.meleePartner.origin - self.origin;
	self OrientMode( "face angle", VectorToAngles( partnerDir )[1] );
	self AnimMode( "zonly_physics" );

	self SetFlaggedAnimKnobAllRestart( "meleeAnim", myAnim, %body, 1, 0.2 );
	self animscripts\shared::DoNoteTracks( "meleeAnim" );
	
	self notify("end_melee");
}

endMeleeOnKillanimscript()
{
	self endon("end_melee");
	self waittill("killanimscript");
	self.meleePartner notify("end_melee");
}
