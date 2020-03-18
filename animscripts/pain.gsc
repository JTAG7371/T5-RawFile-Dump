#include animscripts\Utility;
#include animscripts\weaponList;
#include common_scripts\utility;
#include animscripts\anims;
#include animscripts\Combat_Utility;
#include maps\_utility;

#using_animtree ("generic_human");

main()
{
	if ( self animscripts\balcony::tryBalcony() )
	{
		return;
	}
	
	// AI revive feature - AI will bleed instead on pain
	if( self animscripts\revive::shouldBleed() )
	{
		self animscripts\revive::revive_strat();
		return;	
	}

	// AI revive feature - if AI is already bleeding then avoid pain
	if( self animscripts\revive::isBleedingOrFalling() )
	{
		// important that we don't run any other animscripts.
		self waittill("killanimscript");
		return;
	}

	self SetFlashBanged(false);
	
	// MikeD (10/9/2007): Stop the flamethrower AI from shooting, in utility.gsc
	self flamethrower_stop_shoot();
	
	if ( IsDefined( self.longDeathStarting ) )
	{
		// important that we don't run any other animscripts.
		self waittill("killanimscript");
		return;
	}

	if ( [[ anim.pain_test ]]() )
	{
		return;	
	}

	if ( self.a.disablePain )
	{
		return;
	}
	
	self notify( "kill_long_death" );
		
	self.a.painTime = GetTime();

	if( self.a.flamepainTime > self.a.painTime )
	{
		return;
	}

	// JamesS (8/8/08): no more lame pain anims for enemy AI, also disabled the slow damage burn in code
	// because it causes guys to spontaneously combust all of the sudden later.
	/*if( self.team == "axis" && IsDefined( self.damagemod ) && self.damagemod == "MOD_BURNED" )
	{
	return;
	}*/

	if (self.a.nextStandingHitDying)
	{
		self.health = 1;
	}

	dead = false;
	stumble = false;	
	
	ratio = self.health / self.maxHealth;
	
//	println ("hit at " + self.damagelocation);
	
    self trackScriptState( "Pain Main", "code" );
    self notify ("anim entered pain");
	self endon("killanimscript");

	// Two pain animations are played.  One is a longer, detailed animation with little to do with the actual 
	// location and direction of the shot, but depends on what pose the character starts in.  The other is a 
	// "hit" animation that is very location-specific, but is just a single pose for the affected bones so it 
	// can be played easily whichever position the character is in.
    animscripts\utility::initialize("pain");
    
    self AnimMode("gravity");

	//thread [[anim.println]] ("Shot in "+self.damageLocation+" from "+self.damageYaw+" for "+self.damageTaken+" hit points");#/

	self animscripts\face::SayGenericDialogue("pain");
	
	if ( self.damageLocation == "helmet" )
	{
		self animscripts\death::helmetPop();
		self PlaySound( "prj_bullet_impact_headshot_helmet_nodie" );
	}

	if( ratio < 0.75 && IsDefined(level.setup_wounded_anims_callback) )
	{
		self [[level.setup_wounded_anims_callback]]();
	}
	
	// MJD - helmetPop on explosive damage causes aim assert (cod4 integrate)
	//else if ( self wasDamagedByExplosive() && RandomInt(2) == 0 )
	//	self animscripts\death::helmetPop();

	// corner grenade death takes priority over crawling pain
	/#
	if ( GetDvarInt( #"scr_forceCornerGrenadeDeath" ) == 1 )
	{
		if ( self TryCornerRightGrenadeDeath() )
		{
			return;
		}
	}
	#/

	if ( self.a.special == "corner_right_mode_b" && TryCornerRightGrenadeDeath() )
	{
		return;
	}
	
	if ( crawlingPain() )
	{
		return;
	}
	
	if ( specialPain( self.a.special ) )
	{
		return;
	}

	// if we didn't handle self.a.special, we can't rely on it being accurate after the pain animation we're about to play.
	self.a.special = "none";

	//self thread PlayHitAnimation();

	painAnim = getPainAnim();
	
	/#
	if ( GetDvarInt( #"scr_paindebug") == 1 )
	{
		println( "^2Playing pain: ", painAnim, " ; pose is ", self.a.pose );
	}
	#/
	
	playPainAnim( painAnim );
}

isExplosiveDamageMOD( mod )
{
	if( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
	{
		return true;
	}

	return false;
}

wasDamagedByExplosive()
{	
	if ( isExplosiveDamageMOD( self.damageMod ) )
	{
		self.mayDoUpwardsDeath = (self.damageTaken > 300); // TODO: is this a good value?
		return true;
	}

	if ( GetTime() - anim.lastCarExplosionTime <= 50 )
	{
		rangesq = anim.lastCarExplosionRange * anim.lastCarExplosionRange * 1.2 * 1.2;
		if ( DistanceSquared( self.origin, anim.lastCarExplosionDamageLocation ) < rangesq )
		{
			// assume this exploding car damaged us.
			upwardsDeathRangeSq = rangesq * 0.5 * 0.5;
			self.mayDoUpwardsDeath = (DistanceSquared( self.origin, anim.lastCarExplosionLocation ) < upwardsDeathRangeSq );
			return true;
		}
	}

	return false;
}

getPainAnim()
{
	if ( self.a.pose == "stand" )
	{
		// MikeD (9/27/2007): New flamethrower pains
		if( IsDefined( self.damagemod ) && self.damagemod == "MOD_BURNED" )
		{
			return get_flamethrower_pain();
		}
		else if ( self.a.movement == "run" && (self getMotionAngle()<60) && (self getMotionAngle()>-60) )
		{
			if( self.damageWeapon == "crossbow_explosive_alt_sp" )
			{
				return get_explosive_crossbow_run_pain();
			}
			else
			{
				return getRunningForwardPainAnim();
			}
		}
		else if( self.damageWeapon == "crossbow_explosive_alt_sp" )
		{
			return get_explosive_crossbow_pain();
		}
		
		self.a.movement = "stop";
		return getStandPainAnim();
	}
	else if ( self.a.pose == "crouch" )
	{
		// MikeD (9/27/2007): New flamethrower pains
		if( IsDefined( self.damagemod ) && self.damagemod == "MOD_BURNED" )
		{
			return get_flamethrower_crouch_pain();
		}

		self.a.movement = "stop";
		return getCrouchPainAnim();
	}
	else if ( self.a.pose == "prone" )
	{
		self.a.movement = "stop";
		return getPronePainAnim();
	}
	else
	{
		assert( self.a.pose == "back" );
		self.a.movement = "stop";
		return animArray("chest");
	}
}

// MikeD (9/28/2007): New flame pain animations (STAND)
get_flamethrower_pain()
{
	painArray = animArray("burn_chest");
	assert( IsArray(painArray) && painArray.size > 0 );

	tagArray = array( "J_Elbow_RI", "J_Wrist_LE", "J_Wrist_RI", "J_Head" );

	painArray = removeBlockedAnims( painArray );
	if ( !painArray.size )
	{
		self.a.movement = "stop";
		return getStandPainAnim();
	}

	anim_num = RandomInt( painArray.size );
	if( self.team == "axis" && IsDefined( level._effect["character_fire_pain_sm"] ) )
	{
		PlayFxOnTag( level._effect["character_fire_pain_sm"], self, tagArray[anim_num] );
	}
	else
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_pain_sm\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_sm\"" );
#/
	}

	pain_anim = painArray[anim_num];
	time = GetAnimLength( pain_anim );
	self.a.flamepainTime = GetTime() + ( time * 1000 );

	return pain_anim;
}

// MikeD (9/28/2007): New flame pain animations (CROUCH)
get_flamethrower_crouch_pain()
{
	// simple random choice for now
	painArray = animArray("burn_chest");
	assert( IsArray(painArray) && painArray.size > 0 );

	tagArray = array( "J_Elbow_LE", "J_Wrist_LE", "J_Wrist_RI", "J_Head" );

	painArray = removeBlockedAnims( painArray );
	if ( !painArray.size )
	{
		self.a.movement = "stop";
		return getStandPainAnim();
	}

	anim_num = RandomInt( painArray.size );
	if( self.team == "axis" && IsDefined( level._effect["character_fire_pain_sm"] ) )
	{
		PlayFxOnTag( level._effect["character_fire_pain_sm"], self, tagArray[anim_num] );
	}
	else
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_pain_sm\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_sm\"" );
#/
	}

	pain_anim = painArray[anim_num];
	time = GetAnimLength( pain_anim );
	self.a.flamepainTime = GetTime() + ( time * 1000 );

	return pain_anim;
}

getRunningForwardPainAnim()
{
	// simple random choice for now
	painArray = animArray("run_chest");

	painArray = removeBlockedAnims( painArray );
	if ( !painArray.size )
	{
		self.a.movement = "stop";
		return getStandPainAnim();
	}
	
	return painArray[ RandomInt( painArray.size ) ];
}

get_explosive_crossbow_pain()
{
	painArray = [];

	// crossbow pains end with start_ragdoll notetrack
	if ( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		return getStandPainAnim();
	}

	if( damageLocationIsAny( "left_leg_upper", "left_leg_lower", "left_foot" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_l_leg_explode_v1");
		painArray[painArray.size] = animArray("crossbow_l_leg_explode_v2");
	}
	else if( damageLocationIsAny( "right_leg_upper", "right_leg_lower", "right_foot" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_r_leg_explode_v1");
		painArray[painArray.size] = animArray("crossbow_r_leg_explode_v2");
	}
	else if( damageLocationIsAny( "left_arm_upper", "left_arm_lower", "left_hand" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_l_arm_explode_v1");
		painArray[painArray.size] = animArray("crossbow_l_arm_explode_v2");
	}
	else if( damageLocationIsAny( "right_arm_upper", "right_arm_lower", "right_arm" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_r_arm_explode_v1");
		painArray[painArray.size] = animArray("crossbow_r_arm_explode_v2");
	}
	else if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
	{
		painArray[painArray.size] = animArray("crossbow_front_explode_v1");
		painArray[painArray.size] = animArray("crossbow_front_explode_v2");
	}
	else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
	{
		painArray[painArray.size] = animArray("crossbow_back_explode_v1");
		painArray[painArray.size] = animArray("crossbow_back_explode_v2");
	}
	else
	{
		return getStandPainAnim();
	}
	
	assertex( painArray.size > 0, painArray.size ); 

	return painArray[ RandomInt( painArray.size ) ];
}

get_explosive_crossbow_run_pain()
{
	painArray = [];

	// crossbow pains end with start_ragdoll notetrack
	if ( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		return getRunningForwardPainAnim();
	}

	if( damageLocationIsAny( "left_leg_upper", "left_leg_lower", "left_foot" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_run_l_leg_explode");
	}
	else if( damageLocationIsAny( "right_leg_upper", "right_leg_lower", "right_foot" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_run_r_leg_explode");
	}
	else if( damageLocationIsAny( "left_arm_upper", "left_arm_lower", "left_hand" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_run_l_arm_explode");
	}
	else if( damageLocationIsAny( "right_arm_upper", "right_arm_lower", "right_arm" )	 )
	{
		painArray[painArray.size] = animArray("crossbow_run_r_arm_explode");
	}
	else if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
	{
		painArray[painArray.size] = animArray("crossbow_run_front_explode");
	}
	else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
	{
		painArray[painArray.size] = animArray("crossbow_run_back_explode");
	}
	else
	{
		return getRunningForwardPainAnim();
	}
	
	assertex( painArray.size > 0, painArray.size ); 

	return painArray[ RandomInt( painArray.size ) ];
}

getStandPainAnim()
{
	painArray = [];
	
	if ( weaponAnims() == "pistol" )
	{
		if ( self damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		{
			painArray[painArray.size] = animArray("chest");
		}

		if ( self damageLocationIsAny( "torso_lower", "left_leg_upper", "right_leg_upper" ) )
		{
			painArray[painArray.size] = animArray("groin");
		}

		if ( self damageLocationIsAny( "head", "neck" ) )
		{
			painArray[painArray.size] = animArray("head");
		}

		if ( self damageLocationIsAny( "left_arm_lower", "left_arm_upper", "torso_upper" ) )
		{
			painArray[painArray.size] = animArray("left_arm");
		}

		if ( self damageLocationIsAny( "right_arm_lower", "right_arm_upper", "torso_upper" ) )
		{
			painArray[painArray.size] = animArray("right_arm");
		}
		
		if ( painArray.size < 2 )
		{
			painArray[painArray.size] = animArray("chest");
		}

		if ( painArray.size < 2 )
		{
			painArray[painArray.size] = animArray("groin");
		}
	}
	else if( self usingGasWeapon() )
	{
			painArray[painArray.size] = animArray("chest");
	}
	else
	{
		damageAmount = self.damageTaken / self.maxhealth;

		//TODO: get rid of if/else left over from getting rid of exposed2_ set of anims
		if ( damageAmount > .4 && !damageLocationIsAny( "left_hand", "right_hand", "left_foot", "right_foot", "helmet" ) )
		{
			painArray[painArray.size] = animArray("big");
		}

		if ( self damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		{
			painArray[painArray.size] = animArray("chest");
		}

		if ( self damageLocationIsAny( "right_hand", "right_arm_upper", "right_arm_lower", "torso_upper" ) )
		{
			painArray[painArray.size] = animArray("drop_gun");
		}

		if ( self damageLocationIsAny( "torso_lower", "left_leg_upper", "right_leg_upper" ) )
		{
			painArray[painArray.size] = animArray("groin");
		}

		if ( self damageLocationIsAny( "left_hand", "left_arm_lower", "left_arm_upper" ) )
		{
			painArray[painArray.size] = animArray("left_arm");
		}

		if ( self damageLocationIsAny( "right_hand", "right_arm_lower", "right_arm_upper" ) )
		{
			painArray[painArray.size] = animArray("right_arm");
		}

		if ( self damageLocationIsAny( "left_foot", "right_foot", "left_leg_lower", "right_leg_lower", "left_leg_upper", "right_leg_upper" ) )
		{
			painArray[painArray.size] = animArray("leg");
		}
		
		if ( painArray.size < 2 )
		{
			painArray[painArray.size] = animArray("chest");
		}

		if ( painArray.size < 2 )
		{
			painArray[painArray.size] = animArray("drop_gun");
		}
	}

	assertex( painArray.size > 0, painArray.size );
	return painArray[ RandomInt( painArray.size ) ];
}

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

getCrouchPainAnim()
{
	painArray = [];

	if( self usingGasWeapon() )
	{
		painArray[painArray.size] = animArray("chest");
	}
	else
	{
		if ( damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		{
			painArray[painArray.size] = animArray("chest");
		}

		if ( damageLocationIsAny( "head", "neck", "torso_upper" ) )
		{
			painArray[painArray.size] = animArray("head");
		}

		if ( damageLocationIsAny( "left_hand", "left_arm_lower", "left_arm_upper" ) )
		{
			painArray[painArray.size] = animArray("left_arm");
		}

		if ( damageLocationIsAny( "right_hand", "right_arm_lower", "right_arm_upper" ) )
		{
			painArray[painArray.size] = animArray("right_arm");
		}
		
		if ( painArray.size < 2 )
		{
			painArray[painArray.size] = animArray("flinch");
		}

		if ( painArray.size < 2 )
		{
			painArray[painArray.size] = animArray("chest");
		}
	}

	assertex( painArray.size > 0, painArray.size );
	return painArray[ RandomInt( painArray.size ) ];
}

getPronePainAnim()
{
	return animArrayPickRandom( "chest" );
}


playPainAnim( painAnim )
{
	if ( IsDefined( self.magic_bullet_shield ) )
	{
		rate = 1.5;
	}
	else
	{
		rate = self.animPlayBackRate;
	}

	self SetFlaggedAnimKnobAllRestart( "painanim", painAnim, %body, 1, .1, rate );
	
	if ( self.a.pose == "prone" )
	{
		self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.1, 1);
	}
	
	if ( animHasNotetrack( painAnim, "start_aim" ) )
	{
		self thread notifyStartAim( "painanim" );
		self endon("start_aim");
	}
	
	self animscripts\shared::DoNoteTracks( "painanim" );
}

notifyStartAim( animFlag )
{
	self endon( "killanimscript" );
	self waittillmatch( animFlag, "start_aim" );
	self notify( "start_aim" );
}

// Special pain is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the pain for the special animation state, or false if it wants the regular 
// pain function to handle it.
specialPain( anim_special )
{
	if (anim_special == "none")
	{
		return false;
	}

	// MikeD (10/9/2007): Don't do this special animation if the guy is a flamethrower ai
	if( self usingGasWeapon() )
	{
		return false;
	}

//	self thread PlayHitAnimation();
	
	switch ( anim_special )
	{
	case "cover_left":
		if( self.a.pose == "stand" || (self.a.pose == "crouch" && usingPistol()) )
		{
			painArray = [];
			if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || RandomFloat(10) < 3 )
			{
				painArray[painArray.size] = animArray("cover_left_groin");
			}

			if ( self damageLocationIsAny("torso_lower", "torso_upper", "left_arm_upper", "right_arm_upper", "neck") || RandomFloat(10) < 3 )
			{
				painArray[painArray.size] = animArray("cover_left_chest");
			}

			if ( self damageLocationIsAny("left_leg_upper", "left_leg_lower", "left_foot") || RandomFloat(10) < 3 )
			{
				painArray[painArray.size] = animArray("cover_left_left_leg");
			}

			if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || RandomFloat(10) < 3 )
			{
				painArray[painArray.size] = animArray("cover_left_right_leg");
			}

			if ( painArray.size < 2 )
			{
				painArray[painArray.size] = animArray("cover_left_head"); // dizzy fall against wall
			}

			DoPainFromArray(painArray);
			handled = true;

			// get back into cover
			if( self.a.cornerMode == "lean" && !usingPistol() )
			{
				returnAnim = animArrayPickRandom( "lean_to_alert", "cover_left" );
				self SetFlaggedAnimKnobAllRestart( "returnAnim", returnAnim, %body, 1, 0.2, 1);
				self animscripts\shared::DoNoteTracks("returnAnim");
			}
		}
		else
		{
			handled = false;
		}

		break;
	case "cover_right":
		if( self.a.pose == "stand" || (self.a.pose == "crouch" && usingPistol()) )
		{
			painArray = [];
			if ( self damageLocationIsAny("right_arm_upper", "torso_upper", "neck") || RandomFloat(10) < 3 )
			{
				painArray[painArray.size] = animArray("cover_right_chest"); // right shoulder hit
			}

			if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || RandomFloat(10) < 3 )
			{
				painArray[painArray.size] = animArray("cover_right_right_leg"); // right leg hit
			}

			if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || RandomFloat(10) < 3 )
			{
				painArray[painArray.size] = animArray("cover_right_groin"); // groin hit
			}

			if ( painArray.size == 0 )
			{
				painArray[0] =  animArray("cover_right_chest");
				painArray[1] =  animArray("cover_right_right_leg");
				painArray[2] =  animArray("cover_right_groin");
			}

			DoPainFromArray(painArray);
			handled = true;

			// get back into cover
			if( self.a.cornerMode == "lean" && !usingPistol() )
			{
				returnAnim = animArrayPickRandom( "lean_to_alert", "cover_right" );
				self SetFlaggedAnimKnobAllRestart( "returnAnim", returnAnim, %body, 1, 0.2, 1);
				self animscripts\shared::DoNoteTracks("returnAnim");
			}
		}
		else
		{
			handled = false;
		}

		break;
	case "cover_crouch":
		painArray = [];

		if( self.damageyaw > 135 || self.damageyaw <= -135 ) // Front quadrant
		{
			painArray[painArray.size] = animArray("cover_crouch_front");
		}
		else if( self.damageyaw > 45 && self.damageyaw < 135 ) // Right quadrant
		{
			painArray[painArray.size] = animArray("cover_crouch_right");
		}
		else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
		{
			painArray[painArray.size] = animArray("cover_crouch_left");
		}
		else // Back quadrant
		{
			painArray[painArray.size] = animArray("cover_crouch_back");
		}

		DoPainFromArray(painArray);
		handled = true;
		break;	
	case "cover_stand":
		painArray = [];
		if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || RandomFloat(10) < 3 )
		{
			painArray[painArray.size] = animArray("cover_stand_groin"); // groin hit
		}

		if ( self damageLocationIsAny("torso_lower", "torso_upper", "left_arm_upper", "right_arm_upper", "neck") || RandomFloat(10) < 3 )
		{
			painArray[painArray.size] = animArray("cover_stand_chest"); // chest hit
		}

		if ( self damageLocationIsAny("left_leg_upper", "left_leg_lower", "left_foot") || RandomFloat(10) < 3 )
		{
			painArray[painArray.size] = animArray("cover_stand_left_leg"); // left leg hit
		}

		if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || RandomFloat(10) < 3 )
		{
			painArray[painArray.size] = animArray("cover_stand_right_leg"); // right leg hit
		}

		if ( painArray.size < 2 )
		{
			painArray[painArray.size] = animArray("cover_stand_right_leg");
		}

		DoPainFromArray(painArray);
		handled = true;
		break;	
	case "cover_pillar":
		painArray = [];
		if( self.cornerDirection == "left" )
		{
			if( self.a.cornerMode == "lean" )
			{
				painArray[painArray.size] = animArray("cover_pillar_l_return");
			}
			else
			{
				painArray[painArray.size] = animArray("cover_pillar_l_remain");
			}
		}
		else
		{
			if( self.a.cornerMode == "lean" )
			{
				painArray[painArray.size] = animArray("cover_pillar_r_return");
			}
			else
			{
				painArray[painArray.size] = animArray("cover_pillar_r_remain");
			}
		}

		DoPainFromArray(painArray);

		handled = true;
		break;	
	case "saw":
		painAnim = animArray("saw_chest");

		self SetFlaggedAnimKnob( "painanim", painAnim, 1, .3, 1);
		self animscripts\shared::DoNoteTracks ("painanim");
		handled = true;
		break;
	case "mg42":
		mg42pain( self.a.pose );
		handled = true;
		break;
	case "corner_right_mode_b":
	case "rambo_left":
	case "rambo_right":
	case "rambo":
	case "dying_crawl":
		handled = false;
		break;
	default:
		println ("Unexpected anim_special value : "+anim_special+" in specialPain.");
		handled = false;
	}
	return handled;
}

painDeathNotify()
{
	self endon("death");
	
	// it isn't safe to notify "pain_death" from the start of an animscript.
	// this can cause level script to run, which might cause things with this AI to change while the animscript is starting
	// and this can screw things up in unexpected ways.
	// take my word for it.
	wait .05;
	self notify("pain_death");
}

DoPainFromArray( painArray )
{
	painAnim = painArray[RandomInt(painArray.size)];
	
	self SetFlaggedAnimKnob( "painanim", painAnim, 1, .3, 1);
	self animscripts\shared::DoNoteTracks ("painanim");
}

mg42pain( pose )
{
//		assertmsg("mg42 pain anims not implemented yet");//scripted_mg42gunner_pain
		
	/#
	assertEx ( IsDefined( level.mg_animmg ), "You're missing maps\\_mganim::main();  Add it to your level." );
	{
		println("	maps\\_mganim::main();");
		return;
	}
	#/

	self SetFlaggedAnimKnob( "painanim", level.mg_animmg[ "pain_" + pose ], 1, .1, 1);
	self animscripts\shared::DoNoteTracks ("painanim");
}

PlayHitAnimation()
{
	// Note the this thread doesn't endon "killanimscript" like most thread, because I don't want it to die 
	// when a new script starts.

	animWeights = animscripts\utility::QuadrantAnimWeights( self.damageYaw + 180 );

	// Pick the animation to play, based on location and direction.
	playHitAnim = 1;
	switch(self.damageLocation)
	{
	case "torso_upper":
	case "torso_lower":
		frontAnim =	animArray("chest_front");
		backAnim =	animArray("chest_back");
		leftAnim =	animArray("chest_left");
		rightAnim =	animArray("chest_right");
		break;
	case "helmet":
	case "head":
	case "neck":
		frontAnim =	animArray("head_front");
		backAnim =	animArray("head_back");
		leftAnim =	animArray("head_left");
		rightAnim =	animArray("head_right");
		break;
	case "left_arm_upper":
	case "left_arm_lower":
	case "left_hand":
		frontAnim =	animArray("left_arm_front");
		backAnim =	animArray("left_arm_back");
		leftAnim =	animArray("left_arm_left");
		rightAnim =	animArray("left_arm_right");
		break;
	case "right_arm_upper":
	case "right_arm_lower":
	case "right_hand":
	case "gun":
		frontAnim =	animArray("right_arm_front");
		backAnim =	animArray("right_arm_back");
		leftAnim =	animArray("right_arm_left");
		rightAnim =	animArray("right_arm_right");
		break;
	case "none":
	case "left_leg_upper":
	case "left_leg_lower":
	case "left_foot":
	case "right_leg_upper":
	case "right_leg_lower":
	case "right_foot":
//println (self.damagelocation+" "+direction+" "+self.damageTaken);
		return;
	default:
		assertmsg("pain.gsc/HitAnimation: unknown hit location "+self.damageLocation);
		return;
	}

//println (self.damagelocation+" "+direction+" "+self.damageTaken+" "+playHitAnim);
	// Now play the animation for a really sort amount of time.  Weight the animation based on the 
	// damage inflicted (or k-factor?).
	if (playHitAnim)
	{
		if(self.damageTaken > 200)
		{
			weight = 1;
		}
		else
		{
			weight = (self.damageTaken+50.0)/250;
		}

//println (weight);
		// (Note that SetAnim makes the animation transition to the weight set at a rate of 1 per the time 
		// set, so if the weight is less than 1, I need to set my time longer since it will get there faster 
		// than my time.)
		self ClearAnim(%minor_pain, 0.1);	// In case there's a minor pain already playing.

		self SetAnim(frontAnim, animWeights["front"], 0.05, 1);	// Setting the blendtime to 0.05 will result in 
		self SetAnim(backAnim, animWeights["back"], 0.05, 1);	// some non-linear blending in of these anims, 
		self SetAnim(leftAnim, animWeights["left"], 0.05, 1);	// but that's not such a bad thing.  A pop 
		self SetAnim(rightAnim, animWeights["right"], 0.05, 1);	// would be a bad thing.

		self SetAnim(%minor_pain, weight, (0.05/weight), 1);
		wait 0.05;

		if (!IsDefined(self))
		{
			return;
		}

		self ClearAnim(%minor_pain, (0.2/weight));	// Don't want to leave residue for the next pain.
		wait 0.2;
	}
}

crawlingPain()
{
	/#
	if ( GetDvarInt( #"scr_forceCrawl" ) == 1 && !IsDefined( self.magic_bullet_shield ) )
	{
		self.health = 10;
		self thread crawlingPistol();
		
		self waittill("killanimscript");
		return true;
	}
	#/
	
	legHit = self damageLocationIsAny( "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower", "left_foot", "right_foot" );

	if ( legHit && self.health < self.maxhealth * .4 )
	{
		if ( GetTime() < anim.nextCrawlingPainTimeFromLegDamage )
		{
			return false;
		}
	}
	else
	{
		if ( anim.numDeathsUntilCrawlingPain > 0 )
		{
			return false;
		}

		if ( GetTime() < anim.nextCrawlingPainTime )
		{
			return false;
		}
	}

	if ( self.team != "axis" )
	{
		return false;
	}
	
	//This will allow you to sidable all long deaths for certain parts of the map
	if ( IsDefined(level._disable_all_long_deaths) && level._disable_all_long_deaths )
	{
		return false;
	}

	if ( is_true(level.disableLongDeaths) || self.a.disableLongDeath || (IsDefined( self.dieQuietly ) && self.dieQuietly) )
	{
		return false;
	}

	// MikeD (10/1/2007): Don't do a crawl animation if getting burned!
	if( self.damageMod == "MOD_BURNED" || self.damageMod == "MOD_GAS" )
	{
		return false;
	}

	// MikeD (10/9/2007): Don't do this special animation if the guy is a flamethrower ai
	if( self usingGasWeapon() )
	{
		return false;
	}

	/*if ( self.a.movement != "stop" )
		return false;*/
	
	if ( self.a.pose != "prone" && self.a.pose != "crouch" && self.a.pose != "stand" )
	{
		return false;
	}
	
	if ( IsDefined( self.deathFunction ) )
	{
		return false;
	}
		
	players = GetPlayers();
	if ( players.size == 0 )
	{
		return false;
	}

	anybody_nearby = 0;
	for (i=0;i<players.size;i++)
	{
		if ( IsDefined(players[i]) && distance( self.origin, players[i].origin ) < 175 )
		{
			anybody_nearby = 1;
			break;
		}
	}

	if ( !anybody_nearby )
	{
		return false;
	}

	if ( self damageLocationIsAny( "head", "helmet", "gun", "right_hand", "left_hand" ) )
	{
		return false;
	}
		
	if ( usingSidearm() )
	{
		return false;
	}
		
	if ( self depthinwater() > 8 )
	{
		return false;
	}
	
	if( !self AIHasSidearm() )
	{
		return false;
	}
	
	// we'll wait a bit to see if this crawling pain will really succeed.
	// in the meantime, don't start any other ones.
	anim.nextCrawlingPainTime = GetTime() + 3000;
	anim.nextCrawlingPainTimeFromLegDamage = GetTime() + 3000;
	
	// needs to be threaded
	self thread crawlingPistol();
	
	self waittill("killanimscript");
	return true;
}


crawlingPistol()
{
	// don't end on killanimscript. pain.gsc will abort if self.crawlingPistolStarting is true.
	self endon ( "kill_long_death" );
	self endon ( "death" );

	// don't collide with player during long death
	self SetPlayerCollision(false);
	
	self thread preventPainForAShortTime( "crawling" );
	
	self.a.special = "none";
	
	self thread painDeathNotify();
	//notify ac130 missions that a guy is crawling so context sensative dialog can be played
	level notify ( "ai_crawling", self );
		
	self.isSniper = false;
	
	self SetAnimKnobAll( %dying, %body, 1, 0.1, 1 );
	
	// dyingCrawl() returns false if we die without turning around
	if ( !self dyingCrawl() )
	{
		return;
	}
	
	assert( self.a.pose == "stand" || self.a.pose == "crouch" || self.a.pose == "prone" );
	transAnimSlot = self.a.pose + "_2_back";
	transAnim = animArrayPickRandom( transAnimSlot );
	
	self SetFlaggedAnimKnob( "transition", transAnim, 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracksIntercept( "transition", ::handleBackCrawlNotetracks );
	
	// A complicated way of doing an assertEx, where the assert needs to contain the name of an anim.
	if ( self.a.pose != "back" )
	{
		println( "Anim \"", transAnim, "\" is missing an 'anim_pose = \"back\"' notetrack." );
		assert( self.a.pose == "back" );
	}
	
	self.a.special = "dying_crawl";
	
	self thread dyingCrawlBackAim();
	
	decideNumCrawls();
	while ( shouldKeepCrawling() )
	{
		crawlAnim = animArray( "back_crawl" );
		delta = getMoveDelta( crawlAnim, 0, 1 );
		endPos = self localToWorldCoords( delta );
		
		if ( !self mayMoveToPoint( endPos ) )
		{
			break;
		}
		
		self SetFlaggedAnimKnobRestart( "back_crawl", crawlAnim, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracksIntercept( "back_crawl", ::handleBackCrawlNotetracks );
	}
	
	self.desiredTimeOfDeath = GetTime() + randomintrange( 4000, 20000 );
	while ( shouldStayAlive() )
	{
		if ( self canSeeEnemy() && self aimedSomewhatAtEnemy() )
		{
			backAnim = animArray( "back_fire" );
		
			self SetFlaggedAnimKnobRestart( "back_idle_or_fire", backAnim, 1, 0.2, 1.0 );
			self animscripts\shared::DoNoteTracks( "back_idle_or_fire" );
		}
		else
		{
			backAnim = animArray( "back_idle" );
			if ( RandomFloat(1) < .4 )
			{
				backAnim = animArrayPickRandom( "back_idle_twitch" );
			}
			
			self SetFlaggedAnimKnobRestart( "back_idle_or_fire", backAnim, 1, 0.1, 1.0 );
			
			timeRemaining = getAnimLength( backAnim );
			while( timeRemaining > 0 )
			{
				if ( self canSeeEnemy() && self aimedSomewhatAtEnemy() )
				{
					break;
				}
				
				interval = 0.5;
				if ( interval > timeRemaining )
				{
					interval = timeRemaining;
					timeRemaining = 0;
				}
				else
				{
					timeRemaining -= interval;
				}

				self animscripts\shared::DoNoteTracksForTime( interval, "back_idle_or_fire" );
			}
		}
	}
	
	self notify("end_dying_crawl_back_aim");
	self ClearAnim( %dying_back_aim_4_wrapper, .3 );
	self ClearAnim( %dying_back_aim_6_wrapper, .3 );
	
	self.a.nodeath = true;
	animscripts\death::play_death_anim( animArrayPickRandom( "back_death" ) );
	self DoDamage( self.health + 5, (0,0,0) );

	self.a.special = "none";
}

shouldStayAlive()
{
	if ( !enemyIsInGeneralDirection( AnglesToForward( self.angles ) ) )
	{
		return false;
	}
	
	return GetTime() < self.desiredTimeOfDeath;
}

dyingCrawl()
{
	if ( self.a.pose == "prone" )
	{
		return true;
	}
	
	if ( self.a.movement == "stop" )
	{
		if ( RandomFloat(1) < .2 ) // small chance of randomness
		{
			if ( RandomFloat(1) < .5 )
			{
				return true;
			}
		}
		else
		{
			// if hit from front, return true
			if ( abs( self.damageYaw ) > 90 )
			{
				return true;
			}
		}
	}
	else
	{
		// if we're not stopped, we want to fall in the direction of movement
		// so return true if moving backwards
		if ( abs( self getMotionAngle() ) > 90 )
		{
			return true;
		}
	}
	
	self SetFlaggedAnimKnob( "falling", animArrayPickRandom( self.a.pose + "_2_crawl" ), 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracks( "falling" );
	assert( self.a.pose == "prone" );
	
	self.a.special = "dying_crawl";
	
	decideNumCrawls();
	while ( shouldKeepCrawling() )
	{
		crawlAnim = animArray( "crawl" );
		delta = getMoveDelta( crawlAnim, 0, 1 );
		endPos = self localToWorldCoords( delta );

		if ( !self mayMoveToPoint( endPos ) )
		{
			return true;
		}
			
		self SetFlaggedAnimKnobRestart( "crawling", crawlAnim, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracks( "crawling" );
	}
	
	// check if target is in cone to shoot
	if ( enemyIsInGeneralDirection( AnglesToForward( self.angles ) * -1 ) )
	{
		return true;
	}
	
	self.a.nodeath = true;
	animscripts\death::play_death_anim( animArrayPickRandom( "death" ) );
	self DoDamage( self.health + 5, (0,0,0) );
	
	self.a.special = "none";
	
	return false;
}

dyingCrawlBackAim()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	self endon ( "end_dying_crawl_back_aim" );
	
	if ( IsDefined( self.dyingCrawlAiming ) )
	{
		return;
	}

	self.dyingCrawlAiming = true;
	
	self SetAnimLimited( animArray("aim_left"), 1, 0 );
	self SetAnimLimited( animArray("aim_right"), 1, 0 );
	
	prevyaw = 0;
	
	while(1)
	{
		aimyaw = self getYawToEnemy();
		
		diff = AngleClamp180( aimyaw - prevyaw );
		if ( abs( diff ) > 3 )
		{
			diff = sign( diff ) * 3;
		}
		
		aimyaw = AngleClamp180( prevyaw + diff );
		
		if ( aimyaw < 0 )
		{
			if ( aimyaw < -45.0 )
			{
				aimyaw = -45.0;
			}

			weight = aimyaw / -45.0;
			self SetAnim( %dying_back_aim_4_wrapper, weight, .05 );
			self SetAnim( %dying_back_aim_6_wrapper, 0, .05 );
		}
		else
		{
			if ( aimyaw > 45.0 )
			{
				aimyaw = 45.0;
			}

			weight = aimyaw / 45.0;
			self SetAnim( %dying_back_aim_6_wrapper, weight, .05 );
			self SetAnim( %dying_back_aim_4_wrapper, 0, .05 );
		}
		
		prevyaw = aimyaw;
		
		wait .05;
	}
}

startDyingCrawlBackAimSoon()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );

	wait 0.5;
	self thread dyingCrawlBackAim();
}

handleBackCrawlNotetracks( note )
{
	if ( note == "fire_spray" )
	{
		if ( !self canSeeEnemy() )
		{
			return true;
		}
		
		if ( !self aimedSomewhatAtEnemy() )
		{
			return true;
		}
		
		self shootEnemyWrapper();
		
		return true;
	}
	else if ( note == "pistol_pickup" )
	{
		self thread startDyingCrawlBackAimSoon();
		return false;
	}
	return false;
}

aimedSomewhatAtEnemy()
{
	assert( isValidEnemy( self.enemy ) );
	
	enemyShootAtPos = self.enemy GetShootAtPos();
	
	weaponAngles = self GetTagAngles("tag_weapon");
	anglesToEnemy = VectorToAngles( enemyShootAtPos - self GetTagOrigin("tag_weapon") );
	
	absyawdiff = AbsAngleClamp180( weaponAngles[1] - anglesToEnemy[1] );
	if ( absyawdiff > 25 )
	{
		if ( DistanceSquared( self GetShootAtPos(), enemyShootAtPos ) > 64*64 || absyawdiff > 45 )
		{
			return false;
		}
	}
	
	return AbsAngleClamp180( weaponAngles[0] - anglesToEnemy[0] ) <= 30;
}

enemyIsInGeneralDirection( dir )
{
	if ( !isValidEnemy( self.enemy ) )
	{
		return false;
	}
	
	toenemy = VectorNormalize( self.enemy GetShootAtPos() - self getEye() );
	
	return (vectorDot( toenemy, dir ) > 0.5); // cos(60) = 0.5
}


preventPainForAShortTime( type )
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	
	self.flashBangImmunity = true;
	
	self.longDeathStarting = true;
	self.doingLongDeath = true;
	self notify( "long_death" );
	self.health = 10000; // also prevent death
	
	// during this time, we won't be interrupted by more pain.
	// this increases the chances of the crawling pain succeeding.
	wait .75;
	
	// important that we die the next time we get hit,
	// instead of maybe going into pain and coming out and going into combat or something
	if ( self.health > 1 )
	{
		self.health = 1;
	}
	
	// important that we wait a bit in case we're about to start pain later in this frame
	wait .05;
	
	self.longDeathStarting = undefined;
	self.a.mayOnlyDie = true; // we've probably dropped our weapon and stuff; we must not do any other animscripts but death!
	
	if ( type == "crawling" )
	{
		wait 1.0;
		
		players = GetPlayers();
		anybody_nearby = 0;
		for (i=0;i<players.size;i++)
		{
			if ( IsDefined(players[i]) && DistanceSquared( self.origin, players[i].origin ) < 1048576 )
			{
				anybody_nearby = 1;
				break;
			}
		}

		// we've essentially succeeded in doing a crawling pain.
		if ( anybody_nearby )
		{
			anim.numDeathsUntilCrawlingPain = randomintrange( 10, 30 );
			anim.nextCrawlingPainTime = GetTime() + randomintrange( 15000, 60000 );
		}
		else
		{
			anim.numDeathsUntilCrawlingPain = randomintrange( 5, 12 );
			anim.nextCrawlingPainTime = GetTime() + randomintrange( 5000, 25000 );
		}
		anim.nextCrawlingPainTimeFromLegDamage = GetTime() + randomintrange( 7000, 13000 );
		/#
		if ( getDebugDvarInt( "scr_crawldebug" ) == 1 )
		{
			thread printLongDeathDebugText( self.origin + (0,0,64), "crawl death" );
			return;
		}
		#/
	}
	else if ( type == "corner_grenade" )
	{
		wait 1.0;
		
		players = GetPlayers();
		anybody_nearby = 0;
		for (i=0;i<players.size;i++)
		{
			if ( IsDefined(players[i]) && DistanceSquared( self.origin, players[i].origin ) < 490000 )
			{
				anybody_nearby = 1;
				break;
			}
		}

		// we've essentially succeeded in doing a corner grenade death.
		if ( anybody_nearby )
		{
			anim.numDeathsUntilCornerGrenadeDeath = randomintrange( 10, 30 );
			anim.nextCornerGrenadeDeathTime = GetTime() + randomintrange( 15000, 60000 );
		}
		else
		{
			anim.numDeathsUntilCornerGrenadeDeath = randomintrange( 5, 12 );
			anim.nextCornerGrenadeDeathTime = GetTime() + randomintrange( 5000, 25000 );
		}
		/#
		if ( getDebugDvarInt( "scr_cornergrenadedebug" ) == 1 )
		{
			thread printLongDeathDebugText( self.origin + (0,0,64), "grenade death" );
			return;
		}
		#/
	}
}

/#
printLongDeathDebugText( loc, text )
{
	for ( i = 0; i < 100; i++ )
	{
		Print3d( loc, text );
		wait .05;
	}
}
#/

decideNumCrawls()
{
	self.a.numCrawls = randomIntRange( 0, 5 );
}

shouldKeepCrawling()
{
	// TODO: player distance checks, etc...
	
	assert( IsDefined( self.a.numCrawls ) );
		
	if ( !self.a.numCrawls )
	{
		self.a.numCrawls = undefined;
		return false;
	}
		
	self.a.numCrawls--;
	
	return true;
}


TryCornerRightGrenadeDeath()
{
	/#
	if ( GetDvarInt( #"scr_forceCornerGrenadeDeath" ) == 1 )
	{
		self thread CornerRightGrenadeDeath();
		self waittill("killanimscript");
		return true;
	}
	#/

	// MikeD (10/9/2007): Don't do this special animation if the guy is a flamethrower ai
	if( self usingGasWeapon() )
	{
		return false;
	}

	if ( anim.numDeathsUntilCornerGrenadeDeath > 0 )
	{
		return false;
	}

	if ( GetTime() < anim.nextCornerGrenadeDeathTime )
	{
		return false;
	}
	
	if ( self.team != "axis" )
	{
		return false;
	}
	
	if ( is_true(level.disableLongDeaths) || self.a.disableLongDeath || (IsDefined( self.dieQuietly ) && self.dieQuietly) )
	{
		return false;
	}
	
	if ( IsDefined( self.deathFunction ) )
	{
		return false;
	}
		
	players = GetPlayers();
	if ( players.size == 0 )
	{
		return false;
	}

	anybody_nearby = 0;
	for (i=0;i<players.size;i++)
	{
		if ( IsDefined(players[i]) && distance( self.origin, players[i].origin ) < 175 )
		{
			anybody_nearby = 1;
			break;
		}
	}

	// we've essentially succeeded in doing a corner grenade death.
	if ( anybody_nearby )
	{
		return false;
	}

	// we'll wait a bit to see if this crawling pain will really succeed.
	// in the meantime, don't start any other ones.
	anim.nextCornerGrenadeDeathTime = GetTime() + 3000;

	self thread CornerRightGrenadeDeath();

	self waittill("killanimscript");
	return true;
}

CornerRightGrenadeDeath()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	
	self thread painDeathNotify();
	
	self thread preventPainForAShortTime( "corner_grenade" );
	
	//self thread maps\_utility::set_battlechatter( false );
	
	self.threatbias = -1000; // no need for AI to target me
	
	self SetFlaggedAnimKnobAllRestart( "corner_grenade_pain", animArray("cover_right_corner_hit"), %body, 1, .1 );

	//wait getAnimLength( %corner_standR_death_grenade_hit ) * 0.2;
	self waittillmatch( "corner_grenade_pain", "dropgun" );
	self animscripts\shared::DropAllAIWeapons();
	
	self waittillmatch( "corner_grenade_pain", "anim_pose = \"back\"" );
	self.a.pose = "back";
	
	self waittillmatch( "corner_grenade_pain", "grenade_left" );
	model = getWeaponModel( self.grenadeWeapon );
	self attach( model, "tag_inhand" );
	self.deathFunction = ::prematureCornerGrenadeDeath;
	
	self waittillmatch( "corner_grenade_pain", "end" );
	
	
	desiredDeathTime = GetTime() + randomintrange( 25000, 60000 );
	
	self SetFlaggedAnimKnobAllRestart( "corner_grenade_idle", animArray("cover_right_corner_idle"), %body, 1, .2 );
	
	self thread watchEnemyVelocity();
	while( !enemyIsApproaching() )
	{
		if ( GetTime() >= desiredDeathTime )
		{
			break;
		}
		
		self animscripts\shared::DoNoteTracksForTime( 0.1, "corner_grenade_idle" );
	}
	
	dropAnim = animArray("cover_right_corner_slump");
	self SetFlaggedAnimKnobAllRestart( "corner_grenade_release", dropAnim, %body, 1, .2 );
	
	dropTimeArray = getNotetrackTimes( dropAnim, "grenade_drop" );
	assert( dropTimeArray.size == 1 );
	dropTime = dropTimeArray[0] * getAnimLength( dropAnim );
	
	wait dropTime - 1.0;
	
	self animscripts\death::PlayDeathSound();
	
	wait 0.7;
	
	self.deathFunction = ::waitTillGrenadeDrops;

	velocity = (0,0,30) - AnglesToRight( self.angles ) * 70;
	self CornerDeathReleaseGrenade( velocity, RandomFloatRange( 2.0, 3.0 ) );
	
	wait .05;
	self detach( model, "tag_inhand" );
	
	self thread killSelf();
}

CornerDeathReleaseGrenade( velocity, fusetime )
{
	releasePoint = self GetTagOrigin( "tag_inhand" );
	
	// avoid dropping under the floor.
	releasePointLifted = releasePoint + (0,0,20);
	releasePointDropped = releasePoint - (0,0,20);
	trace = bullettrace( releasePointLifted, releasePointDropped, false, undefined );
	
	if ( trace["fraction"] < .5 )
	{
		releasePoint = trace["position"];
	}
	
	surfaceType = "default";
	if ( trace["surfacetype"] != "none" )
	{
		surfaceType = trace["surfacetype"];
	}
	
	// play the grenade drop sound because we're probably not dropping it with enough velocity for it to play it normally
	thread playSoundAtPoint( "wpn_grenade_bounce_" + surfaceType, releasePoint );
	
	self magicGrenadeManual( releasePoint, velocity, fusetime );
}

playSoundAtPoint( alias, origin )
{
	org = Spawn( "script_origin", origin );
	org PlaySound( alias, "sounddone" );
	org waittill( "sounddone" );
	org delete();
}

killSelf()
{
	self.a.nodeath = true;
	self DoDamage( self.health + 5, (0,0,0) );
	self startragdoll();
	wait .1;
	self notify("grenade_drop_done");
}

enemyIsApproaching()
{
	if ( !isValidEnemy( self.enemy ) )
	{
		return false;
	}

	if ( DistanceSquared( self.origin, self.enemy.origin ) > 384 * 384 )
	{
		return false;
	}

	if ( DistanceSquared( self.origin, self.enemy.origin ) < 128 * 128 )
	{
		return true;
	}
	
	predictedEnemyPos = self.enemy.origin + self.enemyVelocity * 3.0;
	
	nearestPos = self.enemy.origin;
	if ( self.enemy.origin != predictedEnemyPos )
	{
		nearestPos = pointOnSegmentNearestToPoint( self.enemy.origin, predictedEnemyPos, self.origin );
	}
	
	if ( DistanceSquared( self.origin, nearestPos ) < 128 * 128 )
	{
		return true;
	}
	
	return false;
}

prematureCornerGrenadeDeath()
{
	deathAnim = animArrayPickRandom("cover_right_corner_death", "death");
	
	self animscripts\death::PlayDeathSound();
	
	self SetFlaggedAnimKnobAllRestart( "corner_grenade_die", deathAnim, %body, 1, .2 );
	
	velocity = getGrenadeDropVelocity();
	self CornerDeathReleaseGrenade( velocity, 3.0 );
	
	model = getWeaponModel( self.grenadeWeapon );
	self detach( model, "tag_inhand" );
	
	wait .05;
	
	self startragdoll();
	
	self waittillmatch( "corner_grenade_die", "end" );
}

waitTillGrenadeDrops()
{
	self waittill("grenade_drop_done");
}

watchEnemyVelocity()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	
	self.enemyVelocity = (0,0,0);
	
	prevenemy = undefined;
	prevpos = self.origin;

	interval = .15;
	
	while(1)
	{
		if ( IsDefined( self.enemy ) && IsDefined( prevenemy ) && self.enemy == prevenemy )
		{
			curpos = self.enemy.origin;
			self.enemyVelocity = vector_scale( curpos - prevpos, 1 / interval );
			prevpos = curpos;
		}
		else
		{
			if ( IsDefined( self.enemy ) )
			{
				prevpos = self.enemy.origin;
			}
			else
			{
				prevpos = self.origin;
			}

			prevenemy = self.enemy;
			
			self.shootEntVelocity = (0,0,0);
		}
		
		wait interval;
	}
}


additive_pain_think( enable_regular_pain_on_low_health ) // self = AI
{
	self endon("death");

	AssertEx( !IsDefined( self.a.additivePain ), "Calling additive pain twice on the same AI" );

	// disable pain for now, enable it later if needed
	self disable_pain();
	self.a.additivePain = true;

	// store starting health
	starting_health = self.health;

	while(1)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type );
		
		// regular pain starts at 30% of the starting health
		if( IsDefined( enable_regular_pain_on_low_health ) && enable_regular_pain_on_low_health )
		{
			if( self.health / starting_health < 0.3 )
			{
				// enable regular pain and turn off additives
				self enable_pain();
				self.a.additivePain = false;
			}
		}
		
		// play additive pain now
		self additive_pain( damage, attacker, direction_vec, point, type );
	}

}

additive_pain( damage, attacker, direction_vec, point, type )
{
	self endon( "death" );

	if ( !isdefined( self ) )
		return;

	// if already doing the additive pains dont do it again
	if ( IsDefined( self.doingAdditivePain ) )
		return;

	// if the damage is more than minpain damage then this AI will play actual pain
	//if ( damage > self.minPainDamage )
	//	return;

	if( !self.a.additivePain )
		return;
			
	self.doingAdditivePain = true;
	painAnimArray = array( %pain_add_standing_belly, %pain_add_standing_left_arm, %pain_add_standing_right_arm );

	painAnim = %pain_add_standing_belly;

	if ( self damageLocationIsAny( "left_arm_lower", "left_arm_upper", "left_hand" ) )
		painAnim = %pain_add_standing_left_arm;
	if ( self damageLocationIsAny( "right_arm_lower", "right_arm_upper", "right_hand" ) )
		painAnim = %pain_add_standing_right_arm;
	else if ( self damageLocationIsAny( "left_leg_upper", "left_leg_lower", "left_foot" ) )
		painAnim = %pain_add_standing_left_leg;
	else if ( self damageLocationIsAny( "right_leg_upper", "right_leg_lower", "right_foot" ) )
		painAnim = %pain_add_standing_right_leg;
	else
		painAnim = painAnimArray[ randomint( painAnimArray.size ) ];


	
	self setanimlimited( %juggernaut_pain, 1, 0.1, 1 );
	self setanimlimited( painAnim, 1, 0, 1 );

	wait 0.4;

	self clearanim( painAnim, 0.2 );
	self clearanim( %juggernaut_pain, 0.2 );
	self.doingAdditivePain = undefined;
}


