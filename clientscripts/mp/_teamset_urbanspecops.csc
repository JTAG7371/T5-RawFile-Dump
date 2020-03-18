level_init()
{
	level.allies_team = "specops";
	level.axis_team   = "russian";

	level.chopper_gunner_player_model["specops"] = "c_usa_cia_mp_body_armor";
	level.chopper_gunner_player_model["russian"] = "c_rus_spet_mp_body_armor";
	level.chopper_gunner_player_head["specops"] = "c_usa_cia_mp_head_1";
	level.chopper_gunner_player_head["russian"] = "c_rus_spet_mp_head_1";
	level.chopper_gunner_viewmodel["specops"] = "viewmodel_usa_cia_armor_arms";
	level.chopper_gunner_viewmodel["russian"] = "viewmodel_rus_spet_armor_arms";
}