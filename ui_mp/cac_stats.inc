

#define STAT_CAC_PRIMARY_GRENADE				getCACItemIndex( ( dvarString( ui_custom_name ) ), "primarygrenade" )
#define STAT_CAC_PRIMARY						getCACItemIndex( ( dvarString( ui_custom_name ) ), "primary" )
#define STAT_CAC_PRIMARY_ATTACHMENT				getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryattachment" )
#define STAT_CAC_PRIMARY_ATTACHMENT_TOP			getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryattachmenttop" )
#define STAT_CAC_PRIMARY_ATTACHMENT_BOTTOM		getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryattachmentbottom" )
#define STAT_CAC_PRIMARY_ATTACHMENT_TRIGGER		getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryattachmenttrigger" )
#define STAT_CAC_PRIMARY_ATTACHMENT_MUZZLE		getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryattachmentmuzzle" )
#define STAT_CAC_PRIMARY_CAMO					getCACItemIndex( ( dvarString( ui_custom_name ) ), "primarycamo" )
#define STAT_CAC_PRIMARY_RETICLE				getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryreticle" )
#define STAT_CAC_PRIMARY_RETICLE_COLOR			getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryreticlecolor" )
#define STAT_CAC_PRIMARY_LENS					getCACItemIndex( ( dvarString( ui_custom_name ) ), "primarylens" )
#define STAT_CAC_PRIMARY_TAG					getCACItemIndex( ( dvarString( ui_custom_name ) ), "primarytag" )
#define STAT_CAC_PRIMARY_EMBLEM					getCACItemIndex( ( dvarString( ui_custom_name ) ), "primaryemblem" )
#define STAT_CAC_SECONDARY						getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondary" )
#define STAT_CAC_SECONDARY_ATTACHMENT			getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondaryattachment" )
#define STAT_CAC_SECONDARY_ATTACHMENT_TOP		getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondaryattachmenttop" )
#define STAT_CAC_SECONDARY_ATTACHMENT_BOTTOM	getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondaryattachmentbottom" )
#define STAT_CAC_SECONDARY_ATTACHMENT_TRIGGER	getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondaryattachmenttrigger" )
#define STAT_CAC_SECONDARY_ATTACHMENT_MUZZLE	getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondaryattachmentmuzzle" )
#define STAT_CAC_SECONDARY_CAMO					getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondarycamo" )
#define STAT_CAC_SECONDARY_RETICLE				getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondaryreticle" )
#define STAT_CAC_SECONDARY_LENS					getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondarylens" )
#define STAT_CAC_SECONDARY_TAG					getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondarytag" )
#define STAT_CAC_SECONDARY_EMBLEM				getCACItemIndex( ( dvarString( ui_custom_name ) ), "secondaryemblem" )
#define STAT_CAC_SPECIALTY1						getCACItemIndex( ( dvarString( ui_custom_name ) ), "specialty1" )
#define STAT_CAC_SPECIALTY2						getCACItemIndex( ( dvarString( ui_custom_name ) ), "specialty2" )
#define STAT_CAC_SPECIALTY3						getCACItemIndex( ( dvarString( ui_custom_name ) ), "specialty3" )
#define STAT_CAC_SPECIAL_GRENADE				getCACItemIndex( ( dvarString( ui_custom_name ) ), "specialgrenade" )
#define STAT_CAC_EQUIPMENT						getCACItemIndex( ( dvarString( ui_custom_name ) ), "equipment" )
#define STAT_CAC_BODY							getCACItemIndex( ( dvarString( ui_custom_name ) ), "body" )
#define STAT_CAC_HEAD							getCACItemIndex( ( dvarString( ui_custom_name ) ), "head" )
#define STAT_CAC_FACEPAINT_PATTERN				getCACItemIndex( ( dvarString( ui_custom_name ) ), "facepaintpattern" )
#define STAT_CAC_FACEPAINT_COLOR				getCACItemIndex( ( dvarString( ui_custom_name ) ), "facepaintcolor" )
#define STAT_CAC_DEATHSTREAK					getDStat( "cacLoadouts", "deathstreak" )
#define STAT_CAC_KILLSTREAK_TIER1				getDStat( "cacLoadouts", "killstreak1" )
#define STAT_CAC_KILLSTREAK_TIER2				getDStat( "cacLoadouts", "killstreak2" )
#define STAT_CAC_KILLSTREAK_TIER3				getDStat( "cacLoadouts", "killstreak3" )

#define FIRST_ATTACHMENT_PRIMARY_WEAPON \
		GetItemEquippedAttachment( dvarString( ui_custom_name ), STAT_CAC_PRIMARY, 0 )
		
#define SECOND_ATTACHMENT_PRIMARY_WEAPON \
		GetItemEquippedAttachment( dvarString( ui_custom_name ), STAT_CAC_PRIMARY, 1 )

#define FIRST_ATTACHMENT_SECONDARY_WEAPON \
		GetItemEquippedAttachment( dvarString( ui_custom_name ), STAT_CAC_SECONDARY, 0 )

#define SECOND_ATTACHMENT_SECONDARY_WEAPON \
		GetItemEquippedAttachment( dvarString( ui_custom_name ), STAT_CAC_SECONDARY, 1 )