#include maps\_utility;
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\Debug;
#include maps\_anim;

#using_animtree ("generic_human");

// --------------------------------------------------------------------------------
// ---- Revive feature ----
/* 
*/
// --------------------------------------------------------------------------------

// Precache everything here
precacheReviveModels()
{
	if ( IsDefined( level.reviveFeature ) && !level.reviveFeature )
		return;

	// bandage precache
	precacheModel( "char_rus_bandages1" );
}

// Creates an array of the animations based on the pose of the AI while going down
revive_main()
{
	// --------------------------------------------------------------------------------
	// ---- Revive controls/timers setup ----
	// --------------------------------------------------------------------------------

	anim.nextReviveSequenceTime = GetTime() + RandomIntRange(0, 20000); // used for deciding the next possible revive sequence
	
	anim.nextReviveSequencePlayerTimeMin = 15000; // minimum time range after player has seen last revive sequence
	anim.nextReviveSequencePlayerTimeMax = 30000; // maximum time range after player has seen last revive sequence
	
	anim.nextReviveSequenceTimeMin = 5000; // minimum time range after last revive sequence
	anim.nextReviveSequenceTimeMax = 10000; // maximum time range after last revive sequence

	anim.bleederBleedOutTimeMin =  5000; // bleeder bleed out range min
	anim.bleederBleedOutTimeMax =  10000; // bleeder bleed out range max	
		
	// Revive related constants
	anim.reviverPingDist = 512; // Bleeder will search for reviver in this distance.
	anim.reviverIgnorePlayerDistSq = 200*200; // Bleeder will not be revived until there is a player within this range.
	anim.reviveSequencePlayerVisibleDistSq = 1000*1000; // Assuming that players within this range will be able to get a glance of revive sequence.
	
	// --------------------------------------------------------------------------------
	// ---- Revive animation setup ----
	// --------------------------------------------------------------------------------

	anim.revive = [];

	// Bleeder animations - Fall to bleed translation based on current pose.
	anim.bleed["stand"]["fall"]  = %ai_revive_wounded_onback_fall_stand;
	anim.bleed["crouch"]["fall"] = %ai_revive_wounded_onback_fall_crouch;
	anim.bleed["prone"]["fall"]  = %ai_dying_crawl_2_back_revive; // Temp anim

	//Bleeder animations - Bleeding and getup.
	anim.bleed["bleed_loop"] = %ai_revive_wounded_onback_loop;
	anim.bleed["left"]["being_revived"] = %ai_revive_wounded_onback_left_revive;
	anim.bleed["left"]["get_up"] = %ai_revive_wounded_onback_left_get_up;

	// Reviver animations - revive and getup.
	anim.revive["left"]["reviving"] = %ai_revive_reviver_onback_left_revive;
	anim.revive["left"]["get_up"] = %ai_revive_reviver_onback_left_get_up;
	
	
/#
	// debug information
	level.totalReviveSequences = 0;	// Number of total full revive sequences
	level.totalBleedersNotRevived = 0; // Number of AI bleeded to death
	level.avgTimeBetwenReviveSequnces = -1000; // Average time between two revives
	level.reviveTimeStamps = [];

	// average debug display
	level thread reviveDrawData();

	// dvar hud elements
	level thread reviveReadDvarChanges();
	
#/

}


// Run only once after the AI is spawned
revive_init()
{
	// Following variables are used for revive state management.
	self.a.revivedOnce = false; // Is AI revived once already, cant be revived again.
	self.a.reviveMe    = false; // AI is going to go down, pain animscript will put it down soon.
	self.a.falling	   = false; // AI is falling down to bleed
	self.a.bleeding	   = false;	// AI is down and bleeding already, to avoid bleeding again
	self.a.isReviver   = false; // AI is selected as a reviver and going to revive bleeding AI	  
	self.a.isReviving  = false; // Is AI reviving other bleeding AI
		
	// For scripter to control this behavior in the level
	self.a.canBleed    = true; 	// if turned off, AI will not become the bleeder.
	self.a.canRevive   = true;  // If turned off, AI will not become a reviver.
	
	self.a.reviver	   = undefined; // current reviver on bleeder.
	self.a.bleeder	   = undefined; // current bleeder on reviver.
	self.a.oldRevivers = [];		// Save old revivers of this bleeding AI
}

// --------------------------------------------------------------------------------
// ---- Main revive functionality handling wounded and reviver logic ----
// --------------------------------------------------------------------------------

// Decides if the AI can go down into reviveMe state
tryGoingDown(damage, hitloc)
{

	// If needed to turn of this feature, just uncomment this script.
	//if( !GetDvarInt( #"scr_aiReviveFeature") )
	//	return false;

	// Check if the revive feature is turned off
	Assert(IsDefined(level.reviveFeature), "level.reviveFeature is not initialized.");
	if(!level.reviveFeature)
		return false;

	// Check if the revive happened recently with a random roll
	if(!GetDvarInt( #"scr_aiReviveFeature")) // This will ensure that this will not run in test map.
	{
		if(!shouldReviveSequenceHappen())
			return false;
	}	

	if( !IsAI( self ) || !IsAlive(self) || (self.isdog) || (self.team != "axis") || (self.a.canBleed == false) || (self.a.pose == "back") )
		return false;

	// AI_TODO - Once prone is fixed, test the animations
	if( self.a.pose == "prone" )
		return false;
	
	// If AI is using turret (MG42/SAW) then should not bleed, can cause issues.
	if( IsDefined( self.a.usingTurret ) )
		return false;

	// If only couple of AI's alive at a given instance, then turn off revive.
	if(!GetDvarInt( #"scr_aiReviveFeature")) // This will ensure that this will not run in test map.
	{
		friendlies = GetAIArray(self.team);
		alive_nearby_ai = get_array_of_closest( self.origin, friendlies, undefined, undefined, anim.reviverPingDist );
		
		if( alive_nearby_ai.size <= 2 )
			return false;
	}
		
	// This AI can bleed if, 
	// 1. is not a reviver and on the way to revive a bleeder
	// 2. is not revived once already
	// 3. not already bleeding
	// 4. is about to die i.e damage is fatal
	// 5. is not damaged by headshot (head or helmet)
	// 6. is not on higher slopes, stairs, rocks where the reviving would not look good.
	// AI_TODO - Put the distance on the dvar for testing and tweaking

	if( (self.a.isreviver == false ) && (self.a.revivedOnce == false) && (self.a.reviveMe == false) && isAIDamageFatal(damage) && !damageLocation(hitloc) )
	{

		// Check for slopes, stairs and other things
		// Calculates predicted revive point.
		if( !IsReviveOnSafeTerrain() )
			return false;

		Assert(IsAlive(self) == true, "AI is already dead or in extended death and cant be put down.");
	
		// AI_TODO - Do we need to do something for explosive damage?
		// set the revive me flag
		self.a.reviveMe = true;

		// AI_TODO: remove hack (figure out how AI can get out of the revive script and try running, for example)
		self thread killMeOnScriptInterrupt();

		// modify the health so that the AI doesnt actually die.
		self.health = self.health + damage + RandomIntRange(60,100);
		return true;
	}

	// just do nothing
	return false;
}

killMeOnScriptInterrupt()
{
	self endon( "death" );

	self waittill( "killanimscript" ); // wait to get into pain
	self waittill( "killanimscript" ); // wait to get out of pain

	// somehow got interrupted, so just die
	if( self isBleeder() && IsAlive(self) )
	{
		self DoDamage( self.health + 200, self.origin );
	}
}


// Logic for reviver selection and animation setup for bleeder
// self = bleeder;
revive_strat()
{
	self endon("death");
	/#
	self animscripts\debug::debugPushState( "bleeder" );
	#/

	self endon("killanimscript");
	
	// Start a timer on AI for eventually bleed to death
	self thread bleeder_bleed_to_death();

	// Animation setup for the guy going down
	self thread fall_down_to_bleed();

	// waittill revived and got up and ready to go
	self waittill("ready_after_revived");

	/#
	self animscripts\debug::debugPopState();
	#/
}



// Chooses the best possible reviver 
reviver_selection_think(team)
{
	self endon("death");
	self endon("revived");
	self endon("reevaluate_reviver"); // In case this is going on already, makes sure that we dont have two threads
	self endon("killanimscript");
	
	Assert(IsAlive(self) == true, "AI is already dead or in extended death and cant be put down.");	

	if( self.a.revivedOnce != true )
	{
		// AI will be revived if	
		// 1. Not revived already i.e self.a.revivedOnce == true
		// 2. If a player is not within anim.reviverIgnorePlayerDist range
	
		// AI_TODO - Optimize player existance check.	
		self waittill_players_goes_away();
		
		// Continue the reviver finding process until a reviver is found.
		reviver_found = false;
	
		while(!reviver_found)
		{
			
			friendlies = GetAIArray( self.team );
			
			// Excluders are discarded/dead revivers, this list is sorted already, so just loop through it
			if( self.a.oldRevivers.size > 0 )
				ai = get_array_of_closest( self.origin, friendlies, self.a.oldRevivers, undefined, anim.reviverPingDist );
			else	
				ai = get_array_of_closest( self.origin, friendlies, undefined, undefined, anim.reviverPingDist );		
			
			for( i = 0; i < ai.size; i++ )
			{
				current_ai = ai[i];
	
				// This AI can be possible reviver if, 
				// 1. Not the old/discarded reviver of the fallen AI
				// 2. Within anim.reviverPingDist distance from the fallen AI
				// 3. Not the himself	
				// 4. Not reviving any other AI
				// 5. Not fallen down
				// 6. Can move to the fallen down AI
				// 7. CanRevive is set to true
				// 8. does not have ignore all set to true.
				// AI_TODO - Put the distance on the dvar for testing and tweaking
	
				if( isAIOldReviver( current_ai ) ||  ( current_ai.a.canRevive == false ) )
					continue;

				if( IsDefined( current_ai.ignoreall ) &&  current_ai.ignoreall == true )
					continue;
					
				if( ( current_ai != self ) && IsDefined( current_ai.a.revivedOnce ) && ( current_ai.a.reviveMe == false ) && ( current_ai.a.isReviver == false ) )	
				{
	
					// Make sure revive point is predicted at this point
					AssertEx(IsDefined(self.predictedRevivePoint), "Predicted revive point is not calculated.");
					
					// AI_TODO - Account for friendly fire lines and suppression and dividers
					if( findpath( current_ai.origin, self.predictedRevivePoint ) )					
					{
						// Tell this function that reviver is found
						reviver_found = true;
	
						// This AI is selected as reviver
						self.a.oldRevivers[self.a.oldRevivers.size] = current_ai;
	
						self.a.reviver = current_ai;
						current_ai.a.bleeder = self;					
/#
						// debug line between the reviver and revive point
						self.a.reviver thread reviveDrawDebugLineCross(self.predictedRevivePoint, (0,0,1), true);
#/
						// start the revive process
						self thread revive_process();
									
						break;
					}
				}
			}
			
			// Wait sometime before looking for another reviver if no reviver is found yet
			// Other wise this thread should end right away.
			if( !reviver_found )
				wait(2);	
		}

	}
}



// Actual revive process
// self = bleeder	
revive_process()
{
	// If the bleeder dies then this thread will end
	self endon("death");

	self.a.reviver thread reviver_think();
/#
	// debug printing
	self.a.reviver thread reviveDebugPrintThread();
#/
	// Handle bleeder death
	self thread handle_bleeder_death();

	// Handle reviver death, goal changed, bad path i.e if something invalidates his path
	self.a.reviver thread handle_reviver_death();
}



// Reviver waits until there is no player around the bleeder
waittill_players_goes_away()
{
	while( IsAlive(self) )
	{
		player = get_closest_player(self.origin);

		// AI_TODO - Add more checks to this decision process, like player firing the reviver.			
		if( DistanceSquared( player.origin, self.origin) > anim.reviverIgnorePlayerDistSq )
			break;
		
		wait(1); 
	}
}



// Logic if reviver dies, or somehow cant find a path
handle_reviver_death()
{
	self endon("revive_complete");
	self endon("bleeder_death");

	// waittill either of following happens to invalidate the reviver
	// AI_TODO - What should be done if the goal radius is changed	
	// AI_TODO - Handle goal changed and other level specific things
	self waittill_any( "death" );

	// Free the reviver
	self free_reviver("death");

	wait(0.05);

	if( IsDefined( self.a.bleeder ) &&  IsAlive(self.a.bleeder)) // Only care about the bleeder if he is alive
	{
		// Start the re-evaluation of the reviver if he is not revived already, else make him get up
		if( self.a.revivedOnce )
		{
			 self.a.bleeder thread bleeder_getup();
		}
		else
		{
			// play the bleed loop again	
			self .a.bleeder play_bleed_loop();
		 	self.a.bleeder thread reviver_selection_think(self.a.bleeder.team);
		}
	}
}




// Logic if the revivers goalradius changes by any other scripts
// self = reviver
handle_reviver_goal_change()
{
	self endon("revive_complete");
	self endon("bleeder_death");
	self endon("reevaluate_reviver");
	self endon("reviving_bleeder"); // While reviving the bleeder, if goal radius is changed then it doesn't matter.

	// AI_TODO
	self waittill_any("goalradius_changed");

	// Free the reviver
	self free_reviver("goalradius_changed");
	
	wait(0.05);

	if( IsDefined( self.a.bleeder ) && IsAlive(self.a.bleeder) ) // Only care about the bleeder if he is alive
	{

		// Start the re-evaluation of the reviver if he is not revived already, else make him get up
		if( self.a.revivedOnce )
			self.a.bleeder thread bleeder_getup(); // Ideally this should never be the case as this thread ends on "reviving_bleeder"
		else
			self.a.bleeder thread reviver_selection_think(self.a.bleeder.team);
	}
	    
}


handle_bleeder_death(reviver)
{
	self endon("revived");
	self endon("reevaluate_reviver");

	self waittill("death");

	// Tell the reviver that the bleeder died
	self.a.reviver notify("bleeder_death");

	// Free the reviver
	self.a.reviver free_reviver("bleeder_death");
	
}

// Handles the reviver process of going and reviving the wounded
//self = reviver
reviver_think()
{
	// if the reviver dies then this thread is going to end
	self endon("death");
	self endon("bleeder_death");
	self endon("reevaluate_reviver");
	
	self.a.isReviver = true;

	// waittill bleeder is fully on the ground
	while(!self.a.bleeder.a.bleeding)
	{
		wait(0.05);
	}
	
	// store the old radius
	self.ReviveOldgoalradius = self.goalradius;
	self.goalradius = 4;
	
	// watches for goal radius changed, this can happen in level script or in other animscripts
	//self thread watchGoalRadiusChanged();
	self thread handle_reviver_goal_change();

	// Get the revive animation
	revive_anim = getReviverReviveAnim();
	approach_angle = GetStartAngles( self.a.bleeder.origin, self.a.bleeder.angles, revive_anim );

	// recalculate the accurate revive point
	revive_point = getRevivePoint(self.a.bleeder);

/#
	self thread reviveDrawDebugLineCross(revive_point, (1,0,1), true);
#/

	self SetGoalPos(revive_point, approach_angle);
	self waittill("goal");
	
	self reviver_revive(revive_anim, revive_point);
}



// Frees the reviver if the revive is done or he gets invalidated
free_reviver(reason)
{
	self endon("death");

	// if the reviver is not dead then clear the variables on him
	if( IsDefined(self) )
	{
		self.a.isReviver  = false;
		self.a.isReviving = false;
		
		// Change the ignore flag back
		self.ignoreme = false;
	
		// Only reevaluate the reviver if current reviver died or his goal radius changed.
		if( IsDefined(reason) && ( (reason == "death") || (reason == "goalradius_changed" ) ) )
		{
			// relieve the reviver
			self notify("reevaluate_reviver");
			
			// tell the bleeder that he needs to re-evaluate
			self.a.bleeder notify("reevaluate_reviver");
		}

		// Reset the old goal radius if it was defined
		if( IsDefined(self.ReviveOldgoalradius) )
			self.goalradius = self.ReviveOldgoalradius;

		// AI_TODO - make sure he is alive and start the combat script on him.
		// AI_TODO - Forcing him into the combat exposed animscript. Need to do more than just calling this function here.
		if( IsAlive(self) && IsDefined(reason) && reason != "death" )
		{
			/#
			debug_replay("revive.gsc freeReviver()");
			#/
			self notify( "killanimscript" );
			waittillframeend;
			self thread call_overloaded_func( "animscripts\combat", "main" );	
		}
	}
}


// After bleeder is revived, restores him into combat
free_bleeder()
{
	self endon("death");

	if (IsDefined(self))
	{
		self.a.reviveMe = false;
		self.a.bleeding = false;
		self.a.falling = false;

		// Give some health back to the AI
		self.health = RandomIntRange(90, 120);

		// let the script know that AI is ready to go
		self notify("ready_after_revived");

		// set his special death back to normal
		if( IsDefined( self.a.special ) && self.a.special == "bleeder_death" )
			self.a.special = "none";		
				
		// AI_TODO - make sure he is alive and start the combat script on him.
		// AI_TODO - Forcing him into the combat exposed animscript. Need to do more than just calling this function here.
		/#
		debug_replay("revive.gsc freeBleeder()");
		#/
		
		if( IsAlive(self) )
		{
			self notify( "killanimscript" );
			waittillframeend;
			self thread call_overloaded_func( "animscripts\combat", "main" );
		}
	}
}



// Animation setup for the reviver
// self = reviver
reviver_revive(revive_anim, revive_point)
{
	self endon("bleeder_death");

	self.a.isReviving = true;
	bleeder = self.a.bleeder;

	// Used to kill the bleed out thread on the bleeder.
	bleeder notify("being_revived");

	// Used to stop the goalradius_changed thread on the reviver.
	self notify("reviving_bleeder"); 

	// Ignore this AI for a bit
	self.ignoreme = true;

	// reset the timer as there is a revive sequence here.
	resetReviveSequenceTimer();

	// Bleeder is being revived now, change its animation set.
	bleeder SetFlaggedAnimKnob( "being_revived", getBleederReviveAnim(), 1, 0.1, 1 );
	
	// AI_TODO - Fix the issues related to the non-responsive state of the reviver.
	self AnimScripted( "revive", bleeder.origin, bleeder.angles, revive_anim, "normal", %body, 1 );

	//angles = VectorToAngles( revive_point - self.a.bleeder.origin );
	//self OrientMode( "face angle", angles[1] );
	//self SetFlaggedAnimKnobAllRestart("revive", revive_anim, %body, 1, 0.1, 1.0 );

	self animscripts\shared::DoNoteTracks("revive", ::handleReviverNotetracks);

	// notify both the reviver the revive is done.
	self notify("revive_complete");	

/#
	// Store the level timestamps for debugging.
	level.reviveTimeStamps[level.reviveTimeStamps.size] = GetTime();
	level.totalReviveSequences++;
	reviveAvgTimeCalculation();
#/  

	// start get up animations for both reviver and the bleeder
	self revive_getup_process();
}

// Plays the after revive get up animations
// self = reviver
revive_getup_process()
{
	self.a.bleeder thread bleeder_getup();
	self animcustom( ::reviver_getup );
}


bleeder_getup()
{
	self SetFlaggedAnimKnobAllRestart( "bleeder_get_up", getBleederGetUpAnim(), %body ,1, 0.1, 1.0 );
	self animscripts\shared::DoNoteTracks( "bleeder_get_up" );

	self free_bleeder();
}



reviver_getup()
{
	self SetFlaggedAnimKnobAllRestart( "reviver_get_up", getReviverGetUpAnim(), %body, 1, 0.1, 1.0 );
	self animscripts\shared::DoNoteTracks( "reviver_get_up" );

	self free_reviver("revive_complete");
}



// If bleeder AI is not revived then after certain time this function kills the AI
bleeder_bleed_to_death()
{
	// AI should continue bleeding until completely revived.
	// If AI stops bleeding while being revived, and reviver dies, then bleeder AI would not die.
	self endon("revived");
	
	self.bleedOutTime = RandomIntRange(anim.bleederBleedOutTimeMin,anim.bleederBleedOutTimeMax);

/#
	// Debug bleeder print
	self thread bleederDebugPrintThread();
	level.totalBleedersNotRevived++;

#/

	// AI_TODO - Put this on a level timer
	wait( self.bleedOutTime/1000 );
		
	// If AI is being revived by the reviver, then increase the timer?
	// AI_TODO - Special death animations
	if( IsDefined(self) && IsAlive(self) )
		self DoDamage( self.health + 200, self.origin );
}


// Handles animations for the downed/fallen AI
// self = bleeder;
fall_down_to_bleed()
{
	self endon("death");
	self endon("revived");
	self endon("being_revived");
	self endon("killanimscript");
		
	self SetAnimKnobAll( %revive, %body, 1, 0.1, 1 );

	transAnim = getTransitionAnim();

	// This AI is falling down to bleed	
	self.a.falling = true;
	
	self SetFlaggedAnimKnob( "fall_transition", transAnim, 1, 0.1, 1.5 );
	self thread handleBleederNotetracks("fall_transition"); // invokes the reviver selection process
	self animscripts\shared::DoNoteTracks( "fall_transition");

	Assert( self.a.pose == "back", "Fall transition animation is missing the anim_pose = back notetrack." );
	self ClearAnim(transAnim, 0.2);

	// This AI started bleeding and not falling down anymore
	// we still dont need to reset the flag as it happens in free bleeder functions
	self.a.bleeding = true;

	// play the bleed loop	
	self play_bleed_loop();

}

// Plays the bleed looping animation
play_bleed_loop()
{
	self SetFlaggedAnimKnobAllRestart( "bleeding", getBleedLoopAnim(), %body ,1, 0.1, 1.0 );
}


// --------------------------------------------------------------------------------
// ---- Notetrack Functions for Revive feature ----
// --------------------------------------------------------------------------------

handleBleederNotetracks(anim_name)
{
	self endon("death");

	for (;;)
	{
		self waittill(anim_name, note);
		
		switch ( note )
		{
			case "reviver_selection":
			{
				self thread reviver_selection_think(self.team);
				break;
			}
			case "anim_pose = \"back\"":
			{
				// AI_TODO - To handle special deaths, specifically for downed AI.
				self.a.special = "bleeder_death";
				break;
			}
		}

		if(note == "end")
		{
			break;
		}	
	}
}


handleReviverNotetracks(note)
{
	switch ( note )
	{
		// AI nearby hears this and is aware of the bleeding AI.
		case "attach_bandage":
		{
			bleeder = self.a.bleeder;

			bleeder Attach("char_rus_bandages1");
		
			// As the bandage is applied, we can safely assume that the bleeder is revived.
			// This will make sure that the bleeder	will not be looking for new reviver
			// even though the current reviver died.
			bleeder.a.revivedOnce = true;
			
			// Tell the bleeder AI that he is revived
			bleeder notify("revived"); 
	
			break;
		}
	}
}

// --------------------------------------------------------------------------------
// ---- Animation Functions for Revive feature ----
// --------------------------------------------------------------------------------

// Get the transition animation based on the pose.
getTransitionAnim()
{
	assert( self.a.pose == "stand" || self.a.pose == "crouch" || self.a.pose == "prone" );
	
	//AI_TODO - Add randomness and variety to the animations.
	transitionAnim = anim.bleed[self.a.pose]["fall"];

	Assert(animHasNoteTrack( transitionAnim, "anim_pose = \"back\"" ));
	Assert(animHasNoteTrack( transitionAnim, "reviver_selection" ));

	return transitionAnim;
}


// Bleeding loop animation
getBleedLoopAnim()
{
	//AI_TODO - Add randomness and variety to the animations.
	bleedLoopAnim = anim.bleed["bleed_loop"];

	return bleedLoopAnim;
}

// bleeder is being revived
getBleederReviveAnim()
{
	reviveAnim = anim.bleed["left"]["being_revived"];
		
	return reviveAnim;
}

// reviver is reviving
getReviverReviveAnim()
{
	reviveAnim = anim.revive["left"]["reviving"];
	
	Assert(animHasNoteTrack( reviveAnim, "anim_pose = \"crouch\"" ));
	Assert(animHasNoteTrack( reviveAnim, "attach_bandage" ));
	
	return reviveAnim;
}

// bleeder getting up
getBleederGetUpAnim()
{
	bleederGetUpAnim = anim.bleed["left"]["get_up"];
	
	Assert(animHasNoteTrack( bleederGetUpAnim, "anim_pose = \"stand\"" ));

	return bleederGetUpAnim;
}

// reviver getting up
getReviverGetUpAnim()
{
	reviverGetUpAnim = anim.revive["left"]["get_up"];
	
	Assert(animHasNoteTrack( reviverGetUpAnim, "anim_pose = \"stand\"" ));

	return reviverGetUpAnim;	
}


// --------------------------------------------------------------------------------
// ---- Utility Functions for Revive feature ----
// --------------------------------------------------------------------------------

// Returns true if its a headshot.
damageLocation(hitloc)
{
	// Cant be either head or helmet, cause that might be a headshot
	if( hitloc == "helmet" || hitloc == "head" )
		return true;

	return false;
}


// Returns true if this ai was one of the discarded revivers
isAIOldReviver(ai)
{
	if( self.a.oldRevivers.size > 0 )
	{
		for( i = 0; i < self.a.oldRevivers.size; i++ )
		{
			if( IsDefined( self.a.oldRevivers[i] ) && self.a.oldRevivers[i] == ai )
				return true;
		}	
	
	}

	return false;
}



// Get the start origin of the revive animation
getRevivePoint(bleeder)
{
	// AI_TODO - Need to add some logic for which animation to play
	revive_point = GetStartOrigin(bleeder.origin, bleeder.angles, getReviverReviveAnim() );
	
	return revive_point;
}

// Checks for sloped surfaces
//self = bleeder
IsReviveOnSafeTerrain()
{
	self endon("death");
	
	// AI_TODO - This may not work well if we have feet IK, find out. Talk to John Yuill.
	// AI_TODO - Account for dynamic revive point selection

	// get the distance from ground
	groundPos = physicstrace( self.origin, self.origin - ( 0, 0, 10000 ) );
	bleederDistanceFromGround = distance( self.origin, groundPos );
	
	// If the distance from ground is big then guys is floating, cant bleed
	// If somehow AI is in ground already then dont bleed
	if( ( bleederDistanceFromGround > 2 ) || ( bleederDistanceFromGround < 0 ) )
		return false;

	// Check if the bleeder origin is going to end up in Solid
	angleDelta = getAngleDelta(anim.bleed[self.a.pose]["fall"], 0, 1);
	finalYaw   = self.angles[1] + angleDelta;
	finalAngles = ( self.angles[0], finalYaw, self.angles[2] );

	moveDelta = GetMoveDelta( anim.bleed[self.a.pose]["fall"], 0, 1 ); 
	endPoint = self localToWorldCoords( moveDelta );
/#
	// draw the predicted revive point
	self thread reviveDrawDebugLineCross(endPoint, (0,1,0));
#/
	// If AI cant move to that point means it might be in solid, dont take chances as this might look bad.
	if( !self mayMoveToPoint( endPoint ) )
		return false; 
	
	// Get the revive point based off of animations
	self.predictedRevivePoint = getPredictedRevivePoint( endPoint, finalAngles );
			
	// Get the distance from ground
	groundPos = physicstrace( self.predictedRevivePoint, self.predictedRevivePoint - ( 0, 0, 10000 ) );
	revivePointDistanceFromGround = distance( self.predictedRevivePoint, groundPos );
	
	if( revivePointDistanceFromGround < 0 || revivePointDistanceFromGround > 15 ) // revive point is negative and in ground
		return false;

	diff = abs( bleederDistanceFromGround - revivePointDistanceFromGround );

	if( diff > 15 ) // then difference is too much
		return false;
	
	return true;
}




// predicts the revive point before actual revive is kicked off
//self = bleeder
getPredictedRevivePoint( endPoint, finalAngles )
{

	// AI_TODO - Revive point calculation based on different points in revive animations i.e left, right, head, toe
	revive_point = GetStartOrigin(endPoint, finalAngles, getReviverReviveAnim());

/#
	// draw the predicted revive point
	self thread reviveDrawDebugLineCross(revive_point, (1,0,0));
#/
	
	return revive_point;
}



// Checks if the damage is fatal 
isAIDamageFatal(damage)
{
	Assert(IsAlive(self) == true, "AI is already dead or in extended death and cant be put down.");	

	health = self.health - damage;

	//AI_TODO - Think about random logic here?
	if( health <= 0 )
		return true;

	return false;
}


// Decides if AI should bleed
shouldBleed()
{
	self endon("death");

	Assert(IsAlive(self) == true, "AI is already dead or in extended death and cant be put down.");
	Assert(IsAlive(self.a.revivedOnce) == false, "AI is already revived/bleeded once.");
		
	// AI should bleed if it has reviveMe set on him and its not already bleeding or falling to bleed
	if( ( self.a.reviveMe == true ) && ( self.a.bleeding == false ) && ( self.a.falling == false ) )
		return true;

	return false;
}



// Check if the AI is bleeding or falling to bleed
isBleedingOrFalling()
{
	Assert(IsAlive(self) == true, "AI is already dead or in extended death and cant be put down.");	

	
	if( (self.a.bleeding == true) || (self.a.falling == true) )
		return true;

	return false;
}

// Reviver timer
shouldReviveSequenceHappen()
{
	// Check reviver timer
	if ( GetTime() < anim.nextReviveSequenceTime )
	{
		return false;
	}

	// If the timer allows us then random roll
	// AI_TODO - Control this random value per level basis?
	if( ( randomint(100) > 40 ) )
		return false;


	return true;
}


resetReviveSequenceTimer()
{
	// Check if any of the players are nearby
	// AI_TODO - Use isbeingwatched functionality here.
	players = GetPlayers();
	anybody_nearby = 0;
	for (i=0;i<players.size;i++)
	{
		if ( IsDefined(players[i]) && DistanceSquared( self.origin, players[i].origin ) < anim.reviveSequencePlayerVisibleDistSq )
		{
			anybody_nearby = 1;
			break;
		}
	}

	// if the player has seen this sequence then set the timer higher
	if ( anybody_nearby )
	{
		anim.nextReviveSequenceTime = GetTime() + RandomIntRange( anim.nextReviveSequencePlayerTimeMin, anim.nextReviveSequencePlayerTimeMax );
	}
	else
	{
		anim.nextReviveSequenceTime = GetTime() + RandomIntRange( anim.nextReviveSequenceTimeMin, anim.nextReviveSequenceTimeMax );
	}
}


// --------------------------------------------------------------------------------
// ---- Scripter control functions for Revive feature ----
// --------------------------------------------------------------------------------

isReviverOrBleeder()
{
	if(IsDefined(self) & IsAI(self))
	{
		if(self.a.isReviver || self.a.reviveMe)
			return true;
	}
	
	return false;
}

isBleeder()
{
	if(IsDefined(self) & IsAI(self))
	{
		if( self.a.reviveMe )
			return true;
	}
	
	return false;
}


// --------------------------------------------------------------------------------
// ---- Debug functions for Revive feature ----
// --------------------------------------------------------------------------------

/#
// Draw the bleeder
bleederDebugPrintThread()
{
	self endon("death");
	self endon("revived");
	
	if( GetDvar( #"ai_reviveDebug") != "1" )
		return;

	totalTime = GetTime() + self.bleedOutTime;

	while(1)
	{
		time = (totalTime - GetTime()) / 1000;
	
		Print3d(self.origin + (0,0,60),"Bleeder " + time, ( 1,1,1 ), 1, 1);
		wait .05;
	}
}


// Debug lines - Threaded on the reviver or the bleeder
reviveDrawDebugLineCross(revive_point, color, drawline)
{
	self endon("death");
	self endon("reevaluate_reviver");
	self endon("revive_complete");
	self endon("bleeder_death");
	self endon("revived");
		
	if( GetDvar( #"ai_reviveDebug") != "1" )
		return;

	while(1)
	{
		if(IsDefined(drawline) && (drawline == true ))
		{
			Line(self.origin, revive_point, (0,1,0));
		}

		drawDebugCross(revive_point, 1, color, .6);
		wait(0.05);
	}
}

// Draw the reviver 
reviveDebugPrintThread()
{
	self endon("death");
	self endon("reevaluate_reviver");
	self endon("revive_complete");
	self endon("bleeder_death");

	if( GetDvar( #"ai_reviveDebug") != "1" )
		return;
	
	while(1)
	{
		Print3d(self.origin + (0,0,60),"Reviver" , (1,1,1), 1, 1);
		wait(0.05);
	}
}

// Draw average
reviveAvgTimeCalculation()
{
	samples = [];
	total = 0;

	if ( level.reviveTimeStamps.size <= 2 )
		return;

	for( i=0; i<level.reviveTimeStamps.size - 1; i++ )
	{
		samples[samples.size] = abs(level.reviveTimeStamps[i] - level.reviveTimeStamps[i+1]);
	}

	// calculate the average
	for( i=0; i<samples.size; i++ )
	{
		total += samples[i];
	}

	total = total / 1000;

	level.avgTimeBetwenReviveSequnces = total/samples.size;
}

// average debug display
reviveDrawData()
{
	while(1)
	{
		// Just for testing 
		if( GetDvar( #"ai_reviveDebug") != "1" )
		{
			wait(0.05);

			// destroy the hud
			if(IsDefined(level.reviveAvg))
			{
				level.reviveAvgText Destroy();
				level.reviveAvg Destroy();
				level.reviveTotalText Destroy();
				level.reviveTotal Destroy();
				level.PlayerRangeMinText Destroy();
				level.PlayerRangeMin Destroy();	
				level.PlayerRangeMaxText Destroy();
				level.PlayerRangeMax Destroy();
				level.RangeMinText Destroy();
				level.RangeMin Destroy();
				level.RangeMaxText Destroy();
				level.RangeMax Destroy();
				level.BleedRangeMinText Destroy();
				level.BleedRangeMin Destroy();
				level.BleedRangeMaxText Destroy();
				level.BleedRangeMax Destroy();
				level.PingDistText Destroy();
				level.PingDist Destroy();
				level.PlayerIgnoreDistText Destroy();
				level.PlayerIgnoreDist Destroy();
				level.PlayerVisDistText Destroy();
				level.PlayerVisDist Destroy();
			}

			continue;
		}

		if(!isdefined(level.reviveAvg))
		{
			// average
			level.reviveAvgText = NewHudElem(); 
			level.reviveAvgText.alignX = "left";
			level.reviveAvgText.horzAlign = "left";
			level.reviveAvgText.x = 10; 
			level.reviveAvgText.y = 100;
			level.reviveAvgText.fontscale = 1;
			level.reviveAvgText.color = ( 0.8, 1, 0.8 );
	
			level.reviveAvg = NewHudElem(); 
			level.reviveAvg.alignX = "left";
			level.reviveAvg.horzAlign = "left";
			level.reviveAvg.x = 60; 
			level.reviveAvg.y = 100;
			level.reviveAvg.fontscale = 1;
			level.reviveAvg.color = ( 0.8, 1, 0.8 );
	
			// total revives		
			level.reviveTotalText = NewHudElem(); 
			level.reviveTotalText.alignX = "left";
			level.reviveTotalText.horzAlign = "left";
			level.reviveTotalText.x = 10; 
			level.reviveTotalText.y = 120;
			level.reviveTotalText.fontscale = 1;
			level.reviveTotalText.color = ( 0.8, 1, 0.8 );
		
			level.reviveTotal = NewHudElem(); 
			level.reviveTotal.alignX = "left";
			level.reviveTotal.horzAlign = "left";
			level.reviveTotal.x = 40; 
			level.reviveTotal.y = 120;
			level.reviveTotal.fontscale = 1;
			level.reviveTotal.color = ( 0.8, 1, 0.8 );
	
			// revive player min and max range	
			level.PlayerRangeMinText = NewHudElem(); 
			level.PlayerRangeMinText.alignX = "left";
			level.PlayerRangeMinText.horzAlign = "left";
			level.PlayerRangeMinText.x = 10; 
			level.PlayerRangeMinText.y = 140;
			level.PlayerRangeMinText.fontscale = 1;
			level.PlayerRangeMinText.color = ( 0.8, 1, 0.8 );
	
			level.PlayerRangeMin = NewHudElem(); 
			level.PlayerRangeMin.alignX = "left";
			level.PlayerRangeMin.horzAlign = "left";
			level.PlayerRangeMin.x = 130; 
			level.PlayerRangeMin.y = 140;
			level.PlayerRangeMin.fontscale = 1;
			level.PlayerRangeMin.color = ( 0.8, 1, 0.8 );
					
	
			level.PlayerRangeMaxText = NewHudElem(); 
			level.PlayerRangeMaxText.alignX = "left";
			level.PlayerRangeMaxText.horzAlign = "left";
			level.PlayerRangeMaxText.x = 10; 
			level.PlayerRangeMaxText.y = 160;
			level.PlayerRangeMaxText.fontscale = 1;
			level.PlayerRangeMaxText.color = ( 0.8, 1, 0.8 );
	
			level.PlayerRangeMax = NewHudElem(); 
			level.PlayerRangeMax.alignX = "left";
			level.PlayerRangeMax.horzAlign = "left";
			level.PlayerRangeMax.x = 130; 
			level.PlayerRangeMax.y = 160;
			level.PlayerRangeMax.fontscale = 1;
			level.PlayerRangeMax.color = ( 0.8, 1, 0.8 );
	
			// revive min and max range
			level.RangeMinText = NewHudElem(); 
			level.RangeMinText.alignX = "left";
			level.RangeMinText.horzAlign = "left";
			level.RangeMinText.x = 10; 
			level.RangeMinText.y = 180;
			level.RangeMinText.fontscale = 1;
			level.RangeMinText.color = ( 0.8, 1, 0.8 );	
	
			level.RangeMin = NewHudElem(); 
			level.RangeMin.alignX = "left";
			level.RangeMin.horzAlign = "left";
			level.RangeMin.x = 120; 
			level.RangeMin.y = 180;
			level.RangeMin.fontscale = 1;
			level.RangeMin.color = ( 0.8, 1, 0.8 );
	
	
			level.RangeMaxText = NewHudElem(); 
			level.RangeMaxText.alignX = "left";
			level.RangeMaxText.horzAlign = "left";
			level.RangeMaxText.x = 10; 
			level.RangeMaxText.y = 200;
			level.RangeMaxText.fontscale = 1;
			level.RangeMaxText.color = ( 0.8, 1, 0.8 );
	
			level.RangeMax = NewHudElem(); 
			level.RangeMax.alignX = "left";
			level.RangeMax.horzAlign = "left";
			level.RangeMax.x = 120; 
			level.RangeMax.y = 200;
			level.RangeMax.fontscale = 1;
			level.RangeMax.color = ( 0.8, 1, 0.8 );
				
			// bleed out range
			level.BleedRangeMinText = NewHudElem(); 
			level.BleedRangeMinText.alignX = "left";
			level.BleedRangeMinText.horzAlign = "left";
			level.BleedRangeMinText.x = 10; 
			level.BleedRangeMinText.y = 220;
			level.BleedRangeMinText.fontscale = 1;
			level.BleedRangeMinText.color = ( 0.8, 1, 0.8 );				
	
			level.BleedRangeMin = NewHudElem(); 
			level.BleedRangeMin.alignX = "left";
			level.BleedRangeMin.horzAlign = "left";
			level.BleedRangeMin.x = 120; 
			level.BleedRangeMin.y = 220;
			level.BleedRangeMin.fontscale = 1;
			level.BleedRangeMin.color = ( 0.8, 1, 0.8 );				
	
			level.BleedRangeMaxText = NewHudElem(); 
			level.BleedRangeMaxText.alignX = "left";
			level.BleedRangeMaxText.horzAlign = "left";
			level.BleedRangeMaxText.x = 10; 
			level.BleedRangeMaxText.y = 240;
			level.BleedRangeMaxText.fontscale = 1;
			level.BleedRangeMaxText.color = ( 0.8, 1, 0.8 );	
	
			level.BleedRangeMax = NewHudElem(); 
			level.BleedRangeMax.alignX = "left";
			level.BleedRangeMax.horzAlign = "left";
			level.BleedRangeMax.x = 120; 
			level.BleedRangeMax.y = 240;
			level.BleedRangeMax.fontscale = 1;
			level.BleedRangeMax.color = ( 0.8, 1, 0.8 );
	
			// reviver ping distance
			level.PingDistText = NewHudElem(); 
			level.PingDistText.alignX = "left";
			level.PingDistText.horzAlign = "left";
			level.PingDistText.x = 10; 
			level.PingDistText.y = 260;
			level.PingDistText.fontscale = 1;
			level.PingDistText.color = ( 0.8, 1, 0.8 );
	
			level.PingDist = NewHudElem(); 
			level.PingDist.alignX = "left";
			level.PingDist.horzAlign = "left";
			level.PingDist.x = 120; 
			level.PingDist.y = 260;
			level.PingDist.fontscale = 1;
			level.PingDist.color = ( 0.8, 1, 0.8 );
	
			// reviver player ignore distance
			level.PlayerIgnoreDistText = NewHudElem(); 
			level.PlayerIgnoreDistText.alignX = "left";
			level.PlayerIgnoreDistText.horzAlign = "left";
			level.PlayerIgnoreDistText.x = 10; 
			level.PlayerIgnoreDistText.y = 280;
			level.PlayerIgnoreDistText.fontscale = 1;
			level.PlayerIgnoreDistText.color = ( 0.8, 1, 0.8 );	
	
			level.PlayerIgnoreDist = NewHudElem(); 
			level.PlayerIgnoreDist.alignX = "left";
			level.PlayerIgnoreDist.horzAlign = "left";
			level.PlayerIgnoreDist.x = 120; 
			level.PlayerIgnoreDist.y = 280;
			level.PlayerIgnoreDist.fontscale = 1;
			level.PlayerIgnoreDist.color = ( 0.8, 1, 0.8 );				
	
			// player visibility distance
			level.PlayerVisDistText = NewHudElem(); 
			level.PlayerVisDistText.alignX = "left";
			level.PlayerVisDistText.horzAlign = "left";
			level.PlayerVisDistText.x = 10; 
			level.PlayerVisDistText.y = 300;
			level.PlayerVisDistText.fontscale = 1;
			level.PlayerVisDistText.color = ( 0.8, 1, 0.8 );	
	
			level.PlayerVisDist = NewHudElem(); 
			level.PlayerVisDist.alignX = "left";
			level.PlayerVisDist.horzAlign = "left";
			level.PlayerVisDist.x = 120; 
			level.PlayerVisDist.y = 300;
			level.PlayerVisDist.fontscale = 1;
			level.PlayerVisDist.color = ( 0.8, 1, 0.8 );
			
		}
	
		// Average
		level.reviveAvgText SetText("Average :");

		if(level.avgTimeBetwenReviveSequnces > 0)
		{			
			level.reviveAvg SetValue(level.avgTimeBetwenReviveSequnces);
		}

		// Total
		level.reviveTotalText SetText("Total :");
		level.reviveTotal SetValue(level.totalReviveSequences);

		// player range
		level.PlayerRangeMinText SetText("RevivePlayerMinRange :");
		level.PlayerRangeMin SetValue(anim.nextReviveSequencePlayerTimeMin);
		level.PlayerRangeMaxText SetText("RevivePlayerMaxRange :");
		level.PlayerRangeMax SetValue(anim.nextReviveSequencePlayerTimeMax);

		// range
		level.RangeMinText SetText("ReviveMinRange :"); 
		level.RangeMin SetValue(anim.nextReviveSequenceTimeMin);
		level.RangeMaxText SetText("ReviveMaxRange :"); 
		level.RangeMax SetValue(anim.nextReviveSequenceTimeMax); 

		// bleed out range
		level.BleedRangeMinText SetText("BleedOutMinRange :"); 
		level.BleedRangeMin SetValue(anim.bleederBleedOutTimeMin);
		level.BleedRangeMaxText SetText("BleedOutMaxRange :"); 
		level.BleedRangeMax SetValue(anim.bleederBleedOutTimeMax);

		// reviver ping distance
		level.PingDistText SetText("ReviverPingDist :"); 
		level.PingDist SetValue(anim.reviverPingDist);
		
		// reviver player ignore distance
		level.PlayerIgnoreDistText SetText("PlayerIgnoreDist :");
		level.PlayerIgnoreDist SetValue(GetDvarInt( #"ai_reviverIgnorePlayerDist"));
		
		// player visibility distance
		level.PlayerVisDistText SetText("PlayerVisDist :");
		level.PlayerVisDist SetValue(GetDvarInt( #"ai_reviveSeqPlayerVisibleDist"));
				
		wait(0.05);
	}	
}


// Reads the dvar changes
reviveReadDvarChanges()
{
	while(1)
	{
		// Just for testing 
		if( GetDvar( #"ai_reviveDebug") != "1" )
		{
			wait(0.05);
			continue;
		}

		anim.nextReviveSequencePlayerTimeMin = GetDvarInt( #"ai_reviveSeqTimePlayerMin") * 1000; // minimum time range after player has seen last revive sequence
		anim.nextReviveSequencePlayerTimeMax = GetDvarInt( #"ai_reviveSeqTimePlayerMax") * 1000; // maximum time range after player has seen last revive sequence
		
		AssertEx( ( anim.nextReviveSequencePlayerTimeMin < anim.nextReviveSequencePlayerTimeMax ), "Min value for player based revive time should be smaller than max value" );

		anim.nextReviveSequenceTimeMin = GetDvarInt( #"ai_reviveSeqTimeMin") * 1000; // minimum time range after last revive sequence
		anim.nextReviveSequenceTimeMax = GetDvarInt( #"ai_reviveSeqTimeMax") * 1000; // maximum time range after last revive sequence

		AssertEx( ( anim.nextReviveSequenceTimeMin < anim.nextReviveSequenceTimeMax ), "Min value for revive time range should be smaller than max value" );	

		anim.bleederBleedOutTimeMin =  GetDvarInt( #"ai_bleederBleedOutTimeMin") * 1000; // bleeder bleed out range min
		anim.bleederBleedOutTimeMax =  GetDvarInt( #"ai_bleederBleedOutTimeMax") * 1000; // bleeder bleed out range max	
		
		AssertEx( ( anim.bleederBleedOutTimeMin < anim.bleederBleedOutTimeMax ), "Min value for bleed out time range should be smaller than max value" );	
	
		// Revive related constants
		anim.reviverPingDist = GetDvarInt( #"ai_reviverPingDist"); // Bleeder will search for reviver in this distance.
		anim.reviverIgnorePlayerDistSq = GetDvarInt( #"ai_reviverIgnorePlayerDist")*GetDvarInt( #"ai_reviverIgnorePlayerDist"); // Bleeder will not be revived until there is a player within this range.
		anim.reviveSequencePlayerVisibleDistSq = GetDvarInt( #"ai_reviveSeqPlayerVisibleDist")*GetDvarInt( #"ai_reviveSeqPlayerVisibleDist"); // Assuming that players within this range will be able to get a glance of revive sequence.

		wait(1);
	}
}


#/
