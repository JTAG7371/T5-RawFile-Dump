
main()
{
	self setModel("c_rus_scientist_body2");
	self.headModel = "c_rus_scientist_head5";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_scientist_body2");
	precacheModel("c_rus_scientist_head5");
}  
