
main()
{
	level.tweakfile = true;
 
	
	setdvar("scr_fog_exp_halfplane", "3759.28");
	setdvar("scr_fog_exp_halfheight", "243.735");
	setdvar("scr_fog_nearplane", "601.593");
	setdvar("scr_fog_red", "0.806694");
	setdvar("scr_fog_green", "0.962521");
	setdvar("scr_fog_blue", "0.9624");
	setdvar("scr_fog_baseheight", "-475.268");
	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
start_dist = 494.723;
	half_dist = 4902.47;
	half_height = 1102.96;
	base_height = 52.9608;
	fog_r = 0.647059;
	fog_g = 0.733333;
	fog_b = 0.796079;
	fog_scale = 3.5;
	sun_col_r = 1;
	sun_col_g = 0.670588;
	sun_col_b = 0.533333;
	sun_dir_x = -0.942282;
	sun_dir_y = 0.24178;
	sun_dir_z = 0.231618;
	sun_start_ang = 0;
	sun_stop_ang = 73.3458;
	time = 0;
	max_fog_opacity = 0.975633;
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
          
	VisionSetNaked( "mp_crisis", 0 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.4 );
	SetDvar( "r_lightGridContrast", 0.3 );
} 
 
  
