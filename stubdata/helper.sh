#!/bin/bash

echo "Compiling (possibly modified) source files into binaries..."
cd icudt38l
../../../../prebuilt/Linux/icu-3.8/gencnval convrtrs.txt
../../../../prebuilt/Linux/icu-3.8/genrb res_index.txt
cd ..

cd icudt38l/brkitr
../../../../../prebuilt/Linux/icu-3.8/genrb res_index.txt
cd ../..

cd icudt38l/coll
../../../../../prebuilt/Linux/icu-3.8/genrb res_index.txt
cd ../..

cd icudt38l/rbnf
../../../../../prebuilt/Linux/icu-3.8/genrb res_index.txt
cd ../..

echo "Creating ICU data file..."
../../../prebuilt/Linux/icu-3.8/icupkg -tl -s icudt38l -a icudt38l.txt new icudt38l.dat

echo "Finished."
