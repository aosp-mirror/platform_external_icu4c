#!/bin/bash
export TOOLS=$ANDROID_EABI_TOOLCHAIN/../../../icu-3.8

echo "Compiling (possibly modified) source files into binaries..."
cd icudt38l
$TOOLS/gencnval convrtrs.txt
$TOOLS/genrb res_index.txt
cd ..

cd icudt38l/brkitr
$TOOLS/genrb res_index.txt
cd ../..

cd icudt38l/coll
$TOOLS/genrb res_index.txt
cd ../..

cd icudt38l/rbnf
$TOOLS/genrb res_index.txt
cd ../..

echo "Creating ICU data file..."
$TOOLS/icupkg -tl -s icudt38l -a icudt38l.txt new icudt38l.dat

echo "Finished."
