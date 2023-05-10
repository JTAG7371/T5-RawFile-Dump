#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include animscripts\zombie_Utility;
chainsaw_precache()
{
	PrecacheModel( "zombie_sabertooth_icon" );
}
init()
{
	level.chainsaw_active = 0;
	level.chainsaw_last_drop_time = 0;
	level.chainsaw_pickup_pos = (-506, 127, -485+40);
}
chainsaw_set_spawn_position( pos )
{
	level.chainsaw_pickup_pos = pos;
}
chainsaw_debug_test()
{
	wait( 12 );
	chainsaw_pickup_spawn( (-506, 127, -485+40) );
}
chainsaw_pickup_spawn( pos )
{
	if( !isdefined( pos ) )
	{
		pos = level.chainsaw_pickup_pos;
	}
	chainsaw = spawn( "script_model", pos );
	chainsaw SetModel( "zombie_sabertooth_icon" );
	chainsaw thread chainsaw_timeout();
	chainsaw thread chainsaw_wobble();
	chainsaw thread chainsaw_pickup_grab();
}
chainsaw_wobble()
{
	self endon ("chainsaw_grabbed");
	self endon( "chainsaw_timedout" );
	if( isdefined(self) )
	{
		playfxontag (level._effect["powerup_on_red"], self, "tag_origin");
		self playsound("zmb_spawn_powerup");
		self playloopsound("zmb_spawn_powerup_loop");
	}
	while( isdefined(self) )
	{
		self rotateyaw( 360, 3, 3, 0 );
		wait( 3 );
	}
}
chainsaw_pickup_grab()
{
	self endon( "chainsaw_timedout" );
	
	found = 0;
	while( !found )
	{
		players = get_players();
		for( i=0; i < players.size; i++ )
		{
			dist = distance( players[i].origin, self.origin );
			if( dist < 80 )	
			{
				playfx( level._effect["powerup_grabbed"], self.origin );
				playfx( level._effect["powerup_grabbed_wave"], self.origin );
				playsoundatposition( "zmb_powerup_grabbed_3p", self.origin );
				wait( 0.1 );
				self stoploopsound();
				found = 1;
			}
		}
		wait( 0.25 );
		wait_network_frame();
	}
	
	
	
	
	self notify( "chainsaw_grabbed" );
	level thread player_chainsaw_control();
	wait_network_frame();
	wait( 0.1 );
	
	self delete();
}
player_chainsaw_control()
{
	level.chainsaw_active = 1;
	
 	flag_clear( "zombie_drop_powerups" );
	players = get_players();
	for( i=0; i<players.size; i++ )
	{
		player = players[i];
		if ( !player maps\_laststand::player_is_in_laststand() )
		{
			player chainsaw_pickup_message();
			player chainsaw_take_player_weapons();
			player chainsaw_give_to_player();
		}
	}
	
	
	time = 50;
	
	level thread chainsaw_countdown( time );
	wait( time );
	
	
	players = get_players();
	for( i=0; i<players.size; i++ )
	{
		player = players[i];
		player thread chainsaw_give_back_player_weapons();
	}
	
 	flag_set( "zombie_drop_powerups" );
	
	level.chainsaw_active = 0;
}
chainsaw_pickup_message()
{
	notifyData = spawnStruct();
	notifyData.titleText = &"ZOMBIE_CHAINSAW_PICKUP";
	notifyData.sound = "zmb_laugh_child";
	self thread maps\_hud_message::notifyMessage( notifyData );
}
chainsaw_take_player_weapons()
{
	if( !IsDefined( self.chainsaw ) )
	{
		self.chainsaw = SpawnStruct();
	}
		
	saw = self.chainsaw;
	saw.weaponInventory = self GetWeaponsList();
	saw.lastActiveWeapon = self GetCurrentWeapon();
	saw.weaponAmmo = [];	
	for( inv=0; inv<saw.weaponInventory.size; inv++ )
	{
		weapon = saw.weaponInventory[inv];
		saw.weaponAmmo[weapon]["clip"] = self GetWeaponAmmoClip( weapon );
		saw.weaponAmmo[weapon]["stock"] = self GetWeaponAmmoStock( weapon );
	}
	self TakeAllWeapons();
	self EnableInvulnerability();
}
chainsaw_give_to_player()
{
	self GiveWeapon( "sabertooth_zm" );
}
chainsaw_give_back_player_weapons()
{
	saw = self.chainsaw;
		
	if( isdefined( saw ) )
	{
		self TakeAllWeapons();
		
		for( inv=0; inv<saw.weaponInventory.size; inv++ )
		{
			weapon = saw.weaponInventory[inv];
			
			switch( weapon )
			{
				case "syrette_sp": 
				case "zombie_perk_bottle_doubletap": 
				case "zombie_perk_bottle_revive":
				case "zombie_perk_bottle_jugg":
				case "zombie_perk_bottle_sleight":
				case "zombie_perk_bottle_marathon":
				case "zombie_perk_bottle_nuke":
				continue;
			}
			self GiveWeapon( weapon );
			self SetWeaponAmmoClip( weapon, saw.weaponAmmo[weapon]["clip"] );
			if( WeaponType( weapon ) != "grenade" )
			{
				self SetWeaponAmmoStock( weapon, saw.weaponAmmo[weapon]["stock"] );
			}
			
			if( saw.lastActiveWeapon != "none" && is_placeable_mine( saw.lastActiveWeapon ) )
			{
				self SwitchToWeapon( saw.lastActiveWeapon );
			}
			else
			{
				primaryWeapons = self GetWeaponsListPrimaries();
				if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
				{
					self SwitchToWeapon( primaryWeapons[0] );
				}
			}
		}
		
		self.chainsaw = undefined;
	}
	wait( 2 );
	self DisableInvulnerability();
}
chainsaw_player_enters_laststand()
{
	saw = self.chainsaw;
	if( isdefined( saw ) )
	{
		
		self chainsaw_give_back_player_weapons();
		
		
	}
}
chainsaw_countdown( time )
{
	wait( 0.1 );
	level.chainsaw_hud = create_counter_hud();
	level.chainsaw_hud SetValue( time );
	level.chainsaw_hud.color = ( 1, 1, 1 );
	level.chainsaw_hud.alpha = 1;
	level.chainsaw_hud FadeOverTime( 2.0 );
	level.chainsaw_hud.color = ( 0.95, 0.71, 0 );
	level.chainsaw_hud FadeOverTime( 3.0 );
	while( time >= 1 )
	{
		time--;
		level.chainsaw_hud SetValue( time );
		wait (1);
	}
	level.chainsaw_hud FadeOverTime( 1.0 );
	level.chainsaw_hud.color = (1,1,1);
	level.chainsaw_hud.alpha = 0;
	wait( 0.1 );
	level.chainsaw_hud destroy_hud();
}
chainsaw_timeout()
{
	self endon ("chainsaw_grabbed");
	wait( 25 );
	for( i=0; i<40; i++)
	{
		
		if (i % 2)
		{
			self hide();
		}
		else
		{
			self show();
		}
		if (i < 15)
		{
			wait 0.5;
		}
		else if (i < 25)
		{
			wait 0.25;
		}
		else
		{
			wait 0.1;
		}
	}
	self notify ("chainsaw_timedout");
	self delete();
} 
  
