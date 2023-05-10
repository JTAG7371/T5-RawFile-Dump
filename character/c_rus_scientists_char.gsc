
main()
{
	codescripts\character::setModelFromArray(xmodelalias\c_rus_scientist_body_char_alias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\c_rus_scientist_head_char_alias::main());
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\c_rus_scientist_body_char_alias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_rus_scientist_head_char_alias::main());
}  
