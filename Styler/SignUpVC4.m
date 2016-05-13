//
//  SignUpVC4.m
//  Styler
//
//  Created by Apple on 4/27/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC4.h"
#import "SWRevealViewController.h"
#import "PushView.h"

@implementation SignUpVC4{
    float keyboardHeight;
}

-(void)viewDidLoad{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardwasShown:) name:UIKeyboardDidShowNotification object:nil];
}
- (void) keyBoardwasShown:(NSNotification*)notification{
    CGSize keyboardSize = [[[notification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    keyboardHeight = MIN(keyboardSize.width, keyboardSize.height);
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.view.frame.origin.y==0)
    if (textField.frame.origin.y>self.view.frame.size.height-keyboardHeight){
        [PushView pushView:self.view distance:-keyboardHeight];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.view.frame.origin.y<0)
        if (textField.frame.origin.y>self.view.frame.size.height - keyboardHeight){
            [PushView pushView:self.view distance:keyboardHeight];
        }
}
- (IBAction)onNextButton:(id)sender {
    SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
    [self.navigationController pushViewController:swRevealVC animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_creditCardTF isFirstResponder]){
        [_creditCardTF resignFirstResponder];
    }
    if ([_expiredYearTF isFirstResponder]){
        [_expiredYearTF resignFirstResponder];
    }
    if ([_expiredMonthTF isFirstResponder]){
        [_expiredMonthTF resignFirstResponder];
    }
    if ([_cvvTF isFirstResponder]){
        [_cvvTF resignFirstResponder];
    }
    if ([_postalCodeTF isFirstResponder]){
        [_postalCodeTF resignFirstResponder];
    }
}
@end
