//
//  FSBasicABTestModel.h
//  iOS-GMFinance-Fund
//
//  Created by wangyang on 2018/3/16.
//  Copyright © 2018年 胡林虎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSBasicABTestModel : NSObject

@property (nonatomic, copy) NSString *testName;     //实验名称
@property (nonatomic, copy) NSString *testStrategy; //策略key，客户端根据策略key选择策略方案
@property (nonatomic, copy) NSString *testFlow;     // 流量组，用于上报。每个流量组只属于一个策略
@property (nonatomic, assign) BOOL testFinished;    //标识实验是否终止，如果已经终止，则不再上传数据，但是不影响规则

@end
