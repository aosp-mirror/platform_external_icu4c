LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

subdirs := $(addprefix $(LOCAL_PATH)/,$(addsuffix /Makefile, \
		stubdata \
		common   \
		i18n     \
	))

include $(subdirs)
