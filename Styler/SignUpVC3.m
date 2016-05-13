//
//  SignUpVC3.m
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC3.h"
#import "ShowAlertView.h"
#import "UpdateUserData.h"
#import "IOSRequest.h"
#import "CreateLink.h"
#import "SignUpVC4.h"
#import "SetViewMoveUp.h"
#import "ShowActivityIndicatorView.h"
#import "PushView.h"
#import "EncodeString.h"
#define kOFFSET_FOR_KEYBOARD 80.0


@interface SignUpVC3 ()

@end

@implementation SignUpVC3{
    NSMutableDictionary *userData;
    UIActivityIndicatorView*activityIndicatorView;
    float keyboardHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    
}

- (IBAction)onConfirmBt:(id)sender {
    if ([_phoneTF.text isEqualToString:@""]){
        [ShowAlertView showAlertwithTitle:@"Please enter your phone number" andMessenge:nil inViewController:self];
    }else {
        [self updateUserData];
        [self postUserData];
        
    }
}
- (void) updateUserData{
    NSDictionary *saveduserData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    userData = [NSMutableDictionary dictionaryWithDictionary:saveduserData];
    [userData setObject:_phoneTF.text forKey:@"phonenumber"];
    
}

- (void) postUserData{
    [ShowActivityIndicatorView startActivityIndicatorView:activityIndicatorView inView:self.view];
    NSString*email = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    NSString *loginType = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginType"];
    
    NSMutableDictionary *paras =[NSMutableDictionary dictionaryWithDictionary: @{@"email":email,@"firstname":userData[@"firstname"],@"lastname":userData[@"lastname"],@"phonenumber":_phoneTF.text}];
    
    NSString *url;
    if (userData[@"password"]!=nil) {
     [paras setObject:userData[@"password"] forKey:@"pass"];
        url =@"http://styler.theammobile.com/CREATE_NEW_ACCOUNT_CUSTOMER.php?";
    }else {
        [paras setObject:loginType forKey:@"type"];
        url = @"http://styler.theammobile.com/CREATE_NEW_ACCOUNT_CUSTOMER_FACEBOOK.php?";
    }
    
    NSString *UrlString = [CreateLink linkwithUrl:url andparas:paras];
    NSLog(@"urlString: %@",UrlString);
    
    [IOSRequest requestPath:UrlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            [[NSUserDefaults standardUserDefaults]setObject:json[@"id"] forKey:@"idcustomer"];
            [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userData"];
            [self gotoSignUp4];
        }
        NSLog(@"error: %@",error.localizedDescription);
        
        [ShowActivityIndicatorView stopActivityIndicatorView:activityIndicatorView];
        
    }];
}

- (void) gotoSignUp4{
    dispatch_async(dispatch_get_main_queue(), ^{
        SignUpVC4 *signUp4 = [self.storyboard instantiateViewControllerWithIdentifier:@"signupvc4"];
        [self.navigationController pushViewController:signUp4 animated:YES];
    });
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_codeTF]){
        [SetViewMoveUp setViewMoveUp:YES inView:self.view];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_codeTF]){
        [SetViewMoveUp setViewMoveUp:NO inView:self.view];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_phoneTF isFirstResponder]) [_phoneTF resignFirstResponder];
    if ([_codeTF isFirstResponder]) [_codeTF resignFirstResponder];
}

@end
