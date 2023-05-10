#include maps\mp\_utility;
#include common_scripts\utility; 
main()
{
	
	maps\mp\mp_hanoi_fx::main();
	maps\mp\_load::main();
	if ( GetDvarInt( #"xblive_wagermatch" ) == 1 )
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_hanoi_wager"); 
	}
	else
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_hanoi"); 
	}
	maps\mp\mp_hanoi_amb::main();
	
	
	maps\mp\gametypes\_teamset_junglemarines::level_init();
	
	setdvar("compassmaxrange","2100");
	
	
	
	
	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAPNAME_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAPNAME_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAPNAME_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAPNAME_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAPNAME_E";
	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAPNAME_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAPNAME_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAPNAME_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAPNAME_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAPNAME_E";
	
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	level thread spotlight_function();
}
spotlight_function()
{
	spot_light_model = GetEnt("large_spot_light","targetname");
	AssertEX( IsDefined( spot_light_model ), "'large_spot_light' model is not defined" );
	primary_spot_light = GetEnt("scr_floodlight", "targetname");
	AssertEX( IsDefined( primary_spot_light ), "'scr_floodlight' light is not defined" );
	
	
	spot_light_model RotateYaw( -30, 4);
	primary_spot_light RotateYaw( -30, 4);
	spot_light_model waittill("rotatedone");
	
	
	
	PlayFXOnTag(level._effect["spotlight"],spot_light_model,"tag_flash");
	
	spot_light_angle_change = 60;
	spot_light_speed = 6;
	
	
	while(1)
	{
		spot_light_model RotateYaw(spot_light_angle_change, spot_light_speed);
		primary_spot_light RotateYaw(spot_light_angle_change, spot_light_speed);
		spot_light_model waittill("rotatedone");
		spot_light_model RotateYaw((spot_light_angle_change * -1), spot_light_speed);
		primary_spot_light RotateYaw((spot_light_angle_change * -1), spot_light_speed);
		spot_light_model waittill("rotatedone");
	}	
}