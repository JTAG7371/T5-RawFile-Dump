
main()
{
	self setModel("c_rus_engineer1_body_yellow");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_rus_engineer_head_alias::main());
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_engineer1_body_yellow");
	codescripts\character::precacheModelArray(xmodelalias\c_rus_engineer_head_alias::main());
}  
