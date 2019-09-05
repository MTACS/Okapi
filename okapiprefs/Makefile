ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = okapiprefs
okapiprefs_FILES = Preferences.m
okapiprefs_INSTALL_PATH = /Library/PreferenceBundles
okapiprefs_FRAMEWORKS = UIKit
okapiprefs_PRIVATE_FRAMEWORKS = Preferences
okapiprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/okapiprefs.plist$(ECHO_END)
