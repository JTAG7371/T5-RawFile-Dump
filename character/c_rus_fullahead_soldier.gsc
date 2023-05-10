
main()
{
	self setModel("c_rus_fullahead_soldier_body1");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_rus_fullahead_head_alias::main());
	self attach(self.headModel, "", true);
	self.voice = "russian_english";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_fullahead_soldier_body1");
	codescripts\character::precacheModelArray(xmodelalias\c_rus_fullahead_head_alias::main());
}  
