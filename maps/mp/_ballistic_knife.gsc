#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	PrecacheModel( "t5_weapon_ballistic_knife_blade" );
	PrecacheModel( "t5_weapon_ballistic_knife_blade_retrieve" );
}

onSpawn( watcher, player )
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );

	self waittill( "stationary", endpos, normal, angles, attacker, prey, bone );

	isFriendly = false;

	if( isDefined(endpos) )
	{
		// once the missile dies, spawn a model there to be retrieved
		retrievable_model = Spawn( "script_model", endpos );
		retrievable_model SetModel( "t5_weapon_ballistic_knife_blade" );
		retrievable_model SetTeam( player.team );
		retrievable_model SetOwner( player );
		retrievable_model.owner = player;
		retrievable_model.angles = angles;
		retrievable_model.name = watcher.weapon;
		retrievable_model.targetname = "sticky_weapon";

		if( IsDefined( prey ) )
		{
			//Don't stick to teammates and friendly dogs
			if( level.teamBased && isPlayer(prey) && player.team == prey.team )
				isFriendly = true;
			else if(level.teamBased && isAI(prey) && player.team == prey.aiTeam)
				isFriendly = true;

			if( !isFriendly )
			{
				if( IsAlive( prey ) )
				{
					retrievable_model dropToGround( retrievable_model.origin, 80 );
				}
				else
				{
					retrievable_model LinkTo( prey, bone );
				}
			}
			else if( isFriendly )
			{
				//launchVec = normal * -1;
				retrievable_model physicslaunch( normal, (randomint(10),randomint(10),randomint(10)) );

				//Since the impact normal is not what we want anymore, and the knife will fall to the ground, send the world up normal.
				normal = (0,0,1);
			}

		}

		watcher.objectArray[watcher.objectArray.size] = retrievable_model;

		//Wait until the model is stationary again
		if( isFriendly )
			retrievable_model waittill( "stationary");

		retrievable_model thread dropKnivesToGround();

		if ( isFriendly )
			player notify( "ballistic_knife_stationary", retrievable_model, normal );
		else
			player notify( "ballistic_knife_stationary", retrievable_model, normal, prey );

		retrievable_model thread wait_to_show_glowing_model( prey );
	}
}

wait_to_show_glowing_model( prey ) // self == retrievable_model
{
	level endon( "game_ended" );
	self endon( "death" );

	glowing_retrievable_model = Spawn( "script_model", self.origin );
	self.glowing_model = glowing_retrievable_model;
	glowing_retrievable_model.angles = self.angles;
	glowing_retrievable_model LinkTo( self );

	// we don't want to show the glowing retrievable model until the ragdoll finishes, this will keep the glow out of the kill cam
	if( IsDefined( prey ) && !IsAlive( prey ) )
	{
		wait( 2 );
	}

	glowing_retrievable_model SetModel( "t5_weapon_ballistic_knife_blade_retrieve" );
}

watch_shutdown() // self == retrievable_model
{
	pickUpTrigger = self.pickUpTrigger;
	otherTeamPickUpTrigger = self.otherTeamPickUpTrigger;
	glowing_model = self.glowing_model;

	self waittill( "death" );

	if( IsDefined( pickUpTrigger ) )
		pickUpTrigger delete();
	if( IsDefined( otherTeamPickUpTrigger ) )
		otherTeamPickUpTrigger delete();

	if( IsDefined( glowing_model  ) )
	{
		glowing_model delete();
	}
}

onSpawnRetrieveTrigger( watcher, player )
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );

	player waittill( "ballistic_knife_stationary", retrievable_model, normal, prey );

	if( !IsDefined( retrievable_model ) )
		return;

	vec_scale = 10;
	trigger_pos = [];
	if ( IsDefined( prey ) && ( isPlayer( prey ) || isAI( prey ) ) )
	{
		trigger_pos[0] = prey.origin[0];
		trigger_pos[1] = prey.origin[1];
		trigger_pos[2] = prey.origin[2] + vec_scale;
	}
	else
	{
		trigger_pos[0] = retrievable_model.origin[0] + (vec_scale * normal[0]);
		trigger_pos[1] = retrievable_model.origin[1] + (vec_scale * normal[1]);
		trigger_pos[2] = retrievable_model.origin[2] + (vec_scale * normal[2]);
	}
	pickup_trigger = Spawn( "trigger_radius_use", (trigger_pos[0], trigger_pos[1], trigger_pos[2]) );
	pickup_trigger SetCursorHint( "HINT_NOICON", watcher.weapon );
	pickup_trigger.owner = player;
	retrievable_model.pickUpTrigger = pickup_trigger;


	//retrievable_model thread debug_print( endpos );

	hint_string = &"MP_BALLISTIC_KNIFE_PICKUP";
	if( IsDefined( hint_string ) )
	{
		pickup_trigger SetHintString( hint_string );
	}
	else
	{
		pickup_trigger SetHintString( &"MP_GENERIC_PICKUP" );
	}


	//Check for FFA
	if( !level.teamBased )
		pickup_trigger SetTeamForTrigger( "none" );
	else
		pickup_trigger SetTeamForTrigger( player.team );

	//player ClientClaimTrigger( pickup_trigger );

	// link the model and trigger, then link them to the ragdoll if needed
	pickup_trigger EnableLinkTo();
	if ( IsDefined( prey ) )
		pickup_trigger LinkTo( prey );
	else
		pickup_trigger LinkTo( retrievable_model );

	retrievable_model thread watch_use_trigger( pickup_trigger, retrievable_model, ::pick_up, watcher.pickUpSoundPlayer, watcher.pickUpSound );

	//////////////////////////////////////////////
	// OTHER TEAM'S TRIGGER
	// the blade needs another trigger for the other team because anyone with a ballistic knife loadout can pick it up, no matter the team
	other_team_pickup_trigger = Spawn( "trigger_radius_use", (trigger_pos[0], trigger_pos[1], trigger_pos[2]) );
	other_team_pickup_trigger SetCursorHint( "HINT_NOICON" );
	retrievable_model.otherTeamPickUpTrigger = other_team_pickup_trigger;

	if( IsDefined( hint_string ) )
	{
		other_team_pickup_trigger SetHintString( hint_string );
	}
	else
	{
		other_team_pickup_trigger SetHintString( &"MP_GENERIC_PICKUP" );
	}

	// if we're team based then set the team on the trigger
	if ( level.teamBased )
	{
		other_team_pickup_trigger SetTeamForTrigger( GetOtherTeam( player.team ) );
	}
	else
	{
		other_team_pickup_trigger SetTeamForTrigger( "none" );
	}

	triggers = [];
	triggers[ "owner_pickup" ] = pickup_trigger;
	triggers[ "enemy_pickup" ] = other_team_pickup_trigger;
	triggers[ "glowing_model" ] = retrievable_model.glowing_model;

	retrievable_model thread watch_trigger_visibility( triggers, "knife_ballistic_mp" );
	retrievable_model thread watch_use_trigger( other_team_pickup_trigger, retrievable_model, ::pick_up, watcher.pickUpSoundPlayer, watcher.pickUpSound );
	retrievable_model thread watch_shutdown();
}

watch_trigger_visibility( triggers, weap_name ) // self == retrievable_model
{
	self notify( "watchTriggerVisibility" );
	self endon( "watchTriggerVisibility" );
	self endon( "death" );

	// need to add 1 to max ammo because the ballistic knife has a max ammo of 1 but can hold 1 in the clip and 1 in the stock
	//	there's something janky in the code so if we do 2 max ammo then players could pick up 3 and we only want them to have 2
	max_ammo = WeaponMaxAmmo( weap_name ) + 1;

	while( true )
	{
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			if( !IsAlive( players[i] ) )
			{
				wait( 0.05 );
				continue;
			}

			// make sure the player has the weapon
			if( players[i] HasWeapon( weap_name ) )
			{
				ammo_stock = players[i] GetWeaponAmmoStock( weap_name );
				ammo_clip = players[i] GetWeaponAmmoClip( weap_name );
				current_weapon = players[i] GetCurrentWeapon();
				total_ammo = ammo_stock + ammo_clip;
				
				// see if this player hasn't reloaded yet, we make this check so you can't pick it up before your stock ammo has updated
				//	if your stock ammo hasn't updated then you'll take it but you won't get it in your reserves, it just goes away
				hasReloaded = true;
				if( total_ammo > 0 && ammo_stock == total_ammo && current_weapon == "knife_ballistic_mp" )
				{
					hasReloaded = false;
				}

				// see if the player is the owner
				if( self.owner == players[i] )
				{
					// now we are the owner, if we have less than the max ammo then we should hide the enemy trigger so we can see the owner pick up trigger
					if( total_ammo < max_ammo && hasReloaded )
					{
						triggers[ "owner_pickup" ] SetVisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "glowing_model" ] SetVisibleToPlayer( players[i] );
					}
					// we are the owner, so if we have the max ammo already then hide the triggers
					else
					{
						triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "glowing_model" ] SetInvisibleToPlayer( players[i] );
					}
				}
				// we aren't the owner
				else
				{
					// now we aren't the owner, if we have less than the max ammo then we should show the enemy trigger and hide the owner trigger
					if( total_ammo < max_ammo && hasReloaded )
					{
						triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetVisibleToPlayer( players[i] );
						triggers[ "glowing_model" ] SetVisibleToPlayer( players[i] );
					}
					// we aren't the owner, so if we have the max ammo already then hide the triggers
					else
					{
						triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
						triggers[ "glowing_model" ] SetInvisibleToPlayer( players[i] );
					}
				}
			}
			// you don't have the weapon so hide the triggers
			else
			{
				triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
				triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
				triggers[ "glowing_model" ] SetInvisibleToPlayer( players[i] );
			}
		}

		wait( 0.05);
	}
}

debug_print( endpos )
{
	self endon( "death" );
	while( true )
	{
		Print3d( endpos, "pickup_trigger" );
		wait(0.05);
	}
}

watch_use_trigger( trigger, model, callback, playerSoundOnUse, npcSoundOnUse ) // self == retrievable_model
{
	self endon( "death" );
	self endon( "delete" );
	level endon ( "game_ended" );

	while ( true )
	{
		trigger waittill( "trigger", player );

		if ( !IsAlive( player ) )
			continue;

		if ( !player IsOnGround() )
			continue;

		if ( IsDefined( trigger.triggerTeam ) && ( player.team != trigger.triggerTeam ) )
			continue;

		if ( IsDefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;

		if ( player UseButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() )
		{
			if ( isdefined( playerSoundOnUse ) )
				player playLocalSound( playerSoundOnUse );
			if ( isdefined( npcSoundOnUse ) )
				player playSound( npcSoundOnUse );
			self thread [[callback]]( player );
			break;
		}
	}
}

pick_up( player ) // self == retrievable_model
{
	self destroy_ent();

	// if we're not currently on the ballistic knife and the clip is empty then put the ammo in the clip
	current_weapon = player GetCurrentWeapon();
	if( current_weapon != "knife_ballistic_mp" )
	{
		// if the clip is empty, fill it
		clip_ammo = player GetWeaponAmmoClip( "knife_ballistic_mp" );
		if( !clip_ammo )
		{
			player SetWeaponAmmoClip( "knife_ballistic_mp", 1 );
		}
		else
		{
			new_ammo_stock = player GetWeaponAmmoStock( "knife_ballistic_mp" ) + 1;
			player SetWeaponAmmoStock( "knife_ballistic_mp", new_ammo_stock );		
		}
	}
	else
	{
		new_ammo_stock = player GetWeaponAmmoStock( "knife_ballistic_mp" ) + 1;
		player SetWeaponAmmoStock( "knife_ballistic_mp", new_ammo_stock );		
	}
}

destroy_ent()
{
	if( IsDefined(self) )
	{
		pickUpTrigger = self.pickUpTrigger;
		otherTeamPickUpTrigger = self.otherTeamPickUpTrigger;

		if( IsDefined( pickUpTrigger ) )
			pickUpTrigger delete();
		if( IsDefined( otherTeamPickUpTrigger ) )
			otherTeamPickUpTrigger delete();

		if( IsDefined( self.glowing_model  ) )
		{
			self.glowing_model delete();
		}

		self delete();
	}
}

dropKnivesToGround()
{
	self endon("death");

	for( ;; )
	{
		level waittill( "drop_objects_to_ground", origin, radius );
		self dropToGround( origin, radius );
	}
}

dropToGround( origin, radius )
{
	if( DistanceSquared( origin, self.origin )< radius * radius )
	{
		self physicslaunch( (0,0,1), (5,5,5));
		self thread updateRetrieveTrigger();
	}
}

updateRetrieveTrigger()
{
	self endon("death");

	self waittill( "stationary");

	trigger = self.pickUpTrigger;

	trigger.origin = ( self.origin[0], self.origin[1], self.origin[2] + 10 );
	trigger LinkTo( self );
}