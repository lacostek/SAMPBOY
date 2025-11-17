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
#define MAX_RAM_SIZE 128 * 1024 // MBC5

//----------------------------------------------------
enum E_MAPPER_TYPE
{
	INVALID_MAPPER = 0,
	// ---------------
	MAPPER_MBC0,
	MAPPER_MBC1,
	MAPPER_MBC2,
	MAPPER_MBC3,
	MAPPER_MBC5
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
	E_MODE_SELECT,

	// MBC3 RealTimeClock
	E_RTC_SEC,
	E_RTC_MIN,
	E_RTC_HOUR,
	E_RTC_DL,
	E_RTC_DH
};

new g_mapper[E_GB_MAPPER_STRUCT];

//----------------------------------------------------
stock GB_Mapper_Init(E_MAPPER_TYPE:type)
{
	g_mapper[E_TYPE] = type;
	g_mapper[E_ROM] = g_rom;

	switch(type)
	{
		case MAPPER_MBC1: GB_MBC1_Init();
		case MAPPER_MBC2: GB_MBC2_Init();
		case MAPPER_MBC3: GB_MBC3_Init();
		case MAPPER_MBC5: GB_MBC5_Init();
	}
}

stock GB_Mapper_Write(address, value)
{
	switch(g_mapper[E_TYPE])
	{
		case MAPPER_MBC1: return GB_MBC1_Write(address, value);
		case MAPPER_MBC2: return GB_MBC2_Write(address, value);
		case MAPPER_MBC3: return GB_MBC3_Write(address, value);
		case MAPPER_MBC5: return GB_MBC5_Write(address, value);
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
		case MAPPER_MBC3: return GB_MBC3_Read(address);
		case MAPPER_MBC5: return GB_MBC5_Read(address);
	}
	return GB_MBC0_Read(address);
}

stock GB_Mapper_Reset()
{
	switch(g_mapper[E_TYPE])
	{
		case MAPPER_MBC1: GB_MBC1_Reset();
		case MAPPER_MBC2: GB_MBC2_Reset();
		case MAPPER_MBC3: GB_MBC3_Reset();
		case MAPPER_MBC5: GB_MBC5_Reset();
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
stock GB_MBC1_Init()
{
	g_mapper[E_RAM_SIZE] = g_rom[E_RAM_SIZE];
	g_mapper[E_HAS_BATTERY] = (g_rom[E_HEADER][E_TYPE] == _:ROM_TYPE_MBC1_RAM_BATT);

	GB_MBC1_Reset();
}

stock GB_MBC1_Reset()
{
	g_mapper[E_RAM_ENABLED] = false;
	g_mapper[E_ROM_BANK] = 1;
	g_mapper[E_RAM_BANK] = 0;
}

stock GB_MBC1_Read(address)
{
	switch(address)
	{
		case 0x0000..0x3FFF: // ROM bank 0 (fixed)
		{
			return g_mapper[E_ROM][E_DATA][address];
		}
		case 0x4000..0x7FFF: // ROM bank 1-31
		{
			new rom_addr = (ROM_BANK_SIZE * g_mapper[E_ROM_BANK]) + (address - 0x4000);

			if(rom_addr >= g_mapper[E_ROM][E_ROM_SIZE])
			{
				#if defined _ENABLE_CRITICAL_LOG
					printf("[MBC1]: index out of bounds: %d", rom_addr);
				#endif
				return 0xFF;
			}
			return g_mapper[E_ROM][E_DATA][rom_addr];
		}
		case 0xA000..0xBFFF: // RAM bank
		{
			if(g_mapper[E_RAM_ENABLED])
			{
				new ram_addr = (RAM_BANK_SIZE * g_mapper[E_RAM_BANK]) + (address - 0xA000);
				return g_mapper[E_RAM][ram_addr % g_mapper[E_RAM_SIZE]];
			}
			return 0xFF;
		}
#if defined _ENABLE_WARNING_LOG
		default:
		{
			printf("[MBC1]: unknown read address: 0x%04x", address);
			return 0xFF;
		}
#endif
	}
	return 0xFF;
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
				new ram_addr = (RAM_BANK_SIZE * g_mapper[E_RAM_BANK]) + (address - 0xA000);
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
stock GB_MBC2_Init()
{
	g_mapper[E_RAM_SIZE] = 0x200;
	g_mapper[E_HAS_BATTERY] = (g_rom[E_HEADER][E_TYPE] == _:ROM_TYPE_MBC2_BATT);

    GB_MBC2_Reset();
}

stock GB_MBC2_Reset()
{
	g_mapper[E_RAM_ENABLED] = false;
	g_mapper[E_ROM_BANK] = 1;
}

stock GB_MBC2_Read(address)
{
	switch(address)
	{
		case 0x0000..0x3FFF: // ROM Bank 00 (Read Only)
		{
			return g_mapper[E_ROM][E_DATA][address];
		}
		case 0x4000..0x7FFF: // ROM Bank 01-0F (Read Only)
		{
			new rom_addr = (ROM_BANK_SIZE * g_mapper[E_ROM_BANK]) + (address - 0x4000);

			if(rom_addr >= g_mapper[E_ROM][E_ROM_SIZE])
			{
				printf("[MBC2]: index out of bounds: %d", rom_addr);
				return 0xFF;
			}
			return g_mapper[E_ROM][E_DATA][rom_addr];
		}
		case 0xA000..0xA1FF: // 512x4bits RAM, built-in into the MBC2 chip (Read/Write)
		{
			if(!g_mapper[E_RAM_ENABLED])
                return 0xFF;

            return (g_mapper[E_RAM][address - 0xA000] & 0x0F) | 0xF0;
		}
	}
    return 0xFF;
}

stock GB_MBC2_Write(address, value)
{
	switch(address)
	{
		case 0x0000..0x3FFF: // RAM Enable (Write Only 0x0000..0x1FFF) / ROM Bank Number (Write Only 0x2000..0x3FFF)
		{
			if((address & 0x0100) == 0)
                g_mapper[E_RAM_ENABLED] = (value & 0x0F) == 0x0A;
			else
			{
				g_mapper[E_ROM_BANK] = value & 0x0F;

                if(g_mapper[E_ROM_BANK] == 0)
                    g_mapper[E_ROM_BANK] = 1;
			}
		}
		case 0xA000..0xA1FF: // 512x4bits RAM, built-in into the MBC2 chip (Read/Write)
		{
			if(!g_mapper[E_RAM_ENABLED])
                return 0;

            g_mapper[E_RAM][address - 0xA000] = value & 0x0F;
		}
	}
	return 1;
}

// ---------------------------------------------------------------------------------------
// -----------------------------------------MBC3------------------------------------------
// ---------------------------------------------------------------------------------------
stock GB_MBC3_Init()
{
	g_mapper[E_RAM_SIZE] = g_rom[E_RAM_SIZE];

	switch(E_GB_ROM_TYPE: g_rom[E_HEADER][E_TYPE])
	{
		case ROM_TYPE_MBC3_TIMER_BATT, ROM_TYPE_MBC3_TIMER_RAM_BATT, ROM_TYPE_MBC3_RAM_BATT:
			g_mapper[E_HAS_BATTERY] = true;
	}

    GB_MBC3_Reset();
}

stock GB_MBC3_Reset()
{
	g_mapper[E_RAM_ENABLED] = false;
	g_mapper[E_ROM_BANK] = 1;
	g_mapper[E_RAM_BANK] = 0;
}

stock GB_MBC3_Read(address)
{
	switch(address)
	{
		case 0x0000..0x3FFF: // ROM Bank 00 (Read Only)
		{
			return g_mapper[E_ROM][E_DATA][address];
		}
		case 0x4000..0x7FFF: // ROM Bank 01-0F (Read Only)
		{
			new rom_addr = (ROM_BANK_SIZE * g_mapper[E_ROM_BANK]) + (address - 0x4000);

			if(rom_addr >= g_mapper[E_ROM][E_ROM_SIZE])
			{
				printf("[MBC3]: index out of bounds: %d", rom_addr);
				return 0xFF;
			}
			return g_mapper[E_ROM][E_DATA][rom_addr];
		}
		case 0xA000..0xBFFF: // RAM Bank 00-03 or RTC Register 08-0C (Read/Write)
		{
			if(g_mapper[E_RAM_ENABLED])
			{	
				switch(g_mapper[E_RAM_BANK])
				{
					case 0x00..0x03:
					{
						new ram_addr = (RAM_BANK_SIZE * g_mapper[E_RAM_BANK]) + (address - 0xA000);
						return g_mapper[E_RAM][ram_addr];
					}
					case 0x08: return g_mapper[E_RTC_SEC];
					case 0x09: return g_mapper[E_RTC_MIN];
					case 0x0A: return g_mapper[E_RTC_HOUR];
					case 0x0B: return g_mapper[E_RTC_DL];
					case 0x0C: return g_mapper[E_RTC_DH];
				}
			}
			return 0xFF;
		}
	}
	return 0xFF;
}

stock GB_MBC3_Write(address, value)
{
	switch(address)
	{
		case 0x0000..0x1FFF: // RAM and Timer Enable (Write Only)
		{
			g_mapper[E_RAM_ENABLED] = value == 0x0A;
		}
		case 0x2000..0x3FFF: // ROM Bank Number (Write Only)
		{
			g_mapper[E_ROM_BANK] = value & 0x7F;

			if(g_mapper[E_ROM_BANK] == 0)
				g_mapper[E_ROM_BANK] = 1;
		}
		case 0x4000..0x5FFF: // RAM Bank Number or RTC Register Select (Write Only)
		{
			g_mapper[E_RAM_BANK] = value;
		}
		case 0x6000..0x7FFF: // Latch Clock Data (Write Only)
		{
			gettime(g_mapper[E_RTC_HOUR], g_mapper[E_RTC_MIN], g_mapper[E_RTC_SEC]);
		}
		case 0xA000..0xBFFF: // RAM Bank 00-03 or RTC Register 08-0C (Read/Write)
		{
			if(g_mapper[E_RAM_ENABLED])
			{	
				switch(g_mapper[E_RAM_BANK])
				{
					case 0x00..0x03:
					{
						new ram_addr = (RAM_BANK_SIZE * g_mapper[E_RAM_BANK]) + (address - 0xA000);
						g_mapper[E_RAM][ram_addr] = value;
					}
					case 0x08: g_mapper[E_RTC_SEC] = value;
					case 0x09: g_mapper[E_RTC_MIN] = value;
					case 0x0A: g_mapper[E_RTC_HOUR] = value;
					case 0x0B: g_mapper[E_RTC_DL] = value;
					case 0x0C: g_mapper[E_RTC_DH] = value;
				}
			}
		}
	}
	return 1;
}

// ---------------------------------------------------------------------------------------
// -----------------------------------------MBC5------------------------------------------
// ---------------------------------------------------------------------------------------
stock GB_MBC5_Init()
{
	g_mapper[E_RAM_SIZE] = g_rom[E_RAM_SIZE];
	g_mapper[E_HAS_BATTERY] = (g_rom[E_HEADER][E_TYPE] == _:ROM_TYPE_MBC5_RAM_BATT);

    GB_MBC5_Reset();
}

stock GB_MBC5_Reset()
{
	g_mapper[E_RAM_ENABLED] = false;
	g_mapper[E_ROM_BANK] = 1;
	g_mapper[E_RAM_BANK] = 0;
}

stock GB_MBC5_Read(address)
{
	switch(address)
	{
		case 0x0000..0x3FFF: // ROM Bank 00 (Read Only)
		{
			return g_mapper[E_ROM][E_DATA][address];
		}
		case 0x4000..0x7FFF: // ROM Bank 00-1FF (Read Only)
		{
			new rom_addr = (ROM_BANK_SIZE * g_mapper[E_ROM_BANK]) + (address - 0x4000);

			if(rom_addr >= g_mapper[E_ROM][E_ROM_SIZE])
			{
				printf("[MBC5]: index out of bounds: %d", rom_addr);
				return 0xFF;
			}
			return g_mapper[E_ROM][E_DATA][rom_addr];
		}
		case 0xA000..0xBFFF: // RAM Bank 00-0F (Read/Write)
		{
			if(g_mapper[E_RAM_ENABLED])
			{
				new ram_addr = (RAM_BANK_SIZE * g_mapper[E_RAM_BANK]) + (address - 0xA000);
				return g_mapper[E_RAM][ram_addr];
			}
		}
	}
	return 0xFF;
}

stock GB_MBC5_Write(address, value)
{
	switch(address)
	{
        case 0x0000..0x1FFF: // RAM Enable (Write Only)
        {
			g_mapper[E_RAM_ENABLED] = value == 0x0A;
        }
        case 0x2000..0x2FFF: // Low 8 bits of ROM Bank Number (Write Only)
        {
			g_mapper[E_ROM_BANK] = (g_mapper[E_ROM_BANK] & 0x100) | value;
        }
        case 0x3000..0x3FFF: // High bit of ROM Bank Number (Write Only)
        {
			g_mapper[E_ROM_BANK] = (g_mapper[E_ROM_BANK] & 0xFF) | ((value & 1) << 8);
        }
        case 0x4000..0x5FFF: // RAM Bank Number (Write Only)
        {
			g_mapper[E_RAM_BANK] = value & 0xF;
        }
        case 0xA000..0xBFFF: // RAM Bank 00-0F (Read/Write)
        {
			if(g_mapper[E_RAM_ENABLED])
			{
				new ram_addr = (RAM_BANK_SIZE * g_mapper[E_RAM_BANK]) + (address - 0xA000);
				g_mapper[E_RAM][ram_addr] = value;
			}
        }
	}
	return 1;
}