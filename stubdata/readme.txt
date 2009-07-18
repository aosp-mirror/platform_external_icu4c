This directory is used for building our Android
ICU data file.

Quick tour:

- icudt38l/* contains the resources in unpacked
  form. It includes everything that comes with
  a vanilla ICU 3.8 as well as two additional
  encodings required by Android. These two are
  gsm-03.38-2000.cnv and iso-8859_16-2001.cnv.

- icudt38l.txt contains the manifest of our data
  file. It currently contains a lot of character
  conversion tables, locale data for English,
  German, Czech, and Dutch, as well as timezone
  information.

- icudt38l.dat is our actual data file. The file
  currently needs to be rebuilt manually whenever
  the manifest changes (don't forget to submit!).
  This is done using the following command line:
  
  ../../../prebuilt/Linux/icu-3.8/icupkg -tl \
  -a icudt38l.txt -s icudt38l new icudt38l.dat

  (change "Linux" to something else if platform
   differs.))

- The Android.mk makefile should pick up the new
  data file during the next build. But to make
  sure, a clean build might make sense.

- The various files named *smaller* and so on are
  older data files used previously. They contain
  either only English data (*reduced* and *smaller*)
  or the complete ICU data (*full*). They should be
  dropped in favor of the new file.

- If variants of the data file are needed for
  different locales/markets/devices, please
  create new manifests, generate data files from
  them, and wire them in android.mk.
