
main()
{
	self setModel("c_cub_tropas_body1");
	self.headModel = "c_cub_tropas_head1";
	self attach(self.headModel, "", true);
	self.gearModel = codescripts\character::randomElement(xmodelalias\c_cub_tropas_gearalias::main());
	self attach(self.gearModel, "", true);
	self.voice = "cuban";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_cub_tropas_body1");
	precacheModel("c_cub_tropas_head1");
	codescripts\character::precacheModelArray(xmodelalias\c_cub_tropas_gearalias::main());
} 
