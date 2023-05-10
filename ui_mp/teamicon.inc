#ifndef SPLITSCREEN_ENABLED
	#define RECT_TEAMICON		-94 0 92 92 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	#define RECT_TEAMICON2		-162 60 64 64 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	#define LOCAL_FORECOLOR		1 1 1 1
	#define LOCAL_FORECOLOR2	1 1 1 1
#else
	#define RECT_TEAMICON		-35 0 30 30 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	#define RECT_TEAMICON2		-105 25 64 64 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	#define LOCAL_FORECOLOR		1 1 1 1
	#define LOCAL_FORECOLOR2	1 1 1 1
#endif

//---------------- icon ----------------
itemDef	
{
	style			WINDOW_STYLE_SHADER
	type			ITEM_TYPE_IMAGE
	rect			RECT_TEAMICON
	exp				material( dvarString( "g_TeamIcon_Allies" ) );
	forecolor		LOCAL_FORECOLOR
	visible			when ( TEAM_IS_MARINES ); 
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	type			ITEM_TYPE_IMAGE
	rect			RECT_TEAMICON
	exp				material( dvarString( "g_TeamIcon_Axis" ) );
	visible			when ( TEAM_IS_OPFOR );
	forecolor		LOCAL_FORECOLOR
	decoration
}

//--------------- name -----------------
itemDef 
{
	type		ITEM_TYPE_TEXT
	rect		RECT_TEAMICON2
	exp 		text( "@"+dvarString( "g_TeamName_Allies" ) );
	textfont	UI_FONT_NORMAL
	textscale	TEXTSIZE_TITLE
	textalign	ITEM_ALIGN_RIGHT
	textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
	forecolor	LOCAL_FORECOLOR2
	visible 	when ( TEAM_IS_MARINES )
	decoration 
}

itemDef 
{
	type		ITEM_TYPE_TEXT
	rect		RECT_TEAMICON2
	exp 		text( "@"+dvarString( "g_TeamName_Axis" ) );
	textfont	UI_FONT_NORMAL
	textscale	TEXTSIZE_TITLE
	textalign	ITEM_ALIGN_RIGHT
	textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
	forecolor	LOCAL_FORECOLOR2
	visible 	when ( TEAM_IS_OPFOR )
	decoration 
}
