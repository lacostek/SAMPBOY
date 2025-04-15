#if defined _GAMEBOY_SERIAL
#endinput
#endif
#define _GAMEBOY_SERIAL

//----------------------------------------------------
enum E_GB_SERIAL_STRUCT
{
	SERIAL_BYTE,
	SERIAL_CTRL
};

new g_serial[E_GB_SERIAL_STRUCT];

//----------------------------------------------------
stock GB_Serial_Init()
{
	GB_Serial_Reset();
}

stock GB_Serial_Reset()
{
	g_serial[SERIAL_BYTE] =
	g_serial[SERIAL_CTRL] = 0;
}

stock GB_Serial_Read(address)
{
	switch(address)
	{
		case 0xFF01: return g_serial[SERIAL_BYTE];
		case 0xFF02: return g_serial[SERIAL_CTRL];
	}
#if defined _ENABLE_CRITICAL_LOG
	printf("[SERIAL]: unhandled serial read at 0x%04x", address);
#endif
	return 0;
}

stock GB_Serial_Write(address, value)
{
	switch(address)
	{
		case 0xFF01: g_serial[SERIAL_BYTE] = value;
		case 0xFF02: g_serial[SERIAL_CTRL] = value;
#if defined _ENABLE_CRITICAL_LOG
		default:
			printf("[SERIAL]: unhandled serial write at 0x%04x", address);
#endif
	}
}