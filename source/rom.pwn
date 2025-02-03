//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_ROM
#endinput
#endif
#define _GAMEBOY_ROM

//----------------------------------------------------
stock GB_ROM_Open(const filename[])
{
    new File: file = fopen(filename, io_read);

    if(!file)
    {
        printf("[ROM]: Failed to open file %s", filename);
        return 0;
    }

    new file_size = flength(file);

    // Load file
    for(new i = 0; i <= file_size; i++)
    {
        g_rom[E_DATA][i] = fgetchar(file, false);
    }
        
    memcpy(g_rom[E_HEADER][E_TITLE], g_rom[E_DATA][0x134], 0, ROM_TITLE_SIZE * 4, ROM_TITLE_SIZE);
    g_rom[E_HEADER][E_TITLE][ROM_TITLE_SIZE] = '\0';

    g_rom[E_HEADER][E_TYPE] =             g_rom[E_DATA][0x147];
    g_rom[E_HEADER][E_ROM_SIZE] =         g_rom[E_DATA][0x148];
    g_rom[E_HEADER][E_RAM_SIZE] =         g_rom[E_DATA][0x149];

    g_rom[E_ROM_SIZE] = file_size;

    // Ram
    static const ram_sizes[] = {0, 2, 8, 32, 128, 64};
    new ram_size = g_rom[E_HEADER][E_RAM_SIZE];

    if(ram_size < 0 || ram_size >= sizeof(ram_sizes))
    {
        printf("[ROM]: Invalid ram size: %02x", ram_size);
        return 0;
    }

    g_rom[E_RAM_SIZE] = ram_sizes[ram_size] * 1024;

    printf
    (
        "\n\nROM loaded\n Title: %s\n Type: 0x%02x\n RAM size: %dKB\n ROM size: %dKB\n\n",
        g_rom[E_HEADER][E_TITLE],
        g_rom[E_HEADER][E_TYPE],
        g_rom[E_RAM_SIZE] / 1024,
        g_rom[E_ROM_SIZE] / 1024
    );

    fclose(file);

    return 1;
}