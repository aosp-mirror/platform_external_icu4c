LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	icudt38_dat_reduced.S
#	icudt38_dat_full.S

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH)/../common

LOCAL_CFLAGS  += -D_REENTRANT -DPIC -fPIC 
LOCAL_CFLAGS  += -O3 -nodefaultlibs -nostdlib 

LOCAL_MODULE := libicudata

include $(BUILD_SHARED_LIBRARY)
