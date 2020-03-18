playerFootstep(client_num, player, movementtype, ground_type, firstperson, quiet )
{
	// don't play footstep sounds while underwater
	if( player underwater() )
	{
		return;
	}
	if ( player HasPerk( "specialty_quieter" ))
	{
		return;
	}	

	full_movement_type = "step_" + movementtype;
	sound_alias = buildMovementSoundAliasName(full_movement_type, ground_type, firstperson, quiet, player );
	
	//set movement type for current footstep for use in _audio.csc
	player.movementtype = movementtype;
	
	//print for debug
	if( getdvarint( #"debug_footsteps" ) > 0 )
	{
		//iprintlnbold ("ground_type " + ground_type + " movementtype " + movementtype + "Alias " + sound_alias);	
		/#
		if ( !IsDefined( player.step_sound ))
		{
			player.step_sound = "none";
		}	
		iprintlnbold ("ground_type " + ground_type);
		iprintlnbold ("movementtype " + movementtype);
		iprintlnbold ("Alias " + sound_alias + " Step Sound " + player.step_sound);		
		//iprintlnbold ("Step Sound " + player.step_sound);		
		#/
		
	}

	player playsound( client_num, sound_alias);
	
		
	if ( IsDefined( player.step_sound ) && (!quiet) && (player.step_sound) != "none" )
	{
		volume = clientscripts\mp\_audio::get_vol_from_speed (player);
	
		//debug information for step triggers 
		if( getdvarint( #"debug_audio" ) > 0 && ( firstperson ))
		{
			/#
			iprintlnbold ("step sound " + player.step_sound + " Volume " + volume);	
			#/
		}
		
 		player playsound (client_num, player.step_sound, player.origin, volume);				
	}
}

playerJump(client_num, player, ground_type, firstperson, quiet)
{
	if ( player HasPerk( "specialty_quieter" ))
	{
		return;
	}	
	// in cod4 and WAW the jump just played the run footstep sound
	sound_alias = buildMovementSoundAliasName("step_run", ground_type, firstperson, quiet, player );
	
	//iprintlnbold ("jump sound " + sound_alias );	
	
	player playsound( client_num, sound_alias );
}

playerLand(client_num, player, ground_type, firstperson, quiet, damagePlayer)
{
	if ( player HasPerk( "specialty_quieter" ))
	{
		return;
	}	
	sound_alias = buildMovementSoundAliasName("land", ground_type, firstperson, quiet, player );

	player playsound( client_num, sound_alias );
	// play step sound for landings if one exists
	if ( IsDefined( player.step_sound ) && (!quiet) && (player.step_sound) != "none" )
	{
		volume = clientscripts\mp\_audio::get_vol_from_speed (player);
	
		//iprintlnbold ("step sound " + player.step_sound + " Volume " + volume);	
 		player playsound (client_num, player.step_sound, player.origin, volume);				
	}
	if ( damagePlayer )
	{
		sound_alias = "fly_land_damage_npc";
		if ( firstperson )
		{
			sound_alias = "fly_land_damage_plr";
			player playsound( client_num, sound_alias );
				
		}
	}
}

playerFoliage(client_num, player, firstperson, quiet)
{
	if ( player IsPlayer() && player HasPerk( "specialty_quieter" ))
	{
		return;
	}	
	sound_alias = "fly_movement_foliage_npc";
	if ( firstperson )
	{
		sound_alias = "fly_movement_foliage_plr";
	}

	volume = clientscripts\mp\_audio::get_vol_from_speed (player);	
	//iprintlnbold ("Foliage sound " + sound_alias + "Volume: " + volume);
	
	player playsound( client_num, sound_alias, player.origin, volume );
}

buildMovementSoundAliasName( movementtype, ground_type, firstperson, quiet, player )
{
	sound_alias = "fly_";

/*	if ( quiet )
	{
		sound_alias = sound_alias + "q";
	}
*/
	if (player.team != GetLocalPlayerTeam(0) && IsDefined( level.loudenemies ) && ( level.loudenemies ) )	
	{
		sound_alias = sound_alias + "q";
	}		
	sound_alias = sound_alias + movementtype;

	if ( firstperson )
	{
		sound_alias = sound_alias + "_plr_";
	}
	else
	{
		sound_alias = sound_alias + "_npc_";
	}
	
	sound_alias = sound_alias + ground_type; 
	
	return sound_alias;
}

do_foot_effect(client_num, ground_type, foot_pos, on_fire)
{

	if(!isdefined(level._optionalStepEffects))
		return;

	if( on_fire )
	{
		ground_type = "fire";
	} 
	
	/#
	
	if(GetDvarInt(#"debug_surface_type"))
	{
		print3d(foot_pos, ground_type, (0.5, 0.5, 0.8), 1, 3, 30);
	}
	
	#/
		
	for(i = 0; i < level._optionalStepEffects.size; i ++)
	{
		if(level._optionalStepEffects[i] == ground_type)
		{
			effect = "fly_step_" + ground_type;
			
			if(isdefined(level._effect[effect]))
			{
				playfx(client_num, level._effect[effect], foot_pos, foot_pos + (0,0,100));
				return;				
			}
		}
	}
	
}
