#!/bin/bash
export TOOLS=$ANDROID_EABI_TOOLCHAIN/../../../icu-4.2
export WHICH=$1

if [ "$WHICH" == "" ]; then
    echo "Usage: ./helper <config name>"
    exit
fi;

if [ ! -d "cfg-$WHICH" ]; then
    echo "Configuration $WHICH does not exist."
    exit
fi;

cp cfg-$WHICH/icudt42l/res_index.txt  icudt42l
cp cfg-$WHICH/icudt42l/brkitr/res_index.txt icudt42l/brkitr
cp cfg-$WHICH/icudt42l/coll/res_index.txt icudt42l/coll
cp cfg-$WHICH/icudt42l/rbnf/res_index.txt icudt42l/rbnf

echo "Compiling (possibly modified) source files into binaries..."
cd icudt42l
$TOOLS/gencnval convrtrs.txt
$TOOLS/genrb res_index.txt
cd ..

cd icudt42l/brkitr
$TOOLS/genrb res_index.txt
cd ../..

cd icudt42l/coll
$TOOLS/genrb res_index.txt
cd ../..

cd icudt42l/rbnf
$TOOLS/genrb res_index.txt
cd ../..

echo "Creating ICU data file..."
$TOOLS/icupkg -tl -s icudt42l -a cfg-$WHICH/icudt42l.txt new icudt42l.dat
cp icudt42l.dat icudt42l-$WHICH.dat
rm icudt42l.dat

echo "Finished."
