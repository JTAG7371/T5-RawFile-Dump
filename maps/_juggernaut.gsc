
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include animscripts\anims_table;
#using_animtree( "generic_human" );
make_juggernaut()
{
	if( !IsDefined( level.JUGGERNAUT_HEALTH ) )
	{
		level.JUGGERNAUT_GOALRADIUS        = 128;
		level.JUGGERNAUT_GOALHEIGHT        = 81;
		level.JUGGERNAUT_HEALTH            = 1500;
		level.JUGGERNAUT_MINDAMAGE         = 150;
		level.JUGGERNAUT_SPRINTDISTSQ      = 500 * 500;
		level.JUGGERNAUT_SPRINTTTIME	   = 3 * 1000;
	}
	
	self.overrideActorDamage			= ::juggernaut_damage_override;	
	self.juggernaut = true;
	
	
	self.allowdeath  		  = true; 		
	self.gibbed      		  = false; 
	self.head_gibbed 		  = false;
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.grenadeAmmo		  = 0;					
	self.disableExits		  = true;
	self.disableArrivals	  = true;
	self.a.disableLongDeath   = true;
	self.disableTurns		  = true;
	self.pathEnemyFightDist	  = 128;
	self.pathenemylookahead   = 128;
	self.noreload			  = true;
	self.disableIdleStrafing  = true;
	
	self.script_accuracy = 0.7;
	self.baseAccuracy = 0.7;
	
	self.health				  = level.JUGGERNAUT_HEALTH;
	self.minPainDamage		  = level.JUGGERNAUT_MINDAMAGE;
	self enable_additive_pain( true ); 
	self PushPlayer( true ); 		      
	self disable_react();
	self allowedStances( "stand" );
	
	
	set_juggernaut_run_cycles();
	setup_juggernaut_anim_array();
	self setclientflag(14);
	self thread juggernaut_hunt_immediately_behavior();
	level notify( "juggernaut_spawned" );
}
set_juggernaut_run_cycles()
{
	self animscripts\anims::clearAnimCache();
	self.a.combatrunanim 	= %Juggernaut_walkF;
	self.run_noncombatanim  = self.a.combatrunanim;
	self.walk_combatanim 	= self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
}
juggernaut_hunt_immediately_behavior()
{
	self endon("death");
	while (1)
	{
		if( isdefined( self.enemy ) )
		{
			self setgoalpos( self.enemy.origin );
			self.goalradius = level.JUGGERNAUT_GOALRADIUS;
			self.goalheight = level.JUGGERNAUT_GOALHEIGHT;
			if( DistanceSquared( self.origin, self.enemy.origin ) > level.JUGGERNAUT_SPRINTDISTSQ || !( self canSee( self.enemy ) ) )
			{
				self.sprintStartTime = GetTime();
				self.sprint = true;
			}
			else if(    ( DistanceSquared( self.origin, self.enemy.origin ) < level.JUGGERNAUT_SPRINTDISTSQ )
				     || ( IsDefined( self.sprintStartTime ) && ( GetTime() > self.sprintStartTime + level.JUGGERNAUT_SPRINTTTIME ) )
				    )
			{
				self.sprintStartTime = undefined;
				self.sprint = false;
			}
		}
		
		wait .5;
	}
}
juggernaut_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime)
{
	Assert( IsDefined( self.minPainDamage ) );
		
	
	isHeadShot = ( sHitLoc == "head" || sHitLoc == "helmet" );
	if( isHeadShot )
		return self.health;
	
	
	damage = iDamage;
	
	if( sWeapon == "ak47_gl_sp" &&  sMeansOfDeath == "MOD_RIFLE_BULLET" ) 
		damage = int( iDamage );
	else if( sWeapon == "ak47_gl_sp" ) 
		damage = self.health;
		
	
	if( sMeansOfDeath == "MOD_EXPLOSIVE" || sMeansOfDeath == "MOD_EXPLOSIVE_SPLASH" 
			|| sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		
		if( DistanceSquared( vPoint, self.origin ) > 150 * 150 )
			damage = iDamage;
		else
			damage = self.health;	
	}
		
	
	if( sWeapon == "minigun_sp" )
		damage = int( iDamage * 1.5 );
	
	
	if( weaponClass( sWeapon ) == "spread" )
		damage = iDamage;
			
	return damage;
} 
 
 
  
