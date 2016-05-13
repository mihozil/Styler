//
//  SignUpVC2.m
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC2.h"
#import "ShowAlertView.h"
#import "SignUpVC3.h"

@interface SignUpVC2 ()

@end

@implementation SignUpVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    _passTF.secureTextEntry = YES;
    _passRepeatTF.secureTextEntry = YES;

}

- (IBAction)onNextBt:(id)sender {
    if ([self checkEmpty])
        if ([self checkPass]){
            [self updateUserData];
            SignUpVC3 *signUpVC3 = [self.storyboard instantiateViewControllerWithIdentifier:@"signupvc3"];
            [self.navigationController pushViewController:signUpVC3 animated:YES];
        }
}
- (BOOL) checkEmpty{
    if ([_firstnameTF.text isEqualToString:@""]) return NO;
    if ([_lastnameTF.text isEqualToString:@""]) return NO;
    if ([_passTF.text isEqualToString:@""]) return NO;
    if ([_passRepeatTF.text isEqualToString:@""]) return NO;
    return YES;
}
- (BOOL) checkPass{
    if (![_passRepeatTF.text isEqualToString:_passTF.text]){
        [ShowAlertView showAlertwithTitle:@"Password error" andMessenge:@"password not match" inViewController:self];
        return NO;
    }
    return YES;
}
- (void) updateUserData{
    NSDictionary *userData = @{@"firstname":_firstnameTF.text,@"lastname":_lastnameTF.text,@"password":_passTF.text};
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userData"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_firstnameTF isFirstResponder]) [_firstnameTF resignFirstResponder];
    if ([_lastnameTF isFirstResponder]) [_lastnameTF resignFirstResponder];
    if ([_passTF isFirstResponder]) [_passTF resignFirstResponder];
    if ([_passRepeatTF isFirstResponder]) [_passRepeatTF resignFirstResponder];
}


@end
