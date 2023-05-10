#include maps\mp\_utility;
main()
{
	
	maps\mp\mp_havana_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_havana");
	maps\mp\mp_havana_amb::main();
	
	
	maps\mp\gametypes\_teamset_urbanspecops::level_init();
	
	
}  
