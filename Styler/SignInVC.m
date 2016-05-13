//
//  SignInVC.m
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignInVC.h"
#import "CreateLink.h"
#import "IOSRequest.h"
#import "OnEmailLogin.h"
#import "SignUpVC.h"
#import "LoginFacebook.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CheckLoginFacebook.h"
#import "OnLoginFacebook.h"
#import "ShowActivityIndicatorView.h"



@interface SignInVC ()

@end

@implementation SignInVC{
    UIActivityIndicatorView *activityIndicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordTF.secureTextEntry = YES;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    
}

- (IBAction)onGoogleLogin:(id)sender {
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

- (IBAction)onFacebookLogin:(id)sender {
    LoginFacebook *loginFacebook = [LoginFacebook new];
    [loginFacebook loginFacebookfromViewController:self];
    [[NSUserDefaults standardUserDefaults]setObject:@"Facebook" forKey:@"loginType"];
}

- (IBAction)onSignInBt:(id)sender {
    [ShowActivityIndicatorView startActivityIndicatorView:activityIndicatorView inView:self.view];
    if ([_emailTF.text isEqualToString:@""]||[_passwordTF.text isEqualToString:@""]) return;
    if (![self checkValidPassWord]) return;
    NSString *url = @"http://styler.theammobile.com/LOGIN_CUSTOMER.php?";
    NSDictionary *paras =@{@"email":_emailTF.text,@"pass":_passwordTF.text};
    NSString *urlString = [CreateLink linkwithUrl:url andparas:paras];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
          [OnEmailLogin loginWithEmail:_emailTF.text andJson:json inViewController:self];  
        }
        
        [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
        
    }];
}
- (BOOL) checkValidPassWord{
    return YES;
}

- (IBAction)createNewAccountBt:(id)sender {
    SignUpVC *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signupvc"];
    [self.navigationController pushViewController:signupVC animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_emailTF isFirstResponder]) {
        [_emailTF resignFirstResponder];
    }
    if ([_passwordTF isFirstResponder]){
        [_passwordTF resignFirstResponder];
    }
}

@end
