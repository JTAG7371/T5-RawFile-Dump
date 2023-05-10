
main()
{
	self setModel("c_cub_tropas_mp_body_flak_demo");
	self.headModel = "c_cub_tropas_mp_head_3_demo";
	self attach(self.headModel, "", true);
	self.voice = "cuban";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_cub_tropas_mp_body_flak_demo");
	precacheModel("c_cub_tropas_mp_head_3_demo");
}  
