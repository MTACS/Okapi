TARGET := iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = OkapiPrefs

OkapiPrefs_FILES = OkapiRootListController.xm
OkapiPrefs_FRAMEWORKS = UIKit
OkapiPrefs_LIBRARIES = sparkcolourpicker
OkapiPrefs_PRIVATE_FRAMEWORKS = Preferences
OkapiPrefs_INSTALL_PATH = /Library/PreferenceBundles
OkapiPrefs_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/bundle.mk
