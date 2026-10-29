// hooks.mm
#import <Foundation/Foundation.h>
#import <substrate.h> // Importa o Substrate
#include "hooks.hpp"
#include "exploit.hpp"
#include "execution.hpp"
#include "config.hpp"
#include "memory.hpp"

typedef uint64_t (*gc_step_t)(void*, int);
static gc_step_t g_orig_gc_step = nullptr;

static uint64_t HookedGcStep(void* L, int idx) {
    if (ExploitThread && !ExecutionRequests.empty()) {
        std::string script = ExecutionRequests.front();
        ExecutionRequests.erase(ExecutionRequests.begin());
        ExecuteScript(ExploitThread, script);
    }
    return g_orig_gc_step(L, idx);
}

void SetupExecution(void* L) {
    (void)L;
    uintptr_t base = memory::GetRobloxLibBase();
    if (!base) return;

    uintptr_t gcStepAddr = base + Offsets::Luau::gc_step;
    
    // Usa MSHookFunction do Substrate
    MSHookFunction((void*)gcStepAddr, (void*)HookedGcStep, (void**)&g_orig_gc_step);

    if (g_orig_gc_step) NSLog(@"[Spork] gc_step hooked");
}
