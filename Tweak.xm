#import "Tweak.h"

#define zebraBlue [UIColor colorWithRed:107/255.0f green:127/255.0f blue:242/255.0f alpha:1.0f]
#define LocalizedString(string) [NSBundle.mainBundle localizedStringForKey:string value:string table:nil]
#define rootViewController [[[[UIApplication sharedApplication] delegate] window] rootViewController]

HBPreferences *preferences;
BOOL enabled;
BOOL hideTabBarLabels;
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
BOOL betterexport;
BOOL darkRefresh;
BOOL showPackageNumber;
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

%group Tweak

// Refresh View

%hook ZBRefreshViewController

- (void)viewDidLoad {

	%orig;

	if (enabled && darkRefresh) {

		self.view.backgroundColor = [UIColor blackColor];

		UITextView *consoleTextView = MSHookIvar<UITextView *>(self, "_consoleView");

		consoleTextView.backgroundColor = [UIColor blackColor];

	}

}

%end

// Tab Bar Icon labels and position

%hook UITabBar

- (void)setFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.tintColor = color;

	}

}

%end

// Navigation Bar Tint Colors

%hook UINavigationBar

- (void)setFrame:(CGRect)arg1 {

	%orig; 

	if (enabled && ctintcolor) { 

		UIColor *color = ctintcolorhex;

		self.tintColor = color;

	}

}

%end

// Global app progress view tint color

%hook UIProgressView

- (void)setFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.progressTintColor = color;

	}

}

%end

// Install view tint button color

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

// Table view side alphabet index tint color

%hook UITableViewIndex

- (id)initWithFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		UIColor *color = ctintcolorhex;

		self.interactionTintColor = color;

	}

	return %orig;

}

- (BOOL)canBecomeFocused {

	return true;

}

%end

// Package & Repo Cells

%hook ZBPackageTableViewCell

NSString *currentSection = nil;

- (void)updateData:(ZBPackage *)package {

	%orig;

	NSLog(@"%@", [@"OKAPI:" stringByAppendingString:package.sectionImageName]);

	if (enabled && useCydiaIcons) {

		NSString *sectionString = package.section;

		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.mtac.okapi.bundle"];

		UIImage *iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:sectionString ofType:@"png"]];

		UIImageView *packageCellImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		UIImage *staticIconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Tweaks" ofType:@"png"]];

		if (iconImage != nil) {

			packageCellImageView.image = iconImage;

			//[self imageView];

		} else {

			//UIImageView *packageCellImageView = MSHookIvar<UIImageView *>(self, "_imageView");

			packageCellImageView.image = staticIconImage;

			//[self imageView];

		}

	}

}

- (UIImageView *)imageView {

	NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.mtac.okapi.bundle"];

	UIImage *iconImage = nil;

	if (currentSection != nil) {

		iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:currentSection ofType:@"png"]];

	} else {

		iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Tweaks" ofType:@"png"]];

	}

	UIImageView *imageCellView = [[UIImageView alloc] initWithImage:iconImage];

	//UIImage *staticIconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Tweaks" ofType:@"png"]];

	if (enabled && useCydiaIcons) {
	
		return imageCellView;

	}

	return %orig;

}

- (id)image {

	NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.mtac.okapi.bundle"];

	UIImage *iconImage = nil;
	
	if (currentSection != nil) {

		iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:currentSection ofType:@"png"]];

	} else {

		iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Tweaks" ofType:@"png"]];

	}

	if (enabled && useCydiaIcons) {

		return iconImage;

	}

	return %orig;

}

%end

// Community Repos

%hook ZBCommunityReposTableViewController

- (void)fetchRepoJSON {
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

				// NSArray *newCommunityRepos = MSHookIvar<NSArray *>(self, "_communityRepos");

				self.communityRepos = json[@"repos"];
            	
            }
              // self->changeLogArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self.tableView reloadData];
              });
          }
          if (error){
              NSLog(@"[Zebra] Github error %@", error);
          }
      }] resume];
    
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

// Tab bar icon spacing

%hook UITabBarButton

- (void)layoutSubviews {

	%orig;

	if (enabled && hideTabBarLabels) {

		NSString *deviceType = [[UIDevice currentDevice] model];

		if (![deviceType containsString:@"iPad"]) {

			CGPoint newCenter = self.center;

    		newCenter.y = 30;

    		self.center = newCenter;

		} 

	}

}

%end

// Homepage cell icons

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

// Badge tint color

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

// Clear separators

%hook UITableView
	
- (void)layoutSubviews {
	
	%orig;

	if (enabled && noSeparators) {

		self.separatorColor = [UIColor clearColor];

	}
	
}
	
%end

// Set Okapi build number at footer of Home view

%hook ZBHomeTableViewController

/* - (void)viewDidLoad {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.1.2"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

} */

/* - (void)toggleDarkMode:(id)arg1 {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.1.2"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

} */

- (void)configureFooter {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.1.3"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}

/* - (void)viewWillAppear:(_Bool)arg1 {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.1.2"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

} */

%end

// Featured package cells 

%hook ZBFeaturedCollectionViewCell

- (void)awakeFromNib {

	%orig;

	NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.mtac.okapi.bundle"];

	UIImageView *newImageView = MSHookIvar<UIImageView *>(self, "_imageView");

	UIImage *iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Tweaks" ofType:@"png"]];

	newImageView.image = iconImage;

}

%end

// # of packages title

%hook _UINavigationBarLargeTitleView

- (void)setTitle:(NSString *)arg1 {

	/* ZBTabBarController *tabBarController = [[%c(ZBTabBarController) alloc] init];

	UITabBar *tabBar = MSHookIvar<UITabBar *>(tabBarController, "_tabBar");

	UITabBarItem *selectedBarItem = MSHookIvar<UITabBarItem *>(tabBar, "_selectedItem");

	NSArray *tabBarItems = MSHookIvar<NSArray *>(tabBar, "_items");

	if (selectedBarItem == tabBarItems[4]) {

		NSMutableArray *newInstalledPackagesList = [[%c(ZBDatabaseManager) sharedInstance] installedPackages:YES];

		int packages = [newInstalledPackagesList count];

		%orig([NSString stringWithFormat:@"%d", packages]);

	} else {

		%orig;

	} */

	if (enabled && showPackageNumber) {

		if ([arg1 isEqualToString:NSLocalizedString(@"Packages", @"")]) {

			NSMutableArray *newInstalledPackagesList = [[%c(ZBDatabaseManager) sharedInstance] installedPackages:YES];

			int packages = [newInstalledPackagesList count];

			%orig([[[NSString stringWithFormat:@"%d", packages] stringByAppendingString:@" "] stringByAppendingString:NSLocalizedString(@"Packages", @"")]);

		} 

	} else {

		%orig;

	}

}

%end

// Better exportation of sources and packages

%hook ZBPackageListTableViewController

- (void)sharePackages {

	if (enabled && betterexport) {

		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zebra" message:@"What do you want to export?" preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *packages = [UIAlertAction actionWithTitle:@"Packages" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

			// [self exportPackages];

			%orig;
                        
    	}];

		UIAlertAction *sources = [UIAlertAction actionWithTitle:@"Sources" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
			[self exportSources];

    	}];

		UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[alert addAction:cancel];
		[alert addAction:packages];
		[alert addAction:sources];
		[self presentViewController:alert animated:YES completion:nil];

	}

	%orig;

}

%new 

- (void)exportSources {

	NSString *lists = [@"/var/mobile/Library/Application Support/xyz.willy.Zebra" stringByAppendingPathComponent:@"sources.list"];

	NSURL *url = [NSURL fileURLWithPath:lists];

	UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [self presentActivityController:controller];

}

%end

// Clear search history

%hook ZBSearchViewController

- (void)didDismissSearchController:(id)arg1 {

	%orig;

	if (enabled && hidesearches) {

		[self clearSearches];

	}

}

%end

// Auto respring

%hook ZBConsoleViewController

- (void)updateCompleteButton {

    %orig;

	if (enabled && autorespring) {

		[self.completeButton sendActionsForControlEvents:UIControlEventTouchUpInside];

	}

}

%end

// Redesigned queue  

%hook ZBQueueViewController 

- (void)confirm:(id)arg1 {

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

							%orig;

						});
					}
				}
			];
		}

	} else {

		%orig;

	}

}

%end

/* %hook LNPopupBar

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

%end */

%end

// Load colors from libcolorpicker cells in preferences

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

	[preferences registerBool:&tintBadges default:YES forKey:@"tintBadges"];

	[preferences registerBool:&noSeparators default:NO forKey:@"tintBadges"];

	[preferences registerBool:&hidePaidIcon default:NO forKey:@"hidePaidIcon"];

	[preferences registerBool:&hideInstalledIcon default:NO forKey:@"hideInstalledIcon"];

	[preferences registerBool:&hidePackageIcons default:YES forKey:@"hidePackageIcons"];

	[preferences registerBool:&homecells default:YES forKey:@"homecells"];

	[preferences registerBool:&redesignedQueue default:YES forKey:@"redesignedQueue"];

	[preferences registerBool:&ctintcolor default:YES forKey:@"ctintcolor"];

	[preferences registerObject:&ctintcolorhex default:nil forKey:@"ctintcolorhex"];

	[preferences registerFloat:&pcellframe default:0.0 forKey:@"pcellframe"];

	[preferences registerFloat:&respringdelay default:0.0 forKey:@"respringdelay"];

	[preferences registerBool:&autorespring default:NO forKey:@"autorespring"];

	[preferences registerBool:&hidesearches default:YES forKey:@"hidesearches"];

	[preferences registerBool:&confirmfaceid default:YES forKey:@"confirmfaceid"];

	[preferences registerBool:&useCydiaIcons default:YES forKey:@"useCydiaIcons"];

	[preferences registerBool:&hideThemes default:NO forKey:@"hideThemes"];

	[preferences registerBool:&useCommunityRepos default:YES forKey:@"useCommunityRepos"];

	[preferences registerBool:&betterexport default:YES forKey:@"betterexport"];

	[preferences registerBool:&darkRefresh default:NO forKey:@"darkRefresh"];
	
	[preferences registerBool:&showPackageNumber default:NO forKey:@"showPackageNumber"];

	loadColors();

	if (kCFCoreFoundationVersionNumber >= 1240.10) policy = LAPolicyDeviceOwnerAuthentication;
	else policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

	%init(Tweak);

}