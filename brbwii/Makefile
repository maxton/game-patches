
AS := $(DEVKITPPC)/bin/powerpc-eabi-as
LD := $(DEVKITPPC)/bin/powerpc-eabi-ld
DOLDIR := .

FUNC_OFFSET = $(shell printf "%d" 0x7213C0)
PATCH_OFFSET = $(shell printf "%d" 0x61BCEC)

dump.bin : dump.o
	$(LD) -T linkage.ld

dump.o : dump.s
	$(AS) -mregnames -o dump.o -I. dump.s

clean :
	rm -f dump.o dump.bin

# patch the dol, by writing the payload and patching the function call
patch : dump.bin
	cp $(DOLDIR)/boot.dol $(DOLDIR)/boot.patch.dol
	dd if=dump.bin of=$(DOLDIR)/boot.patch.dol bs=1 seek=$(FUNC_OFFSET) conv=notrunc status=none
	dd if=funccall.bin of=$(DOLDIR)/boot.patch.dol bs=1 seek=$(PATCH_OFFSET) conv=notrunc status=none
