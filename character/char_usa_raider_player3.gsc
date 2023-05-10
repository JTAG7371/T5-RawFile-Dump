
main()
{
	self setModel("char_usa_raider_player_body1_1");
	self.headModel = "char_usa_raider_head3_3";
	self attach(self.headModel, "", true);
	self.hatModel = "char_usa_raider_helm3";
	self attach(self.hatModel);
	self.gearModel = "char_usa_raider_gear2";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_usa_raider_player_body1_1");
	precacheModel("char_usa_raider_head3_3");
	precacheModel("char_usa_raider_helm3");
	precacheModel("char_usa_raider_gear2");
} 
