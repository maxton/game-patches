.text
dump:
  # stack configuration (0x60 bytes)
  .set fileinfo,    0x0 # 0x10 bytes
  .set buffer,      0x10
  .set bytelength,  0x14
  .set memPtr,      0x18
  .set string,      0x1C # 0x44 bytes

  # prologue
  stwu    r1, -0x60(r1)
  mflr    r0
  stw     r0, 0x64(r1)
  stw     r3, buffer(r1)
  stw     r4, bytelength(r1)
  # Allocate enough bytes of 32-byte aligned memory
  mr      r3, r4
  li      r4, 0x20
  bl      MemAlloc
  # Ensure the allocation succeeded
  cmpwi   r3, 0
  beq     epilogue_nofree
  stw     r3, memPtr(r1)
  # ... and copy the decrypted bytes to it (r3 is already set)
  lwz     r4, buffer(r1)
  lwz     r5, bytelength(r1)
  bl      memcpy

  # generate the pathname
  addi    r3, r1, string
  lis     r4, path@h
  ori     r4, r4, path@l
  mr      r5, r29
  bl      sprintf

  # Create the file
  # (ignore error if exists; I don't know where to save state...)
  addi    r3, r1, string
  li      r4, 0x3F # full read-write perms
  li      r5, 0
  bl      NANDCreate

  # Open file
  addi    r3, r1, string
  addi    r4, r1, fileinfo
  li      r5, 3
  bl      NANDOpen
  cmpwi   r3, 0       # make sure it succeeded
  bne     epilogue

  # Seek to the end
  addi    r3, r1, fileinfo
  li      r4, 0
  li      r5, 2 # SEEK_END
  bl      NANDSeek

  # Write to file
  addi    r3, r1, fileinfo
  lwz     r4, memPtr(r1)
  lwz     r5, bytelength(r1)
  bl      NANDWrite

  # Close file
  addi    r3, r1, fileinfo
  bl      NANDClose

epilogue:
  # free buffer
  lwz     r3, memPtr(r1)
  bl      MemFree
epilogue_nofree:
  # make the call to intelendian that we overwrote
  lwz     r3, buffer(r1)
  lwz     r4, bytelength(r1)
  bl      intelendian
  lwz     r0, 0x64(r1)
  mtlr    r0
  addi    r1, r1, 0x60
  blr

path:
  .string "/dumps/%x.bin"
