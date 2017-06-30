#import "CountrySelectionViewController.h"
@import SinchVerification;

@implementation CountrySelectionViewController {
  __strong NSArray<id<SINRegionInfo>>* _entries;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  id<SINRegionList> regions = [SINPhoneNumberUtil() regionListWithLocale:NSLocale.currentLocale];
  NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"countryDisplayName" ascending:YES];
  _entries = [regions.entries sortedArrayUsingDescriptors:@[ sortDescriptor ]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSUInteger row = [_entries indexOfObjectPassingTest:^BOOL(id<SINRegionInfo> obj, NSUInteger idx, BOOL* stop) {
    return [self.isoCountryCode isEqual:obj.isoCountryCode];
  }];
  if (row != NSNotFound) {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionMiddle];
  }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  return _entries.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"country" forIndexPath:indexPath];

  id<SINRegionInfo> entry = _entries[indexPath.row];

  cell.textLabel.text = entry.countryDisplayName;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"(+%@)", entry.countryCallingCode];

  return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
  self.onCompletion(_entries[indexPath.row].isoCountryCode);
}

@end
