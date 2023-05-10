
#undef UPLOAD_TO_FILESHARE
#define UPLOAD_TO_FILESHARE \
	execnow set fsSelectedFileName ( dvarString( "ui_customModeEditName" ) ); \
	execnow set fsIsSelectedFileNameModified 0; \
	execnow set fsSelectedFileDescription ( dvarString( "ui_customModeEditDesc" ) ); \
	execnow set fsIsSelectedFileDescriptionModified 0; \
	open menu_game_mode_upload;

#undef	CUSTOM_MODE_BUTTON_SPACING
#define CUSTOM_MODE_BUTTON_SPACING		20
#undef	SAVE_TO_FILESHARE_BUTTON_OFFSET
#define SAVE_TO_FILESHARE_BUTTON_OFFSET	( getTextWidth( locString( "@PLATFORM_BACK" ), CHOICE_TEXTFONT, TEXTSIZE_DEFAULT ) + 8 + CUSTOM_MODE_BUTTON_SPACING )

#undef SAVE_TO_FILESHARE_BUTTON_NEW_FRAME_ACTION
#define SAVE_TO_FILESHARE_BUTTON_NEW_FRAME_ACTION( FRAME_WIDTH, FRAME_HEIGHT ) \
	NEW_FRAME_BUTTON_PC_LEFT_OFFSET( FRAME_WIDTH, FRAME_HEIGHT, SAVE_TO_FILESHARE_BUTTON_OFFSET, "@PLATFORM_BUTTON_SAVE_FILESHARE", \
		UPLOAD_TO_FILESHARE, when( !dvarBool( systemlink ) ) )

#undef SAVE_TO_FILESHARE_BUTTON_NEW_FRAME	
#define SAVE_TO_FILESHARE_BUTTON_NEW_FRAME( FRAME_WIDTH, FRAME_HEIGHT ) \
	itemDef \
	{ \
		type			ITEM_TYPE_BUTTON \
		rect			( (-FRAME_WIDTH / 2) + 80 ) ( FRAME_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		text			"@CUSTOM_BUTTON_SAVE_FILESHARE" \
		textfont		CHOICE_TEXTFONT \
		textscale		TEXTSIZE_DEFAULT \
		textalign		ITEM_ALIGN_BOTTOM_LEFT \
		visible			when( !dvarBool( systemlink ) ) \		
		decoration \
		execKeyInt		BUTTON_X \
		{ \
			UPLOAD_TO_FILESHARE \
		} \
	}

#undef CUSTOMMODEINFO_ORIGIN_X
#undef CUSTOMMODEINFO_ORIGIN_Y
#undef CUSTOMMODEINFO_ORIGIN
#define CUSTOMMODEINFO_ORIGIN_X			-160
#define CUSTOMMODEINFO_ORIGIN_Y			65
#define CUSTOMMODEINFO_ORIGIN			CUSTOMMODEINFO_ORIGIN_X CUSTOMMODEINFO_ORIGIN_Y

#undef CUSTOMMODEINFO_WIDTH
#undef CUSTOMMODEINFO_HEIGHT
#undef CUSTOMMODEINFO_DESC_X
#undef CUSTOMMODEINFO_DESC_Y
#define CUSTOMMODEINFO_WIDTH			160
#define CUSTOMMODEINFO_HEIGHT			100
#define	CUSTOMMODEINFO_DESC_X			-50
#define CUSTOMMODEINFO_DESC_Y			256

#undef CUSTOMMODEINFO_RECT
#define CUSTOMMODEINFO_RECT				CUSTOMMODEINFO_ORIGIN CUSTOMMODEINFO_WIDTH CUSTOMMODEINFO_HEIGHT

#undef CUSTOM_GAMETYPE_IMAGE
#undef CUSTOM_GAMETYPE_NAME
#define CUSTOM_GAMETYPE_IMAGE			tableLookup( "mp/gametypesTable.csv",	0, dvarString( ui_gametype ), 3 )
#define CUSTOM_GAMETYPE_NAME			locString( tableLookup( "mp/gametypesTable.csv", 0, dvarString( ui_gametype ), 1 ) )

#undef SET_CHOICE_DESC
#define SET_CHOICE_DESC( choiceText, choiceDesc, choiceProtip ) \
	execnow set ui_choice_name choiceText; \
	execnow set ui_choice_desc ( choiceDesc ); \
	execnow set ui_choice_protip ( choiceProtip );
#undef CLEAR_CHOICE_DESC
#define CLEAR_CHOICE_DESC \
	execnow set ui_choice_name ""; \
	execnow set ui_choice_desc ""; \
	execnow set ui_choice_protip "";

#undef CUSTOM_BUTTON
#define CUSTOM_BUTTON( itemIndex, textArg, actionArg, descArg, protipArg, visArg ) \
	FRAME_CHOICE_BUTTON_FOCUS_VIS_EX( itemIndex, textArg, actionArg, SET_CHOICE_DESC( textArg, descArg, protipArg ), CLEAR_CHOICE_DESC, visArg, name CHOICE_BUTTON_NAME#itemIndex )

#undef CUSTOM_FRAME_CHOICE_VIS
#define CUSTOM_FRAME_CHOICE_VIS( itemIndex, textArg, visArg )					\
		itemDef																	\
		{																		\
			type			ITEM_TYPE_TEXT										\
			rect			CHOICE_RECT( itemIndex )							\
			exp				text( textArg );									\
			textfont		CHOICE_TEXTFONT										\
			textscale		CHOICE_TEXTSIZE										\
			textstyle		CHOICE_TEXTSTYLE									\
			textAlign		CHOICE_DVAR_TEXTALIGN								\
			textAlignX		CHOICE_DVAR_OFFSET_X								\
			forecolor		TEXT_COLOR_NO_HL									\
			visible			when( visArg );										\
			decoration															\
		}																		\
		itemDef																	\
		{																		\
			type			ITEM_TYPE_TEXT										\
			name			CHOICE_BUTTON_NAME#itemIndex						\
			rect			CHOICE_RECT( itemIndex )							\
			exp				text( textArg );									\
			textfont		CHOICE_TEXTFONT										\
			textscale		CHOICE_TEXTSIZE										\
			textstyle		CHOICE_TEXTSTYLE									\
			textAlign		CHOICE_DVAR_TEXTALIGN								\
			textAlignX		CHOICE_DVAR_OFFSET_X								\
			forecolor		TEXT_COLOR_HL										\
			visible			when( MenuHasFocus() && localVarInt( ui_highlight ) == itemIndex && visArg );	\
			decoration															\
		}

#undef CUSTOM_TOGGLE_PRO_PERKS
#define CUSTOM_TOGGLE_PRO_PERKS \
	execNow "toggle custom_perks_allow_pro 0 1"; \
	execnow buildItemListForSlotName (dvarString( selected_loadout_slot ));

#undef CUSTOM_IS_INSIDE_PERK_POPUP
#define CUSTOM_IS_INSIDE_PERK_POPUP \
	( dvarString( "ui_inside_popup" ) == "specialties_1" || dvarString( "ui_inside_popup" ) == "specialties_2" || dvarString( "ui_inside_popup" ) == "specialties_3" )

#undef CUSTOM_TOGGLE_PRO_PERKS_BUTTON
#define CUSTOM_TOGGLE_PRO_PERKS_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, xArg, textArg, shouldBuildItemListArg, visArg ) \
	itemDef \
	{ \
		type			ITEM_TYPE_BUTTON \
		rect			( (-FRAME_WIDTH / 2) + xArg ) ( FRAME_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		text			textArg \
		textfont		CHOICE_TEXTFONT \
		textscale		TEXTSIZE_DEFAULT \
		textalign		ITEM_ALIGN_BOTTOM_LEFT \
		visible			when( visArg ) \
		execKeyInt		BUTTON_Y { \
			execNow "toggle custom_perks_allow_pro 0 1"; \
			if( shouldBuildItemListArg ) \
			{ \
				execnow buildItemListForSlotName (dvarString( selected_loadout_slot )); \
			} \
		} \
		decoration \
	}
	
#undef CUSTOM_TOGGLE_PRO_PERKS_BUTTON_PC
#define CUSTOM_TOGGLE_PRO_PERKS_BUTTON_PC( textArg, shouldBuildItemListArg, visArg ) \
	itemDef \
	{ \
		type			ITEM_TYPE_BUTTON \
		rect			230 -20 120 20 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM \
		text			textArg \
		textfont		CHOICE_TEXTFONT \
		textscale		TEXTSIZE_DEFAULT \
		textalign		ITEM_ALIGN_MIDDLE_LEFT \
		visible			when( visArg ) \
		action { \
			execNow "toggle custom_perks_allow_pro 0 1"; \
			if( shouldBuildItemListArg ) \
			{ \
				execnow buildItemListForSlotName (dvarString( selected_loadout_slot )); \
			} \
		} \
	}

#undef CUSTOM_TOGGLE_PRO_PERKS_FOR_CAC
#define CUSTOM_TOGGLE_PRO_PERKS_FOR_CAC( FRAME_WIDTH, FRAME_HEIGHT ) \
	CUSTOM_TOGGLE_PRO_PERKS_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, 80, "@CUSTOM_PERKS_BUTTON_ENABLE_PRO", CUSTOM_IS_INSIDE_PERK_POPUP, !dvarBool( custom_perks_allow_pro ) && CUSTOM_IS_INSIDE_PERK_POPUP && dvarInt( "ui_items_no_cost" ) ) \
	CUSTOM_TOGGLE_PRO_PERKS_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, 80, "@CUSTOM_PERKS_BUTTON_DISABLE_PRO", CUSTOM_IS_INSIDE_PERK_POPUP, dvarBool( custom_perks_allow_pro ) && CUSTOM_IS_INSIDE_PERK_POPUP && dvarInt( "ui_items_no_cost" ) )
	
#undef CUSTOM_TOGGLE_PRO_PERKS_PC
#define CUSTOM_TOGGLE_PRO_PERKS_PC \
	CUSTOM_TOGGLE_PRO_PERKS_BUTTON_PC( "@CUSTOM_PERKS_BUTTON_EDIT_PRO", dvarInt( list_perks_in_slot ) != 0, !dvarBool( custom_perks_allow_pro ) ) \
	CUSTOM_TOGGLE_PRO_PERKS_BUTTON_PC( "@CUSTOM_PERKS_BUTTON_EDIT_BASIC", dvarInt( list_perks_in_slot ) != 0, dvarBool( custom_perks_allow_pro ) )

#undef CUSTOM_IS_TOGGLE_PRO_PERKS_VIS
#define CUSTOM_IS_TOGGLE_PRO_PERKS_VIS \
	CUSTOM_IS_INSIDE_PERK_POPUP && dvarInt( "ui_items_no_cost" )

#undef CUSTOM_MODE_RESET_TO_DEFAULT_BUTTON
#define CUSTOM_MODE_RESET_TO_DEFAULT_BUTTON( FRAME_WIDTH, FRAME_HEIGHT, xArg, actionArg, visArg ) \
	itemDef \
	{ \
		type			ITEM_TYPE_BUTTON \
		rect			( xArg ) ( FRAME_HEIGHT / 2 + 18 ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		origin			0 0 \
		text			"@PLATFORM_RESET_TO_DEFAULT" \
		textfont		CHOICE_TEXTFONT \
		textscale		TEXTSIZE_DEFAULT \
		textalign		ITEM_ALIGN_BOTTOM_LEFT \
		execkeyint		BUTTON_BACK \
		{ \
			actionArg \
		} \
		visible			when( visArg ) \
		decoration \
	}

#undef CUSTOM_MODE_CUSTOMIZED_STAR
#define CUSTOM_MODE_CUSTOMIZED_STAR( xPos, yPos, visArg ) \
	itemDef \
	{ \
		style			WINDOW_STYLE_SHADER \
		type			ITEM_TYPE_IMAGE \
		rect			( xPos ) ( yPos - 2 ) 14 14 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		exp				material( "ui_host" ); \
		forecolor		1 1 1 1 \
		visible			when( visArg ) \
		decoration \
	} \
	itemDef \
	{ \
		type			ITEM_TYPE_TEXT \
		rect			( xPos + 17 ) ( yPos ) 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		exp				text( "= " + locString( "CUSTOM_CUSTOMIZED_CAPS" ) ) \
		textfont		CHOICE_TEXTFONT \
		textscale		TEXTSIZE_SMALL \
		textalign		ITEM_ALIGN_TOP_LEFT \
		visible			when( visArg ) \
		decoration \
	}

#undef CUSTOM_FRAME_HINT
#define CUSTOM_FRAME_HINT( dvarName ) \
	HINT_TEXT_ALL_RECT( CHOICE_X_START, ( (NEW_FRAME_DEFAULT_HEIGHT / 2) - 60 ), ( CHOICE_SIZE_X ), dvarString( dvarName ), 1 1 1 1, ( MenuHasFocus() && dvarString( dvarName ) != "" ), ; )

#undef CUSTOM_MODE_BACKGROUND_WATERMARK_SIZE
#define CUSTOM_MODE_BACKGROUND_WATERMARK_SIZE ( (NEW_FRAME_DEFAULT_WIDTH/2-10) + 30 )

#undef CUSTOM_MODE_BACKGROUND_WATERMARK
#define CUSTOM_MODE_BACKGROUND_WATERMARK \
	CUSTOM_MODE_BACKGROUND_WATERMARK_VIS( 1 )

#undef CUSTOM_MODE_BACKGROUND_WATERMARK_VIS
#define CUSTOM_MODE_BACKGROUND_WATERMARK_VIS( visarg ) \
	PREPROC_SHADER_DRAW_VIS_EX( (0-CUSTOM_MODE_BACKGROUND_WATERMARK_SIZE/2) (0-CUSTOM_MODE_BACKGROUND_WATERMARK_SIZE/2+25) CUSTOM_MODE_BACKGROUND_WATERMARK_SIZE CUSTOM_MODE_BACKGROUND_WATERMARK_SIZE HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, "menu_mp_lobby_customgame", 1 1 1 0.05, when( visarg ), ;  )
