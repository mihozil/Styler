//
//  ReceiptVC.h
//  Styler
//
//  Created by Apple on 5/7/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface ReceiptVC : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *stylerNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *servicesTextView;
@property (weak, nonatomic) IBOutlet RateView *rateView;

@end
