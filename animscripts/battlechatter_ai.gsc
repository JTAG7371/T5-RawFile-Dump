/****************************************************************************
 
 battleChatter_ai.gsc
		
*****************************************************************************/

#include common_scripts\utility;
#include animscripts\utility;
//#include maps\_utility;
#include animscripts\battlechatter;

/****************************************************************************
 initialization
*****************************************************************************/

isHero()
{
	return	self.npcID == "bar" ||
			self.npcID == "lew";
}

addToSystem (squadName)
{
	/*
	self endon ("death");
	
	//prof_begin("addToSystem");

	if ( !bcsEnabled() )
	{
		return;
	}
	
	if ( self.chatInitialized )
	{
		return;
	}
	
	assert( IsDefined( self.squad ) );

	// initialize battlechatter data for this AI's squad if it hasn't been already
	if ( !IsDefined( self.squad.chatInitialized ) || !self.squad.chatInitialized )
	{
		self.squad init_squadBattleChatter();
	}
	
	self.enemyClass = "infantry";
	self.calledOut = [];

	if ( IsPlayer( self ) )
	{
		self.battleChatter = false;
		self.type = "human";
		return;
	}

	if ( self.isdog )
	{
		self.enemyClass = undefined;
		self.battlechatter = false;
		return;
	}

	self.countryID = anim.countryIDs[self.voice];
	
	if ( IsDefined( self.animType ) )
	{
		//friendname = tolower(self.script_friendname);
		if ( issubstr( self.animType, "barnes" ) )
		{
			self.npcID = "bar";
		}
		else if ( issubstr( self.animType, "lewis" ) )
		{
			self.npcID = "lew";
		}
		else if ( issubstr( self.animType, "hudson" ) )
		{
			self.npcID = "lew";
		}
		else
		{
			self setNPCID();
		}
	}
	else
	{
		self setNPCID();
	}

	self thread aiNameAndRankWaiter();
		
	self init_aiBattleChatter();	
	self thread aiThreadThreader();

	//prof_end("addToSystem");
	*/
}

// semi hackish way to make large numbers of ai spawning take less time
aiThreadThreader()
{
	self endon ( "death" );
	self endon ( "removed from battleChatter" );

	assert(IsDefined(self.isSpeaking));
	
	waitTime = 0.5;
	// readd individual ai threat waiter here if needed
	wait ( waitTime );
	self thread aiGrenadeDangerWaiter();
	self thread aiFollowOrderWaiter();
	
	if (self.team == "allies" )
	{
		wait ( waitTime );
		self thread aiFlankerWaiter();
		self thread aiDisplaceWaiter();
	}
	
	wait ( waitTime );
	self thread aiBattleChatterLoop();

//	if (issubstr(self.classname, "mgportable"))
//		self thread portableMG42Waiter();
}

setNPCID()
{
	//prof_begin("setNPCID");
	assert (!IsDefined( self.npcID ) );
	
	usedIDs = anim.usedIDs[self.voice];
	numIDs = usedIDs.size;
	
	startIndex = randomIntRange( 0, numIDs );
	
	lowestID = startIndex;
	for ( index = 0; index <= numIDs; index++ )
	{
		if ( usedIDs[(startIndex+index)%numIDs].count < usedIDs[lowestID].count )
		{
			lowestID = ( startIndex + index ) % numIDs;
		}
	}
	
	self thread npcIDTracker( lowestID );
	self.npcID = usedIDs[lowestID].npcID;
	//prof_end("setNPCID");
}


npcIDTracker( lowestID )
{
//	self endon ("removed from battleChatter");
	
	voice = self.voice;

	anim.usedIDs[voice][lowestID].count++;
	self waittill ( "death" );
	
	if ( !bcsEnabled() )
	{
		return;
	}
		
	anim.usedIDs[voice][lowestID].count--;
}


aiBattleChatterLoop()
{
	
}

aiNameAndRankWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	while (1)
	{	
		self.bcName = self animscripts\battlechatter::getName();
		self.bcRank = self animscripts\battlechatter::getRank();
		self waittill ("set name and rank");
	}
}

removeFromSystem (squadName)
{
	/*
	if (!IsAlive (self) && bcsEnabled() )
	{
		self aiDeathFriendly();
		self aiDeathEnemy();
	}

	if (IsDefined (self))
	{
		self.battleChatter = false;
		self.chatInitialized = false;
	}

	self notify ("removed from battleChatter");

	if (IsDefined (self))
	{
		if (GetDvar( #"debug_bclotsoprint") == "on")
		{
			println("BC DEBUG removing "+self.bcname);
		}

		self.chatQueue = undefined;
		self.nextSayTime = undefined;
		self.nextSayTimes = undefined;
		self.isSpeaking = undefined;
		self.enemyClass = undefined;
		self.calledOut = undefined;
		self.countryID = undefined;
		self.npcID = undefined;
	}
	*/
}

init_aiBattleChatter ()
{
	//prof_begin("init_aiBattleChatter");
	self.chatQueue = [];
	self.chatQueue["threat"] = SpawnStruct();
	self.chatQueue["threat"].expireTime = 0;
	self.chatQueue["threat"].priority = 0.0;
	self.chatQueue["response"] = SpawnStruct();
	self.chatQueue["response"].expireTime = 0;
	self.chatQueue["response"].priority = 0.0;
	self.chatQueue["reaction"] = SpawnStruct();
	self.chatQueue["reaction"].expireTime = 0;
	self.chatQueue["reaction"].priority = 0.0;
	self.chatQueue["inform"] = SpawnStruct();
	self.chatQueue["inform"].expireTime = 0;
	self.chatQueue["inform"].priority = 0.0;
	self.chatQueue["order"] = SpawnStruct();
	self.chatQueue["order"].expireTime = 0;
	self.chatQueue["order"].priority = 0.0;
	self.chatQueue["custom"] = SpawnStruct();
	self.chatQueue["custom"].expireTime = 0;
	self.chatQueue["custom"].priority = 0.0;

	self.nextSayTime = GetTime() + 50;
	self.nextSayTimes["threat"] = 0;
	self.nextSayTimes["reaction"] = 0;
	self.nextSayTimes["response"] = 0;
	self.nextSayTimes["inform"] = 0;
	self.nextSayTimes["order"] = 0;
	self.nextSayTimes["custom"] = 0;
	
	self.isSpeaking = false;
	self.bcs_minPriority = 0.0;

	if (IsDefined (self.script_battlechatter) && !self.script_battlechatter)
	{
		self.battleChatter = false;
	}
	else
	{
		self.battleChatter = level.battlechatter[self.team];
	}
	
	self.chatInitialized = true;
	//prof_end("init_aiBattleChatter");
}

//old crap

squadOfficerWaiter(){}
getThreats(potentialThreats){}
squadThreatWaiter(){}
flexibleThreatWaiter(){}
filterThreats(potentialThreats){}
randomThreatWaiter(){}
aiThreatWaiter(){}
aiGrenadeDangerWaiter(){}
aiFlankerWaiter(){}
aiFlankerOrderWaiter(){}
aiDisplaceWaiter(){}
portableMG42Waiter(){}
aiFollowOrderWaiter(){}
evaluateSuppressionEvent(){}
addThreatEvent( a,b,c ) {}
endCustomEvent( x ){}
addGenericAliasEx(a,b,c){}


aiDeathFriendly ()
{
	attacker = self.attacker;
	// reaction event
	if (IsDefined (self))
	{
		for (i = 0; i < self.squad.members.size; i++)
		{
			// dead guy vs. member
			// need origin, name, etc... these may not be available	
			
			// this should not be needed but is.  members can't be reliably counted on to only contain living members
			// because of the recent change that disallows setting variables on entities.
			if (IsAlive(self.squad.members[i]) 
			 && self.squad.members[i] cansee(self)
			 && distance(self.origin,self.squad.members[i].origin) < 500)
			{
				self.squad.members[i].bcFriendDeathTime = GetTime();
			}
		}
	}
}


aiDeathEnemy ()
{
	attacker = self.attacker;

	if (!IsAlive (attacker) || !IsSentient (attacker) || !IsDefined (attacker.squad))
	{
		return;
	}

	// if we've been called out by someone in the squad of our attacker
	// and the one who did so is still alive
	// and he's not the one who killed us
	// and the callout happened recently enough
	if (IsDefined (self.calledOut[attacker.squad.squadName]) && 
		IsAlive (self.calledOut[attacker.squad.squadName].spotter) &&
		self.calledOut[attacker.squad.squadName].spotter != attacker &&
		GetTime() < self.calledOut[attacker.squad.squadName].expireTime)
	{
		attacker.bcKillTime = GetTime();
	}
	else if (!IsPlayer(attacker))
	{
		// attacker says "got one" or something similar ... check threatType
		attacker.bcKillTime = GetTime();
	}
}

addOrder(type, modifier)
{
	self.bcOrderType = type;
	self.bcOrderModifier = modifier;
	self.bcOrderTime = GetTime();
}

evaluateMoveEvent (leavingCover)
{
	/*
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
	{
		return;
	}

	// temp
	if (!IsDefined (self.node))
	{
		return;
	}

	dist = distance (self.origin, self.node.origin);

	if (dist < 150)
	{
		return;
	}

	if (!self isNodeCover())
	{
		return;
	}

	if ( self.combatTime > 0.0)
	{
		anim.moveOrigin.origin = self.node.origin;
		self.squad animscripts\squadmanager::updateStates();

		if (self.squad.squadStates["move"].isActive)
		{
			if(self isHero())
			{
				self addOrder("move", "follow");
			}
			else
			{
				self addOrder("action", "coverme");
			}
		}
		else
		{
			addOrder("cover", "generic");
		}
	}
	else
	{
		if (self isHero())
		{
			self addOrder("move", "forward");
		}
		else
		{
			self addOrder("move", "generic");
		}
	}
	*/
}

evaluateReloadEvent()
{
	/*
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
	{
		return;
	}

	self.bcReloadTime = GetTime();
	*/
}

evaluateMeleeEvent()
{
	//return false;
}

evaluateFiringEvent()
{
	//return false;
}

evaluateAttackEvent(type)
{
	/*
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
	{
		return;
	}

	switch (type)
	{
		case "grenade":
		self.bcThrewGrenadeTime = GetTime();
		break;
	}
	*/
}

addSituationalOrder()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!IsDefined (self.squad.chatInitialized))
	{
		return;
	}

	if (self.squad.squadStates["combat"].isActive)
	{
		self addSituationalCombatOrder();
	}
	else
	{
		self addSituationalIdleOrder();
	}
}

addSituationalIdleOrder()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	squad = self.squad;
	squad animscripts\squadmanager::updateStates();

	if (squad.squadStates["move"].isActive)
	{
		self addOrder ("move", "generic");
	}
}

addSituationalCombatOrder()
{
	
	self endon ("death");
	self endon ("removed from battleChatter");
	
	squad = self.squad;
	squad animscripts\squadmanager::updateStates();
	
	if (squad.squadStates["suppressed"].isActive)
	{
		if (squad.squadStates["move"].isActive)
		{
			self addOrder("cover", "generic");
		}
		else if (squad.squadStates["cover"].isActive)
		{
			self addOrder("action", "grenade");
		}
		else
		{
			self addOrder("cover", "generic"); // need to calc specifics?
		}
	}
	else
	{
		//if (squad.squadStates["move"].isActive)
		//{
		//	if (RandomFloat (1) > 0.5)
		//		self addOrderEvent ("cover", "generic");
		//	else
		//		self addOrderEvent ("move", "generic"); // need to calc specifics?
		//}
		//else 
		if ( self.team == "allies" )
		{
			soldiers = GetAIArray( "axis" );
		}
		else
		{
			soldiers = GetAIArray( "allies");
		}

		closestSoldier = undefined;
		closestSoldierDistance = 1000000000;
		closestSoldierInCover = undefined;
		closestSoldierInCoverDistance = 1000000000;
		closestSoldierInCoverLocation = undefined;

		for (index = 0; index < soldiers.size; index++)
		{
			soldier = soldiers[index];
			distance = DistanceSquared(self.origin, soldier.origin);

			if(closestSoldierDistance > distance)
			{
				closestSoldierDistance = distance;
				closestSoldier = soldier;
			}

			if(soldier isClaimedNodeCover())
			{
				if(closestSoldierInCoverDistance > distance)
				{
					closestSoldierInCover = soldier;
					closestSoldierInCoverDistance = distance;
				}
			}
		}


		if(IsDefined(closestSoldierInCover))
		{
			node = closestSoldierInCover bcGetClaimedNode();
			if(IsDefined(node) && IsDefined(node.script_location))
			{
				closestSoldierInCoverLocation = node.script_location;
			}
		}

		if(self canshootenemy())
		{
			if(squad.squadStates["attacking"].isActive)
			{
				if(RandomFloatRange(0,1) < .3)
				{
					self addOrder("action", "boost");
				}
				if(RandomFloatRange(0,1) < .3)
				{
					self addOrder("action", "supress");
				}
				else
				{
					self addOrder("attack", "infantry");
				}
			}
		}
		else
		{
			//test for repeating, dont keep this
			//self addOrderEvent ("action", "boost");
		}
	}
	
}


/****************************************************************************
 custom event functions
*****************************************************************************/

beginCustomEvent ()
{
	/*
	if (!bcsEnabled())
	{
		return;
	}

	self.customChatPhrase = createChatPhrase();
	*/
}
