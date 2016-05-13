//
//  StylerFindingVC.h
//  Styler
//
//  Created by Apple on 5/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StylerFindingVC : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *stylerImg;
@property (weak, nonatomic) IBOutlet UILabel *stylerInfo;
@property (weak, nonatomic) IBOutlet RateView *rateView;

@property (weak, nonatomic) IBOutlet UIButton *acceptBt;
@property (weak, nonatomic) IBOutlet UILabel *stylerFinding;

@end
