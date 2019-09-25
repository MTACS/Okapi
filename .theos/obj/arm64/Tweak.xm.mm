#line 1 "Tweak.xm"
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


#define zebraBlue [UIColor colorWithRed:107/255.0f green:127/255.0f blue:242/255.0f alpha:1.0f]
#define LocalizedString(string) [NSBundle.mainBundle localizedStringForKey:string value:string table:nil]
#define rootViewController [[[[UIApplication sharedApplication] delegate] window] rootViewController]

HBPreferences *preferences;
BOOL enabled;
BOOL hideTabBarLabels;
BOOL centerIcons;
BOOL tintBadges;
BOOL noSeparators;
BOOL hidePaidIcon;
BOOL hideInstalledIcon;
BOOL hidePackageIcons;
BOOL homecells;
BOOL redesignedQueue;
BOOL ctintcolor;
BOOL autorespring;
BOOL hidesearches;
BOOL confirmfaceid;
BOOL useCydiaIcons;
BOOL hideThemes;
BOOL useCommunityRepos;
UIColor *ctintcolorhex = nil;
CGFloat pcellframe;
CGFloat respringdelay;
LAPolicy policy;
NSArray *moreRepos;

enum ZBSourcesOrder {
    ZBTransfer,
    ZBJailbreakRepo,
    ZBCommunity,
	ZBMore
};



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
- (NSString *)deviceModelString;
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

@interface ZBPackage : NSObject
@property(retain, nonatomic) NSString *section;
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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class UITabBar; @class ZBQueueViewController; @class SBSeparatorView; @class UITabBarButtonLabel; @class UIProgressView; @class UITableViewCell; @class LNPopupBar; @class ZBPackageTableViewCell; @class UITabBarButton; @class ZBSearchViewController; @class ZBConsoleViewController; @class UINavigationBar; @class _UIBadgeView; @class UITableView; @class ZBCommunityReposTableViewController; @class ZBHomeTableViewController; 


#line 185 "Tweak.xm"
static void (*_logos_orig$Tweak$UITabBar$setFrame$)(_LOGOS_SELF_TYPE_NORMAL UITabBar* _LOGOS_SELF_CONST, SEL, CGRect); static void _logos_method$Tweak$UITabBar$setFrame$(_LOGOS_SELF_TYPE_NORMAL UITabBar* _LOGOS_SELF_CONST, SEL, CGRect); static void (*_logos_orig$Tweak$UINavigationBar$setFrame$)(_LOGOS_SELF_TYPE_NORMAL UINavigationBar* _LOGOS_SELF_CONST, SEL, CGRect); static void _logos_method$Tweak$UINavigationBar$setFrame$(_LOGOS_SELF_TYPE_NORMAL UINavigationBar* _LOGOS_SELF_CONST, SEL, CGRect); static void (*_logos_orig$Tweak$UIProgressView$setFrame$)(_LOGOS_SELF_TYPE_NORMAL UIProgressView* _LOGOS_SELF_CONST, SEL, CGRect); static void _logos_method$Tweak$UIProgressView$setFrame$(_LOGOS_SELF_TYPE_NORMAL UIProgressView* _LOGOS_SELF_CONST, SEL, CGRect); static void (*_logos_orig$Tweak$ZBConsoleViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL ZBConsoleViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$ZBConsoleViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL ZBConsoleViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$ZBConsoleViewController$updateCompleteButton)(_LOGOS_SELF_TYPE_NORMAL ZBConsoleViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$ZBConsoleViewController$updateCompleteButton(_LOGOS_SELF_TYPE_NORMAL ZBConsoleViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$ZBPackageTableViewCell$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$ZBPackageTableViewCell$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$ZBPackageTableViewCell$updateData$)(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST, SEL, ZBPackage *); static void _logos_method$Tweak$ZBPackageTableViewCell$updateData$(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST, SEL, ZBPackage *); static NSString * _logos_method$Tweak$ZBPackageTableViewCell$deviceModelString(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$ZBCommunityReposTableViewController$fetchRepoJSON)(_LOGOS_SELF_TYPE_NORMAL ZBCommunityReposTableViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$ZBCommunityReposTableViewController$fetchRepoJSON(_LOGOS_SELF_TYPE_NORMAL ZBCommunityReposTableViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITabBarButtonLabel$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL UITabBarButtonLabel* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITabBarButtonLabel$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UITabBarButtonLabel* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITabBarButton$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL UITabBarButton* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITabBarButton$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITabBarButton* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITableViewCell$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITableViewCell$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static UIImageView * (*_logos_orig$Tweak$UITableViewCell$imageView)(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static UIImageView * _logos_method$Tweak$UITableViewCell$imageView(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$_UIBadgeView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL _UIBadgeView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$_UIBadgeView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL _UIBadgeView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITableView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL UITableView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITableView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITableView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$SBSeparatorView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBSeparatorView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$SBSeparatorView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBSeparatorView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$ZBHomeTableViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$ZBHomeTableViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$ZBHomeTableViewController$toggleDarkMode$)(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$Tweak$ZBHomeTableViewController$toggleDarkMode$(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$Tweak$ZBSearchViewController$didDismissSearchController$)(_LOGOS_SELF_TYPE_NORMAL ZBSearchViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$Tweak$ZBSearchViewController$didDismissSearchController$(_LOGOS_SELF_TYPE_NORMAL ZBSearchViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$Tweak$ZBQueueViewController$confirm$)(_LOGOS_SELF_TYPE_NORMAL ZBQueueViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$Tweak$ZBQueueViewController$confirm$(_LOGOS_SELF_TYPE_NORMAL ZBQueueViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$Tweak$LNPopupBar$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL LNPopupBar* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$LNPopupBar$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL LNPopupBar* _LOGOS_SELF_CONST, SEL); 





static void _logos_method$Tweak$UITabBar$setFrame$(_LOGOS_SELF_TYPE_NORMAL UITabBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect arg1) {

	_logos_orig$Tweak$UITabBar$setFrame$(self, _cmd, arg1);

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.tintColor = color;

	}

}





static void _logos_method$Tweak$UINavigationBar$setFrame$(_LOGOS_SELF_TYPE_NORMAL UINavigationBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect arg1) {

	_logos_orig$Tweak$UINavigationBar$setFrame$(self, _cmd, arg1);

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.tintColor = color;

	}

}





static void _logos_method$Tweak$UIProgressView$setFrame$(_LOGOS_SELF_TYPE_NORMAL UIProgressView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect arg1) {

	_logos_orig$Tweak$UIProgressView$setFrame$(self, _cmd, arg1);

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.progressTintColor = color;

	}

}





static void _logos_method$Tweak$ZBConsoleViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL ZBConsoleViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$ZBConsoleViewController$viewDidLoad(self, _cmd);

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		UIButton *finishButton = MSHookIvar<UIButton *>(self, "_completeButton");

		finishButton.backgroundColor = color;

	}

}







static void _logos_method$Tweak$ZBPackageTableViewCell$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) { 

	_logos_orig$Tweak$ZBPackageTableViewCell$layoutSubviews(self, _cmd);

	if (enabled && hidePackageIcons) {

		UIImageView *newImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		newImageView.hidden = YES;		

		CGPoint newContentCenter;

		if ([[self deviceModelString] containsString:@"iPhone10,6"] || [[self deviceModelString] containsString:@"iPhone10,3"]) {

			newContentCenter.x = 120 + pcellframe;

			newContentCenter.y = 29;

		} else if ([[self deviceModelString] containsString:@"iPhone11,4"] || [[self deviceModelString] containsString:@"iPhone11,6"]) {

			newContentCenter.x = 150 + pcellframe;

			newContentCenter.y = 29;

		} else if ([[self deviceModelString] containsString:@"iPad"]) {

			newContentCenter.x = 328 + pcellframe;

		} else {

			newContentCenter.x = 138 + pcellframe;

			newContentCenter.y = 29;

		}

		UIView *newContentView = MSHookIvar<UIView *>(self, "_contentView");

		newContentView.center = newContentCenter;

	}

	if (enabled && hideInstalledIcon) {

		UIImageView *installed = MSHookIvar<UIImageView *>(self, "_isInstalledImageView");

		installed.hidden = YES;

	}

	if (enabled && hidePaidIcon) {

		UIImageView *paid = MSHookIvar<UIImageView *>(self, "_isPaidImageView");

		paid.hidden = YES;

	}

	

}

static void _logos_method$Tweak$ZBPackageTableViewCell$updateData$(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, ZBPackage * package) {

	_logos_orig$Tweak$ZBPackageTableViewCell$updateData$(self, _cmd, package);

	if (enabled && useCydiaIcons) {

		NSString *sectionString = package.section;

		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.mtac.okapi.bundle"];

		UIImage *iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:sectionString ofType:@"png"]];

		UIImageView *newIconImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		if (iconImage == nil) {

			UIImage *staticIconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Tweaks" ofType:@"png"]];

			newIconImageView.image = staticIconImage;

		} else {

			newIconImageView.image = iconImage;

		}
		
	}

	











}



static NSString * _logos_method$Tweak$ZBPackageTableViewCell$deviceModelString(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	struct utsname systemInfo;

	uname(&systemInfo);

	return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

}







static void _logos_method$Tweak$ZBCommunityReposTableViewController$fetchRepoJSON(_LOGOS_SELF_TYPE_NORMAL ZBCommunityReposTableViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];

	if (enabled && useCommunityRepos) {

		[request setURL:[NSURL URLWithString:@"https://mtac.app/api/morerepos.json"]];

	} else {

		[request setURL:[NSURL URLWithString:@"https://getzbra.com/api/communityrepos.json"]];

	}

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
        if (data && !error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([json objectForKey:@"repos"]) {

				

				self.communityRepos = json[@"repos"];
            	
            }
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.tableView reloadData];
              });
          }
          if (error){
              NSLog(@"[Zebra] Github error %@", error);
          }
      }] resume];
    
}








static void _logos_method$Tweak$UITabBarButtonLabel$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UITabBarButtonLabel* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$UITabBarButtonLabel$didMoveToWindow(self, _cmd);

	if (enabled && hideTabBarLabels) {

		self.hidden = YES;

	}

}





static void _logos_method$Tweak$UITabBarButton$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITabBarButton* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$UITabBarButton$layoutSubviews(self, _cmd);

	if (enabled && centerIcons) {

		NSString *deviceType = [[UIDevice currentDevice] model];

		if (![deviceType containsString:@"iPad"]) {

			CGPoint newCenter = self.center;

    		newCenter.y = 30;

    		self.center = newCenter;

		} 

	}

}







static void _logos_method$Tweak$UITableViewCell$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$UITableViewCell$layoutSubviews(self, _cmd);

	if (enabled && homecells) {

		UILabel *newTextLabel = MSHookIvar<UILabel *>(self, "_textLabel");

		CGRect newTextLabelFrame = newTextLabel.frame;

		newTextLabelFrame.origin.x = 12;

		newTextLabel.frame = newTextLabelFrame;

	}

}

static UIImageView * _logos_method$Tweak$UITableViewCell$imageView(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$UITableViewCell$imageView(self, _cmd);

	if (enabled && homecells) {

		return NULL;

	}

	return _logos_orig$Tweak$UITableViewCell$imageView(self, _cmd);

}







static void _logos_method$Tweak$_UIBadgeView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL _UIBadgeView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$_UIBadgeView$layoutSubviews(self, _cmd);

	if (enabled && tintBadges) {

		if (ctintcolor) {

			UIColor *color = ctintcolorhex;

			self.backgroundColor = color;

		} else {

			self.backgroundColor = [UIColor tintColor];

		}

	}

}






	
static void _logos_method$Tweak$UITableView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITableView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	
	_logos_orig$Tweak$UITableView$layoutSubviews(self, _cmd);

	if (enabled && noSeparators) {

		self.separatorColor = [UIColor clearColor];

	}
	
}
	



	
static void _logos_method$Tweak$SBSeparatorView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBSeparatorView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$SBSeparatorView$layoutSubviews(self, _cmd);

	if (enabled && noSeparators) {

		self.backgroundColor = [UIColor clearColor];

	}

}
	




static void _logos_method$Tweak$ZBHomeTableViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$ZBHomeTableViewController$viewDidLoad(self, _cmd);

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.0.7"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}

static void _logos_method$Tweak$ZBHomeTableViewController$toggleDarkMode$(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {

	_logos_orig$Tweak$ZBHomeTableViewController$toggleDarkMode$(self, _cmd, arg1);

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.0.6"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}







static void _logos_method$Tweak$ZBSearchViewController$didDismissSearchController$(_LOGOS_SELF_TYPE_NORMAL ZBSearchViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {

	_logos_orig$Tweak$ZBSearchViewController$didDismissSearchController$(self, _cmd, arg1);

	if (enabled && hidesearches) {

		[self clearSearches];

	}

}







static void _logos_method$Tweak$ZBConsoleViewController$updateCompleteButton(_LOGOS_SELF_TYPE_NORMAL ZBConsoleViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

    _logos_orig$Tweak$ZBConsoleViewController$updateCompleteButton(self, _cmd);

	if (enabled && autorespring) {

		if (respringdelay > 0) {

			sleep(respringdelay);

		}

		[self.completeButton sendActionsForControlEvents:UIControlEventTouchUpInside];

	}

}





 

static void _logos_method$Tweak$ZBQueueViewController$confirm$(_LOGOS_SELF_TYPE_NORMAL ZBQueueViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {

	if (enabled && confirmfaceid) {

		@autoreleasepool {
		LAContext *context = [[LAContext alloc] init];
		[context evaluatePolicy:policy
			localizedReason:LocalizedString(@"Authentication is required")
			reply:^(BOOL success, NSError *error) {
				if (success || (error && ((error.code == LAErrorPasscodeNotSet) ||
					(
						(policy == LAPolicyDeviceOwnerAuthenticationWithBiometrics) && (
							(error.code == LAErrorTouchIDNotAvailable) ||
							(error.code == LAErrorTouchIDNotEnrolled)
						)
					)
				))) {
		
						dispatch_sync(dispatch_get_main_queue(), ^{

							_logos_orig$Tweak$ZBQueueViewController$confirm$(self, _cmd, arg1);

						});
					}
				}
			];
		}

	}

}





static void _logos_method$Tweak$LNPopupBar$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL LNPopupBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$LNPopupBar$layoutSubviews(self, _cmd);

	if (enabled && redesignedQueue) {

		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/okapiprefs.bundle"];

		UILabel *newSubtitle = MSHookIvar<UILabel *>(self, "_subtitleLabel");

		newSubtitle.hidden = YES;

		UILabel *newTitle = MSHookIvar<UILabel *>(self, "_titleLabel");

		CGPoint newCenter = newTitle.center;

		newCenter.y = 33;

		newTitle.center = newCenter;

		UIImageView *dliv = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"arrow" ofType:@"png"]]];

		dliv.image = [dliv.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

		[dliv setTintColor:[UIColor tintColor]];

		[self setImage:dliv.image];

	}

}





void loadColors() {

	NSDictionary *colors = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mtac.okapi.plist"];

	if (!colors) {

		return;

	}

	ctintcolorhex = [LCPParseColorString([colors objectForKey:@"ctintcolorhex"], @"#6B7FF2:1.0") copy];

}

static __attribute__((constructor)) void _logosLocalCtor_2d225aed(int __unused argc, char __unused **argv, char __unused **envp) {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.mtac.okapi"];

	[preferences registerBool:&enabled default:YES forKey:@"Enabled"];

	[preferences registerBool:&hideTabBarLabels default:YES forKey:@"hideTabBarLabels"]; 

	[preferences registerBool:&centerIcons default:YES forKey:@"centerIcons"];

	[preferences registerBool:&tintBadges default:YES forKey:@"tintBadges"];

	[preferences registerBool:&noSeparators default:YES forKey:@"tintBadges"];

	[preferences registerBool:&hidePaidIcon default:YES forKey:@"hidePaidIcon"];

	[preferences registerBool:&hideInstalledIcon default:YES forKey:@"hideInstalledIcon"];

	[preferences registerBool:&hidePackageIcons default:YES forKey:@"hidePackageIcons"];

	[preferences registerBool:&homecells default:YES forKey:@"homecells"];

	[preferences registerBool:&redesignedQueue default:YES forKey:@"redesignedQueue"];

	[preferences registerBool:&ctintcolor default:YES forKey:@"ctintcolor"];

	[preferences registerObject:&ctintcolorhex default:nil forKey:@"ctintcolorhex"];

	[preferences registerFloat:&pcellframe default:0.0 forKey:@"pcellframe"];

	[preferences registerFloat:&respringdelay default:0.0 forKey:@"respringdelay"];

	[preferences registerBool:&autorespring default:YES forKey:@"autorespring"];

	[preferences registerBool:&hidesearches default:YES forKey:@"hidesearches"];

	[preferences registerBool:&confirmfaceid default:YES forKey:@"confirmfaceid"];

	[preferences registerBool:&useCydiaIcons default:YES forKey:@"useCydiaIcons"];

	[preferences registerBool:&hideThemes default:YES forKey:@"hideThemes"];

	[preferences registerBool:&useCommunityRepos default:YES forKey:@"useCommunityRepos"];

	loadColors();

	if (kCFCoreFoundationVersionNumber >= 1240.10) policy = LAPolicyDeviceOwnerAuthentication;
	else policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

	{Class _logos_class$Tweak$UITabBar = objc_getClass("UITabBar"); MSHookMessageEx(_logos_class$Tweak$UITabBar, @selector(setFrame:), (IMP)&_logos_method$Tweak$UITabBar$setFrame$, (IMP*)&_logos_orig$Tweak$UITabBar$setFrame$);Class _logos_class$Tweak$UINavigationBar = objc_getClass("UINavigationBar"); MSHookMessageEx(_logos_class$Tweak$UINavigationBar, @selector(setFrame:), (IMP)&_logos_method$Tweak$UINavigationBar$setFrame$, (IMP*)&_logos_orig$Tweak$UINavigationBar$setFrame$);Class _logos_class$Tweak$UIProgressView = objc_getClass("UIProgressView"); MSHookMessageEx(_logos_class$Tweak$UIProgressView, @selector(setFrame:), (IMP)&_logos_method$Tweak$UIProgressView$setFrame$, (IMP*)&_logos_orig$Tweak$UIProgressView$setFrame$);Class _logos_class$Tweak$ZBConsoleViewController = objc_getClass("ZBConsoleViewController"); MSHookMessageEx(_logos_class$Tweak$ZBConsoleViewController, @selector(viewDidLoad), (IMP)&_logos_method$Tweak$ZBConsoleViewController$viewDidLoad, (IMP*)&_logos_orig$Tweak$ZBConsoleViewController$viewDidLoad);MSHookMessageEx(_logos_class$Tweak$ZBConsoleViewController, @selector(updateCompleteButton), (IMP)&_logos_method$Tweak$ZBConsoleViewController$updateCompleteButton, (IMP*)&_logos_orig$Tweak$ZBConsoleViewController$updateCompleteButton);Class _logos_class$Tweak$ZBPackageTableViewCell = objc_getClass("ZBPackageTableViewCell"); MSHookMessageEx(_logos_class$Tweak$ZBPackageTableViewCell, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$ZBPackageTableViewCell$layoutSubviews, (IMP*)&_logos_orig$Tweak$ZBPackageTableViewCell$layoutSubviews);MSHookMessageEx(_logos_class$Tweak$ZBPackageTableViewCell, @selector(updateData:), (IMP)&_logos_method$Tweak$ZBPackageTableViewCell$updateData$, (IMP*)&_logos_orig$Tweak$ZBPackageTableViewCell$updateData$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$Tweak$ZBPackageTableViewCell, @selector(deviceModelString), (IMP)&_logos_method$Tweak$ZBPackageTableViewCell$deviceModelString, _typeEncoding); }Class _logos_class$Tweak$ZBCommunityReposTableViewController = objc_getClass("ZBCommunityReposTableViewController"); MSHookMessageEx(_logos_class$Tweak$ZBCommunityReposTableViewController, @selector(fetchRepoJSON), (IMP)&_logos_method$Tweak$ZBCommunityReposTableViewController$fetchRepoJSON, (IMP*)&_logos_orig$Tweak$ZBCommunityReposTableViewController$fetchRepoJSON);Class _logos_class$Tweak$UITabBarButtonLabel = objc_getClass("UITabBarButtonLabel"); MSHookMessageEx(_logos_class$Tweak$UITabBarButtonLabel, @selector(didMoveToWindow), (IMP)&_logos_method$Tweak$UITabBarButtonLabel$didMoveToWindow, (IMP*)&_logos_orig$Tweak$UITabBarButtonLabel$didMoveToWindow);Class _logos_class$Tweak$UITabBarButton = objc_getClass("UITabBarButton"); MSHookMessageEx(_logos_class$Tweak$UITabBarButton, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$UITabBarButton$layoutSubviews, (IMP*)&_logos_orig$Tweak$UITabBarButton$layoutSubviews);Class _logos_class$Tweak$UITableViewCell = objc_getClass("UITableViewCell"); MSHookMessageEx(_logos_class$Tweak$UITableViewCell, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$UITableViewCell$layoutSubviews, (IMP*)&_logos_orig$Tweak$UITableViewCell$layoutSubviews);MSHookMessageEx(_logos_class$Tweak$UITableViewCell, @selector(imageView), (IMP)&_logos_method$Tweak$UITableViewCell$imageView, (IMP*)&_logos_orig$Tweak$UITableViewCell$imageView);Class _logos_class$Tweak$_UIBadgeView = objc_getClass("_UIBadgeView"); MSHookMessageEx(_logos_class$Tweak$_UIBadgeView, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$_UIBadgeView$layoutSubviews, (IMP*)&_logos_orig$Tweak$_UIBadgeView$layoutSubviews);Class _logos_class$Tweak$UITableView = objc_getClass("UITableView"); MSHookMessageEx(_logos_class$Tweak$UITableView, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$UITableView$layoutSubviews, (IMP*)&_logos_orig$Tweak$UITableView$layoutSubviews);Class _logos_class$Tweak$SBSeparatorView = objc_getClass("SBSeparatorView"); MSHookMessageEx(_logos_class$Tweak$SBSeparatorView, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$SBSeparatorView$layoutSubviews, (IMP*)&_logos_orig$Tweak$SBSeparatorView$layoutSubviews);Class _logos_class$Tweak$ZBHomeTableViewController = objc_getClass("ZBHomeTableViewController"); MSHookMessageEx(_logos_class$Tweak$ZBHomeTableViewController, @selector(viewDidLoad), (IMP)&_logos_method$Tweak$ZBHomeTableViewController$viewDidLoad, (IMP*)&_logos_orig$Tweak$ZBHomeTableViewController$viewDidLoad);MSHookMessageEx(_logos_class$Tweak$ZBHomeTableViewController, @selector(toggleDarkMode:), (IMP)&_logos_method$Tweak$ZBHomeTableViewController$toggleDarkMode$, (IMP*)&_logos_orig$Tweak$ZBHomeTableViewController$toggleDarkMode$);Class _logos_class$Tweak$ZBSearchViewController = objc_getClass("ZBSearchViewController"); MSHookMessageEx(_logos_class$Tweak$ZBSearchViewController, @selector(didDismissSearchController:), (IMP)&_logos_method$Tweak$ZBSearchViewController$didDismissSearchController$, (IMP*)&_logos_orig$Tweak$ZBSearchViewController$didDismissSearchController$);Class _logos_class$Tweak$ZBQueueViewController = objc_getClass("ZBQueueViewController"); MSHookMessageEx(_logos_class$Tweak$ZBQueueViewController, @selector(confirm:), (IMP)&_logos_method$Tweak$ZBQueueViewController$confirm$, (IMP*)&_logos_orig$Tweak$ZBQueueViewController$confirm$);Class _logos_class$Tweak$LNPopupBar = objc_getClass("LNPopupBar"); MSHookMessageEx(_logos_class$Tweak$LNPopupBar, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$LNPopupBar$layoutSubviews, (IMP*)&_logos_orig$Tweak$LNPopupBar$layoutSubviews);}

}
