This directory is used for building our Android ICU data file.

1. To generate ICU data files:run the icu_dat_generator.py script.
   The command is:
     ./icu_dat_generator.py  <icu version> [-v] [-h]
   For example:
     ./icu_dat_generator.py  4.2

2. To add a new resource to existing ICU data file: insert an entry to
   icudtxx-<tag name>.txt under external/icu4c/stubdata diretory then
   run the icu_dat_generator.py.
   For example, to add French sort to icudt42l-us.dat, you need to
   a. Add an entry, "coll/fr.res", into external/icu4c/stubdata/icudt42l-us.txt
   b. run "./icu_dat_generator.py 4.2".

3. To add a new ICU data file: add the <tag name> to datlist[] in
   icu_dat_generator.py and add corresponding resource list to
   icudtxxl<tag name>.txt. Then run the script icu_dat_generator.py to generate
   dat files.
   For example, to add icudt42l-latin.dat, you need to
   a. Modify icu_dat_generator.py by adding "latin" into datlist.
   b. Make a new file icudt42l-latin.txt to include the resource list.
   c. run "./icu_dat_generator.py 4.2".

Locale Resource Files:

- icudt42l-all.dat contains the resources in packed
  form. It includes everything that comes with
  a vanilla ICU 4.2. icu_dat_generator.py uses this file to generate
  custom build dat files.

- cnv/*.cnv are the additional encodings required by Android.
  These are
  - gsm-03.38-2000.cnv
  - iso-8859_16-2001.cnv
  - docomo-shift_jis-2007.cnv
  - kddi-jisx-208-2007.cnv
  - kddi-shift_jis-2007.cnv
  - softbank-jisx-208-2007.cnv
  - softbank-shift_jis-2007.cnv

Note:
  1. The script assumes you have done
  envsetup.sh and choosecombo before, because
  it relies on an enviroment variable pointing
  to the prebuilt tools.
  2. To add new charset conversion tables, the table
  should be created with the "--small" option. So they
  are built in compact mode and can be decompressed
  when needed.

