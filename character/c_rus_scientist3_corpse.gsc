
main()
{
	self setModel("c_rus_scientist_body3_corpse");
	self.headModel = "c_rus_scientist_head3";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_scientist_body3_corpse");
	precacheModel("c_rus_scientist_head3");
}  
