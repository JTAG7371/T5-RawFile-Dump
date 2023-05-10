
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include maps\_civilians_anim;
#using_animtree( "generic_human" );
init_civilians()
{
	
	self setup_civilian_override_animations();
	
	
	ai = GetSpawnerArray();
	civilians = [];
	for( i = 0; i< ai.size; i++ )
	{
		if( IsSubStr( ToLower( ai[i].classname ), "civilian" ) )
			civilians[civilians.size] = ai[i];
	}
	array_thread( civilians, ::add_spawn_function, ::civilian_spawn_init );
}
civilian_spawn_init( type )
{
	self.is_civilian 		  = true;		
	self.ignoreall 	 		  = true; 		
	self.ignoreme    		  = true;		
	self.allowdeath  		  = true; 		
		
	self.gibbed      		  = false; 
	self.head_gibbed 		  = false;
	
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead   = 0;
	self.badplaceawareness    = 0;
	self.chatInitialized      = false;
	self.dropweapon           = false; 
	
	self.goalradius 		  = 16;
	self.a.oldgoalradius 	  = self.goalradius;
	self.disableExits		  = true;
	self.disableArrivals	  = true;
	
	
	self.specialReact		  = true;	
										
	self.a.runOnlyReact		  = true;	
	self disable_pain(); 				  
	
	self PushPlayer( true ); 		      
	
	animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );
	self allowedStances( "stand" );       
	
	
	if( !IsDefined( level.civilian_health ) )
		level.civilian_health = 80;
	self.health = level.civilian_health; 
	
	self set_civilian_run_cycle("scared_run");
	
	self setup_civilian_attributes();
	
	self thread handle_civilian_sounds();
	
	self notify( "civilian_init_done" );
}
set_civilian_run_cycle( state )
{
	
	self.alwaysRunForward = true;
	
	self.a.combatrunanim 	= level.civilian[self.a.pose][state][ RandomInt( level.civilian[self.a.pose][state].size ) ];		
	self.run_noncombatanim  = self.a.combatrunanim;
	self.walk_combatanim 	= self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
}
handle_civilian_sounds()
{
	self endon( "death" );
	
	
	while(1)
	{
		if( self.a.script != "move" || self.a.movement != "run" )
		{
			wait(0.5);
			continue;
		}
		if( self.civilianSex == "male" )
		{
		    self playsound ("chr_civ_scream_male");
		}
		else
		{
		    self playsound ("chr_civ_scream_female");
		}
		
		wait( RandomIntRange( 2, 5 ) );
	}
}
setup_civilian_attributes()
{
	classname	= ToLower( self.classname );
	tokens		= StrTok( classname, "_" );
	
	if( ( tokens.size < 2 ) || ( tokens[1] != "civilian" ) ) 
		return;
		
	
	
	
	self.civilianSex = "male";
	if( IsSubStr( classname, "female" ) )
		self.civilianSex = "female";
	
	
	self.nationality = "default";
	if( IsSubStr( classname, "viet" ) )
		self.nationality = "viet";
	else if( IsSubStr( classname, "russian" ) )
		self.nationality = "russian";
}