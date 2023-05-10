
#include "ui_mp/navcontrols.inc"

#ifndef GAMETYPE_LIST
#error "GAMETYPE undefined"
#endif

#ifndef GAMETYPE_TABLE
#error "GAMETYPE_TABLE undefined"
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
// -------------- gametype list -------------------
// ------------------------------------------------

#define LOCAL_GAMETYPE_SHOW( p_gametype, p_gametype2 )	\
		hide "gametype_image_group";					\
		hide "gametype_name_group";						\
		hide "gametype_desc_group";						\
		show "image_"p_gametype;						\
		show "name_"p_gametype;							\
		show "desc_"p_gametype;

#define LOCAL_GAMETYPE_ACTION( p_gametype, p_gametype_text )				\
		play CHOICE_FOCUS_SOUND;											\
		setdvar ui_gametype p_gametype;										\
		execOnDvarIntValue splitscreen 1 "exec "SPLITSCREEN_MP_CFG;			\
		execOnDvarIntValue systemlink 1 "exec "SYSTEMLINK_MP_CFG;			\
		execOnDvarIntValue xblive_privatematch 1 "exec "XBOXLIVE_MP_CFG;	\
		close self;

#define LOCAL_GAMETYPE_SELECTION( itemNum, p_gametype_text, p_gametype, vis_arg )\
		CHOICE_BUTTON_FOCUS_VIS_EX( itemNum, p_gametype_text, LOCAL_GAMETYPE_ACTION( p_gametype, p_gametype_text ), LOCAL_GAMETYPE_SHOW( p_gametype, p_gametype_text ), ;, when( vis_arg ), dvartest "ui_gametype" focusdvar { p_gametype } ) \
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-20) 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,					4 18, "@"+tablelookup(GAMETYPE_TABLE,0,p_gametype,1), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_TITLE,		1, name "name_"p_gametype group "gametype_name_group" )\
		PREPROC_TEXT_DRAW_VIS_EX( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-8) GAMEINFO_HEIGHT2 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER,	4 40, "@"+tablelookup(GAMETYPE_TABLE,0,p_gametype,2), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR,	1, name "desc_"p_gametype group "gametype_desc_group" autowrapped )\
		PREPROC_SHADER_DRAW_VIS_EX( 4 -140 GAMEINFO_WIDTH2 (GAMEINFO_HEIGHT-26) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, tablelookup(GAMETYPE_TABLE,0,p_gametype,3), 1 1 1 1, 1, name "image_"p_gametype group "gametype_image_group" )

GAMETYPE_LIST
