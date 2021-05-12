#import <Preferences/PSListController.h>
#import "SparkColourPickerUtils.h"
#import <Preferences/PSTableCell.h>

@interface PSSpecifier: NSObject {
    NSMutableDictionary* _properties;
}
- (id)properties;
@end

@interface OkapiRootListController : PSListController {
    UITableView * _table;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@end

@interface OkapiColorsListController : PSListController
@end

@interface OkapiPackageOptionsListController : PSListController
@end

@interface OkapiTabBarListController : PSListController
@end

@interface OkapiHomeListController : PSListController
@end

@interface OkapiSourceListController : PSListController
@end

@interface OkapiPackageListController : PSListController
@end

@interface OkapiQueueListController : PSListController
@end

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier;
- (void)controlChanged:(id)arg1;
@end

@interface OkapiSwitchCell: PSSwitchTableCell
@end

@interface ZBThemeManager: NSObject
+ (id)sharedInstance;
- (void)refreshViews;
- (void)configureNavigationBar;
@end