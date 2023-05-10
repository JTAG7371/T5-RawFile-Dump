
main()
{
	codescripts\character::setModelFromArray(xmodelalias\c_vtn_civ_town_upperbody_alias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\c_vtn_civ_head_alias::main());
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\c_vtn_civ_town_lowerbody_alias::main());
	self attach(self.hatModel, "", true);
	self.gearModel = codescripts\character::randomElement(xmodelalias\c_vtn_civ_town_accoutrement::main());
	self attach(self.gearModel, "", true);
	self.voice = "civilian";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\c_vtn_civ_town_upperbody_alias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_vtn_civ_head_alias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_vtn_civ_town_lowerbody_alias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_vtn_civ_town_accoutrement::main());
}  
