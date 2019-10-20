#import "Tweak.h"

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
BOOL betterexport;
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

%hook ZBFeaturedCollectionViewCell

- (void)viewDidLoad {

	%orig;

	UIImageView *featuredImageView = MSHookIvar<UIImageView *>(self, "_imageView");

	featuredImageView.hidden = YES;

}

%end

// Package & Repo Cells

%hook ZBPackageTableViewCell

- (void)layoutSubviews { // Sets package cells

	%orig;

	if (enabled && hideInstalledIcon) {

		UIImageView *installed = MSHookIvar<UIImageView *>(self, "_isInstalledImageView");

		installed.hidden = YES;

	}

	if (enabled && hidePaidIcon) {

		UIImageView *paid = MSHookIvar<UIImageView *>(self, "_isPaidImageView");

		paid.hidden = YES;

	}

	

}

- (void)updateData:(ZBPackage *)package {

	%orig;

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

	if (enabled && hideThemes) {

		if ([package.section containsString:@"Theme"]) {

			UIView *newContentView = MSHookIvar<UIView *>(self, "_contentView");

			newContentView.alpha = 0.1;

		}

	}

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

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.0.9"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}

- (void)toggleDarkMode:(id)arg1 {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.0.9"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}

%end

%hook ZBPackageListTableViewController

- (void)sharePackages {

	if (enabled && betterexport) {

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zebra" message:@"What do you want to export?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *packages = [UIAlertAction actionWithTitle:@"Packages" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

		[self exportPackages];
                        
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

- (void)exportPackages {

	NSArray *packages = [[[%c(ZBDatabaseManager) sharedInstance] installedPackages] copy];
	// NSArray *packages = [[self.databaseManager installedPackages] copy];
    NSMutableArray *packageIds = [NSMutableArray new];
    for (ZBPackage *package in packages) {
        if (package.identifier) {
            [packageIds addObject:package.identifier];
        }
    }
    if ([packageIds count]) {
        packageIds = [[packageIds sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        NSString *fullList = [packageIds componentsJoinedByString:@"\n"];
        NSArray *share = @[fullList];

		UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:share applicationActivities:nil];
        [self presentActivityController:controller];
        
    }

	
		
}

%new 

- (void)exportSources {

	NSString *lists = [@"/var/mobile/Library/Application Support/xyz.willy.Zebra" stringByAppendingPathComponent:@"sources.list"];

	NSURL *url = [NSURL fileURLWithPath:lists];

	UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [self presentActivityController:controller];

}

%end

// Search

%hook ZBSearchViewController

- (void)didDismissSearchController:(id)arg1 {

	%orig;

	if (enabled && hidesearches) {

		[self clearSearches];

	}

}

%end

// Console

%hook ZBConsoleViewController

- (void)updateCompleteButton {

    %orig;

	if (enabled && autorespring) {

		if (respringdelay > 0) {

			sleep(respringdelay);

		}

		[self.completeButton sendActionsForControlEvents:UIControlEventTouchUpInside];

	}

}

%end

// Queue

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

	UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:[%c(ZBQueue) sharedInstance] action:@selector(clearQueue)];

	longpress.minimumPressDuration = 1.0;

	[self addGestureRecognizer:longpress];

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

	[preferences registerFloat:&pcellframe default:0.0 forKey:@"pcellframe"];

	[preferences registerFloat:&respringdelay default:0.0 forKey:@"respringdelay"];

	[preferences registerBool:&autorespring default:YES forKey:@"autorespring"];

	[preferences registerBool:&hidesearches default:YES forKey:@"hidesearches"];

	[preferences registerBool:&confirmfaceid default:YES forKey:@"confirmfaceid"];

	[preferences registerBool:&useCydiaIcons default:YES forKey:@"useCydiaIcons"];

	[preferences registerBool:&hideThemes default:YES forKey:@"hideThemes"];

	[preferences registerBool:&useCommunityRepos default:YES forKey:@"useCommunityRepos"];

	[preferences registerBool:&betterexport default:YES forKey:@"betterexport"];

	loadColors();

	if (kCFCoreFoundationVersionNumber >= 1240.10) policy = LAPolicyDeviceOwnerAuthentication;
	else policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

	%init(Tweak);

}