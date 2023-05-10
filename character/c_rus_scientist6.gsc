
main()
{
	self setModel("c_rus_scientist_body3");
	self.headModel = "c_rus_scientist_head6";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_scientist_body3");
	precacheModel("c_rus_scientist_head6");
}  
