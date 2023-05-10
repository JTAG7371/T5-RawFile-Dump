#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
null_ai_face_anims_func()
{
	
	anims = %faces;
	
	anims = %f_idle_casual_v1;
	
	anims = %f_idle_alert_v1;
	anims = %f_idle_alert_v2;
	anims = %f_idle_alert_v3;
	
	anims = %f_firing_v1;
	anims = %f_firing_v2;
	anims = %f_firing_v3;
	anims = %f_firing_v4;
	anims = %f_firing_v5;
	anims = %f_firing_v6;
	anims = %f_firing_v7;
	anims = %f_firing_v8;
	anims = %f_firing_v9;
	anims = %f_firing_v10;
	anims = %f_firing_v12;
	anims = %f_firing_v13;
	anims = %f_firing_v14;
	anims = %f_firing_v15;
	
	anims = %f_melee_v1;
	anims = %f_melee_v2;
	anims = %f_melee_v3;
	anims = %f_melee_v4;
	
	anims = %f_pain_v1;
	anims = %f_pain_v2;
	anims = %f_pain_v3;
	anims = %f_pain_v4;
	anims = %f_pain_v5;
	
	anims = %f_death_v1;
	anims = %f_death_v2;
	anims = %f_death_v3;
	anims = %f_death_v4;
	anims = %f_death_v5;
	anims = %f_death_v6;
	anims = %f_death_v7;
	anims = %f_death_v8;
	
	anims = %f_react_v1;
	anims = %f_react_v2;
	anims = %f_react_v3;
	anims = %f_react_v4;
	anims = %f_react_v5;
	
	anims = %f_running_v1;
	anims = %f_running_v2;
}
init_clientfaceanim()
{
	
	if ( isDefined(level.zombiemode) && level.zombiemode )
	{
		return;
	}
	
	self addAIEventListener( "grenade danger" );	
	self addAIEventListener( "bulletwhizby" );	
	self addAIEventListener( "projectile_impact" );	
	
	self thread watchfor_death();
	
	
	self thread watchfor_notify( "grenade danger", "face_alert" );
	self thread watchfor_notify( "bulletwhizby", "face_alert" );
	self thread watchfor_notify( "projectile_impact", "face_alert" );
	self thread watchfor_notify( "explode", "face_alert" );
	self thread watchfor_notify( "alert", "face_alert" );
	
	self thread watchfor_notify( "shoot", "face_shoot_single" );
	self thread watchfor_notify( "melee", "face_melee" );
	self thread watchfor_notify( "damage", "face_pain" );
}
watchfor_notify( svNotify, face_event )
{
	self endon( "death" );
	
	while( true )
	{
		self waittill ( svNotify );
		self SendFaceEvent( face_event );
	}
}
watchfor_death()
{
	self waittill( "death" );
	if ( isdefined( self ) )
		self SendFaceEvent( "face_death" );
}  
