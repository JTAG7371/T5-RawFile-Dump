
main()
{
	self setModel("char_usa_marine_wet_body1_1");
	self.headModel = codescripts\character::randomElement(xmodelalias\char_usa_marine_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\char_usa_marine_wet_helmalias::main());
	self attach(self.hatModel, "", true);
	self.gearModel = "char_usa_marine_helmF";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_usa_marine_wet_body1_1");
	codescripts\character::precacheModelArray(xmodelalias\char_usa_marine_headalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_usa_marine_wet_helmalias::main());
	precacheModel("char_usa_marine_helmF");
} 
