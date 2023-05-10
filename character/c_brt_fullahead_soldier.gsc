
main()
{
	self setModel("c_brt_fullahead_soldier_body");
	self.headModel = "c_brt_fullahead_soldier_head";
	self attach(self.headModel, "", true);
	self.gearModel = "c_brt_fullahead_soldier_gear";
	self attach(self.gearModel, "", true);
	self.voice = "british";
	self.skeleton = "base";
	self.torsoDmg1 = "c_brt_fullahead_soldier_body_g_upclean";
	self.torsoDmg2 = "c_brt_fullahead_soldier_body_g_rarmoff";
	self.torsoDmg3 = "c_brt_fullahead_soldier_body_g_larmoff";
	self.torsoDmg4 = "c_brt_fullahead_soldier_body_g_torso";
	self.legDmg1 = "c_brt_fullahead_soldier_body_g_lowclean";
	self.legDmg2 = "c_brt_fullahead_soldier_body_g_rlegoff";
	self.legDmg3 = "c_brt_fullahead_soldier_body_g_llegoff";
	self.legDmg4 = "c_brt_fullahead_soldier_body_g_legsoff";
	self.gibSpawn1 = "c_brt_fullahead_soldier_body_g_rarmspawn";
	self.gibSpawnTag1 = "J_Elbow_RI";
	self.gibSpawn2 = "c_brt_fullahead_soldier_body_g_larmspawn";
	self.gibSpawnTag2 = "J_Elbow_LE";
	self.gibSpawn3 = "c_brt_fullahead_soldier_body_g_rlegspawn";
	self.gibSpawnTag3 = "J_Knee_RI";
	self.gibSpawn4 = "c_brt_fullahead_soldier_body_g_llegspawn";
	self.gibSpawnTag4 = "J_Knee_LE";
}
precache()
{
	precacheModel("c_brt_fullahead_soldier_body");
	precacheModel("c_brt_fullahead_soldier_head");
	precacheModel("c_brt_fullahead_soldier_gear");
	precacheModel("c_brt_fullahead_soldier_body_g_upclean");
	precacheModel("c_brt_fullahead_soldier_body_g_rarmoff");
	precacheModel("c_brt_fullahead_soldier_body_g_larmoff");
	precacheModel("c_brt_fullahead_soldier_body_g_torso");
	precacheModel("c_brt_fullahead_soldier_body_g_lowclean");
	precacheModel("c_brt_fullahead_soldier_body_g_rlegoff");
	precacheModel("c_brt_fullahead_soldier_body_g_llegoff");
	precacheModel("c_brt_fullahead_soldier_body_g_legsoff");
	precacheModel("c_brt_fullahead_soldier_body_g_rarmspawn");
	precacheModel("c_brt_fullahead_soldier_body_g_larmspawn");
	precacheModel("c_brt_fullahead_soldier_body_g_rlegspawn");
	precacheModel("c_brt_fullahead_soldier_body_g_llegspawn");
	precacheModel("c_brt_fullahead_soldier_body_g_upclean");
	precacheModel("c_brt_fullahead_soldier_body_g_rarmoff");
	precacheModel("c_brt_fullahead_soldier_body_g_larmoff");
	precacheModel("c_brt_fullahead_soldier_body_g_torso");
	precacheModel("c_brt_fullahead_soldier_body_g_lowclean");
	precacheModel("c_brt_fullahead_soldier_body_g_rlegoff");
	precacheModel("c_brt_fullahead_soldier_body_g_llegoff");
	precacheModel("c_brt_fullahead_soldier_body_g_legsoff");
	precacheModel("c_brt_fullahead_soldier_body_g_rarmspawn");
	precacheModel("c_brt_fullahead_soldier_body_g_larmspawn");
	precacheModel("c_brt_fullahead_soldier_body_g_rlegspawn");
	precacheModel("c_brt_fullahead_soldier_body_g_llegspawn");
} 
