ARCHS = arm64
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PUBG_Patcher

PUBG_Patcher_FILES = Tweak.mm
PUBG_Patcher_CFLAGS = -fobjc-arc -std=c++11 -Wno-deprecated-declarations
PUBG_Patcher_FRAMEWORKS = UIKit Foundation
# إضافة -dynamiclib لضمان إنتاج ملف dylib متوافق مع الحقن التلقائي
PUBG_Patcher_LDFLAGS = -L. -ldobby -dynamiclib

include $(THEOS_MAKE_PATH)/tweak.mk
