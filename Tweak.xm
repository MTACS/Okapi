#import "Tweak.h"

UIColor *currentTint() {
	NSMutableDictionary *colorDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mtac.okapicolors.plist"];
	return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"appTintColor"] withFallback:@"#667FFA"];
}

BOOL isNotched() {
    if ([UIScreen mainScreen].bounds.size.height == 667 || [UIScreen mainScreen].bounds.size.height == 1334) { // Terrible, awful button layout, someone smarter please add autolayout to the safe area insets maybe?
        return NO;
    }
    return YES;
}

int getTabBarHeight() {
    switch ((int)HEIGHT) {
        case 667:
            return HEIGHT - 120;
        case 812:
            return HEIGHT - 150;
        case 844:
            return HEIGHT - 150;
        default:
            return HEIGHT - 120;
    }
    return 100;
}

%group App
%hook UITableView
- (UIEdgeInsets)_sectionContentInset {
    UIEdgeInsets insets = %orig;
    if (useInsetCells) {
        return UIEdgeInsetsMake(insets.top, 16, insets.bottom, 16);
    }
    return %orig;
}
- (void)_setSectionContentInset:(UIEdgeInsets)insets {
    if (useInsetCells) {
        insets = UIEdgeInsetsMake(insets.top, 16, insets.bottom, 16);
    }
    %orig;	
}
- (UIColor *)separatorColor {
    if (hideTableSeparators) {
        return [UIColor clearColor];
    }
    return %orig;
}
%end

%hook ZBPackageTableViewCell
- (void)updateData:(ZBPackage *)package calculateSize:(BOOL)calculateSize showVersion:(BOOL)showVersion {
    if (showPackageVersion) {
        showVersion = 1;
    }
    %orig;
}
%end

%hook UIButton // Dirty hack I know...
- (void)didMoveToWindow {
    %orig;
    if ([[self _viewControllerForAncestor] isKindOfClass:%c(ZBConsoleViewController)]) {
        self.backgroundColor = currentTint();
    }
}
%end

%hook UISwitch
- (void)layoutSubviews { // Not ideal
	%orig;
    [self setOnTintColor:currentTint()];
}
- (void)setOnTintColor:(UIColor *)arg1 {
    %orig(currentTint());
}
%end

%hook _UIBadgeView
- (void)setBadgeColor:(UIColor *)arg1 {
	if (tintBadge) {
		NSMutableDictionary *colorDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mtac.okapicolors.plist"];
        arg1 = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"appTintColor"] withFallback:@"#667FFA"];
    }
	%orig;
}
%end

%hook UITabBarButton
- (void)setFrame:(CGRect)arg1 {
	%orig;
}
%end

%hook UITabBarButtonLabel
- (void)setFrame:(CGRect)arg1 {
	if (hideTabLabels) {
		arg1 = CGRectMake(0, 0, 0, 0);
	}
	%orig;
}
%end

%hook UITableViewCell
- (void)didMoveToWindow {
    %orig;
    if ([[self _viewControllerForAncestor] isKindOfClass:%c(ZBHomeTableViewController)]) {
        if (hideHomeIcons) {
            MSHookIvar<UIImageView *>(self, "_imageView").hidden = YES;
        }   
    }
}
%end

%hook UITableViewCellContentView // Better to hook tableview datasource
- (void)setFrame:(CGRect)arg1 {
    if (([[self _viewControllerForAncestor] isKindOfClass:%c(ZBChangesTableViewController)] || [[self _viewControllerForAncestor] isKindOfClass:%c(ZBPackageListTableViewController)]) && hidePackageIcons) {
        arg1 = CGRectMake(arg1.origin.x - 60, arg1.origin.y, arg1.size.width + 60, arg1.size.height);
    }
    if ([[self _viewControllerForAncestor] isKindOfClass:%c(ZBHomeTableViewController)] && hideHomeIcons && [self.subviews count] > 1) {
        arg1 = CGRectMake(arg1.origin.x - 44, arg1.origin.y, arg1.size.width + 44, arg1.size.height);
    }
    if (([[self _viewControllerForAncestor] isKindOfClass:%c(ZBSourceListTableViewController)] 
    || [[self _viewControllerForAncestor] isKindOfClass:%c(ZBStoresListTableViewController)] 
    || [[self _viewControllerForAncestor] isKindOfClass:%c(ZBCommunitySourcesTableViewController)] 
    || [[self _viewControllerForAncestor] isKindOfClass:%c(ZBSourceListViewController)]) && hideSourceIcons) {
        arg1 = CGRectMake(arg1.origin.x - 44, arg1.origin.y, arg1.size.width + 44, arg1.size.height);
    }
    if ([[self _viewControllerForAncestor] isKindOfClass:%c(ZBQueueViewController)] && hidePackageIcons) {
        arg1 = CGRectMake(arg1.origin.x - 42, arg1.origin.y, arg1.size.width + 42, arg1.size.height);
    }
    %orig;
}
%end

%hook ZBSourceTableViewCell
- (void)awakeFromNib {
    %orig;
    if (hideSourceIcons) {
        self.iconImageView.hidden = YES;
    }
}
%end

%hook ZBHomeTableViewController
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (%orig != NULL && hideDeviceID) {
        return NULL;
    }
    return %orig;
}
%end 
%end

%group Beta
%hook _UISystemBackgroundView
- (void)didMoveToWindow {
    %orig;
    if ([[self _viewControllerForAncestor] isKindOfClass:%c(ZBPackageListViewController)]) 
        MSHookIvar<UIView *>(self, "_backgroundView").hidden = YES;
}
%end

%hook ZBSourceListViewController
- (void)layoutNavigationButtons {
    %orig;
    if (showSourceCount) {
        NSString *originalTitle = MSHookIvar<NSString *>(self.navigationItem, "_title");
        if (![self.navigationItem.title containsString:@" - "]) {
            self.navigationItem.title = [NSString stringWithFormat:@"%@ - %lu", originalTitle, [[[%c(ZBSourceManager) sharedInstance] sources] count]];
        }
    }
}
%end
%hook _UINavigationBarLargeTitleView
- (void)setTitle:(NSString *)arg1 {
    ZBTabBarController *tabBar = (ZBTabBarController *)((ZBAppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    if ([tabBar selectedIndex] == 3) {
        NSDictionary *allPackages = MSHookIvar<NSDictionary *>([%c(ZBPackageManager) sharedInstance], "_installedPackages");
        if (showPackageCount && ![arg1 containsString:@" - "]) {
            arg1 = [NSString stringWithFormat:@"%@ - %lu", arg1, [[allPackages allKeys] count]];
        }
    } 
    %orig;
}
%end

%hook ZBSourceTableViewCell
- (void)setStoreBadge:(UIImageView *)arg1 {
    arg1.image = [arg1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; // Force store badge color on Zebra 1.2-beta+
    arg1.tintColor = currentTint();
    %orig;
}
%end
%hook ZBBasePackage
- (void)setIconImageForImageView:(UIImageView *)imageView {
    if (hidePackageIcons) {
        return;
    } else {
        if (useCydiaIcons) {
            NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Applications/Cydia.app/Sections"];
            UIImage *iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:self.section ofType:@"png"]];
            if (iconImage) {
                imageView.image = iconImage;
            } else {
                imageView.image = [UIImage imageWithContentsOfFile:@"/Applications/Cydia.app/Sections/Tweaks.png"];
            }
        } else {
            %orig;
        }
    }
}
%end

%hook ZBMainSettingsTableViewController
- (void)viewDidLoad {
    %orig;

    UIButton *okapiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okapiButton.frame = CGRectMake(0,0,30,30);
    okapiButton.layer.cornerRadius = okapiButton.frame.size.height / 2;
    okapiButton.layer.masksToBounds = YES;
    [okapiButton setTitle:@"Okapi" forState:UIControlStateNormal];
    [okapiButton setTitleColor:currentTint() forState:UIControlStateNormal];
    [okapiButton addTarget:self action:@selector(okapi:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *okapiButtonItem = [[UIBarButtonItem alloc] initWithCustomView:okapiButton];
    self.navigationItem.leftBarButtonItems = @[okapiButtonItem];
}
%new
- (void)okapi:(id)sender {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/OkapiPrefs.bundle"];
    [bundle load];
	if ([bundle isLoaded]) {
        OkapiRootListController* okapiController = [%c(OkapiRootListController) new];
        UINavigationController* okapiNavigationController = [[UINavigationController alloc] initWithRootViewController:okapiController];
        [self presentViewController:okapiNavigationController animated:YES completion:nil];
    }
}
%end

%hook UINavigationBar
- (void)didMoveToWindow {
    %orig;
    self.tintColor = currentTint();
}
%end
%end

%group Stable
%hook _UINavigationBarLargeTitleView
- (void)setTitle:(NSString *)arg1 {
    ZBTabBarController *tabBar = (ZBTabBarController *)((ZBAppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    if ([tabBar selectedIndex] == 1) {
        if (showSourceCount && ![arg1 containsString:@" - "]) {
            NSMutableDictionary *sources = [[%c(ZBSourceManager) sharedInstance] sources];
            arg1 = [NSString stringWithFormat:@"%@ - %lu", arg1, [[sources allKeys] count]];
        } 
    } 
    %orig;
}
%end
%hook ZBPackageListTableViewController
- (void)layoutNavigationButtonsNormal {
    %orig;
    if (showPackageCount) {
        NSString *originalTitle = MSHookIvar<NSString *>(self.navigationItem, "_title");
        if (![self.navigationItem.title containsString:@" - "]) {
            self.navigationItem.title = [NSString stringWithFormat:@"%@ - %lu", originalTitle, [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/MobileSubstrate/DynamicLibraries" error:nil] count] / 2];
        }
    }
}
%end
%hook ZBPackage
- (void)setIconImageForImageView:(UIImageView *)imageView {
    if (hidePackageIcons) {
        return;
    } else {
        if (useCydiaIcons) {
            NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Applications/Cydia.app/Sections"];
            UIImage *iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:self.section ofType:@"png"]];
            if (iconImage) {
                imageView.image = iconImage;
            } else {
                imageView.image = [UIImage imageWithContentsOfFile:@"/Applications/Cydia.app/Sections/Tweaks.png"];
            }
        } else {
            %orig;
        }
    }
}
%end
%hook ZBSettingsTableViewController
- (void)viewDidLoad {
    %orig;

    UIButton *okapiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okapiButton.frame = CGRectMake(0,0,30,30);
    okapiButton.layer.cornerRadius = okapiButton.frame.size.height / 2;
    okapiButton.layer.masksToBounds = YES;
    [okapiButton setTitleColor:currentTint() forState:UIControlStateNormal];
    [okapiButton setTitle:@"Okapi" forState:UIControlStateNormal];
    [okapiButton addTarget:self action:@selector(okapi:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *okapiButtonItem = [[UIBarButtonItem alloc] initWithCustomView:okapiButton];
    self.navigationItem.leftBarButtonItems = @[okapiButtonItem];
}
%new
- (void)okapi:(id)sender {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/OkapiPrefs.bundle"];
    [bundle load];
	if ([bundle isLoaded]) {
        OkapiRootListController* okapiController = [%c(OkapiRootListController) new];
        UINavigationController* okapiNavigationController = [[UINavigationController alloc] initWithRootViewController:okapiController];
        [self presentViewController:okapiNavigationController animated:YES completion:nil];
    }
}
%end
%end

%group OkapiColors 
%hook ZBThemeManager
+ (UIColor *)getAccentColor:(ZBAccentColor)accentColor {
    if (useCustomTintColor) {
        NSMutableDictionary *colorDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mtac.okapicolors.plist"];
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"appTintColor"] withFallback:@"#667FFA"];
    }
    return %orig;
}
%end
%end

%group FloatingQueue
%hook ZBTabBarController
%property (strong, nonatomic) UIView *queueButton;
- (void)viewDidLoad {
    %orig;
    if (!self.queueButton) {
        NSMutableDictionary *colorDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mtac.okapicolors.plist"];
        self.queueButton = [[UIView alloc] init];
        self.queueButton.frame = CGRectMake(WIDTH - 70, getTabBarHeight(), 60, 60);
        self.queueButton.backgroundColor = [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"appTintColor"] withFallback:@"#667FFA"];
        self.queueButton.layer.cornerRadius = 30;
        self.queueButton.layer.masksToBounds = YES;
        self.queueButton.translatesAutoresizingMaskIntoConstraints = false;

        UIButton *openQueue = [UIButton buttonWithType:UIButtonTypeCustom];
        openQueue.frame = self.queueButton.bounds;
        openQueue.tintColor = [UIColor whiteColor];
        openQueue.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        openQueue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        openQueue.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [openQueue setImage:[UIImage systemImageNamed:@"arrow.down.circle.fill"] forState:UIControlStateNormal];
        [openQueue addTarget:self action:@selector(okapiOpenQueue:) forControlEvents:UIControlEventTouchUpInside];
        [self.queueButton addSubview:openQueue];

        [self.viewIfLoaded addSubview:self.queueButton];
        self.queueButton.hidden = YES;
    }
}
- (void)openQueue:(BOOL)openPopup {
    self.queueButton.hidden = NO;
    %orig;
}
%new
- (void)okapiOpenQueue:(id)sender {
    [self openQueue:YES];
}
%end

%hook LNPopupBar
- (void)didMoveToWindow {
    %orig;
    self.hidden = YES;
}
%end

%hook ZBQueue
- (void)clear {
    %orig;
    ZBTabBarController *tabBar = (ZBTabBarController *)((ZBAppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    tabBar.queueButton.hidden = YES;
}
%end
%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	RLog(@"[+] OKAPI DEBUG: Callback");
    
    NSNumber *enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:domain];
	enabled = (enabledValue) ? [enabledValue boolValue] : YES;
    NSNumber *useCustomTintColorValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useCustomTintColor" inDomain:domain];
    useCustomTintColor = (useCustomTintColorValue) ? [useCustomTintColorValue boolValue] : NO;
    NSNumber *hidePackageIconsValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hidePackageIcons" inDomain:domain];
    hidePackageIcons = (hidePackageIconsValue) ? [hidePackageIconsValue boolValue] : NO;
    NSNumber *showPackageVersionValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"showPackageVersion" inDomain:domain];
    showPackageVersion = (showPackageVersionValue) ? [showPackageVersionValue boolValue] : NO;
    NSNumber *hideHomeIconsValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideHomeIcons" inDomain:domain];
    hideHomeIcons = (hideHomeIconsValue) ? [hideHomeIconsValue boolValue] : NO;
    NSNumber *hideSourceIconsValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideSourceIcons" inDomain:domain];
    hideSourceIcons = (hideSourceIconsValue) ? [hideSourceIconsValue boolValue] : NO;
    NSNumber *showSourceCountValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"showSourceCount" inDomain:domain];
    showSourceCount = (showSourceCountValue) ? [showSourceCountValue boolValue] : NO;
    NSNumber *showPackageCountValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"showPackageCount" inDomain:domain];
    showPackageCount = (showPackageCountValue) ? [showPackageCountValue boolValue] : NO;
    NSNumber *hideDeviceIDValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideDeviceID" inDomain:domain];
    hideDeviceID = (hideDeviceIDValue) ? [hideDeviceIDValue boolValue] : NO;
    NSNumber *useFloatingQueueValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useFloatingQueue" inDomain:domain];
    useFloatingQueue = (useFloatingQueueValue) ? [useFloatingQueueValue boolValue] : NO;
    NSNumber *useCydiaIconsValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useCydiaIcons" inDomain:domain];
    useCydiaIcons = (useCydiaIconsValue) ? [useCydiaIconsValue boolValue] : NO;
    NSNumber *tintBadgeValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"tintBadge" inDomain:domain];
    tintBadge = (tintBadgeValue) ? [tintBadgeValue boolValue] : NO;
    NSNumber *hideTabLabelsValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideTabLabels" inDomain:domain];
    hideTabLabels = (hideTabLabelsValue) ? [hideTabLabelsValue boolValue] : NO;
    NSNumber *hideTableSeparatorsValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"hideTableSeparators" inDomain:domain];
    hideTableSeparators = (hideTableSeparatorsValue) ? [hideTableSeparatorsValue boolValue] : NO;
    NSNumber *useInsetCellsValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"useInsetCells" inDomain:domain];
    useInsetCells = (useInsetCellsValue) ? [useInsetCellsValue boolValue] : NO;
}

%ctor {
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)PostNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
    if (enabled) {
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *actualVersion = [info objectForKey:@"CFBundleShortVersionString"];
        NSString *requiredVersion = @"1.2~beta";
        if ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending) {
            %init(Stable);
        } else {
            %init(Beta);
        }
        %init(App);
        %init(OkapiColors);
        if (useFloatingQueue) {
            %init(FloatingQueue);
        }
    }
}
