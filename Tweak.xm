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

// Package Cells

%group Tweak

%hook ZBPackageTableViewCell

- (void)layoutSubviews { // Sets package cells

	%orig;

	if (enabled && hidePackageIcons) {

		UIImageView *newImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		newImageView.hidden = YES;

		// Remove cell icon

		CGPoint newContentCenter;

		newContentCenter.x = 130;

		newContentCenter.y = 29;

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

		self.backgroundColor = [UIColor tintColor];

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

	self.backgroundColor = [UIColor clearColor];

}
	
%end

%hook ZBHomeTableViewController

- (void)viewDidLoad {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	// newLabel.hidden = YES;

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.0.2-beta"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}

%end

%hook LNPopupBar

- (void)layoutSubviews {

	%orig;

	/* if (enabled) {

		UILabel *newSubtitle = MSHookIvar<UILabel *>(self, "_subtitleLabel");

		newSubtitle.hidden = YES;

		UILabel *newTitle = MSHookIvar<UILabel *>(self, "_titleLabel");

		// newTitle.hidden = YES;

		NSString *origString = newTitle.text;

		NSString *numberString;

		NSScanner *scanner = [NSScanner scannerWithString:origString];

		NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];

		[scanner scanUpToCharactersFromSet:numbers intoString:NULL];

		[scanner scanCharactersFromSet:numbers intoString:&numberString];

		int number = [numberString integerValue];

		NSLog(@"%d", number);

		// newTitle.text = [NSString stringWithFormat:@"%d", number];

		UIView *queueView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];

		queueView.layer.cornerRadius = 25;

		queueView.layer.masksToBounds = YES;

		queueView.backgroundColor = [UIColor tintColor];

		[self addSubview:queueView];
		
	} */

}

%end

%end

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

	%init(Tweak);

}