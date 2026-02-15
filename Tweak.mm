#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <string.h>
#include "dobby.h"

// ==========================================
// 1. تعريف أوامر ARM64
// ==========================================
const uint32_t NOP_HEX = 0xD503201F; // أمر NOP
const uint32_t RET_HEX = 0xD65F03C0; // أمر RET

// ==========================================
// 2. مصفوفة NOP (الأكثر أماناً)
// ==========================================
uintptr_t nop_offsets[] = {
    [span_3](start_span)0x00004380, 0x00104D2C, 0x00104DBC, 0x00104DC8,[span_3](end_span)
    [span_4](start_span)0x00104DD4, 0x00104E9C, 0x001050F8, 0x0010AEF0,[span_4](end_span)
    [span_5](start_span)0x0010AF0C, 0x0010AF18, 0x0010B438, 0x0010B448,[span_5](end_span)
    [span_6](start_span)0x0010C3B4, 0x0010C6A0, 0x0010DB68, 0x0010DE50,[span_6](end_span)
    [span_7](start_span)0x0010EDD8, 0x0010F48C, 0x0010F648, 0x0010F9A4,[span_7](end_span)
    [span_8](start_span)0x0010FEA4, 0x00110068, 0x00110564, 0x0011128C,[span_8](end_span)
    [span_9](start_span)0x00111B38, 0x00111D38, 0x00111DFC, 0x00112DA8,[span_9](end_span)
    [span_10](start_span)0x00113320, 0x001136BC, 0x0011374C, 0x001139EC,[span_10](end_span)
    [span_11](start_span)0x00114DA4, 0x00115650, 0x00115920, 0x00116CAC,[span_11](end_span)
    [span_12](start_span)0x00116FA8, 0x00118250, 0x00119F5C, 0x00119F7C,[span_12](end_span)
    [span_13](start_span)0x0011A038, 0x0011A1D4, 0x0011B044, 0x0011C6B0,[span_13](end_span)
    [span_14](start_span)0x0011C704, 0x0011CB58, 0x0011CBE4, 0x0011CC0C,[span_14](end_span)
    [span_15](start_span)0x0011CC44, 0x0011CDF4, 0x0011CE98, 0x0011D4C0,[span_15](end_span)
    [span_16](start_span)0x0011D4E4, 0x0011D5A4, 0x0011D5E8, 0x0011DDA4,[span_16](end_span)
    [span_17](start_span)0x0011E3B4, 0x0011E4B0, 0x0011E5A0, 0x0011E638,[span_17](end_span)
    [span_18](start_span)0x0011EA80, 0x0011ECC4, 0x0011EF78, 0x0011EFA0,[span_18](end_span)
    [span_19](start_span)0x0011F0D8, 0x0011F214, 0x0011F658, 0x0011F6AC,[span_19](end_span)
    [span_20](start_span)0x00120218, 0x00120404, 0x001204F0, 0x00120678,[span_20](end_span)
    [span_21](start_span)0x00120730, 0x001207B4, 0x001207D4, 0x001208AC,[span_21](end_span)
    [span_22](start_span)0x001210C8, 0x0012199C, 0x00121B10, 0x00121E0C,[span_22](end_span)
    [span_23](start_span)0x00122FA0, 0x00123664, 0x00123B50, 0x00123E60,[span_23](end_span)
    [span_24](start_span)0x00124DE0, 0x001250C8, 0x001251E8, 0x0012570C,[span_24](end_span)
    [span_25](start_span)0x00125970, 0x00125B94, 0x00125F94, 0x00125FAC,[span_25](end_span)
    [span_26](start_span)0x001262F8, 0x001264D4, 0x001266BC, 0x00126748,[span_26](end_span)
    [span_27](start_span)0x001267D4, 0x00126948, 0x00126A30, 0x00126A48,[span_27](end_span)
    [span_28](start_span)0x0012734C, 0x001275D8, 0x001275F0, 0x0012765C,[span_28](end_span)
    [span_29](start_span)0x001276C0, 0x00127710, 0x0012774C, 0x00127828,[span_29](end_span)
    [span_30](start_span)0x0012827C, 0x00128500, 0x00128598, 0x001285E0,[span_30](end_span)
    [span_31](start_span)0x00128754, 0x001287BC, 0x001288B0, 0x00128A40,[span_31](end_span)
    [span_32](start_span)0x00128AA8, 0x00128BDC, 0x00128C44, 0x001296EC,[span_32](end_span)
    [span_33](start_span)0x00129724, 0x00129B9C, 0x00129BF8, 0x00129FAC,[span_33](end_span)
    [span_34](start_span)0x0012A1E8, 0x001370A4, 0x001371F0, 0x001372AC,[span_34](end_span)
    [span_35](start_span)0x001373F8, 0x00137624, 0x0013763C, 0x001376A0,[span_35](end_span)
    [span_36](start_span)0x0013772C, 0x001377CC, 0x001378D0, 0x0013796C,[span_36](end_span)
    [span_37](start_span)0x00137AA0, 0x00137B1C, 0x00137DF0, 0x00138168,[span_37](end_span)
    [span_38](start_span)0x001382B4, 0x0013849C, 0x001385FC, 0x001386E8,[span_38](end_span)
    [span_39](start_span)0x001388B8, 0x001388D4, 0x001388F8, 0x001389C8,[span_39](end_span)
    [span_40](start_span)0x00138A3C, 0x00138C00, 0x00138CC8, 0x00139A74,[span_40](end_span)
    [span_41](start_span)0x00139B60, 0x00139B70, 0x00139E58, 0x0013A0B4,[span_41](end_span)
    [span_42](start_span)0x0013A1D8, 0x0013A234, 0x0013A294, 0x0013A460,[span_42](end_span)
    [span_43](start_span)0x0013A498, 0x0013A560, 0x0013A598, 0x0013A65C,[span_43](end_span)
    [span_44](start_span)0x0013A748, 0x0013A758, 0x0013A768, 0x0013A80C,[span_44](end_span)
    [span_45](start_span)0x0013A854, 0x0013C370, 0x0013C654, 0x0013C818,[span_45](end_span)
    [span_46](start_span)0x0013CC58, 0x0013CDC4, 0x0013DE94, 0x0013E150,[span_46](end_span)
    [span_47](start_span)0x0013F094, 0x0013FE80, 0x00140104, 0x001402C8,[span_47](end_span)
    [span_48](start_span)0x00140358, 0x001404E0, 0x00140528, 0x001405C8,[span_48](end_span)
    [span_49](start_span)0x001405D8, 0x00140680, 0x00140854, 0x00140E10,[span_49](end_span)
    [span_50](start_span)0x00140EE8, 0x00140EF4, 0x00141254, 0x00141264,[span_50](end_span)
    [span_51](start_span)0x0014151C, 0x00141884, 0x00141AE0, 0x00141B0C,[span_51](end_span)
    [span_52](start_span)0x00141C8C, 0x00141CB8, 0x00145EE8, 0x00146230,[span_52](end_span)
    [span_53](start_span)0x00146544, 0x00146714, 0x00146754, 0x001468A4,[span_53](end_span)
    [span_54](start_span)0x00146920, 0x00146964, 0x00146A68, 0x00146F34,[span_54](end_span)
    [span_55](start_span)0x00147184, 0x001471B0, 0x001471D8, 0x00147468,[span_55](end_span)
    [span_56](start_span)0x00147BF8, 0x00147C24, 0x00147D30, 0x00147D70,[span_56](end_span)
    [span_57](start_span)0x001486CC, 0x001486EC, 0x00148720, 0x001487A8,[span_57](end_span)
    [span_58](start_span)0x0014885C, 0x00148950, 0x00148998, 0x001489C8,[span_58](end_span)
    [span_59](start_span)0x00148A1C, 0x00148A8C, 0x00148BA8, 0x00148C24,[span_59](end_span)
    [span_60](start_span)0x00148C88, 0x00148CBC, 0x00148CD4, 0x00148D14,[span_60](end_span)
    [span_61](start_span)0x00148D48, 0x00148D60, 0x0014A78C, 0x0014A898,[span_61](end_span)
    [span_62](start_span)0x0014ABE8, 0x0014B038, 0x0014B054, 0x0014B33C,[span_62](end_span)
    [span_63](start_span)0x0014B4D8, 0x0014B510, 0x0014B548, 0x0014B5D8,[span_63](end_span)
    [span_64](start_span)0x0014B80C, 0x0014B958, 0x0014B96C, 0x0014CF88,[span_64](end_span)
    [span_65](start_span)0x0014D0A4, 0x0014D900, 0x0014DB28, 0x0014DB60,[span_65](end_span)
    [span_66](start_span)0x0014DE68, 0x0014E5B4, 0x0014E880, 0x0014EB68,[span_66](end_span)
    [span_67](start_span)0x0014EC7C, 0x0014F164, 0x0014F21C, 0x0014F904,[span_67](end_span)
    [span_68](start_span)0x0014F91C, 0x0014FBA0, 0x0014FC00, 0x0014FDD8,[span_68](end_span)
    [span_69](start_span)0x0014FDF0, 0x0014FE3C, 0x0014FED0, 0x0015000C,[span_69](end_span)
    [span_70](start_span)0x00150054, 0x00150438, 0x00150780, 0x001507F4,[span_70](end_span)
    [span_71](start_span)0x00150AEC, 0x00150D70, 0x00150DB0, 0x00150E14,[span_71](end_span)
    [span_72](start_span)0x00150E68, 0x001510E8, 0x0015112C, 0x00151514,[span_72](end_span)
    [span_73](start_span)0x001517B0, 0x001518A8, 0x001519D0, 0x00151A9C,[span_73](end_span)
    [span_74](start_span)0x00151D0C, 0x00151E4C, 0x00152144, 0x001527FC,[span_74](end_span)
    [span_75](start_span)0x001528E8, 0x00152D58, 0x00152DB0, 0x00152F90,[span_75](end_span)
    [span_76](start_span)0x001580F4, 0x0015839C, 0x0015917C, 0x0015929C,[span_76](end_span)
    [span_77](start_span)0x00159694, 0x00159D18, 0x00159D74, 0x00159F9C,[span_77](end_span)
    [span_78](start_span)0x0015A054, 0x0015A1A8, 0x0015A214, 0x0015A380,[span_78](end_span)
    [span_79](start_span)0x0015A3E0, 0x0015A4A4, 0x0015A680, 0x0015AAD8,[span_79](end_span)
    [span_80](start_span)0x0015AD40, 0x0015ADC0, 0x0015AE2C, 0x0015AE8C,[span_80](end_span)
    [span_81](start_span)0x0015AEF8, 0x0015AF58, 0x0015AFC4, 0x0015B064,[span_81](end_span)
    [span_82](start_span)0x0015B0C4, 0x0015B660, 0x0015B668, 0x0015B6AC,[span_82](end_span)
    [span_83](start_span)0x0015B844, 0x0015B9F0, 0x0015BD40, 0x0015BD58,[span_83](end_span)
    [span_84](start_span)0x0015BF68, 0x0015BFF8, 0x0015C0EC, 0x0015C26C,[span_84](end_span)
    [span_85](start_span)0x0015C474, 0x0015C504, 0x0015C594, 0x0015C670,[span_85](end_span)
    [span_86](start_span)0x0015C758, 0x0015C9D4, 0x0015D6C8, 0x0015DDEC,[span_86](end_span)
    [span_87](start_span)0x0015E078, 0x0015E164, 0x0015F2B8, 0x0015F824,[span_87](end_span)
    [span_88](start_span)0x0015F9C4, 0x0015FA34, 0x0015FB84, 0x0015FBF4,[span_88](end_span)
    [span_89](start_span)0x0015FD8C, 0x0015FDB8, 0x00160118, 0x00160438,[span_89](end_span)
    [span_90](start_span)0x001604FC, 0x00160E44, 0x00161018, 0x00161348,[span_90](end_span)
    [span_91](start_span)0x00161754, 0x0016195C, 0x00161974, 0x001619AC,[span_91](end_span)
    [span_92](start_span)0x001619F8, 0x001620BC, 0x00162764, 0x00162A68,[span_92](end_span)
    [span_93](start_span)0x00162B18, 0x00162D1C, 0x00162E68, 0x00162F44,[span_93](end_span)
    [span_94](start_span)0x00163028, 0x001635AC, 0x001639DC, 0x00163A9C,[span_94](end_span)
    [span_95](start_span)0x00163D9C, 0x00163E3C, 0x001640FC, 0x00164188,[span_95](end_span)
    [span_96](start_span)0x00164214, 0x001642FC, 0x001643DC, 0x00164410,[span_96](end_span)
    [span_97](start_span)0x0016485C, 0x00164958, 0x00164D44, 0x00164E40,[span_97](end_span)
    [span_98](start_span)0x001657FC, 0x00165C6C, 0x00165F14, 0x00165F90,[span_98](end_span)
    [span_99](start_span)0x001692AC, 0x00169758, 0x001699D4, 0x0016AEA8,[span_99](end_span)
    [span_100](start_span)0x0016AFC8, 0x0016B2F0, 0x0016B450, 0x0016B978,[span_100](end_span)
    [span_101](start_span)0x0016BC08, 0x0016BDC0, 0x0016BEF8, 0x0016C030,[span_101](end_span)
    [span_102](start_span)0x0016C76C, 0x0016CCD0, 0x0016CD20, 0x0016CD7C,[span_102](end_span)
    [span_103](start_span)0x0016D050, 0x0016D1B8, 0x0016D250, 0x0016D344,[span_103](end_span)
    [span_104](start_span)0x0016D4DC, 0x0016DF28, 0x0016E650, 0x0016E8CC,[span_104](end_span)
    [span_105](start_span)0x0016F5F8, 0x0016F9B0, 0x0016FA20, 0x0016FF90,[span_105](end_span)
    [span_106](start_span)0x001700A4, 0x0017017C, 0x00170210, 0x00170308,[span_106](end_span)
    [span_107](start_span)0x00170F10, 0x0017115C, 0x00171E40, 0x00172420,[span_107](end_span)
    [span_108](start_span)0x00172504, 0x001727C4, 0x00172830, 0x00172848,[span_108](end_span)
    [span_109](start_span)0x001729B0, 0x00172E24, 0x00173C60, 0x00173EE0,[span_109](end_span)
    [span_110](start_span)0x00174000, 0x00174014, 0x001743B0, 0x00174400,[span_110](end_span)
    [span_111](start_span)0x00174880, 0x0017491C, 0x00174CE4, 0x0017508C,[span_111](end_span)
    [span_112](start_span)0x001777B0, 0x00177A8C, 0x00177D48, 0x00178EFC,[span_112](end_span)
    [span_113](start_span)0x001795B4, 0x001796A8, 0x0017979C, 0x0017A0F8,[span_113](end_span)
    [span_114](start_span)0x0017A51C, 0x0017A7C4, 0x0017B354, 0x0017B4C8,[span_114](end_span)
    [span_115](start_span)0x0017BAD8, 0x0017BC20, 0x0017BC74, 0x0017CCA4,[span_115](end_span)
    [span_116](start_span)0x0017D0FC, 0x0017D3E4, 0x0017E2D4, 0x0017E404,[span_116](end_span)
    [span_117](start_span)0x0017E424, 0x0017EF9C, 0x0017F244, 0x0017FFE0,[span_117](end_span)
    [span_118](start_span)0x001803D4, 0x001803F0, 0x00180784, 0x001807BC,[span_118](end_span)
    [span_119](start_span)0x001807D0, 0x001809F4, 0x00180BEC, 0x00180C78,[span_119](end_span)
    [span_120](start_span)0x00180D04, 0x00180FF8, 0x00181044, 0x001811E4,[span_120](end_span)
    [span_121](start_span)0x001813AC, 0x001817E8, 0x00181808, 0x00181930,[span_121](end_span)
    [span_122](start_span)0x00181968, 0x00181FD8, 0x00182048, 0x00182364,[span_122](end_span)
    [span_123](start_span)0x001831B4, 0x00184B24, 0x00184B38, 0x0018515C,[span_123](end_span)
    [span_124](start_span)0x001851B8, 0x00185290, 0x00185770, 0x0018585C,[span_124](end_span)
    [span_125](start_span)0x00185AE8, 0x00185E0C, 0x00185E14, 0x00185E58,[span_125](end_span)
    [span_126](start_span)0x001862C8, 0x00186460, 0x001865F8, 0x0018694C,[span_126](end_span)
    [span_127](start_span)0x00186C18, 0x00187410, 0x001876F8, 0x00189394,[span_127](end_span)
    [span_128](start_span)0x00189600, 0x0018A9EC, 0x0018AAA0, 0x0018B31C,[span_128](end_span)
    [span_129](start_span)0x0018B740, 0x0018B9E8, 0x0018E2DC, 0x0018E508,[span_129](end_span)
    [span_130](start_span)0x0018EC40, 0x0018EFA4, 0x0018F948, 0x0018FFD4,[span_130](end_span)
    [span_131](start_span)0x00190254, 0x001903E4, 0x0019080C, 0x00190C98,[span_131](end_span)
    [span_132](start_span)0x001916B8, 0x001917C8, 0x00191FC0, 0x00192008,[span_132](end_span)
    [span_133](start_span)0x001920D4, 0x00192108, 0x001922F4, 0x00192770,[span_133](end_span)
    [span_134](start_span)0x0019295C, 0x00192AB0, 0x00192FE4, 0x00193268,[span_134](end_span)
    [span_135](start_span)0x001933E8, 0x001937E8, 0x00193DA8, 0x00193E6C,[span_135](end_span)
    [span_136](start_span)0x00193FB0, 0x0019445C, 0x00194814, 0x00194A30,[span_136](end_span)
    [span_137](start_span)0x00194BB0, 0x00194D8C, 0x00194F4C, 0x00194F6C,[span_137](end_span)
    [span_138](start_span)0x001952D8, 0x001952F8, 0x0019532C, 0x001955DC,[span_138](end_span)
    [span_139](start_span)0x0019575C, 0x00195D1C, 0x001A1EE0, 0x001A1EF4,[span_139](end_span)
    [span_140](start_span)0x001A1FE0, 0x001A1FF8, 0x001A2018, 0x001A20CC,[span_140](end_span)
    [span_141](start_span)0x001A224C, 0x001A2264, 0x001A2284, 0x001A22E4,[span_141](end_span)
    [span_142](start_span)0x001A2338, 0x001A2348, 0x001A2390, 0x001A2624,[span_142](end_span)
    [span_143](start_span)0x001A2A8C, 0x001A2E84, 0x001A2EF4, 0x001A2FB4,[span_143](end_span)
    [span_144](start_span)0x001A3030, 0x001A3108, 0x001A3114, 0x001A33C8,[span_144](end_span)
    [span_145](start_span)0x001A33D8, 0x001A34D0, 0x001A35A8, 0x001A35B4,[span_145](end_span)
    [span_146](start_span)0x001A3688, 0x001A36D8, 0x001A37B0, 0x001A37EC,[span_146](end_span)
    [span_147](start_span)0x001A38AC, 0x001A392C, 0x001A39EC, 0x001A3AA0,[span_147](end_span)
    [span_148](start_span)0x001A3E38, 0x001A3F1C, 0x001A3F54, 0x001A4020,[span_148](end_span)
    [span_149](start_span)0x001A402C, 0x001A4144, 0x001A4150, 0x001A4220,[span_149](end_span)
    [span_150](start_span)0x001A42F4, 0x001A43A0, 0x001A4504, 0x001A4740,[span_150](end_span)
    [span_151](start_span)0x001A47B8, 0x001A47D8, 0x001A4850, 0x001A48B8,[span_151](end_span)
    [span_152](start_span)0x001A49FC, 0x001A4A9C, 0x001A4AC8, 0x001A4B68,[span_152](end_span)
    [span_153](start_span)0x001A4B94, 0x001A4CCC, 0x001A4CD8, 0x001A4D64,[span_153](end_span)
    [span_154](start_span)0x001A4E24, 0x001A5000, 0x001A500C, 0x001A5110,[span_154](end_span)
    [span_155](start_span)0x001A51E0, 0x001A5234, 0x001A5274, 0x001A52A0,[span_155](end_span)
    [span_156](start_span)0x001A5404, 0x001A5490, 0x001A54F8, 0x001A562C,[span_156](end_span)
    [span_157](start_span)0x001A5638, 0x001A5718, 0x001A5724, 0x001A57E4,[span_157](end_span)
    [span_158](start_span)0x001A5960, 0x001A59BC, 0x001A5AAC, 0x001A5BEC,[span_158](end_span)
    [span_159](start_span)0x001A6498, 0x001A65DC, 0x001A65E8, 0x001A66C8,[span_159](end_span)
    [span_160](start_span)0x001A66D4, 0x001A6840, 0x001A697C, 0x001A6E38,[span_160](end_span)
    [span_161](start_span)0x001A6E44, 0x001A6ED8, 0x001A6FC4, 0x001A6FD0,[span_161](end_span)
    [span_162](start_span)0x001A7104, 0x001A7110, 0x001A71A8, 0x001A7298,[span_162](end_span)
    [span_163](start_span)0x001A7338, 0x001A7344, 0x001A73EC, 0x001A7550,[span_163](end_span)
    [span_164](start_span)0x001A7718, 0x001A7744, 0x001A7800, 0x001A78B4,[span_164](end_span)
    [span_165](start_span)0x001A7C04, 0x001A8284, 0x001A86CC, 0x001A87DC,[span_165](end_span)
    [span_166](start_span)0x001A8284, 0x001A86CC, 0x001A87DC, 0x001A8824,[span_166](end_span)
    [span_167](start_span)0x001A88C0, 0x001A8ADC, 0x001A8D18, 0x001A8FC8,[span_167](end_span)
    [span_168](start_span)0x001A8FD4, 0x001A9100, 0x001A910C, 0x001A9158,[span_168](end_span)
    [span_169](start_span)0x001A9198, 0x001A91D8, 0x001B2148, 0x001B24D0,[span_169](end_span)
    [span_170](start_span)0x001B28BC, 0x001B36DC, 0x001B3BBC, 0x001B4644,[span_170](end_span)
    [span_171](start_span)0x001B48C0, 0x001B536C, 0x001B55E8, 0x001B62EC,[span_171](end_span)
    [span_172](start_span)0x001B64A0, 0x001B6864, 0x001B692C, 0x001B6990,[span_172](end_span)
    [span_173](start_span)0x001B6A74, 0x001B6AA8, 0x001B6B4C, 0x001B6C38,[span_173](end_span)
    [span_174](start_span)0x001B6CC8, 0x001B6DA8, 0x001B6DE4, 0x001B6EC8,[span_174](end_span)
    [span_175](start_span)0x001B6F90, 0x001B7078, 0x001B725C, 0x001B736C,[span_175](end_span)
    [span_176](start_span)0x001B75B8, 0x001B75D4, 0x001B75F0, 0x001B7614,[span_176](end_span)
    [span_177](start_span)0x001B7634, 0x001B7690, 0x001B789C, 0x001B7904,[span_177](end_span)
    [span_178](start_span)0x001B7C4C, 0x001B7C88, 0x001B7CE0, 0x001B7D80,[span_178](end_span)
    [span_179](start_span)0x001B80A0, 0x001B88F8, 0x001B9808, 0x001B98CC,[span_179](end_span)
    [span_180](start_span)0x001B9AE8, 0x001BA130, 0x001BA174, 0x001BACBC,[span_180](end_span)
    [span_181](start_span)0x001BB03C, 0x001BC2E0, 0x001BC3E8, 0x001C317C,[span_181](end_span)
    [span_182](start_span)0x001C3244, 0x001C5794, 0x001C5824, 0x001CEF10,[span_182](end_span)
    [span_183](start_span)0x001CF43C, 0x001CF844, 0x001D2694, 0x001D2704,[span_183](end_span)
    [span_184](start_span)0x001D2800, 0x001D28D4, 0x001D29A8, 0x001D2DBC,[span_184](end_span)
    [span_185](start_span)0x001D334C, 0x001D387C, 0x001D389C, 0x001D38D8,[span_185](end_span)
    [span_186](start_span)0x001D397C, 0x001D39A8, 0x001EE45C, 0x001EE760,[span_186](end_span)
    [span_187](start_span)0x001EED3C, 0x001EEDA8, 0x001F13D0, 0x001F147C,[span_187](end_span)
    [span_188](start_span)0x001F169C, 0x001F2C34, 0x001F33E8, 0x001F3400,[span_188](end_span)
    [span_189](start_span)0x00201204, 0x00201210, 0x002016EC, 0x00203AF8,[span_189](end_span)
    [span_190](start_span)0x00203B10, 0x00206508, 0x0020654C, 0x0020BA90,[span_190](end_span)
    [span_191](start_span)0x0020BAB0, 0x0020BAFC, 0x0020BB40, 0x0020C204,[span_191](end_span)
    [span_192](start_span)0x0020E1A4, 0x002110DC, 0x0021157C, 0x00213F38,[span_192](end_span)
    [span_193](start_span)0x00213FA4, 0x0021C488, 0x0021C4F0, 0x0021F438,[span_193](end_span)
    [span_194](start_span)0x0022238C, 0x00222848, 0x00225274, 0x00225400,[span_194](end_span)
    [span_195](start_span)0x0022546C, 0x00229898, 0x0022AD4C, 0x0022ADA4,[span_195](end_span)
    [span_196](start_span)0x0022B238, 0x0022B28C, 0x0022B92C, 0x0022B978,[span_196](end_span)
    [span_197](start_span)0x0022DE6C, 0x0022E1A8, 0x0023104C, 0x00231278,[span_197](end_span)
    [span_198](start_span)0x002312DC, 0x002318D4, 0x00232EE0, 0x00232F34,[span_198](end_span)
    [span_199](start_span)0x002333C0, 0x00233414, 0x00233A78, 0x00233AC8,[span_199](end_span)
    [span_200](start_span)0x00235FF4, 0x00236330, 0x00239184, 0x002393B0,[span_200](end_span)
    0x00239414
};

// ==========================================
// 3. مصفوفة RET (عالية الخطورة)
// ==========================================
uintptr_t ret_offsets[] = {
    [span_201](start_span)0x000CC0FC, 0x000D22EC, 0x000ECE88[span_201](end_span)
};

// ==========================================
// 4. تنفيذ الحقن المزدوج
// ==========================================
void ExecutePatch(intptr_t slide) {
    // تطبيق باتشات NOP
    size_t nop_count = sizeof(nop_offsets) / sizeof(nop_offsets[0]);
    for (size_t i = 0; i < nop_count; i++) {
        void* addr = (void*)(slide + nop_offsets[i]);
        DobbyCodePatch(addr, (uint8_t *)&NOP_HEX, 4);
    }

    // تطبيق باتشات RET
    size_t ret_count = sizeof(ret_offsets) / sizeof(ret_offsets[0]);
    for (size_t i = 0; i < ret_count; i++) {
        void* addr = (void*)(slide + ret_offsets[i]);
        DobbyCodePatch(addr, (uint8_t *)&RET_HEX, 4);
    }
}

// ==========================================
// 5. المراقب والمنبه (بناءً على التست الناجح)
// ==========================================
void ShowBypassInfo() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!window) window = [UIApplication sharedApplication].keyWindow;
        if (!window || !window.rootViewController) return;

        UIViewController *top = window.rootViewController;
        while (top.presentedViewController) top = top.presentedViewController;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"System" 
                                                                       message:@"Anogs Bypass: Enabled ✅\nCategorized Patches Applied." 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [top presentViewController:alert animated:YES completion:nil];
    });
}

void on_image_added(const struct mach_header *mh, intptr_t slide) {
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i) == mh) {
            const char *name = _dyld_get_image_name(i);
            if (name && strstr(name, "anogs")) {
                ExecutePatch(slide);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    ShowBypassInfo();
                });
            }
            break;
        }
    }
}

__attribute__((constructor))
static void init() {
    _dyld_register_func_for_add_image(on_image_added);
}
