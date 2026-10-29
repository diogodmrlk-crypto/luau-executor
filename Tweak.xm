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

    // 2. Timer para pegar o RobloxLib
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (memory::GetRobloxLibBase() != 0) {
            [timer invalidate];
            SetupExploit();
            SetupExecution(nullptr);
            NSLog(@"[Spork] Hooks globais injetados.");
        }
    }];
}
