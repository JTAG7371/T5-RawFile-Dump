
main()
{
	self setModel("c_usa_moto_cop_body");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_usa_moto_cop_head_alias::main());
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_moto_cop_body");
	codescripts\character::precacheModelArray(xmodelalias\c_usa_moto_cop_head_alias::main());
}  
