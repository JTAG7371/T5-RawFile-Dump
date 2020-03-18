level_init()
{
	level.allies_team = "rebels";
	level.axis_team   = "tropas";

	level.chopper_gunner_player_model["rebels"] = "c_cub_rebels_mp_body_armor";
	level.chopper_gunner_player_model["tropas"] = "c_cub_tropas_mp_body_armor";
	level.chopper_gunner_player_head["rebels"] = "c_cub_rebels_mp_head_1";
	level.chopper_gunner_player_head["tropas"] = "c_cub_tropas_mp_head_1";
	level.chopper_gunner_viewmodel["rebels"] = "viewmodel_cub_rebels_armor_arms";
	level.chopper_gunner_viewmodel["tropas"] = "viewmodel_cub_tropas_armor_arms";
}