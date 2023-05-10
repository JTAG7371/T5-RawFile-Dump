
main()
{
	self setModel("c_usa_ciawin_mp_body_armor_demo");
	self.headModel = "c_usa_ciawin_mp_head_1_demo";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_ciawin_mp_body_armor_demo");
	precacheModel("c_usa_ciawin_mp_head_1_demo");
} 
