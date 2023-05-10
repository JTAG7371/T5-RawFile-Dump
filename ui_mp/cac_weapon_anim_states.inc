
#define DROPDOWN_TIME	40
#define DROPUP_TIME		40
#define DROPDOWN_COUNT  6

#define DROPDOWN( menuName, nextName ) \
		state \
		{ \
			name		"DropDown" \
			forecolor	1 1 1 1 \
			onEnter \
			{ \
				execNow ui_animate menuName nextName DropDown DROPDOWN_TIME; \
			} \
		}

#define DROPDOWN_LAST( menuName ) \
		state \
		{ \
			name		"DropDown" \
			forecolor	1 1 1 1 \
			onEnter \
			{ \
				execNow set ui_droppedDown 1; \
			} \
		}

#define DROPUP( menuName, prevName ) \
		state \
		{ \
			name		"DropUp" \
			forecolor	1 1 1 0 \
			onEnter \
			{ \
				execNow ui_animate menuName prevName DropUp DROPDOWN_TIME; \
			} \
		}
		
#define DROPUP_LAST( menuName ) \
		state \
		{ \
			name		"DropUp" \
			forecolor	1 1 1 0 \
			onEnter \
			{ \
				execNow set ui_droppedDown 0; \
			} \
		}

		
#define DROPUP_OPENMENU( menuName, prevName ) \
		state \
		{ \
			name		"DropUpOpenMenu" \
			forecolor	1 1 1 0 \
			onEnter \
			{ \
				execNow ui_animate menuName prevName DropUpOpenMenu (DROPUP_TIME/DROPDOWN_COUNT); \
			} \
		}
		
#define DROPUP_OPENMENU_LAST( menuName ) \
		state \
		{ \
			name		"DropUpOpenMenu" \
			forecolor	1 1 1 0 \
			onEnter \
			{ \
				execNow set ui_droppedDown 0; \
				execNow openmenu menuName; \
			} \
		}

#define ACTION_DROPDOWN_START( condition, menuName ) \
		execNow ui_animate menuName WEAPON_GROUP_NAME"0" Default 0; \
		execNow ui_animate menuName WEAPON_GROUP_NAME"1" Default 0; \
		execNow ui_animate menuName WEAPON_GROUP_NAME"2" Default 0; \
		execNow if( condition ) ui_animate menuName WEAPON_GROUP_NAME"3" Default 0; \
		execNow if( condition ) ui_animate menuName WEAPON_GROUP_NAME"4" Default 0; \
		execNow ui_animate menuName WEAPON_GROUP_NAME"bg" DropDown (DROPDOWN_TIME*(DROPDOWN_COUNT-1)); \
		execNow ui_animate menuName WEAPON_GROUP_NAME"0" DropDown DROPDOWN_TIME;

#define ACTION_DROPUP_START( priCond, secCond, menuName ) \
		execNow ui_animate menuName WEAPON_GROUP_NAME"bg" DropUpDelay DROPUP_TIME; \
		execNow if( priCond ) ui_animate menuName WEAPON_GROUP_NAME"4" DropUp DROPUP_TIME; \
		execNow if( secCond ) ui_animate menuName WEAPON_GROUP_NAME"2" DropUp DROPUP_TIME;

