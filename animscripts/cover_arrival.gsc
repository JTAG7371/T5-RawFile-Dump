#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\debug;
#include animscripts\anims;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree ("generic_human");

main()
{
	self endon("killanimscript");
	
	if ( IsDefined( self.doMiniArrival ) )
	{
		self.doMiniArrival = undefined;
		node = self.miniArrivalNode;
		self.miniArrivalNode = undefined;
		self DoMiniArrival( node );
		return;
	}
	else if( self.a.pose != "stand" )
	{
		// arrivals only available from stand right now
		return;
	}
	
	approachnumber = self.approachNumber;
	
	newstance = undefined;
	
	assert( IsDefined( self.approachtype ) );

	arrivalAnim = animArray("arrive_" + self.approachtype)[approachnumber];
	
	assert( IsDefined( arrivalAnim ) );
	
	switch ( self.approachtype )
	{
		case "left":
		case "right":
		case "left_cqb":
		case "right_cqb":
		case "stand":
		case "stand_saw":
		case "exposed":
		case "exposed_cqb":
		case "pillar":
		case "custom_exposed":
			newstance = "stand";
			break;
			
		case "left_crouch":
		case "right_crouch":
		case "left_crouch_cqb":
		case "right_crouch_cqb":
		case "crouch_saw":
		case "crouch":
		case "exposed_crouch":
		case "exposed_crouch_cqb":
		case "pillar_crouch":
		case "custom_exposed_crouch":
			newstance = "crouch";
			break;
		
		case "prone_saw":
			newstance = "prone";
			break;
			
		default:
			assertmsg("bad node approach type: " + self.approachtype);
			return;			
	}

	rate = 1;	
	
	if( IsDefined( self.custom_approachanimrate ) )
	{
		rate = self.custom_approachanimrate;
	}
	
	blendInDuration = 0.3;
	
	self ClearAnim( %root, blendInDuration );
	
	self SetFlaggedAnimKnobRestart( "coverArrival", arrivalAnim, 1, blendInDuration, 1 );
	
	// ShortCircuiting prototype
	// Set the shortcircuted animation time if needed.	
	self thread setShortCircuitedAnimTime(arrivalAnim);
	self animscripts\shared::DoNoteTracks( "coverArrival" );
	
	if ( IsDefined( newstance ) )
	{
		self.a.pose = newstance;
	}

	self.a.movement = "stop";

	self.a.arrivalType = self.approachType;
	
	// we rely on cover to start doing something else with animations very soon.
	// in the meantime, we don't want any of our parent nodes lying around with positive weights.
	self ClearAnim( %root, .3 );
}

getNodeStanceYawOffset( approachtype )
{
	// returns the base stance's yaw offset when hiding at a node, based off the approach type
	
	if ( approachtype == "left" || approachtype == "left_crouch" )
	{
		return 90.0;
	}
	else if ( approachtype == "right" || approachtype == "right_crouch" )
	{
		return -90.0;
	}
	
	return 0;
}


canUseSawApproach( node )
{
	// SCRIPTER_MOD: JesseS (6/25/2007): updated for COD 5 weapons
	if ( 		self.weapon != "saw" 					&& self.weapon != "rpd" 
		&& 	self.weapon != "dp28"					&& self.weapon != "dp28_bipod" 
		&& 	self.weapon != "bren" 				&& self.weapon != "bren_bipod"  
		&& 	self.weapon != "30cal" 				&& self.weapon != "30cal_bipod"
		&& 	self.weapon != "bar" 					&& self.weapon != "bar_bipod"
		&& 	self.weapon != "mg42" 				&& self.weapon != "mg42_bipod" 
		&& 	self.weapon != "fg42" 				&& self.weapon != "fg42_bipod" 
		&& 	self.weapon != "type99_lmg" 	&& self.weapon != "type99_lmg_bipod")
	{
		return false;
	}

	if ( !IsDefined( node.turretInfo ) )
	{
		return false;
	}

	if ( node.type != "Cover Stand" && node.type != "Cover Prone" && node.type!= "Cover Crouch" )
	{
		return false;
	}

	if ( IsDefined( self.enemy ) && DistanceSquared( self.enemy.origin, node.origin ) < 256*256 )
	{
		return false;
	}

	if ( GetNodeYawToEnemy() > 40 || GetNodeYawToEnemy() < -40 )
	{
		return false;
	}

	return true;
}

determineNodeApproachType( node )
{
//	if ( IsDefined( node.approachtype ) )
//		return;

	if ( canUseSawApproach( node ) )
	{
		if ( node.type == "Cover Stand" )
		{
			node.approachtype = "stand_saw";
		}

		if ( node.type == "Cover Crouch" )
		{
			node.approachtype = "crouch_saw";
		}
		else if ( node.type == "Cover Prone" )
		{
			node.approachtype = "prone_saw";
		}

		assert( IsDefined( node.approachtype ) );
		return;
	}
	
	// SCRIPTER_MOD: JesseS (4/16/2008): HMG guys should only go on pathnodes or deploy.
	// So lets disable their arrivals unless they're set up the MG.
	if (self is_heavy_machine_gun())
	{ 
		if ( node.type == "Path" )
		{
			self.disablearrivals = true;
		}
		else
		{
			self.disablearrivals = false;
		}
	}
	
	if ( !IsDefined( anim.approach_types[ node.type ] ) )
	{
		return;
	}

	nodeType = node.type;

	// ALEXP 7/27/2010: no pillar arrival anims for pistol, so cheat by using cover left and right
	if( nodeType == "Cover Pillar" && usingPistol() )
	{
		if( node isNodeDontRight() )
		{
			nodeType = "Cover Left";
		}
		else
		{
			nodeType = "Cover Right";
		}
	}
	
	stance = node isNodeDontStand() && !node isNodeDontCrouch();
	
	node.approachtype = anim.approach_types[ nodeType ][ stance ];
}

getMaxDirectionsAndExcludeDirFromApproachType( approachtype )
{
	returnobj = SpawnStruct();
	
	if ( approachtype == "left" || approachtype == "left_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = 9;
	}
	else if ( approachtype == "right" || approachtype == "right_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = 7;
	}
	else if ( approachtype == "stand" || approachtype == "crouch" || approachtype == "stand_saw" || approachType == "crouch_saw" )
	{
		returnobj.maxDirections = 6;
		returnobj.excludeDir = -1;
	}
	else if ( approachtype == "exposed" || approachtype == "exposed_crouch" || approachtype == "pillar" || approachtype == "pillar_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = -1;
	}
	else if ( approachtype == "prone_saw" )
	{
		returnobj.maxDirections = 3;
		returnobj.excludeDir = -1;
	}
	else
	{
		assertmsg( "unsupported approach type " + approachtype );
	}

	return returnobj;
}

shouldApproachToExposed()
{
	// decide whether it's a good idea to go directly into the exposed position as we approach this node.

	if ( !isValidEnemy( self.enemy ) )
	{
		return false; // nothing to shoot!
	}

	if ( self NeedToReload( 0.5 ) )
	{
		return false;
	}

	if ( self isSuppressedWrapper() )
	{
		return false; // too dangerous, we need cover
	}

	// path nodes have no special "exposed" position
	if ( self.node.approachtype == "exposed" || self.node.approachtype == "exposed_crouch" )
	{
		return false;
	}

	// no arrival animations into exposed for left/right crouch
	if ( self.node.approachtype == "left_crouch" || self.node.approachtype == "right_crouch" )
	{
		return false;
	}

	return canSeePointFromExposedAtNode( self.enemy GetShootAtPos(), self.node );
}

// gets the point and angle to approach in order to arrive in exposed
//getExposedApproachData()
//{
//	returnobj = SpawnStruct();
//	
//	if ( self.node.approachtype == "stand" )
//	{
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( self.node.angles, getMoveDelta( %coverstand_hide_2_aim ) );
//		returnobj.yaw = self.node.angles[1];
//	}
//	else if ( self.node.approachtype == "crouch" )
//	{
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( self.node.angles, getMoveDelta( %covercrouch_hide_2_stand ) );
//		returnobj.yaw = self.node.angles[1];
//	}
//	else if ( self.node.approachtype == "left" || self.node.approachtype == "left_crouch" )
//	{
//		cornerMode = animscripts\corner::getCornerMode( self.node, self.enemy GetShootAtPos() );
//		assert( cornerMode != "none" ); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
//		
//		alert_to_exposed_anim = undefined;
//		if ( self.node.approachtype == "left" )
//		{
//			if ( cornerMode == "A" )
//				alert_to_exposed_anim = %corner_standL_trans_alert_2_A;
//			else
//				alert_to_exposed_anim = %corner_standL_trans_alert_2_B;
//		}
//		else
//		{
//			assert( self.node.approachtype == "left_crouch" );
//			if ( cornerMode == "A" )
//				alert_to_exposed_anim = %CornerCrL_trans_alert_2_A;
//			else
//				alert_to_exposed_anim = %CornerCrL_trans_alert_2_B;
//		}
//		
//		baseAngles = self.node.angles;
//		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset( self.node.approachtype ), baseAngles[2]);
//		
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( baseAngles, getMoveDelta( alert_to_exposed_anim ) );
//		returnobj.yaw = baseAngles[1] + getAngleDelta( alert_to_exposed_anim )[1];
//	}
//	else if ( self.node.approachtype == "right" || self.node.approachtype == "right_crouch" )
//	{
//		cornerMode = animscripts\corner::getCornerMode( self.node, self.enemy GetShootAtPos() );
//		assert( cornerMode != "none" ); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
//		
//		alert_to_exposed_anim = undefined;
//		if ( self.node.approachtype == "right" )
//		{
//			if ( cornerMode == "A" )
//				alert_to_exposed_anim = %corner_standR_trans_alert_2_A;
//			else
//				alert_to_exposed_anim = %corner_standR_trans_alert_2_B;
//		}
//		else
//		{
//			assert( self.node.approachtype == "right_crouch" );
//			if ( cornerMode == "A" )
//				alert_to_exposed_anim = %CornerCrR_trans_alert_2_A;
//			else
//				alert_to_exposed_anim = %CornerCrR_trans_alert_2_B;
//		}
//		
//		baseAngles = self.node.angles;
//		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset( self.node.approachtype ), baseAngles[2]);
//		
//		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( baseAngles, getMoveDelta( alert_to_exposed_anim ) );
//		returnobj.yaw = baseAngles[1] + getAngleDelta( alert_to_exposed_anim )[1];
//	}
//	else
//	{
//		assertmsg( "bad node approach type: " + self.node.approachtype );
//	}
//	
//	return returnobj;
//}

calculateNodeOffsetFromAnimationDelta( nodeAngles, delta )
{
	// in the animation, forward = +x and right = -y
	right = AnglesToRight( nodeAngles );
	forward = AnglesToForward( nodeAngles );
		
	return vector_scale( forward, delta[0] ) + vector_scale( right, 0-delta[1] );
}

setupApproachNode( firstTime )
{
	self endon("killanimscript");
	
	// this lets code know that script is expecting the "corner_approach" notify
	if ( firstTime )
	{
		self.requestArrivalNotify = true;
	}
	
	self.a.arrivalType = undefined;
	self thread doLastMinuteExposedApproachWrapper();
	
	// ShortCircuiting prototype
	self.isShortCircuiting = false;
		
	// "corner_approach" actually means "cover_approach".
	self waittill( "corner_approach", approach_dir );
	
	// if we're going to do a negotiation, we want to wait until it's over and move.gsc is called again
	if ( IsDefined( self getnegotiationstartnode() ) )
	{
		/#
		debug_arrival( "Not doing approach: path has negotiation start node" );
		#/
		return;
	}
	
	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("Not doing approach: self.disableArrivals is true");
		#/
		return;
	}

	if( self.a.pose != "stand" )
	{
		/#
		debug_arrival("Not doing approach: pose is not stand");
		#/
		return;
	}

	self thread setupApproachNode( false );	// wait again
	
	approachType = "exposed";
	approachPoint = self.pathGoalPos;
	approachNodeYaw = VectorToAngles( approach_dir )[1];
	approachFinalYaw = approachNodeYaw;
	if ( IsDefined( self.node ) )
	{
		determineNodeApproachType( self.node );
		if ( IsDefined( self.node.approachtype ) && self.node.approachtype != "exposed" )
		{
			approachType = self.node.approachtype;

			if ( approachType == "stand_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = AnglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = AnglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + vector_scale( forward, -32.545 ) - vector_scale( right, 6.899 );
			}
			else if ( approachType == "crouch_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = AnglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = AnglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + vector_scale( forward, -32.545 ) - vector_scale( right, 6.899 );
			}
			else if ( approachType == "prone_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = AnglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = AnglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + vector_scale( forward, -37.36 ) - vector_scale( right, 13.279 );
			}
			else
			{
				approachPoint = self.node.origin;
			}
				
			approachNodeYaw = self.node.angles[1];
			approachFinalYaw = approachNodeYaw + getNodeStanceYawOffset( approachType );
		}
		
		/#
		if ( IsDefined( level.testingApproaches ) && approachType == "exposed" )
		{
			approachNodeYaw = self.node.angles[1];
			approachFinalYaw = approachNodeYaw;
		}
		#/
	}

	
	//if ( approachType == "exposed" && !IsDefined( self.pathGoalPos ) )
	//	return;
	
	/#
	debug_arrival("^5approaching cover (ent " + self getentnum() + ", type \"" + approachType + "\"):");
	debug_arrival("   approach_dir = (" + approach_dir[0] + ", " + approach_dir[1] + ", " + approach_dir[2] + ")");

	angle = AngleClamp180( VectorToAngles( approach_dir )[1] - approachNodeYaw + 180 );
	if ( angle < 0 )
	{
		debug_arrival("   (Angle of " + (0-angle) + " right from node forward.)");
	}
	else
	{
		debug_arrival("   (Angle of " + angle + " left from node forward.)");
	}
	#/
	
	// we're doing default exposed approaches in doLastMinuteExposedApproach now
	if ( approachType == "exposed" )
	{
		/#
		if ( IsDefined( self.node ) )
		{
			if ( IsDefined( self.node.approachtype ) )
			{
				debug_arrival( "Aborting cover approach: node approach type was " + self.node.approachtype );
			}
			else
			{
				debug_arrival( "Aborting cover approach: node approach type was undefined" );
			}
		}
		else
		{
			debug_arrival( "Aborting cover approach: self.node is undefined" );
		}
		#/
		return;
	}
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		// removed this because it needs to be maintained/fixed but i didn't feel it was that important
		//thread drawTransAnglesOnNode(self.node);
		thread drawApproachVec(approach_dir);
	}
	#/
	
	//prof_begin( "move_startCornerApproach" );
	startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir );
	//prof_end( "move_startCornerApproach" );
}

startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir, forceCQB )
{
	self endon("killanimscript");
	self endon("corner_approach");
	
	assert( IsDefined( approachType ) );
	
	if ( approachType == "stand" || approachType == "crouch" )
	{
		assert( IsDefined( self.node ) );
		if ( AbsAngleClamp180( VectorToAngles( approach_dir )[1] - self.node.angles[1] + 180 ) < 60 )
		{
			/#
			debug_arrival( "approach aborted: approach_dir is too far forward for node type " + self.node.type );
			#/
			return;
		}
	}
	
	result = getMaxDirectionsAndExcludeDirFromApproachType( approachType );
	maxDirections = result.maxDirections;
	excludeDir = result.excludeDir;
	
	approachNumber = -1;
	approachYaw = undefined;
	finalPositionYawOffset = 0;
	
	// Switch to CQB transition if needed
	doingCQBApproach = shouldDoCQBTransition( self.node, approachType, 1, forceCQB );
	if( doingCQBApproach )
		approachType = approachType + "_cqb";

	result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approach_dir, maxDirections, excludeDir );

	/#
	for ( i = 0; i < result.data.size; i++ )
	{
		debug_arrival( result.data[i] );
	}
	#/

	if ( result.approachNumber < 0 )
	{
		// try the cqb transitions since they're shorter
		if( !doingCQBApproach && canDoCQBTransition( self.node, approachType, 1 ) )
		{
			/#
			debug_arrival( "approach aborted: " + result.failure );
			debug_arrival( "attempting cqb approach" );
			#/

			return startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir, true );
		}

		/#
		debug_arrival( "approach aborted: " + result.failure );
		#/
		return;
	}

	approachNumber = result.approachNumber;
	
	/#
	debug_arrival( "approach success: dir " + approachNumber );
	#/

	// send an AI to the cover enter position from the current position.
	// ShortCircuiting prototype - modify the cover enter position if shortcircuiting.
	if( IsDefined(result.approachPoint) )	
	{		
		/#
		thread debug_arrival_line( self.origin, result.approachPoint, (1,0,0), 1.5 );
		#/

		self.coverEnterPos = result.approachPoint;
	}
	
	self setRunToPos( self.coverEnterPos );
	self waittill("runto_arrived");
	
	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("approach aborted at last minute: self.disableArrivals is true");
		#/

		return;
	}
	
	/*if ( self isCQBWalking() )
	{
		/#
		debug_arrival("approach aborted at last minute: self.cqbwalking is true");
		#/
		return;
	}*/

	// so we don't make guys turn around when they're (smartly) facing their enemy as they walk away
	if ( abs( self getMotionAngle() ) > 45 && IsDefined( self.enemy ) && vectorDot( AnglesToForward( self.angles ), VectorNormalize( self.enemy.origin - self.origin ) ) > .8 )
	{
		/#
		debug_arrival("approach aborted at last minute: facing enemy instead of current motion angle");
		#/

		return;
	}

	if ( self.a.pose != "stand" || ( self.a.movement != "run" && !(self isCQBWalking()) && !( self is_banzai() )  ) )
	{
		/#
		debug_arrival( "approach aborted at last minute: not standing and running" );
		#/

		return;
	}

	// ShortCircuiting prototype - Shortcircuiting will require a different angle.
	if( IsDefined(result.animTime) )
	{
		requiredYaw = approachFinalYaw - getAngleDelta( animArray("arrive_"+approachType)[approachNumber], result.animTime, 1 );
	}
	else
	{
		requiredYaw = approachFinalYaw - angleDeltaArray("arrive_" + approachType)[approachNumber];	 
	}
	
	if ( AbsAngleClamp180( requiredYaw - self.angles[1] ) > 30 )
	{
		// don't do an approach away from an enemy that we would otherwise face as we moved away from them
		if ( isValidEnemy( self.enemy ) && self canSee( self.enemy ) && DistanceSquared( self.origin, self.enemy.origin ) < 256 * 256 )
		{
			// check if enemy is in frontish of us
			if ( vectorDot( AnglesToForward( self.angles ), self.enemy.origin - self.origin ) > 0 )
			{
				/#
				debug_arrival( "aborting approach at last minute: don't want to turn back to nearby enemy" );
				#/
				return;
			}
		}
	}

	// make sure the path is still clear
	if ( !checkCoverEnterPos( approachPoint, approachFinalYaw, approachType, approachNumber ) )
	{
		/#
		debug_arrival( "approach blocked at last minute" );
		#/
		return;
	}
	
	self.approachNumber = approachNumber;	// used in cover_arrival::main()
	self.approachType = approachType;
	self.doMiniArrival = undefined;
	self.shortCircuitAnimTime = result.animTime; // ShortCircuiting prototype	
	self startcoverarrival( self.coverEnterPos, requiredYaw );
}

CheckArrivalEnterPositions( approachpoint, approachYaw, approachtype, approach_dir, maxDirections, excludeDir )
{
	//println("approachtype " + approachtype + " max d " + maxDirections + " ed " + excludeDir);
	angleDataObj = SpawnStruct();
	
	calculateNodeTransitionAngles( angleDataObj, approachtype, true, approachYaw, approach_dir, maxDirections, excludeDir );
	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	resultobj = SpawnStruct();
	/#resultobj.data = [];#/
	
	arrivalPos = (0, 0, 0);
	resultobj.approachNumber = -1;

	// ShortCircuiting prototype - 
	// If the AI is too close to destination and cant play full arrival animation (even with doLastMinuteExposedApproach) then
	// we try to shortcircuit the arrival animation and play part of it from the available distance.
	// This will modify the self.coverEnterPos which will be at smaller distance from the approachpoint
	// than the original distance.
	resultObj.animTime = undefined; 
	selectedNotetrackIndex = undefined;
	coverEnterEnt = undefined;
	resultobj.approachPoint = undefined;
			
	numAttempts = 2;
	if ( approachtype == "exposed" )
	{
		numAttempts = 1;
	}
	
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
		
		resultobj.approachNumber = angleDataObj.transIndex[i];
		if ( !self checkCoverEnterPos( approachpoint, approachYaw, approachtype, resultobj.approachNumber ) )
		{
			/#resultobj.data[resultobj.data.size] = "approach blocked: dir " + resultobj.approachNumber;#/
			continue;
		}

		break;
	}

	if ( i > numAttempts )
	{
		/#resultobj.failure = numAttempts + " direction attempts failed";#/
		resultobj.approachNumber = -1;
		return resultobj;
	}
	
	// if AI is closer to node than coverEnterPos is, don't do arrival
	distToApproachPoint = DistanceSquared( approachpoint, self.origin );
	distToAnimStart = DistanceSquared( approachpoint, self.coverEnterPos );

	/#recordLine( approachpoint, self.coverEnterPos, level.color_debug[ "green" ], "Cover", self );#/

	if ( distToApproachPoint < distToAnimStart * 2 * 2 )
	{
		if ( distToApproachPoint < distToAnimStart )
		{
			// ShortCircuiting prototype - Try shortcircuiting the animation as we dont have enough distance
			// to play the full animation. selectedNotetrackIndex undefined means we cant play the shortcircuited animation.
			if( GetDvarInt( #"scr_shortCircuit") )
			{
				/#
				debug_arrival( "Trying to play part of arrival animation" );
				#/

				coverEnterEnt = tryShortCircuitingArrivalAnimation( approachpoint, approachtype, resultobj.approachNumber,  self.coverEnterPos, distToApproachPoint, distToAnimStart, approachYaw );
				selectedNotetrackIndex = coverEnterEnt.selectedNotetrackIndex;
			}

			if( !IsDefined(selectedNotetrackIndex) )
			{
				// keep the result.animTime undefined	
				/#resultobj.failure = "too close to destination";#/
				resultobj.approachNumber = -1;
				return resultobj;
		
			}
			else
			{
				// ShortCircuiting prototype - get the animTime from the notetrack,
				resultObj.animTime = getShortCircuitedArrivalAnimTime( approachtype, resultobj.approachNumber, coverEnterEnt, self.origin );
			
				/#
				debug_arrival( "Too close to destination, trying to short circuit arrival animation with time " +  resultObj.animTime );
				#/
	
				// create the new approach point
				resultobj.approachPoint = coverEnterEnt.coverEnterPos;
			}
		}
	
		// If AI is less than twice the distance from the node than the begining of the approach animation,
		// make sure the angle we'll turn when we start the animation is small.
		
		// ShortCircuiting prototype - If AI is going to play the shortcircuted animation then the self.coverEnterPos is going to be changed.
		if( !IsDefined(selectedNotetrackIndex) )
		{
			selfToAnimStart = VectorNormalize( self.coverEnterPos - self.origin );
			AnimStartToNode = VectorNormalize( approachpoint - self.coverEnterPos );
		
			cosAngle = vectorDot( selfToAnimStart, AnimStartToNode );
	
			if ( cosAngle < 0.819  ) // 0.819 == cos(35)
			{
				/#resultobj.failure = "angle to start of animation is too great (angle of " + acos( cosAngle ) + " > 35)";#/
				resultobj.approachNumber = -1;
				return resultobj;
			}

		}
		else	
		{
			// ShortCircuiting prototype -  
			//selfToAnimStart = VectorNormalize( resultobj.approachPoint - self.origin );
			//AnimStartToNode = VectorNormalize( approachpoint - resultobj.approachPoint );
			self.isShortCircuiting = true;
		}
		
	}
	
	return resultobj;
}

doLastMinuteExposedApproachWrapper()
{
	self endon("killanimscript");

	self notify("doing_last_minute_exposed_approach");
	self endon ("doing_last_minute_exposed_approach");
	
	self thread watchGoalChanged();
	
	while(1)
	{
		doLastMinuteExposedApproach();
		
		// try again when our goal pos changes
		while(1)
		{
			self waittill_any("goal_changed", "goal_changed_previous_frame");

			// our goal didn't *really* change if it only changed because we called setRunToPos
			if ( IsDefined( self.coverEnterPos ) && IsDefined( self.pathGoalPos ) && DistanceSquared( self.coverEnterPos, self.pathGoalPos ) < 1 )
			{
				continue;
			}

			break;
		}
	}
}

watchGoalChanged()
{
	self endon("killanimscript");
	self endon ("doing_last_minute_exposed_approach");
	
	while(1)
	{
		self waittill("goal_changed");
		wait .05;
		self notify("goal_changed_previous_frame");
	}
}

doLastMinuteExposedApproach()
{
	self endon("goal_changed");
	
	if ( IsDefined( self getnegotiationstartnode() ) )
	{
		return;
	}

	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("Aborting exposed approach because self.disableArrivals is true");
		#/

		return;
	}
	
	maxSpeed = 200; // units/sec
	
	allowedError = 6;
	
	// wait until we get to the point where we have to decide what approach animation to play
	while(1)
	{
		if ( !IsDefined( self.pathGoalPos ) )
		{
			self waitForPathGoalPos();
		}
		
		dist = distance( self.origin, self.pathGoalPos );
		
		if ( dist <= longestExposedApproachDist() + allowedError )
		{
			break;
		}
		
		// underestimate how long to wait so we don't miss the crucial point
		waittime = (dist - longestExposedApproachDist()) / maxSpeed - .1;
		if ( waittime < .05 )
		{
			waittime = .05;
		}

		///#self thread animscripts\shared::showNoteTrack("wait " + waittime);#/
		wait waittime;
	}
	
	if ( IsDefined( self.grenade ) && IsDefined( self.grenade.activator ) && self.grenade.activator == self )
	{
		return;
	}
	
	// only do an arrival if we have a clear path
	if ( !self maymovetopoint( self.pathGoalPos ) )
	{
		/#
		debug_arrival("Aborting exposed approach: maymove check failed");
		
		if( IsDefined(self.node) )
		{
			errorMsg  = "AI " + self getEntNum() + " can't play arrival to " + self.node.type;
			errorMsg += " node at (" + self.node.origin[0] + ", " + self.node.origin[1] + ", " + self.node.origin[2];
			errorMsg += ") from (" + self.origin[0] + ", " + self.origin[1] + ", " + self.origin[2] + ")";

			println( "ERROR: " + errorMsg );
		}
		#/

		return;
	}

	// ALEXP_MOD 1/5/10: no prone approaches
	if( self.a.pose == "prone" || (IsDefined(self.node) && self.node isNodeDontStand() && self.node isNodeDontCrouch()) )
	{
		/#
		debug_arrival("Aborting exposed approach because node stance is prone");
		#/

		return;
	}
	
	approachType = "exposed";
	
	if ( IsDefined( self.node ) && IsDefined( self.pathGoalPos ) && DistanceSquared( self.pathGoalPos, self.node.origin ) < 1 )
	{
		determineNodeApproachType( self.node );
		if ( IsDefined( self.node.approachtype ) && (self.node.approachtype == "exposed" || self.node.approachtype == "exposed_crouch") )
		{
			approachType = self.node.approachtype;
		}

		self thread alignToNodeAngles(); // we'll cancel this if our arrival succeeds
	}
/*	else
	{
		if(self.goalangle != (0,0,0))
		{
			self thread alignToGoalAngle();
		}
	} */
	
	approachDir = VectorNormalize( self.pathGoalPos - self.origin );
	
	// by default, want to face forward
	desiredFacingYaw = VectorToAngles( approachDir )[1];
	if ( !self.a.isReviver && isValidEnemy( self.enemy ) && sightTracePassed( self.enemy GetShootAtPos(), self.pathGoalPos + (0,0,60), false, undefined ) )
	{
		desiredFacingYaw = VectorToAngles( self.enemy.origin - self.pathGoalPos )[1];
	}
	else if ( IsDefined( self.node ) && ( self.node.type == "Guard" ) && self.node.origin == self.pathGoalPos )
	{
		desiredFacingYaw = self.node.angles[1];
	}
	else if ( self.goalangle != (0,0,0) || self.a.isReviver )
	{
		desiredFacingYaw = self.goalangle[1];
	}
	else
	{
		likelyEnemyDir = self getAnglesToLikelyEnemyPath();
		if ( IsDefined( likelyEnemyDir ) )
		{
			desiredFacingYaw = likelyEnemyDir[1];
		}
	}
	
	angleDataObj = SpawnStruct();
	calculateNodeTransitionAngles( angleDataObj, approachType, true, desiredFacingYaw, approachDir, 9, -1 );
	
	// take best animation
	best = 1;
	for ( i = 2; i < 9; i++ )
	{
		if ( angleDataObj.transitions[i] > angleDataObj.transitions[best] )
		{
			best = i;
		}
	}

	// Switch to CQB transitions if needed
	if( self shouldDoCQBTransition( self.node, approachType ) )
		approachType = approachType + "_cqb";

	self.approachNumber = angleDataObj.transIndex[best];
	self.approachType = approachType;

	// MikeD (8/15/2008): Custom approachtypes
	custom_approach = false;
	if( IsDefined( self.custom_approachType ) && IsDefined( self.custom_approachNumber ) )
	{
		approachNumber = self.custom_approachNumber;
		approachType = self.custom_approachType;

		self.approachNumber = approachNumber;
		self.approachType = approachType;
		custom_approach = true;
	}
	
	/#
	debug_arrival("Doing exposed approach in direction " + self.approachNumber);
	#/
		
	approachAnim = animArray("arrive_"+approachType)[self.approachNumber];
	animDist = length( moveDeltaArray("arrive_"+approachType)[self.approachNumber] );	
	
	requiredDistSq = animDist + allowedError;
	requiredDistSq = requiredDistSq * requiredDistSq;
	
	// we should already be close
	while( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) > requiredDistSq )
	{
		wait .05;
	}
	
	if ( !IsDefined( self.pathGoalPos ) )
	{
		/#
		debug_arrival("Aborting exposed approach because I have no path");
		#/

		return;
	}
	
	if ( IsDefined( self.node ) && DistanceSquared( self.pathGoalPos, self.node.origin ) < 1 )
	{
		if ( self.node.type != "Guard" && self.node.type != "Path" && self.node.type != "Cover Prone" && self.node.type != "Conceal Prone" )
		{
			/#
			debug_arrival("Aborting exposed approach because we're going to a cover node");
			#/

			return;
		}
	}

	// MikeD (1/24/2008): Added banzai feature
	if( self is_banzai() && ( !IsDefined( self.node ) || self.node.type == "Path" ) )
	{
		/#
		debug_arrival("Aborting exposed approach because self.banzai is true and not going to a node");
		#/

		return;
	}
	
	if ( self.a.pose != "stand" || self.a.movement != "run" )
	{
		/#
		debug_arrival( "approach aborted at last minute: not standing and running" );
		#/

		return;
	}
	
	dist = distance( self.origin, self.pathGoalPos );
	if ( !custom_approach && abs( dist - animDist ) > allowedError )
	{
		/#
		debug_arrival("Aborting exposed approach because distance difference exceeded allowed error: " + dist + " more than " + allowedError + " from " + animDist);
		#/

		return;
	}
	
	facingYaw = VectorToAngles( self.pathGoalPos - self.origin )[1];
	
	delta = moveDeltaArray("arrive_"+approachType)[self.approachNumber];
	assert( delta[0] != 0 );
	yawToMakeDeltaMatchUp = atan( delta[1] / delta[0] );
	
	requiredYaw = facingYaw - yawToMakeDeltaMatchUp;
	
	if ( AbsAngleClamp180( requiredYaw - self.angles[1] ) > 30 )
	{
		/#
		debug_arrival("Aborting exposed approach because angle change was too great");
		#/
		
		return;
	}
	
	closerDist = dist - animDist;
	idealStartPos = self.origin + vector_scale( VectorNormalize( self.pathGoalPos - self.origin ), closerDist );
	
	self notify( "dont_align_to_node_angles" );
	
	self startcoverarrival( idealStartPos, requiredYaw );
}

waitForPathGoalPos()
{
	while(1)
	{
		if ( IsDefined( self.pathgoalpos ) )
		{
			return;
		}
		
		wait 1;
	}
}

alignToGoalAngle()
{
	self endon("killanimscript");
	self endon("goal_changed");
	self endon( "dont_align_to_node_angles" );
	self endon("doing_last_minute_exposed_approach");
	
	waittillframeend;

	// this is a last ditch fake approach.
	// we gradually turn to face the direction we want to face at the node
	// as we get there.
	
	maxdist = 80;
	
	while(1)
	{
//		if ( !IsDefined( self.node ) || self.node.type == "Path" || self.node.type == "Guard" || !IsDefined( self.pathGoalPos ) || DistanceSquared( self.node.origin, self.pathGoalPos ) > 1 )
//			return;
		
		// don't do this if we're too far away.
		if ( DistanceSquared( self.origin, self.goalPos ) > maxdist * maxdist )
		{
			wait .05;
			continue;
		}
		
		// don't do this if we're going to do an approach.
		if ( IsDefined( self.coverEnterPos ) && IsDefined( self.pathGoalPos ) && DistanceSquared( self.coverEnterPos, self.pathGoalPos ) < 1 )
		{
			wait .1;
			continue;
		}
		
		break;
	}
	
	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		return;
	}

	startdist = distance( self.origin, self.goalPos );
	
	if ( startdist <= 0 )
	{
		return;
	}
	
	//determineNodeApproachType( self.node );
	
	startYaw = self.angles[1];
	targetYaw = self.goalangle[1];
/*	if ( IsDefined( self.node.approachtype ) )
		targetYaw += getNodeStanceYawOffset( self.node.approachtype ); */
	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);
	
	self thread resetOrientModeOnGoalChange();

	while(1)
	{
/*		if ( !IsDefined( self.node ) )
		{
			self OrientMode("face default");
			return;
		} */
		
/*		if ( self ShouldDoMiniArrival() )
		{
			self StartMiniArrival();
			return;
		}*/
		
		dist = distance( self.origin, self.goalPos );

		if ( dist > startdist * 1.1 ) // failsafe
		{
			self OrientMode("face default");
			return;
		}
		else
		{
			if(dist < 5)
			{
				self OrientMode("face default");
				return;
			}	
		}
		
		distfrac = 1.0 - (dist / startdist);
		
		currentYaw = startYaw + distfrac * (targetYaw - startYaw);
		
		self OrientMode( "face angle", currentYaw );
		
		wait .05;
	}
}

alignToNodeAngles()
{
	self endon("killanimscript");
	self endon("goal_changed");
	self endon( "dont_align_to_node_angles" );
	self endon("doing_last_minute_exposed_approach");
	
	waittillframeend;

	// this is a last ditch fake approach.
	// we gradually turn to face the direction we want to face at the node
	// as we get there.
	
	maxdist = 80;
	
	while(1)
	{
		if ( !IsDefined( self.node ) || self.node.type == "Path" || self.node.type == "Guard" || !IsDefined( self.pathGoalPos ) || DistanceSquared( self.node.origin, self.pathGoalPos ) > 1 )
		{
			return;
		}
		
		// don't do this if we're too far away.
		if ( DistanceSquared( self.origin, self.node.origin ) > maxdist * maxdist )
		{
			wait .05;
			continue;
		}
		
		// don't do this if we're going to do an approach.
		if ( IsDefined( self.coverEnterPos ) && IsDefined( self.pathGoalPos ) && DistanceSquared( self.coverEnterPos, self.pathGoalPos ) < 1 )
		{
			wait .1;
			continue;
		}
		
		break;
	}
	
	if ( IsDefined( self.disableArrivals ) && self.disableArrivals )
	{
		return;
	}

	startdist = distance( self.origin, self.node.origin );
	
	if ( startdist <= 0 )
	{
		return;
	}
	
	determineNodeApproachType( self.node );
	
	startYaw = self.angles[1];
	targetYaw = self.node.angles[1];
	if ( IsDefined( self.node.approachtype ) )
	{
		targetYaw += getNodeStanceYawOffset( self.node.approachtype );
	}

	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);
	
	self thread resetOrientModeOnGoalChange();

	while(1)
	{
		if ( !IsDefined( self.node ) )
		{
			self OrientMode("face default");
			return;
		}
		
		if ( self ShouldDoMiniArrival() )
		{
			self StartMiniArrival();
			return;
		}
		
		dist = distance( self.origin, self.node.origin );
		
		if ( dist > startdist * 1.1 ) // failsafe
		{
			self OrientMode("face default");
			return;
		}
		
		distfrac = 1.0 - (dist / startdist);
		
		currentYaw = startYaw + distfrac * (targetYaw - startYaw);
		
		// ShortCircuiting prototype 
		if( IsDefined( self.isShortCircuiting ) && self.isShortCircuiting == false )
			self OrientMode( "face angle", currentYaw );
		wait .05;
	}
}

resetOrientModeOnGoalChange()
{
	self endon("killanimscript");
	self waittill_any("goal_changed", "dont_align_to_node_angles");
	
	self OrientMode("face default");
}

startMoveTransition()
{
	self endon("killanimscript");
	
	self.exitingCover = false;
	
	// if we don't know where we're going, we can't check if it's a good idea to do the exit animation
	// (and it's probably not)
	if ( !IsDefined( self.pathGoalPos ) )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.pathGoalPos is undefined");
		#/

		return;
	}
	
	if ( self.a.pose == "prone" )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.a.pose is \"prone\"");
		#/

		return;
	}
	
	if ( IsDefined( self.disableExits ) && self.disableExits )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.disableExits is true");
		#/

		return;
	}
	
	if ( !self IsStanceAllowed( "stand" ) )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): not allowed to stand");
		#/
		return;
	}
	
	/*if ( self isCQBWalking() )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.cqbwalking is true");
		#/
		return;
	}*/

	// assume an exit from exposed.
	exitpos = self.origin;
	exityaw = self.angles[1];
	exittype = "exposed";
	
	exitNode = undefined;
	if ( IsDefined( self.node ) && ( DistanceSquared( self.origin, self.node.origin ) < 225 ) )
	{
		exitNode = self.node;
	}
	else if ( IsDefined( self.prevNode ) )
	{
		exitNode = self.prevNode;
	}
	
	// if we're at a node, try to do an exit from the node.
	if ( IsDefined( exitNode ) )
	{
		determineNodeApproachType( exitNode );

		if ( IsDefined( exitNode.approachtype ) && exitNode.approachtype != "exposed" && exitNode.approachtype != "stand_saw" && exitNode.approachType != "crouch_saw" )
		{
			// if far from cover node, or angle is wrong, don't do exit behavior for the node.
			
			distancesq = DistanceSquared( exitNode.origin, self.origin );
			anglediff = AbsAngleClamp180( self.angles[1] - exitNode.angles[1] - getNodeStanceYawOffset( exitNode.approachtype ) );
			if ( distancesq < 225 && anglediff < 5 ) // (225 = 15 * 15)
			{
				// do exit behavior for the node.
				exitpos = exitNode.origin;
				exityaw = exitNode.angles[1];
				exittype = exitNode.approachtype;
			}
		}
	}
	
	/#
	debug_arrival("^3exiting cover (ent " + self getentnum() + ", type \"" + exittype + "\"):");
	debug_arrival("   lookaheaddir = (" + self.lookaheaddir[0] + ", " + self.lookaheaddir[1] + ", " + self.lookaheaddir[2] + ")");

	angle = AngleClamp180( VectorToAngles( self.lookaheaddir )[1] - exityaw );
	if ( angle < 0 )
	{
		debug_arrival("   (Angle of " + (0-angle) + " right from node forward.)");
	}
	else
	{
		debug_arrival("   (Angle of " + angle + " left from node forward.)");
	}
	#/
	
	if ( !IsDefined( exittype ) )
	{
		/#
		debug_arrival( "aborting exit: not supported for node type " + exitNode.type );
		#/

		return;
	}
	
	// since we transition directly into a standing run anyway,
	// we might as well just use the standing exits when crouching too
	if ( exittype == "exposed" )
	{
		if ( self.a.pose != "stand" && self.a.pose != "crouch" )
		{
			/#
			debug_arrival( "exposed exit aborted because anim_pose is not \"stand\" or \"crouch\"" );
			#/

			return;
		}

		if ( self.a.movement != "stop" )
		{
			/#
			debug_arrival( "exposed exit aborted because anim_movement is not \"stop\"" );
			#/

			return;
		}

		if ( self.a.pose == "crouch" )
		{
			exittype = "exposed_crouch";
		}
	}
	
	/*if ( exittype == "crouch" || exittype == "stand" )
	{
		if ( AbsAngleClamp180( VectorToAngles( self.lookaheaddir )[1] - exityaw ) < 60 )
		{
			/#
			debug_arrival( "aborting exit: lookaheaddir is too far forward for node type " + exittype );
			#/
			return;
		}
	}*/
	
	// don't do an exit away from an enemy that we would otherwise face as we moved away from them
	if ( isValidEnemy( self.enemy ) && vectorDot( self.lookaheaddir, self.enemy.origin - self.origin ) < 0 )
	{
		if ( self canSeeEnemyFromExposed() && DistanceSquared( self.origin, self.enemy.origin ) < 600 * 600 )
		{
			/#
			debug_arrival( "aborting exit: don't want to turn back to nearby enemy" );
			#/

			return;
		}
	}
	
	// since we're leaving, take the opposite direction of lookahead
	leaveDir = ( -1 * self.lookaheaddir[0], -1 * self.lookaheaddir[1], 0 );
	
	//println("lookaheaddir: " + self.lookaheaddir[0] + " " + self.lookaheaddir[1] );
	
	
	result = getMaxDirectionsAndExcludeDirFromApproachType( exittype );
	maxDirections = result.maxDirections;
	excludeDir	  = result.excludeDir;
	exityaw		  = exityaw + getNodeStanceYawOffset( exittype );
	
	// Switch to CQB transition if needed
	if( shouldDoCQBTransition( exitNode, exittype ) )
		exittype = exittype + "_cqb";
	
	angleDataObj = SpawnStruct();
	calculateNodeTransitionAngles( angleDataObj, exittype, false, exityaw, leaveDir, maxDirections, excludeDir );

	/#
	if ( GetDvar( #"scr_testCoverExits") == "on" )
	{
		debug_arrival( "checking exits for: " + exittype );

		for ( i = 1; i <= maxDirections; i++ )
		{
			if( angleDataObj.transIndex[i] == excludeDir )
			{
				continue;
			}
		
			approachNumber = angleDataObj.transIndex[i];

			if( !IsDefined( moveDeltaArray("exit_"+exittype)[approachNumber] ) )
			{
				continue;
			}

			if ( self checkCoverExitPos( exitpos, exityaw, exittype, approachNumber, false ) )
			{
				debug_arrival( "exit success: dir " + approachNumber );
			}
			else
			{
				debug_arrival( "exit blocked: dir " + approachNumber );
			}
		}

		debug_arrival( "done checking" );
	}
	#/

	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	approachnumber = -1;
	numAttempts = 3;
	
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
	
		approachNumber = angleDataObj.transIndex[i];

		if ( self checkCoverExitPos( exitpos, exityaw, exittype, approachNumber, true ) )
		{
			break;
		}

		/#
		debug_arrival( "exit blocked: dir " + approachNumber );
		#/
	}

	// ShortCircuiting prototype
	animTime = undefined;
	selectedNotetrackIndex = undefined;
	
	if ( i > numAttempts )
	{
		/#
		debug_arrival( "aborting exit: too many exit directions blocked" );
		#/

		// ShortCircuiting prototype
		if( GetDvarInt( #"scr_shortCircuit") )
		{
			/#
			debug_arrival( "Trying to play part of Exit animation" );
			#/
	
			selectedNotetrackIndex = tryShortCircuitingExitAnimation( exittype, approachNumber );
		}
	
		// If selectedNotetrackIndex is undefined, that means shortcircuiting is not possible.
		if( !IsDefined( selectedNotetrackIndex ) )
		{
			return;
		}
		else
		{
			/#
			debug_arrival( "exit success: dir " + approachNumber + " short circuited"  );
			#/

			// ShortCircuiting prototype - Get the shortciruited animation time
			animTime = getShortCircuitedExitAnimTime( exittype, approachNumber, selectedNotetrackIndex, exitPos );
	
		}
	}

	// If AI is closer to destination than arrivalPos is, don't do exit
	allowedDistSq = DistanceSquared( self.origin, self.coverExitPos );// * 1.25*1.25;
	availableDistSq = DistanceSquared( self.origin, self.pathgoalpos ); 

	if( availableDistSq < allowedDistSq )
	{
		/#
		debug_arrival( "exit failed, too close to destination");
		#/

		// ShortCircuiting prototype
		if( GetDvarInt( #"scr_shortCircuit") )
		{
			/#
			debug_arrival( "Trying to play part of Exit animation" );
			#/

			selectedNotetrackIndex = tryShortCircuitingExitAnimation( exittype, approachNumber );
		}
		
		// ShortCircuiting prototype - If selectedNotetrackIndex is undefined, that means shortcircuiting is not possible.
		if( !IsDefined( selectedNotetrackIndex ) )
		{
			return;
		}
		else
		{
			/#
			debug_arrival( "exit success: dir " + approachNumber + " short circuited"  );
			#/
			
			// ShortCircuiting prototype - Get the shortciruited animation time
			animTime = getShortCircuitedExitAnimTime( exittype, approachNumber, selectedNotetrackIndex, exitPos );
		}
	}

	/#
	debug_arrival( "exit success: dir " + approachNumber );
	#/

	self doCoverExitAnimation( exittype, approachNumber, animTime );
}

str( val )
{
	if (!IsDefined(val))
	{
		return "{undefined}";
	}

	return val;
}

doCoverExitAnimation( exittype, approachNumber, animTime )
{
	assert( IsDefined( approachNumber ) );
	assert( approachnumber > 0 );
	
	assert( IsDefined( exittype ) );

	// MikeD (8/15/2008): Custom Exposed Exit Transition
	if( IsDefined( self.custom_exitType ) && IsDefined( self.custom_exitNumber ) )
	{
		approachnumber = self.custom_exitNumber;
		exittype = self.custom_exitType;
	}

	leaveAnim = animArray("exit_"+exittype)[approachnumber];
	
	assert( IsDefined( leaveAnim ) );

	lookaheadAngles = VectorToAngles( self.lookaheaddir );
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		endpos = self.origin + vector_scale( self.lookaheaddir, 100 );
		thread debug_arrival_line( self.origin, endpos, (1,0,0), 1.5 );
	}
	#/
	
	if ( self.a.pose == "prone" )
	{
		return;
	}

	transTime = 0.2;
	
	self AnimMode( "zonly_physics", false );
	self OrientMode( "face angle", self.angles[1] );
	
	rate = 1;	
	
	if( IsDefined( self.custom_exitanimrate ) )
	{
		rate = self.custom_exitanimrate;
	}	
		
	self setFlaggedAnimKnobAllRestart( "coverexit", leaveAnim, %body, 1, transTime, rate );

	animStartTime = GetTime();

	// ShortCircuiting prototype
	shouldDoShortCircuitedExit = IsDefined(animTime);
	if( shouldDoShortCircuitedExit )
	{
		/#
		debug_arrival( "Short circuiting the animation with time of " + animTime );
		#/
	
		blendOutDuration = animTime;
		runBlendInDuration = 0.2; // We want to start playing the run animation right away
	}
	else
	{
		blendOutDuration = 0.15;
		runBlendInDuration = 0.15;
	}

	// Sumeet - We added cover exit blend to run animation on COD5. This was done to hide the fozen frames after exit animation
	// is finished. The frozen frame was an issue is cod4 as well but only to the extent of a frame, as animation
	// update happens next server frame. In COD5, due to network layer it takes almost multiple frames for client to add this animations
	// into the tree and hence the frozen frame lasts longer. 		
	// Turn on scr_cod4_test to bypass the exit blend that was added on COD5 and use COD4 script.

/*	ALEXP 6/3/10: don't need this anymore since the blendout is taken care of just above
	if( !GetDvarInt( #"scr_cod4_test" ) )
	{
		self thread coverexit_blend_out( leaveAnim, rate, blendOutDuration, runBlendInDuration, shouldDoShortCircuitedExit );
	}
*/	
	
	hasExitAlign = animHasNotetrack( leaveAnim, "exit_align" );
	if ( !hasExitAlign )
	{
		println("^1Animation exit_" + exittype + "[" + approachnumber + "] has no \"exit_align\" notetrack");
	}

	self thread DoNoteTracksForExit( "coverexit", hasExitAlign );
	
	self waittillmatch( "coverexit", "exit_align" );
	
	self.exitingCover = true;
	
	self.a.pose = "stand";
	self.a.movement = "run";

	hasCodeMoveNoteTrack = animHasNotetrack( leaveAnim, "code_move" );

	while ( 1 )
	{
		curfrac = self getAnimTime( leaveAnim );
		remainingMoveDelta = getMoveDelta( leaveAnim, curfrac, 1 );
		remainingAngleDelta = getAngleDelta( leaveAnim, curfrac, 1 );
		faceYaw = lookaheadAngles[1] - remainingAngleDelta;
		
		// make sure we can complete the animation in this direction
		forward = AnglesToForward( (0,faceYaw,0) );
		right = AnglesToRight( (0,faceYaw,0) );
		endPoint = self.origin + vector_scale( forward, remainingMoveDelta[0] ) - vector_scale( right, remainingMoveDelta[1] );
		
		if ( self mayMoveToPoint( endPoint ) )
		{
			self OrientMode( "face angle", faceYaw );
			break;
		}
		
		if ( hasCodeMoveNoteTrack )
			break;
		
		// wait a bit or until the animation is over, then try again
		if(!GetDvarInt( #"scr_cod4_test"))
			timeLeft = getAnimLength( leaveAnim ) * (1 - curfrac) - blendOutDuration - .05;
		else
			timeLeft = getAnimLength( leaveAnim ) * (1 - curfrac) - .05;
		
		if ( timeLeft < .05 )
		{
			break;
		}
		
		if ( timeLeft > .4 )
		{
			timeleft = .4;
		}
		
		wait timeleft;
	}

	// ShortCircuiting prototype
	if ( hasCodeMoveNoteTrack & !shouldDoShortCircuitedExit )
	{
		notetrack_times = GetNotetrackTimes( leaveAnim, "code_move" );
		absolute_code_move_time = getAnimLength(leaveAnim) * notetrack_times[0];

		curfrac = self getAnimTime( leaveAnim );
		current_anim_time = getAnimLength(leaveAnim) * curfrac;

		if( absolute_code_move_time > current_anim_time + 0.05 )
		{
			// the code_move notetrack won't fire if the anim is being blended out
			if( absolute_code_move_time + blendOutDuration > getAnimLength(leaveAnim) )
			{
				wait( getAnimLength(leaveAnim) - absolute_code_move_time );
			}
			else
			{
				self waittillmatch( "coverexit", "code_move" );
			}
		}
	
		self OrientMode( "face motion" );
		self AnimMode( "none", false );
	}

	// Turn on scr_cod4_test to bypass the exit blend that was added on COD5 and use COD4 script.
	if(!GetDvarInt( #"scr_cod4_test"))
	{
		// Wait until [blendOutDuration] seconds before the end of the animation to start the next one.
		// This way, we start blending in the new anim before this one ends.
		totalAnimTime	= getAnimLength( leaveAnim ) / rate;
		timePassed		= (GetTime() - animStartTime) / 1000;
		timeLeft		= totalAnimTime - timePassed - blendOutDuration;
		if ( timeLeft > 0 )
		{
			wait timeLeft;
		}

		self ClearAnim( %root, blendOutDuration );

		self OrientMode( "face motion" );
		self thread faceEnemyOrMotionAfterABit();
		self AnimMode( "normal", false );
	}
	else
	{
		self waittillmatch("coverexit", "end");
	
		self clearanim( %root, 0 );

		// the end of the exit animations (should) line up *exactly* with the start of the run animations.
		// Play a run animation immediately so that if we blend to something other than a run, we don't pop.
		self setAnimRestart( animArray("combat_run_f", "move"), 1, 0 );
	
		self OrientMode( "face motion" );
		self thread faceEnemyOrMotionAfterABit();
		self animMode( "normal", false );
	}
}

/* ALEXP 6/3/10: don't need this anymore since the blendout is taken care of just above
coverexit_blend_out( leaveAnim, playSpeed, blendOutTime, runBlendInDuration, shortCircuitedExit )
{
	self endon( "killanimscript" );

	// ShortCircuiting prototype - If AI is shortcircuiting then we just want to wait until the animation is 
	// over before starting to blend into run.
	if(!shortCircuitedExit)	
	{
		playLength = GetAnimLength( leaveAnim ) / playSpeed;
		timeTillBlendOut = playLength - blendOutTime;
		wait( timeTillBlendOut );
	
	}
	else
	{
		wait( blendOutTime );
	}
	
	
	// CCheng (8/21/2008): In CoD4, ClearAnim() was called after the cover exit enimation
	// ended. That meant that the next animation would blend with the frozen last frame of
	// the cover exit animation, which made it look like the guy was skating. What should
	// really be happening is the old animation should start to blend out in its last few
	// frames, which must overlap and match the first few frames of the next animation.
	self ClearAnim( %root, runBlendInDuration );

	// ALEXP (5/7/2010): the reload may have started at this point, so kill that thread since we just cleared the root
	self notify("movemode");

	// ALEXP (3/26/2010): clearing root can clear shooting anims as well, so tell the shooting thread to restart
	self notify("stopShooting");
	
	// Start a run animation so the we have something to blend into just in case nothing
	// else starts playing next.
	self SetAnimRestart( animscripts\run::GetRunAnim(), 1, runBlendInDuration );

	// SUMEET - Fix for cqb aiming
	// CQB AIM was broken because the run animations clears animation after CQB script
	// sets the aim animation.
	if ( self isCQBWalking() )
	{
		self SetAnimLimited( %walk_aim_2 );
		self SetAnimLimited( %walk_aim_4 );
		self SetAnimLimited( %walk_aim_6 );
		self SetAnimLimited( %walk_aim_8 );
	}

	// WARNING: This last part will execute after the parent function has already returned.
	// This is intentional, since we want the next animation to start playing before this
	// one has ended.
	
	// Sumeet - we dont need this for shortcircuited exits.
	if(!shortCircuitedExit)	
	{
		wait( blendOutTime );
	}
	
	self OrientMode( "face motion" );
	self thread faceEnemyOrMotionAfterABit();
	self AnimMode( "normal", false );
}
*/
	

faceEnemyOrMotionAfterABit()
{
	self endon("killanimscript");
	
	wait 1.0;
	
	// don't want to spin around if we're almost where we're going anyway
	while ( IsDefined( self.pathGoalPos ) && DistanceSquared( self.origin, self.pathGoalPos ) < 200*200 )
	{
		wait .25;
	}
	
	self OrientMode( "face default" );
}

DoNoteTracksForExit( animname, hasExitAlign )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );

	if ( !hasExitAlign )
	{
		self notify( animname, "exit_align" ); // failsafe
	}
}

/*RestartAllMoveAnims( timeUntilTheyWrap )
{
	// rely on loopsynch to reset the time of all movement animations
	fractionalTimeUntilTheyWrap = timeUntilTheyWrap / getAnimLength( %run_lowready_F );
	// this doesn't work unless the anim has a goal weight > 0
	self SetAnim( %run_lowready_F, .01, 1000 );
	self SetAnim( %precombatrun1, .01, 1000 );
	self setAnimTime( %run_lowready_F, 1 - fractionalTimeUntilTheyWrap );
	self setAnimTime( %precombatrun1, 1 - fractionalTimeUntilTheyWrap );
}*/


drawVec( start, end, duration, color )
{
	for( i = 0; i < duration * 100; i++ )
	{
		line( start + (0,0,30), end + (0,0,30), color);
		wait 0.05;
	}
}

drawApproachVec(approach_dir)
{
	self endon("killanimscript");

	for(;;)
	{
		if(!IsDefined(self.node))
		{
			break;
		}

		line(self.node.origin + (0,0,20), (self.node.origin - vector_scale(approach_dir,64)) + (0,0,20));	
		recordLine(self.node.origin + (0,0,20), (self.node.origin - vector_scale(approach_dir,64)) + (0,0,20));	
		wait(0.05);
	}	
}

calculateNodeTransitionAngles( angleDataObj, approachtype, isarrival, arrivalYaw, approach_dir, maxDirections, excludeDir )
{
	angleDataObj.transitions = [];
	angleDataObj.transIndex = [];
	
	anglearray = undefined;
	sign = 1;
	offset = 0;
	if ( isarrival )
	{
		anglearray = angleDeltaArray("arrive_"+approachtype);

		sign = -1;
		offset = 0;
	}
	else
	{
		anglearray = angleDeltaArray("exit_"+approachtype);

		sign = 1;
		offset = 180;
	}
	
	for ( i = 1; i <= maxDirections; i++ )
	{
		angleDataObj.transIndex[i] = i;
		
		if ( i == 5 || i == excludeDir || !IsDefined( anglearray[i] ) )
		{
			angleDataObj.transitions[i] = -1.0003;	// cos180 - epsilon
			continue;
		}
		
		angles = ( 0, arrivalYaw + sign * anglearray[i] + offset, 0 );
		
		dir = VectorNormalize( AnglesToForward( angles ) );
		angleDataObj.transitions[i] = vectordot( approach_dir, dir );
	}
}

// TODO: probably better done in code
// (actually, for an array of 8 elements, insertion sort should be fine)
sortNodeTransitionAngles( angleDataObj, maxDirections )
{
	for ( i = 2; i <= maxDirections; i++ )
	{
		currentValue = angleDataObj.transitions[ angleDataObj.transIndex[i] ];
		currentIndex = angleDataObj.transIndex[i];
		
		for ( j = i-1; j >= 1; j-- )
		{
			if ( currentValue < angleDataObj.transitions[ angleDataObj.transIndex[j] ] )
			{
				break;
			}
			
			angleDataObj.transIndex[j + 1]  = angleDataObj.transIndex[j];
		}
		
		angleDataObj.transIndex[j + 1] = currentIndex;
	}
}

checkCoverExitPos( exitpoint, exityaw, exittype, approachNumber, checkWithPath )
{
	angle = (0, exityaw, 0);
	
	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );

	moveDeltaArray = moveDeltaArray("exit_"+exittype);

	forward = vector_scale( forwardDir, moveDeltaArray[approachNumber][0] );
	right   = vector_scale( rightDir, moveDeltaArray[approachNumber][1] );
	
	exitPos = exitpoint + forward - right;
	self.coverExitPos = exitPos;
	
	isExposedApproach = ( exittype == "exposed" || exittype == "exposed_crouch" );
	isExposedApproach = ( isExposedApproach || ( exittype == "exposed_cqb" || exittype == "exposed_crouch_cqb" ) );
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		thread debug_arrival_line( self.origin, exitpos, (1,.5,.5), 1.5 );
	}
	#/
	
	if ( !isExposedApproach && checkWithPath && !( self checkCoverExitPosWithPath( exitPos ) ) )
	{
		/#
		debug_arrival( "cover exit " + approachNumber + " path check failed" );
		#/

		return false;
	}
	
	if ( !( self MayMoveFromPointToPoint( self.origin, exitPos ) ) )
	{
		return false;
	}

	if ( approachNumber <= 6 || isExposedApproach )
	{
		return true;
	}

	assert( exittype == "left" || exittype == "left_crouch" || exittype == "right" || exittype == "right_crouch" ||
			exittype == "left_cqb" || exittype == "left_crouch_cqb" || exittype == "right_cqb" || exittype == "right_crouch_cqb" ||
			exittype == "pillar" || exittype == "pillar_crouch" );

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the first part, from node to corner, now doing from corner to end of exit anim)
	postMoveDeltaArray = postMoveDeltaArray("exit_"+exittype);
	forward = vector_scale( forwardDir, postMoveDeltaArray[approachNumber][0] );
	right   = vector_scale( rightDir, postMoveDeltaArray[approachNumber][1] );
	
	finalExitPos = exitPos + forward - right;
	self.coverExitPos = finalExitPos;

	/#
	if ( debug_arrivals_on_actor() )
	{
		thread debug_arrival_line( exitpos, finalExitPos, (1,.5,.5), 1.5 );
	}
	#/
	return ( self MayMoveFromPointToPoint( exitPos, finalExitPos ) );
}

checkCoverEnterPos( arrivalpoint, arrivalYaw, approachtype, approachNumber )
{
	angle = (0, arrivalYaw - angleDeltaArray("arrive_"+approachtype)[approachNumber], 0);
	
	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );

	moveDeltaArray = moveDeltaArray("arrive_"+approachtype);
	forward = vector_scale( forwardDir, moveDeltaArray[approachNumber][0] );
	right   = vector_scale( rightDir, moveDeltaArray[approachNumber][1] );
	
	enterPos = arrivalpoint - forward + right;
	self.coverEnterPos = enterPos;

	/#
	if ( debug_arrivals_on_actor() )
	{
		thread debug_arrival_line( enterPos, arrivalpoint, (1,.5,.5), 1.5 );
	}
	#/
	
	if ( !( self MayMoveFromPointToPoint( enterPos, arrivalpoint ) ) )
	{
		return false;
	}
	
	if ( approachNumber <= 6 || approachtype == "exposed" || approachtype == "exposed_crouch" )
	{
		return true;
	}
	
	assert( approachtype == "left" || approachtype == "left_crouch" || approachtype == "right" || approachtype == "right_crouch" ||
			approachtype == "left_cqb" || approachtype == "left_crouch_cqb" || approachtype == "right_cqb" || approachtype == "right_crouch_cqb" ||
			approachtype == "pillar" || approachtype == "pillar_crouch" );
	
	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the second part, from corner to node, now doing from start of enter anim to corner)
	
	preMoveDeltaArray = preMoveDeltaArray("arrive_"+approachtype);
	forward = vector_scale( forwardDir, preMoveDeltaArray[approachNumber][0] );
	right   = vector_scale( rightDir, preMoveDeltaArray[approachNumber][1] );
	
	originalEnterPos = enterPos - forward + right;
	self.coverEnterPos = originalEnterPos;
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		thread debug_arrival_line( originalEnterPos, enterPos, (1,.5,.5), 1.5 );
	}
	#/

	return ( self MayMoveFromPointToPoint( originalEnterPos, enterPos ) );
}

shouldDoCQBTransition( node, type, isExit, forceCQB )
{
	// no CQB transition if this AI is in heat mode
	if( ( !IsDefined( forceCQB ) || !forceCQB ) && IsDefined( self.heat ) && self.heat )
		return false;

	if( !call_overloaded_func( "animscripts\cqb", "shouldCQB" ) )
	{
		if( !IsDefined(forceCQB) || !forceCQB )
		{
			return false;
		}
	}

	return canDoCQBTransition( node, type, isExit );
}

canDoCQBTransition( node, type, isExit )
{
	// CQB transitions are supported for exposed
	if( IsSubStr( type, "_cqb" )|| type == "exposed" || type == "exposed_crouch" )
		return true;

	if( IsDefined( isExit ) && isExit )
	{
		Assert( IsDefined(type) );

		if( type == "left" || type == "right"  )
			return true;
	}

	// CQB transitions are supported only for cover left and right for now	
	if( IsDefined( node ) && ( node.type == "Cover Left" || node.type == "Cover Right"  ) )
		return true;

	return false;
}

ShouldDoMiniArrival()
{
	node = self.node;
	assert( IsDefined( node ) );
	
	if ( GetDvar( #"scr_miniarrivals") != "1" && GetDvar( #"scr_miniarrivals") != "on" )
	{
		return false;
	}

	if ( DistanceSquared( self.origin, node.origin ) > 40 * 40 )
	{
		return false;
	}

	determineNodeApproachType( node );

	// only cover stand for now
	if ( !IsDefined( node.approachtype ) || node.approachtype != "stand" )
	{
		return false;
	}

	if ( !self mayMoveToPoint( node.origin ) )
	{
		return false;
	}
	
	return true;
}

StartMiniArrival()
{
	self.doMiniArrival = true;
	assert( IsDefined( self.node ) );
	self.miniArrivalNode = self.node;
	self startcoverarrival( self.origin, self.angles[1] );
}

DoMiniArrival( node )
{
	arrivalanim = decideMiniArrivalAnim( node, self.origin );
	
	animtime = getAnimLength( arrivalanim );

	transTime = 0.2;
	if ( self.a.movement != "stop" )
	{
		transTime = animtime * 0.65;
	}
	
	self SetAnimKnobAllRestart( arrivalAnim, %body, 1, transTime );
	
	totalAnimDist = length( getMoveDelta( arrivalAnim, 0, 1 ) );
	if ( totalAnimDist <= 0 )
	{
		totalAnimDist = 0.5;
	}
	
	numFrames = floor( animtime * 20 );
	
	startPos = self.origin;
	targetPos = node.origin;
	startYaw = self.angles[1];
	targetYaw = node.angles[1];
	
	if ( IsDefined( node.approachtype ) )
	{
		targetYaw += getNodeStanceYawOffset( node.approachtype );
	}

	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);
	
	for ( i = 0; i < numFrames; i++ )
	{
		timefrac = (i + 1) / numFrames;
		frac = length( getMoveDelta( arrivalAnim, 0, timefrac ) ) / totalAnimDist;
		
		currentYaw = startYaw + frac * (targetYaw - startYaw);
		currentPos = startPos + frac * (targetPos - startPos);
		
		self OrientMode( "face angle", currentYaw );
		self Teleport( currentPos );
		
		wait .05;
	}
	
	return true;
}

decideMiniArrivalAnim( node, pos )
{
	dirToNode = pos - node.origin;
	angle = AngleClamp180( VectorToAngles( dirToNode )[1] - node.angles[1] );
	
	dir = -1;
	if ( angle < -180 + 22.5 )
	{
		dir = 2;
	}
	else if ( angle < -180 + 67.5 )
	{
		dir = 3;
	}
	else if ( angle < 0 )
	{
		dir = 6;
	}
	else if ( angle < 180 - 67.5 )
	{
		dir = 4;
	}
	else if ( angle < 180 - 22.5 )
	{
		dir = 1;
	}
	else
	{
		dir = 2;
	}
	
	// for now, assume cover stand
	anims = [];
	anims[1] = animArray("arrive_stand_mini_1");
	anims[2] = animArray("arrive_stand_mini_2");
	anims[3] = animArray("arrive_stand_mini_3");
	anims[4] = animArray("arrive_stand_mini_4");
	anims[6] = animArray("arrive_stand_mini_6");
	
	assertex( IsDefined( anims[ dir ] ), dir );
	
	return anims[ dir ];
}


debug_arrivals_on_actor()
{
	/#
	dvar = GetDvarInt( #"ai_debugCoverArrivals" );
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


debug_arrival( msg )
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

	println( msg );

	/#recordEntText( msg, self, level.color_debug["white"], "Cover" );#/
}


debug_arrival_cross(atPoint, radius, color, durationFrames)
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debug_arrival_line(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debug_arrival_line(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debug_arrival_line(atPoint_forward,	atPoint_back,	color, durationFrames);
}

debug_arrival_line( start, end, color, duration )
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

	if( IsDefined(self) )
	{
		recordLine( start, end, color, "Cover", self );
	}

/#
	debugLine( start, end, color, duration );
#/

}

debug_arrival_record_text( msg, position, color )
{
	if ( !debug_arrivals_on_actor() )
	{
		return;
	}

/#
	Record3DText( msg, position, color, "Script" );				
#/

}

/#
fakeAiLogic()
{
	self.animType		= "default";
	self.a.script		= "move";
	self.a.pose			= "stand";
	self.a.prevPose		= "stand";
	self.weapon			= "ak47_sp";

	self.ignoreMe		= true;
	self.ignoreAll		= true;

	self AnimMode("nogravity");
	self ForceTeleport( get_players()[0].origin + (0,0,-1000), self.origin );

	while( IsDefined(self) && IsAlive(self) )
	{
		wait(0.05);
	}
}

coverArrivalDebugTool()
{
	// same as nodeColorTable in pathnode.cpp
	nodeColors =  [];
	nodeColors["Cover Stand"]			=  (0, 0.54, 0.66);
	nodeColors["Cover Crouch"]			=  (0, 0.93, 0.72);
	nodeColors["Cover Crouch Window"]	=  (0, 0.7, 0.5);
	nodeColors["Cover Prone"]			=  (0, 0.6, 0.46);
	nodeColors["Cover Right"]			=  (0.85, 0.85, 0.1);
	nodeColors["Cover Left"]			=  (1, 0.7, 0);
	nodeColors["Cover Wide Right"]		=  (0.75, 0.75, 0);
	nodeColors["Cover Wide Left"]		=  (0.75, 0.53, 0.38);
	nodeColors["Conceal Stand"]			=  (0, 0, 1);
	nodeColors["Conceal Crouch"]		=  (0, 0, 0.75);
	nodeColors["Conceal Prone"]			=  (0, 0, 0.5);
	nodeColors["Turret"]				=  (0, 0.93, 0.72);
	nodeColors["Bad"]					=  (1, 0, 0);
	nodeColors["Poor"]					=  (1,0.5,0);
	nodeColors["Ok"]					=  (1, 1, 0);
	nodeColors["Good"]					=  (0, 1, 0);

	wait_for_first_player();

	player = get_players()[0];

	// same as PREDICTION_TRACE_MIN + AIPHYS_STEPSIZE and PREDICTION_TRACE_MAX in actor_navigation.cpp
	traceMin = (-15,-15,18);
	traceMax = (15,15,72);

	hudGood = NewDebugHudElem();
	hudGood.location = 0;
	hudGood.alignX = "left";
	hudGood.alignY = "middle";
	hudGood.foreground = 1;
	hudGood.fontScale = 1.3;
	hudGood.sort = 20;
	hudGood.x = 680;
	hudGood.y = 240;
	hudGood.og_scale = 1;
	hudGood.color = nodeColors["Good"];
	hudGood.alpha = 1;

	hudOk = NewDebugHudElem();
	hudOk.location = 0;
	hudOk.alignX = "left";
	hudOk.alignY = "middle";
	hudOk.foreground = 1;
	hudOk.fontScale = 1.3;
	hudOk.sort = 20;
	hudOk.x = 680;
	hudOk.y = 260;
	hudOk.og_scale = 1;
	hudOk.color = nodeColors["Ok"];
	hudOk.alpha = 1;

	hudPoor = NewDebugHudElem();
	hudPoor.location = 0;
	hudPoor.alignX = "left";
	hudPoor.alignY = "middle";
	hudPoor.foreground = 1;
	hudPoor.fontScale = 1.3;
	hudPoor.sort = 20;
	hudPoor.x = 680;
	hudPoor.y = 280;
	hudPoor.og_scale = 1;
	hudPoor.color = nodeColors["Poor"];
	hudPoor.alpha = 1;

	hudBad = NewDebugHudElem();
	hudBad.location = 0;
	hudBad.alignX = "left";
	hudBad.alignY = "middle";
	hudBad.foreground = 1;
	hudBad.fontScale = 1.3;
	hudBad.sort = 20;
	hudBad.x = 680;
	hudBad.y = 300;
	hudBad.og_scale = 1;
	hudBad.color = nodeColors["Bad"];
	hudBad.alpha = 1;

	hudTotal = NewDebugHudElem();
	hudTotal.location = 0;
	hudTotal.alignX = "left";
	hudTotal.alignY = "middle";
	hudTotal.foreground = 1;
	hudTotal.fontScale = 1.3;
	hudTotal.sort = 20;
	hudTotal.x = 680;
	hudTotal.y = 330;
	hudTotal.og_scale = 1;
	hudTotal.color = (1,1,1);
	hudTotal.alpha = 1;

	hudGoodText = NewDebugHudElem();
	hudGoodText.location = 0;
	hudGoodText.alignX = "right";
	hudGoodText.alignY = "middle";
	hudGoodText.foreground = 1;
	hudGoodText.fontScale = 1.3;
	hudGoodText.sort = 20;
	hudGoodText.x = 670;
	hudGoodText.y = 240;
	hudGoodText.og_scale = 1;
	hudGoodText.color = nodeColors["Good"];
	hudGoodText.alpha = 1;
	hudGoodText SetText("Good: ");

	hudOkText = NewDebugHudElem();
	hudOkText.location = 0;
	hudOkText.alignX = "right";
	hudOkText.alignY = "middle";
	hudOkText.foreground = 1;
	hudOkText.fontScale = 1.3;
	hudOkText.sort = 20;
	hudOkText.x = 670;
	hudOkText.y = 260;
	hudOkText.og_scale = 1;
	hudOkText.color = nodeColors["Ok"];
	hudOkText.alpha = 1;
	hudOkText SetText("Ok: ");

	hudPoorText = NewDebugHudElem();
	hudPoorText.location = 0;
	hudPoorText.alignX = "right";
	hudPoorText.alignY = "middle";
	hudPoorText.foreground = 1;
	hudPoorText.fontScale = 1.3;
	hudPoorText.sort = 20;
	hudPoorText.x = 670;
	hudPoorText.y = 280;
	hudPoorText.og_scale = 1;
	hudPoorText.color = nodeColors["Poor"];
	hudPoorText.alpha = 1;
	hudPoorText SetText("Poor: ");

	hudBadText = NewDebugHudElem();
	hudBadText.location = 0;
	hudBadText.alignX = "right";
	hudBadText.alignY = "middle";
	hudBadText.foreground = 1;
	hudBadText.fontScale = 1.3;
	hudBadText.sort = 20;
	hudBadText.x = 670;
	hudBadText.y = 300;
	hudBadText.og_scale = 1;
	hudBadText.color = nodeColors["Bad"];
	hudBadText.alpha = 1;
	hudBadText SetText("Bad: ");	

	hudLineText = NewDebugHudElem();
	hudLineText.location = 0;
	hudLineText.alignX = "left";
	hudLineText.alignY = "middle";
	hudLineText.foreground = 1;
	hudLineText.fontScale = 1.3;
	hudLineText.sort = 20;
	hudLineText.x = 630;
	hudLineText.y = 315;
	hudLineText.og_scale = 1;
	hudLineText.color = (1,1,1);
	hudLineText.alpha = 1;
	hudLineText SetText("------------------");

	hudTotalText = NewDebugHudElem();
	hudTotalText.location = 0;
	hudTotalText.alignX = "right";
	hudTotalText.alignY = "middle";
	hudTotalText.foreground = 1;
	hudTotalText.fontScale = 1.3;
	hudTotalText.sort = 20;
	hudTotalText.x = 670;
	hudTotalText.y = 330;
	hudTotalText.og_scale = 1;
	hudTotalText.color = (1,1,1);
	hudTotalText.alpha = 1;
	hudTotalText SetText("Total: ");

	badNode = undefined;

	fakeAi = undefined;

	while(1)
	{
		tool = GetDvarInt( #"ai_debugCoverArrivalsTool");

		// check if there's a node selected in Radiant
		if( tool <= 0 && IsDefined(level.nodedrone) && IsDefined(level.nodedrone.currentnode) )
		{
			tool = 1;
		}

		if( tool <= 0 )
		{
			if( IsDefined(fakeAi) )
			{
				fakeAi Delete();
				fakeAi = undefined;
			}

			// hide the UI
			hudBad.alpha		= 0;
			hudPoor.alpha		= 0;
			hudOk.alpha			= 0;
			hudGood.alpha		= 0;
			hudTotal.alpha		= 0;
			hudBadText.alpha	= 0;
			hudPoorText.alpha	= 0;
			hudOkText.alpha		= 0;
			hudGoodText.alpha	= 0;
			hudLineText.alpha	= 0;
			hudTotalText.alpha	= 0;

			wait 0.2;
			continue;
		}

		// spawn the fakeAi
		if( !IsDefined(fakeAi) )
		{
			spawners = getSpawnerArray();

			for( i=0; i < spawners.size; i++ )
			{
				fakeAi = spawners[i] StalingradSpawn();

				if( IsDefined(fakeAi) )
				{
					fakeAi AnimCustom( ::fakeAiLogic );
					break;
				}
			}

			if( !IsDefined(fakeAi) )
			{
				//iprintlnbold("no suitable spawners found in level");
				wait 0.2;
				continue;
			}
		}

		// show the UI
		hudBad.alpha		= 1;
		hudPoor.alpha		= 1;
		hudOk.alpha			= 1;
		hudGood.alpha		= 1;
		hudTotal.alpha		= 1;
		hudBadText.alpha	= 1;
		hudPoorText.alpha	= 1;
		hudOkText.alpha		= 1;
		hudGoodText.alpha	= 1;
		hudLineText.alpha	= 1;
		hudTotalText.alpha	= 1;

		numBad				= 0;
		numPoor				= 0;
		numOk				= 0;
		numGood				= 0;
		tracesThisFrame		= 0;
		renderedThisFrame	= 0;
		evaluatedThisframe	= 0;

		// find all cover node within given radius
		radius = GetDvarFloat( #"ai_debugCoverArrivalsToolRadius");
		nodes = GetAnyNodeArray( player.origin, radius );

		// show the node selected in Radiant
		if( tool > 0 && IsDefined(level.nodedrone) && IsDefined(level.nodedrone.currentnode) )
		{
			nodes = [];
			nodes[0] = level.nodedrone.currentnode;
		}

		showNodes = GetDvarInt( #"ai_debugCoverArrivalsToolShowNodes");

		totalNodes = 1;
		if( showNodes > 0 || nodes.size == 0 )
		{
			totalNodes = nodes.size;
		}

		fakeAi.cqbwalking	= false;
		fakeAi.weapon		= "ak47_sp";
		fakeAi.heat			= false;

		// set cqb/pistol
		toolType = GetDvarInt( #"ai_debugCoverArrivalsToolType");
		if( toolType == 1 )
		{
			fakeAi.cqbwalking = true;
		}
		else if( toolType == 2 )
		{
			fakeAi.weapon = "m1911_sp";
		}

		// ALEXP_TODO: this is pretty useless.. need to do it off FPS
		// scale based on number of AI (more AI -> lower FPS)
		minAi = 5;
		maxAi = 15;
		nodesMin = 5;
		nodesMax = 30;

		allAi = entsearch( level.CONTENTS_ACTOR, player.origin, 10000 );
		numAi = allAi.size;
		
		// clamp
		if( numAi < minAi )
		{
			numAi = minAi;
		}
		else if( numAi > maxAi )
		{
			numAi = maxAi;
		}

		maxNodesPerFrame = (numAi - minAi) / (maxAi - minAi);
		maxNodesPerFrame = (1-maxNodesPerFrame) * (nodesMax - nodesMin) + nodesMin;

		// how often to evaluate nodes (spread them out for optimization)
		frameInterval = int( ceil( totalNodes / maxNodesPerFrame ) );
		//println("interval: " + frameInterval + " nodes: " + maxNodesPerFrame + " ai: " + numAi);

		for( i=0; i < totalNodes && i < nodes.size; i++ )
		{
			node = nodes[i];

			// clear the cached data
			if( !IsDefined(node.tool) || node.tool != tool || !IsDefined(node.toolType) || node.toolType != toolType )
			{
				node.angleDeltaArray	= undefined;
				node.moveDeltaArray		= undefined;
				node.preMoveDeltaArray	= undefined;
				node.postMoveDeltaArray	= undefined;
				node.tool				= tool;
				node.toolType			= toolType;
			}

			assert( IsDefined(node) );
			if( !IsDefined(node) || node.type == "BAD NODE" || node.type == "Path" )
			{
				totalNodes++;
				continue;
			}
			else if( !IsDefined( anim.approach_types[node.type] ) )
			{
				totalNodes++;
				continue;
			}

			// skip node evaluation every few frames (PhysicsTrace is expensive)
			if( IsDefined(node.lastCheckedTime) && (gettime() - node.lastCheckedTime) < 50*frameInterval )
			{
				if( node.lastRatio == 0 )
				{
					numBad++;
				}
				else if( node.lastRatio < 0.5 )
				{
					numPoor++;
				}
				else if( node.lastRatio < 1.0 )
				{
					numOk++;
				}
				else
				{
					numGood++;
				}

				continue;
			}

			// limit the number of traces per frame
			if( evaluatedThisFrame > maxNodesPerFrame ) // 30 nodes
			{
				continue;
			}

			// use the the AI that's on the node if there is one
			testAi = fakeAi;
			nearAiArray = entsearch( level.CONTENTS_ACTOR, node.origin, 16 );

			if( nearAiArray.size > 0 )
			{
				testAi = nearAiArray[0];
			}

			renderNode = true;
			if( DistanceSquared(node.origin, player.origin) > 800*800 ) //|| renderedThisFrame*frameInterval > maxNodesPerFrame )
			{
				renderNode = false;
			}

			nodeColor = nodeColors["Good"];

			// find transition type
			stance = node isNodeDontStand() && !node isNodeDontCrouch();
			transType = anim.approach_types[node.type][stance];

			totalTransitions = 0;
			validTransitions = 0;

			animName = "arrive_" + transType;

			// exit support
			if( tool == 2 )
			{
				animName = "exit_" + transType;
			}

			if( fakeAi shouldDoCQBTransition( node, transType ) )
				animName = animName + "_cqb";

			// cache for performance
			if( !IsDefined(node.angleDeltaArray) )
			{
				node.angleDeltaArray = fakeAi angleDeltaArray( animName, "move" );
			}

			// go through all available transitions
			for( j=1; j <= 9; j++ )
			{
				if( IsDefined(node.angleDeltaArray[j]) )
				{
					totalTransitions++;

					lineColor = (0.5,0,0);

					approachIsGood = false;
					originalEnterPos = undefined;

					// final yaw at node
					approachFinalYaw = node.angles[1] + animscripts\cover_arrival::getNodeStanceYawOffset( transType );

					angle = (0, approachFinalYaw - node.angleDeltaArray[j], 0);

					// exits
					if( tool == 2 )
					{
						angle = (0, approachFinalYaw, 0 );
					}
			
					forwardDir = AnglesToForward( angle );
					rightDir = AnglesToRight( angle );

					// cache for performance
					if( !IsDefined(node.moveDeltaArray) )
					{
						node.moveDeltaArray = fakeAi moveDeltaArray( animName, "move" );
					}

					enterPos = node.origin;

					forward = vector_scale( forwardDir, node.moveDeltaArray[j][0] );
					right   = vector_scale( rightDir, node.moveDeltaArray[j][1] );

					// start position of arrival animation
					if( tool == 1 ) // arrival
					{
						enterPos = node.origin - forward + right;
					}
					else
					{
						enterPos = node.origin + forward - right;
					}

					// check if the AI can move between the node and anim start pos or corner
					if( testAi MayMoveFromPointToPoint(node.origin, enterPos) )
					{
						approachIsGood = true;

						lineColor = (0,0.75,0);
					}

					if( renderNode )
					{
						line( node.origin, enterPos, lineColor, 1, 1, frameInterval );
					}
	
					// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
					// (already did the second part, from corner to node, now doing from start of enter anim to corner)
					if( approachIsGood && j >= 7 && !isSubstr(transType, "exposed") )
					{
						originalEnterPos = enterPos;

						if( tool == 1 ) // arrival
						{
							if( !IsDefined(node.preMoveDeltaArray) )
							{
								node.preMoveDeltaArray = fakeAi preMoveDeltaArray( animName, "move" );
							}

							forward = vector_scale( forwardDir, node.preMoveDeltaArray[j][0] );
							right   = vector_scale( rightDir, node.preMoveDeltaArray[j][1] );

							originalEnterPos = enterPos - forward + right;
						}
						else // exit
						{
							if( !IsDefined(node.postMoveDeltaArray) )
							{
								node.postMoveDeltaArray = fakeAi postMoveDeltaArray( animName, "move" );
							}

							forward = vector_scale( forwardDir, node.postMoveDeltaArray[j][0] );
							right   = vector_scale( rightDir, node.postMoveDeltaArray[j][1] );

							originalEnterPos = enterPos + forward - right;
						}

						// check if the AI can move between the corner and anim start pos
						if( !testAi MayMoveFromPointToPoint(originalEnterPos, enterPos) )
						{
							approachIsGood = false;
							lineColor = (0.5,0,0);
						}

						if( renderNode )
						{
							line( originalEnterPos, enterPos, lineColor, 1, 1, frameInterval );
							print3d( originalEnterPos, j, lineColor, 1, 0.2, frameInterval );
						}
					}
					else if( renderNode )
					{
						print3d( enterPos, j, lineColor, 1, 0.2, frameInterval );
					}

					if( approachIsGood )
					{
						validTransitions++;
					}

					tracesThisFrame++;
				}
			}

			// assign categories based on number of valid transitions
			node.lastRatio = validTransitions / totalTransitions;
			if( node.lastRatio == 0 )
			{
				nodeColor = nodeColors["Bad"];
				numBad++;

				badNode = node;
			}
			else if( node.lastRatio < 0.5 )
			{
				nodeColor = nodeColors["Poor"];
				numPoor++;
			}
			else if( node.lastRatio < 1.0 )
			{
				nodeColor = nodeColors["Ok"];
				numOk++;
			}
			else
			{
				numGood++;
			}

			if( renderNode )
			{
				// render box, node type and node forward
				print3d( node.origin, node.type + " (" + transType + ")", nodeColor, 1, 0.35, frameInterval );
				box( node.origin, (-16,-16,0), (16,16,16), node.angles[1], nodeColor, 1, 1, frameInterval );

				nodeForward = anglesToForward( node.angles );
				nodeForward = vector_scale( nodeForward, 8 );
				line( node.origin, node.origin + nodeForward, nodeColor, 1, 1, frameInterval );

				renderedThisFrame++;
			}

			// save last time
			evaluatedThisFrame++;
			node.lastCheckedTime = gettime();
		}

		//println("evaluated: " + evaluatedThisFrame + " traced: " + tracesThisFrame + " rendered: " + renderedThisFrame);

		// render stats
		hudTotal	SetValue( totalNodes );
		hudBad		SetValue( numBad );
		hudPoor		SetValue( numPoor );
		hudOk		SetValue( numOk );
		hudGood		SetValue( totalNodes - numBad - numPoor - numOk );

		wait(0.05);
	}
}
#/

// --------------------------------------------------------------------------------
// ---- AI Feature - Shortcircuiting Prototype - Arrival ----
// --------------------------------------------------------------------------------

tryShortCircuitingArrivalAnimation( approachpoint, approachType, approachNumber, coverEnterPos, availableDistSq, actualDistSq, arrivalYaw )
{
	// Distance to pathgoal should be less than the length of the arrival animation.
	Assert( availableDistSq < actualDistSq );
	
	// ALEXP: storing the notetrack info costs way too many scriptVars
	//noteTrackInfo = notetrackArray("arrive_"+approachType)[approachNumber];
	noteTrackInfo = getNotetracksInDelta( animArray("arrive_"+approachType)[approachNumber], 0, 9999 );
	
	numberOfFootNotetracks = getNumberOfFootNotetracks( noteTrackInfo );

	coverEnterEnt = SpawnStruct();
	selectedNotetrackIndex = undefined; // start with undefined notetrack selection
	parsedFootStepNotetracks = 0;
	point = undefined;
	
	// needed for angle checks
	selfToAnimStart = undefined;
	AnimStartToNode = undefined;

	for( i = 0; i < noteTrackInfo.size; i++ )
	{
		// Keep finding the foorstep notetrack until the distance is greater than the available distance 
		// and choose the previous one, this is assuming the notetrackInfo list is in order they are fired.	
		if( !IsSubStr( noteTrackInfo[i][1], "footstep" ) )
		  continue;

		// we have parsed this notetrack, increase the count.
		parsedFootStepNotetracks++;
	
		// Find the localized approach point
		point = getLocalizedshortCircuitedApproachPoint( approachpoint, approachType, approachNumber, arrivalYaw, noteTrackInfo, i );

/#
		// Draw debug cross at the notetrack positions, its essentially two lines, so I can run this through recorder 
		debug_arrival_cross( point, 1, level.color_debug["white"], 0.6 );
#/
		
		if( DistanceSquared( approachpoint, point ) > availableDistSq )
		{

			thread debug_arrival_line( approachpoint, point, (0,1,1), 1.5 );			
			// No need to save the ones which are at a distance higher then 70% of the available disance.
			continue;

		}
		else
		{
			// Check for the angle difference, if its greater then store it until we find a better one.
			selfToAnimStart = VectorNormalize( point - self.origin );
			AnimStartToNode = VectorNormalize( approachpoint - point );

			cosAngle = vectorDot( selfToAnimStart, AnimStartToNode );

			// record the angle for debugging
			/#debug_arrival_record_text( ""+ ACos(cosAngle), point, level.color_debug["red"] );#/
		
			// If the angle is still greater than 90 but this is the last notetrack then choose the last footstep notetrack.
			// We are allowing more angle for short circuited animations.
			if( ( cosAngle < 0 ) && ( parsedFootStepNotetracks != numberOfFootNotetracks ) ) 
			{
				continue;
			}

			// If AI cant move from point to the approachpoint then shortcircuting will not help
			if(!self MayMoveFromPointToPoint(point, approachPoint))
			{
				// show this point as red color to distinguish the reason for discarding it	
				/#debug_arrival_cross( point, 1, level.color_debug["red"], 0.6 );#/
				continue;
			}

			// Draw the blue line for selected approach point.
			thread debug_arrival_line( approachpoint, point, (0,0,1), 1.5 );
		
			selectedNotetrackIndex = i;
			break;		
		}
	}

	// Draw debug line from the selected point to the approach point.
	if( IsDefined( selectedNotetrackIndex ) )
	{
		thread debug_arrival_line( approachpoint, point, (0,0,1), 1.5 );			
	}

	// Found a notetrack with a higher distance than available distance
	Assert( i <= noteTrackInfo.size );

	coverEnterEnt.selectedNotetrackIndex = selectedNotetrackIndex;
	coverEnterEnt.coverEnterPos = point;

	return coverEnterEnt;
	
}

// Returns modified animation time for ShortCircuiting
getShortCircuitedArrivalAnimTime( approachType, approachNumber, coverEnterEnt, exitPos )
{
	// ALEXP: storing the notetrack info costs way too many scriptVars
	//noteTrackInfo = notetrackArray("arrive_"+approachType)[approachNumber];
	noteTrackInfo = getNotetracksInDelta( animArray("arrive_"+approachType)[approachNumber], 0, 9999 );
	
	selectedNotetrackIndex = coverEnterEnt.selectedNotetrackIndex;
	
	// Select the animation time from the notetrackInfo
	animTime = noteTrackInfo[ selectedNotetrackIndex ][2];

	// Select the notetrack foot/ it might be left or right
	whichFoot = noteTrackInfo[ selectedNotetrackIndex ][1];

	// Make sure that the time is less than the actual full length time of the animation.
	// This is not a valid assert as the animTime is normalized.
	// SUMEET 8/5/09 doesn't make sense since one is normalized and one is absolute
	// Assert( animTime < GetAnimLength( anim.coverTrans[approachType][approachnumber] ) );

	return animTime;
}


// Get the approach point for shortcircuited animation.
getLocalizedshortCircuitedApproachPoint( approachpoint, approachType, approachNumber, arrivalYaw, noteTrackInfo, i )
{
	// get the movedelta for the shortcircuted time
	distanceDelta = Length( getMoveDelta( animArray("arrive_"+approachType)[approachNumber], noteTrackInfo[i][2], 1 ) );

	// get the direction, and apply the distance from the approachpoint in this direction to get the new enter position.
	direction = VectorNormalize( self.coverEnterPos - approachpoint );

	enterPos = approachpoint + vector_scale( direction, distanceDelta );

	
	if ( approachNumber <= 6 || approachtype == "exposed" || approachtype == "exposed_crouch" )
	{
		return enterPos;
	}
	
	Assert( approachtype == "left" || approachtype == "left_crouch" || approachtype == "right" || approachtype == "right_crouch" );

	angle = (0, arrivalYaw - GetAngleDelta( animArray("arrive_"+approachType)[approachNumber], noteTrackInfo[i][2], 1 ), 0 );
	
	forwardDir = AnglesToForward( angle );
	rightDir = AnglesToRight( angle );
	
	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the second part, from corner to node, now doing from start of enter anim to corner)
	coverTransPreDist = getMoveDelta( animArray("arrive_"+approachType)[approachNumber], noteTrackInfo[i][2], getTransSplitTime( approachType, approachNumber) );	
	

	forward = vector_scale( forwardDir, coverTransPreDist[0] );
	right   = vector_scale( rightDir, coverTransPreDist[1] );

	enterPos = enterPos - forward + right;
	
	return enterPos;
}



// --------------------------------------------------------------------------------
// ---- AI Feature - Shortcircuiting Prototype - Exits ----
// --------------------------------------------------------------------------------

tryShortCircuitingExitAnimation( exittype, approachNumber )
{

	// In case the AI does not have the pathgoal position then short circuiting is not possible.
	if(!IsDefined( self.pathgoalpos ))
		return undefined;
	
	// If the coverExit psotion is not defiend then short circuiting is not possible.
	if(!IsDefined( self.coverExitPos ))
		return undefined;	

	// AI_TODO - if the pathgoal position is not defined then wait for it or dont do the short circuit.	
	actualDistSq = DistanceSquared( self.origin, self.coverExitPos ); // actual distance the animation will take us to	
	availableDistSq = DistanceSquared( self.origin, self.pathgoalpos ); // distance available to the animation 

	// Cut the distance a little. TODO decide this number based on one run cycle(maybe!)
	availableDistSq = availableDistSq * 0.8 * 0.8;
	
	// ALEXP: storing the notetrack info costs way too many scriptVars
	//noteTrackInfo = notetrackArray("exit_"+exittype)[approachNumber];
	noteTrackInfo = getNotetracksInDelta( animArray("exit_"+exittype)[approachNumber], 0, 9999 );
	selectedNotetrackIndex = undefined;
		
	for( i = 0; i < noteTrackInfo.size; i++ )
	{
		// Keep finding the foorstep notetrack until the distance is greater than the available distance 
		// and choose the previous one, this is assuming the notetrackInfo list is in order they are fired.	
		if( !IsSubStr( noteTrackInfo[i][1], "footstep" ) )
		  continue;	
	
		point = self localToWorldCoords( noteTrackInfo[i][3] );	

/#
		// Draw debug cross at the notetrack positions, its essentially two lines, so I can run this through recorder 
		debug_arrival_cross( point, 1, level.color_debug["white"], 0.6 );
#/	

		if( DistanceSquared( self.origin, point ) < availableDistSq )
		{
			selectedNotetrackIndex = i;
			continue;
		}
		else
		{
			break;		
		}
	}

	// Found a notetrack with a higher distance than available distance
	Assert( i <= noteTrackInfo.size );

	return selectedNotetrackIndex; // time can be either undefined or some valid value
}


// Returns modified animation time for ShortCircuiting.
getShortCircuitedExitAnimTime( exittype, approachNumber, selectedNotetrackIndex, exitPos )
{
	// ALEXP: storing the notetrack info costs way too many scriptVars
	//noteTrackInfo = notetrackArray("exit_"+exittype)[approachNumber];
	noteTrackInfo = getNotetracksInDelta( animArray("exit_"+exittype)[approachNumber], 0, 9999 );
	
	// Select the animation time from the notetrackInfo
	animTime = noteTrackInfo[ selectedNotetrackIndex ][2];

	// Select the notetrack foot/ it might be left or right
	whichFoot = noteTrackInfo[ selectedNotetrackIndex ][1];

	// Draw line to the short circuted pos
	/#
	endPoint = self localToWorldCoords( noteTrackInfo[ selectedNotetrackIndex ][3] );
	thread debug_arrival_line( exitpos, endPoint, (1,0,0), 1.5 );
	#/

	// Make sure that the time is less than the actual full length time of the animation.
	// SUMEET 8/5/09 doesn't make sense since one is normalized and one is absolute
	// Assert( animTime < GetAnimLength( anim.coverExit[exittype][approachnumber] ) );

	return animTime;
}


// --------------------------------------------------------------------------------
// ---- AI Feature - Shortcircuiting Prototype - utility Functions ----
// --------------------------------------------------------------------------------

setShortCircuitedAnimTime(arrivalAnim)
{
	if(IsDefined(self.shortCircuitAnimTime))
	{
		self setanimtime( arrivalAnim, self.shortCircuitAnimTime );
	}	
}



whichFootNotetrack(note)
{
	noteTrack = undefined;

	if( !IsSubStr( note, "footstep_left" ) )
		noteTrack = "left";
	
	if( !IsSubStr( note, "footstep_right" ) )
		noteTrack = "right";

	return noteTrack;
}


// Returns number of footsteps notetracks from the list
getNumberOfFootNotetracks( noteTrackInfo )
{
	numberOfFootNotetracks = 0;	

	for( i=0;i<noteTrackInfo.size;i++ )
	{
		if( !IsSubStr( noteTrackInfo[i][1], "footstep" ) )
		  continue;

		numberOfFootNotetracks++;
	}

	return numberOfFootNotetracks;
}


getTransSplitTime( approachType, dir )
{
	return anim.coverTransSplit[ approachType ][ dir ];
}
