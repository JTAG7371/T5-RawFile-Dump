/#

isDebugOn()
{
	return ( (getdebugdvarint("animDebug") == 1) || ( IsDefined (anim.debugEnt) && anim.debugEnt == self ) );
}

drawDebugLineInternal(fromPoint, toPoint, color, durationFrames)
{
	//println ("Drawing line, color "+color[0]+","+color[1]+","+color[2]);
	//player = getent("player", "classname" );
	//println ( "Point1 : "+fromPoint+", Point2: "+toPoint+", player: "+player.origin );
	for (i=0;i<durationFrames;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}

drawDebugLine(fromPoint, toPoint, color, durationFrames)
{
	if (isDebugOn())
	{
		thread drawDebugLineInternal(fromPoint, toPoint, color, durationFrames);
	}
}

debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}

drawDebugCross(atPoint, radius, color, durationFrames)
{
	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debugLine(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debugLine(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debugLine(atPoint_forward,	atPoint_back,	color, durationFrames);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// BEGIN ANIMSCRIPT STATE DEBUGGING /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UpdateDebugInfo()
{
	self endon("death");

	self.debugInfo = SpawnStruct();
	self.debugInfo.enabled = GetDvarInt( #"ai_debugAnimscript") > 0;
	debugClearState();

    while(1)
    {
		waittillframeend;

		UpdateDebugInfoInternal();

		wait(0.05);
    }
}

UpdateDebugInfoInternal()
{
	if( IsDefined(anim.debugEnt) && (anim.debugEnt==self) )
	{
		doInfo = true;
	}
	else
	{
		doInfo = GetDvarInt( #"ai_debugAnimscript") > 0;

		// check if there's a selected ent
		if( doInfo )
		{
			ai_entNum = GetDvarInt( #"ai_debugEntIndex");
			if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
			{
				doInfo = false;
			}
		}

		// clear everything out if it was just switched on to make sure we start clean
		if( !self.debugInfo.enabled && doInfo )
		{
			self.debugInfo.shouldClearOnAnimscriptChange = true;
		}

		self.debugInfo.enabled = doInfo;
	}

	if( doInfo )
	{
		drawDebugInfo(doInfo);
	}
}

drawDebugInfo(debugLevel)
{
	allowedStancesStr = "";

	if( self IsStanceAllowed("stand") )
		allowedStancesStr += "s";
	if( self IsStanceAllowed("crouch") )
		allowedStancesStr += "c";
	if( self IsStanceAllowed("prone") )
		allowedStancesStr += "p";

	// general info: entnum - pose - movement type - goal radius
	drawDebugEntText( "(" + self getEntityNumber() + ") : " + self.a.pose + " (" + allowedStancesStr + ") : " + self.a.movement + " : " + self.goalradius + " : " + self.pathEnemyFightDist, self, level.color_debug["cyan"], "Brain" );

	// extra info
	extraInfoStr = "";

	if( self.ignoreall )
	{
		extraInfoStr += "ignoreAll ";
	}

	if( self.ignoreme )
	{
		extraInfoStr += "ignoreMe ";
	}

	if( self.ignoresuppression )
	{
		extraInfoStr += "ignoreSuppression ";
	}

	if( !self.a.allow_shooting )
	{
		extraInfoStr += "!allow_shooting ";
	}

	if( animscripts\utility::isCQBWalking() )
	{
		extraInfoStr += "cqb ";
	}

	if( self.walk )
	{
		extraInfoStr += "walk ";
	}

	if( self.sprint )
	{
		extraInfoStr += "sprint ";
	}

	if( IsDefined(self.disableArrivals) && self.disableArrivals )
	{
		extraInfoStr += "!arrivals ";
	}

	if( IsDefined(self.disableExits) && self.disableExits )
	{
		extraInfoStr += "!exits ";
	}

	if( self.grenadeAwareness == 0 )
	{
		extraInfoStr += "!grenadeAwareness ";
	}

	if( !self.takedamage )
	{
		extraInfoStr += "!takedamage ";
	}

	if( !self.allowPain )
	{
		extraInfoStr += "!allowPain ";
	}

//	if( !self.allowDeath )
//	{
//		extraInfoStr += "!allowDeath ";
//	}

	if( self.delayedDeath )
	{
		extraInfoStr += "delayedDeath ";
	}

	if( IsDefined(self.disableTurns) && self.disableTurns )
	{
		extraInfoStr += "disableTurns ";
	}

	if( extraInfoStr != "" )
	{
		drawDebugEntText( extraInfoStr, self, level.color_debug["grey"], "Brain" );
	}

	// weapon info
	drawDebugEntText( self.primaryweapon + " : " + self.secondaryweapon + " : " + self.sidearm + " (" + self.weapon + ")", self, level.color_debug["grey"], "Brain" );

	// state info
	for( i=0; i < self.debugInfo.states.size; i++ )
	{
		stateString = self.debugInfo.states[i].stateName;

		if( debugLevel > 1 )
		{
			stateString += " (" + (GetTime() - self.debugInfo.states[i].stateTime)/1000 + ")";
		}

		if( IsDefined(self.debugInfo.states[i].extraInfo) )
		{
			stateString += ": " + self.debugInfo.states[i].extraInfo;
		}

		lineColor = level.color_debug["white"];

		// state was popped this frame
		if( !self.debugInfo.states[i].stateValid )
		{
			stateString += " [end";
			lineColor = (1,0.75,0.75);

			if( IsDefined(self.debugInfo.states[i].exitReason) )
			{
				stateString += ": " + self.debugInfo.states[i].exitReason;
			}

			stateString += "]";
		}
		else if( self.debugInfo.states[i].stateTime == GetTime() - 50 ) // new state
		{
			lineColor = (0.75,1,0.75);
		}

		drawDebugEntText( indent(self.debugInfo.states[i].stateLevel) + "-" + stateString, self, lineColor, "Brain" );
	}

	// insert empty line
	drawDebugEntText( " ", self, level.color_debug["grey"], "Brain" );

	// remove popped states
	debugCleanStateStack();
}

drawDebugEntText( text, ent, color, channel )
{
	assert( IsDefined(ent) );

	if( !GetDvarInt( #"recorder_enableRec") )
	{
		if( !IsDefined(ent.debugAnimScriptTime) || GetTime() > ent.debugAnimScriptTime )
		{
			ent.debugAnimScriptLevel = 0;
			ent.debugAnimScriptTime = GetTime();
		}

		indentLevel = common_scripts\utility::vector_scale( (0,0,-10), ent.debugAnimScriptLevel );
		print3d( self.origin + (0,0,70) + indentLevel, text, color );
		ent.debugAnimScriptLevel++;
	}
	else
	{
		recordEntText( text, ent, color, channel );
	}
}

debugPushState(stateName, extraInfo)
{
	if( !GetDvarInt( #"ai_debugAnimscript") )
	{
		return;
	}

	// don't do anything if it's not the selected ent
	ai_entNum = GetDvarInt( #"ai_debugEntIndex");
	if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
	{
		return;
	}

	assert( IsDefined(self.debugInfo.states) );
	assert( IsDefined(stateName) );

	//recordEntText( "push: " + stateName, self, level.color_debug["green"], "Brain" );

	state			 = SpawnStruct();
	state.stateName  = stateName;
	state.stateLevel = self.debugInfo.stateLevel;
	state.stateTime  = GetTime();
	state.stateValid = true;

	self.debugInfo.stateLevel++;

	if( IsDefined(extraInfo) )
	{
		state.extraInfo = extraInfo + " ";
	}

	self.debugInfo.states[ self.debugInfo.states.size ] = state;
}

debugAddStateInfo(stateName, extraInfo)
{
	if( !GetDvarInt( #"ai_debugAnimscript") )
	{
		return;
	}

	// don't do anything if it's not the selected ent
	ai_entNum = GetDvarInt( #"ai_debugEntIndex");
	if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
	{
		return;
	}

	assert( IsDefined(self.debugInfo.states) );

	// find the first matching state from bottom
	if( IsDefined(stateName) )
	{
		for( i = self.debugInfo.states.size - 1; i >= 0; i-- )
		{
			assert( IsDefined( self.debugInfo.states[i] ) );

			if( self.debugInfo.states[i].stateName == stateName )
			{
				if( !IsDefined(self.debugInfo.states[i].extraInfo) )
				{
					self.debugInfo.states[i].extraInfo = "";
				}

				self.debugInfo.states[i].extraInfo += extraInfo + " ";
				break;
			}
		}
	}
	else if( self.debugInfo.states.size > 0 )
	{
		// add to the last one
		lastIndex = self.debugInfo.states.size - 1;

		assert( IsDefined(self.debugInfo.states[lastIndex]) );

		if( !IsDefined(self.debugInfo.states[lastIndex].extraInfo) )
		{
			self.debugInfo.states[lastIndex].extraInfo = "";
		}

		self.debugInfo.states[lastIndex].extraInfo += extraInfo + " ";
	}
}

debugPopState(stateName, exitReason)
{
	if( !GetDvarInt( #"ai_debugAnimscript") || self.debugInfo.states.size <= 0 )
	{
		return;
	}

	// don't do anything if it's not the selected ent
	ai_entNum = GetDvarInt( #"ai_debugEntIndex");
	if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
	{
		return;
	}

	assert( IsDefined(self.debugInfo.states) );

	if( IsDefined(stateName) )
	{
		//recordEntText( "pop: " + stateName, self, level.color_debug["red"], "Brain" );

		// remove elements at and after stateName
		for( i=0; i < self.debugInfo.states.size; i++ )
		{
			if( self.debugInfo.states[i].stateName == stateName && self.debugInfo.states[i].stateValid )
			{
				self.debugInfo.states[i].stateValid	= false;
				self.debugInfo.states[i].exitReason	= exitReason;
				self.debugInfo.stateLevel			= self.debugInfo.states[i].stateLevel;

				// invalidate all states below this one
				for( j=i+1; j < self.debugInfo.states.size && self.debugInfo.states[j].stateLevel > self.debugInfo.states[i].stateLevel; j++ )
				{
					self.debugInfo.states[j].stateValid = false;
				}

				break;
			}
		}
	}
	else
	{
		//recordEntText( "pop", self, level.color_debug["red"], "Brain" );

		// remove the last element
		if( self.debugInfo.states[ self.debugInfo.states.size - 1 ].stateValid )
		{
			self.debugInfo.states[ self.debugInfo.states.size - 1 ].stateValid = false;
			self.debugInfo.states[ self.debugInfo.states.size - 1 ].exitReason = exitReason;
			self.debugInfo.stateLevel--;
		}
	}
}

debugClearState()
{
	self.debugInfo.states		= [];
	self.debugInfo.stateLevel	= 0;
	self.debugInfo.shouldClearOnAnimscriptChange = false;
}

debugShouldClearState()
{
	if( IsDefined(self.debugInfo) && IsDefined(self.debugInfo.shouldClearOnAnimscriptChange) && self.debugInfo.shouldClearOnAnimscriptChange )
	{
		return true;
	}

	return false;
}

debugCleanStateStack()
{
	newArray = [];
	for( i=0; i < self.debugInfo.states.size; i++ )
	{
		if( self.debugInfo.states[i].stateValid )
		{
			newArray[ newArray.size ] = self.debugInfo.states[i];
		}
	}

	self.debugInfo.states = newArray;
}

indent(depth)
{
	indent = "";

	for( i=0; i < depth; i++ )
	{
		indent += " ";
	}

	return indent;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// END ANIMSCRIPT STATE DEBUGGING //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* COD4 version
drawDebugInfo()
{
	// What do we want to print?
	line[0]  = self getEntityNumber()+" "+self.a.script;
	line[1]  = self.a.pose+" "+self.a.movement;
	line[2]  = self.a.alertness+" "+self.a.special;

	if (self DebugIsInCombat())
	{
		line[3]  = "in combat for "+(self.a.combatEndTime - GetTime())+" ms.";
	}
	else
	{
		line[3]  = "not in combat";
	}

	line[4]  = self.a.lastDebugPrint1;

	belowFeet = self.origin + (0,0,-8);	
	//aboveHead = self GetShootAtPos() + (0,0,8);
	offset = (0,0,-10);

	for (i=0 ; i<line.size ; i++)
	{
		if (IsDefined(line[i]))
		{
			textPos = ( belowFeet[0]+(offset[0]*i), belowFeet[1]+(offset[1]*i), belowFeet[2]+(offset[2]*i) );
			Print3d (textPos, line[i], (.2, .2, 1), 1, 0.75);	// origin, text, RGB, alpha, scale
		}
	}
}
*/




#/