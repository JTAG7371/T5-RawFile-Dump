
main()
{
	level.tweakfile = true;
 
	
	setdvar("scr_fog_exp_halfplane", "3696");
	setdvar("scr_fog_exp_halfheight", "2000");
	setdvar("scr_fog_nearplane", "68");
	setdvar("scr_fog_red", "5.27");
	setdvar("scr_fog_green", "6.23");
	setdvar("scr_fog_blue", "7.79");
	setdvar("scr_fog_baseheight", "300");
	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1.8");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
	start_dist = 649.839;
	half_dist = 5285.41;
	half_height = 1049.34;
	base_height = 151.145;
	fog_r = 0.427451;
	fog_g = 0.654902;
	fog_b = 0.823529;
	fog_scale = 7.58431;
	sun_col_r = 0.760784;
	sun_col_g = 0.945098;
	sun_col_b = 1;
	sun_dir_x = -0.536698;
	sun_dir_y = -0.569565;
	sun_dir_z = 0.622536;
	sun_start_ang = 0;
	sun_stop_ang = 120.492;
	time = 0;
	max_fog_opacity = 1;
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	VisionSetNaked( "mp_havoc", 0 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.25 );
	SetDvar( "r_lightGridContrast", 0.21 );
} 
 
  
