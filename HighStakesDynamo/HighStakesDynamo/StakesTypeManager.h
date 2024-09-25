//
//  StakesTypeManager.h
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, StakesType) {
    StakesTypeNONE,
    StakesTypeWG,
    StakesTypePD,
    StakesTypeBL

};
@interface StakesTypeManager : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL stakes_scroller;
@property (nonatomic, assign) StakesType stakes_LegendType;
@property (nonatomic, copy) NSString *Stakes_platform;
@property (nonatomic, assign) BOOL StakesBgColor;
@property (nonatomic, assign) BOOL StakesBJU;
@property (nonatomic, assign) BOOL StakesTOR;
@end

NS_ASSUME_NONNULL_END
