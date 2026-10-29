#import <UIKit/UIKit.h>
#import "SporkUI.h"

%ctor {
    // Só mostra a UI. Não tenta hookar NADA ao abrir o app.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShowSporkUI();
        NSLog(@"[Spork] App abriu com sucesso. UI carregada.");
    });
}
