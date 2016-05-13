//
//  StylerVC.h
//  Styler
//
//  Created by Apple on 5/5/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface StylerVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *stylerImg;
@property (weak, nonatomic) IBOutlet UILabel *stylerName;
@property (weak, nonatomic) IBOutlet RateView *stylerRate;
@property (weak, nonatomic) IBOutlet UITextView *stylerDescription;

@end
