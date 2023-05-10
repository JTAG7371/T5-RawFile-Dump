
main()
{
	self setModel("c_usa_rebirth_hazmat_body");
	self.headModel = "c_usa_rebirth_hazmat_head_gas";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_rebirth_hazmat_body");
	precacheModel("c_usa_rebirth_hazmat_head_gas");
}  
