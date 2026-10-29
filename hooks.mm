// hooks.mm
#import <Foundation/Foundation.h>
#include "hooks.hpp"
#include "exploit.hpp"
#include "execution.hpp"
#include "config.hpp"
#include "memory.hpp"

// Declaração do Dobby
extern "C" void* DobbyHook(void* address, void* replace, void** origin);

// Mantemos a tipagem mas não vamos usar a função por enquanto
typedef uint64_t (*gc_step_t)(void*, int);
static gc_step_t g_orig_gc_step = nullptr;

void SetupExecution(void* L) {
    (void)L;
    
    // AVISO: O hook do gc_step foi desativado temporariamente!
    // Tentar hookar essa função no iOS 18 está causando crash de KERN_PROTECTION_FAILURE.
    // O executor vai funcionar apenas com o hook do luau_load e execução pela UI.
    
    NSLog(@"[Spork] SetupExecution chamado. gc_step hook desativado por segurança.");
}
