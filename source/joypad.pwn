#if defined _GAMEBOY_JOYPAD
#endinput
#endif
#define _GAMEBOY_JOYPAD

//----------------------------------------------------
enum E_JOYPAD_BUTTON
{
	JOYPAD_RIGHT = 0,
	JOYPAD_LEFT = 1,
	JOYPAD_UP = 2,
	JOYPAD_DOWN = 3,
	JOYPAD_A = 4,
	JOYPAD_B = 5,
	JOYPAD_SELECT = 6,
	JOYPAD_START = 7
};

enum E_GB_JOYPAD_STRUCT
{
	bool: J_SELECT_D_PAD,
	bool: J_SELECT_BUTTONS,
	J_BUTTON_STATES,
	J_D_PAD_STATES
};

new g_joypad[E_GB_JOYPAD_STRUCT];

//----------------------------------------------------
stock GB_Joypad_Init()
{
	GB_Joypad_Reset();
}

stock GB_Joypad_Reset()
{
	g_joypad[J_SELECT_D_PAD] =
	g_joypad[J_SELECT_BUTTONS] = false;
	g_joypad[J_BUTTON_STATES] =
	g_joypad[J_D_PAD_STATES] = 0;
}

stock GB_Joypad_Read()
{
	new data = 0x00;

	if(g_joypad[J_SELECT_D_PAD])
	{
		data |= g_joypad[J_D_PAD_STATES];
	}

	if(g_joypad[J_SELECT_BUTTONS])
	{
		data |= g_joypad[J_BUTTON_STATES];
	}

	return data;
}

stock GB_Joypad_Write(value)
{
	g_joypad[J_SELECT_D_PAD] = (value & 0x10) == 0;
	g_joypad[J_SELECT_BUTTONS] = (value & 0x20) == 0;
}

stock GB_Joypad_Clear()
{
	g_joypad[J_BUTTON_STATES] =
	g_joypad[J_D_PAD_STATES] = 0x0F;
}

stock GB_Joypad_Press(E_JOYPAD_BUTTON: button)
{
	switch(button)
	{
		case JOYPAD_RIGHT:  g_joypad[J_D_PAD_STATES] &= ~0x01;
		case JOYPAD_LEFT:   g_joypad[J_D_PAD_STATES] &= ~0x02;
		case JOYPAD_UP:     g_joypad[J_D_PAD_STATES] &= ~0x04;
		case JOYPAD_DOWN:   g_joypad[J_D_PAD_STATES] &= ~0x08;
		case JOYPAD_A:      g_joypad[J_BUTTON_STATES] &= ~0x01;
		case JOYPAD_B:      g_joypad[J_BUTTON_STATES] &= ~0x02;
		case JOYPAD_SELECT: g_joypad[J_BUTTON_STATES] &= ~0x04;
		case JOYPAD_START:  g_joypad[J_BUTTON_STATES] &= ~0x08;
#if defined _ENABLE_WARNING_LOG
		default:
			printf("[GB_JOYPAD]: INVALID BUTTON: %d", _:button);
#endif
	}
}