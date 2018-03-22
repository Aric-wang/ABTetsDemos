//
//  FSABTestExtModelParam.m
//  iOS-GMFinance-Fund
//
//  Created by wangyang on 2018/3/16.
//  Copyright © 2018年 胡林虎. All rights reserved.
//

#import "FSABTestFundModelParam.h"

@implementation FSABTestFundModelParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.twoABTest = @"BTwoABTest";
        self.fundDetailRnAbtest = [[FSBasicABTestModel alloc] init];
    }
    return self;
}

@end
