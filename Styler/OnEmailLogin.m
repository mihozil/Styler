//
//  OnEmailLogin.m
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "OnEmailLogin.h"
#import "ShowAlertView.h"
#import "SWRevealViewController.h"
#import "UpdateUserData.h"

@interface OnEmailLogin ()

@end

@implementation OnEmailLogin

- (void)viewDidLoad {
    [super viewDidLoad];

}
+ (void)loginWithEmail:(NSString *)email andJson:(NSDictionary *)json inViewController:(UIViewController *)viewController{
    
    int success = [json[@"success"] intValue];
    if (success == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShowAlertView showAlertwithTitle:@"Error Email or Password" andMessenge:@"Please reenter your account" inViewController:viewController];
 
        });
            } else {
        [[NSUserDefaults standardUserDefaults]setObject:@"email" forKey:email];
        [UpdateUserData updateDatawithID:json[@"id"] onCompletion:^(NSError*error){
            SWRevealViewController *swRevealVC = [viewController.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
            dispatch_async(dispatch_get_main_queue(), ^{
                  [viewController.navigationController pushViewController:swRevealVC animated:YES];
            });
          
        }];
    }
}


@end
