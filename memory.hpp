#pragma once
#include <cstdint>
#include <cstddef>

// Macro para remover a assinatura PAC (ARM64e)
#include <ptrauth.h>
#define STRIP_PAC(p) ((void*)ptrauth_strip((void*)(p), ptrauth_key_asia))

namespace memory {
    uintptr_t GetRobloxLibBase();
    bool safe_read(void* address, void* buffer, size_t size);
}
