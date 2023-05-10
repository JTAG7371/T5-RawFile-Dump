
main()
{
	self setModel("c_rus_spetznaz_body1_gassed");
	self.headModel = "c_rus_military_head2_gassed";
	self attach(self.headModel, "", true);
	self.gearModel = "c_rus_spetznaz_body1_gear1";
	self attach(self.gearModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_spetznaz_body1_gassed");
	precacheModel("c_rus_military_head2_gassed");
	precacheModel("c_rus_spetznaz_body1_gear1");
}  
