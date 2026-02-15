#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <string.h>
#include "dobby.h"

// مصفوفة فارغة للاختبار
uintptr_t offsets_list[] = {};

void ExecutePatch(intptr_t slide) {
    // لن يفعل شيئاً هنا لأن المصفوفة فارغة
    // هذا الاختبار للتأكد من أن الاستدعاء لا يسبب كراش
    NSLog(@"[TestLog] ExecutePatch called with slide: %p", (void*)slide);
}

void on_image_added(const struct mach_header *mh, intptr_t slide) {
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i) == mh) {
            const char *name = _dyld_get_image_name(i);
            if (name && strstr(name, "anogs")) {
                NSLog(@"[TestLog] Target Found: %s", name);
                
                // تشغيل المحرك وهو فارغ
                ExecutePatch(slide);
                
                // إظهار رسالة بسيطة للتأكد من الوصول لهذه النقطة
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"[TestLog] Showing test alert...");
                    // كود رسالة بسيط جداً للاختبار
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Test" message:@"Engine is Running!" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                });
            }
            break;
        }
    }
}

__attribute__((constructor))
static void init() {
    NSLog(@"[TestLog] Dylib Loaded into Process");
    _dyld_register_func_for_add_image(on_image_added);
}
