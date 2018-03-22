//
//  FSABTestModel.m
//  ABTestDemo
//
//  Created by wangyang on 2018/3/14.
//  Copyright © 2018年 com.gmfund.app. All rights reserved.
//

#import "FSABTestModelResult.h"

@implementation FSABTestModelResult

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.oneABTest = @"BoneABTest";
        self.abtestExtparams = [[FSABTestFundModelParam alloc] init];
    }
    return self;
}


@end
