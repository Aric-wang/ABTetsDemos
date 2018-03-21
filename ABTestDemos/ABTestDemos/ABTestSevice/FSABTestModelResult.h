//
//  FSABTestModel.h
//  ABTestDemo
//
//  Created by wangyang on 2018/3/14.
//  Copyright © 2018年 com.gmfund.app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSABTestFundModelParam.h"

@interface FSABTestModelResult : NSObject

@property (nonatomic, strong)   NSString *oneABTest;
@property (nonatomic, strong)   FSABTestFundModelParam *abtestExtparams;

@end
