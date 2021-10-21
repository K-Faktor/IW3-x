
#include maps\mp\_utility;
#include iw3x\_hud_util;
#include iw3x\_utility;

init()
{
	iw3x\_precache::init();
	thread iw3x\_dBot::addBot();
	
	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );
	level.players = [];
	
	level.freeRun = _getDvar( level.gametype + "_freerun_round", 1, 0, 1, "int" );
	level.freeRunTime = _getDvar( level.gametype + "_freerun_time", 1.5, 0, 6.0, "float" );
	level.roundLimit = _getDvar( level.gametype + "_roundlimit", 6, 1, 10, "int" );
	level.timeLimit = _getDvar( level.gametype + "_timelimit", 6, 0, 10.0, "float" );
	level.numLives = _getDvar( level.gametype + "_numlives", 3, 1, 3, "int" );
	
	level.PrematchTimer = _getDvar( level.gametype + "_strattimer" , 10, 0, 999, "int" );
	level.roundDelay = _getDvar( level.gametype + "_rounddelay" , 5	, 0, 999, "int" );
	
	level.speedAllies = _getDvar( level.gametype + "_allies_speed" , 1.2, 1.0, 2.0, "float" );
	level.speedAxis = _getDvar( level.gametype + "_axis_speed" , 1.2, 1.0, 2.0, "float" );
}

SetupCallbacks()
{
	level.spawnPlayer = ::spawnPlayer;
	level.spawnSpectator = ::spawnSpectator;
	
	level.onSpawnPlayer = ::blank;
	
	level.onStartGameType = ::blank;
	level.onPrecacheGametype = ::blank;
}

spawnPlayer( origin, angles )
{
	level notify( "jumper", self );
	
	if( isAlive( self ) && self.sessionstate == "playing" )
		self suicide();
	
	self.statusicon = "";
	self.team = self.pers["team"];
	self.sessionteam = self.team;
	
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	
	self.hasSpawned = true;
	self.spawnTime = getTime();
	
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
	if( isDefined( origin ) && isDefined( angles ) )
		self [[level.onSpawnPlayer]]( origin, angles );
	else 
		self [[level.onSpawnPlayer]]();
	
	
	self giveWeapon( "deserteagle_mp" );
	self giveMaxAmmo( "deserteagle_mp" );
	self setSpawnWeapon( "deserteagle_mp" );
	
	self setModel("body_mp_sas_urban_sniper");
	self setViewmodel("viewmodel_base_viewhands");
	
	if ( game["state"] == "readyup" )
	{
		self allowsprint( false );
		self allowjump( false );
		self disableWeapons( );
		self setMoveSpeedScale( 0 );
	}
	else if( game["state"] == "playing" )
	{
		self allowsprint(true);
		self allowjump(true);
		self enableWeapons();
		self setSpeedPlayer();
	}
	
	self notify( "spawned_player" );
	level notify( "player_spawn", self );
}

/***************\
|	COMPLETED	|
\***************/
spawnSpectator()
{
	self notify( "joined_spectators" );
	
	self.pers["team"] = "spectator";
	self.team = self.pers["team"];
	self.sessionteam = self.pers["team"];
	self.sessionstate = self.pers["team"];
	self.spectatorclient = -1;
	self.statusicon = "";
	
	spawnpoints = getEntArray("mp_global_intermission", "classname");
	if( !spawnpoints.size )
	{
		spawnpoint = iw3x\_spawnlogic::getTeamSpawnPoints( "allies" );
		spawnpoints = iw3x\_spawnlogic::getSpawnpoint_Random(spawnpoint);
	}
	spawnpoint = iw3x\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	self spawn( spawnpoint.origin, spawnpoint.angles );
	
	self allowSpectateTeam( "allies", true );
	self allowSpectateTeam( "axis", true );
	self allowSpectateTeam( "none", false );
	
	level notify( "player_spectator", self );
}

blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

Callback_StartGameType()
{
	game["state"] = "readyup";
	if ( !isDefined( game["gamestarted"] ) )
	{
		if ( !isDefined( game["allies"] ) )
			game["allies"] = "marines";
		if ( !isDefined( game["axis"] ) )
			game["axis"] = "opfor";
		
		[[level.onPrecacheGameType]]();
		game["gamestarted"] = true;
	}
	
	if( !isDefined( game["roundsplayed"] ) )
		game["roundsplayed"] = 1;
	
	level.forcedEnd = false;
	level.aliveJumpers = 0;
	level.aliveActivator = 0;
	level.activatorKilled = false;
	
	level.roundEndDelay = 4;
	[[level.onStartGameType]]();
	
	thread iw3x\_hud::init();
	thread iw3x\_menus::init();
	thread iw3x\_scoreboard::init();
	thread iw3x\_quickmessages::init();
	thread iw3x\_damagefeedback::init();
	
	thread iw3x\_dr_setup::init();
	
	deletePlacedEntity("misc_turret");
	thread deletePickups();
	
	thread startGame();
	level thread updateGameTypeDvars();
}

deletePickups()
{
	pickups = getentarray( "oldschool_pickup", "targetname" );

	for ( i = 0; i < pickups.size; i++ )
	{
		if ( isdefined( pickups[i].target ) )
			getent( pickups[i].target, "targetname" ) delete();
		pickups[i] delete();
	}
}

isFreeRun()
{
	return level.freeRun && game["roundsplayed"] == 1;
}

matchStartTimer()
{
	level.waitingForPlayers = false;
	visionSetNaked( getDvar( "mapname" ), 0 );
	
	min = 2;
	if( isFreeRun() )
	{
		min = 1;
		level.timeLimit = level.freeRunTime;
	}
	
	matchStartText = createServerFontString( "objective", 1.5 );
	matchStartText setPoint( "CENTER", "CENTER", 0, 200 );
	matchStartText.sort = 1001;
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;
	matchStartText setText( &"IW3X_WAITING_PLAYERS" );
	
	waitForPlayers( min );
	
	matchStartText setText( &"IW3X_ROUND_BEGINS_IN" );	
	matchStartText setPoint( "CENTER", "CENTER", 0, -20 );
	
	matchStartTimer = createServerTimer( "objective", 1.4 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.foreground = false;
	matchStartTimer.hideWhenInMenu = true;
	matchStartTimer setTimer( level.PrematchTimer );
		
	wait level.PrematchTimer;
		
	matchStartText destroyElem();
	matchStartTimer destroyElem();
	
	if( isFreeRun() )
		iprintlnbold( ">> Free Run <<" );
	
	visionSetNaked( getDvar( "mapname" ), 2.0 );
	game["state"] = "playing";
}

startGame()
{
	level endon("game_ended");
	matchStartTimer();	
	
	level.clockTime setTimer( level.timeLimit * 60 );
	level.roundHud setText( game["roundsplayed"] + "/" + level.roundLimit );
	level.aliveHud.label = &"Jumpers: &&1";
	
	for (i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		player allowsprint( true );
		player allowjump( true );
		player enableWeapons();
		player setSpeedPlayer();
	}
	thread gameLogic();
	level notify("game_started");
}

gameLogic()
{
	level endon( "game_ended" );
	
	while( true )
	{
		activators = 0;
		jumpers = 0;
		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if( player.pers["team"] == "allies" && player.sessionstate == "playing" )
				jumpers++;
			if( player.pers["team"] == "axis" && player.sessionstate == "playing" )
				activators++;
		}
		level.aliveJumpers = jumpers;
		level.aliveActivator = activators;
		level.aliveHud setValue( jumpers );
		
		if( jumpers > 1 && !activators && !level.activatorKilled && !isFreeRun() )
			pickRandomActivator();
		wait 0.1;
	}
}

pickRandomActivator()
{
	if( game["state"] != "playing" || level.activatorKilled )
		return;
	
	guy = undefined;
	while( true )
	{
		size = level.players.size;
		num = randomInt(size);
		guy = level.players[num];
		
		if( guy getEntityNumber() == getDvarInt( "last_picked_player" ) )
		{	
			i = num-1;
			j = num+1;
			if( i >= 0 && isDefined( level.players[i] ) && isPlayer( level.players[i] ) )
				guy = level.players[i];
			else if( j < size && isDefined( level.players[j] ) && isPlayer( level.players[j] ) )
				guy = level.players[j];
		}
		if( guy.pers["team"] != "spectator" )
			break;
		wait 0.1;
	}

	iPrintlnBold( guy.name + "^2 was picked to be ^1Activator^2." );
	
	guy.pers["team"] = "axis";
	guy [[level.spawnPlayer]]();
	setDvar( "last_picked_player", guy getEntityNumber() );
	level notify( "activator", guy );
	level notify( "activator_selected" );
	level.activ = guy;
}

updateGameTypeDvars()
{
	level endon( "game_ended" );
	level waittill( "game_started" );
	level.startTime = gettime();
	message = "";
	while ( true /*game["state"] == "playing"*/ ) {
		if( !getTimeRemaining() ) {
			message = "Time limit reached!";
			break;
		}
		if( level.activatorKilled && level.aliveJumpers > 0 ) {
			message = "Activator Died!";
			break;
		}
		if( !level.activatorKilled && level.aliveJumpers < 1 && !isFreeRun() ) {
			message = "Jumpers Died!";
			break;
		}
		if( !level.activatorKilled && level.aliveJumpers < 2 && !isFreeRun() && !level.aliveActivator ) {
			message = "No More Activator Found";
			break;
		}
		wait 1;
	}
	thread endGame( undefined, message );
}

getTimeRemaining() {
	return level.timeLimit * 60000 - ( gettime() - level.startTime );
}

endGame( reason, message )
{
	if ( game["state"] == "postgame" )
		return;

	level notify ( "game_ended" );
	game["state"] = "postgame";

	level.clockTime destroy();
	level.roundHud destroy();
	level.aliveHud destroy();
	
	setGameEndTime( 0 );
	game["roundsplayed"]++;
	wait 2.5;
	
	if ( level.roundLimit > 1 && game["roundsplayed"] <= level.roundLimit && !level.forcedEnd )
	{
		notifyText = ("Starting round " + game["roundsplayed"] + "^7 out of " + level.roundLimit );
		
		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			player closeMenu();
			player closeInGameMenu();
			player freezeControls( true );
		}
		
		iprintlnbold( message );
		wait 2.5;
		iprintlnbold( notifyText );
		
		wait 10;
		map_restart( true );
		return;
	}
	
	iprintlnbold( message );
	wait 2.5;
	
	wait 4;
	exitLevel( false );
}

waitForPlayers( min )
{
	level.waitingForPlayers = true;
	while( true )
	{
		counter = 0;
		for( i = 0;i < level.players.size; i++ )
		{
			player = level.players[i];
			if( player.pers["team"] == "allies" && player.sessionstate == "playing" )
				counter++;
		}
		if( counter >= min )
			break;
		wait 0.5;
	}
	level.waitingForPlayers = false;
}

notifyConnecting()
{
	waittillframeend;
	if( isDefined( self ) )
		level notify( "connecting", self );
}

Callback_PlayerConnect()
{
	thread notifyConnecting();
	
	self.statusicon = "hud_status_connecting";
	self waittill( "begin" );
	waittillframeend;
	
	level notify( "connected", self );
	self.statusicon = "";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	
	logPrint("J;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n");
	if( !isDefined( self.pers["score"] ) )
	{
		iPrintLn( &"MP_CONNECTED", self.name );
		self.pers["score"] = 0;
		self.pers["deaths"] = 0;
		self.pers["suicides"] = 0;
		self.pers["kills"] = 0;
		self.pers["headshots"] = 0;
		self.pers["assists"] = 0;
	}
	self.score = self.pers["score"];
	self.deaths = self.pers["deaths"];
	self.kills = self.pers["kills"];
	self.assists = self.pers["assists"];
	
	level.players[level.players.size] = self;
	
	self setClientDvar( "g_scriptMainMenu", game["menu_team"] );
	
	if( !isDefined( self.pers["team"] ) || self.pers["team"] == "spectator" )
	{
		self.pers["team"] = "spectator";
		self.team = "spectator";
		self [[level.spawnSpectator]]();
		self openMenu( game["menu_team"] );
	}
	else if( isDefined( self.pers["team"] ) && self.pers["team"] != "spectator" )
	{
		self.pers["team"] = "allies";
		self.team = "allies";
		self [[level.spawnPlayer]]();
	}
}

Callback_PlayerDisconnect()
{
	logPrint("Q;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n");
	for ( i = 0; i < level.players.size; i++ )
	{
		if ( level.players[i] == self )
		{
			while ( i < level.players.size-1 )
			{
				level.players[i] = level.players[i+1];
				i++;
			}
			level.players[i] = undefined;
			break;
		}
	}
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if( self.sessionteam == "spectator" || game["state"] == "postgame" )
		return;
	
	level notify( "player_damage", self, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

	if( isPlayer( eAttacker ) && eAttacker.pers["team"] == self.pers["team"] )
		return;
	
	if( isPlayer( eAttacker ) && sMeansOfDeath == "MOD_MELEE" && isWallKnifing( eAttacker, self ) )
		return;
	
	if( sMeansOfDeath != "MOD_MELEE" )
		iDamage = int( iDamage * 1.4 );
	
	if ( !isDefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
	
	if ( !( iDFlags & level.iDFLAGS_NO_PROTECTION ) )
	{
		if( iDamage < 1 )
			iDamage = 1;

		self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	
		if( isDefined( self ) && isPlayer( self ) && isDefined( eAttacker ) && isPlayer( eAttacker ) && eAttacker != self )
			eAttacker thread iw3x\_damagefeedback::updateDamageFeedback();
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("spawned");
	self notify("killed_player");
	self notify("death");
	
	if (self.sessionteam == "spectator" || game["state"] == "postgame")
		return;
	
	level notify( "player_killed", self, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	
	if (sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";
	
	self clonePlayer(deathAnimDuration);
	
	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";
	self.sessionstate =  "spectator";
	
	if ( isPlayer( attacker ) && attacker != self )
	{
		attacker.kills++;
		attacker.pers["kills"]++;
		
		//	Give Extra Life to Jumper. Not Added yet
	}
	
	if( !isFreeRun() )
	{
		self.deaths++;
		self.pers["deaths"]++;
	}
	
	obituary(self, attacker, sWeapon, sMeansOfDeath);
	
	if( self.pers["team"] == "axis" && isPlayer( attacker ) && attacker.pers["team"] == "allies" )
	{
		text = ( attacker.name + " ^7killed Activator" );
		iprintlnbold( text );

		level.activatorKilled = true;
		self.pers["team"] = "allies";
	}
	
	if( self.pers["team"] != "axis" )
	{
		self thread respawnLogic();
	}	
}

Callback_PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self suicide();
}

respawnLogic()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );

	if( level.activatorKilled  )
		return;
	
	if( level.freeRun || game["state"] != "playing" )
	{
		wait 0.1;
		self [[level.spawnPlayer]]();
		return;
	}
}

isWallKnifing( attacker, victim )
{
	start = attacker getEye();
	end = victim getEye();

	if( bulletTracePassed( start, end, false, attacker ) == 1 )
	{
		return false;
	}
	return true;
}
