#include common_scripts\utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#include animscripts\anims;

#using_animtree ("generic_human");

// (Note that animations called right are used with left corner nodes, and vice versa.)

main()
{
	self.hideYawOffset = 90;
	
    self trackScriptState( "Cover Left Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_left");

	animscripts\corner::corner_think( "left" );
}