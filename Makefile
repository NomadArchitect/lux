all:
	@echo "\x1B[0;1;35m make\x1B[0m lxfs"
	@make -C lxfs
	@echo "\x1B[0;1;35m make\x1B[0m boot-x86_64"
	@make -C boot-x86_64
	@echo "\x1B[0;1;35m make\x1B[0m kernel"
	@make -C kernel
	@echo "\x1B[0;1;35m make\x1B[0m lucerna"
	@make -C lucerna
	@echo "\x1B[0;1;35m make\x1B[0m install lucerna"
	@make install -C lucerna
	@echo "\x1B[0;1;35m make\x1B[0m servers"
	@make -C servers
	@echo "\x1B[0;1;35m make\x1B[0m install servers"
	@make install -C servers
	@echo "\x1B[0;1;35m make\x1B[0m lumen"
	@make -C lumen
	@echo "\x1B[0;1;35m make\x1B[0m utilities"
	@make -C utilities
	@echo "\x1B[0;1;35m make\x1B[0m install utilities"
	@make install -C utilities
	@echo "\x1B[0;1;35m lxfs\x1B[0m create"
	@./lxfs/lxfs create lux.hdd 10
	@echo "\x1B[0;1;35m lxfs\x1B[0m format"
	@./lxfs/lxfs format lux.hdd 9
	@echo "\x1B[0;1;35m lxfs\x1B[0m mbr"
	@./lxfs/lxfs mbr lux.hdd boot-x86_64/mbr.bin
	@echo "\x1B[0;1;35m lxfs\x1B[0m boot"
	@./lxfs/lxfs boot lux.hdd 0
	@echo "\x1B[0;1;35m lxfs\x1B[0m bootsec"
	@./lxfs/lxfs bootsec lux.hdd 0 boot-x86_64/bootsec.bin
	@echo "\x1B[0;1;35m lxfs\x1B[0m bootblk"
	@./lxfs/lxfs bootblk lux.hdd 0 boot-x86_64/lxboot.bin
	@echo "\x1B[0;1;35m lxfs\x1B[0m cp lxboot.conf"
	@./lxfs/lxfs cp lux.hdd 0 lxboot.conf lxboot.conf
	@echo "\x1B[0;1;35m lxfs\x1B[0m cp lux"
	@./lxfs/lxfs cp lux.hdd 0 kernel/lux lux
	@cp lumen/lumen ramdisk/
	@cp -r servers/out/* ramdisk/
	@cp -r utilities/out/* ramdisk/
	@echo "\x1B[0;1;35m tar \x1B[0m c ramdisk.tar"
	@cd ramdisk; tar --format ustar -c * > ../ramdisk.tar; cd ..
	@echo "\x1B[0;1;35m lxfs\x1B[0m cp ramdisk.tar"
	@./lxfs/lxfs cp lux.hdd 0 ramdisk.tar ramdisk.tar
	@./lxfs/lxfs mkdir lux.hdd 0 /bin
	@./lxfs/lxfs mkdir lux.hdd 0 /dev
	@./lxfs/lxfs mkdir lux.hdd 0 /proc
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/nterm /bin/nterm
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/hello /bin/hello
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/lush /bin/lush
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/echo /bin/echo
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/pwd /bin/pwd
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/ls /bin/ls
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/cat /bin/cat
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/luxfetch /bin/luxfetch
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/head /bin/head
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/reset /bin/reset
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/chmod /bin/chmod
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/touch /bin/touch
	@./lxfs/lxfs cp lux.hdd 0 ramdisk/rm /bin/rm
	@./lxfs/lxfs mkdir lux.hdd 0 /test

clean:
	@echo "\x1B[0;1;35m make\x1B[0m clean lxfs"
	@make -C lxfs clean
	@echo "\x1B[0;1;35m make\x1B[0m clean boot-x86_64"
	@make -C boot-x86_64 clean
	@echo "\x1B[0;1;35m make\x1B[0m clean kernel"
	@make -C kernel clean
	@echo "\x1B[0;1;35m make\x1B[0m clean lucerna"
	@make -C lucerna clean
	@echo "\x1B[0;1;35m make\x1B[0m clean lumen"
	@make -C lumen clean
	@echo "\x1B[0;1;35m make\x1B[0m clean servers"
	@make -C servers clean
	@echo "\x1B[0;1;35m make\x1B[0m clean utilities"
	@make -C utilities clean

toolchain:
	@cd toolchain-x86_64; ./build-toolchain.sh

qemu:
	@qemu-system-x86_64 -monitor stdio -m 4096 -smp 4 -cpu Skylake-Client \
	-drive file=lux.hdd,format=raw,if=none,id=disk \
	-device nvme,serial=12345678,drive=disk
