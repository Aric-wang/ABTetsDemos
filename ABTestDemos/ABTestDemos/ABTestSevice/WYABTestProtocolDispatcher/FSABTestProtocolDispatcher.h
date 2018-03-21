//
//  FSABTestProtocolDispatcher.h
//  ABTestDemo
//
//  Created by wangyang on 2018/3/13.
//  Copyright © 2018年 com.gmfund.app. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GGABTestProtocolDispatcher(__protocol__,index,...)  \
    [FSABTestProtocolDispatcher dispatcherProtocol:@protocol(__protocol__)  \
                                withIndexImplemertor:index \
    toImplemertors:[NSArray arrayWithObjects:__VA_ARGS__, nil]]

@interface FSABTestProtocolDispatcher : NSObject


/** 协议分发器
 *  protocol 遵循的协议;
 *  indexImplemertor AB Test 需要执行的协议实现实例数组下标;
    若传入 对应的 NSNumber 数字, 则调用改实现实例的协议方法;
    若传入 nil,则调用全部的遵循协议的实现实例
 
 *  implemertors 所有需要遵循协议的实现实例;
 *  return 协议分发器;
 */

+ (id)dispatcherProtocol:(Protocol *)protocol
    withIndexImplemertor:(NSNumber *)indexImplemertor
          toImplemertors:(NSArray *)implemertors;





@end
