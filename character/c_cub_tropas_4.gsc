
main()
{
	self setModel("c_cub_tropas_body1");
	self.headModel = "c_cub_tropas_head5";
	self attach(self.headModel, "", true);
	self.gearModel = codescripts\character::randomElement(xmodelalias\c_cub_tropas_gearalias::main());
	self attach(self.gearModel, "", true);
	self.voice = "cuban";
	self.skeleton = "base";
	self.torsoDmg1 = "c_cub_tropas_body1_g_upclean";
	self.torsoDmg2 = "c_cub_tropas_body1_g_rarmoff";
	self.torsoDmg3 = "c_cub_tropas_body1_g_larmoff";
	self.torsoDmg4 = "c_cub_tropas_body1_g_torso";
	self.legDmg1 = "c_cub_tropas_body1_g_lowclean";
	self.legDmg2 = "c_cub_tropas_body1_g_rlegoff";
	self.legDmg3 = "c_cub_tropas_body1_g_llegoff";
	self.legDmg4 = "c_cub_tropas_body1_g_legsoff";
	self.gibSpawn1 = "c_cub_tropas_body1_g_rarmspawn";
	self.gibSpawnTag1 = "J_Elbow_RI";
	self.gibSpawn2 = "c_cub_tropas_body1_g_larmspawn";
	self.gibSpawnTag2 = "J_Elbow_LE";
	self.gibSpawn3 = "c_cub_tropas_body1_g_rlegspawn";
	self.gibSpawnTag3 = "J_Knee_RI";
	self.gibSpawn4 = "c_cub_tropas_body1_g_llegspawn";
	self.gibSpawnTag4 = "J_Knee_LE";
}
precache()
{
	precacheModel("c_cub_tropas_body1");
	precacheModel("c_cub_tropas_head5");
	codescripts\character::precacheModelArray(xmodelalias\c_cub_tropas_gearalias::main());
	precacheModel("c_cub_tropas_body1_g_upclean");
	precacheModel("c_cub_tropas_body1_g_rarmoff");
	precacheModel("c_cub_tropas_body1_g_larmoff");
	precacheModel("c_cub_tropas_body1_g_torso");
	precacheModel("c_cub_tropas_body1_g_lowclean");
	precacheModel("c_cub_tropas_body1_g_rlegoff");
	precacheModel("c_cub_tropas_body1_g_llegoff");
	precacheModel("c_cub_tropas_body1_g_legsoff");
	precacheModel("c_cub_tropas_body1_g_rarmspawn");
	precacheModel("c_cub_tropas_body1_g_larmspawn");
	precacheModel("c_cub_tropas_body1_g_rlegspawn");
	precacheModel("c_cub_tropas_body1_g_llegspawn");
	precacheModel("c_cub_tropas_body1_g_upclean");
	precacheModel("c_cub_tropas_body1_g_rarmoff");
	precacheModel("c_cub_tropas_body1_g_larmoff");
	precacheModel("c_cub_tropas_body1_g_torso");
	precacheModel("c_cub_tropas_body1_g_lowclean");
	precacheModel("c_cub_tropas_body1_g_rlegoff");
	precacheModel("c_cub_tropas_body1_g_llegoff");
	precacheModel("c_cub_tropas_body1_g_legsoff");
	precacheModel("c_cub_tropas_body1_g_rarmspawn");
	precacheModel("c_cub_tropas_body1_g_larmspawn");
	precacheModel("c_cub_tropas_body1_g_rlegspawn");
	precacheModel("c_cub_tropas_body1_g_llegspawn");
} 
