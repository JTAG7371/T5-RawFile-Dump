#define CHOICE_TEXTCOLOR_NO_ALPHA				0.84313 0.84313 0.84313 0
#define CHOICE_TEXTCOLOR_NO_ALPHA_COMPONENT		0.84313 0.84313 0.84313 
#define MEDIUM_GRAY_NO_ALPHA					0.4 0.4 0.4 0
#define LIGHT_GRAY_NO_ALPHA						0.8 0.8 0.8 0
#define DARK_GRAY_NO_ALPHA						0.2 0.2 0.2 0
#define GRID_OUTLINE_COLOR_NO_ALPHA				0.3 0.3 0.3 0
#define COLOR_BODY_TEXT_NO_ALPHA				0.62745 0.66667 0.67451 0

#define FADEOUT_STATE_NAME FadeOut
#define SLIDE_STATE_NAME Slide
#define SLIDEANDFADE_STATE_NAME SlideAndFade
#define GRID_SPECIALTIES_FADEIN_NAME spec_fadein

#define FADING_TIME 250

#define SPECIALTIES_SLIDING_TIME 250
#define SPECIALTIES_RESET_TIME 250
#define GRID_BUTTON_SLIDING_TIME 250
#define GRID_BUTTON_RESET_TIME 250

#define SLIDE_DISTANCE_SPECIALTIES 100
#define GRID_BUTTON_SLIDE_DISTANCE 400

#define ITEM_STATE( stateName, args, onEnterArgs ) \
		state { name stateName; args; onEnter { onEnterArgs; } }

#define ITEM_STATE_FADEOUT( color, onEnterArgs ) \
		ITEM_STATE( FADEOUT_STATE_NAME, forecolor color, onEnterArgs )

#define ITEM_STATE_SLIDE( rectArg, onEnterArgs ) \
		ITEM_STATE( SLIDE_STATE_NAME, rect rectArg, onEnterArgs )

#define ITEM_ANIMATE( menuName, itemName, stateName, duration ) \
		execnow ui_animate menuName itemName stateName duration;

#define ITEM_FADEOUT( menuName, itemName ) \
		ITEM_ANIMATE( menuName, itemName, FADEOUT_STATE_NAME, FADING_TIME ) 

#define ITEM_FADEIN( menuName, itemName ) \
		ITEM_ANIMATE( menuName, itemName, default, FADING_TIME ) 

#define ITEM_SLIDE( menuName, itemName, slideDuration ) \
		ITEM_ANIMATE( menuName, itemName, SLIDE_STATE_NAME, slideDuration )

#define GRID_BUTTON_FADEOUT( menuName, itemIndex ) \
		ITEM_FADEOUT( menuName, GRID_BUTTON_NAME#itemIndex ) \
		ITEM_FADEOUT( menuName, GRID_BUTTON_NAME"_outline"#itemIndex ) \
		ITEM_FADEOUT( menuName, GRID_BUTTON_NAME"_rect"#itemIndex )

#define GRID_BUTTON_FADEIN( menuName, itemIndex ) \
		ITEM_FADEIN( menuName, GRID_BUTTON_NAME#itemIndex ) \
		ITEM_FADEIN( menuName, GRID_BUTTON_NAME"_outline"#itemIndex ) \
		ITEM_FADEIN( menuName, GRID_BUTTON_NAME"_rect"#itemIndex )

#define GRID_BUTTON_SPECIALTIES_SLIDE_UP \
		ITEM_ANIMATE( menu_cac_custom, GRID_BUTTON_NAME"9", STATE_SLIDE_UP, SPECIALTIES_SLIDING_TIME  ) \
		ITEM_ANIMATE( menu_cac_custom, GRID_BUTTON_NAME"_outline9", STATE_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, GRID_BUTTON_NAME"_rect9", STATE_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialty1, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtySpecial, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtyFrag, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialty2, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_icon, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_desc, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_icon, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_desc, SPECIALTIES_INFO_SLIDE_UP, SPECIALTIES_SLIDING_TIME ) 

#define GRID_BUTTON_SPECIALTIES_SLIDE_RIGHT \
		ITEM_ANIMATE( menu_cac_custom, GRID_BUTTON_NAME"9",			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, GRID_BUTTON_NAME"_outline9",	FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, GRID_BUTTON_NAME"_rect9",	FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialty1,			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtySpecial,		FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtyFrag,			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialty2,			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_icon,			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_desc,			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_icon,			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_desc,			FADEOUT_STATE_NAME, SPECIALTIES_SLIDING_TIME ) 

#define GRID_BUTTON_SLIDE( menuName, itemIndex ) \
		ITEM_SLIDE( menuName, GRID_BUTTON_NAME#itemIndex, GRID_BUTTON_SLIDING_TIME  ) \
		ITEM_SLIDE( menuName, GRID_BUTTON_NAME"_outline"#itemIndex, GRID_BUTTON_SLIDING_TIME ) \
		ITEM_SLIDE( menuName, GRID_BUTTON_NAME"_rect"#itemIndex, GRID_BUTTON_SLIDING_TIME )

#define GRID_BUTTON_ANIMATE( menuName, itemIndex, state, duration ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME#itemIndex, state, duration  ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME"_outline"#itemIndex, state, duration ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME"_rect"#itemIndex, state, duration )

#define GRID_BUTTON_RESET_POS( menuName, itemIndex ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME#itemIndex, default, GRID_BUTTON_SLIDING_TIME  ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME"_outline"#itemIndex, default, GRID_BUTTON_SLIDING_TIME ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME"_rect"#itemIndex, default, GRID_BUTTON_SLIDING_TIME )

#define SPECIALTIES_DUMMY_BUTTON_FADEIN \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME"10", FadeOut, FADING_TIME  ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME"_outline10", FadeOut, FADING_TIME ) \
		ITEM_ANIMATE( menuName, GRID_BUTTON_NAME"_rect10", FadeOut, FADING_TIME )

#define SPECIALTIES_INFO_FADEOUT \
		ITEM_FADEOUT( menu_cac_custom, local_specialty1 ) \
		ITEM_FADEOUT( menu_cac_custom, local_specialtySpecial ) \
		ITEM_FADEOUT( menu_cac_custom, local_specialtyFrag ) \
		ITEM_FADEOUT( menu_cac_custom, local_specialty2 ) \
		ITEM_FADEOUT( menu_cac_custom, specialty_1_icon ) \
		ITEM_FADEOUT( menu_cac_custom, specialty_1_desc ) \
		ITEM_FADEOUT( menu_cac_custom, specialty_2_icon ) \
		ITEM_FADEOUT( menu_cac_custom, specialty_2_desc ) 

#define SPECIALTIES_INFO_SLIDEUPANDFADE \
		ITEM_ANIMATE( menu_cac_custom, local_specialty1, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtySpecial, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtyFrag, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialty2, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_icon, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_desc, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_icon, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_desc, SLIDEANDFADE_STATE_NAME, SPECIALTIES_SLIDING_TIME ) \

#define SPECIALTIES_INFO_FADEIN \
		ITEM_FADEIN( menu_cac_custom, local_specialty1 ) \
		ITEM_FADEIN( menu_cac_custom, local_specialtySpecial ) \
		ITEM_FADEIN( menu_cac_custom, local_specialtyFrag ) \
		ITEM_FADEIN( menu_cac_custom, local_specialty2 ) \
		ITEM_FADEIN( menu_cac_custom, specialty_1_icon ) \
		ITEM_FADEIN( menu_cac_custom, specialty_1_desc ) \
		ITEM_FADEIN( menu_cac_custom, specialty_2_icon ) \
		ITEM_FADEIN( menu_cac_custom, specialty_2_desc ) 

#define GRID_SPECIALTIES_INFO_FADEIN \
		ITEM_ANIMATE( menu_cac_custom, grid_specialty1, GRID_SPECIALTIES_FADEIN_NAME, FADING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, grid_specialty_1_icon, GRID_SPECIALTIES_FADEIN_NAME, FADING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, grid_specialty_1_desc, GRID_SPECIALTIES_FADEIN_NAME, FADING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, grid_specialties_hint, GRID_SPECIALTIES_FADEIN_NAME, FADING_TIME ) 

#define GRID_SPECIALTIES_INFO_FADEOUT \
		ITEM_ANIMATE( menu_cac_custom, grid_specialty1, default, FADING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, grid_specialty_1_icon, default, FADING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, grid_specialty_1_desc, default, FADING_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, grid_specialties_hint, default, FADING_TIME ) 

#define ITEM_INFO_LEFT_FADEIN( timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_icon_left, ITEM_INFO_FADEIN_STATE, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_name_left, ITEM_INFO_FADEIN_STATE, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_desc_left, ITEM_INFO_FADEIN_STATE, timeArg ) \

#define ITEM_INFO_LEFT_FADEOUT( timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_icon_left, default, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_name_left, default, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_desc_left, default, timeArg ) \

#define ITEM_INFO_RIGHT_FADEIN( timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_icon_right, ITEM_INFO_FADEIN_STATE, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_name_right, ITEM_INFO_FADEIN_STATE, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_desc_right, ITEM_INFO_FADEIN_STATE, timeArg ) \

#define ITEM_INFO_RIGHT_FADEOUT( timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_icon_right, default, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_name_right, default, timeArg ) \
		ITEM_ANIMATE( menu_cac_custom, item_info_desc_right, default, timeArg ) \

#define SPECIALTIES_INFO_RESET_POSITION \
		ITEM_ANIMATE( menu_cac_custom, local_specialty1, default, SPECIALTIES_RESET_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtySpecial, default, SPECIALTIES_RESET_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialtyFrag, default, SPECIALTIES_RESET_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, local_specialty2, default, SPECIALTIES_RESET_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_icon, default, SPECIALTIES_RESET_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_1_desc, default, SPECIALTIES_RESET_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_icon, default, SPECIALTIES_RESET_TIME ) \
		ITEM_ANIMATE( menu_cac_custom, specialty_2_desc, default, SPECIALTIES_RESET_TIME ) \
		GRID_BUTTON_RESET_POS( menu_cac_custom, 2 )

#define CLASS_BONUS_INFO_FADEOUT \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_title ) \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_vert_line ) \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_horiz_line ) \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_name ) \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_desc ) \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_icon ) \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_explanation ) \
		ITEM_FADEOUT( menu_cac_custom, class_bonus_bottom_horiz_line ) 

#define CLASS_BONUS_INFO_FADEIN \
		ITEM_FADEIN( menu_cac_custom, class_bonus_title ) \
		ITEM_FADEIN( menu_cac_custom, class_bonus_vert_line ) \
		ITEM_FADEIN( menu_cac_custom, class_bonus_horiz_line ) \
		ITEM_FADEIN( menu_cac_custom, class_bonus_name ) \
		ITEM_FADEIN( menu_cac_custom, class_bonus_desc ) \
		ITEM_FADEIN( menu_cac_custom, class_bonus_icon ) \
		ITEM_FADEIN( menu_cac_custom, class_bonus_explanation ) \
		ITEM_FADEIN( menu_cac_custom, class_bonus_bottom_horiz_line ) 

#define MOBILITY_BAR_FADEOUT \
		ITEM_FADEOUT( menu_cac_custom, ANIMATE_BAR_NAME ) 

#define MOBILITY_BAR_FADEIN \
		ITEM_FADEIN( menu_cac_custom, ANIMATE_BAR_NAME ) 

