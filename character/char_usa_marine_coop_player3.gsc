
main()
{
	self setModel("char_usa_marine_coop_body3");
	self.hatModel = "char_usa_marine_coop_defhat";
	self attach(self.hatModel);
	self.gearModel = "char_usa_marine_coop_defpak";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_usa_marine_coop_body3");
	precacheModel("char_usa_marine_coop_defhat");
	precacheModel("char_usa_marine_coop_defpak");
} 
