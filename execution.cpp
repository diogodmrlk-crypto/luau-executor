#include "execution.hpp"
#include "config.hpp"
#include "memory.hpp"
#include <cstdlib>
#include <cstdio>

#include "lua.h"
#include "luacode.h"

extern "C" void* ExploitThread;

int ExecuteScript(void* L, const std::string& Source) {
    if (!L) {
        fprintf(stderr, "[Spork] ERRO: lua_State (L) é NULL.\n");
        return -5;
    }
    uintptr_t base = memory::GetRobloxLibBase();
    if (!base) {
        fprintf(stderr, "[Spork] ERRO: RobloxLib base não encontrada.\n");
        return -4;
    }

    // 1. Compila
    size_t bcSize = 0;
    char* bc = luau_compile(Source.c_str(), Source.size(), nullptr, &bcSize);
    if (!bc) {
        fprintf(stderr, "[Spork] ERRO: luau_compile retornou NULL.\n");
        return -1;
    }

    typedef int (*luau_load_t)(void*, const char*, const char*, size_t, int);
    typedef int (*lua_pcall_t)(void*, int, int, int);
    typedef const char* (*lua_tolstring_t)(void*, int, size_t*);

    auto luau_load = (luau_load_t)(base + Offsets::Luau::luau_load);
    auto lua_pcall = (lua_pcall_t)(base + Offsets::Luau::lua_pcall);
    auto lua_tolstring = (lua_tolstring_t)(base + Offsets::Luau::lua_tolstring);

    // 2. Carrega
    if (luau_load(L, "=Spork", bc, bcSize, 0) != 0) {
        size_t len = 0;
        const char* err = lua_tolstring(L, -1, &len);
        fprintf(stderr, "[Spork] ERRO luau_load: %s\n", err ? err : "Desconhecido");
        free(bc);
        return -2;
    }
    free(bc);

    // 3. Executa
    int result = lua_pcall(L, 0, 0, 0);
    if (result != 0) {
        size_t len = 0;
        const char* err = lua_tolstring(L, -1, &len);
        fprintf(stderr, "[Spork] ERRO lua_pcall (%d): %s\n", result, err ? err : "Desconhecido");
    }
    return result;
}
