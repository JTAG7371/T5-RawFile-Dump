#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include animscripts\anims;
#include common_scripts\utility;

#using_animtree ("generic_human");

main()
{
	self endon("killanimscript");
	self endon("death");

    self trackScriptState( "Turn Main", "code" );

	previousScript = self.a.script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
	animscripts\utility::initialize("turn");

	self notify("stopShooting");
	
	doTurn();

	self thread startMove();
}

doTurn()
{
	self notify("stopTurnBlendOut");

	/#recordEntText( "turn angle: " + self animscripts\run::GetLookaheadAngle(), self, level.color_debug["green"], "Pathfind" );#/
	//recordEntText( "motion angle: " + self GetMotionAngle(), self, level.color_debug["green"], "Pathfind" );

	minAngle = GetDvarFloat( #"ai_turnAnimAngleThreshold");

	turnAngle = self animscripts\run::GetLookaheadAngle();

	/#
	angleStr = "";
	if( turnAngle < 0 )
	{
		angleStr = "right " + turnAngle;
	}
	else
	{
		angleStr = "left " + turnAngle;
	}

	self animscripts\debug::debugPushState( "angle", angleStr );
	#/

	turnAnim = getTurnAnim(turnAngle);

	if( IsDefined(turnAnim) )
	{
		prevMovement = self.a.movement;
		self.a.movement = "stop";

		// play strict anim
		self AnimMode( "gravity", false );
		self OrientMode( "face angle", self.angles[1] );

		// must keep this low, otherwise there's a weird pop because of the client until we fix the networking
		runBlendOutTime = 0.10;

		self ClearAnim( %body, runBlendOutTime );
		self SetFlaggedAnimRestart( "turn_anim", turnAnim, 1, runBlendOutTime );

		// ugh
		self thread forceClearClientRunTree( runBlendOutTime );

		animStartTime = GetTime();
		animLength    = GetAnimLength(turnAnim);

		hasExitAlign = animHasNotetrack( turnAnim, "exit_align" );
		if ( !hasExitAlign )
		{
			// AI_TODO: print anim name
			println("^3Warning: turn animation for angle " + turnAngle + " has no \"exit_align\" notetrack.");
		}

		self thread doTurnNotetracks( "turn_anim" );
		self thread turnBlendOut( animLength, "turn_anim", hasExitAlign );
	
		// wait till the notetrack telling us to start turning the AI
		self waittillmatch( "turn_anim", "exit_align" );

		// set the time we have to available to turn
		elapsed  = (getTime() - animStartTime) / 1000.0;
		timeLeft = animLength - elapsed;

		// see if there's a notetrack that says when to stop turning, otherwise go till end
		hasCodeMoveNoteTrack = animHasNotetrack( turnAnim, "code_move" );
		if( hasCodeMoveNoteTrack )
		{
			times = getNotetrackTimes( turnAnim, "code_move" );
			assertEx( times.size == 1, "More than one code_move notetrack found" );

			timeLeft = times[0] * animLength - elapsed;

			/#recordEntText( "hasCodeMove", self, level.color_debug["red"], "Pathfind" );#/
		}

		/#recordEntText( "animLength: " + animLength + " elapsed: " + elapsed + " timeLeft: " + timeLeft, self, level.color_debug["red"], "Pathfind" );#/

		// AI_TODO: need to set up test case and fix case when a turn needs to be performed over a very short distance
		// right now the AI will turn too slow and miss the goal, and just keep going back and forth

		// now manually set the facing vector of the AI every frame during this turn window
		self AnimMode( "pos deltas", false );
		lookaheadAngles = VectorToAngles( self.lookaheaddir );

		yawDelta = AngleClamp180(lookaheadAngles[1] - self.angles[1]);	// total
		yawDelta = yawDelta / ceil(timeLeft / 0.05);					// per frame

		timer = 0;
		while( timer < timeLeft )
		{
			//self OrientMode("face angle", self.angles[1] + yawDelta);

			newAngles = (self.angles[0], self.angles[1] + yawDelta, self.angles[2]);
			self Teleport( self.origin, newAngles );

			/#recordEntText( "face angle: " + (self.angles[1] + yawDelta), self, level.color_debug["red"], "Pathfind" );#/

			timer += 0.05;
			wait( 0.05 );
		}

		self AnimMode( "normal", false );
		self OrientMode( "face default" );

		// wait till end of anim, if necessary
		elapsed  = (getTime() - animStartTime) / 1000.0;
		timeLeft = animLength - elapsed;

		timer = 0;		
		while( timer < timeLeft )
		{
			// make another turn, if necessary
			if( shouldTurn() )
			{
				break;
			}

			timer += 0.05;

			wait( 0.05 );
		}

		self.a.movement = prevMovement;
	}

	/#
	self animscripts\debug::debugPopState();
	#/
}

startMove()
{
	self endon("death");

	self notify( "killanimscript" );
	waittillframeend;

	// before the turn, the move script may have been waiting to get to an arrival pos for the cover node
	// and that thread would've been killed by the turn, so repath again to the original node in order
	// to make sure the cover arrival animations end up playing
	if( IsDefined(self.node) )
	{
		self ClearRunToPos();
		self UseCoverNode(self.node);

		//println( self GetEntNum() + ": turn/arrival fix (time: " + GetTime() + ")" );
	}

	if( self.moveMode == "run" || self.moveMode == "walk" )
	{
		self thread animscripts\move::main();
	}
	else
	{
		self thread animscripts\stop::main();
	}
}

forceClearClientRunTree( blendTime )
{
	self endon("killanimscript");
	self endon("death");

	wait( 0.05 );

	self ClearAnim( %stand_and_crouch, blendTime - 0.05 );
}

turnBlendOut( animLength, animName, hasExitAlign )
{
	self endon("killanimscript");
	self endon("death");
	self endon("stopTurnBlendOut");

	runBlendInTime = 0.05; // to fix an extra frame of sliding that happens on the client

	assert( animLength > runBlendInTime );
	wait( animLength - runBlendInTime );

	// go back to run
	self ClearAnim( %body, runBlendInTime );
	self SetFlaggedAnimRestart( "run_anim", animscripts\run::GetRunAnim(), 1, runBlendInTime );

	if ( !hasExitAlign )
	{
		self notify( animName, "exit_align" ); // failsafe
	}
}

shouldTurn()
{
	// SUMEET - added a way to turn turns on a perticular AI
	if( IsDefined( self.disableTurns ) && self.disableTurns )
	{
		return false;
	}

	self.a.turnIgnoreMotionAngle = false;

	minAngle = GetDvarFloat( #"ai_turnAnimAngleThreshold");

	// this is not scientific at all, just trying to see if the AI's moving
	minSpeed = 190 * 0.05; // typical run speed per frame
	minSpeed *= minSpeed;  // square it
	minSpeed *= 0.25;	   // quarter it

	turnAngle = self animscripts\run::GetLookaheadAngle();

	velocity	= self GetAiVelocity();
	velocity	= (velocity[0], velocity[1], 0); // only care about horizontal
	speedSq		= LengthSquared(velocity);

	// dvar: ai_turnAnimAngleThreshold
	if( abs(turnAngle) < minAngle )
	{
		return false;
	}

	// must be standing
	if( self.a.pose != "stand" )
	{
		return false;
	}

	// must not strafing and must have at least some speed
	if( !self.isFacingMotion || speedSq < minSpeed )
	{
		// unless just coming out of a traversal
		if( self.a.prevScript == "traverse" && self.a.movement == "run" && self.a.scriptStartTime == GetTime() )
		{
			self.a.turnIgnoreMotionAngle = true;
		}
		else
		{
			return false;
		}
	}

	// turns may make us miss the target
	if( self.lookaheaddist < 100 )
	{
		// unless it's a big turn
		if( self.lookaheaddist < 50 || abs(turnAngle) < 45 )
		{
			return false;
		}
	}

	// must have an anim
	if( !IsDefined( getTurnAnim(turnAngle) ) )
	{
		return false;
	}

	return true;
}

getTurnAnim(turnAngle)
{
	turnAnim = undefined;
	turnAnimLookUpKey = undefined;
	
	// pick a turn anim. if turn shouldn't be done, then leave it undefined;
	motionAngle = self GetMotionAngle();
	
	// ALEXP_TODO: need to check velocity too
	if( !self.a.turnIgnoreMotionAngle && abs(motionAngle) > 45 ) // strafing
	{
		if( abs(turnAngle) > 135 )
		{
			if( turnAngle > 0 )
			{
				turnAnimLookUpKey = "turn_b_r_180";
			}
			else
			{
				turnAnimLookUpKey = "turn_b_l_180";
			}			
		}
	}
	else // normal turns
	{
		if( turnAngle > 135 )
		{
			turnAnimLookUpKey = "turn_f_l_180";
			
		}
		else if( turnAngle > 90 )
		{
			turnAnimLookUpKey = "turn_f_l_90";
			
		}
		else if( turnAngle > 45 )
		{
			turnAnimLookUpKey = "turn_f_l_45";
			
		}
		else if( turnAngle < -135 )
		{
			turnAnimLookUpKey = "turn_f_r_180";
			
		}
		else if( turnAngle < -90 )
		{
			turnAnimLookUpKey = "turn_f_r_90";
			
		}
		else if( turnAngle < -45 )
		{
			turnAnimLookUpKey = "turn_f_r_45";
			
		}
	}

	// get the turn anim based on the selected look up key
	if( IsDefined( turnAnimLookUpKey ) )
	{
		// switch to special turn key if needed for current run cycle
		turnAnimLookUpKey = turnAnimLookUpKey + shouldDoSpecialTurn();

		turnAnim = animArray( turnAnimLookUpKey, "turn" );
	}
	
	return turnAnim;
}

shouldDoSpecialTurn()
{
	specialTurnSuffix = "";

	// special turn anims for sprint and cqb
	if( self IsCQBWalking() )
		specialTurnSuffix = "_cqb";
	else if( self.sprint )
		specialTurnSuffix = "_sprint";
	
	return specialTurnSuffix;
}

doTurnNotetracks( flagName )
{
	self notify("stop_DoNotetracks");

	self endon("killanimscript");
	self endon("death");
	self endon("stop_DoNotetracks");

	self animscripts\shared::DoNoteTracks( flagName );
}