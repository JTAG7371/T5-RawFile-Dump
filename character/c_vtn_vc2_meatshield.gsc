
main()
{
	self setModel("c_vtn_vc2_body_meatshield");
	self.headModel = "c_vtn_vc2_head";
	self attach(self.headModel, "", true);
	self.voice = "vietnamese";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_vtn_vc2_body_meatshield");
	precacheModel("c_vtn_vc2_head");
}  
