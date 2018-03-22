//
//  FSABTestService.h
//  ABTestDemo
//
//  Created by wangyang on 2018/3/14.
//  Copyright © 2018年 com.gmfund.app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSABTestModelResult.h"
#import "FABTestSeviceDef.h"

#define force_inline        __inline__ __attribute__((always_inline))
#define strKeyPath(x)       #x
#define middlewareOne(x)    [NSString stringWithFormat:@"%s|%@",strKeyPath(x),x]
#define middlewareTwo(x)    [[middlewareOne(x) componentsSeparatedByString:@"|"] objectAtIndex:0]
static force_inline NSArray * middlewareThree(NSString *string)
{
    NSMutableArray *temp = [string componentsSeparatedByString:@"."].mutableCopy;
    [temp removeObjectAtIndex:0];
    return temp;
}

#define keyPath(x)          [middlewareThree(middlewareTwo(x)) componentsJoinedByString:@"."]
/**
 策略存储优先级
 */
typedef NS_ENUM(NSUInteger, FSeviceABTestStoreLevel)
{
    FSeviceABTest_HighLevel = 0, // 高优先级 = ABTestUrl 接口回来之前
    FSeviceABTest_LowLevel = 1,  // 低优先级 = ABTestUrl 接口回来之后
};

/**
 Final 类，不可被继承
 */
__attribute__((objc_subclassing_restricted))

/**
 *  AB Test 类，解决基于该接口的时效性和规范性问题
 */
@interface FSABTestManager : NSObject

/**
 FSABTestManager 单例对象 
 */
+ (instancetype)sharedABTestService;

/**
 获取远程所有AB Test
 
 @param url  :  链接地址
 @param dictParmas   参数字典
 @param successBlock  成功回调
 @param failBlock   失败回调
 */
- (void)fetchAllABTests:(NSString *)url parmas:(NSDictionary *)dictParmas successBlock:(void (^)(id dict))successBlock failBlock:(void (^)(NSError *error))failBlock;

//===========================================================================//
/**
 设置 策略
 @param keyPath :   请使用👆上面的keyPath宏获取keyPath，直接点语法调用即可
 @param key     :   A/B 策略key，用于进行本地存储
 @param level   :   策略等级
 */
- (void)setWithfStartKeyPath:(NSString *)keyPath
             LocalStorageKey:(NSString *)key
                       Level:(FSeviceABTestStoreLevel)level;

/**
 得到 对应的策略值, 该方法考虑了不同环境的时的策略
 
 @param key     :   Strategy key
 @return        :   Strategy object 可能为nil,外部调用需增加判断
 */
- (id)getStartABValueWithKey:(NSString *)key;

/**
 更新 低优先级的存储AB策略, SeviceABTest_Url 接口回调时调用

 @param testModelResult SeviceABTest_Url 接口回调参数
 */
- (void)updateLowLevelFlightStartABTestStoreValueWith:(FSABTestModelResult *)testModelResult;

/**
 更新 高优先级的存储AB策略,VC dealloc 调用
 */
- (void)updateHighLevelFlightStartABTestStoreValue;


@end
















