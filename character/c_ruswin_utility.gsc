
main()
{
	self setModel("c_rus_spetwin_mp_body_utility_demo");
	self.headModel = "c_rus_spetwin_mp_head_5_demo";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_spetwin_mp_body_utility_demo");
	precacheModel("c_rus_spetwin_mp_head_5_demo");
} 
