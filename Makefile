CROSS_COMPILE=riscv32-unknown-elf-

CC=$(CROSS_COMPILE)gcc
OBJCOPY=$(CROSS_COMPILE)objcopy

all: \
	nmon_picorv32-wb-soc_10MHz_9600.txt

nmon_picorv32-wb-soc_10MHz_9600: \
	nmon_picorv32-wb-soc_10MHz_9600.S \
	debug_ll_ns16550.h \
	riscv_nmon.h

%: %.S riscv_nmon.lds
	$(CC) -nostdlib -nostartfiles -Triscv_nmon.lds -g -o $@ $<

hello_picorv32-wb-soc_10MHz_9600: hello_picorv32-wb-soc_10MHz_9600.S hello.lds
	$(CC) -nostdlib -nostartfiles -Thello.lds -g -o $@ $<

hello_picorv32-wb-soc_10MHz_9600.nmon: hello_picorv32-wb-soc_10MHz_9600.bin
	xxd -e -c 4 -o 0x40000000 -g 4 $< | sed "s/^/w/;s/: //;s/  .*//" > $@

.PRECIOUS: %.bin
%.bin: %
	$(OBJCOPY) -O binary $< $@

%.txt: %.bin
	hexdump -v -e '/4 "%08x\n"' $< > $@

.PHONY: clean
clean:
	rm -f nmon_picorv32-wb-soc_10MHz_9600 \
		nmon_picorv32-wb-soc_10MHz_9600.bin \
		nmon_picorv32-wb-soc_10MHz_9600.txt
	rm -f hello_picorv32-wb-soc_10MHz_9600 \
		hello_picorv32-wb-soc_10MHz_9600.bin \
		hello_picorv32-wb-soc_10MHz_9600.nmon
