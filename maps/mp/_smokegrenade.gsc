#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\_airsupport;

init()
{
	level.willyPeteDamageRadius = 300;	
	level.willyPeteDamageHeight = 128;	
	//level.willyPeteInnerDamage = 20;	
	//level.willyPeteOuterDamage = 10;	
	level.sound_smoke_start = "wpn_smoke_hiss_start";
	level.sound_smoke_loop = "wpn_smoke_hiss_lp";
	level.sound_smoke_stop = "wpn_smoke_hiss_end";
	level.smokeSoundDuration = 8;

	level.fx_smokegrenade_single = "smoke_center_mp";
	PreCacheItem( level.fx_smokegrenade_single );
}

watchSmokeGrenadeDetonation( owner )
{	
	self waittill( "explode", position, surface );
	
	if( !IsDefined(level.water_duds) || level.water_duds == true)
	{
		if( IsDefined(surface) && surface == "water" )
		{
			return;
		}
	}
	
	// do a little damage because it's white phosphorous, we want to control it here instead of the gdt entry
	oneFoot = ( 0, 0, 12 );
	startPos = position + oneFoot;

	SpawnTimedFX( level.fx_smokegrenade_single, position );
	thread playSmokeSound( position, level.smokeSoundDuration, level.sound_smoke_start, level.sound_smoke_stop, level.sound_smoke_loop );
	//level thread play_sound_in_space( "wpn_smoke_grenade_explode", position );

    owner maps\mp\gametypes\_globallogic_score::setWeaponStat( "willy_pete_mp", 1, "used" );

	//killCamEnt = spawn( "script_model", startPos + (0,0,16) );
	//killCamEnt thread deleteAfterTime( 15.0 );
	//killCamEnt.startTime = gettime();
	damageEffectArea ( owner, startPos, level.willyPeteDamageRadius, level.willyPeteDamageHeight, undefined );	
}	

damageEffectArea ( owner, position, radius, height, killCamEnt )
{
	// spawn trigger radius for the effect areas
	effectArea = spawn( "trigger_radius", position, 0, radius, height );

	// dog stuff
	owner thread maps\mp\_dogs::flash_dogs( effectArea );

	//players = get_players();
	//for (i = 0; i < players.size; i++)
	//{
	//	// if this is not hardcore then don't affect teammates
	//	if ( level.friendlyfire == 0 )
	//	{
	//		if ( players[i] != owner )				
	//		{
	//			if (!isdefined (owner) || !isdefined(owner.team) )
	//				continue;
	//			if( level.teambased && players[i].team == owner.team )
	//				continue;
	//		}
	//	}

	//	if( players[i] IsTouching( effectArea ) )
	//	{
	//		players[i] DoDamage( level.willyPeteInnerDamage, position, owner, killCamEnt, 0, "MOD_EXPLOSIVE", 0, "willy_pete_mp" );
	//	}
	//}

	// clean up
	effectArea delete();
}

