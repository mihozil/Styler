//
//  IOSRequest.m
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "IOSRequest.h"
#import "ShowAlertView.h"

@implementation IOSRequest
+(void)requestPath:(NSString *)path onCompletion:(onCompletionHandle)complete{
    NSMutableURLRequest*request = [[NSMutableURLRequest alloc]init];
    request.URL = [NSURL URLWithString:path];
    request.HTTPMethod=@"Get";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        if (error){
            if (complete) complete(error, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
        
               [ShowAlertView showAlertwithTitle:@"Error" andMessenge:@"Error Requesting" inViewController:nil]; 
            });
            
        }else {
            NSError*error2;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
            if (complete) complete(error, json);
        }
                
    }]resume];
}


@end
