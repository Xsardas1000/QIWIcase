@import UIKit;

@protocol SINVerification;
@class SINUITextFieldPhoneNumberFormatter;

@interface NumberEntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString *isoCountryCode;
@property (strong, nonatomic) SINUITextFieldPhoneNumberFormatter *formatter;

@end
