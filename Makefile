TARGET := iphone:clang:latest:13.0
SYSROOT = $(THEOS)/sdks/iPhoneOS14.2.sdk
INSTALL_TARGET_PROCESSES = Zebra
ARCHS = arm64 arm64e
DEBUG = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Okapi

Okapi_FILES = Tweak.xm $(wildcard *.m)
Okapi_LIBRARIES = sparkcolourpicker
Okapi_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += okapiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
