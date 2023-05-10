
matches_me()
{
	if(self.model == "char_rus_guard_player_body_cqb")
	{
		return true;
	}
	return(false);
}
register_gibs()
{
	if(!isDefined(level._gibbing_actor_models))
	{
		level._gibbing_actor_models = [];
	}
	gib_spawn = spawnstruct();
	gib_spawn.matches_me = ::matches_me;
	gib_spawn.gibSpawn1 = "char_rus_guard_body1_m_g_rarmspawn";
	gib_spawn.gibSpawnTag1 = "J_Elbow_RI";
	gib_spawn.gibSpawn2 = "char_rus_guard_body1_m_g_larmspawn";
	gib_spawn.gibSpawnTag2 = "J_Elbow_LE";
	gib_spawn.gibSpawn3 = "char_rus_guard_body1_m_g_rlegspawn";
	gib_spawn.gibSpawnTag3 = "J_Knee_RI";
	gib_spawn.gibSpawn4 = "char_rus_guard_body1_m_g_llegspawn";
	gib_spawn.gibSpawnTag4 = "J_Knee_LE";
	level._gibbing_actor_models[level._gibbing_actor_models.size] = gib_spawn;
}  
