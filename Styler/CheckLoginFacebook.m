//
//  CheckLoginFacebook.m
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "CheckLoginFacebook.h"
#import "CreateLink.h"
#import "IOSRequest.h"

@implementation CheckLoginFacebook
+(void)checkLoginwithEmail:(NSString *)email andType:(NSString *)type onCompletion:(onCheckCompletion)complete{
    
    NSDictionary *paras=@{@"email":email,@"type":type};
    NSString *url = @"http://styler.theammobile.com/LOGIN_CUSTOMER_FACEBOOK.php?";
    NSString *urlString = [CreateLink linkwithUrl:url andparas:paras];
    
    
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (complete) complete(error, json);
    }];
    
}


@end
