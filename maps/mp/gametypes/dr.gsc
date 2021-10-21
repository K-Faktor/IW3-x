
main()
{
	if(getdvar("mapname") == "mp_background")
		return;

	iw3x\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	iw3x\_globallogic::SetupCallbacks();
	
	level.callbackStartGameType = iw3x\_globallogic::Callback_StartGameType;
	level.callbackPlayerConnect = iw3x\_globallogic::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = iw3x\_globallogic::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = iw3x\_globallogic::Callback_PlayerDamage;
	level.callbackPlayerKilled = iw3x\_globallogic::Callback_PlayerKilled;
	level.callbackPlayerLastStand = iw3x\_globallogic::Callback_PlayerLastStand;
	
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
}

onStartGameType()
{
	level.teamSpawnPoint = [];
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	
	iw3x\_spawnlogic::addSpawnPoints( "allies", "mp_jumper_spawn", "mp_dm_spawn" );
	iw3x\_spawnlogic::addSpawnPoints( "axis", "mp_activator_spawn", "mp_tdm_spawn" );
	
	level.mapCenter = iw3x\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = "war";
	entitytypes = getentarray();
	for(i = 0; i < entitytypes.size; i++)
	{
		if(isdefined(entitytypes[i].script_gameobjectname))
		{
			dodelete = true;
			gameobjectnames = strtok(entitytypes[i].script_gameobjectname, " ");
			for(j = 0; j < allowed.size; j++)
			{
				for (k = 0; k < gameobjectnames.size; k++)
				{
					if(gameobjectnames[k] == allowed[j])
					{
						dodelete = false;
						break;
					}
				}
				if (!dodelete)
					break;
			}
			if(dodelete)
				entitytypes[i] delete();
		}
	}
}

onSpawnPlayer( origin, angles )
{
	if( isDefined( origin ) && isDefined( angles ) )
		self spawn( origin,angles );
	else 
	{
		spawnPoints = iw3x\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		spawnPoint = iw3x\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		self spawn( spawnPoint.origin, spawnPoint.angles );
	}
}
