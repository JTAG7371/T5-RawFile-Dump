
main()
{
	self setModel("c_ger_infantry_frozen_body");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_ger_infantry_frozen_head_alias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "c_ger_infantry_frozen_helm";
	self attach(self.hatModel);
	self.gearModel = "c_ger_infantry_frozen_gear";
	self attach(self.gearModel, "", true);
	self.voice = "german";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_ger_infantry_frozen_body");
	codescripts\character::precacheModelArray(xmodelalias\c_ger_infantry_frozen_head_alias::main());
	precacheModel("c_ger_infantry_frozen_helm");
	precacheModel("c_ger_infantry_frozen_gear");
} 
