
main()
{
	codescripts\character::setModelFromArray(xmodelalias\char_ger_honorgd_bodyalias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\char_ger_waffen_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "char_ger_wermacht_helm1";
	self attach(self.hatModel);
	self.gearModel = codescripts\character::randomElement(xmodelalias\char_ger_honorgd_gearalias::main());
	self attach(self.gearModel, "", true);
	self.voice = "german";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\char_ger_honorgd_bodyalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_ger_waffen_headalias::main());
	precacheModel("char_ger_wermacht_helm1");
	codescripts\character::precacheModelArray(xmodelalias\char_ger_honorgd_gearalias::main());
} 
