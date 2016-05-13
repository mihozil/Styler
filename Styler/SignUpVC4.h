//
//  SignUpVC4.h
//  Styler
//
//  Created by Apple on 4/27/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC4 : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *creditCardTF;
@property (weak, nonatomic) IBOutlet UITextField *cvvTF;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *expiredMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *expiredYearTF;

@end
