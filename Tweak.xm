#import <UIKit/UIKit.h>
#import "exploit.hpp"
#import "hooks.hpp"
#import "SporkUI.h"
#include "memory.hpp"

%ctor {
    // 1. Mostra a UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShowSporkUI();
    });

    // 2. Roda o hook numa thread separada (Background Thread) pra não crashar o app
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (memory::GetRobloxLibBase() == 0) {
            [NSThread sleepForTimeInterval:1.0];
        }
        
        // Aplica APENAS o hook do luau_load (que é essencial)
        SetupExploit();
        
        // NÃO CHAMA MAIS O SetupExecution (gc_step) POR ENQUANTO.
        NSLog(@"[Spork] Hook do luau_load aplicado com segurança na background.");
    });
}
