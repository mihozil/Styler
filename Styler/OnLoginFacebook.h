//
//  OnLoginFacebook.h
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^onCompletion) (NSError*error);

@interface OnLoginFacebook :UIViewController
@property (nonatomic, strong)UIViewController *viewController;
@property (nonatomic, strong) NSString *email;
-(void) onLoginwithEmail:(NSString*)email andJson:(NSDictionary*)json inViewController:(UIViewController*)viewController onCompletion:(onCompletion)complete;

@end
