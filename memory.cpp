#include "memory.hpp"
#include <mach-o/dyld.h>
#include <string.h>
#include <mach/mach.h>
#include <mach/vm_map.h>

namespace memory {

    bool safe_read(void* address, void* buffer, size_t size) {
        if (!address || !buffer || size == 0) return false;
        uintptr_t addr = (uintptr_t)address;
        if (addr < 0x100000000ULL) return false;

        vm_size_t out_size = 0;
        // Usando mach_vm_read_overwrite que é mais estável no iOS moderno
        kern_return_t kr = mach_vm_read_overwrite(mach_task_self(), (mach_vm_address_t)addr, (mach_vm_size_t)size, (mach_vm_address_t)buffer, &out_size);
        return (kr == KERN_SUCCESS && out_size == size);
    }

    uintptr_t GetRobloxLibBase() {
        uint32_t count = _dyld_image_count();
        for (uint32_t i = 0; i < count; i++) {
            const char* name = _dyld_get_image_name(i);
            if (name && strstr(name, "RobloxLib")) {
                return (uintptr_t)_dyld_get_image_header(i);
            }
        }
        return 0;
    }

}
