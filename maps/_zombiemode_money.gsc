#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include animscripts\zombie_Utility;
init()
{
	thread check_players();
	level.money_dump_delay = 500;
	level.money_dump_size = 500;
}
money_precache()
{
	PrecacheModel( "zombie_z_money_icon" );
}
check_players()
{
	flag_wait( "all_players_connected" );
	players = getplayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players.size > 1 )
		{
			players[i] thread money_dump();
		}
	}
}
player_can_dump()
{
	if ( self.score < level.money_dump_size )
	{
		return false;
	}
	if ( self.sessionstate == "spectator" )
	{
		return false;
	}
	if ( self maps\_laststand::player_is_in_laststand() )
	{
		return false;
	}
	if ( isdefined( self.lander ) && self.lander == true )
	{
		return false;
	}
	return true;
}
money_dump()
{
	self endon( "disconnect" );
	self.moneyDump = undefined;
	while ( 1 )
	{
		if ( self player_can_dump() )
		{
			while ( self actionslottwobuttonpressed() )
			{
				
				if ( !isDefined( self.moneyDump ) )
				{
					self.moneyDump = thread money_spawn( self );
				}
				if ( self.score >= level.money_dump_size )
				{
					self.old_score -= level.money_dump_size;
					self.score -= level.money_dump_size;
					self.moneyDump.score += level.money_dump_size;
				}
				wait( 0.05 );
			}
		}
		wait( 0.05 );
	}
}
money_spawn( player )
{
	money = spawn( "script_model", player.origin + ( 0, 0, 40 ) );
	money.angles = player.angles;
	money SetModel( "zombie_z_money_icon" );
	money.score = 0;
	money.player = player;
	money thread money_wobble();
	money thread money_grab();
	return money;
}
money_grab()
{
	while ( isdefined( self ) )
	{
		players = get_players();
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i].is_zombie )
			{
				continue;
			}
			if ( players[i] == self.player )
			{
				continue;
			}
			dist = distance( players[i].origin, self.origin );
			if ( dist < 64 )
			{
				playfx( level._effect["powerup_grabbed"], self.origin );
				playfx( level._effect["powerup_grabbed_wave"], self.origin );
				playsoundatposition("zmb_powerup_grabbed_3p", self.origin);
				players[i].old_score += self.score;
				players[i].score += self.score;
				wait( 0.1 );
				playsoundatposition("zmb_cha_ching", self.origin);
				self stoploopsound();
				self.player.moneyDump = undefined;
				self delete();
				self notify( "money_grabbed" );
				break;
			}
		}
		wait_network_frame();
	}
}
money_wobble()
{
	self endon ("money_grabbed");
	if (isdefined(self))
	{
		playfxontag (level._effect["powerup_on"], self, "tag_origin");
		self playsound("zmb_spawn_powerup");
		self playloopsound("zmb_spawn_powerup_loop");
	}
	while (isdefined(self))
	{
		self rotateyaw( 360, 3, 3, 0 );
		self waittill("rotatedone");
		
	}
}  
