//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------

#if defined _GAMEBOY_CPU
#endinput
#endif
#define _GAMEBOY_CPU

//----------------------------------------------------
static const cpu_reset_addr[8] = 
{
    0x00, 0x08, 0x10, 0x18,
    0x20, 0x28, 0x30, 0x38
};

//----------------------------------------------------
stock GB_CPU_Init()
{
    GB_CPU_Reset();
}

stock GB_CPU_Reset()
{
    CPU_SET_AF(g_cpu, 0x01B0);
    CPU_SET_BC(g_cpu, 0x0013);
    CPU_SET_DE(g_cpu, 0x00D8);
    CPU_SET_HL(g_cpu, 0x014D);

    g_cpu[CPU_SP] = 0xFFFE;
    g_cpu[CPU_PC] = 0x0000; // 0x0100 to skip boot
    g_cpu[CPU_IME] = 0;

    g_cpu[CPU_HALTED] = false;
    g_cpu[CPU_IME_DELAY] = -1;
    g_cpu[CPU_CYCLE] = 0;
    g_cpu[CPU_STEP] = 0;
}

stock GB_CPU_Get(E_CPU_ARG_TYPE: arg_type)
{
    new value = 0;
    new address = 0;

    switch(arg_type)
    {
        case 
            ARG_BIT_0,
            ARG_BIT_1,
            ARG_BIT_2,
            ARG_BIT_3,
            ARG_BIT_4,
            ARG_BIT_5,
            ARG_BIT_6,
            ARG_BIT_7:
        {
            value = (_:arg_type - _:ARG_BIT_0) & 0xFFFF;
        }
        case 
            ARG_RST_0,
            ARG_RST_1,
            ARG_RST_2,
            ARG_RST_3,
            ARG_RST_4,
            ARG_RST_5,
            ARG_RST_6,
            ARG_RST_7:
        {
            value = cpu_reset_addr[_:arg_type - _:ARG_RST_0];
        }
        case ARG_IMM_16:
        {
            value = GB_MMU_Read16(g_cpu[CPU_PC]);
            g_cpu[CPU_PC] += 2;
        }
        case ARG_REG_A:
        {
            value = g_cpu[CPU_A];
        }
        case ARG_REG_B:
        {
            value = g_cpu[CPU_B];
        }
        case ARG_REG_C:
        {
            value = g_cpu[CPU_C];
        }
        case ARG_REG_D:
        {
            value = g_cpu[CPU_D];
        }
        case ARG_REG_E:
        {
            value = g_cpu[CPU_E];
        }
        case ARG_REG_H:
        {
            value = g_cpu[CPU_H];
        }
        case ARG_REG_L:
        {
            value = g_cpu[CPU_L];
        }
        case ARG_REG_AF:
        {
            value = CPU_GET_AF(g_cpu);
        }
        case ARG_REG_BC:
        {
            value = CPU_GET_BC(g_cpu);
        }
        case ARG_REG_DE:
        {
            value = CPU_GET_DE(g_cpu);
        }
        case ARG_REG_HL:
        {
            value = CPU_GET_HL(g_cpu);
        }
        case ARG_REG_SP:
        {
            value = g_cpu[CPU_SP];
        }
        case ARG_IND_C:
        {   
            address = 0xFF00 + g_cpu[CPU_C];
            value = GB_MMU_Read(address);
        }
        case ARG_IND_BC:
        {
            value = GB_MMU_Read(CPU_GET_BC(g_cpu));
        }
        case ARG_IND_DE:
        {
            value = GB_MMU_Read(CPU_GET_DE(g_cpu));
        }
        case ARG_IND_HL:
        {
            value = GB_MMU_Read(CPU_GET_HL(g_cpu));
        }
        case ARG_IND_HLI:
        {
            value = GB_MMU_Read(CPU_GET_HL(g_cpu)); 
            CPU_SET_HL(g_cpu, CPU_GET_HL(g_cpu) + 1);
        }
        case ARG_IND_HLD:
        {
            value = GB_MMU_Read(CPU_GET_HL(g_cpu)); 
            CPU_SET_HL(g_cpu, CPU_GET_HL(g_cpu) - 1);
        }
        case ARG_IMM_8:
        {
            value = GB_MMU_Read(g_cpu[CPU_PC]++);
        }
        case ARG_IND_8:
        {
            address = 0xFF00 + GB_MMU_Read(g_cpu[CPU_PC]++);
            value = GB_MMU_Read(address);
        }
        case ARG_IND_16:
        {
            address = GB_MMU_Read16(g_cpu[CPU_PC]);
            value = GB_MMU_Read(address);
            g_cpu[CPU_PC] += 2;
        }
        case ARG_FLAG_CARRY:
        {
            value = CPU_GetCarryFlag();
        }
        case ARG_FLAG_ZERO:
        {
            value = CPU_GetZeroFlag();
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[CPU] INVALID ARG TYPE: %d", _:arg_type);
        }
#endif
    }
    return value;
}

stock GB_CPU_Set(E_CPU_ARG_TYPE: arg_type, value32)
{
    new value = value32 & 0xFF;
    new value16 = value32 & 0xFFFF;
    new address;

    switch(arg_type)
    {
        case ARG_REG_A:
        {
            g_cpu[CPU_A] = value;
        }
        case ARG_REG_B:
        {
            g_cpu[CPU_B] = value;
        }
        case ARG_REG_C:
        {
            g_cpu[CPU_C] = value;
        }
        case ARG_REG_D:
        {
            g_cpu[CPU_D] = value;
        }
        case ARG_REG_E:
        {
            g_cpu[CPU_E] = value;
        }
        case ARG_REG_H:
        {
            g_cpu[CPU_H] = value;
        }
        case ARG_REG_L:
        {
            g_cpu[CPU_L] = value;
        }
        case ARG_REG_AF:
        {
            CPU_SET_AF(g_cpu, value16);
        }
        case ARG_REG_BC:
        {
            CPU_SET_BC(g_cpu, value16);
        }
        case ARG_REG_DE:
        {
            CPU_SET_DE(g_cpu, value16);
        }
        case ARG_REG_HL:
        {
            CPU_SET_HL(g_cpu, value16);
        }
        case ARG_REG_SP:
        {
            g_cpu[CPU_SP] = value16;
        }
        case ARG_IND_C:
        {
            address = 0xFF00 + g_cpu[CPU_C];
            GB_MMU_Write(address, value);
        }
        case ARG_IND_BC:
        {
            GB_MMU_Write(CPU_GET_BC(g_cpu), value);
        }
        case ARG_IND_DE:
        {
            GB_MMU_Write(CPU_GET_DE(g_cpu), value);
        }
        case ARG_IND_HL:
        {
            GB_MMU_Write(CPU_GET_HL(g_cpu), value);
        }
        case ARG_IND_HLI:
        {
            GB_MMU_Write(CPU_GET_HL(g_cpu), value); 
            CPU_SET_HL(g_cpu, CPU_GET_HL(g_cpu) + 1);
        }
        case ARG_IND_HLD:
        {
            GB_MMU_Write(CPU_GET_HL(g_cpu), value); 
            CPU_SET_HL(g_cpu, CPU_GET_HL(g_cpu) - 1);
        }
        case ARG_IND_8:
        {
            address = 0xFF00 + GB_MMU_Read(g_cpu[CPU_PC]++);
            GB_MMU_Write(address, value);
        }
        case ARG_IND_16:
        {
            address = GB_MMU_Read16(g_cpu[CPU_PC]);
            GB_MMU_Write(address, value);
            g_cpu[CPU_PC] += 2;
        }
#if defined _ENABLE_WARNING_LOG
        default:
        {
            printf("[CPU] INVALID ARG TYPE: %d", _:arg_type);
        }
#endif
    }
}

stock GB_CPU_GetBit(E_CPU_ARG_TYPE: arg_type, bit)
{
    new value = GB_CPU_Get(arg_type);
    return (value >> bit & 7) & 1;
}

stock GB_CPU_SetBit(E_CPU_ARG_TYPE: arg_type, bit, value)
{
    new _value = GB_CPU_Get(arg_type) & 0xFF;

    bit &= 7;
    _value &= ~(1 << bit);
    _value |= (value & 1) << bit;

    GB_CPU_Set(arg_type, _value);
}

stock GB_CPU_Push(value)
{
    g_cpu[CPU_SP] -= 2;
    GB_MMU_Write16(g_cpu[CPU_SP], value);
}

stock GB_CPU_Pop()
{
    new value = GB_MMU_Read16(g_cpu[CPU_SP]);
    g_cpu[CPU_SP] += 2;
    return value;
}

stock GB_CPU_Interrput_Enabled()
{
    return g_cpu[CPU_IME] != 0;
}

stock GB_CPU_Interrput(address)
{
    g_cpu[CPU_HALTED] = false;

    if(g_cpu[CPU_IME] == 0)
        return 0;

    g_cpu[CPU_IME] = 0; // disable

    GB_CPU_Push(g_cpu[CPU_PC]);

    g_cpu[CPU_PC] = address;
    
    return 1;
}

stock GB_CPU_Execute(op_cpu[E_GB_CPU_OPCODE_INFO])
{
    new opcode = GB_MMU_Read(g_cpu[CPU_PC]++);

    if(opcode > 0xFF)
        return 0;
        
    if(opcode == 0xCB)
    {
        opcode = GB_MMU_Read(g_cpu[CPU_PC]++);

        if(opcode > 0xFF)
            return 0;

        op_cpu = g_cpu_opcodes_cb[opcode];
    }
    else
    {
        op_cpu = g_cpu_opcodes[opcode];
    }

    if(!op_cpu[E_OP_TYPE])
    {
#if defined _ENABLE_CRITICAL_LOG
        printf("[CPU_EXECUTE] invalid opcode: 0x%02x", opcode);
#endif
        return 0;
    }

    if(g_cpu[CPU_IME_DELAY] != -1)
    {
        g_cpu[CPU_IME] = g_cpu[CPU_IME_DELAY] & 0xFF;
        g_cpu[CPU_IME_DELAY] = -1;
    }

    GB_Opcodes_Call(op_cpu);

    return 1;
}

stock GB_CPU_Step()
{
    if(g_cpu[CPU_STEP] > 0)
    {
        g_cpu[CPU_STEP]--;
        return 0;
    }

    if(g_cpu[CPU_HALTED])
        return 0;

    new op_cpu[E_GB_CPU_OPCODE_INFO];
    GB_CPU_Execute(op_cpu);

    g_cpu[CPU_STEP] = op_cpu[E_OP_CYCLES] - 1;

    return 1;
}