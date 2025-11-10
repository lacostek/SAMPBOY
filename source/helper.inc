//----------------------------------------------------
//
// File Author: Roman Shadow (lacostek)
//
//----------------------------------------------------
#if defined _HELPER_INC
#endinput
#endif
#define _HELPER_INC

//----------------------------------------------------
stock INT8(value)
{
    value &= 0xFF;
    return (value > 127) ? (value - 256) : value;
}

stock UINT8(value)
{
    return (value < 0) ? (value + 256) : (value & 0xFF);
}

stock INT16(value)
{
    value &= 0xFFFF;
    return (value > 32767) ? (value - 65536) : value;
}

stock UINT16(value)
{
    return (value < 0) ? (value + 65536) : (value & 0xFFFF);
}

stock bool:IsValidINT8(value)
{
    return (value >= -128 && value <= 127);
}

stock bool:IsValidUINT8(value)
{
    return (value >= 0 && value <= 255);
}

stock bool:IsValidINT16(value)
{
    return (value >= -32768 && value <= 32767);
}

stock bool:IsValidUINT16(value)
{
    return (value >= 0 && value <= 65535);
}

stock ClampUINT8(value)
{
    if(value < 0) return 0;
    if(value > 255) return 255;
    return value;
}

stock ClampUINT16(value)
{
    if(value < 0) return 0;
    if(value > 65535) return 65535;
    return value;
}