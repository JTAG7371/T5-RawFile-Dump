#include maps\_utility;
#include common_scripts\utility;
init()
{
	PreCacheModel("t5_veh_rcbomb_allies");
	PreCacheModel("t5_veh_rcbomb_axis");
	PrecacheVehicle("zombie_rc_car_medium");
	
	level.fx_treadfx_dust = loadfx( "vehicle/treadfx/fx_treadfx_dust" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_dust" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_dust_drift" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_dust_peel" );
	loadfx( "vehicle/light/fx_rcbomb_blinky_light" );
	loadfx( "vehicle/light/fx_rcbomb_solid_light" );
	
	
	level._effect["rcbombexplosion"] = loadfx("maps/mp_maps/fx_mp_exp_rc_bomb");
	
		car_size = GetDvar( #"scr_rcbomb_car_size");
	if ( car_size == "" )
	{
		SetDvar("scr_rcbomb_car_size","1");
	}
}
spawnRCBomb(placement, team)
{
	car_size = GetDvar( #"scr_rcbomb_car_size");
	
	model = "t5_veh_rcbomb_allies";
	enemymodel = "t5_veh_rcbomb_axis";
	death_model = "t5_veh_rcbomb_allies";
	car = "zombie_rc_car_medium";
	
	vehicle = SpawnVehicle(
	model,
	"rcbomb",
	car,
	placement,
	self.angles );
	
	vehicle MakeVehicleUnusable();
	vehicle.death_model = death_model;
	
	
	
	
	
	return vehicle;
}
useRcCar( placement )
{
	self endon("death"); 
	self endon("disconnect"); 
	
	if ( !IsDefined( self.rcbomb ) )
	{
		self.rcbomb = self spawnRCBomb(placement, self.pers["team"] );
		
		if ( !IsDefined( self.rcbomb ) )
		{
			return false;
		}
	}
	
	flag_set("end_target_confirm");
	
	
	self.rcbomb usevehicle( self, 0 );
	self thread exitCarWaiter( self.rcbomb );
	self waittill( "rcbomb_done" );
	
	self Unlink();
	self setOrigin( self.rcbomb.origin ); 
	self.rcbomb Delete();
	return true;
}
exitCarWaiter( vehicle )
{
	self endon("death"); 
	self endon("disconnect"); 
	vehicle endon("death"); 
	
	while( !self attackbuttonpressed() )
	{
		self setOrigin( vehicle.origin ); 	
		wait 0.05;
	}
		
	self notify("rcbomb_done");
}
getPlacementStartHeight
()
{
	startheight = 50;
	
	switch( self GetStance() )
	{
		case "crouch":
			startheight = 30;
			break;
		case "prone":
			startheight = 15;
			break;
	}
	return startheight;
}
testWheelLocations( origin, angles, heightoffset )
{
	forward = 13;
	side = 10;
	
	wheels = [];
	wheels[0] = ( forward, side, 0 );
	wheels[1] = ( forward, -1 * side, 0 );
	wheels[2] = ( -1 * forward, -1 * side, 0 );
	wheels[3] = ( -1 * forward, side, 0 );
	height = 5;
	touchCount = 0;
	
	yawangles = (0,angles[1],0);
	
	for (i = 0; i < 4; i++ )
	{
		wheel = RotatePoint( wheels[i], yawangles  );
		startPoint = origin + wheel;
		endPoint = startPoint + (0,0,(-1 * height) - heightoffset);
		startPoint = startPoint + (0,0,height - heightoffset) ;
	
		trace = bulletTrace( startPoint, endPoint, false, self );
		if ( trace["fraction"] < 1 )
		{
			touchCount++;
			rcbomb_debug_line( startPoint, endPoint,(1,0,0) );
		}
		else
		{
			rcbomb_debug_line( startPoint, endPoint,(0,0,1) );
		}
	}
	
	return touchCount;
}
testSpawnOrigin( origin, angles )
{
	liftedorigin = origin + (0,0,5);
	size = 12;
	height = 15;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	
	
	if ( BoundsWouldTelefrag( absmins, absmaxs ) )
	{
		rcbomb_debug_box( liftedorigin, mins, maxs,(1,0,0) );
		return false;
	}
	else
	{
		rcbomb_debug_box( liftedorigin, mins, maxs,(0,0,1) );
	}
	
	startheight = getPlacementStartHeight();
	
	mask =  level.PhysicsTraceMaskPhysics | level.PhysicsTraceMaskVehicle | level.PhysicsTraceMaskWater;
	
	
	trace = physicstrace( liftedorigin, (origin +(0,0,1)), mins, maxs, self, mask);
	if ( trace["fraction"] < 1 )
	{
		rcbomb_debug_box( trace["position"], mins, maxs, (1,0,0) );
		return false;
	}
	else
	{
		rcbomb_debug_box( (origin +(0,0,1)), mins, maxs, (0,1,0) );
	}
	
	
	size = 2.5;
	height = size * 2;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	
	sweeptrace = physicstrace( (self.origin + (0,0,startheight)), liftedorigin, mins, maxs, self, mask);
	if ( sweeptrace["fraction"] < 1 )
	{
		rcbomb_debug_box( sweeptrace["position"], mins, maxs, (1,0,0) );
		return false;
	}
	
	return true;
}
rcbomb_debug_box( origin, mins, maxs, color )
{
}
rcbomb_debug_line( start, end, color )
{
}  
