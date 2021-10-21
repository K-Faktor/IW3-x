
init()
{
	precacheShader( "white" );
	precacheShader( "black" );
	precacheShader( "damage_feedback" );
	
	precacheStatusIcon("hud_status_dead");
	precacheStatusIcon("hud_status_connecting");
		
	precacheString( &"MP_CONNECTED" );
	precacheString( &"IW3X_WAITING_PLAYERS" );
	precacheString( &"IW3X_ROUND_BEGINS_IN" );
	
	precacheItem( "dog_mp" );
	precacheItem( "knife_mp" );
	precacheItem( "deserteagle_mp" );
	
	precacheModel("mil_frame_charge");
	precacheModel("body_mp_sas_urban_sniper");
	
	precacheModel("viewmodel_base_viewhands");
}