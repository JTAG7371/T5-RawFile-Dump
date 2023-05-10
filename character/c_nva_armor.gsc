
main()
{
	self setModel("c_vtn_nva_mp_body_armor_demo");
	self.headModel = "c_vtn_nva_mp_head_1_demo";
	self attach(self.headModel, "", true);
	self.voice = "vietnamese";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_vtn_nva_mp_body_armor_demo");
	precacheModel("c_vtn_nva_mp_head_1_demo");
} 
