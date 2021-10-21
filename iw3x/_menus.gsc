
init()
{
	game["menu_team"] = "iw3x_team";
	game["menu_quickcommands"] = "quickcommands";
	game["menu_quickstatements"] = "quickstatements";
	game["menu_quickresponses"] = "quickresponses";
	game["menu_quickstuff"] = "quickstuff";
	
	precacheMenu( "iw3x_team" );
	
	precacheMenu( "quickcommands" );
	precacheMenu( "quickstatements" );
	precacheMenu( "quickresponses" );
	precacheMenu( "quickstuff" );
	precacheMenu( "scoreboard" );
	precacheMenu( "clientcmd" );
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		switch( menu )
		{
			case "iw3x_team":
				switch( response )
				{
					case "join_game":
						self closeMenus();
						self.pers["team"] = "allies";
					//	if( self canSpawn() )
							self [[level.spawnPlayer]]();
						break;
					case "spectator":
						self closeMenus();
						self [[level.spawnSpectator]]();
						break;
				}
		
			case "quickcommands":
			case "quickstatements":
			case "quickresponses":
				iw3x\_quickmessages::doQuickMessage( menu, int(response)-1 );
			case "quickstuff":
				iw3x\_quickmessages::quickstuff( response );
		}
	}
}

closeMenus()
{
	self closeMenu();
	self closeInGameMenu();
}
