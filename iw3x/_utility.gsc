
_getDvar( dvar, default_value, min, max, type )
{
	vdvar = undefined;
	if( type == "int" )
	{
		if( getDvar( dvar ) == "" )
			vdvar = default_value;
		else 
			vdvar = getDvarInt( dvar );
	}
	else if( type == "float" )
	{
		if( getDvar( dvar ) == "" )
			vdvar = default_value;
		else 
			vdvar = getDvarFloat( dvar );
	}
	else 
	{
		if( getDvar( dvar ) == "" )
			vdvar = default_value;
		else 
			vdvar = getDvar( dvar );
	}
	
	if( type == "int" || type == "float" )
	{
		if( min != 0 && vdvar < min )
			vdvar = min;
		if( max != 0 && vdvar > max )
			vdvar = max;
	}
	
	if( getDvar( dvar ) == "")
		setDvar( dvar, vdvar );
	
	return vdvar;
}



setSpeedPlayer()
{
	speed = 1.0;
	switch( self.pers["team"] )
	{
	case "allies":
		speed = level.speedAllies;
		break;
	case "axis":
		speed = level.speedAxis;
		break;
	}
	self setMoveSpeedScale( speed );
}