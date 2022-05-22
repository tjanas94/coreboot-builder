#!/usr/bin/env bash

set -euo pipefail

function buildVariant() {
    make defconfig KBUILD_DEFCONFIG=configs/$1-defconfig
    make CPUS=$(nproc)
    cp build/coreboot.rom build/$1-coreboot.rom
}

make distclean
make crossgcc-i386 CPUS=$(nproc)
buildVariant tianocore
buildVariant seabios
buildVariant grub

cd build
cp grub-coreboot.rom complete-coreboot.rom
./cbfstool tianocore-coreboot.rom extract -m x86 -n fallback/payload -f tianocore.elf
./cbfstool complete-coreboot.rom add-payload -f tianocore.elf -n tianocore.elf -c lzma
./cbfstool complete-coreboot.rom add-payload -f ../payloads/external/SeaBIOS/seabios/out/bios.bin.elf -n seabios.elf -c lzma
./cbfstool complete-coreboot.rom add -f ../payloads/external/SeaBIOS/seabios/out/vgabios.bin -n vgaroms/seavgabios.bin -t raw
./cbfstool complete-coreboot.rom add-int -i 5000 -n etc/ps2-keyboard-spinup
./cbfstool complete-coreboot.rom add -f ../payloads/external/GRUB2/grub2/build/unicode.pf2 -n unicode.pf2 -t raw
./cbfstool complete-coreboot.rom add -f ../grub.cfg -n etc/grub.cfg -t raw
./cbfstool complete-coreboot.rom print

dd if=complete-coreboot.rom of=complete-coreboot_top.rom bs=1M skip=8
sha256sum complete-coreboot_top.rom > complete-coreboot_top.rom.sha256
