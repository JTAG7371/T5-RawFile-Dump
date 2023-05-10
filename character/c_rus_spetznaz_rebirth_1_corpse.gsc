
main()
{
	self setModel("c_rus_spetznaz_body1_corpse");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_rus_spetsnaz_rebirth_head_alias::main());
	self attach(self.headModel, "", true);
	self.gearModel = "c_rus_spetznaz_body1_gear1";
	self attach(self.gearModel, "", true);
	self.voice = "russian";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_rus_spetznaz_body1_corpse");
	codescripts\character::precacheModelArray(xmodelalias\c_rus_spetsnaz_rebirth_head_alias::main());
	precacheModel("c_rus_spetznaz_body1_gear1");
}  
