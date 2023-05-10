#include maps\mp\_utility; 
precache_util_fx()
{
	
}
precache_scripted_fx()
{
	
}
#using_animtree ( "fxanim_props" );
precache_fx_prop_anims()
{
	level.cairo_fxanims = [];
	level.cairo_fxanims["fxanim_cuba_line_flag01_anim"] = %fxanim_cuba_line_flag01_anim;
}
precache_createfx_fx()
{
  level._effect["fx_mp_light_dust_motes_md"]                = loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
  level._effect["fx_light_godray_lrg_warm"]                 = loadfx("env/light/fx_light_godray_lrg_warm");
  level._effect["fx_light_office_light_03"]                 = loadfx("env/light/fx_light_office_light_03");
  level._effect["fx_light_overhead_sm_warm"]                = loadfx("env/light/fx_light_overhead_sm_warm");  
  level._effect["fx_debris_papers"]                         = loadfx("env/debris/fx_debris_papers");
  
  level._effect["fx_water_splash_fountain"]                 = loadfx("env/water/fx_water_splash_fountain");
  level._effect["fx_insects_swarm_md_light"]                = loadfx("bio/insects/fx_insects_swarm_md_light");
  level._effect["fx_seagulls_shore_distant"]								= loadfx("bio/animals/fx_seagulls_shore_distant");
  
  level._effect["fx_mp_fumes_vent_sm"]                      = loadfx("maps/mp_maps/fx_mp_fumes_vent_sm");
  level._effect["fx_mp_fumes_haze_md"]                      = loadfx("maps/mp_maps/fx_mp_fumes_haze_md");
  
	level._effect["fx_mp_fog_ground_md"]											= loadfx("maps/mp_maps/fx_mp_fog_ground_md");	
	level._effect["fx_fogrolling_ground_md"]          				= loadfx("env/smoke/fx_fog_rolling_ground_md");
	level._effect["fx_fog_interior_md"]          							= loadfx("env/smoke/fx_fog_interior_md");
	level._effect["fx_fog_rolling_vista_lg"]      						= loadfx("env/smoke/fx_fog_rolling_vista_lg");
	
	
	level._effect["fx_debris_papers_dust_devil"]      				= loadfx("env/debris/fx_debris_papers_dust_devil");
	
	level._effect["fx_mp_elec_spark_burst_sm"]								= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_sm");
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
}
wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); 
SetDvar( "wind_global_vector", "-110 -150 -110" );    
SetDvar( "wind_global_low_altitude", -175);    
SetDvar( "wind_global_hi_altitude", 4000);    
SetDvar( "wind_global_low_strength_percent", .5);    
}
main()
{
	
	
	precache_util_fx();
  precache_createfx_fx();
	precache_scripted_fx();
	precache_fx_prop_anims();
	
	maps\mp\createfx\mp_cairo_fx::main();
	
	maps\mp\createart\mp_cairo_art::main();
	
	wind_initial_setting();
}