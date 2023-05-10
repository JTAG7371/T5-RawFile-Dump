
main()
{
	codescripts\character::setModelFromArray(xmodelalias\c_vtn_nova_bodiesalias::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\c_vtn_nova_shirtsalias::main());
	self attach(self.headModel, "", true);
	self.voice = "civilian";
	self.skeleton = "base";
}
precache()
{
	codescripts\character::precacheModelArray(xmodelalias\c_vtn_nova_bodiesalias::main());
	codescripts\character::precacheModelArray(xmodelalias\c_vtn_nova_shirtsalias::main());
}  
