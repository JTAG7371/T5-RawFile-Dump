
main()
{
	self setModel("c_rus_fullahead_officer1_body");
	self.headModel = "c_rus_fullahead_officer1_head";
	self attach(self.headModel, "", true);
	self.voice = "russian_english";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_fullahead_officer1_body");
	precacheModel("c_rus_fullahead_officer1_head");
}  
