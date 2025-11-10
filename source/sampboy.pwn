//----------------------------------------------------
//
// Description: GameBoy Emulator for SA-MP (server open.mp), powered by brickboy. 
//
// WARNING: SCRIPT SUPPORT FOR SA-MP SERVER IS NOT PROVIDED DUE TO INEFFICIENT SA-MP TIMERS
//
// Author: Roman Shadow (lacostek)
//
//----------------------------------------------------
//#define FILTERSCRIPT

#include <open.mp>

// Libs
#include "libraries/mxini.inc"

//----------------------------------------------------
// Config
#define SCRIPT_NAME     "SAMPBOY - Emulator GameBoy Classic in open.mp server"

#define VERSION_MAJOR 1
#define VERSION_MINOR 0
#define VERSION_PATCH 0
/*
#define _DEBUG
#define _ENABLE_WARNING_LOG
#define _ENABLE_CRITICAL_LOG*/
//#define DEBUG_OPCODES // - very slow


#if defined _samp_included
	#define _SAMP_SERVER_TEST
#endif

// Options
#define OPTIONS_FILE 	"roms.ini"

#define DIALOG_SELECT_ROM 31000

#define CPU_TICKS_PER_FRAME 24

//----------------------------------------------------
#include "helper.inc"
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
	should_stop_timer = 0,
	gb_player = INVALID_PLAYER_ID;

//new CPU_CYCLES_TIME;

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
				return 1;
			}
			else
			{
				g_cpu[CPU_HALTED] = false;
				return 0;
			}
		}
	}
	return 0;
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
	
	Screen_GetPlayerInput(gb_player);

	for(new i = 0; i < sizeof(buttons); i++)
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

	for(new i = 0; i < CPU_TICKS_PER_FRAME; i++)
	{
		if(gb_process_ticks % 4 == 0)
		{
			HandleInterrupts();
			GB_CPU_Step();
		}

		GB_Timer_Step();
		GB_PPU_Step();
		GB_MMU_DMA_Step();

		gb_process_ticks++;
	}

	if(GB_PPU_Vblank_Interrupt())
	{
		GB_MMU_Interrupt_Set(INT_VBLANK);

		//new value = HandleInput();
		HandleInput();

		if(!g_mmu[E_BOOTROM_MAPPED]/* && !value*/)
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

	return SetTimer("SAMPBOY_Process", tick_interval, false);
}

stock SAMPBOY_Start(const rom[])
{
	if(!GB_ROM_Open(rom))
	{
		printf("[MAIN]: Failed to open rom file: %s", rom);
		return 0;
	}

	new E_MAPPER_TYPE: mapper = GetMapperType();
	if(mapper == INVALID_MAPPER)
	{
		printf("[MAIN]: Failed to load rom: %s", rom);
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

	#if defined CPU_CYCLES_TIME
		CPU_CYCLES_TIME = GetTickCount();
	#endif
	SAMPBOY_Process();

	return 1;
}

stock SAMPBOY_Stop()
{
	should_stop_timer = 1;
	gb_process_ticks = 0;
	tick_interval = 1;
	gb_player = INVALID_PLAYER_ID;
}

stock SAMPBOY_ShowRomsList(playerid)
{
	new str[MAX_FILE_NAME * MAX_FILE_ROMS + 2 + 1];
	new buffer[MAX_FILE_NAME + 2 + 1];

	for(new i = 0; i < sizeof(g_gb_roms_list); i++)
	{
		if(g_gb_roms_list[i][0] != '\0')
		{
			format(buffer, sizeof buffer, "%s\n", g_gb_roms_list[i]);
			strcat(str, buffer);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_SELECT_ROM, DIALOG_STYLE_LIST, "Select ROM", str, "Select", "Close");
}

//----------------------------------------------------
#if defined FILTERSCRIPT
public OnFilterScriptInit()
#else
public OnGameModeInit()
#endif
{
	CreateGameBoyTD();
	GB_Options_Init(OPTIONS_FILE);

	SendRconCommand("network.acks_limit 64000");

	print("\n--------------------------------------");
	printf(" %s loaded", SCRIPT_NAME);
	printf(" Version: %d.%d.%d", VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH);
	printf(" Build time: %s ", __time);
	print("--------------------------------------\n");

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

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SELECT_ROM)
	{
		if(response)
		{
			if(g_gb_roms_list[listitem][0] != '\0')
			{
				gb_player = playerid;
				SAMPBOY_Start(g_gb_roms_list[listitem]);
			}
		}
		else
		{
			HideGameBoyForPlayer(playerid);
		}
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!strcmp(cmdtext, "/startgb", true))
	{
		ShowGameBoyForPlayer(playerid);
		SAMPBOY_ShowRomsList(playerid)

		SendClientMessage(playerid, 0xFFFFFFFF, "{FFD97A}=== GameBoy Emulator ===");
		SendClientMessage(playerid, 0xFFFFFFFF, "Commands: {FFD97A}/stopgb{FFFFFF}, {FFD97A}/resetgb{FFFFFF}, {FFD97A}/keys_control");
		SendClientMessage(playerid, 0xFFFFFFFF, "Use {FFD97A}/keys_control{FFFFFF} to enable new experimental controls!");
		SendClientMessage(playerid, 0xFFFFFFFF, "DPAD: {FFD97A}W{FFFFFF} / {FFD97A}A{FFFFFF} / {FFD97A}S{FFFFFF} / {FFD97A}D");
		SendClientMessage(playerid, 0xFFFFFFFF, "A: {FFD97A}Fire{FFFFFF} (Left Ctrl / Left Mouse Button)");
		SendClientMessage(playerid, 0xFFFFFFFF, "B: {FFD97A}Aim{FFFFFF} (Right Mouse Button)");
		SendClientMessage(playerid, 0xFFFFFFFF, "Start: {FFD97A}Crouch{FFFFFF} (C) | Select: {FFD97A}Walk{FFFFFF} (Left Alt)");

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
	else if(!strcmp(cmdtext, "/keys_control", true))
	{ 
		SetSpawnInfo(playerid, NO_TEAM, 0, 0.0, 0.0, 500.0, 0.0, WEAPON_FIST, 0, WEAPON_FIST, 0, WEAPON_FIST, 0);
		SpawnPlayer(playerid);

		TogglePlayerControllable(playerid, false);

		CancelSelectTextDraw(playerid);
		SetPVarInt(playerid, "UseNewInput", 1);

		SendClientMessage(playerid, 0xFFFFFFFF, "{FFD97A}[GameBoy]{FFFFFF} New experimental controls {FFD97A}enabled!");
		return 1;
	}

	return 0;
}

//----------------------------------------------------
main() {}