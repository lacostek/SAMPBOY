//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_MAPPER
#endinput
#endif
#define _GAMEBOY_MAPPER

//----------------------------------------------------
#define MAX_RAM_SIZE 128 * 1024

//----------------------------------------------------
enum E_MAPPER_TYPE
{
    INVALID_MAPPER = 0,
    // ---------------
    MAPPER_MBC0,
    MAPPER_MBC1,
    // W.I.P
    MAPPER_MBC2,
    MAPPER_MBC3,
    MAPPER_MBC5,
    MAPPER_MBC7
};

enum E_GB_MAPPER_STRUCT
{
    E_MAPPER_TYPE: E_TYPE,
    
    // For all mappers
    E_ROM[E_GB_ROM_STRUCT],

    // For MBC1 and above
    E_MODE,
    bool: E_RAM_ENABLED,
    bool: E_HAS_BATTERY,
    E_RAM_SIZE,
    E_RAM[MAX_RAM_SIZE], // 0x8000 - MBC1 | 0x200 - MBC2 | 0x8000 - MBC3 | 0x20000 - MBC5 (MAX_RAM_SIZE value)
    E_ROM_BANK,
    E_RAM_BANK,
    E_MODE_SELECT
};

new g_mapper[E_GB_MAPPER_STRUCT];

//----------------------------------------------------
stock GB_Mapper_Init(E_MAPPER_TYPE:type)
{
    g_mapper[E_TYPE] = type;
    g_mapper[E_ROM] = g_rom;

    switch(type)
    {
        case MAPPER_MBC1:
        {
            g_mapper[E_RAM_SIZE] = g_rom[E_RAM_SIZE];
        
            if(g_rom[E_HEADER][E_TYPE] == _:ROM_TYPE_MBC1_RAM_BATT)
            {
                g_mapper[E_HAS_BATTERY] = true;
            }

            GB_MBC1_Reset();
        }
        case MAPPER_MBC2:
        {
            g_mapper[E_RAM_SIZE] = g_rom[E_RAM_SIZE];
            
            if(g_rom[E_HEADER][E_TYPE] == _:ROM_TYPE_MBC2_BATT)
            {
                g_mapper[E_HAS_BATTERY] = true;
            }

            GB_MBC2_Reset();
        }
    }
}

stock GB_Mapper_Write(address, value)
{
    switch(g_mapper[E_TYPE])
    {
        case MAPPER_MBC1: return GB_MBC1_Write(address, value);
        case MAPPER_MBC2: return GB_MBC2_Write(address, value);
    }

#if defined _ENABLE_CRITICAL_LOG
    printf("[MBC0]: write to read-only memory at 0x%04x", address);
#endif
    return 0;
}

stock GB_Mapper_Read(address)
{
    switch(g_mapper[E_TYPE])
    {
        case MAPPER_MBC1: return GB_MBC1_Read(address);
        case MAPPER_MBC2: return GB_MBC2_Read(address);
    }
    return GB_MBC0_Read(address);
}

stock GB_Mapper_Reset()
{
    switch(g_mapper[E_TYPE])
    {
        case MAPPER_MBC1: GB_MBC1_Reset();
        case MAPPER_MBC2: GB_MBC2_Reset();
    }
}

// ---------------------------------------------------------------------------------------
// -----------------------------------------MBC0------------------------------------------
// ---------------------------------------------------------------------------------------
stock GB_MBC0_Read(address)
{
    if(address >= g_mapper[E_ROM][E_ROM_SIZE])
    {
        #if defined _ENABLE_CRITICAL_LOG
            printf("[MBC0]: address out of range: 0x%04x", address);
        #endif
        return 0;
    }
    return g_mapper[E_ROM][E_DATA][address];
}

// ---------------------------------------------------------------------------------------
// -----------------------------------------MBC1------------------------------------------
// ---------------------------------------------------------------------------------------
stock GB_MBC1_Reset()
{
    g_mapper[E_RAM_ENABLED] = false;
    g_mapper[E_ROM_BANK] = 1;
    g_mapper[E_RAM_BANK] = 0;
}

stock GB_MBC1_Read(address)
{
    new rom_addr;
    new ram_addr;

    switch(address)
    {
        case 0x0000..0x3FFF: // ROM bank 0 (fixed)
        {
            return g_mapper[E_ROM][E_DATA][address];
        }
        case 0x4000..0x7FFF: // ROM bank 1-31
        {
            rom_addr = ROM_BANK_SIZE * g_mapper[E_ROM_BANK] + address - 0x4000;

            if(rom_addr >= g_mapper[E_ROM][E_ROM_SIZE])
            {
                #if defined _ENABLE_CRITICAL_LOG
                    printf("[MBC1]: index out of bounds: %d", rom_addr);
                #endif
                return 0;
            }
            return g_mapper[E_ROM][E_DATA][rom_addr];
        }
        case 0xA000..0xBFFF: // RAM bank
        {
            if(g_mapper[E_RAM_ENABLED])
            {
                ram_addr = RAM_BANK_SIZE * g_mapper[E_RAM_BANK] + address - 0xA000;
                return g_mapper[E_RAM][ram_addr % g_mapper[E_RAM_SIZE]];
            }
            return 0xFF;
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[MBC1]: unknown read address: 0x%04x", address);
            return 0;
        }
#endif
    }
    return 0;
}

stock GB_MBC1_Write(address, value)
{
    switch(address)
    {
        case 0x0000..0x1FFF: // RAM enable
        {
            g_mapper[E_RAM_ENABLED] = (value & 0x0F) == 0x0A;
        }
        case 0x2000..0x3FFF: // ROM bank
        {
            g_mapper[E_ROM_BANK] = (g_mapper[E_ROM_BANK] & 0xE0) | (value & 0x1F);
            if(g_mapper[E_ROM_BANK] == 0)
            {
                g_mapper[E_ROM_BANK] = 1;
            }
        }
        case 0x4000..0x5FFF: // RAM bank
        {
            if(g_mapper[E_MODE_SELECT] == 1)
            {
                g_mapper[E_ROM_BANK] |= (value & 0x03) << 5; 
            }
            else
            {
                g_mapper[E_RAM_BANK] = value & 0x03;
            }
        }
        case 0xA000..0xBFFF: // RAM data
        {
            if(g_mapper[E_RAM_ENABLED])
            {
                new ram_addr = RAM_BANK_SIZE * g_mapper[E_RAM_BANK] + address - 0xA000;
                g_mapper[E_RAM][ram_addr % g_mapper[E_RAM_SIZE]] = value;
            }
        }
        case 0x6000..0x7FFF: // Mode select
        {
            g_mapper[E_MODE_SELECT] = value & 0x01;
        }
        default:
        {
            #if defined _ENABLE_WARNING_LOG
                printf("[MBC1]: unknown write address: 0x%04x", address);
            #endif
            return 0;
        }
    }
    return 1;
}

// ---------------------------------------------------------------------------------------
// -----------------------------------------MBC2------------------------------------------
// ---------------------------------------------------------------------------------------
stock GB_MBC2_Reset()
{
    g_mapper[E_RAM_ENABLED] = false;
    g_mapper[E_ROM_BANK] = 0;
}

stock GB_MBC2_Read(address)
{
    new rom_addr;
    new ram_addr;

    switch(address)
    {
        case 0x0000..0x3FFF: // ROM bank 0 (fixed)
        {
            return g_mapper[E_ROM][E_DATA][address];
        }
        case 0x4000..0x7FFF: // ROM bank 1-31
        {
            rom_addr = ROM_BANK_SIZE * g_mapper[E_ROM_BANK] + address - 0x4000;

            if(rom_addr >= g_mapper[E_ROM][E_ROM_SIZE])
            {
                #if defined _ENABLE_CRITICAL_LOG
                    printf("[MBC1]: index out of bounds: %d", rom_addr);
                #endif
                return 0;
            }
            return g_mapper[E_ROM][E_DATA][rom_addr];
        }
        case 0xA000..0xBFFF: // RAM bank
        {
            if(g_mapper[E_RAM_ENABLED])
            {
                ram_addr = RAM_BANK_SIZE * g_mapper[E_RAM_BANK] + address - 0xA000;
                return g_mapper[E_RAM][ram_addr % g_mapper[E_RAM_SIZE]];
            }
            return 0xFF;
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[MBC2]: unknown read address: 0x%04x", address);
            return 0;
        }
#endif
    }
    return 0;
}

stock GB_MBC2_Write(address, value)
{
    switch(address)
    {
        case 0x0000..0x1FFF: // RAM enable
        {
            if((((address & 0xFF) & (1 << 4)) > 0) == false)
            {
                g_mapper[E_RAM_ENABLED] = (value & 0x0F) == 0x0A;
            }
        }
        case 0x2000..0x3FFF: // ROM bank
        {
            g_mapper[E_ROM_BANK] = value & 0xF;
            if(g_mapper[E_ROM_BANK] == 0)
            {
                g_mapper[E_ROM_BANK] = 1;
            }
        }
        case 0x4000..0x5FFF: // RAM bank
        {
            if(g_mapper[E_MODE_SELECT] == 1)
            {
                g_mapper[E_ROM_BANK] |= (value & 0x03) << 5; 
            }
            else
            {
                g_mapper[E_RAM_BANK] = value & 0x3;
            }
        }
        case 0xA000..0xBFFF: // RAM data
        {
            if(g_mapper[E_RAM_ENABLED])
            {
                new ram_addr = RAM_BANK_SIZE * g_mapper[E_RAM_BANK] + address - 0xA000;
                g_mapper[E_RAM][ram_addr % g_mapper[E_RAM_SIZE]] = value;
            }
        }
        case 0x6000..0x7FFF: // Mode select
        {
            g_mapper[E_MODE_SELECT] = value & 0x01;
        }
        default:
        {
            #if defined _ENABLE_WARNING_LOG
                printf("[MBC2]: unknown write address: 0x%04x", address);
            #endif
            return 0;
        }
    }
    return 1;
}