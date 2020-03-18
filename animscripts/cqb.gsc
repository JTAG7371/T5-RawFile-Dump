#include animscripts\utility;
#include animscripts\combat_utility;
#include animscripts\shared;
#include common_scripts\utility;

#using_animtree ("generic_human");

shouldCQB()
{
	return self isCQBWalking() && !IsDefined( self.grenade ) && !usingPistol();
}

MoveCQB()
{
	animscripts\run::changeWeaponStandRun();
	
	// any endons in this function must also be in CQBShootWhileMoving and CQBDecideWhatAndHowToShoot
	
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

	self.a.movement = self.moveMode;
	
	self ClearAnim(%combatrun, 0.2);
	
	self thread CQBTracking();
	
	variation = getRandomIntFromSeed( self.a.runLoopCount, 2 );
	if ( variation == 0 )
	{
		cqbWalkAnim = %run_CQB_F_search_v1;
	}
	else
	{
		cqbWalkAnim = %run_CQB_F_search_v2;
	}
	
	if ( self.movemode == "walk" )
	{
		cqbWalkAnim = %walk_CQB_F;
	}
	
	rate = self.moveplaybackrate;
	
	// (we don't use %body because that would reset the aiming knobs)
	self SetFlaggedAnimKnobAll( "runanim", cqbWalkAnim, %walk_and_run_loops, 1, 0.3, rate );
	
	// Play the appropriately weighted animations for the direction he's moving.
	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
	self SetAnim(%combatrun_forward, animWeights["front"], 0.2, 1);
	self SetAnim(%walk_backward, animWeights["back"], 0.2, 1);
	self SetAnim(%walk_left, animWeights["left"], 0.2, 1);
	self SetAnim(%walk_right, animWeights["right"], 0.2, 1);
	
	animscripts\shared::DoNoteTracksForTime( 0.2, "runanim" );
	
	self thread DontCQBTrackUnlessWeMoveCQBAgain();
}

CQBTracking()
{
	self notify("want_cqb_tracking");
	
	if ( IsDefined( self.cqb_track_thread ) )
	{
		return;
	}

	self.cqb_track_thread = true;
	
	self endon("killanimscript");
	self endon("end_cqb_tracking");
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
	
	self SetAnimLimited( %walk_aim_2 );
	self SetAnimLimited( %walk_aim_4 );
	self SetAnimLimited( %walk_aim_6 );
	self SetAnimLimited( %walk_aim_8 );
	
	self.shootEnt = undefined;
	self.shootPos = undefined;
	
	if ( animscripts\move::MayShootWhileMoving() )
	{
		self thread CQBDecideWhatAndHowToShoot();
		self thread CQBShootWhileMoving();
	}

	self animscripts\shared::setAimingAnims( %run_aim_2, %run_aim_4, %run_aim_6, %run_aim_8 );
	self animscripts\shared::trackLoopStart();
}

CQBDecideWhatAndHowToShoot()
{
	self endon("killanimscript");
	self endon("end_cqb_tracking");
	self animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
}

CQBShootWhileMoving()
{
	self endon("killanimscript");
	self endon("end_cqb_tracking");
	self animscripts\move::shootWhileMoving();
}

DontCQBTrackUnlessWeMoveCQBAgain()
{
	self endon("killanimscript");
	self endon("want_cqb_tracking");
	
	wait .05;
	
	self notify("end_cqb_tracking");
	self.cqb_track_thread = undefined;
}

setupCQBPointsOfInterest()
{
	level.cqbPointsOfInterest = [];
	level.cqbSetupComplete = false;
	
	while( !IsDefined(level.struct_class_names) )
	{
		wait( 0.05 );
	}
	
	level.cqbSetupComplete = true;
	
	pointents = getEntArray( "cqb_point_of_interest", "targetname" );
	pointstructs = getstructarray( "cqb_point_of_interest", "targetname" );
	points = array_combine( pointents, pointstructs );
	for ( i = 0; i < points.size; i++ )
	{
		level.cqbPointsOfInterest[i] = points[i].origin;
		
				// TFLAME 4/30/10 - recent support for structs didn't account for not being able to delete a struct
		if (IsDefined (points[i].classname) && (points[i].classname == "script_origin" || points[i].classname == "script_model") )
		{
			points[i] delete();
		}
		
	}
}

findCQBPointsOfInterest()
{
	if ( IsDefined( anim.findingCQBPointsOfInterest ) )
	{
		return;
	}

	anim.findingCQBPointsOfInterest = true;
	
	while( !IsDefined( level.cqbSetupComplete ) || !level.cqbSetupComplete )
	{
		wait( 0.05 );
	}
	
	// one AI per frame, find best point of interest.
	if ( !level.cqbPointsOfInterest.size )
	{
		return;
	}
	
	while(1)
	{
		ai = GetAIArray();
		waited = false;

		for ( i = 0; i < ai.size; i++ )
		{
			if ( IsAlive( ai[i] ) && ai[i] isCQBWalking() )
			{
				if( IsDefined( ai[i].avoidCQBPointsOfInterests ) &&  ai[i].avoidCQBPointsOfInterests )
				{
					continue;					
				}

				moving = ( ai[i].a.movement != "stop" );

				// if you change this, change the debug function below too

				shootAtPos = ai[i] GetShootAtPos();
				lookAheadPoint = shootAtPos;
				forward = AnglesToForward( ai[i].angles );
				if ( moving )
				{
					trace = bulletTrace( lookAheadPoint, lookAheadPoint + forward * 128, false, undefined );
					lookAheadPoint = trace["position"];
				}

				best = -1;
				bestdist = 1024*1024;
				for ( j = 0; j < level.cqbPointsOfInterest.size; j++ )
				{
					point = level.cqbPointsOfInterest[j];

					dist = DistanceSquared( point, lookAheadPoint );
					if ( dist < bestdist )
					{
						if ( moving )
						{
							if ( DistanceSquared( point, shootAtPos ) < 64 * 64 )
							{
								continue;
							}

							dot = vectorDot( VectorNormalize(point - shootAtPos), forward );
							if ( dot < 0.643 || dot > 0.966 ) // 0.643 = cos(50), 0.966 = cos(15)
							{
								continue;
							}
						}
						else
						{
							if ( dist < 50 * 50 )
							{
								continue;
							}
						}

						if ( !sightTracePassed( lookAheadPoint, point, false, undefined ) )
						{
							continue;
						}

						bestdist = dist;
						best = j;
					}
				}

				if ( best < 0 )
				{
					ai[i].cqb_point_of_interest = undefined;
				}
				else
				{
					ai[i].cqb_point_of_interest = level.cqbPointsOfInterest[best];
				}

				wait .05;
				waited = true;
			}
		}

		if ( !waited )
		{
			wait .25;
		}
	}
}

/#
CQBDebug()
{
	self notify("end_cqb_debug");
	self endon("end_cqb_debug");
	self endon("death");

	if ( GetDvar( #"scr_cqbdebug") == "" )
	{
		SetDvar("scr_cqbdebug", "off");
	}

	level thread CQBDebugGlobal();

	while(1)
	{
		if ( GetDebugDvar("scr_cqbdebug") == "on" || getdebugdvarint("scr_cqbdebug") == self getentnum() )
		{
			if ( IsDefined( self.shootPos ) )
			{
				line( self GetShootAtPos(), self.shootPos, (1,1,1) );
				Print3d( self.shootPos, "shootPos", (1,1,1), 1, 0.5 );
				Record3DText( "cqb_target", self.shootPos + ( 0, 0, 20 ), (.5,1,.5), "Script" );		
			}
			else if ( IsDefined( self.cqb_target ) )
			{
				line( self GetShootAtPos(), self.cqb_target.origin, (.5,1,.5) );
				Print3d( self.cqb_target.origin, "cqb_target", (.5,1,.5), 1, 0.5 );
				Record3DText( "cqb_target", self.cqb_target.origin + ( 0, 0, 70 ), (.5,1,.5), "Script" );		
				
			}
			else
			{
				moving = ( self.a.movement != "stop" );

				forward = AnglesToForward( self.angles );
				shootAtPos = self GetShootAtPos();
				lookAheadPoint = shootAtPos;

				if ( moving )
				{
					lookAheadPoint += forward * 128;
					line( shootAtPos, lookAheadPoint, (0.7,.5,.5) );

					right = AnglesToRight( self.angles );
					leftScanArea  = shootAtPos + (forward * 0.643 - right) * 64;
					rightScanArea = shootAtPos + (forward * 0.643 + right) * 64;

					line( shootAtPos, leftScanArea, (0.5,0.5,0.5), 0.7 );
					recordLine( shootAtPos, leftScanArea, (0.5,0.5,0.5), "Script", self );

					line( shootAtPos, rightScanArea, (0.5,0.5,0.5), 0.7 );
					recordLine( shootAtPos, rightScanArea, (0.5,0.5,0.5), "Script", self );	
				}

				if ( IsDefined( self.cqb_point_of_interest ) )
				{
					line( lookAheadPoint, self.cqb_point_of_interest, (1,.5,.5) );
					Print3d( self.cqb_point_of_interest, "cqb_point_of_interest", (1,.5,.5), 1, 0.5 );
					Record3DText( "cqb_point_of_interest", self.cqb_point_of_interest, (1,.5,.5), "Script" );		
				}
			}

			wait .05;
			continue;
		}

		wait 1;
	}
}

CQBDebugGlobal()
{
	if ( IsDefined( level.cqbdebugglobal ) )
	{
		return;
	}

	level.cqbdebugglobal = true;
	
	while(1)
	{
		if ( GetDebugDvar("scr_cqbdebug") != "on" )
		{
			wait 1;
			continue;
		}
		
		for ( i = 0; i < level.cqbPointsOfInterest.size; i++ )
		{
			Print3d( level.cqbPointsOfInterest[i], ".", (.7,.7,1), .7, 3 );
		}
		
		wait .05;
	}
}
#/

