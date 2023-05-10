
main()
{
	self setModel("c_usa_pent_ciaagent_body");
	self.headModel = "c_usa_pent_ciaagent_head2";
	self attach(self.headModel, "", true);
	self.gearModel = "c_usa_pent_ciaagent_radio";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_pent_ciaagent_body");
	precacheModel("c_usa_pent_ciaagent_head2");
	precacheModel("c_usa_pent_ciaagent_radio");
}  
