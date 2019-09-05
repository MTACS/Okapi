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

@class UITableViewCell; @class ZBHomeTableViewController; @class UITableView; @class _UIBadgeView; @class ZBPackageTableViewCell; @class UITabBarButtonLabel; @class UITabBarButton; @class SBSeparatorView; 


#line 108 "Tweak.xm"
static void (*_logos_orig$Tweak$ZBPackageTableViewCell$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$ZBPackageTableViewCell$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITabBarButtonLabel$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL UITabBarButtonLabel* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITabBarButtonLabel$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UITabBarButtonLabel* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITabBarButton$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL UITabBarButton* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITabBarButton$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITabBarButton* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITableViewCell$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITableViewCell$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static UIImageView * (*_logos_orig$Tweak$UITableViewCell$imageView)(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static UIImageView * _logos_method$Tweak$UITableViewCell$imageView(_LOGOS_SELF_TYPE_NORMAL UITableViewCell* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$_UIBadgeView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL _UIBadgeView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$_UIBadgeView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL _UIBadgeView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$UITableView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL UITableView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$UITableView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL UITableView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$SBSeparatorView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBSeparatorView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$SBSeparatorView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBSeparatorView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$ZBHomeTableViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$ZBHomeTableViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST, SEL); 



static void _logos_method$Tweak$ZBPackageTableViewCell$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL ZBPackageTableViewCell* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) { 

	_logos_orig$Tweak$ZBPackageTableViewCell$layoutSubviews(self, _cmd);

	if (enabled && hidePackageIcons) {

		UIImageView *newImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		newImageView.hidden = YES;

		

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

		self.backgroundColor = [UIColor tintColor];

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

	self.backgroundColor = [UIColor clearColor];

}
	




static void _logos_method$Tweak$ZBHomeTableViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL ZBHomeTableViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Tweak$ZBHomeTableViewController$viewDidLoad(self, _cmd);

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	

	





	newLabel.text = @"TEST";

}





static __attribute__((constructor)) void _logosLocalCtor_6395bdbc(int __unused argc, char __unused **argv, char __unused **envp) {

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

	{Class _logos_class$Tweak$ZBPackageTableViewCell = objc_getClass("ZBPackageTableViewCell"); MSHookMessageEx(_logos_class$Tweak$ZBPackageTableViewCell, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$ZBPackageTableViewCell$layoutSubviews, (IMP*)&_logos_orig$Tweak$ZBPackageTableViewCell$layoutSubviews);Class _logos_class$Tweak$UITabBarButtonLabel = objc_getClass("UITabBarButtonLabel"); MSHookMessageEx(_logos_class$Tweak$UITabBarButtonLabel, @selector(didMoveToWindow), (IMP)&_logos_method$Tweak$UITabBarButtonLabel$didMoveToWindow, (IMP*)&_logos_orig$Tweak$UITabBarButtonLabel$didMoveToWindow);Class _logos_class$Tweak$UITabBarButton = objc_getClass("UITabBarButton"); MSHookMessageEx(_logos_class$Tweak$UITabBarButton, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$UITabBarButton$layoutSubviews, (IMP*)&_logos_orig$Tweak$UITabBarButton$layoutSubviews);Class _logos_class$Tweak$UITableViewCell = objc_getClass("UITableViewCell"); MSHookMessageEx(_logos_class$Tweak$UITableViewCell, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$UITableViewCell$layoutSubviews, (IMP*)&_logos_orig$Tweak$UITableViewCell$layoutSubviews);MSHookMessageEx(_logos_class$Tweak$UITableViewCell, @selector(imageView), (IMP)&_logos_method$Tweak$UITableViewCell$imageView, (IMP*)&_logos_orig$Tweak$UITableViewCell$imageView);Class _logos_class$Tweak$_UIBadgeView = objc_getClass("_UIBadgeView"); MSHookMessageEx(_logos_class$Tweak$_UIBadgeView, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$_UIBadgeView$layoutSubviews, (IMP*)&_logos_orig$Tweak$_UIBadgeView$layoutSubviews);Class _logos_class$Tweak$UITableView = objc_getClass("UITableView"); MSHookMessageEx(_logos_class$Tweak$UITableView, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$UITableView$layoutSubviews, (IMP*)&_logos_orig$Tweak$UITableView$layoutSubviews);Class _logos_class$Tweak$SBSeparatorView = objc_getClass("SBSeparatorView"); MSHookMessageEx(_logos_class$Tweak$SBSeparatorView, @selector(layoutSubviews), (IMP)&_logos_method$Tweak$SBSeparatorView$layoutSubviews, (IMP*)&_logos_orig$Tweak$SBSeparatorView$layoutSubviews);Class _logos_class$Tweak$ZBHomeTableViewController = objc_getClass("ZBHomeTableViewController"); MSHookMessageEx(_logos_class$Tweak$ZBHomeTableViewController, @selector(viewDidLoad), (IMP)&_logos_method$Tweak$ZBHomeTableViewController$viewDidLoad, (IMP*)&_logos_orig$Tweak$ZBHomeTableViewController$viewDidLoad);}

}