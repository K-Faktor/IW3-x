
init()
{
	level.saytext[0] = &"QUICKMESSAGE_FOLLOW_ME";
	level.saytext[1] = &"QUICKMESSAGE_MOVE_IN";
	level.saytext[2] = &"QUICKMESSAGE_FALL_BACK";
	level.saytext[3] = &"QUICKMESSAGE_SUPPRESSING_FIRE";
	level.saytext[4] = &"QUICKMESSAGE_ATTACK_LEFT_FLANK";
	level.saytext[5] = &"QUICKMESSAGE_ATTACK_RIGHT_FLANK";
	level.saytext[6] = &"QUICKMESSAGE_HOLD_THIS_POSITION";
	level.saytext[7] = &"QUICKMESSAGE_REGROUP";
	level.saytext[8] = &"QUICKMESSAGE_ENEMY_SPOTTED";
	level.saytext[9] = &"QUICKMESSAGE_ENEMIES_SPOTTED";
	level.saytext[10] = &"QUICKMESSAGE_IM_IN_POSITION";
	level.saytext[11] = &"QUICKMESSAGE_AREA_SECURE";
	level.saytext[12] = &"QUICKMESSAGE_WATCH_SIX";
	level.saytext[13] = &"QUICKMESSAGE_SNIPER";
	level.saytext[14] = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
	level.saytext[15] = &"QUICKMESSAGE_YES_SIR";
	level.saytext[16] = &"QUICKMESSAGE_NO_SIR";
	level.saytext[17] = &"QUICKMESSAGE_IM_ON_MY_WAY";
	level.saytext[18] = &"QUICKMESSAGE_SORRY";
	level.saytext[19] = &"QUICKMESSAGE_GREAT_SHOT";
	level.saytext[20] = &"QUICKMESSAGE_COME_ON";
	
	level.soundalias = strtok("followme|movein|fallback|suppressfire|attackleftflank|attackrightflank|holdposition|regroup|enemyspotted|enemiesspotted|iminposition|areasecure|watchsix|sniper|needreinforcements|yessir|nosir|onmyway|sorry|greatshot|comeon", "|");

	for( i = 0; i < 21; i++ ) {
		precacheString(level.saytext[i]);
	}
}

getSoundPrefixForTeam()
{
	a = "";
	if ( self.pers["team"] == "allies" )
	{
		if ( game["allies"] == "sas" )
			a = "UK";
		else
			a = "US";
	}
	else
	{
		if ( game["axis"] == "russian" )
			a = "RU";
		else
			a = "AB";
	}
	return a+"_";
}

doQuickMessage( t, i )
{
	if( isDefined(self.pers["team"]) && self.pers["team"] != "spectator" && !isDefined(self.spamdelay) )
	{
		maxsize = 7;
		offset = 8;
		type = "stm";

		if(t == "quickcommands")
		{
			maxsize = 8;
			offset = 0;
			type = "cmd";
		}
		else if(t == "quickresponses")
		{
			maxsize = 6;
			offset = 15;
			type = "rsp";
		}
		if( i >= 0 && i < maxsize )
		{
			self.spamdelay = true;

			self playSound( self getSoundPrefixForTeam()+"mp_"+type+"_"+level.soundalias[offset+i] );
			saytext = level.saytext[offset+i];
			if( isDefined( level.QuickMessageToAll ) && level.QuickMessageToAll )
				self sayAll( saytext );
			else
			{
				self sayTeam( saytext );
				self pingPlayer();
			}
			wait 3;
			self.spamdelay = undefined;
		}
	}
}

quickstuff( response )
{
	switch( response )
	{
		case "1":
			if( self getStat( 988 ) == 0 )
			{
				self iPrintln( "Third Person Camera Enabled" );
				self setClientDvar( "cg_thirdperson", 1 );
				self setStat( 988, 1 );
			}
			else
			{
				self iPrintln( "Third Person Camera Disabled" );
				self setClientDvar( "cg_thirdperson", 0 );
				self setStat( 988, 0 );
			}	
			break;
		case "2":
			if( self.pers["team"] == "allies" )
				self suicide();
			else
				self iPrintln( "^1Activator cannot suicide!" );
			break;
	}
}
