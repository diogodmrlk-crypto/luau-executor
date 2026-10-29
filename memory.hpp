// memory.hpp
#pragma once
#include <cstdint>

namespace memory {
    uintptr_t GetRobloxLibBase();
    bool safe_read(void* address, void* buffer, size_t size);
}
