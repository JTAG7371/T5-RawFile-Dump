
main()
{
	codescripts\character::setModelFromArray(xmodelalias\c_rus_prisoner_bodyalias::main());
	self.headModel = "c_rus_prisoner_head1";
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\c_rus_prisoner_headwearalias::main());
	self attach(self.hatModel, "", true);
	self.voice = "russian_english";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\c_rus_prisoner_bodyalias::main());
	precacheModel("c_rus_prisoner_head1");
	codescripts\character::precacheModelArray(xmodelalias\c_rus_prisoner_headwearalias::main());
}  
