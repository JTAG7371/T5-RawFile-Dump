
main()
{
	self setModel("c_rus_scientist_body2_corpse");
	self.headModel = "c_rus_scientist_head2";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_scientist_body2_corpse");
	precacheModel("c_rus_scientist_head2");
}  
