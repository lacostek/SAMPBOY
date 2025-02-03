//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_ROM_INC
#endinput
#endif
#define _GAMEBOY_ROM_INC

//----------------------------------------------------

#define ROM_TITLE_SIZE      16
#define ROM_BANK_SIZE       0x4000
#define RAM_BANK_SIZE       0x2000
#define ROM_HEADER_OFFSET   0x100

#define MAX_ROM_DATA_SIZE   3 * 1024 * 1024

//----------------------------------------------------
enum E_GB_ROM_TYPE
{
    ROM_TYPE_ROM_ONLY =         0x00,
    // ---------------
    ROM_TYPE_MBC1 =             0x01,
    ROM_TYPE_MBC1_RAM =         0x02,
    ROM_TYPE_MBC1_RAM_BATT =    0x03,
    // ---------------
    ROM_TYPE_MBC2 =             0x05,
    ROM_TYPE_MBC2_BATT =        0x06
};

//----------------------------------------------------
enum E_GB_ROM_HEADER_STRUCT
{
    E_TITLE[ROM_TITLE_SIZE + 1],
    E_TYPE,
    E_ROM_SIZE,
    E_RAM_SIZE
};

enum E_GB_ROM_STRUCT
{
    E_HEADER[E_GB_ROM_HEADER_STRUCT],
    E_DATA[MAX_ROM_DATA_SIZE],
    E_ROM_SIZE,
    E_RAM_SIZE
};

new g_rom[E_GB_ROM_STRUCT];