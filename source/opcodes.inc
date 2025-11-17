//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------
#if defined _GAMEBOY_OPCODES_INC
#endinput
#endif
#define _GAMEBOY_OPCODES_INC

//----------------------------------------------------
#define MAX_OPCODES_SIZE 256

//----------------------------------------------------
enum E_OPCODE_TYPE
{
	OP_NOP = 1,
	OP_DI,
	OP_EI,
	OP_DAA,
	OP_CPL,
	OP_SCF,
	OP_CCF,
	OP_HALT,
	OP_INC8,
	OP_INC16,
	OP_DEC8,
	OP_DEC16,
	OP_LD8,
	OP_LD16,
	OP_LD16_SP,
	OP_LD_HL_SP,
	OP_ADD_A,
	OP_ADD_SP,
	OP_ADD_HL,
	OP_ADC8,
	OP_SUB8,
	OP_SBC8,
	OP_AND8,
	OP_XOR8,
	OP_OR8,
	OP_CP8,
	OP_POP16,
	OP_PUSH16,
	OP_JR8,
	OP_JR8_IF,
	OP_JR8_IFN,
	OP_JP16,
	OP_JP16_IF,
	OP_JP16_IFN,
	OP_CALL,
	OP_CALL_IF,
	OP_CALL_IFN,
	OP_RET,
	OP_RETI,
	OP_RET_IF,
	OP_RET_IFN,
	OP_RST,
	OP_RLCA,
	OP_RLA,
	OP_RRCA,
	OP_RRA,
	// CB
	OP_RLC,
	OP_RRC,
	OP_RL,
	OP_RR,
	OP_SLA,
	OP_SRA,
	OP_SWAP,
	OP_SRL,
	OP_BIT,
	OP_RES,
	OP_SET
};

enum E_GB_CPU_OPCODE_INFO
{
	E_OP_CYCLES,
	E_CPU_ARG_TYPE: E_OP_ARG_1,
	E_CPU_ARG_TYPE: E_OP_ARG_2,
	E_OPCODE_TYPE: E_OP_TYPE
};

//----------------------------------------------------
new g_cpu_opcodes[MAX_OPCODES_SIZE][E_GB_CPU_OPCODE_INFO];
new g_cpu_opcodes_cb[MAX_OPCODES_SIZE][E_GB_CPU_OPCODE_INFO];

#if defined DEBUG_OPCODES
new const g_cpu_opcode_name[] = 
{
    "",                // 0
    "OP_NOP",          // 1
    "OP_DI",           // 2
    "OP_EI",           // 3
    "OP_DAA",          // 4
    "OP_CPL",          // 5
    "OP_SCF",          // 6
    "OP_CCF",          // 7
    "OP_HALT",         // 8
    "OP_INC8",         // 9
    "OP_INC16",        // 10
    "OP_DEC8",         // 11
    "OP_DEC16",        // 12
    "OP_LD8",          // 13
    "OP_LD16",         // 14
    "OP_LD16_SP",      // 15
    "OP_LD_HL_SP",     // 16
    "OP_ADD_A",        // 17
    "OP_ADD_SP",       // 18
    "OP_ADD_HL",       // 19
    "OP_ADC8",         // 20
    "OP_SUB8",         // 21
    "OP_SBC8",         // 22
    "OP_AND8",         // 23
    "OP_XOR8",         // 24
    "OP_OR8",          // 25
    "OP_CP8",          // 26
    "OP_POP16",        // 27
    "OP_PUSH16",       // 28
    "OP_JR8",          // 29
    "OP_JR8_IF",       // 30
    "OP_JR8_IFN",      // 31
    "OP_JP16",         // 32
    "OP_JP16_IF",      // 33
    "OP_JP16_IFN",     // 34
    "OP_CALL",         // 35
    "OP_CALL_IF",      // 36
    "OP_CALL_IFN",     // 37
    "OP_RET",          // 38
    "OP_RETI",         // 39
    "OP_RET_IF",       // 40
    "OP_RET_IFN",      // 41
    "OP_RST",          // 42
    "OP_RLCA",         // 43
    "OP_RLA",          // 44
    "OP_RRCA",         // 45
    "OP_RRA",          // 46
	// CB
    "OP_RLC",          // 47
    "OP_RRC",          // 48
    "OP_RL",           // 49
    "OP_RR",           // 50
    "OP_SLA",          // 51
    "OP_SRA",          // 52
    "OP_SWAP",         // 53
    "OP_SRL",          // 54
    "OP_BIT",          // 55
    "OP_RES",          // 56
    "OP_SET"           // 57
};
#endif
stock const g_cpu_arg_name[][] = 
{
    "ARG_NONE",        // 0
    "ARG_IMM_8",       // 1
    "ARG_IMM_16",      // 2
    "ARG_REG_A",       // 3
    "ARG_REG_B",       // 4
    "ARG_REG_C",       // 5
    "ARG_REG_D",       // 6
    "ARG_REG_E",       // 7
    "ARG_REG_H",       // 8
    "ARG_REG_L",       // 9
    "ARG_REG_AF",      // 10
    "ARG_REG_BC",      // 11
    "ARG_REG_DE",      // 12
    "ARG_REG_HL",      // 13
    "ARG_REG_SP",      // 14
    "ARG_IND_C",       // 15
    "ARG_IND_BC",      // 16
    "ARG_IND_DE",      // 17
    "ARG_IND_HL",      // 18
    "ARG_IND_HLI",     // 19
    "ARG_IND_HLD",     // 20
    "ARG_IND_8",       // 21
    "ARG_IND_16",      // 22
    "ARG_FLAG_ZERO",   // 23
    "ARG_FLAG_CARRY",  // 24
    "ARG_BIT_0",       // 25
    "ARG_BIT_1",       // 26
    "ARG_BIT_2",       // 27
    "ARG_BIT_3",       // 28
    "ARG_BIT_4",       // 29
    "ARG_BIT_5",       // 30
    "ARG_BIT_6",       // 31
    "ARG_BIT_7",       // 32
    "ARG_RST_0",       // 33
    "ARG_RST_1",       // 34
    "ARG_RST_2",       // 35
    "ARG_RST_3",       // 36
    "ARG_RST_4",       // 37
    "ARG_RST_5",       // 38
    "ARG_RST_6",       // 39
    "ARG_RST_7"        // 40
};