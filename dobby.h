#ifndef DOBBY_H
#define DOBBY_H

// يجب أن تكون التضمينات خارج extern "C" في التحديثات الجديدة
#include <stdint.h>
#include <sys/types.h>

#ifdef __cplusplus
extern "C" {
#endif

// تعريف الدوال الأساسية لـ Dobby
int DobbyHook(void *function_address, void *replace_call, void **origin_call);
int DobbyCodePatch(void *address, uint8_t *buffer, uint32_t buffer_size);

#ifdef __cplusplus
}
#endif

#endif // DOBBY_H
