
main()
{
	self setModel("c_usa_ubase_body1");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_usa_ubase_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "c_usa_ubase_flippers";
	self attach(self.hatModel);
	self.gearModel = "c_usa_ubase_gear1";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_ubase_body1");
	codescripts\character::precacheModelArray(xmodelalias\c_usa_ubase_headalias::main());
	precacheModel("c_usa_ubase_flippers");
	precacheModel("c_usa_ubase_gear1");
}  
