/* ==================================== custom classes ============================================= */

#undef STAT_CLASS_NAME
#ifdef SPLITSCREEN_ENABLED
#define STAT_CLASS_NAME ( localVarString( ui_custom_name ) )
#else
#define STAT_CLASS_NAME ( dvarString( ui_custom_name ) )
#endif

#define STAT_CAC_PRIMARY_GRENADE				getCACItemIndex( STAT_CLASS_NAME, "primarygrenade" )
#define STAT_CAC_PRIMARY						getCACItemIndex( STAT_CLASS_NAME, "primary" )
#define STAT_CAC_PRIMARY_ATTACHMENT				getCACItemIndex( STAT_CLASS_NAME, "primaryattachment" )
#define STAT_CAC_PRIMARY_ATTACHMENT_TOP			getCACItemIndex( STAT_CLASS_NAME, "primaryattachmenttop" )
#define STAT_CAC_PRIMARY_ATTACHMENT_BOTTOM		getCACItemIndex( STAT_CLASS_NAME, "primaryattachmentbottom" )
#define STAT_CAC_PRIMARY_ATTACHMENT_TRIGGER		getCACItemIndex( STAT_CLASS_NAME, "primaryattachmenttrigger" )
#define STAT_CAC_PRIMARY_ATTACHMENT_MUZZLE		getCACItemIndex( STAT_CLASS_NAME, "primaryattachmentmuzzle" )
#define STAT_CAC_PRIMARY_CAMO					getCACItemIndex( STAT_CLASS_NAME, "primarycamo" )
#define STAT_CAC_PRIMARY_RETICLE				getCACItemIndex( STAT_CLASS_NAME, "primaryreticle" )
#define STAT_CAC_PRIMARY_LENS					getCACItemIndex( STAT_CLASS_NAME, "primarylens" )
#define STAT_CAC_PRIMARY_TAG					getCACItemIndex( STAT_CLASS_NAME, "primarytag" )
#define STAT_CAC_PRIMARY_EMBLEM					getCACItemIndex( STAT_CLASS_NAME, "primaryemblem" )
#define STAT_CAC_SECONDARY						getCACItemIndex( STAT_CLASS_NAME, "secondary" )
#define STAT_CAC_SECONDARY_ATTACHMENT			getCACItemIndex( STAT_CLASS_NAME, "secondaryattachment" )
#define STAT_CAC_SECONDARY_ATTACHMENT_TOP		getCACItemIndex( STAT_CLASS_NAME, "secondaryattachmenttop" )
#define STAT_CAC_SECONDARY_ATTACHMENT_BOTTOM	getCACItemIndex( STAT_CLASS_NAME, "secondaryattachmentbottom" )
#define STAT_CAC_SECONDARY_ATTACHMENT_TRIGGER	getCACItemIndex( STAT_CLASS_NAME, "secondaryattachmenttrigger" )
#define STAT_CAC_SECONDARY_ATTACHMENT_MUZZLE	getCACItemIndex( STAT_CLASS_NAME, "secondaryattachmentmuzzle" )
#define STAT_CAC_SECONDARY_CAMO					getCACItemIndex( STAT_CLASS_NAME, "secondarycamo" )
#define STAT_CAC_SECONDARY_RETICLE				getCACItemIndex( STAT_CLASS_NAME, "secondaryreticle" )
#define STAT_CAC_SECONDARY_LENS					getCACItemIndex( STAT_CLASS_NAME, "secondarylens" )
#define STAT_CAC_SECONDARY_TAG					getCACItemIndex( STAT_CLASS_NAME, "secondarytag" )
#define STAT_CAC_SECONDARY_EMBLEM				getCACItemIndex( STAT_CLASS_NAME, "secondaryemblem" )
#define STAT_CAC_EQUIPMENT						getCACItemIndex( STAT_CLASS_NAME, "equipment" )
#define STAT_CAC_SPECIALTY1						getCACItemIndex( STAT_CLASS_NAME, "specialty1" )
#define STAT_CAC_SPECIALTY2						getCACItemIndex( STAT_CLASS_NAME, "specialty2" )
#define STAT_CAC_SPECIALTY3						getCACItemIndex( STAT_CLASS_NAME, "specialty3" )
#define STAT_CAC_SPECIAL_GRENADE				getCACItemIndex( STAT_CLASS_NAME, "specialgrenade" )
#define STAT_CAC_BODY							getCACItemIndex( STAT_CLASS_NAME, "body" )
#define STAT_CAC_DEATHSTREAK					getDStat( "cacLoadouts", "deathstreak" )
#define STAT_CAC_KILLSTREAK_TIER1				getCACItemIndex( "cacLoadouts", "killstreak1" )
#define STAT_CAC_KILLSTREAK_TIER2				getCACItemIndex( "cacLoadouts", "killstreak2" )
#define STAT_CAC_KILLSTREAK_TIER3				getCACItemIndex( "cacLoadouts", "killstreak3" )             
#define FIRST_ATTACHMENT_PRIMARY_WEAPON \
	GetItemEquippedAttachment( STAT_CLASS_NAME, STAT_CAC_PRIMARY, 0 )
#define SECOND_ATTACHMENT_PRIMARY_WEAPON \
	GetItemEquippedAttachment( STAT_CLASS_NAME, STAT_CAC_PRIMARY, 1 )
#define FIRST_ATTACHMENT_SECONDARY_WEAPON \
	Select( localVarInt( ui_multi_s ) == 0, GetItemEquippedAttachment( STAT_CLASS_NAME, STAT_CAC_SECONDARY, 0 ), -1 )
#define SECOND_ATTACHMENT_SECONDARY_WEAPON \
	Select( localVarInt( ui_multi_s ) == 0, GetItemEquippedAttachment( STAT_CLASS_NAME, STAT_CAC_SECONDARY, 1 ), -1 )


#define TEAM_AXIS 2
#define TEAM_ALLIES 3

#define PLAYER_IS_ALLIES ( team( name ) == "TEAM_ALLIES" )
#define PLAYER_IS_AXIS ( team( name ) == "TEAM_AXIS" )

// in custom class data, axis is 2, and allies is 3
#define SHOULD_SHOW_CLASS( num ) \
	( getCustomClassModifier( num, active ) \ 
 && ( getCustomClassModifier( num, "team" ) == 1 || ( PLAYER_IS_AXIS && getCustomClassModifier( num, "team" ) == TEAM_AXIS ) || ( PLAYER_IS_ALLIES && getCustomClassModifier( num, "team" ) == TEAM_ALLIES ) ) )
