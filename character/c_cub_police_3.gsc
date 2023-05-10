
main()
{
	self setModel("c_cub_police_body_blk");
	self.headModel = "c_cub_police_head3";
	self attach(self.headModel, "", true);
	self.hatModel = "c_cub_police_hat";
	self attach(self.hatModel);
	self.gearModel = "c_cub_police_gear";
	self attach(self.gearModel, "", true);
	self.voice = "cuban";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_cub_police_body_blk");
	precacheModel("c_cub_police_head3");
	precacheModel("c_cub_police_hat");
	precacheModel("c_cub_police_gear");
} 
