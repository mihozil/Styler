//
//  GetIdProduct.m
//  Styler
//
//  Created by Apple on 5/12/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "GetIdProduct.h"

@implementation GetIdProduct
+(NSString *)getIdProductfromId:(NSString *)originId{
    int idIndex = [originId intValue];
    idIndex = (idIndex-1)*3;
    NSString *priceName = [[NSUserDefaults standardUserDefaults]objectForKey:@"serviceType"];
    if ([priceName isEqualToString:@"senior"]) idIndex+=1;
    else if ([priceName isEqualToString:@"superstar"]) idIndex+=2;
    
    return [NSString stringWithFormat:@"%d",idIndex];
}


@end
