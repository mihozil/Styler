//
//  UpdateUserData.h
//  Styler
//
//  Created by Apple on 4/26/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUserData : NSObject
+(void) updateDatawithID:(NSString*)idCustomer onCompletion:(void(^)(NSError*error))complete;


@end
