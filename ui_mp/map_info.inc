
#include "ui_mp/navcontrols.inc"

#ifndef MAP_LIST
#error "MAP_LIST undefined"
#endif

#ifndef MAP_TABLE
#error "MAP_TABLE undefined"
#endif

//--- style override ---
#undef CHOICE_Y_SPACING
#define CHOICE_Y_SPACING		20

#undef CHOICE_TEXTSIZE
#define CHOICE_TEXTSIZE			TEXTSIZE_SMALL

#undef HIGHLIGHT_COLOR
#define HIGHLIGHT_COLOR			0.9 0.95 1 0.25

//--- end style override ---

// ----------------------------map images------------------------------------
#define GAMEINFO_WIDTH			270
#define GAMEINFO_WIDTH2			275
#define GAMEINFO_HEIGHT			200
#define GAMEINFO_HEIGHT2		120
#define GAMEINFO_ORIGIN			4 -160

// ------------------------------------------------
// ------------------ map list --------------------
// ------------------------------------------------

#define LOCAL_MAP_SHOW( p_mapname, p_mapname2 )	\
		hide "map_image_group";					\
		hide "map_name_group";					\
		hide "map_desc_group";					\
		setdvar ui_mapname2_text p_mapname2;	\
		show "image_"p_mapname;					\
		show "name_"p_mapname;					\
		show "desc_"p_mapname;

#define LOCAL_MAP_ACTION( p_mapname, p_mapname_text )	\
		play CHOICE_FOCUS_SOUND;						\
		setdvar ui_mapname p_mapname;					\
		setdvar ui_mapname_text p_mapname_text;			\
		close self;

#define LOCAL_MAP_SELECTION( itemNum, p_mapname_text, p_mapname, vis_arg )\
		CHOICE_BUTTON_FOCUS_VIS_EX( itemNum, p_mapname_text, LOCAL_MAP_ACTION( p_mapname, p_mapname_text ), LOCAL_MAP_SHOW( p_mapname, p_mapname_text ), ;, when( vis_arg ), dvartest "ui_mapname" focusdvar { p_mapname } ) \
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-20) 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,					4 18,					"@"+tablelookup(MAP_TABLE,0,p_mapname,3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_TITLE,		1, name "name_"p_mapname group "map_name_group" ) \
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-8) GAMEINFO_HEIGHT2 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,	4 (GAMEINFO_HEIGHT+20),	"@"+tablelookup(MAP_TABLE,0,p_mapname,6), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR,	1, name "desc_"p_mapname group "map_desc_group" autowrapped ) \
		PREPROC_SHADER_DRAW_VIS_EX( 4 -140 GAMEINFO_WIDTH2 (GAMEINFO_HEIGHT-26) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, tablelookup(MAP_TABLE,0,p_mapname,4), 1 1 1 1, 1, name "image_"p_mapname group "map_image_group" )

MAP_LIST
