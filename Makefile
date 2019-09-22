THEOS_DEVICE_IP = 10.0.0.186

ARCHS = arm64 arm64e 

DEBUG = 1C

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Okapi
Okapi_FILES = Tweak.xm
Okapi_EXTRA_FRAMEWORKS = Cephei
Okapi_LIBRARIES = colorpicker

BUNDLE_NAME = com.mtac.okapi
com.mtac.okapi_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "sbreload"
SUBPROJECTS += okapiprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
