#import "Helper.h"
@import SinchVerification;

// The following functions should not be considered critical to the
// functionality of the Sinch SDK.  The functions are primarily
// helpers for showing UIAlerts, and styling the sample app
// appearance.

@interface NSObject (SinchSampleApps)
- (UIButton *)countryButton;
- (UIButton *)verifyButton;
- (UILabel *)statusLabel;
- (UIActivityIndicatorView *)activityIndicator;
@end

void showErrorMessage(NSString *message) {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil];
  [alert show];
}

void showError(NSError *error) {
  NSString *msg =
      [NSString stringWithFormat:@"%@\n(%@, %ld)", error.localizedDescription, error.domain, (long)error.code];
  showErrorMessage(msg);
}

// Add a block-based observer for a NSNotification
void addNotificationObserver(NSString *notificationName, dispatch_block_t block) {
  [[NSNotificationCenter defaultCenter] addObserverForName:notificationName
                                                    object:nil
                                                     queue:nil
                                                usingBlock:^(NSNotification *note) {
                                                  block();
                                                }];
}

static void setSinchLogInNavigationBar(UIViewController *viewController) {
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sinch-logo-navbar.png"]];
  image.contentMode = UIViewContentModeScaleAspectFit;
  viewController.navigationItem.titleView = image;
}

static void styleButton(UIButton *button) {
  button.layer.borderWidth = 1.0;
  button.layer.cornerRadius = 5.0;
  button.layer.borderColor = button.titleLabel.textColor.CGColor;
}

static void toggleActivityIndicator(UIActivityIndicatorView *activityIndicator, BOOL visible, BOOL animated) {
  if (visible) {
    [activityIndicator startAnimating];
  } else {
    [activityIndicator stopAnimating];
  }
  CGFloat alpha = visible ? 1.0 : 0.0;
  if (animated) {
    [UIView animateWithDuration:0.3
                     animations:^{
                       activityIndicator.alpha = alpha;
                     }];
  } else {
    activityIndicator.alpha = alpha;
  }
}

static void initActivityIndicator(UIActivityIndicatorView *activityIndicator) {
  toggleActivityIndicator(activityIndicator, NO, NO);

  addNotificationObserver(SINVerificationDidBeginInitiatingNotification, ^{
    toggleActivityIndicator(activityIndicator, YES, YES);
  });
  addNotificationObserver(SINVerificationDidEndInitiatingNotification, ^{
    toggleActivityIndicator(activityIndicator, NO, YES);
  });
  addNotificationObserver(SINVerificationDidBeginVerifyingCalloutNotification, ^{
    toggleActivityIndicator(activityIndicator, YES, YES);
  });
  addNotificationObserver(SINVerificationDidEndVerifyingCalloutNotification, ^{
    toggleActivityIndicator(activityIndicator, NO, YES);
  });
}

void initAppearance(UIViewController *vc) {
  // This function must handle that the view controller is any of
  // NumberEntryViewController or CodeEntryViewController.

  setSinchLogInNavigationBar(vc);

  if ([vc respondsToSelector:@selector(countryButton)]) {
    styleButton([vc countryButton]);
  }

  if ([vc respondsToSelector:@selector(verifyButton)]) {
    // Disable the "verify" button initially (should be enabled based
    // on whether input is a viable phone number).
    UIButton *button = [vc verifyButton];
    button.enabled = NO;
  }

  if ([vc respondsToSelector:@selector(statusLabel)]) {
    // Initially set status label to empty string
    UILabel *label = [vc statusLabel];
    label.text = @"";
  }

  if ([vc respondsToSelector:@selector(activityIndicator)]) {
    initActivityIndicator([vc activityIndicator]);
  }
}

UIColor *colorForPossiblePhoneNumber() {
  return [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0];
}

UIColor *colorForNotPossiblePhoneNumber() {
  return [UIColor colorWithRed:1.0 green:0.9 blue:0.9 alpha:1.0];
}
