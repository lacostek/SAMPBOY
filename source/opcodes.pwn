//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_OPCODES
#endinput
#endif
#define _GAMEBOY_OPCODES

//----------------------------------------------------
#define AddOpcodeMacro(%0,%1,%2,%3,%4,%5) \
    %0[%1][E_OP_CYCLES] = %2, \
    %0[%1][E_OP_ARG_1] = E_CPU_ARG_TYPE:%3, \
    %0[%1][E_OP_ARG_2] = E_CPU_ARG_TYPE:%4, \
    %0[%1][E_OP_TYPE] = E_OPCODE_TYPE:%5

#define AddOpcode(%0,%1,%2,%3,%4) \
    AddOpcodeMacro(g_cpu_opcodes,%0,%1,%2,%3,%4)

#define AddOpcodeCB(%0,%1,%2,%3,%4) \
    AddOpcodeMacro(g_cpu_opcodes_cb,%0,%1,%2,%3,%4)

stock GB_Opcodes_Init()
{
    AddOpcode(0x00, 1, ARG_NONE, ARG_NONE, OP_NOP);
    AddOpcode(0xF3, 1, ARG_NONE, ARG_NONE, OP_DI);
    AddOpcode(0xFB, 1, ARG_NONE, ARG_NONE, OP_EI);
    AddOpcode(0x27, 1, ARG_NONE, ARG_NONE, OP_DAA);
    AddOpcode(0x2F, 1, ARG_NONE, ARG_NONE, OP_CPL);
    AddOpcode(0x37, 1, ARG_NONE, ARG_NONE, OP_SCF);
    AddOpcode(0x3F, 1, ARG_NONE, ARG_NONE, OP_CCF);
    AddOpcode(0x76, 1, ARG_NONE, ARG_NONE, OP_HALT);

    AddOpcode(0x04, 1, ARG_REG_B, ARG_NONE, OP_INC8);
    AddOpcode(0x0C, 1, ARG_REG_C, ARG_NONE, OP_INC8);
    AddOpcode(0x14, 1, ARG_REG_D, ARG_NONE, OP_INC8);
    AddOpcode(0x1C, 1, ARG_REG_E, ARG_NONE, OP_INC8);
    AddOpcode(0x24, 1, ARG_REG_H, ARG_NONE, OP_INC8);
    AddOpcode(0x2C, 1, ARG_REG_L, ARG_NONE, OP_INC8);
    AddOpcode(0x3C, 1, ARG_REG_A, ARG_NONE, OP_INC8);
    AddOpcode(0x34, 3, ARG_IND_HL, ARG_NONE, OP_INC8);

    AddOpcode(0x03, 2, ARG_REG_BC, ARG_NONE, OP_INC16);
    AddOpcode(0x13, 2, ARG_REG_DE, ARG_NONE, OP_INC16);
    AddOpcode(0x23, 2, ARG_REG_HL, ARG_NONE, OP_INC16);
    AddOpcode(0x33, 2, ARG_REG_SP, ARG_NONE, OP_INC16);

    AddOpcode(0x05, 1, ARG_REG_B, ARG_NONE, OP_DEC8);
    AddOpcode(0x0D, 1, ARG_REG_C, ARG_NONE, OP_DEC8);
    AddOpcode(0x15, 1, ARG_REG_D, ARG_NONE, OP_DEC8);
    AddOpcode(0x1D, 1, ARG_REG_E, ARG_NONE, OP_DEC8);
    AddOpcode(0x25, 1, ARG_REG_H, ARG_NONE, OP_DEC8);
    AddOpcode(0x2D, 1, ARG_REG_L, ARG_NONE, OP_DEC8);
    AddOpcode(0x3D, 1, ARG_REG_A, ARG_NONE, OP_DEC8);
    AddOpcode(0x35, 3, ARG_IND_HL, ARG_NONE, OP_DEC8);

    AddOpcode(0x0B, 2, ARG_REG_BC, ARG_NONE, OP_DEC16);
    AddOpcode(0x1B, 2, ARG_REG_DE, ARG_NONE, OP_DEC16);
    AddOpcode(0x2B, 2, ARG_REG_HL, ARG_NONE, OP_DEC16);
    AddOpcode(0x3B, 2, ARG_REG_SP, ARG_NONE, OP_DEC16);

    AddOpcode(0x02, 2, ARG_IND_BC, ARG_REG_A, OP_LD8);
    AddOpcode(0x0A, 2, ARG_REG_A, ARG_IND_BC, OP_LD8);
    AddOpcode(0x12, 2, ARG_IND_DE, ARG_REG_A, OP_LD8);
    AddOpcode(0x1A, 2, ARG_REG_A, ARG_IND_DE, OP_LD8);
    AddOpcode(0x22, 2, ARG_IND_HLI, ARG_REG_A, OP_LD8);
    AddOpcode(0x2A, 2, ARG_REG_A, ARG_IND_HLI, OP_LD8);
    AddOpcode(0x32, 2, ARG_IND_HLD, ARG_REG_A, OP_LD8);
    AddOpcode(0x3A, 2, ARG_REG_A, ARG_IND_HLD, OP_LD8);
    AddOpcode(0x40, 1, ARG_REG_B, ARG_REG_B, OP_LD8);
    AddOpcode(0x41, 1, ARG_REG_B, ARG_REG_C, OP_LD8);
    AddOpcode(0x42, 1, ARG_REG_B, ARG_REG_D, OP_LD8);
    AddOpcode(0x43, 1, ARG_REG_B, ARG_REG_E, OP_LD8);
    AddOpcode(0x44, 1, ARG_REG_B, ARG_REG_H, OP_LD8);
    AddOpcode(0x45, 1, ARG_REG_B, ARG_REG_L, OP_LD8);
    AddOpcode(0x46, 2, ARG_REG_B, ARG_IND_HL, OP_LD8);
    AddOpcode(0x47, 1, ARG_REG_B, ARG_REG_A, OP_LD8);
    AddOpcode(0x48, 1, ARG_REG_C, ARG_REG_B, OP_LD8);
    AddOpcode(0x49, 1, ARG_REG_C, ARG_REG_C, OP_LD8);
    AddOpcode(0x4A, 1, ARG_REG_C, ARG_REG_D, OP_LD8);
    AddOpcode(0x4B, 1, ARG_REG_C, ARG_REG_E, OP_LD8);
    AddOpcode(0x4C, 1, ARG_REG_C, ARG_REG_H, OP_LD8);
    AddOpcode(0x4D, 1, ARG_REG_C, ARG_REG_L, OP_LD8);
    AddOpcode(0x4E, 2, ARG_REG_C, ARG_IND_HL, OP_LD8);
    AddOpcode(0x4F, 1, ARG_REG_C, ARG_REG_A, OP_LD8);
    AddOpcode(0x50, 1, ARG_REG_D, ARG_REG_B, OP_LD8);
    AddOpcode(0x51, 1, ARG_REG_D, ARG_REG_C, OP_LD8);
    AddOpcode(0x52, 1, ARG_REG_D, ARG_REG_D, OP_LD8);
    AddOpcode(0x53, 1, ARG_REG_D, ARG_REG_E, OP_LD8);
    AddOpcode(0x54, 1, ARG_REG_D, ARG_REG_H, OP_LD8);
    AddOpcode(0x55, 1, ARG_REG_D, ARG_REG_L, OP_LD8);
    AddOpcode(0x56, 2, ARG_REG_D, ARG_IND_HL, OP_LD8);
    AddOpcode(0x57, 1, ARG_REG_D, ARG_REG_A, OP_LD8);
    AddOpcode(0x58, 1, ARG_REG_E, ARG_REG_B, OP_LD8);
    AddOpcode(0x59, 1, ARG_REG_E, ARG_REG_C, OP_LD8);
    AddOpcode(0x5A, 1, ARG_REG_E, ARG_REG_D, OP_LD8);
    AddOpcode(0x5B, 1, ARG_REG_E, ARG_REG_E, OP_LD8);
    AddOpcode(0x5C, 1, ARG_REG_E, ARG_REG_H, OP_LD8);
    AddOpcode(0x5D, 1, ARG_REG_E, ARG_REG_L, OP_LD8);
    AddOpcode(0x5E, 2, ARG_REG_E, ARG_IND_HL, OP_LD8);
    AddOpcode(0x5F, 1, ARG_REG_E, ARG_REG_A, OP_LD8);
    AddOpcode(0x60, 1, ARG_REG_H, ARG_REG_B, OP_LD8);
    AddOpcode(0x61, 1, ARG_REG_H, ARG_REG_C, OP_LD8);
    AddOpcode(0x62, 1, ARG_REG_H, ARG_REG_D, OP_LD8);
    AddOpcode(0x63, 1, ARG_REG_H, ARG_REG_E, OP_LD8);
    AddOpcode(0x64, 1, ARG_REG_H, ARG_REG_H, OP_LD8);
    AddOpcode(0x65, 1, ARG_REG_H, ARG_REG_L, OP_LD8);
    AddOpcode(0x66, 2, ARG_REG_H, ARG_IND_HL, OP_LD8);
    AddOpcode(0x67, 1, ARG_REG_H, ARG_REG_A, OP_LD8);
    AddOpcode(0x68, 1, ARG_REG_L, ARG_REG_B, OP_LD8);
    AddOpcode(0x69, 1, ARG_REG_L, ARG_REG_C, OP_LD8);
    AddOpcode(0x6A, 1, ARG_REG_L, ARG_REG_D, OP_LD8);
    AddOpcode(0x6B, 1, ARG_REG_L, ARG_REG_E, OP_LD8);
    AddOpcode(0x6C, 1, ARG_REG_L, ARG_REG_H, OP_LD8);
    AddOpcode(0x6D, 1, ARG_REG_L, ARG_REG_L, OP_LD8);
    AddOpcode(0x6E, 2, ARG_REG_L, ARG_IND_HL, OP_LD8);
    AddOpcode(0x6F, 1, ARG_REG_L, ARG_REG_A, OP_LD8);
    AddOpcode(0x70, 2, ARG_IND_HL, ARG_REG_B, OP_LD8);
    AddOpcode(0x71, 2, ARG_IND_HL, ARG_REG_C, OP_LD8);
    AddOpcode(0x72, 2, ARG_IND_HL, ARG_REG_D, OP_LD8);
    AddOpcode(0x73, 2, ARG_IND_HL, ARG_REG_E, OP_LD8);
    AddOpcode(0x74, 2, ARG_IND_HL, ARG_REG_H, OP_LD8);
    AddOpcode(0x75, 2, ARG_IND_HL, ARG_REG_L, OP_LD8);
    AddOpcode(0x77, 2, ARG_IND_HL, ARG_REG_A, OP_LD8);
    AddOpcode(0x78, 1, ARG_REG_A, ARG_REG_B, OP_LD8);
    AddOpcode(0x79, 1, ARG_REG_A, ARG_REG_C, OP_LD8);
    AddOpcode(0x7A, 1, ARG_REG_A, ARG_REG_D, OP_LD8);
    AddOpcode(0x7B, 1, ARG_REG_A, ARG_REG_E, OP_LD8);
    AddOpcode(0x7C, 1, ARG_REG_A, ARG_REG_H, OP_LD8);
    AddOpcode(0x7D, 1, ARG_REG_A, ARG_REG_L, OP_LD8);
    AddOpcode(0x7E, 2, ARG_REG_A, ARG_IND_HL, OP_LD8);
    AddOpcode(0x7F, 1, ARG_REG_A, ARG_REG_A, OP_LD8);
    AddOpcode(0xE0, 3, ARG_IND_8, ARG_REG_A, OP_LD8);
    AddOpcode(0xF0, 3, ARG_REG_A, ARG_IND_8, OP_LD8);
    AddOpcode(0xEA, 4, ARG_IND_16, ARG_REG_A, OP_LD8);
    AddOpcode(0xFA, 4, ARG_REG_A, ARG_IND_16, OP_LD8);
    AddOpcode(0x06, 2, ARG_REG_B, ARG_IMM_8, OP_LD8);
    AddOpcode(0xE2, 2, ARG_IND_C, ARG_REG_A, OP_LD8);
    AddOpcode(0xF2, 2, ARG_REG_A, ARG_IND_C, OP_LD8);
    AddOpcode(0x0E, 2, ARG_REG_C, ARG_IMM_8, OP_LD8);
    AddOpcode(0x16, 2, ARG_REG_D, ARG_IMM_8, OP_LD8);
    AddOpcode(0x1E, 2, ARG_REG_E, ARG_IMM_8, OP_LD8);
    AddOpcode(0x26, 2, ARG_REG_H, ARG_IMM_8, OP_LD8);
    AddOpcode(0x2E, 2, ARG_REG_L, ARG_IMM_8, OP_LD8);
    AddOpcode(0x36, 3, ARG_IND_HL, ARG_IMM_8, OP_LD8);
    AddOpcode(0x3E, 2, ARG_REG_A, ARG_IMM_8, OP_LD8);

    AddOpcode(0x01, 3, ARG_REG_BC, ARG_IMM_16, OP_LD16);
    AddOpcode(0x11, 3, ARG_REG_DE, ARG_IMM_16, OP_LD16);
    AddOpcode(0x21, 3, ARG_REG_HL, ARG_IMM_16, OP_LD16);
    AddOpcode(0x31, 3, ARG_REG_SP, ARG_IMM_16, OP_LD16);
    AddOpcode(0xF9, 2, ARG_REG_SP, ARG_REG_HL, OP_LD16);
    AddOpcode(0x08, 5, ARG_NONE, ARG_NONE, OP_LD16_SP);
    AddOpcode(0xF8, 3, ARG_IMM_8, ARG_NONE, OP_LD_HL_SP);

    AddOpcode(0x80, 1, ARG_REG_B, ARG_NONE, OP_ADD_A);
    AddOpcode(0x81, 1, ARG_REG_C, ARG_NONE, OP_ADD_A);
    AddOpcode(0x82, 1, ARG_REG_D, ARG_NONE, OP_ADD_A);
    AddOpcode(0x83, 1, ARG_REG_E, ARG_NONE, OP_ADD_A);
    AddOpcode(0x84, 1, ARG_REG_H, ARG_NONE, OP_ADD_A);
    AddOpcode(0x85, 1, ARG_REG_L, ARG_NONE, OP_ADD_A);
    AddOpcode(0x86, 2, ARG_IND_HL, ARG_NONE, OP_ADD_A);
    AddOpcode(0x87, 1, ARG_REG_A, ARG_NONE, OP_ADD_A);
    AddOpcode(0xC6, 2, ARG_IMM_8, ARG_NONE, OP_ADD_A);

    AddOpcode(0xE8, 4, ARG_IMM_8, ARG_NONE, OP_ADD_SP);
    AddOpcode(0x09, 2, ARG_REG_BC, ARG_NONE, OP_ADD_HL);
    AddOpcode(0x19, 2, ARG_REG_DE, ARG_NONE, OP_ADD_HL);
    AddOpcode(0x29, 2, ARG_REG_HL, ARG_NONE, OP_ADD_HL);
    AddOpcode(0x39, 2, ARG_REG_SP, ARG_NONE, OP_ADD_HL);

    AddOpcode(0x88, 1, ARG_REG_B, ARG_NONE, OP_ADC8);
    AddOpcode(0x89, 1, ARG_REG_C, ARG_NONE, OP_ADC8);
    AddOpcode(0x8A, 1, ARG_REG_D, ARG_NONE, OP_ADC8);
    AddOpcode(0x8B, 1, ARG_REG_E, ARG_NONE, OP_ADC8);
    AddOpcode(0x8C, 1, ARG_REG_H, ARG_NONE, OP_ADC8);
    AddOpcode(0x8D, 1, ARG_REG_L, ARG_NONE, OP_ADC8);
    AddOpcode(0x8E, 2, ARG_IND_HL, ARG_NONE, OP_ADC8);
    AddOpcode(0x8F, 1, ARG_REG_A, ARG_NONE, OP_ADC8);
    AddOpcode(0xCE, 2, ARG_IMM_8, ARG_NONE, OP_ADC8);

    AddOpcode(0x90, 1, ARG_REG_B, ARG_NONE, OP_SUB8);
    AddOpcode(0x91, 1, ARG_REG_C, ARG_NONE, OP_SUB8);
    AddOpcode(0x92, 1, ARG_REG_D, ARG_NONE, OP_SUB8);
    AddOpcode(0x93, 1, ARG_REG_E, ARG_NONE, OP_SUB8);
    AddOpcode(0x94, 1, ARG_REG_H, ARG_NONE, OP_SUB8);
    AddOpcode(0x95, 1, ARG_REG_L, ARG_NONE, OP_SUB8);
    AddOpcode(0x96, 2, ARG_IND_HL, ARG_NONE, OP_SUB8);
    AddOpcode(0x97, 1, ARG_REG_A, ARG_NONE, OP_SUB8);
    AddOpcode(0xD6, 2, ARG_IMM_8, ARG_NONE, OP_SUB8);

    AddOpcode(0x98, 1, ARG_REG_B, ARG_NONE, OP_SBC8);
    AddOpcode(0x99, 1, ARG_REG_C, ARG_NONE, OP_SBC8);
    AddOpcode(0x9A, 1, ARG_REG_D, ARG_NONE, OP_SBC8);
    AddOpcode(0x9B, 1, ARG_REG_E, ARG_NONE, OP_SBC8);
    AddOpcode(0x9C, 1, ARG_REG_H, ARG_NONE, OP_SBC8);
    AddOpcode(0x9D, 1, ARG_REG_L, ARG_NONE, OP_SBC8);
    AddOpcode(0x9E, 2, ARG_IND_HL, ARG_NONE, OP_SBC8);
    AddOpcode(0x9F, 1, ARG_REG_A, ARG_NONE, OP_SBC8);
    AddOpcode(0xDE, 2, ARG_IMM_8, ARG_NONE, OP_SBC8);

    AddOpcode(0xA0, 1, ARG_REG_B, ARG_NONE, OP_AND8);
    AddOpcode(0xA1, 1, ARG_REG_C, ARG_NONE, OP_AND8);
    AddOpcode(0xA2, 1, ARG_REG_D, ARG_NONE, OP_AND8);
    AddOpcode(0xA3, 1, ARG_REG_E, ARG_NONE, OP_AND8);
    AddOpcode(0xA4, 1, ARG_REG_H, ARG_NONE, OP_AND8);
    AddOpcode(0xA5, 1, ARG_REG_L, ARG_NONE, OP_AND8);
    AddOpcode(0xA6, 2, ARG_IND_HL, ARG_NONE, OP_AND8);
    AddOpcode(0xA7, 1, ARG_REG_A, ARG_NONE, OP_AND8);
    AddOpcode(0xE6, 2, ARG_IMM_8, ARG_NONE, OP_AND8);

    AddOpcode(0xA8, 1, ARG_REG_B, ARG_NONE, OP_XOR8);
    AddOpcode(0xA9, 1, ARG_REG_C, ARG_NONE, OP_XOR8);
    AddOpcode(0xAA, 1, ARG_REG_D, ARG_NONE, OP_XOR8);
    AddOpcode(0xAB, 1, ARG_REG_E, ARG_NONE, OP_XOR8);
    AddOpcode(0xAC, 1, ARG_REG_H, ARG_NONE, OP_XOR8);
    AddOpcode(0xAD, 1, ARG_REG_L, ARG_NONE, OP_XOR8);
    AddOpcode(0xAE, 2, ARG_IND_HL, ARG_NONE, OP_XOR8);
    AddOpcode(0xAF, 1, ARG_REG_A, ARG_NONE, OP_XOR8);
    AddOpcode(0xEE, 2, ARG_IMM_8, ARG_NONE, OP_XOR8);

    AddOpcode(0xB0, 1, ARG_REG_B, ARG_NONE, OP_OR8);
    AddOpcode(0xB1, 1, ARG_REG_C, ARG_NONE, OP_OR8);
    AddOpcode(0xB2, 1, ARG_REG_D, ARG_NONE, OP_OR8);
    AddOpcode(0xB3, 1, ARG_REG_E, ARG_NONE, OP_OR8);
    AddOpcode(0xB4, 1, ARG_REG_H, ARG_NONE, OP_OR8);
    AddOpcode(0xB5, 1, ARG_REG_L, ARG_NONE, OP_OR8);
    AddOpcode(0xB6, 2, ARG_IND_HL, ARG_NONE, OP_OR8);
    AddOpcode(0xB7, 1, ARG_REG_A, ARG_NONE, OP_OR8);
    AddOpcode(0xF6, 2, ARG_IMM_8, ARG_NONE, OP_OR8);

    AddOpcode(0xB8, 1, ARG_REG_B, ARG_NONE, OP_CP8);
    AddOpcode(0xB9, 1, ARG_REG_C, ARG_NONE, OP_CP8);
    AddOpcode(0xBA, 1, ARG_REG_D, ARG_NONE, OP_CP8);
    AddOpcode(0xBB, 1, ARG_REG_E, ARG_NONE, OP_CP8);
    AddOpcode(0xBC, 1, ARG_REG_H, ARG_NONE, OP_CP8);
    AddOpcode(0xBD, 1, ARG_REG_L, ARG_NONE, OP_CP8);
    AddOpcode(0xBE, 2, ARG_IND_HL, ARG_NONE, OP_CP8);
    AddOpcode(0xBF, 1, ARG_REG_A, ARG_NONE, OP_CP8);
    AddOpcode(0xFE, 2, ARG_IMM_8, ARG_NONE, OP_CP8);

    AddOpcode(0xC1, 3, ARG_REG_BC, ARG_NONE, OP_POP16);
    AddOpcode(0xD1, 3, ARG_REG_DE, ARG_NONE, OP_POP16);
    AddOpcode(0xE1, 3, ARG_REG_HL, ARG_NONE, OP_POP16);
    AddOpcode(0xF1, 3, ARG_REG_AF, ARG_NONE, OP_POP16);

    AddOpcode(0xC5, 4, ARG_REG_BC, ARG_NONE, OP_PUSH16);
    AddOpcode(0xD5, 4, ARG_REG_DE, ARG_NONE, OP_PUSH16);
    AddOpcode(0xE5, 4, ARG_REG_HL, ARG_NONE, OP_PUSH16);
    AddOpcode(0xF5, 4, ARG_REG_AF, ARG_NONE, OP_PUSH16);

    AddOpcode(0x18, 2, ARG_IMM_8, ARG_NONE, OP_JR8);
    AddOpcode(0x28, 2, ARG_FLAG_ZERO, ARG_IMM_8, OP_JR8_IF);
    AddOpcode(0x38, 2, ARG_FLAG_CARRY, ARG_IMM_8, OP_JR8_IF);
    AddOpcode(0x20, 2, ARG_FLAG_ZERO, ARG_IMM_8, OP_JR8_IFN);
    AddOpcode(0x30, 2, ARG_FLAG_CARRY, ARG_IMM_8, OP_JR8_IFN);

    AddOpcode(0xC3, 4, ARG_IMM_16, ARG_NONE, OP_JP16);
    AddOpcode(0xE9, 1, ARG_REG_HL, ARG_NONE, OP_JP16);
    AddOpcode(0xCA, 3, ARG_FLAG_ZERO, ARG_IMM_16, OP_JP16_IF);
    AddOpcode(0xDA, 3, ARG_FLAG_CARRY, ARG_IMM_16, OP_JP16_IF);
    AddOpcode(0xC2, 3, ARG_FLAG_ZERO, ARG_IMM_16, OP_JP16_IFN);
    AddOpcode(0xD2, 3, ARG_FLAG_CARRY, ARG_IMM_16, OP_JP16_IFN);

    AddOpcode(0xCD, 6, ARG_IMM_16, ARG_NONE, OP_CALL);
    AddOpcode(0xCC, 3, ARG_FLAG_ZERO, ARG_IMM_16, OP_CALL_IF);
    AddOpcode(0xDC, 3, ARG_FLAG_CARRY, ARG_IMM_16, OP_CALL_IF);
    AddOpcode(0xC4, 3, ARG_FLAG_ZERO, ARG_IMM_16, OP_CALL_IFN);
    AddOpcode(0xD4, 3, ARG_FLAG_CARRY, ARG_IMM_16, OP_CALL_IFN);

    AddOpcode(0xC9, 4, ARG_NONE, ARG_NONE, OP_RET);
    AddOpcode(0xD9, 4, ARG_NONE, ARG_NONE, OP_RETI);
    AddOpcode(0xC8, 2, ARG_FLAG_ZERO, ARG_NONE, OP_RET_IF);
    AddOpcode(0xD8, 2, ARG_FLAG_CARRY, ARG_NONE, OP_RET_IF);
    AddOpcode(0xC0, 2, ARG_FLAG_ZERO, ARG_NONE, OP_RET_IFN);
    AddOpcode(0xD0, 2, ARG_FLAG_CARRY, ARG_NONE, OP_RET_IFN);

    AddOpcode(0xC7, 4, ARG_RST_0, ARG_NONE, OP_RST);
    AddOpcode(0xCF, 4, ARG_RST_1, ARG_NONE, OP_RST);
    AddOpcode(0xD7, 4, ARG_RST_2, ARG_NONE, OP_RST);
    AddOpcode(0xDF, 4, ARG_RST_3, ARG_NONE, OP_RST);
    AddOpcode(0xE7, 4, ARG_RST_4, ARG_NONE, OP_RST);
    AddOpcode(0xEF, 4, ARG_RST_5, ARG_NONE, OP_RST);
    AddOpcode(0xF7, 4, ARG_RST_6, ARG_NONE, OP_RST);
    AddOpcode(0xFF, 4, ARG_RST_7, ARG_NONE, OP_RST);

    AddOpcode(0x07, 1, ARG_REG_A, ARG_NONE, OP_RLCA);
    AddOpcode(0x17, 1, ARG_REG_A, ARG_NONE, OP_RLA);
    AddOpcode(0x0F, 1, ARG_REG_A, ARG_NONE, OP_RRCA);
    AddOpcode(0x1F, 1, ARG_REG_A, ARG_NONE, OP_RRA);
}

stock GB_Opcodes_InitCB()
{
    AddOpcodeCB(0x00, 2, ARG_REG_B, ARG_NONE, OP_RLC);
    AddOpcodeCB(0x01, 2, ARG_REG_C, ARG_NONE, OP_RLC);
    AddOpcodeCB(0x02, 2, ARG_REG_D, ARG_NONE, OP_RLC);
    AddOpcodeCB(0x03, 2, ARG_REG_E, ARG_NONE, OP_RLC);
    AddOpcodeCB(0x04, 2, ARG_REG_H, ARG_NONE, OP_RLC);
    AddOpcodeCB(0x05, 2, ARG_REG_L, ARG_NONE, OP_RLC);
    AddOpcodeCB(0x06, 4, ARG_IND_HL, ARG_NONE, OP_RLC);
    AddOpcodeCB(0x07, 2, ARG_REG_A, ARG_NONE, OP_RLC);

    AddOpcodeCB(0x08, 2, ARG_REG_B, ARG_NONE, OP_RRC);
    AddOpcodeCB(0x09, 2, ARG_REG_C, ARG_NONE, OP_RRC);
    AddOpcodeCB(0x0A, 2, ARG_REG_D, ARG_NONE, OP_RRC);
    AddOpcodeCB(0x0B, 2, ARG_REG_E, ARG_NONE, OP_RRC);
    AddOpcodeCB(0x0C, 2, ARG_REG_H, ARG_NONE, OP_RRC);
    AddOpcodeCB(0x0D, 2, ARG_REG_L, ARG_NONE, OP_RRC);
    AddOpcodeCB(0x0E, 4, ARG_IND_HL, ARG_NONE, OP_RRC);
    AddOpcodeCB(0x0F, 2, ARG_REG_A, ARG_NONE, OP_RRC);

    AddOpcodeCB(0x10, 2, ARG_REG_B, ARG_NONE, OP_RL);
    AddOpcodeCB(0x11, 2, ARG_REG_C, ARG_NONE, OP_RL);
    AddOpcodeCB(0x12, 2, ARG_REG_D, ARG_NONE, OP_RL);
    AddOpcodeCB(0x13, 2, ARG_REG_E, ARG_NONE, OP_RL);
    AddOpcodeCB(0x14, 2, ARG_REG_H, ARG_NONE, OP_RL);
    AddOpcodeCB(0x15, 2, ARG_REG_L, ARG_NONE, OP_RL);
    AddOpcodeCB(0x16, 4, ARG_IND_HL, ARG_NONE, OP_RL);
    AddOpcodeCB(0x17, 2, ARG_REG_A, ARG_NONE, OP_RL);

    AddOpcodeCB(0x18, 2, ARG_REG_B, ARG_NONE, OP_RR);
    AddOpcodeCB(0x19, 2, ARG_REG_C, ARG_NONE, OP_RR);
    AddOpcodeCB(0x1A, 2, ARG_REG_D, ARG_NONE, OP_RR);
    AddOpcodeCB(0x1B, 2, ARG_REG_E, ARG_NONE, OP_RR);
    AddOpcodeCB(0x1C, 2, ARG_REG_H, ARG_NONE, OP_RR);
    AddOpcodeCB(0x1D, 2, ARG_REG_L, ARG_NONE, OP_RR);
    AddOpcodeCB(0x1E, 4, ARG_IND_HL, ARG_NONE, OP_RR);
    AddOpcodeCB(0x1F, 2, ARG_REG_A, ARG_NONE, OP_RR);

    AddOpcodeCB(0x20, 2, ARG_REG_B, ARG_NONE, OP_SLA);
    AddOpcodeCB(0x21, 2, ARG_REG_C, ARG_NONE, OP_SLA);
    AddOpcodeCB(0x22, 2, ARG_REG_D, ARG_NONE, OP_SLA);
    AddOpcodeCB(0x23, 2, ARG_REG_E, ARG_NONE, OP_SLA);
    AddOpcodeCB(0x24, 2, ARG_REG_H, ARG_NONE, OP_SLA);
    AddOpcodeCB(0x25, 2, ARG_REG_L, ARG_NONE, OP_SLA);
    AddOpcodeCB(0x26, 4, ARG_IND_HL, ARG_NONE, OP_SLA);
    AddOpcodeCB(0x27, 2, ARG_REG_A, ARG_NONE, OP_SLA);

    AddOpcodeCB(0x28, 2, ARG_REG_B, ARG_NONE, OP_SRA);
    AddOpcodeCB(0x29, 2, ARG_REG_C, ARG_NONE, OP_SRA);
    AddOpcodeCB(0x2A, 2, ARG_REG_D, ARG_NONE, OP_SRA);
    AddOpcodeCB(0x2B, 2, ARG_REG_E, ARG_NONE, OP_SRA);
    AddOpcodeCB(0x2C, 2, ARG_REG_H, ARG_NONE, OP_SRA);
    AddOpcodeCB(0x2D, 2, ARG_REG_L, ARG_NONE, OP_SRA);
    AddOpcodeCB(0x2E, 4, ARG_IND_HL, ARG_NONE, OP_SRA);
    AddOpcodeCB(0x2F, 2, ARG_REG_A, ARG_NONE, OP_SRA);

    AddOpcodeCB(0x30, 2, ARG_REG_B, ARG_NONE, OP_SWAP);
    AddOpcodeCB(0x31, 2, ARG_REG_C, ARG_NONE, OP_SWAP);
    AddOpcodeCB(0x32, 2, ARG_REG_D, ARG_NONE, OP_SWAP);
    AddOpcodeCB(0x33, 2, ARG_REG_E, ARG_NONE, OP_SWAP);
    AddOpcodeCB(0x34, 2, ARG_REG_H, ARG_NONE, OP_SWAP);
    AddOpcodeCB(0x35, 2, ARG_REG_L, ARG_NONE, OP_SWAP);
    AddOpcodeCB(0x36, 4, ARG_IND_HL, ARG_NONE, OP_SWAP);
    AddOpcodeCB(0x37, 2, ARG_REG_A, ARG_NONE, OP_SWAP);

    AddOpcodeCB(0x38, 2, ARG_REG_B, ARG_NONE, OP_SRL);
    AddOpcodeCB(0x39, 2, ARG_REG_C, ARG_NONE, OP_SRL);
    AddOpcodeCB(0x3A, 2, ARG_REG_D, ARG_NONE, OP_SRL);
    AddOpcodeCB(0x3B, 2, ARG_REG_E, ARG_NONE, OP_SRL);
    AddOpcodeCB(0x3C, 2, ARG_REG_H, ARG_NONE, OP_SRL);
    AddOpcodeCB(0x3D, 2, ARG_REG_L, ARG_NONE, OP_SRL);
    AddOpcodeCB(0x3E, 4, ARG_IND_HL, ARG_NONE, OP_SRL);
    AddOpcodeCB(0x3F, 2, ARG_REG_A, ARG_NONE, OP_SRL);

    AddOpcodeCB(0x40, 2, ARG_BIT_0, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x41, 2, ARG_BIT_0, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x42, 2, ARG_BIT_0, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x43, 2, ARG_BIT_0, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x44, 2, ARG_BIT_0, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x45, 2, ARG_BIT_0, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x46, 3, ARG_BIT_0, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x47, 2, ARG_BIT_0, ARG_REG_A, OP_BIT);
    AddOpcodeCB(0x48, 2, ARG_BIT_1, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x49, 2, ARG_BIT_1, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x4A, 2, ARG_BIT_1, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x4B, 2, ARG_BIT_1, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x4C, 2, ARG_BIT_1, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x4D, 2, ARG_BIT_1, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x4E, 3, ARG_BIT_1, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x4F, 2, ARG_BIT_1, ARG_REG_A, OP_BIT);
    AddOpcodeCB(0x50, 2, ARG_BIT_2, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x51, 2, ARG_BIT_2, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x52, 2, ARG_BIT_2, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x53, 2, ARG_BIT_2, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x54, 2, ARG_BIT_2, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x55, 2, ARG_BIT_2, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x56, 3, ARG_BIT_2, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x57, 2, ARG_BIT_2, ARG_REG_A, OP_BIT);
    AddOpcodeCB(0x58, 2, ARG_BIT_3, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x59, 2, ARG_BIT_3, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x5A, 2, ARG_BIT_3, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x5B, 2, ARG_BIT_3, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x5C, 2, ARG_BIT_3, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x5D, 2, ARG_BIT_3, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x5E, 3, ARG_BIT_3, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x5F, 2, ARG_BIT_3, ARG_REG_A, OP_BIT);
    AddOpcodeCB(0x60, 2, ARG_BIT_4, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x61, 2, ARG_BIT_4, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x62, 2, ARG_BIT_4, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x63, 2, ARG_BIT_4, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x64, 2, ARG_BIT_4, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x65, 2, ARG_BIT_4, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x66, 3, ARG_BIT_4, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x67, 2, ARG_BIT_4, ARG_REG_A, OP_BIT);
    AddOpcodeCB(0x68, 2, ARG_BIT_5, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x69, 2, ARG_BIT_5, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x6A, 2, ARG_BIT_5, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x6B, 2, ARG_BIT_5, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x6C, 2, ARG_BIT_5, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x6D, 2, ARG_BIT_5, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x6E, 3, ARG_BIT_5, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x6F, 2, ARG_BIT_5, ARG_REG_A, OP_BIT);
    AddOpcodeCB(0x70, 2, ARG_BIT_6, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x71, 2, ARG_BIT_6, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x72, 2, ARG_BIT_6, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x73, 2, ARG_BIT_6, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x74, 2, ARG_BIT_6, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x75, 2, ARG_BIT_6, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x76, 3, ARG_BIT_6, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x77, 2, ARG_BIT_6, ARG_REG_A, OP_BIT);
    AddOpcodeCB(0x78, 2, ARG_BIT_7, ARG_REG_B, OP_BIT);
    AddOpcodeCB(0x79, 2, ARG_BIT_7, ARG_REG_C, OP_BIT);
    AddOpcodeCB(0x7A, 2, ARG_BIT_7, ARG_REG_D, OP_BIT);
    AddOpcodeCB(0x7B, 2, ARG_BIT_7, ARG_REG_E, OP_BIT);
    AddOpcodeCB(0x7C, 2, ARG_BIT_7, ARG_REG_H, OP_BIT);
    AddOpcodeCB(0x7D, 2, ARG_BIT_7, ARG_REG_L, OP_BIT);
    AddOpcodeCB(0x7E, 3, ARG_BIT_7, ARG_IND_HL, OP_BIT);
    AddOpcodeCB(0x7F, 2, ARG_BIT_7, ARG_REG_A, OP_BIT);

    AddOpcodeCB(0x80, 2, ARG_BIT_0, ARG_REG_B, OP_RES);
    AddOpcodeCB(0x81, 2, ARG_BIT_0, ARG_REG_C, OP_RES);
    AddOpcodeCB(0x82, 2, ARG_BIT_0, ARG_REG_D, OP_RES);
    AddOpcodeCB(0x83, 2, ARG_BIT_0, ARG_REG_E, OP_RES);
    AddOpcodeCB(0x84, 2, ARG_BIT_0, ARG_REG_H, OP_RES);
    AddOpcodeCB(0x85, 2, ARG_BIT_0, ARG_REG_L, OP_RES);
    AddOpcodeCB(0x86, 4, ARG_BIT_0, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0x87, 2, ARG_BIT_0, ARG_REG_A, OP_RES);
    AddOpcodeCB(0x88, 2, ARG_BIT_1, ARG_REG_B, OP_RES);
    AddOpcodeCB(0x89, 2, ARG_BIT_1, ARG_REG_C, OP_RES);
    AddOpcodeCB(0x8A, 2, ARG_BIT_1, ARG_REG_D, OP_RES);
    AddOpcodeCB(0x8B, 2, ARG_BIT_1, ARG_REG_E, OP_RES);
    AddOpcodeCB(0x8C, 2, ARG_BIT_1, ARG_REG_H, OP_RES);
    AddOpcodeCB(0x8D, 2, ARG_BIT_1, ARG_REG_L, OP_RES);
    AddOpcodeCB(0x8E, 4, ARG_BIT_1, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0x8F, 2, ARG_BIT_1, ARG_REG_A, OP_RES);
    AddOpcodeCB(0x90, 2, ARG_BIT_2, ARG_REG_B, OP_RES);
    AddOpcodeCB(0x91, 2, ARG_BIT_2, ARG_REG_C, OP_RES);
    AddOpcodeCB(0x92, 2, ARG_BIT_2, ARG_REG_D, OP_RES);
    AddOpcodeCB(0x93, 2, ARG_BIT_2, ARG_REG_E, OP_RES);
    AddOpcodeCB(0x94, 2, ARG_BIT_2, ARG_REG_H, OP_RES);
    AddOpcodeCB(0x95, 2, ARG_BIT_2, ARG_REG_L, OP_RES);
    AddOpcodeCB(0x96, 4, ARG_BIT_2, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0x97, 2, ARG_BIT_2, ARG_REG_A, OP_RES);
    AddOpcodeCB(0x98, 2, ARG_BIT_3, ARG_REG_B, OP_RES);
    AddOpcodeCB(0x99, 2, ARG_BIT_3, ARG_REG_C, OP_RES);
    AddOpcodeCB(0x9A, 2, ARG_BIT_3, ARG_REG_D, OP_RES);
    AddOpcodeCB(0x9B, 2, ARG_BIT_3, ARG_REG_E, OP_RES);
    AddOpcodeCB(0x9C, 2, ARG_BIT_3, ARG_REG_H, OP_RES);
    AddOpcodeCB(0x9D, 2, ARG_BIT_3, ARG_REG_L, OP_RES);
    AddOpcodeCB(0x9E, 4, ARG_BIT_3, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0x9F, 2, ARG_BIT_3, ARG_REG_A, OP_RES);
    AddOpcodeCB(0xA0, 2, ARG_BIT_4, ARG_REG_B, OP_RES);
    AddOpcodeCB(0xA1, 2, ARG_BIT_4, ARG_REG_C, OP_RES);
    AddOpcodeCB(0xA2, 2, ARG_BIT_4, ARG_REG_D, OP_RES);
    AddOpcodeCB(0xA3, 2, ARG_BIT_4, ARG_REG_E, OP_RES);
    AddOpcodeCB(0xA4, 2, ARG_BIT_4, ARG_REG_H, OP_RES);
    AddOpcodeCB(0xA5, 2, ARG_BIT_4, ARG_REG_L, OP_RES);
    AddOpcodeCB(0xA6, 4, ARG_BIT_4, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0xA7, 2, ARG_BIT_4, ARG_REG_A, OP_RES);
    AddOpcodeCB(0xA8, 2, ARG_BIT_5, ARG_REG_B, OP_RES);
    AddOpcodeCB(0xA9, 2, ARG_BIT_5, ARG_REG_C, OP_RES);
    AddOpcodeCB(0xAA, 2, ARG_BIT_5, ARG_REG_D, OP_RES);
    AddOpcodeCB(0xAB, 2, ARG_BIT_5, ARG_REG_E, OP_RES);
    AddOpcodeCB(0xAC, 2, ARG_BIT_5, ARG_REG_H, OP_RES);
    AddOpcodeCB(0xAD, 2, ARG_BIT_5, ARG_REG_L, OP_RES);
    AddOpcodeCB(0xAE, 4, ARG_BIT_5, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0xAF, 2, ARG_BIT_5, ARG_REG_A, OP_RES);
    AddOpcodeCB(0xB0, 2, ARG_BIT_6, ARG_REG_B, OP_RES);
    AddOpcodeCB(0xB1, 2, ARG_BIT_6, ARG_REG_C, OP_RES);
    AddOpcodeCB(0xB2, 2, ARG_BIT_6, ARG_REG_D, OP_RES);
    AddOpcodeCB(0xB3, 2, ARG_BIT_6, ARG_REG_E, OP_RES);
    AddOpcodeCB(0xB4, 2, ARG_BIT_6, ARG_REG_H, OP_RES);
    AddOpcodeCB(0xB5, 2, ARG_BIT_6, ARG_REG_L, OP_RES);
    AddOpcodeCB(0xB6, 4, ARG_BIT_6, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0xB7, 2, ARG_BIT_6, ARG_REG_A, OP_RES);
    AddOpcodeCB(0xB8, 2, ARG_BIT_7, ARG_REG_B, OP_RES);
    AddOpcodeCB(0xB9, 2, ARG_BIT_7, ARG_REG_C, OP_RES);
    AddOpcodeCB(0xBA, 2, ARG_BIT_7, ARG_REG_D, OP_RES);
    AddOpcodeCB(0xBB, 2, ARG_BIT_7, ARG_REG_E, OP_RES);
    AddOpcodeCB(0xBC, 2, ARG_BIT_7, ARG_REG_H, OP_RES);
    AddOpcodeCB(0xBD, 2, ARG_BIT_7, ARG_REG_L, OP_RES);
    AddOpcodeCB(0xBE, 4, ARG_BIT_7, ARG_IND_HL, OP_RES);
    AddOpcodeCB(0xBF, 2, ARG_BIT_7, ARG_REG_A, OP_RES);

    AddOpcodeCB(0xC0, 2, ARG_BIT_0, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xC1, 2, ARG_BIT_0, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xC2, 2, ARG_BIT_0, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xC3, 2, ARG_BIT_0, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xC4, 2, ARG_BIT_0, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xC5, 2, ARG_BIT_0, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xC6, 4, ARG_BIT_0, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xC7, 2, ARG_BIT_0, ARG_REG_A, OP_SET);
    AddOpcodeCB(0xC8, 2, ARG_BIT_1, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xC9, 2, ARG_BIT_1, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xCA, 2, ARG_BIT_1, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xCB, 2, ARG_BIT_1, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xCC, 2, ARG_BIT_1, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xCD, 2, ARG_BIT_1, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xCE, 4, ARG_BIT_1, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xCF, 2, ARG_BIT_1, ARG_REG_A, OP_SET);
    AddOpcodeCB(0xD0, 2, ARG_BIT_2, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xD1, 2, ARG_BIT_2, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xD2, 2, ARG_BIT_2, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xD3, 2, ARG_BIT_2, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xD4, 2, ARG_BIT_2, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xD5, 2, ARG_BIT_2, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xD6, 4, ARG_BIT_2, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xD7, 2, ARG_BIT_2, ARG_REG_A, OP_SET);
    AddOpcodeCB(0xD8, 2, ARG_BIT_3, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xD9, 2, ARG_BIT_3, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xDA, 2, ARG_BIT_3, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xDB, 2, ARG_BIT_3, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xDC, 2, ARG_BIT_3, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xDD, 2, ARG_BIT_3, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xDE, 4, ARG_BIT_3, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xDF, 2, ARG_BIT_3, ARG_REG_A, OP_SET);
    AddOpcodeCB(0xE0, 2, ARG_BIT_4, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xE1, 2, ARG_BIT_4, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xE2, 2, ARG_BIT_4, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xE3, 2, ARG_BIT_4, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xE4, 2, ARG_BIT_4, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xE5, 2, ARG_BIT_4, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xE6, 4, ARG_BIT_4, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xE7, 2, ARG_BIT_4, ARG_REG_A, OP_SET);
    AddOpcodeCB(0xE8, 2, ARG_BIT_5, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xE9, 2, ARG_BIT_5, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xEA, 2, ARG_BIT_5, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xEB, 2, ARG_BIT_5, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xEC, 2, ARG_BIT_5, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xED, 2, ARG_BIT_5, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xEE, 4, ARG_BIT_5, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xEF, 2, ARG_BIT_5, ARG_REG_A, OP_SET);
    AddOpcodeCB(0xF0, 2, ARG_BIT_6, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xF1, 2, ARG_BIT_6, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xF2, 2, ARG_BIT_6, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xF3, 2, ARG_BIT_6, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xF4, 2, ARG_BIT_6, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xF5, 2, ARG_BIT_6, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xF6, 4, ARG_BIT_6, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xF7, 2, ARG_BIT_6, ARG_REG_A, OP_SET);
    AddOpcodeCB(0xF8, 2, ARG_BIT_7, ARG_REG_B, OP_SET);
    AddOpcodeCB(0xF9, 2, ARG_BIT_7, ARG_REG_C, OP_SET);
    AddOpcodeCB(0xFA, 2, ARG_BIT_7, ARG_REG_D, OP_SET);
    AddOpcodeCB(0xFB, 2, ARG_BIT_7, ARG_REG_E, OP_SET);
    AddOpcodeCB(0xFC, 2, ARG_BIT_7, ARG_REG_H, OP_SET);
    AddOpcodeCB(0xFD, 2, ARG_BIT_7, ARG_REG_L, OP_SET);
    AddOpcodeCB(0xFE, 4, ARG_BIT_7, ARG_IND_HL, OP_SET);
    AddOpcodeCB(0xFF, 2, ARG_BIT_7, ARG_REG_A, OP_SET);
}

//----------------------------------------------------
stock GB_Opcodes_Call(const op_info[E_GB_CPU_OPCODE_INFO])
{
    new E_OPCODE_TYPE: op_type = op_info[E_OP_TYPE];

    switch(op_type)
    {
        case OP_NOP:
        {
            // Nop
        }
        case OP_DI:
        {
            g_cpu[CPU_IME] = 0;
        }
        case OP_EI:
        {
            g_cpu[CPU_IME_DELAY] = 1;
        }
        case OP_DAA:
        {
            new a = g_cpu[CPU_A];
            new correction = CPU_GetCarryFlag() ? 0x60 : 0x00;

            if(CPU_GetHalfCarryFlag() || (!CPU_GetNegativeFlag() && (a & 0xF) > 9))
            {
                correction |= 0x06;
            } 
            
            if(CPU_GetCarryFlag() || (!CPU_GetNegativeFlag() && a > 0x99))
            {
                correction |= 0x60;
            }

            if(CPU_GetNegativeFlag())
                a -= correction;
            else
                a += correction;

            CPU_SetZeroFlag(a == 0);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(correction >= 0x60);

            g_cpu[CPU_A] = a;
        }
        case OP_CPL:
        {
            g_cpu[CPU_A] = ~g_cpu[CPU_A];
            CPU_SetNegativeFlag(true);
            CPU_SetHalfCarryFlag(true);
        }
        case OP_SCF:
        {
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(true);
        }
        case OP_CCF:
        {
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(!CPU_GetCarryFlag());
        }
        case OP_HALT:
        {
            g_cpu[CPU_HALTED] = true;
        }
        case OP_INC8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)

            new half_sum = (v & 0xF) + 1;
            new r = v + 1;

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(half_sum > 0xF);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_INC16:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]);
            new r = v + 1;

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_DEC8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = (v - 1) & 0xFF; // (fix_uint8)

            new half_sum = (v & 0xF) - 1;

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(true);
            CPU_SetHalfCarryFlag(half_sum > 0xF);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_DEC16:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]);
            new r = v - 1;

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_LD8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_2]) & 0xFF; // (uint8)
            GB_CPU_Set(op_info[E_OP_ARG_1], v);
        }
        case OP_LD16:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_2]);
            GB_CPU_Set(op_info[E_OP_ARG_1], v);
        }
        case OP_LD16_SP:
        {
            new address = GB_MMU_Read16(g_cpu[CPU_PC]);
            new sp = g_cpu[CPU_SP];

            g_cpu[CPU_PC] += 2;

            GB_MMU_Write(address, sp & 0xFF);
            GB_MMU_Write(address + 1, sp >> 8);
        }
        case OP_LD_HL_SP:
        {
            new v = int8_from_uint8(GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF); // (int8)
            new sp = g_cpu[CPU_SP];

            new sum8 = ((sp & 0xFF) & 0xFFFF) + ((v & 0xFF) & 0xFFFF); // (uint16) (uint16)
            new sum16 = sp + v;
            new half_sum = (sp & 0xF) + (v & 0xF);
            new r = sum16 & 0xFFFF; // (uint16)

            CPU_SetZeroFlag(false);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(half_sum > 0xF);
            CPU_SetCarryFlag(sum8 > 0xFF);

            CPU_SET_HL(g_cpu, r);
        }
        case OP_ADD_A:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new a = g_cpu[CPU_A];

            new sum = (a & 0xFFFF) + (v & 0xFFFF); // (uint16) (uint16)
            new half_sum = (a & 0xF) + (v & 0xF);
            new r = sum & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(half_sum > 0xF);
            CPU_SetCarryFlag(sum > 0xFF);

            g_cpu[CPU_A] = r;
        }
        case OP_ADD_SP:
        {
            new v = int8_from_uint8(GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF); // (int8)
            new sp = g_cpu[CPU_SP];

            new sum8 = ((sp & 0xFF) & 0xFFFF) + ((v & 0xFF) & 0xFFFF); // (uint16) (uint16)
            new sum16 = sp + v;
            new half_sum = (sp & 0xF) + (v & 0xF);
            new r = sum16 & 0xFFFF; // (uint16)

            CPU_SetZeroFlag(false);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(half_sum > 0xF);
            CPU_SetCarryFlag(sum8 > 0xFF);

            g_cpu[CPU_SP] = r;
        }
        case OP_ADD_HL:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]);
            new hl = CPU_GET_HL(g_cpu);

            new half_sum = (hl & 0x0FFF) + (v & 0x0FFF);
            new sum = hl + v;
            new r = sum & 0xFFFF; // (uint16)

            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(half_sum > 0x0FFF);
            CPU_SetCarryFlag(sum > 0xFFFF);

            CPU_SET_HL(g_cpu, r);
        }
        case OP_ADC8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new c = CPU_GetCarryFlag();
            new a = g_cpu[CPU_A];

            new sum = (a & 0xFFFF) + (v & 0xFFFF) + (c & 0xFFFF); // (uint16) (uint16) (uint16)
            new half_sum = (a & 0xF) + (v & 0xF) + c;
            new r = sum & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(half_sum > 0xF);
            CPU_SetCarryFlag(sum > 0xFF);

            g_cpu[CPU_A] = r;
        }
        case OP_SUB8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new a = g_cpu[CPU_A];
            
            new sum = (a & 0xFFFF) - (v & 0xFFFF); // (uint16) (uint16)
            new half_sum = (a & 0xF) - (v & 0xF);
            new r = sum & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(true);
            CPU_SetHalfCarryFlag(half_sum > 0xF);
            CPU_SetCarryFlag(sum > 0xFF);

            g_cpu[CPU_A] = r;
        }
        case OP_SBC8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new c = CPU_GetCarryFlag() ? 1 : 0;
            new a = g_cpu[CPU_A];

            new sum = (a & 0xFFFF) - (v & 0xFFFF) - (c & 0xFFFF); // (uint16) (uint16) (uint16)
            new half_sum = (a & 0xF) - (v & 0xF) - c;
            new r = sum & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(true);
            CPU_SetHalfCarryFlag(half_sum > 0xF);
            CPU_SetCarryFlag(sum > 0xFF);

            g_cpu[CPU_A] = r;
        }
        case OP_AND8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new a = g_cpu[CPU_A];
            new r = a & v;

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(true);
            CPU_SetCarryFlag(false);

            g_cpu[CPU_A] = r;
        }
        case OP_XOR8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new a = g_cpu[CPU_A];
            new r = a ^ v;

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(false);

            g_cpu[CPU_A] = r;
        }
        case OP_OR8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new a = g_cpu[CPU_A];
            new r = a | v;

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(false);

            g_cpu[CPU_A] = r;
        }
        case OP_CP8:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new a = g_cpu[CPU_A];

            new sum = (a & 0xFFFF) - (v & 0xFFFF); // (uint16) (uint16)
            new half_sum = (a & 0xF) - (v & 0xF);
            new r = sum & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(true);
            CPU_SetHalfCarryFlag(half_sum > 0xF);
            CPU_SetCarryFlag(sum > 0xFF);
        }
        case OP_POP16:
        {
            new v = GB_CPU_Pop();

            if(op_info[E_OP_ARG_1] == ARG_REG_AF) 
            {
                v &= 0xFFF0;
            }

            GB_CPU_Set(op_info[E_OP_ARG_1], v);
        }
        case OP_PUSH16:
        { 
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]);
            GB_CPU_Push(v);
        }
        case OP_JR8:
        {
            new offset = int8_from_uint8(GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF); // (int8)
            g_cpu[CPU_PC] += offset;
        }
        case OP_JR8_IF:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]);
            new offset = int8_from_uint8(GB_CPU_Get(op_info[E_OP_ARG_2]) & 0xFF); // (int8)

            if(flag) 
            {
                g_cpu[CPU_PC] += offset;
                g_cpu[CPU_STEP] += 1;
            }
        }
        case OP_JR8_IFN:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]);
            new offset = int8_from_uint8(GB_CPU_Get(op_info[E_OP_ARG_2]) & 0xFF); // (int8)

            if(!flag) 
            {
                g_cpu[CPU_PC] += offset;
                g_cpu[CPU_STEP] += 1;
            }
        }
        case OP_JP16:
        {
            new address = GB_CPU_Get(op_info[E_OP_ARG_1]);
            g_cpu[CPU_PC] = address;
        }
        case OP_JP16_IF:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]);
            new addr = GB_CPU_Get(op_info[E_OP_ARG_2]);

            if(flag) 
            {
                g_cpu[CPU_PC] = addr;
                g_cpu[CPU_STEP] += 1;
            }
        }
        case OP_JP16_IFN:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]);
            new addr = GB_CPU_Get(op_info[E_OP_ARG_2]);

            if(!flag) 
            {
                g_cpu[CPU_PC] = addr;
                g_cpu[CPU_STEP] += 1;
            }
        }
        case OP_CALL:
        {
            new addr = GB_CPU_Get(op_info[E_OP_ARG_1]);
            GB_CPU_Push(g_cpu[CPU_PC]);
            g_cpu[CPU_PC] = addr;
        }
        case OP_CALL_IF:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]) != 0;
            new addr = GB_CPU_Get(op_info[E_OP_ARG_2]);

            if(flag) 
            {
                GB_CPU_Push(g_cpu[CPU_PC]);
                g_cpu[CPU_STEP] += 3;
                g_cpu[CPU_PC] = addr;
            }
        }
        case OP_CALL_IFN:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]) != 0;
            new addr = GB_CPU_Get(op_info[E_OP_ARG_2]);

            if(!flag) 
            {
                GB_CPU_Push(g_cpu[CPU_PC]);
                g_cpu[CPU_STEP] += 3;
                g_cpu[CPU_PC] = addr;
            }
        }
        case OP_RET:
        {
            g_cpu[CPU_PC] = GB_CPU_Pop();
        }
        case OP_RETI:
        {
            g_cpu[CPU_PC] = GB_CPU_Pop();
            g_cpu[CPU_IME] = 1; // looks like not delayed unlike EI
            g_cpu[CPU_IME_DELAY] = -1;
        }
        case OP_RET_IF:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]);

            if(flag)
            {
                g_cpu[CPU_PC] = GB_CPU_Pop();
                g_cpu[CPU_STEP] += 3;
            }
        }
        case OP_RET_IFN:
        {
            new flag = GB_CPU_Get(op_info[E_OP_ARG_1]);

            if(!flag)
            {
                g_cpu[CPU_PC] = GB_CPU_Pop();
                g_cpu[CPU_STEP] += 3;
            }
        }
        case OP_RST:
        {
            new addr = GB_CPU_Get(op_info[E_OP_ARG_1]);
            GB_CPU_Push(g_cpu[CPU_PC]);
            g_cpu[CPU_PC] = addr;
        }
        case OP_RLCA:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF;  // (uint8)
            new r = ((v << 1) | (v >> 7)) & 0xFF;  // (uint8)

            CPU_SetZeroFlag(false);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag((v >> 7) & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_RLA:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = ((v << 1) | CPU_GetCarryFlag()) & 0xFF; // (uint8)

            CPU_SetZeroFlag(false);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag((v >> 7) & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_RRCA:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF;  // (uint8)
            new r = ((v >> 1) | (v << 7)) & 0xFF;  // (uint8)

            CPU_SetZeroFlag(false);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(v & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_RRA:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = ((v >> 1) | (CPU_GetCarryFlag() << 7)) & 0xFF; // (uint8)
            
            CPU_SetZeroFlag(false);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(v & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_RLC:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = ((v << 1) | (v >> 7)) & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag((v >> 7) & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_RRC:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = ((v >> 1) | (v << 7)) & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(v & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_RL:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = ((v << 1) | CPU_GetCarryFlag()) & 0xFF;  // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag((v >> 7) & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_RR:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = ((v >> 1) | (CPU_GetCarryFlag() << 7)) & 0xFF; // (uint8)
            
            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(v & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_SLA:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = (v << 1) & 0xFF; // (uint8)

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag((v >> 7) & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_SRA:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = (v >> 1) | (v & 0x80);

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(v & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_SWAP:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new l = ((v & 0x0F) << 4) & 0xFF; // (uint8)
            new h = ((v & 0xF0) >> 4) & 0xFF; // (uint8)
            new r = l | h;

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(false);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_SRL:
        {
            new v = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new r = v >> 1;

            CPU_SetZeroFlag(r == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(false);
            CPU_SetCarryFlag(v & 1);

            GB_CPU_Set(op_info[E_OP_ARG_1], r);
        }
        case OP_BIT:
        {
            new bit = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            new v = GB_CPU_GetBit(op_info[E_OP_ARG_2], bit);

            CPU_SetZeroFlag(v == 0);
            CPU_SetNegativeFlag(false);
            CPU_SetHalfCarryFlag(true);
        }
        case OP_RES:
        {
            new bit = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            GB_CPU_SetBit(op_info[E_OP_ARG_2], bit, 0);
        }
        case OP_SET:
        {
            new bit = GB_CPU_Get(op_info[E_OP_ARG_1]) & 0xFF; // (uint8)
            GB_CPU_SetBit(op_info[E_OP_ARG_2], bit, 1);
        }
    }
}