//
//  LoginFacebook.h
//  Styler
//
//  Created by Apple on 4/27/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@interface LoginFacebook : UIViewController
@property (nonatomic, strong) UIViewController *viewController;

- (void) loginFacebookfromViewController:(UIViewController*)viewController;

@end
