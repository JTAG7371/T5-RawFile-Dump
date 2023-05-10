
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include maps\_prisoners_anim;
#include animscripts\anims_table;
#using_animtree( "generic_human" );
init_prisoners()
{
	setup_prisoners_override_animations();
}
make_prisoner() 
{
	self set_prisoner_script_settings();
	
	
	self set_prisoner_run_cycle("prisoner_run_cycle");
	
	self setup_prisoner_anims();
}
unmake_prisoner( weaponName ) 
{
	self endon("death");
	self reset_prisoner_script_settings( weaponName );
	self reset_prisoner_run_cycle();
	self reset_prisoner_anims();
}
set_prisoner_script_settings()
{
	self.is_prisoner 		  = true;		
	self.ignoreall 	 		  = true; 		
	self.ignoreme    		  = true;		
			
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.noDodgeMove 		  = false; 
	self.dontShootWhileMoving = true;
	
	self.dropweapon           = false;
	self.a.oldgoalradius 	  = self.goalradius;
	self.goalradius 		  = 32;
	self.specialReact		  = true;	
										
	self.a.runOnlyReact		  = true;	
			
	self disable_pain(); 				  
	self PushPlayer( true ); 		      
	
	self gun_remove();					  
	
	self.alwaysRunForward = true;		  	
}
reset_prisoner_script_settings( weaponName )
{
	self.is_prisoner 		  = false;		
	self.ignoreall 	 		  = false; 		
	self.ignoreme    		  = false;		
			
	self.grenadeawareness     = 1;
	self.badplaceawareness    = 1;
	self.ignoreSuppression    = false; 	
	self.noDodgeMove 		  = false; 
	self.dontShootWhileMoving = undefined;
	self.disableIdleStrafing  = true;
		
	self.dropweapon           = true;
	self.goalradius 		  = self.a.oldgoalradius;
	self.specialReact		  = undefined;		
	self.a.runOnlyReact		  = undefined;	
	self enable_pain(); 				  
	self PushPlayer( false ); 		      
	
	if( IsDefined( weaponName ) )	
		self gun_switchto( weaponName, "right" );
	else
		self gun_recall();					  
	
	self allowedStances( "stand", "crouch", "prone" );
	self.alwaysRunForward = undefined;		  	
}
set_prisoner_run_cycle( state )
{	
	
	if( IsDefined( self.animType ) && self.animType == "reznov" )
		self.a.combatrunanim	= %ai_prisoner_run_upright;
	else
		self.a.combatrunanim 	= level.prisoner[self.a.pose][state][ RandomInt( level.prisoner[self.a.pose][state].size ) ];
	self.run_noncombatanim  = self.a.combatrunanim;
	self.walk_combatanim 	= self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
}
reset_prisoner_run_cycle()
{	
	self.a.combatrunanim 	= undefined;
	self.run_noncombatanim  = undefined;
	self.walk_combatanim 	= undefined;
	self.walk_noncombatanim = undefined;
}  
