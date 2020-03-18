#include common_scripts\utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#include animscripts\anims;
#using_animtree ("generic_human");

// (Note that animations called left are used with right corner nodes, and vice versa.)

main()
{
	self.hideYawOffset = -90;
	
    self trackScriptState( "Cover Right Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_right");

	animscripts\corner::corner_think( "right" );
}

