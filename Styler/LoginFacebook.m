//
//  LoginFacebook.m
//  Styler
//
//  Created by Apple on 4/27/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "LoginFacebook.h"
#import "CheckLoginFacebook.h"
#import "OnLoginFacebook.h"

#import "SWRevealViewController.h"
#import "ShowActivityIndicatorView.h"

@implementation LoginFacebook{
    UIActivityIndicatorView *activityIndicatorView;
}
- (void)loginFacebookfromViewController:(UIViewController *)viewController{
    _viewController = viewController;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    [login logOut];
    [login logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:_viewController handler:^(FBSDKLoginManagerLoginResult*result, NSError*error){
        if (error){
            NSLog(@"process Error: %@",error.localizedDescription);
        }else if (result.isCancelled){
            NSLog(@"is cancelled");
        }else {
            [self loginFacebook];

        }
    }];

}
-(void) loginFacebook{
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [ShowActivityIndicatorView startActivityIndicatorView:activityIndicatorView inView:_viewController.view];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id,name,email,first_name,last_name,picture"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection*connection, id result, NSError*error){
        NSLog(@"result: %@",result);
        if (!error){
            [self saveUserData:result];
            
            NSString*email = result[@"email"];
            [CheckLoginFacebook checkLoginwithEmail:email andType:@"Facebook" onCompletion:^(NSError*error, NSDictionary*json){
                if (!error){
                    OnLoginFacebook *onLogin = [OnLoginFacebook new];
                    [onLogin onLoginwithEmail:email andJson:json inViewController:_viewController];
                }
                
                [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
                            }];
            
        }else {
            NSLog(@"error Login Facebook");
            [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
        }
    }];
    
}
- (void) saveUserData:(NSDictionary*)result{
    NSDictionary *userData = @{@"firstname":result[@"first_name" ] ,@"lastname":result[@"last_name"]};
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userData"];
    
}


@end
