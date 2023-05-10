#ifndef	INFO_BOX_ORIENT
	#define INFO_BOX_TITLE_HEIGHT		20
	#define INFO_BOX_WIDTH				(CHOICE_SIZE_X-(INFO_BOX_TITLE_HEIGHT/3))
	#define INFO_BOX_HEIGHT				100//126
	#define INFO_BOX_X					2//0//-260//(CHOICE_X_START)
	#define INFO_BOX_Y					-130//270
	#define ORIGIN_INFO_BOX_TITLE		INFO_BOX_X INFO_BOX_Y
#endif

#define INFO_BOX_WIDTH2				(INFO_BOX_WIDTH+30)
#define ORIGIN_INFO_BOX				INFO_BOX_X (INFO_BOX_Y+25)
#define ORIGIN_INFO_BOX_FRAME		INFO_BOX_X INFO_BOX_Y

#ifndef	INFO_TEXT 				
#define INFO_TEXT				dvarString( "motd" )
#endif

#ifndef INFO_TITLE
#define INFO_TITLE				"@MPUI_MOTD"
#endif

#ifndef INFO_TITLE_COLOR
#define INFO_TITLE_COLOR		1 1 1 1
#endif

#ifndef INFO_TEXT_COLOR
#define INFO_TEXT_COLOR			0.69 0.69 0.69 1
#endif

#ifndef	INFO_TITLE_COLOR_DEV
#define	INFO_TITLE_COLOR_DEV	1 0.5725 0.0196 1
#endif

#ifndef	INFO_TEXT_COLOR_DEV
#define	INFO_TEXT_COLOR_DEV		0.69 0.2625 0 1
#endif

#define PREPROC_TEXT_DRAW_ALIGNED_EXP_MOTD( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor, visArg ) \
itemDef { \
	type			ITEM_TYPE_TEXT \
	rect			prect \
	origin 			porigin \
	textfont		CHOICE_TEXTFONT \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textalignx		palignx \
	textaligny		paligny \
	textscale		psize \
	forecolor		pcolor \
	exp				text( ptext ); \
	visible			visArg \ 
	decoration \
	autowrapped }

//title
PREPROC_TEXT_DRAW_ALIGNED_EXP_MOTD( ORIGIN_INFO_BOX_FRAME INFO_BOX_WIDTH 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM, 20 0, INFO_TITLE, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, INFO_TITLE_COLOR, 1 )
//message
PREPROC_TEXT_DRAW_ALIGNED_EXP_MOTD( ORIGIN_INFO_BOX (INFO_BOX_WIDTH-4) 100 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM, 20 0, INFO_TEXT, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, INFO_TEXT_COLOR, 1 )
