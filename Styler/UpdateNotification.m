//
//  UpdateNotification.m
//  Styler
//
//  Created by Apple on 5/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "UpdateNotification.h"


@implementation UpdateNotification{
    NSTimer *timer;
    NSMutableDictionary *customerNoti;
}
- (void)updateNoti{
    [self onTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}
- (void) onTimer{
//    NSLog(@"onTimer");
    NSString *idCustomer = [[NSUserDefaults standardUserDefaults]objectForKey:@"idcustomer"];
    if (!idCustomer){
        [timer invalidate];
        return;
    }
    Firebase *notiRef = [[Firebase alloc]initWithUrl:@"https://stylerapplication.firebaseio.com/noti"];
    Firebase *customeRef = [notiRef childByAppendingPath:idCustomer];
    
    [customeRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        if (snapShot.value!=[NSNull null]){
            customerNoti = [NSMutableDictionary dictionaryWithDictionary:snapShot.value];
            [self getNewNoti];
            
            // update noti from show to off
            [customeRef setValue:customerNoti];
            [[NSUserDefaults standardUserDefaults]setObject:customerNoti forKey:@"customerNoti"];
        }else {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"customerNoti"];
        }
        
        
        
    }];
    
}
- (void) getNewNoti{
    NSArray *allKeys = customerNoti.allKeys;
    int badgeNumber = 0; 
    for (int i=0; i<allKeys.count; i++){
        
        NSMutableDictionary *notiRoom = customerNoti[allKeys[i]];
        if ([notiRoom[@"status"] isEqualToString:@"show"]){
            [self notiReceived:notiRoom[@"content"]];
            [UIApplication sharedApplication].applicationIconBadgeNumber+=1;
            // update to off
            if ([[UIApplication sharedApplication]applicationState] == UIApplicationStateActive){
                notiRoom[@"status"] = @"opened";
            }else {
                notiRoom[@"status"] = @"off";
            }
            
            
        }
        if ([notiRoom[@"status"] isEqualToString:@"off"]) badgeNumber+=1;
        customerNoti[allKeys[i]] = notiRoom;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber =badgeNumber;
}
- (void) notiReceived:(NSString*)notiBody{
//    NSLog(@"noti Received");
    
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.alertBody = notiBody;
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
}


@end
