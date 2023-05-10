
main()
{
	self setModel("c_usa_jungmar_body");
	self.headModel = "c_usa_jungmar_head4";
	self attach(self.headModel, "", true);
	self.gearModel = "c_usa_jungmar_gear4";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_jungmar_body");
	precacheModel("c_usa_jungmar_head4");
	precacheModel("c_usa_jungmar_gear4");
}  
