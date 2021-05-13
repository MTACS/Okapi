#include "OkapiRootListController.h"

@import SafariServices;

UIColor *currentTint() {
	NSMutableDictionary *colorDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.mtac.okapicolors.plist"];
	return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"appTintColor"] withFallback:@"#667FFA"];
}

@implementation OkapiRootListController
- (void)viewDidLoad {
	[super viewDidLoad];

	UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(apply)];
	[applyButton setTintColor:currentTint()];
	self.navigationItem.rightBarButtonItem = applyButton;

	UIButton *info = [UIButton buttonWithType:UIButtonTypeCustom];
    info.frame = CGRectMake(0,0,30,30);
    info.layer.cornerRadius = info.frame.size.height / 2;
    info.layer.masksToBounds = YES;
	[info setTintColor:currentTint()];
    [info setImage:[UIImage systemImageNamed:@"info.circle"] forState:UIControlStateNormal];
    [info addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:info];
    self.navigationItem.leftBarButtonItems = @[infoButton];

	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,175)];
	self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,175)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/OkapiPrefs.bundle/logo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	self.headerImageView.tintColor = currentTint();

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];
	_table.tableHeaderView = self.headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.tableHeaderView = self.headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
- (void)info:(id)sender {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Okapi 2.0" message:@"2021 © MTAC" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *sourceCode = [UIAlertAction actionWithTitle:@"View Source Code" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		[[NSBundle bundleWithPath:@"/System/Library/Frameworks/SafariServices.framework"] load];
		if ([SFSafariViewController class] != nil) {
			SFSafariViewController *safariView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/MTACS/Okapi"]];
			if ([safariView respondsToSelector:@selector(setPreferredControlTintColor:)]) {
				safariView.preferredControlTintColor = currentTint();
			}
			[self.navigationController presentViewController:safariView animated:YES completion:nil];
		} else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/MTACS/Okapi"]];
		}
	}];
	UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:nil];
	[alert addAction:sourceCode];	
	[alert addAction:dismiss];	
	[self presentViewController:alert animated:YES completion:nil];
}
- (void)apply {
	UIApplication *app = [UIApplication sharedApplication];
	[app performSelector:@selector(suspend)];
	[NSThread sleepForTimeInterval:1.0];
	exit(0);
}
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiColorsListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Colors" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiPackageOptionsListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"PackageOptions" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiHomeListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Home" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiSourceListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Sources" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiTabBarListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Tabbar" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiPackageListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Packages" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiQueueListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Queue" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiTableListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"TableViews" target:self];
	}
	return _specifiers;
}
@end

@implementation OkapiSwitchCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
	if (self) {
		[((UISwitch *)[self control]) setOnTintColor:currentTint()];
		self.detailTextLabel.text = specifier.properties[@"subtitle"] ?: @"";
		self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
		self.detailTextLabel.textColor = currentTint();

		if ([specifier.properties[@"id"] isEqualToString:@"shouldEnable"] && ![[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
			[self setCellEnabled:NO];
		}
	}
	return self;
}
@end