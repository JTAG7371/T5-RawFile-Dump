
// MikeD (12/17/2007): Not called anywhere
precache()
{
	precacheShader( "damage_feedback" );
}


init()
{	
	if ( GetDvar( #"scr_damagefeedback" ) == "" )
		setDvar( "scr_damagefeedback", "1" );

	if ( !GetDvarInt( #"scr_damagefeedback" ) )
		return;

	self.hud_damagefeedback = newclientHudElem( self );
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback setShader("damage_feedback", 24, 48);
}

doDamageFeedback( sWeapon, eInflictor )
{
	switch(sWeapon)
	{
		case "artillery_mp":
		case "airstrike_mp":
		case "napalm_mp":
		case "mortar_mp":
			return false;
	}
		
	if ( IsDefined( eInflictor ) )
	{
		if ( IsAI(eInflictor) )
		{
			return false;
		}
		if ( IsDefined(level.chopper) && level.chopper == eInflictor )
		{
			return false;
		}
	}
	
	return true;
}

monitorDamage()
{
	if ( !GetDvarInt( #"scr_damagefeedback" ) )
		return;

	//for ( ;; )
	//{
	//	self waittill( "damage", amount, attacker );
	//	
	//	if ( IsPlayer( attacker ) && self == attacker )
	//		attacker updateDamageFeedback();
	//}
}

updateDamageFeedback()
{
	if ( !GetDvarInt( #"scr_damagefeedback" ) )
		return;

	if ( !IsPlayer( self ) )
		return;

	self playlocalsound( "SP_hit_alert" );
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime( 1 );
	self.hud_damagefeedback.alpha = 0;
}