#include maps\mp\_destructible;
#using_animtree( "mp_vehicles" );
makeType( destructibleType )
{
	
	
	
	infoIndex = getInfoIndex( destructibleType );
	if ( infoIndex >= 0 )
	{
		
		return infoIndex;
	}
	
	
	
	switch( destructibleType )
	{
		case "vehicle_80s_sedan1_green":
			vehicle_80s_sedan1( "green" );
			break;
		case "vehicle_80s_sedan1_red":
			vehicle_80s_sedan1( "red" );
			break;
		case "vehicle_80s_sedan1_silv":
			vehicle_80s_sedan1( "silv" );
			break;
		case "vehicle_80s_sedan1_tan":
			vehicle_80s_sedan1( "tan" );
			break;
		case "vehicle_80s_sedan1_yel":
			vehicle_80s_sedan1( "yel" );
			break;
		case "vehicle_80s_sedan1_brn":
			vehicle_80s_sedan1( "brn" );
			break;
		case "vehicle_80s_wagon1_green":
			vehicle_80s_wagon1( "green" );
			break;
		case "vehicle_80s_wagon1_red":
			vehicle_80s_wagon1( "red" );
			break;
		case "vehicle_80s_wagon1_silv":
			vehicle_80s_wagon1( "silv" );
			break;
		case "vehicle_80s_wagon1_tan":
			vehicle_80s_wagon1( "tan" );
			break;
		case "vehicle_80s_wagon1_yel":
			vehicle_80s_wagon1( "yel" );
			break;
		case "vehicle_80s_wagon1_brn":
			vehicle_80s_wagon1( "brn" );
			break;
		case "vehicle_80s_hatch1_green":
			vehicle_80s_hatch1( "green" );
			break;
		case "vehicle_80s_hatch1_red":
			vehicle_80s_hatch1( "red" );
			break;
		case "vehicle_80s_hatch1_silv":
			vehicle_80s_hatch1( "silv" );
			break;
		case "vehicle_80s_hatch1_tan":
			vehicle_80s_hatch1( "tan" );
			break;
		case "vehicle_80s_hatch1_yel":
			vehicle_80s_hatch1( "yel" );
			break;
		case "vehicle_80s_hatch1_brn":
			vehicle_80s_hatch1( "brn" );
			break;
		case "vehicle_80s_hatch2_green":
			return -1;
		case "vehicle_small_wagon_blue":
			vehicle_small_wagon( "blue" );
			break;
		case "vehicle_small_wagon_green":
			vehicle_small_wagon( "green" );
			break;
		case "vehicle_small_wagon_turq":
			vehicle_small_wagon( "turq" );
			break;
		case "vehicle_small_wagon_white":
			vehicle_small_wagon( "white" );
			break;
		case "vehicle_small_hatch_blue":
			vehicle_small_hatch( "blue" );
			break;
		case "vehicle_small_hatch_green":
			vehicle_small_hatch( "green" );
			break;
		case "vehicle_small_hatch_turq":
			vehicle_small_hatch( "turq" );
			break;
		case "vehicle_small_hatch_white":
			vehicle_small_hatch( "white" );
			break;
		case "vehicle_uaz_fabric":
			vehicle_uaz_fabric( destructibleType );
			break;
			
		default:
			assertMsg( "Destructible object 'destructible_type' key/value of '" + destructibleType + "' is not valid" );
			break;
	}
	
	infoIndex = getInfoIndex( destructibleType );
	assert( infoIndex >= 0 );
	return infoIndex;
}
getInfoIndex( destructibleType )
{
	if ( !isdefined( level.destructible_type ) )
		return -1;
	if ( level.destructible_type.size == 0 )
		return -1;
	
	for( i = 0 ; i < level.destructible_type.size ; i++ )
	{
		if ( destructibleType == level.destructible_type[ i ].v[ "type" ] )
			return i;
	}
	
	
	return -1;
}
vehicle_80s_sedan1( color )
{
	
	
	
	destructible_create( "vehicle_80s_sedan1_" + color, 250, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible_mp", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible_mp", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible_mp", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible_mp", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/fx_default_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 375, 20, 300 ); 	
				
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destroyed", undefined, 32, "no_melee" );
		
		
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_hood", undefined, undefined, undefined, undefined, 1.0, 2.5 );
		
		tag = "tag_trunk";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_trunk", undefined, undefined, undefined, undefined, 1.0 );
		
		destructible_part( "tag_wheel_front_right", "vehicle_80s_sedan1_" + color + "_wheel_LF", undefined, undefined, undefined, "no_melee", undefined, 0.7 );
		destructible_part( "tag_wheel_back_right", "vehicle_80s_sedan1_" + color + "_wheel_LF", undefined, undefined, undefined, "no_melee", undefined, 0.7 );
		
		destructible_part( "tag_door_left_front", "vehicle_80s_sedan1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_80s_sedan1_" + color + "_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_sedan1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_80s_sedan1_" + color + "_door_RB", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_F", 40 );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_glass_F_dam", 60 );
			destructible_fx( "tag_glass_front_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_B", 40 );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_glass_B_dam", 60 );
			destructible_fx( "tag_glass_back_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LF", 20, undefined );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_glass_LF_dam", 60, "vehicle_80s_sedan1_" + color + "_door_LF" );
			destructible_fx( "tag_glass_left_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RF", 20, undefined );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_glass_RF_dam", 60, "vehicle_80s_sedan1_" + color + "_door_RF" );
			destructible_fx( "tag_glass_right_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LB", 20, undefined );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_glass_LB_dam", 60, "vehicle_80s_sedan1_" + color + "_door_LB" );
			destructible_fx( "tag_glass_left_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RB", 20, undefined );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_glass_RB_dam", 60, "vehicle_80s_sedan1_" + color + "_door_RB" );
			destructible_fx( "tag_glass_right_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_" + color + "_light_LF_dam" );
		
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_" + color + "_light_RF_dam" );
		
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_" + color + "_light_LB_dam" );
		
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_sedan1_" + color + "_light_RB_dam" );
		
		destructible_part( "tag_bumper_front", "vehicle_80s_sedan1_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_80s_sedan1_" + color + "_bumper_B", undefined, undefined, undefined, undefined, undefined, 1.0 );
		
		destructible_part( "tag_mirror_left", "vehicle_80s_sedan1_" + color + "_mirror_L", 40, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_sedan1_" + color + "_mirror_R", 40, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		
}
vehicle_80s_wagon1( color )
{
	
	
	
	destructible_create( "vehicle_80s_wagon1_" + color, 250, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible_mp", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible_mp", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible_mp", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible_mp", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/fx_default_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 250, 20, 300 ); 	
				
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destroyed", undefined, 32, "no_melee" );
		
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
		
		
		
		destructible_part( "tag_door_left_front", "vehicle_80s_wagon1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_80s_wagon1_" + color + "_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_wagon1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_80s_wagon1_" + color + "_door_RB", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_F", 40 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_F_dam", 60 );
			destructible_fx( "tag_glass_front_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_B", 40 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_B_dam", 60 );
			destructible_fx( "tag_glass_back_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LF", 20 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_LF_dam", 60 );
			destructible_fx( "tag_glass_left_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RF", 20 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_RF_dam", 60 );
			destructible_fx( "tag_glass_right_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LB", 20 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_LB_dam", 60 );
			destructible_fx( "tag_glass_left_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RB", 20 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_RB_dam", 60 );
			destructible_fx( "tag_glass_right_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_back2";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LB2", 20 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_LB2_dam", 60 );
			destructible_fx( "tag_glass_left_back2_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back2";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RB2", 20 );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_glass_RB2_dam", 60 );
			destructible_fx( "tag_glass_right_back2_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_LF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_" + color + "_light_LF_dam" );
		
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_RF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_" + color + "_light_RF_dam" );
		
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_LB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_" + color + "_light_LB_dam" );
		
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_RB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_wagon1_" + color + "_light_RB_dam" );
		
		destructible_part( "tag_bumper_front", "vehicle_80s_wagon1_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0, 0.7 );
		destructible_part( "tag_bumper_back", "vehicle_80s_wagon1_" + color + "_bumper_B", undefined, undefined, undefined, undefined, undefined, 0.6 );
		
		destructible_part( "tag_mirror_left", "vehicle_80s_wagon1_" + color + "_mirror_L", 40 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_wagon1_" + color + "_mirror_R", 40 );
			destructible_physics();
}
vehicle_80s_hatch1( color )
{
	
	
	
	destructible_create( "vehicle_80s_hatch1_" + color, 250, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible_mp", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible_mp", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2 );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible_mp", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible_mp", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/fx_default_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 250, 20, 300 ); 	
				
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destroyed", undefined, 32, "no_melee" );
		
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
		
		
		
		destructible_part( "tag_door_left_front", "vehicle_80s_hatch1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_hatch1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_hatch1_glass_F", 40 );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_glass_F_dam", 60 );
			destructible_fx( "tag_glass_front_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_hatch1_glass_B", 40 );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_glass_B_dam", 60 );
			destructible_fx( "tag_glass_back_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_hatch1_glass_LF", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_glass_LF_dam", 60 );
			destructible_fx( "tag_glass_left_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_hatch1_glass_RF", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_glass_RF_dam", 60 );
			destructible_fx( "tag_glass_right_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_hatch1_glass_LB", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_glass_LB_dam", 60 );
			destructible_fx( "tag_glass_left_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_hatch1_glass_RB", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_glass_RB_dam", 60 );
			destructible_fx( "tag_glass_right_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_LF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_" + color + "_light_LF_dam" );
		
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_RF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_" + color + "_light_RF_dam" );
		
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_LB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_" + color + "_light_LB_dam" );
		
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_RB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch1_" + color + "_light_RB_dam" );
		
		destructible_part( "tag_bumper_front", "vehicle_80s_hatch1_" + color + "_bumper_F" );
		destructible_part( "tag_bumper_back", "vehicle_80s_hatch1_" + color + "_bumper_B" );
		
		destructible_part( "tag_mirror_left", "vehicle_80s_hatch1_" + color + "_mirror_L", 40 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_hatch1_" + color + "_mirror_R", 40 );
			destructible_physics();
}
vehicle_small_wagon( color )
{
	
	
	
	destructible_create( "vehicle_small_wagon_" + color, 250, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible_mp", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible_mp", 100, "player_only", 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2 );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible_mp", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible_mp", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/fx_default_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 250, 20, 300 ); 	
				
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destroyed", undefined, 32, "no_melee" );
		
		tag = "tag_hood";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
		
		
		
		destructible_part( "tag_door_left_front", "vehicle_small_wagon_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_small_wagon_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_small_wagon_glass_F", 40 );
			destructible_state( tag+"_d", "vehicle_small_wagon_glass_F_dam", 60 );
			destructible_fx( "tag_glass_front_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_small_wagon_glass_B", 40 );
			destructible_state( tag+"_d", "vehicle_small_wagon_glass_B_dam", 60 );
			destructible_fx( "tag_glass_back_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_small_wagon_glass_LF", 20 );
			destructible_state( tag+"_d", "vehicle_small_wagon_glass_LF_dam", 60 );
			destructible_fx( "tag_glass_left_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_small_wagon_glass_RF", 20 );
			destructible_state( tag, "vehicle_small_wagon_glass_RF_dam", 60 );
			destructible_fx( "tag_glass_right_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_small_wagon_glass_LB", 20 );
			destructible_state( tag+"_d", "vehicle_small_wagon_glass_LB_dam", 60 );
			destructible_fx( "tag_glass_left_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_small_wagon_glass_RB", 20 );
			destructible_state( tag, "vehicle_small_wagon_glass_RB_dam", 60 );
			destructible_fx( "tag_glass_right_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_LF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_wagon_" + color + "_light_LF_dam" );
		
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_RF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_wagon_" + color + "_light_RF_dam" );
		
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_LB", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_wagon_" + color + "_light_LB_dam" );
		
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_RB", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_wagon_" + color + "_light_RB_dam" );
		
		destructible_part( "tag_bumper_front", "vehicle_small_wagon_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_small_wagon_" + color + "_bumper_B", undefined, undefined, undefined, undefined, 0.5 );
		
		destructible_part( "tag_mirror_left", "vehicle_small_wagon_" + color + "_mirror_L", 40, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_small_wagon_" + color + "_mirror_R", 40, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
}
vehicle_small_hatch( color )
{
	
	
	
	destructible_create( "vehicle_small_hatch_" + color, 250, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible_mp", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible_mp", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 15, 0.25 );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible_mp", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible_mp", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/fx_default_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 250, 20, 300 ); 	
				
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destroyed", undefined, 32, "no_melee" );
		
		tag = "tag_hood";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
		
		
		
		destructible_part( "tag_door_left_front", "vehicle_small_hatch_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_small_hatch_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_small_hatch_glass_F", 40 );
			destructible_state( tag+"_d", "vehicle_small_hatch_glass_F_dam", 60 );
			destructible_fx( "tag_glass_front_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_small_hatch_glass_B", 40 );
			destructible_state( tag+"_d", "vehicle_small_hatch_glass_B_dam", 60 );
			destructible_fx( "tag_glass_back_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_small_hatch_glass_LF", 20 );
			destructible_state( tag+"_d", "vehicle_small_hatch_glass_LF_dam", 60 );
			destructible_fx( "tag_glass_left_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_small_hatch_glass_RF", 20 );
			destructible_state( tag+"_d", "vehicle_small_hatch_glass_RF_dam", 60 );
			destructible_fx( "tag_glass_right_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_small_hatch_glass_LB", 20 );
			destructible_state( tag+"_d", "vehicle_small_hatch_glass_LB_dam", 60 );
			destructible_fx( "tag_glass_left_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_small_hatch_glass_RB", 20 );
			destructible_state( tag+"_d", "vehicle_small_hatch_glass_RB_dam", 60 );
			destructible_fx( "tag_glass_right_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_LF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_hatch_" + color + "_light_LF_dam" );
		
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_RF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_hatch_" + color + "_light_RF_dam" );
		
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_LB", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_hatch_" + color + "_light_LB_dam" );
		
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_RB", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_small_hatch_" + color + "_light_RB_dam" );
		
		destructible_part( "tag_bumper_front", "vehicle_small_hatch_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_small_hatch_" + color + "_bumper_B", undefined, undefined, undefined, undefined, 0.5 );
		
		destructible_part( "tag_mirror_left", "vehicle_small_hatch_" + color + "_mirror_L", 40, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_small_hatch_" + color + "_mirror_R", 40, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
}
vehicle_80s_hatch2( color )
{
	
	
	
	destructible_create( "vehicle_80s_hatch2_" + color, 250, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible_mp", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible_mp", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2 );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible_mp", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible_mp", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/fx_default_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 250, 20, 300 ); 	
				
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destroyed", undefined, 32, "no_melee" );
		
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
		
		
		
		destructible_part( "tag_door_left_front", "vehicle_80s_hatch2_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_hatch2_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_hatch2_glass_F", 40 );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_glass_F_dam", 60 );
			destructible_fx( "tag_glass_front_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_hatch2_glass_B", 40 );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_glass_B_dam", 60 );
			destructible_fx( "tag_glass_back_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_hatch2_glass_LF", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_glass_LF_dam", 60 );
			destructible_fx( "tag_glass_left_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_hatch2_glass_RF", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_glass_RF_dam", 60 );
			destructible_fx( "tag_glass_right_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_hatch2_glass_LB", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_glass_LB_dam", 60 );
			destructible_fx( "tag_glass_left_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_hatch2_glass_RB", 20 );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_glass_RB_dam", 60 );
			destructible_fx( "tag_glass_right_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_LF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_" + color + "_light_LF_dam" );
		
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_RF", 20, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_" + color + "_light_RF_dam" );
		
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_LB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_" + color + "_light_LB_dam" );
		
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_RB", 20 );
			destructible_fx( tag, "destructibles/fx_break_glass_car_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag+"_d", "vehicle_80s_hatch2_" + color + "_light_RB_dam" );
		
		destructible_part( "tag_bumper_front", "vehicle_80s_hatch2_" + color + "_bumper_F" );
		destructible_part( "tag_bumper_back", "vehicle_80s_hatch2_" + color + "_bumper_B" );
		
		destructible_part( "tag_mirror_left", "vehicle_80s_hatch2_" + color + "_mirror_L", 40 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_hatch2_" + color + "_mirror_R", 40 );
			destructible_physics();
}
vehicle_uaz_fabric( destructibleType )
{
	destructible_create( "vehicle_uaz_fabric_", 500, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_uaz_fabric_destructible_mp", 100, undefined, 32, "no_melee" );
				destructible_fx( "tag_origin", "explosions/fx_default_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 250, 150, 300 ); 	
			destructible_state( undefined, "vehicle_uaz_fabric_dsr");
		
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_uaz_glass_F", 40 );
			destructible_state( tag+"_d", "vehicle_uaz_glass_F_dam", 60 );
			destructible_fx( "tag_glass_front_fx", "destructibles/fx_break_glass_car_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_uaz_glass_LF", 99 );
			destructible_state( tag+"_d", "vehicle_uaz_glass_LF_dam", 60 );
			destructible_fx( "tag_glass_left_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_uaz_glass_RF", 99 );
			destructible_state( tag+"_d", "vehicle_uaz_glass_RF_dam", 60 );
			destructible_fx( "tag_glass_right_front_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_uaz_glass_LB", 99 );
			destructible_state( tag+"_d", "vehicle_uaz_glass_LB_dam", 60 );
			destructible_fx( "tag_glass_left_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_uaz_glass_RB", 99 );
			destructible_state( tag+"_d", "vehicle_uaz_glass_RB_dam", 60 );
			destructible_fx( "tag_glass_right_back_fx", "destructibles/fx_break_glass_car_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
}  
