#include "ui_mp/ordnance_disposal_mp.inc"
#include "ui_mp/camo_mp.inc"
#include "ui_mp/hardened_mp.inc"
#include "ui_mp/standard_mp.inc"
#include "ui_mp/utility_mp.inc"

#define ARMOR_NAME( INDEX ) statstablelookup(0,INDEX,4)

#define MOBILITY_VALUE		( dvarfloat( "ui_movespeed" ) * 100 ) + ( ( dvarfloat( "ui_sprinttimetotal" ) - 4 ) * 10 ) + ( ( 0 - dvarfloat( "ui_sprinttimecooldown" ) ) * 10 ) + 75
#define ARMOR_VALUE			( dvarfloat( "ui_armorbullet" ) * 100 ) + ( dvarfloat( "ui_armorexplosive" ) * 5 ) + 25
		
#define SET_ARMOR_VALUES( INDEX ) \
	if( ARMOR_NAME( INDEX ) == "ordnance_disposal_mp" )	{ UI_BODY_ARMOR_MP; } \
	if( ARMOR_NAME( INDEX ) == "camo_mp" )			{ UI_CAMO_MP; } \
	if( ARMOR_NAME( INDEX ) == "hardened_mp" )			{ UI_FLAK_MP; } \
	if( ARMOR_NAME( INDEX ) == "standard_mp" )		{ UI_STANDARD_MP; } \
	if( ARMOR_NAME( INDEX ) == "utility_mp" )		{ UI_UTILITY_MP; }