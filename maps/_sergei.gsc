
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include animscripts\anims_table;
#using_animtree( "generic_human" );
init_sergei()
{	
	
	self.animname = "sergei";
	level.scr_anim[ self.animname ][ "run_cycle" ] = %ai_sergei_run_upright;
	set_run_anim( "run_cycle", 1 );
	
	self set_sergei_script_settings();
	
	
	self setup_sergei_anim_array();
	
	self setclientflag(15);
}
set_sergei_script_settings()
{	
	self.name				  = "Sergei";
	self.is_sergei			  = true;
	self.ignoreall 	 		  = true; 		
	self.ignoreme    		  = true;		
			
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.noDodgeMove 		  = true; 
	self.dontShootWhileMoving = true;
	self.disableIdleStrafing  = true;
	
	self.dropweapon           = false;
	self.a.oldgoalradius 	  = self.goalradius;
	self.goalradius 		  = 32;
	self.specialReact		  = true;	  
										  
	self.a.runOnlyReact		  = true;	
			
	self disable_pain(); 				  
	self PushPlayer( true ); 		      
	
	self gun_remove();					  
	self thread magic_bullet_shield();
	
	self.alwaysRunForward = true;		  	
}  
