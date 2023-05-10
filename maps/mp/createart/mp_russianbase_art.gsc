
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
	start_dist = 766.193;
	half_dist = 2768.59;
	half_height = 1317.26;
	base_height = -63.5022;
	fog_r = 0.372549;
	fog_g = 0.45098;
	fog_b = 0.466667;
	fog_scale = 10;
	sun_col_r = 0.941177;
	sun_col_g = 0.729412;
	sun_col_b = 0.545098;
	sun_dir_x = 0.953783;
	sun_dir_y = 0.0318239;
	sun_dir_z = 0.298805;
	sun_start_ang = 14.4854;
	sun_stop_ang = 40.7814;
	time = 0;
	max_fog_opacity = 1;
	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	VisionSetNaked( "mp_russianbase", 0 );
	SetDvar( "r_lightGridEnableTweaks", 1 );
	SetDvar( "r_lightGridIntensity", 1.31 );
	SetDvar( "r_lightGridContrast", 0.31 );
} 
 
 
