//
//  FSABTestProtocolDispatcher.m
//  ABTestDemo
//
//  Created by wangyang on 2018/3/13.
//  Copyright © 2018年 com.gmfund.app. All rights reserved.
//

#import "FSABTestProtocolDispatcher.h"
#import <objc/runtime.h>

@interface ImplemertorContext : NSObject
@property (nonatomic,weak) id implemertor;
@end

@implementation ImplemertorContext
@end

@interface FSABTestProtocolDispatcher ()

@property (nonatomic, strong) Protocol *prococol;
@property (nonatomic, strong) NSNumber *indexImplemertor;
@property (nonatomic, strong) NSArray *implemertorArray;

@end

@implementation FSABTestProtocolDispatcher

- (instancetype)initWithProtocol:(Protocol *)protocol withIndexImplemertor:(NSNumber *)indexImplemertor toImplemertors:(NSArray *)implemertors
{
    self = [super init];
    if (self) {
        
        self.prococol = protocol;
        self.indexImplemertor = indexImplemertor;
        NSMutableArray *implemertorContextArray = [NSMutableArray arrayWithCapacity:implemertors.count];
        [implemertors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            ImplemertorContext *implemertorContext = [[ImplemertorContext alloc] init];
            implemertorContext.implemertor = obj;
            [implemertorContextArray addObject:implemertorContext];
            
            //  为什么关联个 ProtocolDispatcher 属性？
            // "自释放"，ProtocolDispatcher 并不是一个单例，而是一个局部变量，当implemertor释放时就会触发ProtocolDispatcher释放。
            // key 需要为随机，否则当有两个分发器时，key 会被覆盖，导致第一个分发器释放。所以 key = _cmd 是不行的。
            
            void *key = (__bridge void *)([NSString stringWithFormat:@"%p",self]);
            objc_setAssociatedObject(obj, key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
        
        self.implemertorArray = implemertorContextArray;
    }
    
    return self;
}


+ (id)dispatcherProtocol:(Protocol *)protocol
    withIndexImplemertor:(NSNumber *)indexImplemertor
          toImplemertors:(NSArray *)implemertors
{
    FSABTestProtocolDispatcher *abTestProtocolDispatcher = [[FSABTestProtocolDispatcher alloc] initWithProtocol:protocol withIndexImplemertor:indexImplemertor toImplemertors:implemertors];
    return abTestProtocolDispatcher;
}


- (void)dealloc
{
    NSLog(@"ProtocolDispatcher dealloc");
}

#pragma mark --  函数的调用做分发是设计的关键，系统提供有函数通过以下方法即可判断Selector是否属于某一Protocol
/**
 如何做到只对Protocol中Selector函数的调用做分发是设计的关键，系统提供有函数
 通过以下方法即可判断Selector是否属于某一Protocol
 */
struct objc_method_description MethodDescriptionForSELInProtocol(Protocol *protocol, SEL sel)
{
    struct objc_method_description description = protocol_getMethodDescription(protocol, sel, YES, YES);
    if (description.types)
    {
        return description;
    }
    description = protocol_getMethodDescription(protocol, sel, NO, YES);
    if (description.types)
    {
        return description;
    }
    return (struct objc_method_description){NULL, NULL};
}

BOOL ProtocolContainSel(Protocol *protocol, SEL sel)
{
    return MethodDescriptionForSELInProtocol(protocol, sel).types ? YES: NO;
}


#pragma mark --  未实现的Selector函数调用

/**
 NSObject对象主要通过以下函数响应未实现的Selector函数调用
 
 方案一：动态解析
 + (BOOL)resolveInstanceMethod:(SEL)sel
 + (BOOL)resolveClassMethod:(SEL)sel
 
 方案二：快速转发
 //返回实现了方法的消息转发对象
 - (id)forwardingTargetForSelector:(SEL)aSelector OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);
 
 方案三：慢速转发
 //函数签名
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
 //函数调用
 - (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE("");
 */

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    
    if (!ProtocolContainSel(self.prococol, aSelector))
    {//协议没有此方法
        return [super methodSignatureForSelector:aSelector];
    }
    
    struct objc_method_description methodDescription = MethodDescriptionForSELInProtocol(self.prococol, aSelector);
    return [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
}

#pragma mark -- 协议分发器Dispatcher可以在该函数中将Protocol中Selector的调用传递给实现者Implemertor，由实现者Implemertor实现具体的Selector函数即可

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = anInvocation.selector;
    if (!ProtocolContainSel(self.prococol, aSelector))
    {//协议没有此方法
        [super forwardInvocation:anInvocation];
        return ;
    }
    
    if (self.indexImplemertor)
    {
        
        
        for(NSInteger i=0; i < self.implemertorArray.count; i++)
        {
            ImplemertorContext *implemertorContext = [self.implemertorArray objectAtIndex:i];
            if (i == self.indexImplemertor.integerValue && [implemertorContext.implemertor respondsToSelector:aSelector]) {
                [anInvocation invokeWithTarget:implemertorContext.implemertor];
            }
        }
        
        
    }
    else
    {
        for(ImplemertorContext *implemertorContext in self.implemertorArray)
        {
            if ([implemertorContext.implemertor respondsToSelector:aSelector])
            {
                [anInvocation invokeWithTarget:implemertorContext.implemertor];
            }
        }
    }
}


//重写系统方法
- (BOOL)respondsToSelector:(SEL)aSelector
{
    //    NSLog(@"%@",NSStringFromSelector(aSelector));
    if (!ProtocolContainSel(self.prococol, aSelector))
    {
        return [super respondsToSelector:aSelector];
    }
    
    for (ImplemertorContext *implemertorContext in self.implemertorArray)
    {
        if ([implemertorContext.implemertor respondsToSelector:aSelector])
        {
            return YES;
        }
    }
    return NO;
}









@end
