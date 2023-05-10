
main()
{
	self setModel("c_usa_rebirth_hazmat_body");
	self.headModel = "c_usa_rebirth_hazmat_head";
	self attach(self.headModel, "", true);
	self.hatModel = "c_usa_rebirth_hazmat_mask";
	self attach(self.hatModel);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_rebirth_hazmat_body");
	precacheModel("c_usa_rebirth_hazmat_head");
	precacheModel("c_usa_rebirth_hazmat_mask");
}  
