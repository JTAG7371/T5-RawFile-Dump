
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
	start_dist = 445.857;
	half_dist = 5404;
	half_height = 2301.01;
	base_height = 90.6808;
	fog_r = 0.423529;
	fog_g = 0.501961;
	fog_b = 0.533333;
	fog_scale = 7.36099;
	sun_col_r = 0.8;
	sun_col_g = 0.745098;
	sun_col_b = 0.592157;
	sun_dir_x = 0.919175;
	sun_dir_y = 0.325392;
	sun_dir_z = 0.221896;
	sun_start_ang = 0;
	sun_stop_ang = 57.6513;
	time = 0;
	max_fog_opacity = 1;
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
                    
	
	VisionSetNaked( "mp_cairo", 0 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.39 );
	SetDvar( "r_lightGridContrast", 0.3);
	
} 
  
