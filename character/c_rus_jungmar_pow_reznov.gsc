
main()
{
	self setModel("c_rus_jungmar_reznov_pris_body");
	self.headModel = "c_rus_jungmar_reznov_pris_head";
	self attach(self.headModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_jungmar_reznov_pris_body");
	precacheModel("c_rus_jungmar_reznov_pris_head");
}  