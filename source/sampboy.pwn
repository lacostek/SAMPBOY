//----------------------------------------------------
//
// Description: GameBoy Emulator for SA-MP (server open.mp), powered by brickboy - a lightweight GameBoy emulator. 
//
// WARNING: SCRIPT SUPPORT FOR SA-MP SERVER IS NOT PROVIDED DUE TO INEFFICIENT SA-MP TIMERS
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------
//#define FILTERSCRIPT

#include <open.mp>

// Libs
#include "libraries/mxini.inc"

//----------------------------------------------------
// Config
#define SCRIPT_NAME     "SAMPBOY - Emulator GameBoy 1989 in open.mp server"

#define VERSION_MAJOR 0
#define VERSION_MINOR 0
#define VERSION_PATCH 6

//#define _DEBUG
//#define _ENABLE_WARNING_LOG
//#define _ENABLE_CRITICAL_LOG
//#define _SAMP_SERVER_TEST

//----------------------------------------------------
#include "rom.inc"
#include "boot.inc"
#include "cpu.inc"
#include "interrupt.inc"
#include "opcodes.inc"

#include "options.pwn"
#include "rom.pwn"
#include "mapper.pwn"
#include "mmu.pwn"
#include "cpu.pwn"
#include "ppu.pwn"
#include "opcodes.pwn"
#include "timer.pwn"
#include "serial.pwn"
#include "joypad.pwn"
#include "screen.pwn"

new
    gb_process_ticks = 0,
    tick_interval = 1,
    should_stop_timer = 0;

//----------------------------------------------------
stock E_MAPPER_TYPE: GetMapperType()
{
    new E_GB_ROM_TYPE: rom_type = E_GB_ROM_TYPE: g_rom[E_HEADER][E_TYPE];
    new E_MAPPER_TYPE: map_type = INVALID_MAPPER;

    switch(rom_type)
    {
        case ROM_TYPE_ROM_ONLY: 
            map_type = MAPPER_MBC0;

        case ROM_TYPE_MBC1, ROM_TYPE_MBC1_RAM, ROM_TYPE_MBC1_RAM_BATT:
            map_type = MAPPER_MBC1;

        // Work In Progress
        /*case ROM_TYPE_MBC2, ROM_TYPE_MBC2_BATT:
            map_type = MAPPER_MBC2;*/

        default:
            printf("[MAIN]: Unknown mapper: %02x", _:rom_type);
    }

    return map_type;
}

stock HandleInterrupts()
{
    static const E_GB_INTERRUPT: ints[] = {INT_VBLANK, INT_LCD_STAT, INT_TIMER, INT_SERIAL, INT_JOYPAD};
    static const addrs[] = {0x0040, 0x0048, 0x0050, 0x0058, 0x0060};

    if(g_mmu[E_IF] == 0 || g_mmu[E_IE] == 0)
        return 0;

    for(new i = 0; i < sizeof ints; i++)
    {
        new requested = GB_MMU_Interrupt_Requested(ints[i]);
        new enabled = GB_MMU_Interrupt_Enabled(ints[i]);

        if(requested && enabled)
        {
            if(GB_CPU_Interrput_Enabled())
            {
                GB_MMU_Interrupt_Clear(ints[i]);
                GB_CPU_Interrput(addrs[i]);
            }
            return 1;
        }
    }
    return 1;
}

stock HandleInput()
{
    static const E_JOYPAD_BUTTON: buttons[] = 
    {
        JOYPAD_RIGHT, JOYPAD_LEFT, JOYPAD_UP, JOYPAD_DOWN,  // D-PAD
        JOYPAD_A, JOYPAD_B, JOYPAD_SELECT, JOYPAD_START     // Buttons
    };

    GB_MMU_Interrupt_Clear(INT_JOYPAD);
    GB_Joypad_Clear();

    for(new i = 0; i < sizeof buttons; i++)
    {
        if(Screen_IsButtonPressed(buttons[i]))
        {
            GB_Joypad_Press(buttons[i]);
            GB_MMU_Interrupt_Set(INT_JOYPAD);

            Screen_ReleaseButton();

            return 1;
        }
    }
    return 0;
}

forward SAMPBOY_Process();
public SAMPBOY_Process()
{
    if(should_stop_timer)
    {
        should_stop_timer = 0;
        return 1;
    }

    tick_interval = 1;

    if(gb_process_ticks % 4 == 0)
    {
        HandleInterrupts();
        GB_CPU_Step();
    }

    GB_Timer_Step();
    GB_PPU_Step();
    GB_MMU_DMA_Step();

    if(GB_PPU_Vblank_Interrupt())
    {
        GB_MMU_Interrupt_Set(INT_VBLANK);

        new value = HandleInput();

        if(!g_mmu[E_BOOTROM_MAPPED] && !value)
        {
            tick_interval = 2;
        }
    }

    if(GB_PPU_Stat_Interrupt())
    {
        GB_MMU_Interrupt_Set(INT_LCD_STAT);
    }

    if(GB_Timer_Interrupt())
    {
        GB_MMU_Interrupt_Set(INT_TIMER);
    }

    gb_process_ticks++;

    return SetTimer("SAMPBOY_Process", tick_interval, false);
}

stock SAMPBOY_Start()
{
    GB_Options_Init("roms.ini"); // scriptfiles

    if(!GB_ROM_Open(g_gb_options[E_ROM_PATH]))
    {
        printf("[MAIN]: Failed to open rom file: %s", g_gb_options[E_ROM_PATH]);
        return 0;
    }

    new E_MAPPER_TYPE: mapper = GetMapperType();
    if(mapper == INVALID_MAPPER)
    {
        printf("[MAIN]: Failed to load rom: %s", g_gb_options[E_ROM_PATH]);
        return 0;
    }
    GB_Mapper_Init(mapper);

    GB_Opcodes_Init();
    GB_Opcodes_InitCB();

    GB_CPU_Init();
    GB_PPU_Init();
    GB_Timer_Init();
    GB_Serial_Init();
    GB_Joypad_Init();
    GB_MMU_Init();

    SAMPBOY_Process();

    return 1;
}

stock SAMPBOY_Stop()
{
    should_stop_timer = 1;
    gb_process_ticks = 0;
    tick_interval = 1;
}

//----------------------------------------------------
#if defined FILTERSCRIPT
public OnFilterScriptInit()
#else
public OnGameModeInit()
#endif
{
    SendRconCommand("network.acks_limit 64000");

    print("\n--------------------------------------");
    printf(" %s loaded", SCRIPT_NAME);
    printf(" Version: %d.%d.%d", VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH);
	printf(" Build time: %s ", __time);
    print("--------------------------------------\n");

    CreateGameBoyTD();

    return 1;
}

#if defined FILTERSCRIPT
public OnFilterScriptExit()
#else
public OnGameModeExit()
#endif
{
    print("\n--------------------------------------");
    printf(" %s unloaded", SCRIPT_NAME);
    print("--------------------------------------\n");

    DestroyGameBoyTD();

	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/startgb", true))
    {
        ShowGameBoyForPlayer(playerid);
        SAMPBOY_Start();
        return 1;
    }
    else if(!strcmp(cmdtext, "/stopgb", true))
    {
        SAMPBOY_Stop();
        HideGameBoyForPlayer(playerid);
        return 1;
    }
    else if(!strcmp(cmdtext, "/resetgb", true))
    {
        GB_CPU_Reset();
        GB_MMU_Reset();
        return 1;
    }

    return 0;
}

//----------------------------------------------------
main() {}