
main()
{
	codescripts\character::setModelFromArray(xmodelalias\c_rus_scientist_bodyalias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\c_rus_scientist_headalias::main());
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\c_rus_scientist_bodyalias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_rus_scientist_headalias::main());
}  
