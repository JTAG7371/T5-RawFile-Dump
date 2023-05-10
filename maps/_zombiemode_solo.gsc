#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include animscripts\zombie_Utility;
init()
{
	level.restart_round = 0;
	players = getplayers();
	if ( players.size == 1 )
	{
		players[0].lives = level.zombie_vars["starting_lives"];
		players[0] solo_create_lives_hud();
		players[0] solo_update_lives_hud();
		players[0] thread solo_award_life();
	}
}
solo_has_lives()
{
	players = getplayers();
	if ( players.size == 1 )
	{
		if ( players[0].lives > 0 )
		{
			return 1;
		}
	}
	return 0;
}
solo_restart_round()
{
	notifyData = spawnStruct();
	notifyData.titleText = &"ZOMBIE_SOLO_LIFE_LOST";
	
	self thread maps\_hud_message::notifyMessage( notifyData );
	level.restart_round = level.round_number;
	level.zombie_total = 0;
	maps\_zombiemode::ai_calculate_health( level.round_number );
	level.round_number = level.restart_round - 1 ;
	level notify( "restart_round" );
	wait( 1 );
	zombies = GetAiSpeciesArray( "axis", "all" );
	
	level.total_zombies_killed -= zombies.size;
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( zombies[i].animname == "ape_zombie" )
		{
			
			zombies[i].restart = 1;
		}
		zombies[i] dodamage( zombies[i].health + 100, zombies[i].origin );
	}
}
solo_respawn_life()
{
	self notify( "spawned_spectator" ); 
	if( !IsDefined( level.custom_spawnPlayer ) )
	{
		
		level.custom_spawnPlayer = maps\_zombiemode::spectator_respawn;
	}
	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
		self notify( "stop_revive_trigger" );
	}
	self [[level.spawnPlayer]]();
	if (isDefined(level.script) && level.round_number > 6 && self.score < 1500)
	{
		self.old_score = self.score;
		self.score = 1500;
		self maps\_zombiemode_score::set_player_score_hud();
	}
	self.lives--;
	self solo_update_lives_hud();
	self waittill( "CAC_loadout" );
	self thread maps\_zombiemode_deathcard::deathcard_give_solo();
}
solo_create_lives_hud()
{
	if ( !IsDefined( self.hud_lives ) )
	{
		hud = create_simple_hud( self );
		hud.alignX = "center"; 
		hud.alignY = "middle";
		hud.horzAlign = "center"; 
		hud.vertAlign = "middle";
		hud.color = ( 1, 1, 1 );
		hud.x = 300;
		hud.y = 100;
		hud.alpha = 1;
		hud SetShader( "zom_icon_player_life", 32, 32 );
		self.hud_lives = hud;
	}
	if ( !IsDefined( self.hud_lives_count ) )
	{
		hud = newclientHudElem( self );
		hud.alignX = "center"; 
		hud.alignY = "middle";
		hud.horzAlign = "center"; 
		hud.vertAlign = "middle";
		hud.color = ( 1, 1, 1 );
		hud.x = 324;
		hud.y = 100;
		hud.foreground = true;
		hud.font = "default";
		hud.fontScale = 8;
		hud.alpha = 1;
		hud settext( "25" );
		self.hud_lives_count = hud;
	}
}
solo_destroy_lives_hud()
{
	if ( IsDefined( self.hud_lives ) )
	{
		self.hud_lives Destroy();
		self.hud_lives = undefined;
	}
	if ( IsDefined( self.hud_lives_count ) )
	{
		self.hud_lives_count Destroy();
		self.hud_lives_count = undefined;
	}
}
solo_update_lives_hud()
{
	self.hud_lives_count SetText( "x " + self.lives );
}
solo_should_restart()
{
	if ( solo_has_lives() )
	{
		solo_restart_round();
		self solo_respawn_life();
		return true;
	}
	return false;
}
solo_award_life()
{
	next_life_round = 5;
	while ( 1 )
	{
		level waittill( "between_round_over" );
		if ( level.round_number == next_life_round )
		{
			self.lives++;
			self solo_update_lives_hud();
			notifyData = spawnStruct();
			notifyData.titleText = &"ZOMBIE_EXTRA_LIFE";
			notifyData.sound = "evt_extra_life";
			self thread maps\_hud_message::notifyMessage( notifyData );
			next_life_round += 5;
		}
		wait_network_frame();
	}
} 
  
