#import "Tweak.h"

#define zebraBlue [UIColor colorWithRed:107/255.0f green:127/255.0f blue:242/255.0f alpha:1.0f]
#define LocalizedString(string) [NSBundle.mainBundle localizedStringForKey:string value:string table:nil]
#define rootViewController [[[[UIApplication sharedApplication] delegate] window] rootViewController]

HBPreferences *preferences;
BOOL enabled;
BOOL hideTabBarLabels;
BOOL tintBadges;
BOOL noSeparators;
BOOL homecells;
BOOL ctintcolor;
BOOL autorespring;
BOOL hidesearches;
BOOL confirmfaceid;
BOOL useCydiaIcons;
BOOL useCommunityRepos;
BOOL betterexport;
BOOL tintRefreshControl;
UIColor *ctintcolorhex = nil;
CGFloat pcellframe;
CGFloat respringdelay;
//LAPolicy policy;
NSArray *moreRepos;

enum ZBSourcesOrder {
    ZBTransfer,
    ZBJailbreakRepo,
    ZBCommunity,
	ZBMore
};

%group Tweak

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

// Set refresh control color

%hook UIRefreshControl

- (UIColor *)tintColor {

	if (enabled && tintRefreshControl) {

		return ctintcolorhex;
	
	} else {

		return %orig;

	}

}

%end

// Global app progress view tint color

%hook UIProgressView

- (void)setFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		// UIColor *color = ctintcolorhex;

		self.progressTintColor = ctintcolorhex;

	}

}

%end

// Install view tint button color

%hook ZBConsoleViewController

- (void)viewDidLoad {

	%orig;

	if (enabled && ctintcolor) {

		// UIColor *color = ctintcolorhex;

		UIButton *finishButton = MSHookIvar<UIButton *>(self, "_completeButton");

		finishButton.backgroundColor = ctintcolorhex;

	}

}

%end

// Table view side alphabet index tint color

%hook UITableViewIndex

- (id)initWithFrame:(CGRect)arg1 {

	%orig;

	if (enabled && ctintcolor) {

		// UIColor *color = ctintcolorhex;

		self.interactionTintColor = ctintcolorhex;

	}

	return %orig;

}

%end

// Package & Repo Cells

%hook ZBPackageTableViewCell

NSString *currentSection = nil;

- (void)updateData:(ZBPackage *)package {

	%orig;

	if (enabled && useCydiaIcons) {

		NSString *sectionString = package.section;

		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Applications/Cydia.app/Sections"];

		UIImage *iconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:sectionString ofType:@"png"]];

		UIImageView *packageCellImageView = MSHookIvar<UIImageView *>(self, "_iconImageView");

		UIImage *staticIconImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Tweaks" ofType:@"png"]];

		if (iconImage != nil) {

			packageCellImageView.image = iconImage;

		} else {

			packageCellImageView.image = staticIconImage;

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

				self.communityRepos = json[@"repos"];
            	
            } dispatch_async(dispatch_get_main_queue(), ^{
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

		// return NULL;

		return nil;

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

			// UIColor *color = ctintcolorhex;

			self.backgroundColor = ctintcolorhex;

		} else {

			self.backgroundColor = [UIColor tintColor];

		}

	}

}

%end

// Clear separators

%hook UITableViewCell
	
- (void)setSeparatorColor:(id)arg1 {

	if (enabled && noSeparators) {

		%orig([UIColor clearColor]);

	}

}
	
%end

// Set Okapi build number at footer of Home view

%hook ZBHomeTableViewController

- (void)configureFooter {

	%orig;

	UILabel *newLabel = MSHookIvar<UILabel *>(self, "_udidLabel");

	NSString *uniqueid = MSHookIvar<UILabel *>(self, "_udidLabel").text;

	uniqueid = [uniqueid stringByAppendingString:[NSString stringWithFormat:@"\r%@", @"Okapi 1.1.5"]];

	newLabel.numberOfLines = 2;

	newLabel.text = uniqueid;

}

%end

// Better exportation of sources and packages

%hook ZBPackageListTableViewController

- (void)sharePackages {

	if (enabled && betterexport) {

		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zebra" message:@"What do you want to export?" preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *packages = [UIAlertAction actionWithTitle:@"Packages" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

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

/* - (void)didDismissSearchController:(id)arg1 {

	%orig;

	if (enabled && hidesearches) {

		[self clearSearches];

	}

} */

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
	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	[preferences registerBool:&hideTabBarLabels default:NO forKey:@"hideTabBarLabels"]; 
	[preferences registerBool:&tintBadges default:NO forKey:@"tintBadges"];
	[preferences registerBool:&noSeparators default:NO forKey:@"tintBadges"];
	//[preferences registerBool:&hidePaidIcon default:NO forKey:@"hidePaidIcon"];
	//[preferences registerBool:&hideInstalledIcon default:NO forKey:@"hideInstalledIcon"];
	//[preferences registerBool:&hidePackageIcons default:YES forKey:@"hidePackageIcons"];
	[preferences registerBool:&homecells default:NO forKey:@"homecells"];
	// [preferences registerBool:&redesignedQueue default:YES forKey:@"redesignedQueue"];
	[preferences registerBool:&ctintcolor default:NO forKey:@"ctintcolor"];
	[preferences registerObject:&ctintcolorhex default:nil forKey:@"ctintcolorhex"];
	[preferences registerFloat:&pcellframe default:0.0 forKey:@"pcellframe"];
	//[preferences registerFloat:&respringdelay default:0.0 forKey:@"respringdelay"];
	[preferences registerBool:&autorespring default:NO forKey:@"autorespring"];
	[preferences registerBool:&hidesearches default:NO forKey:@"hidesearches"];
	//[preferences registerBool:&confirmfaceid default:YES forKey:@"confirmfaceid"];
	[preferences registerBool:&useCydiaIcons default:NO forKey:@"useCydiaIcons"];
	[preferences registerBool:&useCommunityRepos default:NO forKey:@"useCommunityRepos"];
	[preferences registerBool:&betterexport default:NO forKey:@"betterexport"];
	[preferences registerBool:&tintRefreshControl default:NO forKey:@"tintRefreshControl"];

	loadColors();

	//if (kCFCoreFoundationVersionNumber >= 1240.10) policy = LAPolicyDeviceOwnerAuthentication;
	//else policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

	%init(Tweak);

}