//
//  OnLoginFacebook.m
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "OnLoginFacebook.h"
#import "SignUpVC3.h"
#import "SWRevealViewController.h"
#import "UpdateUserData.h"
#import "ShowAlertView.h"

@implementation OnLoginFacebook
- (void)onLoginwithEmail:(NSString *)email andJson:(NSDictionary *)json inViewController:(UIViewController*)viewController onCompletion:(onCompletion)complete{
    
    _viewController = viewController;
    _email = email;
    int success = [json[@"success"] intValue];
    if (success == 0) {
     [self signUpVC3:json[@"id"]];
        if (complete) complete(nil);
    }
    
    if (success == 1) {
        // login success
        [UpdateUserData updateDatawithID:json[@"id"] onCompletion:^void(NSError*error){
            
            [[NSUserDefaults standardUserDefaults]setObject:_email forKey:@"email"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                SWRevealViewController *revealVC = [_viewController.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
                [_viewController.navigationController pushViewController:revealVC animated:YES];
                
                if (complete) complete(error);
            });
            
        }];

    }
    
    if (success == 2 ){
     [self duplicateEmail];
        if (complete) complete(nil);
    }
}

- (void) signUpVC3:(NSString*)idcustomer{
    [[NSUserDefaults standardUserDefaults]setObject:_email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults]setObject:idcustomer forKey:@"idcustomer"];
    // save user data
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SignUpVC3 *signUpVC3 = [_viewController.storyboard instantiateViewControllerWithIdentifier:@"signupvc3"];
        [_viewController.navigationController pushViewController:signUpVC3 animated:YES];
    });
    
    
}

- (void) duplicateEmail{
    dispatch_async(dispatch_get_main_queue(), ^{
            [ShowAlertView showAlertwithTitle:@"Account invalid" andMessenge:@"Please try to use another account" inViewController:_viewController];
    });
}

@end
