
main()
{
	self setModel("c_rus_scientist_body1");
	self.headModel = "c_rus_scientist_head1";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_scientist_body1");
	precacheModel("c_rus_scientist_head1");
}  
