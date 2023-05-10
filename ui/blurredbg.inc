#undef	FOG_SCROLL_TIME
#define FOG_SCROLL_TIME 60000 //30000

#undef	THINFOG_SCROLL_TIME
#define THINFOG_SCROLL_TIME 50000 //50000

//SP
#define MAIN_BG_SP \
	TOP_BOTTOM_BORDERS
//	MAIN_BG( "menu_background_sp" ) \
//	SCROLL_FOG \

#define INGAME_FULLSCREEN_BG \
itemDef \
{ \
	style		WINDOW_STYLE_SHADER \
	rect		-4 -4 648 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN \
	forecolor	0 0 0 0.55 \
	background	"white"   \
	visible		1 \
	decoration \
}

#define SP_SUBMENU_BG \
	TOP_BOTTOM_BORDERS
//	MAIN_BG( "menu_background_sp_blurred" ) \

//COOP
#define MAIN_BG_COOP \
	TOP_BOTTOM_BORDERS
//	MAIN_BG( "menu_background_coop" ) \
//	SCROLL_FOG \

//MP
#define MAIN_BG_MP \
	MAIN_BG( "menu_background_mp_tank" ) \
	SCROLL_FOG \
	TOP_BOTTOM_BORDERS

#define MAIN_BG( pshader ) \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			FULLSCREEN_WIDE 0 0 \
	background		pshader \
	visible			1 \
	decoration \
}

#define TOP_BOTTOM_BORDERS \
/* top black border */ \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			-107 0 854 66 0 0 \
	forecolor		1 1 1 1 \
	background		"menu_black_line" \
	visible			1 \
	decoration \
} \
/* bottom black border */ \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			-107 420 854 70 0 0 \
	forecolor		1 1 1 1 \
	background		"menu_black_line" \
	visible			1 \
	decoration \
}

#define SCROLL_FOG \
itemDef \
{ \
	style			WINDOW_STYLE_SHADER \
	rect			-107 0 1708 480 0 0 \
	exp				rect X((-961) + ((float(milliseconds() % THINFOG_SCROLL_TIME) / THINFOG_SCROLL_TIME) * (854))) \
	background		"animbg_fogscrollthin" \
	visible			1 \
	decoration \
}
