#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility;
#include maps\_zombiemode_net;
#using_animtree( "generic_human" );
init()
{
	if( !sabertooth_exists() )
	{
		return;
	}
	
	precacheshellshock( "sabertooth_dmg" );
	level._effect["sabertooth_blood_geyser_view"] = loadfx("weapon/sabre_tooth/fx_zombie_st_blood_view");
	level._effect["sabertooth_blood_geyser_world"] = loadfx("weapon/sabre_tooth/fx_zombie_st_blood_world");
	set_zombie_var( "sabertooth_pain_time", 1 );
	set_zombie_var( "sabertooth_360_range",	270 ); 
	level thread sabertooth_on_player_connect(); 
}
sabertooth_on_player_connect()
{
	for( ;; )
	{
		level waittill( "connecting", player ); 
		player thread wait_for_sabertooth_360_fired(); 
		player thread sabertooth_sound_thread(); 
		player thread sabertooth_swap();
	}
}
wait_for_sabertooth_360_fired()
{
	self endon( "disconnect" );
	self waittill( "spawned_player" ); 
	for( ;; )
	{
		self waittill( "weapon_fired" ); 
		currentweapon = self GetCurrentWeapon(); 
		if( ( currentweapon == "sabertooth_360_zm" ) || ( currentweapon == "sabertooth_360_upgraded_zm" ) )
		{
			self thread sabertooth_360_fired( currentweapon ); 
		}
	}
}
sabertooth_360_fired( weap )
{
	origin = self GetEye();
	zombies = get_array_of_closest( origin, GetAiSpeciesArray( "axis", "all" ), undefined, undefined, level.zombie_vars["sabertooth_360_range"] );
	if ( !isDefined( zombies ) )
	{
		return;
	}
	wait_time = 0;
	killed_count = 0;
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( !IsDefined( zombies[i] ) )
		{
			continue;
		}
		test_origin = zombies[i] getcentroid();
		if ( !BulletTracePassed( origin, test_origin, false, undefined ) )
		{
			continue;
		}
		
		zombies[i] sabertooth_360_kill_zombie( self, wait_time, weap );
		killed_count += 1;
		if ( !(killed_count % 3) )
		{
			wait_time = min( wait_time + 0.1, 0.4 );
		}
	}
}
sabertooth_360_kill_zombie( player, wait_time, weap )
{
	self endon( "death" );
	player endon( "disconnect" );
	if ( wait_time )
	{
		wait( wait_time );
	}
	if( !IsDefined( self ) || !IsAlive( self ) )
	{
		
		return;
	}
	direction_vec = VectorNormalize( self.origin - player.origin );
	direction_vec = vector_scale( direction_vec, 75);
	self StartRagdoll();
	self launchragdoll(direction_vec);
	wait_network_frame();
	self playweapondeatheffects( weap, player getEntityNumber() );
	self DoDamage( self.health + 666, player.origin, player, undefined, "riflebullet" );
}
sabertooth_damage_start( player, mod, hit_location )
{
	if ( !isDefined( self.sabertooth_damage_counter ) || 0 >= self.sabertooth_damage_counter )
	{
		self.sabertooth_damage_counter = 0.25;
		self playWeaponDamageEffects( self.damageweapon, player getEntityNumber() );
		self thread sabertooth_damage_countdown();
		self thread sabertooth_send_damage_end( self.damageweapon );
	}
	else
	{
		self.sabertooth_damage_counter += 0.05;
	}
	player shellshock( "sabertooth_dmg", 0.1 );
	modName = remove_mod_from_methodofdeath( mod );
	if ( self.animname != "ape_zombie" && !level.zombie_vars["zombie_insta_kill"] )
	{
		self DoDamage( int( self.maxhealth * .35 ), self.origin, player, undefined, modName, hit_location );
	}
}
sabertooth_death( player )
{
	self notify( "sabertooth_death" );
	self.sabertooth_death = true;
	self playWeaponDeathEffects( self.damageweapon, player getEntityNumber() );
	player shellshock( "sabertooth_dmg", 0.1 );
}
sabertooth_damage_countdown()
{
	self endon( "death" );
	self endon( "sabertooth_death" );
	self endon( "sabertooth_send_damage_end" );
	
	while ( self.sabertooth_damage_counter > 0 )
	{
		wait( 0.05 );
		
		self.sabertooth_damage_counter -= 0.05;
	}
	
	self notify( "sabertooth_send_damage_end" );
}
sabertooth_send_damage_end( damageweapon )
{
	self endon( "sabertooth_death" );
	self waittill_any( "death", "sabertooth_send_damage_end" );
	self playWeaponDamageEffects( damageweapon, 65535 );
}
sabertooth_exists()
{
	return IsDefined( level.zombie_weapons["sabertooth_zm"] );
}
is_sabertooth_damage( mod )
{
	return (mod == "MOD_RIFLE_BULLET" && IsDefined( self.damageweapon ) && (self.damageweapon == "sabertooth_zm" || self.damageweapon == "sabertooth_upgraded_zm"));
}
enemy_killed_by_sabertooth()
{
	return ( IsDefined( self.sabertooth_death ) && self.sabertooth_death == true ); 
}
sabertooth_swap()
{
	self endon( "disconnect" );
	
	while (1)
	{
		last_weapon = self getCurrentWeapon();
		self waittill( "weapon_change" );
		if ( last_weapon == "sabertooth_zm" || last_weapon == "sabertooth_upgraded_zm" )
		{
			self clientnotify( "st0" );	
		}
	}
}
sabertooth_sound_thread()
{
	self endon( "disconnect" );
	self waittill( "spawned_player" ); 
	for( ;; )
	{
		result = self waittill_any_return( "grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback" );		
		if ( !IsDefined( result ) )
		{
			continue;
		}
		if( ( result == "weapon_change" || result == "grenade_fire" ) && (self GetCurrentWeapon() == "sabertooth_zm" || self GetCurrentWeapon() == "sabertooth_upgraded_zm") )
		{
			
			
		}
		else
		{
			self notify ("weap_away");
			
			
		}
	}
}  
