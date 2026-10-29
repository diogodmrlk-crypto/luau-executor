// hooks.mm
#import <Foundation/Foundation.h>
#import "dobby.h" // Importa o header do Dobby corretamente
#include <ptrauth.h> // Para remover a proteção PAC (arm64e)
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
    
    // Remove a assinatura PAC do endereço
    void* hookAddr = ptrauth_strip((void*)gcStepAddr, ptrauth_key_asm_isa);

    void* orig = nullptr;
    DobbyHook(hookAddr, (void*)HookedGcStep, &orig);
    g_orig_gc_step = (gc_step_t)orig;

    if (g_orig_gc_step) NSLog(@"[Spork] gc_step hooked");
}
