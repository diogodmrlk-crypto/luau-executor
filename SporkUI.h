// SporkUI.h
#import <UIKit/UIKit.h>

extern NSMutableArray<NSString *> *g_logs;
void SporkLog(NSString *format, ...);

@interface SporkViewController : UIViewController
@end

// Função que o Tweak chama para colocar a UI no jogo
void ShowSporkUI(void);
