//
//  Tweak.mm
//  PUBG_Anogs_Patcher_Final
//
//  Target: anogs (Framework)
//  Fixes: iOS 13+ UI, Dobby Headers
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <string.h>
#include "dobby.h"

// ---------------------------------------------------------
// 1. تعليمة NOP (ARM64)
// ---------------------------------------------------------
const uint32_t NOP_INSTRUCTION = 0xD503201F;

// ---------------------------------------------------------
// 2. قائمة الأوفستات الكاملة (672 أوفست)
// ---------------------------------------------------------
uintptr_t offsets_list[] = {
    // Source 1
    0x0009AD18, 0x000AD7D0, 0x000ADB50,
    // Source 2
    0x000D1478, 0x000D511C, 0x000E2618, 0x000E8AE8,
    // Source 3
    0x001029B0, 0x001029C8, 0x00104B10,
    // Source 4
    0x00104D2C, 0x00104DBC, 0x00104DC8, 0x00104DD4,
    // Source 5
    0x00104E9C, 0x001050F8, 0x0010ADC8,
    // Source 6
    0x0010AEF0, 0x0010AF0C, 0x0010AF18, 0x0010B438,
    // Source 7
    0x0010B448, 0x0010C3B4, 0x0010C6A0, 0x0010D2E8,
    // Source 8
    0x0010D37C, 0x0010D408, 0x0010D4A0,
    // Source 9
    0x0010DB68, 0x0010DE50, 0x0010EDD8, 0x0010F48C,
    // Source 10
    0x0010F648, 0x0010F9A4, 0x0010FEA4,
    // Source 11
    0x00110068, 0x00110564, 0x0011128C, 0x00111B38,
    // Source 12
    0x00111D38, 0x00111DFC, 0x00111FA0,
    // Source 13
    0x001126F0, 0x00112DA8, 0x00113320, 0x001136BC,
    // Source 14
    0x0011374C, 0x001139EC, 0x00114DA4, 0x00115650,
    // Source 15
    0x00115920, 0x00116CAC, 0x00116FA8,
    // Source 16
    0x00118250, 0x00119F5C, 0x00119F7C, 0x0011A038,
    // Source 17
    0x0011A1D4, 0x0011B044, 0x0011B114,
    // Source 18
    0x0011C628, 0x0011C6B0, 0x0011C704, 0x0011CB58,
    // Source 19
    0x0011CBE4, 0x0011CC0C, 0x0011CC44,
    // Source 20
    0x0011CDF4, 0x0011CE98, 0x0011D4C0, 0x0011D4E4,
    // Source 21
    0x0011D5A4, 0x0011D5E8, 0x0011DBF8, 0x0011DDA4,
    // Source 22
    0x0011E3B4, 0x0011E4B0, 0x0011E5A0,
    // Source 23
    0x0011E638, 0x0011EA80, 0x0011ECC4, 0x0011EF78,
    // Source 24
    0x0011EFA0, 0x0011F0D8, 0x0011F214,
    // Source 25
    0x0011F658, 0x0011F6AC, 0x00120218, 0x00120404,
    // Source 26
    0x001204F0, 0x001205C4, 0x00120678,
    // Source 27
    0x00120730, 0x001207B4, 0x001207D4, 0x001208AC,
    // Source 28
    0x001210C8, 0x0012199C, 0x00121B10, 0x00121E0C,
    // Source 29
    0x00122FA0, 0x00123664, 0x00123B50,
    // Source 30
    0x00123E60, 0x00124DE0, 0x001250C8, 0x001251E8,
    // Source 31
    0x0012570C, 0x00125970, 0x00125B94,
    // Source 32
    0x00125F94, 0x00125FAC, 0x001262F8, 0x001264D4,
    // Source 33
    0x001266BC, 0x00126748, 0x001267D4,
    // Source 34
    0x00126948, 0x00126A30, 0x00126A48, 0x0012734C,
    // Source 35
    0x001275D8, 0x001275F0, 0x0012765C, 0x001276C0,
    // Source 36
    0x00127710, 0x0012774C, 0x00127828,
    // Source 37
    0x0012827C, 0x00128500, 0x00128524, 0x00128598,
    // Source 38
    0x001285E0, 0x00128754, 0x001287BC,
    // Source 39
    0x001288B0, 0x00128A40, 0x00128AA8, 0x00128BDC,
    // Source 40
    0x00128C44, 0x001296EC, 0x00129724,
    // Source 41
    0x00129A70, 0x00129B9C, 0x00129BF8, 0x00129FAC,
    // Source 42
    0x0012A1E8, 0x001370A4, 0x001371F0, 0x001372AC,
    // Source 43
    0x001373F8, 0x0013763C, 0x001376A0,
    // Source 44
    0x0013772C, 0x001377CC, 0x001378D0, 0x00137AA0,
    // Source 45
    0x00137B1C, 0x00137DF0, 0x001382B4,
    // Source 46
    0x0013849C, 0x001385FC, 0x001386E8, 0x001388B8,
    // Source 47
    0x001388D4, 0x001388F8, 0x001389C8,
    // Source 48
    0x00138A3C, 0x00138CC8, 0x00139A74, 0x00139B60,
    // Source 49
    0x00139B70, 0x00139E58, 0x0013A0B4, 0x0013A1D8,
    // Source 50
    0x0013A234, 0x0013A460, 0x0013A498,
    // Source 51
    0x0013A560, 0x0013A598, 0x0013A65C, 0x0013A748,
    // Source 52
    0x0013A758, 0x0013A854, 0x0013C370,
    // Source 53
    0x0013C818, 0x0013DE94, 0x0013E150, 0x0013F094,
    // Source 54
    0x0013FE80, 0x001402C8, 0x00140358,
    // Source 55
    0x001404E0, 0x00140528, 0x001405C8, 0x001405D8,
    // Source 56
    0x00140680, 0x00140854, 0x00140EE8, 0x00140EF4,
    // Source 57
    0x00141254, 0x00141264, 0x0014151C,
    // Source 58
    0x00141AE0, 0x00141B0C, 0x00141B94, 0x00141C8C,
    // Source 59
    0x00141CB8, 0x00141D40, 0x00145EE8,
    // Source 60
    0x00146230, 0x00146544, 0x00146714, 0x00146754,
    // Source 61
    0x001468A4, 0x00146964, 0x00146A68,
    // Source 62
    0x001471D8, 0x00147D70, 0x00148420, 0x001486CC,
    // Source 63
    0x001486EC, 0x00148720, 0x001487A8, 0x0014885C,
    // Source 64
    0x00148950, 0x00148998, 0x001489C8,
    // Source 65
    0x00148A1C, 0x00148A8C, 0x00148BA8, 0x00148C24,
    // Source 66
    0x00148C88, 0x00148CD4, 0x00148D14,
    // Source 67
    0x00148D60, 0x0014A78C, 0x0014A898, 0x0014B038,
    // Source 68
    0x0014B054, 0x0014B33C, 0x0014B4D8,
    // Source 69
    0x0014B510, 0x0014B548, 0x0014B5D8, 0x0014B80C,
    // Source 70
    0x0014B96C, 0x0014CF88, 0x0014D0A4, 0x0014DB28,
    // Source 71
    0x0014DE68, 0x0014E5B4, 0x0014EB68,
    // Source 72
    0x0014F164, 0x0014F5F4, 0x0014F948, 0x0014FBA0,
    // Source 73
    0x0014FE68, 0x0014FED0, 0x0015000C,
    // Source 74
    0x00150054, 0x00150438, 0x00150780, 0x001507F4,
    // Source 75
    0x00150D74, 0x00150DB0, 0x00150E68,
    // Source 76
    0x001510E8, 0x0015112C, 0x00151514, 0x0015163C,
    // Source 77
    0x001517B0, 0x001518AC, 0x001519D0, 0x00152AD8,
    // Source 78
    0x00152D58, 0x001580F4, 0x0015839C,
    // Source 79
    0x0015917C, 0x0015929C, 0x00159694, 0x00159D74,
    // Source 80
    0x0015AAD8, 0x0015ADC0, 0x0015AE2C,
    // Source 81
    0x0015AE8C, 0x0015AEF8, 0x0015AF58, 0x0015AFC4,
    // Source 82
    0x0015B064, 0x0015B0C4, 0x0015B660,
    // Source 83
    0x0015B668, 0x0015B6AC, 0x0015B844, 0x0015B9F0,
    // Source 84
    0x0015BD40, 0x0015BD58, 0x0015BF68, 0x0015BFF8,
    // Source 85
    0x0015C0EC, 0x0015C474, 0x0015C504,
    // Source 86
    0x0015C594, 0x0015C670, 0x0015C758, 0x0015C9D4,
    // Source 87
    0x0015D6C8, 0x0015DDEC, 0x0015E164,
    // Source 88
    0x0015F824, 0x0015F9C4, 0x0015FA34, 0x0015FB84,
    // Source 89
    0x0015FBF4, 0x0015FD8C, 0x0015FDB8,
    // Source 90
    0x00160118, 0x00160438, 0x001604FC, 0x00160E44,
    // Source 91
    0x00161018, 0x00161348, 0x00161754, 0x0016195C,
    // Source 92
    0x00161974, 0x001619AC, 0x001619F8,
    // Source 93
    0x001620BC, 0x00162A68, 0x00162B18, 0x00162D1C,
    // Source 94
    0x00162E68, 0x00162F44, 0x00163028,
    // Source 95
    0x0016344C, 0x001635E4, 0x001639DC, 0x00163A9C,
    // Source 96
    0x00163D9C, 0x00163E3C, 0x001640FC,
    // Source 97
    0x00164188, 0x00164214, 0x001642FC, 0x001643DC,
    // Source 98
    0x00164410, 0x0016485C, 0x00164958, 0x00164D44,
    // Source 99
    0x00164E40, 0x001657FC, 0x00165C6C,
    // Source 100
    0x00165F14, 0x00165F90, 0x001692AC, 0x00169758,
    // Source 101
    0x001699D4, 0x0016AEA8, 0x0016AFC8,
    // Source 102
    0x0016B2F0, 0x0016B450, 0x0016BDC0, 0x0016BEF8,
    // Source 103
    0x0016C030, 0x0016CD7C, 0x0016D1B8,
    // Source 104
    0x0016D250, 0x0016D344, 0x0016D4DC, 0x0016DF28,
    // Source 105
    0x0016E650, 0x0016E8CC, 0x0016F9B0, 0x0016FA20,
    // Source 106
    0x0016FF90, 0x001700A4, 0x0017017C,
    // Source 107
    0x00170210, 0x00170308, 0x00170F10, 0x0017115C,
    // Source 108
    0x00171E40, 0x00172420, 0x001727C4,
    // Source 109
    0x00172830, 0x00172848, 0x00173C60, 0x00173EE0,
    // Source 110
    0x00174000, 0x00174014, 0x001743B0,
    // Source 111
    0x00174400, 0x00174658, 0x0017471C, 0x001747EC,
    // Source 112
    0x0017491C, 0x00174CE4, 0x001777B0, 0x00177A8C,
    // Source 113
    0x00177D48, 0x00178EFC, 0x001795B4,
    // Source 114
    0x001796A8, 0x0017979C, 0x0017A0F8, 0x0017A51C,
    // Source 115
    0x0017A7C4, 0x0017B354, 0x0017B4C8,
    // Source 116
    0x0017BC20, 0x0017CCA4, 0x0017D0FC, 0x0017D3E4,
    // Source 117
    0x0017E404, 0x0017E424, 0x0017EF9C,
    // Source 118
    0x0017F244, 0x0017FFE0, 0x001803D4, 0x001803F0,
    // Source 119
    0x00180784, 0x001807BC, 0x001807D0, 0x001809F4,
    // Source 120
    0x00180BEC, 0x00180C78, 0x00180D04,
    // Source 121
    0x00180FF8, 0x00181044, 0x001811E4, 0x001813AC,
    // Source 122
    0x001817E8, 0x00181808, 0x00181930,
    // Source 123
    0x00181968, 0x001831B4, 0x00184B24, 0x00184B38,
    // Source 124
    0x001851B8, 0x00185290, 0x00185770,
    // Source 125
    0x0018585C, 0x00185AE8, 0x00185E58, 0x001862C8,
    // Source 126
    0x00186460, 0x001865F8, 0x0018694C, 0x00186C18,
    // Source 127
    0x00187410, 0x001876F8, 0x00189394,
    // Source 128
    0x0018A9EC, 0x0018B31C, 0x0018B740, 0x0018B9E8,
    // Source 129
    0x0018F948, 0x0018FFD4, 0x001903E4,
    // Source 130
    0x0019080C, 0x00191FC0, 0x00192008, 0x001920A8,
    // Source 131
    0x00192114, 0x001922F4, 0x0019295C,
    // Source 132
    0x00192AB0, 0x00192FE4, 0x001937E8, 0x00193CEC,
    // Source 133
    0x00193FB0, 0x0019445C, 0x00194A10, 0x00194BB0,
    // Source 134
    0x00194D8C, 0x00194F6C, 0x001952D8, 0x0019575C,
    // Source 135
    0x001A1EF4, 0x001A1FF8, 0x001A2018,
    // Source 136
    0x001A20CC, 0x001A2264, 0x001A2284, 0x001A22E4,
    // Source 137
    0x001A2348, 0x001A3114, 0x001A33C8,
    // Source 138
    0x001A33D8, 0x001A35B4, 0x001A3F1C,
    // Source 139
    0x001A3F54, 0x001A4020, 0x001A402C, 0x001A4144,
    // Source 140
    0x001A4150, 0x001A4504, 0x001A4538, 0x001A47B8,
    // Source 141
    0x001A47D8, 0x001A4850, 0x001A48B8,
    // Source 142
    0x001A4CD8, 0x001A500C, 0x001A5114, 0x001A5144,
    // Source 143
    0x001A5190, 0x001A51E0, 0x001A5234,
    // Source 144
    0x001A52A0, 0x001A5638, 0x001A5724, 0x001A5AAC,
    // Source 145
    0x001A5BEC, 0x001A65E8, 0x001A66D4,
    // Source 146
    0x001A6840, 0x001A6E38, 0x001A6E44, 0x001A6ED8,
    // Source 147
    0x001A6FC4, 0x001A6FD0, 0x001A7104, 0x001A7110,
    // Source 148
    0x001A71A8, 0x001A7338, 0x001A7344,
    // Source 149
    0x001A7744, 0x001A7800, 0x001A78B4, 0x001A8284,
    // Source 150
    0x001A86CC, 0x001A88C0, 0x001A8ADC,
    // Source 151
    0x001A9158, 0x001A9198, 0x001A91D8, 0x001B2148,
    // Source 152
    0x001B28BC, 0x001B36DC, 0x001B3BBC,
    // Source 153
    0x001B4644, 0x001B48C0, 0x001B536C, 0x001B55E8,
    // Source 154
    0x001B62EC, 0x001B64A0, 0x001B6864, 0x001B692C,
    // Source 155
    0x001B6990, 0x001B6A74, 0x001B6AA8,
    // Source 156
    0x001B6B4C, 0x001B6C38, 0x001B6CC8, 0x001B6DA8,
    // Source 157
    0x001B6DE4, 0x001B6EC8, 0x001B6F90,
    // Source 158
    0x001B7078, 0x001B725C, 0x001B75B8, 0x001B75D4,
    // Source 159
    0x001B75F0, 0x001B7634, 0x001B7690,
    // Source 160
    0x001B789C, 0x001B7C4C, 0x001B7C88, 0x001B7CE0,
    // Source 161
    0x001B7D80, 0x001B9808, 0x001B98CC, 0x001B9AE8,
    // Source 162
    0x001BA174, 0x001BACBC, 0x001BB03C,
    // Source 163
    0x001CEF10, 0x001CF43C, 0x001CF844, 0x001D2694,
    // Source 164
    0x001D2704, 0x001D2800, 0x001D28D4,
    // Source 165
    0x001D29A8, 0x001D2DBC, 0x001D334C, 0x001D387C,
    // Source 166
    0x001D389C, 0x001D38D8, 0x001D397C,
    // Source 167
    0x001D39A8, 0x001EED3C, 0x001EEDA8, 0x001EEDD0,
    // Source 168
    0x001EF2CC, 0x001F13D0, 0x001F147C, 0x001F169C,
    // Source 169
    0x001F2C34, 0x001F2CB0, 0x001F33E8,
    // Source 170
    0x001F3400, 0x00201204, 0x002016EC, 0x00203AF8,
    // Source 171
    0x00203B10, 0x00206508, 0x0020654C,
    // Source 172
    0x00209208, 0x002094CC, 0x0020AAE8, 0x0020B074,
    // Source 173
    0x0020B470, 0x0020BA90, 0x0020BAB0, 0x0020BAFC,
    // Source 174
    0x0020BB40, 0x0020C204, 0x0020C664, 0x0020E588,
    // Source 175
    0x0020E7BC, 0x0020ED98, 0x00211090, 0x002111FC,
    // Source 176
    0x002113BC, 0x00213D3C, 0x00214C6C, 0x0021C488,
    // Source 177
    0x0021C4F0, 0x0021D740, 0x0021D808, 0x0021D998,
    // Source 178
    0x0021E868, 0x0021F650, 0x0021F810, 0x0021F9B8,
    // Source 179
    0x0021FF14, 0x0022019C, 0x00222340,
    // Source 180
    0x00222688, 0x00225204, 0x00226128, 0x00227070,
    // Source 181
    0x00227540, 0x00227880, 0x00228970, 0x00228E40,
    // Source 182
    0x00229180, 0x00229898, 0x0022A328, 0x0022B92C,
    // Source 183
    0x0022B978, 0x0022BA58, 0x0022BAC4, 0x0022D510,
    // Source 184
    0x0023104C, 0x00231278, 0x002312DC, 0x002318D4,
    // Source 185
    0x00232B18, 0x00232EE0, 0x00232F34, 0x00233BE0,
    // Source 186
    0x00233C4C, 0x0023569C, 0x00235FF4, 0x002393B0,
    // Source 187
    0x00239414, 0x00239B08
};

// ---------------------------------------------------------
// 3. دالة البحث عن anogs (حروف صغيرة)
// ---------------------------------------------------------
intptr_t GetAnogsSlide() {
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char *name = _dyld_get_image_name(i);
        // البحث عن anogs بالحروف الصغيرة
        if (name && strstr(name, "anogs")) {
            return _dyld_get_image_vmaddr_slide(i);
        }
    }
    return 0;
}

// ---------------------------------------------------------
// 4. دالة الإشعار الحديثة (iOS 13+ Fixed)
// ---------------------------------------------------------
void ShowAlert(NSString *title, NSString *message) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *window = nil;
        
        // دعم iOS 13+ (Scenes)
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *w in scene.windows) {
                        if (w.isKeyWindow) {
                            window = w;
                            break;
                        }
                    }
                }
                if (window) break;
            }
        }
        
        // دعم iOS القديم مع إخفاء التحذير
        if (!window) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            window = [UIApplication sharedApplication].keyWindow;
            #pragma clang diagnostic pop
        }

        if (!window) return;

        UIViewController *topController = window.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }

        if (!topController) return;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        [alert addAction:okAction];
        [topController presentViewController:alert animated:YES completion:nil];
    });
}

// ---------------------------------------------------------
// 5. منطق الحقن
// ---------------------------------------------------------
void ApplyPatches() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        intptr_t slide = GetAnogsSlide();
        
        if (slide == 0) {
            ShowAlert(@"❌ Error", @"Module 'anogs' not found!");
            return;
        }
        
        @try {
            size_t count = sizeof(offsets_list) / sizeof(offsets_list[0]);
            int success_counter = 0;

            for (size_t i = 0; i < count; i++) {
                void* target_addr = (void*)(slide + offsets_list[i]);
                DobbyCodePatch(target_addr, (uint8_t *)&NOP_INSTRUCTION, sizeof(NOP_INSTRUCTION));
                success_counter++;
            }

            NSString *msg = [NSString stringWithFormat:@"Patched %d/672 offsets in 'anogs'.", success_counter];
            ShowAlert(@"✅ Success", msg);
            
        } @catch (NSException *exception) {
            ShowAlert(@"❌ Crash", exception.reason);
        }
    });
}

__attribute__((constructor))
void init() {
    ApplyPatches();
}
