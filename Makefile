ARCHS = arm64
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PUBG_Patcher
PUBG_Patcher_FILES = Tweak.mm
PUBG_Patcher_CFLAGS = -fobjc-arc
# لا حاجة لـ Dobby الآن، المحرك مدمج في الكود
PUBG_Patcher_LDFLAGS = -dynamiclib
PUBG_Patcher_CODESIGN_FLAGS = -SEntitlements.plist

include $(THEOS_MAKE_PATH)/tweak.mk
