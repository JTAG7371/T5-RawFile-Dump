level_init()
{
	level.allies_team = "specops_winter";
	level.axis_team   = "russian_winter";
	level.isWinter	  = true;

	level.chopper_gunner_player_model["specops_winter"] = "c_usa_ciawin_mp_body_armor";
	level.chopper_gunner_player_model["russian_winter"] = "c_rus_spetwin_mp_body_armor";
	level.chopper_gunner_player_head["specops_winter"] = "c_usa_ciawin_mp_head_1";
	level.chopper_gunner_player_head["russian_winter"] = "c_rus_spetwin_mp_head_1";
	level.chopper_gunner_viewmodel["specops_winter"] = "viewmodel_usa_ciawin_armor_arms";
	level.chopper_gunner_viewmodel["russian_winter"] = "viewmodel_rus_spetwin_armor_arms";
}