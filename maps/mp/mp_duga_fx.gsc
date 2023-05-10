#include maps\mp\_utility;
precache_util_fx()
{
}
precache_scripted_fx()
{
}
precache_createfx_fx()
{
	level._effect["fx_snow_gust_ground_sm_os"]						= loadfx("env/weather/fx_snow_gust_ground_sm_os");
	level._effect["fx_snow_gust_ground_xsm_os"]						= loadfx("env/weather/fx_snow_gust_ground_xsm_os");
	level._effect["fx_snow_md_gusty_lg"]									= loadfx("env/weather/fx_snow_md_gusty_lg");	
	level._effect["fx_snow_fog_field_sm"]							    = loadfx("env/weather/fx_snow_fog_field_sm");
	level._effect["fx_snow_fog_field_lg"]							    = loadfx("env/weather/fx_snow_fog_field_lg");			
	level._effect["fx_snow_tree_md_runner"] 							= loadfx("env/weather/fx_snow_tree_md_runner");	
	level._effect["fx_snow_gust_rooftop_slow"]						= loadfx("env/weather/fx_snow_gust_rooftop_slow");
	level._effect["fx_snow_gust_ground_lg_slow_distant"]= loadfx("env/weather/fx_snow_gust_ground_lg_slow_distant");		
	level._effect["fx_pipe_steam_md"]											= loadfx("env/smoke/fx_pipe_steam_md");
	level._effect["fx_mp_smk_tin_hat_steam_pipe"]					= loadfx("maps/mp_maps/fx_mp_smk_tin_hat_steam_pipe");
	level._effect["fx_water_drip_light_short"]						= loadfx("env/water/fx_water_drip_light_short");
	level._effect["fx_water_drip_light_long"]							= loadfx("env/water/fx_water_drip_light_long");	
	level._effect["fx_mp_fumes_vent_sm"]									= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm");
	level._effect["fx_mp_fumes_vent_sm_int"]							= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm_int");
	level._effect["fx_mp_fumes_vent_xsm_int"]							= loadfx("maps/mp_maps/fx_mp_fumes_vent_xsm_int");
	level._effect["fx_debris_papers"]											= loadfx("env/debris/fx_debris_papers");
	
	level._effect["fx_mp_elec_spark_burst_lg"]						= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_lg");
	level._effect["fx_mp_elec_spark_burst_sm"]						= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_sm");
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]			= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	level._effect["fx_light_fluorescent_tube_bulb"]				= loadfx("env/light/fx_light_fluorescent_tube_bulb");
	level._effect["fx_light_fluorescent_tube_bulb_set"]		= loadfx("env/light/fx_light_fluorescent_tube_bulb_set");
	level._effect["fx_light_floodlight_int_blue"]					= loadfx("env/light/fx_light_floodlight_int_blue");
	level._effect["fx_light_floodlight_ext_warm"]					= loadfx("env/light/fx_light_floodlight_ext_warm");
	level._effect["fx_light_tinhat_cage_white"]						= loadfx("env/light/fx_light_tinhat_cage_white");	
	level._effect["fx_light_beacon_red"]									= loadfx("env/light/fx_light_beacon_red_xlg");
	level._effect["fx_light_desk_lamp"]												= loadfx("env/light/fx_light_desk_lamp");
	
	level._effect["fx_light_godray_sm_warm"]							= loadfx("env/light/fx_light_godray_sm_warm");
	level._effect["fx_light_godray_md_warm"]							= loadfx("env/light/fx_light_godray_md_warm");
	
	level._effect["fx_mp_light_dust_motes_md"]						= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
}
wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); 
SetDvar( "wind_global_vector", "-90 -100 -90" );    
SetDvar( "wind_global_low_altitude", -175);    
SetDvar( "wind_global_hi_altitude", 4000);    
SetDvar( "wind_global_low_strength_percent", .5);    
}
main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	
	maps\mp\createfx\mp_duga_fx::main();
	maps\mp\createart\mp_duga_art::main();
	
	wind_initial_setting();
} 
  
