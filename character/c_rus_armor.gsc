
main()
{
	self setModel("c_rus_spet_mp_body_armor_demo");
	self.headModel = "c_rus_spet_mp_head_1_demo";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_spet_mp_body_armor_demo");
	precacheModel("c_rus_spet_mp_head_1_demo");
} 
