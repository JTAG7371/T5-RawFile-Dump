
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include animscripts\anims_table;
#using_animtree( "generic_human" );
make_baton_guard()
{
	
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	
	batonModel = getWeaponModel( "baton_sp" );
	self.baton = Spawn( "script_model", self GetTagOrigin("tag_weapon_right") );
	self.baton.angles = self GetTagAngles("tag_weapon_right");
	self.baton SetModel( batonModel );
	self.baton LinkTo( self, "tag_weapon_right" );
	
	
	self set_baton_guard_run_cycles();
	self setup_baton_guard_anim_array();
	
	self disable_react();	
	self allowedStances( "stand" );
	self.disableExits		  = true;
	self.disableArrivals	  = true;
	self.a.disableLongDeath   = true;
	self.disableTurns		  = true;
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.grenadeAmmo		  = 0;
	self.disableIdleStrafing  = true;
	self.dontShootWhileMoving = true;
	self.a.allow_shooting	  = false;
	self.baton_guard		  = true;
	
	self.health				  = 1;
	self thread baton_guard_hunt_immediately_behavior();
	self thread baton_guard_get_closer_if_melee_blocked();
	self thread baton_guard_drop_baton_on_death();
	level notify( "baton_guard_spawned" );
}
make_machete_guard()
{
	
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	
	self.baton = Spawn( "script_model", self GetTagOrigin("tag_weapon_right") );
	self.baton.angles = self GetTagAngles("tag_weapon_right");
	self.baton SetModel( "t5_weapon_machete" );
	self.baton LinkTo( self, "tag_weapon_right" );
	
	
	self set_baton_guard_run_cycles();
	self setup_baton_guard_anim_array();
	
	self disable_react();	
	self allowedStances( "stand" );
	self.disableExits		  = true;
	self.disableArrivals	  = true;
	self.a.disableLongDeath   = true;
	self.disableTurns		  = true;
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.grenadeAmmo		  = 0;
	self.disableIdleStrafing  = true;
	self.dontShootWhileMoving = true;
	self.a.allow_shooting	  = false;
	self.baton_guard		  = true;
	
	self.health				  = 1;
	self thread baton_guard_hunt_immediately_behavior();
	self thread baton_guard_get_closer_if_melee_blocked();
	self thread baton_guard_drop_baton_on_death();
	level notify( "baton_guard_spawned" );
}
baton_guard_hunt_immediately_behavior()
{
	self endon("death");
	self.pathEnemyFightDist = 0;
	while (1)
	{
		if( isdefined( self.enemy ) )
		{
			self SetGoalEntity( self.enemy );
			self.goalradius = 199; 
		}
		else
		{
			self SetGoalPos( self.origin );
			self.goalradius = 32;
		}
		
		wait .5;
	}
}
set_baton_guard_run_cycles()
{
	self animscripts\anims::clearAnimCache();
	self.a.combatrunanim 	= %ai_baton_run_f;
	self.run_noncombatanim  = self.a.combatrunanim;
	self.walk_combatanim 	= self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.alwaysRunForward	= true;
}
baton_guard_get_closer_if_melee_blocked()
{
	self endon("death");
	while(1)
	{
		self waittill("melee_path_blocked");
		if( isdefined( self.enemy ) )
		{
			self SetGoalEntity( self.enemy );
			self.goalradius = 32;
		}
		else
		{
			self SetGoalPos( self.origin );
			self.goalradius = 32;
		}
	}
}
baton_guard_drop_baton_on_death()
{
	self waittill("death");
	baton = self.baton;
	baton Unlink();
	baton PhysicsLaunch();
	wait(60);
	
	baton Delete();
}