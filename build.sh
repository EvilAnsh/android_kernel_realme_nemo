#!/bin/bash

function compile()
{
rm -rf AnyKernel
source ~/.bashrc && source ~/.profile
TANGGAL=$(date +"%Y%m%d-%H")
export LC_ALL=C && export USE_CCACHE=1
export ARCH=arm64
if [ ! -d "clang" ]; then
    git clone https://gitlab.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-r547379.git clang --depth=1
fi

[ -d "out" ] && rm -rf out || mkdir -p out

make O=out ARCH=arm64 nemo_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      CC="clang" \
                      LLVM=1 \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zipping()
{
git clone --depth=1 https://github.com/kardebayan/AnyKernel3.git AnyKernel
cp out/arch/arm64/boot/Image.gz AnyKernel
cd AnyKernel
zip -r9 Stormbreaker-RMX2001L1-${TANGGAL}.zip *
}

compile
zipping
