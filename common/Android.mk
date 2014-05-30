# Copyright (C) 2008 The Android Open Source Project
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


LOCAL_PATH:= $(call my-dir)

#
# Common definitions.
#

src_files := \
	cmemory.c          cstring.c          \
	cwchar.c           locmap.c           \
	lrucache.cpp \
	punycode.cpp       putil.cpp          \
	sharedobject.cpp \
	simplepatternformatter.cpp \
	uarrsort.c         ubidi.c            \
	ubidiln.c          ubidi_props.c      \
	ubidiwrt.c         ucase.cpp          \
	ucasemap.cpp       ucat.c             \
	uchar.c            ucln_cmn.c         \
	ucmndata.c                            \
	ucnv2022.cpp       ucnv_bld.cpp       \
	ucnvbocu.cpp       ucnv.c             \
	ucnv_cb.c          ucnv_cnv.c         \
	ucnvdisp.c         ucnv_err.c         \
	ucnv_ext.cpp       ucnvhz.c           \
	ucnv_io.cpp        ucnvisci.c         \
	ucnvlat1.c         ucnv_lmb.c         \
	ucnvmbcs.c         ucnvscsu.c         \
	ucnv_set.c         ucnv_u16.c         \
	ucnv_u32.c         ucnv_u7.c          \
	ucnv_u8.c                             \
	udatamem.c         \
	udataswp.c         uenum.c            \
	uhash.c            uinit.cpp          \
	uinvchar.c         uloc.cpp           \
	umapfile.c         umath.c            \
	umutex.cpp         unames.cpp         \
	uresbund.cpp       \
	ures_cnv.c         uresdata.c         \
	usc_impl.c         uscript.c          \
	uscript_props.cpp  \
	ushape.cpp         ustrcase.cpp       \
	ustr_cnv.c         ustrfmt.c          \
	ustring.cpp        ustrtrns.cpp       \
	ustr_wcs.cpp       utf_impl.c         \
	utrace.c           utrie.cpp          \
	utypes.c           wintz.c            \
	utrie2_builder.cpp icuplug.c          \
	propsvec.c         ulist.c            \
	uloc_tag.c         ucnv_ct.c

src_files += \
        bmpset.cpp      unisetspan.cpp   \
	brkeng.cpp      brkiter.cpp      \
	caniter.cpp     chariter.cpp     \
	dictbe.cpp	locbased.cpp     \
	locid.cpp       locutil.cpp      \
	normlzr.cpp     parsepos.cpp     \
	propname.cpp    rbbi.cpp         \
	rbbidata.cpp    rbbinode.cpp     \
	rbbirb.cpp      rbbiscan.cpp     \
	rbbisetb.cpp    rbbistbl.cpp     \
	rbbitblb.cpp    resbund_cnv.cpp  \
	resbund.cpp     ruleiter.cpp     \
	schriter.cpp    serv.cpp         \
	servlk.cpp      servlkf.cpp      \
	servls.cpp      servnotf.cpp     \
	servrbf.cpp     servslkf.cpp     \
	ubrk.cpp         \
	uchriter.cpp    uhash_us.cpp     \
	uidna.cpp       uiter.cpp        \
	unifilt.cpp     unifunct.cpp     \
	uniset.cpp      uniset_props.cpp \
	unistr_case.cpp unistr_cnv.cpp   \
	unistr.cpp      unistr_props.cpp \
	unormcmp.cpp    unorm.cpp        \
	uobject.cpp     uset.cpp         \
	usetiter.cpp    uset_props.cpp   \
	usprep.cpp      ustack.cpp       \
	ustrenum.cpp    utext.cpp        \
	util.cpp        util_props.cpp   \
	uvector.cpp     uvectr32.cpp     \
	errorcode.cpp                    \
	bytestream.cpp  stringpiece.cpp  \
	dtintrv.cpp      \
	ucnvsel.cpp     uvectr64.cpp     \
	locavailable.cpp         locdispnames.cpp   \
	loclikely.cpp            locresdata.cpp     \
	normalizer2impl.cpp      normalizer2.cpp    \
	filterednormalizer2.cpp  ucol_swp.cpp       \
	uprops.cpp      utrie2.cpp \
        charstr.cpp     uts46.cpp \
        udata.cpp   appendable.cpp  bytestrie.cpp \
        bytestriebuilder.cpp  bytestrieiterator.cpp \
        messagepattern.cpp patternprops.cpp stringtriebuilder.cpp \
        ucharstrie.cpp ucharstriebuilder.cpp ucharstrieiterator.cpp \
	dictionarydata.cpp \
	ustrcase_locale.cpp unistr_titlecase_brkiter.cpp \
	uniset_closure.cpp ucasemap_titlecase_brkiter.cpp \
	ustr_titlecase_brkiter.cpp unistr_case_locale.cpp \
	listformatter.cpp


# This is the empty compiled-in icu data structure
# that we need to satisfy the linker.
src_files += ../stubdata/stubdata.c

c_includes := \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/../i18n

# We make the ICU data directory relative to $ANDROID_ROOT on Android, so both
# device and sim builds can use the same codepath, and it's hard to break one
# without noticing because the other still works.
local_cflags := '-DICU_DATA_DIR_PREFIX_ENV_VAR="ANDROID_ROOT"'
local_cflags += '-DICU_DATA_DIR="/usr/icu"'

# bionic doesn't have <langinfo.h>.
local_cflags += -DU_HAVE_NL_LANGINFO_CODESET=0

local_cflags += -D_REENTRANT
local_cflags += -DU_COMMON_IMPLEMENTATION

local_cflags += -O3 -fvisibility=hidden

#
# Build for the target (device).
#

include $(CLEAR_VARS)
LOCAL_SRC_FILES += $(src_files)
LOCAL_C_INCLUDES += $(c_includes) $(optional_android_logging_includes)
LOCAL_CFLAGS += $(local_cflags) -DPIC -fPIC
LOCAL_SHARED_LIBRARIES += libdl $(optional_android_logging_libraries)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libicuuc
LOCAL_ADDITIONAL_DEPENDENCIES += $(LOCAL_PATH)/Android.mk
LOCAL_REQUIRED_MODULES += icu-data
LOCAL_RTTI_FLAG := -frtti
include external/libcxx/libcxx.mk
include $(BUILD_SHARED_LIBRARY)

#
# Build for the host.
#

include $(CLEAR_VARS)
LOCAL_SRC_FILES += $(src_files)
LOCAL_C_INCLUDES += $(c_includes) $(optional_android_logging_includes)
LOCAL_CFLAGS += $(local_cflags)
LOCAL_SHARED_LIBRARIES += $(optional_android_logging_libraries)
LOCAL_LDLIBS += -ldl -lm -lpthread
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libicuuc-host
LOCAL_ADDITIONAL_DEPENDENCIES += $(LOCAL_PATH)/Android.mk
LOCAL_REQUIRED_MODULES += icu-data-host
include $(BUILD_HOST_SHARED_LIBRARY)

#
# Build as a static library against the NDK
#

include $(CLEAR_VARS)
LOCAL_SDK_VERSION := 9
LOCAL_NDK_STL_VARIANT := stlport_static
LOCAL_C_INCLUDES += $(c_includes)
LOCAL_EXPORT_C_INCLUDES += $(LOCAL_PATH)
LOCAL_CPP_FEATURES := rtti
LOCAL_CFLAGS += $(local_cflags) -DPIC -fPIC -frtti
# Using -Os over -O3 actually cuts down the final executable size by a few dozen kilobytes
LOCAL_CFLAGS += -Os
LOCAL_EXPORT_CFLAGS += -DU_STATIC_IMPLEMENTATION=1
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libicuuc_static
LOCAL_SRC_FILES += $(src_files)
LOCAL_REQUIRED_MODULES += icu-data
include $(BUILD_STATIC_LIBRARY)
