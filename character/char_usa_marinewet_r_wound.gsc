
main()
{
	self setModel("char_usa_marine_wet_body1_w");
	self.headModel = "char_usa_marine_head2_2";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_usa_marine_wet_body1_w");
	precacheModel("char_usa_marine_head2_2");
} 
