
#include maps\mp\_utility;
#include maps\mp\_ambientpackage;
main()
{
 thread CarioBarRadio();
}
CarioBarRadio()
{
	
	audio_trgger_damage = getent("amb_bar_music", "targetname");
 	if (isdefined (audio_trgger_damage))
	{ 	
		radio = getent("amb_bar_music_origin", "targetname");
		
		radio playloopsound ("amb_bar_music");
		radioplaying = true;
		
		while (radioplaying)		
		{
			audio_trgger_damage waittill( "damage", amount, attacker, direction, point, method );
	
				radio stoploopsound (.2);
			
				
				wait .5;
				radio playsound ("dst_electronics_sparks_lg");
				radioplaying = false;
			wait .5;
		}
		wait .5;
	}
}	