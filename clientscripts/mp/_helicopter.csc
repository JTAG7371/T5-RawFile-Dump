#include clientscripts\mp\_utility;

init()
{		
	level.coptertailrotor_fx = loadfx ("vehicle/props/fx_cobra_rotor_small_run_mp");
	level.coptertailrotordamaged_fx = loadfx ("vehicle/props/fx_huey_small_blade_dmg");

	level._client_flag_callbacks["script_mover"][level.const_flag_copterrotor] = ::rotor;
	level._client_flag_callbacks["script_mover"][level.const_flag_copterdamaged] = ::rotordamaged;

	level.chopper_fx["damage"]["light_smoke"] = loadfx ("trail/fx_trail_heli_killstreak_engine_smoke_33");
	level.chopper_fx["damage"]["heavy_smoke"] = loadfx ("trail/fx_trail_heli_killstreak_engine_smoke_66");

	level._effect["chinook_light"]["friendly"] = loadfx( "vehicle/light/fx_chinook_exterior_lights_grn_mp" );
	level._effect["chinook_light"]["enemy"] = loadfx( "vehicle/light/fx_chinook_exterior_lights_red_mp" );
	level._effect["cobra_light"]["friendly"] = loadfx( "vehicle/light/fx_cobra_exterior_lights_red_mp" );
	level._effect["cobra_light"]["enemy"] = loadfx( "vehicle/light/fx_cobra_exterior_lights_red_mp" );
	level._effect["hind_light"]["friendly"] = loadfx( "vehicle/light/fx_hind_exterior_lights_grn_mp" );
	level._effect["hind_light"]["enemy"] = loadfx( "vehicle/light/fx_hind_exterior_lights_red_mp" );
	level._effect["huey_light"]["friendly"] = loadfx( "vehicle/light/fx_huey_exterior_lights_grn_mp" );
	level._effect["huey_light"]["enemy"] = loadfx( "vehicle/light/fx_huey_exterior_lights_red_mp" );
}


rotor(localClientNum, set )
{
	if ( !set )
		return;

	player = GetLocalPlayer( localClientNum );
	
//	PrintLn("Client: _helicopter.csc - rotor() - playing tail rotor");

	if( IsDefined(self.rotorTailRunningFx) )
	{
			self.rotorTailfxHandle = PlayFXOnTag(localClientNum, self.rotorTailRunningFx, self, "tail_rotor_jnt");
	}
	else
	{
		PrintLn("Client: _helicopter.csc - startfx() - tail rotor fx is not loaded");
	}
	
}

rotordamaged(localClientNum, set )
{
	if ( !set )
		return;

	player = GetLocalPlayer( localClientNum );
	
	playfxontag( localClientNum, level.coptertailrotordamaged_fx, self, "tag_origin");		
}

heli_deletefx(localClientNum)
{
	if (isdefined(self.rotorMainfxHandle))
	{
		deletefx( localClientNum, self.rotorMainfxHandle );
		self.rotorMainfxHandle = undefined;
	}

	if (isdefined(self.rotorTailfxHandle))
	{
		deletefx( localClientNum, self.rotorTailfxHandle );
		self.rotorTailfxHandle = undefined;
	}
	
	if (isdefined(self.exhaustLeftFxHandle))
	{
		deletefx( localClientNum, self.exhaustLeftFxHandle );
		self.exhaustLeftFxHandle = undefined;
	}
	
	if (isdefined(self.exhaustRightFxHandlee))
	{
		deletefx( localClientNum, self.exhaustRightFxHandle );
		self.exhaustRightFxHandle = undefined;
	}
	
	if (isdefined(self.lightFXID))
	{
		deletefx( localClientNum, self.lightFXID );
		self.lightFXID = undefined;
	}

}

startfx(localClientNum)
{
	if( isdefined( self.rotorMainRunningFxName ) && self.rotorMainRunningFxName != "" )
	{
		self.rotorMainRunningFx = LoadFX( self.rotorMainRunningFxName );
	}
	
	if( IsDefined(self.rotorMainRunningFx) )
	{
			self.rotorMainfxHandle = PlayFXOnTag(localClientNum, self.rotorMainRunningFx, self, "main_rotor_jnt");
	}
	else
	{
		PrintLn("Client: _helicopter.csc - startfx() - main rotor fx is not loaded");
	}
	
	if( isdefined( self.rotorTailRunningFxName ) && self.rotorTailRunningFxName != "" )
	{
		self.rotorTailRunningFx = LoadFX( self.rotorTailRunningFxName );
	}
	
	if( IsDefined(self.rotorTailRunningFx) )
	{
		self.rotorTailfxHandle = PlayFXOnTag(localClientNum, self.rotorTailRunningFx, self, "tail_rotor_jnt");
	}
	else
	{
		PrintLn("Client: _helicopter.csc - startfx() - tail rotor fx is not loaded");
	}

	if( isdefined( self.exhaustfxname ) && self.exhaustfxname != "" )
	{
		self.exhaustFx = loadfx( self.exhaustfxname ); 
	}

	if( IsDefined(self.exhaustFx) )
	{
		self.exhaustLeftFxHandle = PlayFXOnTag( localClientNum, self.exhaustFx, self, "tag_engine_left" );		
		if( !self.oneexhaust )
			self.exhaustRightFxHandle = PlayFXOnTag( localClientNum, self.exhaustFx, self, "tag_engine_right" );		
	}
	else
	{
		PrintLn("Client: _helicopter.csc - startfx() - exhaust rotor fx is not loaded");
	}
	
	if( isDefined( self.vehicletype ) )
	{
		light_fx = undefined;
		
		switch( self.vehicletype )
		{
			case "heli_ai_mp":
				light_fx = "cobra_light";
				break;
			case "heli_supplydrop_mp":
				light_fx = "chinook_light";
				break;
			case "heli_gunner_mp":			
				light_fx = "huey_light";
				break;
			case "heli_player_controlled_firstperson_mp":
			case "heli_player_controlled_mp":
				light_fx = "hind_light";
				break;
		};
	
		if ( self friendNotFoe( localClientNum ) )
		{
			PrintLn( "HELI playing friendly " + light_fx + " " +   level._effect[light_fx]["friendly"] );
			self.lightFXID = PlayFXOnTag( localClientNum, level._effect[light_fx]["friendly"], self, "tag_origin" );
		}
		else
		{
			PrintLn( "HELI playing enemy " + light_fx + " " +   level._effect[light_fx]["enemy"] );
			self.lightFXID = PlayFXOnTag( localClientNum, level._effect[light_fx]["enemy"], self, "tag_origin" );
		}
	}
	
	self damage_fx_stages(localClientNum);
}

startfx_loop(localClientNum)
{
	self endon( "entityshutdown" );

	self thread clientscripts\mp\_helicopter_sounds::aircraft_dustkick(localClientNum);
	self clientscripts\mp\_helicopter_sounds::start_helicopter_sounds();

	startfx( localClientNum );
	
	serverTime = getServerTime( 0 );
	lastServerTime = serverTime;
	
	while( isdefined( self ) )
	{
		//println( "HELI startfx_loop (" + serverTime + ")" );
		// if time goes backwards, then restart them
		if (serverTime < lastServerTime)
		{
			//println( "HELI !!! startfx called (" + serverTime + ")" );
			heli_deletefx( localClientNum );
			//wait( 0.5 );
			startfx( localClientNum );
		}
		wait( 0.05 );	// small for added granularity. any bigger and rapid time switching can cause problems.
		lastServerTime = serverTime;
		serverTime = getServerTime( 0 );
	}
}

damage_fx_stages(localClientNum)
{
	last_damage_state = self GetHeliDamageState();
	fx = undefined;
	
	for ( ;; )
	{
		if ( last_damage_state != self GetHeliDamageState() )
		{
			if ( self GetHeliDamageState() == 2 )
			{
				if ( IsDefined(fx) )
					stopfx( localClientNum, fx );
					
				fx = trail_fx( localClientNum, level.chopper_fx["damage"]["light_smoke"], "tag_engine_left" );
			}
			else if ( self GetHeliDamageState() == 1 )
			{
				if ( IsDefined(fx) )
					stopfx( localClientNum, fx );

				fx = trail_fx( localClientNum, level.chopper_fx["damage"]["heavy_smoke"], "tag_engine_left" );
			}
			else
			{
				if ( IsDefined(fx) )
					stopfx( localClientNum, fx );

				self notify( "stop trail" );
			}		
			last_damage_state = self GetHeliDamageState();
		}
		wait(0.25);
	}
}

trail_fx( localClientNum, trail_fx, trail_tag )
{
	// only one instance allowed
//	self notify( "stop trail" );
//	self endon( "stop trail" );
//	self endon( "entityshutdown" );
		
//	for ( ;; )
	{
		id = playfxontag( localClientNum, trail_fx, self, trail_tag );
		//wait( 0.05 );
	}
	return id;
}
