//
//  CreateLink.m
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "CreateLink.h"

@implementation CreateLink
+(NSString *)linkwithUrl:(NSString *)url andparas:(NSDictionary *)paras{
    NSString *link = [NSString stringWithString:url];
    NSArray*allKey = paras.allKeys;
    NSArray*allValue = paras.allValues;
    for (int i=0; i<paras.count; i++){
        NSString *addedString = [NSString stringWithFormat:@"%@=%@",allKey[i],allValue[i]];
        if (i<paras.count-1) {
            addedString = [addedString stringByAppendingString:@"&"];
            
        }
        link=[link stringByAppendingString:addedString];
    }
    
    return link;
};


@end
