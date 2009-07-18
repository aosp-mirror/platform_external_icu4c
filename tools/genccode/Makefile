LOCAL_PATH:= $(call my-dir)

# the device command line tool
include $(CLEAR_VARS)

LOCAL_SRC_FILES := genccode.c

LOCAL_C_INCLUDES +=            \
	$(LOCAL_PATH)/../toolutil  \
	$(LOCAL_PATH)/../../common

LOCAL_STATIC_LIBRARIES := libicutu libicuuc libicui18n

ifneq ($(DEVICE_ARCH),arm)
LOCAL_LDLIBS += -lpthread -ldl
endif

LOCAL_CFLAGS :=

LOCAL_TARGET := genccode

# the host command line tool


include $(BUILD_HOST_EXECUTABLE)
