//
//  PushView.m
//  Styler
//
//  Created by Apple on 5/9/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "PushView.h"

@implementation PushView

+(void)pushView:(UIView *)view distance:(float)distance{
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectOffset(view.frame, 0, distance);
    }];
}

@end
