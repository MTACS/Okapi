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

@interface MoreSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface PackageSettingsListController: HBRootListController {

    UITableView * _table;

}
@property (nonatomic, retain) UILabel *titleLabel;
@end

// Thanks Nepeta

@interface OkapiAppearanceSettings: HBAppearanceSettings

@end
