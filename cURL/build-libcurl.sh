#!/bin/sh

#run with sudo

export OSSDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/"
export SIMSDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/"
export SDKROOT=$OSSDK
export VER=5.1

buildit()
{
    target=$1
    platform=$2

    export CC="${root}/usr/bin/llvm-gcc-4.2"
    export CFLAGS="-arch ${target} -isysroot=${PLATFORM}/${SDKROOT}/${PLATFORM}${SDK}.sdk"
    export CPPFLAGS="-isysroot=${SDKROOT}/${platform}${SDK}.sdk"
    export LDFLAGS="-arch ${target} -isysroot=${SDKROOT}/${platform}${SDK}.sdk"
    export CPP="${root}/usr/bin/llvm-cpp-4.2"
    export AR="${root}/usr/bin/ar"    
    export RANLIB="${root}/usr/bin/ranlib"

    sudo ./configure --disable-shared --without-ca-bundle --without-ldap --disable-ldap --host=arm-apple-darwin10 --build=arm-apple-darwin10

    sudo make clean
    sudo make
    sudo $AR rv libcurl.${target}.a lib/*.o
}

# Run once for armv6 & armv7, then for i386. Comment lines alternatively, as explained below.

# Run for armv6 & armv7 by changing line 6 to "export SDKROOT=$OSSDK". Comment line with "buildit i386..."
#buildit armv6 iPhoneOS
#buildit armv7 iPhoneOS

# Run for i386 by changing line 6 to "export SDKROOT=$SIMSDK". Comment line with buildit "armv6..." and "buildit armv7..."
buildit i386 iPhoneSimulator

sudo lipo -create libcurl.armv7.a libcurl.armv6.a libcurl.i386.a -output libcurl.a