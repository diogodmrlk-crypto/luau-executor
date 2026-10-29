// hooks.mm
#import <Foundation/Foundation.h>
#include "hooks.hpp"

void SetupExecution(void* L) {
    // Desativado para evitar crash no iOS 18
    NSLog(@"[Spork] SetupExecution chamado, mas desativado.");
}
