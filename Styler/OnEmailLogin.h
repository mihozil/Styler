//
//  OnEmailLogin.h
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onCompletion)(NSError*error);


@interface OnEmailLogin : UIViewController

+ (void) loginWithEmail:(NSString*)email andJson:(NSDictionary*)json inViewController:(UIViewController*)viewController onCompletion:(onCompletion)complete;

@end
