
main()
{
	self setModel("c_vtn_nva_mp_body_flak_demo");
	self.headModel = "c_vtn_nva_mp_head_3_demo";
	self attach(self.headModel, "", true);
	self.voice = "vietnamese";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_vtn_nva_mp_body_flak_demo");
	precacheModel("c_vtn_nva_mp_head_3_demo");
} 
