
#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility; 
init()
{
	flag_init("end_target_confirm");
	precacheItem( "zombie_airstrike" );
	precacheItem( "zombie_artillery" );
	precacheItem( "zombie_napalm" );
	precacheItem( "zombie_helicopter" );
	precacheItem( "zombie_dogs" );
	precacheItem( "zombie_turret" );
	precacheItem( "zombie_portal" );
	precacheItem( "zombie_rcbomb" );
	precacheItem( "zombie_cloak" );
	precacheItem( "zombie_endurance" );
	
	precacheLocationSelector( "map_artillery_selector" );	
	initAbilityTable();
		
 	level.hardpointHints["zombie_artillery"] = 						&"ZOMBIE_EARNED_ARTILLERY";
 	level.hardpointHints["zombie_airstrike"] = 						&"ZOMBIE_EARNED_AIRSTRIKE";
 	level.hardpointHints["zombie_napalm"] = 						&"ZOMBIE_EARNED_NAPALM";
 	level.hardpointHints["zombie_dogs"] = 							&"ZOMBIE_EARNED_DOGS";
 	level.hardpointHints["zombie_rcbomb"] = 						&"ZOMBIE_EARNED_RCBOMB";
 	level.hardpointHints["zombie_cloak"] = 							&"ZOMBIE_EARNED_CLOAK";
 	level.hardpointHints["zombie_endurance"] = 						&"ZOMBIE_EARNED_ENDURANCE";
 	level.hardpointHints["zombie_helicopter"] =						&"ZOMBIE_EARNED_HELICOPTER";
 
 
 	level.hardpointHints["zombie_turret"] =							&"ZOMBIE_EARNED_TURRET";
 	level.hardpointHints["zombie_portal"] =							&"ZOMBIE_EARNED_PORTAL";
 	level.hardpointHints["zombie_artillery_not_available"] = 		&"ZOMBIE_ARTILLERY_NOT_AVAILABLE";
 	level.hardpointHints["zombie_airstrike_not_available"] = 		&"ZOMBIE_AIRSTRIKE_NOT_AVAILABLE";
 	level.hardpointHints["zombie_napalm_not_available"] = 			&"ZOMBIE_NAPALM_NOT_AVAILABLE";
 	level.hardpointHints["zombie_dogs_not_available"] = 			&"ZOMBIE_DOGS_NOT_AVAILABLE";
 	level.hardpointHints["zombie_rcbomb_not_available"] = 			&"ZOMBIE_RCBOMB_NOT_AVAILABLE";
 	level.hardpointHints["zombie_cloak_not_available"] = 			&"ZOMBIE_CLOAK_NOT_AVAILABLE";
 	level.hardpointHints["zombie_endurance_not_available"] = 		&"ZOMBIE_ENDURANCE_NOT_AVAILABLE";
 	level.hardpointHints["zombie_helicopter_not_available"] = 		&"ZOMBIE_HELICOPTER_NOT_AVAILABLE";
 
 
 	level.hardpointHints["zombie_turret_not_available"] =			&"ZOMBIE_TURRET_NOT_AVAILABLE";
 	level.hardpointHints["zombie_portal_not_available"] =			&"ZOMBIE_PORTAL_NOT_AVAILABLE";
 	level.hardpointInforms["zombie_artillery"] = 					"zombie_ability_artillery";
 	level.hardpointInforms["zombie_airstrike"] = 					"zombie_ability_airstrike";
 	level.hardpointInforms["zombie_napalm"] = 						"zombie_ability_napalm";
 	level.hardpointInforms["zombie_dogs"] = 						"zombie_ability_dogs";
 	level.hardpointInforms["zombie_rcbomb"] = 						"zombie_ability_rccar";
 	level.hardpointInforms["zombie_cloak"] = 						"zombie_ability_cloak";
 	level.hardpointInforms["zombie_endurance"] = 					"zombie_ability_endurance";
 	level.hardpointInforms["zombie_helicopter"] = 					"zombie_ability_heli";
 
 
 	level.hardpointInforms["zombie_turret"] = 						"zombie_ability_turret";
 	level.hardpointInforms["zombie_portal"] = 						"zombie_ability_portal";
	level.hardpointInforms["zombie_artillery_used"] = 				&"ZOMBIE_ABILITY_ARTILLERY_USED";
 	level.hardpointInforms["zombie_airstrike_used"] = 				&"ZOMBIE_ABILITY_AIRSTRIKE_USED";
 	level.hardpointInforms["zombie_napalm_used"] = 					&"ZOMBIE_ABILITY_NAPALM_USED";
 	level.hardpointInforms["zombie_dogs_used"] = 					&"ZOMBIE_ABILITY_DOGS_USED";
 	level.hardpointInforms["zombie_rcbomb_used"] = 					&"ZOMBIE_ABILITY_RCCAR_USED";
 	level.hardpointInforms["zombie_cloak_used"] = 					&"ZOMBIE_ABILITY_CLOAK_USED";
 	level.hardpointInforms["zombie_endurance_used"] = 				&"ZOMBIE_ABILITY_ENDURANCE_USED";
 	level.hardpointInforms["zombie_helicopter_used"] = 				&"ZOMBIE_ABILITY_HELI_USED";
 
 
 	level.hardpointInforms["zombie_turret_used"] = 					&"ZOMBIE_ABILITY_TURRET_USED";
 	level.hardpointInforms["zombie_portal_used"] = 					&"ZOMBIE_ABILITY_PORTAL_USED";
 	precacheString( level.hardpointHints["zombie_artillery"] );	
 	precacheString( level.hardpointHints["zombie_airstrike"] );	
 	precacheString( level.hardpointHints["zombie_napalm"] );	
 	precacheString( level.hardpointHints["zombie_dogs"] );	
 	precacheString( level.hardpointHints["zombie_rcbomb"] );
 	precacheString( level.hardpointHints["zombie_cloak"] );
 	precacheString( level.hardpointHints["zombie_endurance"] );
 		
 	precacheString( level.hardpointHints["zombie_helicopter"] );	
 
 
 	precacheString( level.hardpointHints["zombie_turret"] );
 	precacheString( level.hardpointHints["zombie_portal"] );
 	
 	precacheString( level.hardpointHints["zombie_artillery_not_available"] );
 	precacheString( level.hardpointHints["zombie_airstrike_not_available"] );
 	precacheString( level.hardpointHints["zombie_napalm_not_available"] );
 	precacheString( level.hardpointHints["zombie_dogs_not_available"] );
 	precacheString( level.hardpointHints["zombie_rcbomb_not_available"] );	
 	precacheString( level.hardpointHints["zombie_cloak_not_available"] );	
 	precacheString( level.hardpointHints["zombie_endurance_not_available"] );	
 	
 	precacheString( level.hardpointHints["zombie_helicopter_not_available"] );	
 
 
 	precacheString( level.hardpointHints["zombie_turret_not_available"] );	
 	precacheString( level.hardpointHints["zombie_portal_not_available"] );	
 	game["dialog"]["artillery_inbound"] = 			"friendlyartillery";
 	game["dialog"]["airstrike_inbound"] = 			"friendlyairstrike";
 	game["dialog"]["napalm_inbound"] = 				"friendlynapalm";
 	game["dialog"]["dogs_inbound"] = 				"friendlydogs";
 	game["dialog"]["helicopter_inbound"] = 			"friendlyheli";
	game["dialog"]["enemy_turret_online"] = 		"turret";
	game["dialog"]["enemy_portal_online"] = 		"portal";
 	
 	game["dialog"]["zombie_artillery"] = 			"artillery";
 	game["dialog"]["zombie_airstrike"] = 			"airstrike";
 	game["dialog"]["zombie_napalm"] = 				"napalm";
 	game["dialog"]["zombie_dogs"] = 				"dogsupport";
 	game["dialog"]["zombie_rcbomb"] = 				"rcbomb";
 	game["dialog"]["zombie_cloak"] = 				"cloak";
 	game["dialog"]["zombie_endurance"] = 			"endurance";
 	
 	game["dialog"]["zombie_helicopter"] = 			"helisupport";
 
 
 	game["dialog"]["zombie_turret"] = 				"turretsupport";
 	game["dialog"]["zombie_portal"] = 				"portalsupport";
	level._effect["target_arrow_green"]			= loadfx("misc/fx_zombie_ui_airstrike_smk_grn");
	level._effect["target_arrow_yellow"]		= loadfx("misc/fx_zombie_ui_airstrike_smk_yellow");
	level._effect["target_arrow_red"]			= loadfx("misc/fx_zombie_ui_airstrike_smk_red");
	
	if ( GetDvar( #"scr_dog_hardpoint_interval" ) != "" )
		level.dogsInterval = GetDvarFloat( #"scr_dog_hardpoint_interval" );
	else
	{
		setdvar( "scr_dog_hardpoint_interval" , 180 );
		level.dogsInterval = 180; 
	}
	
	
	if ( GetDvar( #"scr_heli_hardpoint_interval" ) != "" )
		level.helicopterInterval = GetDvarFloat( #"scr_heli_hardpoint_interval" );
	else
	{
		setdvar( "scr_heli_hardpoint_interval" , 180 );
		level.helicopterInterval = 180; 
	}
	level.numHardpointReservedObjectives = 0;
	level.abilityTraceLength = 4000;
	flag_init( "ability_firing" );
	
	maps\_zombiemode_ability_airstrike::init();
 	maps\_zombiemode_ability_napalm::init();
 	maps\_zombiemode_ability_helicopter::init();
 	maps\_zombiemode_ability_artillery::init();
 	maps\_zombiemode_ability_dogs::init();
 	maps\_zombiemode_ability_turret::init();
 	maps\_zombiemode_ability_portal::init();
 	maps\_zombiemode_ability_rcbomb::init();
 	maps\_zombiemode_ability_cloak::init();
 	maps\_zombiemode_ability_endurance::init();
	level thread init_ability_wallbuys();
}
create_simple_ability_hud( )
{
	hud = create_simple_hud( self );
	hud.alignX = "center"; 
	hud.alignY = "bottom";
	hud.horzAlign = "center"; 
	hud.vertAlign = "bottom";
	return hud;
}
create_ability_slot_hud()
{
	curr_ability_offset = -50;
	if ( !IsDefined( self.hud_ability ) )
	{
		hud = self create_simple_ability_hud();
		hud.color = ( 1, 1, 1 );
		hud.scale = 32;
		hud.alpha = 0;
		hud.y = curr_ability_offset;
		hud SetShader( "white", 64, 64 );
		self.hud_ability = hud;
	}
	
	
}
initAbilityTable()
{
	
	
	
	init_ability( "zombie_airstrike", 5, 5, "hud_icon_airstrike", 2000, &"ZOMBIE_ABILITY_AIRSTRIKE", &"ZOMBIE_ROUND_AIRSTRIKE" );
	init_ability( "zombie_turret", 5, 5, "hud_icon_mg42", 2000, &"ZOMBIE_ABILITY_TURRET", &"ZOMBIE_ROUND_TURRET" );
 	init_ability( "zombie_portal", 5, 5, "zom_icon_portal", 2000, &"ZOMBIE_ABILITY_PORTAL", &"ZOMBIE_ROUND_PORTAL" );
	init_ability( "zombie_napalm", 5, 5, "hud_icon_air_napalm", 2000, &"ZOMBIE_ABILITY_NAPALM", &"ZOMBIE_ROUND_NAPALM" );
 	init_ability( "zombie_helicopter", 5, 5, "hud_icon_helicopter", 2000, &"ZOMBIE_ABILITY_HELICOPTER", &"ZOMBIE_ROUND_HELICOPTER" );
 	init_ability( "zombie_artillery", 5, 5, "hud_icon_artillery", 2000, &"ZOMBIE_ABILITY_ARTILLERY", &"ZOMBIE_ROUND_ARTILLERY" );
 	init_ability( "zombie_dogs", 5, 5, "hud_icon_dogkill", 2000, &"ZOMBIE_ABILITY_DOGS", &"ZOMBIE_ROUND_DOGS" );
 	init_ability( "zombie_cloak", 5, 5, "hud_icon_cloak", 2000, &"ZOMBIE_ABILITY_CLOAK", &"ZOMBIE_ROUND_CLOAK" );
 	init_ability( "zombie_endurance", -1, 1, "hud_icon_endurance", 2000, &"ABILITY_ENDURANCE", &"ZOMBIE_ROUND_ENDURANCE" );
 	
	
 	
}
init_ability( ability_name, round_available, max_available, material_name, cost, hint, hint_round )
{
	
	difficulty = 1;
	if( difficulty == 3 )
	{
		return;
	}
	
	if ( !IsDefined( max_available ) )
	{
		max_available = 1;
	}
	
	level._abilities[ ability_name ]					= spawnStruct();
	level._abilities[ ability_name ].round_available	= round_available;
	level._abilities[ ability_name ].max_available		= max_available;
	level._abilities[ ability_name ].in_use				= false;
	level._abilities[ ability_name ].material_name		= material_name;
	level._abilities[ ability_name ].cost				= cost;
	level._abilities[ ability_name ].hint				= hint;
	level._abilities[ ability_name ].hint_round			= hint_round;
	PrecacheString( hint );
	PrecacheString( hint_round );
	preCacheShader( material_name );
}
getRandomAbility( round_number )
{
	if( !IsDefined(level._abilities) )
	{
		return undefined;
	}
	keys = GetArrayKeys( level._abilities );
	abilities = [];
	for ( i = 0; i < keys.size; i++ )
	{
		if ( (level._abilities[ keys[i] ].round_available!=-1) && (level._abilities[ keys[i] ].round_available >= round_number) )
			abilities[ abilities.size ] = keys[i];
	}
	if ( !abilities.size )
	{
		return undefined;
	}
	return abilities[ RandomInt( abilities.size ) ];
}
isHardPointAvailableForAbility( ability )
{
	if ( IsDefined( level._abilities ) && IsDefined( level._abilities[ability] ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}
drawLine( start, end, timeSlice, color )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
}
giveAbility( ability )
{
	
	
	
	
		self giveHardpoint( ability );
		self notify( "ability_awarded" );
		self create_ability_slot_hud();
		self.hud_ability FadeOverTime( 1.0 );
		self.hud_ability.alpha = 1.0;
		
		
		self maps\_zombiemode_ability_airstrike::set_airstrike_status( "update" );
		self maps\_zombiemode_ability_napalm::set_napalm_status( "update" );
	
	
}
giveHardpointItems()
{
	self update_player_ability_status();
}
giveHardpoint( hardpointType )
{
	self endon("disconnect");
	level endon( "game_ended" );
	
	had_to_delay = false;
	
	if ( IsDefined( self.selectingLocation ) && hasHardpointItemEquipped( ) )
	{
		self waittill( "stop_location_selection" );
		had_to_delay = true;
	}
	self giveHardpointItem( hardpointType );
}
give_round1_abilities()
{
	
	
	
	
	self give_ability_now( "zombie_turret" );
	wait_network_frame();
	
	
	self maps\_zombiemode_ability_airstrike::set_airstrike_status( "update" );
	self maps\_zombiemode_ability_napalm::set_napalm_status( "update" );
}
give_ability_now( ability )
{
	if ( maps\_zombiemode_ability::isHardPointAvailableForAbility( ability ) )
	{
		
		
		
			self maps\_zombiemode_ability::giveHardpoint( ability );
			self notify( "ability_awarded" );
			self maps\_zombiemode_ability::create_ability_slot_hud();
			self.hud_ability FadeOverTime( 1.0 );
			self.hud_ability.alpha = 1.0;
			
			
			
		
		
		
		
		
	}
	self update_player_ability_status();
}
hasHardpointItemEquipped( )
{
	currentWeapon = self getCurrentWeapon();
 	if(	currentWeapon == "zombie_airstrike" || 
 		currentWeapon == "zombie_napalm" || 
 		currentWeapon == "zombie_artillery" || 
 		currentWeapon == "zombie_helicopter" || 
 		currentWeapon == "zombie_dogs" ||
 		currentWeapon == "zombie_turret" || 
 		currentWeapon == "zombie_portal" || 
 		currentWeapon == "zombie_rcbomb" ||
 		currentWeapon == "zombie_cloak" ||
 		currentWeapon == "zombie_endurance" )
 			return true;
	return false;
}
giveHardpointItem( ability_type, do_not_update_death_count )
{
	
	if( level.round_number > 1 )
	{
		self display_message( level.hardpointHints[ability_type] );
	}
	if ( level.gameEnded )
		return;
		
		
	if ( IsDefined( self.selectingLocation ) && hasHardpointItemEquipped( ) )
		return false;
	if ( !IsDefined( level._abilities[ability_type] ) )
		return false;
	if ( (!IsDefined( level.heli_paths ) || !level.heli_paths.size) && ( ability_type == "helicopter_mp" || ability_type == "helicopter_x2_mp"  || ability_type == "helicopter_comlink_mp" ) )
	{
		
		return false;
	}
	
	
	
	
	
	if( isDefined( self.curr_ability ) )
	{
		self TakeWeapon( self.curr_ability );
	}
	self.curr_ability = ability_type;
	self setActionSlot( 1, "weapon", self.curr_ability );
	self giveWeapon( ability_type );
	
	
	self.pers["hardPointItem"] = ability_type;	
	if ( !IsDefined( do_not_update_death_count ) || do_not_update_death_count != false )
	{
		self.pers["hardPointItemDeathCount"+ability_type] = self.deathCount;
	}	
	
	return true;
}
takeHardpointItem( hardpointType )
{
	if ( level.gameEnded )
		return;
		
	if ( GetDvar( #"scr_game_hardpoints" ) != "" && GetDvarInt( #"scr_game_hardpoints" ) == 0 )
		return false;
		
	if ( IsDefined( self.selectingLocation ) )
		return false;
	if ( !IsDefined( level._abilities[hardpointType] ) )
		return false;
	if ( IsDefined( self.pers["hardPointItem"] ) )
	{
		if ( self.pers["hardPointItem"] != hardpointType )
			return false;
	}
	
	
	return true;
}
giveOwnedHardpointItem()
{
	if ( IsDefined( self.pers["hardPointItem"] ) )
		self giveHardpointItem( self.pers["hardPointItem"], false );
}
clear_hud()
{
	if ( IsDefined( self.hud_ability ) )
	{
		self.hud_ability Destroy();
		self.hud_ability = undefined;
	}
	
	
}
update_player_ability_status()
{
	
	
	ability = self.curr_ability;
	if ( !IsDefined( ability )  )
	{
		clear_hud();
		return;
	}
	self create_ability_slot_hud();
	if ( IsDefined( self.hud_ability ) )
	{
		if ( level._abilities[ self.curr_ability ].in_use )
		{
			self.hud_ability SetShader( level._abilities[ self.curr_ability ].material_name, 32, 32 );
			self.hud_ability.color = ( 1, 0, 0 );
		}
		else
		{
			self.hud_ability SetShader( level._abilities[ self.curr_ability ].material_name, 32, 32 );
			self.hud_ability.color = ( 1, 1, 1 );
		}
	}
	
	
}
hardpointItemWaiter()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	
	lastWeapon = self getCurrentWeapon();
	self giveOwnedHardpointItem();
	
	
	for ( ;; )
	{
		self waittill( "weapon_change" );
		
		currentWeapon = self getCurrentWeapon();
		switch( currentWeapon )
		{
 			case "zombie_artillery":
 			case "zombie_airstrike":
 			case "zombie_napalm":
 			case "zombie_dogs":
 			case "zombie_rcbomb":
 			case "zombie_cloak":
 			case "zombie_endurance":
 			case "zombie_helicopter":
 			case "zombie_turret":
 			case "zombie_portal":
				if ( self triggerHardpoint( currentWeapon ) )
				{	
					logString( "hardpoint: " + currentWeapon );
					
					self.pers["hardPointItem"] = undefined;
				}
				
				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
				break;
			case "none":
				break;	
			default:
				lastWeapon = self getCurrentWeapon();
				break;
		}
	}
}
isAbilityActive()
{
	keys = GetArrayKeys( level._abilities );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( level._abilities[ keys[i] ].in_use )
			return true;
	}
	return false;
}
triggerHardPoint( hardpointType )
{
	if ( isAbilityActive()  )
	{
		self display_message( level.hardpointHints[hardpointType+"_not_available"] );
		return false;
	}
	result = false;
	if ( hardpointType == "zombie_artillery" )
 	{
 		if ( IsDefined( level.airSupportInProgress ) )
 		{
 			self display_message( level.hardpointHints[hardpointType+"_not_available"] );
 			return false;
 		}
 			
 		result = self targetLocation( maps\_zombiemode_ability_artillery::useArtillery, "target_arrow_yellow", "target_arrow_red", "target_arrow_green" );
 	}
	else if ( hardpointType == "zombie_airstrike" )
	{
		if ( IsDefined( level.airSupportInProgress ) )
		{
			self display_message( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
			
		result = self targetLocation( maps\_zombiemode_ability_airstrike::call_airstrike, "target_arrow_yellow", "target_arrow_red", "target_arrow_green" );
	}
 	else if ( hardpointType == "zombie_napalm" )
 	{
 		if ( IsDefined( level.airSupportInProgress ) )
 		{
 			self display_message( level.hardpointHints[hardpointType+"_not_available"] );
 			return false;
 		}
 		result = self targetLocation( maps\_zombiemode_ability_napalm::useNapalm, "target_arrow_yellow", "target_arrow_red", "target_arrow_green" );
 	}
 	else if ( hardpointType == "zombie_dogs" )
 	{
 		if ( IsDefined( level.dogs ) )
 		{
 			self display_message( level.hardpointHints[hardpointType+"_not_available"] );
 			return false;
 		}
 		
 		if ( !IsDefined( level.dogs_enabled ) || (level.dogs_enabled==false) )
 		{
 			self display_message( level.hardpointHints[hardpointType+"_not_available"] );
 			return false;
 		}
 		
 		
 		
 		
 			
 			
 			
 			
 
 		
		ownerDeathCount = 0;
 		self thread maps\_zombiemode_ability_dogs::dog_manager_spawn_dogs( "allies", "axis", ownerDeathCount );
 
 		
		result = true;
 	}
	else if( hardpointType == "zombie_helicopter" )
 	{			
 		self thread maps\_zombiemode_ability_helicopter::useKillstreakHelicopter( hardpointType );
		result = true;
 	}
 	else if( hardpointType == "zombie_turret" )
 	{			
 		result = self targetLocation( maps\_zombiemode_ability_turret::useTurret, "target_arrow_yellow", "target_arrow_red", "target_arrow_green" );
 	}
 	else if( hardpointType == "zombie_portal" )
 	{			
  		if ( IsDefined( level.portalSupportInProgress ) )
 		{
 			self display_message( level.hardpointHints[hardpointType+"_not_available"] );
 			return false;
 		}
 		result = self targetLocation( maps\_zombiemode_ability_portal::usePortal, "target_arrow_yellow", "target_arrow_red", "target_arrow_green" );
 	}
 	else if( hardpointType == "zombie_rcbomb" )
 	{			
 		result = self targetLocation( maps\_zombiemode_ability_rcbomb::useRcCar, "target_arrow_yellow", "target_arrow_red", "target_arrow_green" );
 	}
 	else if( hardpointType == "zombie_cloak" )
 	{			
 		self thread maps\_zombiemode_ability_cloak::useCloak();
 		result = true;
		
 	}
 	else if( hardpointType == "zombie_endurance" )
 	{			
 		thread maps\_zombiemode_ability_endurance::useEndurance();
 		result = true;
		
 	}
	if ( !IsDefined(result) || !result )
		return false;
	self notify( "hardpoint_used", hardpointType );
	display_message( level.hardpointInforms[hardpointType+"_used"] );
	
	
	
	
		self.curr_ability = undefined;
		self setActionSlot( 1, "" );
	
	self update_player_ability_status();
	return true;
}
addToKillstreakCount( weapon )
{
	if ( !IsDefined( self.streakKillCount ) )
		self.streakKillCount = 0;
}
fireWatch( useFunc, validTargetColor, invalidTargetColor, confirmTargetColor )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "weapon_change" );
	self thread fireWatchCancel();
	self thread drawAimpoint( validTargetColor, invalidTargetColor );
	while (1)
	{
		
		if( self attackbuttonPressed() )
		{
			flag_set( "ability_firing" );
			thread drawConfirmPoint( confirmTargetColor );
			thread [[ useFunc ]] ( self.targetpoint.origin );		
			return true;
		}
		wait( 0.1 );
	}
}
fireWatchCancel()
{		
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "ability_firing" );
	self waittill( "weapon_change" );
	if ( !flag( "ability_firing" ) )
	{
		self.targetpoint delete();
	}
}
drawAimpoint( validTargetColor, invalidTargetColor )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "weapon_change" );
	self endon ( "end_confirm" );
	
	while ( isdefined(self.targetpoint) )
	{
		if ( self.ability_ok )
			playfxontag( level._effect[validTargetColor], self.targetpoint, "tag_origin" );	
		else
			playfxontag( level._effect[invalidTargetColor], self.targetpoint, "tag_origin" );
		wait 0.1;
	}
}
drawConfirmPoint( confirmTargetColor )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_confirm" );
	flag_clear("end_target_confirm" );
	
	while ( !flag( "end_target_confirm" ) )
	{
		playfxontag( level._effect[ confirmTargetColor ], self.targetpoint, "tag_origin" );
		wait 0.1;
	}
	if( isDefined( self.targetpoint ) )
	{
		self notify ( "end_confirm" );
		self.targetpoint delete();
	}
}
targetLocation( useFunc, validTargetColor, invalidTargetColor, confirmTargetColor )
{
	self endon ("death");
	self endon ("disconnect");
	self endon ("weapon_change");
	
	
	if ( !IsDefined( self.targetpoint ) )
	{
		self.targetpoint = spawn( "script_model", self.origin );
		self.targetpoint.angles = (270,0,0);
		self.targetpoint setmodel( "tag_origin" );
	}
	self.ability_ok = false;
	flag_clear( "ability_firing" );
	self thread fireWatch( useFunc, validTargetColor, invalidTargetColor, confirmTargetColor );
	for (;;)
	{
		if ( flag( "ability_firing" ) )
		{
			return true;
		}
		
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();
		
		trace = bullettrace( eye, eye + vector_multiply( direction_vec , level.abilityTraceLength ), 0, undefined );
		trace2 = bullettrace( trace["position"]+(0,0,2),  trace["position"] - (0,0,100000), 0, undefined );
		
		tracepos = trace2["position"];
		if (tracepos[2] < -650)
		{
			tracepos = (tracepos[0], tracepos[1], -650);
			trace2["position"] = tracepos;
		}
		if( isDefined( self.targetpoint ) )
		{
			self.targetpoint.origin = trace2["position"];
			self.targetpoint rotateTo( vectortoangles( trace2["normal"] ), 0.15 );
		}
		
		if ( self.usingturret )
			self.ability_ok = false;	
		else
			self.ability_ok = true;
		wait (0.05);
	}
}
get_ability_hint( ability_name )
{
	return level._abilities[ ability_name ].hint;
}
get_ability_hint_round( ability_name )
{
	return level._abilities[ ability_name ].hint_round;
}
get_ability_type( ability_name )
{
	return level._abilities[ ability_name ].type;
}
get_ability_cost( ability_name )
{
	return level._abilities[ ability_name ].cost;
}
get_ability_round( ability_name )
{
	return level._abilities[ ability_name ].round_available;
}
init_ability_wallbuys()
{
	while (!isdefined (level.flag) || !isdefined(level.flag[ "all_players_connected" ]))
	{
		wait 0.05;
		continue;
	}
	flag_wait( "all_players_connected" );
	ability_spawns = [];
	ability_spawns = GetEntArray( "ability", "targetname" ); 
	
	if( !IsDefined(level._abilities) )
	{
		return undefined;
	}
	for( i = 0; i < ability_spawns.size; i++ )
	{
		ability_name = "zombie_" + ability_spawns[i].script_noteworthy;
		type = get_ability_type( ability_name ); 
		cost = get_ability_cost( ability_name );
		hint_round = get_ability_hint_round( ability_name );
		round = get_ability_round( ability_name );
	
		ability_spawns[i] SetHintString( hint_round, round ); 
		ability_spawns[i] setCursorHint( "HINT_NOICON" ); 
		ability_spawns[i] UseTriggerRequireLookAt();
		ability_spawns[i] thread ability_hint_think( ability_name );
		players = getplayers();
		for( j = 0; j < players.size; j++ )
		{
			players[j].first_use[ability_name] = false;
		}
	}
}
can_buy_ability( ability_name )
{
	if( self in_revive_trigger() )
	{
		return false;
	}
	else if( isDefined( self.curr_ability ) && ability_name == self.curr_ability )
	{
		display_message( &"ZOMBIE_HAS_ABILITY" );
		return false;
	}
	
	return true;
}
ability_hint_think( ability_name )
{
	round = get_ability_round( ability_name );
	for ( ;; )
	{
		level waittill( "between_round_over" );
		if ( level.round_number >= round )
		{
			break;
		}
	}
	self thread ability_spawn_think();
	hint_string = get_ability_hint( ability_name ); 
	cost = get_ability_cost( ability_name );
	self SetHintString( hint_string, cost );
}
ability_spawn_think()
{
	FIRST_COST = 500;
	ability_name = "zombie_" + self.script_noteworthy;
	cost = get_ability_cost( ability_name );
	round = get_ability_round( ability_name );
	for( ;; )
	{
		self waittill( "trigger", player ); 		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
		if( !player can_buy_ability( ability_name ) )
		{
			wait( 0.1 );
			continue;
		}
		
		
		
		
		
		
		if ( !player.first_use[ ability_name ] && player.score >= FIRST_COST )
		{
			player.first_use[ ability_name ] = true;
			player maps\_zombiemode_score::minus_to_player_score( FIRST_COST );
			player giveAbility( ability_name );
		}
		else if( player.score >= cost )
		{
			player maps\_zombiemode_score::minus_to_player_score( cost ); 
			player giveAbility( ability_name );
		}
		else
		{
			play_sound_on_ent( "no_purchase" );
			player maps\_zombiemode_audio::create_and_play_dialog( "general", "no_money", undefined, 0 );
		}
	}
} 
  
