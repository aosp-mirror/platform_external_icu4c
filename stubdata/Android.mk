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

#
# To get your own ICU userdata:
#
# Go to http://apps.icu-project.org/datacustom/ and configure yourself
# a data file.  Unzip the file it gives you, and save that somewhere,
# Set the icu_var_name variable to the location of that file in the tree.
#
# Make sure to choose ICU4C at the bottom.  You should also
# make sure to pick all of the following options, as they are required
# by the system.  Things will fail quietly if you don't have them:
#
# TODO: >>> base list goes here once we have it <<<
#


#
# Common definitions for all variants.
#

LOCAL_PATH:= $(call my-dir)

# Build configuration:
#
# "Large" includes all the supported locales.
# Japanese includes US and Japan.
# US-Euro is needed for IT or PL builds
# Default is suitable for CS, DE, EN, ES, FR, NL
# US has only EN and ES

config := $(word 1, \
            $(if $(findstring ar,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring da,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring el,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring fi,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring he,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring hr,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring hu,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring id,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring ko,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring nb,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring pt,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring ro,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring ru,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring sk,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring sr,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring sv,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring th,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring tr,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring uk,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring zh,$(PRODUCT_LOCALES)),large) \
            $(if $(findstring ja,$(PRODUCT_LOCALES)),us-japan) \
            $(if $(findstring it,$(PRODUCT_LOCALES)),us-euro) \
            $(if $(findstring pl,$(PRODUCT_LOCALES)),us-euro) \
            $(if $(findstring cs,$(PRODUCT_LOCALES)),default) \
            $(if $(findstring de,$(PRODUCT_LOCALES)),default) \
            $(if $(findstring fr,$(PRODUCT_LOCALES)),default) \
            $(if $(findstring nl,$(PRODUCT_LOCALES)),default) \
            us)

icu_var_name := icudt42_dat


#
# Japanese (for target)
#

include $(CLEAR_VARS)

LOCAL_MODULE := libicudata-jp

required_config := us-japan
data_file_name := icudt42l-us-japan.dat
output_file_name := icu_data_jp.S

include $(LOCAL_PATH)/IcuData.mk
include $(BUILD_SHARED_LIBRARY)


#
# Large (for target)
#

include $(CLEAR_VARS)
LOCAL_MODULE := libicudata-large

required_config := large
data_file_name := icudt42l-large.dat
output_file_name := icu_data_large.S

include $(LOCAL_PATH)/IcuData.mk
include $(BUILD_SHARED_LIBRARY)


#
# Euro (for target)
#

include $(CLEAR_VARS)
LOCAL_MODULE := libicudata-eu

required_config := us-euro
data_file_name := icudt42l-us-euro.dat
output_file_name := icu_data_eu.S

include $(LOCAL_PATH)/IcuData.mk
include $(BUILD_SHARED_LIBRARY)


#
# Default (for target)
#

include $(CLEAR_VARS)
LOCAL_MODULE := libicudata-default

required_config := default
data_file_name := icudt42l-default.dat
output_file_name := icu_data_default.S

include $(LOCAL_PATH)/IcuData.mk
include $(BUILD_SHARED_LIBRARY)


#
# US (for target)
#

include $(CLEAR_VARS)
LOCAL_MODULE := libicudata-us

required_config := us
data_file_name := icudt42l-us.dat
output_file_name := icu_data_us.S

include $(LOCAL_PATH)/IcuData.mk
include $(BUILD_SHARED_LIBRARY)


#
# Large (for host). This is the only config we support on the host,
# and you can see the "config" variable being set below for that
# reason.
#

ifeq ($(WITH_HOST_DALVIK),true)

    include $(CLEAR_VARS)
    LOCAL_MODULE := libicudata-large

    config := large
    required_config := large
    data_file_name := icudt42l-large.dat
    output_file_name := icu_data_large.S

    include $(LOCAL_PATH)/IcuData.mk
    include $(BUILD_HOST_SHARED_LIBRARY)

endif
