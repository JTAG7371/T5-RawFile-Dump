#define CAMO_LOCKED								IS_ITEM_LOCKED( FEATURE_CAMO )

#define WEAPOPT_GRP_INDEX( index, group )		( GetWeaponOptionGroupIndex( index, group ) )

#define	CAMO_SELECTED \
		( GetWeaponOptionName( WEAPOPT_GRP_INDEX( dvarInt( ui_stat_camo ), 0 ) ) != "MPUI_NONE" ) 

#define RETICLES_LOCKED							IS_ITEM_LOCKED( FEATURE_RETICLES )
#define RETICLE_COLOR_LOCKED					IS_ITEM_LOCKED( FEATURE_RETICLE_COLOR )

#define LENSESORRETICLES_AVAILABLE														\
		(	( GetAttachmentName( dvarInt( ui_att_slot_top ) ) == "MPUI_REFLEX" )	||	\
			( GetAttachmentName( dvarInt( ui_att_slot_top ) ) == "MPUI_ELBIT" )		)
	
#define	RETICLE_SELECTED \
		( GetWeaponOptionName( WEAPOPT_GRP_INDEX( dvarInt( ui_stat_reticle ), 1 ) ) != "MPUI_RETICLE_DEFAULT" )
	
#define LENSES_LOCKED							IS_ITEM_LOCKED( FEATURE_LENSES )

#define	LENS_SELECTED \
		( GetWeaponOptionName( WEAPOPT_GRP_INDEX( dvarInt( ui_stat_lens ), 2 ) ) != "MPUI_LENS_DEFAULT" )

#define GUN_TAG_LOCKED							IS_ITEM_LOCKED( FEATURE_GUN_TAG )
#define GUN_TAG_PURCHASED						IsItemOptionPurchasedByName( "tag" )

#define GUN_EMBLEM_LOCKED						IS_ITEM_LOCKED( FEATURE_GUN_EMBLEM )
#define GUN_EMBLEM_PURCHASED					IsItemOptionPurchasedByName( "emblem" )	

#define GUN_2NDATTACH_LOCKED					IS_ITEM_LOCKED( FEATURE_SECOND_ATTACHMENT )
#define GUN_2NDATTACH_PURCHASED					IsItemOptionPurchasedByName( "2ndattach" )