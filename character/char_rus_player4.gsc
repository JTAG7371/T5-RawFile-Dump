
main()
{
	self setModel("char_rus_guard_player_body1_2");
	self.headModel = "char_rus_guard_head4_4";
	self attach(self.headModel, "", true);
	self.hatModel = "char_rus_guard_ushankaup1";
	self attach(self.hatModel);
	self.gearModel = "char_rus_guard_body1_gear2_1";
	self attach(self.gearModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("char_rus_guard_player_body1_2");
	precacheModel("char_rus_guard_head4_4");
	precacheModel("char_rus_guard_ushankaup1");
	precacheModel("char_rus_guard_body1_gear2_1");
} 
