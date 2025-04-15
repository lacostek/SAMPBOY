#if defined _GAMEBOY_TIMER
#endinput
#endif
#define _GAMEBOY_TIMER

//----------------------------------------------------
static const timer_freqs[] = {1024, 16, 64, 256};

enum E_GB_TIMER_STRUCT
{
	T_DIVIDER,
	T_COUNTER,
	T_RELOAD,
	T_CTRL,

	bool: T_INTERRUPT,
	T_INTERNAL_DIVIDER,
	T_INTERNAL_COUNTER
};

new g_timer[E_GB_TIMER_STRUCT];

//----------------------------------------------------
stock GB_Timer_Init()
{
	GB_Timer_Reset();
}

stock GB_Timer_Reset()
{
	g_timer[T_DIVIDER] =
	g_timer[T_COUNTER] =
	g_timer[T_RELOAD] =
	g_timer[T_CTRL] =
	g_timer[T_INTERNAL_DIVIDER] =
	g_timer[T_INTERNAL_COUNTER] = 0;
	g_timer[T_INTERRUPT] = false;
}

stock GB_Timer_Read(address)
{
	switch(address)
	{
		case 0xFF04: return g_timer[T_DIVIDER];
		case 0xFF05: return g_timer[T_COUNTER];
		case 0xFF06: return g_timer[T_RELOAD];
		case 0xFF07: return g_timer[T_CTRL];
	}
#if defined _ENABLE_CRITICAL_LOG
	printf("[TIMER]: unhandled timer read at 0x%04x", address);
#endif
	return 0;
}

stock GB_Timer_Write(address, value)
{
	switch(address)
	{
		case 0xFF04: g_timer[T_DIVIDER] = 0;
		case 0xFF05: g_timer[T_COUNTER] = value;
		case 0xFF06: g_timer[T_RELOAD] = value;
		case 0xFF07: g_timer[T_CTRL] = value;
#if defined _ENABLE_CRITICAL_LOG
		default:
			printf("[GB_TIMER]: unhandled timer write at 0x%04x", address);
#endif
	}
}

stock GB_Timer_Step()
{
	new bool: enabled = (g_timer[T_CTRL] & (1 << 2)) != 0;

	g_timer[T_INTERNAL_DIVIDER]++;

	if(g_timer[T_INTERNAL_DIVIDER] == 256)
	{
		g_timer[T_INTERNAL_DIVIDER] = 0;
		g_timer[T_DIVIDER]++;
	}

	if(enabled)
	{
		new freq = timer_freqs[g_timer[T_CTRL] & 0x03];
		g_timer[T_INTERNAL_COUNTER]++;

		if(g_timer[T_INTERNAL_COUNTER] == freq)
		{
			g_timer[T_INTERNAL_COUNTER] = 0;
			g_timer[T_COUNTER]++;

			if(g_timer[T_COUNTER] == 0xFF)
			{
				g_timer[T_INTERRUPT] = true;
			}
			else if(g_timer[T_COUNTER] == 0x00)
			{
				g_timer[T_COUNTER] = g_timer[T_RELOAD];
			}
		}
	}
}

stock GB_Timer_Interrupt()
{
	if(g_timer[T_INTERRUPT])
	{
		g_timer[T_INTERRUPT] = false;
		return 1;
	}
	return 0;
}