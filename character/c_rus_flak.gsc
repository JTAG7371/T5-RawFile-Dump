
main()
{
	self setModel("c_rus_spet_mp_body_flak_demo");
	self.headModel = "c_rus_spet_mp_head_3_demo";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_spet_mp_body_flak_demo");
	precacheModel("c_rus_spet_mp_head_3_demo");
}  
