#include common_scripts\utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#include animscripts\anims;

#using_animtree ("generic_human");

// (Note that animations called right are used with left corner nodes, and vice versa.)

main()
{
	self.hideYawOffset = 0; // pillar nodes just face straight

	scriptName = "cover_pillar";

	if( usingPistol() )
	{
		if( self.node isNodeDontRight() )
		{
			self.hideYawOffset = 90;
			scriptName = "cover_left";
		}
		else
		{
			self.hideYawOffset = -90;
			scriptName = "cover_right";
		}
	}
	
    self trackScriptState( "Cover Pillar Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize(scriptName);

	if( self.node isNodeDontRight() )
	{
		animscripts\corner::corner_think( "left" );
	}
	else
	{
		animscripts\corner::corner_think( "right" );
	}
}
