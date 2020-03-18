init()
{
	SetDvar("g_ScoresColor_Spectator", ".25 .25 .25");
	setdvar("g_ScoresColor_Free", ".76 .78 .10");

	setdvar("g_teamColor_MyTeam", ".4 .7 .4" );	
	setdvar("g_teamColor_EnemyTeam", "1 .315 0.35" );	
	setdvar("g_teamColor_MyTeamAlt", ".35 1 1" ); //cyan
	setdvar("g_teamColor_EnemyTeamAlt", "1 .5 0" ); //orange	

	setdvar("g_teamColor_Squad", ".315 0.35 1" );

	if ( level.createFX_enabled )
		return;

	setdvar( "g_TeamIcon_Axis", game["icons"]["axis"] );
	setdvar( "g_TeamIcon_Allies", game["icons"]["allies"] );
}
