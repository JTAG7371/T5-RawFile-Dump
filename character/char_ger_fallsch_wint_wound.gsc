
main()
{
	codescripts\character::setModelFromArray(xmodelalias\char_ger_fallschirm_bodyalias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\char_ger_fallschirm_headalias::main());
	self attach(self.headModel, "", true);
	self.voice = "german";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\char_ger_fallschirm_bodyalias::main());
	codescripts\character::precacheModelArray(xmodelalias\char_ger_fallschirm_headalias::main());
} 
