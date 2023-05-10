
main()
{
	codescripts\character::setModelFromArray(xmodelalias\c_cub_civilians_upperalias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\c_cub_civilians_headalias::main());
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\c_cub_civilians_hatalias::main());
	self attach(self.hatModel, "", true);
	self.gearModel = codescripts\character::randomElement(xmodelalias\c_cub_civilians_loweralias::main());
	self attach(self.gearModel, "", true);
	self.voice = "cuban";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\c_cub_civilians_upperalias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_cub_civilians_headalias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_cub_civilians_hatalias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_cub_civilians_loweralias::main());
} 
