OUTPUT_FORMAT(binary)
OUTPUT(dump.bin)

SECTIONS {
  . = 0x8072C000;
  .text : {
    dump.o (.text);
  }
}

intelendian = 0x806260D8;
sprintf = 0x8066E8A4;
MemAlloc = 0x80632E30;
MemFree = 0x80633014;
memcpy = 0x8059ADD0;
DisableInterrupts = 0x806E6058;
EnableInterrupts = 0x806E606C;
Decrypt = 0x805BC1F4;
NANDCreate = 0x806DB364;
NANDOpen = 0x806DC75C;
NANDClose = 0x806DC9DC;
NANDSeek = 0x806DB88C;
NANDWrite = 0x806DB7AC;
