#define DR_FULLSCREEN			FULLSCREEN
#define DR_FULLSCREEN_WIDE		FULLSCREEN_WIDE

#define ON_MENU_OPEN( params ) 	\
		onOpen 	{params}

#define ON_MENU_ESC( params ) 	\
		onEsc 	{params}

#define DR_COLOR( DR_RECT, DR_BCOLOR, VISARG ) 	\
itemDef	{										\
	style			WINDOW_STYLE_FILLED			\
	rect			DR_RECT						\
	backcolor		DR_BCOLOR					\
	visible			VISARG						\
	decoration	}

#define DR_MATERIAL( DR_RECT, DR_NAME, VISARG ) \
itemDef	{										\
	style			WINDOW_STYLE_SHADER			\
	rect			DR_RECT						\
	background		DR_NAME						\
	visible			VISARG						\
	decoration	}


#define DR_BUTTON( DR_RECT, itemText, itemAction, visArg ) \
itemDef {	\
	rect			DR_RECT					\
	style			WINDOW_STYLE_FILLED		\
	type			1						\
	text			itemText				\
	textstyle		ITEM_TEXTSTYLE_SHADOWED	\
	textfont		UI_FONT_NORMAL			\
	textalign		ITEM_ALIGN_MIDDLE_LEFT	\
	textscale		0.3						\
	textalignx		10						\
	visible			visArg					\
	mouseEnter	{ 							\
		play "mouse_over"; 	}				\
	action {								\
		play "mouse_click";					\
		itemAction;		}	}