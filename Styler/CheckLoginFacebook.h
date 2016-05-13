//
//  CheckLoginFacebook.h
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^onCheckCompletion)(NSError*error, NSDictionary*json);
@interface CheckLoginFacebook : UIViewController


+(void) checkLoginwithEmail:(NSString*)email andType:(NSString*)type onCompletion:(onCheckCompletion)complete;


@end
