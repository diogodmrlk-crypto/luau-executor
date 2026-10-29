#pragma once
#include <cstdint>

namespace Offsets {
    namespace Luau {
        constexpr uintptr_t luau_load     = 0x410f3b0;
        constexpr uintptr_t lua_pcall     = 0x40e4cc0;
        constexpr uintptr_t lua_newthread = 0x40e1e50;
    }
    namespace DataModel {
        // Offsets extraídos de projetos base para iOS
        constexpr uintptr_t FakeDataModelPointer = 0x7A3F4A0; 
        constexpr uintptr_t FakeDataModelToDataModel = 0x1D8;
        constexpr uintptr_t Children = 0x78;
        constexpr uintptr_t ScriptContext = 0x3F0; 
    }
}
