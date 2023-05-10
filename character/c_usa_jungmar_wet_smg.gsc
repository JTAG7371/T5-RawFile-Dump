
main()
{
	self setModel("c_usa_jungmar_wet_body");
	self.headModel = "c_usa_jungmar_wet_head5";
	self attach(self.headModel, "", true);
	self.gearModel = "c_usa_jungmar_wet_gear5";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_jungmar_wet_body");
	precacheModel("c_usa_jungmar_wet_head5");
	precacheModel("c_usa_jungmar_wet_gear5");
}  
