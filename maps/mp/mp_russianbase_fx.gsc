#include maps\mp\_utility;
main()
{
    maps\mp\createfx\mp_russianbase_fx::main();
    maps\mp\createart\mp_russianbase_art::main();
    precachefx();
    spawnfx();
    
    wind_initial_setting();
}
wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); 
SetDvar( "wind_global_vector", "-110 -160 -140" );    
SetDvar( "wind_global_low_altitude", -175);    
SetDvar( "wind_global_hi_altitude", 4000);    
SetDvar( "wind_global_low_strength_percent", .5);    
}
precachefx()
{
	
	level._effect["fx_snow_light_lg"]										= loadfx("env/weather/fx_snow_light_lg");
	level._effect["fx_snow_gust_rooftop"]								= loadfx("env/weather/fx_snow_gust_rooftop_slow");
	level._effect["fx_snow_gust_ground_lg_slow_distant"]= loadfx("env/weather/fx_snow_gust_ground_lg_slow_distant");		
	level._effect["fx_snow_windy_heavy_md"] 						= loadfx("env/weather/fx_snow_windy_heavy_md_slow");   
	
	
	level._effect["fx_mp_snow_gust_door_low"]						= loadfx("maps/mp_maps/fx_mp_snow_gust_door_low_slow");	
	level._effect["fx_mp_snow_wall_hvy_loop_sm"] 				= loadfx("maps/mp_maps/fx_mp_snow_wall_hvy_os_sm_slow_lt");
	
	
	level._effect["fx_debris_papers"]										= loadfx("env/debris/fx_debris_papers");
	level._effect["fx_pipe_steam_md"] 									= loadfx("maps/mp_maps/fx_mp_pipe_steam_md");
	level._effect["fx_water_drip_light_short"]					= loadfx("env/water/fx_water_drip_light_short");	
	level._effect["fx_water_drip_light_long"]						= loadfx("env/water/fx_water_drip_light_long");	
	level._effect["fx_mp_oil_drip_short"]								= loadfx("maps/mp_maps/fx_mp_oil_drip_short");		
	level._effect["fx_fumes_vent_sm_int"]								= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm_int");
	level._effect["fx_jungle_generator_prop"]						= loadfx("props/fx_jungle_generator_prop");	
	
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]		= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	level._effect["fx_mp_elec_spark_burst_lg"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_lg");
	
	
	level._effect["fx_fire_barrel_small"] 							= loadfx("env/fire/fx_fire_barrel_small");
	
	
	
	level._effect["fx_light_godray_wmd_md"]             = loadfx("maps/wmd/fx_light_godray_wmd_md"); 
	
	level._effect["fx_light_tinhat_cage_white"]					= loadfx("env/light/fx_light_tinhat_cage_white");	
	level._effect["fx_light_floodlight_int_blue"]				= loadfx("env/light/fx_light_floodlight_int_blue");
	
	level._effect["fx_mp_light_dust_motes_md"]					= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	
	
	
	level._effect["fx_smk_plume_lg_grey_wispy"]					= loadfx("env/smoke/fx_smk_plume_lg_grey_wispy");
	level._effect["fx_mp_smk_smolder_sm"]								= loadfx("maps/mp_maps/fx_mp_smk_smolder_sm");	
	level._effect["fx_smk_vent"]												= loadfx("maps/mp_maps/fx_mp_smk_vent");	
	level._effect["fx_smk_fire_sm_white"]								= loadfx("env/smoke/fx_smk_fire_sm_white");
	level._effect["fx_mp_smk_tin_hat_steam_pipe"]				= loadfx("maps/mp_maps/fx_mp_smk_tin_hat_steam_pipe");
	
	
	
	level._effect["fx_smoke_train"]									= loadfx("maps/Vorkuta/fx_smoke_train");
}
spawnfx()
{
}