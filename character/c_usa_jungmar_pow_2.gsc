
main()
{
	self setModel("c_usa_jungmar_2_pris_body");
	self.headModel = "c_usa_jungmar_2_pris_head";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_jungmar_2_pris_body");
	precacheModel("c_usa_jungmar_2_pris_head");
}  