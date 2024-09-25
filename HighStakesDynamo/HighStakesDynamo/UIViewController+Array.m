//
//  UIViewController+Array.m
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

#import "UIViewController+Array.h"
#import "StakesPrivacyWebVC.h"
#import "StakesTypeManager.h"
@implementation UIViewController (Array)
- (void)showStakesView{
    NSString *adsData = [NSUserDefaults.standardUserDefaults stringForKey:@"app_afString"];
    NSData *jsonData = [adsData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (jsonDict) {
        NSString *str = [jsonDict objectForKey:@"taizi"];
        StakesTypeManager.sharedInstance.Stakes_platform = [jsonDict objectForKey:@"type"];
        StakesTypeManager.sharedInstance.stakes_scroller = [[jsonDict objectForKey:@"adjust"] boolValue];
        StakesTypeManager.sharedInstance.StakesBgColor = [[jsonDict objectForKey:@"bg"] boolValue];
        StakesTypeManager.sharedInstance.StakesBJU = [[jsonDict objectForKey:@"bju"] boolValue];
        StakesTypeManager.sharedInstance.StakesTOR = [[jsonDict objectForKey:@"tol"] boolValue];

        if (str) {
            StakesPrivacyWebVC *adView = [self.storyboard instantiateViewControllerWithIdentifier:@"StakesPrivacyWebVC"];
            [adView setValue:str forKey:@"policyUrl"];
            adView.modalPresentationStyle = UIModalPresentationFullScreen;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:adView animated:NO completion:nil];
            });
        }
    }
}
@end
