#import <Foundation/Foundation.h>
#include "exploit.hpp"
#include "config.hpp"
#include "memory.hpp"

extern "C" void* DobbyHook(void* address, void* replace, void** origin);

void* ExploitThread = nullptr;
std::vector<std::string> ExecutionRequests;
static uintptr_t g_robloxLibBase = 0;

typedef int (*luau_load_t)(void*, const char*, const char*, size_t, int);
static luau_load_t g_orig_luau_load = nullptr;

static int HookedLuauLoad(void* L, const char* chunk, const char* data, size_t len, int env) {
    if (!ExploitThread && L) {
        typedef void* (*lua_newthread_t)(void*);
        auto lua_newthread = (lua_newthread_t)(g_robloxLibBase + Offsets::Luau::lua_newthread);
        ExploitThread = lua_newthread(L);
        NSLog(@"[Spork] SUCESSO: lua_State capturado via luau_load: %p", ExploitThread);
    }
    return g_orig_luau_load(L, chunk, data, len, env);
}

void SetupExploit() {
    if (g_robloxLibBase) return;
    g_robloxLibBase = memory::GetRobloxLibBase();
    if (!g_robloxLibBase) return;

    uintptr_t luauLoadAddr = g_robloxLibBase + Offsets::Luau::luau_load;
    void* orig = nullptr;
    DobbyHook((void*)luauLoadAddr, (void*)HookedLuauLoad, &orig);
    g_orig_luau_load = (luau_load_t)orig;

    if (g_orig_luau_load) NSLog(@"[Spork] Hook do luau_load aplicado.");
}

void RequestExecution(const std::string& Script) {
    if (!ExploitThread) {
        NSLog(@"[Spork] AVISO: Script enfileirado, mas o lua_State está NULL. O jogo carregou?");
    }
    ExecutionRequests.push_back(Script);
    NSLog(@"[Spork] Script adicionado na fila (Total na fila: %lu)", ExecutionRequests.size());
}
