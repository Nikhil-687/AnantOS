# === Paths ===
EFI_BASE     := /home/konsol/AnantOSLab/gnu-efi
INC          := $(EFI_BASE)/inc
GNUEFI       := $(EFI_BASE)/x86_64/gnuefi
EFILIB       := $(EFI_BASE)/x86_64/lib
LINKSCRIPT   := $(EFI_BASE)/gnuefi/elf_x86_64_efi.lds
CRT0         := $(GNUEFI)/crt0-efi-x86_64.o
GCC_LIB      := /usr/lib/gcc/x86_64-linux-gnu/13/libgcc.a

# === Tools ===
CC       := x86_64-linux-gnu-gcc
LD       := x86_64-linux-gnu-ld
OBJCOPY  := objcopy

# === Flags ===
CFLAGS   := -I$(INC) -I$(INC)/x86_64 -I$(INC)/protocol \
            -fPIC -fshort-wchar -mno-red-zone -Wall -Wno-pointer-sign \
            -fno-stack-protector -fno-stack-check -fno-strict-aliasing \
            -fno-merge-all-constants -ffreestanding -maccumulate-outgoing-args \
            -funsigned-char -fPIE -DGNU_EFI_USE_MS_ABI -O2 -g -std=c11

LDFLAGS  := -nostdlib -znocombreloc -T $(LINKSCRIPT) \
            -shared -Bsymbolic -L$(EFILIB) -L$(GNUEFI)

OBJCOPY_FLAGS := -j .text -j .sdata -j .data -j .dynamic -j .rodata -j .rel \
                 -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
                 -j .areloc -j .reloc

# === Targets ===
TARGET    := build/BOOTX64
SRC       := src/main.c

all: $(TARGET).EFI

$(TARGET).EFI: build/main.o
	$(LD) $(LDFLAGS) $(CRT0) build/main.o -o $(TARGET).so -lefi -lgnuefi $(GCC_LIB)
	$(OBJCOPY) $(OBJCOPY_FLAGS) --target=efi-app-x86_64 $(TARGET).so $@

build/main.o: $(SRC)
	mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf build
