
main()
{
	self setModel("c_rus_military_body3");
	self.headModel = "c_rus_helicopter_pilot_head";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_military_body3");
	precacheModel("c_rus_helicopter_pilot_head");
}  
