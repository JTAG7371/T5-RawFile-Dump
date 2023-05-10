#include maps\mp\_utility;
main()
{
	
	
	maps\mp\mp_cracked_fx::main();
	if ( GetDvarInt( #"xblive_wagermatch" ) == 1 )
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_cracked_wager");
	}
	else
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_cracked");
	}
	maps\mp\_load::main();
	maps\mp\mp_cracked_amb::main();
	
	
	maps\mp\gametypes\_teamset_junglemarines::level_init();
	
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
}  
