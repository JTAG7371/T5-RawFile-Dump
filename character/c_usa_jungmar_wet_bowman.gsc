
main()
{
	self setModel("c_usa_jungmar_wet_bowman_fb");
	self.gearModel = "c_usa_jungmar_wet_bowman_gear";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_jungmar_wet_bowman_fb");
	precacheModel("c_usa_jungmar_wet_bowman_gear");
}  
