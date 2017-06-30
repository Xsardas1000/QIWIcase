#import "CodeEntryViewController.h"
#import "Helper.h"

@import SinchVerification;

@implementation CodeEntryViewController

- (void)verify:(id)sender {
  [self.verification verifyCode:self.codeTextField.text
              completionHandler:^(BOOL success, NSError* error) {
                if (success) {
                  [self setStatusText:@"Verification Successful"];
                } else {
                  [self setStatusText:@"Verification Failed"];
                  showError(error);
                }
              }];
}

#pragma mark -

- (void)setStatusText:(NSString*)text {
  self.statusLabel.text = text;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.codeTextField becomeFirstResponder];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  initAppearance(self);
}

@end
