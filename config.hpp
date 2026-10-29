#pragma once
#include <cstdint>

namespace Offsets {
    namespace Luau {
        constexpr uintptr_t luau_load     = 0x410f3b0;
        constexpr uintptr_t lua_pcall     = 0x40e4cc0;
        constexpr uintptr_t lua_newthread = 0x40e1e50;
        constexpr uintptr_t lua_tolstring = 0x40e2b44;
    }
    namespace DataModel {
        constexpr uintptr_t FakeDataModelPointer = 0x7A3F4A0; // Offset do DataModel no Roblox iOS
        constexpr uintptr_t FakeDataModelToDataModel = 0x1D8;
        constexpr uintptr_t Children = 0x78;
        constexpr uintptr_t ScriptContext = 0x3F0; // Offset do ScriptContext
    }
}
