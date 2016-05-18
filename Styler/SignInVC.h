//
//  SignInVC.h
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Google/SignIn.h>



@interface SignInVC : UIViewController<UITextFieldDelegate, GIDSignInDelegate,GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end
