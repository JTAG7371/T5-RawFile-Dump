#include animscripts\utility;
#include animscripts\weaponList;
#include common_scripts\utility;
#include animscripts\combat_Utility;
#include animscripts\anims;
#include maps\_utility;

// --------------------------------------------------------------------------------
// ---- AI behavior - React ----
//	Written by Sumeet Jakatdar
//	Standing AI can react to 6 different locations.
//  Running AI can react to two locations.
//	  right [|]   left
//		  ---|--- j_neck
//			|||	  j_mainroot
//			/|\	  tag_origin
// --------------------------------------------------------------------------------


#using_animtree ("generic_human");
main()
{
	self SetFlashBanged(false);

	// Stop flamethrower from shooting.
	self flamethrower_stop_shoot();
	
	// SUMEET_TODO - Hook up react dialogue
	//self animscripts\face::SayGenericDialogue("react");
		
 	self trackScriptState( "React Main", "code" );
    self notify ("anim entered react");
	self endon("killanimscript");
	
	animscripts\utility::initialize("react");
	self AnimMode("gravity");

	// Decide which animation to play
	reactAnim = getReactAnim();
	
/#
	if( GetDvarInt( #"scr_debugAiReactFeature") == 1 )
	{
		Record3DText( "going to react", self.origin + ( 0, 0, 70 ), ( 1, 1, 1 ), "Script" );
		//Print( "Playing react: " + self.a.pose + " - " + reactAnim, self, level.color_debug["white"], "Script" );
	}
#/
	
	// Play the react animation.
	if( IsDefined(reactAnim) )
	{
		playReactAnim( reactAnim );
	}

	// Switch to heat unless it's a VC or already has custom anims
	if( !self.heat && self.animType != "vc" && !IsDefined(self.anim_array) )
	{
		self animscripts\anims_table::setup_heat_anim_array();
	}
	
	return;
}



// --------------------------------------------------------------------------------
// ---- Init global/individual timers and other variables for once ------
// --------------------------------------------------------------------------------

react_init()
{
	anim.lastReactionTime = 0; // last time any AI reacted within 
	anim.reactionCoolDownTime = 3 * 1000; // for 10 sec nobody will react again.

	anim.reactionDistanceSquaredMax  = 1000 * 1000; // The attacker should be within 500 units to be able to see react.
	anim.reactionDistanceSquaredMin  = 100 * 100;   // The attacker should be outside 100 units to be able to see react.

	anim.reactionAwarenessDist = 32;     // distance between react origin and self origin for allies

	anim.nextReactionTimeForAIMin = 5 * 1000; // min range per AI's next reaction
	anim.nextReactionTimeForAIMax = 10 * 1000; // max range per AI's next reaction
}

// self = AI
init_react_timers()
{
	self.a.reactTime 			 = 0; // Updated when AI reacts
	self.a.nextReactTimeInterval = RandomIntRange( anim.nextReactionTimeForAIMin, anim.nextReactionTimeForAIMax );	//  Random time between two reaction for AI. 
}

// --------------------------------------------------------------------------------
// ---- Functions to play the select react animation ------
// --------------------------------------------------------------------------------

playReactAnim( reactAnim )
{
	// This AI is for sure going to react now, update the reaction time.
	// Do not update the time if the player is hiting allies..
	self.a.reactTime = GetTime();

	//  Random time between two reaction for AI. 	
	self.a.nextReactTimeInterval = RandomIntRange( anim.nextReactionTimeForAIMin, anim.nextReactionTimeForAIMax );	 
	
	if( IsPlayer( self.attacker ) && self.team == "allies" )
	{
		// I may end up adding some logic here.
	}
	else
	{
		// Update the last reaction global time
		anim.lastReactionTime = self.a.reactTime;
	}

	self SetFlaggedAnimKnobAllRestart( "reactAnim", reactAnim, %body, 1, .1, 1 );
	
	if( animHasNotetrack( reactAnim, "start_aim" ) )
	{
		self thread notifyStartAim( "reactAnim" );
		self endon("start_aim");
	}
	
	self thread doReactNotetracks( "reactAnim" );

	// Early blendout to avoid pause into run
	reaction_blendout( reactAnim );
}

reaction_blendout( reactAnim )
{
	blendouttime = 0.1;

	time = GetAnimLength( reactAnim );

	wait( time - blendouttime );
}


notifyStartAim( animFlag )
{
	self endon( "killanimscript" );
	self waittillmatch( animFlag, "start_aim" );
	self notify( "start_aim" );
}


// --------------------------------------------------------------------------------
// ---- Decide if AI can/should react to this event ------
// --------------------------------------------------------------------------------

shouldReact()
{

	Assert( IsDefined( self.reactOrigin ) );

/#
	// debug data
	self thread drawEventPointAndDir( self.reactorigin, undefined, (1,0,0) );	

	if(GetDvarInt( #"scr_forceAiReactFeature")) // This will ensure that this will not run in test map.
		return true;	
#/


	// AI will react if attacked by another "AI",	
	// 1. allowed to react.
	// 2. if the attacker is within anim.reactionDistance min and max range. 
	// 3. nobody reacted for anim.reactionCoolDownTime since the last reaction.
	// 4. a random chance 70%. 
	// 5. is not cqb walking
	// 6. AI can see the reaction origin

	// AI will only react if attacked by "player",
	// 1. allowed to react.
	// 2. AI can see the reaction origin
	// 3. Is not cqb walking
	// 4. if player shoots within 64 units from the AI
	// 5. if individual timers dont allow to react
	
	if(self.a.disableReact)
		return false;
	
	// flamethrower will not react
	if( self usingGasWeapon() )
		return false;

	// pistol will not react (no animations)
	if( self usingPistol() )
		return false;
	
	// if guy is bleeding or reviving then he should not react
	if( self animscripts\revive::isReviverOrBleeder() )
		return false;
	
	// no support for prone reactions
	if( self.a.pose == "prone" )
		return false;
	
	// SUMEET_TODO - Turn on the cover react animations, flinching in cover behavior is enough for now.
	// Ideally AI should not get here as AI is not put into react state if at cover in code, checked in code.
	if( IsDefined(self.coverNode) )
		return false;
	
	// see if this AI is set to ignoreall, only civilians are exempt
	if( self.ignoreall && ( !IsDefined( self.specialReact ) ) )
		return false;
			
	// AXIS AI will not reat if, shot by axis AI
	if( self.team == "axis" && IsDefined( self.attacker ) && self.attacker.team == "axis" )
		return false;
		
	// SUMEET_TODO - Ask Jimmy about CQB reactions
	if ( self isCQBWalking() )
		return false;
	
	// Check for individual timer 
	if( self.a.reactTime !=0 && ( GetTime() < self.a.reactTime + self.a.nextReactTimeInterval ) )
		return false; 
	
	// don't want to go way off path
	if( self.a.script == "move" && self.lookaheaddist < 250 )
		return false;
	
	// if set then reaction will only happen while running
	if( IsDefined( self.a.runOnlyReact ) && self.a.runOnlyReact )
	{
		if( self.a.script != "move" )
			return false;
	}

	// check if there's an animation available (some may be blocked)
	reactAnim = getReactAnim();
	if( !IsDefined( reactAnim ) )
		return false;

	// ALLIES ONLY
	// if attacker is player then higher chance to react.
	if( self.team == "allies" && IsDefined( self.attacker ) && IsPlayer( self.attacker  ) && ( RandomInt(100) > 20 ) )
	{
		dist = DistanceSquared( self.attacker.origin, self.origin );

		// dist should be less than max and greater than min range.
		if( dist < anim.reactionDistanceSquaredMax && dist > anim.reactionDistanceSquaredMin )
		{
			if( Distance2D( self.reactOrigin, self.origin ) < anim.reactionAwarenessDist )
			{ 
				if( sightTracePassed( self getEye(), self.reactOrigin, false, undefined ) )
				{	
					return true;	
				}
			}
		}
	}

	// Non player attacker logic
	if( ( anim.lastReactionTime == 0 ) || ( GetTime() > anim.lastReactionTime + anim.reactionCoolDownTime && ( RandomInt(100) > 40 ) ) )
	{		
		dist = DistanceSquared( self.attacker.origin, self.origin );

		// dist should be less than max and greater than min range.
		if( dist < anim.reactionDistanceSquaredMax && dist > anim.reactionDistanceSquaredMin )
		{
			if( sightTracePassed( self getEye(), self.reactOrigin, false, undefined ) )
			{
					return true;
			}
		}
	}
		
	return false;
}

// --------------------------------------------------------------------------------
// ---- Functions to select a react animation based on the current situation ------
// --------------------------------------------------------------------------------

getReactAnim() // self = AI
{

	reactAnim = undefined;
	location  = getEventLocationInfo();

/#
	// debug data
	self thread drawEventPointAndDir( self.reactorigin, location, (0,1,0) );	
#/

/*
	// SUMEET_TODO - Implement cover react through cover_behavior and corner script
	// Ideally AI should not get here as AI is not put into react state if at cover in code
	if( self.a.special != "none" )
	{ 
		reactAnim = specialReact( self.a.special, location );
		
		if( IsDefined( reactAnim ) )
			return reactAnim;	
	}
	
*/
	
	// running animation
	if( self.a.pose == "stand" && self.a.movement == "run" && (self getMotionAngle()<60) && (self getMotionAngle()>-60) )
	{
		reactAnim = getRunningForwardReactAnim( location );
		
		if( IsDefined( reactAnim ) )
			return reactAnim;	
	}
	
	// standing animation
	if( !IsDefined( self.a.runOnlyReact ) || !self.a.runOnlyReact )
	{
		if( self.a.pose == "stand" || self.a.pose == "crouch" )
		{
			reactAnim = getReactAnimInternal( location );
			
			// explicitely set the movement of AI to Stop
			self.a.movement = "stop";

			if( IsDefined( reactAnim ) )
				return reactAnim;	
		}
	}

	return reactAnim;
}


// --------------------------------------------------------------------------------
// ---- Cover Reactions ------
// --------------------------------------------------------------------------------
/*
// SUMEET_TODO - Implement cover react through cover_behavior and corner script
specialReact( type, location )
{
	if ( type == "none" )
	{
		return undefined;
	}

	// create a set of animation that AI can play in this case.
	reactArray = [];
	
	switch ( type )
	{
		case "cover_left":
		case "cover_right":
		case "cover_stand":
			if( IsSubStr( location, "_lower_torso" ) )
			{
				reactArray[reactArray.size] = animArray( type + "_lower_torso" );
			}
			else if( IsSubStr( location, "_upper_torso" ) )
			{
				reactArray[ reactArray.size ] = animArray( type + "_upper_torso" );
			}
			else if( IsSubStr( location, "_head" ) )
			{
				reactArray[ reactArray.size ] = animArray( type + "_head" );
			}	
			break;
	}

	if( reactArray.size > 0 )
	{
		return reactArray[ RandomInt( reactArray.size ) ];
	}
	else
	{
		return undefined;
	}
}
*/
// --------------------------------------------------------------------------------
// ---- Exposed Reactions ------
// --------------------------------------------------------------------------------
getReactAnimInternal( location )
{

	// create a set of animation that AI can play in this case.
	reactArray = [];
	type = "exposed";

	reactArray[ reactArray.size ] = animArray( type + "_" + location, "react" );
			
	AssertEx( reactArray.size > 0, reactArray.size );
	return reactArray[ RandomInt( reactArray.size ) ];
}

// --------------------------------------------------------------------------------
// ---- Running Reactions ------
// --------------------------------------------------------------------------------
getRunningForwardReactAnim( location )
{
	// create a set of animation that AI can play in this case.
	reactArray = [];
	type = "run";

	if( self.sprint )
	{
		type = "sprint";
	}

	if( IsSubStr( location, "upper" ) || IsSubStr( location, "head" ) )
	{
		reactArray[ reactArray.size ] = animArray( type + "_head", "react" );
	}
	else 
	{
		if( RandomIntRange( 0, 2 ) < 1 )
		{
			reactArray[ reactArray.size ] = animArray( type + "_lower_torso_fast", "react" );
		}
		else
		{
			reactArray[ reactArray.size ] = animArray( type + "_lower_torso_stop", "react" );
		}
	}

	// remove any animation that cant be played because of geo
	reactArray = removeBlockedAnims( reactArray );
	
	if( reactArray.size > 0 )
		return reactArray[ RandomInt( reactArray.size ) ];
	else
		return undefined;
}

// --------------------------------------------------------------------------------
// ---- Functions to calculate the react event location info ----
// --------------------------------------------------------------------------------

getEventLocationInfo()
{
	Assert( IsDefined( self.reactorigin ) );
	
	// Decide the area to react to based on the event origin.
	position_info = calculateLocationInfo( self.reactorigin );
	
	return position_info;
}


calculateLocationInfo( point )
{
	// try to find if bullet is on left or right
	direction = getPointDirection( point );

	// distance from neck to ground
	pos = self GetTagOrigin("j_neck");
	tag_neck_dist = distanceFromTagOrigin( pos );

	// distance from pelvis to ground
	pos = self GetTagOrigin("j_mainroot");
	tag_main_root_dist = distanceFromTagOrigin( pos );

	// calculate vertical distance of point from ground.
	point_dist = distanceFromTagOrigin( ( self.origin[0], self.origin[1], point[2] ) );

	// three regions, each region divided into two, either left or right
	if( point_dist < tag_main_root_dist )
	{
		// lower torso
		location = direction + "_lower_torso";
	}
	else if( point_dist < tag_neck_dist )
	{
		// upper torso and below neck
		location = direction + "_upper_torso";
	}
	else
	{
		// above nect near head
		location = direction + "_head";
	}

	return location;
}

// decide point location, left or right
getPointDirection( point )
{
	closestPointDir = ( point - self.origin );
	forwardDir = AnglesToRight( self.angles );

	dotProduct = VectorDot( forwardDir, closestPointDir );

	if( dotProduct > 0 )
	{
		side = "right";
	}
	else
	{
		side = "left";	
	}

	return side;
}

distanceFromTagOrigin( org )
{
	return DistanceSquared( self.origin, org );
}


// --------------------------------------------------------------------------------
// ---- Animations utility functions ----
// --------------------------------------------------------------------------------
removeBlockedAnims( array )
{
	newArray = [];
	for ( index = 0; index < array.size; index++ )
	{
		localDeltaVector = getMoveDelta( array[index], 0, 1 );
		endPoint = self localToWorldCoords( localDeltaVector );

		if ( self mayMoveToPoint( endPoint ) )
		{
			newArray[newArray.size] = array[index];
		}
	}

	return newArray;
}

doReactNotetracks( flagName )
{
	self notify("stop_DoNotetracks");

	self endon("killanimscript");
	self endon("death");
	self endon("stop_DoNotetracks");

	self animscripts\shared::DoNoteTracks( flagName );
}


// --------------------------------------------------------------------------------
// ---- Debug functions ----
// --------------------------------------------------------------------------------

/#

drawEventPointAndDir( position, location, color )
{
	self endon("death");

	current_time = GetTime();


	if(!GetDvarInt( #"scr_debugAiReactFeature")) // This will ensure that this will not run in test map.
		return;	

	if( IsDefined( location ) )
	{		
		recordEntText( "Location - " + location, self, level.color_debug["white"], "Script" );
	}
	
	while(1)
	{
		drawDebugCross( position, 1, color, .05 );
	
		if( GetTime() - current_time > 2 * 1000 )
		{
			break;
		}
	
		wait(0.05);
	}
}


debugLine( fromPoint, toPoint, color, durationFrames )
{
	self endon("death");

	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		recordLine( fromPoint, toPoint, color, "Script", self );
		wait (0.05);
	}
}


drawDebugCross(atPoint, radius, color, durationFrames)
{
	self endon("death");

	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debugLine(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debugLine(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debugLine(atPoint_forward,	atPoint_back,	color, durationFrames);
}

#/