//
//  UpdateUserData.m
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "UpdateUserData.h"
#import "CreateLink.h"
#import "IOSRequest.h"
#import "EncodeString.h"

@implementation UpdateUserData
+(void)updateDatawithID:(NSString *)idCustomer onCompletion:(void (^)(NSError*error))complete{
    [[NSUserDefaults standardUserDefaults]setObject:idCustomer forKey:@"idcustomer"];
    
    NSString *url = @"http://styler.theammobile.com/GET_CUSTOMER_INFORMATION_BASIC.php?";
    NSDictionary *paras = @{@"idcustomer":idCustomer};
    NSString*urlString = [CreateLink linkwithUrl:url andparas:paras];
    
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"userData"];
        if (complete) complete(error);
        
    }];
    
}

@end
