# إعدادات المعمارية والسيرفر
TARGET := iphone:clang:latest:14.0
ARCHS = arm64

# استدعاء ملفات Theos الأساسية
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PUBG_Patcher

# ملف الكود الخاص بك (Objective-C++)
PUBG_Patcher_FILES = Tweak.mm

# إعدادات الكومبايلر (C++17 + ARC)
PUBG_Patcher_CFLAGS = -fobjc-arc -std=c++17 -Wno-unused-variable -Wno-unused-function

# المكتبات المطلوبة للواجهة
PUBG_Patcher_FRAMEWORKS = UIKit Foundation

# أمر مهم جداً: ربط مكتبة Dobby الموجودة بجانب الملف
# -L. تعني ابحث في المجلد الحالي
# -ldobby تعني اربط ملف libdobby.a
PUBG_Patcher_LDFLAGS = -L. -ldobby

include $(THEOS_MAKE_PATH)/tweak.mk
