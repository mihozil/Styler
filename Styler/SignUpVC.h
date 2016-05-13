//
//  SignUpVC.h
//  Styler
//
//  Created by Apple on 4/25/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface SignUpVC : UIViewController<GIDSignInDelegate,GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTf;

@end
