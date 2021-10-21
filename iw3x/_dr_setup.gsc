
init()
{
	setDvar( "jump_slowdownEnable", 0 );
	
	setDvar( "sv_disableClientConsole", "0" );
	setDvar( "g_gravity", "800" );
	setDvar( "g_knockback", "1000" );
	setDvar( "g_playercollisionejectspeed", "25" );
	setDvar( "g_dropforwardspeed", "10" );
	setDvar( "g_drophorzspeedrand", "100" );
	setDvar( "g_dropupspeedbase", "10" );
	setDvar( "g_dropupspeedrand", "5" );
	setDvar( "g_useholdtime", "0" );
	setDvar( "bg_fallDamageMaxHeight", 9999 );
	setDvar( "bg_fallDamageMinHeight", 9998 );

	setDvar( "bg_bobMax", "0" );  
	setDvar( "player_sustainAmmo", "0" );  
	setDvar( "player_throwBackInnerRadius", "0" );  
	setDvar( "player_throwBackOuterRadius", "0" );  
	setDvar( "clientsideeffects", "0" );  
	setDvar( "sv_pure", "0" );    
	setDvar( "sv_maxRate", "25000" );  
	setDvar( "g_speed", "200" );  
}