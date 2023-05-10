
main()
{
	self setModel("c_usa_ubase_body1");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_usa_ubase_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\c_usa_ubase_hatalias::main());
	self attach(self.hatModel, "", true);
	self.gearModel = "c_usa_ubase_gear2";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_ubase_body1");
	codescripts\character::precacheModelArray(xmodelalias\c_usa_ubase_headalias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_usa_ubase_hatalias::main());
	precacheModel("c_usa_ubase_gear2");
}  
