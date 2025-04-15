//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _TEXTDRAW_SCREEN
#endinput
#endif
#define _TEXTDRAW_SCREEN

//----------------------------------------------------
#define SCREEN_WIDTH   160
#define SCREEN_HEIGHT  144

#define SCREEN_CHARS_PER_PIXEL ((3 * 4) + 1)
#define SCREEN_LINE_COUNT 8

#define SCREEN_LINE_SIZE  (((SCREEN_WIDTH / SCREEN_LINE_COUNT) * SCREEN_CHARS_PER_PIXEL) + 1)
#define SCREEN_LINE_WIDTH (SCREEN_WIDTH / SCREEN_LINE_COUNT)

// If you read this, don't blame me pls, I will fix textdraws later, but now it's like this.  
#define TextDrawAlignmentF(%0,%1) TextDrawAlignment(%0,TEXT_DRAW_ALIGN:%1)
#define TextDrawFontF(%0,%1) TextDrawFont(%0,TEXT_DRAW_FONT:%1)

//----------------------------------------------------
enum E_SCREEN_COLORS
{
	CTD_LIGHTEST_GREEN = 1,
	CTD_LIGHT_GREEN,
	CTD_DARK_GREEN,
	CTD_DARKEST_GREEN
};

new const g_screen_colors[][4 + 1] = 
{
	"",
	"ghhh", "gghh", "gggh", "gggg"
};
//----------------------------------------------------
enum E_SCREEN_BUTTONS
{
	// d-pad
	S_BUTTON_UP = 4,
	S_BUTTON_DOWN = 6,
	S_BUTTON_LEFT = 7,
	S_BUTTON_RIGHT = 8,
	// buttons
	S_BUTTON_B = 9,
	S_BUTTON_A = 10,
	S_BUTTON_SELECT = 11,
	S_BUTTON_START = 12
};

new E_JOYPAD_BUTTON: pressed_button;

//----------------------------------------------------

new Text: g_screen_line_td[SCREEN_HEIGHT][SCREEN_LINE_COUNT],
	g_screen_line[SCREEN_HEIGHT][SCREEN_LINE_COUNT][SCREEN_LINE_SIZE],
	E_SCREEN_COLORS: g_screen_color[SCREEN_HEIGHT][SCREEN_WIDTH];

new const g_screen_pixel_map[SCREEN_LINE_WIDTH] = {1, 14, 27, ...};

new Text: g_gameboy_td[22];

//----------------------------------------------------
stock GenerateScreenLine(dest[], size = sizeof(dest))
{
	new pixel = (size - 1) / 3; // = ~w~~w~~w~~w~.

	for(new i = 0; i < pixel; i++)
	{
		strcat(dest, "~w~", size);
		
		if((i + 1) % 4 == 0 && i < pixel - 1)
		{
			strcat(dest, ".", size);
		}
	}
}

stock CreateGameBoyScreen(Float:x = 278.0, Float:y = 105.0)
{
	new line[SCREEN_LINE_SIZE];
	GenerateScreenLine(line);

	for(new i = 0; i < SCREEN_HEIGHT; i++)
	{
		for(new j = 0; j < SCREEN_LINE_COUNT; j++)
		{
			new Float: offset = x + ((j / 2) * 21) + ((j % 2) * 0.55);

			g_screen_line_td[i][j] = TextDrawCreate(offset, y + (i * 0.7), line);
			g_screen_line[i][j] = line;
			
			TextDrawLetterSize(g_screen_line_td[i][j], 0.116, 0.8);
			TextDrawAlignmentF(g_screen_line_td[i][j], 2);
			TextDrawColour(g_screen_line_td[i][j], 0xFFFFFFFF);
			TextDrawUseBox(g_screen_line_td[i][j], false);
			TextDrawBoxColour(g_screen_line_td[i][j], 0x000000AA);
			TextDrawSetShadow(g_screen_line_td[i][j], 0);
			TextDrawSetOutline(g_screen_line_td[i][j], 0);
			TextDrawBackgroundColour(g_screen_line_td[i][j], 0x000000FF);
			TextDrawFontF(g_screen_line_td[i][j], 2);
			TextDrawSetProportional(g_screen_line_td[i][j], true);
		}
	}
}

stock CreateGameBoyTD()
{
	// Corners
	g_gameboy_td[0] = TextDrawCreate(316, 292, "ld_beat:chit");
	TextDrawLetterSize(g_gameboy_td[0], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[0], 98, 101);
	TextDrawAlignmentF(g_gameboy_td[0], 1);
	TextDrawColour(g_gameboy_td[0], 0xC0C0C0FF);
	TextDrawUseBox(g_gameboy_td[0], false);
	TextDrawBoxColour(g_gameboy_td[0], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[0], 0);
	TextDrawSetOutline(g_gameboy_td[0], 1);
	TextDrawBackgroundColour(g_gameboy_td[0], 0x000000FF);
	TextDrawFontF(g_gameboy_td[0], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[0], true);

	g_gameboy_td[1] = TextDrawCreate(316, 292, "ld_beat:chit");
	TextDrawLetterSize(g_gameboy_td[1], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[1], 98, 101);
	TextDrawAlignmentF(g_gameboy_td[1], 1);
	TextDrawColour(g_gameboy_td[1], 0xC0C0C0FF);
	TextDrawUseBox(g_gameboy_td[1], false);
	TextDrawBoxColour(g_gameboy_td[1], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[1], 0);
	TextDrawSetOutline(g_gameboy_td[1], 1);
	TextDrawBackgroundColour(g_gameboy_td[1], 0x000000FF);
	TextDrawFontF(g_gameboy_td[1], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[1], true);

	// Background
	g_gameboy_td[2] = TextDrawCreate(243, 74, "ld_dual:white"); // 1
	TextDrawLetterSize(g_gameboy_td[2], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[2], 155, 272);
	TextDrawAlignmentF(g_gameboy_td[2], 1);
	TextDrawColour(g_gameboy_td[2], 0xC0C0C0FF);
	TextDrawUseBox(g_gameboy_td[2], false);
	TextDrawBoxColour(g_gameboy_td[2], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[2], 0);
	TextDrawSetOutline(g_gameboy_td[2], 1);
	TextDrawBackgroundColour(g_gameboy_td[2], 0x000000FF);
	TextDrawFontF(g_gameboy_td[2], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[2], true);

	g_gameboy_td[3] = TextDrawCreate(243, 345, "ld_dual:white"); // 2
	TextDrawLetterSize(g_gameboy_td[3], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[3], 118, 31);
	TextDrawAlignmentF(g_gameboy_td[3], 1);
	TextDrawColour(g_gameboy_td[3], 0xC0C0C0FF);
	TextDrawUseBox(g_gameboy_td[3], false);
	TextDrawBoxColour(g_gameboy_td[3], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[3], 0);
	TextDrawSetOutline(g_gameboy_td[3], 1);
	TextDrawBackgroundColour(g_gameboy_td[3], 0x000000FF);
	TextDrawFontF(g_gameboy_td[3], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[3], true);

	// Buttons
	g_gameboy_td[4] = TextDrawCreate(268, 252, "ld_dual:white"); // D-PAD UP
	TextDrawLetterSize(g_gameboy_td[4], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[4], 12, 14);
	TextDrawAlignmentF(g_gameboy_td[4], 1);
	TextDrawColour(g_gameboy_td[4], 0x000000FF);
	TextDrawUseBox(g_gameboy_td[4], false);
	TextDrawBoxColour(g_gameboy_td[4], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[4], 0);
	TextDrawSetOutline(g_gameboy_td[4], 1);
	TextDrawBackgroundColour(g_gameboy_td[4], 0x000000FF);
	TextDrawFontF(g_gameboy_td[4], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[4], true);
	TextDrawSetSelectable(g_gameboy_td[4], true);

	g_gameboy_td[5] = TextDrawCreate(268, 266, "ld_dual:white"); // D-PAD UNUSED
	TextDrawLetterSize(g_gameboy_td[5], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[5], 12, 14);
	TextDrawAlignmentF(g_gameboy_td[5], 1);
	TextDrawColour(g_gameboy_td[5], 0x000000FF);
	TextDrawUseBox(g_gameboy_td[5], false);
	TextDrawBoxColour(g_gameboy_td[5], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[5], 0);
	TextDrawSetOutline(g_gameboy_td[5], 1);
	TextDrawBackgroundColour(g_gameboy_td[5], 0x000000FF);
	TextDrawFontF(g_gameboy_td[5], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[5], true);

	g_gameboy_td[6] = TextDrawCreate(268, 280, "ld_dual:white"); // D-PAD DOWN
	TextDrawLetterSize(g_gameboy_td[6], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[6], 12, 14);
	TextDrawAlignmentF(g_gameboy_td[6], 1);
	TextDrawColour(g_gameboy_td[6], 0x000000FF);
	TextDrawUseBox(g_gameboy_td[6], false);
	TextDrawBoxColour(g_gameboy_td[6], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[6], 0);
	TextDrawSetOutline(g_gameboy_td[6], 1);
	TextDrawBackgroundColour(g_gameboy_td[6], 0x000000FF);
	TextDrawFontF(g_gameboy_td[6], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[6], true);
	TextDrawSetSelectable(g_gameboy_td[6], true);

	g_gameboy_td[7] = TextDrawCreate(256, 266, "ld_dual:white"); // D-PAD LEFT
	TextDrawLetterSize(g_gameboy_td[7], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[7], 12, 14);
	TextDrawAlignmentF(g_gameboy_td[7], 1);
	TextDrawColour(g_gameboy_td[7], 0x000000FF);
	TextDrawUseBox(g_gameboy_td[7], false);
	TextDrawBoxColour(g_gameboy_td[7], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[7], 0);
	TextDrawSetOutline(g_gameboy_td[7], 1);
	TextDrawBackgroundColour(g_gameboy_td[7], 0x000000FF);
	TextDrawFontF(g_gameboy_td[7], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[7], true);
	TextDrawSetSelectable(g_gameboy_td[7], true);

	g_gameboy_td[8] = TextDrawCreate(280, 266, "ld_dual:white"); // D-PAD RIGHT
	TextDrawLetterSize(g_gameboy_td[8], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[8], 12, 14);
	TextDrawAlignmentF(g_gameboy_td[8], 1);
	TextDrawColour(g_gameboy_td[8], 0x000000FF);
	TextDrawUseBox(g_gameboy_td[8], false);
	TextDrawBoxColour(g_gameboy_td[8], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[8], 0);
	TextDrawSetOutline(g_gameboy_td[8], 1);
	TextDrawBackgroundColour(g_gameboy_td[8], 0x000000FF);
	TextDrawFontF(g_gameboy_td[8], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[8], true);
	TextDrawSetSelectable(g_gameboy_td[8], true);

	// Button_B
	g_gameboy_td[9] = TextDrawCreate(336, 265, "ld_beat:chit");
	TextDrawLetterSize(g_gameboy_td[9], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[9], 30, 36);
	TextDrawAlignmentF(g_gameboy_td[9], 1);
	TextDrawColour(g_gameboy_td[9], 0x800040FF);
	TextDrawUseBox(g_gameboy_td[9], false);
	TextDrawBoxColour(g_gameboy_td[9], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[9], 0);
	TextDrawSetOutline(g_gameboy_td[9], 1);
	TextDrawBackgroundColour(g_gameboy_td[9], 0x000000FF);
	TextDrawFontF(g_gameboy_td[9], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[9], true);
	TextDrawSetSelectable(g_gameboy_td[9], true);

	// Button_A
	g_gameboy_td[10] = TextDrawCreate(362, 254, "ld_beat:chit");
	TextDrawLetterSize(g_gameboy_td[10], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[10], 30, 36);
	TextDrawAlignmentF(g_gameboy_td[10], 1);
	TextDrawColour(g_gameboy_td[10], 0x800040FF);
	TextDrawUseBox(g_gameboy_td[10], false);
	TextDrawBoxColour(g_gameboy_td[10], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[10], 0);
	TextDrawSetOutline(g_gameboy_td[10], 1);
	TextDrawBackgroundColour(g_gameboy_td[10], 0x000000FF);
	TextDrawFontF(g_gameboy_td[10], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[10], true);
	TextDrawSetSelectable(g_gameboy_td[10], true);

	// Button_Select
	g_gameboy_td[11] = TextDrawCreate(283, 320, "ld_dual:white");
	TextDrawLetterSize(g_gameboy_td[11], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[11], 22, 8);
	TextDrawAlignmentF(g_gameboy_td[11], 1);
	TextDrawColour(g_gameboy_td[11], 0x808080FF);
	TextDrawUseBox(g_gameboy_td[11], false);
	TextDrawBoxColour(g_gameboy_td[11], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[11], 0);
	TextDrawSetOutline(g_gameboy_td[11], 1);
	TextDrawBackgroundColour(g_gameboy_td[11], 0x000000FF);
	TextDrawFontF(g_gameboy_td[11], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[11], true);
	TextDrawSetSelectable(g_gameboy_td[11], true);

	// Button_Start
	g_gameboy_td[12] = TextDrawCreate(314, 320, "ld_dual:white");
	TextDrawLetterSize(g_gameboy_td[12], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[12], 22, 8);
	TextDrawAlignmentF(g_gameboy_td[12], 1);
	TextDrawColour(g_gameboy_td[12], 0x808080FF);
	TextDrawUseBox(g_gameboy_td[12], false);
	TextDrawBoxColour(g_gameboy_td[12], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[12], 0);
	TextDrawSetOutline(g_gameboy_td[12], 1);
	TextDrawBackgroundColour(g_gameboy_td[12], 0x000000FF);
	TextDrawFontF(g_gameboy_td[12], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[12], true);
	TextDrawSetSelectable(g_gameboy_td[12], true);

	// Corners display
	g_gameboy_td[13] = TextDrawCreate(328, 137, "ld_beat:chit");
	TextDrawLetterSize(g_gameboy_td[13], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[13], 70, 93.333333);
	TextDrawAlignmentF(g_gameboy_td[13], 1);
	TextDrawColour(g_gameboy_td[13], 0x808080FF);
	TextDrawUseBox(g_gameboy_td[13], false);
	TextDrawBoxColour(g_gameboy_td[13], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[13], 0);
	TextDrawSetOutline(g_gameboy_td[13], 1);
	TextDrawBackgroundColour(g_gameboy_td[13], 0x000000FF);
	TextDrawFontF(g_gameboy_td[13], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[13], true);

	// Background display
	g_gameboy_td[14] = TextDrawCreate(255, 97, "ld_dual:white");
	TextDrawLetterSize(g_gameboy_td[14], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[14], 131, 83.377777);
	TextDrawAlignmentF(g_gameboy_td[14], 1);
	TextDrawColour(g_gameboy_td[14], 0x808080FF);
	TextDrawUseBox(g_gameboy_td[14], false);
	TextDrawBoxColour(g_gameboy_td[14], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[14], 0);
	TextDrawSetOutline(g_gameboy_td[14], 1);
	TextDrawBackgroundColour(g_gameboy_td[14], 0x000000FF);
	TextDrawFontF(g_gameboy_td[14], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[14], true);

	g_gameboy_td[15] = TextDrawCreate(255, 180, "ld_dual:white");
	TextDrawLetterSize(g_gameboy_td[15], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[15], 107, 34.844444);
	TextDrawAlignmentF(g_gameboy_td[15], 1);
	TextDrawColour(g_gameboy_td[15], 0x808080FF);
	TextDrawUseBox(g_gameboy_td[15], false);
	TextDrawBoxColour(g_gameboy_td[15], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[15], 0);
	TextDrawSetOutline(g_gameboy_td[15], 1);
	TextDrawBackgroundColour(g_gameboy_td[15], 0x000000FF);
	TextDrawFontF(g_gameboy_td[15], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[15], true);

	// Inscriptions
	g_gameboy_td[16] = TextDrawCreate(255, 215, "SAMP-BOY tm");
	TextDrawLetterSize(g_gameboy_td[16], 0.2, 1.3);
	TextDrawTextSize(g_gameboy_td[16], 316, 228);
	TextDrawAlignmentF(g_gameboy_td[16], 1);
	TextDrawColour(g_gameboy_td[16], 0x004080FF);
	TextDrawUseBox(g_gameboy_td[16], false);
	TextDrawBoxColour(g_gameboy_td[16], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[16], 0);
	TextDrawSetOutline(g_gameboy_td[16], 0);
	TextDrawBackgroundColour(g_gameboy_td[16], 0x000000FF);
	TextDrawFontF(g_gameboy_td[16], 2);
	TextDrawSetProportional(g_gameboy_td[16], true);

	g_gameboy_td[17] = TextDrawCreate(350, 288, "           a~n~b");
	TextDrawLetterSize(g_gameboy_td[17], 0.2, 1.3);
	TextDrawTextSize(g_gameboy_td[17], 386, 318);
	TextDrawAlignmentF(g_gameboy_td[17], 1);
	TextDrawColour(g_gameboy_td[17], 0x004080FF);
	TextDrawUseBox(g_gameboy_td[17], false);
	TextDrawBoxColour(g_gameboy_td[17], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[17], 0);
	TextDrawSetOutline(g_gameboy_td[17], 0);
	TextDrawBackgroundColour(g_gameboy_td[17], 0x000000FF);
	TextDrawFontF(g_gameboy_td[17], 2);
	TextDrawSetProportional(g_gameboy_td[17], true);

	g_gameboy_td[18] = TextDrawCreate(280, 330, "select start");
	TextDrawLetterSize(g_gameboy_td[18], 0.2, 1.3);
	TextDrawTextSize(g_gameboy_td[18], 346, 344);
	TextDrawAlignmentF(g_gameboy_td[18], 1);
	TextDrawColour(g_gameboy_td[18], 0x004080FF);
	TextDrawUseBox(g_gameboy_td[18], false);
	TextDrawBoxColour(g_gameboy_td[18], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[18], 0);
	TextDrawSetOutline(g_gameboy_td[18], 0);
	TextDrawBackgroundColour(g_gameboy_td[18], 0x000000FF);
	TextDrawFontF(g_gameboy_td[18], 2);
	TextDrawSetProportional(g_gameboy_td[18], true);

	// Speaker
	g_gameboy_td[19] = TextDrawCreate(350, 318, "\\\\\\\\\\\\");
	TextDrawLetterSize(g_gameboy_td[19], 0.4, 5);
	TextDrawTextSize(g_gameboy_td[19], 403.600006, 381.822222);
	TextDrawAlignmentF(g_gameboy_td[19], 1);
	TextDrawColour(g_gameboy_td[19], 0xC0C0C0FF);
	TextDrawUseBox(g_gameboy_td[19], false);
	TextDrawBoxColour(g_gameboy_td[19], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[19], 0);
	TextDrawSetOutline(g_gameboy_td[19], 1);
	TextDrawBackgroundColour(g_gameboy_td[19], 0x808080FF);
	TextDrawFontF(g_gameboy_td[19], 1);
	TextDrawSetProportional(g_gameboy_td[19], true);

	// Battery indicator
	g_gameboy_td[20] = TextDrawCreate(264, 138, "ld_beat:chit");
	TextDrawLetterSize(g_gameboy_td[20], 1, 3.5);
	TextDrawTextSize(g_gameboy_td[20], 6, 7);
	TextDrawAlignmentF(g_gameboy_td[20], 1);
	TextDrawColour(g_gameboy_td[20], 0xFF0000FF);
	TextDrawUseBox(g_gameboy_td[20], false);
	TextDrawBoxColour(g_gameboy_td[20], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[20], 0);
	TextDrawSetOutline(g_gameboy_td[20], 1);
	TextDrawBackgroundColour(g_gameboy_td[20], 0x000000FF);
	TextDrawFontF(g_gameboy_td[20], TEXT_DRAW_FONT_SPRITE_DRAW);
	TextDrawSetProportional(g_gameboy_td[20], true);

	g_gameboy_td[21] = TextDrawCreate(258, 148, "battery");
	TextDrawLetterSize(g_gameboy_td[21], 0.1, 0.7);
	TextDrawTextSize(g_gameboy_td[21], 317.599998, 161.088888);
	TextDrawAlignmentF(g_gameboy_td[21], 1);
	TextDrawColour(g_gameboy_td[21], 0xFFFFFFFF);
	TextDrawUseBox(g_gameboy_td[21], false);
	TextDrawBoxColour(g_gameboy_td[21], 0x000000AA);
	TextDrawSetShadow(g_gameboy_td[21], 0);
	TextDrawSetOutline(g_gameboy_td[21], 0);
	TextDrawBackgroundColour(g_gameboy_td[21], 0x000000FF);
	TextDrawFontF(g_gameboy_td[21], 2);
	TextDrawSetProportional(g_gameboy_td[21], true);

	CreateGameBoyScreen(288.0, 100.0);
}

stock DestroyGameBoyTD()
{
	for(new i = 0; i < sizeof g_gameboy_td; i++)
	{
		TextDrawDestroy(g_gameboy_td[i]);
	}

	for(new i = 0; i < SCREEN_HEIGHT; i++)
	{
		for(new l = 0; l < SCREEN_LINE_COUNT; l++)
		{
			TextDrawDestroy(g_screen_line_td[i][l]);
		}
	}
}

stock ShowGameBoyForPlayer(playerid)
{
	for(new i = 0; i < sizeof g_gameboy_td; i++)
	{
		TextDrawShowForPlayer(playerid, g_gameboy_td[i]);
	}

	for(new i = 0; i < SCREEN_HEIGHT; i++)
	{
		for(new l = 0; l < SCREEN_LINE_COUNT; l++)
		{
			TextDrawShowForPlayer(playerid, g_screen_line_td[i][l]);
		}
	}

	SelectTextDraw(playerid, -1);
}

stock HideGameBoyForPlayer(playerid)
{
	for(new i = 0; i < sizeof g_gameboy_td; i++)
	{
		TextDrawHideForPlayer(playerid, g_gameboy_td[i]);
	}

	for(new i = 0; i < SCREEN_HEIGHT; i++)
	{
		for(new l = 0; l < SCREEN_LINE_COUNT; l++)
		{
			TextDrawHideForPlayer(playerid, g_screen_line_td[i][l]);
		}
	}

	CancelSelectTextDraw(playerid);
}

stock E_SCREEN_COLORS: ConvertScreenColor(color_id)
{
	switch(color_id)
	{
		case 0: return CTD_LIGHTEST_GREEN;
		case 1: return CTD_LIGHT_GREEN;
		case 2: return CTD_DARK_GREEN;
		case 3: return CTD_DARKEST_GREEN;
		default: return CTD_LIGHTEST_GREEN;
	}
}

stock Screen_SetPixelColor(width, height, color_id)
{
	if(width < 0 || width >= SCREEN_WIDTH || height < 0 || height >= SCREEN_HEIGHT)
		return 0;

	new E_SCREEN_COLORS:color = ConvertScreenColor(color_id);

	if(g_screen_color[height][width] == color)
		return 0;

	new group = (width / (SCREEN_LINE_WIDTH * 2)) * 2;
	new line_type = group + (width % 2);
	new pixel_index = (width % (SCREEN_LINE_WIDTH * 2)) / 2;

	new line[SCREEN_LINE_SIZE];
	format(line, sizeof line, g_screen_line[height][line_type]);

	new color_pixel = g_screen_pixel_map[pixel_index];
	for(new i = 0; i < 4; i++)
	{
		line[color_pixel + (i * 3)] = g_screen_colors[_:color][i];
	}

	g_screen_color[height][width] = color;

	format(g_screen_line[height][line_type], SCREEN_LINE_SIZE, line);
	TextDrawSetString(g_screen_line_td[height][line_type], g_screen_line[height][line_type]);

	return 1;
}

// JOYPAD
stock Screen_IsButtonPressed(E_JOYPAD_BUTTON:button)
{
	return button == pressed_button;
}

stock Screen_ReleaseButton()
{
	pressed_button = E_JOYPAD_BUTTON: -1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	switch(E_SCREEN_BUTTONS: clickedid)
	{    
		// d-pad
		case S_BUTTON_UP: pressed_button = JOYPAD_UP;
		case S_BUTTON_DOWN: pressed_button = JOYPAD_DOWN;
		case S_BUTTON_LEFT: pressed_button = JOYPAD_LEFT;
		case S_BUTTON_RIGHT: pressed_button = JOYPAD_RIGHT;
		// buttons
		case S_BUTTON_B: pressed_button = JOYPAD_B;
		case S_BUTTON_A: pressed_button = JOYPAD_A;
		case S_BUTTON_SELECT: pressed_button = JOYPAD_SELECT;
		case S_BUTTON_START: pressed_button = JOYPAD_START;
	}
	return 0;
}