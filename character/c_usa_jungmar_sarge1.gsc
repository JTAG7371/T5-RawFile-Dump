
main()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head_sarge1";
	self attach(self.headModel, "", true);
	self.gearModel = "c_usa_jungmar_gear3";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
	self.torsoDmg1 = "c_usa_jungmar_body_g_upclean";
	self.torsoDmg2 = "c_usa_jungmar_body_g_upclean";
	self.torsoDmg3 = "c_usa_jungmar_body_g_upclean";
	self.torsoDmg4 = "c_usa_jungmar_body_g_upclean";
	self.legDmg1 = "c_usa_jungmar_body_g_llegoff";
	self.legDmg2 = "c_usa_jungmar_body_g_llegoff";
	self.legDmg3 = "c_usa_jungmar_body_g_llegoff";
	self.legDmg4 = "c_usa_jungmar_body_g_llegoff";
	self.gibSpawn1 = "c_usa_jungmar_body_g_llegspawn";
	self.gibSpawnTag1 = "J_Elbow_RI";
	self.gibSpawn2 = "c_usa_jungmar_body_g_llegspawn";
	self.gibSpawnTag2 = "J_Elbow_LE";
	self.gibSpawn3 = "c_usa_jungmar_body_g_llegspawn";
	self.gibSpawnTag3 = "J_Knee_RI";
	self.gibSpawn4 = "c_usa_jungmar_body_g_llegspawn";
	self.gibSpawnTag4 = "J_Knee_LE";
}
precache()
{
	precacheModel("c_usa_jungmar_body_drab");
	precacheModel("c_usa_jungmar_head_sarge1");
	precacheModel("c_usa_jungmar_gear3");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_upclean");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegoff");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
	precacheModel("c_usa_jungmar_body_g_llegspawn");
}  
