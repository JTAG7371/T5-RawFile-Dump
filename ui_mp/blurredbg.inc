
#undef	THINFOG_SCROLL_TIME
#define THINFOG_SCROLL_TIME 50000

// Solid black backing prevents doubling up in subsequent menus.
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"white"
	forecolor		0 0 0 1
	visible			1
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"menu_mp_background_main"
	forecolor		1 1 1 1
	visible			1
	decoration
}

#define BG_WIDTH_4_3 430
#define BG_WIDTH_16_9 322
#define BG_WIDTH ( select( dvarbool( widescreen ), BG_WIDTH_16_9, BG_WIDTH_4_3 ) )

itemDef
{
	style			WINDOW_STYLE_SHADER
	type			ITEM_TYPE_IMAGE
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	exp             rect X( 640 - BG_WIDTH )
	exp             rect W( BG_WIDTH )
	exp				material( dvarString( ui_bg_image ) );		
	forecolor		1 1 1 0.3
	visible			when( !IsPartyReady() && dvarString( ui_bg_image ) != "" )
	decoration
}

#define MAP_LOCKED ( IsPartyReady() && InLobby() )

itemDef
{
	style			WINDOW_STYLE_SHADER
	type			ITEM_TYPE_IMAGE
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	exp             rect X( 640 - BG_WIDTH )
	exp             rect W( BG_WIDTH )
	exp				material( ( "menu_" + dvarString( ui_mapname ) + "_map_select_big" ) );		
	forecolor		1 1 1 0.3
	visible			when( MAP_LOCKED )
	decoration
}

// lower corner glows
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN;
	background		"menu_mp_background_glow"
	forecolor		0.411 0.331 0.111 0
	exp forecolor	a ( ((sin(milliseconds()/1500) + 1) * 0.25) + 0.25 )
	visible			1
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN;
	background		"menu_mp_background_glow"
	forecolor		0.411 0.331 0.111 0
	exp forecolor	a ( ((sin(milliseconds()/480) + 1) * 0.25) + 0.25 )
	visible			1
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			-107 0 1708 480
	exp				rect X((-961) + ((float(milliseconds() % THINFOG_SCROLL_TIME) / THINFOG_SCROLL_TIME) * (854)))
	background		"animbg_fogscrollthin"
	forecolor		1 1 1 0.2
	visible			1
	decoration
}

#include "ui/bg.inc"
