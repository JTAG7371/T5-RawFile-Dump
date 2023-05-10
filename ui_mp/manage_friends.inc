
#include "ui_mp/friends_common.inc"	
	menuDef
	{
		name			manage_friends
		fullscreen		1
		rect			0 0 640 480 //RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
		focuscolor		COLOR_FOCUSED
		style			WINDOW_STYLE_FILLED
		soundloop 		MENU_MUSIC
		onOpen			{ }
		onclose			{ setLocalVarBool ui_hideBack 0; setLocalVarBool ui_showInvite 0; }
		onESC 			{ setLocalVarBool ui_hideBack 0; setLocalVarBool ui_showInvite 0; close self; }

		#undef BACK_OPEN
		#define BACK_OPEN	;
		#include "ui/blurredbg.inc"
		#include "ui_mp/navcontrols.inc"

		FRIEND_CAPTION_VIS( "@MENU_INVITE_FRIEND", 22, 5, 100, 100, HORIZONTAL_ALIGN_LEFT, VERTICAL_ALIGN_TOP, when( localVarBool( ui_showInvite )); )
		FRIEND_CAPTION_RIGHT( dvarString( com_playerProfile ), 487, 5, 100, 100, HORIZONTAL_ALIGN_LEFT, VERTICAL_ALIGN_TOP )

		// player list frame clone
		// caption liner
		PREPROC_SHADER_DRAW( LB_GROUP_X (-4+LB_GROUP_Y) LIST_BOX_FR_WIDTH 16 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP, "white", PLATING_COLOR )
		// highliter at the bottom of the list box ( underliner )
		PREPROC_SHADER_DRAW( LB_GROUP_X (LIST_BOX_FR_HEIGHT+12+LB_GROUP_Y) LIST_BOX_FR_WIDTH 8 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP, "white", PLATING_COLOR )
		
		// Friends listbox section
#undef SECTION_X_OFFSET
#define SECTION_X_OFFSET -20
#undef CHOICE_Y_START
#define CHOICE_Y_START   15
		CHOICE_SECTION_TITLE_VIS( 3, "@MENU_FRIENDS_CAPS", when( !localVarBool( ui_hideBack ) || localVarBool( ui_showInvite )) )

		FRIEND_COLUMN_VIS( "@MENU_NAME", LB_COLUMN1_OFFSET_X, 0, 50, 20, HORIZONTAL_ALIGN_LEFT, VERTICAL_ALIGN_TOP, LB_GROUP_ORIGIN, uiScript sortFriends 0;, MENU_TRUE )
		FRIEND_COLUMN_VIS( "@MENU_STATUS1", LB_COLUMN3_OFFSET_X, 0, 50, 20, HORIZONTAL_ALIGN_LEFT, VERTICAL_ALIGN_TOP, LB_GROUP_ORIGIN, uiScript sortFriends 2;, MENU_TRUE )
		itemDef 
		{
			name			friend_list
			type			ITEM_TYPE_LISTBOX
			feeder			FEEDER_FRIENDS
			rect			0 LB_BOX_OFFSET_Y (LIST_BOX_FR_WIDTH-2) (LIST_BOX_FR_HEIGHT-4) HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
			origin          LB_GROUP_ORIGIN
			elementwidth	120
			elementheight	18
			textalignx		2
			textaligny		0
			textscale		TEXTSIZE_SMALL
			textfont		UI_FONT_NORMAL
			forecolor		1 1 1 0.75
			forecolor		CHOICE_TEXTCOLOR
			focusColor		CHOICE_TEXTCOLOR
			disableColor 	CHOICE_TEXTCOLOR
			outlinecolor	0.9 0.9 0.925 0.2
			selectBorder	0.8 0.95 1 0
			columns			2 
			                LB_COLUMN1_OFFSET_X 0 20 
			                LB_COLUMN3_OFFSET_X 0 8
			visible			when( !localVarBool( ui_hideBack ) );
			
			onfocus 
			{
				play CHOICE_FOCUS_SOUND;
			}
			execkeyint 13
			{
				play CHOICE_FOCUS_SOUND;
				close manage_friends;
			}
			doubleclick
			{
				play CHOICE_FOCUS_SOUND;
				//exec "accept invite";
			}
		}

		// --------------------  buttons ---------------------------------
  		FRIEND_BUTTON_VIS( "@MENU_SEND_INVITE", 220, 420, 80, 20, HORIZONTAL_ALIGN_LEFT, CHOICE_VERTICAL_ALIGN, uiScript inviteFriend, when (hasfriends()> 0 && localVarBool( ui_showInvite ));  )
  		FRIEND_DBUTTON_VIS( "@MENU_SEND_INVITE", 220, 420, 80, 20, HORIZONTAL_ALIGN_LEFT, CHOICE_VERTICAL_ALIGN, when (hasfriends()== 0 && localVarBool( ui_showInvite ) ) ; )

  	}//menuDef manage_friends

