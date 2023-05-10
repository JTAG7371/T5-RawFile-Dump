#define PUBLIC_PARTY_COUNT_DVAR 9
#define PRIVATE_PARTY_COUNT_DVAR 18
#define BASIC_TRAINING_PARTY_COUNT_DVAR 12
#define SPLITSCREEN_PLAYER_COUNT 2

//
// GENERIC LOBBY SETUP FUNCTIONS
//

#define EXEC_XBOXLIVE_CFG 		execNow "exec "XBOXLIVE_MP_CFG;																				
#define EXEC_PRIVATE_CFG 		execNow "exec "PRIVATE_MP_CFG;																				
#define EXEC_DEFAULT_DVAR_CFG 		execNow "exec dvar_defaults.cfg";																				

#define INITIALIZE_LOCAL_PLAYERS 																					\
		execNow "disableallclients";																					\
		execNow "setclientbeingusedandprimary";																
                                                              						
#define CREATE_PARTY_LOBBY			 																					\
		execNow "xstartprivateparty";			                        						
                                                              						
#define CREATE_PRIVATE_LOBBY			 																				\
		execNow "ui_enumeratesaved";																					\
		execNow "xstartpartyhost";		                            						
                                                              						
#define RESET_GAME_MODES 																									\
		EXEC_DEFAULT_DVAR_CFG																									\
		resetdvar systemlink;																									\
		resetdvar splitscreen;																								\
		resetdvar onlinegame;																									\
		resetdvar xblive_privatematch;																				\
		resetdvar xblive_rankedmatch;																					\
		resetdvar xblive_wagermatch;																					\
		resetdvar xblive_clanmatch;																						\
		resetdvar xblive_theater;																							\
		resetdvar xblive_basictraining;	                        						
                                                              						
#define INIT_ACTION_LOBBY( PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR ) \
		RESET_GAME_MODES																											\
		EXEC_XBOXLIVE_CFG																											\
		setdvar onlinegame 1;																									\
		setdvar party_maxlocalplayers dvarInt( SPLITSCREEN_PLAYER_COUNT_DVAR );	\
		setdvar party_maxplayers dvarInt( PARTY_COUNT_DVAR ); 								\
		setdvar ui_mptype 0;																									\
		resetdvar party_timerVisible;			                      						
                                                              						
#define INIT_ACTION_PRIVATE_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )						\
		INIT_ACTION_LOBBY( PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )																		\
		setdvar LOBBY_DVAR 1;																																										\
		EXEC_PRIVATE_CFG
                                                              						                                                       						                                                              						
#define INIT_ACTION_PARTY_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )							\
		INIT_ACTION_LOBBY(PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR)																			\
		setdvar LOBBY_DVAR 1;																									

#define SWITCH_ACTION_PRIVATE_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )					\
		INIT_ACTION_PRIVATE_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )								\
		execNow "xpartyswitchlobbies";
                                                              						                                                       						                                                              						
#define SWITCH_ACTION_PARTY_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )						\
		INIT_ACTION_PARTY_LOBBY(LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR)										\
		execNow "xpartyswitchlobbies";

#define START_ACTION_LOBBY( PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )																\
		INITIALIZE_LOCAL_PLAYERS																																								\
		INIT_ACTION_LOBBY( PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )		                    						

#define CONVERT_ACTION_PARTY_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )						\
		INIT_ACTION_PARTY_LOBBY(LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR)										\
		execNow "xpartyconvertlobbies";
			                                                          						
#define CONVERT_ACTION_PRIVATE_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )					\
		INIT_ACTION_PRIVATE_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )								\
		CREATE_PRIVATE_LOBBY                                      						

#define START_ACTION_PARTY_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )							\
		INITIALIZE_LOCAL_PLAYERS																																								\
		INIT_ACTION_PARTY_LOBBY(LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR)										\
		CREATE_PARTY_LOBBY                                        						
		                                                          						
#define START_ACTION_PRIVATE_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )						\
		INITIALIZE_LOCAL_PLAYERS																																								\
		INIT_ACTION_PRIVATE_LOBBY( LOBBY_DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )								\
		CREATE_PARTY_LOBBY																																											\
		CREATE_PRIVATE_LOBBY                                      						
                                                              						
#define SWITCH_ACTION_PARTY_MENULOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, MENU, CLOSE_MENU ) \	
		SWITCH_ACTION_PARTY_LOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )											\
		close CLOSE_MENU;																																												\
		open MENU;																																															\
		close self;                               														

#define CONVERT_ACTION_PARTY_MENULOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, MENU, CLOSE_MENU )					\	
		CONVERT_ACTION_PARTY_LOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )												\
		close CLOSE_MENU;																											\
		open MENU;																														\
		close self;                               														
                                                              						                                                              						
#define START_ACTION_PARTY_MENULOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, MENU )						\	
		START_ACTION_PARTY_LOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )													\
		open MENU;																														\
		close self;                               														
                                                              						
#define SWITCH_ACTION_PRIVATE_MENULOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, MENU, CLOSE_MENU )				\	
		SWITCH_ACTION_PRIVATE_LOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )											\
		close CLOSE_MENU;																											\
		open MENU;																														\
		close self;                               														
                                                              						
#define CONVERT_ACTION_PRIVATE_MENULOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, MENU, CLOSE_MENU )				\	
		CONVERT_ACTION_PRIVATE_LOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )											\
		close CLOSE_MENU;																											\
		open MENU;																														\
		close self;                               														
                                                              						
#define START_ACTION_PRIVATE_MENULOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR, MENU )					\	
		START_ACTION_PRIVATE_LOBBY( DVAR, PARTY_COUNT_DVAR, SPLITSCREEN_PLAYER_COUNT_DVAR )												\
		open MENU;																														\
		close self;                               														
    
    
//                                                            						
// LOBBY FULL START FUNCTIONS (no current lobby)                         						
//                                                            						
                                                              						
#define START_ACTION_PLAYERMATCH																							\	
		START_ACTION_PARTY_MENULOBBY( onlinegame, party_maxplayers_partylobby, party_maxlocalplayers_playermatch, menu_xboxlive )
	
#define START_ACTION_WAGERMATCH																						\	
		START_ACTION_PARTY_MENULOBBY( xblive_wagermatch, party_maxplayers_wagerpartylobby, party_maxlocalplayers_wagermatch, menu_xboxlive )
	
#define START_ACTION_PRIVATEMATCH																					\	
		START_ACTION_PRIVATE_MENULOBBY( xblive_privatematch, party_maxplayers_privatematch, party_maxlocalplayers_privatematch, menu_xboxlive_privatelobby )
	
#define START_ACTION_THEATER																							\	
		execNow set ui_demoname "";																						\
		START_ACTION_PRIVATE_MENULOBBY( xblive_theater, party_maxplayers_theater, party_maxlocalplayers_theater, menu_xboxlive_theaterlobby )
	
#define START_ACTION_BASIC_TRAINING																				\	
		START_ACTION_PRIVATE_MENULOBBY( xblive_basictraining, party_maxplayers_basictraining, party_maxlocalplayers_basictraining, menu_xboxlive_basictraining ) \
		execNow "ui_gametype tdm"																

//                                                            						
// LOBBY SWITCH FUNCTIONS ( switch to a lobby of the same type )                             						
//                                                            						

#define SWITCH_ACTION_PLAYERMATCH( CLOSE_MENU )																						\	
		SWITCH_ACTION_PARTY_MENULOBBY( onlinegame, party_maxplayers_partylobby, party_maxlocalplayers_playermatch, menu_xboxlive, CLOSE_MENU )

#define SWITCH_ACTION_WAGERMATCH( CLOSE_MENU )																					\	
		SWITCH_ACTION_PARTY_MENULOBBY( xblive_wagermatch, party_maxplayers_wagerpartylobby, party_maxlocalplayers_wagermatch, menu_xboxlive, CLOSE_MENU )

#define SWITCH_ACTION_PRIVATEMATCH( CLOSE_MENU )																				\	
		SWITCH_ACTION_PRIVATE_MENULOBBY( xblive_privatematch, party_maxplayers_privatematch, party_maxlocalplayers_privatematch, menu_xboxlive_privatelobby, CLOSE_MENU )

#define SWITCH_ACTION_THEATER( CLOSE_MENU )																							\	
		execNow set ui_demoname "";																									\
		SWITCH_ACTION_PRIVATE_MENULOBBY( xblive_theater, party_maxplayers_theater, party_maxlocalplayers_theater, menu_xboxlive_theaterlobby, CLOSE_MENU )

#define SWITCH_ACTION_BASIC_TRAINING( CLOSE_MENU )																			\	
		SWITCH_ACTION_PRIVATE_MENULOBBY( xblive_basictraining, party_maxplayers_basictraining, party_maxlocalplayers_basictraining, menu_xboxlive_basictraining, CLOSE_MENU ) \
		execNow "ui_gametype tdm"																

//                                                            						
// LOBBY CONVERT FUNCTIONS ( switch to a lobby of a different type )                             						
//                                                            						

#define CONVERT_ACTION_PLAYERMATCH( CLOSE_MENU )																						\	
		CONVERT_ACTION_PARTY_MENULOBBY( onlinegame, party_maxplayers_partylobby, party_maxlocalplayers_playermatch, menu_xboxlive, CLOSE_MENU )

#define CONVERT_ACTION_WAGERMATCH( CLOSE_MENU )																					\	
		CONVERT_ACTION_PARTY_MENULOBBY( xblive_wagermatch, party_maxplayers_wagerpartylobby, party_maxlocalplayers_wagermatch, menu_xboxlive, CLOSE_MENU )

#define CONVERT_ACTION_PRIVATEMATCH( CLOSE_MENU )																				\	
		CONVERT_ACTION_PRIVATE_MENULOBBY( xblive_privatematch, party_maxplayers_privatematch, party_maxlocalplayers_privatematch, menu_xboxlive_privatelobby, CLOSE_MENU )

#define CONVERT_ACTION_THEATER( CLOSE_MENU )																							\	
		execNow set ui_demoname "";																										\
		CONVERT_ACTION_PRIVATE_MENULOBBY( xblive_theater, party_maxplayers_theater, party_maxlocalplayers_theater, menu_xboxlive_theaterlobby, CLOSE_MENU )

#define CONVERT_ACTION_BASIC_TRAINING( CLOSE_MENU )																			\	
		CONVERT_ACTION_PRIVATE_MENULOBBY( xblive_basictraining, party_maxplayers_basictraining, party_maxlocalplayers_basictraining, menu_xboxlive_basictraining, CLOSE_MENU ) \
		execNow "ui_gametype tdm"																


