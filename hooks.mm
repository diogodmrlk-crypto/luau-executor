#import <Foundation/Foundation.h>
#include "hooks.hpp"
#include "exploit.hpp"
#include "execution.hpp"
#include "config.hpp"
#include "memory.hpp"

extern "C" void* DobbyHook(void* address, void* replace, void** origin);

typedef uint64_t (*gc_step_t)(void*, int);
static gc_step_t g_orig_gc_step = nullptr;

static uint64_t HookedGcStep(void* L, int idx) {
    // FALLBACK: Pega o lua_State se o luau_load não tiver pego ainda
    if (!ExploitThread && L) {
        typedef void* (*lua_newthread_t)(void*);
        auto lua_newthread = (lua_newthread_t)(memory::GetRobloxLibBase() + Offsets::Luau::lua_newthread);
        ExploitThread = lua_newthread(L);
        NSLog(@"[Spork] SUCESSO: lua_State capturado via gc_step: %p", ExploitThread);
    }

    // Executa os scripts da fila
    if (ExploitThread && !ExecutionRequests.empty()) {
        std::string script = ExecutionRequests.front();
        ExecutionRequests.erase(ExecutionRequests.begin());
        
        NSLog(@"[Spork] Puxando script da fila para executar...");
        int result = ExecuteScript(ExploitThread, script);
        NSLog(@"[Spork] Execução terminou com código: %d", result);
    }
    
    return g_orig_gc_step(L, idx);
}

void SetupExecution(void* L) {
    (void)L;
    uintptr_t base = memory::GetRobloxLibBase();
    if (!base) return;

    uintptr_t gcStepAddr = base + Offsets::Luau::gc_step;
    void* orig = nullptr;
    DobbyHook((void*)gcStepAddr, (void*)HookedGcStep, &orig);
    g_orig_gc_step = (gc_step_t)orig;

    if (g_orig_gc_step) NSLog(@"[Spork] Hook do gc_step aplicado.");
}
