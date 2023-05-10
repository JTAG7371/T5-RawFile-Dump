#include maps\mp\_utility; 
precache_util_fx()
{
	
}
precache_scripted_fx()
{
	level._effect["rocket_blast_trail"]							= loadfx("vehicle/exhaust/fx_russian_rocket_exhaust_mp");
	level._effect["mig_trail"]											= loadfx("trail/fx_geotrail_jet_contrail");
	level._effect["rocket_explosion"]								= loadfx("maps/flashpoint/fx_exp_rocket_soyuz");
}
precache_createfx_fx()
{
	level._effect["fx_smoke_plume_xlg_blk"]								= loadfx("env/smoke/fx_smoke_plume_xlg_blk");	
	level._effect["fx_smk_vent"]													= loadfx("maps/mp_maps/fx_mp_smk_vent");
	level._effect["fx_smk_plume_md_wht_wispy"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_md_wht_wispy");
	level._effect["fx_mp_smk_tin_hat_steam_pipe"]					= loadfx("maps/mp_maps/fx_mp_smk_tin_hat_steam_pipe");
	level._effect["fx_smk_linger_lit"]										= loadfx("maps/mp_maps/fx_mp_smk_linger");
		
	level._effect["fx_water_drip_light_long"]							= loadfx("env/water/fx_water_drip_light_long");	
	level._effect["fx_water_drip_light_short"]						= loadfx("env/water/fx_water_drip_light_short");	
	
	level._effect["fx_insect_swarm"]											= loadfx("maps/creek/fx_insect_swarm");
	level._effect["fx_debris_papers"]											= loadfx("env/debris/fx_debris_papers");
	level._effect["fx_pipe_steam_md"]											= loadfx("env/smoke/fx_pipe_steam_md");
	level._effect["fx_fumes_vent_sm"]											= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm");
	level._effect["fx_fumes_haze_md"]											= loadfx("maps/mp_maps/fx_mp_fumes_haze_md");
	level._effect["fx_coolant_gas_md"]										= loadfx("env/smoke/fx_coolant_gas_md");
	
	level._effect["fx_sand_windy_fast_sm_os"]							= loadfx("maps/mp_maps/fx_mp_sand_windy_fast_sm_os");
	level._effect["fx_sand_windy_fast_door_os"]						= loadfx("maps/mp_maps/fx_mp_sand_windy_fast_door_os");
	level._effect["fx_sand_windy_heavy_sm"]								= loadfx("maps/mp_maps/fx_mp_sand_windy_heavy_sm");
	level._effect["fx_mp_sand_blowing_lg"]								= loadfx("maps/mp_maps/fx_mp_sand_blowing_lg");	
	level._effect["fx_mp_sand_blowing_xlg"]								= loadfx("maps/mp_maps/fx_mp_sand_blowing_xlg");
	level._effect["fx_mp_sand_blowing_xlg_distant"]				= loadfx("maps/mp_maps/fx_mp_sand_blowing_xlg_distant");
	level._effect["fx_mp_sand_windy_pcloud_lg"]						= loadfx("maps/mp_maps/fx_mp_sand_windy_pcloud_lg");	
	
	level._effect["fx_mp_distortion_heat_field_lg"]				= loadfx("maps/mp_maps/fx_mp_distortion_heat_field_lg");		
	level._effect["fx_mp_distortion_heat_field_sm"]				= loadfx("maps/mp_maps/fx_mp_distortion_heat_field_sm");
	
	level._effect["fx_mp_elec_spark_burst_sm"]						= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_sm");
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]			= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	
	level._effect["fx_light_beacon_red"]									= loadfx("env/light/fx_light_beacon_red");
	level._effect["fx_light_beacon_yllw_distant"]					= loadfx("env/light/fx_light_beacon_yllw_distant");	
	level._effect["fx_tower_light_glow"] 									= loadfx("maps/flashpoint/fx_tower_light_glow");	
	
	level._effect["fx_light_floodlight_int_yllw"]					= loadfx("env/light/fx_light_floodlight_int_yllw");	
	
	level._effect["fx_mp_light_dust_motes_md"]						= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	
	level._effect["fx_gantry_coolant_lg"]									= loadfx("maps/flashpoint/fx_gantry_coolant_lg");
	level._effect["fx_gantry_coolant_md"]									= loadfx("maps/mp_maps/fx_mp_cosmodrome_rocket_coolant_md");
}
main()
{
	maps\mp\createart\mp_cosmodrome_art::main();
	
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	maps\mp\createfx\mp_cosmodrome_fx::main();
	SetDvar( "enable_global_wind", 1 );
	SetDvar( "wind_global_vector", "1 0 0" );   
	SetDvar( "wind_global_low_altitude", 0 );
	SetDvar( "wind_global_hi_altitude", 0 );
	SetDvar( "wind_global_low_strength_percent", 1 );
}