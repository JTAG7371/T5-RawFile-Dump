
main()
{
	self setModel("c_ger_officer_frozen_body");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_ger_infantry_frozen_head_alias::main());
	self attach(self.headModel, "", true);
	self.voice = "german";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_ger_officer_frozen_body");
	codescripts\character::precacheModelArray(xmodelalias\c_ger_infantry_frozen_head_alias::main());
} 
