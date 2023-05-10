
main()
{
	self setModel("c_rus_spet_mp_body_standard_demo");
	self.headModel = "c_rus_spet_mp_head_4_demo";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_spet_mp_body_standard_demo");
	precacheModel("c_rus_spet_mp_head_4_demo");
}  
