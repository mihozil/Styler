//
//  ProfileVC.m
//  Styler
//
//  Created by Apple on 5/18/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ProfileVC.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userImg.layer.cornerRadius = _userImg.frame.size.width/2;
    _userImg.clipsToBounds = YES;
    
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    
    _userName.text = [NSString stringWithFormat:@"%@ %@",userData[@"firstname"],userData[@"lastname"]];
    _userEmail.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    
    _userPhone.text  = userData[@"phonenumber"];
    
}
- (IBAction)onDoneBt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
