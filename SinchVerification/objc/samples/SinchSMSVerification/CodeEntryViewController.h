@import UIKit;

@protocol SINVerification;

@interface CodeEntryViewController : UIViewController

@property (strong, nonatomic) id<SINVerification> verification;

@property (weak, nonatomic) IBOutlet UITextField* codeTextField;
@property (weak, nonatomic) IBOutlet UILabel* statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

- (IBAction)verify:(id)sender;

@end
