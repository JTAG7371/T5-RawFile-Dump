
main()
{
	self setModel("c_vtn_vc1_body");
	self.headModel = "c_vtn_vc1_head_meatshield";
	self attach(self.headModel, "", true);
	self.gearModel = "c_vtn_vc1_gear_meatshield";
	self attach(self.gearModel, "", true);
	self.voice = "vietnamese";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_vtn_vc1_body");
	precacheModel("c_vtn_vc1_head_meatshield");
	precacheModel("c_vtn_vc1_gear_meatshield");
}  
