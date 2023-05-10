
main()
{
	self setModel("char_usa_raider_body1_1");
	self.headModel = "char_usa_marine_head_behead";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_usa_raider_body1_1");
	precacheModel("char_usa_marine_head_behead");
} 
