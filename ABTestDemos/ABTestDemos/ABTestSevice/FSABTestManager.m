//
//  FSABTestService.m
//  ABTestDemo
//
//  Created by wangyang on 2018/3/14.
//  Copyright © 2018年 com.gmfund.app. All rights reserved.
//

#import "FSABTestManager.h"
//#import "AFNetManager.h"

@interface FSABTestManager ()

@property(nonatomic,strong) NSMutableDictionary *hightLevelkeyPathCache;
@property(nonatomic,strong) NSMutableDictionary *lowLevelkeyPathCache;
@property(nonatomic,strong) NSMutableDictionary *memoryCache;
@property(nonatomic,strong) NSMutableDictionary *diskCache;

@end

@implementation FSABTestManager

//  单例函数
static FSABTestManager *abTestManager = nil;
+ (instancetype)sharedABTestService
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        abTestManager = [[FSABTestManager alloc] init];
    });
    
    return abTestManager;
}

//  构造函数
- (instancetype)init
{
    self = [super init];
    if (self) {
        _hightLevelkeyPathCache = [[NSMutableDictionary alloc] init];
        _lowLevelkeyPathCache = [[NSMutableDictionary alloc] init];
        _memoryCache = [[NSMutableDictionary alloc] init];
        _diskCache = [[NSMutableDictionary alloc] initWithDictionary:[self getLocalDataABTestWithKey:FSABTestSeviceAllTest_Key]];
    }
    return self;
}

#pragma mark - 单例功能函数

//  获取远程的ABTest
- (void)fetchAllABTests:(NSString *)url parmas:(NSDictionary *)dictParmas successBlock:(void (^)(id dict))successBlock failBlock:(void (^)(NSError *error))failBlock
{
    if (url==nil || dictParmas==nil) {
        return;
    }
//    [[AFNetManager sharedAFNetWorkManager] requestWithType:BAHttpRequestTypePost withUrlString:url withParameters:dictParmas withSuccessBlock:^(id dict) {
//            successBlock(dict);
//
//    } withFailureBlock:^(NSError *error) {
//
//            failBlock(error);
//
//    } progress:nil isHubShow:YES];
}

// 获取本地 ABTest
- (NSDictionary *)getLocalDataABTestWithKey:(NSString *)abTestKey
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:abTestKey];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dict;
}

//存储 ABTest
- (void)saveLocalDataABTestWithKey:(NSString *)abTestKey withValue:(id)object
{
    NSDictionary *dict = (NSDictionary *)object;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:abTestKey];
}

- (void)setWithfStartKeyPath:(NSString *)keyPath
             LocalStorageKey:(NSString *)key
                       Level:(FSeviceABTestStoreLevel)level;
{
    [abTestManager.memoryCache setValue:[abTestManager.diskCache objectForKey:key] forKey:key];
    if (level == FSeviceABTest_HighLevel)
    {
        [abTestManager.hightLevelkeyPathCache setValue:keyPath forKey:key];
    }
    else
    {
        [abTestManager.lowLevelkeyPathCache setValue:keyPath forKey:key];
    }
    
}

//  获取策略
- (id)getStartABValueWithKey:(NSString *)strategyKey
{
    id value =  [abTestManager.memoryCache objectForKey:strategyKey];
    // 异常处理：ABTestUrl 接口没回来，但是去Low Level的 取了 key，提示优先级不对
    if (value == nil && [abTestManager.lowLevelkeyPathCache objectForKey:strategyKey])
    {
        id LocalData = [abTestManager.diskCache objectForKey:strategyKey];
#if (TEST == 1 || DEBUG)
        // 如果本地数据不为空，说明优先级错误，本地并没有删除
        if (LocalData != nil)
        {
            NSLog(@"FSABTestSevice 优先级不合适，请调整 key: %@ 的优先级");
        }
#endif
        value = LocalData;
    }
    return value;
}

- (void)updateLowLevelFlightStartABTestStoreValueWith:(FSABTestModelResult *)testModelResult
{
    [abTestManager.lowLevelkeyPathCache enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [abTestManager.memoryCache setValue:[self saveDiskCache:testModelResult keyPath:obj key:key] forKey:key];
    }];

    [abTestManager.hightLevelkeyPathCache enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self saveDiskCache:testModelResult keyPath:obj key:key];
    }];
    
    [self saveLocalDataABTestWithKey:FSABTestSeviceAllTest_Key withValue:abTestManager.diskCache];
}

- (id)saveDiskCache:(FSABTestModelResult *)abTestResult
            keyPath:(NSString *)keyPath
                key:(NSString *)key
{
#if (TEST == 1 || DEBUG)
    @try {
        id temp = [abTestResult valueForKeyPath:keyPath];
        [abTestManager.diskCache setObject:temp forKey:key];
        return temp;
    } @catch (NSException *exception) {
        
        NSLog(@"FSABTestModelResult 没有对应 keyPath。\n %@");
    }
    return nil;
#endif
    
    id temp = [abTestResult valueForKeyPath:keyPath];
    [abTestManager.diskCache setValue:temp forKey:key];
    return temp;
}

- (void)updateHighLevelFlightStartABTestStoreValue
{
    [abTestManager.hightLevelkeyPathCache enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [abTestManager.memoryCache setValue:[abTestManager.diskCache objectForKey:key] forKey:key];
    }];
}


@end

















