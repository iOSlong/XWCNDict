//
//  AppDelegate.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/3.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "AppDelegate.h"
#import "XWTabBarViewController.h"
#import "XWNavigationViewController.h"
#import "XWCharactersViewController.h"
#import "XWRadicalViewController.h"
#import "XWPhoneticViewController.h"
#import "XWCollectionViewController.h"
#import "XWPoemViewController.h"
#import "XWYizijingViewController.h"
#import "XWNotebookViewController.h"
#import "XWNotebookViewController.h"
#import "XWGameViewController.h"

#import "RadicalPinyinDict.h"
#import "PlistReader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self configureViewControllers];

    [self configureLoadingData];

    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }


    NSLog(@"hello %d",100);


    return YES;
}

- (void)configureLoadingData {
    RadicalPinyinDict *_RPD = [RadicalPinyinDict shareRadicalPinyinDict];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PlistReader *_PR = [PlistReader sharePlistReader];
        _RPD.radicalRootDict = [_PR getRootDictOfRadical];
        _RPD.radicalRootKeys = [_PR getRootkeysOfRadical];
        _RPD.pinyinRootDict = [_PR getRootDictOfPinyin];
        _RPD.pinyinRootKeys = [_PR getRootkeysOfPinyin];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"获取数据完毕！\n");
        });
    });

}

- (void)configureViewControllers{


    XWCharactersViewController *charactersVC = [[XWCharactersViewController alloc] init];
    XWRadicalViewController *radicalVC = [[XWRadicalViewController alloc] init];
    XWPhoneticViewController *phoneticVC = [[XWPhoneticViewController alloc] init];
    XWCollectionViewController *collectionVC = [[XWCollectionViewController alloc] init];
    XWPoemViewController *poemVC = [[XWPoemViewController alloc] init];
    XWYizijingViewController *yizijingVC = [[XWYizijingViewController alloc] init];
    XWNotebookViewController *notebookVC = [[XWNotebookViewController alloc] init];
    XWGameViewController *gameVC = [[XWGameViewController alloc] init];


    XWNavigationViewController *navCharacters = [[XWNavigationViewController alloc] initWithRootViewController:charactersVC];
    XWNavigationViewController *navRadical = [[XWNavigationViewController alloc] initWithRootViewController:radicalVC];
    XWNavigationViewController *navPhonetic = [[XWNavigationViewController alloc] initWithRootViewController:phoneticVC];
    XWNavigationViewController *navCollection = [[XWNavigationViewController alloc] initWithRootViewController:collectionVC];
    XWNavigationViewController *navPoem = [[XWNavigationViewController alloc] initWithRootViewController:poemVC];
    XWNavigationViewController *navYizijing = [[XWNavigationViewController alloc] initWithRootViewController:yizijingVC];
    XWNavigationViewController *navNotebook = [[XWNavigationViewController alloc] initWithRootViewController:notebookVC];
    XWNavigationViewController *navGame = [[XWNavigationViewController alloc] initWithRootViewController:gameVC];


    collectionVC.title = @"collection";
    collectionVC.view.backgroundColor = [UIColor yellowColor];

    XWTabBarViewController *rootTab = [[XWTabBarViewController alloc] init];
    rootTab.imgBackground = [UIImage imageNamed:@"navbackground"];
    rootTab.viewControllers = @[navCharacters,navRadical,navPhonetic,navCollection,navPoem,navYizijing,navNotebook,navGame];
    self.window.rootViewController = rootTab;

    [self.window makeKeyAndVisible];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
