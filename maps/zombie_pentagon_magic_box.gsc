#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
magic_box_init()
{
	
	
	level._pentagon_no_power = "n";
	level._pentagon_fire_sale = "f";
	level._box_locations = array(	"level1_chest", 
																"level1_chest2", 
																"level2_chest", 
																"start_chest", 
																"start_chest2", 
																"start_chest3" ); 
																
	level thread magic_box_update();
}
get_location_from_chest_index( chest_index )
{
	if( IsDefined( level.chests[ chest_index ] ) )
	{
		chest_loc = level.chests[ chest_index ].script_noteworthy;
		
		for(i = 0; i < level._box_locations.size; i ++)
		{
			if( level._box_locations[i] == chest_loc )
			{
				return i;
			}
		}
	}
	
	
	
}
magic_box_update()
{
	
	wait(2);
	
	setclientsysstate( "box_indicator", level._pentagon_no_power ); 
	
	
	
	box_mode = "no_power";
	
	
	
	
	
	
	
	
	
	while( 1 )
	{		
		
		if( ( !flag( "power_on" ) || flag( "moving_chest_now" ) )
				&& level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 0 ) 
		{
			box_mode = "no_power";
		}
		else if( IsDefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) 
						&& level.zombie_vars["zombie_powerup_fire_sale_on"] == 1 )
		{
			box_mode = "fire_sale";
		}
		else
		{
			box_mode = "box_available";
		}
		
		
		switch( box_mode )
		{
			case "no_power":
				setclientsysstate( "box_indicator", level._pentagon_no_power );	
				while( !flag( "power_on" )
								&& level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 0 )
				{
					wait( 0.1 );
				}
				break;
				
			case "fire_sale":
				setclientsysstate( "box_indicator", level._pentagon_fire_sale );	
				while ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 1 )
				{
					wait( 0.1 );
				}
				
				break;
				
			case "box_available":
				setclientsysstate( "box_indicator", get_location_from_chest_index( level.chest_index ) );
				while( !flag( "moving_chest_now" ) 
								&& level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 0 )
				{
					wait( 0.1 );
				}
				break;
				
			default:
				setclientsysstate( "box_indicator", level._pentagon_no_power );	
				break;
				
				
		}
		wait( 1.0 );
	}
}