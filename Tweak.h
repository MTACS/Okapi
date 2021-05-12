#import "./okapiprefs/OkapiRootListController.h"
#import "SparkColourPickerUtils.h"

#define CURRENT_TINT [[UIApplication sharedApplication] keyWindow].tintColor
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

static NSString *domain = @"com.mtac.okapi";
static NSString *PostNotificationString = @"com.mtac.okapi/preferences.changed";
static BOOL enabled;
static BOOL useCustomTintColor;
static BOOL hidePackageIcons;
static BOOL showPackageVersion;
static BOOL hideHomeIcons;
static BOOL hideSourceIcons;
static BOOL showSourceCount;
static BOOL showPackageCount;
static BOOL hideDeviceID;
static BOOL useFloatingQueue;
static BOOL useCydiaIcons;
static BOOL tintBadge;
static BOOL hideTabLabels;

typedef enum : NSUInteger {
    ZBAccentColorAquaVelvet,
    ZBAccentColorCornflowerBlue,
    ZBAccentColorGoldenTainoi,
    ZBAccentColorIrisBlue,
    ZBAccentColorLotusPink,
    ZBAccentColorMonochrome,
    ZBAccentColorMountainMeadow,
    ZBAccentColorPastelRed,
    ZBAccentColorPurpleHeart,
    ZBAccentColorRoyalBlue,
    ZBAccentColorShark,
    ZBAccentColorStorm,
} ZBAccentColor;

@interface NSUserDefaults (Okapi)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface _UISystemBackgroundView: UIView
@end

@interface UIView (Okapi)
- (id)_viewControllerForAncestor;
- (void)setOverrideUserInterfaceStyle:(NSInteger)style;
@end

@interface UITableViewLabel: UIView
@end

@interface UITableViewCellContentView: UIView
@end

@interface ZBPackage : NSObject
@property (nonatomic, strong) NSString *section;
@end

@interface ZBPackageTableViewCell: UITableViewCell
@property (strong, nonatomic) UIView *backgroundContainerView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *packageLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *isPaidImageView;
@property (strong, nonatomic) UIImageView *isInstalledImageView;
@property (strong, nonatomic) UILabel *queueStatusLabel;
@property (strong, nonatomic) UILabel *authorAndSourceAndSize;
@end

@interface ZBSourceTableViewCell: UITableViewCell
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *sourceLabel;
@end

@interface ZBSourceListTableViewController: UITableViewController
@end

@interface ZBSourceManager: NSObject
+ (id)sharedInstance;
- (NSMutableDictionary *)sources;
@end

@interface ZBPackageListTableViewController: UITableViewController {
    NSArray *packages;
}
@end

@interface ZBHomeTableViewController: UITableViewController
- (void)showUDID;
- (void)hideUDID;
@end

@interface ZBTabBarController: UITabBarController
@property (strong, nonatomic) UIView *queueButton;
- (void)openQueue:(BOOL)arg1;
- (void)okapiOpenQueue;
@end

@interface LNPopupBar: UIView
@end

@interface ZBAppDelegate: UIResponder
@property (strong, nonatomic) UIWindow *window;
@end

@interface ZBQueue: NSObject
@property (nonatomic, strong) NSMutableArray<NSString *> *queuedPackagesList;
+ (id)sharedQueue;
+ (int)count;
@end