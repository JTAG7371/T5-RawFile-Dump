
#define FRIEND_CAPTION_VIS( textArg, x, y, w, h, alignx, aligny, visArg ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(x) (y) (w) (h) alignx aligny \
			origin			ORIGIN_TITLE \
			forecolor		COLOR_HEADER \
			exp				text( textArg ); \
			textfont		UI_FONT_NORMAL \
			textscale		TEXTSIZE_TITLE \
			textstyle		CHOICE_TEXTSTYLE \
			textalign		ITEM_ALIGN_TOP_LEFT \ 
			textaligny		TITLE_Y_OFFSET \
			textalignx		TITLE_X_OFFSET \
			visible			visArg \
			decoration  \
		}

#define FRIEND_CAPTION_RIGHT( textArg, x, y, w, h, alignx, aligny ) \
		itemDef \
		{ \
			type			ITEM_TYPE_TEXT \
			rect			(x) (y) (w) (h) alignx aligny \
			origin			ORIGIN_TITLE \
			forecolor		COLOR_HEADER \
			exp				text( textArg ); \
			textfont		UI_FONT_NORMAL \
			textscale		TEXTSIZE_TITLE \
			textstyle		CHOICE_TEXTSTYLE \
			textalign		ITEM_ALIGN_TOP_RIGHT \ 
			textaligny		TITLE_Y_OFFSET \
			textalignx		TITLE_X_OFFSET \
			visible			MENU_TRUE \
			decoration  \
		}

#define FRIEND_LOGO_VIS( x, y, visArg ) \
		itemDef \
		{ \
			rect			x y 256 64 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP \
			origin			0 0 \
			style			WINDOW_STYLE_SHADER \
			background		"logo_cod2" \
			visible			visArg \
			decoration \
		}

#define FRIEND_COLUMN_VIS( textArg, x, y, w, h, alignx, aligny, orig, actionArg, visArg ) \
		itemDef \
		{ \
			type            ITEM_TYPE_BUTTON \
			exp				text( textArg ); \
			textfont        UI_FONT_NORMAL \
			style           WINDOW_STYLE_FILLED \
			textstyle       ITEM_TEXTSTYLE_SHADOWED \
			rect			(x) (y) (w) (h) alignx aligny \
			origin          orig \
			textscale       .33 \
			textalignx		0 \
			textaligny      12 \
			forecolor       CHOICE_TEXTCOLOR \
			visible         visArg \
			mouseEnter      { play CHOICE_FOCUS_SOUND; } \
			action \
			{ \
				play CHOICE_FOCUS_SOUND; \
				actionArg; \
			} \
  		}

#define FRIEND_BUTTON_VIS( textArg, x, y, w, h, alignx, aligny, actionArg, visArg ) \
		itemDef \
		{ \
			type            ITEM_TYPE_BUTTON \
			exp				text( textArg ); \
			textfont        UI_FONT_NORMAL \
			style           WINDOW_STYLE_FILLED \
			textstyle       ITEM_TEXTSTYLE_SHADOWED \
			rect			(x) (y) (w) (h) alignx aligny \
			textalign       ITEM_ALIGN_CENTER \
			textscale       .33 \
			textaligny      15 \
			forecolor       CHOICE_TEXTCOLOR \
			visible         visArg \
			mouseEnter     { play CHOICE_FOCUS_SOUND; } \
			action \
			{ \
				play CHOICE_FOCUS_SOUND; \
				actionArg; \
			} \
  		}

#define FRIEND_DBUTTON_VIS( textArg, x, y, w, h, alignx, aligny, visArg ) \
		itemDef \
		{ \
			type            ITEM_TYPE_TEXT \
			exp				text( textArg ); \
			textfont        UI_FONT_NORMAL \
			style           WINDOW_STYLE_FILLED \
			textstyle       ITEM_TEXTSTYLE_SHADOWED \
			rect			(x) (y) (w) (h) alignx aligny \
			textalign       ITEM_ALIGN_CENTER \
			textscale       .33 \
			textaligny      15 \
			forecolor       CHOICE_TEXTCOLOR_DISABLED \
			visible         visArg \
			decoration \
  		}

