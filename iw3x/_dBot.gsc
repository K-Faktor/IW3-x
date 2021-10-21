
addBot()
{
	level waittill( "connected" );
	
	bot = addTestClient();
	while( !isDefined( bot ) )
		wait 0.05;
	bot.pers["isBot"] = true;
	bot thread TestClient();
	
	level waittill( "game_ended" );
	exec( "kick " + ( bot getEntityNumber() ) );
}

TestClient()
{
	self endon( "disconnect" );
	while( !isDefined( self.pers["team"] ) )
		wait .05;

	self notify( "menuresponse", game["menu_team"], "join_game" );
	wait 0.5;
}