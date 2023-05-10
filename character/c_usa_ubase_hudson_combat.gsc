
main()
{
	self setModel("c_usa_ubase_hudson_fb");
	self.gearModel = "c_usa_ubase_hudson_gear_combat";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_ubase_hudson_fb");
	precacheModel("c_usa_ubase_hudson_gear_combat");
}  
