//
//  ShowActivityIndicatorView.m
//  Styler
//
//  Created by Apple on 4/28/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ShowActivityIndicatorView.h"

@implementation ShowActivityIndicatorView
+(void)startActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView inView:(UIView *)view{
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.frame =CGRectMake(0, 0, 80, 80);
    activityIndicatorView.center = view.center;
    [view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
}
+(void)stopActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView{
    dispatch_async(dispatch_get_main_queue(), ^{
       [activityIndicatorView stopAnimating];
    });
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
}

@end
