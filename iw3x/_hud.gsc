
init()
{	
	level.uiParent = spawnstruct();
	level.uiParent.horzAlign = "left";
	level.uiParent.vertAlign = "top";
	level.uiParent.alignX = "left";
	level.uiParent.alignY = "top";
	level.uiParent.x = 0;
	level.uiParent.y = 0;
	level.uiParent.width = 0;
	level.uiParent.height = 0;
	level.uiParent.children = [];	
	
	level.fontHeight = 12;
	
	level.lowerTextYAlign = "CENTER";
	level.lowerTextY = 70;
	level.lowerTextFontSize = 2;
	
	level.roundHud = newHudElem();
    level.roundHud.foreground = true;
    level.roundHud.alignX = "right";
    level.roundHud.alignY = "top";
    level.roundHud.horzAlign = "right";
    level.roundHud.vertAlign = "top";
    level.roundHud.x = -10;
    level.roundHud.y = 25;
    level.roundHud.sort = 0;
    level.roundHud.fontScale = 2;
    level.roundHud.color = (1, 1, 1);
    level.roundHud.font = "default";
    level.roundHud.glowColor = (0.3, 3, 1);
    level.roundHud.glowAlpha = 1;
    level.roundHud.hidewheninmenu = true;
	
	level.clockTime = newHudElem();
    level.clockTime.foreground = true;
    level.clockTime.alignX = "right";
    level.clockTime.alignY = "top";
    level.clockTime.horzAlign = "right";
    level.clockTime.vertAlign = "top";
    level.clockTime.x = -10;
    level.clockTime.y = 50;
    level.clockTime.sort = 0;
    level.clockTime.fontScale = 2;
    level.clockTime.color = (1, 1, 1);
    level.clockTime.font = "default";
    level.clockTime.glowColor = (0.3, 3, 1);
    level.clockTime.glowAlpha = 1;
    level.clockTime.hidewheninmenu = true;
	
	level.aliveHud = newHudElem();
    level.aliveHud.foreground = true;
	level.aliveHud.alignX = "right";
	level.aliveHud.alignY = "top";
	level.aliveHud.horzAlign = "right";
    level.aliveHud.vertAlign = "top";
    level.aliveHud.x = -10;
    level.aliveHud.y = 75;
    level.aliveHud.sort = 0;
  	level.aliveHud.fontScale = 2;
	level.aliveHud.color = (0.8, 1.0, 0.8);
	level.aliveHud.font = "default";
	level.aliveHud.glowColor = (0.3, 3, 1);
	level.aliveHud.glowAlpha = 1;
 	level.aliveHud.hidewheninmenu = true;
    
	thread onRoundStarted();
	thread onRoundEnded();
}

onRoundStarted()
{
	level waittill( "game_started" );
	
}

onRoundEnded()
{
	level waittill( "game_ended" );
	
}