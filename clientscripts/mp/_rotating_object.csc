#include clientscripts\mp\_utility;

/*
This script sets up functionality in multiplayer where an object can be rotated. It must be given the "rotating_object" targetname.
It must also have a script_float, which determines how many seconds it take for the object to complete a full 360 degree rotation.
This script is called by the _load.csc
*/

//Start a rotation thread on each object with the appropriate targetname and set a rotation speed dvar.
init( localClientNum )
{
	rotating_objects = GetEntArray( localClientNum, "rotating_object", "targetname" );
	array_thread( rotating_objects, ::rotating_object_think );
}

//Set up rotation behvahior. 'Self' is the rotating object. 	
rotating_object_think()
{
	self endon ("entityshutdown");
	
	//I create this variable to manage what kind of rotate I want to use
	change_spin = 0;
	
	//In Radiant, the script_noteworthy on the object determines the nature of the rotate
	if(IsDefined(self.script_noteworthy) && self.script_noteworthy == "roll")
	{
		change_spin = 1;
	} 
	else if(IsDefined(self.script_noteworthy) && self.script_noteworthy == "pitch")
	{
		change_spin = 2;
	}
	
	while(1)
	{
		rotate_time = GetDvarFloat(#"scr_rotating_objects_secs");
		
		//Prevent SRE if zero were to be passed as a time value in the rotate function
		if ( rotate_time == 0 )
		{
			//Default spin speed
			rotate_time = 12;
		}
		
		if(IsDefined(self.script_float) && (rotate_time == 12)) 
		{
			//The script_float on the object determines how fast it spins, if it is defined
			rotate_time = self.script_float;
		}
		
		if(rotate_time > 0)
		{	
			switch(change_spin)
			{
				case 0:
					self RotateYaw( 360, rotate_time );
				break;
				
				case 1:
					self RotateRoll( 360, rotate_time );
				break;
				
				case 2:
					self RotatePitch( 360, rotate_time );
				break;
				
				default:
				break;
			}	
		}
		//If the value is negative, the object should spin counter-clockwise.
		else
		{
			switch(change_spin)
			{
				case 0:
					self RotateYaw( -360, Abs(rotate_time ));	
				break;
				
				case 1:
					self RotateRoll( -360, Abs(rotate_time ));
				break;
				
				case 2:
					self RotatePitch( -360, Abs(rotate_time ));
				break;
				
				default:
				break;
			}
		}
		
		self waittill( "rotatedone" );
	}

}
