//
//  OnLoginFacebook.h
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OnLoginFacebook :UIViewController
@property (nonatomic, strong)UIViewController *viewController;
@property (nonatomic, strong) NSString *email;
-(void) onLoginwithEmail:(NSString*)email andJson:(NSDictionary*)json inViewController:(UIViewController*)viewController;

@end
