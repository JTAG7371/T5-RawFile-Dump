
main()
{
	self setModel("c_usa_blackops_bowman_disguise_body");
	self.headModel = "c_usa_blackops_bowman_disguise_headb";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_blackops_bowman_disguise_body");
	precacheModel("c_usa_blackops_bowman_disguise_headb");
}  
