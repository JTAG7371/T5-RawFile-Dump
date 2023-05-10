// This include file attempts to unify sliding tab menus to make them all as similar as possible.
// it also facilitates porting to PC platform

#ifdef CONSOLE

#define SLIDER_RECT_ORIGIN_X	0
#define SLIDER_RECT_ORIGIN_Y	0

#else

#define SLIDER_RECT_ORIGIN_X	0
#define SLIDER_RECT_ORIGIN_Y	0

#endif

#define SLIDER_RECT_ORIGIN SLIDER_RECT_ORIGIN_X SLIDER_RECT_ORIGIN_Y
#define BACKGROUND_IMAGES_X_START	-545

#define LIST_X_START				-535
#define LIST_Y_START				100

#define TAB_X_START						LIST_X_START

#define TAB_LINE_WIDTH					3
#define TAB_UNSELECTED_WIDTH			32

#define TAB_BUMPER_BUTTONS_WIDTH	185

#ifdef CONSOLE
#define TAB_BUMPER_BUTTONS(px, py, pwidth, leftActionArg, rightActionArg) \
	/* Cycle buttons */ \
	itemDef \
	{ \
		name			"LB" \
		type			ITEM_TYPE_BUTTON \
		rect			px py 20 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
		origin			0 0 \
		forecolor		1 1 1 0.75 \
		text			"@PLATFORM_CAC_PREV" \
		textfont		CHOICE_TEXTFONT \
		textscale		TEXTSIZE_DEFAULT \
		textalign		ITEM_ALIGN_TOP_LEFT \
		visible			1 \
		decoration \
		 \
		state \
		{ \
			name		"Flash" \
			forecolor	1 1 1 1 \
			onEnter \
			{ \
				changeState Default 250; \
			} \
		} \
	} \
	itemDef \
	{ \
		name			"RB" \
		type			ITEM_TYPE_BUTTON \
		rect			(px+pwidth) py 20 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
		origin			0 0 \
		forecolor		1 1 1 0.75 \
		text			"@PLATFORM_CAC_NEXT" \
		textfont		CHOICE_TEXTFONT \
		textscale		TEXTSIZE_DEFAULT \
		textalign		ITEM_ALIGN_TOP_LEFT \
		visible			1 \
		decoration \
		 \
		state \
		{ \
			name		"Flash" \
			forecolor	1 1 1 1 \
			onEnter \
			{ \
				changeState Default 250; \
			} \
		} \
	}
#else // #ifdef CONSOLE
	#define TAB_BUMPER_BUTTONS(px, py, pwidth, leftActionArg, rightActionArg ) \
	/* Cycle buttons */ \
	itemDef \
	{ \
		name			"LB" \
		type			ITEM_TYPE_BUTTON \
		style			WINDOW_STYLE_SHADER \
		background		"ui_arrow_left" \
		rect			px py 16 16 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
		origin			0 0 \
		forecolor		1 1 1 1 \
		mouseEnter 		{ play CHOICE_FOCUS_SOUND; } \
		action			{ leftActionArg } \
		visible			1 \
		mouseenter { setcolor forecolor 0.98 0.83 0.25 1 }	\
		mouseexit { setcolor forecolor 1 1 1 1 }			\
	} \
	itemDef \
	{ \
		name			"RB" \
		type			ITEM_TYPE_BUTTON \
		style			WINDOW_STYLE_SHADER \
		background		"ui_arrow_right" \
		rect			(px+pwidth) py 16 16 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
		origin			0 0 \
		forecolor		1 1 1 1 \
		mouseEnter 		{ play CHOICE_FOCUS_SOUND; } \
		action			{ rightActionArg } \
		visible			1 \
		mouseenter { setcolor forecolor 0.98 0.83 0.25 1 }	\
		mouseexit { setcolor forecolor 1 1 1 1 }			\
	}
#endif // #else // #ifdef CONSOLE
