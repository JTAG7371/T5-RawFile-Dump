#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_music;
init_motorcycle_audio()
{
    self thread bike_setup_player();
    
}
bike_setup_player()
{
	self.is_accelerating = false;			
	self.is_braking	     = false;			
	self.is_on_ground	 = true;            
	self.is_jumping		 = false;           
	self.moto_stage		 = "vMi";           
    
    self bike_start_audio_plr();            
    self thread send_moto_clientnotify();   
    self thread set_moto_stage();           
	self thread track_bike_liftoff();       
	self thread track_bike_landing();       
	self gear_setup();						
	self thread set_gear_state();			
}
bike_start_audio_plr()
{
    player = get_players()[0];
    
    player PlaySound( "veh_moto_activate_plr" );
    clientnotify( "vM" );  
}
send_moto_clientnotify()
{
    self endon( "death" );
    self endon( "crashed" );
    level endon( "evM" );
    
    current_stage = undefined;
    previous_stage = undefined;
    notify_timer = 0;
    
    while(1)
    {
        if( !IsDefined( self.moto_stage ) )
        {
            wait(.05);
            continue;
        }
        
        if( !IsDefined( current_stage ) || !IsDefined( previous_stage ) )
        {
            current_stage = self.moto_stage;
            previous_stage = self.moto_stage;
            
        }
        
        current_stage = self.moto_stage;
        
        if( ( current_stage != previous_stage ) && ( notify_timer >= .5 ) )
        {
            previous_stage = current_stage;
            clientnotify( current_stage );
            notify_timer = 0;
        }
        
        notify_timer = notify_timer + .05;
        wait(.05);
    }
}
set_moto_stage()
{
    self endon( "death" );
    self endon( "crashed" );
    level endon( "evM" );
    
    player = get_players()[0];
    
    while(1)
    {
        if( self.is_on_ground == false )
        {
            self.moto_stage = "vMj";  
        }
        else if( player AttackButtonPressed() == false && self GetSpeedMPH() <= 20  )
        {
            self.moto_stage = "vMi";  
			self.is_accelerating = false;
			self.is_idling = true;
        }
        else if( player AttackButtonPressed() == false && self GetSpeedMPH() <= 80 )
		{
            self.moto_stage = "vMd";  
			self.is_accelerating = false;
			self.is_idling = false;
        }
        else if( player AttackButtonPressed() == true )
        {
            self.moto_stage = "vMa";  
			self.is_accelerating = true;
			self.is_idling = false;
        }
        wait(.05);
    }
}
track_bike_liftoff()
{
	while(1)
	{
		self waittill("veh_inair"); 
		self.is_on_ground = false;  
		self.is_jumping = true;
	}
}
track_bike_landing() 
{
    while(1)
    {
        self waittill( "veh_landed" ); 
		self.is_on_ground = true;  
		self.is_jumping = false;
    }
}
gear_setup()
{
	self.moto_gear_trans = [];
	p = 1;
	n = 0;
	m = 0;
	for(i=0;i<8;i++)
	{
		self.moto_gear_trans[i] = [];
		if( i == 0 )
			self.moto_gear_trans[i]["pitch_time"] = 1;
		else
			self.moto_gear_trans[i]["pitch_time"] = p*2;
		self.moto_gear_trans[i]["min_pitch"] = .75 + n;
		self.moto_gear_trans[i]["max_pitch"] = 1.15 + m;
		
		p = self.moto_gear_trans[i]["pitch_time"];
		n = n + .055;
		m = m + .045;
	}
}
set_gear_state()
{
	level endon( "evM" );
	self.gear_state = 0;
	current_time = undefined;
	decelerate_time = undefined;
		
	while(1)
	{
		while( IsDefined( self ) && self.is_accelerating && !self.is_jumping && !self.is_braking )
		{
			if( !IsDefined( current_time ) )
				current_time = 0;
			gear_change_time = self.moto_gear_trans[self.gear_state]["pitch_time"];
						
			if( current_time >= gear_change_time )
			{
				current_time = undefined;
				self.gear_state = self.gear_state + 1;
				
				self.gearStateChanged = true;
				self notify( "gear_changed" );
				wait(.05);
			}
			else
			{
				wait(.05);
				current_time = current_time + .05;
			}
		}
		while( IsDefined( self ) && (!self.is_accelerating || self.is_jumping || self.is_braking) )
		{
			current_time = undefined;
			if( !IsDefined( decelerate_time ) )
				decelerate_time = 0;
			if( decelerate_time >= 1 )
			{
				if( self.gear_state == 0 )
				{
					decelerate_time = undefined;
					wait(.05);
				}
				else
				{
					decelerate_time = undefined;
					self.gear_state = self.gear_state - 1;
					
					self.gearStateChanged = true;
					self notify( "gear_changed" );
					wait(.05);
				}
			}
			else
			{
				wait(.05);
				decelerate_time = decelerate_time + .05;
			}
		}
		
		wait(.05);
	}
}  
