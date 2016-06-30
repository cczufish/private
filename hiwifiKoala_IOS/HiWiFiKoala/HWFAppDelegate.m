//
//  HWFAppDelegate.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-12.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFAppDelegate.h"

//!!!: ft
#import "HWFService+User.h"
#import "HWFService+Router.h"

#import "AKSDeviceConsole.h"

#import "HWFNavigationController.h"
#import "HWFMasterViewController.h"

#import "HWFAudioPlayer.h"

#import <AFNetworking/AFNetworking.h>

@interface HWFAppDelegate ()

@property (strong, nonatomic) HWFNavigationController *navigationViewController;
@property (strong, nonatomic) HWFMasterViewController *masterViewController;

@end

@implementation HWFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self loadMainController];
    
    [self loadSettings];
    
    //!!!: ft
    [self TEST];
        
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadMainController
{
    self.masterViewController = [[HWFMasterViewController alloc] initWithNibName:@"HWFMasterViewController" bundle:nil];
    self.navigationViewController = [[HWFNavigationController alloc] initWithRootViewController:self.masterViewController];
    self.window.rootViewController = self.navigationViewController;
}

- (void)loadSettings
{
    // NavigationBar
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor navigationBarColor]];
    }
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
#ifdef GOD_MODE
    // Default Settings Bundle
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kSettingBundleSwitchTestingEnv:@(NO), kSettingBundleSwitchDeviceConsole:@(NO) }];
    
    // DeviceConsole
    if (IS_DEVICE_CONSOLE) {
        [AKSDeviceConsole startService];
    }
#else
    // Nothing.
#endif
    
    // 监听网络变化
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReachabilityStatusChange object:nil userInfo:@{ @"status":@(status) }];
    }];
    
    // DDLog
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // ColorConsole
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    UIColor *blueColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(255/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:blueColor backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
    UIColor *pinkColor = [UIColor colorWithRed:(255/255.0) green:(60/255.0) blue:(160/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:pinkColor backgroundColor:nil forFlag:LOG_FLAG_DEBUG];
    UIColor *greenColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(60/255.0) alpha:1.0];
    [[DDTTYLogger sharedInstance] setForegroundColor:greenColor backgroundColor:nil forFlag:LOG_FLAG_INFO];
    
    /*
     DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
     fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
     fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
     [DDLog addLogger:fileLogger];
     */
    
    // RemoteNotification
    NSNumber *remoteNotificationStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteNotificationStatus];
    if (!remoteNotificationStatus || [remoteNotificationStatus boolValue]) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) { // >= iOS 8.0
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else { // < iOS 8.0
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
        }
    }
}

//!!!: ft
- (void)TEST
{
    DDLogVerbose(@"HiWiFi Koala Verbose");
    DDLogDebug(@"HiWiFi Koala Debug");
    DDLogInfo(@"HiWiFi Koala Info");
    DDLogWarn(@"HiWiFi Koala Warn");
    DDLogError(@"HiWiFi Koala Error");
    
    DDLogInfo(@"SYSTEM LANGUAGE : %@", SYSTEM_LANGUAGE);
    
    DDLogDebug(@"DefaultUser In Cache : %@", [HWFUser defaultUser]);
    DDLogDebug(@"BindRouters In Cache : %@", [[HWFUser defaultUser] bindRouters]);
    DDLogDebug(@"DefaultRouter In Cache : %@", [HWFRouter defaultRouter]);
}

#pragma mark - AudioPlayer Control
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    HWFAudioPlayer *player = [HWFAudioPlayer defaultPlayer];
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if([player isPlaying]) {
                    [player pause];
                } else {
                    [player play];
                }
                break;
            case UIEventSubtypeRemoteControlPlay:
                [player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [player pause];
                break;
            case UIEventSubtypeRemoteControlStop:
                [player stop];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [player preve];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [player next];
                break;
            default:
                break;
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString *pToken = [NSMutableString string];
    unsigned char *codepos = (unsigned char *)[deviceToken bytes];
    int codelen = (int)[deviceToken length];
    for (int loopcode=0; loopcode < codelen;loopcode++) {
        [pToken appendFormat:@"%02x", codepos[loopcode]];
    }
    
    DDLogInfo(@"PushToken : %@", pToken);
    
    if (pToken) {
        [[NSUserDefaults standardUserDefaults] setObject:pToken forKey:kRemoteNotificationPushToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([HWFUser defaultUser] && [[HWFUser defaultUser] uToken]) {
            // 上报PushToken
            [[HWFService defaultService] uploadPushToken:pToken completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                // Nothing.
            }];
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    DDLogInfo(@"Register PushToken Failed");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
