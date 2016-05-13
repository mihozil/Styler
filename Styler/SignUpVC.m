//
//  SignUpVC.m
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC.h"
#import "NSString+EmailValidation.h"
#import "SignUpVC2.h"
#import "LoginFacebook.h"
#import "CheckLoginFacebook.h"
#import "OnLoginFacebook.h"
#import "CreateLink.h"
#import "IOSRequest.h"
#import "ShowAlertView.h"
#import "ShowActivityIndicatorView.h"


@interface SignUpVC ()

@end

@implementation SignUpVC{
    UIActivityIndicatorView *activityIndicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    
}

- (IBAction)onNextBt:(id)sender {
    if ([_emailTf.text isValidEmail]){
        [ShowActivityIndicatorView startActivityIndicatorView:activityIndicatorView inView:self.view];
        [self checkUnusedEmail];
    }
}
- (void) checkUnusedEmail{
        NSString *url = @"http://styler.theammobile.com/CHECK_EMAIL_IS_ALREADY_USED.php?";
    NSDictionary *paras =@{@"email":_emailTf.text};
    NSString *urlString = [CreateLink linkwithUrl:url andparas:paras];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            int success = [json[@"success" ] intValue];
            if (success==0){
                [self gotoSignUpVC2];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ShowAlertView showAlertwithTitle:@"Email used" andMessenge:@"Please reenter your email adress" inViewController:self];
                });
            }
        }
        
        [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
    }];
}

- (void) gotoSignUpVC2{
    [[NSUserDefaults standardUserDefaults]setObject:_emailTf.text forKey:@"email"];
    dispatch_async(dispatch_get_main_queue(), ^{
        SignUpVC2 *signUpvc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"signupvc2"];
        [self.navigationController pushViewController:signUpvc2 animated:YES];
    });
}

- (IBAction)onFacebookSignUp:(id)sender {
    LoginFacebook *loginFacebook = [LoginFacebook new];
    [loginFacebook loginFacebookfromViewController:self];
    [[NSUserDefaults standardUserDefaults]setObject:@"Facebook" forKey:@"loginType"];
}
- (IBAction)onGoogleSignUp:(id)sender {
    [[GIDSignIn sharedInstance]signOut];
    [[GIDSignIn sharedInstance]signIn];
    [[NSUserDefaults standardUserDefaults]setObject:@"Google" forKey:@"loginType"];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    NSString*email = user.profile.email;
    [ShowActivityIndicatorView startActivityIndicatorView:activityIndicatorView inView:self.view];
    
    [CheckLoginFacebook checkLoginwithEmail:email andType:@"Google" onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            OnLoginFacebook *onLogin = [OnLoginFacebook new];
            [onLogin onLoginwithEmail:email andJson:json inViewController:self];
        }
        
        [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_emailTf isFirstResponder]){
        [_emailTf resignFirstResponder];
    }
}



@end
