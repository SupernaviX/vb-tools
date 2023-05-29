OUTPUT_FORMAT("elf32-v810", "elf32-v810", "elf32-v810")
OUTPUT("a.elf") /* force elf format output */
OUTPUT_ARCH(v810)
TARGET(elf32-v810)
ENTRY(_start)
SEARCH_DIR(.);

MEMORY
{
    dram    (!r)    : ORIGIN =  0x0003A000, LENGTH = 14k
    wram    (!r)    : ORIGIN =  0x05000000, LENGTH = 64k
    exp     (r)     : ORIGIN =  0x04000000, LENGTH = 16M
    sram    (!r)    : ORIGIN =  0x06000000, LENGTH = 16M
    rom     (rx)    : ORIGIN =  0x07000000, LENGTH = 16M
}

__data_vma = ORIGIN(wram);
__text_vma = ORIGIN(rom);

SECTIONS
{
    .text __text_vma :
    {
        *(.text*)
    } >rom = 0xFF

    .rodata . :
    {
        *(.rodata*)
    } >rom = 0xff

    __data_lma = .;
    .data __data_vma : AT(__data_lma)
    {
        *(.data*)
        *(COMMON)
        PROVIDE (__data_end = .);
    } >wram = 0xff

    .vbheader 0xffffffe0 :
    {
        fill 0x69
    }
}