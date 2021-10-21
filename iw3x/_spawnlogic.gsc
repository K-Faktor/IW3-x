
findBoxCenter( mins, maxs )
{
	center = ( 0, 0, 0 );
	center = maxs - mins;
	center = ( center[0]/2, center[1]/2, center[2]/2 ) + mins;
	return center;
}

expandMins( mins, point )
{
	if ( mins[0] > point[0] )
		mins = ( point[0], mins[1], mins[2] );
	if ( mins[1] > point[1] )
		mins = ( mins[0], point[1], mins[2] );
	if ( mins[2] > point[2] )
		mins = ( mins[0], mins[1], point[2] );
	return mins;
}

expandMaxs( maxs, point )
{
	if ( maxs[0] < point[0] )
		maxs = ( point[0], maxs[1], maxs[2] );
	if ( maxs[1] < point[1] )
		maxs = ( maxs[0], point[1], maxs[2] );
	if ( maxs[2] < point[2] )
		maxs = ( maxs[0], maxs[1], point[2] );
	return maxs;
}

addSpawnPoints( team, spawnPointName, spawnPointName2 )
{
	spawnPoints = getEntArray( spawnPointName, "classname" );
	if( !spawnPoints.size )
		spawnPoints = getEntArray( spawnPointName2, "classname" );
	if( !spawnPoints.size )
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		wait 1;
		return;
	}
	
	for( i = 0; i < spawnPoints.size; i++ ) 
	{
		spawnPoint = spawnPoints[i];
		if( !isDefined( spawnPoint.inited ) )
		{
			spawnPoint spawnPointInit();
			level.spawnMins = expandMins( level.spawnMins, spawnPoint.origin );
			level.spawnMaxs = expandMaxs( level.spawnMaxs, spawnPoint.origin );
			level.teamSpawnPoints[team][i] = spawnPoint;
		}
	}
}

spawnPointInit()
{	
	self placeSpawnpoint();
	self.forward = anglesToForward( self.angles );
	self.sightTracePoint = self.origin + (0,0,50);
	self.inited = true;
}

getTeamSpawnPoints( team )
{
	return level.teamSpawnPoints[team];
}

getSpawnpoint_Random( spawnPoint )
{
	if( !isDefined( spawnPoint ) )
		return undefined;
	return spawnPoint[randomInt(spawnPoint.size)];
}
