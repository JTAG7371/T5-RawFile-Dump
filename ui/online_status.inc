#ifndef SIGNED_IN_X
#define SIGNED_IN_X				-350
#endif

#ifndef SIGNED_IN_Y
#define SIGNED_IN_Y				60
#endif

#ifndef SIGNED_IN_ORIGIN
#define SIGNED_IN_ORIGIN		SIGNED_IN_X SIGNED_IN_Y
#endif

#ifndef SIGNED_IN_WIDTH
#define SIGNED_IN_WIDTH			250
#endif

#ifndef SIGNED_IN_HEIGHT
#define SIGNED_IN_HEIGHT		15
#endif

#ifndef SIGNED_IN_SIZE
#define SIGNED_IN_SIZE			SIGNED_IN_WIDTH SIGNED_IN_HEIGHT
#endif

#define SIGNIN_STATUS \
		itemDef \
		{ \
			type			ITEM_TYPE_OWNERDRAW_TEXT \
			name			signedinas \
			rect			SIGNED_IN_ORIGIN SIGNED_IN_SIZE HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_DEFAULT \
			style			WINDOW_STYLE_EMPTY \
			textscale		TEXTSIZE_SMALL \
			textfont		CHOICE_TEXTFONT \
			forecolor		COLOR_DISABLED \
			ownerdraw		UI_LOGGEDINUSER \
			visible			1 \
			decoration \
		}
#ifdef PC
	#define ONLINE_OFFLINE_BUTTON \
			itemDef \
			{ \
				type			ITEM_TYPE_BUTTON \
				name			button_online \
				exp text		( locString( "@PLATFORM_GO" ) + " " + locString( "@PLATFORM_ONLINE" ) ) \
				rect			(SIGNED_IN_X+100) (SIGNED_IN_Y-30) (SIGNED_IN_WIDTH-100) SIGNED_IN_HEIGHT HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_DEFAULT \
				style			WINDOW_STYLE_EMPTY \
				textalign		ITEM_ALIGN_RIGHT \
				textaligny		15 \
				textscale		TEXTSIZE_SMALL \
				textfont		CHOICE_TEXTFONT \
				forecolor		CHOICE_TEXTCOLOR \
				action			{ exec "dwconnect" } \
				visible			when( dvarBool( ui_showOnlineOfflineButton ) && !dvarBool( dw_loggedin ) ) \
			}
#endif // #ifdef PC
