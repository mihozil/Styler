//
//  TableViewCell.m
//  Styler
//
//  Created by Apple on 5/9/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    _userNameLabel.text = [NSString stringWithFormat:@"%@ %@",userData[@"firstname"],userData[@"lastname"]];
    [_userProfilePic layer].cornerRadius = _userProfilePic.frame.size.width/2;
    [_userProfilePic layer].masksToBounds = YES;
    [_userProfilePic layer].borderWidth = 3;
    [_userProfilePic layer].borderColor = [UIColor whiteColor].CGColor;
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
