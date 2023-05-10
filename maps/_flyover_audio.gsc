
#include maps\_utility; 
#include common_scripts\utility; 
closest_point_on_line_to_point( Point, LineStart, LineEnd )
{
	
	LineMagSqrd = lengthsquared(LineEnd - LineStart);
 
    t =	( ( ( Point[0] - LineStart[0] ) * ( LineEnd[0] - LineStart[0] ) ) +
				( ( Point[1] - LineStart[1] ) * ( LineEnd[1] - LineStart[1] ) ) +
				( ( Point[2] - LineStart[2] ) * ( LineEnd[2] - LineStart[2] ) ) ) /
				( LineMagSqrd );
 
  if( t < 0.0  )
	{
		return LineStart;
	}
	else if( t > 1.0 )
	{
		return LineEnd;
	}
	else
	{
		start_x = LineStart[0] + t * ( LineEnd[0] - LineStart[0] );
		start_y = LineStart[1] + t * ( LineEnd[1] - LineStart[1] );
		start_z = LineStart[2] + t * ( LineEnd[2] - LineStart[2] );
		
		return (start_x,start_y,start_z);
	}
}
plane_position_updater (miliseconds, soundalias_1, soundalias_2)
{
	
	apex = miliseconds;
	
	soundid = -1;
	dx = undefined;
	last_time = undefined;
	last_pos = undefined;
	start_time = 0;
	if(!IsDefined (soundalias_1))
	{
		self.soundalias_1 = "veh_mig_flyby";		
	}
	else
	{
		self.soundalias_1 = soundalias_1;
	}
	if(!IsDefined (soundalias_2))
	{
		self.soundalias_2 = "veh_mig_flyby_lfe";			
	}
	else
	{
		self.soundalias_2 = soundalias_2;
	}
	
	while(IsDefined(self))
	{
		
		
		if((soundid < 0) && isdefined(last_pos))
		{
			dx = self.origin - last_pos;
			
			if(length(dx) > .01)
			{
				velocity = dx / (GetTime()-last_time);
				assert(isdefined(velocity));
				players = getplayers();
				assert(isdefined(players));
				other_point = self.origin + (velocity * 100000);
				point = closest_point_on_line_to_point(players[0].origin, self.origin, other_point );
				assert(isdefined(point));
				dist = Distance( point, self.origin );	
				assert(isdefined(dist));
				time = dist / length(velocity);
				assert(isdefined(time));
				
				if(time < apex)
				{
					self playsound(self.soundalias_1);	
					if(self.soundalias_2 != "null")
					{			
						self playsound (self.soundalias_2);
					}
					start_time = GetTime();
					break;
				}
				
			
			}
	
		}
		
		last_pos = self.origin;
		last_time = GetTime();
		
		if(start_time != 0)
		{
			
		}
					
		wait(0.1);		
		
	}
	
}  
