
main()
{
	self setModel("c_rus_engineer1_body_orange");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_rus_engineer_head_alias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "c_rus_engineer_helmet";
	self attach(self.hatModel);
	self.gearModel = codescripts\character::randomElement(xmodelalias\c_rus_engineer_headgear_alias::main());
	self attach(self.gearModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_engineer1_body_orange");
	codescripts\character::precacheModelArray(xmodelalias\c_rus_engineer_head_alias::main());
	precacheModel("c_rus_engineer_helmet");
	codescripts\character::precacheModelArray(xmodelalias\c_rus_engineer_headgear_alias::main());
}  
