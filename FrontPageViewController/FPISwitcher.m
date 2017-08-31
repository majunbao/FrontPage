//
//  FPISwitcher.m
//  FrontPageViewController
//
//  Created by Edward Winget on 6/4/17.
//  Copyright © 2017 junesiphone. All rights reserved.
//

#import "FPISwitcher.h"
#import <objc/runtime.h>


@interface FPISwitcher ()

@end

@interface SBAppSwitcherModel
+ (id)sharedInstance;
- (id)mainSwitcherDisplayItems;
- (id)snapshot;
-(id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
@end

@interface SBApplication
- (id)displayName;
- (id)bundleIdentifier;
- (id)displayIdentifier;
- (_Bool)isWebApplication;
- (_Bool)isInternalApplication;
- (_Bool)isSystemProvisioningApplication;
- (_Bool)isSystemApplication;
- (_Bool)isSpringBoard;
- (id)_appInfo;
-(int)dataUsage;
- (id)applicationWithBundleIdentifier:(id)arg1;
- (void)uninstallApplication:(id)arg1;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)allApplications;
- (id)applicationWithBundleIdentifier:(id)arg1;

@end

@implementation FPISwitcher

#define deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

+(NSMutableDictionary *)switcherInfo{
    NSMutableDictionary *switcherInfo = [[NSMutableDictionary alloc] init];
    NSMutableArray *switcherArray = [[NSMutableArray alloc] init];
    
    NSArray *switcherApps;
    if(deviceVersion < 9.0){
        switcherApps = [[objc_getClass("SBAppSwitcherModel") sharedInstance] snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary];
    }

    if(deviceVersion >= 9.0){
        switcherApps = [[objc_getClass("SBAppSwitcherModel") sharedInstance] mainSwitcherDisplayItems];
    }
    
    
    if(deviceVersion < 9.0){
        for (NSString* currentString in switcherApps){
            SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:currentString];
            NSString *bundle = app.displayIdentifier;
            [switcherArray addObject:bundle];
        }
        
    }else{
        for (SBApplication *app in switcherApps) {
            NSString *bundle = app.displayIdentifier;
            [switcherArray addObject:bundle];
        }
    }
    
    [switcherInfo setValue:switcherArray forKey:@"bundles"];
    switcherArray = nil;
    switcherApps = nil;
    return switcherInfo;
}
@end
