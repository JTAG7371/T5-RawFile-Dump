//-- Arrays --//

/*
============= 
///ScriptDocBegin
"Name: array( a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z )"
"Module: Array"
"Summary: Returns an array containing all values passed in."
"OptionalArg: Takes up to 26 arguments."
"Example: my_array = array(guy1, guy2, guy19);"
"SPMP: both"
///ScriptDocEnd
============= 
*/
array(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
{
	array = [];
	if ( IsDefined( a ) ) array[ 0] = a; else return array;
	if ( IsDefined( b ) ) array[ 1] = b; else return array;
	if ( IsDefined( c ) ) array[ 2] = c; else return array;
	if ( IsDefined( d ) ) array[ 3] = d; else return array;
	if ( IsDefined( e ) ) array[ 4] = e; else return array;
	if ( IsDefined( f ) ) array[ 5] = f; else return array;
	if ( IsDefined( g ) ) array[ 6] = g; else return array;
	if ( IsDefined( h ) ) array[ 7] = h; else return array;
	if ( IsDefined( i ) ) array[ 8] = i; else return array;
	if ( IsDefined( j ) ) array[ 9] = j; else return array;
	if ( IsDefined( k ) ) array[10] = k; else return array;
	if ( IsDefined( l ) ) array[11] = l; else return array;
	if ( IsDefined( m ) ) array[12] = m; else return array;
	if ( IsDefined( n ) ) array[13] = n; else return array;
	if ( IsDefined( o ) ) array[14] = o; else return array;
	if ( IsDefined( p ) ) array[15] = p; else return array;
	if ( IsDefined( q ) ) array[16] = q; else return array;
	if ( IsDefined( r ) ) array[17] = r; else return array;
	if ( IsDefined( s ) ) array[18] = s; else return array;
	if ( IsDefined( t ) ) array[19] = t; else return array;
	if ( IsDefined( u ) ) array[20] = u; else return array;
	if ( IsDefined( v ) ) array[21] = v; else return array;
	if ( IsDefined( w ) ) array[22] = w; else return array;
	if ( IsDefined( x ) ) array[23] = x; else return array;
	if ( IsDefined( y ) ) array[24] = y; else return array;
	if ( IsDefined( z ) ) array[25] = z;
	return array;
}

/* 
============= 
///ScriptDocBegin
"Name: add_to_array( <array> , <item>, <allow_dupes> )"
"Summary: Adds <item> to <array> and returns the new array.  Will not add the new value if undefined."
"Module: Array"
"CallOn: "
"MandatoryArg:	<array> The array to add <item> to."
"MandatoryArg:	<item> The item to be added. This can be anything."
"OptionalArg:	<allow_dupes> If true, will not add the new value if it already exists."
"Example: nodes = add_to_array( nodes, new_node );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
add_to_array( array, item, allow_dupes )
{
	if( !IsDefined( item ) )
	{
		return array; 
	}

	if (!IsDefined(allow_dupes))
	{
		allow_dupes = true;
	}

	if( !IsDefined( array ) )
	{
		array[ 0 ] = item;
	}
	else if (allow_dupes || !is_in_array(array, item))
	{
		array[ array.size ] = item;
	}

	return array; 
}

/*
=============
///ScriptDocBegin
"Name: array_add( <array>, <item> )"
"Summary: Returns a new array of <array> with <item> added to it."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> The array to add <item> to."
"MandatoryArg: <item> The item (or anything) to add to <array>."
"Example: my_new_array = array_add( my_array, my_new_thing_to_put_in_array );"
"SPMP: both"
///ScriptDocEnd
=============
*/

array_add( array, item )
{
	array[ array.size ] = item;
	return array; 
}

/* 
============= 
///ScriptDocBegin
"Name: array_delete( <array> )"
"Summary: Delete all the elements in an array"
"Module: Array"
"MandatoryArg: <array> : The array whose elements to delete."
"Example: array_delete( GetAIArray( "axis" ) );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_delete( array )
{
	for( i = 0; i < array.size; i++ )
	{
		if(isDefined(array[i]))
		{
			array[ i ] delete();
		}
	}
}

/* 
============= 
///ScriptDocBegin
"Name: array_randomize( <array> )"
"Summary: Randomizes the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array to be randomized."
"Example: roof_nodes = array_randomize( roof_nodes );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_randomize( array )
{
	for( i = 0; i < array.size; i++ )
	{
		j = RandomInt( array.size ); 
		temp = array[ i ];
		array[ i ] = array[ j ];
		array[ j ] = temp;
	}

	return array; 
}

/*
============= 
///ScriptDocBegin
"Name: array_reverse( <array> )"
"Summary: Reverses the order of the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array to be reversed."
"Example: patrol_nodes = array_reverse( patrol_nodes );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_reverse( array )
{
	array2 = [];
	for( i = array.size - 1; i >= 0; i-- )
	{
		array2[ array2.size ] = array[ i ];
	}

	return array2;
}

/* 
============= 
///ScriptDocBegin
"Name: array_removeUndefined( <array> )"
"Summary: Returns a new array of < array > minus the undefined indicies"
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : The array to search for undefined indicies in."
"Example: ents = array_removeUndefined( ents );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_removeUndefined( array )
{
	newArray = []; 
	for( i = 0; i < array.size; i++ )
	{
		if( !IsDefined( array[ i ] ) )
		{
			continue; 
		}
		newArray[ newArray.size ] = array[ i ];
	}

	return newArray; 
}

/* 
============= 
///ScriptDocBegin
"Name: array_insert( <array> , <object> , <index> )"
"Summary: Returns a new array of < array > plus < object > at the specified index"
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : The array to add to."
"MandatoryArg: <object> : The entity to add"
"MandatoryArg: <index> : The index position < object > should be added to."
"Example: ai = array_insert( ai, spawned, 0 );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_insert( array, object, index )
{
	if( index == array.size )
	{
		temp = array; 
		temp[ temp.size ] = object;
		return temp; 
	}
	temp = []; 
	offset = 0; 
	for( i = 0; i < array.size; i++ )
	{
		if( i == index )
		{
			temp[ i ] = object;
			offset = 1; 
		}
		temp[ i + offset ] = array[ i ];
	}

	return temp; 
}

/* 
============= 
///ScriptDocBegin
"Name: array_remove( <ents> , <remover> )"
"Summary: Returns < ents > array minus < remover > "
"Module: Array"
"CallOn: "
"MandatoryArg: <ents> : array to remove < remover > from"
"MandatoryArg: <remover> : entity to remove from the array"
"Example: ents = array_remove( ents, guy );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_remove( ents, remover, keepArrayKeys )
{
	newents = []; 
	// if this array is a simple numbered array - array keys will return the array in a reverse order
	// causing the array that is returned from this function to be flipped, that is an un expected 
	// result, which is why we're counting down in the for loop instead of the usual counting up
	keys = getArrayKeys( ents );

	//GLocke 2/28/08 - added ability to keep array keys from previous array
	if(IsDefined(keepArrayKeys))
	{
		for( i = keys.size - 1; i >= 0; i-- )
		{
			if( ents[ keys[ i ] ] != remover )
			{
				newents[ keys[i] ] = ents[ keys[ i ] ];
			}
		}

		return newents;
	}

	// Returns array with index of ints
	for( i = keys.size - 1; i >= 0; i-- )
	{
		if( ents[ keys[ i ] ] != remover )
		{
			newents[ newents.size ] = ents[ keys[ i ] ];
		}
	}

	return newents; 
}

array_remove_nokeys( ents, remover )
{
	newents = [];
	for ( i = 0; i < ents.size; i++ )
	{
		if( ents[ i ] != remover )
		{
			newents[ newents.size ] = ents[ i ];
		}
	}
	return newents;
}

array_remove_index( array, index )
{
	newArray = [];
	keys = getArrayKeys( array );
	for( i = ( keys.size - 1 );i >= 0 ; i-- )
	{
		if( keys[ i ] != index )
		{
			newArray[ newArray.size ] = array[ keys[ i ] ];
		}
	}

	return newArray;
}

/* 
============= 
///ScriptDocBegin
"Name: array_combine( <array1> , <array2> )"
"Summary: Combines the two arrays and returns the resulting array. This function doesn't care if it produces duplicates in the array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array1> : first array"
"MandatoryArg: <array2> : second array"
"Example: combinedArray = array_combine( array1, array2 );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_combine( array1, array2 )
{
	if( !array1.size )
	{
		return array2; 
	}

	array3 = [];

	keys = GetArrayKeys( array1 );
	for( i = 0;i < keys.size;i++ )
	{
		key = keys[ i ];
		array3[ array3.size ] = array1[ key ]; 
	}	

	keys = GetArrayKeys( array2 );
	for( i = 0;i < keys.size;i++ )
	{
		key = keys[ i ];
		array3[ array3.size ] = array2[ key ];
	}

	return array3; 
}

/* 
============= 
///ScriptDocBegin
"Name: array_merge( <array1> , <array2> )"
"Summary: Combines the two arrays and returns the resulting array. Adds only things that are new to the array, no duplicates."
"Module: Array"
"CallOn: "
"MandatoryArg: <array1> : first array"
"MandatoryArg: <array2> : second array"
"Example: combinedArray = array_merge( array1, array2 );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_merge( array1, array2 )// adds only things that are new to the array
{
	if( array1.size == 0 )
	{
		return array2; 
	}
	if( array2.size == 0 )
	{
		return array1; 
	}
	newarray = array1; 
	for( i = 0;i < array2.size;i++ )
	{
		foundmatch = false; 
		for( j = 0;j < array1.size;j++ )
		{
			if( array2[ i ] == array1[ j ] )
			{
				foundmatch = true; 
				break; 
			}
		}
		if( foundmatch )
		{
			continue; 
		}
		else
		{
			newarray[ newarray.size ] = array2[ i ];
		}
	}
	return newarray; 
}

/* 
============= 
///ScriptDocBegin
"Name: array_exclude( <array> , <arrayExclude> )"
"Summary: Returns an array excluding all members of < arrayExclude > "
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array containing all items"
"MandatoryArg: <arrayExclude> : Array containing all items to remove or individual entity"
"Example: newArray = array_exclude( array1, array2 );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
array_exclude( array, arrayExclude )// returns "array" minus all members of arrayExclude
{
	newarray = array;
	
	if( IsArray( arrayExclude ) )
	{
		for( i = 0;i < arrayExclude.size;i++ )
		{
			if( is_in_array( array, arrayExclude[ i ] ) )
			{
				newarray = array_remove( newarray, arrayExclude[ i ] );
			}
		}
	}
	else
	{
			if( is_in_array( array, arrayExclude ) )
			{
				newarray = array_remove( newarray, arrayExclude );
			}
  }
  
	return newarray;
}

/*
=============
///ScriptDocBegin
"Name: array_notify( <array>, <notify> )"
"Summary: Sends a notify to every element within the array"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <notify>: the string notify sent to the elements"
"Example: array_notify( soldiers, "fire" );"
"SPMP: both"
///ScriptDocEnd
=============
*/
array_notify( ents, notifier )
{
	for( i = 0;i < ents.size;i++ )
	{
		ents[ i ] notify( notifier );
	}
}

/*
=============
///ScriptDocBegin
"Name: array_wait( <array>, <msg>, <timeout> )"
"Summary: waits for every entry in the <array> to recieve the <msg> notify, die, or timeout"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <msg>: the msg each array entity will wait on"
"OptionalArg: <timeout>: timeout to kill the wait prematurely"
"Example: array_wait( guys, "at the hq" );"
"SPMP: both"
///ScriptDocEnd
=============
*/
array_wait(array, msg, timeout)
{	
	keys = getarraykeys(array);	
	structs = [];

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		structs[ key ] = spawnstruct();
		structs[ key ]._array_wait = true;	

		structs[ key ] thread array_waitlogic1( array[ key ], msg, timeout );
	}

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		if( IsDefined( array[ key ] ) && structs[ key ]._array_wait)
		{
			structs[ key ] waittill( "_array_wait" );	
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: array_wait_any( <array>, <msg>, <timeout> )"
"Summary: waits for any entry in the <array> to recieve the <msg> notify, die, or timeout"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <msg>: the msg each array entity will wait on"
"OptionalArg: <timeout>: timeout to kill the wait prematurely"
"Example: array_wait_any( guys, "at the hq" );"
"SPMP: both"
///ScriptDocEnd
=============
*/
array_wait_any(array, msg, timeout)
{
	if (array.size == 0)
	{
		return undefined;
	}

	keys = getarraykeys(array);	
	structs = [];

	internal_msg = msg + "array_wait";

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		structs[ key ] = spawnstruct();
		structs[ key ]._array_wait = true;	
		structs[ key ] thread array_waitlogic3( array[ key ], msg, internal_msg, timeout );
	}

	level waittill(internal_msg, ent);

	return ent;
}

array_waitlogic1( ent, msg, timeout )
{
	self array_waitlogic2( ent, msg, timeout );	

	self._array_wait = false;
	self notify( "_array_wait" );
}

array_waitlogic2( ent, msg, timeout )
{
	ent endon( msg );
	ent endon( "death" );

	if( isdefined( timeout ) )
	{
		wait timeout;
	}
	else
	{
		ent waittill( msg );
	}
}

array_waitlogic3(ent, msg, internal_msg, timeout) // self = struct
{
	//GLocke 3.21.2010 Special case if waiting on "death"
	if(msg !="death")
	{
		ent endon("death");
	}	
	level endon(internal_msg);
	
	self array_waitlogic2(ent, msg, timeout);
	level notify(internal_msg, ent);
}

// MikeD (3/20/2007): Checks the array if the "single" already exists, if so it returns false.
array_check_for_dupes( array, single )
{
	for( i = 0; i < array.size; i++ )
	{
		if( array[i] == single )
		{
			return false;
		}
	}

	return true;
}

// Lucas (5/22/2008) added an array_swap for easy quicksorting
array_swap( array, index1, index2 )
{
	assertEx( index1 < array.size, "index1 to swap out of range" );
	assertEx( index2 < array.size, "index2 to swap out of range" );

	temp = array[index1];
	array[index1] = array[index2];
	array[index2] = temp;

	return array;
}

/*
=============
///ScriptDocBegin
"Name: array_average( <array> )"
"Summary: Given an array of numbers, returns the average (mean) value of the array"
"Module: Utility"
"MandatoryArg: <array>: the array of numbers which will be averaged"
"Example: array_average( numbers );"
"SPMP: both"
///ScriptDocEnd
=============
*/
array_average( array )
{
	assert( IsArray( array ) );
	assert( array.size > 0 );

	total = 0;

	for ( i = 0; i < array.size; i++ )
	{
		total += array[i];
	}

	return ( total / array.size );
}

/*
=============
///ScriptDocBegin
"Name: array_std_deviation( <array>, <mean> )"
"Summary: Given an array of numbers and the average of the array, returns the standard deviation value of the array"
"Module: Utility"
"MandatoryArg: <array>: the array of numbers"
"MandatoryArg: <mean>: the average (mean) value of the array"
"Example: array_std_deviation( numbers, avg );"
"SPMP: both"
///ScriptDocEnd
=============
*/
array_std_deviation( array, mean )
{
	assert( IsArray( array ) );
	assert( array.size > 0 );

	tmp = [];
	for ( i = 0; i < array.size; i++ )
	{
		tmp[i] = ( array[i] - mean ) * ( array[i] - mean );
	}

	total = 0;
	for ( i = 0; i < tmp.size; i++ )
	{
		total = total + tmp[i];
	}

	return Sqrt( total / array.size );
}

/*
=============
///ScriptDocBegin
"Name: random_normal_distribution( <mean>, <std_deviation>, <lower_bound>, <upper_bound> )"
"Summary: Given the mean and std deviation of a set of numbers, returns a random number from the normal distribution"
"Module: Utility"
"MandatoryArg: <mean>: the average (mean) value of the array"
"MandatoryArg: <std_deviation>: the standard deviation value of the array"
"OptionalArg: <lower_bound> the minimum value that will be returned"
"OptionalArg: <upper_bound> the maximum value that will be returned"
"Example: random_normal_distribution( avg, std_deviation );"
"SPMP: both"
///ScriptDocEnd
=============
*/
random_normal_distribution( mean, std_deviation, lower_bound, upper_bound )
{
	//pixbeginevent( "random_normal_distribution" );

	// implements the Box-Muller transform for Gaussian random numbers (http://en.wikipedia.org/wiki/Box-Muller_transform)
	x1 = 0;
	x2 = 0;
	w = 1;
	y1 = 0;

	while ( w >= 1 )
	{
		x1 = 2 * RandomFloatRange( 0, 1 ) - 1;
		x2 = 2 * RandomFloatRange( 0, 1 ) - 1;
		w = x1 * x1 + x2 * x2;
	}

	w = Sqrt( ( -2.0 * Log( w ) ) / w );
	y1 = x1 * w;

	number = mean + y1 * std_deviation;

	if ( IsDefined( lower_bound ) && number < lower_bound )
	{
		number = lower_bound;
	}

	if ( IsDefined( upper_bound ) && number > upper_bound )
	{
		number = upper_bound;
	}

	//pixendevent();

	return( number );
}

/* 
============= 
///ScriptDocBegin
"Name: random( <array> )"
"Summary: returns a random element from the passed in array "
"Module: Array"
"Example: random_spawner = random( event_1_spawners );"
"MandatoryArg: <array> : the array from which to pluck a random element"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
random( array )
{
	keys = GetArrayKeys(array);
	return array[ keys[RandomInt( keys.size )] ];
}

/* 
============= 
///ScriptDocBegin
"Name: is_in_array( <aeCollection> , <eFindee> )"
"Summary: Returns true if < eFindee > is an entity in array < aeCollection > . False if it is not. "
"Module: Array"
"CallOn: "
"MandatoryArg: <aeCollection> : array of entities to search through"
"MandatoryArg: <eFindee> : entity to check if it's in the array"
"Example: qBool = is_in_array( eTargets, vehicle1 );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
is_in_array( aeCollection, eFindee )
{
	for( i = 0; i < aeCollection.size; i++ )
	{
		if( aeCollection[ i ] == eFindee )
		{
			return( true ); 
		}
	}

	return( false ); 
}

//-- Vectors --//

/* 
============= 
///ScriptDocBegin
"Name: vector_compare( <vec1>, <vec2> )"
"Summary: For 3D vectors.  Returns true if the vectors are the same"
"MandatoryArg: <vec1> : A 3D vector (origin)"
"MandatoryArg: <vec2> : A 3D vector (origin)"
"Example: if (vector_compare(self.origin, node.origin){print(\"yay, i'm on the node!\");}"
"SPMP: both"
///ScriptDocEnd
============= 
*/
vector_compare(vec1, vec2)
{
	return (abs(vec1[0] - vec2[0]) < .001) && (abs(vec1[1] - vec2[1]) < .001) && (abs(vec1[2] - vec2[2]) < .001);
}

/* 
============= 
///ScriptDocBegin
"Name: vector_scale( <vec>, <scale> )"
"Summary: Scale a vector by a scalar value."
"Module: Vector"
"Example: new_vector = vector_scale( vec, 10 ); // scale the vector by 10"
"MandatoryArg: <vec>"
"MandatoryArg: <scale>"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
vector_scale(vec, scale)
{
	vec = (vec * scale);
	return vec;
}

/* 
============= 
///ScriptDocBegin
"Name: vector_multiply( <vec>, <vec2> )"
"Summary: Multiplies 2 vectors together."
"Module: Vector"
"Example: new_vector = vector_multiply( vector1, vector2 );"
"MandatoryArg: <vec>"
"MandatoryArg: <dif>"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
vector_multiply( vec, vec2 )
{
	vec = (vec * vec2);

	return vec;
}

//-- Other / Unsorted --//

draw_debug_line(start, end, timer)
{
	for (i=0;i<timer*20;i++)
	{
		line (start, end, (1,1,0.5));
		wait (0.05);
	}
}

waittillend(msg)
{
	self waittillmatch (msg, "end");
}

randomvector(num)
{
	return (RandomFloat(num) - num*0.5, RandomFloat(num) - num*0.5,RandomFloat(num) - num*0.5);
}

angle_dif(oldangle, newangle)
{
	// returns the difference between two yaws
	if (oldangle == newangle)
		return 0;
	
	while (newangle > 360)
		newangle -=360;
	
	while (newangle < 0)
		newangle +=360;
	
	while (oldangle > 360)
		oldangle -=360;
	
	while (oldangle < 0)
		oldangle +=360;
	
	olddif = undefined;
	newdif = undefined;
	
	if (newangle > 180)
		newdif = 360 - newangle;
	else
		newdif = newangle;
	
	if (oldangle > 180)
		olddif = 360 - oldangle;
	else
		olddif = oldangle;
	
	outerdif = newdif + olddif;
	innerdif = 0;
	
	if (newangle > oldangle)
		innerdif = newangle - oldangle;
	else
		innerdif = oldangle - newangle;
	
	if (innerdif < outerdif)
		return innerdif;
	else
		return outerdif;
}

sign( x )
{
	if ( x >= 0 )
		return 1;
	return -1;
}


track(spot_to_track)
{
	if(IsDefined(self.current_target))
	{
		if(spot_to_track == self.current_target)
			return;	
	}
	self.current_target = spot_to_track;	
}

clear_exception( type )
{
	assert( IsDefined( self.exception[ type ] ) );
	self.exception[ type ] = anim.defaultException;
}

set_exception( type, func )
{
	assert( IsDefined( self.exception[ type ] ) );
	self.exception[ type ] = func;
}

set_all_exceptions( exceptionFunc )
{
	keys = getArrayKeys( self.exception );
	for ( i=0; i < keys.size; i++ )
	{
		self.exception[ keys[ i ] ] = exceptionFunc;
	}
}

cointoss()
{
	return RandomInt( 100 ) >= 50 ;
}


waittill_string( msg, ent )
{
	if ( msg != "death" )
		self endon ("death");
		
	ent endon ( "die" );
	self waittill ( msg );
	ent notify ( "returned", msg );
}

/*
=============
///ScriptDocBegin
"Name: waittill_multiple( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for all of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: guy waittill_multiple( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
///ScriptDocEnd
=============
*/
waittill_multiple( string1, string2, string3, string4, string5 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;

	if (IsDefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (IsDefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (IsDefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (IsDefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (IsDefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

/*
=============
///ScriptDocBegin
"Name: waittill_multiple_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )"
"Summary: Waits for all of the the specified notifies on their associated entities."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"OptionalArg:	<ent3> entity to wait for <string3> on"
"OptionalArg:	<string3> notify to wait for on <ent3>"
"OptionalArg:	<ent4> entity to wait for <string4> on"
"OptionalArg:	<string4> notify to wait for on <ent4>"
"Example: guy waittill_multiple_ents( guy, "goal", guy, "pain", guy, "near_goal", player, "weapon_change" );"
"SPMP: both"
///ScriptDocEnd
=============
*/
waittill_multiple_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;

	if ( IsDefined( ent1 ) )
	{
		assert( IsDefined( string1 ) );
		ent1 thread waittill_string( string1, ent );
		ent.threads++;
	}
	if ( IsDefined( ent2 ) )
	{
		assert( IsDefined( string2 ) );
		ent2 thread waittill_string ( string2, ent );
		ent.threads++;
	}
	if ( IsDefined( ent3 ) )
	{
		assert( IsDefined( string3 ) );
		ent3 thread waittill_string ( string3, ent );
		ent.threads++;
	}
	if ( IsDefined( ent4 ) )
	{
		assert( IsDefined( string4 ) );
		ent4 thread waittill_string ( string4, ent );
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
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
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string6> name of a notify to wait on"
"Example: which_notify = guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
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

	if (IsDefined (string1))
		self thread waittill_string (string1, ent);

	if (IsDefined (string2))
		self thread waittill_string (string2, ent);

	if (IsDefined (string3))
		self thread waittill_string (string3, ent);

	if (IsDefined (string4))
		self thread waittill_string (string4, ent);

	if (IsDefined (string5))
		self thread waittill_string (string5, ent);

	if (IsDefined (string6))
		self thread waittill_string (string6, ent);

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
"SPMP: both"
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
///ScriptDocBegin
"Name: waittill_any_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )"
"Summary: Waits for any of the the specified notifies on their associated entities."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"OptionalArg:	<ent3> entity to wait for <string3> on"
"OptionalArg:	<string3> notify to wait for on <ent3>"
"OptionalArg:	<ent4> entity to wait for <string4> on"
"OptionalArg:	<string4> notify to wait for on <ent4>"
"Example: guy waittill_any_ents( guy, "goal", guy, "pain", guy, "near_goal", player, "weapon_change" );"
"SPMP: both"
///ScriptDocEnd
=============
*/
waittill_any_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4, ent5, string5, ent6, string6, ent7, string7 )
{
	assert( IsDefined( ent1 ) );
	assert( IsDefined( string1 ) );
	
	if ( ( IsDefined( ent2 ) ) && ( IsDefined( string2 ) ) )
		ent2 endon( string2 );

	if ( ( IsDefined( ent3 ) ) && ( IsDefined( string3 ) ) )
		ent3 endon( string3 );
	
	if ( ( IsDefined( ent4 ) ) && ( IsDefined( string4 ) ) )
		ent4 endon( string4 );
	
	if ( ( IsDefined( ent5 ) ) && ( IsDefined( string5 ) ) )
		ent5 endon( string5 );
	
	if ( ( IsDefined( ent6 ) ) && ( IsDefined( string6 ) ) )
		ent6 endon( string6 );
	
	if ( ( IsDefined( ent7 ) ) && ( IsDefined( string7 ) ) )
		ent7 endon( string7 );
	
	ent1 waittill( string1 );
}

/*
=============
///ScriptDocBegin
"Name: isFlashed()"
"Summary: Returns true if the player or an AI is flashed"
"Module: Utility"
"CallOn: An AI"
"Example: flashed = level.price isflashed();"
"SPMP: both"
///ScriptDocEnd
=============
*/
isFlashed()
{
	if ( !IsDefined( self.flashEndTime ) )
		return false;
	
	return GetTime() < self.flashEndTime;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: flag( <flagname> )"
"Summary: Checks if the flag is set. Returns true or false."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to check"
"Example: flag( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag( message )
{
	assertEx( IsDefined( message ), "Tried to check flag but the flag was not defined." );
	assertEx( IsDefined( level.flag[ message ] ), "Tried to check flag " + message + " but the flag was not initialized." );
	if ( !level.flag[ message ] )
		return false;

	return true;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: flag_init( <flagname> )"
"Summary: Initialize a flag to be used. All flags must be initialized before using flag_set or flag_wait"
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to create"
"Example: flag_init( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag_init( message, val )
{
	if ( !IsDefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}

	if ( !IsDefined( level.sp_stat_tracking_func ) )
	{
		level.sp_stat_tracking_func = ::empty_init_func;
	}

	if ( !IsDefined( level.first_frame ) )
	{
		assertEx( !IsDefined( level.flag[ message ] ), "Attempt to reinitialize existing flag: " + message );
	}
	
	if (is_true(val))
	{
		level.flag[ message ] = true;

		/#
			level.flags_lock[ message ] = true;
		#/
	}
	else
	{
		level.flag[ message ] = false;

		/#
			level.flags_lock[ message ] = false;
		#/
	}
  
	if ( !IsDefined( level.trigger_flags ) )
	{
		init_trigger_flags();
		level.trigger_flags[ message ] = [];
	}
	else if ( !IsDefined( level.trigger_flags[ message ] ) )
	{
		level.trigger_flags[ message ] = [];
	}
	
	if ( issuffix( message, "aa_" ) )
	{
		thread [[ level.sp_stat_tracking_func ]]( message );
	}
}

empty_init_func( empty )
{
}

issuffix( msg, suffix )
{
	if ( suffix.size > msg.size )
		return false;
	
	for ( i = 0; i < suffix.size; i++ )
	{
		if ( msg[ i ] != suffix[ i ] )
			return false;
	}
	return true;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: flag_set( <flagname> )"
"Summary: Sets the specified flag, all scripts using flag_wait will now continue."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to set"
"Example: flag_set( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag_set( message )
{
 /#
	assertEx( IsDefined( level.flag[ message ] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[ message ] == level.flags_lock[ message ] );
	level.flags_lock[ message ] = true;
#/ 	
	level.flag[ message ] = true;
	level notify( message );

	set_trigger_flag_permissions( message );
}

/* 
============= 
///ScriptDocBegin
"Name: flag_toggle( <flagname> )"
"Summary: Toggles the specified flag."
"Module: Flag"
"MandatoryArg: <flagname> : name of the flag to toggle"
"Example: flag_toggle( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
flag_toggle( message )
{
	if (flag(message))
	{
		flag_clear(message);
	}
	else
	{
		flag_set(message);
	}
}

 /* 
 ============= 
///ScriptDocBegin
"Name: flag_wait( <flagname> )"
"Summary: Waits until the specified flag is set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to wait on"
"Example: flag_wait( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag_wait( msg )
{
	while( !level.flag[ msg ] )
		level waittill( msg );
}

 /* 
 ============= 
///ScriptDocBegin
"Name: flag_clear( <flagname> )"
"Summary: Clears the specified flag."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to clear"
"Example: flag_clear( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag_clear( message )
{
 /#
	assertEx( IsDefined( level.flag[ message ] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[ message ] == level.flags_lock[ message ] );
	level.flags_lock[ message ] = false;
#/ 	
	//do this check so we don't unneccessarily send a notify
	if (	level.flag[ message ] )
	{
		level.flag[ message ] = false;
		level notify( message );
		set_trigger_flag_permissions( message );
	}
}

/*
=============
///ScriptDocBegin
"Name: flag_waitopen( <flagname> )"
"Summary: Waits for the flag to open"
"Module: Flag"
"MandatoryArg: <flagname>: The flag"
"Example: flag_waitopen( "get_me_bagels" );"
"SPMP: both"
///ScriptDocEnd
=============
*/

flag_waitopen( msg )
{
	while( level.flag[ msg ] )
		level waittill( msg );
}

/*
=============
///ScriptDocBegin
"Name: flag_exists( <flagname> )"
"Summary: Waits for the flag to open"
"Module: Flag"
"Call on: Entity, You can also call this on level entity for level flags."
"MandatoryArg: <flagname>: The flag"
"Example: flag_waitopen( "get_me_bagels" );"
"SPMP: both"
///ScriptDocEnd
=============
*/

flag_exists( msg )
{
	if( self == level )
	{
		if( !IsDefined( level.flag ) )
			return false;

		if( IsDefined( level.flag[ msg ] ) )
			return true;
	}
	else
	{
		if( !IsDefined( self.ent_flag ) )
			return false;

		if( IsDefined( self.ent_flag[ msg ] ) )
			return true;
	}
	
	return false;
}

script_gen_dump_addline( string, signature )
{
	
	if ( !IsDefined( string ) )
		string = "nowrite";// some things like the standardized CSV sound entries don't really need anything in script. just the asset
		
	if ( !IsDefined( level._loadstarted ) )
	{
			// stashes commands away so they can be handled in the correct place within load
			if ( !IsDefined( level.script_gen_dump_preload ) )
				level.script_gen_dump_preload = [];
			struct = SpawnStruct();
			struct.string = string;
			struct.signature = signature;
			level.script_gen_dump_preload[ level.script_gen_dump_preload.size ] = struct;
			return;
	}
		
		
	if ( !IsDefined( level.script_gen_dump[ signature ] ) )
		level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "Added: " + string;// console print as well as triggering the dump
	level.script_gen_dump[ signature ] = string;
	level.script_gen_dump2[ signature ] = string;// second array gets compared later with saved array. When something is missing dump is generated
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
"SPMP: both"
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
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
single_func(entity, func, arg1, arg2, arg3, arg4, arg5)
{
	if(!IsDefined(entity))
	{
		entity = level;
	}

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
"Name: array_thread( <entities>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5> )"
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
	AssertEX(IsDefined(entities), "Undefined array passed to common_scripts\utility::array_thread()");

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
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
single_thread(entity, func, arg1, arg2, arg3, arg4, arg5)
{
	AssertEX(IsDefined(entity), "Undefined entity passed to common_scripts\utility::single_thread()");

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

remove_undefined_from_array( array )
{
	newarray = [];
	for( i = 0; i < array.size; i ++ )
	{
		if ( !IsDefined( array[ i ] ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

realWait(seconds) //wait is time based off off 1/20 * number of frames not real time.
{
	start = GetTime();

	//println("realWait "+seconds*1000);
	while(GetTime() - start < seconds * 1000)
	{
		//println("waited "+(GetRealTime() - start));
		wait(.05);
	}
	//println("real wait done");
}

/* 
 ============= 
///ScriptDocBegin
"Name: trigger_on( <name>, <type> )"
"Summary: Turns a trigger on. This only needs to be called if it was previously turned off"
"Module: Trigger"
"CallOn: A trigger"
"OptionalArg: <name> : the name corrisponding to a targetname or script_noteworthy to grab the trigger internally"
"OptionalArg: <type> : the type( targetname, or script_noteworthy ) corrisponding to a name to grab the trigger internally"
"Example: trigger trigger_on(); -or- trigger_on( "base_trigger", "targetname" )"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
trigger_on( name, type )
{
	if ( IsDefined ( name ) && IsDefined( type ) )
	{
		ents = getentarray( name, type );
		array_thread( ents, ::trigger_on_proc );
	}
	else
		self trigger_on_proc();	
}

trigger_on_proc()
{
	if ( IsDefined( self.realOrigin ) )
		self.origin = self.realOrigin;
	self.trigger_off = undefined;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: trigger_off( <name>, <type> )"
"Summary: Turns a trigger off so it can no longer be triggered."
"Module: Trigger"
"CallOn: A trigger"
"OptionalArg: <name> : the name corrisponding to a targetname or script_noteworthy to grab the trigger internally"
"OptionalArg: <type> : the type( targetname, or script_noteworthy ) corrisponding to a name to grab the trigger internally"
"Example: trigger trigger_off();"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */
trigger_off( name, type )
{
	if ( IsDefined ( name ) && IsDefined( type ) )
	{
		ents = getentarray( name, type );
		array_thread( ents, ::trigger_off_proc );
	}
	else
		self trigger_off_proc();	
}
 
trigger_off_proc()
{
	if ( !IsDefined( self.realOrigin ) )
		self.realOrigin = self.origin;

	if ( self.origin == self.realorigin )
		self.origin += ( 0, 0, -10000 );
	self.trigger_off = true;
}

/* 
============= 
///ScriptDocBegin
"Name: trigger_wait( <strName> , <strKey> )"
"Summary: Waits until a trigger with the specified key / value is triggered. Returns the trigger and assigns the entity that triggered it to "trig.who"."
"Module: Trigger"
"MandatoryArg: <strName> : Key value."
"OptionalArg: <strKey> : Key name on the trigger to use, example: "targetname" or "script_noteworthy". Defaults to "targetname"."
"Example: trigger_wait( "player_in_building1, "script_noteworthy" );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
trigger_wait( strName, strKey )
{
	if( !IsDefined( strKey ) )
	{
		strKey = "targetname";
	}

	triggers = GetEntArray( strName, strKey ); 
	AssertEX( IsDefined(triggers) && triggers.size > 0, "trigger not found: " + strName + " key: " + strKey );
	
	ent = spawnstruct();
	array_thread( triggers, ::trigger_wait_think, ent );
	ent waittill( "trigger", eOther, trigger_hit );
	level notify( strName, eOther );
	
	//GLOCKE: 1/27/10 - change to return the trigger, then store the 'trigger entity' info on the trigger itself
	if(IsDefined(trigger_hit)) //-- to catch trigger_once;
	{
		trigger_hit.who = eother;
		return trigger_hit;
	}
	else
	{
		return eOther;
	}
}

trigger_wait_think( ent )
{
	self endon( "death" );
	ent endon( "trigger" );
	self waittill( "trigger", eother );
	ent notify( "trigger", eother, self );
}

set_trigger_flag_permissions( msg )
{
	// turns triggers on or off depending on if they have the proper flags set, based on their shift-g menu settings

	// this can be init before _load has run, thanks to AI.
	if ( !IsDefined( level.trigger_flags ) )
		return;

	// cheaper to do the upkeep at this time rather than with endons and waittills on the individual triggers	
	level.trigger_flags[ msg ] = remove_undefined_from_array( level.trigger_flags[ msg ] );
	array_thread( level.trigger_flags[ msg ], ::update_trigger_based_on_flags );
}

update_trigger_based_on_flags()
{
	true_on = true;
	if ( IsDefined( self.script_flag_true ) )
	{
		true_on = false;
		tokens = create_flags_and_return_tokens( self.script_flag_true );
		
		// stay off unless any of the flags are true
		for( i=0; i < tokens.size; i++ )
		{
			if ( flag( tokens[ i ] ) )
			{
				true_on = true;
				break;
			}
		}	
	}
	
	false_on = true;
	if ( IsDefined( self.script_flag_false ) )
	{
		tokens = create_flags_and_return_tokens( self.script_flag_false );
		
		// stay on unless any of the flags are true
		for( i=0; i < tokens.size; i++ )
		{
			if ( flag( tokens[ i ] ) )
			{
				false_on = false;
				break;
			}
		}	
	}
	
	[ [ level.trigger_func[ true_on && false_on ] ] ]();
}

create_flags_and_return_tokens( flags )
{
	tokens = strtok( flags, " " );	

	// create the flag if level script does not
	for( i=0; i < tokens.size; i++ )
	{
		if ( !IsDefined( level.flag[ tokens[ i ] ] ) )
		{
			flag_init( tokens[ i ] );
		}
	}
	
	return tokens;
}

init_trigger_flags()
{
	level.trigger_flags = [];
	level.trigger_func[ true ] = ::trigger_on;
	level.trigger_func[ false ] = ::trigger_off;
}

/* 
============= 
///ScriptDocBegin
"Name: getstruct( <name> , <type> )"
"Summary: Returns a struct with the specified value of "target", "targetname", "script_noteworthy", or "script_linkname"."
"Module: Utility"
"Example: getstruct("some_value", "targetname");"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
getstruct( name, type )
{
	assertEx( IsDefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

	if (!IsDefined(type))
	{
		type = "targetname";
	}

	array = level.struct_class_names[ type ][ name ];
	if( !IsDefined( array ) )
	{
		return undefined; 
	}

	if( array.size > 1 )
	{
		assertMsg( "getstruct used for more than one struct of type " + type + " called " + name + "." );
		return undefined; 
	}
	return array[ 0 ];
}

 /* 
 ============= 
///ScriptDocBegin
"Name: getstructarray( <name> , <type )"
"Summary: gets an array of script_structs"
"Module: Array"
"CallOn: An entity"
"MandatoryArg: <name> : "
"MandatoryArg: <type> : "
"Example: fxemitters = getstructarray( "streetlights", "targetname" )"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 

getstructarray( name, type )
{
	assertEx( IsDefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

	if (!IsDefined(type))
	{
		type = "targetname";
	}
	
	array = level.struct_class_names[ type ][ name ];
	if ( !IsDefined( array ) )
		return [];
	return array;
}

struct_class_init()
{
	assertEx( !IsDefined( level.struct_class_names ), "level.struct_class_names is being initialized in the wrong place! It shouldn't be initialized yet." );
	
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_linkname" ] = [];
	
	for ( i=0; i < level.struct.size; i++ )
	{
		if ( IsDefined( level.struct[ i ].targetname ) )
		{
			if ( !IsDefined( level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ] ) )
				level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ] = [];
			
			size = level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ].size;
			level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ][ size ] = level.struct[ i ];
		}
		if ( IsDefined( level.struct[ i ].target ) )
		{
			if ( !IsDefined( level.struct_class_names[ "target" ][ level.struct[ i ].target ] ) )
				level.struct_class_names[ "target" ][ level.struct[ i ].target ] = [];
			
			size = level.struct_class_names[ "target" ][ level.struct[ i ].target ].size;
			level.struct_class_names[ "target" ][ level.struct[ i ].target ][ size ] = level.struct[ i ];
		}
		if ( IsDefined( level.struct[ i ].script_noteworthy ) )
		{
			if ( !IsDefined( level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ] ) )
				level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ] = [];
			
			size = level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ].size;
			level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ][ size ] = level.struct[ i ];
		}
		if ( IsDefined( level.struct[ i ].script_linkname ) )
		{
			assertex( !IsDefined( level.struct_class_names[ "script_linkname" ][ level.struct[ i ].script_linkname ] ), "Two structs have the same linkname" );
			level.struct_class_names[ "script_linkname" ][ level.struct[ i ].script_linkname ][ 0 ] = level.struct[ i ];
		}
	}

	//setup target chains
	for( i = 0; i < level.struct.size; i++ )
	{
		if( !IsDefined( level.struct[i].target ) )
		{
			continue; 
		}
		level.struct[i].targeted = level.struct_class_names["targetname"][level.struct[i].target]; 
	}
}

fileprint_start( file )
{
	 /#
	filename = file;

//hackery here, sometimes the file just doesn't open so keep trying
//	file = -1;
//	while( file == -1 )
//	{
		file = openfile( filename, "write" );
//		if (file == -1)
//			wait .05; // try every frame untill the file becomes writeable
//	}
	level.fileprint = file;
	level.fileprintlinecount = 0;
	level.fileprint_filename = filename;
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_start( <filename> )"
"Summary: starts map export with the file trees\cod3\cod3\map_source\xenon_export\ < filename > .map adds header / worldspawn entity to the map.  Use this if you want to start a .map export."
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <param1> : "
"OptionalArg: <param2> : "
"Example: fileprint_map_start( filename );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_start( file )
{
	 /#
	file = "map_source/" + file + ".map";
	fileprint_start( file );

	// for the entity count
	level.fileprint_mapentcount = 0;

	fileprint_map_header( true );
	#/ 
	
}

fileprint_chk( file , str )
{
	/#
		//dodging infinite loops for file dumping. kind of dangerous
		level.fileprintlinecount++;
		if (level.fileprintlinecount>400)
		{
			wait .05;
			level.fileprintlinecount++;
			level.fileprintlinecount = 0;
		}
		fprintln( file, str );
	#/
}

fileprint_map_header( bInclude_blank_worldspawn )
{
	if ( !IsDefined( bInclude_blank_worldspawn ) )
		bInclude_blank_worldspawn = false;
		
	// this may need to be updated if map format changes
	assert( IsDefined( level.fileprint ) );
	 /#
	fileprint_chk( level.fileprint, "iwmap 4" );
	fileprint_chk( level.fileprint, "\"000_Global\" flags  active" );
	fileprint_chk( level.fileprint, "\"The Map\" flags" ); 
	
	if ( !bInclude_blank_worldspawn )
		return;
	 fileprint_map_entity_start();
	 fileprint_map_keypairprint( "classname", "worldspawn" );
	 fileprint_map_entity_end();

	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_keypairprint( <key1> , <key2> )"
"Summary: prints a pair of keys to the current open map( by fileprint_map_start() )"
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <key1> : "
"MandatoryArg: <key2> : "
"Example: fileprint_map_keypairprint( "classname", "script_model" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_keypairprint( key1, key2 )
{
	 /#
	assert( IsDefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "\"" + key1 + "\" \"" + key2 + "\"" );
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_entity_start()"
"Summary: prints entity number and opening bracket to currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_start();"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_entity_start()
{
	 /#
	assert( !IsDefined( level.fileprint_entitystart ) );
	level.fileprint_entitystart = true;
	assert( IsDefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "// entity " + level.fileprint_mapentcount );
	fileprint_chk( level.fileprint, "{" );
	level.fileprint_mapentcount ++ ;
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_entity_end()"
"Summary: close brackets an entity, required for the next entity to begin"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_end();"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_entity_end()
{
	 /#
	assert( IsDefined( level.fileprint_entitystart ) );
	assert( IsDefined( level.fileprint ) );
	level.fileprint_entitystart = undefined;
	fileprint_chk( level.fileprint, "}" );
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_end()"
"Summary: saves the currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_end();"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
 
fileprint_end()
{
	 /#
	assert( !IsDefined( level.fileprint_entitystart ) );
	saved = closefile( level.fileprint );
	if (saved != 1)
	{
		println("-----------------------------------");
		println(" ");
		println("file write failure");
		println("file with name: "+level.fileprint_filename);
		println("make sure you checkout the file you are trying to save");
		println("note: USE P4 Search to find the file and check that one out");
		println("      Do not checkin files in from the xenonoutput folder, ");
		println("      this is junctioned to the proper directory where you need to go");
		println("junctions looks like this");
		println(" ");
		println("..\\xenonOutput\\scriptdata\\createfx      ..\\share\\raw\\maps\\createfx");
		println("..\\xenonOutput\\scriptdata\\createart     ..\\share\\raw\\maps\\createart");
		println("..\\xenonOutput\\scriptdata\\vision        ..\\share\\raw\\vision");
		println("..\\xenonOutput\\scriptdata\\scriptgen     ..\\share\\raw\\maps\\scriptgen");
		println("..\\xenonOutput\\scriptdata\\zone_source   ..\\xenon\\zone_source");
		println("..\\xenonOutput\\accuracy                  ..\\share\\raw\\accuracy");
		println("..\\xenonOutput\\scriptdata\\map_source    ..\\map_source\\xenon_export");
		println(" ");
		println("-----------------------------------");
		
		println( "File not saved( see console.log for info ) " );
	}
	level.fileprint = undefined;
	level.fileprint_filename = undefined;
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_radiant_vec( <vector> )"
"Summary: this converts a vector to a .map file readable format"
"Module: Fileprint"
"CallOn: An entity"
"MandatoryArg: <vector> : "
"Example: origin_string = fileprint_radiant_vec( vehicle.angles )"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */
fileprint_radiant_vec( vector )
{
	 /#
		string = "" + vector[ 0 ] + " " + vector[ 1 ] + " " + vector[ 2 ] + "";
		return string;
	#/ 
}


is_mature()
{
	if ( level.onlineGame )
		return true;

	return GetDvarInt( #"cg_mature" );
}

is_german_build()
{
	if( GetDvar( #"language" ) == "german" )
	{
		return true;
	}
	return false;
}
is_gib_restricted_build()
{
	if( GetDvar( #"language" ) == "german" )
	{
		return true;
	}
	if( GetDvar( #"language" ) == "japanese" )
	{
		return true;
	}
	return false;
}

/* 
============= 
///ScriptDocBegin
"Name: is_true(<check>)"
"Summary: For boolean checks when undefined should mean 'false'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_true( self.is_linked ) { //do stuff }"
"SPMP: both"
///ScriptDocEnd
============= 
*/
is_true(check)
{
	return(IsDefined(check) && check);
}

/* 
============= 
///ScriptDocBegin
"Name: is_false(<check>)"
"Summary: For boolean checks when undefined should mean 'true'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_false( self.is_linked ) { //do stuff }"
"SPMP: both"
///ScriptDocEnd
============= 
*/
is_false(check)
{
	return(IsDefined(check) && !check);
}

/* 
============= 
///ScriptDocBegin
"Name: has_spawnflag(<spawnflags>)"
"Summary: Check to see if a spawnflag value is set on an entity."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg: <spawnflags> : The spawnflags value you want to check for."
"Example: has_spawnflag( level.SPAWNFLAG_ACTOR_SPAWNER );"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
has_spawnflag(spawnflags)
{
	if (IsDefined(self.spawnflags))
	{
		return ((self.spawnflags & spawnflags) == spawnflags);
	}

	return false;
}

/* 
============= 
///ScriptDocBegin
"Name: clamp(val, val_min, val_max)"
"Summary: Clamps a value between a min and max value."
"Module: Math"
"MandatoryArg: val: the value to clamp."
"MandatoryArg: val_min: the min value to clamp to."
"MandatoryArg: val_max: the mac value to clamp to."
"Example: clamped_val = clamp(8, 0, 5); // returns 5	*	clamped_val = clamp(-1, 0, 5); // returns 0"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
clamp(val, val_min, val_max)
{
	if (val < val_min)
	{
		val = val_min;
	}
	else if (val > val_max)
	{
		val = val_max;
	}

	return val;
}

/* 
============= 
///ScriptDocBegin
"Name: linear_map(val, min_a, max_a, min_b, max_b)"
"Summary: Maps a value within one range to a value in another range."
"Module: Math"
"MandatoryArg: val: the value to map."
"MandatoryArg: min_a: the min value of the range in which <val> exists."
"MandatoryArg: max_a: the max value of the range in which <val> exists."
"MandatoryArg: min_b: the min value of the range in which the return value should exist."
"MandatoryArg: max_b: the max value of the range in which the return value should exist."
"Example: fov = linear_map(speed, min_speed, max_speed, min_fov, max_fov);"
"SPMP: both"
///ScriptDocEnd
============= 
*/ 
linear_map(num, min_a, max_a, min_b, max_b)
{
	return clamp(( (num - min_a) / (max_a - min_a) * (max_b - min_b) + min_b ), min_b, max_b);
}

// Facial animation event notify wrappers
death_notify_wrapper( attacker, damageType )
{
	level notify( "face", "death", self );
	self notify( "death", attacker, damageType );
}

damage_notify_wrapper( damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags )
{
	level notify( "face", "damage", self );
	self notify( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
}

explode_notify_wrapper()
{
	level notify( "face", "explode", self );
	self notify( "explode" );
}

alert_notify_wrapper()
{
	level notify( "face", "alert", self );
	self notify( "alert" );
}

shoot_notify_wrapper()
{
	level notify( "face", "shoot", self );
	self notify( "shoot" );
}

melee_notify_wrapper()
{
	level notify( "face", "melee", self );
	self notify( "melee" );
}

isUsabilityEnabled()
{
	return ( !self.disabledUsability );
}


_disableUsability()
{
	self.disabledUsability++;
	self DisableUsability();
}


_enableUsability()
{
	self.disabledUsability--;
	
	assert( self.disabledUsability >= 0 );
	
	if ( !self.disabledUsability )
		self EnableUsability();
}


resetUsability()
{
	self.disabledUsability = 0;
	self EnableUsability();
}


_disableWeapon()
{
	self.disabledWeapon++;
	self disableWeapons();
}

_enableWeapon()
{
	self.disabledWeapon--;
	
	assert( self.disabledWeapon >= 0 );
	
	if ( !self.disabledWeapon )
		self enableWeapons();
}

isWeaponEnabled()
{
	return ( !self.disabledWeapon );
}
