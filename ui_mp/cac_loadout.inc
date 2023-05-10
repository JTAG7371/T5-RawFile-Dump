
#define LOADOUT_WIDTH 				270

#define LOADOUT_IMAGE_X				110
#define LOADOUT_IMAGE_Y				0

#define LOADOUT_TITLE_X				20
#define LOADOUT_TITLE_Y				(LOADOUT_IMAGE_Y + 100)

#define LOADOUT_DESC_X				(LOADOUT_TITLE_X)
#define LOADOUT_DESC_Y				(LOADOUT_TITLE_Y + 20)

#define ORIGIN_X					((-(LOADOUT_WIDTH - RIGHTITEM_OFFSET))-10)
#define ORIGIN_Y					38
#define ORIGIN_LOADOUT				ORIGIN_X ORIGIN_Y


#define RATEBAR_FRAME_BORDER		0//WINDOW_BORDER_SUNKEN
#define RATEBAR_FRAME_BORDERSIZE	2
#define RATEBAR_FRAME_BORDERCOLOR	0.4 0.4 0.425 1

#define RATEBAR_BAR_SHADER			"gradient_fadein"
#define RATEBAR_BAR_COLOR			1 1 1 0.3

#define ATTRIBUTE_BACK_COLOR		0.1804 0.1961 0.2078 0.5
#define ATTRIBUTE_FILL_COLOR		0.2862 0.3098 0.3098 0.8

#define RATE_BAR_WIDTH				98
#define RATE_BAR_HEIGHT				12
	
#define VIS_WHEN_ATTACH_PLUS(pweapon,pattribute)	when( (STAT_CAC_PRIMARY_ATTACHMENT != 0) && (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) > 0) )
#define VIS_WHEN_ATTACH_MINUS(pweapon,pattribute)	when( (STAT_CAC_PRIMARY_ATTACHMENT != 0) && (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) < 0) ) 

#define VIS_WHEN_ATTACH_PLUS_PREVIEW(pweapon,pattribute,extraArg)	when( (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) > 0) && extraArg )
#define VIS_WHEN_ATTACH_MINUS_PREVIEW(pweapon,pattribute,extraArg)	when( (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) < 0) && extraArg ) 

#define IS_ONE_PRIME			("perk_professional" != GetItemRef( STAT_CAC_SPECIALTY2 ) )
#define IS_TWO_PRIME			("perk_professional" == GetItemRef( STAT_CAC_SPECIALTY2 ) )
#define IS_DEFAULT_ONE_PRIME	("perk_professional" != GetItemRef( CAC_DEFAULT_SPECIALTY2 ) )
#define IS_DEFAULT_TWO_PRIME	("perk_professional" == GetItemRef( CAC_DEFAULT_SPECIALTY2 ) )

#define CAC_PRI_ATTACHMENT_SLOT			getItemAttachment( STAT_CAC_PRIMARY, STAT_CAC_PRIMARY_ATTACHMENT )
#define CAC_PRI_ATTACHMENT_SLOT_TOP		getItemAttachment( STAT_CAC_PRIMARY, STAT_CAC_PRIMARY_ATTACHMENT_TOP )
#define CAC_PRI_ATTACHMENT_SLOT_BOTTOM	getItemAttachment( STAT_CAC_PRIMARY, STAT_CAC_PRIMARY_ATTACHMENT_BOTTOM )
#define CAC_PRI_ATTACHMENT_SLOT_TRIGGER	getItemAttachment( STAT_CAC_PRIMARY, STAT_CAC_PRIMARY_ATTACHMENT_TRIGGER )
#define CAC_PRI_ATTACHMENT_SLOT_MUZZLE	getItemAttachment( STAT_CAC_PRIMARY, STAT_CAC_PRIMARY_ATTACHMENT_MUZZLE )

#define CAC_SEC_ATTACHMENT_SLOT			getItemAttachment( STAT_CAC_SECONDARY, STAT_CAC_SECONDARY_ATTACHMENT )
#define CAC_SEC_ATTACHMENT_SLOT_TOP		getItemAttachment( STAT_CAC_SECONDARY, STAT_CAC_SECONDARY_ATTACHMENT_TOP )
#define CAC_SEC_ATTACHMENT_SLOT_BOTTOM	getItemAttachment( STAT_CAC_SECONDARY, STAT_CAC_SECONDARY_ATTACHMENT_BOTTOM )
#define CAC_SEC_ATTACHMENT_SLOT_TRIGGER	getItemAttachment( STAT_CAC_SECONDARY, STAT_CAC_SECONDARY_ATTACHMENT_TRIGGER )
#define CAC_SEC_ATTACHMENT_SLOT_MUZZLE	getItemAttachment( STAT_CAC_SECONDARY, STAT_CAC_SECONDARY_ATTACHMENT_MUZZLE )

/* ================================================================================= */
/* ================================ LOADOUT DISPLAY ================================ */
/* ================================================================================= */

	#define LOADOUT_ALIGN 	HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	
// attributes box ======================

#ifndef HIDE_WEAPON_ATTRIBUTE		

	#define INFO_BOX_ORIENT			0
	#define INFO_BOX_WIDTH			222
	#define INFO_BOX_HEIGHT			126
	#define INFO_BOX_X				(CHOICE_X_START+CHOICE_SIZE_X-INFO_BOX_WIDTH)
	#define ATTRIBUTE_BAR_X			INFO_BOX_X+268

	#ifdef PC  
		#define INFO_BOX_Y				320
	#else     
		#define INFO_BOX_Y				285//274
	#endif     
	
	#define ORIGIN_ATTRIBUTE_LABEL	(INFO_BOX_X+150) (INFO_BOX_Y)//(INFO_BOX_Y+10)

	// meter bar unit dividers
	#define ATTRIBUTE_UNITS( px, py )																																\
			PREPROC_SHADER_DRAW( (px+(RATE_BAR_WIDTH/4)) (py+RATE_BAR_HEIGHT) 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,		"line_vertical", 1 1 1 0.2 )	\
			PREPROC_SHADER_DRAW( (px+(RATE_BAR_WIDTH/2)) (py+RATE_BAR_HEIGHT) 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,		"line_vertical", 1 1 1 0.2 )	\
			PREPROC_SHADER_DRAW( (px+((RATE_BAR_WIDTH/4)*3)) (py+RATE_BAR_HEIGHT) 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,	"line_vertical", 1 1 1 0.2 )
		
	// weapon attribut meter bars
	#define ATTRIBUTE_BAR_FORMAT( px, py, pnum )																																							\
			ATTRIBUTE_UNITS( px, py )																																										\
			PREPROC_SHADER_DRAW( px py (-(RATE_BAR_WIDTH)) RATE_BAR_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, "white", ATTRIBUTE_BACK_COLOR )														\
			PREPROC_SHADER_DRAW_ADV(	px,																																									\
										py,																																									\
										(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum ))+														\
										(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+															\
										CAC_PRI_ATTACHMENT_SLOT, pnum ))))*RATE_BAR_WIDTH/100,																												\
										RATE_BAR_HEIGHT,																																					\
										CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																															\
										"white", ATTRIBUTE_FILL_COLOR )																																		\
			PREPROC_SHADER_DRAW_ADV(	px,																																									\
										py,																																									\
										(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum ))+														\
										(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+															\
										CAC_PRI_ATTACHMENT_SLOT, pnum ))))*RATE_BAR_WIDTH/100,																												\
										RATE_BAR_HEIGHT,																																					\
										CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																															\
										RATEBAR_BAR_SHADER, ATTRIBUTE_BACK_COLOR )																															\
			/* attachment delta bar -*/																																										\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px+(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum )))*RATE_BAR_WIDTH/100+							\
											((int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+CAC_PRI_ATTACHMENT_SLOT, pnum )))*RATE_BAR_WIDTH/100),	\
											py,																																								\
											(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+CAC_PRI_ATTACHMENT_SLOT, pnum )))*RATE_BAR_WIDTH/100,	\
											RATE_BAR_HEIGHT,																																				\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																														\
											"white", 0.4 0.15 0.15 1,																																		\
											VIS_WHEN_ATTACH_MINUS(tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+CAC_PRI_ATTACHMENT_SLOT,pnum), ; )												\
			/* attachment delta bar +*/																																										\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px+(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum )))*RATE_BAR_WIDTH/100,							\
											py,																																								\
											(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+CAC_PRI_ATTACHMENT_SLOT, pnum )))*RATE_BAR_WIDTH/100,	\
											RATE_BAR_HEIGHT,																																				\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																														\
											"white", 0.3 0.8 0.3 0.5,																																		\
											VIS_WHEN_ATTACH_PLUS(tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+CAC_PRI_ATTACHMENT_SLOT,pnum), ; )

	#define PREVIEW_VIS_CONDITION when( PREVIEW_VIS_CONDITION_RAW );
	#define PREVIEW_VIS_CONDITION_RAW dvarInt( ui_show_preview )

	#define ATTRIBUTE_BAR_FORMAT_PREVIEW( px, py, pnum )																																				\
			ATTRIBUTE_UNITS( px, py )																																									\
			PREPROC_SHADER_DRAW_VIS_EX( px py (-(RATE_BAR_WIDTH)) RATE_BAR_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, "white", 0 0 0 1, PREVIEW_VIS_CONDITION, ; )								\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px,																																							\
											py,																																							\
											(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum ))+																	\
											(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+																		\
											dvarString(ui_attachment_highlighted), pnum ))))*RATE_BAR_WIDTH/100,																						\
											RATE_BAR_HEIGHT,																																			\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																													\
											"white", ATTRIBUTE_FILL_COLOR, PREVIEW_VIS_CONDITION, ; )																									\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px,																																							\
											py,																																							\
											(100)*RATE_BAR_WIDTH/100,																																	\
											RATE_BAR_HEIGHT,																																			\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																													\
											RATEBAR_BAR_SHADER, ATTRIBUTE_BACK_COLOR, PREVIEW_VIS_CONDITION, ; )																						\
			/* attachment delta bar -*/																																									\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px+(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum )))*RATE_BAR_WIDTH/100+											\
											((int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100),	\
											py,																																							\
											(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100,	\
											RATE_BAR_HEIGHT,																																			\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																													\
											"white", 0.4 0.15 0.15 1,																																	\
											VIS_WHEN_ATTACH_MINUS_PREVIEW(dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted),pnum, PREVIEW_VIS_CONDITION_RAW ), ; )			\
			/* attachment delta bar +*/																																									\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px+(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum )))*RATE_BAR_WIDTH/100,											\
											py,																																							\
											(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100,	\
											RATE_BAR_HEIGHT,																																			\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																													\
											"white", 0.3 0.8 0.3 0.5,																																	\
											VIS_WHEN_ATTACH_PLUS_PREVIEW(dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted),pnum, PREVIEW_VIS_CONDITION_RAW ), ; )
		
	#define ATTRIBUTE_BAR_FORMAT_PREVIEW_NA( px, py, pnum )																													\
			ATTRIBUTE_UNITS( px, py )																																		\
			PREPROC_SHADER_DRAW_VIS_EX( px py (-(RATE_BAR_WIDTH)) RATE_BAR_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, "white", 0 0 0 1, PREVIEW_VIS_CONDITION, ; )	\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px,																																\
											py, 																															\
											(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum )))*RATE_BAR_WIDTH/100,					\
											RATE_BAR_HEIGHT,																												\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																						\
											"white", ATTRIBUTE_FILL_COLOR,																									\
											PREVIEW_VIS_CONDITION, ; )																										\
			PREPROC_SHADER_DRAW_ADV_VIS_EX(	px,																																\
											py,																																\
											(100)*RATE_BAR_WIDTH/100,																										\
											RATE_BAR_HEIGHT,																												\
											CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP,																						\
											RATEBAR_BAR_SHADER, ATTRIBUTE_BACK_COLOR,																						\
											PREVIEW_VIS_CONDITION, ; )
	
#endif

// ------------------------- RENAME BUTTON ------------------------------
	#ifdef PC
		#define CAC_SETUP_ACTION_RENAME \		
			open "pc_rename";
	#else
		#define CAC_SETUP_ACTION_RENAME \		
			play CHOICE_FOCUS_SOUND; \
			execOnDvarStringValue ui_custom_name customclass1 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD customclass1"; \
			execOnDvarStringValue ui_custom_name customclass2 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD customclass2"; \
			execOnDvarStringValue ui_custom_name customclass3 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD customclass3"; \
			execOnDvarStringValue ui_custom_name customclass4 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD customclass4"; \
			execOnDvarStringValue ui_custom_name customclass5 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD customclass5"; \
			execOnDvarStringValue ui_custom_name prestigeclass1 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD prestigeclass1"; \
			execOnDvarStringValue ui_custom_name prestigeclass2 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD prestigeclass2"; \
			execOnDvarStringValue ui_custom_name prestigeclass3 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD prestigeclass3"; \
			execOnDvarStringValue ui_custom_name prestigeclass4 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD prestigeclass4"; \
			execOnDvarStringValue ui_custom_name prestigeclass5 "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD prestigeclass5";
	#endif		

// ------------------------- RESET BUTTON -------------------------------	
	#define CAC_SETUP_ACTION_RESET \		
		exec "set ui_menu_selection_title @MENU_RESET_TO_DEFAULT"; \
		play CHOICE_FOCUS_SOUND; \
		open "popup_cac_template";	

// ------------------------- CLEAR SLOTS BUTTON -------------------
	#define CAC_SETUP_ACTION_CLEAR_SLOTS \
		if ( dvarString( selected_group ) == "killstreak" ) \
		{ \
			execnow "equipDefaultGlobalItemToSlot killstreak1"; \
			execnow "equipDefaultGlobalItemToSlot killstreak2"; \
			execnow "equipDefaultGlobalItemToSlot killstreak3"; \
		} \
		if ( dvarString( selected_group ) == "specialty" ) \ 
		{ \
			execnow "equipDefaultItemToSlot ( dvarString( ui_custom_name ) ) specialty1"; \
			execnow "equipDefaultItemToSlot ( dvarString( ui_custom_name ) ) specialty2"; \
		}
		

// perk loadout info display =============
	#ifdef PC
		#define PERK_DESC_TEXTSIZE	0.25
	#else
		#define PERK_DESC_TEXTSIZE 	TEXTSIZE_SMALL
	#endif
	
	#define PERK_IMAGE_X		25
	#define PERK_IMAGE_Y		198

	#define PERK_TITLE_X		(PERK_IMAGE_X+35)
	#define PERK_TITLE_Y		(PERK_IMAGE_Y)

	#define PERK_DESC_X			(PERK_TITLE_X-4)
	#define PERK_DESC_Y			(PERK_IMAGE_Y+15)

	#define PERK_Y_OFFSET		38
	#define GRENADE_Y_OFFSET	24

	// perk 1 name -------------
	#define LOCAL_PERK1( ptext, visArg ) \
			PREPROC_TEXT_DRAW_VIS( PERK_TITLE_X (PERK_TITLE_Y) (LOADOUT_WIDTH-50) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, ptext, TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW, when( visArg ); )

#define CAC_LOADOUT_PERKS_GRENADES \
		CAC_LOADOUT_GRENADES_VIS( 1 ) \
		CAC_LOADOUT_PERKS_VIS( !dvarInt( "barebones_class_mode" ) )

#define CAC_LOADOUT_GRENADES_VIS( visArg )																										\
		/* primary grenade name */																												\
		PREPROC_TEXT_DRAW_VIS(	PERK_TITLE_X (PERK_TITLE_Y-GRENADE_Y_OFFSET+2) (LOADOUT_WIDTH-20) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT,				\
								toUpper( locString( "@"+GetItemName( STAT_CAC_PRIMARY_GRENADE ) ) ),															\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,												\
								when( visArg && ( STAT_CAC_PRIMARY_GRENADE > 0 ) ) )															\
		/* primary grenade icon */																												\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y-GRENADE_Y_OFFSET+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,		\
									"white", 1 1 1 0.1,																							\
									when( visArg ), ; )																							\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X+5+ORIGIN_X) (PERK_IMAGE_Y-GRENADE_Y_OFFSET+ORIGIN_Y) 20 20 LOADOUT_ALIGN,						\
									GetItemImage( STAT_CAC_PRIMARY_GRENADE ), 1 1 1 1,															\
									when( visArg && ( STAT_CAC_PRIMARY_GRENADE > 0 ) ), ; )														\
		/* special grenade name */																												\
		PREPROC_TEXT_DRAW_VIS(	(PERK_TITLE_X+125) (PERK_TITLE_Y-GRENADE_Y_OFFSET+2) (LOADOUT_WIDTH-20) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT,		\
								toUpper( locString( "@"+GetItemName( STAT_CAC_SPECIAL_GRENADE ) ) ),															\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,												\
								when( visArg && ( STAT_CAC_SPECIAL_GRENADE > 0 ) ) )															\
		/* special grenade icon */																												\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X+130+ORIGIN_X) (PERK_IMAGE_Y-GRENADE_Y_OFFSET+ORIGIN_Y) 20 20 LOADOUT_ALIGN,					\
									GetItemImage( STAT_CAC_SPECIAL_GRENADE ), 1 1 1 1,															\
									when( visArg && ( STAT_CAC_SPECIAL_GRENADE > 0 ) ), ; )
		
#define CAC_LOADOUT_PERKS_VIS( visArg )																											\	
		/* perk loadout info display ============= */																							\
		/* perk 1 name ------------- */																											\
		LOCAL_PERK1( toUpper( locString( "@" + GetItemName( STAT_CAC_SPECIALTY1 ) ) ), visArg )																	\
		/* perk 1 icon */																														\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X-19ORIGIN_X) (PERK_IMAGE_Y-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,						\
									"white", 1 1 1 0.1,																							\
									when( visArg ), ; )																							\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X+ORIGIN_X) (PERK_IMAGE_Y+ORIGIN_Y) 32 32 LOADOUT_ALIGN,										\
									GetItemImage( STAT_CAC_SPECIALTY1 ), 1 1 1 0.75,															\
									when( visArg ), ; )																							\
		/* perk 1 desc */																														\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_DESC_X+ORIGIN_X) (PERK_DESC_Y+ORIGIN_Y) 14 14 LOADOUT_ALIGN,											\
									"ui_arrow_right", 1 1 1 0.4,																				\
									when( visArg ), ; )																							\
		PREPROC_TEXT_DRAW_VIS( (PERK_DESC_X+16) (PERK_DESC_Y) (LOADOUT_WIDTH-63) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT,								\
								"@"+GetItemDesc( STAT_CAC_SPECIALTY1 ),																			\
								PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,											\
								when( visArg ) )																								\
		/* perk 2 name ------------- */																											\
		PREPROC_TEXT_DRAW_VIS( (PERK_TITLE_X) (PERK_TITLE_Y+PERK_Y_OFFSET) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,					\
								toUpper( locString( "@"+GetItemName( STAT_CAC_SPECIALTY2 ) ) ),																	\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW,												\
								when( visArg ) )																								\
		/* perk 2 icon */																														\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,		\
									"white", 1 1 1 0.1,																							\
									when( visArg ), ; )																							\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET+ORIGIN_Y) 32 32 LOADOUT_ALIGN,							\
									GetItemImage( STAT_CAC_SPECIALTY2 ), 1 1 1 0.75,															\
									when( visArg ), ; ) 																						\
		/* perk 2 desc */																														\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_DESC_X+ORIGIN_X) (PERK_DESC_Y+PERK_Y_OFFSET+ORIGIN_Y) 14 14 LOADOUT_ALIGN,							\
									"ui_arrow_right", 1 1 1 0.4,																				\
									when( visArg ), ; )																							\
		PREPROC_TEXT_DRAW_VIS( (PERK_DESC_X+16) (PERK_DESC_Y+PERK_Y_OFFSET) (LOADOUT_WIDTH-63) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,				\
								"@"+GetItemDesc( STAT_CAC_SPECIALTY2 ),																			\
								PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,											\
								when( visArg ) )																								\
		/* equipment name ------------- */																										\
		PREPROC_TEXT_DRAW_VIS(	(PERK_TITLE_X) (PERK_TITLE_Y+(PERK_Y_OFFSET*2)) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,			\
								toUpper( locString( "@"+GetItemName( STAT_CAC_EQUIPMENT ) ) ),																	\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW,												\
								when( visArg ) )																								\
		/* equipment icon */																													\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y+(PERK_Y_OFFSET*2)-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,	\
									"white", 1 1 1 0.1,																							\
									when( visArg ), ; )																							\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X+ORIGIN_X) (PERK_IMAGE_Y+(PERK_Y_OFFSET*2)+ORIGIN_Y) 32 32 LOADOUT_ALIGN,						\
									GetItemImage( STAT_CAC_EQUIPMENT ), 1 1 1 0.75,																\
									when( visArg ), ; )																							\
		/* equipment desc */																													\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_DESC_X+ORIGIN_X) (PERK_DESC_Y+(PERK_Y_OFFSET*2)+ORIGIN_Y) 14 14 LOADOUT_ALIGN,						\
									"ui_arrow_right", 1 1 1 0.4,																				\
									when( visArg ), ; )																							\
		PREPROC_TEXT_DRAW_VIS(	(PERK_DESC_X+16) (PERK_DESC_Y+(PERK_Y_OFFSET*2)) (LOADOUT_WIDTH-63) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,			\
								"@"+GetItemDesc( STAT_CAC_EQUIPMENT ),																			\
								PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,											\
								when( visArg ) )																								\
		PREPROC_SHADER_DRAW_VIS_EX(	(PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,		\
									"white", 1 1 1 0.1,																							\
									when( visArg ), ; )																							\
		PREPROC_TEXT_DRAW_VIS(	(PERK_TITLE_X-40) (PERK_TITLE_Y+PERK_Y_OFFSET*3) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,			\
								"@MPUI_KILLSTREAKS",																							\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW,												\
								when( visArg ) )																								\
		/* kill streak tier1 icon */																											\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X+75+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3+ORIGIN_Y) 16 16 LOADOUT_ALIGN,						\
									GetItemImage( STAT_CAC_KILLSTREAK_TIER1 ), 1 1 1 0.75,														\
									when( visArg && ( STAT_CAC_KILLSTREAK_TIER1 > 202 ) ), ; )													\
		/* kill streak tier2 icon */																											\
		PREPROC_SHADER_DRAW_VIS_EX( ((PERK_IMAGE_X*2)+75+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3+ORIGIN_Y) 16 16 LOADOUT_ALIGN,					\
									GetItemImage( STAT_CAC_KILLSTREAK_TIER2 ), 1 1 1 0.75,														\
									when( visArg && ( STAT_CAC_KILLSTREAK_TIER2 > 202 ) ), ; )													\
		/* kill streak tier3 icon */																											\
		PREPROC_SHADER_DRAW_VIS_EX( ((PERK_IMAGE_X*3)+75+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3+ORIGIN_Y) 16 16 LOADOUT_ALIGN,					\
									GetItemImage( STAT_CAC_KILLSTREAK_TIER3 ), 1 1 1 0.75,														\
									when( visArg && ( STAT_CAC_KILLSTREAK_TIER3 > 202 ) ), ; )													\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,		\
									"white", 1 1 1 0.1,																							\
									when( visArg ), ; )																							\
		/* armor */																																\
		PREPROC_TEXT_DRAW_VIS(	(PERK_TITLE_X-40) (PERK_TITLE_Y+PERK_Y_OFFSET*3+20) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,		\
								"@"+GetItemName( STAT_CAC_BODY )+"_CAPS",																		\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,												\
								when( visArg ) )

#define CAC_LOADOUT_DEFAULT_PERKS_GRENADES																																\
		/*custom class name*/																																			\
		CHOICE_OVERLAY_TITLE_VIS( dvarString( dvarString( ui_custom_name ) ), when( !menuIsOpen( "cac_main" ) ) )														\
		/* primary grenade name */																																		\
		PREPROC_TEXT_DRAW_VIS(	PERK_TITLE_X (PERK_TITLE_Y-GRENADE_Y_OFFSET+2) (LOADOUT_WIDTH-20) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT,										\
								toUpper( locString( "@"+GetItemName( CAC_DEFAULT_PRIMARY_GRENADE ) ) ),																					\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,																		\
								when( ( CAC_DEFAULT_PRIMARY_GRENADE ) > 0 ) )																							\
		/* primary grenade icon */																																		\
		PREPROC_SHADER_DRAW( (PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y-GRENADE_Y_OFFSET+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,	"white", 1 1 1 0.1 )				\
		PREPROC_SHADER_DRAW_VIS_EX( (PERK_IMAGE_X+ORIGIN_X) (PERK_IMAGE_Y-GRENADE_Y_OFFSET+ORIGIN_Y) 20 20 LOADOUT_ALIGN,												\
									GetItemImage( GetItemName ( CAC_DEFAULT_PRIMARY_GRENADE ) )+"_cac", 1 1 1 1,														\
									when( ( CAC_DEFAULT_PRIMARY_GRENADE ) > 0 ), ; )																					\
		/* special grenade name */																																		\
		PREPROC_TEXT_DRAW_VIS( (PERK_TITLE_X+125) (PERK_TITLE_Y-GRENADE_Y_OFFSET+2) (LOADOUT_WIDTH-20) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT,								\
								toUpper( locString( "@"+GetItemName( CAC_DEFAULT_SPECIAL_GRENADE ) ) ),																					\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,																		\
								when( ( CAC_DEFAULT_SPECIAL_GRENADE ) > 0 )  )																							\
		/* special grenade icon */																																		\
		PREPROC_SHADER_DRAW_VIS_EX(	(PERK_IMAGE_X+115+ORIGIN_X) (PERK_IMAGE_Y-GRENADE_Y_OFFSET+ORIGIN_Y) 20 20 LOADOUT_ALIGN,											\
									GetItemImage( GetItemName ( CAC_DEFAULT_SPECIAL_GRENADE ) )+"_cac", 1 1 1 1,														\
									when( ( CAC_DEFAULT_SPECIAL_GRENADE ) > 0 ), ; )																					\
		/* perk loadout info display ============= */																													\
		/* perk 1 name ------------- */																																	\
		LOCAL_PERK1( toUpper( locString( "@" + GetItemName( CAC_DEFAULT_SPECIALTY1 ) ) ), 1 )																							\
		/* perk 1 icon */																																				\
		PREPROC_SHADER_DRAW( (PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, "white", 1 1 1 0.1 )								\
		PREPROC_SHADER_DRAW( (PERK_IMAGE_X+ORIGIN_X) (PERK_IMAGE_Y+ORIGIN_Y) 32 32 LOADOUT_ALIGN, GetItemImage( CAC_DEFAULT_SPECIALTY1 ), 1 1 1 0.75 )					\
		/* perk 1 desc */																																				\
		PREPROC_SHADER_DRAW( (PERK_DESC_X+ORIGIN_X) (PERK_DESC_Y+ORIGIN_Y) 14 14 LOADOUT_ALIGN, "ui_arrow_right", 1 1 1 0.4 )											\
		PREPROC_TEXT_DRAW( (PERK_DESC_X+16) (PERK_DESC_Y) (LOADOUT_WIDTH-63) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT,															\
							"@" +  GetItemDesc( CAC_DEFAULT_SPECIALTY1 ),																								\
							PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )																		\
		/* perk 2 name ------------- */																																	\
		PREPROC_TEXT_DRAW(	(PERK_TITLE_X) (PERK_TITLE_Y+PERK_Y_OFFSET) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,											\
							"@" + GetItemName( CAC_DEFAULT_SPECIALTY2 ),																								\
							TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW )																			\
		/* perk 2 icon */																																				\
		PREPROC_SHADER_DRAW( (PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, "white", 1 1 1 0.1 )					\
		PREPROC_SHADER_DRAW( (PERK_IMAGE_X+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET+ORIGIN_Y) 32 32 LOADOUT_ALIGN, GetItemImage( CAC_DEFAULT_SPECIALTY2 ), 1 1 1 0.75 )	\
		/* perk 2 desc */																																				\
		PREPROC_SHADER_DRAW( (PERK_DESC_X+ORIGIN_X) (PERK_DESC_Y+PERK_Y_OFFSET+ORIGIN_Y) 14 14 LOADOUT_ALIGN, "ui_arrow_right", 1 1 1 0.4 )								\
		PREPROC_TEXT_DRAW(	(PERK_DESC_X+16) (PERK_DESC_Y+PERK_Y_OFFSET) (LOADOUT_WIDTH-63) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,											\
							"@" + GetItemDesc( CAC_DEFAULT_SPECIALTY2 ),																								\
							PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )																		\
		PREPROC_SHADER_DRAW_VIS_EX(	(PERK_IMAGE_X-19+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3-4+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,								\
									"white", 1 1 1 0.1,																													\
									when( visArg ), ; )																													\
		PREPROC_TEXT_DRAW_VIS(	(PERK_TITLE_X-40) (PERK_TITLE_Y+PERK_Y_OFFSET*3) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,									\
								"@MPUI_KILLSTREAKS",																													\
								TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW,																		\
								when( visArg ) )																														\
		/* kill streak tier1 icon */																																	\
		PREPROC_SHADER_DRAW_VIS_EX(	(PERK_IMAGE_X+75+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3+ORIGIN_Y) 16 16 LOADOUT_ALIGN,												\
									GetItemImage( CAC_DEFAULT_KILLSTREAK_TIER1 ), 1 1 1 0.75,																			\
									when( visArg ), ; )																													\
		/* kill streak tier2 icon */																																	\
		PREPROC_SHADER_DRAW_VIS_EX( ((PERK_IMAGE_X*2)+75+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3+ORIGIN_Y) 16 16 LOADOUT_ALIGN,											\
									GetItemImage( CAC_DEFAULT_KILLSTREAK_TIER1 ), 1 1 1 0.75,																			\
									when( visArg ) )																													\
		/* kill streak tier3 icon */																																	\
		PREPROC_SHADER_DRAW_VIS_EX(	((PERK_IMAGE_X*3)+75+ORIGIN_X) (PERK_IMAGE_Y+PERK_Y_OFFSET*3+ORIGIN_Y) 16 16 LOADOUT_ALIGN,											\
									GetItemImage( CAC_DEFAULT_KILLSTREAK_TIER1 ), 1 1 1 0.75,																			\
									when( visArg ), ; )
		
#define CAC_LOADOUT_ATTRIBUTES \
	/* primary weapon attributes title */ \
	PREPROC_TEXT_DRAW( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 25 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -2 -20, "@MENU_PRIMARY_ATTRIBUTES", TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, COLOR_TITLE ) \
	/* drawing attributes */ \
	PREPROC_TEXT_DRAW_VIS_EX( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -42 2,  "@MENU_ACCURACY1",	TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, COLOR_BODY_TEXT, 1, name accuracy) \
	PREPROC_TEXT_DRAW_VIS_EX( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -42 20, "@MENU_DAMAGE",		TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, COLOR_BODY_TEXT, 1, name damage) \
	PREPROC_TEXT_DRAW_VIS_EX( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -42 38, "@MENU_RANGE",		TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, COLOR_BODY_TEXT, 1, name range) \
	PREPROC_TEXT_DRAW_VIS_EX( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -42 56, "@MENU_FIRE_RATE",	TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, COLOR_BODY_TEXT, 1, name fire_rate) \
	PREPROC_TEXT_DRAW_VIS_EX( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -42 74, "@MENU_MOBILITY",	TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, COLOR_BODY_TEXT, 1, name mobility) \
	\
	ATTRIBUTE_BAR_FORMAT( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+6), 2 ) \
	ATTRIBUTE_BAR_FORMAT( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+24), 3 ) \
	ATTRIBUTE_BAR_FORMAT( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+42), 4 ) \
	ATTRIBUTE_BAR_FORMAT( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+60), 5 ) \
	ATTRIBUTE_BAR_FORMAT( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+78), 6 ) \

#define CAC_LOADOUT_ATTRIBUTES_PREVIEW \
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+6), 2 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+24), 3 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+42), 4 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+60), 5 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+78), 6 )

#define CAC_LOADOUT_ATTRIBUTES_PREVIEW_NA \
	ATTRIBUTE_BAR_FORMAT_PREVIEW_NA( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+6), 2 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW_NA( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+24), 3 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW_NA( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+42), 4 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW_NA( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+60), 5 ) \
	ATTRIBUTE_BAR_FORMAT_PREVIEW_NA( (ATTRIBUTE_BAR_X), (INFO_BOX_Y+78), 6 )

//SPEICAL LOADOUT SCREENS FOR CREATE A CLASS MENUS
#define CAC_LOADOUT_CAC_TITLE1 \
	/*custom class name*/ \
	CHOICE_OVERLAY_TITLE_VIS( dvarString( dvarString( ui_custom_name ) ), when( !menuIsOpen( "cac_main" ) && !menuIsOpen( "changeclass" ) && !menuIsOpen( "changeclass_offline" ) ) )

#define WEAPON_TITLE_X		-5
#define WEAPON_TITLE_Y		-10

#define WEAPON_IMAGE_X		130
#define WEAPON_IMAGE_Y		(WEAPON_TITLE_Y+20)

#define ATTACHMENT_TITLE_X	10
#define ATTACHMENT_TITLE_Y	(WEAPON_TITLE_Y+72)

#define ATTACHMENT_IMAGE_X	30
#define ATTACHMENT_IMAGE_Y	(WEAPON_IMAGE_Y)

#define SECONDARY_OFFSET_Y	92

#define CAC_LOADOUT_NORMAL \
		CAC_LOADOUT_NORMAL_VIS( 1 )

#define CAC_LOADOUT_NORMAL_VIS( visArg )																										\
	/*primary weapon camo =====================*/																								\
	PREPROC_SHADER_DRAW_VIS_EX( ORIGIN_X (16-20+ORIGIN_Y+ORIGIN_Y) ((LOADOUT_WIDTH+8)/4) 90 LOADOUT_ALIGN,										\
								getWeaponOptionImage( STAT_CAC_PRIMARY_CAMO ), 1 1 1 0.8,														\
								when( visArg );, ; )																							\
	PREPROC_SHADER_DRAW_VIS_EX( (((LOADOUT_WIDTH+8)/4)+ORIGIN_X) (16-20+ORIGIN_Y) ((LOADOUT_WIDTH+8)/4) 90 LOADOUT_ALIGN,						\
								getWeaponOptionImage( STAT_CAC_PRIMARY_CAMO ), 1 1 1 0.8,														\
								when( visArg );, ; )																							\
	PREPROC_SHADER_DRAW_VIS_EX( (((LOADOUT_WIDTH+8)/2)+ORIGIN_X) (16-20+ORIGIN_Y) ((LOADOUT_WIDTH+8)/4) 90 LOADOUT_ALIGN,						\
								getWeaponOptionImage( STAT_CAC_PRIMARY_CAMO ), 1 1 1 0.8,														\
								when( visArg );, ; )																							\
	PREPROC_SHADER_DRAW_VIS_EX( ((((LOADOUT_WIDTH+8)/4)*3)+ORIGIN_X) (16-20+ORIGIN_Y) ((LOADOUT_WIDTH+8)/4) 90 LOADOUT_ALIGN,					\
								getWeaponOptionImage( STAT_CAC_PRIMARY_CAMO ), 1 1 1 0.8,														\
								when( visArg );, ; )																							\
	/*weapon loadout info display =============*/																								\
	/* primary weapon name */																													\
	PREPROC_TEXT_DRAW_VIS(	WEAPON_TITLE_X WEAPON_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,									\
							"@"+GetItemName( STAT_CAC_PRIMARY ),																				\
							TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, COLOR_INFO_YELLOW,													\
							when( visArg && ( STAT_CAC_PRIMARY > 0 ) ); )																		\
	/* primary weapon attachment name */																										\
	PREPROC_TEXT_DRAW_VIS(	ATTACHMENT_TITLE_X ATTACHMENT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,							\
							"@"+GetAttachmentName( CAC_PRI_ATTACHMENT_SLOT ),																	\
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,														\
							when( visArg && ( STAT_CAC_PRIMARY > 0 ) ); )																		\
	/* primary weapon image */																													\
	PREPROC_SHADER_DRAW_VIS_EX( (WEAPON_IMAGE_X+ORIGIN_X) (WEAPON_IMAGE_Y+ORIGIN_Y) 140 70 LOADOUT_ALIGN,										\
								GetItemImage( STAT_CAC_PRIMARY ) , 1 1 1 1,																		\
								when( visArg && ( STAT_CAC_PRIMARY > 0 ) );, ; )																\
	/* primary weapon attachment image */																										\
	PREPROC_SHADER_DRAW_VIS_EX( (ATTACHMENT_IMAGE_X+ORIGIN_X) (ATTACHMENT_IMAGE_Y+ORIGIN_Y) 48 48 LOADOUT_ALIGN,								\
								GetAttachmentImage( CAC_PRI_ATTACHMENT_SLOT ), 1 1 1 1,															\
								when( visArg && ( STAT_CAC_PRIMARY > 0 ) );, ; )																\
	/* second weapon name */																													\
	PREPROC_SHADER_DRAW_VIS_EX( (WEAPON_TITLE_X+11+ORIGIN_X) (WEAPON_TITLE_Y+SECONDARY_OFFSET_Y+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN,	\
								"white", 1 1 1 0.1,																								\
								when( visArg && ( STAT_CAC_SECONDARY > 0 ) );, ; )																\
	PREPROC_TEXT_DRAW_VIS( WEAPON_TITLE_X (WEAPON_TITLE_Y+SECONDARY_OFFSET_Y) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,				\
							"@" + GetItemName( STAT_CAC_SECONDARY ),																			\
							TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, COLOR_INFO_YELLOW,													\
							when( visArg && ( STAT_CAC_SECONDARY > 0 ) ); )																		\
	/* second weapon attachment name */																											\
	PREPROC_TEXT_DRAW_VIS(	ATTACHMENT_TITLE_X (ATTACHMENT_TITLE_Y+SECONDARY_OFFSET_Y) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,		\
							"@"+GetAttachmentName( CAC_SEC_ATTACHMENT_SLOT ),																	\
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,														\
							when( visArg && ( STAT_CAC_SECONDARY > 0 ) ); )																		\
	/* second weapon image */																													\
	PREPROC_SHADER_DRAW_VIS_EX( (WEAPON_IMAGE_X+ORIGIN_X) (WEAPON_IMAGE_Y+SECONDARY_OFFSET_Y+ORIGIN_Y) 140 70 LOADOUT_ALIGN,					\
								GetItemImage( STAT_CAC_SECONDARY ), 1 1 1 1,																	\
								when( IS_TWO_PRIME && visArg && ( STAT_CAC_SECONDARY > 0 ) );, ; )												\
	PREPROC_SHADER_DRAW_VIS_EX( (WEAPON_IMAGE_X+ORIGIN_X) (WEAPON_IMAGE_Y+SECONDARY_OFFSET_Y-5+ORIGIN_Y) 140 70 LOADOUT_ALIGN,					\
								GetItemImage( STAT_CAC_SECONDARY ), 1 1 1 1,																	\
								when( IS_ONE_PRIME && visArg && ( STAT_CAC_SECONDARY > 0 ) );, ; )												\
	/* second weapon attachment image */																										\
	PREPROC_SHADER_DRAW_VIS_EX( (ATTACHMENT_IMAGE_X+ORIGIN_X) (ATTACHMENT_IMAGE_Y+SECONDARY_OFFSET_Y+ORIGIN_Y) 48 48 LOADOUT_ALIGN,				\
								GetAttachmentImage( CAC_SEC_ATTACHMENT_SLOT ), 1 1 1 1,															\
								when( visArg && ( STAT_CAC_SECONDARY > 0 ) );, ; )																\
	/* grenade loadout info display ============= */																							\
	CAC_LOADOUT_GRENADES_VIS( 1 )																												\
	/* perk loadout info display ============= */																								\
	CAC_LOADOUT_PERKS_VIS( !dvarInt( "barebones_class_mode" ) )

//SPEICAL LOADOUT SCREENS FOR CREATE A CLASS DEFAULT MENUS
#define CAC_LOADOUT_DEFAULT_CLASSES																																				\
		/*weapon loadout info display =============*/																															\
		/* primary weapon name */																																				\
		PREPROC_TEXT_DRAW(	WEAPON_TITLE_X WEAPON_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,																	\
							"@"+GetItemName( CAC_DEFAULT_PRIMARY ),																												\
							TEXTSIZE_DEFAULT, 0, 0,	ITEM_ALIGN_MIDDLE_RIGHT, COLOR_INFO_YELLOW )																				\
		/* primary weapon attachment name */																																	\
		PREPROC_TEXT_DRAW(	ATTACHMENT_TITLE_X ATTACHMENT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,															\
							"@"+GetAttachmentName( CAC_DEFAULT_PRIMARY_ATTACHMENT ),																							\
							TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )																					\
		/* primary weapon image */																																				\
		PREPROC_SHADER_DRAW( (WEAPON_IMAGE_X+ORIGIN_X) (WEAPON_IMAGE_Y+ORIGIN_Y) 140 70 LOADOUT_ALIGN, GetItemImage( CAC_DEFAULT_PRIMARY ), 1 1 1 1 )							\
		/* primary weapon attachment image */																																	\
		PREPROC_SHADER_DRAW( (ATTACHMENT_IMAGE_X+ORIGIN_X) (ATTACHMENT_IMAGE_Y+ORIGIN_Y) 48 48 LOADOUT_ALIGN, GetAttachmentImage( CAC_DEFAULT_PRIMARY_ATTACHMENT ), 1 1 1 1 ) 	\
		/* second weapon name */																																				\
		PREPROC_SHADER_DRAW( (WEAPON_TITLE_X+11+ORIGIN_X) (WEAPON_TITLE_Y+SECONDARY_OFFSET_Y+ORIGIN_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, "white", 1 1 1 0.1 )					\
		PREPROC_TEXT_DRAW_VIS(	WEAPON_TITLE_X (WEAPON_TITLE_Y+SECONDARY_OFFSET_Y) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,											\
								"@"+GetItemName( CAC_DEFAULT_SECONDARY ),																										\
								TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, COLOR_INFO_YELLOW,																				\
								when( ( CAC_DEFAULT_SECONDARY ) > 0 ); )																										\
		/* second weapon attachment name */																																		\
		PREPROC_TEXT_DRAW_VIS(	ATTACHMENT_TITLE_X (ATTACHMENT_TITLE_Y+SECONDARY_OFFSET_Y) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,									\
								"@"+GetAttachmentName( CAC_DEFAULT_SECONDARY_ATTACHMENT ),																						\
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,																					\
								when( ( ( CAC_DEFAULT_SECONDARY ) > 0 ) && ( ( CAC_DEFAULT_SECONDARY_ATTACHMENT ) > 0 ) );  )													\
		/* second weapon image */																																				\
		PREPROC_SHADER_DRAW_VIS_EX(	(WEAPON_IMAGE_X+ORIGIN_X) (WEAPON_IMAGE_Y+SECONDARY_OFFSET_Y+ORIGIN_Y) 140 70 LOADOUT_ALIGN,												\
									GetItemImage( CAC_DEFAULT_SECONDARY ), 1 1 1 1,																								\
									when( IS_DEFAULT_TWO_PRIME && ( CAC_DEFAULT_SECONDARY > 0 ) );, ; )																			\
		PREPROC_SHADER_DRAW_VIS_EX( (WEAPON_IMAGE_X+ORIGIN_X) (WEAPON_IMAGE_Y+SECONDARY_OFFSET_Y-5+ORIGIN_Y) 140 70 LOADOUT_ALIGN,												\
									GetItemImage( CAC_DEFAULT_SECONDARY ), 1 1 1 1,																								\
									when( IS_DEFAULT_ONE_PRIME && ( CAC_DEFAULT_SECONDARY > 0 ) );, ; ) 																		\
		/* second weapon attachment image */																																	\
		PREPROC_SHADER_DRAW_VIS_EX( (ATTACHMENT_IMAGE_X+ORIGIN_X) (ATTACHMENT_IMAGE_Y+SECONDARY_OFFSET_Y+ORIGIN_Y) 48 48 LOADOUT_ALIGN,											\
									GetAttachmentImage( CAC_DEFAULT_SECONDARY_ATTACHMENT ), 1 1 1 1,																			\
									when( ( ( CAC_DEFAULT_SECONDARY ) > 0 ) && ( ( CAC_DEFAULT_SECONDARY_ATTACHMENT ) > 0 ) );, ; ) 											\
		/* perk loadout info display ============= */																															\
		CAC_LOADOUT_DEFAULT_PERKS_GRENADES

#define LOCKED_CLASS \
		LOCKED_CLASS_VIS( 1 )

#define LOCKED_CLASS_VIS( visArg )																										\
		itemDef																															\
		{																																\
			style			WINDOW_STYLE_SHADER																							\
			rect			-274 137 342 1 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP													\
			background		"menu_white_line_faded"																						\
			forecolor		1 1 1 0.1																									\
			visible			visArg																										\
			decoration																													\
		}																																\
		/* image*/																														\
		PREPROC_SHADER_DRAW_VIS_EX(	(LOADOUT_IMAGE_X+ORIGIN_X)  (LOADOUT_IMAGE_Y+ORIGIN_Y) 90 90 LOADOUT_ALIGN,							\
									"menu_mp_lobby_locked_big", 1 1 1 0.75,																\
									visArg, ; )																							\
		/* title*/																														\
		PREPROC_TEXT_DRAW_VIS(	LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,						\
								dvarString( ui_custom_name ), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW,		\
								visArg )																								\
		/* perk desc unlocked*/																											\
		PREPROC_TEXT_DRAW_VIS(	LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,						\
								dvarString( ui_prestige_unlock_desc ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,	\
								visArg )


#define WEAPON_ALIGN				CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
#define WEAPON_WIDTH 				150

#define WEAPON_X_START				-360
#define WEAPON_Y_START				60


#define APP_ALIGN					CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN 
#define APP_WIDTH 					100

#define APP_X_START					90
#define APP_Y_START					-110

#define SPECIALTY_LOADOUT_ALIGN		CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN 
#define SPECIALTY_LOADOUT_WIDTH 	150

#define SPECIALTY_IMAGE_X			175
#define SPECIALTY_IMAGE_Y			-10
#define SPECIALTY_IMAGE_WIDTH		48

#define SPECIALTY_TITLE_X			(SPECIALTY_IMAGE_X+(SPECIALTY_IMAGE_WIDTH/2)-(SPECIALTY_LOADOUT_WIDTH/2))
#define SPECIALTY_TITLE_Y			(SPECIALTY_IMAGE_Y+SPECIALTY_IMAGE_WIDTH)

#define SPECIALTY_DESC_X			SPECIALTY_TITLE_X
#define SPECIALTY_DESC_Y			(SPECIALTY_TITLE_Y+15)

#define SPECIALTY_Y_OFFSET	100

#define SPECIALTY_DESC_TEXTSIZE	0.24

#define LOCAL_SPECIALTY_EXTRA_ARGS( nameArg, xpos, ypos )																																\
		name nameArg;																																									\
		ITEM_STATE( SPECIALTIES_INFO_SLIDE_UP, rect xpos (ypos-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, ; );										\
		ITEM_STATE( SLIDEANDFADE_STATE_NAME, forecolor CHOICE_TEXTCOLOR_NO_ALPHA; rect xpos (ypos-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, ; ) ;	\ 
		ITEM_STATE( STATE_SLIDE_RIGHT, forecolor CHOICE_TEXTCOLOR_NO_ALPHA; rect (xpos+GRID_BUTTON_SLIDE_DISTANCE) ypos SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, ; ) ;		\ 
		ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR_NO_ALPHA, ; )																																\
		HIGHLIGHT_STATES( TEXT_COLOR_HL, TEXT_COLOR_NO_HL, MEDIUM_GRAY );

#define LOCAL_SPECIALTY( origin, ptext, visArg )												\
		PREPROC_TEXT_DRAW_ALL( origin SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, 0 0,	\
							   ptext, 0.3, 0, 0,												\
							   ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR, UI_FONT_BOLD,		\
							   ITEM_TEXTSTYLE_NORMAL, when( visArg );, ; )

#define LOCAL_SPECIALTY_EX( xpos, ypos, ptext, nameArg, visArg )															\
		PREPROC_TEXT_DRAW_ALL( xpos ypos SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, 0 0,							\
							   ptext, 0.3, 0, 0,																			\
							   ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR, UI_FONT_BOLD,									\
							   ITEM_TEXTSTYLE_NORMAL, when( visArg );, LOCAL_SPECIALTY_EXTRA_ARGS( nameArg, xpos, ypos ) )

#define CLASS_BONUS GetClassBonus( dvarString( ui_custom_name ) )
#define CLASS_BONUS_NAME "@" + tablelookup( "mp/classbonustable.csv", 0, CLASS_BONUS, 2 )
#define CLASS_BONUS_DESC "@" + tablelookup( "mp/classbonustable.csv", 0, CLASS_BONUS, 3 )
#define CLASS_BONUS_UNLOCK "@" + tablelookup( "mp/classbonustable.csv", 0, CLASS_BONUS, 4 )
#define CLASS_BONUS_ICON tablelookup( "mp/classbonustable.csv", 0, CLASS_BONUS, 5 )

#define CAC_LOADOUT_SPECIALTIES_CLASS_BONUS	\
		CAC_LOADOUT_SPECIALTIES_CLASS_BONUS_VIS( 1 ) 

#define CAC_LOADOUT_SPECIALTIES_CLASS_BONUS_VIS( visArg )	\
		CAC_LOADOUT_SPECIALTIES_VIS( visArg )				\
		CAC_LOADOUT_CLASS_BONUS_VIS( visArg )

#define CAC_LOADOUT_SPECIALTIES_VIS( visArg )																														\
		/* specialty 1 name ------------- */																														\
		LOCAL_SPECIALTY( SPECIALTY_TITLE_X SPECIALTY_TITLE_Y, toUpper( locString( "@" + GetItemName( STAT_CAC_SPECIALTY1 ) ) ), visArg )							\
		/* specialty 1 icon */																																		\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X SPECIALTY_IMAGE_Y SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN,						\
									GetItemImage( STAT_CAC_SPECIALTY1 ), 1 1 1 0.75,																				\
									when( visArg ), ; )																												\
		/* specialty 1 desc */																																		\
		PREPROC_TEXT_DRAW_ALL( SPECIALTY_DESC_X SPECIALTY_DESC_Y SPECIALTY_LOADOUT_WIDTH 16 SPECIALTY_LOADOUT_ALIGN, 0 0,											\
							   "@"+GetItemDesc( STAT_CAC_SPECIALTY1 ), SPECIALTY_DESC_TEXTSIZE, 0, -2,																\
							   ITEM_ALIGN_MIDDLE_CENTER, MEDIUM_GRAY, UI_FONT_NORMAL,																				\
							   ITEM_TEXTSTYLE_NORMAL, when( visArg ), autowrapped )																					\
		/* specialty 2 name ------------- */																														\
		LOCAL_SPECIALTY( SPECIALTY_TITLE_X (SPECIALTY_TITLE_Y+SPECIALTY_Y_OFFSET), toUpper( locString( "@"+GetItemName( STAT_CAC_SPECIALTY2 ) ) ), visArg )			\
		/* specialty 2 icon */																																		\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y+SPECIALTY_Y_OFFSET) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN,	\
									GetItemImage( STAT_CAC_SPECIALTY2 ), 1 1 1 0.75,																				\
									when( visArg ) )																												\
		/* specialty 2 desc */																																		\
		PREPROC_TEXT_DRAW_ALL( SPECIALTY_DESC_X (SPECIALTY_DESC_Y+SPECIALTY_Y_OFFSET) SPECIALTY_LOADOUT_WIDTH 16 SPECIALTY_LOADOUT_ALIGN, 0 0,						\
							   "@"+GetItemDesc( STAT_CAC_SPECIALTY2 ), SPECIALTY_DESC_TEXTSIZE, 0, -2,																\
							   ITEM_ALIGN_MIDDLE_CENTER, MEDIUM_GRAY, UI_FONT_NORMAL,																				\
							   ITEM_TEXTSTYLE_NORMAL, when( visArg ), autowrapped ) 
		
#define INGAME_SPECIALTY_TITLE_X	(SPECIALTY_IMAGE_X+(SPECIALTY_IMAGE_WIDTH))
#define INGAME_SPECIALTY_TITLE_Y	(SPECIALTY_IMAGE_Y+2)
		
#define INGAME_SPECIALTY_DESC_X		INGAME_SPECIALTY_TITLE_X
#define INGAME_SPECIALTY_DESC_Y		(INGAME_SPECIALTY_TITLE_Y+15)

#define CAC_LOADOUT_INGAME_SPECIALTIES_VIS( visArg )																															\
		/* specialty 1 name ------------- */																																	\
		LOCAL_SPECIALTY( INGAME_SPECIALTY_TITLE_X ( INGAME_SPECIALTY_TITLE_Y - SPECIALTY_Y_OFFSET ), toUpper( locString( "@" + GetItemName( STAT_CAC_SPECIALTY1 ) ) ), visArg )	\
		/* specialty 1 icon */																																					\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X ( SPECIALTY_IMAGE_Y - SPECIALTY_Y_OFFSET ) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN,			\
									GetItemImage( STAT_CAC_SPECIALTY1 ), 1 1 1 0.75,																							\
									when( visArg ), ; )																															\
		/* specialty 1 desc */																																					\
		PREPROC_TEXT_DRAW_ALL( INGAME_SPECIALTY_DESC_X ( INGAME_SPECIALTY_DESC_Y - SPECIALTY_Y_OFFSET ) SPECIALTY_LOADOUT_WIDTH 16 SPECIALTY_LOADOUT_ALIGN, 0 0,				\
							   "@"+GetItemDesc( STAT_CAC_SPECIALTY1 ), SPECIALTY_DESC_TEXTSIZE, 0, -2,																			\
							   ITEM_ALIGN_MIDDLE_CENTER, MEDIUM_GRAY, UI_FONT_NORMAL,																							\
							   ITEM_TEXTSTYLE_NORMAL, when( visArg ), autowrapped )																								\
		/* specialty 2 name ------------- */																																	\
		LOCAL_SPECIALTY( INGAME_SPECIALTY_TITLE_X INGAME_SPECIALTY_TITLE_Y, toUpper( locString( "@"+GetItemName( STAT_CAC_SPECIALTY2 ) ) ), visArg )							\
		/* specialty 2 icon */																																					\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X SPECIALTY_IMAGE_Y SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN,									\
									GetItemImage( STAT_CAC_SPECIALTY2 ), 1 1 1 0.75,																							\
									when( visArg ), ; )																															\
		/* specialty 2 desc */																																					\
		PREPROC_TEXT_DRAW_ALL( INGAME_SPECIALTY_DESC_X INGAME_SPECIALTY_DESC_Y SPECIALTY_LOADOUT_WIDTH 16 SPECIALTY_LOADOUT_ALIGN, 0 0,											\
							   "@"+GetItemDesc( STAT_CAC_SPECIALTY2 ), SPECIALTY_DESC_TEXTSIZE, 0, -2,																			\
							   ITEM_ALIGN_MIDDLE_CENTER, MEDIUM_GRAY, UI_FONT_NORMAL,																							\
							   ITEM_TEXTSTYLE_NORMAL, when( visArg ), autowrapped )																								\
		/* specialty 3 name ------------- */																																	\
		LOCAL_SPECIALTY( INGAME_SPECIALTY_TITLE_X (INGAME_SPECIALTY_TITLE_Y+SPECIALTY_Y_OFFSET), toUpper( locString( "@"+GetItemName( STAT_CAC_SPECIALTY3 ) ) ), visArg )		\
		/* specialty 3 icon */																																					\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y+SPECIALTY_Y_OFFSET) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN,				\
									GetItemImage( STAT_CAC_SPECIALTY3 ), 1 1 1 0.75,																							\
									when( visArg ) )																															\
		/* specialty 3 desc */																																					\
		PREPROC_TEXT_DRAW_ALL( INGAME_SPECIALTY_DESC_X (INGAME_SPECIALTY_DESC_Y+SPECIALTY_Y_OFFSET) SPECIALTY_LOADOUT_WIDTH 16 SPECIALTY_LOADOUT_ALIGN, 0 0,					\
							   "@"+GetItemDesc( STAT_CAC_SPECIALTY3 ), SPECIALTY_DESC_TEXTSIZE, 0, -2,																			\
							   ITEM_ALIGN_MIDDLE_CENTER, MEDIUM_GRAY, UI_FONT_NORMAL,																							\
							   ITEM_TEXTSTYLE_NORMAL, when( visArg ), autowrapped ) 
						   

#define CAC_LOADOUT_CLASS_BONUS_VIS( visArg )																											\
		/* class bonus */																																\
		PREPROC_TEXT_DRAW_VIS(	SPECIALTY_IMAGE_X (SPECIALTY_TITLE_Y+7+(SPECIALTY_Y_OFFSET*2)) SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, 0 0,	\
								"@MENU_CLASS_BONUS",																									\
								TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW,														\	
								when( visArg ); )																										\
		/* class bonus name ------------- */																											\
		LOCAL_SPECIALTY( SPECIALTY_TITLE_X (SPECIALTY_TITLE_Y+22+(SPECIALTY_Y_OFFSET*2)), CLASS_BONUS_NAME, ( visArg ) )								\
		/* class bonus icon */																															\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y+22+(SPECIALTY_Y_OFFSET*2)) 32 32 SPECIALTY_LOADOUT_ALIGN,						\
									CLASS_BONUS_ICON, 1 1 1 0.75,																						\
									when( visArg ) )																									\
		/* class bonus desc */																															\
		PREPROC_TEXT_DRAW_VIS(	SPECIALTY_DESC_X (SPECIALTY_DESC_Y+22+(SPECIALTY_Y_OFFSET*2)) SPECIALTY_LOADOUT_WIDTH 20 SPECIALTY_LOADOUT_ALIGN, 0 0,	\
								CLASS_BONUS_DESC, SPECIALTY_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR,								\
								when( visArg ) )	


#define CAC_LOADOUT_SPECIALTIES \
		CAC_SPECIALTIES_VIS( 1 ) 

#define CAC_SPECIALTIES_VIS( visArg )																																																							\
		/* specialty 1 name ------------- */																																																					\
		LOCAL_SPECIALTY_EX( SPECIALTY_TITLE_X, SPECIALTY_TITLE_Y, "@" + GetItemName( STAT_CAC_SPECIALTY1 ), local_specialty1, visArg )																															\
		/* specialty 1 icon */																																																									\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X SPECIALTY_IMAGE_Y SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN,																													\
									GetItemImage( STAT_CAC_SPECIALTY1 ), 1 1 1 0.75,																																											\
									when( visArg ),																																																				\
									name specialty_1_icon;																																																		\
									ITEM_STATE( SPECIALTIES_INFO_SLIDE_UP, rect SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN, SPECIALTIES_INFO_SLIDEUPANDFADE; );		\
									ITEM_STATE( SLIDEANDFADE_STATE_NAME, forecolor 1 1 1 0; rect SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN, ; ) ;					\
									ITEM_STATE( STATE_SLIDE_RIGHT, forecolor 1 1 1 0; rect (SPECIALTY_IMAGE_X+GRID_BUTTON_SLIDE_DISTANCE) (SPECIALTY_IMAGE_Y) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN, ; ) ;						\
									ITEM_STATE_FADEOUT( 1 1 1 0, ; ) )																																															\
		/* specialty 1 desc */																																																									\
		PREPROC_TEXT_DRAW_VIS_EX( SPECIALTY_DESC_X SPECIALTY_DESC_Y SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, 0 0,																																	\
								  "@"+GetItemDesc( STAT_CAC_SPECIALTY1 ),																																														\
								  SPECIALTY_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR,																																					\
								  when( visArg ),																																																				\
								  name specialty_1_desc; autowrapped; HIGHLIGHT_STATES( TEXT_COLOR_HL, TEXT_COLOR_NO_HL, MEDIUM_GRAY );																															\
								  ITEM_STATE( SPECIALTIES_INFO_SLIDE_UP, rect SPECIALTY_DESC_X (SPECIALTY_DESC_Y-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, ; );															\
								  ITEM_STATE( SLIDEANDFADE_STATE_NAME, forecolor CHOICE_TEXTCOLOR_NO_ALPHA; rect SPECIALTY_DESC_X (SPECIALTY_DESC_Y-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, ; ) ;						\
								  ITEM_STATE( STATE_SLIDE_RIGHT, forecolor CHOICE_TEXTCOLOR_NO_ALPHA; rect (SPECIALTY_IMAGE_X+GRID_BUTTON_SLIDE_DISTANCE) (SPECIALTY_DESC_Y) SPECIALTY_LOADOUT_WIDTH 18 SPECIALTY_LOADOUT_ALIGN, ; ) ;							\
								  ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR_NO_ALPHA, ; ) )																																											\
		/* specialty 2 name ------------- */																																																					\
		LOCAL_SPECIALTY_EX( SPECIALTY_TITLE_X, (SPECIALTY_TITLE_Y+SPECIALTY_Y_OFFSET), toUpper( locString( "@"+GetItemName( STAT_CAC_SPECIALTY2 ) ) ), local_specialty2, visArg )																				\
		/* specialty 2 icon */																																																									\
		PREPROC_SHADER_DRAW_VIS_EX( SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y+SPECIALTY_Y_OFFSET) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN,																								\
									GetItemImage( STAT_CAC_SPECIALTY2 ), 1 1 1 0.75,																																											\
									when( visArg ),																																																				\
									name specialty_2_icon;																																																		\
									ITEM_STATE( SPECIALTIES_INFO_SLIDE_UP, rect SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y+SPECIALTY_Y_OFFSET-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN, ; );					\
									ITEM_STATE( SLIDEANDFADE_STATE_NAME, forecolor 1 1 1 0; rect SPECIALTY_IMAGE_X (SPECIALTY_IMAGE_Y+SPECIALTY_Y_OFFSET-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN, ; ) ;	\
									ITEM_STATE( STATE_SLIDE_RIGHT, forecolor 1 1 1 0; rect (SPECIALTY_IMAGE_X+GRID_BUTTON_SLIDE_DISTANCE) (SPECIALTY_IMAGE_Y+SPECIALTY_Y_OFFSET) SPECIALTY_IMAGE_WIDTH SPECIALTY_IMAGE_WIDTH SPECIALTY_LOADOUT_ALIGN, ; ) ;		\
									ITEM_STATE_FADEOUT( 1 1 1 0, ; ) )																																															\
		/* specialty 2 desc */																																																									\
		PREPROC_TEXT_DRAW_VIS_EX( SPECIALTY_DESC_X (SPECIALTY_DESC_Y+SPECIALTY_Y_OFFSET) SPECIALTY_LOADOUT_WIDTH 20 SPECIALTY_LOADOUT_ALIGN, 0 0,																												\
								  "@"+GetItemDesc( STAT_CAC_SPECIALTY2 ),																																														\
								  SPECIALTY_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR,																																					\
								  when( visArg ),																																																				\
								  name specialty_2_desc; autowrapped; HIGHLIGHT_STATES( TEXT_COLOR_HL, TEXT_COLOR_NO_HL, MEDIUM_GRAY );																															\
								  ITEM_STATE( SPECIALTIES_INFO_SLIDE_UP, rect SPECIALTY_DESC_X (SPECIALTY_DESC_Y+SPECIALTY_Y_OFFSET-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_LOADOUT_WIDTH 20 SPECIALTY_LOADOUT_ALIGN, ; );										\
								  ITEM_STATE( SLIDEANDFADE_STATE_NAME, forecolor CHOICE_TEXTCOLOR_NO_ALPHA; rect SPECIALTY_DESC_X (SPECIALTY_DESC_Y+SPECIALTY_Y_OFFSET-SLIDE_DISTANCE_SPECIALTIES) SPECIALTY_LOADOUT_WIDTH 20 SPECIALTY_LOADOUT_ALIGN, ; ) ;	\ 
								  ITEM_STATE( STATE_SLIDE_RIGHT, rect (SPECIALTY_IMAGE_X+GRID_BUTTON_SLIDE_DISTANCE) (SPECIALTY_DESC_Y+SPECIALTY_Y_OFFSET) SPECIALTY_LOADOUT_WIDTH 20 SPECIALTY_LOADOUT_ALIGN, ; ) ;											\ 
								  ITEM_STATE_FADEOUT( CHOICE_TEXTCOLOR_NO_ALPHA, ; ) )

#define MOBILITY_ARMOR_BAR_WIDTH			100
#define MOBILITY_ARMOR_BAR_HEIGHT			12

#define MOBILITY_ARMOR_BAR_X				SPECIALTY_IMAGE_X
#define MOBILITY_ARMOR_BAR_Y				SPECIALTY_IMAGE_Y

#define ANIMATE_BAR_NAME animated_shader

#define ANIMATE_BAR						\
		state							\
		{								\
			name	animate				\
			onEnter						\
			{							\
				changeState Default 0;	\
			}							\
		} 

#define BAR_FORMAT( px, py, pw, ph, palign, pvalue, visArg, extraArgs, bgExtraArgs )											\
		PREPROC_SHADER_DRAW_VIS_EX( px py (-(pw)) ph palign, "white", 0.3 0.3 0.3 1, visArg, ANIMATE_BAR bgExtraArgs )			\
		PREPROC_SHADER_DRAW_ADV_VIS_EX( px, py, pvalue*pw/100, ph, "white", palign, MEDIUM_GRAY, visArg, ANIMATE_BAR extraArgs )

// meter bar unit dividers
#define MOBILITY_ARMOR_UNITS( px, py ) \
		PREPROC_SHADER_DRAW_VIS_EX( (px+(MOBILITY_ARMOR_BAR_WIDTH/4))		(py+MOBILITY_ARMOR_BAR_HEIGHT) 1 3 SPECIALTY_LOADOUT_ALIGN, "white", MEDIUM_GRAY, 1, name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( MEDIUM_GRAY_NO_ALPHA, ; ) ) \
		PREPROC_SHADER_DRAW_VIS_EX( (px+(MOBILITY_ARMOR_BAR_WIDTH/2))		(py+MOBILITY_ARMOR_BAR_HEIGHT) 1 3 SPECIALTY_LOADOUT_ALIGN, "white", MEDIUM_GRAY, 1, name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( MEDIUM_GRAY_NO_ALPHA, ; ) ) \
		PREPROC_SHADER_DRAW_VIS_EX( (px+((MOBILITY_ARMOR_BAR_WIDTH/4)*3))	(py+MOBILITY_ARMOR_BAR_HEIGHT) 1 3 SPECIALTY_LOADOUT_ALIGN, "white", MEDIUM_GRAY, 1, name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( MEDIUM_GRAY_NO_ALPHA, ; ) ) \
		PREPROC_SHADER_DRAW_VIS_EX( (px+MOBILITY_ARMOR_BAR_WIDTH)			(py+MOBILITY_ARMOR_BAR_HEIGHT) 1 3 SPECIALTY_LOADOUT_ALIGN, "white", MEDIUM_GRAY, 1, name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( MEDIUM_GRAY_NO_ALPHA, ; ) )
	
// mobility and armor attribute meter bars
#define MOBILITY_ARMOR_BAR( px, py, pvalue ) \
		MOBILITY_ARMOR_UNITS( (px-1), py ) \
		BAR_FORMAT( px, py, MOBILITY_ARMOR_BAR_WIDTH, MOBILITY_ARMOR_BAR_HEIGHT, SPECIALTY_LOADOUT_ALIGN, pvalue, 1, name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( MEDIUM_GRAY_NO_ALPHA , ; ), name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( 0.3 0.3 0.3 0, ; ) )

#define CAC_LOADOUT_MOBILITY_ARMOR \
		/* titles */ \
		PREPROC_TEXT_DRAW_VIS_EX( MOBILITY_ARMOR_BAR_X (MOBILITY_ARMOR_BAR_Y-50) INFO_BOX_WIDTH 20 SPECIALTY_LOADOUT_ALIGN, 0 0, "@MENU_MOBILITY",	TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, 1, name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( COLOR_BODY_TEXT_NO_ALPHA, ; ) ) \
		PREPROC_TEXT_DRAW_VIS_EX( MOBILITY_ARMOR_BAR_X (MOBILITY_ARMOR_BAR_Y-30) INFO_BOX_WIDTH 20 SPECIALTY_LOADOUT_ALIGN, 0 0, "@MENU_ARMOR",		TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, 1, name ANIMATE_BAR_NAME; ITEM_STATE_FADEOUT( COLOR_BODY_TEXT_NO_ALPHA, ; ) ) \
		/* bars */ \
		MOBILITY_ARMOR_BAR( (MOBILITY_ARMOR_BAR_X+60), (MOBILITY_ARMOR_BAR_Y-50), MOBILITY_VALUE ) \
		MOBILITY_ARMOR_BAR(	(MOBILITY_ARMOR_BAR_X+60), (MOBILITY_ARMOR_BAR_Y-30), ARMOR_VALUE ) 

#define DRF_BAR_WIDTH		MOBILITY_ARMOR_BAR_WIDTH
#define DRF_BAR_HEIGHT		MOBILITY_ARMOR_BAR_HEIGHT

#define ACCURACY_VALUE( statArg ) \
		(tablelookup("mp/attributestable.csv", 1, GetItemRef( statArg ), 2 ))
#define DAMAGE_VALUE( statArg ) \
		(tablelookup("mp/attributestable.csv", 1, GetItemRef( statArg ), 3 ))
#define RANGE_VALUE( statArg ) \		
		(tablelookup("mp/attributestable.csv", 1, GetItemRef( statArg ), 4 ))
#define FIRE_RATE_VALUE( statArg ) \
		(tablelookup("mp/attributestable.csv", 1, GetItemRef( statArg ), 5 ))
#define MOBILITY_BAR_VALUE( statArg ) \
		(tablelookup("mp/attributestable.csv", 1, GetItemRef( statArg ), 6 ))
#define MAG_ROUND_VALUE( statArg ) \
		(tablelookup("mp/attributestable.csv", 1, GetItemRef( statArg ), 7 ))
#define FIRE_TYPE_VALUE( statArg ) \
		(tablelookup("mp/attributestable.csv", 1, GetItemRef( statArg ), 8 ))

#define IF_AUTO( statArg ) \
		(FIRE_TYPE_VALUE( statArg ) == auto )
#define IF_NOT_AUTO( statArg ) \
		(FIRE_TYPE_VALUE( statArg ) != auto )

#define DRF_UNITS( px, py, palign, visArg, extraArgs )																						\
		PREPROC_SHADER_DRAW_VIS_EX( (px+(DRF_BAR_WIDTH/4))		(py+DRF_BAR_HEIGHT) 1 3 palign, "white", MEDIUM_GRAY, visArg, extraArgs )	\
		PREPROC_SHADER_DRAW_VIS_EX( (px+(DRF_BAR_WIDTH/2))		(py+DRF_BAR_HEIGHT) 1 3 palign, "white", MEDIUM_GRAY, visArg, extraArgs )	\
		PREPROC_SHADER_DRAW_VIS_EX( (px+((DRF_BAR_WIDTH/4)*3))	(py+DRF_BAR_HEIGHT) 1 3 palign, "white", MEDIUM_GRAY, visArg, extraArgs )	\
		PREPROC_SHADER_DRAW_VIS_EX( (px+DRF_BAR_WIDTH)			(py+DRF_BAR_HEIGHT) 1 3 palign, "white", MEDIUM_GRAY, visArg, extraArgs )

#define ATTRIBUTE_BAR( px, py, palign, pvalue, visArg, extraArgs ) \
		DRF_UNITS( (px-1), py, palign, visArg, extraArgs ) \
		BAR_FORMAT( px, py, DRF_BAR_WIDTH, DRF_BAR_HEIGHT, palign, pvalue, visArg, extraArgs, extraArgs )

#define CAC_LOADOUT_DAMAGE_RANGE_FIRE_RATE( px, py, palign, statArg, visArg, extraArgs ) \
		/* titles */ \
		PREPROC_TEXT_DRAW_VIS_EX( px (py)		INFO_BOX_WIDTH 20 palign, 0 0, "@MENU_ACCURACY1",	TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, when( visArg );, name ANIMATE_BAR_NAME; extraArgs ) \
		PREPROC_TEXT_DRAW_VIS_EX( px (py+20)	INFO_BOX_WIDTH 20 palign, 0 0, "@MENU_MOBILITY",	TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, when( visArg );, name ANIMATE_BAR_NAME; extraArgs ) \
		PREPROC_TEXT_DRAW_VIS_EX( px (py+40)	INFO_BOX_WIDTH 20 palign, 0 0, "@MENU_DAMAGE",		TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, when( visArg );, name ANIMATE_BAR_NAME; extraArgs ) \
		PREPROC_TEXT_DRAW_VIS_EX( px (py+60)	INFO_BOX_WIDTH 20 palign, 0 0, "@MENU_RANGE",		TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, when( visArg );, name ANIMATE_BAR_NAME; extraArgs ) \
		PREPROC_TEXT_DRAW_VIS_EX( px (py+80)	INFO_BOX_WIDTH 20 palign, 0 0, "@MENU_FIRE_RATE",	TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, when( visArg );, name ANIMATE_BAR_NAME; extraArgs ) \
		/* bars */ \
		ATTRIBUTE_BAR( (px+60), (py),		palign, ACCURACY_VALUE( statArg ),										when( visArg );,	name ANIMATE_BAR_NAME; extraArgs ) \
		ATTRIBUTE_BAR( (px+60), (py+20),	palign, MOBILITY_BAR_VALUE( statArg ),									when( visArg );,	name ANIMATE_BAR_NAME; extraArgs ) \
		ATTRIBUTE_BAR( (px+60), (py+40),	palign, DAMAGE_VALUE( statArg ),										when( visArg );,	name ANIMATE_BAR_NAME; extraArgs ) \
		ATTRIBUTE_BAR( (px+60), (py+60),	palign, RANGE_VALUE( statArg ),											when( visArg );,	name ANIMATE_BAR_NAME; extraArgs ) \
		ATTRIBUTE_BAR( (px+60), (py+80),	palign, Select( IF_AUTO( statArg ), FIRE_RATE_VALUE( statArg ), 0 ),	when( visArg );,	name ANIMATE_BAR_NAME; extraArgs ) \
		/* fire type */ \
		PREPROC_TEXT_DRAW_VIS_EX( (px+65)	(py+80)		INFO_BOX_WIDTH 20 palign, 0 0, "@"+FIRE_TYPE_VALUE( statArg ),											TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, when( visArg && IF_NOT_AUTO( statArg ) );, name	ANIMATE_BAR_NAME; extraArgs ) \
		/* magazine size */ \
		PREPROC_TEXT_DRAW_VIS_EX( px		(py+100)	INFO_BOX_WIDTH 20 palign, 0 0, MAG_ROUND_VALUE( statArg ) + " " + locString( "@MENU_ROUND_MAGAZINE"),	TEXTSIZE_SMALL, 0, -5, ITEM_ALIGN_MIDDLE_LEFT, COLOR_BODY_TEXT, when( visArg );,						   name	ANIMATE_BAR_NAME; extraArgs ) 

