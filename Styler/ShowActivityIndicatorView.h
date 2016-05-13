//
//  ShowActivityIndicatorView.h
//  Styler
//
//  Created by Apple on 4/28/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowActivityIndicatorView : UIViewController
+(void) startActivityIndicatorView:(UIActivityIndicatorView*)activityIndicatorView inView:(UIView*)view;
+(void) stopActivityIndicatorView:(UIActivityIndicatorView*)activityIndicatorView;

@end
