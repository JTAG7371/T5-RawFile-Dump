
main()
{
	self setModel("c_usa_militarypolice_body");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_usa_militarypolice_head_alias::main());
	self attach(self.headModel, "", true);
	self.hatModel = "c_usa_militarypolice_hat";
	self attach(self.hatModel);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_militarypolice_body");
	codescripts\character::precacheModelArray(xmodelalias\c_usa_militarypolice_head_alias::main());
	precacheModel("c_usa_militarypolice_hat");
}  
