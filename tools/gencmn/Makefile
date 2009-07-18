LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := gencmn.c

LOCAL_STATIC_LIBRARIES := libicutu libicuuc libicui18n

ifneq ($(DEVICE_ARCH),arm)
LOCAL_LDLIBS += -lpthread -ldl
endif

LOCAL_CFLAGS += 

LOCAL_C_INCLUDES += \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/../toolutil \
	$(LOCAL_PATH)/../../common

LOCAL_TARGET := gencmn

include $(BUILD_HOST_EXECUTABLE)
