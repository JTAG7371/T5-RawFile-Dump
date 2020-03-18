#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include animscripts\debug;
#include common_scripts\utility;
#include maps\_utility; 

#using_animtree ("generic_human");

main()
{
	//prof_begin( "move_init" );
	self endon("killanimscript");

/#
	if ( GetDvar( #"showlookaheaddir") == "on" )
	{
		self thread drawLookaheadDir();
	}
#/
	
	[[ self.exception[ "move" ] ]]();

    self trackScriptState( "Move Main", "code" );
	
	self flamethrower_stop_shoot();
	
	if ( self.a.pose == "prone" )
	{
		newPose = self animscripts\utility::choosePose( "stand" );

		if ( newPose != "prone" )
		{
			self AnimMode( "zonly_physics", false );
			rate = 1;
			if ( IsDefined( self.grenade ) )
			{
				rate = 2;
			}

			self animscripts\cover_prone::proneTo( newPose, rate );
			self AnimMode( "none", false );
			self OrientMode( "face default" );
		}
	}

	previousScript = self.a.script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
	animscripts\utility::initialize("move");

	if (self.moveMode == "run")
	{
		// Say something
		switch (previousScript)
		{
		case "combat": // handle most common cases first
		case "stop":
			// Say random poop.
			self animscripts\battleChatter_ai::evaluateMoveEvent (false);
			break;

		case "cover_crouch":
		case "cover_left":
		case "cover_prone":
		case "cover_right":
		case "cover_stand":
		case "concealment_crouch":
		case "concealment_prone":
		case "concealment_stand":
		case "cover_wide_left":
		case "cover_wide_right":
		case "stalingrad_cover_crouch":
		case "Hide":
		case "turret":
			// Leaving cover.  Say something like "cover me".
			self animscripts\battleChatter_ai::evaluateMoveEvent (true);

			// Request covering fire
			self animscripts\squadmanager::postSquadMessage("coverMe", 0.5);
			break;

		default:
			// Say random poop.
			self animscripts\battleChatter_ai::evaluateMoveEvent (false);
			break;
		}
	}
	//self animscripts\battlechatter::playBattleChatter();
	
	//self thread attackEnemyWhenFlashed();
	
	//prof_end( "move_init" );
	
	// approach/exit stuff
	//prof_begin("move_startMoveTransition");
	self call_overloaded_func( "animscripts\cover_arrival", "startMoveTransition" );
	//prof_end("move_startMoveTransition");
	//prof_begin("move_setupApproachNode");
	self thread call_overloaded_func( "animscripts\cover_arrival", "setupApproachNode", true );
	//prof_end("move_setupApproachNode");
	
	self.cqb_track_thread = undefined;
	self.shoot_while_moving_thread = undefined;
	
	MoveMainLoop();
}

MoveMainLoop()
{
	prevLoopTime			= self getAnimTime( %walk_and_run_loops );
	self.a.runLoopCount		= RandomInt( 10000 ); // integer that is incremented each time we complete a run loop

	// if initial destination is closer than 64 walk to it.
	moveMode = self.moveMode;
	if ( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) < 4096 )
	{
		moveMode = "walk";
	}

	self notify("stopTurnIfNecessary");
	self thread turnIfNecessary();

	startedAiming	= false;

	self call_overloaded_func( "animscripts\rush", "sideStepInit" );
	
	for (;;)
	{
		//prof_begin("MoveMainLoop");
		loopTime = self getAnimTime( %walk_and_run_loops );
		if ( loopTime < prevLoopTime )
		{
			self.a.runLoopCount++;
		}

		prevLoopTime = loopTime;
		
		self animscripts\face::SetIdleFaceDelayed( anim.alertface );

		if( !startedAiming && self.a.isAiming && (self.a.pose == "stand" || self.a.pose == "crouch") )
		{
			startAiming();
			startedAiming = true;
		}
		
		// For banzai dudes, banzai charges take precedence over CQB moves.
		if( self is_banzai() ) // ::should_banzai() )
		{
			self call_overloaded_func( "animscripts\banzai", "move_banzai" );
		}
		else if( self call_overloaded_func( "animscripts\cqb", "shouldCQB" ) && self IsStanceAllowed("stand") )
		{
			// force stand
			if ( self.a.pose != "stand" )
			{
				// (get rid of any prone or other stuff that might be going on)
				self ClearAnim( %root, 0.2 );

				if ( self.a.pose == "prone" )
				{
					self ExitProneWrapper( 1 );
				}

				self.a.pose = "stand";
			}

			self animscripts\run::MoveRun();
		}
		else
		{
			if( movemode != "run" )
			{
				moveMode = "run";
			}

			if ( self.moveMode != "run" )
			{
				moveMode = self.moveMode;
			}

//			if( self.weapon == self.sideArm )
//			{
//				self OrientMode("face enemy");
//			}

			// if walking, check that the destination is close by, and if not, switch to actual self.moveMode
			else if ( moveMode == "walk" )
			{
				if ( !IsDefined( self.pathGoalPos ) || DistanceSquared( self.origin, self.pathGoalPos ) > 4096 )
				{
					moveMode = self.moveMode;
				}
			}
		
			if ( moveMode == "run" )
			{
				//prof_begin("MoveRun");
				self animscripts\run::MoveRun();
				//prof_end("MoveRun");
			}
			else
			{
				assertex( moveMode == "walk", "In move script, but moveMode is " + moveMode + ". Prev script: " + self.a.prevScript + ", time: " + (GetTime() - self.a.scriptStartTime) + ", hasPath: " + self HasPath());
				self animscripts\walk::MoveWalk();
			}

			call_overloaded_func( "animscripts\rush", "trySideStep" );
		}
		
		self.exitingCover = false;
		//prof_end("MoveMainLoop");
	}
}

startTurn()
{
	self endon("death");

	self notify( "killanimscript" );
	waittillframeend;

	// make sure the stance hasn't changed
	if( self.a.pose == "stand" )
	{
		self thread animscripts\turn::main();
	}
	else
	{
		self trackScriptState( "startTurn", "script" );
		
		assert( self.moveMode == "run" || self.moveMode == "walk" );
		self thread animscripts\move::main();
	}
}

// AP_TODO: if we can bring ai_runAnimUpdateFrequency down to 0.05, then we shouldn't kill the animscript
// instead just run the turn in the main move loop
turnIfNecessary()
{
	self endon("death");
	self endon("stopTurnIfNecessary");
	self endon("killanimscript");

	while(1)
	{
		if( self animscripts\turn::shouldTurn() )
		{
			self thread startTurn();
			break;
		}

		wait(0.05);
	}
}

MayShootWhileMoving()
{
	if ( self.weapon == "none" )
	{
		return false;
	}
	
	weapclass = weaponClass( self.weapon );
	if ( weapclass != "rifle" && weapclass != "smg" && weapclass != "spread" && weapclass != "mg" && weapclass != "grenade" && weapclass != "pistol" )
	{
		return false;
	}
	
	if ( self isSniper() )
	{
		return false;
	}

	if ( IsDefined( self.dontShootWhileMoving ) )
	{
		assert( self.dontShootWhileMoving ); // true or undefined
		return false;
	}

	return true;
}
	
shootWhileMoving()
{
	self endon("killanimscript");
	
	// it's possible for this to be called by CQB while it's already running from run.gsc,
	// even though run.gsc will kill it on the next frame. We can't let it run twice at once.
	self notify("doing_shootWhileMoving");
	self endon("doing_shootWhileMoving");

	/#
	self animscripts\debug::debugPushState( "shootWhileMoving" );
	#/
	
	while(1)
	{
		if( !self.bulletsInClip )
		{
			if( self isCQBWalking() || self is_rusher() || self is_banzai() || self.a.idleStrafing || self.a.reactingToAim )
			{
				cheatAmmoIfNecessary();
			}
	
			if( !self.bulletsInClip )
			{
				wait 0.5;
				continue;
			}
		}
	
		self shootUntilShootBehaviorChange();
	}

	/#
	self animscripts\debug::debugPopState();
	#/
}

/#
drawLookaheadDir()
{
	self endon("killanimscript");

	for (;;)
	{
		line(self.origin + (0,0,20), (self.origin + vector_scale(self.lookaheaddir,64)) + (0,0,20));	
		wait(0.05);
	}
}
#/

startAiming()
{
	aimLimit = 50;

	if( self call_overloaded_func( "animscripts\cqb", "shouldCQB" ) && self.a.pose == "stand" )
	{
		aimLimit = 45;
	}

	self.rightAimLimit	= aimLimit;
	self.leftAimLimit	= aimLimit * -1;
	self.upAimLimit		= aimLimit;
	self.downAimLimit	= aimLimit * -1;

	self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 );
	self animscripts\shared::trackLoopStart();
}

