
#define SHOW_VIEWER								setdvar uiViewer_show 1
#define HIDE_VIEWER								setdvar uiViewer_show 0
#define SET_VIEWER_MODE_PLAYER					setdvar uiViewer_mode player
#define SET_VIEWER_MODE_PLAYER_EDIT_HEAD		setdvar uiViewer_mode editplayerhead
#define SET_VIEWER_MODE_PLAYER_EDIT_BODY		setdvar uiViewer_mode editplayerbody
#define SET_VIEWER_MODE_PLAYER_FACE_PATTERN		setdvar uiViewer_mode editfacepattern
#define SET_VIEWER_MODE_PLAYER_FACE_PATTERN_COLOR	setdvar uiViewer_mode editfacepatterncolor
#define SET_VIEWER_MODE_COMBAT_RECORD			setdvar uiViewer_mode combatrecord
#define SET_VIEWER_MODE_WEAPON					setdvar uiViewer_mode weapon
#define SET_VIEWER_MODE_WEAPON_EDIT				setdvar uiViewer_mode editweapon
#define SET_VIEWER_MODE_EDIT_ATTACHMENT_TOP		setdvar uiViewer_mode editattachmenttop
#define SET_VIEWER_MODE_EDIT_ATTACHMENT_BOTTOM	setdvar uiViewer_mode editattachmentbottom
#define SET_VIEWER_MODE_EDIT_ATTACHMENT_TRIGGER	setdvar uiViewer_mode editattachmenttrigger
#define SET_VIEWER_MODE_EDIT_ATTACHMENT_MUZZLE	setdvar uiViewer_mode editattachmentmuzzle
#define SET_VIEWER_MODE_EDIT_CAMO				setdvar uiViewer_mode editcamo
#define SET_VIEWER_MODE_EDIT_RETICLE			setdvar uiViewer_mode editreticle
#define SET_VIEWER_MODE_EDIT_LENS				setdvar uiViewer_mode editlens
#define SET_VIEWER_MODE_EDIT_TAG				setdvar uiViewer_mode edittag
#define SET_VIEWER_MODE_EDIT_EMBLEM				setdvar uiViewer_mode editemblem
#define SET_VIEWER_MODE_AFTER_ACTION_REPORT		setdvar uiViewer_mode aar_weapon

#define VIEWER_SET_PLAYER(customname)		setdvar uiViewer_customname customname
#define VIEWER_SET_EQUIP_WEAPON(which)		setdvar uiViewer_equipWeapon which
#define VIEWER_SET_PLAYER_CAMERA(cam)		setdvar uiViewer_playerCamera cam

#define ADD_3D_VIEWER(right, top, size)													\
		itemDef																			\
		{																				\
			visible			when( dvarint( uiViewer_loaded ) == 1 )						\
			rect			right top size size HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP\
			forecolor		1 1 1 1														\
			style			WINDOW_STYLE_SHADER											\
			background		"ui_viewer"													\
			decoration																	\
		}																				\
		itemDef																			\
		{																				\
			visible			0															\
			rect			right top size size HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP\
			forecolor		1 0 0 0.2													\
			style			WINDOW_STYLE_SHADER											\
			background		"white"														\
			decoration																	\
		}																				\
		itemDef																			\
		{																				\
			visible			when( dvarint( uiViewer_loaded ) == 0 || dvarint( uiViewer_streaming ) == 1 ) \
			rect			(right-40) top size size HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP\
			forecolor		1 1 1 1														\
			style			WINDOW_STYLE_SPINNER										\
			decoration																	\
		}																				\
		itemDef																			\
		{																				\
			visible			when( dvarint( uiViewer_showGrid ) == 1 )					\
			rect			right top size size HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP\
			forecolor		1 1 1 1														\
			style			WINDOW_STYLE_SHADER											\
			background		"viewer_grid"												\
			decoration																	\
		}																				\
		itemDef																			\
		{																				\
			type			ITEM_TYPE_TEXT												\
			visible			when ( dvarint( uiViewer_cameraControl ) == 1 )				\
			rect			right (top+size/2+50) size 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_TOP\
			forecolor		1 1 1 1														\
			forecolor		CHOICE_TEXTCOLOR											\
			textfont		CHOICE_TEXTFONT												\
			textscale		TEXTSIZE_SMALL												\
			exp text		dvarstring( uiViewer_msg );									\
			decoration																	\
		}

#ifdef CONSOLE
#define ADD_PLAYER_VIEWER        ADD_3D_VIEWER(-176, -47, 440)
#define ADD_WEAPON_VIEWER_CENTER ADD_3D_VIEWER(-60, 90, 350)
#define ADD_WEAPON_VIEWER_SMALL  ADD_3D_VIEWER(260, 35, 256)
#define ADD_WEAPON_VIEWER_AAR    ADD_3D_VIEWER(75, 250, 250)
#else //(PC)
#ifndef PC_INGAME
#define ADD_PLAYER_VIEWER        ADD_3D_VIEWER(-176, -12, 440)
#define ADD_WEAPON_VIEWER_CENTER ADD_3D_VIEWER(-60, 60, 550)
#define ADD_WEAPON_VIEWER_SMALL  ADD_3D_VIEWER(260, 85, 256)
#define ADD_WEAPON_VIEWER_AAR    ADD_3D_VIEWER(0, 100, 250)
#else
#define ADD_PLAYER_VIEWER
#define ADD_WEAPON_VIEWER_CENTER
#define ADD_WEAPON_VIEWER_SMALL
#define ADD_WEAPON_VIEWER_AAR
#endif
#endif
 
