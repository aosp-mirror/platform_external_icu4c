#!/usr/bin/env python
#
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Generate ICU dat files for locale relevant resources.
#
# Usage:
#    icu_dat_generator.py [-v] [-h] ICU-VERSION
#
# Sample usage:
#   $ANDROID_BUILD_TOP/external/icu4c/stubdata$ ./icu_dat_generator.py --verbose 4.4
#
#  Add new dat file:
#    1. Add icudtxxl-<datname>.txt to $ANDROID_BUILD_TOP/external/icu4c/stubdata.
#       Check the example file under
#       $ANDROID_BUILD_TOP/external/icu4c/stubdata/icudt42l-us.txt
#    2. Add an entry to main() --> datlist[]
#    3. Run this script to generate dat files.
#
#  For ICU upgrade
#    We cannot get CLDR version from dat file unless calling ICU function.
#    If there is a CLDR version change, please modify "global CLDR_VERSION".

import getopt
import os.path
import re
import shutil
import subprocess
import sys


def PrintHelpAndExit():
  print "Usage:"
  print "  icu_dat_generator.py [-v|--verbose] [-h|--help] ICU-VERSION"
  print "Example:"
  print "  $ANDROID_BUILD_TOP/external/icu4c/stubdata$ ./icu_dat_generator.py 4.4"
  sys.exit(1)


def InvokeIcuTool(tool, working_dir, args):
  command_list = [os.path.join(GetIcuPrebuiltDir(), tool)]
  command_list.extend(args)

  if VERBOSE:
    command = "[%s] %s" % (working_dir, " ".join(command_list))
    print command

  ret = subprocess.call(command_list, cwd = working_dir)
  if ret != 0:
    sys.exit(command_list[0:])


def GetIcuPrebuiltDir():
  return os.path.join(os.environ.get("ANDROID_EABI_TOOLCHAIN"),  "..", "..",
                      "..", "icu-" + ICU_VERSION)


def ExtractAllResourceToTempDir():
  # copy icudtxxl-all.dat to icudtxxl.dat
  source_dat = os.path.join(ICU4C_DIR, "stubdata", ICUDATA + "-all.dat")
  dest_dat = os.path.join(ICU4C_DIR, "stubdata", ICUDATA_DAT)
  shutil.copyfile(source_dat, dest_dat)
  InvokeIcuTool("icupkg", None, [dest_dat, "-x", "*", "-d", TMP_DAT_PATH])


def MakeDat(icu_dat_path, dat_name):
  # Get the resource list. e.g. icudt42l-us.txt, icudt42l-default.txt.
  dat_list_file_path = os.path.join(icu_dat_path, ICUDATA + "-" + dat_name + ".txt")
  print "------ Processing '%s'..." % (dat_list_file_path)
  if not os.path.isfile(dat_list_file_path):
    print "%s not present for resource list." % dat_list_file_path
    return
  GenResIndex(dat_list_file_path)
  CopyAndroidCnvFiles(icu_dat_path)
  os.chdir(TMP_DAT_PATH)
  # Run command such as "icupkg -tl -s icudt42l -a icudt42l-us.txt new icudt42l.dat".
  args = ["-tl", "-s", TMP_DAT_PATH, "-a", dat_list_file_path, "new", ICUDATA_DAT]
  InvokeIcuTool("icupkg", None, args)


def WriteIndex(path, list, cldr_version = None):
  res_index = "res_index.txt"
  empty_value = " {\"\"}\n"  # key-value pair for all locale entries

  f = open(path, "w")
  f.write("res_index:table(nofallback) {\n")
  if cldr_version:
    f.write("  CLDRVersion { %s }\n" % cldr_version)
  f.write("  InstalledLocales {\n")
  for item in list:
    f.write(item + empty_value)

  f.write("  }\n")
  f.write("}\n")
  f.close()


def AddResFile(collection, path):
  end = path.find(".res")
  if end > 0:
    collection.add(path[path.find("/")+1:end])
  else:
    # TODO: this is a bug, right? we really just wanted to strip the extension,
    # and don't care whether it was .res or not?
    print "warning: ignoring '%s'; not a .res file" % (path.rstrip())
  return


# Open input file (such as icudt42l-us.txt).
# Go through the list and generate res_index.txt for locales, brkitr,
# coll, et cetera.
def GenResIndex(dat_list_file_path):
  res_index = "res_index.txt"

  brkitrs = set()
  colls = set()
  currs = set()
  langs = set()
  locales = set()
  regions = set()
  zones = set()

  for line in open(dat_list_file_path, "r"):
    if "root." in line or "res_index" in line or "_.res" in line:
      continue;
    if "brkitr/" in line:
      AddResFile(brkitrs, line)
    elif "coll/" in line:
      AddResFile(colls, line)
    elif "curr/" in line:
      AddResFile(currs, line)
    elif "lang/" in line:
      AddResFile(langs, line)
    elif "region/" in line:
      AddResFile(regions, line)
    elif "zone/" in line:
      AddResFile(zones, line)
    elif ".res" in line:
      # We need to determine the resource is locale resource or misc resource.
      # To determine the locale resource, we assume max script length is 3.
      end = line.find(".res")
      if end <= 3 or (line.find("_") <= 3 and line.find("_") > 0):
        locales.add(line[:end])

  kind_to_locales = {
    "brkitr": brkitrs,
    "coll": colls,
    "curr": currs,
    "lang": langs,
    "locales": locales,
    "region": regions,
    "zone": zones
  }

  # Find every locale we've mentioned, for whatever reason.
  every_locale = set()
  for locales in kind_to_locales.itervalues():
    every_locale = every_locale.union(locales)

  if VERBOSE:
    for kind, locales in kind_to_locales.items():
      print "%s=%s" % (kind, sorted(locales))
    print "every_locale=" % sorted(every_locale)

  # Find cases where we've included only part of a locale's data.
  missing_files = []
  for locale in every_locale:
    for kind, locales in kind_to_locales.items():
      p = os.path.join(ICU4C_DIR, "data", kind, locale + ".txt")
      if not locale in locales and os.path.exists(p):
        missing_files.append(p)

  # Warn about the missing files.
  for missing_file in sorted(missing_files):
    print "warning: %s exists but isn't included in %s" % (missing_file, dat_list_file_path)

  # Write the genrb input files.
  WriteIndex(os.path.join(TMP_DAT_PATH, res_index), locales, CLDR_VERSION)
  for kind, locales in kind_to_locales.items():
    if kind == "locales":
      continue
    WriteIndex(os.path.join(TMP_DAT_PATH, kind, res_index), locales)

  # Call genrb to generate new res_index.res.
  InvokeIcuTool("genrb", TMP_DAT_PATH, [res_index])
  for kind, locales in kind_to_locales.items():
    if kind == "locales":
      continue
    InvokeIcuTool("genrb", os.path.join(TMP_DAT_PATH, kind), [res_index])


def CopyAndroidCnvFiles(icu_dat_path):
  android_specific_cnv = ["gsm-03.38-2000.cnv",
                          "iso-8859_16-2001.cnv",
                          "docomo-shift_jis-2007.cnv",
                          "kddi-jisx-208-2007.cnv",
                          "kddi-shift_jis-2007.cnv",
                          "softbank-jisx-208-2007.cnv",
                          "softbank-shift_jis-2007.cnv"]
  for cnv_file in android_specific_cnv:
    source_path = os.path.join(icu_dat_path, "cnv", cnv_file)
    dest_path = os.path.join(TMP_DAT_PATH, cnv_file)
    shutil.copyfile(source_path, dest_path)
    if VERBOSE:
      print "copy " + source_path + " " + dest_path


def main():
  global ANDROID_BUILD_TOP  # $ANDROID_BUILD_TOP
  global ICU4C_DIR     # $ANDROID_BUILD_TOP/external/icu4c
  global ICU_VERSION   # ICU version number
  global ICUDATA       # e.g. "icudt42l"
  global ICUDATA_DAT   # e.g. "icudt42l.dat"
  global CLDR_VERSION  # CLDR version. The value can be vary upon ICU release.
  global TMP_DAT_PATH  # temp directory to store all resource files and
                       # intermediate dat files.
  global VERBOSE

  VERBOSE = False

  show_help = False
  try:
    opts, args = getopt.getopt(sys.argv[1:], 'hv', ['help', 'verbose'])
  except getopt.error:
    PrintHelpAndExit()
  for opt, arg in opts:
    if opt in ('-h', '--help'):
      show_help = True
    elif opt in ('-v', '--verbose'):
      VERBOSE = True
  if len(args) < 1:
    show_help = True

  if show_help:
    PrintHelpAndExit()

  # TODO: is there any advantage to requiring this as an argument? couldn't we just glob it from
  # the file system, looking for "icudt\d+l.*\.txt"?
  ICU_VERSION = args[0]
  if re.search(r'[0-9]+\.[0-9]+', ICU_VERSION) == None:
    print "'%s' is not a valid icu version number!" % (ICU_VERSION)
    sys.exit(1)
  ICUDATA = "icudt" + re.sub(r'([^0-9])', "", ICU_VERSION) + "l"
  CLDR_VERSION = "1.8"
  ANDROID_BUILD_TOP = os.environ.get("ANDROID_BUILD_TOP")
  if not ANDROID_BUILD_TOP:
    print "$ANDROID_BUILD_TOP not set! Run 'env_setup.sh'."
    sys.exit(1)
  ICU4C_DIR = os.path.join(ANDROID_BUILD_TOP, "external", "icu4c")

  ICUDATA_DAT = ICUDATA + ".dat"
  # Check for required source files.
  stubdata_dir = os.path.join(ICU4C_DIR, "stubdata")
  full_data_filename = os.path.join(stubdata_dir, ICUDATA + "-all.dat")
  if not os.path.isfile(full_data_filename):
    print "%s not present." % full_data_filename
    sys.exit(1)

  # Create a temporary working directory.
  TMP_DAT_PATH = os.path.join(ICU4C_DIR, "tmp")
  if os.path.exists(TMP_DAT_PATH):
    shutil.rmtree(TMP_DAT_PATH)
  os.mkdir(TMP_DAT_PATH)

  # Extract resource files from icudtxxl-all.dat to TMP_DAT_PATH.
  ExtractAllResourceToTempDir()

  # TODO: is there any advantage to hard-coding this? couldn't we just glob it from the file system?
  datlist = ["us", "us-euro", "default", "us-japan", "zh", "medium", "large"]
  for dat_subtag in datlist:
    output_filename = os.path.join(stubdata_dir, ICUDATA + "-" + dat_subtag + ".dat")
    MakeDat(stubdata_dir, dat_subtag)
    # Copy icudtxxl.dat to stubdata directory with corresponding subtag.
    shutil.copyfile(os.path.join(TMP_DAT_PATH, ICUDATA_DAT), output_filename)
    print "Generated ICU data: %s" % (output_filename)

  # Cleanup temporary working directory and icudtxxl.dat
  shutil.rmtree(TMP_DAT_PATH)
  os.remove(os.path.join(stubdata_dir, ICUDATA_DAT))

if __name__ == "__main__":
  main()
