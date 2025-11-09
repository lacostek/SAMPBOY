#if defined _GAMEBOY_OPTIONS
#endinput
#endif
#define _GAMEBOY_OPTIONS

//----------------------------------------------------
#define MAX_FILE_NAME 32
#define MAX_FILE_ROMS 32

//----------------------------------------------------
enum E_GAMEBOY_OPTIONS
{
	E_TEST_OPTION
};

new g_gb_options[E_GAMEBOY_OPTIONS];

new g_gb_roms_list[MAX_FILE_ROMS][MAX_FILE_NAME + 1];

//----------------------------------------------------
stock GB_Options_Init(const config_path[])
{
	new stream = ini_openFile(config_path);
	if(stream >= 0)
	{
		// Load roms path
		new roms_count = 0;
		if(ini_getInteger(stream, "roms", roms_count) == INI_OK)
		{
			new key_name[6];
			for(new i = 0; i < roms_count; i++)
			{
				format(key_name, sizeof key_name, "rom%d", i);

				if(ini_getString(stream, key_name, g_gb_roms_list[i]) != INI_OK)
				{
					g_gb_roms_list[i][0] = '\0';
				}
			}
		}
	}
	ini_closeFile(stream);
}