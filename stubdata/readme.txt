This directory is used for building our Android
ICU data file. Unfortunately this requires some
manual tweaking, since the ICU build process is
not (yet) completely integrated into the Android
one.

Quick tour:

- icudt38l/* contains the resources in unpacked
  form. It includes everything that comes with
  a vanilla ICU 3.8 as well as two additional
  encodings required by Android. These two are
  gsm-03.38-2000.cnv and iso-8859_16-2001.cnv.
  Also, all character translation tables have
  been created with the "--small" option, so
  they use less space than in the vanilla ICU.

- icudt38l.txt contains the main manifest of our
  data file. It currently includes a lot of
  character conversion tables, locale data for
  English, German, Czech, and Dutch, as well as
  timezone information.

- Local manifest files named res_index.txt are
  residing in the following directories:
  
  - icudt38l
  - icudt38l/brkitr
  - icudt38l/coll
  - icudt38l/rbnf

  These also need to be updated to reflect any
  changes to the resources we want in Android.
  
- icudt38l.dat is our actual data file. The file
  currently needs to be rebuilt manually whenever
  one of the manifests changes (don't forget to
  submit!). This can be conveniently done by
  running ./helper.sh in this directory. Note:
  The script assumes you have done envsetup.sh
  and lunch before, because it relies on an
  enviroment variable pointing to the prebuilt
  tools. It also assumes the directory contents
  are writable, so you might want to do a
  
  g4 edit ...
  
  before you run it.
  
- The Android.mk makefile should pick up the new
  data file during the next build. But to make
  sure, a clean build might make sense.

- The various files named *smaller* and so on are
  older data files used previously. They contain
  either only English data (*reduced* and *smaller*)
  or the complete ICU data (*full*). They should be
  dropped in favor of the new file.
