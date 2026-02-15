TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PUBG_Patcher

# ملف الكود الخاص بك
PUBG_Patcher_FILES = Tweak.mm

# إعدادات الكومبايلر (تفعيل ARC وتجاهل تحذيرات معينة)
PUBG_Patcher_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# إضافة مكتبات الواجهة (مهمة لرسالة التنبيه)
PUBG_Patcher_FRAMEWORKS = UIKit Foundation

# ربط مكتبة Dobby (تأكد أن libdobby.a موجود بجانب الـ Makefile)
PUBG_Patcher_LDFLAGS = -L. -ldobby

include $(THEOS_MAKE_PATH)/tweak.mk
