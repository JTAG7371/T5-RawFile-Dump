
main()
{
	self setModel("c_rus_fullahead_soldier_body1");
	self.headModel = "c_rus_fullahead_head3";
	self attach(self.headModel, "", true);
	self.voice = "russian_english";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_fullahead_soldier_body1");
	precacheModel("c_rus_fullahead_head3");
}  
