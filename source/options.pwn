#if defined _GAMEBOY_OPTIONS
#endinput
#endif
#define _GAMEBOY_OPTIONS

//----------------------------------------------------
#define MAX_FILE_NAME 32

//----------------------------------------------------
enum E_GAMEBOY_OPTIONS
{
	E_ROM_PATH[MAX_FILE_NAME + 1]
};

new g_gb_options[E_GAMEBOY_OPTIONS];

//----------------------------------------------------
stock GB_Options_Init(const config_path[])
{
	new stream = ini_openFile(config_path);
	if(stream >= 0)
	{
		ini_getString(stream, "path", g_gb_options[E_ROM_PATH]);
	}
	ini_closeFile(stream);
}