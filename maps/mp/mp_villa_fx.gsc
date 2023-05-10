#include maps\mp\_utility; 
precache_util_fx()
{
}
precache_scripted_fx()
{
}
precache_createfx_fx()
{
	level._effect["fx_lightning_flash_single_lg"]						= loadfx("env/weather/fx_lightning_flash_single_lg");
	
	level._effect["fx_chandelier_candle"]										= loadfx("maps/cuba/fx_cuba_chandelier_candle");
	level._effect["fx_light_floodlight_int_blue"]						= loadfx("env/light/fx_light_floodlight_int_blue");
	level._effect["fx_light_floodlight_ext_warm"]						= loadfx("env/light/fx_light_floodlight_ext_warm");	
	
	level._effect["fx_mp_light_dust_motes_md"]							= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	level._effect["fx_mp_light_gray_warm_md"]								= loadfx("maps/mp_maps/fx_mp_light_gray_warm_md");
	level._effect["fx_water_splash_fountain"]               = loadfx("env/water/fx_water_splash_fountain_lg");
	
	level._effect["fx_insects_moths_light_source_md"]				= loadfx("bio/insects/fx_insects_moths_light_source_md");
	level._effect["fx_insects_moths_flutter"]								= loadfx("bio/insects/fx_insects_moths_flutter");	
	level._effect["fx_seagulls_shore_distant"]							= loadfx("bio/animals/fx_seagulls_shore_distant");
	level._effect["fx_sand_windy_heavy_sm_slow"]						= loadfx("maps/mp_maps/fx_mp_sand_windy_heavy_sm_slow");
	
	level._effect["fx_fog_low"]															= loadfx("maps/mp_maps/fx_mp_fog_md_slow");
	
	level._effect["fx_cuba_waves_shorebreak"]								= loadfx("maps/mp_maps/fx_mp_waves_shorebreak_mp");
	level._effect["fx_cuba_waves_shoreline"]								= loadfx("maps/mp_maps/fx_mp_waves_shoreline_mp");
	level._effect["fx_fire_sm"]															= loadfx("env/fire/fx_fire_sm");
	
	level._effect["fx_leaves_blowing"]											= loadfx("env/foliage/fx_leaves_blowing");
}
wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); 
SetDvar( "wind_global_vector", "-125 -150 -125" );    
SetDvar( "wind_global_low_altitude", -175);    
SetDvar( "wind_global_hi_altitude", 4000);    
SetDvar( "wind_global_low_strength_percent", .5);    
}
main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	maps\mp\createfx\mp_villa_fx::main();
	maps\mp\createart\mp_villa_art::main();
	
	wind_initial_setting();
}  
