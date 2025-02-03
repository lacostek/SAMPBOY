//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_PPU_STABLE
#endinput
#endif
#define _GAMEBOY_PPU_STABLE

//----------------------------------------------------
#define STAT_MODE      (0)
#define STAT_LYC_LY    (2)
#define STAT_HBLANK    (3)
#define STAT_VBLANK    (4)
#define STAT_OAM       (5)
#define STAT_LYC       (6)

#define LCDC_BG_ENABLE    (0)
#define LCDC_OBJ_ENABLE   (1)
#define LCDC_OBJ_SIZE     (2)
#define LCDC_BG_TILEMAP   (3)
#define LCDC_BG_TILEDATA  (4)
#define LCDC_WIN_ENABLE   (5)
#define LCDC_WIN_TILEMAP  (6)
#define LCDC_LCD_ENABLE   (7)

#define SPRITE_FLAG_PALETTE   (4)
#define SPRITE_FLAG_XFLIP     (5)
#define SPRITE_FLAG_YFLIP     (6)
#define SPRITE_FLAG_PRIORITY  (7)

#if !defined SCREEN_WIDTH
    #define SCREEN_WIDTH   160
#endif

#if !defined SCREEN_HEIGHT
    #define SCREEN_HEIGHT  144
#endif

//----------------------------------------------------
enum E_GB_PPU_MODE
{
    PPU_MODE_HBLANK = 0,
    PPU_MODE_VBLANK = 1,
    PPU_MODE_OAM_SCAN = 2,
    PPU_MODE_PIXEL_DRAW = 3
};

enum E_SPRITE_STRUCT 
{
    SPRITE_Y,
    SPRITE_X,
    SPRITE_TILE_ID,
    SPRITE_FLAGS
};

enum E_GB_PPU_STRUCT
{
    E_PPU_VRAM[0x2000],
    E_PPU_OAM[0xA0],

    E_PPU_LCDC,
    E_PPU_STAT,

    E_SCY,
    E_SCX,
    E_LY,
    E_LYC,
    E_DMA,
    E_BGP,
    E_OBP0,
    E_OBP1,
    E_WY,
    E_WX,

    bool: E_VBLANK_INTERRUPT,
    bool: E_STAT_INTERRUPT,
    E_LINE_TICKS
};

//----------------------------------------------------
new g_ppu[E_GB_PPU_STRUCT];

//----------------------------------------------------
stock STAT_Get(bit)
{
    return g_ppu[E_PPU_STAT] & ((bit == STAT_MODE) ? 0b11 : (1 << bit));
}

stock STAT_Set(bit, value)
{
    new stat = g_ppu[E_PPU_STAT];

    g_ppu[E_PPU_STAT] = bit == STAT_MODE ? ((stat & ~0b11) | (value & 0b11)) : (value ? (stat | (1 << bit)) : (stat & ~(1 << bit)));
}

stock LCDC_Get(bit)
{
    return g_ppu[E_PPU_LCDC] & (1 << bit);
}

stock Sprite_Get(const sprite[E_SPRITE_STRUCT], bit)
{
    return sprite[SPRITE_FLAGS] & (1 << bit);
}

//----------------------------------------------------
stock GB_PPU_Init()
{
    GB_PPU_Reset();
}

stock GB_PPU_Reset()
{
    for(new i = 0; i < sizeof(g_ppu[E_PPU_VRAM]); i++)
    {
        g_ppu[E_PPU_VRAM][i] = 0x00;
    }

    for(new i = 0; i < sizeof(g_ppu[E_PPU_OAM]); i++)
    {
        g_ppu[E_PPU_OAM][i] = 0x00;
    }

    g_ppu[E_PPU_LCDC] = 0x91;
    g_ppu[E_PPU_STAT] = 0;

    g_ppu[E_SCX] =
    g_ppu[E_SCY] =
    g_ppu[E_LY] =
    g_ppu[E_LYC] =
    g_ppu[E_DMA] =
    g_ppu[E_WX] =
    g_ppu[E_WY] = 0;
}

stock GB_PPU_Read(address)
{
    switch(address)
    {
        case 0x8000..0x9FFF: // VRAM
        {
            //return g_ppu[E_PPU_VRAM][address & 0x1FFF];
            return g_ppu[E_PPU_VRAM][address - 0x8000];
        }
        case 0xFE00..0xFE9F: // OAM
        {
            //return g_ppu[E_PPU_OAM][address & 0x9F];
            return g_ppu[E_PPU_OAM][address - 0xFE00];
        }
        case 0xFF40: // LCDC
        {
            return g_ppu[E_PPU_LCDC];
        }
        case 0xFF41: // STAT
        {
            return g_ppu[E_PPU_STAT];
        }
        case 0xFF42: // SCY
        {
            return g_ppu[E_SCY];
        }
        case 0xFF43: // SCX
        {
            return g_ppu[E_SCX];
        }
        case 0xFF44: // LY
        {
            return g_ppu[E_LY];
        }
        case 0xFF45: // LYC
        {
            return g_ppu[E_LYC];
        }
        case 0xFF46: // DMA
        {
            return g_ppu[E_DMA];
        }
        case 0xFF47: // BGP
        {
            return g_ppu[E_BGP];
        }
        case 0xFF48: // OBP0
        {
            return g_ppu[E_OBP0];
        }
        case 0xFF49: // OBP1
        {
            return g_ppu[E_OBP1];
        }
        case 0xFF4A: // WY
        {
            return g_ppu[E_WY];
        }
        case 0xFF4B: // WX
        {
            return g_ppu[E_WX];
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[PPU]: unhandled read from 0x%04x", address);
            return 0;
        }
#endif
    }
    return 0;
}

stock GB_PPU_Read_VRAM(address)
{
    new vram_addr = address - 0x8000;
    if(vram_addr >= sizeof(g_ppu[E_PPU_VRAM]))
    {
        #if defined _ENABLE_WARNING_LOG
            printf("[PPU]: invalid VRAM address: 0x%04x", address);
        #endif
        return 0;
    }
    return g_ppu[E_PPU_VRAM][vram_addr];
}

stock GB_PPU_Write_OAM(address, value)
{
    g_ppu[E_PPU_OAM][address] = value;
}

stock GB_PPU_Write(address, value)
{
    switch(address)
    {
        case 0x8000..0x9FFF: // VRAM
        {
            //g_ppu[E_PPU_VRAM][address & 0x1FFF] = value;
            g_ppu[E_PPU_VRAM][address - 0x8000] = value;
        }
        case 0xFE00..0xFE9F: // OAM
        {
            //g_ppu[E_PPU_OAM][address & 0x9F] = value;
            g_ppu[E_PPU_OAM][address - 0xFE00] = value;
        }
        case 0xFF40: // LCDC
        {
            g_ppu[E_PPU_LCDC] = value;
        }
        case 0xFF41: // STAT
        {
            g_ppu[E_PPU_STAT] = (g_ppu[E_PPU_STAT] & 0x7) | (value & ~0x07);
        }
        case 0xFF42: // SCY
        {
            g_ppu[E_SCY] = value;
        }
        case 0xFF43: // SCX
        {
            g_ppu[E_SCX] = value;
        }
        case 0xFF45: // LYC
        {
            g_ppu[E_LYC] = value;
        }
        case 0xFF46: // DMA
        {
            g_ppu[E_DMA] = value;
        }
        case 0xFF47: // BGP
        {
            g_ppu[E_BGP] = value;
        }
        case 0xFF48: // OBP0
        {
            g_ppu[E_OBP0] = value;
        }
        case 0xFF49: // OBP1
        {
            g_ppu[E_OBP1] = value;
        }
        case 0xFF4A: // WY
        {
            g_ppu[E_WY] = value;
        }
        case 0xFF4B: // WX
        {
            g_ppu[E_WX] = value;
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[PPU]: unhandled write to 0x%04x", address);
            return 0;
        }
#endif
    }
    return 0;
}

stock GB_PPU_TileAddress(tile_id)
{
    new address = LCDC_Get(LCDC_BG_TILEDATA) ? 0x8000 : 0x9000;
    return address + tile_id * 16;
}

stock GB_PPU_GetColorID(d0, d1, x)
{
    new bit0 = (d0 >> x) & 1;
    new bit1 = (d1 >> x) & 1;
    return (bit1 << 1) | bit0;
}

stock GB_PPU_FetchTileLine(tile_map, tile_y, tile_x, pixel_y, pixels[8])
{
    new tile_map_addr = tile_map + (tile_y << 5) + tile_x; 
    new tile_id = GB_PPU_Read_VRAM(tile_map_addr);
    new tile_addr = GB_PPU_TileAddress(tile_id);

    new row_addr = tile_addr + (pixel_y << 1);
    new d0 = GB_PPU_Read_VRAM(row_addr);
    new d1 = GB_PPU_Read_VRAM(row_addr + 1);

    for(new x = 0; x < 8; x++)
    {
        pixels[7 - x] = GB_PPU_GetColorID(d0, d1, x);
    }
}

stock GB_PPU_RenderBackground()
{
    new tile_map = LCDC_Get(LCDC_BG_TILEMAP) ? 0x9C00 : 0x9800;
    new screen_y = g_ppu[E_LY];

    new tile_y = ((g_ppu[E_LY] + g_ppu[E_SCY]) / 8) % 32;
    new pixel_y = (g_ppu[E_LY] + g_ppu[E_SCY]) % 8;

    new tile_line[8] = 0;
    new last_tile_x = -1;

    for(new screen_x = 0; screen_x < SCREEN_WIDTH; screen_x++)
    {
        new tile_x = ((g_ppu[E_SCX] + screen_x) / 8) % 32;
        new pixel_x = (g_ppu[E_SCX] + screen_x) % 8;

        if(tile_x != last_tile_x)
        {
            GB_PPU_FetchTileLine(tile_map, tile_y, tile_x, pixel_y, tile_line);
            last_tile_x = tile_x;
        }

        new color_id = tile_line[pixel_x];
        new color = (g_ppu[E_BGP] >> (color_id * 2)) & 0x3;

        Screen_SetPixelColor(screen_x, screen_y, color);
    }
}

stock GB_PPU_RenderWindow()
{
    if(g_ppu[E_LY] < g_ppu[E_WY])
        return 0;

    new tile_map = LCDC_Get(LCDC_WIN_TILEMAP) ? 0x9C00 : 0x9800;
    new tile_y = ((g_ppu[E_LY] - g_ppu[E_WY]) / 8) % 32;
    new pixel_y = (g_ppu[E_LY] - g_ppu[E_WY]) % 8;
    new screen_y = g_ppu[E_LY];
    
    new tile_line[8] = 0;
    new last_tile_x = -1;

    for(new screen_x = 0; screen_x < SCREEN_WIDTH; screen_x++)
    {
        if((screen_x + 7) < g_ppu[E_WX])
            continue;

        new tile_x = (((screen_x + 7) - g_ppu[E_WX]) / 8) % 32;
        new pixel_x = ((screen_x + 7) - g_ppu[E_WX]) % 8;

        if(tile_x != last_tile_x)
        {
            GB_PPU_FetchTileLine(tile_map, tile_y, tile_x, pixel_y, tile_line);
            last_tile_x = tile_x;
        }

        new color_id = tile_line[pixel_x];
        new color = (g_ppu[E_BGP] >> (color_id * 2)) & 0x3;

        Screen_SetPixelColor(screen_x, screen_y, color);
    }

    return 1;
}

stock GB_PPU_GetSprite(index, sprite[E_SPRITE_STRUCT])
{
    sprite[SPRITE_Y] =          g_ppu[E_PPU_OAM][index];
    sprite[SPRITE_X] =          g_ppu[E_PPU_OAM][index + 1];
    sprite[SPRITE_TILE_ID] =    g_ppu[E_PPU_OAM][index + 2];
    sprite[SPRITE_FLAGS] =      g_ppu[E_PPU_OAM][index + 3];
}

stock GB_PPU_RenderSprites()
{
    new screen_y = g_ppu[E_LY];

    if(screen_y >= SCREEN_HEIGHT)
        return 0;

    new height = LCDC_Get(LCDC_OBJ_SIZE) ? 16 : 8;
    new sprite[E_SPRITE_STRUCT];

    for(new i = 0; i < 40; i++)
    {
        GB_PPU_GetSprite(i * 4, sprite);
        new real_sprite_y = sprite[SPRITE_Y] - 16;

        if(real_sprite_y > screen_y || real_sprite_y + height <= screen_y)
            continue;

        new y = screen_y - real_sprite_y;
        new y_flip = Sprite_Get(sprite, SPRITE_FLAG_YFLIP) ? (height - 1 - y) : (y);
        new tile_addr = (0x8000 + (sprite[SPRITE_TILE_ID] * 16) + (y_flip * 2));
        new palette = Sprite_Get(sprite, SPRITE_FLAG_PALETTE) ? g_ppu[E_OBP1] : g_ppu[E_OBP0];

        new d0 = GB_PPU_Read_VRAM(tile_addr);
        new d1 = GB_PPU_Read_VRAM(tile_addr + 1);

        for(new p = 0; p < 8; p++)
        {
            new x_flip = Sprite_Get(sprite, SPRITE_FLAG_XFLIP) ? p : 7 - p;
            new screen_x = (sprite[SPRITE_X] - 8) + x_flip;

            if(screen_x >= SCREEN_WIDTH)
                break;

            new color_id = GB_PPU_GetColorID(d0, d1, p);
            
            if(color_id == 0)
                continue;

            new color = (palette >> (color_id * 2)) & 0x3;
            Screen_SetPixelColor(screen_x, screen_y, color);
        }
    }
    return 1;
}

stock GB_PPU_RenderScanline()
{
    if(LCDC_Get(LCDC_BG_ENABLE))
    {
        GB_PPU_RenderBackground();

        if(LCDC_Get(LCDC_WIN_ENABLE))
        {
            GB_PPU_RenderWindow();
        }
    }

    if(LCDC_Get(LCDC_OBJ_ENABLE))
    {
        GB_PPU_RenderSprites();
    }
}

stock GB_PPU_SetMode(E_GB_PPU_MODE: mode)
{
    switch(mode)
    {
        case PPU_MODE_OAM_SCAN:
        {
            if(STAT_Get(STAT_OAM))
            {
                g_ppu[E_STAT_INTERRUPT] = true;
            }
        } 
        case PPU_MODE_VBLANK:
        {
            if(STAT_Get(STAT_VBLANK))
            {
                g_ppu[E_STAT_INTERRUPT] = true;
            }
        } 
        case PPU_MODE_HBLANK:
        {
            if(STAT_Get(STAT_HBLANK))
            {
                g_ppu[E_STAT_INTERRUPT] = true;
            }
        }
        case PPU_MODE_PIXEL_DRAW: {}
    }

    STAT_Set(STAT_MODE, _:mode);
}

stock GB_PPU_LY_Increment()
{
    g_ppu[E_LY]++;
    if(g_ppu[E_LY] == g_ppu[E_LYC])
    {
        STAT_Set(STAT_LYC_LY, 1);
        if(STAT_Get(STAT_LYC))
        {
            g_ppu[E_STAT_INTERRUPT] = true 
        }
    }
    else
    {
        STAT_Set(STAT_LYC_LY, 0);
    }
}

stock GB_PPU_Step_OAM_Scan()
{
    if(g_ppu[E_LINE_TICKS] == 80)
    {
        GB_PPU_SetMode(PPU_MODE_PIXEL_DRAW);
    }
}

stock GB_PPU_Step_Pixel_Draw()
{
    if(g_ppu[E_LINE_TICKS] == 252)
    {
        GB_PPU_SetMode(PPU_MODE_HBLANK);
        GB_PPU_RenderScanline();
    }
}

stock GB_PPU_Step_HBlank()
{
    if(g_ppu[E_LINE_TICKS] == 456)
    {
        GB_PPU_LY_Increment();
        g_ppu[E_LINE_TICKS] = 0;
        
        if(g_ppu[E_LY] == 144)
        {
            g_ppu[E_VBLANK_INTERRUPT] = true;
            GB_PPU_SetMode(PPU_MODE_VBLANK);
        }
        else
        {
            GB_PPU_SetMode(PPU_MODE_OAM_SCAN);
        }
    }
}

stock GB_PPU_Step_VBlank()
{
    if(g_ppu[E_LINE_TICKS] == 456)
    {
        GB_PPU_LY_Increment();
        g_ppu[E_LINE_TICKS] = 0; 
        
        if(g_ppu[E_LY] == 153)
        {
            GB_PPU_SetMode(PPU_MODE_OAM_SCAN);
            g_ppu[E_LY] = 0;
        }
    }
}

stock GB_PPU_Step()
{
    g_ppu[E_LINE_TICKS]++;

    switch(E_GB_PPU_MODE: STAT_Get(STAT_MODE))
    {
        case PPU_MODE_OAM_SCAN:
        {
            GB_PPU_Step_OAM_Scan();
        }
        case PPU_MODE_PIXEL_DRAW:
        {
            GB_PPU_Step_Pixel_Draw();
        }
        case PPU_MODE_HBLANK:
        {
            GB_PPU_Step_HBlank();
        }
        case PPU_MODE_VBLANK:
        {
            GB_PPU_Step_VBlank();
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[PPU]: invalid PPU mode %d", STAT_Get(STAT_MODE));
            return 0;
        }
#endif
    }
    return 0;
}

stock GB_PPU_Stat_Interrupt()
{
    if(g_ppu[E_STAT_INTERRUPT])
    {
        g_ppu[E_STAT_INTERRUPT] = false;
        return 1;
    }
    return 0;
}

stock GB_PPU_Vblank_Interrupt()
{
    if(g_ppu[E_VBLANK_INTERRUPT])
    {
        g_ppu[E_VBLANK_INTERRUPT] = false;
        return 1;
    }
    return 0;
}