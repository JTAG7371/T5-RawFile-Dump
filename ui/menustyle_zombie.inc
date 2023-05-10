#include "ui/menudef.h"
#include "ui_mp/common_macro.inc"

#ifdef CONSOLE
	#define LOGO_START_X			-300
	#define LOGO_START_Y			-125
#endif

#ifdef PC
	#define LOGO_START_X			-300
	#define LOGO_START_Y			-160
	#undef	SIGNED_IN_RECT
	#define SIGNED_IN_RECT			-350 60 250 15
#endif

#define CHOICE_SIZE_X			150

#define CHOICE_X_START			0
#define CHOICE_Y_START			120

#ifdef CONSOLE
	#undef	CHOICE_Y_START
	#define CHOICE_Y_START			75
#endif

#ifdef PC
	#undef	CHOICE_X_START
	#define CHOICE_X_START			30
	#undef	CHOICE_Y_START
	#define CHOICE_Y_START			50
#endif

#define CHOICE_SEP_OFFSET_Y		-2

#ifdef PC
	#undef CHOICE_SEP_1
	#define CHOICE_SEP_1			12
	#define CHOICE_SEP_2			12
#endif
#ifdef CONSOLE
	#define CHOICE_SEP_1			12
#endif

#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"
#include "ui/choices_setup_popmenu.menu"

#ifdef PC
#include "ui/online_status.inc"
#endif

#include "ui/blurredbg.inc"

#define MAIN_BG_ZOMBIE \
	MAIN_BG( "menu_background_zombies" ) \
	TOP_BOTTOM_BORDERS
//	SCROLL_FOG \
	
#define MAIN_BG_ZOMBIE_BLUR \
	MAIN_BG( "menu_background_zombies_burred" ) \
	TOP_BOTTOM_BORDERS
//	SCROLL_FOG \
			
#define RESET_MUTATORS \
	setdvar mutator_noPerks 0; \		
	setdvar mutator_noTraps 0; \	
	setdvar mutator_noMagicBox 0; \		
	setdvar mutator_noRevive 0;	\	
	setdvar mutator_noPowerups 0; \		
	setdvar mutator_noReloads 0; \		
	setdvar mutator_noBoards 0;	\	
	setdvar mutator_fogMatch 0;	\	
	setdvar mutator_quickStart 0; \	
	setdvar mutator_headshotsOnly 0; \	
	setdvar mutator_friendlyFire 0; \		
	setdvar mutator_doubleMoney 0; \		
	setdvar mutator_susceptible 0; \		
	setdvar mutator_powerShot 0;