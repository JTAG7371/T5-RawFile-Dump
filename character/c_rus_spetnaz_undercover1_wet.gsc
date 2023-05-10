
main()
{
	self setModel("c_rus_spetsnaz_undercover_bodya_2_w");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_rus_spetsnaz_undercover_head_alias::main());
	self attach(self.headModel, "", true);
	self.gearModel = "c_rus_spetsnaz_undercover_geara_w";
	self attach(self.gearModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
	self.torsoDmg1 = "c_rus_spetsnaz_undercover_bodya_2_w_g_upclean";
	self.torsoDmg2 = "c_rus_spetsnaz_undercover_bodya_2_w_g_rarmoff";
	self.torsoDmg3 = "c_rus_spetsnaz_undercover_bodya_2_w_g_larmoff";
	self.torsoDmg4 = "c_rus_spetsnaz_undercover_bodya_2_w_g_torso";
	self.legDmg1 = "c_rus_spetsnaz_undercover_bodya_2_w_g_lowclean";
	self.legDmg2 = "c_rus_spetsnaz_undercover_bodya_2_w_g_rlegoff";
	self.legDmg3 = "c_rus_spetsnaz_undercover_bodya_2_w_g_llegoff";
	self.legDmg4 = "c_rus_spetsnaz_undercover_bodya_2_w_g_legsoff";
	self.gibSpawn1 = "c_vtn_g_rarmspawn";
	self.gibSpawnTag1 = "J_Elbow_RI";
	self.gibSpawn2 = "c_vtn_g_larmspawn";
	self.gibSpawnTag2 = "J_Elbow_LE";
	self.gibSpawn3 = "c_rus_spetsnaz_undercover_bodya_1_w_g_rlegspawn";
	self.gibSpawnTag3 = "J_Knee_RI";
	self.gibSpawn4 = "c_rus_spetsnaz_undercover_bodya_1_w_g_llegspawn";
	self.gibSpawnTag4 = "J_Knee_LE";
}
precache()
{
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w");
	codescripts\character::precacheModelArray(xmodelalias\c_rus_spetsnaz_undercover_head_alias::main());
	precacheModel("c_rus_spetsnaz_undercover_geara_w");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_upclean");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_rarmoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_larmoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_torso");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_lowclean");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_rlegoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_llegoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_legsoff");
	precacheModel("c_vtn_g_rarmspawn");
	precacheModel("c_vtn_g_larmspawn");
	precacheModel("c_rus_spetsnaz_undercover_bodya_1_w_g_rlegspawn");
	precacheModel("c_rus_spetsnaz_undercover_bodya_1_w_g_llegspawn");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_upclean");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_rarmoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_larmoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_torso");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_lowclean");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_rlegoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_llegoff");
	precacheModel("c_rus_spetsnaz_undercover_bodya_2_w_g_legsoff");
	precacheModel("c_vtn_g_rarmspawn");
	precacheModel("c_vtn_g_larmspawn");
	precacheModel("c_rus_spetsnaz_undercover_bodya_1_w_g_rlegspawn");
	precacheModel("c_rus_spetsnaz_undercover_bodya_1_w_g_llegspawn");
}  
