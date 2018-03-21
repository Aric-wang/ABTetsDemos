//
//  FSABTestExtModelParam.h
//  iOS-GMFinance-Fund
//
//  Created by wangyang on 2018/3/16.
//  Copyright © 2018年 胡林虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSBasicABTestModel.h"

@interface FSABTestFundModelParam : NSObject

@property (nonatomic, strong) NSString *twoABTest; //基金详情AB策略：a,native页面,b：RN页面
@property (nonatomic, strong) FSBasicABTestModel *fundDetailRnAbtest; //基金详情AB策略：a,native页面,b：RN页面

@end
