
#include common_scripts\utility;
#include animscripts\Utility;
#include maps\_anim;
#using_animtree( "generic_human" );
setup_civilian_override_animations()
{
	
	level.civilian["stand"]["scared_run"] = array( 
												  %civilian_run_hunched_A,
												  %civilian_run_hunched_B,
												  %civilian_run_hunched_C,
												  %civilian_run_upright	
												 );
}
	
civilian_ai_idle_and_react( guy, idle_anim, reaction_anim, tag, react_flag )
{
	ender = react_flag;
	
	if( !guy is_civilian() )
		Assert( "civilian_ai_idle_and_react function should only be called on civilian AI" );
	
	self thread maps\_anim::anim_generic_loop( guy, idle_anim, ender );
	self civilian_ai_set_custom_animation_reaction( self, reaction_anim, tag, ender );
}
civilian_ai_set_custom_animation_reaction( node, animation, tag, ender )
{
	self endon("death");
	
	self waittill( ender );
	
	self civilian_animation_react( node, animation, tag );	
}
civilian_animation_react( node, animation, tag )
{
	self endon( "death" );
	self endon( "pain_death" );
	
	if ( IsDefined( tag ) )
	{
		node anim_generic_aligned( self, animation, tag );
	}
	else
	{
		node anim_generic_custom_animmode( self, "gravity", animation );
	}
}