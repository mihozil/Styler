//
//  EncodeString.m
//  Styler
//
//  Created by Apple on 5/12/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "EncodeString.h"

@implementation EncodeString
+(NSString *)encodeString:(NSString *)string{
    NSData *nsdata = [string
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    return base64Encoded;
}
+(NSString *)decodeString:(NSString *)string{
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:string options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    
    return base64Decoded;
    
}


@end
