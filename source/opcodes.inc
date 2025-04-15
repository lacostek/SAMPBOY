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

// helper
stock int8_from_uint8(value)
{
	return (value > 127) ? (value - 256) : value;
}