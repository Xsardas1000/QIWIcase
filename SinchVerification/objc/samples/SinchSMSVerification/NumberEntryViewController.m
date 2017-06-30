#import "NumberEntryViewController.h"
#import "CodeEntryViewController.h"
#import "CountrySelectionViewController.h"
#import "Helper.h"

@import SinchVerification;

@implementation NumberEntryViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.isoCountryCode = SINDeviceRegion.currentCountryCode;

  self.formatter = [[SINUITextFieldPhoneNumberFormatter alloc] initWithCountryCode:self.isoCountryCode];
  self.formatter.textField = self.numberTextField;

  __weak __typeof(self) weakSelf = self;
  self.formatter.onTextFieldTextDidChange = ^(UITextField *textField) {
    [weakSelf onTextFieldTextDidChange:textField];
  };

  [self updateFormatter];
  [self updateCountrySelection];

  initAppearance(self);
}

- (void)updateFormatter {
  self.formatter.countryCode = self.isoCountryCode;
  self.numberTextField.placeholder = [self.formatter exampleNumberWithFormat:SINPhoneNumberFormatNational];
}

- (void)updateCountrySelection {
  id<SINRegionList> regions = [SINPhoneNumberUtil() regionListWithLocale:NSLocale.currentLocale];
  NSString *displayName = [regions displayNameForRegion:self.isoCountryCode];
  NSNumber *callingCode = [regions countryCallingCodeForRegion:self.isoCountryCode];
  [self.countryButton setTitle:[NSString stringWithFormat:@"(+%@) %@", callingCode, displayName]
                      forState:UIControlStateNormal];
}

- (void)onTextFieldTextDidChange:(UITextField *)textField {
  void (^update)(BOOL, UIColor *) = ^(BOOL enabled, UIColor *color) {
    self.verifyButton.enabled = enabled;
    textField.backgroundColor = color;
  };

  if (textField.text.length == 0) {
    update(NO, [UIColor clearColor]);
  } else if ([SINPhoneNumberUtil() isPossibleNumber:textField.text fromRegion:self.isoCountryCode error:nil]) {
    update(YES, colorForPossiblePhoneNumber());
  } else {
    update(NO, colorForNotPossiblePhoneNumber());
  }
}

- (void)verify:(id)sender {
  [sender resignFirstResponder];

  NSError *error = nil;
  id<SINPhoneNumber> phoneNumber =
      [SINPhoneNumberUtil() parse:self.numberTextField.text defaultRegion:self.isoCountryCode error:&error];

  if (!phoneNumber) {
    showError(error);
    return;
  }

  NSString *phoneNumberInE164 = [SINPhoneNumberUtil() formatNumber:phoneNumber format:SINPhoneNumberFormatE164];
  id<SINVerification> verification = [SINVerification SMSVerificationWithApplicationKey:@"<APP KEY>"
                                                                            phoneNumber:phoneNumberInE164];

  [verification initiateWithCompletionHandler:^(id<SINInitiationResult> result, NSError *error) {
    if (result.success) {
      [self performSegueWithIdentifier:@"codeEntry" sender:verification];
    } else {
      showError(error);
    }
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController *destination = segue.destinationViewController;

  // To CodeEntryViewController
  if ([destination respondsToSelector:@selector(setVerification:)]) {
    [(id)destination setVerification:sender];
  }

  // To CountrySelectionViewController
  if ([destination respondsToSelector:@selector(setIsoCountryCode:)]) {
    [(id)destination setIsoCountryCode:self.isoCountryCode];
    [(id)destination setOnCompletion:^(NSString *isoCountryCode) {
      [self dismissViewControllerAnimated:YES completion:nil];
      self.isoCountryCode = isoCountryCode;
      [self updateFormatter];
      [self updateCountrySelection];
    }];
  }
}

#pragma mark -

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.numberTextField becomeFirstResponder];
}

@end
