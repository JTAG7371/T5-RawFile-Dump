#define SETUP_ACTION_INVITE																				\		
		play CHOICE_ACTION_SOUND;																		\		
		if ( !menuisopen("popup_summary") && IsSignedInToLive() && areStatsFetched() && !IsGuest() )	\
		{																								\
			execnow changemenuopenslidedirection menu_friends MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;		\				
			execnow openmenu menu_friends;																\
		}
			
#define SETUP_ACTION_PLAYERCARD																								\
		if ( !menuisopen("popup_summary") && IsSignedInToLive() && areStatsFetched() && !IsGuest() )						\
		{																													\
			if ( dvarInt( xblive_basictraining ) )																			\
			{																												\
				execnow changemenuopenslidedirection menu_playercard_self_basictraining MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;	\
				open "menu_playercard_self_basictraining";																	\
			}																												\
			else																											\
			{																												\
				execnow changemenuopenslidedirection menu_playercard_self MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;				\
				open "menu_playercard_self";																				\
			}																												\
		}
			

#define FRIENDS_BUTTON \
		FRIENDS_BUTTON_VIS( 1 )

#ifdef PC
	#define FRIENDS_BUTTON_VIS( visArg ) \
	SIMPLE_CHOICE_BUTTON_SOUND_VIS_RIGHT_BOTTOM( "@PLATFORM_PARTY_INVITE", SETUP_ACTION_INVITE, when( (visArg) && hasinvites() <= 0 ) ) \
	SIMPLE_CHOICE_BUTTON_SOUND_VIS_RIGHT_BOTTOM_PULSE( "@PLATFORM_PARTY_INVITE", SETUP_ACTION_INVITE, when( (visArg) && hasinvites() > 0 ) )
#else // #ifdef PC
	#define FRIENDS_BUTTON_VIS( visArg ) \
		GAMEPAD_BUTTON( -55 -15 70 17 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM, "@PLATFORM_PARTY_INVITE", BUTTON_Y { SETUP_ACTION_INVITE; }, when( anySignedInToLiveAndStatsFetched() && visArg ) )				
#endif // #else #ifdef PC


#define PLAYERCARD_BUTTON	\
		GAMEPAD_BUTTON( -200 -15 90 17 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM, "@PLATFORM_PLAYERCARD", BUTTON_X{ SETUP_ACTION_PLAYERCARD }, when ( dvarbool( invite_visible ) ) )
		
#define PLAYERLIST_SELECTED_ACTIONS																					\
		doubleClick																									\
		{																											\
			execNow set selectedPlayerXuid ( getfeederdata( "xuid" ) );												\
			execNow set selectedFriendname ( getfeederdata( "name" ) );												\
			if ( IsGuest() )																						\
			{																										\
				open error_guest_popmenu;																			\
			}																										\
			else																									\
			{																										\
				if ( getfeederdata( "xuid" ) != getXuid() )															\
				{																									\
					execnow changemenuopenslidedirection menu_playercard MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;		\
					open menu_playercard;																			\
				}																									\
				else																								\	
				{																									\
					if ( dvarInt( xblive_basictraining ) )																			\
					{																												\
						execnow changemenuopenslidedirection menu_playercard_self_basictraining MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;	\
						open "menu_playercard_self_basictraining";																	\
					}																												\
					else																											\
					{																												\
						execnow changemenuopenslidedirection menu_playercard_self MENU_SLIDE_DIRECTION_TOP_TO_BOTTOM;				\
						open "menu_playercard_self";																				\
					}																												\
				}																									\
			}																										\
		}																											\
		PAD_LEFT		
