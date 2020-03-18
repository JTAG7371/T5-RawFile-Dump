level_init()
{
	level.allies_team = "marines";
	level.axis_team   = "japanese";

	level.chopper_gunner_player_model["marines"] = "c_usa_sog_mp_body_armor";
	level.chopper_gunner_player_model["japanese"] = "c_vtn_nva_mp_body_armor";
	level.chopper_gunner_player_head["marines"] = "c_usa_sog_mp_head_1";
	level.chopper_gunner_player_head["japanese"] = "c_vtn_nva_mp_head_1";
	level.chopper_gunner_viewmodel["marines"] = "viewmodel_usa_sog_armor_arms";
	level.chopper_gunner_viewmodel["japanese"] = "viewmodel_vtn_nva_armor_arms";
}