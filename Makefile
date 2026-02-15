TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PUBG_Patcher

# ملف الكود
PUBG_Patcher_FILES = Tweak.mm

# إعدادات الكومبايلر:
# -Wno-error: لا تحول التحذيرات لأخطاء
# -Wno-module-import...: تجاهل أخطاء استيراد الموديولز
PUBG_Patcher_CFLAGS = -fobjc-arc -Wno-error -Wno-deprecated-declarations -Wno-module-import-in-extern-c

PUBG_Patcher_FRAMEWORKS = UIKit Foundation

# ربط مكتبة Dobby
PUBG_Patcher_LDFLAGS = -L. -ldobby

include $(THEOS_MAKE_PATH)/tweak.mk
