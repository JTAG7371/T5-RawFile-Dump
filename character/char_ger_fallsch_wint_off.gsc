
main()
{
	codescripts\character::setModelFromArray(xmodelalias\char_ger_fallschirm_bodyalias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\char_ger_fallschirm_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "char_ger_fallschirm_cap1";
	self attach(self.hatModel);
	self.gearModel = codescripts\character::randomElement(xmodelalias\char_ger_fallschirm_gearalias::main());
	self attach(self.gearModel, "", true);
	self.voice = "german";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\char_ger_fallschirm_bodyalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_ger_fallschirm_headalias::main());
	precacheModel("char_ger_fallschirm_cap1");
	codescripts\character::precacheModelArray(xmodelalias\char_ger_fallschirm_gearalias::main());
} 
