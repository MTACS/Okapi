#include <stdlib.h>
#import <UIKit/UIKit.h>
#import <headers/MobileGestalt.h>
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <headers/UIColor-GlobalColors.h>
#import <headers/UIView+draggable.h>
#import <Cephei/HBPreferences.h>
#import <libcolorpicker.h>
#import <AudioToolbox/AudioServices.h>
#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#include <stdio.h>
#include <stddef.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>

@interface ZBPackageTableViewCell : UITableViewCell {
    UIView *_backgroundContainerView;
    UIImageView *_iconImageView;
    UILabel *_packageLabel;
    UILabel *_descriptionLabel;
    UIImageView *_isPaidImageView;
    UIImageView *_isInstalledImageView;
    UILabel *_queueStatusLabel;
}
@property (nonatomic, assign, readwrite) CGRect frame;
@end

@interface UITabBarButtonLabel : UILabel
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end

@interface UITabBarButton : UIControl
@property (nonatomic, assign, readwrite) CGPoint center;
- (void)refresh;
@end

@interface ZBRefreshViewController: UIViewController
@end

@interface ZBPackageInfoView: UIView {

	UIImageView *_packageIcon;
	UILabel *_packageName;

}
@end

@interface ZBRepoTableViewCell : UITableViewCell {
    UIImageView *_iconImageView;
    UILabel *_repoLabel;
    UIView *_backgroundContainerView;
    UILabel *_urlLabel;
    UIView *_accessoryZBView;
}
@end

@interface _UIBadgeView : UIView
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

@interface SBSeparatorView : UIView
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

@interface ZBDevice : NSObject
+ (long long)selectedColorTint;
+ (void)refreshViews;
+ (void)applyThemeSettings;
+ (void)configureLightMode;
+ (void)configureDarkMode;
+ (void)setDarkModeEnabled:(_Bool)arg1;
+ (_Bool)darkModeOledEnabled;
+ (_Bool)darkModeEnabled;
+ (id)deviceType;
+ (_Bool)isUncover;
+ (_Bool)isElectra;
+ (_Bool)isChimera;
+ (_Bool)_isRegularDirectory:(const char *)arg1;
+ (_Bool)_isRegularFile:(const char *)arg1;
+ (void)uicache:(id)arg1 observer:(id)arg2;
+ (void)sbreload;
+ (id)machineID;
+ (id)deviceModelID;
+ (id)UDID;
+ (_Bool)needsSimulation;
@end

@interface ZBSearchViewController : UITableViewController
@property (retain, nonatomic) UISearchController *searchController;
- (void)clearSearches;
@end

@interface ZBHomeTableViewController : UITableViewController
@property (retain, nonatomic) UILabel *udidLabel;
@end

@interface LNPopupBar

- (void)setImage:(UIImage *)image;
- (void)addGestureRecognizer:(UIGestureRecognizer *)arg1;

@end

@interface ZBQueue
+ (id)sharedInstance;
- (void)clearQueue;
@end

@interface _UIAlertControllerView : UIView
@property (nonatomic, strong, readwrite) UIColor *interactionTintColor;
@end

@interface ZBConsoleViewController : UIViewController {

	UIButton *_completeButton;

}
@property(retain, nonatomic) UIButton *completeButton;
@end

@interface ZBQueueViewController : UITableViewController
- (void)confirm:(id)arg1;
@end

@class NSArray, NSDate, NSString, NSURL, ZBRepo;

@interface ZBPackage : NSObject {

	NSArray *dependsOn;

}
@property(retain, nonatomic) NSString *section;
@property(retain, nonatomic) ZBRepo *repo;
@property(retain, nonatomic) NSString *identifier;
@end

@interface ZBRepo : NSObject
@property(retain, nonatomic) NSString *baseURL;
@end

@interface ZBChangesTableViewController
- (double)tableView:(id)arg1 heightForHeaderInSection:(long long)arg2;
@end

@interface ZBRefreshableTableViewController : UITableViewController
+ (_Bool)supportRefresh;
- (void)refreshSources:(id)arg1;
@end

@interface ZBCommunityReposTableViewController : UITableViewController
- (void)fetchMoreRepoJSON;
@property(retain) NSArray *communityRepos;
@end

@interface ZBPackageDepictionViewController : UIViewController {

	UILabel *_packageName;

}
@property(retain, nonatomic) UITableView *tableView;
@end

@class NSArray, NSMutableArray, NSString, UIBarButtonItem, ZBRepo;

@interface ZBPackageListTableViewController : ZBRefreshableTableViewController <UIViewControllerPreviewingDelegate>
- (void)sharePackages;
- (void)presentActivityController:(id)arg1;
- (void)exportPackages;
- (void)exportSources;
@property(readonly) Class superclass;
@end

@class NSMutableArray, NSString, ZBDownloadManager;
@interface ZBDatabaseManager : NSObject
+ (id)sharedInstance;
- (id)installedPackages;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
- (NSString *)applicationBundleIdentifier;
@end

@interface SBSApplicationShortcutItem : NSObject <NSCopying> 
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * localizedTitle;
@property (nonatomic,copy) NSString * localizedSubtitle;
@property (nonatomic,copy) NSString * bundleIdentifierToLaunch;
// @property (nonatomic,copy) SBSApplicationShortcutIcon * icon; 
@end

@interface _SBFakeBlurView : UIView
@property (assign,getter=isFullscreen,nonatomic) BOOL fullscreen; 
@end