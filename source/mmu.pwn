//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_MMU
#endinput
#endif
#define _GAMEBOY_MMU

//----------------------------------------------------
enum E_GB_MMU_STRUCT
{
    E_RAM[0x2000],
    E_HRAM[0x7F],
    E_IF,
    E_IE,
    bool: E_BOOTROM_MAPPED,
    E_DMA_CYCLES,
    E_DMA_PAGE
};

new g_mmu[E_GB_MMU_STRUCT];

//----------------------------------------------------
stock GB_MMU_Init()
{
    GB_MMU_Reset();
}

stock GB_MMU_Reset()
{
    GB_PPU_Reset();
    GB_Timer_Reset();
    GB_Serial_Reset();
    GB_Mapper_Reset();
    GB_Joypad_Reset();

    for(new i = 0; i < sizeof g_mmu[E_RAM]; i++)
    {
        g_mmu[E_RAM] = 0x00;
    }

    for(new i = 0; i < sizeof g_mmu[E_HRAM]; i++)
    {
        g_mmu[E_HRAM] = 0xFF;
    }

    g_mmu[E_IF] = 0;
    g_mmu[E_IE] = 0;
    g_mmu[E_BOOTROM_MAPPED] = true;
}

stock GB_MMU_Read_ROM(address)
{
    if(g_mmu[E_BOOTROM_MAPPED] && address < 0x0100)
    {
        return boot_rom_dmg[address];
    }
    return GB_Mapper_Read(address);
}

stock GB_MMU_Read(address)
{
    switch(address)
    {
        case 
            0x0000..0x7FFF, // ROM
            0xA000..0xBFFF: // External RAM
        {
            return GB_MMU_Read_ROM(address);
        }
        case 0xC000..0xDFFF: // Internal RAM
        {
            return g_mmu[E_RAM][address - 0xC000];
        }
        case 0xE000..0xFDFF: // Internal RAM (mirror)
        {
            return g_mmu[E_RAM][address - 0xE000];
        }
        case 0xFF01..0xFF02: // Serial
        {
            return GB_Serial_Read(address);
        }
        case 0xFF04..0xFF07: // Timer
        {
            return GB_Timer_Read(address);
        }
        case 0xFF0F: // Interrupt Flags
        {
            return g_mmu[E_IF];
        }
        case 0xFF10..0xFF3F: // Sound
        {
            return 0;
        }
        case
            0xFF40..0xFF4B, // PPU registers
            0x8000..0x9FFF, // VRAM
            0xFE00..0xFE9F: // OAM
        {
            return GB_PPU_Read(address);
        }
        case 0xFEA0..0xFEFF: // Unusable
        { 
            return 0;
        }
        case 0xFF80..0xFFFE: // HRAM
        { 
            return g_mmu[E_HRAM][address - 0xFF80];
        }
        case 0xFF00: // Joypad
        {
            return GB_Joypad_Read();
        }
        case 0xFFFF: // Interrupt Enable
        {
            return g_mmu[E_IE];    
        }
    }
#if defined _ENABLE_WARNING_LOG
    printf("[MMU]: unhandled read from 0x%04x", address);
#endif
    return 0;
}

stock GB_MMU_Write(address, value)
{
    if(address == 0xFF46)
    {
        g_mmu[E_DMA_CYCLES] = 160;
        g_mmu[E_DMA_PAGE] = value;
    }

    switch(address)
    {
        case 
            0x0000..0x7FFF, // ROM
            0xA000..0xBFFF: // External RAM
        {
            GB_Mapper_Write(address, value);
        }
        case 0xC000..0xDFFF: // Internal RAM
        {
            g_mmu[E_RAM][address - 0xC000] = value;
        }
        case 0xE000..0xFDFF: // Internal RAM (mirror)
        {
            g_mmu[E_RAM][address - 0xE000] = value;
        }
        case 0xFF01..0xFF02: // Serial
        {
            GB_Serial_Write(address, value);
        }
        case 0xFF04..0xFF07: // Timer
        {
            GB_Timer_Write(address, value);
        }
        case 0xFF0F: // Interrupt Flags
        {
            g_mmu[E_IF] = value;
        }
        case 0xFF10..0xFF3F: // Sound
        {
            return 0;
        }
        case
            0xFF40..0xFF4B, // PPU registers
            0x8000..0x9FFF, // VRAM
            0xFE00..0xFE9F: // OAM
        {
            GB_PPU_Write(address, value);
        }
        case 0xFEA0..0xFEFF: // Unusable
        { 
            return 0;
        }
        case 0xFF80..0xFFFE: // HRAM
        { 
            g_mmu[E_HRAM][address - 0xFF80] = value;
        }
        case 0xFF00: // Joypad
        {
            GB_Joypad_Write(value);
        }
        case 0xFF50: // Boot ROM Control
        {
            if(value & 0x01) 
            {
                g_mmu[E_BOOTROM_MAPPED] = false;
            }
        }
        case 0xFFFF: // Interrupt Enable
        {
            g_mmu[E_IE] = value & 0x1F;
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[MMU]: unhandled write to 0x%04x", address);
        }
#endif
    }
    return 0;
}

stock GB_MMU_Read16(address)
{
    return (GB_MMU_Read(address + 0) << 0) | (GB_MMU_Read(address + 1) << 8);
}

stock GB_MMU_Write16(address, value)
{
    GB_MMU_Write(address + 0, value >> 0);
    GB_MMU_Write(address + 1, value >> 8);
}

stock GB_MMU_DMA_Copy(page)
{
    new address = page << 8;

    for(new i = 0; i < 0xA0; i++)
    {
        GB_PPU_Write_OAM(i, g_mmu[E_RAM][(address + i) & 0x1FFF]);
    }
}

stock GB_MMU_DMA_Step()
{
    if(g_mmu[E_DMA_CYCLES] > 0)
    {
        g_mmu[E_DMA_CYCLES]--;

        if(g_mmu[E_DMA_CYCLES] == 0)
        {
            GB_MMU_DMA_Copy(g_mmu[E_DMA_PAGE]);
        }
    }
}

stock GB_MMU_Interrupt_Enabled(E_GB_INTERRUPT: interrupt)
{
    return g_mmu[E_IE] & _:interrupt;
}

stock GB_MMU_Interrupt_Requested(E_GB_INTERRUPT: interrupt)
{
    return g_mmu[E_IF] & _:interrupt;
}

stock GB_MMU_Interrupt_Set(E_GB_INTERRUPT: interrupt)
{
    g_mmu[E_IF] |= _:interrupt;
}

stock GB_MMU_Interrupt_Clear(E_GB_INTERRUPT: interrupt)
{
    g_mmu[E_IF] &= ~_:interrupt;
}