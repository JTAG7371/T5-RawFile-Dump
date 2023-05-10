
#undef	POPUP_BUTTON_COUNT
#define	POPUP_BUTTON_COUNT		3

	/////////////////////
	//
	// Enter Friend's name
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( friend_add_popmenu, setdvar ui_friendNameNew ""; setfocus friend_add_popmenu_1;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "Enter Friend's name", 1 )

		itemDef
		{
			name			friend_add_popmenu_1
			TYPE			ITEM_TYPE_VALIDFILEFIELD
			text			"@MENU_NAME"
			dvar			"ui_friendNameNew"
			rect			CHOICE_RECT( 1 )
			textaligny		-2
			maxchars		12
			maxpaintchars	20
			textalign		ITEM_ALIGN_MIDDLE_LEFT
			textfont		UI_FONT_NORMAL
			textscale		TEXTSIZE_SMALL
			forecolor		.9 .9 .9 1
			style			WINDOW_STYLE_FILLED
			backcolor		0 0 0 .3
			visible			1
			accept			{ uiScript sendRequestFriend; close self; }
		}
		FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MENU_OK",		uiScript sendRequestFriend; close self;,	1, ; )
		FRAME_CHOICE_BUTTON_VIS_EX( 3, "@MENU_CANCEL",	close self;,								1, ; )
	}

#undef	POPUP_BUTTON_COUNT
#define	POPUP_BUTTON_COUNT		2

	/////////////////////
	//
	// Delete for sure? popup
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( friend_del_sure_popmenu, ;, ;, 1 )
		SYSTEM_POPUP_TITLE_VIS( "Delete selected friend?", 1 )
		
		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_YES",	uiScript deleteFriend; close self;,	1, ; )
		FRAME_CHOICE_BUTTON_VIS_EX( 2, "@MENU_NO",	close self;,						1, ; )
	}

#undef	POPUP_BUTTON_COUNT
#define	POPUP_BUTTON_COUNT		1

	/////////////////////
	//
	// Check for number of friends limit.
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( friends_too_many, ;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "@MENU_FRIENDSLIMIT", 1 )

		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )
	}

	/////////////////////
	//
	// Expired invite - friend not online.
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( friends_not_online, ;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "@MENU_EXPIRED_INVITE", 1 )

		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )
	}

	/////////////////////
	//
	// Invite sent confirmation popup.
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( invite_sent, ;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "@MENU_INVITE_SENT", 1 )

		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )
	}

	/////////////////////
	//
	// Invite accpeted confirmation popup.
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( invite_accepted, ;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "@MENU_INVITE_ACCEPTED", 1 )

		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )
	}

	/////////////////////
	//
	// Outgoing request to friend already sent.
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( request_sent, ;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "@MENU_REQUEST_SENT", 1 )

		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )
	}

	/////////////////////
	//
	// Friend name doesn not exist.
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( invalid_friend, ;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "@MENU_INVALID_FRIEND_ID", 1 )

		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )
	}

	/////////////////////
	//
	// Can not send game invite to this person yet.
	//
	/////////////////////
	menuDef
	{
		SYSTEM_POPUP_SETUP_VIS( not_friends_yet, ;, ;, 1 )
		
		SYSTEM_POPUP_TITLE_VIS( "@MENU_NOT_FRIENDS_YET", 1 )

		FRAME_CHOICE_BUTTON_VIS_EX( 1, "@MENU_OK", close self;, 1, ; )
	}
