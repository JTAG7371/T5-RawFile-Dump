/*
 * Feature Rusher
 *
 * Implementation: Sumeet Jakatdar
 *	
 * 
*/

// --------------------------------------------------------------------------------
// ---- Global TODO list ----
// --------------------------------------------------------------------------------


#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\anims_table;

#using_animtree( "generic_human" );
// ---------------------------------------------------------------------------------
// ---- inits rusher behavior, supposed to be called in the level main function ----
// ---------------------------------------------------------------------------------

init_rusher()
{
	// Constants
	level.RUSHER_DEFAULT_GOALRADIUS    = 64;
	level.RUSHER_DEFAULT_PATHENEMYDIST = 64;
	level.RUSHER_PISTOL_PATHENEMYDIST  = 300;
}

// ---------------------------------------------------------------------------------
// ---- Called by the level scripter, guy starts rushing towards the player ----
// ---------------------------------------------------------------------------------

rush( endon_flag, timeout )
{
	self endon("death");

	if( !IsAlive( self ) )
		return;

	// if this guy is a rusher already dont do this again
	if( IsDefined( self.rusher ) )
		return;

	// tell everyone that he is a rusher
	self.rusher = true;

	// move faster than usual, SUMEET_TODO - Eventually the actual animation will be faster
	// ALEXP: do we really still need this?
	if( self.animType == "vc" )
	{
		self.moveplaybackrate = 1.6;
	}

	// set the rusher type
	self set_rusher_type();

	// set rusher specific animations
	self setup_rusher_anims();

	// modify the goalradius of the AI so that he closes in to the player
	self.oldgoalradius 		= self.goalradius;
	self.goalradius    		= level.RUSHER_DEFAULT_GOALRADIUS;

	// don't want the pistol rusher to get close enough to melee
	if( self.rusherType == "pistol" )
	{
		// set the path enemy distance
		self.oldpathenemyFightdist	= self.pathenemyFightdist;
		self.pathenemyFightdist = level.RUSHER_PISTOL_PATHENEMYDIST;
	}
	else
	{
		// set the path enemy distance
		self.oldpathenemyFightdist	= self.pathenemyFightdist;
		self.pathenemyFightdist = level.RUSHER_DEFAULT_PATHENEMYDIST;

		// disable exits and arrivals
		self.disableExits = true;
		self.disableArrivals = true;
	}

	// dont react to the player anymore.	
	self disable_react();

	// ignore suppression, so that this AI will not stop if shot
	self.ignoresuppression = true;

	// give this AI more health
	self.health = self.health + 100;
	
	// get the closest player, making it co-op friendly
	player = get_closest_player( self.origin );

	// spawn in a goal entity and use that instead of the player
	self.rushing_goalent = Spawn( "script_origin", player.origin );
	self.rushing_goalent LinkTo( player );

	// keep setting the goal entity on the player - so we never loose him.
	self thread keep_rushing_player( player );

	// thread to swap wounded animation 
	if( !IsDefined( self.noWoundedRushing ) || self.noWoundedRushing == false )
	{
		self thread change_to_wounded();
	}

	// start yelling once in while, so that the player notices
	self thread rusher_yelling();

	// start a thread for wait for going back to normal behavior if needed
	if( IsDefined( endon_flag ) || IsDefined( timeout ) )
	{
		self thread rusher_go_back_to_normal( endon_flag, timeout );
	}
}

rusher_go_back_to_normal( endon_flag, timeout )
{
	self endon("death");

	if( IsDefined( timeout ) )
	{
		self thread notifyTimeOut( timeout, false, "stop_rushing_timeout" );
	}
	
	if( !IsDefined( endon_flag ) )
		endon_flag = "nothing"; // this will never be sent

	// waittill rushing needs to be stopped
	self waittill_any( endon_flag , "stop_rushing_timeout");

	// stop all the thread that are trying to rush this guy
	self notify("stop_rushing");

	self rusher_reset();
}

rusher_reset()
{
	// reset animations back to normal
	self reset_rusher_anims();

	// this AI is not a rusher anymore
	self.rusher = false;
	
	// rest the goalradius
	self.goalradius	= 	self.oldgoalradius;

	// reset the path enemy distance
	self.pathenemyFightdist = self.oldpathenemyFightdist;

	// move normal speed, SUMEET_TODO - Eventually the actual animation will be faster
	self.moveplaybackrate = 1;

	// enable reacting back again
	self enable_react();

	// get suppressed if fired upon
	self.ignoresuppression = false;

	// enable exits and arrivals
	self.disableExits = false;
	self.disableArrivals = false;

	//delete the goal entity attached to the player so that AI doesnt follow it anymore
	self.rushing_goalent Delete();
}


change_to_wounded()
{
	self endon( "death" );
	self endon("stop_rushing");

	self.isRusherWounded = false;
	woundedTrheshold = self.health - 100;

	while(1)
	{
		if( self.health > woundedTrheshold )
		{
			wait(0.05);
			continue;
		}
		
		// always move forward now
		self.alwaysRunForward = true;

		// slow him down
		self.moveplaybackrate = 1;

		// change the run cycle to the wounded run cycle
		setup_rusher_wounded_anim();
		break;
	}  
}

keep_rushing_player( player )
{
	self endon("death");
	self endon("stop_rushing");

	while(1)
	{
		// Attack the player
		self SetGoalEntity( self.rushing_goalent );
		self thread notifyTimeOut( 5, true, "timeout" );
		self waittill_any("goal", "timeout");
	}
}	

notifyTimeOut( timeout, endon_goal, notify_string )
{
	self endon ( "death" );
	self endon("stop_rushing");
	
	if( IsDefined( endon_goal ) && endon_goal )
	{
		self endon ( "goal" );
	}
	
	wait ( timeOut );
	
	self notify ( notify_string );
}


rusher_yelling()
{
	self endon("death");
	self endon("stop_rushing");

	if( IsDefined( self.noRusherYell ) && self.noRusherYell )
		return;

	while(1)
	{
		// wait for certain amount of time and play rushing sound_effect	
		// SUMEET_TODO - this should be replaced by DDS/Battlechatter system
		wait( RandomFloatRange( 1, 3 ) );
		self PlaySound ("chr_npc_charge_viet");
	}
}

set_rusher_type()
{
	if( self usingShotgun() )
	{
		self.rusherType			= "shotgun";
				
		self.perfectAim			= 1;
		self.noRusherYell		= true;
		self.noWoundedRushing	= true;
	}
	else if( self usingPistol() )
	{
		self.rusherType			= "pistol";

		self.noRusherYell		= true;
		self.noWoundedRushing	= true;
		self.disableIdleStrafing = true;
		self.disableArrivals	= true;
		self.disableExits		= true;
		self.disableReact		= true;
		self.disableTurns		= true;

		self.leftGunModel = Spawn("script_model", self.origin);
		self.leftGunModel SetModel( GetWeaponModel( self.weapon ) );
		self.leftGunModel UseWeaponHideTags( self.weapon );
		self.leftGunModel LinkTo( self, "tag_weapon_left", (0,0,0), (0,0,0) );

		self.rightGunModel = Spawn("script_model", self.origin);
		self.rightGunModel SetModel( GetWeaponModel( self.weapon ) );
		self.rightGunModel UseWeaponHideTags( self.weapon );
		self.rightGunModel LinkTo( self, "tag_weapon_right", (0,0,0), (0,0,0) );
		self.rightGunModel Hide();

		self.secondGunHand	= "left";

		self thread dualWeaponDropLogic();
		self thread fakeDualWieldShooting();
		self thread deleteFakeWeaponsOnDeath();
	}
	else
	{
		self.rusherType			= "default";

		if( self.animType == "spetsnaz" )
		{
			self.noRusherYell		= true;
			self.noWoundedRushing	= true;
		}
	}
}

fakeDualWieldShooting()
{
	self endon("death");

	while(1)
	{
		self waittill("shoot");

		if( self.secondGunHand == "left" )
		{
			self animscripts\shared::placeWeaponOn( self.weapon, "left" );

			self.leftGunModel Hide();
			self.rightGunModel Show();

			self.secondGunHand = "right";
		}
		else
		{
			self animscripts\shared::placeWeaponOn( self.weapon, "right" );

			self.leftGunModel Show();
			self.rightGunModel Hide();

			self.secondGunHand = "left";
		}
	}
}

deleteFakeWeaponsOnDeath()
{
	self waittill("death");

	self.leftGunModel Delete();
	self.rightGunModel Delete();
}

dualWeaponDropLogic()
{
	dualWeaponName = "";

	switch( self.weapon )
	{
		case "makarov_sp":
			dualWeaponName = "makarovdw_sp";
			break;

		case "cz75_sp":
			dualWeaponName = "cz75dw_sp";
			break;

		case "cz75_auto_sp":
			dualWeaponName = "cz75dw_auto_sp";
			break;

		case "python_sp":
			dualWeaponName = "pythondw_sp";
			break;

		case "m1911_sp":
			dualWeaponName = "m1911dw_sp";
			break;
	}

	if( IsAssetLoaded("weapon", dualWeaponName) )
	{
		self.script_dropweapon = dualWeaponName;
	}
}