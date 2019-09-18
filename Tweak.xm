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

#define zebraBlue [UIColor colorWithRed:107/255.0f green:127/255.0f blue:242/255.0f alpha:1.0f]

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
UIColor *ctintcolorhex = nil;

// Definitions

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

%group Tweak

// Custom tint color 

%hook UITabBar

- (void)setFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.tintColor = color;

	}

}

%end

%hook UINavigationBar

- (void)setFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.tintColor = color;

	}

}

%end

%hook UIProgressView

- (void)setFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.progressTintColor = color;

	}

}

%end

%hook ZBConsoleViewController

- (void)viewDidLoad {

	%orig;

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		UIButton *finishButton = MSHookIvar<UIButton *>(self, "_completeButton");

		finishButton.backgroundColor = color;

	}

}

%end

// Package Cells

%hook ZBPackageTableViewCell

- (void)layoutSubviews { // Sets package cells

	%orig;

	if (enabled && hidePackageIcons) {

		UIImageView *newImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		newImageView.hidden = YES;

		// Remove cell icon

		CGPoint newContentCenter;

		newContentCenter.y = 29;

		newContentCenter.x = self.center.x - 48;

		UIView *newContentView = MSHookIvar<UIView *>(self, "_contentView");

		newContentView.center = newContentCenter;

		CGRect newFrame = self.frame;

		newFrame.size.width = 420;

		self.frame = newFrame;

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

%new

- (NSString *)deviceModelString {

	struct utsname systemInfo;

	uname(&systemInfo);

	return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

}

%end

// Tab Bar Labels

%hook UITabBarButtonLabel

- (void)didMoveToWindow {

	%orig;

	if (enabled && hideTabBarLabels) {

		self.hidden = YES;

	}

}

%end

%hook UITabBarButton

- (void)layoutSubviews {

	%orig;

	if (enabled && centerIcons) {

		NSString *deviceType = [[UIDevice currentDevice] model];

		if (![deviceType containsString:@"iPad"]) {

			CGPoint newCenter = self.center;

    		newCenter.y = 30;

    		self.center = newCenter;

		} 

	}

}

%end

// Homepage

%hook UITableViewCell

- (void)layoutSubviews {

	%orig;

	if (enabled && homecells) {

		UILabel *newTextLabel = MSHookIvar<UILabel *>(self, "_textLabel");

		CGRect newTextLabelFrame = newTextLabel.frame;

		newTextLabelFrame.origin.x = 12;

		newTextLabel.frame = newTextLabelFrame;

	}

}

- (UIImageView *)imageView {

	%orig;

	if (enabled && homecells) {

		return NULL;

	}

	return %orig;

}

%end

// Badges

%hook _UIBadgeView

- (void)layoutSubviews {

	%orig;

	if (enabled && tintBadges) {

		if (ctintcolor) {

			UIColor *color = ctintcolorhex;

			self.backgroundColor = color;

		} else {

			self.backgroundColor = [UIColor tintColor];

		}

	}

}

%end

// Separators

%hook UITableView
	
- (void)layoutSubviews {
	
	%orig;

	if (enabled && noSeparators) {

		self.separatorColor = [UIColor clearColor];

	}
	
}
	
%end

%hook SBSeparatorView
	
- (void)layoutSubviews {

	%orig;

	if (enabled && noSeparators) {

		self.backgroundColor = [UIColor clearColor];

	}

}
	
%end

%hook ZBHomeTableViewController

- (void)viewDidLoad {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.0.5"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}

%end

// Queue

%hook LNPopupBar

- (void)layoutSubviews {

	%orig;

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

%end

%end

void loadColors() {

	NSDictionary *colors = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mtac.okapi.plist"];

	if (!colors) {

		return;

	}

	ctintcolorhex = [LCPParseColorString([colors objectForKey:@"ctintcolorhex"], @"#6B7FF2:1.0") copy];

}

%ctor {

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

	loadColors();

	%init(Tweak);

}