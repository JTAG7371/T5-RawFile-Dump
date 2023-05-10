

#define PRESTIGE						(	GetStatByName( "PLEVEL" )					)
#define IS_ITEM_LOCKED( ITEM_NAME )		(	IsItemLocked( GetItemIndex( ITEM_NAME ) )	)
#define IS_ITEM_LOCKED_FOR_ALL( ITEM_NAME )	(	IsItemLockedForAll( GetItemIndex( ITEM_NAME ) )	)
#define IS_ITEM_NEW( ITEM_NAME )		(	IsItemNew( GetItemIndex( ITEM_NAME ) )		)

#define CLEAR_ITEM_NEW( ITEM_NAME )		if(	IS_ITEM_NEW( ITEM_NAME ) )		\
										{									\
											execnow clearItemNew ITEM_NAME;	\
										}


#define ANY_NEW_PRIMARIES				(	IsItemGroupNew( "weapon_smg" )		|| IsItemGroupNew( "weapon_assault" )	|| IsItemGroupNew( "weapon_cqb" )	|| IsItemGroupNew( "weapon_lmg" ) || IsItemGroupNew( "weapon_sniper" ) )
#define ANY_NEW_SECONDARIES				(	IsItemGroupNew( "weapon_pistol" )	|| IsItemGroupNew( "weapon_launcher" )	|| IsItemGroupNew( "weapon_special" ) )


#define ANY_NEW_CAC_WEAPON_FEATURE		(	IS_ITEM_NEW( FEATURE_CAMO )				||	\
											IS_ITEM_NEW( FEATURE_RETICLES ) 		||	\
											IS_ITEM_NEW( FEATURE_RETICLE_COLOR )	||	\
											IS_ITEM_NEW( FEATURE_LENSES )			||	\
											IS_ITEM_NEW( FEATURE_GUN_TAG )			||	\
											IS_ITEM_NEW( FEATURE_GUN_EMBLEM )		)


#define ANY_NEW_PRIMARY_FEATURE			(	ANY_NEW_PRIMARIES || ANY_NEW_CAC_WEAPON_FEATURE	)
#define ANY_NEW_SECONDARY_FEATURE		(	ANY_NEW_SECONDARIES								)

#define ANY_NEW_PRESTIGE_CLASS			(	IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_1 )	||	\
											IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_2 )	||	\
											IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_3 )	||	\
											IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_4 )	||	\
											IS_ITEM_NEW( FEATURE_PRESTIGE_CLASS_5 )	)

#define ANY_NEW_CAC						(	ANY_NEW_PRESTIGE_CLASS					||	\
											IS_ITEM_NEW( FEATURE_FACEPAINT )		||	\
											ANY_NEW_PRIMARY_FEATURE					||	\
											ANY_NEW_SECONDARY_FEATURE				)


#define ANY_NEW_CHALLENGES				(	IS_ITEM_NEW( FEATURE_CHALLENGES )				||	\
											IS_ITEM_NEW( FEATURE_CHALLENGES_SPECIALS )		||	\
											IS_ITEM_NEW( FEATURE_CHALLENGES_KILLSTREAKS )	)


#define ANY_NEW_PLAYERCARD_FEATURE		(	IS_ITEM_NEW( FEATURE_EMBLEM ) 				||	\
											IS_ITEM_NEW( FEATURE_CLAN_TAG )				||	\
											ANY_NEW_CHALLENGES							||	\
											IS_ITEM_NEW( FEATURE_COMBAT_RECORD )		)


#define ANY_NEW_FEATURE					(	IS_ITEM_NEW( FEATURE_KILLSTREAKS )	||	\
											IS_ITEM_NEW( FEATURE_CONTRACT )		||	\
											ANY_NEW_CAC							||	\
											ANY_NEW_PLAYERCARD_FEATURE			)