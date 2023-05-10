
main()
{
	self setModel("c_usa_cia_mp_body_utility_demo");
	self.headModel = "c_usa_cia_mp_head_5_demo";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_cia_mp_body_utility_demo");
	precacheModel("c_usa_cia_mp_head_5_demo");
} 
