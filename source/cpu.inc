//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_CPU_INC
#endinput
#endif
#define _GAMEBOY_CPU_INC

//----------------------------------------------------
#define CPU_FLAG_CARRY       (1 << 4)
#define CPU_FLAG_HALF_CARRY  (1 << 5)
#define CPU_FLAG_NEGATIVE    (1 << 6)
#define CPU_FLAG_ZERO        (1 << 7)

//----------------------------------------------------
enum E_CPU_ARG_TYPE
{
    ARG_NONE = 0,

    // immediate values
    ARG_IMM_8,
    ARG_IMM_16,

    // 8-bit registers
    ARG_REG_A,
    ARG_REG_B,
    ARG_REG_C,
    ARG_REG_D,
    ARG_REG_E,
    ARG_REG_H,
    ARG_REG_L,

    // 16-bit registers
    ARG_REG_AF,
    ARG_REG_BC,
    ARG_REG_DE,
    ARG_REG_HL,
    ARG_REG_SP,

    // indirect (register)
    ARG_IND_C,
    ARG_IND_BC,
    ARG_IND_DE,
    ARG_IND_HL,
    ARG_IND_HLI,
    ARG_IND_HLD,

    // indirect (immediate)
    ARG_IND_8,
    ARG_IND_16,

    // cpu flags
    ARG_FLAG_ZERO,
    ARG_FLAG_CARRY,

    // individual bits (of the other operand)
    ARG_BIT_0,
    ARG_BIT_1,
    ARG_BIT_2,
    ARG_BIT_3,
    ARG_BIT_4,
    ARG_BIT_5,
    ARG_BIT_6,
    ARG_BIT_7,

    // reset addresses (for RST instruction)
    ARG_RST_0,
    ARG_RST_1,
    ARG_RST_2,
    ARG_RST_3,
    ARG_RST_4,
    ARG_RST_5,
    ARG_RST_6,
    ARG_RST_7
};

//----------------------------------------------------
enum E_CPU_STRUCT // Sharp LR35902
{
    // AF
    CPU_A, // Battery
    CPU_F, // Register flags
    // BC
    CPU_B,
    CPU_C,
    // DE
    CPU_D,
    CPU_E,
    // HL
    CPU_H,
    CPU_L,

    CPU_SP,        // 16-bit Stack Pointer
    CPU_PC,        // 16-bit Program Counter
    CPU_IME,       // 8-bit Interrupt Master Enable

    CPU_STEP,      // 8-bit CPU step
    CPU_CYCLE[2],  // 64-bit cycle (two 32-bit integers)
    CPU_IME_DELAY, // 8-bit IME delay
    CPU_HALTED     // 8-bit CPU state (halted or not)
};

new g_cpu[E_CPU_STRUCT];

//----------------------------------------------------
#define CPU_GET_AF(%0) ((%0[CPU_A] << 8) | %0[CPU_F])
#define CPU_GET_BC(%0) ((%0[CPU_B] << 8) | %0[CPU_C])
#define CPU_GET_DE(%0) ((%0[CPU_D] << 8) | %0[CPU_E])
#define CPU_GET_HL(%0) ((%0[CPU_H] << 8) | %0[CPU_L])

#define CPU_SET_AF(%0,%1) \
    %0[CPU_A] = (%1 >> 8) & 0xFF; \
    %0[CPU_F] = %1 & 0xF0

#define CPU_SET_BC(%0,%1) \
    %0[CPU_B] = (%1 >> 8) & 0xFF; \
    %0[CPU_C] = %1 & 0xFF

#define CPU_SET_DE(%0,%1) \
    %0[CPU_D] = (%1 >> 8) & 0xFF; \
    %0[CPU_E] = %1 & 0xFF

#define CPU_SET_HL(%0,%1) \
    %0[CPU_H] = (%1 >> 8) & 0xFF; \
    %0[CPU_L] = %1 & 0xFF

// Getters
stock CPU_GetZeroFlag()
{
    return (g_cpu[CPU_F] & CPU_FLAG_ZERO) ? 1 : 0;
}

stock CPU_GetNegativeFlag()
{
    return (g_cpu[CPU_F] & CPU_FLAG_NEGATIVE) ? 1 : 0;
}

stock CPU_GetHalfCarryFlag()
{
    return (g_cpu[CPU_F] & CPU_FLAG_HALF_CARRY) ? 1 : 0;
}

stock CPU_GetCarryFlag()
{
    return (g_cpu[CPU_F] & CPU_FLAG_CARRY) ? 1 : 0;
}

// Setters
stock CPU_SetZeroFlag(value) 
{
    if(value) 
        g_cpu[CPU_F] |= CPU_FLAG_ZERO;
    else 
        g_cpu[CPU_F] &= ~CPU_FLAG_ZERO;
}

stock CPU_SetNegativeFlag(value) 
{
    if(value) 
        g_cpu[CPU_F] |= CPU_FLAG_NEGATIVE;
    else 
        g_cpu[CPU_F] &= ~CPU_FLAG_NEGATIVE;
}

stock CPU_SetHalfCarryFlag(value) 
{
    if(value) 
        g_cpu[CPU_F] |= CPU_FLAG_HALF_CARRY;
    else 
        g_cpu[CPU_F] &= ~CPU_FLAG_HALF_CARRY;
}

stock CPU_SetCarryFlag(value)
{
    if(value) 
        g_cpu[CPU_F] |= CPU_FLAG_CARRY;
    else 
        g_cpu[CPU_F] &= ~CPU_FLAG_CARRY;
}