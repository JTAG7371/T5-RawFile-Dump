
main()
{
	self setModel("c_rus_fullahead_officer2_body");
	self.headModel = "c_rus_fullahead_officer2_head";
	self attach(self.headModel, "", true);
	self.voice = "russian_english";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_fullahead_officer2_body");
	precacheModel("c_rus_fullahead_officer2_head");
}  
