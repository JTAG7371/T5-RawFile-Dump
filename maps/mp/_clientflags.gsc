init()
{
	// Scriptmovers
	level.const_flag_rocket_fx = 1; // used for mp_cosmodrome
	level.const_flag_police_car = 1; // used for mp_gridlock
	level.const_flag_elevator_fx = 1; // used for mp_hotel
	level.const_flag_tactical_insertion = 2;
	level.const_flag_flag_away = 3;
	level.const_flag_stunned = 9;
	level.const_flag_camera_spike = 10;
	level.const_flag_counteruav = 11;
	level.const_flag_destructible_car = 12;
	level.const_flag_copterrotor = 13;
	level.const_flag_copterdamaged = 14;
	level.const_flag_elevator_floor_fx = 15; // used for mp_hotel

	// Missiles
	level.const_flag_scrambler = 3;
	level.const_flag_stunned = 9;
	
	// Helicopters
	level.const_flag_warn_targeted = 3;
	level.const_flag_warn_locked = 4;
	level.const_flag_warn_fired = 5;
	level.const_flag_outofbounds = 6;
	level.const_flag_choppergunner = 7;
	level.const_flag_opendoor = 8;
	level.const_flag_crashing = 9;
	level.const_flag_player_helicopter = 10;

	// Vehicles
	level.const_flag_countdown = 1;
	level.const_flag_timeout = 2;
	level.const_flag_stunned = 9;
	
	// Players
	level.const_flag_ctfcarrier = 0;

	// Planes
	level.const_flag_bombing = 1;
	level.const_flag_airstrike = 2;
	level.const_flag_napalm = 3;
}