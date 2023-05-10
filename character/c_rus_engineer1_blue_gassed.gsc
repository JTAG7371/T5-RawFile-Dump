
main()
{
	self setModel("c_rus_engineer1_body_blue_gassed");
	self.headModel = "c_rus_engineer_head1_gassed";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_engineer1_body_blue_gassed");
	precacheModel("c_rus_engineer_head1_gassed");
} 
