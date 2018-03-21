//
//  AppDelegate.m
//  ABTestDemos
//
//  Created by wangyang on 2018/3/21.
//  Copyright © 2018年 com.gmfund.app. All rights reserved.
//

#import "AppDelegate.h"
#import "FSABTestManager.h"
#import "FABTestSeviceDef.h"

// AB Test
#define FundAbTestKeyO @"FundAbTestKey"
#define FundAbTestKeyT @"FundAbTestKeyT"
#define FundAbTestKeyThree @"FundAbTestKeyThree"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // ABTest
    [self setABTest];
    
    return YES;
}

- (void)setABTest
{
    // 设置 AB Test 策略
    FSABTestModelResult *modelResult = [[FSABTestModelResult alloc] init];
    [[FSABTestManager sharedABTestService] setWithfStartKeyPath:keyPath(modelResult.oneABTest) LocalStorageKey:FundAbTestKeyO Level:FSeviceABTest_HighLevel];
    [[FSABTestManager sharedABTestService] setWithfStartKeyPath:keyPath(modelResult.abtestExtparams.twoABTest) LocalStorageKey:FundAbTestKeyT Level:FSeviceABTest_HighLevel];
    [[FSABTestManager sharedABTestService] setWithfStartKeyPath:keyPath(modelResult.abtestExtparams.fundDetailRnAbtest.testStrategy) LocalStorageKey:FundAbTestKeyThree Level:FSeviceABTest_LowLevel];
    
    [[FSABTestManager sharedABTestService] updateHighLevelFlightStartABTestStoreValue];
    
    [[FSABTestManager sharedABTestService] updateLowLevelFlightStartABTestStoreValueWith:modelResult];
    
    // 请求AB Test 策略
    [[FSABTestManager sharedABTestService] fetchAllABTests:nil parmas:nil successBlock:^(id dict) {
        
//        FSABTestModelResult *resultModel = [FSABTestModelResult yy_modelWithDictionary:dict];
//        //更新AB Test
//        [[FSABTestManager sharedABTestService] updateLowLevelFlightStartABTestStoreValueWith:resultModel];
        
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
