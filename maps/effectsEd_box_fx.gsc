
#include maps\_utility;
main()
{
	
	precacheFX();	
	effectsEd_spawnFX();
}
precacheFX()
{
	
	
	level._effect["missing_effect"]	= loadfx ("misc/fx_missing_fx");
	level._effect["test_smoke"]	= loadfx ("Temp_effects/fx_tmp_smoke_plume_med_slow_def");
	
	
}
effectsEd_spawnFX()
{
maps\createfx\effectsEd_box_fx::main();
 }                       