#import "Tweak.h"
#include <signal.h>

%hook SBUIAppIconForceTouchControllerDataProvider
	
- (NSArray *)applicationShortcutItems {

	if ([[self applicationBundleIdentifier] isEqualToString:@"xyz.willy.Zebra"]) {
		
		NSMutableArray *orig = [%orig mutableCopy];

		if (!orig) {

			orig = [NSMutableArray new];

		} 

		SBSApplicationShortcutItem *item = [[%c(SBSApplicationShortcutItem) alloc] init];

		item.localizedTitle = @"Refresh Repos";

		item.localizedSubtitle = nil;

		item.type = @"refresh";

		item.bundleIdentifierToLaunch = [self applicationBundleIdentifier];

		[orig addObject:item];

		return orig;

	}

	return %orig;

}
	
%end

%hook SBUIAction
	
- (id)initWithTitle:(id)title subtitle:(id)arg2 image:(id)image badgeView:(id)arg4 handler:(id)arg5 {

	if ([title containsString:@"Refresh Repos"]) {

		image = [[UIImage imageWithContentsOfFile:@"/Library/MobileSubstrate/DynamicLibraries/com.mtac.okapi.bundle/shuffle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

		// image = [UIImage imageWithContentsOfFile:@"/Library/MobileSubstrate/DynamicLibraries/com.mtac.okapi.bundle/shuffle.png"];

	}

	return %orig;

}
	
%end