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

# ######################################################################
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
# >>> base list goes here once we have it <<<
#
# ######################################################################
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

##
icu_data_file := $(LOCAL_PATH)/icudt38l.dat
icu_var_name := icudt38_dat
##

LOCAL_MODULE := libicudata
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
intermediates := $(call local-intermediates-dir)

asm_file := $(intermediates)/icu_data.S
LOCAL_GENERATED_SOURCES += $(asm_file)
$(asm_file): PRIVATE_VAR_NAME := $(icu_var_name)
$(asm_file): $(icu_data_file) $(ICUDATA)
	@echo icudata: $@
	$(hide) mkdir -p $(dir $@)
	$(hide) $(ICUDATA) $(PRIVATE_VAR_NAME) < $< > $@

LOCAL_CFLAGS  += -D_REENTRANT -DPIC -fPIC 
LOCAL_CFLAGS  += -O3 -nodefaultlibs -nostdlib 

include $(BUILD_SHARED_LIBRARY)
