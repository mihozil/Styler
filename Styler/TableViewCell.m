//
//  TableViewCell.m
//  Styler
//
//  Created by Apple on 5/9/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "TableViewCell.h"
#import "MKNumberBadgeView.h"
#import <QuartzCore/QuartzCore.h>


@implementation TableViewCell
@synthesize imageView,imgLayerView;


- (void)awakeFromNib {
    [super awakeFromNib];
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    _userNameLabel.text = [NSString stringWithFormat:@"%@ %@",userData[@"firstname"],userData[@"lastname"]];
    [_userProfilePic layer].cornerRadius = _userProfilePic.frame.size.width/2;
    _userProfilePic.clipsToBounds = YES;
    [_userProfilePic layer].borderWidth = 3;
    [_userProfilePic layer].borderColor = [UIColor whiteColor].CGColor;
    
//    MKNumberBadgeView *badgeView = [[MKNumberBadgeView alloc]initWithFrame:CGRectMake(imgLayerView.frame.size.width-40,0, 40, 40)];
//    badgeView.value = [[UIApplication sharedApplication]applicationIconBadgeNumber];
//    NSLog(@"application icon badge number: %2.2d",badgeView.value);
//    
//    for (UIView *view in imgLayerView.subviews){
//        [view removeFromSuperview];
//    };
//    
//    if (badgeView.value>0) [imgLayerView addSubview:badgeView];
    
}


@end
