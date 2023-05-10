#ifndef CALLVOTE_SUBTITLE
#define CALLVOTE_SUBTITLE ""
#endif

#undef	BUTTON_BG_Y_START	
#define	BUTTON_BG_Y_START				70

CHOICE_MENU_TITLE_ALIGN_VIS( toUpper( "@MPUI_CALLVOTE" ), HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP, ITEM_ALIGN_MIDDLE_LEFT, 1 )

PREPROC_TEXT_DRAW_VIS_EX(	BUTTON_BG_X_START (BUTTON_BG_Y_START+35) 230 60 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP, 0 0,
							( CALLVOTE_SUBTITLE ),
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_LEFT, 1 1 1 1,
							1, autowrapped )

FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MPUI_RESTART_MAP", exec "cmd callvote map_restart"; close self;, 1, ; )
FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MPUI_NEXT_MAP", exec "cmd callvote map_rotate"; close self;, 1, ; )
FRAME_CHOICE_BUTTON_VIS_EX( 3, "@MPUI_CHANGE_GAME_TYPEMAP", open changegametype; close changemap; close kickplayer; hideMenu callvote;, 1, ; )
FRAME_CHOICE_BUTTON_VIS_EX( 4, "@MPUI_KICK_PLAYER", open kickplayer; close changemap; close changegametype; hideMenu callvote;, 1, ; )
