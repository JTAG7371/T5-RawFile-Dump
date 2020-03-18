#include clientscripts\mp\_utility_code;

/*
=============
///ScriptDocBegin
"Name: getstructarray( <name> , <type )"
"Summary: gets an array of script_structs"
"Module: Array"
"CallOn: An entity"
"MandatoryArg: <name>: "
"MandatoryArg: <type>: "
"Example: fxemitters = getstructarray( "streetlights" , "targetname" )"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

error( message )
{
	println( "^c * ERROR * ", message );
	wait 0.05;
 }

// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to( IE: can't do 5.struct_array_index ) 
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object



getstruct( name, type )
{
	if(!isdefined( level.struct_class_names ) )
		return undefined;
	
	array = level.struct_class_names[ type ][ name ];
	if( !IsDefined( array ) )
	{
		println("**** Getstruct returns undefined on " + name + " : " + " type.");
		return undefined; 
	}

	if( array.size > 1 )
	{
		assertMsg( "getstruct used for more than one struct of type " + type + " called " + name + "." );
		return undefined; 
	}
	return array[ 0 ];
}

getstructarray( name, type )
{
	assertEx( isdefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

	array = level.struct_class_names[type][name]; 
	if(!isdefined( array ) )
	{
		return []; 
	}
	else
	{
		return array; 
	}
}

 /* 
 ============= 
///ScriptDocBegin
"Name: play_sound_in_space( <clientNum>, <alias> , <origin>  )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: Level"
"MandatoryArg: <clientNum> : local client to hear the sound."
"MandatoryArg: <alias> : Sound alias to play"
"MandatoryArg: <origin> : Origin of the sound"
"Example: play_sound_in_space( "siren", level.speaker.origin );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
play_sound_in_space( localClientNum, alias, origin)
{
	PlaySound( localClientNum, alias, origin); 
}

//-- Vectors --//

vector_compare(vec1, vec2)
{
	return (abs(vec1[0] - vec2[0]) < .001) && (abs(vec1[1] - vec2[1]) < .001) && (abs(vec1[2] - vec2[2]) < .001);
}

vector_scale(vec, scale)
{
	vec = (vec * scale);
	return vec;
}

vector_multiply( vec, vec2 )
{
	vec = (vec * vec2);

	return vec;
}

/* 
============= 
///ScriptDocBegin
"Name: array_func( <array>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
"Summary: Runs the < func > function on every entity in the < array > array. The item will become "self" in the specified function. Each item is run through the function sequentially."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : array of entities to run through <func>"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: array_func( GetAIArray( "allies" ), ::set_ignoreme, false );"
"SPMP: sp"
///ScriptDocEnd
============= 
*/ 
array_func(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	if (!IsDefined( entities ))
	{
		return;
	}

	if (IsArray(entities))
	{
		if (entities.size)
		{
			keys = GetArrayKeys( entities );
			for (i = 0; i < keys.size; i++)
			{
				single_func(entities[keys[i]], func, arg1, arg2, arg3, arg4, arg5);
			}
		}
	}
	else
	{
		single_func(entities, func, arg1, arg2, arg3, arg4, arg5);
	}
}


/* 
============= 
///ScriptDocBegin
"Name: single_func( <entity>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
"Summary: Runs the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: "
"MandatoryArg: <entity> : the entity to run through <func>"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: single_func( guy, ::set_ignoreme, false );"
"SPMP: sp"
///ScriptDocEnd
============= 
*/ 
single_func(entity, func, arg1, arg2, arg3, arg4, arg5)
{
	if (IsDefined(arg5))
	{
		entity [[ func ]](arg1, arg2, arg3, arg4, arg5);
	}
	else if (IsDefined(arg4))
	{
		entity [[ func ]](arg1, arg2, arg3, arg4);
	}
	else if (IsDefined(arg3))
	{
		entity [[ func ]](arg1, arg2, arg3);
	}
	else if (IsDefined(arg2))
	{
		entity [[ func ]](arg1, arg2);
	}
	else if (IsDefined(arg1))
	{
		entity [[ func ]](arg1);
	}
	else
	{
		entity [[ func ]]();
	}
}


/* 
============= 
///ScriptDocBegin
"Name: array_thread( <entities> , <func> , <arg1> , <arg2> , <arg3> )"
"Summary: Threads the < func > function on every entity in the < entities > array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities> : array of entities to thread the process"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: array_thread( GetAIArray( "allies" ), ::set_ignoreme, false );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_thread( entities, func, arg1, arg2, arg3, arg4, arg5 )
{
	if (!IsDefined( entities ))
	{
		return;
	}

	if (IsArray(entities))
	{
		if (entities.size)
		{
			keys = GetArrayKeys( entities );
			for (i = 0; i < keys.size; i++)
			{
				single_thread(entities[keys[i]], func, arg1, arg2, arg3, arg4, arg5);
			}
		}
	}
	else
	{
		single_thread(entities, func, arg1, arg2, arg3, arg4, arg5);
	}
}


/* 
============= 
///ScriptDocBegin
"Name: single_thread( <entity>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
"Summary: Threads the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: "
"MandatoryArg: <entity> : the entity to thread <func> on"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"Example: single_func( guy, ::special_ai_think, "some_string", 345 );"
"SPMP: sp"
///ScriptDocEnd
============= 
*/ 
single_thread(entity, func, arg1, arg2, arg3, arg4, arg5)
{
	if (IsDefined(arg5))
	{
		entity thread [[ func ]](arg1, arg2, arg3, arg4, arg5);
	}
	else if (IsDefined(arg4))
	{
		entity thread [[ func ]](arg1, arg2, arg3, arg4);
	}
	else if (IsDefined(arg3))
	{
		entity thread [[ func ]](arg1, arg2, arg3);
	}
	else if (IsDefined(arg2))
	{
		entity thread [[ func ]](arg1, arg2);
	}
	else if (IsDefined(arg1))
	{
		entity thread [[ func ]](arg1);
	}
	else
	{
		entity thread [[ func ]]();
	}
}

registerSystem(sSysName, cbFunc)
{
	if(!isdefined(level._systemStates))
	{
		level._systemStates = [];
	}
	
	if(level._systemStates.size >= 32)	
	{
		error("Max num client systems exceeded.");
		return;
	}
	
	if(isdefined(level._systemStates[sSysName]))
	{
		error("Attempt to re-register client system : " + sSysName);
		return;
	}
	else
	{
		level._systemStates[sSysName] = spawnstruct();
		level._systemStates[sSysName].callback = cbFunc;
	}	
}

loop_sound_Delete( ender, entId )
{
//	ent endon( "death" ); 
	self waittill( ender ); 
	deletefakeent(0, entId); 
}

loop_fx_sound( clientNum, alias, origin, ender )
{
	entId = spawnfakeent(clientNum);

	if( IsDefined( ender ) )
	{
		thread loop_sound_Delete( ender, entId ); 
		self endon( ender ); 
	}
	
	setfakeentorg(clientNum, entId, origin);
	playloopsound( clientNum, entId, alias ); 
}

waitforallclients()
{
	localClient = 0;
	while (localClient < getlocalplayers().size)
	{
		waitforclient(localClient);
		localClient++;
	}
}

// this function will stall until the client has received a snapshot
waitforclient(client)
{
	while(!clienthassnapshot(client))
	{
		wait(0.01);
	}
}

waittill_string( msg, ent )
{
	if ( msg != "death" )
		self endon ("death");

	ent endon ( "die" );
	self waittill ( msg );
	ent notify ( "returned", msg );
}

waittill_dobj(localClientNum)
{
	while( isdefined( self ) && !(self hasdobj(localClientNum)) )
	{
		wait(0.01);
	}
}

/*
=============
///ScriptDocBegin
"Name: waittill_any_return( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for any of the the specified notifies and return which one it got."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: which_notify = guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
waittill_any_return( string1, string2, string3, string4, string5, string6 )
{
	if ((!IsDefined (string1) || string1 != "death") &&
		(!IsDefined (string2) || string2 != "death") &&
		(!IsDefined (string3) || string3 != "death") &&
		(!IsDefined (string4) || string4 != "death") &&
		(!IsDefined (string5) || string5 != "death") &&
		(!IsDefined (string6) || string6 != "death"))
		self endon ("death");

	ent = SpawnStruct();

	if (IsDefined(string1))
		self thread waittill_string(string1, ent);

	if (IsDefined(string2))
		self thread waittill_string(string2, ent);

	if (IsDefined(string3))
		self thread waittill_string(string3, ent);

	if (IsDefined(string4))
		self thread waittill_string(string4, ent);

	if (IsDefined(string5))
		self thread waittill_string(string5, ent);

	if (IsDefined(string6))
		self thread waittill_string(string6, ent);

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

/*
=============
///ScriptDocBegin
"Name: waittill_any( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for any of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
waittill_any( string1, string2, string3, string4, string5 )
{
	assert( IsDefined( string1 ) );

	if ( IsDefined( string2 ) )
		self endon( string2 );

	if ( IsDefined( string3 ) )
		self endon( string3 );

	if ( IsDefined( string4 ) )
		self endon( string4 );

	if ( IsDefined( string5 ) )
		self endon( string5 );

	self waittill( string1 );
}

/* 
 ============= 
///CScriptDocBegin
"Name: within_fov( <start_origin> , <start_angles> , <end_origin> , <fov> )"
"Summary: Returns true if < end_origin > is within the players field of view, otherwise returns false."
"Module: Vector"
"CallOn: "
"MandatoryArg: <start_origin> : starting origin for FOV check( usually the players origin )"
"MandatoryArg: <start_angles> : angles to specify facing direction( usually the players angles )"
"MandatoryArg: <end_origin> : origin to check if it's in the FOV"
"MandatoryArg: <fov> : cosine of the FOV angle to use"
"Example: qBool = within_fov( level.player.origin, level.player.angles, target1.origin, cos( 45 ) );"
"SPMP: singleplayer"
///CScriptDocEnd
 ============= 
 */ 
within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = VectorNormalize( end_origin - start_origin ); 
	forward = AnglesToForward( start_angles ); 
	dot = VectorDot( forward, normal ); 

	return dot >= fov; 
}


/* 
============= 
///CScriptDocBegin
"Name: add_to_array( <array> , <ent> )"
"Summary: Adds < ent > to < array > and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : The array to add < ent > to."
"MandatoryArg: <ent> : The entity to be added."
"Example: nodes = add_to_array( nodes, new_node );"
"SPMP: singleplayer"
///CScriptDocEnd
============= 
*/ 
add_to_array( array, ent )
{
	if( !IsDefined( ent ) )
		return array; 

	if( !IsDefined( array ) )
		array[ 0 ] = ent;
	else
		array[ array.size ] = ent;

	return array; 
}

setFootstepEffect(name, fx)
{
	assertEx(isdefined(name), "Need to define the footstep surface type.");
	assertEx(isdefined(fx), "Need to define the " + name + " effect.");
	if (!isdefined(level._optionalStepEffects))
		level._optionalStepEffects = [];
	level._optionalStepEffects[level._optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
}

add_trigger_to_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	
	ent._triggers[trig getentitynumber()] = 1;
}

remove_trigger_from_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
		return;
		
	if(!isdefined(ent._triggers[trig getentitynumber()]))
		return;
		
	ent._triggers[trig getentitynumber()] = 0;
}

ent_already_in_trigger(trig)
{
	if(!isdefined(self._triggers))
		return false;
		
	if(!isdefined(self._triggers[trig getentitynumber()]))
		return false;
		
	if(!self._triggers[trig getentitynumber()])
		return false;
		
	return true;	// We're already in this trigger volume.
}

trigger_thread(ent, on_enter_payload, on_exit_payload)
{
	ent endon("entityshutdown");
	
	if(ent ent_already_in_trigger(self))
		return;
		
	add_trigger_to_ent(ent, self);

//	iprintlnbold("Trigger " + self.targetname + " hit by ent " + ent getentitynumber());
	
	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	
	while(isdefined(ent) && ent istouching(self))
	{
		wait(0.01);
	}

//	iprintlnbold(ent getentitynumber() + " leaves trigger " + self.targetname + ".");

	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}

	if(isdefined(ent))
	{
		remove_trigger_from_ent(ent, self);
	}
}

realWait(seconds) //wait is time based off off 1/60 * number of frames not real time.
{
	if ( !isdefined( level.realTime ) )
		level thread realWaitSetTime();

	start = level.realTime;

	while(level.realTime - start < seconds * 1000)
	{
		wait(.01);
	}
}

realWaitSetTime()
{
	level notify( "realWaitSetTime" );
	level endon( "realWaitSetTime" );
	for( ;; )
	{
		level.realTime = GetRealTime();
		wait(.01);	
	}

}

random( array )
{
	return array [ randomint( array.size ) ];
}

friendNotFoe( localClientIndex )
{
	team = GetLocalPlayerTeam(localClientIndex);
	
	// using the player team to determine team base games
	if ( team == "free" )
	{
		player = GetLocalPlayer(localClientIndex);
		if ( IsDefined(player) && self getowner(localClientIndex) == player )
			return true;
	}
	else if ( self.team == team )
	{
		return true;
	}
	
	return false;
}

local_player_entity_thread( localClientNum, entity, func, arg1, arg2, arg3, arg4 )
{
	entity endon("entityshutdown");
	
	entity waittill_dobj( localClientNum );
	
	single_thread(entity, func, localClientNum, arg1, arg2, arg3, arg4);
}

/* 
============= 
///ScriptDocBegin
"Name: local_players_entity_thread( <entity> , <func> , <arg1> , <arg2> , <arg3>, <arg4> )"
"Summary: Threads the < func > function on entity on all local players when the dobj becomes valid. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: <entity> : entity to thread the process"
"MandatoryArg: <func> : pointer to a script function.  Function must have the first parameter of localCientNum"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"Example: local_players_entity_thread( chopper, ::spawn_fx );"
"SPMP: mp"
///ScriptDocEnd
============= 
*/ 
local_players_entity_thread( entity, func, arg1, arg2, arg3, arg4 )
{
	players = GetLocalPlayers();
	for (i = 0; i < players.size; i++)
	{
		players[i] thread local_player_entity_thread( i, entity, func, arg1, arg2, arg3, arg4 );
	}
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

getDvarIntDefault( dvarName, defaultValue)
{
	returnVal = defaultValue;	
	if (getDvar(dvarName) != "")
	{
		return getDvarInt(dvarName);
	}	
	return returnVal;
}	

debug_line( from, to, color, time )
{
/#
	level.debug_line = getDvarIntDefault( #"scr_debug_line", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.debug_line ) && level.debug_line == 1.0 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		Line( from, to, color, 1, 1, time);
	}
#/

}

debug_star( origin, color, time )
{
/#
	level.debug_star = getDvarIntDefault( #"scr_debug_star", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.debug_star ) && level.debug_star == 1.0 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		if ( !IsDefined(color) )
		{
			color = (1,1,1);
		}
		debugstar( origin, time, color );
	}
#/
}

