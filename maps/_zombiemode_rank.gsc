#include common_scripts\utility;
init()
{
	level.scoreInfo = [];
	level.rankTableZm = [];
	precacheShader("white");
	precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
	precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
	precacheString( &"RANK_PROMOTED" );
	precacheString( &"MP_PLUS" );
	precacheString( &"RANK_ROMANI" );
	precacheString( &"RANK_ROMANII" );
	precacheString( &"RANK_ROMANIII" );
	zombie_kill = 10;
	quad_kill	= 50;
	ape_kill	= 100;
	dog_kill	= 25;
	registerScoreInfo( "zombiekill", zombie_kill );
	registerScoreInfo( "quadkill", quad_kill );
	registerScoreInfo( "apekill", ape_kill );
	registerScoreInfo( "dogkill", dog_kill );
	registerScoreInfo( "zombiekill_assist", zombie_kill/4 );
	registerScoreInfo( "quadkill_assist", quad_kill/4 );
	registerScoreInfo( "apekill_assist", ape_kill/4 );
	registerScoreInfo( "dogkill_assist", dog_kill/4 );
	registerScoreInfo( "portal_travel", 20 );
	
	registerScoreInfo( "powercell", 20 );
	registerScoreInfo( "revive", 20 );
	level.maxRankZm = int(tableLookup( "mp/rankTable_zm.csv", 0, "maxrank", 1 ));
	level.maxPrestigeZm = int(tableLookup( "mp/rankIconTable_zm.csv", 0, "maxprestige", 1 ));
	
	pId = 0;
	rId = 0;
	for ( pId = 0; pId <= level.maxPrestigeZm; pId++ )
	{
		
		for ( rId = 0; rId <= level.maxRankZm; rId++ )
			precacheShader( tableLookup( "mp/rankIconTable_zm.csv", 0, rId, pId+1 ) );
	}
	rankId = 0;
	rankName = tableLookup( "mp/rankTable_zm.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) && rankName != "" );
		
	while ( isDefined( rankName ) && rankName != "" )
	{
		level.rankTableZm[rankId][1] = tableLookup( "mp/rankTable_zm.csv", 0, rankId, 1 );
		level.rankTableZm[rankId][2] = tableLookup( "mp/rankTable_zm.csv", 0, rankId, 2 );
		level.rankTableZm[rankId][3] = tableLookup( "mp/rankTable_zm.csv", 0, rankId, 3 );
		level.rankTableZm[rankId][7] = tableLookup( "mp/rankTable_zm.csv", 0, rankId, 7 );
		precacheString( tableLookupIString( "mp/rankTable_zm.csv", 0, rankId, 16 ) );
		rankId++;
		rankName = tableLookup( "mp/rankTable_zm.csv", 0, rankId, 1 );		
	}
	
	level thread onPlayerConnect();
}
registerScoreInfo( type, value )
{
	level.scoreInfo[type]["value"] = value;
}
getScoreInfoValue( type )
{
	return ( level.scoreInfo[type]["value"] );
}
getRankInfoMinXP( rankId )
{
	return int(level.rankTableZm[rankId][2]);
}
getRankInfoXPAmt( rankId )
{
	return int(level.rankTableZm[rankId][3]);
}
getRankInfoMaxXp( rankId )
{
	return int(level.rankTableZm[rankId][7]);
}
getRankInfoFull( rankId )
{
	return tableLookupIString( "mp/rankTable_zm.csv", 0, rankId, 16 );
}
getRankInfoIcon( rankId, prestigeId )
{
	return tableLookup( "mp/rankIconTable_zm.csv", 0, rankId, prestigeId+1 );
}
getRankInfoUnlockWeapon( rankId )
{
	return tableLookup( "mp/rankTable_zm.csv", 0, rankId, 8 );
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player.rankxpZm = player maps\_zombiemode::zombieStatGet( "rankxpzm" );
		if( player is_rank_active() )
		{
			rankId = player getRankForXp( player getRankXP() );
			player.rankZm = rankId;
			
			
			player.cur_rankNum = rankId;
			assertex( isdefined(player.cur_rankNum), "rank: "+ rankId + " does not have an index, check mp/rankTable_zm.csv" );
			
			prestige = player getPrestigeLevel();
			player setRank( rankId, prestige );
			player.prestigeId = prestige;
			
			zombieTitle = player getDStat( "PlayerStatsList", "zombie_title" );
			
		
			player maps\_zombiemode::zombieStatSet( "rankZm", rankId );
			player maps\_zombiemode::zombieStatSet( "minxpZm", getRankInfoMinXp( rankId ) );
			player maps\_zombiemode::zombieStatSet( "maxxpZm", getRankInfoMaxXp( rankId ) );
		}
		player.rankUpdateTotal = 0;
		
		player.summary_xpZm = 0;
		player.summary_challenge = 0;
		
		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}
onJoinedTeam()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("joined_team");
		self thread removeRankHUD();
	}
}
onJoinedSpectators()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeRankHUD();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		if(!isdefined(self.hud_rankscroreupdate))
		{
			self.hud_rankscroreupdate = NewScoreHudElem(self);
			self.hud_rankscroreupdate.horzAlign = "center";
			self.hud_rankscroreupdate.vertAlign = "middle";
			self.hud_rankscroreupdate.alignX = "center";
			self.hud_rankscroreupdate.alignY = "middle";
	 		self.hud_rankscroreupdate.x = 0;
			self.hud_rankscroreupdate.y = -60;
			self.hud_rankscroreupdate.font = "default";
			self.hud_rankscroreupdate.fontscale = 2.0;
			self.hud_rankscroreupdate.archived = false;
			self.hud_rankscroreupdate.color = (0.5,0.5,0.5);
			self.hud_rankscroreupdate.alpha = 0;
			self.hud_rankscroreupdate fontPulseInit();
		}
	}
}
giveRankXP( type, value, levelEnd, showXp )
{
	self endon("disconnect");
	if(	!isDefined( levelEnd ) )
	{
		levelEnd = false;
	}	
	if(	!isDefined( showXp ) )
	{
		showXp = false;
	}	
	if ( !isDefined( value ) )
		value = getScoreInfoValue( type );
	
	value = int(value);
	switch( type )
	{
		case "dogkill_assist":
		case "zombiekill_assist":
		case "apekill_assist":
		case "quadkill_assist":
			self.assists++;
			xpGain_type = "assist";
			break;
		default:
			xpGain_type = type;
			break;
	}
		
	self incRankXP( value );
	if ( self updateRank() && false == levelEnd )
		self thread updateRankAnnounceHUD();
	
	if ( value != 0 )
	{
		self syncXPStat();
	}
	if ( isDefined( self.enableText ) && self.enableText && true == showXp )
	{
		self thread updateRankScoreHUD( value );
	}
	switch( type )
	{
		case "challenge":
			self.summary_challenge += value;
			break;
	}
	
	self.summary_xpZm += value;
	if( isDefined( level.update_match_summary ) )
	{
		self [ [level.update_match_summary] ]( "xpupdate" );
	}
}
updateRank()
{
	if( !self is_rank_active() )
		return false;
	newRankId = self getRank();
	if ( newRankId == self.rankZm)
		return false;
	oldRank = self.rankZm;
	rankId = self.rankZm;
	self.rankZm = newRankId;
	
	
	
	
	while ( rankId <= newRankId )
	{
		self maps\_zombiemode::zombieStatSet( "rankZm", rankId );
		self maps\_zombiemode::zombieStatSet( "minxpZm", int(level.rankTableZm[rankId][2]) );
		self maps\_zombiemode::zombieStatSet( "maxxpZm", int(level.rankTableZm[rankId][7]) );
		rankId++;
	}
	self logString( "promoted from " + oldRank + " to " + newRankId + " timeplayed: " + self maps\_zombiemode::zombieStatGet( "time_played_total" ) );		
	self setRank( newRankId );
	
	return true;
}
updateRankAnnounceHUD()
{
	self endon("disconnect");
	self notify("update_rank");
	self endon("update_rank");
	
	self notify("reset_outcome");
	newRankName = self getRankInfoFull( self.rankZm );
	
	notifyData = spawnStruct();
	notifyData.titleText = &"RANK_PROMOTED";
	notifyData.iconName = self getRankInfoIcon( self.rankZm, self.prestigeId );
	notifyData.sound = "mus_level_up";
	notifyData.duration = 4.0;
	
	rank_char = level.rankTableZm[self.rankZm][1];
	subRank = int(rank_char[rank_char.size-1]);
	
	if ( subRank == 2 )
	{
		notifyData.textLabel = newRankName;
		notifyData.notifyText = &"RANK_ROMANI";
		notifyData.textIsString = true;
	}
	else if ( subRank == 3 )
	{
		notifyData.textLabel = newRankName;
		notifyData.notifyText = &"RANK_ROMANII";
		notifyData.textIsString = true;
	}
	else if ( subRank == 4 )
	{
		notifyData.textLabel = newRankName;
		notifyData.notifyText = &"RANK_ROMANIII";
		notifyData.textIsString = true;
	}
	else
	{
		notifyData.notifyText = newRankName;
	}
	thread maps\_hud_message::notifyMessage( notifyData );
	if ( subRank > 1 )
		return;
	
	players = GetEntArray( "player", "classname" ); 
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		if ( player != self )
		{
			player iprintln( &"RANK_PLAYER_WAS_PROMOTED", self, newRankName );
		}
	}
}
updateRankScoreHUD( amount )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	if ( amount == 0 )
		return;
	self notify( "update_score" );
	self endon( "update_score" );
	self.rankUpdateTotal += amount;
	wait ( 0.05 );
	if( isDefined( self.hud_rankscroreupdate ) )
	{			
		if ( self.rankUpdateTotal < 0 )
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (1,0,0);
		}
		else
		{
			self.hud_rankscroreupdate.label = "+";
			self.hud_rankscroreupdate.color = (1,0,0);
		}
		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 0.85;
		self.hud_rankscroreupdate thread fontPulse( self );
		wait 1;
		self.hud_rankscroreupdate fadeOverTime( 0.75 );
		self.hud_rankscroreupdate.alpha = 0;
		
		self.rankUpdateTotal = 0;
	}
}
removeRankHUD()
{
	if(isDefined(self.hud_rankscroreupdate))
		self.hud_rankscroreupdate.alpha = 0;
}
getRank()
{	
	if( !self is_rank_active() )
		return 0;
	rankXp = self.rankxpZm;
	rankId = self.rankZm;
	
	if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
		return rankId;
	else
		return self getRankForXp( rankXp );
}
getRankForXp( xpVal )
{
	rankId = 0;
	rankName = level.rankTableZm[rankId][1];
	assert( isDefined( rankName ) );
	
	while ( isDefined( rankName ) && rankName != "" )
	{
		if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
			return rankId;
		rankId++;
		if ( isDefined( level.rankTableZm[rankId] ) )
			rankName = level.rankTableZm[rankId][1];
		else
			rankName = undefined;
	}
	
	rankId--;
	return rankId;
}
getPrestigeLevel()
{
	return self maps\_zombiemode::zombieStatGet( "plevelzm" );
}
getRankXP()
{
	return self.rankxpZm;
}
incRankXP( amount )
{
	if( !self is_rank_active() )
		return;
	
	xp = self getRankXP();
	newXp = (xp + amount);
	if ( self.rankZm == level.maxRankZm && newXp >= getRankInfoMaxXP( level.maxRankZm ) )
		newXp = getRankInfoMaxXP( level.maxRankZm );
	self.rankxpZm = newXp;
}
syncXPStat()
{
	if( !self is_rank_active() )
		return;
	xp = self getRankXP();
	
	self maps\_zombiemode::zombieStatSet( "rankxpzm", int(xp) );
}
fontPulseInit()
{
	self.baseFontScale = self.fontScale;
	self.maxFontScale = self.fontScale * 2;
	self.inFrames = 3;
	self.outFrames = 5;
}
fontPulse(player)
{
	self notify ( "fontPulse" );
	self endon ( "fontPulse" );
	player endon("disconnect");
	player endon("joined_team");
	player endon("joined_spectators");
	
	scaleRange = self.maxFontScale - self.baseFontScale;
	
	while ( self.fontScale < self.maxFontScale )
	{
		self.fontScale = min( self.maxFontScale, self.fontScale + (scaleRange / self.inFrames) );
		wait 0.05;
	}
		
	while ( self.fontScale > self.baseFontScale )
	{
		self.fontScale = max( self.baseFontScale, self.fontScale - (scaleRange / self.outFrames) );
		wait 0.05;
	}
}
is_rank_active( )
{
	return false;
	
}