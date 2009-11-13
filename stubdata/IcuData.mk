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
# Common definitions used for building ICU data files.
#
# Prior to including this file, the following variables should be
# set for each variant:
#
#     LOCAL_MODULE -- set (as usual) to name the module being built
#     data_file_name -- the name of the prebuilt data file to use
#     output_file_name -- the name of the output source file
#     required_config -- the name of the configuration that requires this data
#
# And these variables need to be set before the first variant is defined.
# This is done in the preamble of the Android.mk file in this directory:
#
#     config -- current configuration
#     icu_var_name -- name of the symbol that needs to be defined in the
#         data file
#

LOCAL_MODULE_CLASS := SHARED_LIBRARIES

# This sets LOCAL_PRELINK_MODULE := false because the prelink map
# requires a unique address for each shared library, but all the
# variants of libicudata.so actually need to be mapped at the same
# address so they can be interchangable.
LOCAL_PRELINK_MODULE := false

ifeq ($(config),$(required_config))
	LOCAL_MODULE_STEM := libicudata
	LOCAL_MODULE_TAGS := user
else
	LOCAL_MODULE_TAGS := optional
endif

intermediates := $(call local-intermediates-dir)
icu_data_file := $(LOCAL_PATH)/$(data_file_name)

asm_file := $(intermediates)/$(output_file_name)
LOCAL_GENERATED_SOURCES += $(asm_file)

$(asm_file): PRIVATE_VAR_NAME := $(icu_var_name)
$(asm_file): $(icu_data_file) $(ICUDATA)
	@echo icudata: $@
	$(hide) mkdir -p $(dir $@)
	$(hide) $(ICUDATA) $(PRIVATE_VAR_NAME) < $< > $@

LOCAL_CFLAGS  += -D_REENTRANT -DPIC -fPIC
LOCAL_CFLAGS  += -O3 -nodefaultlibs -nostdlib
