#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>

@interface PreferencesListController : HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UIBarButtonItem *killButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@end

@interface PackageSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface AppSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface HomeSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface ExperimentalSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface QueueSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface SearchSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface ConsoleSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

// Thanks Nepeta

@interface OkapiAppearanceSettings: HBAppearanceSettings

@end
