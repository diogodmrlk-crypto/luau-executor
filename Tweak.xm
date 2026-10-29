// Tweak.xm
#import <UIKit/UIKit.h>
#import "SporkUI.h"

%ctor {
    // Só mostra a UI e NÃO hooka nada.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShowSporkUI();
        NSLog(@"[Spork] UI carregada. Hooks desativados para teste.");
    });
}
