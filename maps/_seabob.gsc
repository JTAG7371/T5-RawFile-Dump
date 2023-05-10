
main( model, type )
{
	
	if( !IsDefined( type ) )
	{
		type = "dpv";
	}
	
	level.vehicleInitThread[type][model] = ::init_local;
	
	deathfx = LoadFx( "explosions/fx_large_vehicle_explosion" );
	
	switch( model )
	{
		case "vehicle_usa_seabob":
			PrecacheModel( "vehicle_player_seabob" );
			
			
			
			
			level.vehicle_deathmodel[model] = "vehicle_usa_seabob";
			break;
		case "vehicle_player_seabob":
			PrecacheModel( "vehicle_player_seabob" );
			
			
			
			
			level.vehicle_deathmodel[model] = "vehicle_player_seabob";
			break;
		case "weapon_ger_panzershark_rocket":
			PrecacheModel( "weapon_ger_panzershark_rocket" );
			level.vehicle_deathmodel[model] = "weapon_ger_panzershark_rocket";
			break;
	}
	PrecacheVehicle( type );
	
	level.vehicle_death_fx[type] = [];
	
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	
	level.vehicle_team[type] = "allies";
	
	level.vehicle_hasMainTurret[model] = false;
	
	level.vehicle_compassicon[type] = false;
}
init_local()
{
}  
