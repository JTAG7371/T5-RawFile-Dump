
main()
{
	self setModel("char_usa_marine_body1_1");
	self.headModel = codescripts\character::randomElement(xmodelalias\char_usa_marine_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "char_usa_raider_helm1";
	self attach(self.hatModel);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_usa_marine_body1_1");
	codescripts\character::precacheModelArray(xmodelalias\char_usa_marine_headalias::main());
	precacheModel("char_usa_raider_helm1");
} 