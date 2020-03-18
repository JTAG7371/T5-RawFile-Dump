/****************************************************************************
 
 battleChatter.gsc
*****************************************************************************/

#include common_scripts\utility;
#include animscripts\utility;
#include maps\_utility;
#include animscripts\battlechatter_ai;

/****************************************************************************
 initialization
*****************************************************************************/

// Initializes the battle chatter system
init_battleChatter()
{
//	/#
//	debug_replay("File: battlechatter.gsc. Function: init_battleChatter()\n");
//	#/
//	
//	if (IsDefined (anim.chatInitialized) && anim.chatInitialized)
//	{
//		return;
//	}
//
//	if (GetDvar ("bcs_enable") == "")
//	{
//		SetDvar ("bcs_enable", "on");
//	}
//
//	if (GetDvar ("bcs_enable") == "off")
//	{
//		anim.chatInitialized = false;
//		// CODER_MOD
////		anim.player.chatInitialized = false;
//		return;
//	}
//
//	if(!IsDefined(level.NumberOfImportantPeopleTalking))
//	{
//		level.NumberOfImportantPeopleTalking = 0;
//	}
//	
//	anim.chatInitialized = true;
//	// CODER_MOD
////	anim.player.chatInitialized = false;
//
//	if (GetDvar ("bcs_filterThreat") == "")
//		SetDvar ("bcs_filterThreat", "off");
//	if (GetDvar ("bcs_filterInform") == "")
//		SetDvar ("bcs_filterInform", "off");
//	if (GetDvar ("bcs_filterOrder") == "")
//		SetDvar ("bcs_filterOrder", "off");
//	if (GetDvar ("bcs_filterReaction") == "")
//		SetDvar ("bcs_filterReaction", "off");
//	if (GetDvar ("bcs_filterResponse") == "")
//		SetDvar ("bcs_filterResponse", "off");
//
//	if (GetDvar ("bcs_threatLimitTargettedBySelf") == "")
//		SetDvar ("bcs_threatLimitTargettedBySelf", "off");
//	if (GetDvar ("bcs_threatLimitTargetingPlayer") == "")
//		SetDvar ("bcs_threatLimitTargetingPlayer", "off");
//	if (GetDvar ("bcs_threatLimitInPlayerFOV") == "")
//		SetDvar ("bcs_threatLimitInPlayerFOV", "on");
//	if (GetDvar ("bcs_threatLimitInLocation") == "")
//		SetDvar ("bcs_threatLimitInLocation", "on");
//	if (GetDvar ("bcs_threatLimitSpeakerDist") == "")
//		SetDvar ("bcs_threatLimitSpeakerDist", "512");
//	if (GetDvar ("bcs_threatLimitThreatDist") == "")
//		SetDvar ("bcs_threatLimitThreatDist", "1024");
//
//	if (GetDvar ("bcs_threatPlayerRelative") == "")
//		SetDvar ("bcs_threatPlayerRelative", "off");
//
//	if (GetDvar( #"debug_bcprint") == "")
//		SetDvar("debug_bcprint", "off");
//	if (GetDvar( #"debug_bcshowqueue") == "")
//		SetDvar("debug_bcshowqueue", "off");
//	if (GetDvar( #"debug_bclotsoprint") == "")
//		SetDvar("debug_bclotsoprint", "off");
//
///#
//	if (GetDvar( #"debug_bcthreat") == "")
//		SetDvar("debug_bcthreat", "off");
//	if (GetDvar( #"debug_bcresponse") == "")
//		SetDvar("debug_bcresponse", "off");
//	if (GetDvar( #"debug_bcorder") == "")
//		SetDvar("debug_bcorder", "off");
//	if (GetDvar( #"debug_bcinform") == "")
//		SetDvar("debug_bcinform", "off");
//	if (GetDvar( #"debug_bcdrawobjects") == "")
//		SetDvar("debug_bcdrawobjects", "off");
//	if (GetDvar( #"debug_bcinteraction") == "")
//		SetDvar("debug_bcinteraction", "off");
//#/
//	
//	anim.countryIDs["british"] = "UK";
//	anim.countryIDs["american"] = "vox_spl_us";
//	anim.countryIDs["russian"] = "vox_spl_ru";
//	anim.countryIDs["german"] = "vox_spl_ge";
//	anim.countryIDs["vietnamese"] = "vox_spl_vt";
//	anim.countryIDs["civilian"] = "vox_spl_cv";
//
//	anim.usedIDs = [];
//	anim.usedIDs["russian"] = [];
//	anim.usedIDs["russian"][0] = SpawnStruct();
//	anim.usedIDs["russian"][0].count = 0;
//	anim.usedIDs["russian"][0].npcID = "0";
//	anim.usedIDs["russian"][1] = SpawnStruct();
//	anim.usedIDs["russian"][1].count = 0;
//	anim.usedIDs["russian"][1].npcID = "1";
//	anim.usedIDs["russian"][2] = SpawnStruct();
//	anim.usedIDs["russian"][2].count = 0;
//	anim.usedIDs["russian"][2].npcID = "2";
//	anim.usedIDs["russian"][2] = SpawnStruct();
//	anim.usedIDs["russian"][2].count = 0;
//	anim.usedIDs["russian"][2].npcID = "3";
//
//
//	anim.usedIDs["american"] = [];
//	anim.usedIDs["american"][0] = SpawnStruct();
//	anim.usedIDs["american"][0].count = 0;
//	anim.usedIDs["american"][0].npcID = "0";
//	anim.usedIDs["american"][1] = SpawnStruct();
//	anim.usedIDs["american"][1].count = 0;
//	anim.usedIDs["american"][1].npcID = "1";
//	anim.usedIDs["american"][2] = SpawnStruct();
//	anim.usedIDs["american"][2].count = 0;
//	anim.usedIDs["american"][2].npcID = "2";
//	anim.usedIDs["american"][3] = SpawnStruct();
//	anim.usedIDs["american"][3].count = 0;
//	anim.usedIDs["american"][3].npcID = "3";
//
//	anim.usedIDs["german"] = [];
//	anim.usedIDs["german"][0] = SpawnStruct();
//	anim.usedIDs["german"][0].count = 0;
//	anim.usedIDs["german"][0].npcID = "0";
//	anim.usedIDs["german"][1] = SpawnStruct();
//	anim.usedIDs["german"][1].count = 0;
//	anim.usedIDs["german"][1].npcID = "1";
//	anim.usedIDs["german"][2] = SpawnStruct();
//	anim.usedIDs["german"][2].count = 0;
//	anim.usedIDs["german"][2].npcID = "2";
//	anim.usedIDs["german"][3] = SpawnStruct();
//	anim.usedIDs["german"][3].count = 0;
//	anim.usedIDs["german"][3].npcID = "3";
//
//	anim.usedIDs["vietnamese"] = [];
//	anim.usedIDs["vietnamese"][0] = SpawnStruct();
//	anim.usedIDs["vietnamese"][0].count = 0;
//	anim.usedIDs["vietnamese"][0].npcID = "0";
//	anim.usedIDs["vietnamese"][1] = SpawnStruct();
//	anim.usedIDs["vietnamese"][1].count = 0;
//	anim.usedIDs["vietnamese"][1].npcID = "1";
//	anim.usedIDs["vietnamese"][2] = SpawnStruct();
//	anim.usedIDs["vietnamese"][2].count = 0;
//	anim.usedIDs["vietnamese"][2].npcID = "2";
//	anim.usedIDs["vietnamese"][3] = SpawnStruct();
//	anim.usedIDs["vietnamese"][3].count = 0;
//	anim.usedIDs["vietnamese"][3].npcID = "3";
//	
//	anim.usedIDs["civilian"] = [];
//	anim.usedIDs["civilian"][0] = SpawnStruct();
//	anim.usedIDs["civilian"][0].count = 0;
//	anim.usedIDs["civilian"][0].npcID = "0";
//	anim.usedIDs["civilian"][1] = SpawnStruct();
//	anim.usedIDs["civilian"][1].count = 0;
//	anim.usedIDs["civilian"][1].npcID = "1";
//	anim.usedIDs["civilian"][2] = SpawnStruct();
//	anim.usedIDs["civilian"][2].count = 0;
//	anim.usedIDs["civilian"][2].npcID = "2";
//	anim.usedIDs["civilian"][3] = SpawnStruct();
//	anim.usedIDs["civilian"][3].count = 0;
//	anim.usedIDs["civilian"][3].npcID = "3";
//
//	anim.eventTypeMinWait = [];
//	anim.eventTypeMinWait["threat"] = [];
//	anim.eventTypeMinWait["response"] = [];
//	anim.eventTypeMinWait["reaction"] = [];
//	anim.eventTypeMinWait["order"] = [];
//	anim.eventTypeMinWait["inform"] = [];
//	anim.eventTypeMinWait["custom"] = [];
//	anim.eventTypeMinWait["direction"] = [];
//
//// If you want to tweak how often battlechatter messages happen,
//// this is place to do it.
//// A priority of 1 will force an event to be added to the queue, and 
//// will make it override pre-existing events of the same type.
//
//	// times are in milliseconds
//	/*
//	anim.eventActionMinWait["threat"]["self"] 		= 12000;
//	anim.eventActionMinWait["threat"]["squad"] 		= 6000;
//	anim.eventActionMinWait["response"]["self"] 	= 1000;
//	anim.eventActionMinWait["response"]["squad"] 	= 1000;
//	anim.eventActionMinWait["reaction"]["self"] 	= 1000;
//	anim.eventActionMinWait["reaction"]["squad"] 	= 1000;
//	anim.eventActionMinWait["order"]["self"] 		= 16000;
//	anim.eventActionMinWait["order"]["squad"] 		= 12000;
//	anim.eventActionMinWait["inform"]["self"] 		= 12000;
//	anim.eventActionMinWait["inform"]["squad"] 		= 6000;
//	anim.eventActionMinWait["custom"]["self"] 		= 0;
//	anim.eventActionMinWait["custom"]["squad"] 		= 0;
//	*/
//
//	//these numbers should not share factors since that will make dialog overlap more often
//
//	scale = 2;
//
//	if ( IsDefined( level._stealth ) )
//	{
//		anim.eventActionMinWait["threat"]["self"] 	= scale * 20000;
//		anim.eventActionMinWait["threat"]["squad"] 	= scale * 10000;
//	}
//	else
//	{
//		anim.eventActionMinWait["threat"]["self"] 		= scale * 9628;
//		anim.eventActionMinWait["threat"]["squad"] 		= scale * 4214;
//	}
//
//	anim.eventActionMinWait["response"]["self"] 	= scale * 7234;
//	anim.eventActionMinWait["response"]["squad"] 	= scale * 5366;
//
//	anim.eventActionMinWait["reaction"]["self"] 	= scale * 9855;
//	anim.eventActionMinWait["reaction"]["squad"] 	= scale * 4111;
//
//	anim.eventActionMinWait["order"]["self"] 		= scale * 14222;
//	anim.eventActionMinWait["order"]["squad"] 		= scale * 6333;
//
//	anim.eventActionMinWait["inform"]["self"] 		= scale * 8343;
//	anim.eventActionMinWait["inform"]["squad"] 		= scale * 4846;
//
//	anim.eventActionMinWait["custom"]["self"] 		= scale * 0;
//	anim.eventActionMinWait["custom"]["squad"] 		= scale * 5431;
//	
///*
//	anim.eventTypeMinWait["threat"]["emplacement"]	= 8000;		
//	anim.eventTypeMinWait["threat"]["infantry"] 	= 8000;		
//	anim.eventTypeMinWait["threat"]["vehicle"]		= 8000;		
//	anim.eventTypeMinWait["response"]["killfirm"] 	= 8000;		
//	anim.eventTypeMinWait["response"]["ack"]   		= 8000;		
//	anim.eventTypeMinWait["reaction"]["casualty"] 	= 8000;		
//	anim.eventTypeMinWait["reaction"]["taunt"] 		= 8000;		
//	anim.eventTypeMinWait["order"]["cover"] 		= 8000;		
//	anim.eventTypeMinWait["order"]["action"] 		= 8000;		
//	anim.eventTypeMinWait["order"]["move"] 			= 8000;		
//	anim.eventTypeMinWait["order"]["displace"] 		= 8000;		
//	anim.eventTypeMinWait["inform"]["killfirm"] 	= 8000;		
//	anim.eventTypeMinWait["inform"]["attack"] 		= 8000;		
//	anim.eventTypeMinWait["inform"]["incoming"] 	= 8000;		
//	anim.eventTypeMinWait["inform"]["reloading"] 	= 8000;		
//	anim.eventTypeMinWait["inform"]["suppressed"] 	= 8000;		
//	anim.eventTypeMinWait["custom"]["generic"]		= 8000;		
//*/
//	
//	anim.eventPriority["threat"]["bansai"] 			=1.0;
//	anim.eventPriority["custom"]["generic"]			= 1.0;
//	anim.eventPriority["inform"]["attack"] 			= 1.0;
//	anim.eventPriority["response"]["ack"] 			= 0.9;
//	anim.eventPriority["inform"]["incoming"] 		= 0.8;
//	anim.eventPriority["response"]["killfirm"] 		= 0.8;
//	anim.eventPriority["reaction"]["taunt"] 		= 0.8;
//	anim.eventPriority["order"]["cover"] 			= 0.7;
//	anim.eventPriority["order"]["move"] 			= 0.7;
//	anim.eventPriority["order"]["action"] 			= 0.7;
//	anim.eventPriority["order"]["displace"] 		= 0.7;
//	anim.eventPriority["threat"]["vehicle"] 		= 0.7;
//	anim.eventPriority["threat"]["emplacement"]		= 0.6;
//	anim.eventPriority["inform"]["killfirm"] 		= 0.6;
//	anim.eventPriority["reaction"]["casualty"] 		= 0.5;
//	anim.eventPriority["inform"]["reloading"] 		= 0.2;
//	anim.eventPriority["inform"]["suppressed"] 		= 0.2;
//	anim.eventPriority["threat"]["infantry"] 		= 0.1;
//
//	scale = 1;
//
//	anim.eventDuration["threat"]["emplacement"]		= scale * 2000;
//	anim.eventDuration["threat"]["infantry"] 		= scale * 2000;
//	anim.eventDuration["threat"]["vehicle"]			= scale * 2000;
//	anim.eventDuration["response"]["killfirm"] 		= scale * 2000;
//	anim.eventDuration["response"]["ack"]   		= scale * 2000;
//	anim.eventDuration["reaction"]["casualty"] 		= scale * 2000;
//	anim.eventDuration["reaction"]["taunt"] 		= scale * 2000;
//	anim.eventDuration["order"]["cover"] 			= scale * 2000;
//	anim.eventDuration["order"]["action"] 			= scale * 2000;
//	anim.eventDuration["order"]["move"] 			= scale * 2000;
//	anim.eventDuration["order"]["displace"] 		= scale * 2000;
//	anim.eventDuration["inform"]["killfirm"] 		= scale * 2000;
//	anim.eventDuration["inform"]["attack"] 			= scale * 2000;
//	anim.eventDuration["inform"]["incoming"] 		= scale * 2000;
//	anim.eventDuration["inform"]["reloading"] 		= scale * 2000;
//	anim.eventDuration["inform"]["suppressed"] 		= scale * 2000;
//	anim.eventDuration["custom"]["generic"]			= scale * 2000;
//
//	anim.minTalkTime = 3000;
//
//	anim.chatCount = 0;
//	
//	anim.moveOrigin = Spawn ("script_origin", (0, 0, 0));
//
//	anim.areas = getentarray ("trigger_location", "targetname");
//	anim.locations = getentarray ("trigger_location", "targetname");
//	anim.landmarks = getentarray ("trigger_landmark", "targetname");
//	
//	anim.squadCreateFuncs[anim.squadCreateFuncs.size] = ::init_squadBattleChatter;
//	anim.squadCreateStrings[anim.squadCreateStrings.size] = "::init_squadBattleChatter";
//
//	if (!IsDefined(level.battlechatter))
//	{
//		level.battlechatter = [];
//		level.battlechatter["allies"] = true;
//		level.battlechatter["axis"] = true;
//		level.battlechatter["neutral"] = true;
//	}
//	
//	for (index = 0; index < anim.squadIndex.size; index++)
//	{
//		if (IsDefined(anim.squadIndex[index].chatInitialized) && anim.squadIndex[index].chatInitialized )
//		{
//			continue;
//		}
//
//		anim.squadIndex[index] init_squadBattleChatter();
//	}
//
//	level notify ("battlechatter initialized");
//	anim notify ("battlechatter initialized");
//
//	initHistory();
//
//	thread bcmain();
}

// CODER_MOD
player_init()
{
	//self.chatInitialized = false;
}

shutdown_battleChatter()
{
	anim.countryIDs = undefined;
	anim.eventTypeMinWait = undefined;
	anim.eventActionMinWait = undefined;	
	anim.eventTypeMinWait = undefined;	
	anim.eventPriority = undefined;
	anim.eventDuration = undefined;

	anim.chatCount = undefined;
	
	anim.moveOrigin = undefined;

	anim.areas = undefined;
	anim.locations = undefined;
	anim.landmarks = undefined;

	anim.usedIDs = undefined;

	anim.chatInitialized = false;
// CODER_MOD
//	anim.player.chatInitialized = false;

	level.battlechatter = undefined;

	for (i = 0; i < anim.squadCreateFuncs.size; i++)
	{
		if (anim.squadCreateStrings[i] != "::init_squadBattleChatter")
		{
			continue;
		}

		if (i != (anim.squadCreateFuncs.size - 1))
		{
			anim.squadCreateFuncs[i] = anim.squadCreateFuncs[anim.squadCreateFuncs.size - 1];
			anim.squadCreateStrings[i] = anim.squadCreateStrings[anim.squadCreateStrings.size - 1];
		}

		anim.squadCreateFuncs[anim.squadCreateFuncs.size - 1] = undefined;
		anim.squadCreateStrings[anim.squadCreateStrings.size - 1] = undefined;
	}

	level notify ("battlechatter disabled");
	anim notify ("battlechatter disabled");
}

// initializes battlechatter data that resides in the squad manager
// this is done to keep the squad management system free from clutter

resetSayTime(name)
{
	self.nextSayTimes[name] = GetTime() + 50; //RandomFloatRange(0,anim.eventActionMinWait[name]["squad"]); 
}

resetSayTimes()
{
	self.nextSayTime = GetTime();
	resetSayTime("threat");
	resetSayTime("order");
	resetSayTime("reaction");
	resetSayTime("response");
	resetSayTime("inform");
	resetSayTime("custom");
}

init_squadBattleChatter()
{
	/*
	squad = self;

	// tweakables
	squad.maxSpeakers = 2;

	// non tweakables
	squad resetSayTimes();
	
	squad.nextTypeSayTimes["threat"] = [];
	squad.nextTypeSayTimes["order"] = [];
	squad.nextTypeSayTimes["reaction"] = [];
	squad.nextTypeSayTimes["response"] = [];
	squad.nextTypeSayTimes["inform"] = [];
	squad.nextTypeSayTimes["custom"] = [];

	squad.lastDirection = "";
	
	squad.memberAddFuncs[squad.memberAddFuncs.size] = ::addToSystem;
	squad.memberAddStrings[squad.memberAddStrings.size] = "::addToSystem";
	squad.memberRemoveFuncs[squad.memberRemoveFuncs.size] = ::removeFromSystem;
	squad.memberRemoveStrings[squad.memberRemoveStrings.size] = "::removeFromSystem";
	squad.squadUpdateFuncs[squad.squadUpdateFuncs.size] = ::initContact;
	squad.squadUpdateStrings[squad.squadUpdateStrings.size] = "::initContact";

	for (i = 0; i < anim.squadIndex.size; i++)
	{
		squad thread initContact (anim.squadIndex[i].squadName);
	}

//	squad thread randomThreatWaiter();
	squad thread squadThreatWaiter();
	squad thread squadOfficerWaiter();
	squad.chatInitialized = true;
	
	squad notify ("squad chat initialized");
	*/
}

// initializes battlechatter data that resides in the squad manager
// this is done to keep the squad management system free from clutter
shutdown_squadBattleChatter()
{
	squad = self;

	// tweakables
	squad.maxSpeakers = undefined;

	// non tweakables
	squad.nextSayTime = undefined;
	squad.nextSayTimes = undefined;
	
	squad.nextTypeSayTimes = undefined;

	squad.isMemberSaying = undefined;
	
	for (i = 0; i < squad.memberAddFuncs.size; i++)
	{
		if (squad.memberAddStrings[i] != "::addToSystem")
		{
			continue;
		}
		
		if (i != (squad.memberAddFuncs.size - 1))
		{
			squad.memberAddFuncs[i] = squad.memberAddFuncs[squad.memberAddFuncs.size - 1];
			squad.memberAddStrings[i] = squad.memberAddStrings[squad.memberAddStrings.size - 1];
		}
			
		squad.memberAddFuncs[squad.memberAddFuncs.size - 1] = undefined;
		squad.memberAddStrings[squad.memberAddStrings.size - 1] = undefined;
	}

	for (i = 0; i < squad.memberRemoveFuncs.size; i++)
	{
		if (squad.memberRemoveStrings[i] != "::removeFromSystem" )
		{
			continue;
		}
		
		if (i != (squad.memberRemoveFuncs.size - 1))
		{
			squad.memberRemoveFuncs[i] = squad.memberRemoveFuncs[squad.memberRemoveFuncs.size - 1];
			squad.memberRemoveStrings[i] = squad.memberRemoveStrings[squad.memberRemoveStrings.size - 1];
		}
			
		squad.memberRemoveFuncs[squad.memberRemoveFuncs.size - 1] = undefined;
		squad.memberRemoveStrings[squad.memberRemoveStrings.size - 1] = undefined;
	}
	
	for (i = 0; i < squad.squadUpdateFuncs.size; i++)
	{
		if (squad.squadUpdateStrings[i] != "::initContact")
		{
			continue;
		}
		
		if (i != (squad.squadUpdateFuncs.size - 1))
		{
			squad.squadUpdateFuncs[i] = squad.squadUpdateFuncs[squad.squadUpdateFuncs.size - 1];
			squad.squadUpdateStrings[i] = squad.squadUpdateStrings[squad.squadUpdateStrings.size - 1];
		}
			
		squad.squadUpdateFuncs[squad.squadUpdateFuncs.size - 1] = undefined;
		squad.squadUpdateStrings[squad.squadUpdateStrings.size - 1] = undefined;
	}
	
	for (i = 0; i < anim.squadIndex.size; i++)
	{
		squad shutdownContact (anim.squadIndex[i].squadName);
	}

	squad.chatInitialized = false;
}

initContact (squadName)
{
	if (!IsDefined (self.squadList[squadName].calledOut))
	{
		self.squadList[squadName].calledOut = false;
	}

	if (!IsDefined (self.squadList[squadName].firstContact))
	{
		self.squadList[squadName].firstContact = 2000000000;
	}

	if (!IsDefined (self.squadList[squadName].lastContact))
	{
		self.squadList[squadName].lastContact = 0;
	}
}

shutdownContact (squadName)
{
	self.squadList[squadName].calledOut = undefined;
	self.squadList[squadName].firstContact = undefined;
	self.squadList[squadName].lastContact = undefined;
}

bcsEnabled()
{
	return anim.chatInitialized;
}

bcsDebugWaiter()
{
/*
	lastState = GetDvar ("bcs_enable");

	while (1)
	{
		state = GetDvar ("bcs_enable");
		
		if (state != lastState)
		{
			switch (state)
			{
				case "on":
					if (!anim.chatInitialized)
					{
						enableBattleChatter();
					}
					break;
				case "off":
					if (anim.chatInitialized)
					{
						disableBattleChatter();
					}
					break;
			}

			lastState = state;
		}

		wait (1.0);
	}
*/
}

enableBattleChatter()
{
/*
	init_battleChatter();

	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread animscripts\battleChatter_ai::addToSystem();
	}
	
	ai = GetAIArray();
	for (i = 0; i < ai.size; i++)
	{
		ai[i] addToSystem();
	}
*/
}

disableBattleChatter()
{
/*
	shutdown_battleChatter();

	ai = GetAIArray();
	for (i = 0; i < ai.size; i++)
	{
		if (IsDefined (ai[i].squad) && ai[i].squad.chatInitialized)
		{
			ai[i].squad shutdown_squadBattleChatter();
		}

		ai[i] removeFromSystem();
	}
*/
}

/****************************************************************************
 processing
*****************************************************************************/

playBattleChatter()
{
}


/****************************************************************************
 utility
*****************************************************************************/

samePhrase(a,b)
{
	assert(IsDefined(a));
	assert(IsDefined(b));

	if(a.soundAliases.size != b.soundAliases.size)
	{
		return false;
	}

	for (i = 0; i < a.soundAliases.size; i++)
	{
		if(a.soundAliases[i] != b.soundAliases[i])
		{
			return false;
		}
	}

	return true;
}

initHistory()
{
	level.bcHistoryCount = 100;
	level.bcHistoryPhrases = [];
	level.bcHistoryTimes = [];
	level.bcHistoryIndex = 0;
}

addPhraseToHistory(phrase)
{
	assert(IsDefined(level.bcHistoryIndex));
	i = level.bcHistoryIndex;
	assert(IsDefined(i));
	level.bcHistoryPhrases[i] = phrase;
	level.bcHistoryTimes[i] = GetTime();
	assert(IsDefined(i));
	level.bcHistoryIndex = (i+1)%level.bcHistoryCount;
}

isDupePhrase(phrase, threshold)
{
	for (i=0; i<level.bcHistoryCount; i++)
	{
		if (	IsDefined(level.bcHistoryPhrases[i]) 
				&& samePhrase(level.bcHistoryPhrases[i], phrase) 
				&& GetTime()-level.bcHistoryTimes[i] < threshold)
		{
			if (GetDvar( #"debug_bclotsoprint") == "on")
			{
				println("BC DEBUG history skip time "+GetTime()+" "+level.bcHistoryTimes[i]+" "+(GetTime()-level.bcHistoryTimes[i]));
			}

			return true;
		}
	}

	return false;
}

delayed_notify(n, time, end)
{
	self endon(end);

	wait(time);

	if(IsDefined(self))
	{
		self notify(n);
	}
}

nearestPlayer()
{
	players = GetPlayers();
	if(players.size == 0)
	{
		return undefined;
	}

	distance = DistanceSquared(players[0].origin, self.origin);
	player = players[0];

	for(i=1; i<players.size; i++)
	{
		d = DistanceSquared(players[i].origin, self.origin);
		if(d < distance)
		{
			distance = d;
			player = players[i];
		}
	}

	return player;
}


typeLimited (strAction, strType)
{
	if (!IsDefined (anim.eventTypeMinWait[strAction][strType]))
	{
		//if (GetDvar( #"debug_bclotsoprint") == "on")
		//println("BC DEBUG typeLimited says no eventTypeMinWait");
		return (false);
	}
		
	if (!IsDefined (self.squad.nextTypeSayTimes[strAction][strType]))
	{
		//if (GetDvar( #"debug_bclotsoprint") == "on")
		//println("BC DEBUG typeLimited says no nextTypeSayTimes");
		return (false);
	}

	if (GetTime() > self.squad.nextTypeSayTimes[strAction][strType])
	{
		//if (GetDvar( #"debug_bclotsoprint") == "on")
		//println("BC DEBUG typeLimited says GetTime() > nextTypeSayTimes");
		return (false);
	}
		
	return (true);
}

doTypeLimit(strAction, strType)
{
	if (!IsDefined (anim.eventTypeMinWait[strAction][strType]))
	{
		return;
	}
	
	self.squad.nextTypeSayTimes[strAction][strType] = GetTime() + anim.eventTypeMinWait[strAction][strType];	
}

bcIsSniper()
{
	if ( IsPlayer( self ) )
	{
		return (false);
	}

	//if (self isExposed())
	//	return (false);

	return animscripts\combat_utility::isSniperRifle( self.weapon );
}

isExposed()
{
	/*
	if (IsDefined (self getLocation()))
	{
		return (false);
	}

	node = self bcGetClaimedNode();
	
	if (!IsDefined (node))
	{
		return (true);
	}

	if ((node.type[0] == "C") &&
		(node.type[1] == "o") &&
		(node.type[2] == "v"))
	{
		return (false);
	}
	
	return (true);
	*/
}

isClaimedNodeCover()
{
	node = self bcGetClaimedNode();
	
	if (!IsDefined (node))
	{
		return (false);
	}

	if ((node.type[0] == "C") &&
		(node.type[1] == "o") &&
		(node.type[2] == "v"))
	{
		return (true);
	}
	
	return (false);
}

isNodeCover()
{
	node = self.node;
	
	if (!IsDefined (node))
	{
		return (false);
	}

	if ((node.type[0] == "C") &&
		(node.type[1] == "o") &&
		(node.type[2] == "v"))
	{
		return (true);
	}
	
	return (false);
}

isOfficer()
{
	fullRank = self getRank();
	
	if (fullRank == "sergeant" || fullRank == "lieutenant" || fullRank == "captain" || fullRank == "sergeant")
	{
		return (true);
	}
		
	return (false);
}

bcGetClaimedNode()
{
	if ( IsPlayer( self ) )
	{
		node =self.node;
	}
	else
	{
		node = self GetClaimedNode();
	}
}

getName()
{
	name = undefined;

	if ( self.team == "axis" )
	{
		name = self.name;
	}
	else if ( self.team == "allies" )
	{
		name = self.name;
	}

	if(!IsDefined(name) && IsDefined(self.script_friendname))
	{
		name = self.script_friendname;
	}
	
	if (!IsDefined (name) || self.voice == "british" )
	{
		return ( undefined );
	}

	tokens = strtok( name, " " );

	if ( tokens.size == 1 )
	{
		return tokens[0];
	}

	if (tokens.size >= 2)
	{
		return tokens[1];
	}

	return undefined;
}

getRank()
{
	return self.airank;
}

getClosestSpeaker (strAction, strType, officerOnly)
{
	speakers = self getSpeakers (strAction, strType, officerOnly);
	
	speaker = getClosest(self.origin, speakers);

	return (speaker);
}

getSpeakers (strAction, strType, officersOnly)
{
	speakers = [];

	soldiers = GetAIArray( self.team );

	if (IsDefined (officersOnly) && officersOnly)
	{
		officers = [];
		for (i = 0; i < soldiers.size; i++)
		{
			if (soldiers[i] isOfficer())
			{
				officers[officers.size] = soldiers[i];
			}
		}

		soldiers = officers;
	}

	for (i = 0; i < soldiers.size; i++)
	{
		if (soldiers[i] == self)
		{
			continue;
		}

		if (!soldiers[i] bcCanSay(strAction, strType))
		{
			continue;
		}

		speakers[speakers.size] = soldiers[i];
	}

	return (speakers);
}

getArea()
{
	areas = anim.areas;
	for (i = 0; i < areas.size; i++)
	{
		if (self istouching (areas[i]) && IsDefined (areas[i].script_area))
		{
			return (areas[i]);
		}
	}

	return (undefined);
}

getLocation()
{
	locations = anim.locations;
	for (i = 0; i < locations.size; i++)
	{
		if (self istouching (locations[i]) && IsDefined (locations[i].script_location))
		{
			return (locations[i]);
		}
	}

	return (undefined);
}

getLandmark()
{
	landmarks = anim.landmarks;
	for (i = 0; i < landmarks.size; i++)
	{
		if (self istouching (landmarks[i]) && IsDefined (landmarks[i].script_landmark))
		{
			return (landmarks[i]);
		}
	}

	return (undefined);
}

getDirectionCompass (vOrigin, vPoint)
{
	angles = VectorToAngles (vPoint - vOrigin);
	angle = angles[1];
	
	northYaw = getnorthyaw();
	angle -= northYaw;

	if (angle < 0)
	{
		angle += 360;
	}
	else if (angle > 360)
	{
		angle -= 360;
	}

	if (angle < 22.5 || angle > 337.5)
	{
		direction = "north";
	}
	else if (angle < 67.5)
	{
		direction = "northwest";
	}
	else if (angle < 112.5)
	{
		direction = "west";
	}
	else if (angle < 157.5)
	{
		direction = "southwest";
	}
	else if (angle < 202.5)
	{
		direction = "south";
	}
	else if (angle < 247.5)
	{
		direction = "southeast";
	}
	else if (angle < 292.5)
	{
		direction = "east";
	}
	else if (angle < 337.5)
	{
		direction = "northeast";
	}
	else
	{
		direction = "impossible";
	}

	return (direction);
}

getDirectionReferenceSide (vOrigin, vPoint, vReference)
{
	anglesToReference = VectorToAngles (vReference - vOrigin);
	anglesToPoint = VectorToAngles (vPoint - vOrigin);

	angle = anglesToReference[1] - anglesToPoint[1];
	angle += 360;
	angle = int (angle) % 360;

	if (angle > 180)
	{
		angle -= 360;
	}

	if (angle > 2 && angle < 45)
	{
		side = "right";
	}
	else if (angle < -2 && angle > -45)
	{
		side = "left";
	}
	else
	{
		if (distance (vOrigin, vPoint) < distance (vOrigin, vReference))
		{
			side = "front";
		}
		else
		{
			side = "rear"; 
		}
	}
	
	return (side);		
}

getDirectionFacingFlank (vOrigin, vPoint, vFacing)
{
	anglesToFacing = VectorToAngles (vFacing);
	anglesToPoint = VectorToAngles (vPoint - vOrigin);
	
	angle = anglesToFacing[1] - anglesToPoint[1];
	angle += 360;
	angle = int (angle) % 360;
	
	if (angle > 315 || angle < 45)
	{
		direction = "front";
	}
	else if (angle < 135)
	{
		direction = "right";
	}
	else if (angle < 225)
	{
		direction = "rear";
	}
	else
	{
		direction = "left";
	}

	return (direction);
}

getVectorRightAngle (vDir)
{
	return (vDir[1], 0 - vDir[0], vDir[2]);
}

getVectorArrayAverage (avAngles)
{
	vDominantDir = (0,0,0);
	
	for (i = 0; i < avAngles.size; i++)
	{
		vDominantDir += avAngles[i];
	}
	
	return (vDominantDir[0] / avAngles.size, vDominantDir[1] / avAngles.size, vDominantDir[2] / avAngles.size);
}

addAlias(name)
{
	if(soundExists(name))
	{
		self.soundAliases[self.soundAliases.size] = name;
		return true;
	}
	else
	{
		println("ERROR BC cannot find alias "+name);
		return false;
	}
}

createChatPhrase()
{
	chatPhrase = SpawnStruct();
	chatPhrase.owner = self;
	chatPhrase.soundAliases = [];
	chatPhrase.master = false;
	
	return chatPhrase;
}

canSeePoint(origin)
{
    forward = AnglesToForward(self.angles);
    return (vectordot(forward, origin - self.origin) > 0.766); // 80 fov	
}

pointInFov(origin)
{
    forward = AnglesToForward(self.angles);
    return (vectordot(forward, origin - self.origin) > 0.766); // 80 fov	
}


/****************************************************************************
 debugging functions
*****************************************************************************/

resetNextSayTimes( team, action )
{
	/*
	soldiers = GetAIArray( team );

	for ( index = 0; index < soldiers.size; index++ )
	{
		soldier = soldiers[index];

		if ( !IsAlive( soldier ) )
		{
			continue;
		}

		if ( !IsDefined( soldier.battlechatter ) )
		{
			continue;
		}

		soldier.nextSayTimes[action] = GetTime() + 350;
		soldier.squad.nextSayTimes[action] = GetTime() + 350;
	}
	*/
}


































// new BC

bcGetName()
{
	name = undefined;

	if ( self.team == "axis" )
	{
		name = self.name;
	}
	else if ( self.team == "allies" )
	{
		name = self.name;
	}

	if(!IsDefined(name) && IsDefined(self.script_friendname))
	{
		name = self.script_friendname;
	}

	if (!IsDefined (name) || self.voice == "british" )
	{
		return ( undefined );
	}

	tokens = strtok( name, " " );

	if ( tokens.size == 1 )
	{
		return tokens[0];
	}

	if (tokens.size >= 2)
	{
		return tokens[1];
	}

	return undefined;
}

bcCanSay (eventAction, eventType, priority, modifier)
{
	assert(IsDefined(eventAction));
	assert(IsDefined(eventType));

	isGrenade = false;

	if( IsDefined(eventAction) && eventAction == "inform" 
		&& IsDefined(eventType) && eventType == "incoming"
		&& IsDefined(modifier) && modifier == "grenade"
		)
	{
		//if (GetDvar( #"debug_bclotsoprint") == "on")
		//println("BC DEBUG GOT A GRENADE! "+self.bcname);
		isGrenade = true;
	}

	if( IsDefined(eventAction) && eventAction == "inform" 
		&& IsDefined(eventType) && eventType == "attack"
		&& IsDefined(modifier) && modifier == "grenade"
		)
	{
		//if (GetDvar( #"debug_bclotsoprint") == "on")
		//println("BC DEBUG GOT A GRENADE! "+self.bcname);
		isGrenade = true;
	}

	if( IsDefined(eventAction) && eventAction == "threat" 
		&& IsDefined(eventType) && eventType == "bansai"
		) //treat bansai as grenades due to gameplay importance
	{
		//if (GetDvar( #"debug_bclotsoprint") == "on")
		//println("BC DEBUG GOT A GRENADE! "+self.bcname);
		isGrenade = true;
	}

	if (IsPlayer(self))
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because i'm a player "+self.bcname);
		}

		return false;
	}

	//can't say if saying something else, this is set by face::SaySpecificDialogue
	if(IsDefined(self.isTalking) && self.isTalking)
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because i'm talking "+self.bcname);
		}

		return false;
	}

	if(IsDefined(self.isSpeaking) && self.isSpeaking)
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because i'm speaking "+self.bcname);
		}

		return false;
	}

	// SRS 8/7/2008: added some error checking
	if( !IsDefined( self.nextSayTimes ) )
	{
		msg = "AI at origin " + self.origin + ", classname " + self.classname;
		msg += ", doesn't have the self.nextSayTimes array set up, which the battlechatter system needs! ";
		msg += "This likely means that animscripts\battlechatter_ai::removeFromSystem() was run ";
		msg += "on this guy, but he hasn't been deleted. ";
		msg += "Did you accidentally notify \'death\' without deleting the AI?";

		ASSERTMSG( msg );
		
		return false;
	}

	// our battlechatter is disabled	
	if (!IsDefined( self.battlechatter ) || !self.battlechatter)
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because of self.battlechatter "+self.bcname);
		}

		return false;
	}
	

	//dont start new BC if important people are talking
	if(!isGrenade && IsDefined(level.NumberOfImportantPeopleTalking) && level.NumberOfImportantPeopleTalking > 0) 
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because important people are talking "+level.NumberOfImportantPeopleTalking+" "+self.bcname);
		}

		return false;
	}

	timeout = 3000;

	if(self.team == "axis")
	{
		timeout = 1800;
	}
	else if(self.team == "allies")
	{
		timeout = 1000;
	}

	if(IsDefined(level.ImportantPeopleTalkingTime) && (GetTime()-level.ImportantPeopleTalkingTime)<timeout)
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because important people were talking "+level.NumberOfImportantPeopleTalking+" "+self.bcname +" "+(GetTime()-level.ImportantPeopleTalkingTime));
		}

		return false;
	}

	/*
	if(IsDefined(self.lastSayTime) && self.lastSayTime + anim.minTalkTime < GetTime())
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
			println("BC DEBUG cannot say because i said something recently "+self.bcname);
		return false;
	}
	*/

	np = nearestPlayer();

	if(!IsDefined(np))
	{
		println("BC DEBUG cannot say because there are no people");
		return false; //no player, no BC
	}

	if(np.team == self.team)
	{
		cullDist = 2000;
	}
	else
	{
		cullDist = 3000;
	}

	if(DistanceSquared(np.origin, self.origin) > cullDist*cullDist)
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say, too far from player "+self.bcname);
		}

		return false; //too far for player to hear
	}

		
	//if (IsDefined (priority) && priority >= 1)
	//	return (true);

	// we're not allowed to call out a threat now, and won't be able to before it expires
	if (!isGrenade && GetTime() < self.nextSayTimes[eventAction])
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because of self wait "+self.bcname);
		}

		return (false);
	}

	// the squad is not allowed to call out a threat yet and won't be able to before it expires
	if (!isGrenade && GetTime() < self.squad.nextSayTimes[eventAction])
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because of squad wait "+self.bcname+ " "+self.squad.squadName);
		}

		return (false);
	}

	if (!isGrenade && IsDefined (eventType) && typeLimited (eventAction, eventType))
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because of typeLimit "+self.bcname);
		}

		return (false);
	}

	if(IsDefined (eventType) && !IsDefined(anim.eventPriority[eventAction][eventType]))
	{
		println("BC priority not set for eventType "+eventType+ " "+eventAction);
	}
	else if (!isGrenade && IsDefined (eventType) && anim.eventPriority[eventAction][eventType] < self.bcs_minPriority)
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG cannot say because of minPriority "+self.bcname);
		}

		return (false);
	}

	if (GetDvar( #"debug_bclotsoprint") == "on")
	{
		println("BC DEBUG can say because of self wait "+GetTime()+" "+anim.eventActionMinWait[eventAction]["self"]+" "+self.nextSayTimes[eventAction]+"  "+self.bcname);
		println("BC DEBUG can say because of squad wait "+GetTime()+" "+anim.eventActionMinWait[eventAction]["squad"]+" "+self.squad.nextSayTimes[eventAction]+"  "+self.bcname);
	}

	return (true);
}

bcPlayPhrase(eventAction, eventType, chatPhrase, decCallCount)
{
	if(!IsDefined(decCallCount))
	{
		decCallCount = false;
	}

	if (GetDvar( #"debug_bclotsoprint") == "on")
	{
		a = "";
		for (i = 0; i < chatPhrase.soundAliases.size; i++)
		{
			a += chatPhrase.soundAliases[i] + " ";
		}

		println("BC DEBUG saying "+a);
	}

	if(chatPhrase.soundAliases.size == 0)
	{
		println("BC ERROR tried to play empty phrase" + self.bcname);
		return;
	}

	if(isDupePhrase(chatPhrase, 10000))
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG skipping because of identical phrase "+self.bcname);
		}

		return;
	}

	addPhraseToHistory(chatPhrase);

	squad = self.squad;
	team = self.team;

	self.isSpeaking = true;

	//squad.isMemberSaying[eventAction] = true;
	//anim.isTeamSpeaking[team] = true;
	//anim.isTeamSaying[team][eventAction] = true;

	self.nextSayTimes[eventAction] = GetTime() + anim.eventActionMinWait[eventAction]["self"];
	squad.nextSayTimes[eventAction] = GetTime() + anim.eventActionMinWait[eventAction]["squad"];

	//println("started talking BC "+self.bcname);
	
	for (i = 0; i < chatPhrase.soundAliases.size; i++)
	{
		if(SoundExists(chatPhrase.soundAliases[i]))
		{
			self animscripts\face::PlayFaceThread(undefined, chatPhrase.soundAliases[i], .5, chatPhrase.soundAliases[i]);

			if(!IsDefined(self))
			{
				break;
			}
		}
		else
		{
			println("ERROR BC: needed alias does not exist:"+chatPhrase.soundAliases[i]);
			wait(1.0);
		}
	}

	if (GetDvar( #"debug_bclotsoprint") == "on")
	{
		a = "";
		for (i = 0; i < chatPhrase.soundAliases.size; i++)
		{
			a += chatPhrase.soundAliases[i] + " ";
		}

		println("BC DEBUG done saying "+a);
	}
	
	//println("done talking BC"+self.bcname);
	//squad.isMemberSaying[eventAction] = false;
	//anim.isTeamSpeaking[team] = false;	
	//anim.isTeamSaying[team][eventAction] = false;
	//anim.lastTeamSpeakTime[team] = GetTime();

	if(IsDefined(self))
	{
		self.isSpeaking = false;
		self doTypeLimit (eventAction, eventType);

		if(IsDefined(self.bcCalling) && IsDefined(self.bcCalling.bcCallCount) && decCallCount)
		{
			self.bcCalling.bcCallCount[self.team] -= 1;
		}
	}
}


filter(potentialThreats, isThreat)
{
	threats = [];
	for (i = 0; i < potentialThreats.size; i++)
	{
		players = GetPlayers();

		for(p=0; p<players.size; p++)
		{
			if (potentialThreats[i] [[isThreat]](players[p]))
			{
				threats[threats.size] = potentialThreats[i];
				break;
			}
		}
	}

	return threats;
}


getThreat(team, threats, threatDistance, callCount) 
{
	players = GetPlayers();

	closest = threatDistance;
	threat = undefined;

	for (i = 0; i < threats.size; i++)
	{
		if(!IsDefined(threats[i].bcCallCount))
		{
			threats[i].bcCallCount = [];
			threats[i].bcCallCount["axis"] = 0;
			threats[i].bcCallCount["allies"] = 0;
		}

		for(p=0; p<players.size; p++)
		{
			d = distance (threats[i].origin, players[p].origin);
			if (d < closest	&&  (callCount == 0 || threats[i].bcCallCount[team] < callCount)) 
			{
				closest = d;
				threat = threats[i];
				threat.bcthreatplayer = players[p];
			}
		}
	}

	return threat;
}

getClosestToPlayer(list) 
{
	players = GetPlayers();

	closest = 0;
	obj = undefined;

	for (i = 0; i < list.size; i++)
	{
		for(p=0; p<players.size; p++)
		{
			d = distance (list[i].origin, players[p].origin);
			if(d < 1)
			{
				continue;
			}

			if(closest == 0 || d < closest)
			{
				obj = list[i];
				closest = d;
			}
		}
	}

	return obj;
}

getNearestTalker(origin, threat, friends, action, type, modifier)
{
	talkers = [];
	for(i=0; i<friends.size; i++)
	{
		if(IsDefined(threat) && IsDefined(friends[i].bcCalling) && friends[i].bcCalling == threat)
		{
			continue; //we were the last person to call this, don't dupe
		}
		if(friends[i] bcCanSay(action, type, 1.0, modifier))
		{
			talkers[talkers.size] = friends[i];
		}
	}

	if(talkers.size == 0)
	{
		return undefined;
	}

	return getClosest(origin, talkers);
}

getAlias(action, type, modifier )
{
	alias = self.countryID + "_" + self.npcID;

	if(IsDefined(action))
	{
		alias += "_" + action; 
	}

	if(IsDefined(type))
	{
		alias += "_" + type;
	}

	if(IsDefined(modifier))
	{
		alias += "_" + modifier;
	}

	return alias;
}


getBCLocation()
{
	if(IsDefined(self.node) && IsDefined(self.node.script_area))
	{
		return self.node.script_area;
	}

	triggers = array_combine(anim.locations, anim.landmarks);

	for (i = 0; i < triggers.size; i++)
	{
		if (self istouching (triggers[i]))
		{
			if(IsDefined (triggers[i].script_area))
			{
				return triggers[i].script_area;
			}

			if(IsDefined (triggers[i].script_landmark))
			{
				return triggers[i].script_landmark;
			}

			if(IsDefined (triggers[i].script_location))
			{
				return triggers[i].script_location;
			}
		}
	}
	return undefined;
}

tryAddLocation(talker, object)
{
	a = object getBCLocation();
	if(IsDefined(a))
	{
		self addAlias(talker getAlias("landmark","near", a));
	}
}

tryThreat(friends, them, distance, count, filter, action, type, modifier, doLocation)
{
	threat = filter(them, filter);

	threat = getThreat("allies", threat, distance, count);

	if(!IsDefined(threat))
	{
		return false;
	}

	talker = getNearestTalker(threat.origin, threat, friends, action, type, modifier);

	if(!IsDefined(talker))
	{
		return false;
	}

	talker.bcCalling = threat;
	threat.bcCallCount[talker.team] += 1;
	threat.bcCalloutTime = GetTime();
	phrase = talker createChatPhrase();
	phrase.threatEnt = threat;
	phrase addAlias( talker getAlias(action, type, modifier) );

	if(doLocation && RandomFloat(1) < .5)
	{
		phrase tryAddLocation(talker, threat);
	}

	talker thread bcPlayPhrase(action, type, phrase, true);

	return true;
}


isGrenade(player)
{
	if(IsDefined(self.model) && self.model == "mortar_shell")
	{
		return false;
	}

	if(IsDefined(self.model) && self.model == "projectile_us_smoke_grenade")
	{
		return false;
	}

	if(player.team == "allies" && self.model == "") //friendlies don't call molotovs
	{
		return false;
	}

	if(IsDefined(self.bcCalloutTime) && (GetTime() - self.bcCalloutTime) > 1000) //don't call old grenades
	{
		return false;
	}

	if(distance(self.origin, player.origin) > 400)
	{
		return false;
	}

	return true;
}


isMg(player)
{
	if(IsDefined(self.bcCalloutTime))
	{
		if((GetTime() - self.bcCalloutTime) < 6000)
		{
			return false;
		}
		if((GetTime() - self.bcCalloutTime) > 30000)
		{
			self.bcCalloutTime = undefined;
			self.bcCallCount["axis"] = 0;
			self.bcCallCount["allies"] = 0;
		}
	}

	return self cansee(player) || distance(player.origin, self.origin) < 300;
}


isBanzai(player)
{
	playerIsTarget = false;
	if(IsDefined(self.banzai) && self.banzai)
	{
		if(IsDefined(self.enemy) && IsPlayer(self.enemy))
		{
			playerIsTarget = true;
		}

		if(IsDefined(self.target) && IsPlayer(self.target))
		{
			playerIsTarget = true;
		}

		if(IsDefined(self.favoriteenemy) && IsPlayer(self.favoriteenemy))
		{
			playerIsTarget = true;
		}

		if(!playerIsTarget)
		{
			return false;
		}

		if(!IsDefined(self.bcNoticeTime))
		{
			self.bcNoticeTime = GetTime();
		}

		if(GetTime() - self.bcNoticeTime < 1000) //don't call new ones
		{
			return false;
		}

		if(IsDefined(self.bcCalloutTime))
		{
			return (GetTime() - self.bcCalloutTime) < 4000; //don't call already called bansais
		}

		return true;
	}

	return false;
}

isInfantry(player)
{
	return self cansee(player) && distance(player.origin, self.origin) < 1000;
}

getAllTurrets(team)
{
	t = [];
	turrets = array_combine(getentarray("misc_mg42", "classname"), getentarray("misc_turret", "classname"));

	for(i=0; i<turrets.size; i++)
	{
		dude = turrets[i] getturretowner();
		if(IsDefined(dude) && dude.team == team)
		{
			t[t.size] = dude;
		}
	}

	return t;
}


isSurpressed(player)
{
	valid = false;

	if(IsDefined(self.suppressed) && self.suppressed)
	{
		if(!IsDefined(self.bcSurpressedTime))
		{
			valid = true;
		}
		else 
		{
			valid = GetTime() - self.bcSurpressedTime > 3000;
		}
	}

	if(valid)
	{
		valid = self bcCanSay("inform", "supressed", 1.0, "generic");
	}

	return valid;
}


trySurpressed(team)
{
	players = GetPlayers();

	sp = filter(team, ::isSurpressed);

	talker = getNearestTalker(players[0], undefined, sp, "inform", "supressed");

	if(!IsDefined(talker))
	{
		return false;
	}

	talker.bcSurpressedTime = GetTime();
	phrase = talker createChatPhrase();
	phrase addAlias( talker getAlias("inform", "supressed", 1.0, "generic") );
	talker thread bcPlayPhrase("inform", "supressed", phrase, false);

	return true;
}


findGuyToYellAt(team,notme)
{
	for(i=0; i<team.size; i++)
	{
		if(notme.npcID == team[i].npcID)
		{
			continue;
		}

		if(notme cansee(team[i]))
		{
			return team[i];
		}

		if(distance(notme.origin, team[i].origin) < 500)
		{
			return team[i];
		}
	}

	return undefined;
}

canSeeAny(team)
{
	for(i=0; i<team.size; i++)
	{
		if(IsDefined(team[i]) && team[i] cansee(self))
		{
			return true;
		}
	}

	return false;
}

doReload(otherteam,talker, yellat)
{
	phrase = talker createChatPhrase();
	if(IsDefined(yellat))
	{
		phrase addAlias( talker getAlias("name", yellat bcGetName()));
	}

	if(talker canSeeAny(otherteam))
	{
		phrase addAlias( talker getAlias("order", "action", "coverme") );
	}

	phrase addAlias( talker getAlias("inform", "reloading", "generic") );
	talker thread bcPlayPhrase("order", "action", phrase, false);

	if(!IsDefined(yellat) || !IsDefined(yellat.nextSayTimes) || !yellat bcCanSay("response", "ack", 1.0))
	{
		return;
	}

	phrase = yellat createChatPhrase();
	phrase addAlias( yellat getAlias("response", "ack", "covering"));
/*
	if(IsDefined(talker))
	{
		talker.bcReloadTime = undefined;
		phrase addAlias( yellat getAlias("name", talker bcGetName()));
		
	}
*/
	yellat thread bcPlayPhrase("response", "ack", phrase, false);
}

tryReload(team,otherteam)
{
	for(i=0; i<team.size; i++)
	{
		if(IsDefined(team[i].bcReloadTime) 
			&&(GetTime() - team[i].bcReloadTime ) < 2000
			&&team[i] bcCanSay("order", "action")
			)
		{
			thread doReload(otherteam,team[i],findGuyToYellAt(team, team[i]));
			return true;
		}
	}

	return false;
}


doOrder(talker, yellat, type, modifier)
{
	phrase = talker createChatPhrase();
	if(IsDefined(yellat) && RandomFloat(1) < .6)
	{
		phrase addAlias( talker getAlias("name", yellat bcGetName()));
	}

	phrase addAlias( talker getAlias("order", type, modifier) );
	talker thread bcPlayPhrase("order", type, phrase, false);

	if(!IsDefined(yellat) || !IsDefined(yellat.nextSayTimes) || !yellat bcCanSay("response", "ack", 1.0))
	{
		return;
	}

	if(!IsDefined(modifier) || modifier != "follow")
	{
		modifier = "yes";	
	}

	phrase = yellat createChatPhrase();
	phrase addAlias( yellat getAlias("response", "ack", modifier));
	yellat thread bcPlayPhrase("response", "ack", phrase, false);
}


tryOrder(team)
{
	for(i=0; i<team.size; i++)
	{
		if(IsDefined(team[i].bcOrderTime) 
			&&(GetTime() - team[i].bcOrderTime ) > 2000
			)
		{
			team[i].bcOrderTime = undefined;
			team[i].bcOrderType = undefined;
			team[i].bcOrderModifier = undefined;
			continue;
		}
		if(IsDefined(team[i].bcOrderTime) 
			&&(GetTime() - team[i].bcOrderTime ) < 2000
			&&team[i] bcCanSay("order", team[i].bcOrderType)
			)
		{
			thread doOrder(team[i],findGuyToYellAt(team, team[i]), team[i].bcOrderType, team[i].bcOrderModifier);
			return true;
		}
	}

	return false;
}


hasKill(player)
{
	return IsDefined(self.bcKillTime) && (GetTime() - self.bcKillTime) < 2000 && self bcCanSay("inform", "killfirm");
}


tryKill(team)
{
	dude = getClosestToPlayer(filter(team, ::hasKill));

	if(!IsDefined(dude))
	{
		return false;
	}

	modifier = "infantry";

	if(RandomFloat(1.0) < .35)
	{
		modifier = "generic";
	}

	phrase = dude createChatPhrase();
	phrase addAlias( dude getAlias("inform", "killfirm", modifier));
	dude thread bcPlayPhrase("inform", "killfirm", phrase, false);
	dude.bcKillTime = undefined;

	return true;
}

hasCasualty(player)
{
	return IsDefined(self.bcFriendDeathTime) && (GetTime() - self.bcFriendDeathTime) < 3000 && self bcCanSay("reaction", "casualty");
}


tryCasualty(team)
{
	dude = getClosestToPlayer(filter(team, ::hasCasualty));

	if(!IsDefined(dude))
	{
		return false;
	}

	modifier = "generic";

	phrase = dude createChatPhrase();
	phrase addAlias( dude getAlias("reaction", "casualty", modifier));
	dude thread bcPlayPhrase("reaction", "casualty", phrase, false);
	dude.bcFriendDeathTime = undefined;

	return true;
}


tryGrenade(player)
{
	return IsDefined(self.bcThrewGrenadeTime) && (GetTime() - self.bcThrewGrenadeTime) < 2000 && self bcCanSay("inform", "attack");
}


tryGrenadeInform(team)
{
	dude = getClosestToPlayer(filter(team, ::hasCasualty));

	if(!IsDefined(dude))
	{
		return false;
	}

	modifier = "grenade";

	phrase = dude createChatPhrase();
	phrase addAlias( dude getAlias("inform", "attack", modifier));
	dude thread bcPlayPhrase("inform", "attack", phrase, false);
	dude.bcThrewGrenadeTime = undefined;

	return true;
}



tryFireInform(team,others)
{
	if(!IsDefined(level.bcOnFireTime))
	{
		return false;
	}

	if((GetTime() - level.bcOnFireTime) >3000)
	{
		level.bcOnFireTime = undefined;
		level.bcOnFireOrg = undefined;
		return false;
	}

	if(IsDefined(level.bcOnFireLastSayTime) && (GetTime()-level.bcOnFireLastSayTime) < 10)
	{
		return false;
	}

	talker = getNearestTalker(level.bcOnFireOrg, undefined, team, "inform", "burning");

	if(!IsDefined(talker))
	{
		return false;
	}

	level.bcOnFireLastSayTime = GetTime();

	phrase = talker createChatPhrase();
	phrase addAlias( talker getAlias("inform", "burning"));

	level.bcOnFireTime = undefined;
	level.bcOnFireOrg = undefined;

	talker thread bcPlayPhrase("inform", "burning", phrase, false);

	return true;
}


bccycle(team,otherteam)
{
	if (!bcsEnabled())
	{
		return false;
	}

	//the sleeps are here to make sure we don't hog cpu

	if(tryThreat(GetAIArray (team), getentarray ("grenade", "classname"), 300, 1, ::isGrenade, "inform", "incoming", "grenade", true))
	{
		return true;
	}

	if(team == "allies" && tryThreat(GetAIArray (team), GetAIArray(otherteam), 1000, 3, ::isBanzai, "threat", "banzai", undefined, false))
	{
		return true;
	}

	wait(.01);

	if(team == "allies" && tryThreat(GetAIArray (team), getAllTurrets(otherteam), 3000, 1, ::isMg,  "threat", "mg", undefined, true))
	{
		return true;
	}

	if(tryOrder(GetAIArray(team)))
	{
		return true;
	}

	wait(.01);

	if(trySurpressed(GetAIArray(team)))
	{
		return true;
	}

	if(GetAIArray(otherteam).size > 1 && tryReload(GetAIArray(team),GetAIArray(otherteam)))
	{
		return true;
	}

	wait(.01);

	if(tryKill(GetAIArray(team)))
	{
		return true;
	}

	if(tryCasualty(GetAIArray(team)))
	{
		return true;
	}

	wait(.01);

	if(tryGrenadeInform(GetAIArray(team)))
	{
		return true;
	}

	wait(.01);

	//if(team == "allies" && tryFireInform(GetAIArray(team), GetAIArray(otherteam)))
	//	return true;

	us = GetAIArray(team);
	them = GetAIArray(otherteam);

	if(us.size + 4 < them.size && RandomFloat(1) < .3)
	{
		tryThreat(us, them, 2000, 1, ::isInfantry, "threat", "infantry", "multiple", false);
	}
	else
	{
		tryThreat(us, them, 2000, 1, ::isInfantry, "threat", "infantry", "generic", true);
	}

	return false;
}


bcthread(us,them,talkdelay, nontalkdelay)
{
	while(1)
	{
		wait(nontalkdelay);
		while(bccycle(us,them))
		{
			wait(RandomFloat(2*talkdelay));
		}
	}
}

bcmain()
{
	thread bcthread("axis", "allies", 2, 2);
	thread bcthread("allies", "axis", 1, .5);
}