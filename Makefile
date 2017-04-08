CROSS_COMPILE=riscv32-unknown-elf-

CC=$(CROSS_COMPILE)gcc
OBJCOPY=$(CROSS_COMPILE)objcopy

all: \
	nmon_picorv32-wb-soc_10MHz_9600.txt \
	nmon_vscale-wb-soc_10MHz_9600.txt

nmon_picorv32-wb-soc_10MHz_9600: \
	nmon_picorv32-wb-soc_10MHz_9600.S \
	debug_ll_ns16550.h \
	riscv_nmon.h

nmon_vscale-wb-soc_10MHz_9600: \
	nmon_vscale-wb-soc_10MHz_9600.S \
	debug_ll_ns16550.h \
	riscv_nmon.h

%: %.S riscv_nmon.lds
	$(CC) -nostdlib -nostartfiles -Triscv_nmon.lds -g -o $@ $<

%.bin: %
	$(OBJCOPY) -O binary $< $@

%.txt: %.bin
	hexdump -v -e '/4 "%08x\n"' $< > $@

.PHONY: clean
clean:
	rm -f nmon_picorv32-wb-soc_10MHz_9600 \
		nmon_picorv32-wb-soc_10MHz_9600.bin \
		nmon_picorv32-wb-soc_10MHz_9600.txt
	rm -f nmon_vscale-wb-soc_10MHz_9600 \
		nmon_vscale-wb-soc_10MHz_9600.bin \
		nmon_vscale-wb-soc_10MHz_9600.txt
