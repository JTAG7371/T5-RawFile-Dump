
main()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head1_nc";
	self attach(self.headModel, "", true);
	self.gearModel = "c_usa_jungmar_gear1";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
	self.torsoDmg1 = "c_usa_jungmar_body_g_rarmoff";
	self.torsoDmg2 = "c_usa_jungmar_body_g_rarmoff";
	self.torsoDmg3 = "c_usa_jungmar_body_g_rarmoff";
	self.torsoDmg4 = "c_usa_jungmar_body_g_rarmoff";
	self.legDmg1 = "c_usa_jungmar_body_g_lowclean";
	self.legDmg2 = "c_usa_jungmar_body_g_lowclean";
	self.legDmg3 = "c_usa_jungmar_body_g_lowclean";
	self.legDmg4 = "c_usa_jungmar_body_g_lowclean";
	self.gibSpawn1 = "c_usa_jungmar_body_g_rarmspawn";
	self.gibSpawnTag1 = "J_Elbow_RI";
	self.gibSpawn2 = "c_usa_jungmar_body_g_rarmspawn";
	self.gibSpawnTag2 = "J_Elbow_LE";
	self.gibSpawn3 = "c_usa_jungmar_body_g_rarmspawn";
	self.gibSpawnTag3 = "J_Knee_RI";
	self.gibSpawn4 = "c_usa_jungmar_body_g_rarmspawn";
	self.gibSpawnTag4 = "J_Knee_LE";
}
precache()
{
	precacheModel("c_usa_jungmar_body_drab");
	precacheModel("c_usa_jungmar_head1_nc");
	precacheModel("c_usa_jungmar_gear1");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_rarmoff");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_lowclean");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
	precacheModel("c_usa_jungmar_body_g_rarmspawn");
}  
