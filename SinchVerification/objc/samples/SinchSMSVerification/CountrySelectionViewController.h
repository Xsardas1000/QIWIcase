@import UIKit;

@interface CountrySelectionViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString* isoCountryCode;

@property (nonatomic, copy) void (^onCompletion)(NSString* isoCountryCode);

@end
