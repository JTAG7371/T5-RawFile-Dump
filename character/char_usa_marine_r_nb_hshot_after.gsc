
main()
{
	self setModel("char_usa_marine_body1_1");
	self.headModel = "char_usa_marine_head_shot";
	self attach(self.headModel, "", true);
	self.gearModel = "char_usa_raider_gear2";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_usa_marine_body1_1");
	precacheModel("char_usa_marine_head_shot");
	precacheModel("char_usa_raider_gear2");
} 
