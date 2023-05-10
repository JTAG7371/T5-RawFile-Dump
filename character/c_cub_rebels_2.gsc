
main()
{
	self setModel("c_cub_rebels_body2");
	self.headModel = "c_cub_rebels_head2";
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\c_cub_rebels_hatalias::main());
	self attach(self.hatModel, "", true);
	self.voice = "cuban";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_cub_rebels_body2");
	precacheModel("c_cub_rebels_head2");
	codescripts\character::precacheModelArray(xmodelalias\c_cub_rebels_hatalias::main());
} 
