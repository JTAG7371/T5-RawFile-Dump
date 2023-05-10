#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree( "critter" );
main()
{
	level.scr_anim[ "pig" ][ "pig_hoist_squirm" ][0]	= %a_rebirth_pig_hoist_squirm;
	level.scr_anim[ "pig" ][ "pig_hoist_death" ]	= %a_rebirth_pig_hoist_death;
	level.scr_anim[ "pig" ][ "pig_hoist_deathpose" ][0]	= %a_rebirth_pig_hoist_deathpose;
	
	level thread lab_pigs();	
}
#using_animtree( "critter" );
lab_pigs()
{
	level waittill( "start_of_round" );
	hoist_piggy = getent("hoist_pig","targetname");
	hoist_pig_struct_model = Spawn("script_model", hoist_piggy.origin + (0, 0, 22));
	hoist_pig_struct_model.angles = hoist_piggy.angles + (0, -90, 0);
	hoist_pig_struct_model SetModel( "tag_origin" );
	hoist_piggy LinkTo(hoist_pig_struct_model);
	hoist_piggy.animname = "pig";
	hoist_piggy UseAnimTree( #animtree );
	
	hoist_pig_struct_model thread anim_loop( hoist_piggy, "pig_hoist_squirm", "stop_squirming" );
	
	hoist_piggy SetCanDamage( true );
	hoist_piggy.health = 99999;
	
	hoist_piggy thread pig_audio();
	
	hoist_piggy waittill ( "damage", damage, attacker, direction_vec, point);
	
	hoist_piggy StopSounds();
	hoist_piggy PlaySound( "amb_pig_death" );
	
	hoist_piggy notify( "stop_squirming" );
	hoist_pig_struct_model anim_single( hoist_piggy, "pig_hoist_death" );
	hoist_pig_struct_model anim_loop( hoist_piggy, "pig_hoist_deathpose" );
}
pig_audio()
{
    self endon( "stop_squirming" );
    
    while(1)
    {
        self PlaySound( "amb_pig", "sounddone" );
        self waittill( "sounddone" );
        wait(RandomFloatRange( .75, 1.75 ) );
    }
}  
