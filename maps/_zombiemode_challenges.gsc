#include maps\_utility;
init()
{
	
	if ( !mayGenerateAfterActionReport() )
		return;
	
	level.xpZmScale = GetDvarInt( #"scr_xpzmscale" );
	
	level.challengeTableNames = [];
	level.numChallengeTiersZM = 1;
	table_id = 1;
	table_name = tableLookup( "mp/challengeTable_zm.csv", 0, table_id, 4 );
	while ( isDefined( table_name ) && table_name != "" )
	{
		level.challengeTableNames[level.challengeTableNames.size] = table_name;
		table_id++;
		table_name = tableLookup( "mp/challengeTable_zm.csv", 0, table_id, 4 );	
	}
	buildChallengeInfo();
	precacheTitles();
	level thread onPlayerConnect();
	
	level.missionCallbacks = [];
	level.update_match_summary = ::updateMatchSummary;
	precacheString(&"CHALLENGE_COOP_COMPLETED");
	precacheString(&"CHALLENGE_MULTIPLE_COOP_COMPLETED");
	precacheString(&"CHALLENGE_MULTIPLE_COOP_COMPLETED_DETAILS");	
	registerMissionCallback( "zombieKilled", ::ch_zm_kills );	
	registerMissionCallback( "zm_board_repair", ::ch_zm_board_repair );	
	registerMissionCallback( "playerDied", ::ch_dies );
	registerMissionCallback( "playerGib", ::ch_gib );
	registerMissionCallback( "zm_revive", ::ch_zm_revive );
	registerMissionCallback( "zm_ability", ::ch_zm_ability );
}
precacheTitles()
{
	idx = 1;
	while( 1 )
	{
		display_string = tableLookupIString( "mp/zm_titles.csv", 0, idx, 2 );
		if( !IsDefined( display_string ) || display_string == &"" )
			return;
		icon = tableLookup( "mp/zm_titles.csv", 0, idx, 3 );
		precacheString( display_string );
		precacheShader( icon+"_face" );
		precacheShader( icon+"_full" );
		precacheShader( icon+"_ribbon" );
		idx++;
	}
}
mayGenerateAfterActionReport()
{	
	
	return !isCoopEPD();
}
mayProcessChallenges()
{
	
	if ( isCoopEPD() )
		return false;
	return true;
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );	
		
		player setClientDvars( 	"psn", player.playername,
								"psx", "0",
								"pss", "0",
								"psc", "0",
								"psk", "0",
								"psd", "0",
								"psr", "0",
								"psh", "0", 
								"psa", "0",								
								"ui_lobbypopup", "summary");
		player updateChallenges();
		player thread ch_zm_rounds();
		player thread ch_zm_weapon_fire();
		player thread ch_zm_perk_time();
	}
}
onSaveRestored()
{
	if ( !mayProcessChallenges() )
		return;
	players = get_players();
	for( i = 0; i < players.size; i++)
	{
		players[i].rankxpZm = players[i] statGet( "rankxpzm" );
		rankZmId = players[i] maps\_zombiemode_rank::getRankForXp( players[i] maps\_zombiemode_rank::getRankXp() );
		players[i].rankZm = rankZmId;
	
		prestigeZm = players[i] maps\_zombiemode_rank::getPrestigeLevel();
		players[i] setRank( rankZmId, prestigeZm );
		players[i].prestigeZm = prestigeZm;
		players[i].team = "allies";
		
		players[i] updateChallenges();
	}
}
createCacheSummary()
{
	self.cached_summary_xpZm = 0;
	self.cached_score = 0;
	self.cached_summary_challenge = 0;
	self.cached_kills =  0;
	self.cached_downs = 0;
	self.cached_assists = 0;
	self.cached_headshots = 0;
	self.cached_revives = 0;
	
	self.summary_cache_created = true;
}
buildSummaryArray()
{
	summaryArray = [];
	if(self.cached_summary_xpZm != self.summary_xpZm)
	{
		summaryArray[summaryArray.size] = "psx";
		summaryArray[summaryArray.size] = self.summary_xpZm;
		self.cached_summary_xpZm = self.summary_xpZm;
	}	
	if(self.cached_score != self.score)
	{
		summaryArray[summaryArray.size] = "pss";
		summaryArray[summaryArray.size] = self.score;
		self.cached_score = self.score;
	}
	
	if(self.cached_summary_challenge != self.summary_challenge)
	{
		summaryArray[summaryArray.size] = "psc";
		summaryArray[summaryArray.size] = self.summary_challenge;
		self.cached_summary_challenge = self.summary_challenge;
	}
	
	if(self.cached_downs != self.downs)
	{
		summaryArray[summaryArray.size] = "psd";
		summaryArray[summaryArray.size] = self.downs;
		self.cached_downs = self.downs;
	}
	if(self.cached_headshots != self.headshots)
	{
		summaryArray[summaryArray.size] = "psh";
		summaryArray[summaryArray.size] = self.headshots;
		self.cached_headshots = self.headshots;
	}
	if(self.cached_kills != self.kills - self.headshots)
	{
		summaryArray[summaryArray.size] = "psk";
		summaryArray[summaryArray.size] = self.kills - self.headshots;
		self.cached_kills = self.kills - self.headshots;
	}
	
	if(self.cached_revives != self.revives)
	{
		summaryArray[summaryArray.size] = "psr";
		summaryArray[summaryArray.size] = self.revives;
		self.cached_revives = self.revives;
	}
	
	if(self.cached_assists != self.assists)
	{
		summaryArray[summaryArray.size] = "psa";
		summaryArray[summaryArray.size] = self.assists;
		self.cached_assists = self.assists;
	}	
		
	return summaryArray;
}
updateMatchSummary( callback )
{
	forceUpdate = ( IsDefined(callback) && (callback == "levelEnd" || callback == "checkpointLoaded") );
	if( OkToSpawn() || forceUpdate )
	{
		if( !isdefined(self.summary_cache_created) || callback == "checkpointLoaded" )
		{
			self createCacheSummary();
		}
	
		summary = self buildSummaryArray();
		
		if(summary.size > 0)
		{
			switch(summary.size)	
			{
				case 2:
					self setClientDvars(summary[0], summary[1]);
					break;
				case 4:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3]);
					break;
				case 6:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3], summary[4], summary[5]);
					break;
				case 8:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3], summary[4], summary[5], summary[6], summary[7]);
					break;
				case 10:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3], summary[4], summary[5], summary[6], summary[7], summary[8], summary[9]);
					break;
				case 12:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3], summary[4], summary[5], summary[6], summary[7], summary[8], summary[9], summary[10], summary[11]);
					break;
				case 14:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3], summary[4], summary[5], summary[6], summary[7], summary[8], summary[9], summary[10], summary[11], summary[12], summary[13]);
					break;
				case 16:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3], summary[4], summary[5], summary[6], summary[7], summary[8], summary[9], summary[10], summary[11], summary[12], summary[13], summary[14], summary[15]);
					break;
				case 18:
					self setClientDvars(summary[0], summary[1], summary[2], summary[3], summary[4], summary[5], summary[6], summary[7], summary[8], summary[9], summary[10], summary[11], summary[12], summary[13], summary[14], summary[15], summary[16], summary[17]);
					break;
				default:
					assertex("Unexpected number of elements in summary array.");
			}
			
			println("*** Summary sent " + (summary.size / 2) + " elements.");
		}
		
	}
}
registerMissionCallback(callback, func)
{
	if (!isdefined(level.missionCallbacks[callback]))
		level.missionCallbacks[callback] = [];
	level.missionCallbacks[callback][level.missionCallbacks[callback].size] = func;
}
getChallengeStatus( name )
{
	if ( isDefined( self.challengeDataZM[name] ) )
		return self.challengeDataZM[name];
	else
		return 0;
}
getChallengeLevels( baseName )
{
	if ( isDefined( level.challengeInfoZM[baseName] ) )
		return level.challengeInfoZM[baseName]["levels"];
		
	assertex( isDefined( level.challengeInfoZM[baseName + "1" ] ), "Challenge name " + baseName + " not found!" );
	
	return level.challengeInfoZM[baseName + "1"]["levels"];
}
challengeNotify( challengeName )
{
	notifyData = spawnStruct();
	notifyData.titleText = &"CH_ZM_CHALLENGE_COMPLETED";
	notifyData.notifyText = challengeName;
	notifyData.sound = "evt_challenge_complete";
	notifyData.glowColor = ( 0.78, 0.06, 0.1 );
	
	self maps\_hud_message::notifyMessage( notifyData );
}
updateChallenges()
{
	self.challengeDataZM = [];
	for ( i = 0; i < level.challengeTableNames.size; i++ )
	{
		tableName = level.challengeTableNames[i];
		idx = 1;
		
		for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
		{
			stat_name = tableLookup( tableName, 0, idx, 16 ); 
			if( isdefined( stat_name ) && stat_name != "" )
			{
				statVal = self getDStat( "challengeStats", stat_name, "challengeState" );
				if( !statVal )
				{
					statVal = 1;
					self setDStat( "challengeStats", stat_name, "challengeState", 1 );
				}
				
				refString = tableLookup( tableName, 0, idx, 7 );
				self.challengeDataZM[refString] = statVal;
			}
		}
	}
}
buildChallengeInfo()
{
	level.challengeInfoZM = [];
	for ( i = 0; i < level.challengeTableNames.size; i++ )
	{
		tableName = level.challengeTableNames[i];
		baseRef = "";
		
		for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
		{
			refString = tableLookup( tableName, 0, idx, 7 );
			level.challengeInfoZM[refString] = [];
			level.challengeInfoZM[refString]["tier"] = i + 1;
			level.challengeInfoZM[refString]["statname"] = tableLookup( tableName, 0, idx, 16 );
			level.challengeInfoZM[refString]["maxval"] = int( tableLookup( tableName, 0, idx, 4 ) );
			level.challengeInfoZM[refString]["minval"] = int( tableLookup( tableName, 0, idx, 5 ) );
			level.challengeInfoZM[refString]["name"] = tableLookupIString( tableName, 0, idx, 8 );
			level.challengeInfoZM[refString]["desc"] = tableLookupIString( tableName, 0, idx, 9 );
			level.challengeInfoZM[refString]["reward"] = int( tableLookup( tableName, 0, idx, 10 ) );
			level.challengeInfoZM[refString]["title_unlock"] = tableLookup( tableName, 0, idx, 11 );
			precacheString( level.challengeInfoZM[refString]["name"] );
			
			stateid = string( tableLookup( tableName, 0, idx, 2 ) );
			if ( !isDefined( stateid ) || stateid == "" )
			{
				level.challengeInfoZM[baseRef]["levels"]++;
				level.challengeInfoZM[refString]["level"] = level.challengeInfoZM[baseRef]["levels"];
			}
			else
			{
				level.challengeInfoZM[refString]["levels"] = 1;
				level.challengeInfoZM[refString]["level"] = 1;
				baseRef = refString;
			}
		}
	}
}
processChallenge( baseName, progressInc, levelEnd, singleGameProgress )
{
	if ( !mayProcessChallenges() )
		return 0; 
		
	if(	!isDefined( levelEnd ) )
	{
		levelEnd = false;
	}
		
	numLevels = getChallengeLevels( baseName );
	
	if ( numLevels > 1 )
		missionStatus = self getChallengeStatus( (baseName + "1") );
	else
		missionStatus = self getChallengeStatus( baseName );
	if ( !isDefined( progressInc ) )
		progressInc = 1;
	
	
	
	if ( !missionStatus || missionStatus == 3 )
		return 0; 
		
	assertex( missionStatus <= numLevels, "Mini challenge levels higher than max: " + missionStatus + " vs. " + numLevels );
	
	if ( numLevels > 1 )
		refString = baseName + missionStatus;
	else
		refString = baseName;
	
	progress = self getDStat( "challengeStats", level.challengeInfoZM[refString]["statname"], "challengeProgress" );
	if ( isDefined( singleGameProgress ) && progress >= singleGameProgress )
		return 0; 
	progress += progressInc;
	
	self setDStat( "challengeStats", level.challengeInfoZM[refString]["statname"], "challengeProgress", progress );
	if ( progress >= level.challengeInfoZM[refString]["maxval"] )
	{
		if( false == levelEnd )
		{
			self thread challengeNotify( level.challengeInfoZM[refString]["name"] );
			self processUnlocks( refString );
		}
		if ( missionStatus == numLevels )
			missionStatus = 3;
		else
			missionStatus += 1;
		if ( numLevels > 1 )
			self.challengeDataZM[baseName + "1"] = missionStatus;
		else
			self.challengeDataZM[baseName] = missionStatus;
		
		self setDStat( "challengeStats", level.challengeInfoZM[refString]["statname"], "challengeProgress", level.challengeInfoZM[refString]["maxval"] );
		self setDStat( "challengeStats", level.challengeInfoZM[refString]["statname"], "challengeState", missionStatus );
		
		self maps\_zombiemode_rank::giveRankXp( "challenge", level.challengeInfoZM[refString]["reward"], levelEnd );
		
		return 1; 
	}
	
	return 0; 
}
processUnlocks( refString )
{
	title_unlock = level.challengeInfoZM[refString]["title_unlock"];
	unlocked = 1;
	if( IsDefined( title_unlock ) && title_unlock != "" )
	{
		statIdx = int( tableLookup( "mp/zm_titles.csv", 1, title_unlock, 0 ) );
		stat_state = self getDStat( "ZombieTitles", statIdx );
		if( stat_state == unlocked )
			return;
		icon = tableLookup( "mp/zm_titles.csv", 1, title_unlock, 3 );
		notifyData = spawnStruct();
		notifyData.titleText = &"ZM_TITLE_NEWTITLE";
		notifyData.iconName = icon+"_face";
		
		
		
		notifyData.notifyText = tableLookupIString( "mp/zm_titles.csv", 1, title_unlock, 2 );
		notifyData.textIsString = true;
		self thread maps\_hud_message::notifyMessage( notifyData );
		self setDStat( "ZombieTitles", statIdx, unlocked );
	}
}
ch_zm_kills( victim )
{
	if ( !isDefined( victim.attacker ) || !isPlayer( victim.attacker ) || victim.team == "allies" )
		return;
	
	player = victim.attacker;
	player processChallenge( "ch_zm_p_executioner_" );
	if( player HasPerk( "specialty_bulletdamage" ) )
	{
		player processChallenge( "ch_zm_p_stoppingpower_" );
	}
	weap_class = weaponClass( victim.damageWeapon );
	if( isDefined( level.zombie_weapons ) )
	{
		keys = GetArrayKeys( level.zombie_weapons );
		for( i = 0; i < keys.size; i++ )
		{
			weapon = level.zombie_weapons[ keys[i] ];
			if( isDefined( weapon.challenge_ref ) && victim.damageWeapon == weapon.weapon_name )
			{
				player processChallenge( weapon.challenge_ref );
			}
			else if( isDefined( weapon.upgrade_challenge_ref ) && isDefined( weapon.upgrade_name ) 
				&& victim.damageWeapon == weapon.upgrade_name )
			{
				player processChallenge( weapon.upgrade_challenge_ref );
			}
		}
	}
	
	if( victim animscripts\utility::damageLocationIsAny( "head", "helmet", "neck" ) )
	{
		if ( !isDefined( player.ch_zm_s_headshotkillCount ) )
		{
			player.ch_zm_s_headshotkillCount = 0;
		}
		player.ch_zm_s_headshotkillCount++;
		player processChallenge( "ch_zm_s_headshotkill_", 1, false, player.ch_zm_s_headshotkillCount );
	}
}
ch_zm_board_repair( player )
{
	player processChallenge( "ch_zm_p_bricklayer_" );
}
ch_zm_rounds()
{
	self endon( "disconnect" );
	
	while( 1 )
	{
		level waittill( "end_of_round" );
		self processChallenge( "ch_zm_p_warmonger_" );
	};
}
ch_zm_weapon_fire()
{
	self endon( "disconnect" );
	while( 1 )
	{
		self waittill( "weapon_fired" );
		
		if( self HasPerk( "specialty_extraammo" ) )
		{
			self processChallenge( "ch_zm_p_bandoleer_" );
		}
	};
}
ch_zm_perk_time()
{
	self endon( "disconnect" );
	if( !isDefined( self.fastreload_counter ) )
	{
		self.fastreload_counter = 0;
	}
	if( !isDefined( self.armorvest_counter ) )
	{
		self.armorvest_counter = 0;
	}
	while( 1 )
	{
		if( self HasPerk( "specialty_fastreload" ) )
		{
			self.fastreload_counter++;
			if( self.fastreload_counter >= 6 )
			{
				self.fastreload_counter -= 6;
				self processChallenge( "ch_zm_p_speedcola_" );
			}
		}
		if( self HasPerk( "specialty_armorvest" ) )
		{
			self.armorvest_counter++;
			if( self.armorvest_counter >= 6 )
			{
				self.armorvest_counter -= 6;
				self processChallenge( "ch_zm_p_juggernaut_" );
			}
		}
		wait( 10 );
	};
}
ch_zm_revive( player )
{
	
	player processChallenge( "ch_zm_p_quickrevive_" );
}
ch_zm_ability( data )
{
	data.player processChallenge( data.ability );
}
doAbilityCallback( player, ability )
{
	data = spawnstruct();
	data.player		= player;
	data.ability	= ability;
	doMissionCallback( "zm_ability", data );
}
ch_reset_alive_challenges( player )	
{
	
}
ch_dies( player )	
{
	ch_reset_alive_challenges( player );
	if ( !isdefined( level.playerDeaths ) )
	{
		level.playerDeaths = 0;
	}
	level.playerDeaths++;
}
ch_gib( victim )
{
	
	if ( !isDefined( victim.attacker ) || !isPlayer( victim.attacker ) )
		return;
	
	player = victim.attacker;
	
}
doMissionCallback( callback, data )
{
	if ( !mayProcessChallenges() )
	{
		return;
	}
	if ( GetDvarInt( #"disable_challenges" ) > 0 )
		return;
	if ( !isDefined( level.missionCallbacks[callback] ) )
		return;
	if ( isDefined( data ) ) 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]();
	}
	
	
	
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] updateMatchSummary( callback );
	}
}
statGet( dataName )
{
	if ( !mayProcessChallenges() )
		return 0;
	
	return ( self getdstat( "PlayerStatsList", dataName ) );
}
statSet( dataName, value )
{
	if ( !mayProcessChallenges() )
		return;
	
	self setdstat( "PlayerStatsList", dataName, value );
}  
