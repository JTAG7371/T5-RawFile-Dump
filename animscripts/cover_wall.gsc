#include animscripts\Combat_utility;    
#include animscripts\Utility;
#include animscripts\anims;
#include common_scripts\Utility;
#include maps\_utility;

#using_animtree ("generic_human");

cover_wall_think( coverType )
{	
	self endon("killanimscript");

    self.coverNode = self.node;
	assert( IsDefined(self.coverNode) );

    self.coverType = coverType;
    
    if ( coverType == "crouch" )
    {
		self setup_cover_crouch( "unknown" );
		self.coverNode initCoverCrouchNode();
	}
	else
	{
		self setup_cover_stand();
	}

	// get out of prone if necessary
	if( self.a.pose != "stand" && self.a.pose != "crouch" )
	{
		assert( self.a.pose == "prone" );
		self ExitProneWrapper(1);
		self.a.pose = "crouch";
	}

	self.a.standIdleThread = undefined;

	// face the direction of our covernode
	self OrientMode( "face angle", self.coverNode.angles[1] );	

	//	if ( IsDefined( self.a.arrivalType ) && (self.a.arrivalType == "stand_saw" || self.a.arrivalType == "crouch_saw") )
	if ((	self.weapon == "saw"
		||	self.weapon == "rpd"
		|| 	self.weapon == "dp28"
		|| 	self.weapon == "dp28_bipod"
		|| 	self.weapon == "30cal"
		|| 	self.weapon == "30cal_bipod"
		|| 	self.weapon == "bar"
		|| 	self.weapon == "bar_bipod"
		|| 	self.weapon == "bren"
		|| 	self.weapon == "bren_bipod"
		|| 	self.weapon == "fg42"
		|| 	self.weapon == "fg42_bipod"
		|| 	self.weapon == "mg42"
		|| 	self.weapon == "mg42_bipod"
		|| 	self.weapon == "type99_lmg"
		|| 	self.weapon == "type99_lmg_bipod")
		&& 	IsDefined( self.node.turretInfo )
		&& canspawnturret())
	{
		if( issubstr( self.weapon, "_bipod" ) )
		{
			if ( coverType == "crouch" )
			{
				weaponInfo = self.weapon + "_crouch";
			}
			else
			{
				weaponInfo = self.weapon + "_stand"; 
			}
		}
		else
		{
			if ( coverType == "crouch" )
			{
				weaponInfo = self.weapon + "_bipod_crouch";
			}
			else
			{
				weaponInfo = self.weapon + "_bipod_stand"; 
			}
		}
				
		// SCRIPTER_MOD: JesseS (6/25/2007): updated for COD 5 MGs
		switch(self.weapon)
		{
		// old COD4 guns
			case "saw":
			weaponModel = "weapon_saw_MG_Setup";
			break;
		
			case "rpd":
			weaponModel = "weapon_rpd_MG_Setup";
			break;
			
			// allied guns
			case "dp28":
			weaponModel = "mounted_rus_dp28_bipod_lmg";
			break;

			case "dp28_bipod":
			weaponModel = "mounted_rus_dp28_bipod_lmg";
			break;

			case "30cal":
			weaponModel = "mounted_usa_30cal_bipod_lmg";
			break;
			
			case "30cal_bipod":
			weaponModel = "mounted_usa_30cal_bipod_lmg";
			break;

			case "bren":
			weaponModel = "mounted_brt_bren_bipod_lmg";
			break;
						
			case "bren_bipod":
			weaponModel = "mounted_brt_bren_bipod_lmg";
			break;
			
			case "bar":
			weaponModel = "mounted_usa_bar_bipod_lmg";
			break;
						
			case "bar_bipod":
			weaponModel = "mounted_usa_bar_bipod_lmg";
			break;
						
			// axis guns, MG42 needs new mounted version still			
			case "mg42":
			weaponModel = "weapon_ger_mg_mg42";
			break;
			
			case "mg42_bipod":
			weaponModel = "weapon_ger_mg_mg42";
			break;
						
			case "type99_lmg":
			weaponModel = "mounted_jap_type99_bipod_lmg";
			break;
						
			case "type99_lmg_bipod":
			weaponModel = "mounted_jap_type99_bipod_lmg";
			break;
						
			case "fg42":
			weaponModel = "mounted_ger_fg42_bipod_lmg";
			break;
						
			case "fg42_bipod":
			weaponModel = "mounted_ger_fg42_bipod_lmg";
			break;
			
			default:
			weaponModel = "weapon_saw_MG_Setup";
		}

		self useSelfPlacedTurret( weaponInfo, weaponModel );
	}
	else if ( IsDefined( self.node.turret ) )
	{
		self useStationaryTurret();
	}
	
	self AnimMode("normal");
	
	//start in Hide position
	if ( coverType == "crouch" && self.a.pose == "stand" )
	{
		transAnim = animArray( "stand_2_hide" );
		time = getAnimLength( transAnim );
		self SetAnimKnobAllRestart( transAnim, %body, 1, 0.2 );
		self thread animscripts\shared::moveToOriginOverTime( self.coverNode.origin, time );
		wait time;
		self.a.coverMode = "Hide";
	}
	else
	{
		loopHide( .4 ); // need to transition to Hide here in case we didn't do an approach
		self thread animscripts\shared::moveToOriginOverTime( self.coverNode.origin, .4 );
		wait( .2 );

		if ( coverType == "crouch" )
		{
			self.a.pose = "crouch";
		}

		wait( .2 );
	}

	self AnimMode("zonly_physics");

	if ( coverType == "crouch" )
	{
		if ( self.a.pose == "prone" )
		{
			self ExitProneWrapper(1);
		}

		self.a.pose = "crouch"; // in case we only lerped into the pose
	}

	if ( self.coverType == "stand" )
	{
		self.a.special = "cover_stand";
	}
	else
	{
		self.a.special = "cover_crouch";
	}

	behaviorCallbacks = SpawnStruct();
	behaviorCallbacks.reload				= ::coverReload;
	behaviorCallbacks.leaveCoverAndShoot	= ::leaveCoverAndShoot;
	behaviorCallbacks.look					= ::look;
	behaviorCallbacks.fastlook				= ::fastLook;
	behaviorCallbacks.idle					= ::idle;
	behaviorCallbacks.flinch				= ::flinch;
	behaviorCallbacks.grenade				= ::tryThrowingGrenade;
	behaviorCallbacks.grenadehidden			= ::tryThrowingGrenadeStayHidden;
	behaviorCallbacks.blindfire				= ::blindfire;
	behaviorCallbacks.resetWeaponAnims		= ::resetWeaponAnims;
		
	animscripts\cover_behavior::main( behaviorCallbacks );
}

initCoverCrouchNode()
{
	if ( IsDefined( self.crouchingIsOK ) )
	{
		return;
	}
	
	// it's only ok to crouch at this node if we can see out from a crouched position.
	crouchHeightOffset = (0,0,42);
	forward = AnglesToForward( self.angles );
	self.crouchingIsOK = sightTracePassed( self.origin + crouchHeightOffset, self.origin + crouchHeightOffset + vector_scale( forward, 64 ), false, undefined );
}

setup_cover_crouch( exposedAnimSet )
{
	self.rightAimLimit = 48;
	self.leftAimLimit = -48;
	self.upAimLimit = 45; 
	self.downAimLimit = -45; 		
}

setup_cover_stand()
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45; 
	self.downAimLimit = -45;
}

coverReload()
{
	Reload( 2.0, animArrayPickRandom( "reload" ) ); // (reload no matter what)
	return true;
}

leaveCoverAndShoot( theWeaponType, mode, suppressSpot )
{
	self.keepClaimedNodeInGoal = true;
	
	if ( !pop_up() )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room to pop up" );
		#/

		return false;
	}
	
	shootAsTold();
	
	self notify("kill_idle_thread");

	if ( IsDefined( self.shootPos ) )
	{
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );
		// too close for RPG or out of ammo
		
		if( animscripts\shared::shouldThrowDownWeapon() )
		{
			//println("cover_wall:shouldThrowDownWeapon was true"); // ALEXP_PRINT
			animscripts\shared::throwDownWeapon();

			resetWeaponAnims();
		}
	}

	go_to_hide();

	self.keepClaimedNodeInGoal = false;
	
	return true;
}

shootAsTold()
{
	self endon("return_to_cover");
	self endon("need_to_switch_weapons");

	self maps\_gameskill::didSomethingOtherThanShooting();

	while(1)
	{
		if ( self.shouldReturnToCover )
		{
			break;
		}

		if (!IsDefined(self.shootPos))
		{
			assert( !IsDefined( self.shootEnt ) );

			// give shoot_behavior a chance to iterate
			wait .05;
			waittillframeend;

			if ( IsDefined( self.shootPos ) )
			{
				continue;
			}

			break;
		}

		if ( !self.bulletsInClip )
		{
			break;
		}
		
		// crouch only
		if ( self.coverType == "crouch" && needToChangeCoverMode() )
		{
			break;
			
			// TODO: if changing between stances without returning to cover is implemented, 
			// we can't just endon("return_to_cover") because it will cause problems when it
			// happens while changing stance.
			// see corner's implementation of this idea for a better implementation.

			// NYI
			/*changeCoverMode();
			
			// if they're moving too fast for us to respond intelligently to them,
			// give up on firing at them for the moment
			if ( needToChangeCoverMode() )
				break;
			
			continue;*/
		}
		
		shootUntilShootBehaviorChange_coverWall();		

		if( CoverRechamber() )
		{
			// make sure his weapon always goes back afterwards
			self notify ( "weapon_rechamber_done" );	
		}

		// MikeD (10/11/2007): Stop the AI from firing his weapon when told to change his shoot behavior.
		self flamethrower_stop_shoot();	

		self ClearAnim( %add_fire, .2 );
		
	}
}

shootUntilShootBehaviorChange_coverWall()
{
	if ( self.coverType == "crouch" )
	{
		self thread angleRangeThread(); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	}

	self thread standIdleThread();
	
	shootUntilShootBehaviorChange();
}

idle()
{
	self endon("end_idle");

	while( 1 )
	{
		useTwitch = (RandomInt(2) == 0 && animArrayAnyExist("hide_idle_twitch"));
		if ( useTwitch && !self LookingAtEntity())
		{
			idleanim = animArrayPickRandom("hide_idle_twitch");
		}
		else
		{
			idleanim = animArray("hide_idle");
		}

		playIdleAnimation( idleAnim, useTwitch );
	}
}

flinch()
{
	if ( !animArrayAnyExist( "hide_idle_flinch" ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no flinch anim" );
		#/

		return false;
	}
	
	forward = AnglesToForward( self.angles );
	stepto = self.origin + vector_scale( forward, -16 );
	
	if ( !self mayMoveToPoint( stepto ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room to flinch" );
		#/

		return false;
	}
	
	self AnimMode("zonly_physics");
	self.keepClaimedNodeInGoal = true;
	
	flinchanim = animArrayPickRandom("hide_idle_flinch");
	playIdleAnimation( flinchanim, true );
	
	self.keepClaimedNodeInGoal = false;
	
	return true;
}

playIdleAnimation( idleAnim, needsRestart )
{
	if ( needsRestart )
	{
		self SetFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, 1);
	}
	else
	{
		self SetFlaggedAnimKnobAll       ( "idle", idleAnim, %body, 1, .1, 1);
	}
	
	self.a.coverMode = "Hide";
	
	self animscripts\shared::DoNoteTracks( "idle" );
}

look( lookTime )
{
	if ( !animArrayExist("hide_to_look") )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no look anim" );
		#/

		return false;
	}
	
	if ( !peekOut() )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room peek out" );
		#/

		return false;
	}
	
	animscripts\shared::playLookAnimation( animArray("look_idle"), lookTime ); // TODO: replace
	
	lookanim = undefined;
	if ( self isSuppressedWrapper() )
	{
		lookanim = animArray("look_to_hide_fast");
	}
	else
	{
		lookanim = animArray("look_to_hide");
	}
	
	self setflaggedanimknoballrestart( "looking_end", lookanim, %body, 1, .1 );
	animscripts\shared::DoNoteTracks( "looking_end" );
	
	return true;
}

peekOut()
{
	// no anim support for now
	if( usingPistol() )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no pistol anims" );
		#/

		return false;
	}

	// assuming no delta, so no maymovetopoint check
	
	self SetFlaggedAnimKnobAll( "looking_start", animArray("hide_to_look"), %body, 1, .2 );
	animscripts\shared::DoNoteTracks( "looking_start" );
	
	return true;
}

fastLook()
{
	self setFlaggedAnimKnobAllRestart( "look", animArrayPickRandom( "look" ), %body, 1, .1 );
	self animscripts\shared::DoNoteTracks( "look" );
	
	return true;
}

standIdleThread()
{
	self endon("killanimscript");

	if (!IsDefined(self.a.standIdleThread))
	{
		self.a.standIdleThread = true;

		self SetAnim( %add_idle, 1, .2 );
		standIdleThreadInternal();
		self ClearAnim( %add_idle, .2 );
	}
}

endStandIdleThread()
{
	self.a.standIdleThread = undefined;
	self notify("end_stand_idle_thread");
}

// TODO: need new idles for lean and crouch?
standIdleThreadInternal()
{
	self endon("killanimscript");
	self endon("end_stand_idle_thread");
	
	for( i = 0; ; i++ )
	{
		flagname = "idle" + i;

		if( isValidEnemy( self.enemy ) )
		{
			idleAnim = animArrayPickRandom( "exposed_idle" );
		}
		else
		{
			idleAnim = animArrayPickRandom( "exposed_idle_noncombat" );
		}
		
		self SetFlaggedAnimKnobLimitedRestart( flagname, idleAnim, 1, 0.2 );
		
		self waittillmatch( flagname, "end" );
	}
}

pop_up()
{
	assert( self.a.coverMode == "Hide" );
	
	newCoverMode = getBestCoverMode();
	
	popupAnim = animArray("hide_2_" + newCoverMode);
	
	if ( !self mayMoveToPoint( getAnimEndPos( popupAnim ) ) )
	{
		return false;
	}

	if ( self.coverType == "crouch" )
	{
		self setup_cover_crouch( newCoverMode );
	}
	else
	{
		self setup_cover_stand();
	}

	// play exposed pains/deaths unless aiming from cover_crouch
	if( newCoverMode != "crouch" )
	{
		self.a.special = "none";
	}

	self.a.coverMode = newCoverMode;
	self.changingCoverPos = true; self notify("done_changing_cover_pos");
	
	self AnimMode("zonly_physics");
	
	self setFlaggedAnimKnobAllRestart( "pop_up", popUpAnim, %body, 1 , .1, 1.0 );
	self thread DoNoteTracksForPopup( "pop_up" );

	if ( animHasNoteTrack( popupAnim, "start_aim" ) )
	{
		self waittillmatch( "pop_up", "start_aim" );
		timeleft = getAnimLength( popupAnim ) * (1 - self getAnimTime( popupAnim ));
	}
	else
	{
		self waittillmatch( "pop_up", "end" );
		timeleft = .1;
	}

//	if ( self.a.script == "cover_crouch" && IsDefined( self.a.coverMode ) && self.a.coverMode == "lean" )
//	{
//		self.pitchAngleOffset = -1 * anim.coverCrouchLeanPitch;
//	}
	
	self setup_additive_aim( timeleft );
	self thread animscripts\shared::trackShootEntOrPos();
	self ClearAnim( popUpAnim, timeleft + 0.05 );
	
	wait(timeleft);
	
	self.changingCoverPos = false;
	self.coverPosEstablishedTime = GetTime();
	
	self notify("stop_popup_donotetracks");
	
	return true;
}

DoNoteTracksForPopup( animname )
{
	self endon("killanimscript");
	self endon("stop_popup_donotetracks");
	self animscripts\shared::DoNoteTracks( animname );
}

setup_additive_aim( transTime )
{
	self SetAnimKnobAll(animArray(self.a.coverMode + "_aim"), %body, 1, transTime);

	self SetAnimLimited(animArray("add_aim_down"),1,0);
	self SetAnimLimited(animArray("add_aim_left"),1,0);
	self SetAnimLimited(animArray("add_aim_right"),1,0);
	self SetAnimLimited(animArray("add_aim_up"),1,0);
}

go_to_hide()
{
	self notify("return_to_cover");
	
	self.changingCoverPos = true; self notify("done_changing_cover_pos");
	
	self endStandIdleThread();

/#
	//SUMEET_TODO - take this block out once the issues are resolved.
	if( GetDvar( #"debug_script_issues") == "on" )
	{
		if( self.a.script != "cover_stand" && self.a.script != "cover_crouch"  )
		{
			Print( "AI is in cover wall script but its script is " + self.a.script );
			anything = undefined;
			if( anything )
			{
				// do nothing, this is just to halt the script debugger, as on AssetEx, it does not halt sometimes.
			}
		}
		//AssertEx( ( self.a.script == "cover_stand" ) || ( self.a.script == "cover_crouch" ) , "AI is in cover wall script but its script is " + self.a.script );
	}

#/

	self SetFlaggedAnimKnobAll( "go_to_hide" , animArray( self.a.coverMode + "_2_hide" ), %body, 1, 0.2 );
	self ClearAnim( %exposed_modern, 0.2 );
	
	self animscripts\shared::DoNoteTracks( "go_to_hide" );
	
	self notify( "stop tracking" );
	
	self.a.coverMode = "Hide";
	
	if ( self.coverType == "stand" )
	{
		self.a.special = "cover_stand";
	}
	else
	{
		self.a.special = "cover_crouch";
	}
	
	self.changingCoverPos = false;
}


tryThrowingGrenadeStayHidden( throwAt )
{
	// TODO: check suppression and add rambo grenade support
	return tryThrowingGrenade( throwAt, true );
}


tryThrowingGrenade( throwAt, safe )
{

/#
	//SUMEET_TODO - take this block out once the issues are resolved.
	if( GetDvar( #"debug_script_issues") == "on" )
	{
		if( self.a.script != "cover_stand" && self.a.script != "cover_crouch" && self.a.script != "cover_prone" )
		{
			Print( "AI is in cover wall script but its script is " + self.a.script );
			anything = undefined;
			if( anything )
			{
				// do nothing, this is just to halt the script debugger, as on AssetEx, it does not halt sometimes.
			}
		}
	
		//AssertEx( ( self.a.script == "cover_stand" ) || ( self.a.script == "cover_crouch" ) || ( self.a.script == "cover_prone" ) , "AI is in cover wall but its script is " + self.a.script );
	}

#/

	theanim = undefined;
	if( IsDefined(safe) && safe )
	{
		theanim = animArrayPickRandom("grenade_safe");
	}
	else
	{
		theanim = animArrayPickRandom("grenade_exposed");
	}
	
	self AnimMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	
	armOffset = (32,20,64); // needs fixing!
	threwGrenade = TryGrenade( throwAt, theanim );
	
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}


blindfire()
{
	if ( !animArrayAnyExist( "blind_fire" ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no blind fire anim" );
		#/

		return false;
	}
	
	self AnimMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;

	self SetFlaggedAnimKnobAll("blindfire", animArrayPickRandom("blind_fire"), %body, 1, 0, 1);
	result = self animscripts\shared::DoNoteTracks("blindfire");
	
	// SUMEET - Temp for feb 19th milestone. VC's can blindfire twice in a row
	if( IsDefined( self.animType ) && self.animType == "vc" && RandomInt( 100 ) > level.secondBlindfireChance )
	{
		self setFlaggedAnimKnobAllRestart("blindfire", animArrayPickRandom("blind_fire"), %body, 1, 0, 1);
		result = self animscripts\shared::DoNoteTracks("blindfire");
	}

	self.keepClaimedNodeInGoal = false;
	
	return true;
}


createTurret( posEnt, weaponInfo, weaponModel )
{
	turret = spawnTurret( "misc_turret", posEnt.origin, weaponInfo );
	turret.angles = posEnt.angles;
	turret.aiOwner = self;
	turret SetModel( weaponModel );
	turret makeTurretUsable();
	turret setDefaultDropPitch( 0 );

	if ( IsDefined( posEnt.leftArc ) )
	{
		turret.leftArc = posEnt.leftArc;
	}

	if ( IsDefined( posEnt.rightArc ) )
	{
		turret.rightArc = posEnt.rightArc;
	}

	if ( IsDefined( posEnt.topArc ) )
	{
		turret.topArc = posEnt.topArc;
	}

	if ( IsDefined( posEnt.bottomArc ) )
	{
		turret.bottomArc = posEnt.bottomArc;
	}

	return turret;
}

deleteIfNotUsed( owner )
{
	self endon("death");
	self endon("being_used");
	
	wait .1;
	
	if ( IsDefined( owner ) )
	{
		assert( !IsDefined( owner.a.usingTurret ) || owner.a.usingTurret != self );
		owner notify("turret_use_failed");
	}

	self delete();
}

useSelfPlacedTurret( weaponInfo, weaponModel )
{
	turret = self createTurret( self.node.turretInfo, weaponInfo, weaponModel );

	if ( self useTurret( turret ) )
	{
		turret thread deleteIfNotUsed( self );

		if (IsDefined(self.turret_function))
		{
			thread [[ self.turret_function ]]( turret );
		}

// 		self setAnimKnob( %cover, 0, 0 );
		self waittill("turret_use_failed"); // generally this won't notify, and we'll just not do any more cover_wall for now
	}
	else
	{
		turret delete();
	}
}


useStationaryTurret()
{
	assert( IsDefined( self.node ) );
	assert( IsDefined( self.node.turret ) );

	turret = self.node.turret;	
	if ( !turret.isSetup )
	{
		return;
	}

//	turret setmode( "auto_ai" ); // auto, auto_ai, manual, manual_ai
//	turret startFiring(); // seems to be a bug with the turret being in manual mode to start with
//	wait( 1 );
	thread maps\_mg_penetration::gunner_think( turret );
	self waittill( "continue_cover_script" );
	
//	turret thread maps\_spawner::restorePitch();
//	self useturret( turret ); // dude should be near the mg42
}

loopHide( transTime )
{
	if ( !IsDefined( transTime ) )
	{
		transTime = .1;
	}

	self SetAnimKnobAllRestart( animArray( "hide_idle" ), %body, 1, transTime );
	self.a.coverMode = "Hide";	
}

angleRangeThread()
{
	self endon ("killanimscript");
	self notify ("newAngleRangeCheck");
	self endon ("newAngleRangeCheck");
	self endon ("return_to_cover");

	while (1)
	{
		if ( needToChangeCoverMode() )
		{
			break;
		}

		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}

needToChangeCoverMode()
{
	if ( self.coverType != "crouch" )
	{
		return false;
	}
	
	pitch = getShootPosPitch( self getEye() );
	
	if ( self.a.coverMode == "lean" )
	{
		return pitch < 10;
	}
	else
	{
		return abs( pitch ) > 45;
	}
}

getBestCoverMode()
{
	if ( self.coverType != "crouch" )
	{
		return "stand";
	}

	/#
	dvarval = GetDvar( #"scr_crouchforcestance");
	if ( dvarval == "crouch" || dvarval == "stand" || dvarval == "lean" )
	{
		return dvarval;
	}
	#/

	pitch = getShootPosPitch( self.coverNode.origin + getNodeOffset( self.coverNode ) );
	
	if ( self.a.atConcealmentNode )
	{
		if ( pitch > 30 )
		{
			return "lean";
		}

		if ( pitch > 10 || !self.coverNode.crouchingIsOK )
		{
			return "stand";
		}

		return "crouch";
	}
	else
	{
		if ( pitch > 20 )
		{
			return "lean";
		}

		if ( pitch > 0 || !self.coverNode.crouchingIsOK )
		{
			return "stand";
		}

		return "crouch";
	}
}

getShootPosPitch( fromPos )
{
	shootPos = getEnemyEyePos();
	return AngleClamp180( VectorToAngles(shootPos - fromPos)[0] );
}

CoverRechamber()
{
	return animscripts\combat::exposedRechamber();
}

resetWeaponAnims()
{
	if ( self.coverType == "crouch" )
	{
		self setup_cover_crouch( self.a.coverMode );
	}
	else
	{
		self setup_cover_stand();
	}
}