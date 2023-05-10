
main()
{
	self setModel("c_ger_infantry_body");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_ger_infantry_head_alias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "c_ger_infantry_helm";
	self attach(self.hatModel);
	self.gearModel = "c_ger_infantry_gear";
	self attach(self.gearModel, "", true);
	self.voice = "german";
	self.skeleton = "base";
	self.torsoDmg1 = "c_ger_infantry_body_g_upclean";
	self.torsoDmg2 = "c_ger_infantry_body_g_rarmoff";
	self.torsoDmg3 = "c_ger_infantry_body_g_larmoff";
	self.torsoDmg4 = "c_ger_infantry_body_g_torso";
	self.legDmg1 = "c_ger_infantry_body_g_lowclean";
	self.legDmg2 = "c_ger_infantry_body_g_rlegoff";
	self.legDmg3 = "c_ger_infantry_body_g_llegoff";
	self.legDmg4 = "c_ger_infantry_body_g_legsoff";
	self.gibSpawn1 = "c_ger_infantry_body_g_rarmspawn";
	self.gibSpawnTag1 = "J_Elbow_RI";
	self.gibSpawn2 = "c_ger_infantry_body_g_larmspawn";
	self.gibSpawnTag2 = "J_Elbow_LE";
	self.gibSpawn3 = "c_ger_infantry_body_g_rlegspawn";
	self.gibSpawnTag3 = "J_Knee_RI";
	self.gibSpawn4 = "c_ger_infantry_body_g_llegspawn";
	self.gibSpawnTag4 = "J_Knee_LE";
}
precache()
{
	precacheModel("c_ger_infantry_body");
	codescripts\character::precacheModelArray(xmodelalias\c_ger_infantry_head_alias::main());
	precacheModel("c_ger_infantry_helm");
	precacheModel("c_ger_infantry_gear");
	precacheModel("c_ger_infantry_body_g_upclean");
	precacheModel("c_ger_infantry_body_g_rarmoff");
	precacheModel("c_ger_infantry_body_g_larmoff");
	precacheModel("c_ger_infantry_body_g_torso");
	precacheModel("c_ger_infantry_body_g_lowclean");
	precacheModel("c_ger_infantry_body_g_rlegoff");
	precacheModel("c_ger_infantry_body_g_llegoff");
	precacheModel("c_ger_infantry_body_g_legsoff");
	precacheModel("c_ger_infantry_body_g_rarmspawn");
	precacheModel("c_ger_infantry_body_g_larmspawn");
	precacheModel("c_ger_infantry_body_g_rlegspawn");
	precacheModel("c_ger_infantry_body_g_llegspawn");
	precacheModel("c_ger_infantry_body_g_upclean");
	precacheModel("c_ger_infantry_body_g_rarmoff");
	precacheModel("c_ger_infantry_body_g_larmoff");
	precacheModel("c_ger_infantry_body_g_torso");
	precacheModel("c_ger_infantry_body_g_lowclean");
	precacheModel("c_ger_infantry_body_g_rlegoff");
	precacheModel("c_ger_infantry_body_g_llegoff");
	precacheModel("c_ger_infantry_body_g_legsoff");
	precacheModel("c_ger_infantry_body_g_rarmspawn");
	precacheModel("c_ger_infantry_body_g_larmspawn");
	precacheModel("c_ger_infantry_body_g_rlegspawn");
	precacheModel("c_ger_infantry_body_g_llegspawn");
} 
