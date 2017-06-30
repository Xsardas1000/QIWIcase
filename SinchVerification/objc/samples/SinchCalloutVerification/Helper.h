@import Foundation;
@import UIKit;

// The following functions should not be considered critical to the
// functionality of the Sinch SDK.  The functions are primarily
// helpers for showing UIAlerts, and styling the sample app
// appearance.

// Shows a UIAlert with the given error message
void showErrorMessage(NSString* message);

// Shows a UIAlert with a message based on the given error
void showError(NSError* error);

void initAppearance(UIViewController*);

// light green color
UIColor* colorForPossiblePhoneNumber();
// light red color
UIColor* colorForNotPossiblePhoneNumber();
