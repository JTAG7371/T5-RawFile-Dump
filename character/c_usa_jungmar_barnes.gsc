
main()
{
	self setModel("c_usa_jungmar_barnes_fb");
	self.gearModel = "c_usa_jungmar_barnes_bedroll";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_jungmar_barnes_fb");
	precacheModel("c_usa_jungmar_barnes_bedroll");
}  
