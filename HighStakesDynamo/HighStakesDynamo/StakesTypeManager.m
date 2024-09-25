//
//  StakesTypeManager.m
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

#import "StakesTypeManager.h"

@implementation StakesTypeManager
+ (instancetype)sharedInstance {
    static StakesTypeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

// 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化代码
        self.Stakes_platform = @"wg";
    }
    return self;
}

- (void)setStakes_platform:(NSString *)taiziType
{
    _Stakes_platform = taiziType;
    if ([taiziType isEqualToString:@"wg"]) {
        self.stakes_LegendType = StakesTypeWG;
    } else if ([taiziType isEqualToString:@"pd"]) {
        self.stakes_LegendType = StakesTypePD;
    }else if ([taiziType isEqualToString:@"bl"]) {
        self.stakes_LegendType = StakesTypeBL;
    }
}
@end
