
main()
{
	switch( codescripts\character::get_random_character(4) )
	{
	case 0:
		character\c_usa_marine_michael_carter_player::main();
		break;
	case 1:
		character\c_usa_marine_winston_lewis_player::main();
		break;
	case 2:
		character\c_sprint1_marine_scot_player::main();
		break;
	case 3:
		character\c_sprint1_marine_yaw_player::main();
		break;
	}
}
precache()
{
	character\c_usa_marine_michael_carter_player::precache();
	character\c_usa_marine_winston_lewis_player::precache();
	character\c_sprint1_marine_scot_player::precache();
	character\c_sprint1_marine_yaw_player::precache();
} 
