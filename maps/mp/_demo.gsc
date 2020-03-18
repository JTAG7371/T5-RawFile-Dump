#include maps\mp\_utility;

init()
{
	// This number should match the values of the enum listed in sv_snapshot_demo.h
	level.bookmark["kill"] = 0; // SVSD_BOOKMARK_KILL
	level.bookmark["event"] = 1; // SVSD_BOOKMARK_EVENT
	
	if( !level.console )
		demoOnce();
}

bookmark( type, time, ent1, ent2 )
{
	assertex( isdefined( level.bookmark[type] ), "Unable to find a bookmark type for type - " + type );

	client1 = 255;
	client2 = 255;

	if ( isDefined( ent1 ) )
		client1 = ent1 getEntityNumber();

	if ( isDefined( ent2 ) )
		client2 = ent2 getEntityNumber();

	addDemoBookmark( level.bookmark[type], time, client1, client2 );
}

// PC demo recording starts when scr_demorecord_minplayers are in the server, and stops if < scr_demorecord_minplayers
demoOnce()
{
	if( !isDemoEnabled() )
			return;
			
	if( isPregame() )
		return;

	if ( !GetDvarInt( #"scr_demorecord_minplayers" ) )
	{
		SetDvar( "scr_demorecord_minplayers", 1 );
	}
	
	level.demorecord_minplayers = max( 1, GetDvarInt( #"scr_demorecord_minplayers" ) );
	level thread demoThink();
}


demoThink()
{
	level endon ( "game_ended" );

	wait( 0.5 );	
	
	for( ;; )
	{		
		wait 5.0;
		
		if ( game["state"] == "postgame" )
			return;
			
		if( isPregame() )
		{
			StopDemoRecording();			
			return;
		}
		
		bots = level.botsCount["allies"] +	level.botsCount["axis"];
		humans = level.playerCount["allies"] + level.playerCount["axis"] - bots;
		
/#
		//PrintLn("demoThink bots: " + bots );
		//PrintLn("demoThink humans: " + humans );
		//PrintLn("demoThink minplayers: " + level.demorecord_minplayers );
#/	
		
		if( humans < level.demorecord_minplayers )
		{
/#
			//PrintLn("demoThink StopDemoRecording");
#/			
			StopDemoRecording();
			continue;
		}		
		
		if( isDemoRecording() )
			continue;
			
		if( humans >= level.demorecord_minplayers )
		{
/#
			//PrintLn("demoThink StartDemoRecording");
#/						
			StartDemoRecording();
			continue;
		}					
		
	}
	
}