
main()
{
	self setModel("c_usa_ubase_hudson_fb");
	self.hatModel = "c_usa_ubase_flippers";
	self attach(self.hatModel);
	self.gearModel = "c_usa_ubase_hudson_gear";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_ubase_hudson_fb");
	precacheModel("c_usa_ubase_flippers");
	precacheModel("c_usa_ubase_hudson_gear");
}  
