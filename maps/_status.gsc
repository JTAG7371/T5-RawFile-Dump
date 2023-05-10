
scripter_task( name, days, percent, note )
{
	task( "scripter", name, undefined, undefined, days, percent, note );
	level.current_task = name;
}
scripter_subtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call scripter_task() before you can call script_subtask()" );
		return;
	}
	task( "scripter", name, level.current_task, undefined, days, percent, note );
	level.current_subtask = name;
}
scripter_microtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call script_task() before you can call scripter_microtask()" );
		return;
	}
	if( !IsDefined( level.current_subtask ) )
	{
		assertmsg( "You must call scripter_subtask() before you can call scripter_microtask()" );
		return;
	}
	task( "scripter", name, level.current_task, level.current_subtask, days, percent, note );
}
builder_task( name, days, percent, note )
{
	task( "builder", name, undefined, undefined, days, percent, note );
	level.current_task = name;
}
builder_subtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call builder_task() before you can call builder_subtask()" );
		return;
	}
	task( "builder", name, level.current_task, undefined, days, percent, note );
	level.current_subtask = name;
}
builder_microtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call builder_task() before you can call builder_microtask()" );
		return;
	}
	if( !IsDefined( level.current_subtask ) )
	{
		assertmsg( "You must call builder_subtask() before you can call builder_microtask()" );
		return;
	}
	task( "builder", name, level.current_task, level.current_subtask, days, percent, note );
}
task( type, name, main_task, sub_task, days, percent, note )
{
}
update_percent( type, main_task, sub_task )
{
}
update_days( type, main_task )
{
}
set_start_day( type, main_task )
{
	index = -1;
	if( IsDefined( level._tasks[type]["all_tasks"] ) )
	{
		size = level._tasks[type]["all_tasks"].size;
		for( i = 0; i < size; i++ )
		{
			if( level._tasks[type]["all_tasks"][i] == main_task )
			{
				index = i;
				break;
			}
		}
	}
	
	if( index > 0 )
	{
		previous_name = level._tasks[type]["all_tasks"][index - 1];
		level._tasks[type][main_task]["start_day"] = date_to_day( level._tasks[type][previous_name]["due_date"] ) + 1;
		while( is_day_off( level._tasks[type][main_task]["start_day"] ) )
		{
			level._tasks[type][main_task]["start_day"]++;
		}
	}
	else
	{
		level._tasks[type][main_task]["start_day"] = date_to_day( level._task_start_date );
	}
}
show_task( name )
{
}
show_task_thread( name )
{
}
show_status( type, name, x )
{
	quote = get_status_quote( type, name );
	color = ( 1, 1, 1 );
	if( quote == "On Schedule" )
	{
		color = ( 0, 1, 0 );
	}
	else if( quote == "Ahead of Schedule" )
	{
		color = ( 0, 1, 0 );
	}
	else if( quote == "A Bit Behind Schedule" )
	{
		color = ( 1, 1, 0 );
	}
	else if( quote == "Behind Schedule" )
	{
		color = ( 1, 0, 0 );
	}
	else if( quote == "COMPLETED" )
	{
		color = ( 0, 1, 0 );
	}
	new_hud( name, quote, x + 35, level._status_y - 36, undefined, color );		
	days = level._tasks[type][name]["days"]; 
	days_remaining = days_remaining( level._tasks[type][name]["start_day"], days );
	expected_percent = 100 - ( ( 100 / days ) * days_remaining ); 
	expected = "Expected Percent: " + expected_percent;
	new_hud( name, expected, x, level._status_y - 24 );
	days_remaining_string = "Days Remaining: " + days_remaining;
	new_hud( name, days_remaining_string, x, level._status_y - 12 );
}
get_status_quote( type, name )
{
	quote = "SHOULD NOT SEE THIS!";
	percent = level._tasks[type][name]["percent"];
	if( percent < 100 )
	{
		days = level._tasks[type][name]["days"]; 
		days_remaining = days_remaining( level._tasks[type][name]["start_day"], days );
		expected_percent = 100 - ( ( 100 / days ) * days_remaining ); 
		diff = percent - expected_percent;
		if( expected_percent < 0 || abs( diff ) < 10 ) 
		{
			quote = "On schedule";
		}
		else if( percent > expected_percent )
		{
			quote = "Ahead of Schedule";
		}
		else if( percent < expected_percent )
		{
			if( diff > -20 )
			{
				quote = "A Bit Behind Schedule";
			}
			else
			{
				quote = "Behind Schedule";
			}
		}
	}
	else
	{
		quote = "COMPLETED";
	}
	return quote;
}
days_remaining( start_day, days )
{
}
date_to_day( date )
{
}
get_due_day( start_day, days )
{
}
get_estimated_due_date( type )
{
}
is_day_off( day )
{
}
day_to_date( day, just_day_number )
{
}
get_month_number( date )
{
}
get_month_string( num )
{
}
days_in_year( year )
{
}
month_days( month_num )
{
}
is_leapyear( year )
{
}
get_year()
{
}
show_subtasks( hud_name, sub_tasks, x )
{
}
new_hud( hud_name, msg, x, y, scale, color )
{
}
hud_color( percent )
{
}
remove_hud( hud_name )
{
}
destroy_hud( hud )
{
}
set_hudelem( text, x, y, scale, alpha, color )
{
}
export_status_thread()
{
}
export_to_html( type )
{
}
write_project_header( file, type )
{
}
write_gantt_chart( file )
{
}
figure_days_amount( begin_date, end_date )
{
}
write_gantt_graph_row( file, start_date, due_date, use_odd, columns, overall_width )
{
}
write_gantt_row( file, array, task_num, use_odd, pixels, use_bold )
{
}
write_gantt_chart_header( file, type )
{
}
write_tasks( file )
{
}
write_task_row( file, array, task_num, use_odd, pixels, use_bold )
{
}
write_task_header( file, type )
{
}
write_header( file )
{
}
save_complete( msg )
{
}
check_for_dupes( array, single )
{
}
abs( x )
{
	if( x > 0 )
	{
		return x;
	}
	return 0 - x;
}