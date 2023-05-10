
main()
{
	switch( codescripts\character::get_random_character(4) )
	{
	case 0:
		character\c_rus_prisoner::main();
		break;
	case 1:
		character\c_rus_prisoner::main();
		break;
	case 2:
		character\c_rus_prisoner::main();
		break;
	case 3:
		character\c_rus_prisoner::main();
		break;
	}
}
precache()
{
	character\c_rus_prisoner::precache();
	character\c_rus_prisoner::precache();
	character\c_rus_prisoner::precache();
	character\c_rus_prisoner::precache();
} 
