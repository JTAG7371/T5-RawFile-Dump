
finishHardpointLocationUsage( location, usedCallback )
{
	self notify( "used" );
	wait ( 0.05 );
	self thread stopHardpointLocationSelection( false );
	self thread [[usedCallback]]( location );
	return true;
}
finishDualHardpointLocationUsage( locationStart, locationEnd, usedCallback )
{
	self notify( "used" );
	wait ( 0.05 );
	self thread stopHardpointLocationSelection( false );
	self thread [[usedCallback]]( locationStart, locationEnd );
	return true;
}
endSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );
	
	self waittill( waitfor );
	self thread stopHardpointLocationSelection( (waitfor == "disconnect") );
}
endSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );
	
	level waittill( "game_ended" );
	
	self thread stopHardpointLocationSelection( false );
}
stopHardpointLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self endLocationSelection();
		self.selectingLocation = undefined;
	}
	self notify( "stop_location_selection" );
}
deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( time );
	
	self delete();
}
getDvarIntDefault( dvarName, defaultValue)
{
	returnVal = defaultValue;	
	if (getDvar(dvarName) != "")
	{
		return getDvarInt(dvarName);
	}	
	return returnVal;
}	
getDvarFloatDefault( dvarName, defaultValue)
{
	returnVal = defaultValue;	
	if (getDvar(dvarName) != "")
	{
		return getDvarFloat(dvarName);
	}	
	return returnVal;
}	
calculateFallTime( flyHeight )
{
	
	gravity = GetDvarInt( #"bg_gravity" );
	time = sqrt( (2 * flyHeight) / gravity );
	
	return time;
}
calculateReleaseTime( flyTime, flyHeight, flySpeed, bombSpeedScale )
{
	falltime = calculateFallTime( flyHeight );
	
	
	bomb_x = (flySpeed * bombSpeedScale) * falltime;
	release_time = bomb_x / flySpeed;
	
	return ( (flyTime * 0.5) - release_time);
}
determineGroundPoint( player, position )
{
	ground = (position[0], position[1], player.origin[2]);
	
	trace = bullettrace(ground  + (0,0,10000), ground, false, undefined );
	return trace["position"];
}
setupTimers()
{	
	if ( !isdefined( level.airsupportHeightScale ) ) 
		level.airsupportHeightScale = 1;
	
	level.airsupportHeightScale = getDvarIntDefault( #"scr_airsupportHeightScale", level.airsupportHeightScale );	
	
	level.napalmFlameMinAngle 	= 25;
	level.napalmFlameMaxAngle 	= 40;
}
debug_draw_bomb_explosion(prevpos)
{
	self notify("draw_explosion");
	wait(0.05);
	self endon("draw_explosion");
	
	self waittill("projectile_impact", weapon, position );
	
	thread debug_line( prevpos, position, (.5,1,0) );
	thread debug_star( position, (1,0,0) );
}
debug_draw_bomb_path( projectile )
{
}
debug_print3d_simple( message, ent, offset, frames )
{
	
}
draw_text( msg, color, ent, offset, frames )
{
	if( frames == 0 )
	{
		while ( isdefined( ent ) )
		{
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			wait 0.05;
		}
	}
	else
	{
		for( i=0; i < frames; i++ )
		{
			if( !isdefined( ent ) )
				break;
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			wait 0.05;
		}
	}
}
debug_print3d( message, color, ent, origin_offset, frames )
{
}
debug_line( from, to, color, time )
{
}
debug_star( origin, color, time )
{
}