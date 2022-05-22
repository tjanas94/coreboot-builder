#!/usr/bin/env bash

set -euo pipefail

function buildVariant() {
    make defconfig KBUILD_DEFCONFIG=configs/$1-defconfig
    make CPUS=$(nproc)
    cp build/coreboot.rom build/$1-coreboot.rom
}

make distclean
make crossgcc-i386 CPUS=$(nproc)
buildVariant seabios

cd build
cp seabios-coreboot.rom complete-coreboot.rom
./cbfstool complete-coreboot.rom print

dd if=complete-coreboot.rom of=complete-coreboot_top.rom bs=1M skip=8
sha256sum complete-coreboot_top.rom > complete-coreboot_top.rom.sha256
