#include common_scripts\Utility;

#using_animtree ("generic_human");

setup_female_anim_array( animType, array )
{
	assert( IsDefined(array) && IsArray(array) );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["stop"]["crouch"]["rifle"]["idle_trans"]				= %ai_fem_casual_crouch_idle_in;
	array[animType]["stop"]["crouch"]["rifle"]["idle"]						= array( array(%ai_fem_casual_crouch_idle, %ai_fem_casual_crouch_idle, %ai_fem_casual_crouch_idle, %ai_fem_casual_crouch_idle, %ai_fem_casual_crouch_twitch, %ai_fem_casual_crouch_twitch, %ai_fem_casual_crouch_point) );

	array[animType]["stop"]["stand"]["rifle"]["idle_trans"]					= %ai_fem_casual_stand_idle_trans_in;
	array[animType]["stop"]["stand"]["rifle"]["idle"]						= array(
																				array(%ai_fem_casual_stand_idle, %ai_fem_casual_stand_idle, %ai_fem_casual_stand_idle_twitch, %ai_fem_casual_stand_idle_twitchB),
																				array(%ai_fem_casual_stand_v2_idle, %ai_fem_casual_stand_v2_idle, %ai_fem_casual_stand_v2_twitch_radio, %ai_fem_casual_stand_v2_twitch_shift, %ai_fem_casual_stand_v2_twitch_shift, %ai_fem_casual_stand_v2_twitch_talk)
																			  );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Stop Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_left"]["stand"]["rifle"]["alert_to_look"]		= %ai_fem_corner_standL_alert_2_look;

	array[animType]["cover_left"]["stand"]["rifle"]["alert_idle"]			= %ai_fem_corner_standL_alert_idle;
	array[animType]["cover_left"]["stand"]["rifle"]["alert_idle_twitch"]	= array(
																					%ai_fem_corner_standL_alert_twitch01,
																					%ai_fem_corner_standL_alert_twitch02,
																					%ai_fem_corner_standL_alert_twitch03,
																					%ai_fem_corner_standL_alert_twitch04,
																					%ai_fem_corner_standL_alert_twitch05,
																					%ai_fem_corner_standL_alert_twitch06,
																					%ai_fem_corner_standL_alert_twitch07
																				);

	array[animType]["cover_left"]["stand"]["rifle"]["alert_idle_flinch"]	= array( %ai_fem_corner_standL_flinch );

	array[animType]["cover_left"]["stand"]["rifle"]["blind_fire"]			= array( %ai_fem_corner_standL_blindfire_v1, %ai_fem_corner_standL_blindfire_v2 );

	array[animType]["cover_left"]["stand"]["rifle"]["look_to_alert"]		= %ai_fem_corner_standL_look_2_alert;
	array[animType]["cover_left"]["stand"]["rifle"]["look_idle"]			= %ai_fem_corner_standL_look_idle;

	array[animType]["cover_left"]["stand"]["rifle"]["reload"]				= array( %ai_fem_corner_standL_reload_v1 );

	array[animType]["cover_left"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_fem_corner_standl_trans_alert_2_a );
	array[animType]["cover_left"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_fem_corner_standL_trans_A_2_alert );
	array[animType]["cover_left"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_fem_corner_standL_trans_A_2_B );
	array[animType]["cover_left"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_fem_corner_standL_trans_B_2_alert );
 	array[animType]["cover_left"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_fem_corner_standL_trans_B_2_A );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Left Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["cover_right"]["stand"]["rifle"]["alert_to_look"]		= %ai_fem_corner_standr_alert_2_look;

	array[animType]["cover_right"]["stand"]["rifle"]["alert_idle"]			= %ai_fem_corner_standr_alert_idle;
	array[animType]["cover_right"]["stand"]["rifle"]["alert_idle_twitch"]	= array(
																					%ai_fem_corner_standR_alert_twitch01,
																					%ai_fem_corner_standR_alert_twitch02,
																					%ai_fem_corner_standR_alert_twitch03,
																					%ai_fem_corner_standR_alert_twitch04,
																					%ai_fem_corner_standR_alert_twitch05,
																					%ai_fem_corner_standR_alert_twitch06,
																					%ai_fem_corner_standR_alert_twitch07
																				);

	array[animType]["cover_right"]["stand"]["rifle"]["alert_idle_flinch"]	= array( %ai_fem_corner_standr_flinch );

	array[animType]["cover_right"]["stand"]["rifle"]["blind_fire"]			= array( %ai_fem_corner_standR_blindfire_v1, %ai_fem_corner_standR_blindfire_v2 );
	
	// SUMEET_TODO - Female only have cover right set, in COD7 we are not using females currently
	array[animType]["cover_right"]["stand"]["rifle"]["rambo"]				= array( %ai_fem_corner_standr_rambo_med );
	array[animType]["cover_right"]["stand"]["rifle"]["rambo_jam"]			= array( %ai_fem_corner_standr_rambo_jam );

	// SUMEET_TODO - replace animation with real 45 degree version
	array[animType]["cover_right"]["stand"]["rifle"]["rambo_45"]			= array( %ai_fem_corner_standr_rambo_med );		

	array[animType]["cover_right"]["stand"]["rifle"]["look_to_alert"]		= %ai_fem_corner_standR_look_2_alert;
	array[animType]["cover_right"]["stand"]["rifle"]["look_to_alert_fast"]	= %ai_fem_corner_standR_look_2_alert_fast;
	array[animType]["cover_right"]["stand"]["rifle"]["look_idle"]			= %ai_fem_corner_standR_look_idle;

	array[animType]["cover_right"]["stand"]["rifle"]["reload"]				= array( %ai_fem_corner_standR_reload_v1 );

	array[animType]["cover_right"]["stand"]["rifle"]["alert_to_A"]			= array( %ai_fem_corner_standR_trans_alert_2_a );
	array[animType]["cover_right"]["stand"]["rifle"]["A_to_alert"]			= array( %ai_fem_corner_standR_trans_A_2_alert );
	array[animType]["cover_right"]["stand"]["rifle"]["A_to_B"    ]			= array( %ai_fem_corner_standR_trans_A_2_B );
	array[animType]["cover_right"]["stand"]["rifle"]["B_to_alert"]			= array( %ai_fem_corner_standR_trans_B_2_alert );
 	array[animType]["cover_right"]["stand"]["rifle"]["B_to_A"    ]			= array( %ai_fem_corner_standR_trans_B_2_A );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Right Stand Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][1]				= %ai_fem_corner_standL_trans_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][2]				= %ai_fem_corner_standL_trans_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][3]				= %ai_fem_corner_standL_trans_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][4]				= %ai_fem_corner_standL_trans_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][6]				= %ai_fem_corner_standL_trans_IN_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][7]				= %ai_fem_corner_standL_trans_IN_7;
	array[animType]["move"]["stand"]["rifle"]["arrive_left"][8]				= %ai_fem_corner_standL_trans_IN_8;
	//array[animType]["move"]["stand"]["rifle"]["arrive_left"][9]			= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["arrive_right"][1]			= %ai_fem_corner_standR_trans_IN_1;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][2]			= %ai_fem_corner_standR_trans_IN_2;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][3]			= %ai_fem_corner_standR_trans_IN_3;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][4]			= %ai_fem_corner_standR_trans_IN_4;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][6]			= %ai_fem_corner_standR_trans_IN_6;
	//array[animType]["move"]["stand"]["rifle"]["arrive_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][8]			= %ai_fem_corner_standR_trans_IN_8;
	array[animType]["move"]["stand"]["rifle"]["arrive_right"][9]			= %ai_fem_corner_standR_trans_IN_9;

	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][2]	= %ai_fem_run_2_crouch_F;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][4]	= %ai_fem_run_2_crouch_90L;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][6]	= %ai_fem_run_2_crouch_90R;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed_crouch"][8]	= %ai_fem_run_2_crouch_180L;

	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][2]			= %ai_fem_run_2_stand_F_6;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][4]			= %ai_fem_run_2_stand_90L;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][6]			= %ai_fem_run_2_stand_90R;
	array[animType]["move"]["stand"]["rifle"]["arrive_exposed"][8]			= %ai_fem_run_2_stand_180L;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Arrival Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["exit_left"][1]				= %ai_fem_corner_standL_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][2]				= %ai_fem_corner_standL_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][3]				= %ai_fem_corner_standL_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][4]				= %ai_fem_corner_standL_trans_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][6]				= %ai_fem_corner_standL_trans_OUT_6;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][7]				= %ai_fem_corner_standL_trans_OUT_7;
	array[animType]["move"]["stand"]["rifle"]["exit_left"][8]				= %ai_fem_corner_standL_trans_OUT_8;
	//array[animType]["move"]["stand"]["rifle"]["exit_left"][9]				= can't approach from this direction

	array[animType]["move"]["stand"]["rifle"]["exit_right"][1]				= %ai_fem_corner_standR_trans_OUT_1;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][2]				= %ai_fem_corner_standR_trans_OUT_2;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][3]				= %ai_fem_corner_standR_trans_OUT_3;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][4]				= %ai_fem_corner_standR_trans_OUT_4;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][6]				= %ai_fem_corner_standR_trans_OUT_6;
	//array[animType]["move"]["stand"]["rifle"]["exit_right"][7]			= can't approach from this direction
	array[animType]["move"]["stand"]["rifle"]["exit_right"][8]				= %ai_fem_corner_standR_trans_OUT_8;
	array[animType]["move"]["stand"]["rifle"]["exit_right"][9]				= %ai_fem_corner_standR_trans_OUT_9;

	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][2]		= %ai_fem_crouch_2_run_180;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][4]		= %ai_fem_crouch_2_run_l;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][6]		= %ai_fem_crouch_2_run_r;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed_crouch"][8]		= %ai_fem_crouch_2_run_f;

	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][2]			= %ai_fem_stand_2_run_180_med;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][4]			= %ai_fem_stand_2_run_L;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][6]			= %ai_fem_stand_2_run_R;
	array[animType]["move"]["stand"]["rifle"]["exit_exposed"][8]			= %ai_fem_stand_2_run_F_2;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Cover Exit Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["rifle"]["exposed_idle"]				= array( %ai_fem_exposed_idle_alert_v1, %ai_fem_exposed_idle_alert_v2, %ai_fem_exposed_idle_alert_v3, %ai_fem_exposed_idle_alert_v4, %ai_fem_exposed_idle_alert_v5 );

	array[animType]["combat"]["stand"]["rifle"]["straight_level"]			= %ai_fem_exposed_aim_5;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_up"]				= %ai_fem_exposed_aim_8;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_down"]				= %ai_fem_exposed_aim_2;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_left"]				= %ai_fem_exposed_aim_4;
	array[animType]["combat"]["stand"]["rifle"]["add_aim_right"]			= %ai_fem_exposed_aim_6;  
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["crouch"]["rifle"]["exposed_idle"]			= array( %ai_fem_exposed_crouch_idle_alert_v1, %ai_fem_exposed_crouch_idle_alert_v2, %ai_fem_exposed_crouch_idle_alert_v3 );

	array[animType]["combat"]["crouch"]["rifle"]["single"]					= array( %ai_fem_exposed_crouch_shoot_semi1 );
	array[animType]["combat"]["crouch"]["rifle"]["semi2"]					= %ai_fem_exposed_crouch_shoot_semi2;
	array[animType]["combat"]["crouch"]["rifle"]["semi3"]					= %ai_fem_exposed_crouch_shoot_semi3;
	array[animType]["combat"]["crouch"]["rifle"]["semi4"]					= %ai_fem_exposed_crouch_shoot_semi4;
	array[animType]["combat"]["crouch"]["rifle"]["semi5"]					= %ai_fem_exposed_crouch_shoot_semi5;

	array[animType]["combat"]["crouch"]["rifle"]["straight_level"]			= %ai_fem_exposed_crouch_aim_5;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_up"]				= %ai_fem_exposed_crouch_aim_8;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_right"]			= %ai_fem_exposed_crouch_aim_6;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_left"]			= %ai_fem_exposed_crouch_aim_4;
	array[animType]["combat"]["crouch"]["rifle"]["add_aim_down"]			= %ai_fem_exposed_crouch_aim_2;
	// TODO: where are the rest of the aims?
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Crouch Rifle Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["combat"]["stand"]["rifle"]["melee"]					= %ai_fem_melee;
	array[animType]["combat"]["stand"]["rifle"]["run_2_melee"]				= %ai_fem_run_2_melee_charge;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Combat Stand Melee Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Begin Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	array[animType]["move"]["stand"]["rifle"]["combat_run_f"]				= %ai_fem_run_lowready_F;
	array[animType]["move"]["stand"]["rifle"]["combat_run_r"]				= %ai_fem_run_lowready_R;
	array[animType]["move"]["stand"]["rifle"]["combat_run_l"]				= %ai_fem_run_lowready_L;
	array[animType]["move"]["stand"]["rifle"]["combat_run_b"]				= %ai_fem_run_lowready_B;

	array[animType]["move"]["stand"]["rifle"]["run_n_gun_f"]				= %ai_fem_run_n_gun_F;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_r"]				= %ai_fem_run_n_gun_R;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_l"]				= %ai_fem_run_n_gun_L;
	array[animType]["move"]["stand"]["rifle"]["run_n_gun_b"]				= %ai_fem_run_n_gun_B;

	array[animType]["move"]["stand"]["rifle"]["reload"]						= %ai_fem_run_lowready_reload;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// End Run Actions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	return array;
}
